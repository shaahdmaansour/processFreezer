#include <stdio.h>
#include <stddef.h>
#include "kernel/types.h"
#include "kernel/fs.h"

int main()
{
    printf("struct dinode layout:\n");
    printf("type offset: %zu\n", offsetof(struct dinode, type));
    printf("major offset: %zu\n", offsetof(struct dinode, major));
    printf("minor offset: %zu\n", offsetof(struct dinode, minor));
    printf("nlink offset: %zu\n", offsetof(struct dinode, nlink));
    printf("size offset: %zu\n", offsetof(struct dinode, size));
    printf("mode offset: %zu\n", offsetof(struct dinode, mode));
    printf("unused offset: %zu\n", offsetof(struct dinode, unused));
    printf("addrs offset: %zu\n", offsetof(struct dinode, addrs));
    printf("indirect offset: %zu\n", offsetof(struct dinode, indirect));
    printf("Total size: %zu\n", sizeof(struct dinode));
    return 0;
}
