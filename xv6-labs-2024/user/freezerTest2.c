#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Global variables for synchronization
int frozen1 = 0;
int frozen2 = 0;

void
print_status(int pid, const char *status)
{
  sleep(1);
  printf("Process %d: %s\n", pid, status);
}

void
show_all_processes(int pid1, int pid2)
{
  sleep(2);
  printf("\nCurrent Processes:\n");
  sleep(1);
  printf("PID\tState\n");
  sleep(1);
  printf("----------------\n");
  sleep(1);
  
  // Show parent process
  printf("%d\tRUNNING\n", getpid());
  sleep(1);
  
  // Show first child process
  if(frozen1) {
    printf("%d\tFROZEN\n", pid1);
  } else {
    printf("%d\tRUNNING\n", pid1);
  }
  sleep(1);
  
  // Show second child process
  if(frozen2) {
    printf("%d\tFROZEN\n", pid2);
  } else {
    printf("%d\tRUNNING\n", pid2);
  }
  sleep(1);
  
  // Show init and shell
  printf("1\tRUNNING\n");
  sleep(1);
  printf("2\tRUNNING\n");
  sleep(1);
  
  printf("----------------\n");
  sleep(1);
}

int
main(int argc, char *argv[])
{
  int child1_pid = fork();
  
  if(child1_pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  
  if(child1_pid == 0){
    // First child process
    int mypid = getpid();
    sleep(2);
    printf("Child process 1 started (PID: %d)\n", mypid);
    
    while(1){
      print_status(mypid, "running");
      sleep(100);
    }
  } else {
    // Parent process
    int child2_pid = fork();
    
    if(child2_pid < 0){
      printf("fork failed\n");
      kill(child1_pid);
      wait(0);
      exit(1);
    }
    
    if(child2_pid == 0){
      // Second child process
      int mypid = getpid();
      sleep(2);
      printf("Child process 2 started (PID: %d)\n", mypid);
      
      while(1){
        print_status(mypid, "running");
        sleep(100);
      }
    } else {
      // Parent process
      int mypid = getpid();
      printf("Parent process (PID: %d) created children (PIDs: %d, %d)\n", 
             mypid, child1_pid, child2_pid);
      
      // Show initial state
      show_all_processes(child1_pid, child2_pid);
      
      // Wait for children to start
      sleep(300);
      
      // Freeze first child
      printf("\nAttempting to freeze child process %d...\n", child1_pid);
      if(freeze(child1_pid) < 0){
        printf("Error: Failed to freeze process %d\n", child1_pid);
      } else {
        frozen1 = 1;
        print_status(child1_pid, "Frozen");
      }
      
      show_all_processes(child1_pid, child2_pid);
      sleep(200);
      
      // Freeze second child
      printf("\nAttempting to freeze child process %d...\n", child2_pid);
      if(freeze(child2_pid) < 0){
        printf("Error: Failed to freeze process %d\n", child2_pid);
      } else {
        frozen2 = 1;
        print_status(child2_pid, "Frozen");
      }
      
      show_all_processes(child1_pid, child2_pid);
      sleep(300);
      
      // Unfreeze first child
      printf("\nAttempting to unfreeze child process %d...\n", child1_pid);
      if(unfreeze(child1_pid) < 0){
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
      } else {
        frozen1 = 0;
        print_status(child1_pid, "Unfrozen");
      }
      
      show_all_processes(child1_pid, child2_pid);
      sleep(200);
      
      // Unfreeze second child
      printf("\nAttempting to unfreeze child process %d...\n", child2_pid);
      if(unfreeze(child2_pid) < 0){
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
      } else {
        frozen2 = 0;
        print_status(child2_pid, "Unfrozen");
      }
      
      show_all_processes(child1_pid, child2_pid);
      sleep(300);
      
      // Terminate children
      printf("\nTerminating child processes...\n");
      kill(child1_pid);
      kill(child2_pid);
      wait(0);
      wait(0);
      print_status(child1_pid, "Terminated");
      print_status(child2_pid, "Terminated");
      
      show_all_processes(child1_pid, child2_pid);
    }
  }
  
  exit(0);
} 