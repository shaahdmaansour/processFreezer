
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
  12:	46e000ef          	jal	480 <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	864a                	mv	a2,s2
  18:	85a6                	mv	a1,s1
  1a:	00001517          	auipc	a0,0x1
  1e:	9d650513          	addi	a0,a0,-1578 # 9f0 <malloc+0xfe>
  22:	019000ef          	jal	83a <printf>
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
  3a:	3e6000ef          	jal	420 <fork>
  
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
  4c:	424000ef          	jal	470 <getpid>
  50:	84aa                	mv	s1,a0
    printf("Child process started (PID: %d)\n", mypid);
  52:	85aa                	mv	a1,a0
  54:	00001517          	auipc	a0,0x1
  58:	9bc50513          	addi	a0,a0,-1604 # a10 <malloc+0x11e>
  5c:	7de000ef          	jal	83a <printf>
    
    // Child will print every 100 ticks
    while(1){
      print_status(mypid, "running");
  60:	00001997          	auipc	s3,0x1
  64:	9d898993          	addi	s3,s3,-1576 # a38 <malloc+0x146>
      sleep(100);
  68:	06400913          	li	s2,100
      print_status(mypid, "running");
  6c:	85ce                	mv	a1,s3
  6e:	8526                	mv	a0,s1
  70:	f91ff0ef          	jal	0 <print_status>
      sleep(100);
  74:	854a                	mv	a0,s2
  76:	40a000ef          	jal	480 <sleep>
    while(1){
  7a:	bfcd                	j	6c <main+0x3a>
  7c:	ec26                	sd	s1,24(sp)
  7e:	e84a                	sd	s2,16(sp)
  80:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
  82:	00001517          	auipc	a0,0x1
  86:	97e50513          	addi	a0,a0,-1666 # a00 <malloc+0x10e>
  8a:	7b0000ef          	jal	83a <printf>
    exit(1);
  8e:	4505                	li	a0,1
  90:	398000ef          	jal	428 <exit>
    }
  } else {
    // Parent process
    int mypid = getpid();
  94:	3dc000ef          	jal	470 <getpid>
  98:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
  9a:	8626                	mv	a2,s1
  9c:	00001517          	auipc	a0,0x1
  a0:	9a450513          	addi	a0,a0,-1628 # a40 <malloc+0x14e>
  a4:	796000ef          	jal	83a <printf>
    
    // Wait for child to start and run for a bit
    sleep(300);
  a8:	12c00513          	li	a0,300
  ac:	3d4000ef          	jal	480 <sleep>
    
    // Try to freeze child
    printf("\nAttempting to freeze child process %d...\n", child_pid);
  b0:	85a6                	mv	a1,s1
  b2:	00001517          	auipc	a0,0x1
  b6:	9c650513          	addi	a0,a0,-1594 # a78 <malloc+0x186>
  ba:	780000ef          	jal	83a <printf>
    int result = freeze(child_pid);
  be:	8526                	mv	a0,s1
  c0:	408000ef          	jal	4c8 <freeze>
    if(result < 0){
  c4:	06054d63          	bltz	a0,13e <main+0x10c>
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
      kill(child_pid);
      wait(0);
      exit(1);
    }
    print_status(child_pid, "Frozen");
  c8:	00001597          	auipc	a1,0x1
  cc:	a1858593          	addi	a1,a1,-1512 # ae0 <malloc+0x1ee>
  d0:	8526                	mv	a0,s1
  d2:	f2fff0ef          	jal	0 <print_status>
    
    // Keep frozen for a while
    sleep(300);
  d6:	12c00513          	li	a0,300
  da:	3a6000ef          	jal	480 <sleep>
    
    // Try to unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
  de:	85a6                	mv	a1,s1
  e0:	00001517          	auipc	a0,0x1
  e4:	a0850513          	addi	a0,a0,-1528 # ae8 <malloc+0x1f6>
  e8:	752000ef          	jal	83a <printf>
    result = unfreeze(child_pid);
  ec:	8526                	mv	a0,s1
  ee:	3e2000ef          	jal	4d0 <unfreeze>
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
  fe:	a5658593          	addi	a1,a1,-1450 # b50 <malloc+0x25e>
 102:	8526                	mv	a0,s1
 104:	efdff0ef          	jal	0 <print_status>
    
    // Let it run for a while
    sleep(300);
 108:	12c00513          	li	a0,300
 10c:	374000ef          	jal	480 <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 110:	85a6                	mv	a1,s1
 112:	00001517          	auipc	a0,0x1
 116:	a4e50513          	addi	a0,a0,-1458 # b60 <malloc+0x26e>
 11a:	720000ef          	jal	83a <printf>
    kill(child_pid);
 11e:	8526                	mv	a0,s1
 120:	328000ef          	jal	448 <kill>
    wait(0);
 124:	4501                	li	a0,0
 126:	30a000ef          	jal	430 <wait>
    print_status(child_pid, "Terminated");
 12a:	00001597          	auipc	a1,0x1
 12e:	a5e58593          	addi	a1,a1,-1442 # b88 <malloc+0x296>
 132:	8526                	mv	a0,s1
 134:	ecdff0ef          	jal	0 <print_status>
  }
  
  exit(0);
 138:	4501                	li	a0,0
 13a:	2ee000ef          	jal	428 <exit>
 13e:	e84a                	sd	s2,16(sp)
 140:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to freeze process %d (error code: %d)\n", child_pid, result);
 142:	862a                	mv	a2,a0
 144:	85a6                	mv	a1,s1
 146:	00001517          	auipc	a0,0x1
 14a:	96250513          	addi	a0,a0,-1694 # aa8 <malloc+0x1b6>
 14e:	6ec000ef          	jal	83a <printf>
      kill(child_pid);
 152:	8526                	mv	a0,s1
 154:	2f4000ef          	jal	448 <kill>
      wait(0);
 158:	4501                	li	a0,0
 15a:	2d6000ef          	jal	430 <wait>
      exit(1);
 15e:	4505                	li	a0,1
 160:	2c8000ef          	jal	428 <exit>
 164:	e84a                	sd	s2,16(sp)
 166:	e44e                	sd	s3,8(sp)
      printf("Error: Failed to unfreeze process %d (error code: %d)\n", child_pid, result);
 168:	862a                	mv	a2,a0
 16a:	85a6                	mv	a1,s1
 16c:	00001517          	auipc	a0,0x1
 170:	9ac50513          	addi	a0,a0,-1620 # b18 <malloc+0x226>
 174:	6c6000ef          	jal	83a <printf>
      kill(child_pid);
 178:	8526                	mv	a0,s1
 17a:	2ce000ef          	jal	448 <kill>
      wait(0);
 17e:	4501                	li	a0,0
 180:	2b0000ef          	jal	430 <wait>
      exit(1);
 184:	4505                	li	a0,1
 186:	2a2000ef          	jal	428 <exit>

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
 198:	290000ef          	jal	428 <exit>

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
 1f8:	cf99                	beqz	a5,216 <strlen+0x2a>
 1fa:	0505                	addi	a0,a0,1
 1fc:	87aa                	mv	a5,a0
 1fe:	86be                	mv	a3,a5
 200:	0785                	addi	a5,a5,1
 202:	fff7c703          	lbu	a4,-1(a5)
 206:	ff65                	bnez	a4,1fe <strlen+0x12>
 208:	40a6853b          	subw	a0,a3,a0
 20c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 20e:	60a2                	ld	ra,8(sp)
 210:	6402                	ld	s0,0(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  for(n = 0; s[n]; n++)
 216:	4501                	li	a0,0
 218:	bfdd                	j	20e <strlen+0x22>

000000000000021a <memset>:

void*
memset(void *dst, int c, uint n)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e406                	sd	ra,8(sp)
 21e:	e022                	sd	s0,0(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1e>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x14>
  }
  return dst;
}
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <strchr>:

char*
strchr(const char *s, char c)
{
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
  for(; *s; s++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf81                	beqz	a5,264 <strchr+0x24>
    if(*s == c)
 24e:	00f58763          	beq	a1,a5,25c <strchr+0x1c>
  for(; *s; s++)
 252:	0505                	addi	a0,a0,1
 254:	00054783          	lbu	a5,0(a0)
 258:	fbfd                	bnez	a5,24e <strchr+0xe>
      return (char*)s;
  return 0;
 25a:	4501                	li	a0,0
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfdd                	j	25c <strchr+0x1c>

0000000000000268 <gets>:

char*
gets(char *buf, int max)
{
 268:	7159                	addi	sp,sp,-112
 26a:	f486                	sd	ra,104(sp)
 26c:	f0a2                	sd	s0,96(sp)
 26e:	eca6                	sd	s1,88(sp)
 270:	e8ca                	sd	s2,80(sp)
 272:	e4ce                	sd	s3,72(sp)
 274:	e0d2                	sd	s4,64(sp)
 276:	fc56                	sd	s5,56(sp)
 278:	f85a                	sd	s6,48(sp)
 27a:	f45e                	sd	s7,40(sp)
 27c:	f062                	sd	s8,32(sp)
 27e:	ec66                	sd	s9,24(sp)
 280:	e86a                	sd	s10,16(sp)
 282:	1880                	addi	s0,sp,112
 284:	8caa                	mv	s9,a0
 286:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 288:	892a                	mv	s2,a0
 28a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 28c:	f9f40b13          	addi	s6,s0,-97
 290:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 292:	4ba9                	li	s7,10
 294:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 296:	8d26                	mv	s10,s1
 298:	0014899b          	addiw	s3,s1,1
 29c:	84ce                	mv	s1,s3
 29e:	0349d563          	bge	s3,s4,2c8 <gets+0x60>
    cc = read(0, &c, 1);
 2a2:	8656                	mv	a2,s5
 2a4:	85da                	mv	a1,s6
 2a6:	4501                	li	a0,0
 2a8:	198000ef          	jal	440 <read>
    if(cc < 1)
 2ac:	00a05e63          	blez	a0,2c8 <gets+0x60>
    buf[i++] = c;
 2b0:	f9f44783          	lbu	a5,-97(s0)
 2b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b8:	01778763          	beq	a5,s7,2c6 <gets+0x5e>
 2bc:	0905                	addi	s2,s2,1
 2be:	fd879ce3          	bne	a5,s8,296 <gets+0x2e>
    buf[i++] = c;
 2c2:	8d4e                	mv	s10,s3
 2c4:	a011                	j	2c8 <gets+0x60>
 2c6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2c8:	9d66                	add	s10,s10,s9
 2ca:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2ce:	8566                	mv	a0,s9
 2d0:	70a6                	ld	ra,104(sp)
 2d2:	7406                	ld	s0,96(sp)
 2d4:	64e6                	ld	s1,88(sp)
 2d6:	6946                	ld	s2,80(sp)
 2d8:	69a6                	ld	s3,72(sp)
 2da:	6a06                	ld	s4,64(sp)
 2dc:	7ae2                	ld	s5,56(sp)
 2de:	7b42                	ld	s6,48(sp)
 2e0:	7ba2                	ld	s7,40(sp)
 2e2:	7c02                	ld	s8,32(sp)
 2e4:	6ce2                	ld	s9,24(sp)
 2e6:	6d42                	ld	s10,16(sp)
 2e8:	6165                	addi	sp,sp,112
 2ea:	8082                	ret

00000000000002ec <stat>:

int
stat(const char *n, struct stat *st)
{
 2ec:	1101                	addi	sp,sp,-32
 2ee:	ec06                	sd	ra,24(sp)
 2f0:	e822                	sd	s0,16(sp)
 2f2:	e04a                	sd	s2,0(sp)
 2f4:	1000                	addi	s0,sp,32
 2f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f8:	4581                	li	a1,0
 2fa:	196000ef          	jal	490 <open>
  if(fd < 0)
 2fe:	02054263          	bltz	a0,322 <stat+0x36>
 302:	e426                	sd	s1,8(sp)
 304:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 306:	85ca                	mv	a1,s2
 308:	150000ef          	jal	458 <fstat>
 30c:	892a                	mv	s2,a0
  close(fd);
 30e:	8526                	mv	a0,s1
 310:	1b0000ef          	jal	4c0 <close>
  return r;
 314:	64a2                	ld	s1,8(sp)
}
 316:	854a                	mv	a0,s2
 318:	60e2                	ld	ra,24(sp)
 31a:	6442                	ld	s0,16(sp)
 31c:	6902                	ld	s2,0(sp)
 31e:	6105                	addi	sp,sp,32
 320:	8082                	ret
    return -1;
 322:	597d                	li	s2,-1
 324:	bfcd                	j	316 <stat+0x2a>

0000000000000326 <atoi>:

int
atoi(const char *s)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32e:	00054683          	lbu	a3,0(a0)
 332:	fd06879b          	addiw	a5,a3,-48
 336:	0ff7f793          	zext.b	a5,a5
 33a:	4625                	li	a2,9
 33c:	02f66963          	bltu	a2,a5,36e <atoi+0x48>
 340:	872a                	mv	a4,a0
  n = 0;
 342:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 344:	0705                	addi	a4,a4,1
 346:	0025179b          	slliw	a5,a0,0x2
 34a:	9fa9                	addw	a5,a5,a0
 34c:	0017979b          	slliw	a5,a5,0x1
 350:	9fb5                	addw	a5,a5,a3
 352:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 356:	00074683          	lbu	a3,0(a4)
 35a:	fd06879b          	addiw	a5,a3,-48
 35e:	0ff7f793          	zext.b	a5,a5
 362:	fef671e3          	bgeu	a2,a5,344 <atoi+0x1e>
  return n;
}
 366:	60a2                	ld	ra,8(sp)
 368:	6402                	ld	s0,0(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  n = 0;
 36e:	4501                	li	a0,0
 370:	bfdd                	j	366 <atoi+0x40>

0000000000000372 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 37a:	02b57563          	bgeu	a0,a1,3a4 <memmove+0x32>
    while(n-- > 0)
 37e:	00c05f63          	blez	a2,39c <memmove+0x2a>
 382:	1602                	slli	a2,a2,0x20
 384:	9201                	srli	a2,a2,0x20
 386:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 38a:	872a                	mv	a4,a0
      *dst++ = *src++;
 38c:	0585                	addi	a1,a1,1
 38e:	0705                	addi	a4,a4,1
 390:	fff5c683          	lbu	a3,-1(a1)
 394:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 398:	fee79ae3          	bne	a5,a4,38c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
    dst += n;
 3a4:	00c50733          	add	a4,a0,a2
    src += n;
 3a8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3aa:	fec059e3          	blez	a2,39c <memmove+0x2a>
 3ae:	fff6079b          	addiw	a5,a2,-1
 3b2:	1782                	slli	a5,a5,0x20
 3b4:	9381                	srli	a5,a5,0x20
 3b6:	fff7c793          	not	a5,a5
 3ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3bc:	15fd                	addi	a1,a1,-1
 3be:	177d                	addi	a4,a4,-1
 3c0:	0005c683          	lbu	a3,0(a1)
 3c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c8:	fef71ae3          	bne	a4,a5,3bc <memmove+0x4a>
 3cc:	bfc1                	j	39c <memmove+0x2a>

00000000000003ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e406                	sd	ra,8(sp)
 3d2:	e022                	sd	s0,0(sp)
 3d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d6:	ca0d                	beqz	a2,408 <memcmp+0x3a>
 3d8:	fff6069b          	addiw	a3,a2,-1
 3dc:	1682                	slli	a3,a3,0x20
 3de:	9281                	srli	a3,a3,0x20
 3e0:	0685                	addi	a3,a3,1
 3e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e4:	00054783          	lbu	a5,0(a0)
 3e8:	0005c703          	lbu	a4,0(a1)
 3ec:	00e79863          	bne	a5,a4,3fc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3f0:	0505                	addi	a0,a0,1
    p2++;
 3f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f4:	fed518e3          	bne	a0,a3,3e4 <memcmp+0x16>
  }
  return 0;
 3f8:	4501                	li	a0,0
 3fa:	a019                	j	400 <memcmp+0x32>
      return *p1 - *p2;
 3fc:	40e7853b          	subw	a0,a5,a4
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
  return 0;
 408:	4501                	li	a0,0
 40a:	bfdd                	j	400 <memcmp+0x32>

000000000000040c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e406                	sd	ra,8(sp)
 410:	e022                	sd	s0,0(sp)
 412:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 414:	f5fff0ef          	jal	372 <memmove>
}
 418:	60a2                	ld	ra,8(sp)
 41a:	6402                	ld	s0,0(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 420:	4885                	li	a7,1
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <exit>:
.global exit
exit:
 li a7, SYS_exit
 428:	4889                	li	a7,2
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <wait>:
.global wait
wait:
 li a7, SYS_wait
 430:	488d                	li	a7,3
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 438:	4891                	li	a7,4
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <read>:
.global read
read:
 li a7, SYS_read
 440:	4895                	li	a7,5
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <kill>:
.global kill
kill:
 li a7, SYS_kill
 448:	4899                	li	a7,6
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <exec>:
.global exec
exec:
 li a7, SYS_exec
 450:	489d                	li	a7,7
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 458:	48a1                	li	a7,8
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 460:	48a5                	li	a7,9
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <dup>:
.global dup
dup:
 li a7, SYS_dup
 468:	48a9                	li	a7,10
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 470:	48ad                	li	a7,11
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 478:	48b1                	li	a7,12
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 480:	48b5                	li	a7,13
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 488:	48b9                	li	a7,14
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <open>:
.global open
open:
 li a7, SYS_open
 490:	48bd                	li	a7,15
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <write>:
.global write
write:
 li a7, SYS_write
 498:	48c1                	li	a7,16
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a0:	48c5                	li	a7,17
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a8:	48c9                	li	a7,18
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <link>:
.global link
link:
 li a7, SYS_link
 4b0:	48cd                	li	a7,19
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b8:	48d1                	li	a7,20
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <close>:
.global close
close:
 li a7, SYS_close
 4c0:	48d5                	li	a7,21
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 4c8:	48d9                	li	a7,22
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 4d0:	48dd                	li	a7,23
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d8:	1101                	addi	sp,sp,-32
 4da:	ec06                	sd	ra,24(sp)
 4dc:	e822                	sd	s0,16(sp)
 4de:	1000                	addi	s0,sp,32
 4e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e4:	4605                	li	a2,1
 4e6:	fef40593          	addi	a1,s0,-17
 4ea:	fafff0ef          	jal	498 <write>
}
 4ee:	60e2                	ld	ra,24(sp)
 4f0:	6442                	ld	s0,16(sp)
 4f2:	6105                	addi	sp,sp,32
 4f4:	8082                	ret

00000000000004f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f6:	7139                	addi	sp,sp,-64
 4f8:	fc06                	sd	ra,56(sp)
 4fa:	f822                	sd	s0,48(sp)
 4fc:	f426                	sd	s1,40(sp)
 4fe:	f04a                	sd	s2,32(sp)
 500:	ec4e                	sd	s3,24(sp)
 502:	0080                	addi	s0,sp,64
 504:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 506:	c299                	beqz	a3,50c <printint+0x16>
 508:	0605ce63          	bltz	a1,584 <printint+0x8e>
  neg = 0;
 50c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 50e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 512:	869a                	mv	a3,t1
  i = 0;
 514:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 516:	00000817          	auipc	a6,0x0
 51a:	68a80813          	addi	a6,a6,1674 # ba0 <digits>
 51e:	88be                	mv	a7,a5
 520:	0017851b          	addiw	a0,a5,1
 524:	87aa                	mv	a5,a0
 526:	02c5f73b          	remuw	a4,a1,a2
 52a:	1702                	slli	a4,a4,0x20
 52c:	9301                	srli	a4,a4,0x20
 52e:	9742                	add	a4,a4,a6
 530:	00074703          	lbu	a4,0(a4)
 534:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 538:	872e                	mv	a4,a1
 53a:	02c5d5bb          	divuw	a1,a1,a2
 53e:	0685                	addi	a3,a3,1
 540:	fcc77fe3          	bgeu	a4,a2,51e <printint+0x28>
  if(neg)
 544:	000e0c63          	beqz	t3,55c <printint+0x66>
    buf[i++] = '-';
 548:	fd050793          	addi	a5,a0,-48
 54c:	00878533          	add	a0,a5,s0
 550:	02d00793          	li	a5,45
 554:	fef50823          	sb	a5,-16(a0)
 558:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 55c:	fff7899b          	addiw	s3,a5,-1
 560:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 564:	fff4c583          	lbu	a1,-1(s1)
 568:	854a                	mv	a0,s2
 56a:	f6fff0ef          	jal	4d8 <putc>
  while(--i >= 0)
 56e:	39fd                	addiw	s3,s3,-1
 570:	14fd                	addi	s1,s1,-1
 572:	fe09d9e3          	bgez	s3,564 <printint+0x6e>
}
 576:	70e2                	ld	ra,56(sp)
 578:	7442                	ld	s0,48(sp)
 57a:	74a2                	ld	s1,40(sp)
 57c:	7902                	ld	s2,32(sp)
 57e:	69e2                	ld	s3,24(sp)
 580:	6121                	addi	sp,sp,64
 582:	8082                	ret
    x = -xx;
 584:	40b005bb          	negw	a1,a1
    neg = 1;
 588:	4e05                	li	t3,1
    x = -xx;
 58a:	b751                	j	50e <printint+0x18>

000000000000058c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 596:	0005c483          	lbu	s1,0(a1)
 59a:	26048663          	beqz	s1,806 <vprintf+0x27a>
 59e:	e0ca                	sd	s2,64(sp)
 5a0:	fc4e                	sd	s3,56(sp)
 5a2:	f852                	sd	s4,48(sp)
 5a4:	f456                	sd	s5,40(sp)
 5a6:	f05a                	sd	s6,32(sp)
 5a8:	ec5e                	sd	s7,24(sp)
 5aa:	e862                	sd	s8,16(sp)
 5ac:	e466                	sd	s9,8(sp)
 5ae:	8b2a                	mv	s6,a0
 5b0:	8a2e                	mv	s4,a1
 5b2:	8bb2                	mv	s7,a2
  state = 0;
 5b4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5b6:	4901                	li	s2,0
 5b8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ba:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5c2:	06c00c93          	li	s9,108
 5c6:	a00d                	j	5e8 <vprintf+0x5c>
        putc(fd, c0);
 5c8:	85a6                	mv	a1,s1
 5ca:	855a                	mv	a0,s6
 5cc:	f0dff0ef          	jal	4d8 <putc>
 5d0:	a019                	j	5d6 <vprintf+0x4a>
    } else if(state == '%'){
 5d2:	03598363          	beq	s3,s5,5f8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5d6:	0019079b          	addiw	a5,s2,1
 5da:	893e                	mv	s2,a5
 5dc:	873e                	mv	a4,a5
 5de:	97d2                	add	a5,a5,s4
 5e0:	0007c483          	lbu	s1,0(a5)
 5e4:	20048963          	beqz	s1,7f6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 5e8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5ec:	fe0993e3          	bnez	s3,5d2 <vprintf+0x46>
      if(c0 == '%'){
 5f0:	fd579ce3          	bne	a5,s5,5c8 <vprintf+0x3c>
        state = '%';
 5f4:	89be                	mv	s3,a5
 5f6:	b7c5                	j	5d6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f8:	00ea06b3          	add	a3,s4,a4
 5fc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 600:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 602:	c681                	beqz	a3,60a <vprintf+0x7e>
 604:	9752                	add	a4,a4,s4
 606:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 60a:	03878e63          	beq	a5,s8,646 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 60e:	05978863          	beq	a5,s9,65e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 612:	07500713          	li	a4,117
 616:	0ee78263          	beq	a5,a4,6fa <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 61a:	07800713          	li	a4,120
 61e:	12e78463          	beq	a5,a4,746 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 622:	07000713          	li	a4,112
 626:	14e78963          	beq	a5,a4,778 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 62a:	07300713          	li	a4,115
 62e:	18e78863          	beq	a5,a4,7be <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 632:	02500713          	li	a4,37
 636:	04e79463          	bne	a5,a4,67e <vprintf+0xf2>
        putc(fd, '%');
 63a:	85ba                	mv	a1,a4
 63c:	855a                	mv	a0,s6
 63e:	e9bff0ef          	jal	4d8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 642:	4981                	li	s3,0
 644:	bf49                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 646:	008b8493          	addi	s1,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	ea3ff0ef          	jal	4f6 <printint>
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bfad                	j	5d6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 65e:	06400793          	li	a5,100
 662:	02f68963          	beq	a3,a5,694 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 666:	06c00793          	li	a5,108
 66a:	04f68263          	beq	a3,a5,6ae <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 66e:	07500793          	li	a5,117
 672:	0af68063          	beq	a3,a5,712 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 676:	07800793          	li	a5,120
 67a:	0ef68263          	beq	a3,a5,75e <vprintf+0x1d2>
        putc(fd, '%');
 67e:	02500593          	li	a1,37
 682:	855a                	mv	a0,s6
 684:	e55ff0ef          	jal	4d8 <putc>
        putc(fd, c0);
 688:	85a6                	mv	a1,s1
 68a:	855a                	mv	a0,s6
 68c:	e4dff0ef          	jal	4d8 <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	b791                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 694:	008b8493          	addi	s1,s7,8
 698:	4685                	li	a3,1
 69a:	4629                	li	a2,10
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	e55ff0ef          	jal	4f6 <printint>
        i += 1;
 6a6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
        i += 1;
 6ac:	b72d                	j	5d6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ae:	06400793          	li	a5,100
 6b2:	02f60763          	beq	a2,a5,6e0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b6:	07500793          	li	a5,117
 6ba:	06f60963          	beq	a2,a5,72c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6be:	07800793          	li	a5,120
 6c2:	faf61ee3          	bne	a2,a5,67e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e23ff0ef          	jal	4f6 <printint>
        i += 2;
 6d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	bde5                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e0:	008b8493          	addi	s1,s7,8
 6e4:	4685                	li	a3,1
 6e6:	4629                	li	a2,10
 6e8:	000ba583          	lw	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	e09ff0ef          	jal	4f6 <printint>
        i += 2;
 6f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f4:	8ba6                	mv	s7,s1
      state = 0;
 6f6:	4981                	li	s3,0
        i += 2;
 6f8:	bdf9                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6fa:	008b8493          	addi	s1,s7,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000ba583          	lw	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	defff0ef          	jal	4f6 <printint>
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
 710:	b5d9                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b8493          	addi	s1,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	dd7ff0ef          	jal	4f6 <printint>
        i += 1;
 724:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
        i += 1;
 72a:	b575                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	dbdff0ef          	jal	4f6 <printint>
        i += 2;
 73e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 740:	8ba6                	mv	s7,s1
      state = 0;
 742:	4981                	li	s3,0
        i += 2;
 744:	bd49                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 746:	008b8493          	addi	s1,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	da3ff0ef          	jal	4f6 <printint>
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bdad                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4641                	li	a2,16
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	d8bff0ef          	jal	4f6 <printint>
        i += 1;
 770:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
        i += 1;
 776:	b585                	j	5d6 <vprintf+0x4a>
 778:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 77a:	008b8d13          	addi	s10,s7,8
 77e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 782:	03000593          	li	a1,48
 786:	855a                	mv	a0,s6
 788:	d51ff0ef          	jal	4d8 <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	855a                	mv	a0,s6
 792:	d47ff0ef          	jal	4d8 <putc>
 796:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 798:	00000b97          	auipc	s7,0x0
 79c:	408b8b93          	addi	s7,s7,1032 # ba0 <digits>
 7a0:	03c9d793          	srli	a5,s3,0x3c
 7a4:	97de                	add	a5,a5,s7
 7a6:	0007c583          	lbu	a1,0(a5)
 7aa:	855a                	mv	a0,s6
 7ac:	d2dff0ef          	jal	4d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	0992                	slli	s3,s3,0x4
 7b2:	34fd                	addiw	s1,s1,-1
 7b4:	f4f5                	bnez	s1,7a0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7b6:	8bea                	mv	s7,s10
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	6d02                	ld	s10,0(sp)
 7bc:	bd29                	j	5d6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7be:	008b8993          	addi	s3,s7,8
 7c2:	000bb483          	ld	s1,0(s7)
 7c6:	cc91                	beqz	s1,7e2 <vprintf+0x256>
        for(; *s; s++)
 7c8:	0004c583          	lbu	a1,0(s1)
 7cc:	c195                	beqz	a1,7f0 <vprintf+0x264>
          putc(fd, *s);
 7ce:	855a                	mv	a0,s6
 7d0:	d09ff0ef          	jal	4d8 <putc>
        for(; *s; s++)
 7d4:	0485                	addi	s1,s1,1
 7d6:	0004c583          	lbu	a1,0(s1)
 7da:	f9f5                	bnez	a1,7ce <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7dc:	8bce                	mv	s7,s3
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bbdd                	j	5d6 <vprintf+0x4a>
          s = "(null)";
 7e2:	00000497          	auipc	s1,0x0
 7e6:	3b648493          	addi	s1,s1,950 # b98 <malloc+0x2a6>
        for(; *s; s++)
 7ea:	02800593          	li	a1,40
 7ee:	b7c5                	j	7ce <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7f0:	8bce                	mv	s7,s3
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b3cd                	j	5d6 <vprintf+0x4a>
 7f6:	6906                	ld	s2,64(sp)
 7f8:	79e2                	ld	s3,56(sp)
 7fa:	7a42                	ld	s4,48(sp)
 7fc:	7aa2                	ld	s5,40(sp)
 7fe:	7b02                	ld	s6,32(sp)
 800:	6be2                	ld	s7,24(sp)
 802:	6c42                	ld	s8,16(sp)
 804:	6ca2                	ld	s9,8(sp)
    }
  }
}
 806:	60e6                	ld	ra,88(sp)
 808:	6446                	ld	s0,80(sp)
 80a:	64a6                	ld	s1,72(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 810:	715d                	addi	sp,sp,-80
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	1000                	addi	s0,sp,32
 818:	e010                	sd	a2,0(s0)
 81a:	e414                	sd	a3,8(s0)
 81c:	e818                	sd	a4,16(s0)
 81e:	ec1c                	sd	a5,24(s0)
 820:	03043023          	sd	a6,32(s0)
 824:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 828:	8622                	mv	a2,s0
 82a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82e:	d5fff0ef          	jal	58c <vprintf>
}
 832:	60e2                	ld	ra,24(sp)
 834:	6442                	ld	s0,16(sp)
 836:	6161                	addi	sp,sp,80
 838:	8082                	ret

000000000000083a <printf>:

void
printf(const char *fmt, ...)
{
 83a:	711d                	addi	sp,sp,-96
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e40c                	sd	a1,8(s0)
 844:	e810                	sd	a2,16(s0)
 846:	ec14                	sd	a3,24(s0)
 848:	f018                	sd	a4,32(s0)
 84a:	f41c                	sd	a5,40(s0)
 84c:	03043823          	sd	a6,48(s0)
 850:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	00840613          	addi	a2,s0,8
 858:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85c:	85aa                	mv	a1,a0
 85e:	4505                	li	a0,1
 860:	d2dff0ef          	jal	58c <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6125                	addi	sp,sp,96
 86a:	8082                	ret

000000000000086c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86c:	1141                	addi	sp,sp,-16
 86e:	e406                	sd	ra,8(sp)
 870:	e022                	sd	s0,0(sp)
 872:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 874:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	00001797          	auipc	a5,0x1
 87c:	7887b783          	ld	a5,1928(a5) # 2000 <freep>
 880:	a02d                	j	8aa <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 882:	4618                	lw	a4,8(a2)
 884:	9f2d                	addw	a4,a4,a1
 886:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	6310                	ld	a2,0(a4)
 88e:	a83d                	j	8cc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 890:	ff852703          	lw	a4,-8(a0)
 894:	9f31                	addw	a4,a4,a2
 896:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 898:	ff053683          	ld	a3,-16(a0)
 89c:	a091                	j	8e0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e7e463          	bltu	a5,a4,8a8 <free+0x3c>
 8a4:	00e6ea63          	bltu	a3,a4,8b8 <free+0x4c>
{
 8a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	fed7fae3          	bgeu	a5,a3,89e <free+0x32>
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e6e463          	bltu	a3,a4,8b8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	fee7eae3          	bltu	a5,a4,8a8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8b8:	ff852583          	lw	a1,-8(a0)
 8bc:	6390                	ld	a2,0(a5)
 8be:	02059813          	slli	a6,a1,0x20
 8c2:	01c85713          	srli	a4,a6,0x1c
 8c6:	9736                	add	a4,a4,a3
 8c8:	fae60de3          	beq	a2,a4,882 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d0:	4790                	lw	a2,8(a5)
 8d2:	02061593          	slli	a1,a2,0x20
 8d6:	01c5d713          	srli	a4,a1,0x1c
 8da:	973e                	add	a4,a4,a5
 8dc:	fae68ae3          	beq	a3,a4,890 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e2:	00001717          	auipc	a4,0x1
 8e6:	70f73f23          	sd	a5,1822(a4) # 2000 <freep>
}
 8ea:	60a2                	ld	ra,8(sp)
 8ec:	6402                	ld	s0,0(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f04a                	sd	s2,32(sp)
 8fa:	ec4e                	sd	s3,24(sp)
 8fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fe:	02051993          	slli	s3,a0,0x20
 902:	0209d993          	srli	s3,s3,0x20
 906:	09bd                	addi	s3,s3,15
 908:	0049d993          	srli	s3,s3,0x4
 90c:	2985                	addiw	s3,s3,1
 90e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 910:	00001517          	auipc	a0,0x1
 914:	6f053503          	ld	a0,1776(a0) # 2000 <freep>
 918:	c905                	beqz	a0,948 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91c:	4798                	lw	a4,8(a5)
 91e:	09377663          	bgeu	a4,s3,9aa <malloc+0xb8>
 922:	f426                	sd	s1,40(sp)
 924:	e852                	sd	s4,16(sp)
 926:	e456                	sd	s5,8(sp)
 928:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92a:	8a4e                	mv	s4,s3
 92c:	6705                	lui	a4,0x1
 92e:	00e9f363          	bgeu	s3,a4,934 <malloc+0x42>
 932:	6a05                	lui	s4,0x1
 934:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 938:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93c:	00001497          	auipc	s1,0x1
 940:	6c448493          	addi	s1,s1,1732 # 2000 <freep>
  if(p == (char*)-1)
 944:	5afd                	li	s5,-1
 946:	a83d                	j	984 <malloc+0x92>
 948:	f426                	sd	s1,40(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 950:	00001797          	auipc	a5,0x1
 954:	6c078793          	addi	a5,a5,1728 # 2010 <base>
 958:	00001717          	auipc	a4,0x1
 95c:	6af73423          	sd	a5,1704(a4) # 2000 <freep>
 960:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 962:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 966:	b7d1                	j	92a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	e118                	sd	a4,0(a0)
 96c:	a899                	j	9c2 <malloc+0xd0>
  hp->s.size = nu;
 96e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 972:	0541                	addi	a0,a0,16
 974:	ef9ff0ef          	jal	86c <free>
  return freep;
 978:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 97a:	c125                	beqz	a0,9da <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97e:	4798                	lw	a4,8(a5)
 980:	03277163          	bgeu	a4,s2,9a2 <malloc+0xb0>
    if(p == freep)
 984:	6098                	ld	a4,0(s1)
 986:	853e                	mv	a0,a5
 988:	fef71ae3          	bne	a4,a5,97c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 98c:	8552                	mv	a0,s4
 98e:	aebff0ef          	jal	478 <sbrk>
  if(p == (char*)-1)
 992:	fd551ee3          	bne	a0,s5,96e <malloc+0x7c>
        return 0;
 996:	4501                	li	a0,0
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	a03d                	j	9ce <malloc+0xdc>
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9aa:	fae90fe3          	beq	s2,a4,968 <malloc+0x76>
        p->s.size -= nunits;
 9ae:	4137073b          	subw	a4,a4,s3
 9b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b4:	02071693          	slli	a3,a4,0x20
 9b8:	01c6d713          	srli	a4,a3,0x1c
 9bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c2:	00001717          	auipc	a4,0x1
 9c6:	62a73f23          	sd	a0,1598(a4) # 2000 <freep>
      return (void*)(p + 1);
 9ca:	01078513          	addi	a0,a5,16
  }
}
 9ce:	70e2                	ld	ra,56(sp)
 9d0:	7442                	ld	s0,48(sp)
 9d2:	7902                	ld	s2,32(sp)
 9d4:	69e2                	ld	s3,24(sp)
 9d6:	6121                	addi	sp,sp,64
 9d8:	8082                	ret
 9da:	74a2                	ld	s1,40(sp)
 9dc:	6a42                	ld	s4,16(sp)
 9de:	6aa2                	ld	s5,8(sp)
 9e0:	6b02                	ld	s6,0(sp)
 9e2:	b7f5                	j	9ce <malloc+0xdc>
