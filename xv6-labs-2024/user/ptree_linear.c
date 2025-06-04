#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid1 = fork();
  if (pid1 == 0) {
    int pid2 = fork();
    if (pid2 == 0) {
      int pid3 = fork();
      if (pid3 == 0) {
        sleep(1);
        exit(0);
      } else {
        sleep(1);
        ptree();
        wait(0);
        exit(0);
      }
    } else {
      wait(0);
      exit(0);
    }
  } else {
    wait(0);
  }
  
  exit(0);
}
