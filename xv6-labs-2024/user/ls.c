#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtmode(int mode, int type)
{
  static char buf[11];

  // For device files, the mode field contains the minor device number
  if (type == T_DEVICE)
  {
    buf[0] = 'c'; // character device
    strcpy(buf + 1, "rw-rw-rw-");
    buf[10] = 0;
    return buf;
  }

  buf[0] = (type == T_DIR) ? 'd' : '-';
  buf[1] = (mode & S_IRUSR) ? 'r' : '-';
  buf[2] = (mode & S_IWUSR) ? 'w' : '-';
  buf[3] = (mode & S_IXUSR) ? 'x' : '-';
  buf[4] = (mode & S_IRGRP) ? 'r' : '-';
  buf[5] = (mode & S_IWGRP) ? 'w' : '-';
  buf[6] = (mode & S_IXGRP) ? 'x' : '-';
  buf[7] = (mode & S_IROTH) ? 'r' : '-';
  buf[8] = (mode & S_IWOTH) ? 'w' : '-';
  buf[9] = (mode & S_IXOTH) ? 'x' : '-';
  buf[10] = 0;

  return buf;
}

char *
fmtname(char *path)
{
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  return buf;
}

void ls(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0)
  {
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0)
  {
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type)
  {
  case T_DEVICE:
  case T_FILE:
    printf("%s %s %d %d %d\n", fmtmode(st.mode, st.type), fmtname(path), st.type, st.ino, (int)st.size);
    break;

  case T_DIR:
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
    {
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';
    while (read(fd, &de, sizeof(de)) == sizeof(de))
    {
      if (de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if (stat(buf, &st) < 0)
      {
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      printf("%s %s %d %d %d\n", fmtmode(st.mode, st.type), fmtname(buf), st.type, st.ino, (int)st.size);
    }
    break;
  }
  close(fd);
}

int main(int argc, char *argv[])
{
  int i;

  if (argc < 2)
  {
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
  exit(0);
}
