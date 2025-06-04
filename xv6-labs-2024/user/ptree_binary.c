#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid1 = fork();
  if (pid1 == 0) {
    int pid_left1 = fork();
    if (pid_left1 == 0) {
      sleep(2);
      exit(0);
    }
    
    int pid_left2 = fork();
    if (pid_left2 == 0) {
      sleep(2);
      exit(0);
    }
    
    sleep(2);
    wait(0);
    wait(0);
    exit(0);
  }
  
  int pid2 = fork();
  if (pid2 == 0) {
    int pid_right1 = fork();
    if (pid_right1 == 0) {
      sleep(2);
      exit(0);
    }
    
    int pid_right2 = fork();
    if (pid_right2 == 0) {
      sleep(2);
      exit(0);
    }
    
    sleep(2);
    wait(0);
    wait(0);
    exit(0);
  }
  
  sleep(1);
  ptree();
  
  wait(0);
  wait(0);
  exit(0);
}
