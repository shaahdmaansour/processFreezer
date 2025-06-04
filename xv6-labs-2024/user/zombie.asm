
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

000000000000035a <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 35a:	48e1                	li	a7,24
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 362:	48e5                	li	a7,25
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36a:	1101                	addi	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	1000                	addi	s0,sp,32
 372:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 376:	4605                	li	a2,1
 378:	fef40593          	addi	a1,s0,-17
 37c:	f9fff0ef          	jal	31a <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	addi	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	7139                	addi	sp,sp,-64
 38a:	fc06                	sd	ra,56(sp)
 38c:	f822                	sd	s0,48(sp)
 38e:	f04a                	sd	s2,32(sp)
 390:	ec4e                	sd	s3,24(sp)
 392:	0080                	addi	s0,sp,64
 394:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 396:	cac9                	beqz	a3,428 <printint+0xa0>
 398:	01f5d79b          	srliw	a5,a1,0x1f
 39c:	c7d1                	beqz	a5,428 <printint+0xa0>
    neg = 1;
    x = -xx;
 39e:	40b005bb          	negw	a1,a1
    neg = 1;
 3a2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3a4:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3a8:	86ce                	mv	a3,s3
  i = 0;
 3aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ac:	00000817          	auipc	a6,0x0
 3b0:	50c80813          	addi	a6,a6,1292 # 8b8 <digits>
 3b4:	88ba                	mv	a7,a4
 3b6:	0017051b          	addiw	a0,a4,1
 3ba:	872a                	mv	a4,a0
 3bc:	02c5f7bb          	remuw	a5,a1,a2
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	97c2                	add	a5,a5,a6
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ce:	87ae                	mv	a5,a1
 3d0:	02c5d5bb          	divuw	a1,a1,a2
 3d4:	0685                	addi	a3,a3,1
 3d6:	fcc7ffe3          	bgeu	a5,a2,3b4 <printint+0x2c>
  if(neg)
 3da:	00030c63          	beqz	t1,3f2 <printint+0x6a>
    buf[i++] = '-';
 3de:	fd050793          	addi	a5,a0,-48
 3e2:	00878533          	add	a0,a5,s0
 3e6:	02d00793          	li	a5,45
 3ea:	fef50823          	sb	a5,-16(a0)
 3ee:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3f2:	02e05563          	blez	a4,41c <printint+0x94>
 3f6:	f426                	sd	s1,40(sp)
 3f8:	377d                	addiw	a4,a4,-1
 3fa:	00e984b3          	add	s1,s3,a4
 3fe:	19fd                	addi	s3,s3,-1
 400:	99ba                	add	s3,s3,a4
 402:	1702                	slli	a4,a4,0x20
 404:	9301                	srli	a4,a4,0x20
 406:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40a:	0004c583          	lbu	a1,0(s1)
 40e:	854a                	mv	a0,s2
 410:	f5bff0ef          	jal	36a <putc>
  while(--i >= 0)
 414:	14fd                	addi	s1,s1,-1
 416:	ff349ae3          	bne	s1,s3,40a <printint+0x82>
 41a:	74a2                	ld	s1,40(sp)
}
 41c:	70e2                	ld	ra,56(sp)
 41e:	7442                	ld	s0,48(sp)
 420:	7902                	ld	s2,32(sp)
 422:	69e2                	ld	s3,24(sp)
 424:	6121                	addi	sp,sp,64
 426:	8082                	ret
  neg = 0;
 428:	4301                	li	t1,0
 42a:	bfad                	j	3a4 <printint+0x1c>

000000000000042c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42c:	711d                	addi	sp,sp,-96
 42e:	ec86                	sd	ra,88(sp)
 430:	e8a2                	sd	s0,80(sp)
 432:	e4a6                	sd	s1,72(sp)
 434:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 436:	0005c483          	lbu	s1,0(a1)
 43a:	20048963          	beqz	s1,64c <vprintf+0x220>
 43e:	e0ca                	sd	s2,64(sp)
 440:	fc4e                	sd	s3,56(sp)
 442:	f852                	sd	s4,48(sp)
 444:	f456                	sd	s5,40(sp)
 446:	f05a                	sd	s6,32(sp)
 448:	ec5e                	sd	s7,24(sp)
 44a:	e862                	sd	s8,16(sp)
 44c:	8b2a                	mv	s6,a0
 44e:	8a2e                	mv	s4,a1
 450:	8bb2                	mv	s7,a2
  state = 0;
 452:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 454:	4901                	li	s2,0
 456:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 458:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45c:	06400c13          	li	s8,100
 460:	a00d                	j	482 <vprintf+0x56>
        putc(fd, c0);
 462:	85a6                	mv	a1,s1
 464:	855a                	mv	a0,s6
 466:	f05ff0ef          	jal	36a <putc>
 46a:	a019                	j	470 <vprintf+0x44>
    } else if(state == '%'){
 46c:	03598363          	beq	s3,s5,492 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 470:	0019079b          	addiw	a5,s2,1
 474:	893e                	mv	s2,a5
 476:	873e                	mv	a4,a5
 478:	97d2                	add	a5,a5,s4
 47a:	0007c483          	lbu	s1,0(a5)
 47e:	1c048063          	beqz	s1,63e <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 482:	0004879b          	sext.w	a5,s1
    if(state == 0){
 486:	fe0993e3          	bnez	s3,46c <vprintf+0x40>
      if(c0 == '%'){
 48a:	fd579ce3          	bne	a5,s5,462 <vprintf+0x36>
        state = '%';
 48e:	89be                	mv	s3,a5
 490:	b7c5                	j	470 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 492:	00ea06b3          	add	a3,s4,a4
 496:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 49a:	1a060e63          	beqz	a2,656 <vprintf+0x22a>
      if(c0 == 'd'){
 49e:	03878763          	beq	a5,s8,4cc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4a2:	f9478693          	addi	a3,a5,-108
 4a6:	0016b693          	seqz	a3,a3
 4aa:	f9c60593          	addi	a1,a2,-100
 4ae:	e99d                	bnez	a1,4e4 <vprintf+0xb8>
 4b0:	ca95                	beqz	a3,4e4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4b2:	008b8493          	addi	s1,s7,8
 4b6:	4685                	li	a3,1
 4b8:	4629                	li	a2,10
 4ba:	000ba583          	lw	a1,0(s7)
 4be:	855a                	mv	a0,s6
 4c0:	ec9ff0ef          	jal	388 <printint>
        i += 1;
 4c4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4c6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	b75d                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4cc:	008b8493          	addi	s1,s7,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	855a                	mv	a0,s6
 4da:	eafff0ef          	jal	388 <printint>
 4de:	8ba6                	mv	s7,s1
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	b779                	j	470 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4e4:	9752                	add	a4,a4,s4
 4e6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ea:	f9460713          	addi	a4,a2,-108
 4ee:	00173713          	seqz	a4,a4
 4f2:	8f75                	and	a4,a4,a3
 4f4:	f9c58513          	addi	a0,a1,-100
 4f8:	16051963          	bnez	a0,66a <vprintf+0x23e>
 4fc:	16070763          	beqz	a4,66a <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 500:	008b8493          	addi	s1,s7,8
 504:	4685                	li	a3,1
 506:	4629                	li	a2,10
 508:	000ba583          	lw	a1,0(s7)
 50c:	855a                	mv	a0,s6
 50e:	e7bff0ef          	jal	388 <printint>
        i += 2;
 512:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	8ba6                	mv	s7,s1
      state = 0;
 516:	4981                	li	s3,0
        i += 2;
 518:	bfa1                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 51a:	008b8493          	addi	s1,s7,8
 51e:	4681                	li	a3,0
 520:	4629                	li	a2,10
 522:	000ba583          	lw	a1,0(s7)
 526:	855a                	mv	a0,s6
 528:	e61ff0ef          	jal	388 <printint>
 52c:	8ba6                	mv	s7,s1
      state = 0;
 52e:	4981                	li	s3,0
 530:	b781                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 532:	008b8493          	addi	s1,s7,8
 536:	4681                	li	a3,0
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	855a                	mv	a0,s6
 540:	e49ff0ef          	jal	388 <printint>
        i += 1;
 544:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 546:	8ba6                	mv	s7,s1
      state = 0;
 548:	4981                	li	s3,0
 54a:	b71d                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54c:	008b8493          	addi	s1,s7,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	e2fff0ef          	jal	388 <printint>
        i += 2;
 55e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 560:	8ba6                	mv	s7,s1
      state = 0;
 562:	4981                	li	s3,0
        i += 2;
 564:	b731                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 566:	008b8493          	addi	s1,s7,8
 56a:	4681                	li	a3,0
 56c:	4641                	li	a2,16
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e15ff0ef          	jal	388 <printint>
 578:	8ba6                	mv	s7,s1
      state = 0;
 57a:	4981                	li	s3,0
 57c:	bdd5                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57e:	008b8493          	addi	s1,s7,8
 582:	4681                	li	a3,0
 584:	4641                	li	a2,16
 586:	000ba583          	lw	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	dfdff0ef          	jal	388 <printint>
        i += 1;
 590:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 592:	8ba6                	mv	s7,s1
      state = 0;
 594:	4981                	li	s3,0
 596:	bde9                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 598:	008b8493          	addi	s1,s7,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	de3ff0ef          	jal	388 <printint>
        i += 2;
 5aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ac:	8ba6                	mv	s7,s1
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	b5c1                	j	470 <vprintf+0x44>
 5b2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5b4:	008b8793          	addi	a5,s7,8
 5b8:	8cbe                	mv	s9,a5
 5ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5be:	03000593          	li	a1,48
 5c2:	855a                	mv	a0,s6
 5c4:	da7ff0ef          	jal	36a <putc>
  putc(fd, 'x');
 5c8:	07800593          	li	a1,120
 5cc:	855a                	mv	a0,s6
 5ce:	d9dff0ef          	jal	36a <putc>
 5d2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d4:	00000b97          	auipc	s7,0x0
 5d8:	2e4b8b93          	addi	s7,s7,740 # 8b8 <digits>
 5dc:	03c9d793          	srli	a5,s3,0x3c
 5e0:	97de                	add	a5,a5,s7
 5e2:	0007c583          	lbu	a1,0(a5)
 5e6:	855a                	mv	a0,s6
 5e8:	d83ff0ef          	jal	36a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ec:	0992                	slli	s3,s3,0x4
 5ee:	34fd                	addiw	s1,s1,-1
 5f0:	f4f5                	bnez	s1,5dc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5f2:	8be6                	mv	s7,s9
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	6ca2                	ld	s9,8(sp)
 5f8:	bda5                	j	470 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 5fa:	008b8993          	addi	s3,s7,8
 5fe:	000bb483          	ld	s1,0(s7)
 602:	cc91                	beqz	s1,61e <vprintf+0x1f2>
        for(; *s; s++)
 604:	0004c583          	lbu	a1,0(s1)
 608:	c985                	beqz	a1,638 <vprintf+0x20c>
          putc(fd, *s);
 60a:	855a                	mv	a0,s6
 60c:	d5fff0ef          	jal	36a <putc>
        for(; *s; s++)
 610:	0485                	addi	s1,s1,1
 612:	0004c583          	lbu	a1,0(s1)
 616:	f9f5                	bnez	a1,60a <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd91                	j	470 <vprintf+0x44>
          s = "(null)";
 61e:	00000497          	auipc	s1,0x0
 622:	29248493          	addi	s1,s1,658 # 8b0 <malloc+0xfe>
        for(; *s; s++)
 626:	02800593          	li	a1,40
 62a:	b7c5                	j	60a <vprintf+0x1de>
        putc(fd, '%');
 62c:	85be                	mv	a1,a5
 62e:	855a                	mv	a0,s6
 630:	d3bff0ef          	jal	36a <putc>
      state = 0;
 634:	4981                	li	s3,0
 636:	bd2d                	j	470 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd15                	j	470 <vprintf+0x44>
 63e:	6906                	ld	s2,64(sp)
 640:	79e2                	ld	s3,56(sp)
 642:	7a42                	ld	s4,48(sp)
 644:	7aa2                	ld	s5,40(sp)
 646:	7b02                	ld	s6,32(sp)
 648:	6be2                	ld	s7,24(sp)
 64a:	6c42                	ld	s8,16(sp)
    }
  }
}
 64c:	60e6                	ld	ra,88(sp)
 64e:	6446                	ld	s0,80(sp)
 650:	64a6                	ld	s1,72(sp)
 652:	6125                	addi	sp,sp,96
 654:	8082                	ret
      if(c0 == 'd'){
 656:	06400713          	li	a4,100
 65a:	e6e789e3          	beq	a5,a4,4cc <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 65e:	f9478693          	addi	a3,a5,-108
 662:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 666:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 668:	4701                	li	a4,0
      } else if(c0 == 'u'){
 66a:	07500513          	li	a0,117
 66e:	eaa786e3          	beq	a5,a0,51a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 672:	f8b60513          	addi	a0,a2,-117
 676:	e119                	bnez	a0,67c <vprintf+0x250>
 678:	ea069de3          	bnez	a3,532 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 67c:	f8b58513          	addi	a0,a1,-117
 680:	e119                	bnez	a0,686 <vprintf+0x25a>
 682:	ec0715e3          	bnez	a4,54c <vprintf+0x120>
      } else if(c0 == 'x'){
 686:	07800513          	li	a0,120
 68a:	eca78ee3          	beq	a5,a0,566 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 68e:	f8860613          	addi	a2,a2,-120
 692:	e219                	bnez	a2,698 <vprintf+0x26c>
 694:	ee0695e3          	bnez	a3,57e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 698:	f8858593          	addi	a1,a1,-120
 69c:	e199                	bnez	a1,6a2 <vprintf+0x276>
 69e:	ee071de3          	bnez	a4,598 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6a2:	07000713          	li	a4,112
 6a6:	f0e786e3          	beq	a5,a4,5b2 <vprintf+0x186>
      } else if(c0 == 's'){
 6aa:	07300713          	li	a4,115
 6ae:	f4e786e3          	beq	a5,a4,5fa <vprintf+0x1ce>
      } else if(c0 == '%'){
 6b2:	02500713          	li	a4,37
 6b6:	f6e78be3          	beq	a5,a4,62c <vprintf+0x200>
        putc(fd, '%');
 6ba:	02500593          	li	a1,37
 6be:	855a                	mv	a0,s6
 6c0:	cabff0ef          	jal	36a <putc>
        putc(fd, c0);
 6c4:	85a6                	mv	a1,s1
 6c6:	855a                	mv	a0,s6
 6c8:	ca3ff0ef          	jal	36a <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b34d                	j	470 <vprintf+0x44>

00000000000006d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d0:	715d                	addi	sp,sp,-80
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e010                	sd	a2,0(s0)
 6da:	e414                	sd	a3,8(s0)
 6dc:	e818                	sd	a4,16(s0)
 6de:	ec1c                	sd	a5,24(s0)
 6e0:	03043023          	sd	a6,32(s0)
 6e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	8622                	mv	a2,s0
 6ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ee:	d3fff0ef          	jal	42c <vprintf>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6161                	addi	sp,sp,80
 6f8:	8082                	ret

00000000000006fa <printf>:

void
printf(const char *fmt, ...)
{
 6fa:	711d                	addi	sp,sp,-96
 6fc:	ec06                	sd	ra,24(sp)
 6fe:	e822                	sd	s0,16(sp)
 700:	1000                	addi	s0,sp,32
 702:	e40c                	sd	a1,8(s0)
 704:	e810                	sd	a2,16(s0)
 706:	ec14                	sd	a3,24(s0)
 708:	f018                	sd	a4,32(s0)
 70a:	f41c                	sd	a5,40(s0)
 70c:	03043823          	sd	a6,48(s0)
 710:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 714:	00840613          	addi	a2,s0,8
 718:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71c:	85aa                	mv	a1,a0
 71e:	4505                	li	a0,1
 720:	d0dff0ef          	jal	42c <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6125                	addi	sp,sp,96
 72a:	8082                	ret

000000000000072c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72c:	1141                	addi	sp,sp,-16
 72e:	e406                	sd	ra,8(sp)
 730:	e022                	sd	s0,0(sp)
 732:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 734:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	00001797          	auipc	a5,0x1
 73c:	8c87b783          	ld	a5,-1848(a5) # 1000 <freep>
 740:	a039                	j	74e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	6398                	ld	a4,0(a5)
 744:	00e7e463          	bltu	a5,a4,74c <free+0x20>
 748:	00e6ea63          	bltu	a3,a4,75c <free+0x30>
{
 74c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	fed7fae3          	bgeu	a5,a3,742 <free+0x16>
 752:	6398                	ld	a4,0(a5)
 754:	00e6e463          	bltu	a3,a4,75c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	fee7eae3          	bltu	a5,a4,74c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 75c:	ff852583          	lw	a1,-8(a0)
 760:	6390                	ld	a2,0(a5)
 762:	02059813          	slli	a6,a1,0x20
 766:	01c85713          	srli	a4,a6,0x1c
 76a:	9736                	add	a4,a4,a3
 76c:	02e60563          	beq	a2,a4,796 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 774:	4790                	lw	a2,8(a5)
 776:	02061593          	slli	a1,a2,0x20
 77a:	01c5d713          	srli	a4,a1,0x1c
 77e:	973e                	add	a4,a4,a5
 780:	02e68263          	beq	a3,a4,7a4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 784:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 786:	00001717          	auipc	a4,0x1
 78a:	86f73d23          	sd	a5,-1926(a4) # 1000 <freep>
}
 78e:	60a2                	ld	ra,8(sp)
 790:	6402                	ld	s0,0(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9f2d                	addw	a4,a4,a1
 79a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6310                	ld	a2,0(a4)
 7a2:	b7f9                	j	770 <free+0x44>
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9f31                	addw	a4,a4,a2
 7aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053683          	ld	a3,-16(a0)
 7b0:	bfd1                	j	784 <free+0x58>

00000000000007b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f04a                	sd	s2,32(sp)
 7ba:	ec4e                	sd	s3,24(sp)
 7bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	02051993          	slli	s3,a0,0x20
 7c2:	0209d993          	srli	s3,s3,0x20
 7c6:	09bd                	addi	s3,s3,15
 7c8:	0049d993          	srli	s3,s3,0x4
 7cc:	2985                	addiw	s3,s3,1
 7ce:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d0:	00001517          	auipc	a0,0x1
 7d4:	83053503          	ld	a0,-2000(a0) # 1000 <freep>
 7d8:	c905                	beqz	a0,808 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7dc:	4798                	lw	a4,8(a5)
 7de:	09377663          	bgeu	a4,s3,86a <malloc+0xb8>
 7e2:	f426                	sd	s1,40(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ea:	8a4e                	mv	s4,s3
 7ec:	6705                	lui	a4,0x1
 7ee:	00e9f363          	bgeu	s3,a4,7f4 <malloc+0x42>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00001497          	auipc	s1,0x1
 800:	80448493          	addi	s1,s1,-2044 # 1000 <freep>
  if(p == (char*)-1)
 804:	5afd                	li	s5,-1
 806:	a83d                	j	844 <malloc+0x92>
 808:	f426                	sd	s1,40(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 810:	00001797          	auipc	a5,0x1
 814:	80078793          	addi	a5,a5,-2048 # 1010 <base>
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
 820:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 822:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 826:	b7d1                	j	7ea <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	e118                	sd	a4,0(a0)
 82c:	a899                	j	882 <malloc+0xd0>
  hp->s.size = nu;
 82e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 832:	0541                	addi	a0,a0,16
 834:	ef9ff0ef          	jal	72c <free>
  return freep;
 838:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 83a:	c125                	beqz	a0,89a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83e:	4798                	lw	a4,8(a5)
 840:	03277163          	bgeu	a4,s2,862 <malloc+0xb0>
    if(p == freep)
 844:	6098                	ld	a4,0(s1)
 846:	853e                	mv	a0,a5
 848:	fef71ae3          	bne	a4,a5,83c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 84c:	8552                	mv	a0,s4
 84e:	aadff0ef          	jal	2fa <sbrk>
  if(p == (char*)-1)
 852:	fd551ee3          	bne	a0,s5,82e <malloc+0x7c>
        return 0;
 856:	4501                	li	a0,0
 858:	74a2                	ld	s1,40(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
 860:	a03d                	j	88e <malloc+0xdc>
 862:	74a2                	ld	s1,40(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86a:	fae90fe3          	beq	s2,a4,828 <malloc+0x76>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	slli	a3,a4,0x20
 878:	01c6d713          	srli	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	76a73f23          	sd	a0,1918(a4) # 1000 <freep>
      return (void*)(p + 1);
 88a:	01078513          	addi	a0,a5,16
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	7902                	ld	s2,32(sp)
 894:	69e2                	ld	s3,24(sp)
 896:	6121                	addi	sp,sp,64
 898:	8082                	ret
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	b7f5                	j	88e <malloc+0xdc>
