#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

extern struct proc proc[NPROC];
extern char end[]; // first address after kernel, defined by kernel.ld

// Declare struct run
struct run {
  struct run *next;
};

// Declare kmem as external
extern struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

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
sys_freeze(void)
{
  int pid;
  argint(0, &pid);
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      if(p->state != ZOMBIE && p->state != UNUSED && !p->frozen){
        p->frozen = 1;  // set frozen flag
        release(&p->lock);
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
  }
  return -1;
}

uint64
sys_unfreeze(void)
{
  int pid;
  argint(0, &pid);
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      if(p->frozen){
        p->frozen = 0;  // clear frozen flag
        if(p->state == SLEEPING) {
          // Wake it up
          p->state = RUNNABLE;
        }
        release(&p->lock);
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
  }
  return -1;
}

// Return memory statistics
// Returns a 64-bit value where:
// - Upper 32 bits contain total free pages
// - Lower 32 bits contain total used pages
uint64
sys_meminfo(void)
{
  struct run *r;
  uint64 free_pages = 0;
  uint64 used_pages = 0;
  uint64 total_pages = (PHYSTOP - (uint64)end) / PGSIZE;

  // Count free pages
  acquire(&kmem.lock);
  for(r = kmem.freelist; r; r = r->next)
    free_pages++;
  release(&kmem.lock);

  // Calculate used pages
  used_pages = total_pages - free_pages;

  // Pack the values into a 64-bit return value
  return (free_pages << 32) | used_pages;
}

// Helper function to print process tree recursively
void
print_ptree_recursive(struct proc *p, int depth)
{
  struct proc *child;
  int i;

  // Print current process with indentation (2 spaces per depth level)
  for(i = 0; i < depth * 2; i++) {
    printf(" ");
  }
  printf("%s pid=%d ppid=%d\n", p->name, p->pid, p->parent ? p->parent->pid : 0);

  // Find and print children
  for(child = proc; child < &proc[NPROC]; child++) {
    acquire(&child->lock);
    if(child->state != UNUSED && child->parent == p) {
      release(&child->lock);
      print_ptree_recursive(child, depth + 1);
    } else {
      release(&child->lock);
    }
  }
}

uint64
sys_ptree(void)
{
  struct proc *init_proc = 0;
  struct proc *p;

  // Find the init process (PID 1)
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->pid == 1 && p->state != UNUSED) {
      init_proc = p;
      release(&p->lock);
      break;
    }
    release(&p->lock);
  }

  if(init_proc == 0) {
    printf("ptree: init process not found\n");
    return -1;
  }

  // Print the process tree starting from init
  print_ptree_recursive(init_proc, 0);
  return 0;
}
