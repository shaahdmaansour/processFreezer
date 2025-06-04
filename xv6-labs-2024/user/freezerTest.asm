
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
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  // Add a small delay to help prevent output collisions
  sleep(1);
  10:	4505                	li	a0,1
  12:	4fc000ef          	jal	50e <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	864a                	mv	a2,s2
  18:	85a6                	mv	a1,s1
  1a:	00001517          	auipc	a0,0x1
  1e:	a6650513          	addi	a0,a0,-1434 # a80 <malloc+0xf8>
  22:	0af000ef          	jal	8d0 <printf>
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
  3e:	a5650513          	addi	a0,a0,-1450 # a90 <malloc+0x108>
  42:	08f000ef          	jal	8d0 <printf>
  printf("PID\tState\n");
  46:	00001517          	auipc	a0,0x1
  4a:	a6250513          	addi	a0,a0,-1438 # aa8 <malloc+0x120>
  4e:	083000ef          	jal	8d0 <printf>
  printf("----------------\n");
  52:	00001517          	auipc	a0,0x1
  56:	a6650513          	addi	a0,a0,-1434 # ab8 <malloc+0x130>
  5a:	077000ef          	jal	8d0 <printf>
  
  // Show parent process
  printf("%d\tParent\n", getpid());
  5e:	4a0000ef          	jal	4fe <getpid>
  62:	85aa                	mv	a1,a0
  64:	00001517          	auipc	a0,0x1
  68:	a6c50513          	addi	a0,a0,-1428 # ad0 <malloc+0x148>
  6c:	065000ef          	jal	8d0 <printf>
  
  // Show child process if it exists
  int child_pid = getpid() + 1;  // Child PID is typically parent + 1
  70:	48e000ef          	jal	4fe <getpid>
  printf("%d\tChild\n", child_pid);
  74:	0015059b          	addiw	a1,a0,1
  78:	00001517          	auipc	a0,0x1
  7c:	a6850513          	addi	a0,a0,-1432 # ae0 <malloc+0x158>
  80:	051000ef          	jal	8d0 <printf>
  
  // Show init process (PID 1)
  printf("1\tInit\n");
  84:	00001517          	auipc	a0,0x1
  88:	a6c50513          	addi	a0,a0,-1428 # af0 <malloc+0x168>
  8c:	045000ef          	jal	8d0 <printf>
  
  // Show shell process (PID 2)
  printf("2\tShell\n");
  90:	00001517          	auipc	a0,0x1
  94:	a6850513          	addi	a0,a0,-1432 # af8 <malloc+0x170>
  98:	039000ef          	jal	8d0 <printf>
  
  printf("----------------\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	a1c50513          	addi	a0,a0,-1508 # ab8 <malloc+0x130>
  a4:	02d000ef          	jal	8d0 <printf>
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
  b8:	3f6000ef          	jal	4ae <fork>
  
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
  ca:	434000ef          	jal	4fe <getpid>
  ce:	84aa                	mv	s1,a0
    printf("Child process started (PID: %d)\n", mypid);
  d0:	85aa                	mv	a1,a0
  d2:	00001517          	auipc	a0,0x1
  d6:	a4650513          	addi	a0,a0,-1466 # b18 <malloc+0x190>
  da:	7f6000ef          	jal	8d0 <printf>
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
  de:	00001997          	auipc	s3,0x1
  e2:	a6298993          	addi	s3,s3,-1438 # b40 <malloc+0x1b8>
      sleep(100);
  e6:	06400913          	li	s2,100
      print_status(mypid, "running");
  ea:	85ce                	mv	a1,s3
  ec:	8526                	mv	a0,s1
  ee:	f13ff0ef          	jal	0 <print_status>
      sleep(100);
  f2:	854a                	mv	a0,s2
  f4:	41a000ef          	jal	50e <sleep>
    while(1){
  f8:	bfcd                	j	ea <main+0x3a>
  fa:	ec26                	sd	s1,24(sp)
  fc:	e84a                	sd	s2,16(sp)
  fe:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 100:	00001517          	auipc	a0,0x1
 104:	a0850513          	addi	a0,a0,-1528 # b08 <malloc+0x180>
 108:	7c8000ef          	jal	8d0 <printf>
    exit(1);
 10c:	4505                	li	a0,1
 10e:	3a8000ef          	jal	4b6 <exit>
    }
  } else {
    // Parent process
    int mypid = getpid();
 112:	3ec000ef          	jal	4fe <getpid>
 116:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
 118:	8626                	mv	a2,s1
 11a:	00001517          	auipc	a0,0x1
 11e:	a2e50513          	addi	a0,a0,-1490 # b48 <malloc+0x1c0>
 122:	7ae000ef          	jal	8d0 <printf>
    
    // Show initial process state
    show_all_processes();
 126:	f0dff0ef          	jal	32 <show_all_processes>
    
    // Wait for child to start and run for a bit
    sleep(300);
 12a:	12c00513          	li	a0,300
 12e:	3e0000ef          	jal	50e <sleep>
    
    // Try to freeze child
    printf("\nAttempting to freeze child process %d...\n", child_pid);
 132:	85a6                	mv	a1,s1
 134:	00001517          	auipc	a0,0x1
 138:	a4c50513          	addi	a0,a0,-1460 # b80 <malloc+0x1f8>
 13c:	794000ef          	jal	8d0 <printf>
    int result = freeze(child_pid);
 140:	8526                	mv	a0,s1
 142:	414000ef          	jal	556 <freeze>
    if(result < 0){
 146:	08054363          	bltz	a0,1cc <main+0x11c>
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Frozen");
 14a:	00001597          	auipc	a1,0x1
 14e:	a9e58593          	addi	a1,a1,-1378 # be8 <malloc+0x260>
 152:	8526                	mv	a0,s1
 154:	eadff0ef          	jal	0 <print_status>
    
    // Show processes after freezing
    show_all_processes();
 158:	edbff0ef          	jal	32 <show_all_processes>
    
    // Keep frozen for a while
    sleep(300);
 15c:	12c00513          	li	a0,300
 160:	3ae000ef          	jal	50e <sleep>
    
    // Try to unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
 164:	85a6                	mv	a1,s1
 166:	00001517          	auipc	a0,0x1
 16a:	a8a50513          	addi	a0,a0,-1398 # bf0 <malloc+0x268>
 16e:	762000ef          	jal	8d0 <printf>
    result = unfreeze(child_pid);
 172:	8526                	mv	a0,s1
 174:	3ea000ef          	jal	55e <unfreeze>
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
 184:	ad858593          	addi	a1,a1,-1320 # c58 <malloc+0x2d0>
 188:	8526                	mv	a0,s1
 18a:	e77ff0ef          	jal	0 <print_status>
    
    // Show processes after unfreezing
    show_all_processes();
 18e:	ea5ff0ef          	jal	32 <show_all_processes>
    
    // Let it run for a while
    sleep(300);
 192:	12c00513          	li	a0,300
 196:	378000ef          	jal	50e <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 19a:	85a6                	mv	a1,s1
 19c:	00001517          	auipc	a0,0x1
 1a0:	acc50513          	addi	a0,a0,-1332 # c68 <malloc+0x2e0>
 1a4:	72c000ef          	jal	8d0 <printf>
    kill(child_pid);
 1a8:	8526                	mv	a0,s1
 1aa:	32c000ef          	jal	4d6 <kill>
    wait(0);
 1ae:	4501                	li	a0,0
 1b0:	30e000ef          	jal	4be <wait>
    print_status(child_pid, "Terminated");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	adc58593          	addi	a1,a1,-1316 # c90 <malloc+0x308>
 1bc:	8526                	mv	a0,s1
 1be:	e43ff0ef          	jal	0 <print_status>
    
    // Show final process state
    show_all_processes();
 1c2:	e71ff0ef          	jal	32 <show_all_processes>
  }
  
  exit(0);
 1c6:	4501                	li	a0,0
 1c8:	2ee000ef          	jal	4b6 <exit>
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
 1d0:	862a                	mv	a2,a0
 1d2:	85a6                	mv	a1,s1
 1d4:	00001517          	auipc	a0,0x1
 1d8:	9dc50513          	addi	a0,a0,-1572 # bb0 <malloc+0x228>
 1dc:	6f4000ef          	jal	8d0 <printf>
      kill(child_pid);
 1e0:	8526                	mv	a0,s1
 1e2:	2f4000ef          	jal	4d6 <kill>
      wait(0);
 1e6:	4501                	li	a0,0
 1e8:	2d6000ef          	jal	4be <wait>
      exit(1);
 1ec:	4505                	li	a0,1
 1ee:	2c8000ef          	jal	4b6 <exit>
 1f2:	e84a                	sd	s2,16(sp)
 1f4:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
 1f6:	862a                	mv	a2,a0
 1f8:	85a6                	mv	a1,s1
 1fa:	00001517          	auipc	a0,0x1
 1fe:	a2650513          	addi	a0,a0,-1498 # c20 <malloc+0x298>
 202:	6ce000ef          	jal	8d0 <printf>
      kill(child_pid);
 206:	8526                	mv	a0,s1
 208:	2ce000ef          	jal	4d6 <kill>
      wait(0);
 20c:	4501                	li	a0,0
 20e:	2b0000ef          	jal	4be <wait>
      exit(1);
 212:	4505                	li	a0,1
 214:	2a2000ef          	jal	4b6 <exit>

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
 226:	290000ef          	jal	4b6 <exit>

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
 286:	cf99                	beqz	a5,2a4 <strlen+0x2a>
 288:	0505                	addi	a0,a0,1
 28a:	87aa                	mv	a5,a0
 28c:	86be                	mv	a3,a5
 28e:	0785                	addi	a5,a5,1
 290:	fff7c703          	lbu	a4,-1(a5)
 294:	ff65                	bnez	a4,28c <strlen+0x12>
 296:	40a6853b          	subw	a0,a3,a0
 29a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  for(n = 0; s[n]; n++)
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <strlen+0x22>

00000000000002a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2b0:	ca19                	beqz	a2,2c6 <memset+0x1e>
 2b2:	87aa                	mv	a5,a0
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2c0:	0785                	addi	a5,a5,1
 2c2:	fee79de3          	bne	a5,a4,2bc <memset+0x14>
  }
  return dst;
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <strchr>:

char*
strchr(const char *s, char c)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cf81                	beqz	a5,2f2 <strchr+0x24>
    if(*s == c)
 2dc:	00f58763          	beq	a1,a5,2ea <strchr+0x1c>
  for(; *s; s++)
 2e0:	0505                	addi	a0,a0,1
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	fbfd                	bnez	a5,2dc <strchr+0xe>
      return (char*)s;
  return 0;
 2e8:	4501                	li	a0,0
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	bfdd                	j	2ea <strchr+0x1c>

00000000000002f6 <gets>:

char*
gets(char *buf, int max)
{
 2f6:	7159                	addi	sp,sp,-112
 2f8:	f486                	sd	ra,104(sp)
 2fa:	f0a2                	sd	s0,96(sp)
 2fc:	eca6                	sd	s1,88(sp)
 2fe:	e8ca                	sd	s2,80(sp)
 300:	e4ce                	sd	s3,72(sp)
 302:	e0d2                	sd	s4,64(sp)
 304:	fc56                	sd	s5,56(sp)
 306:	f85a                	sd	s6,48(sp)
 308:	f45e                	sd	s7,40(sp)
 30a:	f062                	sd	s8,32(sp)
 30c:	ec66                	sd	s9,24(sp)
 30e:	e86a                	sd	s10,16(sp)
 310:	1880                	addi	s0,sp,112
 312:	8caa                	mv	s9,a0
 314:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 316:	892a                	mv	s2,a0
 318:	4481                	li	s1,0
    cc = read(0, &c, 1);
 31a:	f9f40b13          	addi	s6,s0,-97
 31e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 320:	4ba9                	li	s7,10
 322:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 324:	8d26                	mv	s10,s1
 326:	0014899b          	addiw	s3,s1,1
 32a:	84ce                	mv	s1,s3
 32c:	0349d563          	bge	s3,s4,356 <gets+0x60>
    cc = read(0, &c, 1);
 330:	8656                	mv	a2,s5
 332:	85da                	mv	a1,s6
 334:	4501                	li	a0,0
 336:	198000ef          	jal	4ce <read>
    if(cc < 1)
 33a:	00a05e63          	blez	a0,356 <gets+0x60>
    buf[i++] = c;
 33e:	f9f44783          	lbu	a5,-97(s0)
 342:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 346:	01778763          	beq	a5,s7,354 <gets+0x5e>
 34a:	0905                	addi	s2,s2,1
 34c:	fd879ce3          	bne	a5,s8,324 <gets+0x2e>
    buf[i++] = c;
 350:	8d4e                	mv	s10,s3
 352:	a011                	j	356 <gets+0x60>
 354:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 356:	9d66                	add	s10,s10,s9
 358:	000d0023          	sb	zero,0(s10)
  return buf;
}
 35c:	8566                	mv	a0,s9
 35e:	70a6                	ld	ra,104(sp)
 360:	7406                	ld	s0,96(sp)
 362:	64e6                	ld	s1,88(sp)
 364:	6946                	ld	s2,80(sp)
 366:	69a6                	ld	s3,72(sp)
 368:	6a06                	ld	s4,64(sp)
 36a:	7ae2                	ld	s5,56(sp)
 36c:	7b42                	ld	s6,48(sp)
 36e:	7ba2                	ld	s7,40(sp)
 370:	7c02                	ld	s8,32(sp)
 372:	6ce2                	ld	s9,24(sp)
 374:	6d42                	ld	s10,16(sp)
 376:	6165                	addi	sp,sp,112
 378:	8082                	ret

000000000000037a <stat>:

int
stat(const char *n, struct stat *st)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	e04a                	sd	s2,0(sp)
 382:	1000                	addi	s0,sp,32
 384:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 386:	4581                	li	a1,0
 388:	196000ef          	jal	51e <open>
  if(fd < 0)
 38c:	02054263          	bltz	a0,3b0 <stat+0x36>
 390:	e426                	sd	s1,8(sp)
 392:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 394:	85ca                	mv	a1,s2
 396:	150000ef          	jal	4e6 <fstat>
 39a:	892a                	mv	s2,a0
  close(fd);
 39c:	8526                	mv	a0,s1
 39e:	1b0000ef          	jal	54e <close>
  return r;
 3a2:	64a2                	ld	s1,8(sp)
}
 3a4:	854a                	mv	a0,s2
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6902                	ld	s2,0(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret
    return -1;
 3b0:	597d                	li	s2,-1
 3b2:	bfcd                	j	3a4 <stat+0x2a>

00000000000003b4 <atoi>:

int
atoi(const char *s)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e406                	sd	ra,8(sp)
 3b8:	e022                	sd	s0,0(sp)
 3ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bc:	00054683          	lbu	a3,0(a0)
 3c0:	fd06879b          	addiw	a5,a3,-48
 3c4:	0ff7f793          	zext.b	a5,a5
 3c8:	4625                	li	a2,9
 3ca:	02f66963          	bltu	a2,a5,3fc <atoi+0x48>
 3ce:	872a                	mv	a4,a0
  n = 0;
 3d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d2:	0705                	addi	a4,a4,1
 3d4:	0025179b          	slliw	a5,a0,0x2
 3d8:	9fa9                	addw	a5,a5,a0
 3da:	0017979b          	slliw	a5,a5,0x1
 3de:	9fb5                	addw	a5,a5,a3
 3e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e4:	00074683          	lbu	a3,0(a4)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	fef671e3          	bgeu	a2,a5,3d2 <atoi+0x1e>
  return n;
}
 3f4:	60a2                	ld	ra,8(sp)
 3f6:	6402                	ld	s0,0(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  n = 0;
 3fc:	4501                	li	a0,0
 3fe:	bfdd                	j	3f4 <atoi+0x40>

0000000000000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 408:	02b57563          	bgeu	a0,a1,432 <memmove+0x32>
    while(n-- > 0)
 40c:	00c05f63          	blez	a2,42a <memmove+0x2a>
 410:	1602                	slli	a2,a2,0x20
 412:	9201                	srli	a2,a2,0x20
 414:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 418:	872a                	mv	a4,a0
      *dst++ = *src++;
 41a:	0585                	addi	a1,a1,1
 41c:	0705                	addi	a4,a4,1
 41e:	fff5c683          	lbu	a3,-1(a1)
 422:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 426:	fee79ae3          	bne	a5,a4,41a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42a:	60a2                	ld	ra,8(sp)
 42c:	6402                	ld	s0,0(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
    dst += n;
 432:	00c50733          	add	a4,a0,a2
    src += n;
 436:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 438:	fec059e3          	blez	a2,42a <memmove+0x2a>
 43c:	fff6079b          	addiw	a5,a2,-1
 440:	1782                	slli	a5,a5,0x20
 442:	9381                	srli	a5,a5,0x20
 444:	fff7c793          	not	a5,a5
 448:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 44a:	15fd                	addi	a1,a1,-1
 44c:	177d                	addi	a4,a4,-1
 44e:	0005c683          	lbu	a3,0(a1)
 452:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 456:	fef71ae3          	bne	a4,a5,44a <memmove+0x4a>
 45a:	bfc1                	j	42a <memmove+0x2a>

000000000000045c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e406                	sd	ra,8(sp)
 460:	e022                	sd	s0,0(sp)
 462:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 464:	ca0d                	beqz	a2,496 <memcmp+0x3a>
 466:	fff6069b          	addiw	a3,a2,-1
 46a:	1682                	slli	a3,a3,0x20
 46c:	9281                	srli	a3,a3,0x20
 46e:	0685                	addi	a3,a3,1
 470:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 472:	00054783          	lbu	a5,0(a0)
 476:	0005c703          	lbu	a4,0(a1)
 47a:	00e79863          	bne	a5,a4,48a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 47e:	0505                	addi	a0,a0,1
    p2++;
 480:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 482:	fed518e3          	bne	a0,a3,472 <memcmp+0x16>
  }
  return 0;
 486:	4501                	li	a0,0
 488:	a019                	j	48e <memcmp+0x32>
      return *p1 - *p2;
 48a:	40e7853b          	subw	a0,a5,a4
}
 48e:	60a2                	ld	ra,8(sp)
 490:	6402                	ld	s0,0(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret
  return 0;
 496:	4501                	li	a0,0
 498:	bfdd                	j	48e <memcmp+0x32>

000000000000049a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a2:	f5fff0ef          	jal	400 <memmove>
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret

00000000000004ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ae:	4885                	li	a7,1
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b6:	4889                	li	a7,2
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <wait>:
.global wait
wait:
 li a7, SYS_wait
 4be:	488d                	li	a7,3
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c6:	4891                	li	a7,4
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <read>:
.global read
read:
 li a7, SYS_read
 4ce:	4895                	li	a7,5
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d6:	4899                	li	a7,6
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <exec>:
.global exec
exec:
 li a7, SYS_exec
 4de:	489d                	li	a7,7
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e6:	48a1                	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ee:	48a5                	li	a7,9
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f6:	48a9                	li	a7,10
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4fe:	48ad                	li	a7,11
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 506:	48b1                	li	a7,12
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 50e:	48b5                	li	a7,13
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 516:	48b9                	li	a7,14
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <open>:
.global open
open:
 li a7, SYS_open
 51e:	48bd                	li	a7,15
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <write>:
.global write
write:
 li a7, SYS_write
 526:	48c1                	li	a7,16
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 52e:	48c5                	li	a7,17
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 536:	48c9                	li	a7,18
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <link>:
.global link
link:
 li a7, SYS_link
 53e:	48cd                	li	a7,19
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 546:	48d1                	li	a7,20
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 556:	48d9                	li	a7,22
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 55e:	48dd                	li	a7,23
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 566:	48e1                	li	a7,24
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56e:	1101                	addi	sp,sp,-32
 570:	ec06                	sd	ra,24(sp)
 572:	e822                	sd	s0,16(sp)
 574:	1000                	addi	s0,sp,32
 576:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57a:	4605                	li	a2,1
 57c:	fef40593          	addi	a1,s0,-17
 580:	fa7ff0ef          	jal	526 <write>
}
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	6105                	addi	sp,sp,32
 58a:	8082                	ret

000000000000058c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58c:	7139                	addi	sp,sp,-64
 58e:	fc06                	sd	ra,56(sp)
 590:	f822                	sd	s0,48(sp)
 592:	f426                	sd	s1,40(sp)
 594:	f04a                	sd	s2,32(sp)
 596:	ec4e                	sd	s3,24(sp)
 598:	0080                	addi	s0,sp,64
 59a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59c:	c299                	beqz	a3,5a2 <printint+0x16>
 59e:	0605ce63          	bltz	a1,61a <printint+0x8e>
  neg = 0;
 5a2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5a4:	fc040313          	addi	t1,s0,-64
  neg = 0;
 5a8:	869a                	mv	a3,t1
  i = 0;
 5aa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ac:	00000817          	auipc	a6,0x0
 5b0:	6fc80813          	addi	a6,a6,1788 # ca8 <digits>
 5b4:	88be                	mv	a7,a5
 5b6:	0017851b          	addiw	a0,a5,1
 5ba:	87aa                	mv	a5,a0
 5bc:	02c5f73b          	remuw	a4,a1,a2
 5c0:	1702                	slli	a4,a4,0x20
 5c2:	9301                	srli	a4,a4,0x20
 5c4:	9742                	add	a4,a4,a6
 5c6:	00074703          	lbu	a4,0(a4)
 5ca:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5ce:	872e                	mv	a4,a1
 5d0:	02c5d5bb          	divuw	a1,a1,a2
 5d4:	0685                	addi	a3,a3,1
 5d6:	fcc77fe3          	bgeu	a4,a2,5b4 <printint+0x28>
  if(neg)
 5da:	000e0c63          	beqz	t3,5f2 <printint+0x66>
    buf[i++] = '-';
 5de:	fd050793          	addi	a5,a0,-48
 5e2:	00878533          	add	a0,a5,s0
 5e6:	02d00793          	li	a5,45
 5ea:	fef50823          	sb	a5,-16(a0)
 5ee:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5f2:	fff7899b          	addiw	s3,a5,-1
 5f6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5fa:	fff4c583          	lbu	a1,-1(s1)
 5fe:	854a                	mv	a0,s2
 600:	f6fff0ef          	jal	56e <putc>
  while(--i >= 0)
 604:	39fd                	addiw	s3,s3,-1
 606:	14fd                	addi	s1,s1,-1
 608:	fe09d9e3          	bgez	s3,5fa <printint+0x6e>
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	7902                	ld	s2,32(sp)
 614:	69e2                	ld	s3,24(sp)
 616:	6121                	addi	sp,sp,64
 618:	8082                	ret
    x = -xx;
 61a:	40b005bb          	negw	a1,a1
    neg = 1;
 61e:	4e05                	li	t3,1
    x = -xx;
 620:	b751                	j	5a4 <printint+0x18>

0000000000000622 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 622:	711d                	addi	sp,sp,-96
 624:	ec86                	sd	ra,88(sp)
 626:	e8a2                	sd	s0,80(sp)
 628:	e4a6                	sd	s1,72(sp)
 62a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62c:	0005c483          	lbu	s1,0(a1)
 630:	26048663          	beqz	s1,89c <vprintf+0x27a>
 634:	e0ca                	sd	s2,64(sp)
 636:	fc4e                	sd	s3,56(sp)
 638:	f852                	sd	s4,48(sp)
 63a:	f456                	sd	s5,40(sp)
 63c:	f05a                	sd	s6,32(sp)
 63e:	ec5e                	sd	s7,24(sp)
 640:	e862                	sd	s8,16(sp)
 642:	e466                	sd	s9,8(sp)
 644:	8b2a                	mv	s6,a0
 646:	8a2e                	mv	s4,a1
 648:	8bb2                	mv	s7,a2
  state = 0;
 64a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 64c:	4901                	li	s2,0
 64e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 650:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 654:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 658:	06c00c93          	li	s9,108
 65c:	a00d                	j	67e <vprintf+0x5c>
        putc(fd, c0);
 65e:	85a6                	mv	a1,s1
 660:	855a                	mv	a0,s6
 662:	f0dff0ef          	jal	56e <putc>
 666:	a019                	j	66c <vprintf+0x4a>
    } else if(state == '%'){
 668:	03598363          	beq	s3,s5,68e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 66c:	0019079b          	addiw	a5,s2,1
 670:	893e                	mv	s2,a5
 672:	873e                	mv	a4,a5
 674:	97d2                	add	a5,a5,s4
 676:	0007c483          	lbu	s1,0(a5)
 67a:	20048963          	beqz	s1,88c <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 67e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 682:	fe0993e3          	bnez	s3,668 <vprintf+0x46>
      if(c0 == '%'){
 686:	fd579ce3          	bne	a5,s5,65e <vprintf+0x3c>
        state = '%';
 68a:	89be                	mv	s3,a5
 68c:	b7c5                	j	66c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 68e:	00ea06b3          	add	a3,s4,a4
 692:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 696:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 698:	c681                	beqz	a3,6a0 <vprintf+0x7e>
 69a:	9752                	add	a4,a4,s4
 69c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6a0:	03878e63          	beq	a5,s8,6dc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6a4:	05978863          	beq	a5,s9,6f4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a8:	07500713          	li	a4,117
 6ac:	0ee78263          	beq	a5,a4,790 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6b0:	07800713          	li	a4,120
 6b4:	12e78463          	beq	a5,a4,7dc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b8:	07000713          	li	a4,112
 6bc:	14e78963          	beq	a5,a4,80e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6c0:	07300713          	li	a4,115
 6c4:	18e78863          	beq	a5,a4,854 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c8:	02500713          	li	a4,37
 6cc:	04e79463          	bne	a5,a4,714 <vprintf+0xf2>
        putc(fd, '%');
 6d0:	85ba                	mv	a1,a4
 6d2:	855a                	mv	a0,s6
 6d4:	e9bff0ef          	jal	56e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bf49                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4685                	li	a3,1
 6e2:	4629                	li	a2,10
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	ea3ff0ef          	jal	58c <printint>
 6ee:	8ba6                	mv	s7,s1
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bfad                	j	66c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f4:	06400793          	li	a5,100
 6f8:	02f68963          	beq	a3,a5,72a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fc:	06c00793          	li	a5,108
 700:	04f68263          	beq	a3,a5,744 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 704:	07500793          	li	a5,117
 708:	0af68063          	beq	a3,a5,7a8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 70c:	07800793          	li	a5,120
 710:	0ef68263          	beq	a3,a5,7f4 <vprintf+0x1d2>
        putc(fd, '%');
 714:	02500593          	li	a1,37
 718:	855a                	mv	a0,s6
 71a:	e55ff0ef          	jal	56e <putc>
        putc(fd, c0);
 71e:	85a6                	mv	a1,s1
 720:	855a                	mv	a0,s6
 722:	e4dff0ef          	jal	56e <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	b791                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4685                	li	a3,1
 730:	4629                	li	a2,10
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e55ff0ef          	jal	58c <printint>
        i += 1;
 73c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
        i += 1;
 742:	b72d                	j	66c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	06400793          	li	a5,100
 748:	02f60763          	beq	a2,a5,776 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74c:	07500793          	li	a5,117
 750:	06f60963          	beq	a2,a5,7c2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 754:	07800793          	li	a5,120
 758:	faf61ee3          	bne	a2,a5,714 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75c:	008b8493          	addi	s1,s7,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000ba583          	lw	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	e23ff0ef          	jal	58c <printint>
        i += 2;
 76e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
        i += 2;
 774:	bde5                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 776:	008b8493          	addi	s1,s7,8
 77a:	4685                	li	a3,1
 77c:	4629                	li	a2,10
 77e:	000ba583          	lw	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	e09ff0ef          	jal	58c <printint>
        i += 2;
 788:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
        i += 2;
 78e:	bdf9                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 790:	008b8493          	addi	s1,s7,8
 794:	4681                	li	a3,0
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	defff0ef          	jal	58c <printint>
 7a2:	8ba6                	mv	s7,s1
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b5d9                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a8:	008b8493          	addi	s1,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4629                	li	a2,10
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	dd7ff0ef          	jal	58c <printint>
        i += 1;
 7ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7bc:	8ba6                	mv	s7,s1
      state = 0;
 7be:	4981                	li	s3,0
        i += 1;
 7c0:	b575                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c2:	008b8493          	addi	s1,s7,8
 7c6:	4681                	li	a3,0
 7c8:	4629                	li	a2,10
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	dbdff0ef          	jal	58c <printint>
        i += 2;
 7d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d6:	8ba6                	mv	s7,s1
      state = 0;
 7d8:	4981                	li	s3,0
        i += 2;
 7da:	bd49                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7dc:	008b8493          	addi	s1,s7,8
 7e0:	4681                	li	a3,0
 7e2:	4641                	li	a2,16
 7e4:	000ba583          	lw	a1,0(s7)
 7e8:	855a                	mv	a0,s6
 7ea:	da3ff0ef          	jal	58c <printint>
 7ee:	8ba6                	mv	s7,s1
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bdad                	j	66c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f4:	008b8493          	addi	s1,s7,8
 7f8:	4681                	li	a3,0
 7fa:	4641                	li	a2,16
 7fc:	000ba583          	lw	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	d8bff0ef          	jal	58c <printint>
        i += 1;
 806:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 808:	8ba6                	mv	s7,s1
      state = 0;
 80a:	4981                	li	s3,0
        i += 1;
 80c:	b585                	j	66c <vprintf+0x4a>
 80e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 810:	008b8d13          	addi	s10,s7,8
 814:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 818:	03000593          	li	a1,48
 81c:	855a                	mv	a0,s6
 81e:	d51ff0ef          	jal	56e <putc>
  putc(fd, 'x');
 822:	07800593          	li	a1,120
 826:	855a                	mv	a0,s6
 828:	d47ff0ef          	jal	56e <putc>
 82c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82e:	00000b97          	auipc	s7,0x0
 832:	47ab8b93          	addi	s7,s7,1146 # ca8 <digits>
 836:	03c9d793          	srli	a5,s3,0x3c
 83a:	97de                	add	a5,a5,s7
 83c:	0007c583          	lbu	a1,0(a5)
 840:	855a                	mv	a0,s6
 842:	d2dff0ef          	jal	56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 846:	0992                	slli	s3,s3,0x4
 848:	34fd                	addiw	s1,s1,-1
 84a:	f4f5                	bnez	s1,836 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 84c:	8bea                	mv	s7,s10
      state = 0;
 84e:	4981                	li	s3,0
 850:	6d02                	ld	s10,0(sp)
 852:	bd29                	j	66c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 854:	008b8993          	addi	s3,s7,8
 858:	000bb483          	ld	s1,0(s7)
 85c:	cc91                	beqz	s1,878 <vprintf+0x256>
        for(; *s; s++)
 85e:	0004c583          	lbu	a1,0(s1)
 862:	c195                	beqz	a1,886 <vprintf+0x264>
          putc(fd, *s);
 864:	855a                	mv	a0,s6
 866:	d09ff0ef          	jal	56e <putc>
        for(; *s; s++)
 86a:	0485                	addi	s1,s1,1
 86c:	0004c583          	lbu	a1,0(s1)
 870:	f9f5                	bnez	a1,864 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 872:	8bce                	mv	s7,s3
      state = 0;
 874:	4981                	li	s3,0
 876:	bbdd                	j	66c <vprintf+0x4a>
          s = "(null)";
 878:	00000497          	auipc	s1,0x0
 87c:	42848493          	addi	s1,s1,1064 # ca0 <malloc+0x318>
        for(; *s; s++)
 880:	02800593          	li	a1,40
 884:	b7c5                	j	864 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	b3cd                	j	66c <vprintf+0x4a>
 88c:	6906                	ld	s2,64(sp)
 88e:	79e2                	ld	s3,56(sp)
 890:	7a42                	ld	s4,48(sp)
 892:	7aa2                	ld	s5,40(sp)
 894:	7b02                	ld	s6,32(sp)
 896:	6be2                	ld	s7,24(sp)
 898:	6c42                	ld	s8,16(sp)
 89a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 89c:	60e6                	ld	ra,88(sp)
 89e:	6446                	ld	s0,80(sp)
 8a0:	64a6                	ld	s1,72(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	ec06                	sd	ra,24(sp)
 8aa:	e822                	sd	s0,16(sp)
 8ac:	1000                	addi	s0,sp,32
 8ae:	e010                	sd	a2,0(s0)
 8b0:	e414                	sd	a3,8(s0)
 8b2:	e818                	sd	a4,16(s0)
 8b4:	ec1c                	sd	a5,24(s0)
 8b6:	03043023          	sd	a6,32(s0)
 8ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	8622                	mv	a2,s0
 8c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c4:	d5fff0ef          	jal	622 <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6161                	addi	sp,sp,80
 8ce:	8082                	ret

00000000000008d0 <printf>:

void
printf(const char *fmt, ...)
{
 8d0:	711d                	addi	sp,sp,-96
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e40c                	sd	a1,8(s0)
 8da:	e810                	sd	a2,16(s0)
 8dc:	ec14                	sd	a3,24(s0)
 8de:	f018                	sd	a4,32(s0)
 8e0:	f41c                	sd	a5,40(s0)
 8e2:	03043823          	sd	a6,48(s0)
 8e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ea:	00840613          	addi	a2,s0,8
 8ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f2:	85aa                	mv	a1,a0
 8f4:	4505                	li	a0,1
 8f6:	d2dff0ef          	jal	622 <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6125                	addi	sp,sp,96
 900:	8082                	ret

0000000000000902 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 902:	1141                	addi	sp,sp,-16
 904:	e406                	sd	ra,8(sp)
 906:	e022                	sd	s0,0(sp)
 908:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	00001797          	auipc	a5,0x1
 912:	6f27b783          	ld	a5,1778(a5) # 2000 <freep>
 916:	a02d                	j	940 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 918:	4618                	lw	a4,8(a2)
 91a:	9f2d                	addw	a4,a4,a1
 91c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	6310                	ld	a2,0(a4)
 924:	a83d                	j	962 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 926:	ff852703          	lw	a4,-8(a0)
 92a:	9f31                	addw	a4,a4,a2
 92c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92e:	ff053683          	ld	a3,-16(a0)
 932:	a091                	j	976 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	6398                	ld	a4,0(a5)
 936:	00e7e463          	bltu	a5,a4,93e <free+0x3c>
 93a:	00e6ea63          	bltu	a3,a4,94e <free+0x4c>
{
 93e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	fed7fae3          	bgeu	a5,a3,934 <free+0x32>
 944:	6398                	ld	a4,0(a5)
 946:	00e6e463          	bltu	a3,a4,94e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	fee7eae3          	bltu	a5,a4,93e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 94e:	ff852583          	lw	a1,-8(a0)
 952:	6390                	ld	a2,0(a5)
 954:	02059813          	slli	a6,a1,0x20
 958:	01c85713          	srli	a4,a6,0x1c
 95c:	9736                	add	a4,a4,a3
 95e:	fae60de3          	beq	a2,a4,918 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 966:	4790                	lw	a2,8(a5)
 968:	02061593          	slli	a1,a2,0x20
 96c:	01c5d713          	srli	a4,a1,0x1c
 970:	973e                	add	a4,a4,a5
 972:	fae68ae3          	beq	a3,a4,926 <free+0x24>
    p->s.ptr = bp->s.ptr;
 976:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 978:	00001717          	auipc	a4,0x1
 97c:	68f73423          	sd	a5,1672(a4) # 2000 <freep>
}
 980:	60a2                	ld	ra,8(sp)
 982:	6402                	ld	s0,0(sp)
 984:	0141                	addi	sp,sp,16
 986:	8082                	ret

0000000000000988 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 988:	7139                	addi	sp,sp,-64
 98a:	fc06                	sd	ra,56(sp)
 98c:	f822                	sd	s0,48(sp)
 98e:	f04a                	sd	s2,32(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 994:	02051993          	slli	s3,a0,0x20
 998:	0209d993          	srli	s3,s3,0x20
 99c:	09bd                	addi	s3,s3,15
 99e:	0049d993          	srli	s3,s3,0x4
 9a2:	2985                	addiw	s3,s3,1
 9a4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9a6:	00001517          	auipc	a0,0x1
 9aa:	65a53503          	ld	a0,1626(a0) # 2000 <freep>
 9ae:	c905                	beqz	a0,9de <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	09377663          	bgeu	a4,s3,a40 <malloc+0xb8>
 9b8:	f426                	sd	s1,40(sp)
 9ba:	e852                	sd	s4,16(sp)
 9bc:	e456                	sd	s5,8(sp)
 9be:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9c0:	8a4e                	mv	s4,s3
 9c2:	6705                	lui	a4,0x1
 9c4:	00e9f363          	bgeu	s3,a4,9ca <malloc+0x42>
 9c8:	6a05                	lui	s4,0x1
 9ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d2:	00001497          	auipc	s1,0x1
 9d6:	62e48493          	addi	s1,s1,1582 # 2000 <freep>
  if(p == (char*)-1)
 9da:	5afd                	li	s5,-1
 9dc:	a83d                	j	a1a <malloc+0x92>
 9de:	f426                	sd	s1,40(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e6:	00001797          	auipc	a5,0x1
 9ea:	62a78793          	addi	a5,a5,1578 # 2010 <base>
 9ee:	00001717          	auipc	a4,0x1
 9f2:	60f73923          	sd	a5,1554(a4) # 2000 <freep>
 9f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fc:	b7d1                	j	9c0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9fe:	6398                	ld	a4,0(a5)
 a00:	e118                	sd	a4,0(a0)
 a02:	a899                	j	a58 <malloc+0xd0>
  hp->s.size = nu;
 a04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a08:	0541                	addi	a0,a0,16
 a0a:	ef9ff0ef          	jal	902 <free>
  return freep;
 a0e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a10:	c125                	beqz	a0,a70 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	03277163          	bgeu	a4,s2,a38 <malloc+0xb0>
    if(p == freep)
 a1a:	6098                	ld	a4,0(s1)
 a1c:	853e                	mv	a0,a5
 a1e:	fef71ae3          	bne	a4,a5,a12 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a22:	8552                	mv	a0,s4
 a24:	ae3ff0ef          	jal	506 <sbrk>
  if(p == (char*)-1)
 a28:	fd551ee3          	bne	a0,s5,a04 <malloc+0x7c>
        return 0;
 a2c:	4501                	li	a0,0
 a2e:	74a2                	ld	s1,40(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	a03d                	j	a64 <malloc+0xdc>
 a38:	74a2                	ld	s1,40(sp)
 a3a:	6a42                	ld	s4,16(sp)
 a3c:	6aa2                	ld	s5,8(sp)
 a3e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a40:	fae90fe3          	beq	s2,a4,9fe <malloc+0x76>
        p->s.size -= nunits;
 a44:	4137073b          	subw	a4,a4,s3
 a48:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4a:	02071693          	slli	a3,a4,0x20
 a4e:	01c6d713          	srli	a4,a3,0x1c
 a52:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a54:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a58:	00001717          	auipc	a4,0x1
 a5c:	5aa73423          	sd	a0,1448(a4) # 2000 <freep>
      return (void*)(p + 1);
 a60:	01078513          	addi	a0,a5,16
  }
}
 a64:	70e2                	ld	ra,56(sp)
 a66:	7442                	ld	s0,48(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6121                	addi	sp,sp,64
 a6e:	8082                	ret
 a70:	74a2                	ld	s1,40(sp)
 a72:	6a42                	ld	s4,16(sp)
 a74:	6aa2                	ld	s5,8(sp)
 a76:	6b02                	ld	s6,0(sp)
 a78:	b7f5                	j	a64 <malloc+0xdc>
