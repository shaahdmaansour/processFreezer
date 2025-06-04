#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pids[5];
  int i;
  
  for (i = 0; i < 5; i++) {
    pids[i] = fork();
    if (pids[i] == 0) {
      sleep(2);
      exit(0);
    }
  }
  
  sleep(1);
  ptree();
  
  for (i = 0; i < 5; i++) {
    wait(0);
  }
  
  exit(0);
}
