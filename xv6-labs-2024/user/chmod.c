#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int mode;
    char *path;

    if (argc != 3)
    {
        printf("Usage: chmod mode file\n");
        exit(1);
    }

    // Simple octal mode parsing (e.g., 755, 644)
    mode = 0;
    for (char *p = argv[1]; *p; p++)
    {
        if (*p < '0' || *p > '7')
        {
            printf("chmod: invalid mode %s\n", argv[1]);
            exit(1);
        }
        mode = mode * 8 + (*p - '0');
    }

    path = argv[2];

    if (chmod(path, mode) < 0)
    {
        printf("chmod: %s failed\n", path);
        exit(1);
    }

    exit(0);
}
