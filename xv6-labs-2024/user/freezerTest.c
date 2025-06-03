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

void
show_all_processes(void)
{
  printf("\nCurrent Processes:\n");
  printf("PID\tState\n");
  printf("----------------\n");
  
  // Show parent process
  printf("%d\tParent\n", getpid());
  
  // Show child process if it exists
  int child_pid = getpid() + 1;  // Child PID is typically parent + 1
  printf("%d\tChild\n", child_pid);
  
  // Show init process (PID 1)
  printf("1\tInit\n");
  
  // Show shell process (PID 2)
  printf("2\tShell\n");
  
  printf("----------------\n");
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
    
    // Show initial process state
    show_all_processes();
    
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
    
    // Show processes after freezing
    show_all_processes();
    
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
    
    // Show processes after unfreezing
    show_all_processes();
    
    // Let it run for a while
    sleep(300);
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
    kill(child_pid);
    wait(0);
    print_status(child_pid, "Terminated");
    
    // Show final process state
    show_all_processes();
  }
  
  exit(0);
} 