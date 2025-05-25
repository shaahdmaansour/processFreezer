#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
print_status(int pid, const char *status)
{
  printf("Process %d: %s\n", pid, status);
}

int
main(int argc, char *argv[])
{
  int pid = fork();
  
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  
  if(pid == 0){
    // Child process
    while(1){
      printf("Child process running...\n");
      sleep(100);
    }
  } else {
    // Parent process
    print_status(pid, "Started");
    sleep(200);
    
    // Freeze the child
    if(freeze(pid) < 0){
      printf("Failed to freeze process %d\n", pid);
      exit(1);
    }
    print_status(pid, "Frozen");
    sleep(200);
    
    // Unfreeze the child
    if(unfreeze(pid) < 0){
      printf("Failed to unfreeze process %d\n", pid);
      exit(1);
    }
    print_status(pid, "Unfrozen");
    sleep(200);
    
    // Kill the child
    kill(pid);
    wait(0);
    print_status(pid, "Terminated");
  }
  
  exit(0);
} 