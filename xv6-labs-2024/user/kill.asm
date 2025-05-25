
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1ba000ef          	jal	1e2 <atoi>
  2c:	2d4000ef          	jal	300 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2a8000ef          	jal	2e0 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8a058593          	addi	a1,a1,-1888 # 8e0 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	6b4000ef          	jal	6fe <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
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

0000000000000390 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 390:	48e1                	li	a7,24
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 398:	1101                	addi	sp,sp,-32
 39a:	ec06                	sd	ra,24(sp)
 39c:	e822                	sd	s0,16(sp)
 39e:	1000                	addi	s0,sp,32
 3a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a4:	4605                	li	a2,1
 3a6:	fef40593          	addi	a1,s0,-17
 3aa:	fa7ff0ef          	jal	350 <write>
}
 3ae:	60e2                	ld	ra,24(sp)
 3b0:	6442                	ld	s0,16(sp)
 3b2:	6105                	addi	sp,sp,32
 3b4:	8082                	ret

00000000000003b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b6:	7139                	addi	sp,sp,-64
 3b8:	fc06                	sd	ra,56(sp)
 3ba:	f822                	sd	s0,48(sp)
 3bc:	f04a                	sd	s2,32(sp)
 3be:	ec4e                	sd	s3,24(sp)
 3c0:	0080                	addi	s0,sp,64
 3c2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c4:	cac9                	beqz	a3,456 <printint+0xa0>
 3c6:	01f5d79b          	srliw	a5,a1,0x1f
 3ca:	c7d1                	beqz	a5,456 <printint+0xa0>
    neg = 1;
    x = -xx;
 3cc:	40b005bb          	negw	a1,a1
    neg = 1;
 3d0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d2:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3d6:	86ce                	mv	a3,s3
  i = 0;
 3d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3da:	00000817          	auipc	a6,0x0
 3de:	52680813          	addi	a6,a6,1318 # 900 <digits>
 3e2:	88ba                	mv	a7,a4
 3e4:	0017051b          	addiw	a0,a4,1
 3e8:	872a                	mv	a4,a0
 3ea:	02c5f7bb          	remuw	a5,a1,a2
 3ee:	1782                	slli	a5,a5,0x20
 3f0:	9381                	srli	a5,a5,0x20
 3f2:	97c2                	add	a5,a5,a6
 3f4:	0007c783          	lbu	a5,0(a5)
 3f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fc:	87ae                	mv	a5,a1
 3fe:	02c5d5bb          	divuw	a1,a1,a2
 402:	0685                	addi	a3,a3,1
 404:	fcc7ffe3          	bgeu	a5,a2,3e2 <printint+0x2c>
  if(neg)
 408:	00030c63          	beqz	t1,420 <printint+0x6a>
    buf[i++] = '-';
 40c:	fd050793          	addi	a5,a0,-48
 410:	00878533          	add	a0,a5,s0
 414:	02d00793          	li	a5,45
 418:	fef50823          	sb	a5,-16(a0)
 41c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 420:	02e05563          	blez	a4,44a <printint+0x94>
 424:	f426                	sd	s1,40(sp)
 426:	377d                	addiw	a4,a4,-1
 428:	00e984b3          	add	s1,s3,a4
 42c:	19fd                	addi	s3,s3,-1
 42e:	99ba                	add	s3,s3,a4
 430:	1702                	slli	a4,a4,0x20
 432:	9301                	srli	a4,a4,0x20
 434:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 438:	0004c583          	lbu	a1,0(s1)
 43c:	854a                	mv	a0,s2
 43e:	f5bff0ef          	jal	398 <putc>
  while(--i >= 0)
 442:	14fd                	addi	s1,s1,-1
 444:	ff349ae3          	bne	s1,s3,438 <printint+0x82>
 448:	74a2                	ld	s1,40(sp)
}
 44a:	70e2                	ld	ra,56(sp)
 44c:	7442                	ld	s0,48(sp)
 44e:	7902                	ld	s2,32(sp)
 450:	69e2                	ld	s3,24(sp)
 452:	6121                	addi	sp,sp,64
 454:	8082                	ret
  neg = 0;
 456:	4301                	li	t1,0
 458:	bfad                	j	3d2 <printint+0x1c>

000000000000045a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45a:	711d                	addi	sp,sp,-96
 45c:	ec86                	sd	ra,88(sp)
 45e:	e8a2                	sd	s0,80(sp)
 460:	e4a6                	sd	s1,72(sp)
 462:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 464:	0005c483          	lbu	s1,0(a1)
 468:	20048963          	beqz	s1,67a <vprintf+0x220>
 46c:	e0ca                	sd	s2,64(sp)
 46e:	fc4e                	sd	s3,56(sp)
 470:	f852                	sd	s4,48(sp)
 472:	f456                	sd	s5,40(sp)
 474:	f05a                	sd	s6,32(sp)
 476:	ec5e                	sd	s7,24(sp)
 478:	e862                	sd	s8,16(sp)
 47a:	8b2a                	mv	s6,a0
 47c:	8a2e                	mv	s4,a1
 47e:	8bb2                	mv	s7,a2
  state = 0;
 480:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 482:	4901                	li	s2,0
 484:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 486:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 48a:	06400c13          	li	s8,100
 48e:	a00d                	j	4b0 <vprintf+0x56>
        putc(fd, c0);
 490:	85a6                	mv	a1,s1
 492:	855a                	mv	a0,s6
 494:	f05ff0ef          	jal	398 <putc>
 498:	a019                	j	49e <vprintf+0x44>
    } else if(state == '%'){
 49a:	03598363          	beq	s3,s5,4c0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 49e:	0019079b          	addiw	a5,s2,1
 4a2:	893e                	mv	s2,a5
 4a4:	873e                	mv	a4,a5
 4a6:	97d2                	add	a5,a5,s4
 4a8:	0007c483          	lbu	s1,0(a5)
 4ac:	1c048063          	beqz	s1,66c <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4b0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4b4:	fe0993e3          	bnez	s3,49a <vprintf+0x40>
      if(c0 == '%'){
 4b8:	fd579ce3          	bne	a5,s5,490 <vprintf+0x36>
        state = '%';
 4bc:	89be                	mv	s3,a5
 4be:	b7c5                	j	49e <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c0:	00ea06b3          	add	a3,s4,a4
 4c4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4c8:	1a060e63          	beqz	a2,684 <vprintf+0x22a>
      if(c0 == 'd'){
 4cc:	03878763          	beq	a5,s8,4fa <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4d0:	f9478693          	addi	a3,a5,-108
 4d4:	0016b693          	seqz	a3,a3
 4d8:	f9c60593          	addi	a1,a2,-100
 4dc:	e99d                	bnez	a1,512 <vprintf+0xb8>
 4de:	ca95                	beqz	a3,512 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e0:	008b8493          	addi	s1,s7,8
 4e4:	4685                	li	a3,1
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	855a                	mv	a0,s6
 4ee:	ec9ff0ef          	jal	3b6 <printint>
        i += 1;
 4f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f4:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	b75d                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4fa:	008b8493          	addi	s1,s7,8
 4fe:	4685                	li	a3,1
 500:	4629                	li	a2,10
 502:	000ba583          	lw	a1,0(s7)
 506:	855a                	mv	a0,s6
 508:	eafff0ef          	jal	3b6 <printint>
 50c:	8ba6                	mv	s7,s1
      state = 0;
 50e:	4981                	li	s3,0
 510:	b779                	j	49e <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 512:	9752                	add	a4,a4,s4
 514:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 518:	f9460713          	addi	a4,a2,-108
 51c:	00173713          	seqz	a4,a4
 520:	8f75                	and	a4,a4,a3
 522:	f9c58513          	addi	a0,a1,-100
 526:	16051963          	bnez	a0,698 <vprintf+0x23e>
 52a:	16070763          	beqz	a4,698 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	008b8493          	addi	s1,s7,8
 532:	4685                	li	a3,1
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e7bff0ef          	jal	3b6 <printint>
        i += 2;
 540:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	8ba6                	mv	s7,s1
      state = 0;
 544:	4981                	li	s3,0
        i += 2;
 546:	bfa1                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 548:	008b8493          	addi	s1,s7,8
 54c:	4681                	li	a3,0
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e61ff0ef          	jal	3b6 <printint>
 55a:	8ba6                	mv	s7,s1
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b781                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 560:	008b8493          	addi	s1,s7,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e49ff0ef          	jal	3b6 <printint>
        i += 1;
 572:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b71d                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e2fff0ef          	jal	3b6 <printint>
        i += 2;
 58c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
        i += 2;
 592:	b731                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 594:	008b8493          	addi	s1,s7,8
 598:	4681                	li	a3,0
 59a:	4641                	li	a2,16
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e15ff0ef          	jal	3b6 <printint>
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bdd5                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	dfdff0ef          	jal	3b6 <printint>
        i += 1;
 5be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bde9                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	de3ff0ef          	jal	3b6 <printint>
        i += 2;
 5d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	b5c1                	j	49e <vprintf+0x44>
 5e0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5e2:	008b8793          	addi	a5,s7,8
 5e6:	8cbe                	mv	s9,a5
 5e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ec:	03000593          	li	a1,48
 5f0:	855a                	mv	a0,s6
 5f2:	da7ff0ef          	jal	398 <putc>
  putc(fd, 'x');
 5f6:	07800593          	li	a1,120
 5fa:	855a                	mv	a0,s6
 5fc:	d9dff0ef          	jal	398 <putc>
 600:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000b97          	auipc	s7,0x0
 606:	2feb8b93          	addi	s7,s7,766 # 900 <digits>
 60a:	03c9d793          	srli	a5,s3,0x3c
 60e:	97de                	add	a5,a5,s7
 610:	0007c583          	lbu	a1,0(a5)
 614:	855a                	mv	a0,s6
 616:	d83ff0ef          	jal	398 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61a:	0992                	slli	s3,s3,0x4
 61c:	34fd                	addiw	s1,s1,-1
 61e:	f4f5                	bnez	s1,60a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 620:	8be6                	mv	s7,s9
      state = 0;
 622:	4981                	li	s3,0
 624:	6ca2                	ld	s9,8(sp)
 626:	bda5                	j	49e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 628:	008b8993          	addi	s3,s7,8
 62c:	000bb483          	ld	s1,0(s7)
 630:	cc91                	beqz	s1,64c <vprintf+0x1f2>
        for(; *s; s++)
 632:	0004c583          	lbu	a1,0(s1)
 636:	c985                	beqz	a1,666 <vprintf+0x20c>
          putc(fd, *s);
 638:	855a                	mv	a0,s6
 63a:	d5fff0ef          	jal	398 <putc>
        for(; *s; s++)
 63e:	0485                	addi	s1,s1,1
 640:	0004c583          	lbu	a1,0(s1)
 644:	f9f5                	bnez	a1,638 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 646:	8bce                	mv	s7,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd91                	j	49e <vprintf+0x44>
          s = "(null)";
 64c:	00000497          	auipc	s1,0x0
 650:	2ac48493          	addi	s1,s1,684 # 8f8 <malloc+0x118>
        for(; *s; s++)
 654:	02800593          	li	a1,40
 658:	b7c5                	j	638 <vprintf+0x1de>
        putc(fd, '%');
 65a:	85be                	mv	a1,a5
 65c:	855a                	mv	a0,s6
 65e:	d3bff0ef          	jal	398 <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bd2d                	j	49e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	bd15                	j	49e <vprintf+0x44>
 66c:	6906                	ld	s2,64(sp)
 66e:	79e2                	ld	s3,56(sp)
 670:	7a42                	ld	s4,48(sp)
 672:	7aa2                	ld	s5,40(sp)
 674:	7b02                	ld	s6,32(sp)
 676:	6be2                	ld	s7,24(sp)
 678:	6c42                	ld	s8,16(sp)
    }
  }
}
 67a:	60e6                	ld	ra,88(sp)
 67c:	6446                	ld	s0,80(sp)
 67e:	64a6                	ld	s1,72(sp)
 680:	6125                	addi	sp,sp,96
 682:	8082                	ret
      if(c0 == 'd'){
 684:	06400713          	li	a4,100
 688:	e6e789e3          	beq	a5,a4,4fa <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	f9478693          	addi	a3,a5,-108
 690:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 694:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 696:	4701                	li	a4,0
      } else if(c0 == 'u'){
 698:	07500513          	li	a0,117
 69c:	eaa786e3          	beq	a5,a0,548 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6a0:	f8b60513          	addi	a0,a2,-117
 6a4:	e119                	bnez	a0,6aa <vprintf+0x250>
 6a6:	ea069de3          	bnez	a3,560 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6aa:	f8b58513          	addi	a0,a1,-117
 6ae:	e119                	bnez	a0,6b4 <vprintf+0x25a>
 6b0:	ec0715e3          	bnez	a4,57a <vprintf+0x120>
      } else if(c0 == 'x'){
 6b4:	07800513          	li	a0,120
 6b8:	eca78ee3          	beq	a5,a0,594 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6bc:	f8860613          	addi	a2,a2,-120
 6c0:	e219                	bnez	a2,6c6 <vprintf+0x26c>
 6c2:	ee0695e3          	bnez	a3,5ac <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c6:	f8858593          	addi	a1,a1,-120
 6ca:	e199                	bnez	a1,6d0 <vprintf+0x276>
 6cc:	ee071de3          	bnez	a4,5c6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6d0:	07000713          	li	a4,112
 6d4:	f0e786e3          	beq	a5,a4,5e0 <vprintf+0x186>
      } else if(c0 == 's'){
 6d8:	07300713          	li	a4,115
 6dc:	f4e786e3          	beq	a5,a4,628 <vprintf+0x1ce>
      } else if(c0 == '%'){
 6e0:	02500713          	li	a4,37
 6e4:	f6e78be3          	beq	a5,a4,65a <vprintf+0x200>
        putc(fd, '%');
 6e8:	02500593          	li	a1,37
 6ec:	855a                	mv	a0,s6
 6ee:	cabff0ef          	jal	398 <putc>
        putc(fd, c0);
 6f2:	85a6                	mv	a1,s1
 6f4:	855a                	mv	a0,s6
 6f6:	ca3ff0ef          	jal	398 <putc>
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b34d                	j	49e <vprintf+0x44>

00000000000006fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fe:	715d                	addi	sp,sp,-80
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e010                	sd	a2,0(s0)
 708:	e414                	sd	a3,8(s0)
 70a:	e818                	sd	a4,16(s0)
 70c:	ec1c                	sd	a5,24(s0)
 70e:	03043023          	sd	a6,32(s0)
 712:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	8622                	mv	a2,s0
 718:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71c:	d3fff0ef          	jal	45a <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6161                	addi	sp,sp,80
 726:	8082                	ret

0000000000000728 <printf>:

void
printf(const char *fmt, ...)
{
 728:	711d                	addi	sp,sp,-96
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	addi	s0,sp,32
 730:	e40c                	sd	a1,8(s0)
 732:	e810                	sd	a2,16(s0)
 734:	ec14                	sd	a3,24(s0)
 736:	f018                	sd	a4,32(s0)
 738:	f41c                	sd	a5,40(s0)
 73a:	03043823          	sd	a6,48(s0)
 73e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	00840613          	addi	a2,s0,8
 746:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74a:	85aa                	mv	a1,a0
 74c:	4505                	li	a0,1
 74e:	d0dff0ef          	jal	45a <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret

000000000000075a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75a:	1141                	addi	sp,sp,-16
 75c:	e406                	sd	ra,8(sp)
 75e:	e022                	sd	s0,0(sp)
 760:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	00001797          	auipc	a5,0x1
 76a:	89a7b783          	ld	a5,-1894(a5) # 1000 <freep>
 76e:	a039                	j	77c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	6398                	ld	a4,0(a5)
 772:	00e7e463          	bltu	a5,a4,77a <free+0x20>
 776:	00e6ea63          	bltu	a3,a4,78a <free+0x30>
{
 77a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77c:	fed7fae3          	bgeu	a5,a3,770 <free+0x16>
 780:	6398                	ld	a4,0(a5)
 782:	00e6e463          	bltu	a3,a4,78a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	fee7eae3          	bltu	a5,a4,77a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 78a:	ff852583          	lw	a1,-8(a0)
 78e:	6390                	ld	a2,0(a5)
 790:	02059813          	slli	a6,a1,0x20
 794:	01c85713          	srli	a4,a6,0x1c
 798:	9736                	add	a4,a4,a3
 79a:	02e60563          	beq	a2,a4,7c4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a2:	4790                	lw	a2,8(a5)
 7a4:	02061593          	slli	a1,a2,0x20
 7a8:	01c5d713          	srli	a4,a1,0x1c
 7ac:	973e                	add	a4,a4,a5
 7ae:	02e68263          	beq	a3,a4,7d2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b4:	00001717          	auipc	a4,0x1
 7b8:	84f73623          	sd	a5,-1972(a4) # 1000 <freep>
}
 7bc:	60a2                	ld	ra,8(sp)
 7be:	6402                	ld	s0,0(sp)
 7c0:	0141                	addi	sp,sp,16
 7c2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c4:	4618                	lw	a4,8(a2)
 7c6:	9f2d                	addw	a4,a4,a1
 7c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	6398                	ld	a4,0(a5)
 7ce:	6310                	ld	a2,0(a4)
 7d0:	b7f9                	j	79e <free+0x44>
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9f31                	addw	a4,a4,a2
 7d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053683          	ld	a3,-16(a0)
 7de:	bfd1                	j	7b2 <free+0x58>

00000000000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	7139                	addi	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	ec4e                	sd	s3,24(sp)
 7ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ec:	02051993          	slli	s3,a0,0x20
 7f0:	0209d993          	srli	s3,s3,0x20
 7f4:	09bd                	addi	s3,s3,15
 7f6:	0049d993          	srli	s3,s3,0x4
 7fa:	2985                	addiw	s3,s3,1
 7fc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7fe:	00001517          	auipc	a0,0x1
 802:	80253503          	ld	a0,-2046(a0) # 1000 <freep>
 806:	c905                	beqz	a0,836 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	09377663          	bgeu	a4,s3,898 <malloc+0xb8>
 810:	f426                	sd	s1,40(sp)
 812:	e852                	sd	s4,16(sp)
 814:	e456                	sd	s5,8(sp)
 816:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 818:	8a4e                	mv	s4,s3
 81a:	6705                	lui	a4,0x1
 81c:	00e9f363          	bgeu	s3,a4,822 <malloc+0x42>
 820:	6a05                	lui	s4,0x1
 822:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 826:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82a:	00000497          	auipc	s1,0x0
 82e:	7d648493          	addi	s1,s1,2006 # 1000 <freep>
  if(p == (char*)-1)
 832:	5afd                	li	s5,-1
 834:	a83d                	j	872 <malloc+0x92>
 836:	f426                	sd	s1,40(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 83e:	00000797          	auipc	a5,0x0
 842:	7d278793          	addi	a5,a5,2002 # 1010 <base>
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
 84e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 850:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 854:	b7d1                	j	818 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 856:	6398                	ld	a4,0(a5)
 858:	e118                	sd	a4,0(a0)
 85a:	a899                	j	8b0 <malloc+0xd0>
  hp->s.size = nu;
 85c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 860:	0541                	addi	a0,a0,16
 862:	ef9ff0ef          	jal	75a <free>
  return freep;
 866:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 868:	c125                	beqz	a0,8c8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	03277163          	bgeu	a4,s2,890 <malloc+0xb0>
    if(p == freep)
 872:	6098                	ld	a4,0(s1)
 874:	853e                	mv	a0,a5
 876:	fef71ae3          	bne	a4,a5,86a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 87a:	8552                	mv	a0,s4
 87c:	ab5ff0ef          	jal	330 <sbrk>
  if(p == (char*)-1)
 880:	fd551ee3          	bne	a0,s5,85c <malloc+0x7c>
        return 0;
 884:	4501                	li	a0,0
 886:	74a2                	ld	s1,40(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	a03d                	j	8bc <malloc+0xdc>
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 898:	fae90fe3          	beq	s2,a4,856 <malloc+0x76>
        p->s.size -= nunits;
 89c:	4137073b          	subw	a4,a4,s3
 8a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a2:	02071693          	slli	a3,a4,0x20
 8a6:	01c6d713          	srli	a4,a3,0x1c
 8aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74a73823          	sd	a0,1872(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b8:	01078513          	addi	a0,a5,16
  }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	7902                	ld	s2,32(sp)
 8c2:	69e2                	ld	s3,24(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	b7f5                	j	8bc <malloc+0xdc>
