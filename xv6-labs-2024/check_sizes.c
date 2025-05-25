
#include <stdio.h>
#include "kernel/types.h"
#include "kernel/fs.h"

int main() {
    printf("BSIZE: %d\n", BSIZE);
    printf("sizeof(struct dinode): %lu\n", sizeof(struct dinode));
    printf("IPB (inodes per block): %d\n", IPB);
    printf("BSIZE %% sizeof(dinode): %lu\n", BSIZE % sizeof(struct dinode));
    return 0;
}

