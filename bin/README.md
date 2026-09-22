# Command-line tools

## CIDR calculator

`common/cidr` is an executable Python 3 script with no third-party dependencies.
Use `cidr` when `bin/common` is on your PATH, or run `bin/common/cidr` from the
repository root.

```sh
cidr 192.168.2.42/24                        # inspect, including previous/next networks
cidr 192.168.2.42/255.255.255.0             # dotted IPv4 masks also work
cidr 2001:db8::1234/64                     # IPv6
cidr nearby 192.168.2.0/24 --count 2        # two same-size networks on each side
cidr contains 10.0.0.0/8 10.2.3.4 10.1.0.0/16
cidr overlaps 10.0.0.0/16 10.0.1.0/24
cidr split 10.0.0.0/24 --prefix 26
cidr collapse 10.0.0.0/25 10.0.0.128/25
cidr range 192.168.1.10 192.168.1.100       # inclusive range, exact CIDR cover
cidr exclude 10.0.0.0/24 10.0.0.64/26
cidr hosts 192.168.1.0/29
cidr hosts 2001:db8::/64 --limit 5 --json
printf '%s\n' 10.0.0.0/25 10.0.0.128/25 | cidr collapse
```

Run `cidr --help` or `cidr COMMAND --help` for options. Calculator output is plain
text, including in terminals. Nearby views mark the current network with `->`.
Help and argument errors use Python's default argparse formatting.

Bare IPs become `/32` or `/128`. Host bits in a CIDR are normalized to its network;
inspection also preserves the input IP. Nearby networks keep the same prefix and
stop at address-space boundaries without wrapping. `--count` defaults to three
networks on each side; zero shows only the current network.

`hosts` and `split` emit at most 256 entries by default. Set `--limit N` to change
the cap. Truncated text output includes a notice on stderr; JSON includes `total`,
`returned`, and `truncated`. These commands calculate counts without enumerating
the entire network. `nearby` also defaults to a 256-entry cap, but rejects an
oversized view so it never hides the current network.

IPv4 host ranges exclude network and broadcast addresses except for `/31` and
`/32`. IPv6 host ranges follow Python's `ipaddress.hosts()`: they exclude the
subnet-router anycast address except for `/127` and `/128`. These are address
counting conventions, not a guarantee of routability. `hosts --all` includes every
address. IPv6 has no broadcast address; its inspection JSON uses `null` for
`broadcast` and `wildcard_mask`.

`inspect`, `collapse`, `contains`, `overlaps`, and `exclude` accept bulk inputs from
stdin when their variadic arguments are omitted, or at a single explicit `-`.
Supply the base network as an argument for `contains`, `overlaps`, and `exclude`.
Input is separated by whitespace. `collapse` handles mixed IPv4/IPv6 inputs by
merging each family separately. Cross-family membership/overlap checks are false;
range conversion and exclusion require matching families. Exclusion subtracts the
union of all exclusions: disjoint networks have no effect and a containing network
removes the entire base.

`--json` works before or after the command. Inspection and checks return an object
for one input and an array for multiple inputs. Other commands return an object
containing `networks` or `addresses`; `nearby` entries also include range endpoints,
an offset, and a `current` marker. JSON counts are exact integers, including IPv6
counts; consumers using floating-point numbers should take care with large values.

Exit codes: **0** for success or all checks true, **1** if any membership/overlap
check is false, **2** for invalid input. Truncated listings exit successfully and
explicitly report truncation as described above.

Tests live in `bin/common/tests/test_cidr.py` and use Python's built-in `unittest`.
They exercise the CLI in subprocesses and check plain-text output through a
pseudo-terminal. Run them from the repository root:

```sh
python3 -m unittest discover -s bin/common/tests -p 'test_cidr.py'
```

You can also run the test file directly with `python3 bin/common/tests/test_cidr.py -v`.
For strict type checking, run `uv tool run --from mypy mypy --strict bin/common/cidr`.
