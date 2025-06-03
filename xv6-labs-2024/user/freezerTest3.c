#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Global variables for synchronization
int frozen = 0;
int cpu_intensive = 0;

void
print_status(int pid, const char *status)
{
  sleep(1);
  printf("Process %d: %s\n", pid, status);
}

void
show_all_processes(int pid)
{
  sleep(2);
  printf("\nCurrent Processes:\n");
  sleep(1);
  printf("PID\tState\t\tCPU Usage\n");
  sleep(1);
  printf("--------------------------------\n");
  sleep(1);
  
  // Show parent process
  printf("%d\tRUNNING\t\tLow\n", getpid());
  sleep(1);
  
  // Show child process
  if(frozen) {
    printf("%d\tFROZEN\t\tHigh\n", pid);
  } else {
    printf("%d\tRUNNING\t\tHigh\n", pid);
  }
  sleep(1);
  
  // Show init and shell
  printf("1\tRUNNING\t\tLow\n");
  sleep(1);
  printf("2\tRUNNING\t\tLow\n");
  sleep(1);
  
  printf("--------------------------------\n");
  sleep(1);
}

// CPU intensive task
void
cpu_intensive_task(void)
{
  int i, j;
  while(1) {
    // Simulate CPU intensive work
    for(i = 0; i < 1000; i++) {
      for(j = 0; j < 1000; j++) {
        // Do some work
        if(i * j % 100 == 0) {
          sleep(1);  // Small sleep to prevent complete CPU hogging
        }
      }
    }
    if(!cpu_intensive) break;  // Exit if not CPU intensive anymore
  }
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
    sleep(2);
    printf("Child process started (PID: %d)\n", mypid);
    printf("Child process is CPU intensive\n");
    
    cpu_intensive = 1;
    cpu_intensive_task();
    
    // After being unfrozen, run normally
    while(1){
      print_status(mypid, "running normally");
      sleep(100);
    }
  } else {
    // Parent process
    int mypid = getpid();
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
    
    // Show initial state
    show_all_processes(child_pid);
    
    // Wait for child to start CPU intensive work
    sleep(300);
    
    // Freeze CPU intensive child
    printf("\nAttempting to freeze CPU intensive child process %d...\n", child_pid);
    if(freeze(child_pid) < 0){
      printf("Error: Failed to freeze process %d\n", child_pid);
    } else {
      frozen = 1;
      print_status(child_pid, "Frozen");
    }
    
    show_all_processes(child_pid);
    sleep(300);
    
    // Unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
    if(unfreeze(child_pid) < 0){
      printf("Error: Failed to unfreeze process %d\n", child_pid);
    } else {
      frozen = 0;
      cpu_intensive = 0;  // Stop CPU intensive work
      print_status(child_pid, "Unfrozen");
    }
    
    show_all_processes(child_pid);
    sleep(300);
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
    kill(child_pid);
    wait(0);
    print_status(child_pid, "Terminated");
    
    show_all_processes(child_pid);
  }
  
  exit(0);
}