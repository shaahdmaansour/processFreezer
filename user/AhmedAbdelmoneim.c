// Example2: Create three child processes with fork()
#include "kernel/types.h"
#include "user/user.h"

int main() {
    int i;
    int pid;

    for (i = 0; i < 3; i++) {
        pid = fork();

        if (pid == 0) {
            printf("Child %d, PID: %d\n", i + 1, getpid());
            exit(0);
        }
    }

    printf("Parent, PID: %d\n", getpid());
    exit(0);
}
