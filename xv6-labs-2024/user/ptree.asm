
user/_ptree:     file format elf64-littleriscv


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
  ptree();
   8:	34e000ef          	jal	356 <ptree>
  exit(0);
   c:	4501                	li	a0,0
   e:	290000ef          	jal	29e <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  extern int main();
  main();
  1a:	fe7ff0ef          	jal	0 <main>
  exit(0);
  1e:	4501                	li	a0,0
  20:	27e000ef          	jal	29e <exit>

0000000000000024 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2c:	87aa                	mv	a5,a0
  2e:	0585                	addi	a1,a1,1
  30:	0785                	addi	a5,a5,1
  32:	fff5c703          	lbu	a4,-1(a1)
  36:	fee78fa3          	sb	a4,-1(a5)
  3a:	fb75                	bnez	a4,2e <strcpy+0xa>
    ;
  return os;
}
  3c:	60a2                	ld	ra,8(sp)
  3e:	6402                	ld	s0,0(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x20>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x20>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	60a2                	ld	ra,8(sp)
  6e:	6402                	ld	s0,0(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <strlen>:

uint
strlen(const char *s)
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x28>
  82:	00150793          	addi	a5,a0,1
  86:	86be                	mv	a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x12>
  90:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfdd                	j	94 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1e>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x14>
  }
  return dst;
}
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strchr>:

char*
strchr(const char *s, char c)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf81                	beqz	a5,ea <strchr+0x24>
    if(*s == c)
  d4:	00f58763          	beq	a1,a5,e2 <strchr+0x1c>
  for(; *s; s++)
  d8:	0505                	addi	a0,a0,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbfd                	bnez	a5,d4 <strchr+0xe>
      return (char*)s;
  return 0;
  e0:	4501                	li	a0,0
}
  e2:	60a2                	ld	ra,8(sp)
  e4:	6402                	ld	s0,0(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  return 0;
  ea:	4501                	li	a0,0
  ec:	bfdd                	j	e2 <strchr+0x1c>

00000000000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	711d                	addi	sp,sp,-96
  f0:	ec86                	sd	ra,88(sp)
  f2:	e8a2                	sd	s0,80(sp)
  f4:	e4a6                	sd	s1,72(sp)
  f6:	e0ca                	sd	s2,64(sp)
  f8:	fc4e                	sd	s3,56(sp)
  fa:	f852                	sd	s4,48(sp)
  fc:	f456                	sd	s5,40(sp)
  fe:	f05a                	sd	s6,32(sp)
 100:	ec5e                	sd	s7,24(sp)
 102:	e862                	sd	s8,16(sp)
 104:	1080                	addi	s0,sp,96
 106:	8baa                	mv	s7,a0
 108:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10a:	892a                	mv	s2,a0
 10c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10e:	faf40b13          	addi	s6,s0,-81
 112:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 114:	8c26                	mv	s8,s1
 116:	0014899b          	addiw	s3,s1,1
 11a:	84ce                	mv	s1,s3
 11c:	0349d463          	bge	s3,s4,144 <gets+0x56>
    cc = read(0, &c, 1);
 120:	8656                	mv	a2,s5
 122:	85da                	mv	a1,s6
 124:	4501                	li	a0,0
 126:	190000ef          	jal	2b6 <read>
    if(cc < 1)
 12a:	00a05d63          	blez	a0,144 <gets+0x56>
      break;
    buf[i++] = c;
 12e:	faf44783          	lbu	a5,-81(s0)
 132:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 136:	0905                	addi	s2,s2,1
 138:	ff678713          	addi	a4,a5,-10
 13c:	c319                	beqz	a4,142 <gets+0x54>
 13e:	17cd                	addi	a5,a5,-13
 140:	fbf1                	bnez	a5,114 <gets+0x26>
    buf[i++] = c;
 142:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 144:	9c5e                	add	s8,s8,s7
 146:	000c0023          	sb	zero,0(s8)
  return buf;
}
 14a:	855e                	mv	a0,s7
 14c:	60e6                	ld	ra,88(sp)
 14e:	6446                	ld	s0,80(sp)
 150:	64a6                	ld	s1,72(sp)
 152:	6906                	ld	s2,64(sp)
 154:	79e2                	ld	s3,56(sp)
 156:	7a42                	ld	s4,48(sp)
 158:	7aa2                	ld	s5,40(sp)
 15a:	7b02                	ld	s6,32(sp)
 15c:	6be2                	ld	s7,24(sp)
 15e:	6c42                	ld	s8,16(sp)
 160:	6125                	addi	sp,sp,96
 162:	8082                	ret

0000000000000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	1101                	addi	sp,sp,-32
 166:	ec06                	sd	ra,24(sp)
 168:	e822                	sd	s0,16(sp)
 16a:	e04a                	sd	s2,0(sp)
 16c:	1000                	addi	s0,sp,32
 16e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	4581                	li	a1,0
 172:	194000ef          	jal	306 <open>
  if(fd < 0)
 176:	02054263          	bltz	a0,19a <stat+0x36>
 17a:	e426                	sd	s1,8(sp)
 17c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17e:	85ca                	mv	a1,s2
 180:	14e000ef          	jal	2ce <fstat>
 184:	892a                	mv	s2,a0
  close(fd);
 186:	8526                	mv	a0,s1
 188:	1ae000ef          	jal	336 <close>
  return r;
 18c:	64a2                	ld	s1,8(sp)
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	57fd                	li	a5,-1
 19c:	893e                	mv	s2,a5
 19e:	bfc5                	j	18e <stat+0x2a>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e406                	sd	ra,8(sp)
 1a4:	e022                	sd	s0,0(sp)
 1a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a8:	00054683          	lbu	a3,0(a0)
 1ac:	fd06879b          	addiw	a5,a3,-48
 1b0:	0ff7f793          	zext.b	a5,a5
 1b4:	4625                	li	a2,9
 1b6:	02f66963          	bltu	a2,a5,1e8 <atoi+0x48>
 1ba:	872a                	mv	a4,a0
  n = 0;
 1bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1be:	0705                	addi	a4,a4,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb5                	addw	a5,a5,a3
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	00074683          	lbu	a3,0(a4)
 1d4:	fd06879b          	addiw	a5,a3,-48
 1d8:	0ff7f793          	zext.b	a5,a5
 1dc:	fef671e3          	bgeu	a2,a5,1be <atoi+0x1e>
  return n;
}
 1e0:	60a2                	ld	ra,8(sp)
 1e2:	6402                	ld	s0,0(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfdd                	j	1e0 <atoi+0x40>

00000000000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f4:	02b57563          	bgeu	a0,a1,21e <memmove+0x32>
    while(n-- > 0)
 1f8:	00c05f63          	blez	a2,216 <memmove+0x2a>
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 204:	872a                	mv	a4,a0
      *dst++ = *src++;
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 212:	fee79ae3          	bne	a5,a4,206 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 216:	60a2                	ld	ra,8(sp)
 218:	6402                	ld	s0,0(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
    while(n-- > 0)
 21e:	fec05ce3          	blez	a2,216 <memmove+0x2a>
    dst += n;
 222:	00c50733          	add	a4,a0,a2
    src += n;
 226:	95b2                	add	a1,a1,a2
 228:	fff6079b          	addiw	a5,a2,-1
 22c:	1782                	slli	a5,a5,0x20
 22e:	9381                	srli	a5,a5,0x20
 230:	fff7c793          	not	a5,a5
 234:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 236:	15fd                	addi	a1,a1,-1
 238:	177d                	addi	a4,a4,-1
 23a:	0005c683          	lbu	a3,0(a1)
 23e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 242:	fef71ae3          	bne	a4,a5,236 <memmove+0x4a>
 246:	bfc1                	j	216 <memmove+0x2a>

0000000000000248 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 250:	c61d                	beqz	a2,27e <memcmp+0x36>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 266:	0505                	addi	a0,a0,1
    p2++;
 268:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x12>
  }
  return 0;
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x2e>
      return *p1 - *p2;
 272:	40e7853b          	subw	a0,a5,a4
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <memcmp+0x2e>

0000000000000282 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28a:	f63ff0ef          	jal	1ec <memmove>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 296:	4885                	li	a7,1
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <exit>:
.global exit
exit:
 li a7, SYS_exit
 29e:	4889                	li	a7,2
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a6:	488d                	li	a7,3
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ae:	4891                	li	a7,4
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <read>:
.global read
read:
 li a7, SYS_read
 2b6:	4895                	li	a7,5
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <kill>:
.global kill
kill:
 li a7, SYS_kill
 2be:	4899                	li	a7,6
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c6:	489d                	li	a7,7
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ce:	48a1                	li	a7,8
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2d6:	48a5                	li	a7,9
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <dup>:
.global dup
dup:
 li a7, SYS_dup
 2de:	48a9                	li	a7,10
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2e6:	48ad                	li	a7,11
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2ee:	48b1                	li	a7,12
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2f6:	48b5                	li	a7,13
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2fe:	48b9                	li	a7,14
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <write>:
.global write
write:
 li a7, SYS_write
 30e:	48c1                	li	a7,16
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 316:	48c5                	li	a7,17
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31e:	48c9                	li	a7,18
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 33e:	48d9                	li	a7,22
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 346:	48dd                	li	a7,23
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 34e:	48e1                	li	a7,24
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 356:	48e5                	li	a7,25
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35e:	1101                	addi	sp,sp,-32
 360:	ec06                	sd	ra,24(sp)
 362:	e822                	sd	s0,16(sp)
 364:	1000                	addi	s0,sp,32
 366:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36a:	4605                	li	a2,1
 36c:	fef40593          	addi	a1,s0,-17
 370:	f9fff0ef          	jal	30e <write>
}
 374:	60e2                	ld	ra,24(sp)
 376:	6442                	ld	s0,16(sp)
 378:	6105                	addi	sp,sp,32
 37a:	8082                	ret

000000000000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	7139                	addi	sp,sp,-64
 37e:	fc06                	sd	ra,56(sp)
 380:	f822                	sd	s0,48(sp)
 382:	f04a                	sd	s2,32(sp)
 384:	ec4e                	sd	s3,24(sp)
 386:	0080                	addi	s0,sp,64
 388:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	cac9                	beqz	a3,41c <printint+0xa0>
 38c:	01f5d79b          	srliw	a5,a1,0x1f
 390:	c7d1                	beqz	a5,41c <printint+0xa0>
    neg = 1;
    x = -xx;
 392:	40b005bb          	negw	a1,a1
    neg = 1;
 396:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 398:	fc040993          	addi	s3,s0,-64
  neg = 0;
 39c:	86ce                	mv	a3,s3
  i = 0;
 39e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a0:	00000817          	auipc	a6,0x0
 3a4:	50880813          	addi	a6,a6,1288 # 8a8 <digits>
 3a8:	88ba                	mv	a7,a4
 3aa:	0017051b          	addiw	a0,a4,1
 3ae:	872a                	mv	a4,a0
 3b0:	02c5f7bb          	remuw	a5,a1,a2
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	97c2                	add	a5,a5,a6
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c2:	87ae                	mv	a5,a1
 3c4:	02c5d5bb          	divuw	a1,a1,a2
 3c8:	0685                	addi	a3,a3,1
 3ca:	fcc7ffe3          	bgeu	a5,a2,3a8 <printint+0x2c>
  if(neg)
 3ce:	00030c63          	beqz	t1,3e6 <printint+0x6a>
    buf[i++] = '-';
 3d2:	fd050793          	addi	a5,a0,-48
 3d6:	00878533          	add	a0,a5,s0
 3da:	02d00793          	li	a5,45
 3de:	fef50823          	sb	a5,-16(a0)
 3e2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3e6:	02e05563          	blez	a4,410 <printint+0x94>
 3ea:	f426                	sd	s1,40(sp)
 3ec:	377d                	addiw	a4,a4,-1
 3ee:	00e984b3          	add	s1,s3,a4
 3f2:	19fd                	addi	s3,s3,-1
 3f4:	99ba                	add	s3,s3,a4
 3f6:	1702                	slli	a4,a4,0x20
 3f8:	9301                	srli	a4,a4,0x20
 3fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3fe:	0004c583          	lbu	a1,0(s1)
 402:	854a                	mv	a0,s2
 404:	f5bff0ef          	jal	35e <putc>
  while(--i >= 0)
 408:	14fd                	addi	s1,s1,-1
 40a:	ff349ae3          	bne	s1,s3,3fe <printint+0x82>
 40e:	74a2                	ld	s1,40(sp)
}
 410:	70e2                	ld	ra,56(sp)
 412:	7442                	ld	s0,48(sp)
 414:	7902                	ld	s2,32(sp)
 416:	69e2                	ld	s3,24(sp)
 418:	6121                	addi	sp,sp,64
 41a:	8082                	ret
  neg = 0;
 41c:	4301                	li	t1,0
 41e:	bfad                	j	398 <printint+0x1c>

0000000000000420 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 420:	711d                	addi	sp,sp,-96
 422:	ec86                	sd	ra,88(sp)
 424:	e8a2                	sd	s0,80(sp)
 426:	e4a6                	sd	s1,72(sp)
 428:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42a:	0005c483          	lbu	s1,0(a1)
 42e:	20048963          	beqz	s1,640 <vprintf+0x220>
 432:	e0ca                	sd	s2,64(sp)
 434:	fc4e                	sd	s3,56(sp)
 436:	f852                	sd	s4,48(sp)
 438:	f456                	sd	s5,40(sp)
 43a:	f05a                	sd	s6,32(sp)
 43c:	ec5e                	sd	s7,24(sp)
 43e:	e862                	sd	s8,16(sp)
 440:	8b2a                	mv	s6,a0
 442:	8a2e                	mv	s4,a1
 444:	8bb2                	mv	s7,a2
  state = 0;
 446:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 448:	4901                	li	s2,0
 44a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 44c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 450:	06400c13          	li	s8,100
 454:	a00d                	j	476 <vprintf+0x56>
        putc(fd, c0);
 456:	85a6                	mv	a1,s1
 458:	855a                	mv	a0,s6
 45a:	f05ff0ef          	jal	35e <putc>
 45e:	a019                	j	464 <vprintf+0x44>
    } else if(state == '%'){
 460:	03598363          	beq	s3,s5,486 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 464:	0019079b          	addiw	a5,s2,1
 468:	893e                	mv	s2,a5
 46a:	873e                	mv	a4,a5
 46c:	97d2                	add	a5,a5,s4
 46e:	0007c483          	lbu	s1,0(a5)
 472:	1c048063          	beqz	s1,632 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 476:	0004879b          	sext.w	a5,s1
    if(state == 0){
 47a:	fe0993e3          	bnez	s3,460 <vprintf+0x40>
      if(c0 == '%'){
 47e:	fd579ce3          	bne	a5,s5,456 <vprintf+0x36>
        state = '%';
 482:	89be                	mv	s3,a5
 484:	b7c5                	j	464 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 486:	00ea06b3          	add	a3,s4,a4
 48a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 48e:	1a060e63          	beqz	a2,64a <vprintf+0x22a>
      if(c0 == 'd'){
 492:	03878763          	beq	a5,s8,4c0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 496:	f9478693          	addi	a3,a5,-108
 49a:	0016b693          	seqz	a3,a3
 49e:	f9c60593          	addi	a1,a2,-100
 4a2:	e99d                	bnez	a1,4d8 <vprintf+0xb8>
 4a4:	ca95                	beqz	a3,4d8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4a6:	008b8493          	addi	s1,s7,8
 4aa:	4685                	li	a3,1
 4ac:	4629                	li	a2,10
 4ae:	000ba583          	lw	a1,0(s7)
 4b2:	855a                	mv	a0,s6
 4b4:	ec9ff0ef          	jal	37c <printint>
        i += 1;
 4b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ba:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b75d                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4c0:	008b8493          	addi	s1,s7,8
 4c4:	4685                	li	a3,1
 4c6:	4629                	li	a2,10
 4c8:	000ba583          	lw	a1,0(s7)
 4cc:	855a                	mv	a0,s6
 4ce:	eafff0ef          	jal	37c <printint>
 4d2:	8ba6                	mv	s7,s1
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	b779                	j	464 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4d8:	9752                	add	a4,a4,s4
 4da:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4de:	f9460713          	addi	a4,a2,-108
 4e2:	00173713          	seqz	a4,a4
 4e6:	8f75                	and	a4,a4,a3
 4e8:	f9c58513          	addi	a0,a1,-100
 4ec:	16051963          	bnez	a0,65e <vprintf+0x23e>
 4f0:	16070763          	beqz	a4,65e <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f4:	008b8493          	addi	s1,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	e7bff0ef          	jal	37c <printint>
        i += 2;
 506:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	8ba6                	mv	s7,s1
      state = 0;
 50a:	4981                	li	s3,0
        i += 2;
 50c:	bfa1                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 50e:	008b8493          	addi	s1,s7,8
 512:	4681                	li	a3,0
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	e61ff0ef          	jal	37c <printint>
 520:	8ba6                	mv	s7,s1
      state = 0;
 522:	4981                	li	s3,0
 524:	b781                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 526:	008b8493          	addi	s1,s7,8
 52a:	4681                	li	a3,0
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	e49ff0ef          	jal	37c <printint>
        i += 1;
 538:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 53a:	8ba6                	mv	s7,s1
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b71d                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 540:	008b8493          	addi	s1,s7,8
 544:	4681                	li	a3,0
 546:	4629                	li	a2,10
 548:	000ba583          	lw	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e2fff0ef          	jal	37c <printint>
        i += 2;
 552:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
        i += 2;
 558:	b731                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4681                	li	a3,0
 560:	4641                	li	a2,16
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e15ff0ef          	jal	37c <printint>
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	bdd5                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4641                	li	a2,16
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	dfdff0ef          	jal	37c <printint>
        i += 1;
 584:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	bde9                	j	464 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	de3ff0ef          	jal	37c <printint>
        i += 2;
 59e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	b5c1                	j	464 <vprintf+0x44>
 5a6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5a8:	008b8793          	addi	a5,s7,8
 5ac:	8cbe                	mv	s9,a5
 5ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b2:	03000593          	li	a1,48
 5b6:	855a                	mv	a0,s6
 5b8:	da7ff0ef          	jal	35e <putc>
  putc(fd, 'x');
 5bc:	07800593          	li	a1,120
 5c0:	855a                	mv	a0,s6
 5c2:	d9dff0ef          	jal	35e <putc>
 5c6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	2e0b8b93          	addi	s7,s7,736 # 8a8 <digits>
 5d0:	03c9d793          	srli	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	855a                	mv	a0,s6
 5dc:	d83ff0ef          	jal	35e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e0:	0992                	slli	s3,s3,0x4
 5e2:	34fd                	addiw	s1,s1,-1
 5e4:	f4f5                	bnez	s1,5d0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5e6:	8be6                	mv	s7,s9
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	6ca2                	ld	s9,8(sp)
 5ec:	bda5                	j	464 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 5ee:	008b8993          	addi	s3,s7,8
 5f2:	000bb483          	ld	s1,0(s7)
 5f6:	cc91                	beqz	s1,612 <vprintf+0x1f2>
        for(; *s; s++)
 5f8:	0004c583          	lbu	a1,0(s1)
 5fc:	c985                	beqz	a1,62c <vprintf+0x20c>
          putc(fd, *s);
 5fe:	855a                	mv	a0,s6
 600:	d5fff0ef          	jal	35e <putc>
        for(; *s; s++)
 604:	0485                	addi	s1,s1,1
 606:	0004c583          	lbu	a1,0(s1)
 60a:	f9f5                	bnez	a1,5fe <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 60c:	8bce                	mv	s7,s3
      state = 0;
 60e:	4981                	li	s3,0
 610:	bd91                	j	464 <vprintf+0x44>
          s = "(null)";
 612:	00000497          	auipc	s1,0x0
 616:	28e48493          	addi	s1,s1,654 # 8a0 <malloc+0xfa>
        for(; *s; s++)
 61a:	02800593          	li	a1,40
 61e:	b7c5                	j	5fe <vprintf+0x1de>
        putc(fd, '%');
 620:	85be                	mv	a1,a5
 622:	855a                	mv	a0,s6
 624:	d3bff0ef          	jal	35e <putc>
      state = 0;
 628:	4981                	li	s3,0
 62a:	bd2d                	j	464 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 62c:	8bce                	mv	s7,s3
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd15                	j	464 <vprintf+0x44>
 632:	6906                	ld	s2,64(sp)
 634:	79e2                	ld	s3,56(sp)
 636:	7a42                	ld	s4,48(sp)
 638:	7aa2                	ld	s5,40(sp)
 63a:	7b02                	ld	s6,32(sp)
 63c:	6be2                	ld	s7,24(sp)
 63e:	6c42                	ld	s8,16(sp)
    }
  }
}
 640:	60e6                	ld	ra,88(sp)
 642:	6446                	ld	s0,80(sp)
 644:	64a6                	ld	s1,72(sp)
 646:	6125                	addi	sp,sp,96
 648:	8082                	ret
      if(c0 == 'd'){
 64a:	06400713          	li	a4,100
 64e:	e6e789e3          	beq	a5,a4,4c0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 652:	f9478693          	addi	a3,a5,-108
 656:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 65a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65c:	4701                	li	a4,0
      } else if(c0 == 'u'){
 65e:	07500513          	li	a0,117
 662:	eaa786e3          	beq	a5,a0,50e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 666:	f8b60513          	addi	a0,a2,-117
 66a:	e119                	bnez	a0,670 <vprintf+0x250>
 66c:	ea069de3          	bnez	a3,526 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 670:	f8b58513          	addi	a0,a1,-117
 674:	e119                	bnez	a0,67a <vprintf+0x25a>
 676:	ec0715e3          	bnez	a4,540 <vprintf+0x120>
      } else if(c0 == 'x'){
 67a:	07800513          	li	a0,120
 67e:	eca78ee3          	beq	a5,a0,55a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 682:	f8860613          	addi	a2,a2,-120
 686:	e219                	bnez	a2,68c <vprintf+0x26c>
 688:	ee0695e3          	bnez	a3,572 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 68c:	f8858593          	addi	a1,a1,-120
 690:	e199                	bnez	a1,696 <vprintf+0x276>
 692:	ee071de3          	bnez	a4,58c <vprintf+0x16c>
      } else if(c0 == 'p'){
 696:	07000713          	li	a4,112
 69a:	f0e786e3          	beq	a5,a4,5a6 <vprintf+0x186>
      } else if(c0 == 's'){
 69e:	07300713          	li	a4,115
 6a2:	f4e786e3          	beq	a5,a4,5ee <vprintf+0x1ce>
      } else if(c0 == '%'){
 6a6:	02500713          	li	a4,37
 6aa:	f6e78be3          	beq	a5,a4,620 <vprintf+0x200>
        putc(fd, '%');
 6ae:	02500593          	li	a1,37
 6b2:	855a                	mv	a0,s6
 6b4:	cabff0ef          	jal	35e <putc>
        putc(fd, c0);
 6b8:	85a6                	mv	a1,s1
 6ba:	855a                	mv	a0,s6
 6bc:	ca3ff0ef          	jal	35e <putc>
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b34d                	j	464 <vprintf+0x44>

00000000000006c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c4:	715d                	addi	sp,sp,-80
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e010                	sd	a2,0(s0)
 6ce:	e414                	sd	a3,8(s0)
 6d0:	e818                	sd	a4,16(s0)
 6d2:	ec1c                	sd	a5,24(s0)
 6d4:	03043023          	sd	a6,32(s0)
 6d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	8622                	mv	a2,s0
 6de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e2:	d3fff0ef          	jal	420 <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6161                	addi	sp,sp,80
 6ec:	8082                	ret

00000000000006ee <printf>:

void
printf(const char *fmt, ...)
{
 6ee:	711d                	addi	sp,sp,-96
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e40c                	sd	a1,8(s0)
 6f8:	e810                	sd	a2,16(s0)
 6fa:	ec14                	sd	a3,24(s0)
 6fc:	f018                	sd	a4,32(s0)
 6fe:	f41c                	sd	a5,40(s0)
 700:	03043823          	sd	a6,48(s0)
 704:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	00840613          	addi	a2,s0,8
 70c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 710:	85aa                	mv	a1,a0
 712:	4505                	li	a0,1
 714:	d0dff0ef          	jal	420 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6125                	addi	sp,sp,96
 71e:	8082                	ret

0000000000000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	1141                	addi	sp,sp,-16
 722:	e406                	sd	ra,8(sp)
 724:	e022                	sd	s0,0(sp)
 726:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 728:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	00001797          	auipc	a5,0x1
 730:	8d47b783          	ld	a5,-1836(a5) # 1000 <freep>
 734:	a039                	j	742 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	6398                	ld	a4,0(a5)
 738:	00e7e463          	bltu	a5,a4,740 <free+0x20>
 73c:	00e6ea63          	bltu	a3,a4,750 <free+0x30>
{
 740:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	fed7fae3          	bgeu	a5,a3,736 <free+0x16>
 746:	6398                	ld	a4,0(a5)
 748:	00e6e463          	bltu	a3,a4,750 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	fee7eae3          	bltu	a5,a4,740 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 750:	ff852583          	lw	a1,-8(a0)
 754:	6390                	ld	a2,0(a5)
 756:	02059813          	slli	a6,a1,0x20
 75a:	01c85713          	srli	a4,a6,0x1c
 75e:	9736                	add	a4,a4,a3
 760:	02e60563          	beq	a2,a4,78a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 768:	4790                	lw	a2,8(a5)
 76a:	02061593          	slli	a1,a2,0x20
 76e:	01c5d713          	srli	a4,a1,0x1c
 772:	973e                	add	a4,a4,a5
 774:	02e68263          	beq	a3,a4,798 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 778:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77a:	00001717          	auipc	a4,0x1
 77e:	88f73323          	sd	a5,-1914(a4) # 1000 <freep>
}
 782:	60a2                	ld	ra,8(sp)
 784:	6402                	ld	s0,0(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 78a:	4618                	lw	a4,8(a2)
 78c:	9f2d                	addw	a4,a4,a1
 78e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	6398                	ld	a4,0(a5)
 794:	6310                	ld	a2,0(a4)
 796:	b7f9                	j	764 <free+0x44>
    p->s.size += bp->s.size;
 798:	ff852703          	lw	a4,-8(a0)
 79c:	9f31                	addw	a4,a4,a2
 79e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a0:	ff053683          	ld	a3,-16(a0)
 7a4:	bfd1                	j	778 <free+0x58>

00000000000007a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a6:	7139                	addi	sp,sp,-64
 7a8:	fc06                	sd	ra,56(sp)
 7aa:	f822                	sd	s0,48(sp)
 7ac:	f04a                	sd	s2,32(sp)
 7ae:	ec4e                	sd	s3,24(sp)
 7b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	02051993          	slli	s3,a0,0x20
 7b6:	0209d993          	srli	s3,s3,0x20
 7ba:	09bd                	addi	s3,s3,15
 7bc:	0049d993          	srli	s3,s3,0x4
 7c0:	2985                	addiw	s3,s3,1
 7c2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c4:	00001517          	auipc	a0,0x1
 7c8:	83c53503          	ld	a0,-1988(a0) # 1000 <freep>
 7cc:	c905                	beqz	a0,7fc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	09377663          	bgeu	a4,s3,85e <malloc+0xb8>
 7d6:	f426                	sd	s1,40(sp)
 7d8:	e852                	sd	s4,16(sp)
 7da:	e456                	sd	s5,8(sp)
 7dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7de:	8a4e                	mv	s4,s3
 7e0:	6705                	lui	a4,0x1
 7e2:	00e9f363          	bgeu	s3,a4,7e8 <malloc+0x42>
 7e6:	6a05                	lui	s4,0x1
 7e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f0:	00001497          	auipc	s1,0x1
 7f4:	81048493          	addi	s1,s1,-2032 # 1000 <freep>
  if(p == (char*)-1)
 7f8:	5afd                	li	s5,-1
 7fa:	a83d                	j	838 <malloc+0x92>
 7fc:	f426                	sd	s1,40(sp)
 7fe:	e852                	sd	s4,16(sp)
 800:	e456                	sd	s5,8(sp)
 802:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 804:	00001797          	auipc	a5,0x1
 808:	80c78793          	addi	a5,a5,-2036 # 1010 <base>
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
 814:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 816:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81a:	b7d1                	j	7de <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	e118                	sd	a4,0(a0)
 820:	a899                	j	876 <malloc+0xd0>
  hp->s.size = nu;
 822:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 826:	0541                	addi	a0,a0,16
 828:	ef9ff0ef          	jal	720 <free>
  return freep;
 82c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82e:	c125                	beqz	a0,88e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	03277163          	bgeu	a4,s2,856 <malloc+0xb0>
    if(p == freep)
 838:	6098                	ld	a4,0(s1)
 83a:	853e                	mv	a0,a5
 83c:	fef71ae3          	bne	a4,a5,830 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 840:	8552                	mv	a0,s4
 842:	aadff0ef          	jal	2ee <sbrk>
  if(p == (char*)-1)
 846:	fd551ee3          	bne	a0,s5,822 <malloc+0x7c>
        return 0;
 84a:	4501                	li	a0,0
 84c:	74a2                	ld	s1,40(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
 854:	a03d                	j	882 <malloc+0xdc>
 856:	74a2                	ld	s1,40(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85e:	fae90fe3          	beq	s2,a4,81c <malloc+0x76>
        p->s.size -= nunits;
 862:	4137073b          	subw	a4,a4,s3
 866:	c798                	sw	a4,8(a5)
        p += p->s.size;
 868:	02071693          	slli	a3,a4,0x20
 86c:	01c6d713          	srli	a4,a3,0x1c
 870:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 872:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 876:	00000717          	auipc	a4,0x0
 87a:	78a73523          	sd	a0,1930(a4) # 1000 <freep>
      return (void*)(p + 1);
 87e:	01078513          	addi	a0,a5,16
  }
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	7902                	ld	s2,32(sp)
 888:	69e2                	ld	s3,24(sp)
 88a:	6121                	addi	sp,sp,64
 88c:	8082                	ret
 88e:	74a2                	ld	s1,40(sp)
 890:	6a42                	ld	s4,16(sp)
 892:	6aa2                	ld	s5,8(sp)
 894:	6b02                	ld	s6,0(sp)
 896:	b7f5                	j	882 <malloc+0xdc>
