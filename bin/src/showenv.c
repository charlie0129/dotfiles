#include "asciiprint.h"

int main(int argc, char *argv[], char *envp[]) {
  int i;
  for (i = 0; envp[i] != NULL; i++) {
    // If an argument is provided, only show that exact environment variable.
    if (argc == 2) {
      if (strncmp(envp[i], argv[1], strlen(argv[1])) != 0 ||
          envp[i][strlen(argv[1])] != '=') {
        continue;
      }
    }
    printf("\033[2menvp[%d] = \033[0m", i);
    env_print(envp[i]);
    putchar('\n');
  }
  return 0;
}
