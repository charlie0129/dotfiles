"""CLI regression tests: python3 -m unittest discover -s bin/common/tests."""

from concurrent.futures import ThreadPoolExecutor
import errno
import ipaddress
import json
import os
from pathlib import Path
import pty
import random
import runpy
import subprocess
import sys
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "cidr"


class CidrTests(unittest.TestCase):
    def cli(self, *args, input="", status=0):
        result = subprocess.run(
            [sys.executable, str(SCRIPT), *args], input=input,
            capture_output=True, text=True, timeout=5,
        )
        self.assertEqual(result.returncode, status, result.stderr)
        self.assertNotIn("Traceback", result.stderr)
        self.assertNotIn("\033[", result.stdout)
        return result

    def data(self, *args, **kwargs):
        return json.loads(self.cli("--json", *args, **kwargs).stdout)

    def terminal_output(self, *args, status=0):
        env = dict(os.environ, TERM="xterm-256color", COLUMNS="80")
        env.pop("NO_COLOR", None)
        master, slave = pty.openpty()

        def read_output():
            chunks = []
            while True:
                try:
                    chunk = os.read(master, 8192)
                except OSError as error:
                    if error.errno == errno.EIO:
                        break  # Linux reports EIO when the slave closes.
                    raise
                if not chunk:
                    break
                chunks.append(chunk)
            return b"".join(chunks).decode().replace("\r\n", "\n")

        try:
            # Drain output while the child runs, including help longer than the
            # terminal buffer. Waiting for the child first can deadlock.
            with ThreadPoolExecutor(max_workers=1) as reader:
                output = reader.submit(read_output)
                try:
                    result = subprocess.run(
                        [sys.executable, str(SCRIPT), *args], stdin=subprocess.DEVNULL,
                        stdout=slave, stderr=slave, env=env, timeout=5,
                    )
                finally:
                    os.close(slave)
                text = output.result(timeout=5)
            self.assertEqual(result.returncode, status, text)
            return text
        finally:
            os.close(master)

    def test_inspect_normalizes_and_preserves_input(self):
        info = self.data("192.168.2.42/255.255.255.0")
        self.assertEqual(info["ip"], "192.168.2.42")
        self.assertEqual(info["network"], "192.168.2.0/24")
        self.assertEqual(info["wildcard_mask"], "0.0.0.255")
        self.assertEqual(info["broadcast"], "192.168.2.255")
        self.assertEqual(info["address_count"], 256)
        self.assertEqual(info["host_count"], 254)
        self.assertEqual(info["first_host"], "192.168.2.1")
        self.assertEqual(info["last_host"], "192.168.2.254")
        self.assertEqual(info["previous_network"], "192.168.1.0/24")
        self.assertEqual(info["next_network"], "192.168.3.0/24")

    def test_bare_ips(self):
        for value, prefix in (("192.0.2.1", 32), ("::1", 128)):
            with self.subTest(value=value):
                info = self.data(value)
                self.assertEqual(info["network"], "{}/{}".format(value, prefix))
                self.assertEqual(info["host_count"], 1)

    def test_host_edge_cases(self):
        cases = {
            "192.0.2.0/30": ["192.0.2.1", "192.0.2.2"],
            "192.0.2.0/31": ["192.0.2.0", "192.0.2.1"],
            "192.0.2.1/32": ["192.0.2.1"],
            "::/126": ["::1", "::2", "::3"],
            "::/127": ["::", "::1"],
            "::/128": ["::"],
        }
        for cidr, expected in cases.items():
            with self.subTest(cidr=cidr):
                info = self.data(cidr)
                hosts = self.data("hosts", cidr)
                self.assertEqual(hosts["addresses"], expected)
                self.assertEqual(hosts["total"], len(expected))
                self.assertEqual(info["host_count"], len(expected))
                self.assertEqual(info["first_host"], expected[0])
                self.assertEqual(info["last_host"], expected[-1])
                if ":" in cidr:
                    self.assertIsNone(info["broadcast"])
                    self.assertIsNone(info["wildcard_mask"])

    def test_nearby_prefix_increments_and_normalization(self):
        rows = self.data("nearby", "192.168.35.42/20", "--count", "2")["networks"]
        self.assertEqual([row["network"] for row in rows], [
            "192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20",
            "192.168.48.0/20", "192.168.64.0/20",
        ])
        self.assertEqual([row["offset"] for row in rows], [-2, -1, 0, 1, 2])
        self.assertEqual([row["current"] for row in rows], [False, False, True, False, False])
        rows = self.data("nearby", "::100/120", "--count", "1")["networks"]
        self.assertEqual([row["network"] for row in rows], ["::/120", "::100/120", "::200/120"])

    def test_address_space_boundaries(self):
        for cidr in ("0.0.0.0/0", "::/0"):
            with self.subTest(cidr=cidr):
                info = self.data(cidr)
                self.assertIsNone(info["previous_network"])
                self.assertIsNone(info["next_network"])
                rows = self.data("nearby", cidr, "--count", "1000000")["networks"]
                self.assertEqual(len(rows), 1)
                self.assertTrue(rows[0]["current"])
        for cidr, missing in (
            ("0.0.0.0/32", "previous_network"),
            ("255.255.255.255/32", "next_network"),
            ("::/128", "previous_network"),
            ("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff/128", "next_network"),
        ):
            with self.subTest(cidr=cidr):
                self.assertIsNone(self.data(cidr)[missing])
                self.assertEqual(len(self.data("nearby", cidr, "--count", "1")["networks"]), 2)

    def test_contains_and_overlap_exit_codes(self):
        self.assertTrue(self.data("contains", "10.0.0.0/8", "10.2.3.4")["result"])
        self.assertTrue(self.data("contains", "10.0.0.0/8", "10.0.0.0/16")["result"])
        self.assertFalse(self.data("contains", "10.0.0.0/16", "10.0.0.0/8", status=1)["result"])
        self.assertEqual(self.data("overlaps", "10.0.1.0/24", "10.0.0.0/16")["relationship"], "contained by")
        self.assertEqual(self.data("overlaps", "10.0.0.0/16", "10.0.1.0/24")["relationship"], "contains")
        self.assertEqual(self.data("overlaps", "::/0", "::/0")["relationship"], "equal")
        self.assertFalse(self.data("overlaps", "10.0.0.0/24", "10.0.1.0/24", status=1)["result"])
        self.assertFalse(self.data("contains", "::/0", "0.0.0.0", status=1)["result"])
        results = self.data("contains", "10.0.0.0/8", "10.0.0.1", "11.0.0.1", status=1)
        self.assertEqual([row["result"] for row in results], [True, False])

    def test_split(self):
        result = self.data("split", "10.0.0.0/24", "--prefix", "26")
        self.assertEqual(result["networks"], [
            "10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26",
        ])
        self.assertFalse(result["truncated"])
        self.assertEqual(self.data("split", "::/128", "--prefix", "128")["networks"], ["::/128"])

    def test_large_outputs_are_bounded(self):
        hosts = self.data("hosts", "::/0", "--limit", "3")
        self.assertEqual(hosts["addresses"], ["::1", "::2", "::3"])
        self.assertEqual(hosts["total"], 2 ** 128 - 1)
        self.assertTrue(hosts["truncated"])
        split = self.data("split", "::/0", "--prefix", "128", "--limit", "2")
        self.assertEqual(split["networks"], ["::/128", "::1/128"])
        self.assertEqual(split["total"], 2 ** 128)
        self.assertTrue(split["truncated"])
        result = self.cli("hosts", "10.0.0.0/8")
        self.assertEqual(len(result.stdout.splitlines()), 256)
        self.assertIn("showing 256 of 16777214", result.stderr)
        self.cli("nearby", "10.0.0.0/24", "--count", "1000000000", status=2)

    def test_hosts_all(self):
        result = self.data("hosts", "192.0.2.0/30", "--all")
        self.assertEqual(result["addresses"], ["192.0.2.0", "192.0.2.1", "192.0.2.2", "192.0.2.3"])
        self.assertEqual(self.data("hosts", "::/126", "--all")["total"], 4)

    def test_collapse_preserves_gaps_and_families(self):
        result = self.data("collapse", "10.0.0.0/25", "::/128", "10.0.0.128/25", "::1/128", "10.0.2.0/24", "10.0.0.1")
        self.assertEqual(result["networks"], ["10.0.0.0/24", "10.0.2.0/24", "::/127"])

    def test_range_exact_coverage(self):
        for start, end in (("192.168.1.10", "192.168.1.100"), ("::a", "::64")):
            with self.subTest(start=start):
                networks = [ipaddress.ip_network(value) for value in self.data("range", start, end)["networks"]]
                actual = [int(ip) for net in networks for ip in net]
                self.assertEqual(actual, list(range(int(ipaddress.ip_address(start)), int(ipaddress.ip_address(end)) + 1)))
                self.assertEqual(len(networks), 7)

    def test_exclude(self):
        self.assertEqual(self.data("exclude", "10.0.0.0/24", "10.0.0.64/26")["networks"], ["10.0.0.0/26", "10.0.0.128/25"])
        self.assertEqual(self.data("exclude", "::/120", "::/0")["networks"], [])
        self.assertEqual(self.data("exclude", "::/120", "::100/120")["networks"], ["::/120"])
        self.cli("exclude", "::/0", "0.0.0.0/0", status=2)

    def test_exclude_against_address_set_oracle(self):
        exclude = runpy.run_path(str(SCRIPT))["exclude_networks"]
        rng = random.Random(42)
        for base in (ipaddress.ip_network("192.0.2.0/28"), ipaddress.ip_network("::/124")):
            candidates = [base.supernet()] + [
                type(base)((int(base.network_address) + offset, base.max_prefixlen - 2))
                for offset in range(0, 24, 4)
            ] + list(base.subnets(prefixlen_diff=4))
            for _ in range(50):
                exclusions = rng.choices(candidates, k=5)
                expected = set(base).difference(*(set(net) for net in exclusions))
                actual = [ip for net in exclude(base, exclusions) for ip in net]
                self.assertEqual(set(actual), expected)
                self.assertEqual(len(actual), len(expected))

    def test_stdin_and_json_positions(self):
        self.assertEqual(self.data("collapse", input="10.0.0.0/25\n10.0.0.128/25\n")["networks"], ["10.0.0.0/24"])
        self.assertEqual(self.data("collapse", "10.0.0.0/25", "-", input="10.0.0.128/25")["networks"], ["10.0.0.0/24"])
        self.assertTrue(self.data("contains", "10.0.0.0/8", input="10.2.3.4")["result"])
        self.assertEqual(len(self.data("inspect", input="192.0.2.1\n::1\n")), 2)
        self.assertEqual(self.data(input="::1")["network"], "::1/128")
        for args in (("::1", "--json"), ("inspect", "--json", "::1"), ("inspect", "::1", "--json")):
            self.assertEqual(json.loads(self.cli(*args).stdout)["network"], "::1/128")

    def test_invalid_inputs(self):
        for args in (
            ("192.0.2.256",), ("10.0.0.1/33",), ("::1/129",), ("fe80::1%en0",),
            ("collapse",), ("collapse", "-", "-"), ("split", "10.0.0.0/24", "--prefix", "23"),
            ("split", "::/64", "--prefix", "129"), ("hosts", "::/0", "--limit", "0"),
            ("nearby", "::/0", "--count", "-1"), ("range", "::2", "::1"),
            ("range", "0.0.0.0", "::1"), ("range", "::1/128", "::2"),
        ):
            with self.subTest(args=args):
                self.assertEqual(self.cli(*args, status=2).stdout, "")

    def test_calculator_terminal_output_is_plain(self):
        cases = (
            (("192.0.2.42/24",), 0),
            (("192.0.2.42/255.255.255.0",), 0),
            (("nearby", "192.0.2.0/24"), 0),
            (("nearby", "::100/120"), 0),
            (("contains", "192.0.2.0/24", "192.0.2.42"), 0),
            (("contains", "192.0.2.0/24", "192.0.3.42"), 1),
            (("overlaps", "::/120", "::/124"), 0),
            (("split", "192.0.2.0/24", "--prefix", "25"), 0),
            (("collapse", "::/128", "::1/128"), 0),
            (("range", "192.0.2.0", "192.0.2.255"), 0),
            (("exclude", "192.0.2.0/24", "192.0.2.0/25"), 0),
            (("hosts", "192.0.2.0/30"), 0),
            (("hosts", "::/64", "--limit", "2"), 0),
            (("--json", "192.0.2.1"), 0),
        )
        for args, status in cases:
            with self.subTest(args=args):
                output = self.terminal_output(*args, status=status)
                self.assertNotIn("\033[", output)
                piped = self.cli(*args, status=status)
                self.assertEqual(output, piped.stdout + piped.stderr)


if __name__ == "__main__":
    unittest.main()
