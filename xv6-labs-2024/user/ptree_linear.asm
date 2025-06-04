
user/_ptree_linear:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  int pid1 = fork();
   8:	2d0000ef          	jal	2d8 <fork>
  if (pid1 == 0) {
   c:	ed15                	bnez	a0,48 <main+0x48>
    int pid2 = fork();
   e:	2ca000ef          	jal	2d8 <fork>
    if (pid2 == 0) {
  12:	e50d                	bnez	a0,3c <main+0x3c>
      int pid3 = fork();
  14:	2c4000ef          	jal	2d8 <fork>
      if (pid3 == 0) {
  18:	e519                	bnez	a0,26 <main+0x26>
        sleep(1);
  1a:	4505                	li	a0,1
  1c:	31c000ef          	jal	338 <sleep>
        exit(0);
  20:	4501                	li	a0,0
  22:	2be000ef          	jal	2e0 <exit>
      } else {
        sleep(1);
  26:	4505                	li	a0,1
  28:	310000ef          	jal	338 <sleep>
        ptree();
  2c:	36c000ef          	jal	398 <ptree>
        wait(0);
  30:	4501                	li	a0,0
  32:	2b6000ef          	jal	2e8 <wait>
        exit(0);
  36:	4501                	li	a0,0
  38:	2a8000ef          	jal	2e0 <exit>
      }
    } else {
      wait(0);
  3c:	4501                	li	a0,0
  3e:	2aa000ef          	jal	2e8 <wait>
      exit(0);
  42:	4501                	li	a0,0
  44:	29c000ef          	jal	2e0 <exit>
    }
  } else {
    wait(0);
  48:	4501                	li	a0,0
  4a:	29e000ef          	jal	2e8 <wait>
  }
  
  exit(0);
  4e:	4501                	li	a0,0
  50:	290000ef          	jal	2e0 <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	27e000ef          	jal	2e0 <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	87aa                	mv	a5,a0
  70:	0585                	addi	a1,a1,1
  72:	0785                	addi	a5,a5,1
  74:	fff5c703          	lbu	a4,-1(a1)
  78:	fee78fa3          	sb	a4,-1(a5)
  7c:	fb75                	bnez	a4,70 <strcpy+0xa>
    ;
  return os;
}
  7e:	60a2                	ld	ra,8(sp)
  80:	6402                	ld	s0,0(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret

0000000000000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x20>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x20>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strlen>:

uint
strlen(const char *s)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e406                	sd	ra,8(sp)
  ba:	e022                	sd	s0,0(sp)
  bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cf91                	beqz	a5,de <strlen+0x28>
  c4:	00150793          	addi	a5,a0,1
  c8:	86be                	mv	a3,a5
  ca:	0785                	addi	a5,a5,1
  cc:	fff7c703          	lbu	a4,-1(a5)
  d0:	ff65                	bnez	a4,c8 <strlen+0x12>
  d2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for(n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfdd                	j	d6 <strlen+0x20>

00000000000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ea:	ca19                	beqz	a2,100 <memset+0x1e>
  ec:	87aa                	mv	a5,a0
  ee:	1602                	slli	a2,a2,0x20
  f0:	9201                	srli	a2,a2,0x20
  f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fa:	0785                	addi	a5,a5,1
  fc:	fee79de3          	bne	a5,a4,f6 <memset+0x14>
  }
  return dst;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf81                	beqz	a5,12c <strchr+0x24>
    if(*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1c>
  for(; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xe>
      return (char*)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfdd                	j	124 <strchr+0x1c>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	e862                	sd	s8,16(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 150:	faf40b13          	addi	s6,s0,-81
 154:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 156:	8c26                	mv	s8,s1
 158:	0014899b          	addiw	s3,s1,1
 15c:	84ce                	mv	s1,s3
 15e:	0349d463          	bge	s3,s4,186 <gets+0x56>
    cc = read(0, &c, 1);
 162:	8656                	mv	a2,s5
 164:	85da                	mv	a1,s6
 166:	4501                	li	a0,0
 168:	190000ef          	jal	2f8 <read>
    if(cc < 1)
 16c:	00a05d63          	blez	a0,186 <gets+0x56>
      break;
    buf[i++] = c;
 170:	faf44783          	lbu	a5,-81(s0)
 174:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 178:	0905                	addi	s2,s2,1
 17a:	ff678713          	addi	a4,a5,-10
 17e:	c319                	beqz	a4,184 <gets+0x54>
 180:	17cd                	addi	a5,a5,-13
 182:	fbf1                	bnez	a5,156 <gets+0x26>
    buf[i++] = c;
 184:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 186:	9c5e                	add	s8,s8,s7
 188:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6c42                	ld	s8,16(sp)
 1a2:	6125                	addi	sp,sp,96
 1a4:	8082                	ret

00000000000001a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	194000ef          	jal	348 <open>
  if(fd < 0)
 1b8:	02054263          	bltz	a0,1dc <stat+0x36>
 1bc:	e426                	sd	s1,8(sp)
 1be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c0:	85ca                	mv	a1,s2
 1c2:	14e000ef          	jal	310 <fstat>
 1c6:	892a                	mv	s2,a0
  close(fd);
 1c8:	8526                	mv	a0,s1
 1ca:	1ae000ef          	jal	378 <close>
  return r;
 1ce:	64a2                	ld	s1,8(sp)
}
 1d0:	854a                	mv	a0,s2
 1d2:	60e2                	ld	ra,24(sp)
 1d4:	6442                	ld	s0,16(sp)
 1d6:	6902                	ld	s2,0(sp)
 1d8:	6105                	addi	sp,sp,32
 1da:	8082                	ret
    return -1;
 1dc:	57fd                	li	a5,-1
 1de:	893e                	mv	s2,a5
 1e0:	bfc5                	j	1d0 <stat+0x2a>

00000000000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ea:	00054683          	lbu	a3,0(a0)
 1ee:	fd06879b          	addiw	a5,a3,-48
 1f2:	0ff7f793          	zext.b	a5,a5
 1f6:	4625                	li	a2,9
 1f8:	02f66963          	bltu	a2,a5,22a <atoi+0x48>
 1fc:	872a                	mv	a4,a0
  n = 0;
 1fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 200:	0705                	addi	a4,a4,1
 202:	0025179b          	slliw	a5,a0,0x2
 206:	9fa9                	addw	a5,a5,a0
 208:	0017979b          	slliw	a5,a5,0x1
 20c:	9fb5                	addw	a5,a5,a3
 20e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 212:	00074683          	lbu	a3,0(a4)
 216:	fd06879b          	addiw	a5,a3,-48
 21a:	0ff7f793          	zext.b	a5,a5
 21e:	fef671e3          	bgeu	a2,a5,200 <atoi+0x1e>
  return n;
}
 222:	60a2                	ld	ra,8(sp)
 224:	6402                	ld	s0,0(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  n = 0;
 22a:	4501                	li	a0,0
 22c:	bfdd                	j	222 <atoi+0x40>

000000000000022e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57563          	bgeu	a0,a1,260 <memmove+0x32>
    while(n-- > 0)
 23a:	00c05f63          	blez	a2,258 <memmove+0x2a>
 23e:	1602                	slli	a2,a2,0x20
 240:	9201                	srli	a2,a2,0x20
 242:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 246:	872a                	mv	a4,a0
      *dst++ = *src++;
 248:	0585                	addi	a1,a1,1
 24a:	0705                	addi	a4,a4,1
 24c:	fff5c683          	lbu	a3,-1(a1)
 250:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 254:	fee79ae3          	bne	a5,a4,248 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
    while(n-- > 0)
 260:	fec05ce3          	blez	a2,258 <memmove+0x2a>
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
 26a:	fff6079b          	addiw	a5,a2,-1
 26e:	1782                	slli	a5,a5,0x20
 270:	9381                	srli	a5,a5,0x20
 272:	fff7c793          	not	a5,a5
 276:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 278:	15fd                	addi	a1,a1,-1
 27a:	177d                	addi	a4,a4,-1
 27c:	0005c683          	lbu	a3,0(a1)
 280:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 284:	fef71ae3          	bne	a4,a5,278 <memmove+0x4a>
 288:	bfc1                	j	258 <memmove+0x2a>

000000000000028a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	c61d                	beqz	a2,2c0 <memcmp+0x36>
 294:	1602                	slli	a2,a2,0x20
 296:	9201                	srli	a2,a2,0x20
 298:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	addi	a0,a0,1
    p2++;
 2aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x12>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x2e>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <memcmp+0x2e>

00000000000002c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2cc:	f63ff0ef          	jal	22e <memmove>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d8:	4885                	li	a7,1
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e0:	4889                	li	a7,2
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e8:	488d                	li	a7,3
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f0:	4891                	li	a7,4
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <read>:
.global read
read:
 li a7, SYS_read
 2f8:	4895                	li	a7,5
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 318:	48a5                	li	a7,9
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <dup>:
.global dup
dup:
 li a7, SYS_dup
 320:	48a9                	li	a7,10
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 328:	48ad                	li	a7,11
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 330:	48b1                	li	a7,12
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 338:	48b5                	li	a7,13
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 340:	48b9                	li	a7,14
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <open>:
.global open
open:
 li a7, SYS_open
 348:	48bd                	li	a7,15
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <write>:
.global write
write:
 li a7, SYS_write
 350:	48c1                	li	a7,16
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <link>:
.global link
link:
 li a7, SYS_link
 368:	48cd                	li	a7,19
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 370:	48d1                	li	a7,20
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 380:	48d9                	li	a7,22
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 388:	48dd                	li	a7,23
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 390:	48e1                	li	a7,24
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 398:	48e5                	li	a7,25
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	f9fff0ef          	jal	350 <write>
}
 3b6:	60e2                	ld	ra,24(sp)
 3b8:	6442                	ld	s0,16(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3be:	7139                	addi	sp,sp,-64
 3c0:	fc06                	sd	ra,56(sp)
 3c2:	f822                	sd	s0,48(sp)
 3c4:	f04a                	sd	s2,32(sp)
 3c6:	ec4e                	sd	s3,24(sp)
 3c8:	0080                	addi	s0,sp,64
 3ca:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3cc:	cac9                	beqz	a3,45e <printint+0xa0>
 3ce:	01f5d79b          	srliw	a5,a1,0x1f
 3d2:	c7d1                	beqz	a5,45e <printint+0xa0>
    neg = 1;
    x = -xx;
 3d4:	40b005bb          	negw	a1,a1
    neg = 1;
 3d8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3da:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3de:	86ce                	mv	a3,s3
  i = 0;
 3e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e2:	00000817          	auipc	a6,0x0
 3e6:	50680813          	addi	a6,a6,1286 # 8e8 <digits>
 3ea:	88ba                	mv	a7,a4
 3ec:	0017051b          	addiw	a0,a4,1
 3f0:	872a                	mv	a4,a0
 3f2:	02c5f7bb          	remuw	a5,a1,a2
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	97c2                	add	a5,a5,a6
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 404:	87ae                	mv	a5,a1
 406:	02c5d5bb          	divuw	a1,a1,a2
 40a:	0685                	addi	a3,a3,1
 40c:	fcc7ffe3          	bgeu	a5,a2,3ea <printint+0x2c>
  if(neg)
 410:	00030c63          	beqz	t1,428 <printint+0x6a>
    buf[i++] = '-';
 414:	fd050793          	addi	a5,a0,-48
 418:	00878533          	add	a0,a5,s0
 41c:	02d00793          	li	a5,45
 420:	fef50823          	sb	a5,-16(a0)
 424:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 428:	02e05563          	blez	a4,452 <printint+0x94>
 42c:	f426                	sd	s1,40(sp)
 42e:	377d                	addiw	a4,a4,-1
 430:	00e984b3          	add	s1,s3,a4
 434:	19fd                	addi	s3,s3,-1
 436:	99ba                	add	s3,s3,a4
 438:	1702                	slli	a4,a4,0x20
 43a:	9301                	srli	a4,a4,0x20
 43c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 440:	0004c583          	lbu	a1,0(s1)
 444:	854a                	mv	a0,s2
 446:	f5bff0ef          	jal	3a0 <putc>
  while(--i >= 0)
 44a:	14fd                	addi	s1,s1,-1
 44c:	ff349ae3          	bne	s1,s3,440 <printint+0x82>
 450:	74a2                	ld	s1,40(sp)
}
 452:	70e2                	ld	ra,56(sp)
 454:	7442                	ld	s0,48(sp)
 456:	7902                	ld	s2,32(sp)
 458:	69e2                	ld	s3,24(sp)
 45a:	6121                	addi	sp,sp,64
 45c:	8082                	ret
  neg = 0;
 45e:	4301                	li	t1,0
 460:	bfad                	j	3da <printint+0x1c>

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	711d                	addi	sp,sp,-96
 464:	ec86                	sd	ra,88(sp)
 466:	e8a2                	sd	s0,80(sp)
 468:	e4a6                	sd	s1,72(sp)
 46a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46c:	0005c483          	lbu	s1,0(a1)
 470:	20048963          	beqz	s1,682 <vprintf+0x220>
 474:	e0ca                	sd	s2,64(sp)
 476:	fc4e                	sd	s3,56(sp)
 478:	f852                	sd	s4,48(sp)
 47a:	f456                	sd	s5,40(sp)
 47c:	f05a                	sd	s6,32(sp)
 47e:	ec5e                	sd	s7,24(sp)
 480:	e862                	sd	s8,16(sp)
 482:	8b2a                	mv	s6,a0
 484:	8a2e                	mv	s4,a1
 486:	8bb2                	mv	s7,a2
  state = 0;
 488:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 48a:	4901                	li	s2,0
 48c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 48e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 492:	06400c13          	li	s8,100
 496:	a00d                	j	4b8 <vprintf+0x56>
        putc(fd, c0);
 498:	85a6                	mv	a1,s1
 49a:	855a                	mv	a0,s6
 49c:	f05ff0ef          	jal	3a0 <putc>
 4a0:	a019                	j	4a6 <vprintf+0x44>
    } else if(state == '%'){
 4a2:	03598363          	beq	s3,s5,4c8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4a6:	0019079b          	addiw	a5,s2,1
 4aa:	893e                	mv	s2,a5
 4ac:	873e                	mv	a4,a5
 4ae:	97d2                	add	a5,a5,s4
 4b0:	0007c483          	lbu	s1,0(a5)
 4b4:	1c048063          	beqz	s1,674 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4b8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4bc:	fe0993e3          	bnez	s3,4a2 <vprintf+0x40>
      if(c0 == '%'){
 4c0:	fd579ce3          	bne	a5,s5,498 <vprintf+0x36>
        state = '%';
 4c4:	89be                	mv	s3,a5
 4c6:	b7c5                	j	4a6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c8:	00ea06b3          	add	a3,s4,a4
 4cc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4d0:	1a060e63          	beqz	a2,68c <vprintf+0x22a>
      if(c0 == 'd'){
 4d4:	03878763          	beq	a5,s8,502 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4d8:	f9478693          	addi	a3,a5,-108
 4dc:	0016b693          	seqz	a3,a3
 4e0:	f9c60593          	addi	a1,a2,-100
 4e4:	e99d                	bnez	a1,51a <vprintf+0xb8>
 4e6:	ca95                	beqz	a3,51a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e8:	008b8493          	addi	s1,s7,8
 4ec:	4685                	li	a3,1
 4ee:	4629                	li	a2,10
 4f0:	000ba583          	lw	a1,0(s7)
 4f4:	855a                	mv	a0,s6
 4f6:	ec9ff0ef          	jal	3be <printint>
        i += 1;
 4fa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fc:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4fe:	4981                	li	s3,0
 500:	b75d                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 502:	008b8493          	addi	s1,s7,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000ba583          	lw	a1,0(s7)
 50e:	855a                	mv	a0,s6
 510:	eafff0ef          	jal	3be <printint>
 514:	8ba6                	mv	s7,s1
      state = 0;
 516:	4981                	li	s3,0
 518:	b779                	j	4a6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 51a:	9752                	add	a4,a4,s4
 51c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 520:	f9460713          	addi	a4,a2,-108
 524:	00173713          	seqz	a4,a4
 528:	8f75                	and	a4,a4,a3
 52a:	f9c58513          	addi	a0,a1,-100
 52e:	16051963          	bnez	a0,6a0 <vprintf+0x23e>
 532:	16070763          	beqz	a4,6a0 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 536:	008b8493          	addi	s1,s7,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000ba583          	lw	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	e7bff0ef          	jal	3be <printint>
        i += 2;
 548:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	8ba6                	mv	s7,s1
      state = 0;
 54c:	4981                	li	s3,0
        i += 2;
 54e:	bfa1                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 550:	008b8493          	addi	s1,s7,8
 554:	4681                	li	a3,0
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e61ff0ef          	jal	3be <printint>
 562:	8ba6                	mv	s7,s1
      state = 0;
 564:	4981                	li	s3,0
 566:	b781                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b8493          	addi	s1,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e49ff0ef          	jal	3be <printint>
        i += 1;
 57a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
 580:	b71d                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000ba583          	lw	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e2fff0ef          	jal	3be <printint>
        i += 2;
 594:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
        i += 2;
 59a:	b731                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e15ff0ef          	jal	3be <printint>
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bdd5                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	dfdff0ef          	jal	3be <printint>
        i += 1;
 5c6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bde9                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4641                	li	a2,16
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	de3ff0ef          	jal	3be <printint>
        i += 2;
 5e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
        i += 2;
 5e6:	b5c1                	j	4a6 <vprintf+0x44>
 5e8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5ea:	008b8793          	addi	a5,s7,8
 5ee:	8cbe                	mv	s9,a5
 5f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f4:	03000593          	li	a1,48
 5f8:	855a                	mv	a0,s6
 5fa:	da7ff0ef          	jal	3a0 <putc>
  putc(fd, 'x');
 5fe:	07800593          	li	a1,120
 602:	855a                	mv	a0,s6
 604:	d9dff0ef          	jal	3a0 <putc>
 608:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60a:	00000b97          	auipc	s7,0x0
 60e:	2deb8b93          	addi	s7,s7,734 # 8e8 <digits>
 612:	03c9d793          	srli	a5,s3,0x3c
 616:	97de                	add	a5,a5,s7
 618:	0007c583          	lbu	a1,0(a5)
 61c:	855a                	mv	a0,s6
 61e:	d83ff0ef          	jal	3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 622:	0992                	slli	s3,s3,0x4
 624:	34fd                	addiw	s1,s1,-1
 626:	f4f5                	bnez	s1,612 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 628:	8be6                	mv	s7,s9
      state = 0;
 62a:	4981                	li	s3,0
 62c:	6ca2                	ld	s9,8(sp)
 62e:	bda5                	j	4a6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 630:	008b8993          	addi	s3,s7,8
 634:	000bb483          	ld	s1,0(s7)
 638:	cc91                	beqz	s1,654 <vprintf+0x1f2>
        for(; *s; s++)
 63a:	0004c583          	lbu	a1,0(s1)
 63e:	c985                	beqz	a1,66e <vprintf+0x20c>
          putc(fd, *s);
 640:	855a                	mv	a0,s6
 642:	d5fff0ef          	jal	3a0 <putc>
        for(; *s; s++)
 646:	0485                	addi	s1,s1,1
 648:	0004c583          	lbu	a1,0(s1)
 64c:	f9f5                	bnez	a1,640 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 64e:	8bce                	mv	s7,s3
      state = 0;
 650:	4981                	li	s3,0
 652:	bd91                	j	4a6 <vprintf+0x44>
          s = "(null)";
 654:	00000497          	auipc	s1,0x0
 658:	28c48493          	addi	s1,s1,652 # 8e0 <malloc+0xf8>
        for(; *s; s++)
 65c:	02800593          	li	a1,40
 660:	b7c5                	j	640 <vprintf+0x1de>
        putc(fd, '%');
 662:	85be                	mv	a1,a5
 664:	855a                	mv	a0,s6
 666:	d3bff0ef          	jal	3a0 <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd2d                	j	4a6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 66e:	8bce                	mv	s7,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	bd15                	j	4a6 <vprintf+0x44>
 674:	6906                	ld	s2,64(sp)
 676:	79e2                	ld	s3,56(sp)
 678:	7a42                	ld	s4,48(sp)
 67a:	7aa2                	ld	s5,40(sp)
 67c:	7b02                	ld	s6,32(sp)
 67e:	6be2                	ld	s7,24(sp)
 680:	6c42                	ld	s8,16(sp)
    }
  }
}
 682:	60e6                	ld	ra,88(sp)
 684:	6446                	ld	s0,80(sp)
 686:	64a6                	ld	s1,72(sp)
 688:	6125                	addi	sp,sp,96
 68a:	8082                	ret
      if(c0 == 'd'){
 68c:	06400713          	li	a4,100
 690:	e6e789e3          	beq	a5,a4,502 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 694:	f9478693          	addi	a3,a5,-108
 698:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 69c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6a0:	07500513          	li	a0,117
 6a4:	eaa786e3          	beq	a5,a0,550 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6a8:	f8b60513          	addi	a0,a2,-117
 6ac:	e119                	bnez	a0,6b2 <vprintf+0x250>
 6ae:	ea069de3          	bnez	a3,568 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b2:	f8b58513          	addi	a0,a1,-117
 6b6:	e119                	bnez	a0,6bc <vprintf+0x25a>
 6b8:	ec0715e3          	bnez	a4,582 <vprintf+0x120>
      } else if(c0 == 'x'){
 6bc:	07800513          	li	a0,120
 6c0:	eca78ee3          	beq	a5,a0,59c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6c4:	f8860613          	addi	a2,a2,-120
 6c8:	e219                	bnez	a2,6ce <vprintf+0x26c>
 6ca:	ee0695e3          	bnez	a3,5b4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ce:	f8858593          	addi	a1,a1,-120
 6d2:	e199                	bnez	a1,6d8 <vprintf+0x276>
 6d4:	ee071de3          	bnez	a4,5ce <vprintf+0x16c>
      } else if(c0 == 'p'){
 6d8:	07000713          	li	a4,112
 6dc:	f0e786e3          	beq	a5,a4,5e8 <vprintf+0x186>
      } else if(c0 == 's'){
 6e0:	07300713          	li	a4,115
 6e4:	f4e786e3          	beq	a5,a4,630 <vprintf+0x1ce>
      } else if(c0 == '%'){
 6e8:	02500713          	li	a4,37
 6ec:	f6e78be3          	beq	a5,a4,662 <vprintf+0x200>
        putc(fd, '%');
 6f0:	02500593          	li	a1,37
 6f4:	855a                	mv	a0,s6
 6f6:	cabff0ef          	jal	3a0 <putc>
        putc(fd, c0);
 6fa:	85a6                	mv	a1,s1
 6fc:	855a                	mv	a0,s6
 6fe:	ca3ff0ef          	jal	3a0 <putc>
      state = 0;
 702:	4981                	li	s3,0
 704:	b34d                	j	4a6 <vprintf+0x44>

0000000000000706 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 706:	715d                	addi	sp,sp,-80
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e010                	sd	a2,0(s0)
 710:	e414                	sd	a3,8(s0)
 712:	e818                	sd	a4,16(s0)
 714:	ec1c                	sd	a5,24(s0)
 716:	03043023          	sd	a6,32(s0)
 71a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	8622                	mv	a2,s0
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	d3fff0ef          	jal	462 <vprintf>
}
 728:	60e2                	ld	ra,24(sp)
 72a:	6442                	ld	s0,16(sp)
 72c:	6161                	addi	sp,sp,80
 72e:	8082                	ret

0000000000000730 <printf>:

void
printf(const char *fmt, ...)
{
 730:	711d                	addi	sp,sp,-96
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e40c                	sd	a1,8(s0)
 73a:	e810                	sd	a2,16(s0)
 73c:	ec14                	sd	a3,24(s0)
 73e:	f018                	sd	a4,32(s0)
 740:	f41c                	sd	a5,40(s0)
 742:	03043823          	sd	a6,48(s0)
 746:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	00840613          	addi	a2,s0,8
 74e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 752:	85aa                	mv	a1,a0
 754:	4505                	li	a0,1
 756:	d0dff0ef          	jal	462 <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6125                	addi	sp,sp,96
 760:	8082                	ret

0000000000000762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 762:	1141                	addi	sp,sp,-16
 764:	e406                	sd	ra,8(sp)
 766:	e022                	sd	s0,0(sp)
 768:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	00001797          	auipc	a5,0x1
 772:	8927b783          	ld	a5,-1902(a5) # 1000 <freep>
 776:	a039                	j	784 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	6398                	ld	a4,0(a5)
 77a:	00e7e463          	bltu	a5,a4,782 <free+0x20>
 77e:	00e6ea63          	bltu	a3,a4,792 <free+0x30>
{
 782:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	fed7fae3          	bgeu	a5,a3,778 <free+0x16>
 788:	6398                	ld	a4,0(a5)
 78a:	00e6e463          	bltu	a3,a4,792 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	fee7eae3          	bltu	a5,a4,782 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 792:	ff852583          	lw	a1,-8(a0)
 796:	6390                	ld	a2,0(a5)
 798:	02059813          	slli	a6,a1,0x20
 79c:	01c85713          	srli	a4,a6,0x1c
 7a0:	9736                	add	a4,a4,a3
 7a2:	02e60563          	beq	a2,a4,7cc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7aa:	4790                	lw	a2,8(a5)
 7ac:	02061593          	slli	a1,a2,0x20
 7b0:	01c5d713          	srli	a4,a1,0x1c
 7b4:	973e                	add	a4,a4,a5
 7b6:	02e68263          	beq	a3,a4,7da <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84f73223          	sd	a5,-1980(a4) # 1000 <freep>
}
 7c4:	60a2                	ld	ra,8(sp)
 7c6:	6402                	ld	s0,0(sp)
 7c8:	0141                	addi	sp,sp,16
 7ca:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7cc:	4618                	lw	a4,8(a2)
 7ce:	9f2d                	addw	a4,a4,a1
 7d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	6398                	ld	a4,0(a5)
 7d6:	6310                	ld	a2,0(a4)
 7d8:	b7f9                	j	7a6 <free+0x44>
    p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9f31                	addw	a4,a4,a2
 7e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e2:	ff053683          	ld	a3,-16(a0)
 7e6:	bfd1                	j	7ba <free+0x58>

00000000000007e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e8:	7139                	addi	sp,sp,-64
 7ea:	fc06                	sd	ra,56(sp)
 7ec:	f822                	sd	s0,48(sp)
 7ee:	f04a                	sd	s2,32(sp)
 7f0:	ec4e                	sd	s3,24(sp)
 7f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f4:	02051993          	slli	s3,a0,0x20
 7f8:	0209d993          	srli	s3,s3,0x20
 7fc:	09bd                	addi	s3,s3,15
 7fe:	0049d993          	srli	s3,s3,0x4
 802:	2985                	addiw	s3,s3,1
 804:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 806:	00000517          	auipc	a0,0x0
 80a:	7fa53503          	ld	a0,2042(a0) # 1000 <freep>
 80e:	c905                	beqz	a0,83e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 812:	4798                	lw	a4,8(a5)
 814:	09377663          	bgeu	a4,s3,8a0 <malloc+0xb8>
 818:	f426                	sd	s1,40(sp)
 81a:	e852                	sd	s4,16(sp)
 81c:	e456                	sd	s5,8(sp)
 81e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 820:	8a4e                	mv	s4,s3
 822:	6705                	lui	a4,0x1
 824:	00e9f363          	bgeu	s3,a4,82a <malloc+0x42>
 828:	6a05                	lui	s4,0x1
 82a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 832:	00000497          	auipc	s1,0x0
 836:	7ce48493          	addi	s1,s1,1998 # 1000 <freep>
  if(p == (char*)-1)
 83a:	5afd                	li	s5,-1
 83c:	a83d                	j	87a <malloc+0x92>
 83e:	f426                	sd	s1,40(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 846:	00000797          	auipc	a5,0x0
 84a:	7ca78793          	addi	a5,a5,1994 # 1010 <base>
 84e:	00000717          	auipc	a4,0x0
 852:	7af73923          	sd	a5,1970(a4) # 1000 <freep>
 856:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 858:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85c:	b7d1                	j	820 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 85e:	6398                	ld	a4,0(a5)
 860:	e118                	sd	a4,0(a0)
 862:	a899                	j	8b8 <malloc+0xd0>
  hp->s.size = nu;
 864:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 868:	0541                	addi	a0,a0,16
 86a:	ef9ff0ef          	jal	762 <free>
  return freep;
 86e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 870:	c125                	beqz	a0,8d0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	03277163          	bgeu	a4,s2,898 <malloc+0xb0>
    if(p == freep)
 87a:	6098                	ld	a4,0(s1)
 87c:	853e                	mv	a0,a5
 87e:	fef71ae3          	bne	a4,a5,872 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 882:	8552                	mv	a0,s4
 884:	aadff0ef          	jal	330 <sbrk>
  if(p == (char*)-1)
 888:	fd551ee3          	bne	a0,s5,864 <malloc+0x7c>
        return 0;
 88c:	4501                	li	a0,0
 88e:	74a2                	ld	s1,40(sp)
 890:	6a42                	ld	s4,16(sp)
 892:	6aa2                	ld	s5,8(sp)
 894:	6b02                	ld	s6,0(sp)
 896:	a03d                	j	8c4 <malloc+0xdc>
 898:	74a2                	ld	s1,40(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8a0:	fae90fe3          	beq	s2,a4,85e <malloc+0x76>
        p->s.size -= nunits;
 8a4:	4137073b          	subw	a4,a4,s3
 8a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8aa:	02071693          	slli	a3,a4,0x20
 8ae:	01c6d713          	srli	a4,a3,0x1c
 8b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74a73423          	sd	a0,1864(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c0:	01078513          	addi	a0,a5,16
  }
}
 8c4:	70e2                	ld	ra,56(sp)
 8c6:	7442                	ld	s0,48(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6121                	addi	sp,sp,64
 8ce:	8082                	ret
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	b7f5                	j	8c4 <malloc+0xdc>
