#include "asciiprint.h"

int main(int argc, char *argv[], char *envp[]) {
  int i;
  for (i = 0; envp[i] != NULL; i++) {
    printf("\033[2menvp[%d] = \033[0m", i);
    env_print(envp[i]);
    putchar('\n');
  }
  return 0;
}
