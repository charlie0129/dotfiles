#include "asciiprint.h"

int main(int argc, char *argv[]) {
  int i;
  for (i = 0; i < argc; i++) {
    printf("\033[2margv[%d] = \033[0m", i);
    ascii_print_quotes(argv[i]);
    putchar('\n');
  }

  return 0;
}
