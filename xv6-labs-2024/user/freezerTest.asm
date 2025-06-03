
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
  1e:	a6650513          	addi	a0,a0,-1434 # a80 <malloc+0x100>
  22:	0a7000ef          	jal	8c8 <printf>
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
  3e:	a5650513          	addi	a0,a0,-1450 # a90 <malloc+0x110>
  42:	087000ef          	jal	8c8 <printf>
  printf("PID\tState\n");
  46:	00001517          	auipc	a0,0x1
  4a:	a6250513          	addi	a0,a0,-1438 # aa8 <malloc+0x128>
  4e:	07b000ef          	jal	8c8 <printf>
  printf("----------------\n");
  52:	00001517          	auipc	a0,0x1
  56:	a6650513          	addi	a0,a0,-1434 # ab8 <malloc+0x138>
  5a:	06f000ef          	jal	8c8 <printf>
  
  // Show parent process
  printf("%d\tParent\n", getpid());
  5e:	4a0000ef          	jal	4fe <getpid>
  62:	85aa                	mv	a1,a0
  64:	00001517          	auipc	a0,0x1
  68:	a6c50513          	addi	a0,a0,-1428 # ad0 <malloc+0x150>
  6c:	05d000ef          	jal	8c8 <printf>
  
  // Show child process if it exists
  int child_pid = getpid() + 1;  // Child PID is typically parent + 1
  70:	48e000ef          	jal	4fe <getpid>
  printf("%d\tChild\n", child_pid);
  74:	0015059b          	addiw	a1,a0,1
  78:	00001517          	auipc	a0,0x1
  7c:	a6850513          	addi	a0,a0,-1432 # ae0 <malloc+0x160>
  80:	049000ef          	jal	8c8 <printf>
  
  // Show init process (PID 1)
  printf("1\tInit\n");
  84:	00001517          	auipc	a0,0x1
  88:	a6c50513          	addi	a0,a0,-1428 # af0 <malloc+0x170>
  8c:	03d000ef          	jal	8c8 <printf>
  
  // Show shell process (PID 2)
  printf("2\tShell\n");
  90:	00001517          	auipc	a0,0x1
  94:	a6850513          	addi	a0,a0,-1432 # af8 <malloc+0x178>
  98:	031000ef          	jal	8c8 <printf>
  
  printf("----------------\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	a1c50513          	addi	a0,a0,-1508 # ab8 <malloc+0x138>
  a4:	025000ef          	jal	8c8 <printf>
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
  d6:	a4650513          	addi	a0,a0,-1466 # b18 <malloc+0x198>
  da:	7ee000ef          	jal	8c8 <printf>
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
  de:	00001997          	auipc	s3,0x1
  e2:	a6298993          	addi	s3,s3,-1438 # b40 <malloc+0x1c0>
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
 104:	a0850513          	addi	a0,a0,-1528 # b08 <malloc+0x188>
 108:	7c0000ef          	jal	8c8 <printf>
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
 11e:	a2e50513          	addi	a0,a0,-1490 # b48 <malloc+0x1c8>
 122:	7a6000ef          	jal	8c8 <printf>
    
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
 138:	a4c50513          	addi	a0,a0,-1460 # b80 <malloc+0x200>
 13c:	78c000ef          	jal	8c8 <printf>
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
 14e:	a9e58593          	addi	a1,a1,-1378 # be8 <malloc+0x268>
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
 16a:	a8a50513          	addi	a0,a0,-1398 # bf0 <malloc+0x270>
 16e:	75a000ef          	jal	8c8 <printf>
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
 184:	ad858593          	addi	a1,a1,-1320 # c58 <malloc+0x2d8>
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
 1a0:	acc50513          	addi	a0,a0,-1332 # c68 <malloc+0x2e8>
 1a4:	724000ef          	jal	8c8 <printf>
    kill(child_pid);
 1a8:	8526                	mv	a0,s1
 1aa:	32c000ef          	jal	4d6 <kill>
    wait(0);
 1ae:	4501                	li	a0,0
 1b0:	30e000ef          	jal	4be <wait>
    print_status(child_pid, "Terminated");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	adc58593          	addi	a1,a1,-1316 # c90 <malloc+0x310>
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
 1d8:	9dc50513          	addi	a0,a0,-1572 # bb0 <malloc+0x230>
 1dc:	6ec000ef          	jal	8c8 <printf>
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
 1fe:	a2650513          	addi	a0,a0,-1498 # c20 <malloc+0x2a0>
 202:	6c6000ef          	jal	8c8 <printf>
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

0000000000000566 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 566:	1101                	addi	sp,sp,-32
 568:	ec06                	sd	ra,24(sp)
 56a:	e822                	sd	s0,16(sp)
 56c:	1000                	addi	s0,sp,32
 56e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 572:	4605                	li	a2,1
 574:	fef40593          	addi	a1,s0,-17
 578:	fafff0ef          	jal	526 <write>
}
 57c:	60e2                	ld	ra,24(sp)
 57e:	6442                	ld	s0,16(sp)
 580:	6105                	addi	sp,sp,32
 582:	8082                	ret

0000000000000584 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 584:	7139                	addi	sp,sp,-64
 586:	fc06                	sd	ra,56(sp)
 588:	f822                	sd	s0,48(sp)
 58a:	f426                	sd	s1,40(sp)
 58c:	f04a                	sd	s2,32(sp)
 58e:	ec4e                	sd	s3,24(sp)
 590:	0080                	addi	s0,sp,64
 592:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 594:	c299                	beqz	a3,59a <printint+0x16>
 596:	0605ce63          	bltz	a1,612 <printint+0x8e>
  neg = 0;
 59a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 59c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 5a0:	869a                	mv	a3,t1
  i = 0;
 5a2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5a4:	00000817          	auipc	a6,0x0
 5a8:	70480813          	addi	a6,a6,1796 # ca8 <digits>
 5ac:	88be                	mv	a7,a5
 5ae:	0017851b          	addiw	a0,a5,1
 5b2:	87aa                	mv	a5,a0
 5b4:	02c5f73b          	remuw	a4,a1,a2
 5b8:	1702                	slli	a4,a4,0x20
 5ba:	9301                	srli	a4,a4,0x20
 5bc:	9742                	add	a4,a4,a6
 5be:	00074703          	lbu	a4,0(a4)
 5c2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5c6:	872e                	mv	a4,a1
 5c8:	02c5d5bb          	divuw	a1,a1,a2
 5cc:	0685                	addi	a3,a3,1
 5ce:	fcc77fe3          	bgeu	a4,a2,5ac <printint+0x28>
  if(neg)
 5d2:	000e0c63          	beqz	t3,5ea <printint+0x66>
    buf[i++] = '-';
 5d6:	fd050793          	addi	a5,a0,-48
 5da:	00878533          	add	a0,a5,s0
 5de:	02d00793          	li	a5,45
 5e2:	fef50823          	sb	a5,-16(a0)
 5e6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5ea:	fff7899b          	addiw	s3,a5,-1
 5ee:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5f2:	fff4c583          	lbu	a1,-1(s1)
 5f6:	854a                	mv	a0,s2
 5f8:	f6fff0ef          	jal	566 <putc>
  while(--i >= 0)
 5fc:	39fd                	addiw	s3,s3,-1
 5fe:	14fd                	addi	s1,s1,-1
 600:	fe09d9e3          	bgez	s3,5f2 <printint+0x6e>
}
 604:	70e2                	ld	ra,56(sp)
 606:	7442                	ld	s0,48(sp)
 608:	74a2                	ld	s1,40(sp)
 60a:	7902                	ld	s2,32(sp)
 60c:	69e2                	ld	s3,24(sp)
 60e:	6121                	addi	sp,sp,64
 610:	8082                	ret
    x = -xx;
 612:	40b005bb          	negw	a1,a1
    neg = 1;
 616:	4e05                	li	t3,1
    x = -xx;
 618:	b751                	j	59c <printint+0x18>

000000000000061a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61a:	711d                	addi	sp,sp,-96
 61c:	ec86                	sd	ra,88(sp)
 61e:	e8a2                	sd	s0,80(sp)
 620:	e4a6                	sd	s1,72(sp)
 622:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 624:	0005c483          	lbu	s1,0(a1)
 628:	26048663          	beqz	s1,894 <vprintf+0x27a>
 62c:	e0ca                	sd	s2,64(sp)
 62e:	fc4e                	sd	s3,56(sp)
 630:	f852                	sd	s4,48(sp)
 632:	f456                	sd	s5,40(sp)
 634:	f05a                	sd	s6,32(sp)
 636:	ec5e                	sd	s7,24(sp)
 638:	e862                	sd	s8,16(sp)
 63a:	e466                	sd	s9,8(sp)
 63c:	8b2a                	mv	s6,a0
 63e:	8a2e                	mv	s4,a1
 640:	8bb2                	mv	s7,a2
  state = 0;
 642:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 644:	4901                	li	s2,0
 646:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 648:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 64c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 650:	06c00c93          	li	s9,108
 654:	a00d                	j	676 <vprintf+0x5c>
        putc(fd, c0);
 656:	85a6                	mv	a1,s1
 658:	855a                	mv	a0,s6
 65a:	f0dff0ef          	jal	566 <putc>
 65e:	a019                	j	664 <vprintf+0x4a>
    } else if(state == '%'){
 660:	03598363          	beq	s3,s5,686 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 664:	0019079b          	addiw	a5,s2,1
 668:	893e                	mv	s2,a5
 66a:	873e                	mv	a4,a5
 66c:	97d2                	add	a5,a5,s4
 66e:	0007c483          	lbu	s1,0(a5)
 672:	20048963          	beqz	s1,884 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 676:	0004879b          	sext.w	a5,s1
    if(state == 0){
 67a:	fe0993e3          	bnez	s3,660 <vprintf+0x46>
      if(c0 == '%'){
 67e:	fd579ce3          	bne	a5,s5,656 <vprintf+0x3c>
        state = '%';
 682:	89be                	mv	s3,a5
 684:	b7c5                	j	664 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 686:	00ea06b3          	add	a3,s4,a4
 68a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 68e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 690:	c681                	beqz	a3,698 <vprintf+0x7e>
 692:	9752                	add	a4,a4,s4
 694:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 698:	03878e63          	beq	a5,s8,6d4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	05978863          	beq	a5,s9,6ec <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a0:	07500713          	li	a4,117
 6a4:	0ee78263          	beq	a5,a4,788 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6a8:	07800713          	li	a4,120
 6ac:	12e78463          	beq	a5,a4,7d4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b0:	07000713          	li	a4,112
 6b4:	14e78963          	beq	a5,a4,806 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6b8:	07300713          	li	a4,115
 6bc:	18e78863          	beq	a5,a4,84c <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c0:	02500713          	li	a4,37
 6c4:	04e79463          	bne	a5,a4,70c <vprintf+0xf2>
        putc(fd, '%');
 6c8:	85ba                	mv	a1,a4
 6ca:	855a                	mv	a0,s6
 6cc:	e9bff0ef          	jal	566 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bf49                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4685                	li	a3,1
 6da:	4629                	li	a2,10
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	ea3ff0ef          	jal	584 <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bfad                	j	664 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6ec:	06400793          	li	a5,100
 6f0:	02f68963          	beq	a3,a5,722 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f4:	06c00793          	li	a5,108
 6f8:	04f68263          	beq	a3,a5,73c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6fc:	07500793          	li	a5,117
 700:	0af68063          	beq	a3,a5,7a0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 704:	07800793          	li	a5,120
 708:	0ef68263          	beq	a3,a5,7ec <vprintf+0x1d2>
        putc(fd, '%');
 70c:	02500593          	li	a1,37
 710:	855a                	mv	a0,s6
 712:	e55ff0ef          	jal	566 <putc>
        putc(fd, c0);
 716:	85a6                	mv	a1,s1
 718:	855a                	mv	a0,s6
 71a:	e4dff0ef          	jal	566 <putc>
      state = 0;
 71e:	4981                	li	s3,0
 720:	b791                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 722:	008b8493          	addi	s1,s7,8
 726:	4685                	li	a3,1
 728:	4629                	li	a2,10
 72a:	000ba583          	lw	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	e55ff0ef          	jal	584 <printint>
        i += 1;
 734:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 736:	8ba6                	mv	s7,s1
      state = 0;
 738:	4981                	li	s3,0
        i += 1;
 73a:	b72d                	j	664 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 73c:	06400793          	li	a5,100
 740:	02f60763          	beq	a2,a5,76e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 744:	07500793          	li	a5,117
 748:	06f60963          	beq	a2,a5,7ba <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 74c:	07800793          	li	a5,120
 750:	faf61ee3          	bne	a2,a5,70c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	008b8493          	addi	s1,s7,8
 758:	4681                	li	a3,0
 75a:	4641                	li	a2,16
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	e23ff0ef          	jal	584 <printint>
        i += 2;
 766:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 768:	8ba6                	mv	s7,s1
      state = 0;
 76a:	4981                	li	s3,0
        i += 2;
 76c:	bde5                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 76e:	008b8493          	addi	s1,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	e09ff0ef          	jal	584 <printint>
        i += 2;
 780:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 782:	8ba6                	mv	s7,s1
      state = 0;
 784:	4981                	li	s3,0
        i += 2;
 786:	bdf9                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 788:	008b8493          	addi	s1,s7,8
 78c:	4681                	li	a3,0
 78e:	4629                	li	a2,10
 790:	000ba583          	lw	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	defff0ef          	jal	584 <printint>
 79a:	8ba6                	mv	s7,s1
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b5d9                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	008b8493          	addi	s1,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	dd7ff0ef          	jal	584 <printint>
        i += 1;
 7b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	8ba6                	mv	s7,s1
      state = 0;
 7b6:	4981                	li	s3,0
        i += 1;
 7b8:	b575                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	008b8493          	addi	s1,s7,8
 7be:	4681                	li	a3,0
 7c0:	4629                	li	a2,10
 7c2:	000ba583          	lw	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	dbdff0ef          	jal	584 <printint>
        i += 2;
 7cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
        i += 2;
 7d2:	bd49                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7d4:	008b8493          	addi	s1,s7,8
 7d8:	4681                	li	a3,0
 7da:	4641                	li	a2,16
 7dc:	000ba583          	lw	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	da3ff0ef          	jal	584 <printint>
 7e6:	8ba6                	mv	s7,s1
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bdad                	j	664 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ec:	008b8493          	addi	s1,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	d8bff0ef          	jal	584 <printint>
        i += 1;
 7fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 800:	8ba6                	mv	s7,s1
      state = 0;
 802:	4981                	li	s3,0
        i += 1;
 804:	b585                	j	664 <vprintf+0x4a>
 806:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 808:	008b8d13          	addi	s10,s7,8
 80c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 810:	03000593          	li	a1,48
 814:	855a                	mv	a0,s6
 816:	d51ff0ef          	jal	566 <putc>
  putc(fd, 'x');
 81a:	07800593          	li	a1,120
 81e:	855a                	mv	a0,s6
 820:	d47ff0ef          	jal	566 <putc>
 824:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 826:	00000b97          	auipc	s7,0x0
 82a:	482b8b93          	addi	s7,s7,1154 # ca8 <digits>
 82e:	03c9d793          	srli	a5,s3,0x3c
 832:	97de                	add	a5,a5,s7
 834:	0007c583          	lbu	a1,0(a5)
 838:	855a                	mv	a0,s6
 83a:	d2dff0ef          	jal	566 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 83e:	0992                	slli	s3,s3,0x4
 840:	34fd                	addiw	s1,s1,-1
 842:	f4f5                	bnez	s1,82e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 844:	8bea                	mv	s7,s10
      state = 0;
 846:	4981                	li	s3,0
 848:	6d02                	ld	s10,0(sp)
 84a:	bd29                	j	664 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 84c:	008b8993          	addi	s3,s7,8
 850:	000bb483          	ld	s1,0(s7)
 854:	cc91                	beqz	s1,870 <vprintf+0x256>
        for(; *s; s++)
 856:	0004c583          	lbu	a1,0(s1)
 85a:	c195                	beqz	a1,87e <vprintf+0x264>
          putc(fd, *s);
 85c:	855a                	mv	a0,s6
 85e:	d09ff0ef          	jal	566 <putc>
        for(; *s; s++)
 862:	0485                	addi	s1,s1,1
 864:	0004c583          	lbu	a1,0(s1)
 868:	f9f5                	bnez	a1,85c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 86a:	8bce                	mv	s7,s3
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bbdd                	j	664 <vprintf+0x4a>
          s = "(null)";
 870:	00000497          	auipc	s1,0x0
 874:	43048493          	addi	s1,s1,1072 # ca0 <malloc+0x320>
        for(; *s; s++)
 878:	02800593          	li	a1,40
 87c:	b7c5                	j	85c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 87e:	8bce                	mv	s7,s3
      state = 0;
 880:	4981                	li	s3,0
 882:	b3cd                	j	664 <vprintf+0x4a>
 884:	6906                	ld	s2,64(sp)
 886:	79e2                	ld	s3,56(sp)
 888:	7a42                	ld	s4,48(sp)
 88a:	7aa2                	ld	s5,40(sp)
 88c:	7b02                	ld	s6,32(sp)
 88e:	6be2                	ld	s7,24(sp)
 890:	6c42                	ld	s8,16(sp)
 892:	6ca2                	ld	s9,8(sp)
    }
  }
}
 894:	60e6                	ld	ra,88(sp)
 896:	6446                	ld	s0,80(sp)
 898:	64a6                	ld	s1,72(sp)
 89a:	6125                	addi	sp,sp,96
 89c:	8082                	ret

000000000000089e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89e:	715d                	addi	sp,sp,-80
 8a0:	ec06                	sd	ra,24(sp)
 8a2:	e822                	sd	s0,16(sp)
 8a4:	1000                	addi	s0,sp,32
 8a6:	e010                	sd	a2,0(s0)
 8a8:	e414                	sd	a3,8(s0)
 8aa:	e818                	sd	a4,16(s0)
 8ac:	ec1c                	sd	a5,24(s0)
 8ae:	03043023          	sd	a6,32(s0)
 8b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b6:	8622                	mv	a2,s0
 8b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8bc:	d5fff0ef          	jal	61a <vprintf>
}
 8c0:	60e2                	ld	ra,24(sp)
 8c2:	6442                	ld	s0,16(sp)
 8c4:	6161                	addi	sp,sp,80
 8c6:	8082                	ret

00000000000008c8 <printf>:

void
printf(const char *fmt, ...)
{
 8c8:	711d                	addi	sp,sp,-96
 8ca:	ec06                	sd	ra,24(sp)
 8cc:	e822                	sd	s0,16(sp)
 8ce:	1000                	addi	s0,sp,32
 8d0:	e40c                	sd	a1,8(s0)
 8d2:	e810                	sd	a2,16(s0)
 8d4:	ec14                	sd	a3,24(s0)
 8d6:	f018                	sd	a4,32(s0)
 8d8:	f41c                	sd	a5,40(s0)
 8da:	03043823          	sd	a6,48(s0)
 8de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	00840613          	addi	a2,s0,8
 8e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ea:	85aa                	mv	a1,a0
 8ec:	4505                	li	a0,1
 8ee:	d2dff0ef          	jal	61a <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6125                	addi	sp,sp,96
 8f8:	8082                	ret

00000000000008fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fa:	1141                	addi	sp,sp,-16
 8fc:	e406                	sd	ra,8(sp)
 8fe:	e022                	sd	s0,0(sp)
 900:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 902:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	00001797          	auipc	a5,0x1
 90a:	6fa7b783          	ld	a5,1786(a5) # 2000 <freep>
 90e:	a02d                	j	938 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 910:	4618                	lw	a4,8(a2)
 912:	9f2d                	addw	a4,a4,a1
 914:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	6310                	ld	a2,0(a4)
 91c:	a83d                	j	95a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91e:	ff852703          	lw	a4,-8(a0)
 922:	9f31                	addw	a4,a4,a2
 924:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 926:	ff053683          	ld	a3,-16(a0)
 92a:	a091                	j	96e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	6398                	ld	a4,0(a5)
 92e:	00e7e463          	bltu	a5,a4,936 <free+0x3c>
 932:	00e6ea63          	bltu	a3,a4,946 <free+0x4c>
{
 936:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	fed7fae3          	bgeu	a5,a3,92c <free+0x32>
 93c:	6398                	ld	a4,0(a5)
 93e:	00e6e463          	bltu	a3,a4,946 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	fee7eae3          	bltu	a5,a4,936 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 946:	ff852583          	lw	a1,-8(a0)
 94a:	6390                	ld	a2,0(a5)
 94c:	02059813          	slli	a6,a1,0x20
 950:	01c85713          	srli	a4,a6,0x1c
 954:	9736                	add	a4,a4,a3
 956:	fae60de3          	beq	a2,a4,910 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 95a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95e:	4790                	lw	a2,8(a5)
 960:	02061593          	slli	a1,a2,0x20
 964:	01c5d713          	srli	a4,a1,0x1c
 968:	973e                	add	a4,a4,a5
 96a:	fae68ae3          	beq	a3,a4,91e <free+0x24>
    p->s.ptr = bp->s.ptr;
 96e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 970:	00001717          	auipc	a4,0x1
 974:	68f73823          	sd	a5,1680(a4) # 2000 <freep>
}
 978:	60a2                	ld	ra,8(sp)
 97a:	6402                	ld	s0,0(sp)
 97c:	0141                	addi	sp,sp,16
 97e:	8082                	ret

0000000000000980 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 980:	7139                	addi	sp,sp,-64
 982:	fc06                	sd	ra,56(sp)
 984:	f822                	sd	s0,48(sp)
 986:	f04a                	sd	s2,32(sp)
 988:	ec4e                	sd	s3,24(sp)
 98a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98c:	02051993          	slli	s3,a0,0x20
 990:	0209d993          	srli	s3,s3,0x20
 994:	09bd                	addi	s3,s3,15
 996:	0049d993          	srli	s3,s3,0x4
 99a:	2985                	addiw	s3,s3,1
 99c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 99e:	00001517          	auipc	a0,0x1
 9a2:	66253503          	ld	a0,1634(a0) # 2000 <freep>
 9a6:	c905                	beqz	a0,9d6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	09377663          	bgeu	a4,s3,a38 <malloc+0xb8>
 9b0:	f426                	sd	s1,40(sp)
 9b2:	e852                	sd	s4,16(sp)
 9b4:	e456                	sd	s5,8(sp)
 9b6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b8:	8a4e                	mv	s4,s3
 9ba:	6705                	lui	a4,0x1
 9bc:	00e9f363          	bgeu	s3,a4,9c2 <malloc+0x42>
 9c0:	6a05                	lui	s4,0x1
 9c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ca:	00001497          	auipc	s1,0x1
 9ce:	63648493          	addi	s1,s1,1590 # 2000 <freep>
  if(p == (char*)-1)
 9d2:	5afd                	li	s5,-1
 9d4:	a83d                	j	a12 <malloc+0x92>
 9d6:	f426                	sd	s1,40(sp)
 9d8:	e852                	sd	s4,16(sp)
 9da:	e456                	sd	s5,8(sp)
 9dc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9de:	00001797          	auipc	a5,0x1
 9e2:	63278793          	addi	a5,a5,1586 # 2010 <base>
 9e6:	00001717          	auipc	a4,0x1
 9ea:	60f73d23          	sd	a5,1562(a4) # 2000 <freep>
 9ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f4:	b7d1                	j	9b8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9f6:	6398                	ld	a4,0(a5)
 9f8:	e118                	sd	a4,0(a0)
 9fa:	a899                	j	a50 <malloc+0xd0>
  hp->s.size = nu;
 9fc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a00:	0541                	addi	a0,a0,16
 a02:	ef9ff0ef          	jal	8fa <free>
  return freep;
 a06:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a08:	c125                	beqz	a0,a68 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	03277163          	bgeu	a4,s2,a30 <malloc+0xb0>
    if(p == freep)
 a12:	6098                	ld	a4,0(s1)
 a14:	853e                	mv	a0,a5
 a16:	fef71ae3          	bne	a4,a5,a0a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a1a:	8552                	mv	a0,s4
 a1c:	aebff0ef          	jal	506 <sbrk>
  if(p == (char*)-1)
 a20:	fd551ee3          	bne	a0,s5,9fc <malloc+0x7c>
        return 0;
 a24:	4501                	li	a0,0
 a26:	74a2                	ld	s1,40(sp)
 a28:	6a42                	ld	s4,16(sp)
 a2a:	6aa2                	ld	s5,8(sp)
 a2c:	6b02                	ld	s6,0(sp)
 a2e:	a03d                	j	a5c <malloc+0xdc>
 a30:	74a2                	ld	s1,40(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a38:	fae90fe3          	beq	s2,a4,9f6 <malloc+0x76>
        p->s.size -= nunits;
 a3c:	4137073b          	subw	a4,a4,s3
 a40:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a42:	02071693          	slli	a3,a4,0x20
 a46:	01c6d713          	srli	a4,a3,0x1c
 a4a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a50:	00001717          	auipc	a4,0x1
 a54:	5aa73823          	sd	a0,1456(a4) # 2000 <freep>
      return (void*)(p + 1);
 a58:	01078513          	addi	a0,a5,16
  }
}
 a5c:	70e2                	ld	ra,56(sp)
 a5e:	7442                	ld	s0,48(sp)
 a60:	7902                	ld	s2,32(sp)
 a62:	69e2                	ld	s3,24(sp)
 a64:	6121                	addi	sp,sp,64
 a66:	8082                	ret
 a68:	74a2                	ld	s1,40(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	b7f5                	j	a5c <malloc+0xdc>
