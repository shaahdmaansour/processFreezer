#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(2, "Usage: setpriority <pid> <priority>\n");
        exit(1);
    }
    int pid = atoi(argv[1]);
    int priority = atoi(argv[2]);

    if (setpriority(pid, priority) < 0) {
        fprintf(2, "Error setting priority\n");
        exit(1);
    }

    printf("Priority of process %d set to %d\n", pid, priority);
    exit(0);
}

