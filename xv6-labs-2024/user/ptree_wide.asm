
user/_ptree_wide:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	4495                	li	s1,5
  int pids[5];
  int i;
  
  for (i = 0; i < 5; i++) {
    pids[i] = fork();
   c:	2b6000ef          	jal	2c2 <fork>
    if (pids[i] == 0) {
  10:	c10d                	beqz	a0,32 <main+0x32>
  for (i = 0; i < 5; i++) {
  12:	34fd                	addiw	s1,s1,-1
  14:	fce5                	bnez	s1,c <main+0xc>
      sleep(2);
      exit(0);
    }
  }
  
  sleep(1);
  16:	4505                	li	a0,1
  18:	30a000ef          	jal	322 <sleep>
  ptree();
  1c:	366000ef          	jal	382 <ptree>
  20:	4495                	li	s1,5
  
  for (i = 0; i < 5; i++) {
    wait(0);
  22:	4501                	li	a0,0
  24:	2ae000ef          	jal	2d2 <wait>
  for (i = 0; i < 5; i++) {
  28:	34fd                	addiw	s1,s1,-1
  2a:	fce5                	bnez	s1,22 <main+0x22>
  }
  
  exit(0);
  2c:	4501                	li	a0,0
  2e:	29c000ef          	jal	2ca <exit>
      sleep(2);
  32:	4509                	li	a0,2
  34:	2ee000ef          	jal	322 <sleep>
      exit(0);
  38:	4501                	li	a0,0
  3a:	290000ef          	jal	2ca <exit>

000000000000003e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  3e:	1141                	addi	sp,sp,-16
  40:	e406                	sd	ra,8(sp)
  42:	e022                	sd	s0,0(sp)
  44:	0800                	addi	s0,sp,16
  extern int main();
  main();
  46:	fbbff0ef          	jal	0 <main>
  exit(0);
  4a:	4501                	li	a0,0
  4c:	27e000ef          	jal	2ca <exit>

0000000000000050 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  58:	87aa                	mv	a5,a0
  5a:	0585                	addi	a1,a1,1
  5c:	0785                	addi	a5,a5,1
  5e:	fff5c703          	lbu	a4,-1(a1)
  62:	fee78fa3          	sb	a4,-1(a5)
  66:	fb75                	bnez	a4,5a <strcpy+0xa>
    ;
  return os;
}
  68:	60a2                	ld	ra,8(sp)
  6a:	6402                	ld	s0,0(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cb91                	beqz	a5,90 <strcmp+0x20>
  7e:	0005c703          	lbu	a4,0(a1)
  82:	00f71763          	bne	a4,a5,90 <strcmp+0x20>
    p++, q++;
  86:	0505                	addi	a0,a0,1
  88:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	fbe5                	bnez	a5,7e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  90:	0005c503          	lbu	a0,0(a1)
}
  94:	40a7853b          	subw	a0,a5,a0
  98:	60a2                	ld	ra,8(sp)
  9a:	6402                	ld	s0,0(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strlen>:

uint
strlen(const char *s)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	cf91                	beqz	a5,c8 <strlen+0x28>
  ae:	00150793          	addi	a5,a0,1
  b2:	86be                	mv	a3,a5
  b4:	0785                	addi	a5,a5,1
  b6:	fff7c703          	lbu	a4,-1(a5)
  ba:	ff65                	bnez	a4,b2 <strlen+0x12>
  bc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret
  for(n = 0; s[n]; n++)
  c8:	4501                	li	a0,0
  ca:	bfdd                	j	c0 <strlen+0x20>

00000000000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d4:	ca19                	beqz	a2,ea <memset+0x1e>
  d6:	87aa                	mv	a5,a0
  d8:	1602                	slli	a2,a2,0x20
  da:	9201                	srli	a2,a2,0x20
  dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e4:	0785                	addi	a5,a5,1
  e6:	fee79de3          	bne	a5,a4,e0 <memset+0x14>
  }
  return dst;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strchr>:

char*
strchr(const char *s, char c)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cf81                	beqz	a5,116 <strchr+0x24>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1c>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xe>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  return 0;
 116:	4501                	li	a0,0
 118:	bfdd                	j	10e <strchr+0x1c>

000000000000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	1080                	addi	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
 13a:	faf40b13          	addi	s6,s0,-81
 13e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 140:	8c26                	mv	s8,s1
 142:	0014899b          	addiw	s3,s1,1
 146:	84ce                	mv	s1,s3
 148:	0349d463          	bge	s3,s4,170 <gets+0x56>
    cc = read(0, &c, 1);
 14c:	8656                	mv	a2,s5
 14e:	85da                	mv	a1,s6
 150:	4501                	li	a0,0
 152:	190000ef          	jal	2e2 <read>
    if(cc < 1)
 156:	00a05d63          	blez	a0,170 <gets+0x56>
      break;
    buf[i++] = c;
 15a:	faf44783          	lbu	a5,-81(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	0905                	addi	s2,s2,1
 164:	ff678713          	addi	a4,a5,-10
 168:	c319                	beqz	a4,16e <gets+0x54>
 16a:	17cd                	addi	a5,a5,-13
 16c:	fbf1                	bnez	a5,140 <gets+0x26>
    buf[i++] = c;
 16e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 170:	9c5e                	add	s8,s8,s7
 172:	000c0023          	sb	zero,0(s8)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6c42                	ld	s8,16(sp)
 18c:	6125                	addi	sp,sp,96
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	addi	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e04a                	sd	s2,0(sp)
 198:	1000                	addi	s0,sp,32
 19a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19c:	4581                	li	a1,0
 19e:	194000ef          	jal	332 <open>
  if(fd < 0)
 1a2:	02054263          	bltz	a0,1c6 <stat+0x36>
 1a6:	e426                	sd	s1,8(sp)
 1a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1aa:	85ca                	mv	a1,s2
 1ac:	14e000ef          	jal	2fa <fstat>
 1b0:	892a                	mv	s2,a0
  close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	1ae000ef          	jal	362 <close>
  return r;
 1b8:	64a2                	ld	s1,8(sp)
}
 1ba:	854a                	mv	a0,s2
 1bc:	60e2                	ld	ra,24(sp)
 1be:	6442                	ld	s0,16(sp)
 1c0:	6902                	ld	s2,0(sp)
 1c2:	6105                	addi	sp,sp,32
 1c4:	8082                	ret
    return -1;
 1c6:	57fd                	li	a5,-1
 1c8:	893e                	mv	s2,a5
 1ca:	bfc5                	j	1ba <stat+0x2a>

00000000000001cc <atoi>:

int
atoi(const char *s)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e406                	sd	ra,8(sp)
 1d0:	e022                	sd	s0,0(sp)
 1d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d4:	00054683          	lbu	a3,0(a0)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	4625                	li	a2,9
 1e2:	02f66963          	bltu	a2,a5,214 <atoi+0x48>
 1e6:	872a                	mv	a4,a0
  n = 0;
 1e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ea:	0705                	addi	a4,a4,1
 1ec:	0025179b          	slliw	a5,a0,0x2
 1f0:	9fa9                	addw	a5,a5,a0
 1f2:	0017979b          	slliw	a5,a5,0x1
 1f6:	9fb5                	addw	a5,a5,a3
 1f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fc:	00074683          	lbu	a3,0(a4)
 200:	fd06879b          	addiw	a5,a3,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	fef671e3          	bgeu	a2,a5,1ea <atoi+0x1e>
  return n;
}
 20c:	60a2                	ld	ra,8(sp)
 20e:	6402                	ld	s0,0(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  n = 0;
 214:	4501                	li	a0,0
 216:	bfdd                	j	20c <atoi+0x40>

0000000000000218 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 220:	02b57563          	bgeu	a0,a1,24a <memmove+0x32>
    while(n-- > 0)
 224:	00c05f63          	blez	a2,242 <memmove+0x2a>
 228:	1602                	slli	a2,a2,0x20
 22a:	9201                	srli	a2,a2,0x20
 22c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 230:	872a                	mv	a4,a0
      *dst++ = *src++;
 232:	0585                	addi	a1,a1,1
 234:	0705                	addi	a4,a4,1
 236:	fff5c683          	lbu	a3,-1(a1)
 23a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
    while(n-- > 0)
 24a:	fec05ce3          	blez	a2,242 <memmove+0x2a>
    dst += n;
 24e:	00c50733          	add	a4,a0,a2
    src += n;
 252:	95b2                	add	a1,a1,a2
 254:	fff6079b          	addiw	a5,a2,-1
 258:	1782                	slli	a5,a5,0x20
 25a:	9381                	srli	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 262:	15fd                	addi	a1,a1,-1
 264:	177d                	addi	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26e:	fef71ae3          	bne	a4,a5,262 <memmove+0x4a>
 272:	bfc1                	j	242 <memmove+0x2a>

0000000000000274 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27c:	c61d                	beqz	a2,2aa <memcmp+0x36>
 27e:	1602                	slli	a2,a2,0x20
 280:	9201                	srli	a2,a2,0x20
 282:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 286:	00054783          	lbu	a5,0(a0)
 28a:	0005c703          	lbu	a4,0(a1)
 28e:	00e79863          	bne	a5,a4,29e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 292:	0505                	addi	a0,a0,1
    p2++;
 294:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 296:	fed518e3          	bne	a0,a3,286 <memcmp+0x12>
  }
  return 0;
 29a:	4501                	li	a0,0
 29c:	a019                	j	2a2 <memcmp+0x2e>
      return *p1 - *p2;
 29e:	40e7853b          	subw	a0,a5,a4
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfdd                	j	2a2 <memcmp+0x2e>

00000000000002ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b6:	f63ff0ef          	jal	218 <memmove>
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c2:	4885                	li	a7,1
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ca:	4889                	li	a7,2
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d2:	488d                	li	a7,3
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2da:	4891                	li	a7,4
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <read>:
.global read
read:
 li a7, SYS_read
 2e2:	4895                	li	a7,5
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ea:	4899                	li	a7,6
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f2:	489d                	li	a7,7
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2fa:	48a1                	li	a7,8
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 302:	48a5                	li	a7,9
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <dup>:
.global dup
dup:
 li a7, SYS_dup
 30a:	48a9                	li	a7,10
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 312:	48ad                	li	a7,11
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31a:	48b1                	li	a7,12
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 322:	48b5                	li	a7,13
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32a:	48b9                	li	a7,14
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <open>:
.global open
open:
 li a7, SYS_open
 332:	48bd                	li	a7,15
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <write>:
.global write
write:
 li a7, SYS_write
 33a:	48c1                	li	a7,16
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 342:	48c5                	li	a7,17
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34a:	48c9                	li	a7,18
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <link>:
.global link
link:
 li a7, SYS_link
 352:	48cd                	li	a7,19
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35a:	48d1                	li	a7,20
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <close>:
.global close
close:
 li a7, SYS_close
 362:	48d5                	li	a7,21
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 36a:	48d9                	li	a7,22
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 372:	48dd                	li	a7,23
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 37a:	48e1                	li	a7,24
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 382:	48e5                	li	a7,25
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38a:	1101                	addi	sp,sp,-32
 38c:	ec06                	sd	ra,24(sp)
 38e:	e822                	sd	s0,16(sp)
 390:	1000                	addi	s0,sp,32
 392:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 396:	4605                	li	a2,1
 398:	fef40593          	addi	a1,s0,-17
 39c:	f9fff0ef          	jal	33a <write>
}
 3a0:	60e2                	ld	ra,24(sp)
 3a2:	6442                	ld	s0,16(sp)
 3a4:	6105                	addi	sp,sp,32
 3a6:	8082                	ret

00000000000003a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a8:	7139                	addi	sp,sp,-64
 3aa:	fc06                	sd	ra,56(sp)
 3ac:	f822                	sd	s0,48(sp)
 3ae:	f04a                	sd	s2,32(sp)
 3b0:	ec4e                	sd	s3,24(sp)
 3b2:	0080                	addi	s0,sp,64
 3b4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b6:	cac9                	beqz	a3,448 <printint+0xa0>
 3b8:	01f5d79b          	srliw	a5,a1,0x1f
 3bc:	c7d1                	beqz	a5,448 <printint+0xa0>
    neg = 1;
    x = -xx;
 3be:	40b005bb          	negw	a1,a1
    neg = 1;
 3c2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c4:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3c8:	86ce                	mv	a3,s3
  i = 0;
 3ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3cc:	00000817          	auipc	a6,0x0
 3d0:	50c80813          	addi	a6,a6,1292 # 8d8 <digits>
 3d4:	88ba                	mv	a7,a4
 3d6:	0017051b          	addiw	a0,a4,1
 3da:	872a                	mv	a4,a0
 3dc:	02c5f7bb          	remuw	a5,a1,a2
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	97c2                	add	a5,a5,a6
 3e6:	0007c783          	lbu	a5,0(a5)
 3ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ee:	87ae                	mv	a5,a1
 3f0:	02c5d5bb          	divuw	a1,a1,a2
 3f4:	0685                	addi	a3,a3,1
 3f6:	fcc7ffe3          	bgeu	a5,a2,3d4 <printint+0x2c>
  if(neg)
 3fa:	00030c63          	beqz	t1,412 <printint+0x6a>
    buf[i++] = '-';
 3fe:	fd050793          	addi	a5,a0,-48
 402:	00878533          	add	a0,a5,s0
 406:	02d00793          	li	a5,45
 40a:	fef50823          	sb	a5,-16(a0)
 40e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 412:	02e05563          	blez	a4,43c <printint+0x94>
 416:	f426                	sd	s1,40(sp)
 418:	377d                	addiw	a4,a4,-1
 41a:	00e984b3          	add	s1,s3,a4
 41e:	19fd                	addi	s3,s3,-1
 420:	99ba                	add	s3,s3,a4
 422:	1702                	slli	a4,a4,0x20
 424:	9301                	srli	a4,a4,0x20
 426:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42a:	0004c583          	lbu	a1,0(s1)
 42e:	854a                	mv	a0,s2
 430:	f5bff0ef          	jal	38a <putc>
  while(--i >= 0)
 434:	14fd                	addi	s1,s1,-1
 436:	ff349ae3          	bne	s1,s3,42a <printint+0x82>
 43a:	74a2                	ld	s1,40(sp)
}
 43c:	70e2                	ld	ra,56(sp)
 43e:	7442                	ld	s0,48(sp)
 440:	7902                	ld	s2,32(sp)
 442:	69e2                	ld	s3,24(sp)
 444:	6121                	addi	sp,sp,64
 446:	8082                	ret
  neg = 0;
 448:	4301                	li	t1,0
 44a:	bfad                	j	3c4 <printint+0x1c>

000000000000044c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44c:	711d                	addi	sp,sp,-96
 44e:	ec86                	sd	ra,88(sp)
 450:	e8a2                	sd	s0,80(sp)
 452:	e4a6                	sd	s1,72(sp)
 454:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 456:	0005c483          	lbu	s1,0(a1)
 45a:	20048963          	beqz	s1,66c <vprintf+0x220>
 45e:	e0ca                	sd	s2,64(sp)
 460:	fc4e                	sd	s3,56(sp)
 462:	f852                	sd	s4,48(sp)
 464:	f456                	sd	s5,40(sp)
 466:	f05a                	sd	s6,32(sp)
 468:	ec5e                	sd	s7,24(sp)
 46a:	e862                	sd	s8,16(sp)
 46c:	8b2a                	mv	s6,a0
 46e:	8a2e                	mv	s4,a1
 470:	8bb2                	mv	s7,a2
  state = 0;
 472:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 474:	4901                	li	s2,0
 476:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 478:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 47c:	06400c13          	li	s8,100
 480:	a00d                	j	4a2 <vprintf+0x56>
        putc(fd, c0);
 482:	85a6                	mv	a1,s1
 484:	855a                	mv	a0,s6
 486:	f05ff0ef          	jal	38a <putc>
 48a:	a019                	j	490 <vprintf+0x44>
    } else if(state == '%'){
 48c:	03598363          	beq	s3,s5,4b2 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 490:	0019079b          	addiw	a5,s2,1
 494:	893e                	mv	s2,a5
 496:	873e                	mv	a4,a5
 498:	97d2                	add	a5,a5,s4
 49a:	0007c483          	lbu	s1,0(a5)
 49e:	1c048063          	beqz	s1,65e <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4a2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4a6:	fe0993e3          	bnez	s3,48c <vprintf+0x40>
      if(c0 == '%'){
 4aa:	fd579ce3          	bne	a5,s5,482 <vprintf+0x36>
        state = '%';
 4ae:	89be                	mv	s3,a5
 4b0:	b7c5                	j	490 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b2:	00ea06b3          	add	a3,s4,a4
 4b6:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4ba:	1a060e63          	beqz	a2,676 <vprintf+0x22a>
      if(c0 == 'd'){
 4be:	03878763          	beq	a5,s8,4ec <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c2:	f9478693          	addi	a3,a5,-108
 4c6:	0016b693          	seqz	a3,a3
 4ca:	f9c60593          	addi	a1,a2,-100
 4ce:	e99d                	bnez	a1,504 <vprintf+0xb8>
 4d0:	ca95                	beqz	a3,504 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4d2:	008b8493          	addi	s1,s7,8
 4d6:	4685                	li	a3,1
 4d8:	4629                	li	a2,10
 4da:	000ba583          	lw	a1,0(s7)
 4de:	855a                	mv	a0,s6
 4e0:	ec9ff0ef          	jal	3a8 <printint>
        i += 1;
 4e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b75d                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4ec:	008b8493          	addi	s1,s7,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000ba583          	lw	a1,0(s7)
 4f8:	855a                	mv	a0,s6
 4fa:	eafff0ef          	jal	3a8 <printint>
 4fe:	8ba6                	mv	s7,s1
      state = 0;
 500:	4981                	li	s3,0
 502:	b779                	j	490 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 504:	9752                	add	a4,a4,s4
 506:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50a:	f9460713          	addi	a4,a2,-108
 50e:	00173713          	seqz	a4,a4
 512:	8f75                	and	a4,a4,a3
 514:	f9c58513          	addi	a0,a1,-100
 518:	16051963          	bnez	a0,68a <vprintf+0x23e>
 51c:	16070763          	beqz	a4,68a <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 520:	008b8493          	addi	s1,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	e7bff0ef          	jal	3a8 <printint>
        i += 2;
 532:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 534:	8ba6                	mv	s7,s1
      state = 0;
 536:	4981                	li	s3,0
        i += 2;
 538:	bfa1                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4681                	li	a3,0
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e61ff0ef          	jal	3a8 <printint>
 54c:	8ba6                	mv	s7,s1
      state = 0;
 54e:	4981                	li	s3,0
 550:	b781                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 552:	008b8493          	addi	s1,s7,8
 556:	4681                	li	a3,0
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	e49ff0ef          	jal	3a8 <printint>
        i += 1;
 564:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	8ba6                	mv	s7,s1
      state = 0;
 568:	4981                	li	s3,0
 56a:	b71d                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	008b8493          	addi	s1,s7,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e2fff0ef          	jal	3a8 <printint>
        i += 2;
 57e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
        i += 2;
 584:	b731                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e15ff0ef          	jal	3a8 <printint>
 598:	8ba6                	mv	s7,s1
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bdd5                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dfdff0ef          	jal	3a8 <printint>
        i += 1;
 5b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b2:	8ba6                	mv	s7,s1
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bde9                	j	490 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	de3ff0ef          	jal	3a8 <printint>
        i += 2;
 5ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	b5c1                	j	490 <vprintf+0x44>
 5d2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b8793          	addi	a5,s7,8
 5d8:	8cbe                	mv	s9,a5
 5da:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5de:	03000593          	li	a1,48
 5e2:	855a                	mv	a0,s6
 5e4:	da7ff0ef          	jal	38a <putc>
  putc(fd, 'x');
 5e8:	07800593          	li	a1,120
 5ec:	855a                	mv	a0,s6
 5ee:	d9dff0ef          	jal	38a <putc>
 5f2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f4:	00000b97          	auipc	s7,0x0
 5f8:	2e4b8b93          	addi	s7,s7,740 # 8d8 <digits>
 5fc:	03c9d793          	srli	a5,s3,0x3c
 600:	97de                	add	a5,a5,s7
 602:	0007c583          	lbu	a1,0(a5)
 606:	855a                	mv	a0,s6
 608:	d83ff0ef          	jal	38a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60c:	0992                	slli	s3,s3,0x4
 60e:	34fd                	addiw	s1,s1,-1
 610:	f4f5                	bnez	s1,5fc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 612:	8be6                	mv	s7,s9
      state = 0;
 614:	4981                	li	s3,0
 616:	6ca2                	ld	s9,8(sp)
 618:	bda5                	j	490 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 61a:	008b8993          	addi	s3,s7,8
 61e:	000bb483          	ld	s1,0(s7)
 622:	cc91                	beqz	s1,63e <vprintf+0x1f2>
        for(; *s; s++)
 624:	0004c583          	lbu	a1,0(s1)
 628:	c985                	beqz	a1,658 <vprintf+0x20c>
          putc(fd, *s);
 62a:	855a                	mv	a0,s6
 62c:	d5fff0ef          	jal	38a <putc>
        for(; *s; s++)
 630:	0485                	addi	s1,s1,1
 632:	0004c583          	lbu	a1,0(s1)
 636:	f9f5                	bnez	a1,62a <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd91                	j	490 <vprintf+0x44>
          s = "(null)";
 63e:	00000497          	auipc	s1,0x0
 642:	29248493          	addi	s1,s1,658 # 8d0 <malloc+0xfe>
        for(; *s; s++)
 646:	02800593          	li	a1,40
 64a:	b7c5                	j	62a <vprintf+0x1de>
        putc(fd, '%');
 64c:	85be                	mv	a1,a5
 64e:	855a                	mv	a0,s6
 650:	d3bff0ef          	jal	38a <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	bd2d                	j	490 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd15                	j	490 <vprintf+0x44>
 65e:	6906                	ld	s2,64(sp)
 660:	79e2                	ld	s3,56(sp)
 662:	7a42                	ld	s4,48(sp)
 664:	7aa2                	ld	s5,40(sp)
 666:	7b02                	ld	s6,32(sp)
 668:	6be2                	ld	s7,24(sp)
 66a:	6c42                	ld	s8,16(sp)
    }
  }
}
 66c:	60e6                	ld	ra,88(sp)
 66e:	6446                	ld	s0,80(sp)
 670:	64a6                	ld	s1,72(sp)
 672:	6125                	addi	sp,sp,96
 674:	8082                	ret
      if(c0 == 'd'){
 676:	06400713          	li	a4,100
 67a:	e6e789e3          	beq	a5,a4,4ec <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 67e:	f9478693          	addi	a3,a5,-108
 682:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 686:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 688:	4701                	li	a4,0
      } else if(c0 == 'u'){
 68a:	07500513          	li	a0,117
 68e:	eaa786e3          	beq	a5,a0,53a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 692:	f8b60513          	addi	a0,a2,-117
 696:	e119                	bnez	a0,69c <vprintf+0x250>
 698:	ea069de3          	bnez	a3,552 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69c:	f8b58513          	addi	a0,a1,-117
 6a0:	e119                	bnez	a0,6a6 <vprintf+0x25a>
 6a2:	ec0715e3          	bnez	a4,56c <vprintf+0x120>
      } else if(c0 == 'x'){
 6a6:	07800513          	li	a0,120
 6aa:	eca78ee3          	beq	a5,a0,586 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ae:	f8860613          	addi	a2,a2,-120
 6b2:	e219                	bnez	a2,6b8 <vprintf+0x26c>
 6b4:	ee0695e3          	bnez	a3,59e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b8:	f8858593          	addi	a1,a1,-120
 6bc:	e199                	bnez	a1,6c2 <vprintf+0x276>
 6be:	ee071de3          	bnez	a4,5b8 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6c2:	07000713          	li	a4,112
 6c6:	f0e786e3          	beq	a5,a4,5d2 <vprintf+0x186>
      } else if(c0 == 's'){
 6ca:	07300713          	li	a4,115
 6ce:	f4e786e3          	beq	a5,a4,61a <vprintf+0x1ce>
      } else if(c0 == '%'){
 6d2:	02500713          	li	a4,37
 6d6:	f6e78be3          	beq	a5,a4,64c <vprintf+0x200>
        putc(fd, '%');
 6da:	02500593          	li	a1,37
 6de:	855a                	mv	a0,s6
 6e0:	cabff0ef          	jal	38a <putc>
        putc(fd, c0);
 6e4:	85a6                	mv	a1,s1
 6e6:	855a                	mv	a0,s6
 6e8:	ca3ff0ef          	jal	38a <putc>
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b34d                	j	490 <vprintf+0x44>

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	8622                	mv	a2,s0
 70a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70e:	d3fff0ef          	jal	44c <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6161                	addi	sp,sp,80
 718:	8082                	ret

000000000000071a <printf>:

void
printf(const char *fmt, ...)
{
 71a:	711d                	addi	sp,sp,-96
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e40c                	sd	a1,8(s0)
 724:	e810                	sd	a2,16(s0)
 726:	ec14                	sd	a3,24(s0)
 728:	f018                	sd	a4,32(s0)
 72a:	f41c                	sd	a5,40(s0)
 72c:	03043823          	sd	a6,48(s0)
 730:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	00840613          	addi	a2,s0,8
 738:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73c:	85aa                	mv	a1,a0
 73e:	4505                	li	a0,1
 740:	d0dff0ef          	jal	44c <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret

000000000000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	1141                	addi	sp,sp,-16
 74e:	e406                	sd	ra,8(sp)
 750:	e022                	sd	s0,0(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00001797          	auipc	a5,0x1
 75c:	8a87b783          	ld	a5,-1880(a5) # 1000 <freep>
 760:	a039                	j	76e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	6398                	ld	a4,0(a5)
 764:	00e7e463          	bltu	a5,a4,76c <free+0x20>
 768:	00e6ea63          	bltu	a3,a4,77c <free+0x30>
{
 76c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	fed7fae3          	bgeu	a5,a3,762 <free+0x16>
 772:	6398                	ld	a4,0(a5)
 774:	00e6e463          	bltu	a3,a4,77c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	fee7eae3          	bltu	a5,a4,76c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77c:	ff852583          	lw	a1,-8(a0)
 780:	6390                	ld	a2,0(a5)
 782:	02059813          	slli	a6,a1,0x20
 786:	01c85713          	srli	a4,a6,0x1c
 78a:	9736                	add	a4,a4,a3
 78c:	02e60563          	beq	a2,a4,7b6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 790:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 794:	4790                	lw	a2,8(a5)
 796:	02061593          	slli	a1,a2,0x20
 79a:	01c5d713          	srli	a4,a1,0x1c
 79e:	973e                	add	a4,a4,a5
 7a0:	02e68263          	beq	a3,a4,7c4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a6:	00001717          	auipc	a4,0x1
 7aa:	84f73d23          	sd	a5,-1958(a4) # 1000 <freep>
}
 7ae:	60a2                	ld	ra,8(sp)
 7b0:	6402                	ld	s0,0(sp)
 7b2:	0141                	addi	sp,sp,16
 7b4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7b6:	4618                	lw	a4,8(a2)
 7b8:	9f2d                	addw	a4,a4,a1
 7ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	6310                	ld	a2,0(a4)
 7c2:	b7f9                	j	790 <free+0x44>
    p->s.size += bp->s.size;
 7c4:	ff852703          	lw	a4,-8(a0)
 7c8:	9f31                	addw	a4,a4,a2
 7ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7cc:	ff053683          	ld	a3,-16(a0)
 7d0:	bfd1                	j	7a4 <free+0x58>

00000000000007d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d2:	7139                	addi	sp,sp,-64
 7d4:	fc06                	sd	ra,56(sp)
 7d6:	f822                	sd	s0,48(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	02051993          	slli	s3,a0,0x20
 7e2:	0209d993          	srli	s3,s3,0x20
 7e6:	09bd                	addi	s3,s3,15
 7e8:	0049d993          	srli	s3,s3,0x4
 7ec:	2985                	addiw	s3,s3,1
 7ee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f0:	00001517          	auipc	a0,0x1
 7f4:	81053503          	ld	a0,-2032(a0) # 1000 <freep>
 7f8:	c905                	beqz	a0,828 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fc:	4798                	lw	a4,8(a5)
 7fe:	09377663          	bgeu	a4,s3,88a <malloc+0xb8>
 802:	f426                	sd	s1,40(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80a:	8a4e                	mv	s4,s3
 80c:	6705                	lui	a4,0x1
 80e:	00e9f363          	bgeu	s3,a4,814 <malloc+0x42>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000497          	auipc	s1,0x0
 820:	7e448493          	addi	s1,s1,2020 # 1000 <freep>
  if(p == (char*)-1)
 824:	5afd                	li	s5,-1
 826:	a83d                	j	864 <malloc+0x92>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 830:	00000797          	auipc	a5,0x0
 834:	7e078793          	addi	a5,a5,2016 # 1010 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7d1                	j	80a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	e118                	sd	a4,0(a0)
 84c:	a899                	j	8a2 <malloc+0xd0>
  hp->s.size = nu;
 84e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 852:	0541                	addi	a0,a0,16
 854:	ef9ff0ef          	jal	74c <free>
  return freep;
 858:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 85a:	c125                	beqz	a0,8ba <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	03277163          	bgeu	a4,s2,882 <malloc+0xb0>
    if(p == freep)
 864:	6098                	ld	a4,0(s1)
 866:	853e                	mv	a0,a5
 868:	fef71ae3          	bne	a4,a5,85c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 86c:	8552                	mv	a0,s4
 86e:	aadff0ef          	jal	31a <sbrk>
  if(p == (char*)-1)
 872:	fd551ee3          	bne	a0,s5,84e <malloc+0x7c>
        return 0;
 876:	4501                	li	a0,0
 878:	74a2                	ld	s1,40(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	a03d                	j	8ae <malloc+0xdc>
 882:	74a2                	ld	s1,40(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 88a:	fae90fe3          	beq	s2,a4,848 <malloc+0x76>
        p->s.size -= nunits;
 88e:	4137073b          	subw	a4,a4,s3
 892:	c798                	sw	a4,8(a5)
        p += p->s.size;
 894:	02071693          	slli	a3,a4,0x20
 898:	01c6d713          	srli	a4,a3,0x1c
 89c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a2:	00000717          	auipc	a4,0x0
 8a6:	74a73f23          	sd	a0,1886(a4) # 1000 <freep>
      return (void*)(p + 1);
 8aa:	01078513          	addi	a0,a5,16
  }
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	7902                	ld	s2,32(sp)
 8b4:	69e2                	ld	s3,24(sp)
 8b6:	6121                	addi	sp,sp,64
 8b8:	8082                	ret
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	b7f5                	j	8ae <malloc+0xdc>
