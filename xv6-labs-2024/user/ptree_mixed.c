#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid1 = fork();
  if (pid1 == 0) {
    int pid_deep = fork();
    if (pid_deep == 0) {
      int pid_deeper = fork();
      if (pid_deeper == 0) {
        sleep(3);
        exit(0);
      }
      wait(0);
      exit(0);
    }
    wait(0);
    exit(0);
  }
  
  int pid2 = fork();
  if (pid2 == 0) {
    int pid_wide1 = fork();
    if (pid_wide1 == 0) {
      sleep(3);
      exit(0);
    }
    
    int pid_wide2 = fork();
    if (pid_wide2 == 0) {
      sleep(3);
      exit(0);
    }
    
    int pid_wide3 = fork();
    if (pid_wide3 == 0) {
      sleep(3);
      exit(0);
    }
    
    wait(0);
    wait(0);
    wait(0);
    exit(0);
  }
  
  int pid3 = fork();
  if (pid3 == 0) {
    sleep(3);
    exit(0);
  }
  
  sleep(1);
  ptree();
  
  wait(0);
  wait(0);
  wait(0);
  exit(0);
}
