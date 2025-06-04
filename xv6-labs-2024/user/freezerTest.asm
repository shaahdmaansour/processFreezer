
user/_freezerTest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_status>:
#include "kernel/stat.h"
#include "user/user.h"

void
print_status(int pid, const char *status)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
  // Add a small delay to help prevent output collisions
  sleep(1);
  10:	4505                	li	a0,1
  12:	4ea000ef          	jal	4fc <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	8626                	mv	a2,s1
  18:	85ca                	mv	a1,s2
  1a:	00001517          	auipc	a0,0x1
  1e:	a8650513          	addi	a0,a0,-1402 # aa0 <malloc+0xf4>
  22:	0d3000ef          	jal	8f4 <printf>
}
  26:	60e2                	ld	ra,24(sp)
  28:	6442                	ld	s0,16(sp)
  2a:	64a2                	ld	s1,8(sp)
  2c:	6902                	ld	s2,0(sp)
  2e:	6105                	addi	sp,sp,32
  30:	8082                	ret

0000000000000032 <show_all_processes>:

void
show_all_processes(void)
{
  32:	1141                	addi	sp,sp,-16
  34:	e406                	sd	ra,8(sp)
  36:	e022                	sd	s0,0(sp)
  38:	0800                	addi	s0,sp,16
  printf("\nCurrent Processes:\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	a7650513          	addi	a0,a0,-1418 # ab0 <malloc+0x104>
  42:	0b3000ef          	jal	8f4 <printf>
  printf("PID\tState\n");
  46:	00001517          	auipc	a0,0x1
  4a:	a8250513          	addi	a0,a0,-1406 # ac8 <malloc+0x11c>
  4e:	0a7000ef          	jal	8f4 <printf>
  printf("----------------\n");
  52:	00001517          	auipc	a0,0x1
  56:	a8650513          	addi	a0,a0,-1402 # ad8 <malloc+0x12c>
  5a:	09b000ef          	jal	8f4 <printf>
  
  // Show parent process
  printf("%d\tParent\n", getpid());
  5e:	48e000ef          	jal	4ec <getpid>
  62:	85aa                	mv	a1,a0
  64:	00001517          	auipc	a0,0x1
  68:	a8c50513          	addi	a0,a0,-1396 # af0 <malloc+0x144>
  6c:	089000ef          	jal	8f4 <printf>
  
  // Show child process if it exists
  int child_pid = getpid() + 1;  // Child PID is typically parent + 1
  70:	47c000ef          	jal	4ec <getpid>
  printf("%d\tChild\n", child_pid);
  74:	0015059b          	addiw	a1,a0,1
  78:	00001517          	auipc	a0,0x1
  7c:	a8850513          	addi	a0,a0,-1400 # b00 <malloc+0x154>
  80:	075000ef          	jal	8f4 <printf>
  
  // Show init process (PID 1)
  printf("1\tInit\n");
  84:	00001517          	auipc	a0,0x1
  88:	a8c50513          	addi	a0,a0,-1396 # b10 <malloc+0x164>
  8c:	069000ef          	jal	8f4 <printf>
  
  // Show shell process (PID 2)
  printf("2\tShell\n");
  90:	00001517          	auipc	a0,0x1
  94:	a8850513          	addi	a0,a0,-1400 # b18 <malloc+0x16c>
  98:	05d000ef          	jal	8f4 <printf>
  
  printf("----------------\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	a3c50513          	addi	a0,a0,-1476 # ad8 <malloc+0x12c>
  a4:	051000ef          	jal	8f4 <printf>
}
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <main>:

int
main(int argc, char *argv[])
{
  b0:	7179                	addi	sp,sp,-48
  b2:	f406                	sd	ra,40(sp)
  b4:	f022                	sd	s0,32(sp)
  b6:	1800                	addi	s0,sp,48
  int child_pid = fork();
  b8:	3e4000ef          	jal	49c <fork>
  
  if(child_pid < 0){
  bc:	02054f63          	bltz	a0,fa <main+0x4a>
  c0:	ec26                	sd	s1,24(sp)
  c2:	84aa                	mv	s1,a0
    printf("fork failed\n");
    exit(1);
  }
  
  if(child_pid == 0){
  c4:	e539                	bnez	a0,112 <main+0x62>
  c6:	e84a                	sd	s2,16(sp)
  c8:	e44e                	sd	s3,8(sp)
    // Child process
    int mypid = getpid();
  ca:	422000ef          	jal	4ec <getpid>
  ce:	84aa                	mv	s1,a0
    printf("Child process started (PID: %d)\n", mypid);
  d0:	85aa                	mv	a1,a0
  d2:	00001517          	auipc	a0,0x1
  d6:	a6650513          	addi	a0,a0,-1434 # b38 <malloc+0x18c>
  da:	01b000ef          	jal	8f4 <printf>
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
  de:	00001997          	auipc	s3,0x1
  e2:	a8298993          	addi	s3,s3,-1406 # b60 <malloc+0x1b4>
      sleep(100);
  e6:	06400913          	li	s2,100
      print_status(mypid, "running");
  ea:	85ce                	mv	a1,s3
  ec:	8526                	mv	a0,s1
  ee:	f13ff0ef          	jal	0 <print_status>
      sleep(100);
  f2:	854a                	mv	a0,s2
  f4:	408000ef          	jal	4fc <sleep>
    while(1){
  f8:	bfcd                	j	ea <main+0x3a>
  fa:	ec26                	sd	s1,24(sp)
  fc:	e84a                	sd	s2,16(sp)
  fe:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 100:	00001517          	auipc	a0,0x1
 104:	a2850513          	addi	a0,a0,-1496 # b28 <malloc+0x17c>
 108:	7ec000ef          	jal	8f4 <printf>
    exit(1);
 10c:	4505                	li	a0,1
 10e:	396000ef          	jal	4a4 <exit>
    }
  } else {
    // Parent process
    int mypid = getpid();
 112:	3da000ef          	jal	4ec <getpid>
 116:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
 118:	8626                	mv	a2,s1
 11a:	00001517          	auipc	a0,0x1
 11e:	a4e50513          	addi	a0,a0,-1458 # b68 <malloc+0x1bc>
 122:	7d2000ef          	jal	8f4 <printf>
    
    // Show initial process state
    show_all_processes();
 126:	f0dff0ef          	jal	32 <show_all_processes>
    
    // Wait for child to start and run for a bit
    sleep(300);
 12a:	12c00513          	li	a0,300
 12e:	3ce000ef          	jal	4fc <sleep>
    
    // Try to freeze child
    printf("\nAttempting to freeze child process %d...\n", child_pid);
 132:	85a6                	mv	a1,s1
 134:	00001517          	auipc	a0,0x1
 138:	a6c50513          	addi	a0,a0,-1428 # ba0 <malloc+0x1f4>
 13c:	7b8000ef          	jal	8f4 <printf>
    int result = freeze(child_pid);
 140:	8526                	mv	a0,s1
 142:	402000ef          	jal	544 <freeze>
    if(result < 0){
 146:	08054363          	bltz	a0,1cc <main+0x11c>
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Frozen");
 14a:	00001597          	auipc	a1,0x1
 14e:	abe58593          	addi	a1,a1,-1346 # c08 <malloc+0x25c>
 152:	8526                	mv	a0,s1
 154:	eadff0ef          	jal	0 <print_status>
    
    // Show processes after freezing
    show_all_processes();
 158:	edbff0ef          	jal	32 <show_all_processes>
    
    // Keep frozen for a while
    sleep(300);
 15c:	12c00513          	li	a0,300
 160:	39c000ef          	jal	4fc <sleep>
    
    // Try to unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
 164:	85a6                	mv	a1,s1
 166:	00001517          	auipc	a0,0x1
 16a:	aaa50513          	addi	a0,a0,-1366 # c10 <malloc+0x264>
 16e:	786000ef          	jal	8f4 <printf>
    result = unfreeze(child_pid);
 172:	8526                	mv	a0,s1
 174:	3d8000ef          	jal	54c <unfreeze>
    if(result < 0){
 178:	06054d63          	bltz	a0,1f2 <main+0x142>
 17c:	e84a                	sd	s2,16(sp)
 17e:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Unfrozen");
 180:	00001597          	auipc	a1,0x1
 184:	af858593          	addi	a1,a1,-1288 # c78 <malloc+0x2cc>
 188:	8526                	mv	a0,s1
 18a:	e77ff0ef          	jal	0 <print_status>
    
    // Show processes after unfreezing
    show_all_processes();
 18e:	ea5ff0ef          	jal	32 <show_all_processes>
    
    // Let it run for a while
    sleep(300);
 192:	12c00513          	li	a0,300
 196:	366000ef          	jal	4fc <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 19a:	85a6                	mv	a1,s1
 19c:	00001517          	auipc	a0,0x1
 1a0:	aec50513          	addi	a0,a0,-1300 # c88 <malloc+0x2dc>
 1a4:	750000ef          	jal	8f4 <printf>
    kill(child_pid);
 1a8:	8526                	mv	a0,s1
 1aa:	31a000ef          	jal	4c4 <kill>
    wait(0);
 1ae:	4501                	li	a0,0
 1b0:	2fc000ef          	jal	4ac <wait>
    print_status(child_pid, "Terminated");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	afc58593          	addi	a1,a1,-1284 # cb0 <malloc+0x304>
 1bc:	8526                	mv	a0,s1
 1be:	e43ff0ef          	jal	0 <print_status>
    
    // Show final process state
    show_all_processes();
 1c2:	e71ff0ef          	jal	32 <show_all_processes>
  }
  
  exit(0);
 1c6:	4501                	li	a0,0
 1c8:	2dc000ef          	jal	4a4 <exit>
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
 1d0:	862a                	mv	a2,a0
 1d2:	85a6                	mv	a1,s1
 1d4:	00001517          	auipc	a0,0x1
 1d8:	9fc50513          	addi	a0,a0,-1540 # bd0 <malloc+0x224>
 1dc:	718000ef          	jal	8f4 <printf>
      kill(child_pid);
 1e0:	8526                	mv	a0,s1
 1e2:	2e2000ef          	jal	4c4 <kill>
      wait(0);
 1e6:	4501                	li	a0,0
 1e8:	2c4000ef          	jal	4ac <wait>
      exit(1);
 1ec:	4505                	li	a0,1
 1ee:	2b6000ef          	jal	4a4 <exit>
 1f2:	e84a                	sd	s2,16(sp)
 1f4:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
 1f6:	862a                	mv	a2,a0
 1f8:	85a6                	mv	a1,s1
 1fa:	00001517          	auipc	a0,0x1
 1fe:	a4650513          	addi	a0,a0,-1466 # c40 <malloc+0x294>
 202:	6f2000ef          	jal	8f4 <printf>
      kill(child_pid);
 206:	8526                	mv	a0,s1
 208:	2bc000ef          	jal	4c4 <kill>
      wait(0);
 20c:	4501                	li	a0,0
 20e:	29e000ef          	jal	4ac <wait>
      exit(1);
 212:	4505                	li	a0,1
 214:	290000ef          	jal	4a4 <exit>

0000000000000218 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 220:	e91ff0ef          	jal	b0 <main>
  exit(0);
 224:	4501                	li	a0,0
 226:	27e000ef          	jal	4a4 <exit>

000000000000022a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 232:	87aa                	mv	a5,a0
 234:	0585                	addi	a1,a1,1
 236:	0785                	addi	a5,a5,1
 238:	fff5c703          	lbu	a4,-1(a1)
 23c:	fee78fa3          	sb	a4,-1(a5)
 240:	fb75                	bnez	a4,234 <strcpy+0xa>
    ;
  return os;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	cb91                	beqz	a5,26a <strcmp+0x20>
 258:	0005c703          	lbu	a4,0(a1)
 25c:	00f71763          	bne	a4,a5,26a <strcmp+0x20>
    p++, q++;
 260:	0505                	addi	a0,a0,1
 262:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	fbe5                	bnez	a5,258 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 26a:	0005c503          	lbu	a0,0(a1)
}
 26e:	40a7853b          	subw	a0,a5,a0
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <strlen>:

uint
strlen(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e406                	sd	ra,8(sp)
 27e:	e022                	sd	s0,0(sp)
 280:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 282:	00054783          	lbu	a5,0(a0)
 286:	cf91                	beqz	a5,2a2 <strlen+0x28>
 288:	00150793          	addi	a5,a0,1
 28c:	86be                	mv	a3,a5
 28e:	0785                	addi	a5,a5,1
 290:	fff7c703          	lbu	a4,-1(a5)
 294:	ff65                	bnez	a4,28c <strlen+0x12>
 296:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  for(n = 0; s[n]; n++)
 2a2:	4501                	li	a0,0
 2a4:	bfdd                	j	29a <strlen+0x20>

00000000000002a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ae:	ca19                	beqz	a2,2c4 <memset+0x1e>
 2b0:	87aa                	mv	a5,a0
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2be:	0785                	addi	a5,a5,1
 2c0:	fee79de3          	bne	a5,a4,2ba <memset+0x14>
  }
  return dst;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <strchr>:

char*
strchr(const char *s, char c)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	cf81                	beqz	a5,2f0 <strchr+0x24>
    if(*s == c)
 2da:	00f58763          	beq	a1,a5,2e8 <strchr+0x1c>
  for(; *s; s++)
 2de:	0505                	addi	a0,a0,1
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	fbfd                	bnez	a5,2da <strchr+0xe>
      return (char*)s;
  return 0;
 2e6:	4501                	li	a0,0
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfdd                	j	2e8 <strchr+0x1c>

00000000000002f4 <gets>:

char*
gets(char *buf, int max)
{
 2f4:	711d                	addi	sp,sp,-96
 2f6:	ec86                	sd	ra,88(sp)
 2f8:	e8a2                	sd	s0,80(sp)
 2fa:	e4a6                	sd	s1,72(sp)
 2fc:	e0ca                	sd	s2,64(sp)
 2fe:	fc4e                	sd	s3,56(sp)
 300:	f852                	sd	s4,48(sp)
 302:	f456                	sd	s5,40(sp)
 304:	f05a                	sd	s6,32(sp)
 306:	ec5e                	sd	s7,24(sp)
 308:	e862                	sd	s8,16(sp)
 30a:	1080                	addi	s0,sp,96
 30c:	8baa                	mv	s7,a0
 30e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 310:	892a                	mv	s2,a0
 312:	4481                	li	s1,0
    cc = read(0, &c, 1);
 314:	faf40b13          	addi	s6,s0,-81
 318:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 31a:	8c26                	mv	s8,s1
 31c:	0014899b          	addiw	s3,s1,1
 320:	84ce                	mv	s1,s3
 322:	0349d463          	bge	s3,s4,34a <gets+0x56>
    cc = read(0, &c, 1);
 326:	8656                	mv	a2,s5
 328:	85da                	mv	a1,s6
 32a:	4501                	li	a0,0
 32c:	190000ef          	jal	4bc <read>
    if(cc < 1)
 330:	00a05d63          	blez	a0,34a <gets+0x56>
      break;
    buf[i++] = c;
 334:	faf44783          	lbu	a5,-81(s0)
 338:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 33c:	0905                	addi	s2,s2,1
 33e:	ff678713          	addi	a4,a5,-10
 342:	c319                	beqz	a4,348 <gets+0x54>
 344:	17cd                	addi	a5,a5,-13
 346:	fbf1                	bnez	a5,31a <gets+0x26>
    buf[i++] = c;
 348:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 34a:	9c5e                	add	s8,s8,s7
 34c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 350:	855e                	mv	a0,s7
 352:	60e6                	ld	ra,88(sp)
 354:	6446                	ld	s0,80(sp)
 356:	64a6                	ld	s1,72(sp)
 358:	6906                	ld	s2,64(sp)
 35a:	79e2                	ld	s3,56(sp)
 35c:	7a42                	ld	s4,48(sp)
 35e:	7aa2                	ld	s5,40(sp)
 360:	7b02                	ld	s6,32(sp)
 362:	6be2                	ld	s7,24(sp)
 364:	6c42                	ld	s8,16(sp)
 366:	6125                	addi	sp,sp,96
 368:	8082                	ret

000000000000036a <stat>:

int
stat(const char *n, struct stat *st)
{
 36a:	1101                	addi	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	e04a                	sd	s2,0(sp)
 372:	1000                	addi	s0,sp,32
 374:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 376:	4581                	li	a1,0
 378:	194000ef          	jal	50c <open>
  if(fd < 0)
 37c:	02054263          	bltz	a0,3a0 <stat+0x36>
 380:	e426                	sd	s1,8(sp)
 382:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 384:	85ca                	mv	a1,s2
 386:	14e000ef          	jal	4d4 <fstat>
 38a:	892a                	mv	s2,a0
  close(fd);
 38c:	8526                	mv	a0,s1
 38e:	1ae000ef          	jal	53c <close>
  return r;
 392:	64a2                	ld	s1,8(sp)
}
 394:	854a                	mv	a0,s2
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	6902                	ld	s2,0(sp)
 39c:	6105                	addi	sp,sp,32
 39e:	8082                	ret
    return -1;
 3a0:	57fd                	li	a5,-1
 3a2:	893e                	mv	s2,a5
 3a4:	bfc5                	j	394 <stat+0x2a>

00000000000003a6 <atoi>:

int
atoi(const char *s)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ae:	00054683          	lbu	a3,0(a0)
 3b2:	fd06879b          	addiw	a5,a3,-48
 3b6:	0ff7f793          	zext.b	a5,a5
 3ba:	4625                	li	a2,9
 3bc:	02f66963          	bltu	a2,a5,3ee <atoi+0x48>
 3c0:	872a                	mv	a4,a0
  n = 0;
 3c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3c4:	0705                	addi	a4,a4,1
 3c6:	0025179b          	slliw	a5,a0,0x2
 3ca:	9fa9                	addw	a5,a5,a0
 3cc:	0017979b          	slliw	a5,a5,0x1
 3d0:	9fb5                	addw	a5,a5,a3
 3d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d6:	00074683          	lbu	a3,0(a4)
 3da:	fd06879b          	addiw	a5,a3,-48
 3de:	0ff7f793          	zext.b	a5,a5
 3e2:	fef671e3          	bgeu	a2,a5,3c4 <atoi+0x1e>
  return n;
}
 3e6:	60a2                	ld	ra,8(sp)
 3e8:	6402                	ld	s0,0(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
  n = 0;
 3ee:	4501                	li	a0,0
 3f0:	bfdd                	j	3e6 <atoi+0x40>

00000000000003f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3fa:	02b57563          	bgeu	a0,a1,424 <memmove+0x32>
    while(n-- > 0)
 3fe:	00c05f63          	blez	a2,41c <memmove+0x2a>
 402:	1602                	slli	a2,a2,0x20
 404:	9201                	srli	a2,a2,0x20
 406:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40a:	872a                	mv	a4,a0
      *dst++ = *src++;
 40c:	0585                	addi	a1,a1,1
 40e:	0705                	addi	a4,a4,1
 410:	fff5c683          	lbu	a3,-1(a1)
 414:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 418:	fee79ae3          	bne	a5,a4,40c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41c:	60a2                	ld	ra,8(sp)
 41e:	6402                	ld	s0,0(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
    while(n-- > 0)
 424:	fec05ce3          	blez	a2,41c <memmove+0x2a>
    dst += n;
 428:	00c50733          	add	a4,a0,a2
    src += n;
 42c:	95b2                	add	a1,a1,a2
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	fff7c793          	not	a5,a5
 43a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43c:	15fd                	addi	a1,a1,-1
 43e:	177d                	addi	a4,a4,-1
 440:	0005c683          	lbu	a3,0(a1)
 444:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 448:	fef71ae3          	bne	a4,a5,43c <memmove+0x4a>
 44c:	bfc1                	j	41c <memmove+0x2a>

000000000000044e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e406                	sd	ra,8(sp)
 452:	e022                	sd	s0,0(sp)
 454:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 456:	c61d                	beqz	a2,484 <memcmp+0x36>
 458:	1602                	slli	a2,a2,0x20
 45a:	9201                	srli	a2,a2,0x20
 45c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 460:	00054783          	lbu	a5,0(a0)
 464:	0005c703          	lbu	a4,0(a1)
 468:	00e79863          	bne	a5,a4,478 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 46c:	0505                	addi	a0,a0,1
    p2++;
 46e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 470:	fed518e3          	bne	a0,a3,460 <memcmp+0x12>
  }
  return 0;
 474:	4501                	li	a0,0
 476:	a019                	j	47c <memcmp+0x2e>
      return *p1 - *p2;
 478:	40e7853b          	subw	a0,a5,a4
}
 47c:	60a2                	ld	ra,8(sp)
 47e:	6402                	ld	s0,0(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  return 0;
 484:	4501                	li	a0,0
 486:	bfdd                	j	47c <memcmp+0x2e>

0000000000000488 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 490:	f63ff0ef          	jal	3f2 <memmove>
}
 494:	60a2                	ld	ra,8(sp)
 496:	6402                	ld	s0,0(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret

000000000000049c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 49c:	4885                	li	a7,1
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a4:	4889                	li	a7,2
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ac:	488d                	li	a7,3
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b4:	4891                	li	a7,4
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <read>:
.global read
read:
 li a7, SYS_read
 4bc:	4895                	li	a7,5
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c4:	4899                	li	a7,6
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4cc:	489d                	li	a7,7
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d4:	48a1                	li	a7,8
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4dc:	48a5                	li	a7,9
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e4:	48a9                	li	a7,10
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ec:	48ad                	li	a7,11
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f4:	48b1                	li	a7,12
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fc:	48b5                	li	a7,13
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 504:	48b9                	li	a7,14
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <open>:
.global open
open:
 li a7, SYS_open
 50c:	48bd                	li	a7,15
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <write>:
.global write
write:
 li a7, SYS_write
 514:	48c1                	li	a7,16
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51c:	48c5                	li	a7,17
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 524:	48c9                	li	a7,18
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <link>:
.global link
link:
 li a7, SYS_link
 52c:	48cd                	li	a7,19
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 534:	48d1                	li	a7,20
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <close>:
.global close
close:
 li a7, SYS_close
 53c:	48d5                	li	a7,21
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 544:	48d9                	li	a7,22
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 54c:	48dd                	li	a7,23
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 554:	48e1                	li	a7,24
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 55c:	48e5                	li	a7,25
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 564:	1101                	addi	sp,sp,-32
 566:	ec06                	sd	ra,24(sp)
 568:	e822                	sd	s0,16(sp)
 56a:	1000                	addi	s0,sp,32
 56c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 570:	4605                	li	a2,1
 572:	fef40593          	addi	a1,s0,-17
 576:	f9fff0ef          	jal	514 <write>
}
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f04a                	sd	s2,32(sp)
 58a:	ec4e                	sd	s3,24(sp)
 58c:	0080                	addi	s0,sp,64
 58e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 590:	cac9                	beqz	a3,622 <printint+0xa0>
 592:	01f5d79b          	srliw	a5,a1,0x1f
 596:	c7d1                	beqz	a5,622 <printint+0xa0>
    neg = 1;
    x = -xx;
 598:	40b005bb          	negw	a1,a1
    neg = 1;
 59c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 59e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 5a2:	86ce                	mv	a3,s3
  i = 0;
 5a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a6:	00000817          	auipc	a6,0x0
 5aa:	72280813          	addi	a6,a6,1826 # cc8 <digits>
 5ae:	88ba                	mv	a7,a4
 5b0:	0017051b          	addiw	a0,a4,1
 5b4:	872a                	mv	a4,a0
 5b6:	02c5f7bb          	remuw	a5,a1,a2
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	97c2                	add	a5,a5,a6
 5c0:	0007c783          	lbu	a5,0(a5)
 5c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c8:	87ae                	mv	a5,a1
 5ca:	02c5d5bb          	divuw	a1,a1,a2
 5ce:	0685                	addi	a3,a3,1
 5d0:	fcc7ffe3          	bgeu	a5,a2,5ae <printint+0x2c>
  if(neg)
 5d4:	00030c63          	beqz	t1,5ec <printint+0x6a>
    buf[i++] = '-';
 5d8:	fd050793          	addi	a5,a0,-48
 5dc:	00878533          	add	a0,a5,s0
 5e0:	02d00793          	li	a5,45
 5e4:	fef50823          	sb	a5,-16(a0)
 5e8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5ec:	02e05563          	blez	a4,616 <printint+0x94>
 5f0:	f426                	sd	s1,40(sp)
 5f2:	377d                	addiw	a4,a4,-1
 5f4:	00e984b3          	add	s1,s3,a4
 5f8:	19fd                	addi	s3,s3,-1
 5fa:	99ba                	add	s3,s3,a4
 5fc:	1702                	slli	a4,a4,0x20
 5fe:	9301                	srli	a4,a4,0x20
 600:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 604:	0004c583          	lbu	a1,0(s1)
 608:	854a                	mv	a0,s2
 60a:	f5bff0ef          	jal	564 <putc>
  while(--i >= 0)
 60e:	14fd                	addi	s1,s1,-1
 610:	ff349ae3          	bne	s1,s3,604 <printint+0x82>
 614:	74a2                	ld	s1,40(sp)
}
 616:	70e2                	ld	ra,56(sp)
 618:	7442                	ld	s0,48(sp)
 61a:	7902                	ld	s2,32(sp)
 61c:	69e2                	ld	s3,24(sp)
 61e:	6121                	addi	sp,sp,64
 620:	8082                	ret
  neg = 0;
 622:	4301                	li	t1,0
 624:	bfad                	j	59e <printint+0x1c>

0000000000000626 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 626:	711d                	addi	sp,sp,-96
 628:	ec86                	sd	ra,88(sp)
 62a:	e8a2                	sd	s0,80(sp)
 62c:	e4a6                	sd	s1,72(sp)
 62e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 630:	0005c483          	lbu	s1,0(a1)
 634:	20048963          	beqz	s1,846 <vprintf+0x220>
 638:	e0ca                	sd	s2,64(sp)
 63a:	fc4e                	sd	s3,56(sp)
 63c:	f852                	sd	s4,48(sp)
 63e:	f456                	sd	s5,40(sp)
 640:	f05a                	sd	s6,32(sp)
 642:	ec5e                	sd	s7,24(sp)
 644:	e862                	sd	s8,16(sp)
 646:	8b2a                	mv	s6,a0
 648:	8a2e                	mv	s4,a1
 64a:	8bb2                	mv	s7,a2
  state = 0;
 64c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 64e:	4901                	li	s2,0
 650:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 652:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 656:	06400c13          	li	s8,100
 65a:	a00d                	j	67c <vprintf+0x56>
        putc(fd, c0);
 65c:	85a6                	mv	a1,s1
 65e:	855a                	mv	a0,s6
 660:	f05ff0ef          	jal	564 <putc>
 664:	a019                	j	66a <vprintf+0x44>
    } else if(state == '%'){
 666:	03598363          	beq	s3,s5,68c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 66a:	0019079b          	addiw	a5,s2,1
 66e:	893e                	mv	s2,a5
 670:	873e                	mv	a4,a5
 672:	97d2                	add	a5,a5,s4
 674:	0007c483          	lbu	s1,0(a5)
 678:	1c048063          	beqz	s1,838 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 67c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 680:	fe0993e3          	bnez	s3,666 <vprintf+0x40>
      if(c0 == '%'){
 684:	fd579ce3          	bne	a5,s5,65c <vprintf+0x36>
        state = '%';
 688:	89be                	mv	s3,a5
 68a:	b7c5                	j	66a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 68c:	00ea06b3          	add	a3,s4,a4
 690:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 694:	1a060e63          	beqz	a2,850 <vprintf+0x22a>
      if(c0 == 'd'){
 698:	03878763          	beq	a5,s8,6c6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	f9478693          	addi	a3,a5,-108
 6a0:	0016b693          	seqz	a3,a3
 6a4:	f9c60593          	addi	a1,a2,-100
 6a8:	e99d                	bnez	a1,6de <vprintf+0xb8>
 6aa:	ca95                	beqz	a3,6de <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	ec9ff0ef          	jal	582 <printint>
        i += 1;
 6be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b75d                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	eafff0ef          	jal	582 <printint>
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b779                	j	66a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 6de:	9752                	add	a4,a4,s4
 6e0:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e4:	f9460713          	addi	a4,a2,-108
 6e8:	00173713          	seqz	a4,a4
 6ec:	8f75                	and	a4,a4,a3
 6ee:	f9c58513          	addi	a0,a1,-100
 6f2:	16051963          	bnez	a0,864 <vprintf+0x23e>
 6f6:	16070763          	beqz	a4,864 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fa:	008b8493          	addi	s1,s7,8
 6fe:	4685                	li	a3,1
 700:	4629                	li	a2,10
 702:	000ba583          	lw	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	e7bff0ef          	jal	582 <printint>
        i += 2;
 70c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70e:	8ba6                	mv	s7,s1
      state = 0;
 710:	4981                	li	s3,0
        i += 2;
 712:	bfa1                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 714:	008b8493          	addi	s1,s7,8
 718:	4681                	li	a3,0
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e61ff0ef          	jal	582 <printint>
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
 72a:	b781                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e49ff0ef          	jal	582 <printint>
        i += 1;
 73e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 740:	8ba6                	mv	s7,s1
      state = 0;
 742:	4981                	li	s3,0
 744:	b71d                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 746:	008b8493          	addi	s1,s7,8
 74a:	4681                	li	a3,0
 74c:	4629                	li	a2,10
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e2fff0ef          	jal	582 <printint>
        i += 2;
 758:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	b731                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 760:	008b8493          	addi	s1,s7,8
 764:	4681                	li	a3,0
 766:	4641                	li	a2,16
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	e15ff0ef          	jal	582 <printint>
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
 776:	bdd5                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	008b8493          	addi	s1,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	dfdff0ef          	jal	582 <printint>
        i += 1;
 78a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 78c:	8ba6                	mv	s7,s1
      state = 0;
 78e:	4981                	li	s3,0
 790:	bde9                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 792:	008b8493          	addi	s1,s7,8
 796:	4681                	li	a3,0
 798:	4641                	li	a2,16
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	de3ff0ef          	jal	582 <printint>
        i += 2;
 7a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	b5c1                	j	66a <vprintf+0x44>
 7ac:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7ae:	008b8793          	addi	a5,s7,8
 7b2:	8cbe                	mv	s9,a5
 7b4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b8:	03000593          	li	a1,48
 7bc:	855a                	mv	a0,s6
 7be:	da7ff0ef          	jal	564 <putc>
  putc(fd, 'x');
 7c2:	07800593          	li	a1,120
 7c6:	855a                	mv	a0,s6
 7c8:	d9dff0ef          	jal	564 <putc>
 7cc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ce:	00000b97          	auipc	s7,0x0
 7d2:	4fab8b93          	addi	s7,s7,1274 # cc8 <digits>
 7d6:	03c9d793          	srli	a5,s3,0x3c
 7da:	97de                	add	a5,a5,s7
 7dc:	0007c583          	lbu	a1,0(a5)
 7e0:	855a                	mv	a0,s6
 7e2:	d83ff0ef          	jal	564 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e6:	0992                	slli	s3,s3,0x4
 7e8:	34fd                	addiw	s1,s1,-1
 7ea:	f4f5                	bnez	s1,7d6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7ec:	8be6                	mv	s7,s9
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	6ca2                	ld	s9,8(sp)
 7f2:	bda5                	j	66a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7f4:	008b8993          	addi	s3,s7,8
 7f8:	000bb483          	ld	s1,0(s7)
 7fc:	cc91                	beqz	s1,818 <vprintf+0x1f2>
        for(; *s; s++)
 7fe:	0004c583          	lbu	a1,0(s1)
 802:	c985                	beqz	a1,832 <vprintf+0x20c>
          putc(fd, *s);
 804:	855a                	mv	a0,s6
 806:	d5fff0ef          	jal	564 <putc>
        for(; *s; s++)
 80a:	0485                	addi	s1,s1,1
 80c:	0004c583          	lbu	a1,0(s1)
 810:	f9f5                	bnez	a1,804 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 812:	8bce                	mv	s7,s3
      state = 0;
 814:	4981                	li	s3,0
 816:	bd91                	j	66a <vprintf+0x44>
          s = "(null)";
 818:	00000497          	auipc	s1,0x0
 81c:	4a848493          	addi	s1,s1,1192 # cc0 <malloc+0x314>
        for(; *s; s++)
 820:	02800593          	li	a1,40
 824:	b7c5                	j	804 <vprintf+0x1de>
        putc(fd, '%');
 826:	85be                	mv	a1,a5
 828:	855a                	mv	a0,s6
 82a:	d3bff0ef          	jal	564 <putc>
      state = 0;
 82e:	4981                	li	s3,0
 830:	bd2d                	j	66a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 832:	8bce                	mv	s7,s3
      state = 0;
 834:	4981                	li	s3,0
 836:	bd15                	j	66a <vprintf+0x44>
 838:	6906                	ld	s2,64(sp)
 83a:	79e2                	ld	s3,56(sp)
 83c:	7a42                	ld	s4,48(sp)
 83e:	7aa2                	ld	s5,40(sp)
 840:	7b02                	ld	s6,32(sp)
 842:	6be2                	ld	s7,24(sp)
 844:	6c42                	ld	s8,16(sp)
    }
  }
}
 846:	60e6                	ld	ra,88(sp)
 848:	6446                	ld	s0,80(sp)
 84a:	64a6                	ld	s1,72(sp)
 84c:	6125                	addi	sp,sp,96
 84e:	8082                	ret
      if(c0 == 'd'){
 850:	06400713          	li	a4,100
 854:	e6e789e3          	beq	a5,a4,6c6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 858:	f9478693          	addi	a3,a5,-108
 85c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 860:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 862:	4701                	li	a4,0
      } else if(c0 == 'u'){
 864:	07500513          	li	a0,117
 868:	eaa786e3          	beq	a5,a0,714 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 86c:	f8b60513          	addi	a0,a2,-117
 870:	e119                	bnez	a0,876 <vprintf+0x250>
 872:	ea069de3          	bnez	a3,72c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 876:	f8b58513          	addi	a0,a1,-117
 87a:	e119                	bnez	a0,880 <vprintf+0x25a>
 87c:	ec0715e3          	bnez	a4,746 <vprintf+0x120>
      } else if(c0 == 'x'){
 880:	07800513          	li	a0,120
 884:	eca78ee3          	beq	a5,a0,760 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 888:	f8860613          	addi	a2,a2,-120
 88c:	e219                	bnez	a2,892 <vprintf+0x26c>
 88e:	ee0695e3          	bnez	a3,778 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 892:	f8858593          	addi	a1,a1,-120
 896:	e199                	bnez	a1,89c <vprintf+0x276>
 898:	ee071de3          	bnez	a4,792 <vprintf+0x16c>
      } else if(c0 == 'p'){
 89c:	07000713          	li	a4,112
 8a0:	f0e786e3          	beq	a5,a4,7ac <vprintf+0x186>
      } else if(c0 == 's'){
 8a4:	07300713          	li	a4,115
 8a8:	f4e786e3          	beq	a5,a4,7f4 <vprintf+0x1ce>
      } else if(c0 == '%'){
 8ac:	02500713          	li	a4,37
 8b0:	f6e78be3          	beq	a5,a4,826 <vprintf+0x200>
        putc(fd, '%');
 8b4:	02500593          	li	a1,37
 8b8:	855a                	mv	a0,s6
 8ba:	cabff0ef          	jal	564 <putc>
        putc(fd, c0);
 8be:	85a6                	mv	a1,s1
 8c0:	855a                	mv	a0,s6
 8c2:	ca3ff0ef          	jal	564 <putc>
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	b34d                	j	66a <vprintf+0x44>

00000000000008ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ca:	715d                	addi	sp,sp,-80
 8cc:	ec06                	sd	ra,24(sp)
 8ce:	e822                	sd	s0,16(sp)
 8d0:	1000                	addi	s0,sp,32
 8d2:	e010                	sd	a2,0(s0)
 8d4:	e414                	sd	a3,8(s0)
 8d6:	e818                	sd	a4,16(s0)
 8d8:	ec1c                	sd	a5,24(s0)
 8da:	03043023          	sd	a6,32(s0)
 8de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	8622                	mv	a2,s0
 8e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e8:	d3fff0ef          	jal	626 <vprintf>
}
 8ec:	60e2                	ld	ra,24(sp)
 8ee:	6442                	ld	s0,16(sp)
 8f0:	6161                	addi	sp,sp,80
 8f2:	8082                	ret

00000000000008f4 <printf>:

void
printf(const char *fmt, ...)
{
 8f4:	711d                	addi	sp,sp,-96
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	addi	s0,sp,32
 8fc:	e40c                	sd	a1,8(s0)
 8fe:	e810                	sd	a2,16(s0)
 900:	ec14                	sd	a3,24(s0)
 902:	f018                	sd	a4,32(s0)
 904:	f41c                	sd	a5,40(s0)
 906:	03043823          	sd	a6,48(s0)
 90a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	00840613          	addi	a2,s0,8
 912:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 916:	85aa                	mv	a1,a0
 918:	4505                	li	a0,1
 91a:	d0dff0ef          	jal	626 <vprintf>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6125                	addi	sp,sp,96
 924:	8082                	ret

0000000000000926 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 926:	1141                	addi	sp,sp,-16
 928:	e406                	sd	ra,8(sp)
 92a:	e022                	sd	s0,0(sp)
 92c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	00001797          	auipc	a5,0x1
 936:	6ce7b783          	ld	a5,1742(a5) # 2000 <freep>
 93a:	a039                	j	948 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	6398                	ld	a4,0(a5)
 93e:	00e7e463          	bltu	a5,a4,946 <free+0x20>
 942:	00e6ea63          	bltu	a3,a4,956 <free+0x30>
{
 946:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 948:	fed7fae3          	bgeu	a5,a3,93c <free+0x16>
 94c:	6398                	ld	a4,0(a5)
 94e:	00e6e463          	bltu	a3,a4,956 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	fee7eae3          	bltu	a5,a4,946 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 956:	ff852583          	lw	a1,-8(a0)
 95a:	6390                	ld	a2,0(a5)
 95c:	02059813          	slli	a6,a1,0x20
 960:	01c85713          	srli	a4,a6,0x1c
 964:	9736                	add	a4,a4,a3
 966:	02e60563          	beq	a2,a4,990 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 96a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 96e:	4790                	lw	a2,8(a5)
 970:	02061593          	slli	a1,a2,0x20
 974:	01c5d713          	srli	a4,a1,0x1c
 978:	973e                	add	a4,a4,a5
 97a:	02e68263          	beq	a3,a4,99e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 97e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 980:	00001717          	auipc	a4,0x1
 984:	68f73023          	sd	a5,1664(a4) # 2000 <freep>
}
 988:	60a2                	ld	ra,8(sp)
 98a:	6402                	ld	s0,0(sp)
 98c:	0141                	addi	sp,sp,16
 98e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 990:	4618                	lw	a4,8(a2)
 992:	9f2d                	addw	a4,a4,a1
 994:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 998:	6398                	ld	a4,0(a5)
 99a:	6310                	ld	a2,0(a4)
 99c:	b7f9                	j	96a <free+0x44>
    p->s.size += bp->s.size;
 99e:	ff852703          	lw	a4,-8(a0)
 9a2:	9f31                	addw	a4,a4,a2
 9a4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9a6:	ff053683          	ld	a3,-16(a0)
 9aa:	bfd1                	j	97e <free+0x58>

00000000000009ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ac:	7139                	addi	sp,sp,-64
 9ae:	fc06                	sd	ra,56(sp)
 9b0:	f822                	sd	s0,48(sp)
 9b2:	f04a                	sd	s2,32(sp)
 9b4:	ec4e                	sd	s3,24(sp)
 9b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b8:	02051993          	slli	s3,a0,0x20
 9bc:	0209d993          	srli	s3,s3,0x20
 9c0:	09bd                	addi	s3,s3,15
 9c2:	0049d993          	srli	s3,s3,0x4
 9c6:	2985                	addiw	s3,s3,1
 9c8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9ca:	00001517          	auipc	a0,0x1
 9ce:	63653503          	ld	a0,1590(a0) # 2000 <freep>
 9d2:	c905                	beqz	a0,a02 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	09377663          	bgeu	a4,s3,a64 <malloc+0xb8>
 9dc:	f426                	sd	s1,40(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e4:	8a4e                	mv	s4,s3
 9e6:	6705                	lui	a4,0x1
 9e8:	00e9f363          	bgeu	s3,a4,9ee <malloc+0x42>
 9ec:	6a05                	lui	s4,0x1
 9ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f6:	00001497          	auipc	s1,0x1
 9fa:	60a48493          	addi	s1,s1,1546 # 2000 <freep>
  if(p == (char*)-1)
 9fe:	5afd                	li	s5,-1
 a00:	a83d                	j	a3e <malloc+0x92>
 a02:	f426                	sd	s1,40(sp)
 a04:	e852                	sd	s4,16(sp)
 a06:	e456                	sd	s5,8(sp)
 a08:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a0a:	00001797          	auipc	a5,0x1
 a0e:	60678793          	addi	a5,a5,1542 # 2010 <base>
 a12:	00001717          	auipc	a4,0x1
 a16:	5ef73723          	sd	a5,1518(a4) # 2000 <freep>
 a1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a20:	b7d1                	j	9e4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a22:	6398                	ld	a4,0(a5)
 a24:	e118                	sd	a4,0(a0)
 a26:	a899                	j	a7c <malloc+0xd0>
  hp->s.size = nu;
 a28:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2c:	0541                	addi	a0,a0,16
 a2e:	ef9ff0ef          	jal	926 <free>
  return freep;
 a32:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a34:	c125                	beqz	a0,a94 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a38:	4798                	lw	a4,8(a5)
 a3a:	03277163          	bgeu	a4,s2,a5c <malloc+0xb0>
    if(p == freep)
 a3e:	6098                	ld	a4,0(s1)
 a40:	853e                	mv	a0,a5
 a42:	fef71ae3          	bne	a4,a5,a36 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a46:	8552                	mv	a0,s4
 a48:	aadff0ef          	jal	4f4 <sbrk>
  if(p == (char*)-1)
 a4c:	fd551ee3          	bne	a0,s5,a28 <malloc+0x7c>
        return 0;
 a50:	4501                	li	a0,0
 a52:	74a2                	ld	s1,40(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	a03d                	j	a88 <malloc+0xdc>
 a5c:	74a2                	ld	s1,40(sp)
 a5e:	6a42                	ld	s4,16(sp)
 a60:	6aa2                	ld	s5,8(sp)
 a62:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a64:	fae90fe3          	beq	s2,a4,a22 <malloc+0x76>
        p->s.size -= nunits;
 a68:	4137073b          	subw	a4,a4,s3
 a6c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a6e:	02071693          	slli	a3,a4,0x20
 a72:	01c6d713          	srli	a4,a3,0x1c
 a76:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a78:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7c:	00001717          	auipc	a4,0x1
 a80:	58a73223          	sd	a0,1412(a4) # 2000 <freep>
      return (void*)(p + 1);
 a84:	01078513          	addi	a0,a5,16
  }
}
 a88:	70e2                	ld	ra,56(sp)
 a8a:	7442                	ld	s0,48(sp)
 a8c:	7902                	ld	s2,32(sp)
 a8e:	69e2                	ld	s3,24(sp)
 a90:	6121                	addi	sp,sp,64
 a92:	8082                	ret
 a94:	74a2                	ld	s1,40(sp)
 a96:	6a42                	ld	s4,16(sp)
 a98:	6aa2                	ld	s5,8(sp)
 a9a:	6b02                	ld	s6,0(sp)
 a9c:	b7f5                	j	a88 <malloc+0xdc>
