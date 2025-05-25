
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	29a000ef          	jal	2a2 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	298000ef          	jal	2aa <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	2ea000ef          	jal	302 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	27e000ef          	jal	2aa <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf91                	beqz	a5,a8 <strlen+0x28>
  8e:	00150793          	addi	a5,a0,1
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for(n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfdd                	j	a0 <strlen+0x20>

00000000000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1e>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x14>
  }
  return dst;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char*
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf81                	beqz	a5,f6 <strchr+0x24>
    if(*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1c>
  for(; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xe>
      return (char*)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfdd                	j	ee <strchr+0x1c>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	addi	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	e862                	sd	s8,16(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11a:	faf40b13          	addi	s6,s0,-81
 11e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 120:	8c26                	mv	s8,s1
 122:	0014899b          	addiw	s3,s1,1
 126:	84ce                	mv	s1,s3
 128:	0349d463          	bge	s3,s4,150 <gets+0x56>
    cc = read(0, &c, 1);
 12c:	8656                	mv	a2,s5
 12e:	85da                	mv	a1,s6
 130:	4501                	li	a0,0
 132:	190000ef          	jal	2c2 <read>
    if(cc < 1)
 136:	00a05d63          	blez	a0,150 <gets+0x56>
      break;
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	0905                	addi	s2,s2,1
 144:	ff678713          	addi	a4,a5,-10
 148:	c319                	beqz	a4,14e <gets+0x54>
 14a:	17cd                	addi	a5,a5,-13
 14c:	fbf1                	bnez	a5,120 <gets+0x26>
    buf[i++] = c;
 14e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 150:	9c5e                	add	s8,s8,s7
 152:	000c0023          	sb	zero,0(s8)
  return buf;
}
 156:	855e                	mv	a0,s7
 158:	60e6                	ld	ra,88(sp)
 15a:	6446                	ld	s0,80(sp)
 15c:	64a6                	ld	s1,72(sp)
 15e:	6906                	ld	s2,64(sp)
 160:	79e2                	ld	s3,56(sp)
 162:	7a42                	ld	s4,48(sp)
 164:	7aa2                	ld	s5,40(sp)
 166:	7b02                	ld	s6,32(sp)
 168:	6be2                	ld	s7,24(sp)
 16a:	6c42                	ld	s8,16(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	194000ef          	jal	312 <open>
  if(fd < 0)
 182:	02054263          	bltz	a0,1a6 <stat+0x36>
 186:	e426                	sd	s1,8(sp)
 188:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18a:	85ca                	mv	a1,s2
 18c:	14e000ef          	jal	2da <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	1ae000ef          	jal	342 <close>
  return r;
 198:	64a2                	ld	s1,8(sp)
}
 19a:	854a                	mv	a0,s2
 19c:	60e2                	ld	ra,24(sp)
 19e:	6442                	ld	s0,16(sp)
 1a0:	6902                	ld	s2,0(sp)
 1a2:	6105                	addi	sp,sp,32
 1a4:	8082                	ret
    return -1;
 1a6:	57fd                	li	a5,-1
 1a8:	893e                	mv	s2,a5
 1aa:	bfc5                	j	19a <stat+0x2a>

00000000000001ac <atoi>:

int
atoi(const char *s)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b4:	00054683          	lbu	a3,0(a0)
 1b8:	fd06879b          	addiw	a5,a3,-48
 1bc:	0ff7f793          	zext.b	a5,a5
 1c0:	4625                	li	a2,9
 1c2:	02f66963          	bltu	a2,a5,1f4 <atoi+0x48>
 1c6:	872a                	mv	a4,a0
  n = 0;
 1c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ca:	0705                	addi	a4,a4,1
 1cc:	0025179b          	slliw	a5,a0,0x2
 1d0:	9fa9                	addw	a5,a5,a0
 1d2:	0017979b          	slliw	a5,a5,0x1
 1d6:	9fb5                	addw	a5,a5,a3
 1d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1dc:	00074683          	lbu	a3,0(a4)
 1e0:	fd06879b          	addiw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	fef671e3          	bgeu	a2,a5,1ca <atoi+0x1e>
  return n;
}
 1ec:	60a2                	ld	ra,8(sp)
 1ee:	6402                	ld	s0,0(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfdd                	j	1ec <atoi+0x40>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 200:	02b57563          	bgeu	a0,a1,22a <memmove+0x32>
    while(n-- > 0)
 204:	00c05f63          	blez	a2,222 <memmove+0x2a>
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 210:	872a                	mv	a4,a0
      *dst++ = *src++;
 212:	0585                	addi	a1,a1,1
 214:	0705                	addi	a4,a4,1
 216:	fff5c683          	lbu	a3,-1(a1)
 21a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21e:	fee79ae3          	bne	a5,a4,212 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 222:	60a2                	ld	ra,8(sp)
 224:	6402                	ld	s0,0(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
    while(n-- > 0)
 22a:	fec05ce3          	blez	a2,222 <memmove+0x2a>
    dst += n;
 22e:	00c50733          	add	a4,a0,a2
    src += n;
 232:	95b2                	add	a1,a1,a2
 234:	fff6079b          	addiw	a5,a2,-1
 238:	1782                	slli	a5,a5,0x20
 23a:	9381                	srli	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	addi	a1,a1,-1
 244:	177d                	addi	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24e:	fef71ae3          	bne	a4,a5,242 <memmove+0x4a>
 252:	bfc1                	j	222 <memmove+0x2a>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	c61d                	beqz	a2,28a <memcmp+0x36>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 266:	00054783          	lbu	a5,0(a0)
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00e79863          	bne	a5,a4,27e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 272:	0505                	addi	a0,a0,1
    p2++;
 274:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 276:	fed518e3          	bne	a0,a3,266 <memcmp+0x12>
  }
  return 0;
 27a:	4501                	li	a0,0
 27c:	a019                	j	282 <memcmp+0x2e>
      return *p1 - *p2;
 27e:	40e7853b          	subw	a0,a5,a4
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  return 0;
 28a:	4501                	li	a0,0
 28c:	bfdd                	j	282 <memcmp+0x2e>

000000000000028e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 296:	f63ff0ef          	jal	1f8 <memmove>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a2:	4885                	li	a7,1
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2aa:	4889                	li	a7,2
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b2:	488d                	li	a7,3
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ba:	4891                	li	a7,4
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <read>:
.global read
read:
 li a7, SYS_read
 2c2:	4895                	li	a7,5
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ca:	4899                	li	a7,6
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d2:	489d                	li	a7,7
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2da:	48a1                	li	a7,8
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2e2:	48a5                	li	a7,9
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 2ea:	48a9                	li	a7,10
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2f2:	48ad                	li	a7,11
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2fa:	48b1                	li	a7,12
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 302:	48b5                	li	a7,13
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 30a:	48b9                	li	a7,14
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <open>:
.global open
open:
 li a7, SYS_open
 312:	48bd                	li	a7,15
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <write>:
.global write
write:
 li a7, SYS_write
 31a:	48c1                	li	a7,16
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 322:	48c5                	li	a7,17
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32a:	48c9                	li	a7,18
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <link>:
.global link
link:
 li a7, SYS_link
 332:	48cd                	li	a7,19
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33a:	48d1                	li	a7,20
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <close>:
.global close
close:
 li a7, SYS_close
 342:	48d5                	li	a7,21
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 34a:	48d9                	li	a7,22
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 352:	48dd                	li	a7,23
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 35a:	48e1                	li	a7,24
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	addi	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	addi	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	addi	a1,s0,-17
 374:	fa7ff0ef          	jal	31a <write>
}
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	6105                	addi	sp,sp,32
 37e:	8082                	ret

0000000000000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	7139                	addi	sp,sp,-64
 382:	fc06                	sd	ra,56(sp)
 384:	f822                	sd	s0,48(sp)
 386:	f04a                	sd	s2,32(sp)
 388:	ec4e                	sd	s3,24(sp)
 38a:	0080                	addi	s0,sp,64
 38c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	cac9                	beqz	a3,420 <printint+0xa0>
 390:	01f5d79b          	srliw	a5,a1,0x1f
 394:	c7d1                	beqz	a5,420 <printint+0xa0>
    neg = 1;
    x = -xx;
 396:	40b005bb          	negw	a1,a1
    neg = 1;
 39a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 39c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3a0:	86ce                	mv	a3,s3
  i = 0;
 3a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a4:	00000817          	auipc	a6,0x0
 3a8:	50480813          	addi	a6,a6,1284 # 8a8 <digits>
 3ac:	88ba                	mv	a7,a4
 3ae:	0017051b          	addiw	a0,a4,1
 3b2:	872a                	mv	a4,a0
 3b4:	02c5f7bb          	remuw	a5,a1,a2
 3b8:	1782                	slli	a5,a5,0x20
 3ba:	9381                	srli	a5,a5,0x20
 3bc:	97c2                	add	a5,a5,a6
 3be:	0007c783          	lbu	a5,0(a5)
 3c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c6:	87ae                	mv	a5,a1
 3c8:	02c5d5bb          	divuw	a1,a1,a2
 3cc:	0685                	addi	a3,a3,1
 3ce:	fcc7ffe3          	bgeu	a5,a2,3ac <printint+0x2c>
  if(neg)
 3d2:	00030c63          	beqz	t1,3ea <printint+0x6a>
    buf[i++] = '-';
 3d6:	fd050793          	addi	a5,a0,-48
 3da:	00878533          	add	a0,a5,s0
 3de:	02d00793          	li	a5,45
 3e2:	fef50823          	sb	a5,-16(a0)
 3e6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3ea:	02e05563          	blez	a4,414 <printint+0x94>
 3ee:	f426                	sd	s1,40(sp)
 3f0:	377d                	addiw	a4,a4,-1
 3f2:	00e984b3          	add	s1,s3,a4
 3f6:	19fd                	addi	s3,s3,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	1702                	slli	a4,a4,0x20
 3fc:	9301                	srli	a4,a4,0x20
 3fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 402:	0004c583          	lbu	a1,0(s1)
 406:	854a                	mv	a0,s2
 408:	f5bff0ef          	jal	362 <putc>
  while(--i >= 0)
 40c:	14fd                	addi	s1,s1,-1
 40e:	ff349ae3          	bne	s1,s3,402 <printint+0x82>
 412:	74a2                	ld	s1,40(sp)
}
 414:	70e2                	ld	ra,56(sp)
 416:	7442                	ld	s0,48(sp)
 418:	7902                	ld	s2,32(sp)
 41a:	69e2                	ld	s3,24(sp)
 41c:	6121                	addi	sp,sp,64
 41e:	8082                	ret
  neg = 0;
 420:	4301                	li	t1,0
 422:	bfad                	j	39c <printint+0x1c>

0000000000000424 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 424:	711d                	addi	sp,sp,-96
 426:	ec86                	sd	ra,88(sp)
 428:	e8a2                	sd	s0,80(sp)
 42a:	e4a6                	sd	s1,72(sp)
 42c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42e:	0005c483          	lbu	s1,0(a1)
 432:	20048963          	beqz	s1,644 <vprintf+0x220>
 436:	e0ca                	sd	s2,64(sp)
 438:	fc4e                	sd	s3,56(sp)
 43a:	f852                	sd	s4,48(sp)
 43c:	f456                	sd	s5,40(sp)
 43e:	f05a                	sd	s6,32(sp)
 440:	ec5e                	sd	s7,24(sp)
 442:	e862                	sd	s8,16(sp)
 444:	8b2a                	mv	s6,a0
 446:	8a2e                	mv	s4,a1
 448:	8bb2                	mv	s7,a2
  state = 0;
 44a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 44c:	4901                	li	s2,0
 44e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 450:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 454:	06400c13          	li	s8,100
 458:	a00d                	j	47a <vprintf+0x56>
        putc(fd, c0);
 45a:	85a6                	mv	a1,s1
 45c:	855a                	mv	a0,s6
 45e:	f05ff0ef          	jal	362 <putc>
 462:	a019                	j	468 <vprintf+0x44>
    } else if(state == '%'){
 464:	03598363          	beq	s3,s5,48a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 468:	0019079b          	addiw	a5,s2,1
 46c:	893e                	mv	s2,a5
 46e:	873e                	mv	a4,a5
 470:	97d2                	add	a5,a5,s4
 472:	0007c483          	lbu	s1,0(a5)
 476:	1c048063          	beqz	s1,636 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 47a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 47e:	fe0993e3          	bnez	s3,464 <vprintf+0x40>
      if(c0 == '%'){
 482:	fd579ce3          	bne	a5,s5,45a <vprintf+0x36>
        state = '%';
 486:	89be                	mv	s3,a5
 488:	b7c5                	j	468 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 48a:	00ea06b3          	add	a3,s4,a4
 48e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 492:	1a060e63          	beqz	a2,64e <vprintf+0x22a>
      if(c0 == 'd'){
 496:	03878763          	beq	a5,s8,4c4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 49a:	f9478693          	addi	a3,a5,-108
 49e:	0016b693          	seqz	a3,a3
 4a2:	f9c60593          	addi	a1,a2,-100
 4a6:	e99d                	bnez	a1,4dc <vprintf+0xb8>
 4a8:	ca95                	beqz	a3,4dc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4aa:	008b8493          	addi	s1,s7,8
 4ae:	4685                	li	a3,1
 4b0:	4629                	li	a2,10
 4b2:	000ba583          	lw	a1,0(s7)
 4b6:	855a                	mv	a0,s6
 4b8:	ec9ff0ef          	jal	380 <printint>
        i += 1;
 4bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4be:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	b75d                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4c4:	008b8493          	addi	s1,s7,8
 4c8:	4685                	li	a3,1
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	855a                	mv	a0,s6
 4d2:	eafff0ef          	jal	380 <printint>
 4d6:	8ba6                	mv	s7,s1
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b779                	j	468 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4dc:	9752                	add	a4,a4,s4
 4de:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e2:	f9460713          	addi	a4,a2,-108
 4e6:	00173713          	seqz	a4,a4
 4ea:	8f75                	and	a4,a4,a3
 4ec:	f9c58513          	addi	a0,a1,-100
 4f0:	16051963          	bnez	a0,662 <vprintf+0x23e>
 4f4:	16070763          	beqz	a4,662 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f8:	008b8493          	addi	s1,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000ba583          	lw	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	e7bff0ef          	jal	380 <printint>
        i += 2;
 50a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	8ba6                	mv	s7,s1
      state = 0;
 50e:	4981                	li	s3,0
        i += 2;
 510:	bfa1                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 512:	008b8493          	addi	s1,s7,8
 516:	4681                	li	a3,0
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	e61ff0ef          	jal	380 <printint>
 524:	8ba6                	mv	s7,s1
      state = 0;
 526:	4981                	li	s3,0
 528:	b781                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52a:	008b8493          	addi	s1,s7,8
 52e:	4681                	li	a3,0
 530:	4629                	li	a2,10
 532:	000ba583          	lw	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e49ff0ef          	jal	380 <printint>
        i += 1;
 53c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 53e:	8ba6                	mv	s7,s1
      state = 0;
 540:	4981                	li	s3,0
 542:	b71d                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 544:	008b8493          	addi	s1,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e2fff0ef          	jal	380 <printint>
        i += 2;
 556:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	8ba6                	mv	s7,s1
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	b731                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 55e:	008b8493          	addi	s1,s7,8
 562:	4681                	li	a3,0
 564:	4641                	li	a2,16
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	e15ff0ef          	jal	380 <printint>
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
 574:	bdd5                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4641                	li	a2,16
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	dfdff0ef          	jal	380 <printint>
        i += 1;
 588:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bde9                	j	468 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	008b8493          	addi	s1,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	de3ff0ef          	jal	380 <printint>
        i += 2;
 5a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	b5c1                	j	468 <vprintf+0x44>
 5aa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5ac:	008b8793          	addi	a5,s7,8
 5b0:	8cbe                	mv	s9,a5
 5b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b6:	03000593          	li	a1,48
 5ba:	855a                	mv	a0,s6
 5bc:	da7ff0ef          	jal	362 <putc>
  putc(fd, 'x');
 5c0:	07800593          	li	a1,120
 5c4:	855a                	mv	a0,s6
 5c6:	d9dff0ef          	jal	362 <putc>
 5ca:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5cc:	00000b97          	auipc	s7,0x0
 5d0:	2dcb8b93          	addi	s7,s7,732 # 8a8 <digits>
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	855a                	mv	a0,s6
 5e0:	d83ff0ef          	jal	362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	slli	s3,s3,0x4
 5e6:	34fd                	addiw	s1,s1,-1
 5e8:	f4f5                	bnez	s1,5d4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5ea:	8be6                	mv	s7,s9
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	6ca2                	ld	s9,8(sp)
 5f0:	bda5                	j	468 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 5f2:	008b8993          	addi	s3,s7,8
 5f6:	000bb483          	ld	s1,0(s7)
 5fa:	cc91                	beqz	s1,616 <vprintf+0x1f2>
        for(; *s; s++)
 5fc:	0004c583          	lbu	a1,0(s1)
 600:	c985                	beqz	a1,630 <vprintf+0x20c>
          putc(fd, *s);
 602:	855a                	mv	a0,s6
 604:	d5fff0ef          	jal	362 <putc>
        for(; *s; s++)
 608:	0485                	addi	s1,s1,1
 60a:	0004c583          	lbu	a1,0(s1)
 60e:	f9f5                	bnez	a1,602 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 610:	8bce                	mv	s7,s3
      state = 0;
 612:	4981                	li	s3,0
 614:	bd91                	j	468 <vprintf+0x44>
          s = "(null)";
 616:	00000497          	auipc	s1,0x0
 61a:	28a48493          	addi	s1,s1,650 # 8a0 <malloc+0xf6>
        for(; *s; s++)
 61e:	02800593          	li	a1,40
 622:	b7c5                	j	602 <vprintf+0x1de>
        putc(fd, '%');
 624:	85be                	mv	a1,a5
 626:	855a                	mv	a0,s6
 628:	d3bff0ef          	jal	362 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bd2d                	j	468 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 630:	8bce                	mv	s7,s3
      state = 0;
 632:	4981                	li	s3,0
 634:	bd15                	j	468 <vprintf+0x44>
 636:	6906                	ld	s2,64(sp)
 638:	79e2                	ld	s3,56(sp)
 63a:	7a42                	ld	s4,48(sp)
 63c:	7aa2                	ld	s5,40(sp)
 63e:	7b02                	ld	s6,32(sp)
 640:	6be2                	ld	s7,24(sp)
 642:	6c42                	ld	s8,16(sp)
    }
  }
}
 644:	60e6                	ld	ra,88(sp)
 646:	6446                	ld	s0,80(sp)
 648:	64a6                	ld	s1,72(sp)
 64a:	6125                	addi	sp,sp,96
 64c:	8082                	ret
      if(c0 == 'd'){
 64e:	06400713          	li	a4,100
 652:	e6e789e3          	beq	a5,a4,4c4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 656:	f9478693          	addi	a3,a5,-108
 65a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 65e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 660:	4701                	li	a4,0
      } else if(c0 == 'u'){
 662:	07500513          	li	a0,117
 666:	eaa786e3          	beq	a5,a0,512 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 66a:	f8b60513          	addi	a0,a2,-117
 66e:	e119                	bnez	a0,674 <vprintf+0x250>
 670:	ea069de3          	bnez	a3,52a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 674:	f8b58513          	addi	a0,a1,-117
 678:	e119                	bnez	a0,67e <vprintf+0x25a>
 67a:	ec0715e3          	bnez	a4,544 <vprintf+0x120>
      } else if(c0 == 'x'){
 67e:	07800513          	li	a0,120
 682:	eca78ee3          	beq	a5,a0,55e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 686:	f8860613          	addi	a2,a2,-120
 68a:	e219                	bnez	a2,690 <vprintf+0x26c>
 68c:	ee0695e3          	bnez	a3,576 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 690:	f8858593          	addi	a1,a1,-120
 694:	e199                	bnez	a1,69a <vprintf+0x276>
 696:	ee071de3          	bnez	a4,590 <vprintf+0x16c>
      } else if(c0 == 'p'){
 69a:	07000713          	li	a4,112
 69e:	f0e786e3          	beq	a5,a4,5aa <vprintf+0x186>
      } else if(c0 == 's'){
 6a2:	07300713          	li	a4,115
 6a6:	f4e786e3          	beq	a5,a4,5f2 <vprintf+0x1ce>
      } else if(c0 == '%'){
 6aa:	02500713          	li	a4,37
 6ae:	f6e78be3          	beq	a5,a4,624 <vprintf+0x200>
        putc(fd, '%');
 6b2:	02500593          	li	a1,37
 6b6:	855a                	mv	a0,s6
 6b8:	cabff0ef          	jal	362 <putc>
        putc(fd, c0);
 6bc:	85a6                	mv	a1,s1
 6be:	855a                	mv	a0,s6
 6c0:	ca3ff0ef          	jal	362 <putc>
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b34d                	j	468 <vprintf+0x44>

00000000000006c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c8:	715d                	addi	sp,sp,-80
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e010                	sd	a2,0(s0)
 6d2:	e414                	sd	a3,8(s0)
 6d4:	e818                	sd	a4,16(s0)
 6d6:	ec1c                	sd	a5,24(s0)
 6d8:	03043023          	sd	a6,32(s0)
 6dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	8622                	mv	a2,s0
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	d3fff0ef          	jal	424 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <printf>:

void
printf(const char *fmt, ...)
{
 6f2:	711d                	addi	sp,sp,-96
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e40c                	sd	a1,8(s0)
 6fc:	e810                	sd	a2,16(s0)
 6fe:	ec14                	sd	a3,24(s0)
 700:	f018                	sd	a4,32(s0)
 702:	f41c                	sd	a5,40(s0)
 704:	03043823          	sd	a6,48(s0)
 708:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	00840613          	addi	a2,s0,8
 710:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 714:	85aa                	mv	a1,a0
 716:	4505                	li	a0,1
 718:	d0dff0ef          	jal	424 <vprintf>
}
 71c:	60e2                	ld	ra,24(sp)
 71e:	6442                	ld	s0,16(sp)
 720:	6125                	addi	sp,sp,96
 722:	8082                	ret

0000000000000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	1141                	addi	sp,sp,-16
 726:	e406                	sd	ra,8(sp)
 728:	e022                	sd	s0,0(sp)
 72a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00001797          	auipc	a5,0x1
 734:	8d07b783          	ld	a5,-1840(a5) # 1000 <freep>
 738:	a039                	j	746 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	6398                	ld	a4,0(a5)
 73c:	00e7e463          	bltu	a5,a4,744 <free+0x20>
 740:	00e6ea63          	bltu	a3,a4,754 <free+0x30>
{
 744:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	fed7fae3          	bgeu	a5,a3,73a <free+0x16>
 74a:	6398                	ld	a4,0(a5)
 74c:	00e6e463          	bltu	a3,a4,754 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	fee7eae3          	bltu	a5,a4,744 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	ff852583          	lw	a1,-8(a0)
 758:	6390                	ld	a2,0(a5)
 75a:	02059813          	slli	a6,a1,0x20
 75e:	01c85713          	srli	a4,a6,0x1c
 762:	9736                	add	a4,a4,a3
 764:	02e60563          	beq	a2,a4,78e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 76c:	4790                	lw	a2,8(a5)
 76e:	02061593          	slli	a1,a2,0x20
 772:	01c5d713          	srli	a4,a1,0x1c
 776:	973e                	add	a4,a4,a5
 778:	02e68263          	beq	a3,a4,79c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 77c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77e:	00001717          	auipc	a4,0x1
 782:	88f73123          	sd	a5,-1918(a4) # 1000 <freep>
}
 786:	60a2                	ld	ra,8(sp)
 788:	6402                	ld	s0,0(sp)
 78a:	0141                	addi	sp,sp,16
 78c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 78e:	4618                	lw	a4,8(a2)
 790:	9f2d                	addw	a4,a4,a1
 792:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	6398                	ld	a4,0(a5)
 798:	6310                	ld	a2,0(a4)
 79a:	b7f9                	j	768 <free+0x44>
    p->s.size += bp->s.size;
 79c:	ff852703          	lw	a4,-8(a0)
 7a0:	9f31                	addw	a4,a4,a2
 7a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a4:	ff053683          	ld	a3,-16(a0)
 7a8:	bfd1                	j	77c <free+0x58>

00000000000007aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7aa:	7139                	addi	sp,sp,-64
 7ac:	fc06                	sd	ra,56(sp)
 7ae:	f822                	sd	s0,48(sp)
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b6:	02051993          	slli	s3,a0,0x20
 7ba:	0209d993          	srli	s3,s3,0x20
 7be:	09bd                	addi	s3,s3,15
 7c0:	0049d993          	srli	s3,s3,0x4
 7c4:	2985                	addiw	s3,s3,1
 7c6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c8:	00001517          	auipc	a0,0x1
 7cc:	83853503          	ld	a0,-1992(a0) # 1000 <freep>
 7d0:	c905                	beqz	a0,800 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	09377663          	bgeu	a4,s3,862 <malloc+0xb8>
 7da:	f426                	sd	s1,40(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e2:	8a4e                	mv	s4,s3
 7e4:	6705                	lui	a4,0x1
 7e6:	00e9f363          	bgeu	s3,a4,7ec <malloc+0x42>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00001497          	auipc	s1,0x1
 7f8:	80c48493          	addi	s1,s1,-2036 # 1000 <freep>
  if(p == (char*)-1)
 7fc:	5afd                	li	s5,-1
 7fe:	a83d                	j	83c <malloc+0x92>
 800:	f426                	sd	s1,40(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 808:	00001797          	auipc	a5,0x1
 80c:	80878793          	addi	a5,a5,-2040 # 1010 <base>
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
 818:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81e:	b7d1                	j	7e2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	e118                	sd	a4,0(a0)
 824:	a899                	j	87a <malloc+0xd0>
  hp->s.size = nu;
 826:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82a:	0541                	addi	a0,a0,16
 82c:	ef9ff0ef          	jal	724 <free>
  return freep;
 830:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 832:	c125                	beqz	a0,892 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 836:	4798                	lw	a4,8(a5)
 838:	03277163          	bgeu	a4,s2,85a <malloc+0xb0>
    if(p == freep)
 83c:	6098                	ld	a4,0(s1)
 83e:	853e                	mv	a0,a5
 840:	fef71ae3          	bne	a4,a5,834 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 844:	8552                	mv	a0,s4
 846:	ab5ff0ef          	jal	2fa <sbrk>
  if(p == (char*)-1)
 84a:	fd551ee3          	bne	a0,s5,826 <malloc+0x7c>
        return 0;
 84e:	4501                	li	a0,0
 850:	74a2                	ld	s1,40(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	a03d                	j	886 <malloc+0xdc>
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 862:	fae90fe3          	beq	s2,a4,820 <malloc+0x76>
        p->s.size -= nunits;
 866:	4137073b          	subw	a4,a4,s3
 86a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86c:	02071693          	slli	a3,a4,0x20
 870:	01c6d713          	srli	a4,a3,0x1c
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00000717          	auipc	a4,0x0
 87e:	78a73323          	sd	a0,1926(a4) # 1000 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	b7f5                	j	886 <malloc+0xdc>
