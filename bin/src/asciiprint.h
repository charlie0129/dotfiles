#pragma once

#include <stdio.h>

#define COLOR "\033[36m"
#define YELLOW "\033[1;33m"
#define NCOLOR "\033[0m"

const char *ascii_char_map[] = {
    COLOR "\\0" NCOLOR,
    COLOR "<SOH>" NCOLOR,
    COLOR "<STX>" NCOLOR,
    COLOR "<ETX>" NCOLOR,
    COLOR "<EOT>" NCOLOR,
    COLOR "<ENQ>" NCOLOR,
    COLOR "<ACK>" NCOLOR,
    COLOR "<BEL>" NCOLOR,
    COLOR "<BS>" NCOLOR,
    COLOR "<HT>" NCOLOR,
    COLOR "\\n" NCOLOR,
    COLOR "<VT>" NCOLOR,
    COLOR "<FF>" NCOLOR,
    COLOR "\\r" NCOLOR,
    COLOR "<SO>" NCOLOR,
    COLOR "<SI>" NCOLOR,
    COLOR "<DLE>" NCOLOR,
    COLOR "<DC1>" NCOLOR,
    COLOR "<DC2>" NCOLOR,
    COLOR "<DC3>" NCOLOR,
    COLOR "<DC4>" NCOLOR,
    COLOR "<NAK>" NCOLOR,
    COLOR "<SYN>" NCOLOR,
    COLOR "<ETB>" NCOLOR,
    COLOR "<CAN>" NCOLOR,
    COLOR "<EM>" NCOLOR,
    COLOR "<SUB>" NCOLOR,
    COLOR "\\e" NCOLOR,
    COLOR "<FS>" NCOLOR,
    COLOR "<GS>" NCOLOR,
    COLOR "<RS>" NCOLOR,
    COLOR "<US>" NCOLOR,
    " ",
    "!",
    COLOR "\\\"" NCOLOR,
    "#",
    "$",
    "%",
    "&",
    "'",
    "(",
    ")",
    "*",
    "+",
    ",",
    "-",
    ".",
    "/",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    ":",
    ";",
    "<",
    "=",
    ">",
    "?",
    "@",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "[",
    COLOR "\\\\" NCOLOR,
    "]",
    "^",
    "_",
    "`",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "{",
    "|",
    "}",
    "~",
};

int char_map_len = sizeof(ascii_char_map) / sizeof(ascii_char_map[0]);

void ascii_print(const char *str) {
  unsigned char *p = (unsigned char *)str;
  while (*p) {
    if (*p < char_map_len) {
      fputs(ascii_char_map[*p], stdout);
    } else {
      putchar(*p);
    }
    p++;
  }
}

void env_print(const char *str) {
  unsigned char *p = (unsigned char *)str;
  fputs(YELLOW, stdout);
  int is_equal_found = 0;
  while (*p) {
    if (!is_equal_found && *p == '=') {
      fputs(NCOLOR, stdout);
      fputs("\033[2m", stdout);
    }
    if (*p < char_map_len) {
      fputs(ascii_char_map[*p], stdout);
    } else {
      putchar(*p);
    }
    if (!is_equal_found && *p == '=') {
      fputs("\033[0m", stdout);
      is_equal_found = 1;
    }
    p++;
  }
  fputs(NCOLOR, stdout);
}
