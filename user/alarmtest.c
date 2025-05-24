#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile int alarm_fired_flag = 0;

void my_alarm_handler();

int main(int argc, char *argv[]) {
  void (*handler_func_ptr)();

  handler_func_ptr = my_alarm_handler;

  int test_duration_seconds = 7;
  int alarm_trigger_seconds = 3;

  if (argc > 1) {
    alarm_trigger_seconds = atoi(argv[1]);
  }
  if (argc > 2) {
    test_duration_seconds = atoi(argv[2]);
  }

  printf("Alarm Test Program\n");

  if (alarm_trigger_seconds > 0) {
    printf("Setting alarm for %d seconds.\n", alarm_trigger_seconds);
  } else {
    printf("Cancelling any existing alarm.\n");
  }
  printf("Test will run for approx %d seconds.\n", test_duration_seconds);

  int prev_alarm_return_val = alarm(alarm_trigger_seconds, handler_func_ptr);

  if (prev_alarm_return_val != 0) {
      printf("Note: A previous alarm was active and had %d seconds remaining. It has been replaced.\n", prev_alarm_return_val);
  }
  
  printf("Alarm set/cancelled. Main loop starting...\n");
  
  uint start_os_ticks = uptime();
  uint current_os_ticks;
  long long i = 0;
  int dots_printed = 0;

  while (1) {
    current_os_ticks = uptime();
    if ((current_os_ticks - start_os_ticks) >= (uint)(test_duration_seconds * 100)) { 
        break; 
    }

    if (i % 500000 == 0) { 
        printf(".");
    }
    i++;
  }
  
  printf("\nMain loop finished.\n");

  if (alarm_fired_flag) {
    printf("SUCCESS: Alarm handler was executed.\n");
  } else {
    if (alarm_trigger_seconds > 0) {
        printf("FAILURE: Alarm handler was NOT executed or test timed out too soon.\n");
    } else {
        printf("INFO: Alarm was cancelled; handler not expected.\n");
    }
  }

  exit(0);
}


void my_alarm_handler() {
  printf("\n<<<<< ALARM FIRED! Handler executed. >>>>>\n");
  alarm_fired_flag = 1;
}