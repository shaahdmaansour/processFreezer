#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_alarm(void)
{
  int seconds;
  uint64 handler_addr;
  struct proc *p = myproc();
  int prev_alarm_remaining_seconds = 0;

  argint(0, &seconds);
  argaddr(1, &handler_addr);
  acquire(&p->lock);

  if (p->alarm_interval > 0 && p->alarm_ticks_left > 0) {
    prev_alarm_remaining_seconds = (p->alarm_ticks_left + HZ - 1) / HZ;
  }

  if (seconds <= 0) {
    p->alarm_interval = 0;
    p->alarm_ticks_left = 0;
    p->alarm_handler_addr = 0;
  } else {
    p->alarm_interval = seconds * HZ;
    p->alarm_ticks_left = p->alarm_interval;
    p->alarm_handler_addr = handler_addr;
  }

  release(&p->lock);

  return prev_alarm_remaining_seconds;
}