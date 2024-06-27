#pragma once

#include <stdio.h>
#include <string.h>

#define COLOR "\033[36m" // cyan
#define GREEN "\033[32m"
#define YELLOW "\033[33m"
#define NCOLOR "\033[0m"

const char *ascii_control_char_map[] = {
    COLOR "\\0" NCOLOR,   COLOR "<SOH>" NCOLOR, COLOR "<STX>" NCOLOR,
    COLOR "<ETX>" NCOLOR, COLOR "<EOT>" NCOLOR, COLOR "<ENQ>" NCOLOR,
    COLOR "<ACK>" NCOLOR, COLOR "<BEL>" NCOLOR, COLOR "<BS>" NCOLOR,
    COLOR "<HT>" NCOLOR,  COLOR "\\n" NCOLOR,   COLOR "<VT>" NCOLOR,
    COLOR "<FF>" NCOLOR,  COLOR "\\r" NCOLOR,   COLOR "<SO>" NCOLOR,
    COLOR "<SI>" NCOLOR,  COLOR "<DLE>" NCOLOR, COLOR "<DC1>" NCOLOR,
    COLOR "<DC2>" NCOLOR, COLOR "<DC3>" NCOLOR, COLOR "<DC4>" NCOLOR,
    COLOR "<NAK>" NCOLOR, COLOR "<SYN>" NCOLOR, COLOR "<ETB>" NCOLOR,
    COLOR "<CAN>" NCOLOR, COLOR "<EM>" NCOLOR,  COLOR "<SUB>" NCOLOR,
    COLOR "\\e" NCOLOR,   COLOR "<FS>" NCOLOR,  COLOR "<GS>" NCOLOR,
    COLOR "<RS>" NCOLOR,  COLOR "<US>" NCOLOR,
};

int is_special_char(unsigned char c) {
  return c < 0x20 || c == 0x22 || c == 0x5C;
}

int is_ascii_char(unsigned char c) { return c < 0x80; }

const char *color_special_char(unsigned char c) {
  switch (c) {
  case 0x00 ... 0x1F:
    return ascii_control_char_map[c];
  case 0x22:
    return COLOR "\\\"" NCOLOR;
  case 0x5C:
    return COLOR "\\\\" NCOLOR;
  default:
    return NULL;
  }
}

void ascii_print(const char *str) {
  unsigned char *p = (unsigned char *)str;
  fputs(YELLOW, stdout);
  while (*p) {
    if (is_special_char(*p)) {
      fputs(color_special_char(*p), stdout);
      fputs(YELLOW, stdout);
    } else {
      putchar(*p);
    }
    p++;
  }
  fputs(NCOLOR, stdout);
}

void ascii_print_quotes(const char *str) {
  unsigned char *p = (unsigned char *)str;
  fputs(YELLOW, stdout);
  putchar('"');
  ascii_print(str);
  fputs(YELLOW, stdout);
  putchar('"');
  fputs(NCOLOR, stdout);
}

void env_print(const char *str) {
  unsigned char *p = (unsigned char *)str;

  int is_path_like = strstr(str, "PATH") != NULL;

  fputs(YELLOW, stdout);
  putchar('"');
  fputs(GREEN, stdout);
  while (*p) {
    if (*p == '=') {
      fputs(NCOLOR, stdout);
      fputs("\033[2m", stdout);
      putchar('=');
      fputs(NCOLOR, stdout);
      break;
    }
    if (is_special_char(*p)) {
      fputs(color_special_char(*p), stdout);
    } else {
      putchar(*p);
    }
    p++;
  }

  p++;
  
  fputs(YELLOW, stdout);
  while (*p) {
    if (is_special_char(*p)) {
      fputs(color_special_char(*p), stdout);
      fputs(YELLOW, stdout);
    } else if (*p == ':' && is_path_like) {
      fputs("\033[2m", stdout);
      putchar(*p);
      fputs(NCOLOR, stdout);
      fputs(YELLOW, stdout);
    } else {
      putchar(*p);
    }
    p++;
  }
  fputs(NCOLOR, stdout);


  fputs(YELLOW, stdout);
  putchar('"');
  fputs(NCOLOR, stdout);
}
