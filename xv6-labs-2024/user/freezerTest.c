#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
print_status(int pid, const char *status)
{
  // Add a small delay to help prevent output collisions
  sleep(1);
  printf("Process %d: %s\n", pid, status);
}

int
main(int argc, char *argv[])
{
  int child_pid = fork();
  
  if(child_pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  
  if(child_pid == 0){
    // Child process
    int mypid = getpid();
    printf("Child process started (PID: %d)\n", mypid);
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
      sleep(100);
    }
  } else {
    // Parent process
    int mypid = getpid();
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
    
    // Wait for child to start and run for a bit
    sleep(300);
    
    // Try to freeze child
    printf("\nAttempting to freeze child process %d...\n", child_pid);
    int result = freeze(child_pid);
    if(result < 0){
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Frozen");
    
    // Keep frozen for a while
    sleep(300);
    
    // Try to unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
    result = unfreeze(child_pid);
    if(result < 0){
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Unfrozen");
    
    // Let it run for a while
    sleep(300);
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
    kill(child_pid);
    wait(0);
    print_status(child_pid, "Terminated");
  }
  
  exit(0);
} 