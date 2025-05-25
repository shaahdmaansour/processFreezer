#define T_DIR 1    // Directory
#define T_FILE 2   // File
#define T_DEVICE 3 // Device

// File permission bits (only define if not already defined by system headers)
#ifndef S_IRUSR
#define S_IRUSR 0400 // User read permission
#define S_IWUSR 0200 // User write permission
#define S_IXUSR 0100 // User execute permission
#define S_IRGRP 0040 // Group read permission
#define S_IWGRP 0020 // Group write permission
#define S_IXGRP 0010 // Group execute permission
#define S_IROTH 0004 // Other read permission
#define S_IWOTH 0002 // Other write permission
#define S_IXOTH 0001 // Other execute permission

// Common permission combinations
#define S_IRWXU (S_IRUSR | S_IWUSR | S_IXUSR) // User read/write/execute
#define S_IRWXG (S_IRGRP | S_IWGRP | S_IXGRP) // Group read/write/execute
#define S_IRWXO (S_IROTH | S_IWOTH | S_IXOTH) // Other read/write/execute
#endif

struct stat
{
  int dev;     // File system's disk device
  uint ino;    // Inode number
  short type;  // Type of file
  short nlink; // Number of links to file
  uint64 size; // Size of file in bytes
  short mode;  // File permissions
};
