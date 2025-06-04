#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  uint64 mem_stats = meminfo();
  
  if(mem_stats == -1) {
    fprintf(2, "meminfo: failed to get memory statistics\n");
    exit(1);
  }

  // Extract free and used pages from the 64-bit value
  uint64 free_pages = mem_stats >> 32;
  uint64 used_pages = mem_stats & 0xFFFFFFFF;
  
  // Convert to bytes (multiply by PGSIZE)
  uint64 free_bytes = free_pages * 4096;
  uint64 used_bytes = used_pages * 4096;
  uint64 total_bytes = free_bytes + used_bytes;

  // Print memory statistics
  printf("Memory Statistics:\n");
  printf("Total Memory: %d bytes\n", (int)total_bytes);
  printf("Used Memory:  %d bytes\n", (int)used_bytes);
  printf("Free Memory:  %d bytes\n", (int)free_bytes);
  
  // Calculate and print memory usage percentage
  int usage_percent;
  if (total_bytes == 0) {
    usage_percent = 0;  // If no memory, usage is 0%
  } else {
    usage_percent = (int)((used_bytes * 100) / total_bytes);
  }
  printf("Memory Usage: %d%%\n", usage_percent);

  exit(0);
} 