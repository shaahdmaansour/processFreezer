
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
  12:	45c000ef          	jal	46e <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	8626                	mv	a2,s1
  18:	85ca                	mv	a1,s2
  1a:	00001517          	auipc	a0,0x1
  1e:	9f650513          	addi	a0,a0,-1546 # a10 <malloc+0xfa>
  22:	03d000ef          	jal	85e <printf>
}
  26:	60e2                	ld	ra,24(sp)
  28:	6442                	ld	s0,16(sp)
  2a:	64a2                	ld	s1,8(sp)
  2c:	6902                	ld	s2,0(sp)
  2e:	6105                	addi	sp,sp,32
  30:	8082                	ret

0000000000000032 <main>:

int
main(int argc, char *argv[])
{
  32:	7179                	addi	sp,sp,-48
  34:	f406                	sd	ra,40(sp)
  36:	f022                	sd	s0,32(sp)
  38:	1800                	addi	s0,sp,48
  int child_pid = fork();
  3a:	3d4000ef          	jal	40e <fork>
  
  if(child_pid < 0){
  3e:	02054f63          	bltz	a0,7c <main+0x4a>
  42:	ec26                	sd	s1,24(sp)
  44:	84aa                	mv	s1,a0
    printf("fork failed\n");
    exit(1);
  }
  
  if(child_pid == 0){
  46:	e539                	bnez	a0,94 <main+0x62>
  48:	e84a                	sd	s2,16(sp)
  4a:	e44e                	sd	s3,8(sp)
    // Child process
    int mypid = getpid();
  4c:	412000ef          	jal	45e <getpid>
  50:	84aa                	mv	s1,a0
    printf("Child process started (PID: %d)\n", mypid);
  52:	85aa                	mv	a1,a0
  54:	00001517          	auipc	a0,0x1
  58:	9dc50513          	addi	a0,a0,-1572 # a30 <malloc+0x11a>
  5c:	003000ef          	jal	85e <printf>
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
  60:	00001997          	auipc	s3,0x1
  64:	9f898993          	addi	s3,s3,-1544 # a58 <malloc+0x142>
      sleep(100);
  68:	06400913          	li	s2,100
      print_status(mypid, "running");
  6c:	85ce                	mv	a1,s3
  6e:	8526                	mv	a0,s1
  70:	f91ff0ef          	jal	0 <print_status>
      sleep(100);
  74:	854a                	mv	a0,s2
  76:	3f8000ef          	jal	46e <sleep>
    while(1){
  7a:	bfcd                	j	6c <main+0x3a>
  7c:	ec26                	sd	s1,24(sp)
  7e:	e84a                	sd	s2,16(sp)
  80:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
  82:	00001517          	auipc	a0,0x1
  86:	99e50513          	addi	a0,a0,-1634 # a20 <malloc+0x10a>
  8a:	7d4000ef          	jal	85e <printf>
    exit(1);
  8e:	4505                	li	a0,1
  90:	386000ef          	jal	416 <exit>
    }
  } else {
    // Parent process
    int mypid = getpid();
  94:	3ca000ef          	jal	45e <getpid>
  98:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
  9a:	8626                	mv	a2,s1
  9c:	00001517          	auipc	a0,0x1
  a0:	9c450513          	addi	a0,a0,-1596 # a60 <malloc+0x14a>
  a4:	7ba000ef          	jal	85e <printf>
    
    // Wait for child to start and run for a bit
    sleep(300);
  a8:	12c00513          	li	a0,300
  ac:	3c2000ef          	jal	46e <sleep>
    
    // Try to freeze child
    printf("\nAttempting to freeze child process %d...\n", child_pid);
  b0:	85a6                	mv	a1,s1
  b2:	00001517          	auipc	a0,0x1
  b6:	9e650513          	addi	a0,a0,-1562 # a98 <malloc+0x182>
  ba:	7a4000ef          	jal	85e <printf>
    int result = freeze(child_pid);
  be:	8526                	mv	a0,s1
  c0:	3f6000ef          	jal	4b6 <freeze>
    if(result < 0){
  c4:	06054d63          	bltz	a0,13e <main+0x10c>
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Frozen");
  c8:	00001597          	auipc	a1,0x1
  cc:	a3858593          	addi	a1,a1,-1480 # b00 <malloc+0x1ea>
  d0:	8526                	mv	a0,s1
  d2:	f2fff0ef          	jal	0 <print_status>
    
    // Keep frozen for a while
    sleep(300);
  d6:	12c00513          	li	a0,300
  da:	394000ef          	jal	46e <sleep>
    
    // Try to unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
  de:	85a6                	mv	a1,s1
  e0:	00001517          	auipc	a0,0x1
  e4:	a2850513          	addi	a0,a0,-1496 # b08 <malloc+0x1f2>
  e8:	776000ef          	jal	85e <printf>
    result = unfreeze(child_pid);
  ec:	8526                	mv	a0,s1
  ee:	3d0000ef          	jal	4be <unfreeze>
    if(result < 0){
  f2:	06054963          	bltz	a0,164 <main+0x132>
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Unfrozen");
  fa:	00001597          	auipc	a1,0x1
  fe:	a7658593          	addi	a1,a1,-1418 # b70 <malloc+0x25a>
 102:	8526                	mv	a0,s1
 104:	efdff0ef          	jal	0 <print_status>
    
    // Let it run for a while
    sleep(300);
 108:	12c00513          	li	a0,300
 10c:	362000ef          	jal	46e <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 110:	85a6                	mv	a1,s1
 112:	00001517          	auipc	a0,0x1
 116:	a6e50513          	addi	a0,a0,-1426 # b80 <malloc+0x26a>
 11a:	744000ef          	jal	85e <printf>
    kill(child_pid);
 11e:	8526                	mv	a0,s1
 120:	316000ef          	jal	436 <kill>
    wait(0);
 124:	4501                	li	a0,0
 126:	2f8000ef          	jal	41e <wait>
    print_status(child_pid, "Terminated");
 12a:	00001597          	auipc	a1,0x1
 12e:	a7e58593          	addi	a1,a1,-1410 # ba8 <malloc+0x292>
 132:	8526                	mv	a0,s1
 134:	ecdff0ef          	jal	0 <print_status>
  }
  
  exit(0);
 138:	4501                	li	a0,0
 13a:	2dc000ef          	jal	416 <exit>
 13e:	e84a                	sd	s2,16(sp)
 140:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
 142:	862a                	mv	a2,a0
 144:	85a6                	mv	a1,s1
 146:	00001517          	auipc	a0,0x1
 14a:	98250513          	addi	a0,a0,-1662 # ac8 <malloc+0x1b2>
 14e:	710000ef          	jal	85e <printf>
      kill(child_pid);
 152:	8526                	mv	a0,s1
 154:	2e2000ef          	jal	436 <kill>
      wait(0);
 158:	4501                	li	a0,0
 15a:	2c4000ef          	jal	41e <wait>
      exit(1);
 15e:	4505                	li	a0,1
 160:	2b6000ef          	jal	416 <exit>
 164:	e84a                	sd	s2,16(sp)
 166:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
 168:	862a                	mv	a2,a0
 16a:	85a6                	mv	a1,s1
 16c:	00001517          	auipc	a0,0x1
 170:	9cc50513          	addi	a0,a0,-1588 # b38 <malloc+0x222>
 174:	6ea000ef          	jal	85e <printf>
      kill(child_pid);
 178:	8526                	mv	a0,s1
 17a:	2bc000ef          	jal	436 <kill>
      wait(0);
 17e:	4501                	li	a0,0
 180:	29e000ef          	jal	41e <wait>
      exit(1);
 184:	4505                	li	a0,1
 186:	290000ef          	jal	416 <exit>

000000000000018a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	ea1ff0ef          	jal	32 <main>
  exit(0);
 196:	4501                	li	a0,0
 198:	27e000ef          	jal	416 <exit>

000000000000019c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a4:	87aa                	mv	a5,a0
 1a6:	0585                	addi	a1,a1,1
 1a8:	0785                	addi	a5,a5,1
 1aa:	fff5c703          	lbu	a4,-1(a1)
 1ae:	fee78fa3          	sb	a4,-1(a5)
 1b2:	fb75                	bnez	a4,1a6 <strcpy+0xa>
    ;
  return os;
}
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cb91                	beqz	a5,1dc <strcmp+0x20>
 1ca:	0005c703          	lbu	a4,0(a1)
 1ce:	00f71763          	bne	a4,a5,1dc <strcmp+0x20>
    p++, q++;
 1d2:	0505                	addi	a0,a0,1
 1d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	fbe5                	bnez	a5,1ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1dc:	0005c503          	lbu	a0,0(a1)
}
 1e0:	40a7853b          	subw	a0,a5,a0
 1e4:	60a2                	ld	ra,8(sp)
 1e6:	6402                	ld	s0,0(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strlen>:

uint
strlen(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf91                	beqz	a5,214 <strlen+0x28>
 1fa:	00150793          	addi	a5,a0,1
 1fe:	86be                	mv	a3,a5
 200:	0785                	addi	a5,a5,1
 202:	fff7c703          	lbu	a4,-1(a5)
 206:	ff65                	bnez	a4,1fe <strlen+0x12>
 208:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 20c:	60a2                	ld	ra,8(sp)
 20e:	6402                	ld	s0,0(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  for(n = 0; s[n]; n++)
 214:	4501                	li	a0,0
 216:	bfdd                	j	20c <strlen+0x20>

0000000000000218 <memset>:

void*
memset(void *dst, int c, uint n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 220:	ca19                	beqz	a2,236 <memset+0x1e>
 222:	87aa                	mv	a5,a0
 224:	1602                	slli	a2,a2,0x20
 226:	9201                	srli	a2,a2,0x20
 228:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 230:	0785                	addi	a5,a5,1
 232:	fee79de3          	bne	a5,a4,22c <memset+0x14>
  }
  return dst;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  for(; *s; s++)
 246:	00054783          	lbu	a5,0(a0)
 24a:	cf81                	beqz	a5,262 <strchr+0x24>
    if(*s == c)
 24c:	00f58763          	beq	a1,a5,25a <strchr+0x1c>
  for(; *s; s++)
 250:	0505                	addi	a0,a0,1
 252:	00054783          	lbu	a5,0(a0)
 256:	fbfd                	bnez	a5,24c <strchr+0xe>
      return (char*)s;
  return 0;
 258:	4501                	li	a0,0
}
 25a:	60a2                	ld	ra,8(sp)
 25c:	6402                	ld	s0,0(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  return 0;
 262:	4501                	li	a0,0
 264:	bfdd                	j	25a <strchr+0x1c>

0000000000000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	711d                	addi	sp,sp,-96
 268:	ec86                	sd	ra,88(sp)
 26a:	e8a2                	sd	s0,80(sp)
 26c:	e4a6                	sd	s1,72(sp)
 26e:	e0ca                	sd	s2,64(sp)
 270:	fc4e                	sd	s3,56(sp)
 272:	f852                	sd	s4,48(sp)
 274:	f456                	sd	s5,40(sp)
 276:	f05a                	sd	s6,32(sp)
 278:	ec5e                	sd	s7,24(sp)
 27a:	e862                	sd	s8,16(sp)
 27c:	1080                	addi	s0,sp,96
 27e:	8baa                	mv	s7,a0
 280:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 282:	892a                	mv	s2,a0
 284:	4481                	li	s1,0
    cc = read(0, &c, 1);
 286:	faf40b13          	addi	s6,s0,-81
 28a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 28c:	8c26                	mv	s8,s1
 28e:	0014899b          	addiw	s3,s1,1
 292:	84ce                	mv	s1,s3
 294:	0349d463          	bge	s3,s4,2bc <gets+0x56>
    cc = read(0, &c, 1);
 298:	8656                	mv	a2,s5
 29a:	85da                	mv	a1,s6
 29c:	4501                	li	a0,0
 29e:	190000ef          	jal	42e <read>
    if(cc < 1)
 2a2:	00a05d63          	blez	a0,2bc <gets+0x56>
      break;
    buf[i++] = c;
 2a6:	faf44783          	lbu	a5,-81(s0)
 2aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ae:	0905                	addi	s2,s2,1
 2b0:	ff678713          	addi	a4,a5,-10
 2b4:	c319                	beqz	a4,2ba <gets+0x54>
 2b6:	17cd                	addi	a5,a5,-13
 2b8:	fbf1                	bnez	a5,28c <gets+0x26>
    buf[i++] = c;
 2ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2bc:	9c5e                	add	s8,s8,s7
 2be:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2c2:	855e                	mv	a0,s7
 2c4:	60e6                	ld	ra,88(sp)
 2c6:	6446                	ld	s0,80(sp)
 2c8:	64a6                	ld	s1,72(sp)
 2ca:	6906                	ld	s2,64(sp)
 2cc:	79e2                	ld	s3,56(sp)
 2ce:	7a42                	ld	s4,48(sp)
 2d0:	7aa2                	ld	s5,40(sp)
 2d2:	7b02                	ld	s6,32(sp)
 2d4:	6be2                	ld	s7,24(sp)
 2d6:	6c42                	ld	s8,16(sp)
 2d8:	6125                	addi	sp,sp,96
 2da:	8082                	ret

00000000000002dc <stat>:

int
stat(const char *n, struct stat *st)
{
 2dc:	1101                	addi	sp,sp,-32
 2de:	ec06                	sd	ra,24(sp)
 2e0:	e822                	sd	s0,16(sp)
 2e2:	e04a                	sd	s2,0(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e8:	4581                	li	a1,0
 2ea:	194000ef          	jal	47e <open>
  if(fd < 0)
 2ee:	02054263          	bltz	a0,312 <stat+0x36>
 2f2:	e426                	sd	s1,8(sp)
 2f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f6:	85ca                	mv	a1,s2
 2f8:	14e000ef          	jal	446 <fstat>
 2fc:	892a                	mv	s2,a0
  close(fd);
 2fe:	8526                	mv	a0,s1
 300:	1ae000ef          	jal	4ae <close>
  return r;
 304:	64a2                	ld	s1,8(sp)
}
 306:	854a                	mv	a0,s2
 308:	60e2                	ld	ra,24(sp)
 30a:	6442                	ld	s0,16(sp)
 30c:	6902                	ld	s2,0(sp)
 30e:	6105                	addi	sp,sp,32
 310:	8082                	ret
    return -1;
 312:	57fd                	li	a5,-1
 314:	893e                	mv	s2,a5
 316:	bfc5                	j	306 <stat+0x2a>

0000000000000318 <atoi>:

int
atoi(const char *s)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 320:	00054683          	lbu	a3,0(a0)
 324:	fd06879b          	addiw	a5,a3,-48
 328:	0ff7f793          	zext.b	a5,a5
 32c:	4625                	li	a2,9
 32e:	02f66963          	bltu	a2,a5,360 <atoi+0x48>
 332:	872a                	mv	a4,a0
  n = 0;
 334:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 336:	0705                	addi	a4,a4,1
 338:	0025179b          	slliw	a5,a0,0x2
 33c:	9fa9                	addw	a5,a5,a0
 33e:	0017979b          	slliw	a5,a5,0x1
 342:	9fb5                	addw	a5,a5,a3
 344:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 348:	00074683          	lbu	a3,0(a4)
 34c:	fd06879b          	addiw	a5,a3,-48
 350:	0ff7f793          	zext.b	a5,a5
 354:	fef671e3          	bgeu	a2,a5,336 <atoi+0x1e>
  return n;
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfdd                	j	358 <atoi+0x40>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36c:	02b57563          	bgeu	a0,a1,396 <memmove+0x32>
    while(n-- > 0)
 370:	00c05f63          	blez	a2,38e <memmove+0x2a>
 374:	1602                	slli	a2,a2,0x20
 376:	9201                	srli	a2,a2,0x20
 378:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37c:	872a                	mv	a4,a0
      *dst++ = *src++;
 37e:	0585                	addi	a1,a1,1
 380:	0705                	addi	a4,a4,1
 382:	fff5c683          	lbu	a3,-1(a1)
 386:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38a:	fee79ae3          	bne	a5,a4,37e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
    while(n-- > 0)
 396:	fec05ce3          	blez	a2,38e <memmove+0x2a>
    dst += n;
 39a:	00c50733          	add	a4,a0,a2
    src += n;
 39e:	95b2                	add	a1,a1,a2
 3a0:	fff6079b          	addiw	a5,a2,-1
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	fff7c793          	not	a5,a5
 3ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ae:	15fd                	addi	a1,a1,-1
 3b0:	177d                	addi	a4,a4,-1
 3b2:	0005c683          	lbu	a3,0(a1)
 3b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ba:	fef71ae3          	bne	a4,a5,3ae <memmove+0x4a>
 3be:	bfc1                	j	38e <memmove+0x2a>

00000000000003c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c8:	c61d                	beqz	a2,3f6 <memcmp+0x36>
 3ca:	1602                	slli	a2,a2,0x20
 3cc:	9201                	srli	a2,a2,0x20
 3ce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3d2:	00054783          	lbu	a5,0(a0)
 3d6:	0005c703          	lbu	a4,0(a1)
 3da:	00e79863          	bne	a5,a4,3ea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3de:	0505                	addi	a0,a0,1
    p2++;
 3e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e2:	fed518e3          	bne	a0,a3,3d2 <memcmp+0x12>
  }
  return 0;
 3e6:	4501                	li	a0,0
 3e8:	a019                	j	3ee <memcmp+0x2e>
      return *p1 - *p2;
 3ea:	40e7853b          	subw	a0,a5,a4
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  return 0;
 3f6:	4501                	li	a0,0
 3f8:	bfdd                	j	3ee <memcmp+0x2e>

00000000000003fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e406                	sd	ra,8(sp)
 3fe:	e022                	sd	s0,0(sp)
 400:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 402:	f63ff0ef          	jal	364 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40e:	4885                	li	a7,1
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exit>:
.global exit
exit:
 li a7, SYS_exit
 416:	4889                	li	a7,2
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <wait>:
.global wait
wait:
 li a7, SYS_wait
 41e:	488d                	li	a7,3
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 426:	4891                	li	a7,4
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <read>:
.global read
read:
 li a7, SYS_read
 42e:	4895                	li	a7,5
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <kill>:
.global kill
kill:
 li a7, SYS_kill
 436:	4899                	li	a7,6
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <exec>:
.global exec
exec:
 li a7, SYS_exec
 43e:	489d                	li	a7,7
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 446:	48a1                	li	a7,8
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44e:	48a5                	li	a7,9
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <dup>:
.global dup
dup:
 li a7, SYS_dup
 456:	48a9                	li	a7,10
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45e:	48ad                	li	a7,11
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 466:	48b1                	li	a7,12
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46e:	48b5                	li	a7,13
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 476:	48b9                	li	a7,14
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <open>:
.global open
open:
 li a7, SYS_open
 47e:	48bd                	li	a7,15
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <write>:
.global write
write:
 li a7, SYS_write
 486:	48c1                	li	a7,16
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48e:	48c5                	li	a7,17
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 496:	48c9                	li	a7,18
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <link>:
.global link
link:
 li a7, SYS_link
 49e:	48cd                	li	a7,19
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a6:	48d1                	li	a7,20
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <close>:
.global close
close:
 li a7, SYS_close
 4ae:	48d5                	li	a7,21
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 4be:	48dd                	li	a7,23
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 4c6:	48e1                	li	a7,24
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4da:	4605                	li	a2,1
 4dc:	fef40593          	addi	a1,s0,-17
 4e0:	fa7ff0ef          	jal	486 <write>
}
 4e4:	60e2                	ld	ra,24(sp)
 4e6:	6442                	ld	s0,16(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret

00000000000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	7139                	addi	sp,sp,-64
 4ee:	fc06                	sd	ra,56(sp)
 4f0:	f822                	sd	s0,48(sp)
 4f2:	f04a                	sd	s2,32(sp)
 4f4:	ec4e                	sd	s3,24(sp)
 4f6:	0080                	addi	s0,sp,64
 4f8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fa:	cac9                	beqz	a3,58c <printint+0xa0>
 4fc:	01f5d79b          	srliw	a5,a1,0x1f
 500:	c7d1                	beqz	a5,58c <printint+0xa0>
    neg = 1;
    x = -xx;
 502:	40b005bb          	negw	a1,a1
    neg = 1;
 506:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 508:	fc040993          	addi	s3,s0,-64
  neg = 0;
 50c:	86ce                	mv	a3,s3
  i = 0;
 50e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 510:	00000817          	auipc	a6,0x0
 514:	6b080813          	addi	a6,a6,1712 # bc0 <digits>
 518:	88ba                	mv	a7,a4
 51a:	0017051b          	addiw	a0,a4,1
 51e:	872a                	mv	a4,a0
 520:	02c5f7bb          	remuw	a5,a1,a2
 524:	1782                	slli	a5,a5,0x20
 526:	9381                	srli	a5,a5,0x20
 528:	97c2                	add	a5,a5,a6
 52a:	0007c783          	lbu	a5,0(a5)
 52e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 532:	87ae                	mv	a5,a1
 534:	02c5d5bb          	divuw	a1,a1,a2
 538:	0685                	addi	a3,a3,1
 53a:	fcc7ffe3          	bgeu	a5,a2,518 <printint+0x2c>
  if(neg)
 53e:	00030c63          	beqz	t1,556 <printint+0x6a>
    buf[i++] = '-';
 542:	fd050793          	addi	a5,a0,-48
 546:	00878533          	add	a0,a5,s0
 54a:	02d00793          	li	a5,45
 54e:	fef50823          	sb	a5,-16(a0)
 552:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 556:	02e05563          	blez	a4,580 <printint+0x94>
 55a:	f426                	sd	s1,40(sp)
 55c:	377d                	addiw	a4,a4,-1
 55e:	00e984b3          	add	s1,s3,a4
 562:	19fd                	addi	s3,s3,-1
 564:	99ba                	add	s3,s3,a4
 566:	1702                	slli	a4,a4,0x20
 568:	9301                	srli	a4,a4,0x20
 56a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56e:	0004c583          	lbu	a1,0(s1)
 572:	854a                	mv	a0,s2
 574:	f5bff0ef          	jal	4ce <putc>
  while(--i >= 0)
 578:	14fd                	addi	s1,s1,-1
 57a:	ff349ae3          	bne	s1,s3,56e <printint+0x82>
 57e:	74a2                	ld	s1,40(sp)
}
 580:	70e2                	ld	ra,56(sp)
 582:	7442                	ld	s0,48(sp)
 584:	7902                	ld	s2,32(sp)
 586:	69e2                	ld	s3,24(sp)
 588:	6121                	addi	sp,sp,64
 58a:	8082                	ret
  neg = 0;
 58c:	4301                	li	t1,0
 58e:	bfad                	j	508 <printint+0x1c>

0000000000000590 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 590:	711d                	addi	sp,sp,-96
 592:	ec86                	sd	ra,88(sp)
 594:	e8a2                	sd	s0,80(sp)
 596:	e4a6                	sd	s1,72(sp)
 598:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59a:	0005c483          	lbu	s1,0(a1)
 59e:	20048963          	beqz	s1,7b0 <vprintf+0x220>
 5a2:	e0ca                	sd	s2,64(sp)
 5a4:	fc4e                	sd	s3,56(sp)
 5a6:	f852                	sd	s4,48(sp)
 5a8:	f456                	sd	s5,40(sp)
 5aa:	f05a                	sd	s6,32(sp)
 5ac:	ec5e                	sd	s7,24(sp)
 5ae:	e862                	sd	s8,16(sp)
 5b0:	8b2a                	mv	s6,a0
 5b2:	8a2e                	mv	s4,a1
 5b4:	8bb2                	mv	s7,a2
  state = 0;
 5b6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5b8:	4901                	li	s2,0
 5ba:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c0:	06400c13          	li	s8,100
 5c4:	a00d                	j	5e6 <vprintf+0x56>
        putc(fd, c0);
 5c6:	85a6                	mv	a1,s1
 5c8:	855a                	mv	a0,s6
 5ca:	f05ff0ef          	jal	4ce <putc>
 5ce:	a019                	j	5d4 <vprintf+0x44>
    } else if(state == '%'){
 5d0:	03598363          	beq	s3,s5,5f6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5d4:	0019079b          	addiw	a5,s2,1
 5d8:	893e                	mv	s2,a5
 5da:	873e                	mv	a4,a5
 5dc:	97d2                	add	a5,a5,s4
 5de:	0007c483          	lbu	s1,0(a5)
 5e2:	1c048063          	beqz	s1,7a2 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 5e6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5ea:	fe0993e3          	bnez	s3,5d0 <vprintf+0x40>
      if(c0 == '%'){
 5ee:	fd579ce3          	bne	a5,s5,5c6 <vprintf+0x36>
        state = '%';
 5f2:	89be                	mv	s3,a5
 5f4:	b7c5                	j	5d4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f6:	00ea06b3          	add	a3,s4,a4
 5fa:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5fe:	1a060e63          	beqz	a2,7ba <vprintf+0x22a>
      if(c0 == 'd'){
 602:	03878763          	beq	a5,s8,630 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 606:	f9478693          	addi	a3,a5,-108
 60a:	0016b693          	seqz	a3,a3
 60e:	f9c60593          	addi	a1,a2,-100
 612:	e99d                	bnez	a1,648 <vprintf+0xb8>
 614:	ca95                	beqz	a3,648 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	008b8493          	addi	s1,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	ec9ff0ef          	jal	4ec <printint>
        i += 1;
 628:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b75d                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 630:	008b8493          	addi	s1,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	eafff0ef          	jal	4ec <printint>
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	b779                	j	5d4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 648:	9752                	add	a4,a4,s4
 64a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64e:	f9460713          	addi	a4,a2,-108
 652:	00173713          	seqz	a4,a4
 656:	8f75                	and	a4,a4,a3
 658:	f9c58513          	addi	a0,a1,-100
 65c:	16051963          	bnez	a0,7ce <vprintf+0x23e>
 660:	16070763          	beqz	a4,7ce <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	008b8493          	addi	s1,s7,8
 668:	4685                	li	a3,1
 66a:	4629                	li	a2,10
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e7bff0ef          	jal	4ec <printint>
        i += 2;
 676:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	bfa1                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e61ff0ef          	jal	4ec <printint>
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
 694:	b781                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e49ff0ef          	jal	4ec <printint>
        i += 1;
 6a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b71d                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	e2fff0ef          	jal	4ec <printint>
        i += 2;
 6c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	b731                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 6ca:	008b8493          	addi	s1,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	e15ff0ef          	jal	4ec <printint>
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bdd5                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	dfdff0ef          	jal	4ec <printint>
        i += 1;
 6f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bde9                	j	5d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	008b8493          	addi	s1,s7,8
 700:	4681                	li	a3,0
 702:	4641                	li	a2,16
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	de3ff0ef          	jal	4ec <printint>
        i += 2;
 70e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	8ba6                	mv	s7,s1
      state = 0;
 712:	4981                	li	s3,0
        i += 2;
 714:	b5c1                	j	5d4 <vprintf+0x44>
 716:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 718:	008b8793          	addi	a5,s7,8
 71c:	8cbe                	mv	s9,a5
 71e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 722:	03000593          	li	a1,48
 726:	855a                	mv	a0,s6
 728:	da7ff0ef          	jal	4ce <putc>
  putc(fd, 'x');
 72c:	07800593          	li	a1,120
 730:	855a                	mv	a0,s6
 732:	d9dff0ef          	jal	4ce <putc>
 736:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 738:	00000b97          	auipc	s7,0x0
 73c:	488b8b93          	addi	s7,s7,1160 # bc0 <digits>
 740:	03c9d793          	srli	a5,s3,0x3c
 744:	97de                	add	a5,a5,s7
 746:	0007c583          	lbu	a1,0(a5)
 74a:	855a                	mv	a0,s6
 74c:	d83ff0ef          	jal	4ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 750:	0992                	slli	s3,s3,0x4
 752:	34fd                	addiw	s1,s1,-1
 754:	f4f5                	bnez	s1,740 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 756:	8be6                	mv	s7,s9
      state = 0;
 758:	4981                	li	s3,0
 75a:	6ca2                	ld	s9,8(sp)
 75c:	bda5                	j	5d4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 75e:	008b8993          	addi	s3,s7,8
 762:	000bb483          	ld	s1,0(s7)
 766:	cc91                	beqz	s1,782 <vprintf+0x1f2>
        for(; *s; s++)
 768:	0004c583          	lbu	a1,0(s1)
 76c:	c985                	beqz	a1,79c <vprintf+0x20c>
          putc(fd, *s);
 76e:	855a                	mv	a0,s6
 770:	d5fff0ef          	jal	4ce <putc>
        for(; *s; s++)
 774:	0485                	addi	s1,s1,1
 776:	0004c583          	lbu	a1,0(s1)
 77a:	f9f5                	bnez	a1,76e <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	bd91                	j	5d4 <vprintf+0x44>
          s = "(null)";
 782:	00000497          	auipc	s1,0x0
 786:	43648493          	addi	s1,s1,1078 # bb8 <malloc+0x2a2>
        for(; *s; s++)
 78a:	02800593          	li	a1,40
 78e:	b7c5                	j	76e <vprintf+0x1de>
        putc(fd, '%');
 790:	85be                	mv	a1,a5
 792:	855a                	mv	a0,s6
 794:	d3bff0ef          	jal	4ce <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	bd2d                	j	5d4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bd15                	j	5d4 <vprintf+0x44>
 7a2:	6906                	ld	s2,64(sp)
 7a4:	79e2                	ld	s3,56(sp)
 7a6:	7a42                	ld	s4,48(sp)
 7a8:	7aa2                	ld	s5,40(sp)
 7aa:	7b02                	ld	s6,32(sp)
 7ac:	6be2                	ld	s7,24(sp)
 7ae:	6c42                	ld	s8,16(sp)
    }
  }
}
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret
      if(c0 == 'd'){
 7ba:	06400713          	li	a4,100
 7be:	e6e789e3          	beq	a5,a4,630 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7c2:	f9478693          	addi	a3,a5,-108
 7c6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ca:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7cc:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7ce:	07500513          	li	a0,117
 7d2:	eaa786e3          	beq	a5,a0,67e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7d6:	f8b60513          	addi	a0,a2,-117
 7da:	e119                	bnez	a0,7e0 <vprintf+0x250>
 7dc:	ea069de3          	bnez	a3,696 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e0:	f8b58513          	addi	a0,a1,-117
 7e4:	e119                	bnez	a0,7ea <vprintf+0x25a>
 7e6:	ec0715e3          	bnez	a4,6b0 <vprintf+0x120>
      } else if(c0 == 'x'){
 7ea:	07800513          	li	a0,120
 7ee:	eca78ee3          	beq	a5,a0,6ca <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7f2:	f8860613          	addi	a2,a2,-120
 7f6:	e219                	bnez	a2,7fc <vprintf+0x26c>
 7f8:	ee0695e3          	bnez	a3,6e2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7fc:	f8858593          	addi	a1,a1,-120
 800:	e199                	bnez	a1,806 <vprintf+0x276>
 802:	ee071de3          	bnez	a4,6fc <vprintf+0x16c>
      } else if(c0 == 'p'){
 806:	07000713          	li	a4,112
 80a:	f0e786e3          	beq	a5,a4,716 <vprintf+0x186>
      } else if(c0 == 's'){
 80e:	07300713          	li	a4,115
 812:	f4e786e3          	beq	a5,a4,75e <vprintf+0x1ce>
      } else if(c0 == '%'){
 816:	02500713          	li	a4,37
 81a:	f6e78be3          	beq	a5,a4,790 <vprintf+0x200>
        putc(fd, '%');
 81e:	02500593          	li	a1,37
 822:	855a                	mv	a0,s6
 824:	cabff0ef          	jal	4ce <putc>
        putc(fd, c0);
 828:	85a6                	mv	a1,s1
 82a:	855a                	mv	a0,s6
 82c:	ca3ff0ef          	jal	4ce <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b34d                	j	5d4 <vprintf+0x44>

0000000000000834 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 834:	715d                	addi	sp,sp,-80
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e010                	sd	a2,0(s0)
 83e:	e414                	sd	a3,8(s0)
 840:	e818                	sd	a4,16(s0)
 842:	ec1c                	sd	a5,24(s0)
 844:	03043023          	sd	a6,32(s0)
 848:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84c:	8622                	mv	a2,s0
 84e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 852:	d3fff0ef          	jal	590 <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6161                	addi	sp,sp,80
 85c:	8082                	ret

000000000000085e <printf>:

void
printf(const char *fmt, ...)
{
 85e:	711d                	addi	sp,sp,-96
 860:	ec06                	sd	ra,24(sp)
 862:	e822                	sd	s0,16(sp)
 864:	1000                	addi	s0,sp,32
 866:	e40c                	sd	a1,8(s0)
 868:	e810                	sd	a2,16(s0)
 86a:	ec14                	sd	a3,24(s0)
 86c:	f018                	sd	a4,32(s0)
 86e:	f41c                	sd	a5,40(s0)
 870:	03043823          	sd	a6,48(s0)
 874:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 878:	00840613          	addi	a2,s0,8
 87c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 880:	85aa                	mv	a1,a0
 882:	4505                	li	a0,1
 884:	d0dff0ef          	jal	590 <vprintf>
}
 888:	60e2                	ld	ra,24(sp)
 88a:	6442                	ld	s0,16(sp)
 88c:	6125                	addi	sp,sp,96
 88e:	8082                	ret

0000000000000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	1141                	addi	sp,sp,-16
 892:	e406                	sd	ra,8(sp)
 894:	e022                	sd	s0,0(sp)
 896:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 898:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	00001797          	auipc	a5,0x1
 8a0:	7647b783          	ld	a5,1892(a5) # 2000 <freep>
 8a4:	a039                	j	8b2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e7e463          	bltu	a5,a4,8b0 <free+0x20>
 8ac:	00e6ea63          	bltu	a3,a4,8c0 <free+0x30>
{
 8b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	fed7fae3          	bgeu	a5,a3,8a6 <free+0x16>
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e6e463          	bltu	a3,a4,8c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	fee7eae3          	bltu	a5,a4,8b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c0:	ff852583          	lw	a1,-8(a0)
 8c4:	6390                	ld	a2,0(a5)
 8c6:	02059813          	slli	a6,a1,0x20
 8ca:	01c85713          	srli	a4,a6,0x1c
 8ce:	9736                	add	a4,a4,a3
 8d0:	02e60563          	beq	a2,a4,8fa <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8d8:	4790                	lw	a2,8(a5)
 8da:	02061593          	slli	a1,a2,0x20
 8de:	01c5d713          	srli	a4,a1,0x1c
 8e2:	973e                	add	a4,a4,a5
 8e4:	02e68263          	beq	a3,a4,908 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ea:	00001717          	auipc	a4,0x1
 8ee:	70f73b23          	sd	a5,1814(a4) # 2000 <freep>
}
 8f2:	60a2                	ld	ra,8(sp)
 8f4:	6402                	ld	s0,0(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8fa:	4618                	lw	a4,8(a2)
 8fc:	9f2d                	addw	a4,a4,a1
 8fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	6310                	ld	a2,0(a4)
 906:	b7f9                	j	8d4 <free+0x44>
    p->s.size += bp->s.size;
 908:	ff852703          	lw	a4,-8(a0)
 90c:	9f31                	addw	a4,a4,a2
 90e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 910:	ff053683          	ld	a3,-16(a0)
 914:	bfd1                	j	8e8 <free+0x58>

0000000000000916 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 916:	7139                	addi	sp,sp,-64
 918:	fc06                	sd	ra,56(sp)
 91a:	f822                	sd	s0,48(sp)
 91c:	f04a                	sd	s2,32(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 922:	02051993          	slli	s3,a0,0x20
 926:	0209d993          	srli	s3,s3,0x20
 92a:	09bd                	addi	s3,s3,15
 92c:	0049d993          	srli	s3,s3,0x4
 930:	2985                	addiw	s3,s3,1
 932:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 934:	00001517          	auipc	a0,0x1
 938:	6cc53503          	ld	a0,1740(a0) # 2000 <freep>
 93c:	c905                	beqz	a0,96c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	09377663          	bgeu	a4,s3,9ce <malloc+0xb8>
 946:	f426                	sd	s1,40(sp)
 948:	e852                	sd	s4,16(sp)
 94a:	e456                	sd	s5,8(sp)
 94c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94e:	8a4e                	mv	s4,s3
 950:	6705                	lui	a4,0x1
 952:	00e9f363          	bgeu	s3,a4,958 <malloc+0x42>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 960:	00001497          	auipc	s1,0x1
 964:	6a048493          	addi	s1,s1,1696 # 2000 <freep>
  if(p == (char*)-1)
 968:	5afd                	li	s5,-1
 96a:	a83d                	j	9a8 <malloc+0x92>
 96c:	f426                	sd	s1,40(sp)
 96e:	e852                	sd	s4,16(sp)
 970:	e456                	sd	s5,8(sp)
 972:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 974:	00001797          	auipc	a5,0x1
 978:	69c78793          	addi	a5,a5,1692 # 2010 <base>
 97c:	00001717          	auipc	a4,0x1
 980:	68f73223          	sd	a5,1668(a4) # 2000 <freep>
 984:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 986:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98a:	b7d1                	j	94e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 98c:	6398                	ld	a4,0(a5)
 98e:	e118                	sd	a4,0(a0)
 990:	a899                	j	9e6 <malloc+0xd0>
  hp->s.size = nu;
 992:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 996:	0541                	addi	a0,a0,16
 998:	ef9ff0ef          	jal	890 <free>
  return freep;
 99c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 99e:	c125                	beqz	a0,9fe <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a2:	4798                	lw	a4,8(a5)
 9a4:	03277163          	bgeu	a4,s2,9c6 <malloc+0xb0>
    if(p == freep)
 9a8:	6098                	ld	a4,0(s1)
 9aa:	853e                	mv	a0,a5
 9ac:	fef71ae3          	bne	a4,a5,9a0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9b0:	8552                	mv	a0,s4
 9b2:	ab5ff0ef          	jal	466 <sbrk>
  if(p == (char*)-1)
 9b6:	fd551ee3          	bne	a0,s5,992 <malloc+0x7c>
        return 0;
 9ba:	4501                	li	a0,0
 9bc:	74a2                	ld	s1,40(sp)
 9be:	6a42                	ld	s4,16(sp)
 9c0:	6aa2                	ld	s5,8(sp)
 9c2:	6b02                	ld	s6,0(sp)
 9c4:	a03d                	j	9f2 <malloc+0xdc>
 9c6:	74a2                	ld	s1,40(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9ce:	fae90fe3          	beq	s2,a4,98c <malloc+0x76>
        p->s.size -= nunits;
 9d2:	4137073b          	subw	a4,a4,s3
 9d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d8:	02071693          	slli	a3,a4,0x20
 9dc:	01c6d713          	srli	a4,a3,0x1c
 9e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e6:	00001717          	auipc	a4,0x1
 9ea:	60a73d23          	sd	a0,1562(a4) # 2000 <freep>
      return (void*)(p + 1);
 9ee:	01078513          	addi	a0,a5,16
  }
}
 9f2:	70e2                	ld	ra,56(sp)
 9f4:	7442                	ld	s0,48(sp)
 9f6:	7902                	ld	s2,32(sp)
 9f8:	69e2                	ld	s3,24(sp)
 9fa:	6121                	addi	sp,sp,64
 9fc:	8082                	ret
 9fe:	74a2                	ld	s1,40(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
 a06:	b7f5                	j	9f2 <malloc+0xdc>
