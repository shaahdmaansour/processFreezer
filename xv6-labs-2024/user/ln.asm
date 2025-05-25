
user/_ln:     file format elf64-littleriscv


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
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8c058593          	addi	a1,a1,-1856 # 8d0 <malloc+0xf6>
  18:	4509                	li	a0,2
  1a:	6de000ef          	jal	6f8 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2ba000ef          	jal	2da <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	336000ef          	jal	362 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2a4000ef          	jal	2da <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8aa58593          	addi	a1,a1,-1878 # 8e8 <malloc+0x10e>
  46:	4509                	li	a0,2
  48:	6b0000ef          	jal	6f8 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	27e000ef          	jal	2da <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0xa>
    ;
  return os;
}
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x20>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x20>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cf91                	beqz	a5,d8 <strlen+0x28>
  be:	00150793          	addi	a5,a0,1
  c2:	86be                	mv	a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	ff65                	bnez	a4,c2 <strlen+0x12>
  cc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for(n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x20>

00000000000000dc <memset>:

void*
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf81                	beqz	a5,126 <strchr+0x24>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strchr+0x1c>

000000000000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	711d                	addi	sp,sp,-96
 12c:	ec86                	sd	ra,88(sp)
 12e:	e8a2                	sd	s0,80(sp)
 130:	e4a6                	sd	s1,72(sp)
 132:	e0ca                	sd	s2,64(sp)
 134:	fc4e                	sd	s3,56(sp)
 136:	f852                	sd	s4,48(sp)
 138:	f456                	sd	s5,40(sp)
 13a:	f05a                	sd	s6,32(sp)
 13c:	ec5e                	sd	s7,24(sp)
 13e:	e862                	sd	s8,16(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14a:	faf40b13          	addi	s6,s0,-81
 14e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 150:	8c26                	mv	s8,s1
 152:	0014899b          	addiw	s3,s1,1
 156:	84ce                	mv	s1,s3
 158:	0349d463          	bge	s3,s4,180 <gets+0x56>
    cc = read(0, &c, 1);
 15c:	8656                	mv	a2,s5
 15e:	85da                	mv	a1,s6
 160:	4501                	li	a0,0
 162:	190000ef          	jal	2f2 <read>
    if(cc < 1)
 166:	00a05d63          	blez	a0,180 <gets+0x56>
      break;
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	0905                	addi	s2,s2,1
 174:	ff678713          	addi	a4,a5,-10
 178:	c319                	beqz	a4,17e <gets+0x54>
 17a:	17cd                	addi	a5,a5,-13
 17c:	fbf1                	bnez	a5,150 <gets+0x26>
    buf[i++] = c;
 17e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 180:	9c5e                	add	s8,s8,s7
 182:	000c0023          	sb	zero,0(s8)
  return buf;
}
 186:	855e                	mv	a0,s7
 188:	60e6                	ld	ra,88(sp)
 18a:	6446                	ld	s0,80(sp)
 18c:	64a6                	ld	s1,72(sp)
 18e:	6906                	ld	s2,64(sp)
 190:	79e2                	ld	s3,56(sp)
 192:	7a42                	ld	s4,48(sp)
 194:	7aa2                	ld	s5,40(sp)
 196:	7b02                	ld	s6,32(sp)
 198:	6be2                	ld	s7,24(sp)
 19a:	6c42                	ld	s8,16(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e04a                	sd	s2,0(sp)
 1a8:	1000                	addi	s0,sp,32
 1aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ac:	4581                	li	a1,0
 1ae:	194000ef          	jal	342 <open>
  if(fd < 0)
 1b2:	02054263          	bltz	a0,1d6 <stat+0x36>
 1b6:	e426                	sd	s1,8(sp)
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	14e000ef          	jal	30a <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	1ae000ef          	jal	372 <close>
  return r;
 1c8:	64a2                	ld	s1,8(sp)
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	57fd                	li	a5,-1
 1d8:	893e                	mv	s2,a5
 1da:	bfc5                	j	1ca <stat+0x2a>

00000000000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e4:	00054683          	lbu	a3,0(a0)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	4625                	li	a2,9
 1f2:	02f66963          	bltu	a2,a5,224 <atoi+0x48>
 1f6:	872a                	mv	a4,a0
  n = 0;
 1f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fa:	0705                	addi	a4,a4,1
 1fc:	0025179b          	slliw	a5,a0,0x2
 200:	9fa9                	addw	a5,a5,a0
 202:	0017979b          	slliw	a5,a5,0x1
 206:	9fb5                	addw	a5,a5,a3
 208:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20c:	00074683          	lbu	a3,0(a4)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	fef671e3          	bgeu	a2,a5,1fa <atoi+0x1e>
  return n;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  n = 0;
 224:	4501                	li	a0,0
 226:	bfdd                	j	21c <atoi+0x40>

0000000000000228 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 230:	02b57563          	bgeu	a0,a1,25a <memmove+0x32>
    while(n-- > 0)
 234:	00c05f63          	blez	a2,252 <memmove+0x2a>
 238:	1602                	slli	a2,a2,0x20
 23a:	9201                	srli	a2,a2,0x20
 23c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 240:	872a                	mv	a4,a0
      *dst++ = *src++;
 242:	0585                	addi	a1,a1,1
 244:	0705                	addi	a4,a4,1
 246:	fff5c683          	lbu	a3,-1(a1)
 24a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
    while(n-- > 0)
 25a:	fec05ce3          	blez	a2,252 <memmove+0x2a>
    dst += n;
 25e:	00c50733          	add	a4,a0,a2
    src += n;
 262:	95b2                	add	a1,a1,a2
 264:	fff6079b          	addiw	a5,a2,-1
 268:	1782                	slli	a5,a5,0x20
 26a:	9381                	srli	a5,a5,0x20
 26c:	fff7c793          	not	a5,a5
 270:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 272:	15fd                	addi	a1,a1,-1
 274:	177d                	addi	a4,a4,-1
 276:	0005c683          	lbu	a3,0(a1)
 27a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27e:	fef71ae3          	bne	a4,a5,272 <memmove+0x4a>
 282:	bfc1                	j	252 <memmove+0x2a>

0000000000000284 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28c:	c61d                	beqz	a2,2ba <memcmp+0x36>
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 296:	00054783          	lbu	a5,0(a0)
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00e79863          	bne	a5,a4,2ae <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a2:	0505                	addi	a0,a0,1
    p2++;
 2a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a6:	fed518e3          	bne	a0,a3,296 <memcmp+0x12>
  }
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	a019                	j	2b2 <memcmp+0x2e>
      return *p1 - *p2;
 2ae:	40e7853b          	subw	a0,a5,a4
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	bfdd                	j	2b2 <memcmp+0x2e>

00000000000002be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c6:	f63ff0ef          	jal	228 <memmove>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d2:	4885                	li	a7,1
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <exit>:
.global exit
exit:
 li a7, SYS_exit
 2da:	4889                	li	a7,2
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e2:	488d                	li	a7,3
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ea:	4891                	li	a7,4
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <read>:
.global read
read:
 li a7, SYS_read
 2f2:	4895                	li	a7,5
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fa:	4899                	li	a7,6
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <exec>:
.global exec
exec:
 li a7, SYS_exec
 302:	489d                	li	a7,7
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30a:	48a1                	li	a7,8
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 312:	48a5                	li	a7,9
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <dup>:
.global dup
dup:
 li a7, SYS_dup
 31a:	48a9                	li	a7,10
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 322:	48ad                	li	a7,11
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 32a:	48b1                	li	a7,12
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 332:	48b5                	li	a7,13
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 33a:	48b9                	li	a7,14
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <open>:
.global open
open:
 li a7, SYS_open
 342:	48bd                	li	a7,15
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <link>:
.global link
link:
 li a7, SYS_link
 362:	48cd                	li	a7,19
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36a:	48d1                	li	a7,20
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 37a:	48d9                	li	a7,22
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 382:	48dd                	li	a7,23
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 38a:	48e1                	li	a7,24
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	1000                	addi	s0,sp,32
 39a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	fef40593          	addi	a1,s0,-17
 3a4:	fa7ff0ef          	jal	34a <write>
}
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret

00000000000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	7139                	addi	sp,sp,-64
 3b2:	fc06                	sd	ra,56(sp)
 3b4:	f822                	sd	s0,48(sp)
 3b6:	f04a                	sd	s2,32(sp)
 3b8:	ec4e                	sd	s3,24(sp)
 3ba:	0080                	addi	s0,sp,64
 3bc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	cac9                	beqz	a3,450 <printint+0xa0>
 3c0:	01f5d79b          	srliw	a5,a1,0x1f
 3c4:	c7d1                	beqz	a5,450 <printint+0xa0>
    neg = 1;
    x = -xx;
 3c6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ca:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3cc:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3d0:	86ce                	mv	a3,s3
  i = 0;
 3d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d4:	00000817          	auipc	a6,0x0
 3d8:	53480813          	addi	a6,a6,1332 # 908 <digits>
 3dc:	88ba                	mv	a7,a4
 3de:	0017051b          	addiw	a0,a4,1
 3e2:	872a                	mv	a4,a0
 3e4:	02c5f7bb          	remuw	a5,a1,a2
 3e8:	1782                	slli	a5,a5,0x20
 3ea:	9381                	srli	a5,a5,0x20
 3ec:	97c2                	add	a5,a5,a6
 3ee:	0007c783          	lbu	a5,0(a5)
 3f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f6:	87ae                	mv	a5,a1
 3f8:	02c5d5bb          	divuw	a1,a1,a2
 3fc:	0685                	addi	a3,a3,1
 3fe:	fcc7ffe3          	bgeu	a5,a2,3dc <printint+0x2c>
  if(neg)
 402:	00030c63          	beqz	t1,41a <printint+0x6a>
    buf[i++] = '-';
 406:	fd050793          	addi	a5,a0,-48
 40a:	00878533          	add	a0,a5,s0
 40e:	02d00793          	li	a5,45
 412:	fef50823          	sb	a5,-16(a0)
 416:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 41a:	02e05563          	blez	a4,444 <printint+0x94>
 41e:	f426                	sd	s1,40(sp)
 420:	377d                	addiw	a4,a4,-1
 422:	00e984b3          	add	s1,s3,a4
 426:	19fd                	addi	s3,s3,-1
 428:	99ba                	add	s3,s3,a4
 42a:	1702                	slli	a4,a4,0x20
 42c:	9301                	srli	a4,a4,0x20
 42e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 432:	0004c583          	lbu	a1,0(s1)
 436:	854a                	mv	a0,s2
 438:	f5bff0ef          	jal	392 <putc>
  while(--i >= 0)
 43c:	14fd                	addi	s1,s1,-1
 43e:	ff349ae3          	bne	s1,s3,432 <printint+0x82>
 442:	74a2                	ld	s1,40(sp)
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	addi	sp,sp,64
 44e:	8082                	ret
  neg = 0;
 450:	4301                	li	t1,0
 452:	bfad                	j	3cc <printint+0x1c>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	711d                	addi	sp,sp,-96
 456:	ec86                	sd	ra,88(sp)
 458:	e8a2                	sd	s0,80(sp)
 45a:	e4a6                	sd	s1,72(sp)
 45c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45e:	0005c483          	lbu	s1,0(a1)
 462:	20048963          	beqz	s1,674 <vprintf+0x220>
 466:	e0ca                	sd	s2,64(sp)
 468:	fc4e                	sd	s3,56(sp)
 46a:	f852                	sd	s4,48(sp)
 46c:	f456                	sd	s5,40(sp)
 46e:	f05a                	sd	s6,32(sp)
 470:	ec5e                	sd	s7,24(sp)
 472:	e862                	sd	s8,16(sp)
 474:	8b2a                	mv	s6,a0
 476:	8a2e                	mv	s4,a1
 478:	8bb2                	mv	s7,a2
  state = 0;
 47a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47c:	4901                	li	s2,0
 47e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 480:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 484:	06400c13          	li	s8,100
 488:	a00d                	j	4aa <vprintf+0x56>
        putc(fd, c0);
 48a:	85a6                	mv	a1,s1
 48c:	855a                	mv	a0,s6
 48e:	f05ff0ef          	jal	392 <putc>
 492:	a019                	j	498 <vprintf+0x44>
    } else if(state == '%'){
 494:	03598363          	beq	s3,s5,4ba <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 498:	0019079b          	addiw	a5,s2,1
 49c:	893e                	mv	s2,a5
 49e:	873e                	mv	a4,a5
 4a0:	97d2                	add	a5,a5,s4
 4a2:	0007c483          	lbu	s1,0(a5)
 4a6:	1c048063          	beqz	s1,666 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4aa:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ae:	fe0993e3          	bnez	s3,494 <vprintf+0x40>
      if(c0 == '%'){
 4b2:	fd579ce3          	bne	a5,s5,48a <vprintf+0x36>
        state = '%';
 4b6:	89be                	mv	s3,a5
 4b8:	b7c5                	j	498 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ba:	00ea06b3          	add	a3,s4,a4
 4be:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4c2:	1a060e63          	beqz	a2,67e <vprintf+0x22a>
      if(c0 == 'd'){
 4c6:	03878763          	beq	a5,s8,4f4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ca:	f9478693          	addi	a3,a5,-108
 4ce:	0016b693          	seqz	a3,a3
 4d2:	f9c60593          	addi	a1,a2,-100
 4d6:	e99d                	bnez	a1,50c <vprintf+0xb8>
 4d8:	ca95                	beqz	a3,50c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4da:	008b8493          	addi	s1,s7,8
 4de:	4685                	li	a3,1
 4e0:	4629                	li	a2,10
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	855a                	mv	a0,s6
 4e8:	ec9ff0ef          	jal	3b0 <printint>
        i += 1;
 4ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ee:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b75d                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4f4:	008b8493          	addi	s1,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	eafff0ef          	jal	3b0 <printint>
 506:	8ba6                	mv	s7,s1
      state = 0;
 508:	4981                	li	s3,0
 50a:	b779                	j	498 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 50c:	9752                	add	a4,a4,s4
 50e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 512:	f9460713          	addi	a4,a2,-108
 516:	00173713          	seqz	a4,a4
 51a:	8f75                	and	a4,a4,a3
 51c:	f9c58513          	addi	a0,a1,-100
 520:	16051963          	bnez	a0,692 <vprintf+0x23e>
 524:	16070763          	beqz	a4,692 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	008b8493          	addi	s1,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	855a                	mv	a0,s6
 536:	e7bff0ef          	jal	3b0 <printint>
        i += 2;
 53a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	8ba6                	mv	s7,s1
      state = 0;
 53e:	4981                	li	s3,0
        i += 2;
 540:	bfa1                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 542:	008b8493          	addi	s1,s7,8
 546:	4681                	li	a3,0
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	e61ff0ef          	jal	3b0 <printint>
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
 558:	b781                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4681                	li	a3,0
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e49ff0ef          	jal	3b0 <printint>
        i += 1;
 56c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
 572:	b71d                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	008b8493          	addi	s1,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e2fff0ef          	jal	3b0 <printint>
        i += 2;
 586:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
        i += 2;
 58c:	b731                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4641                	li	a2,16
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e15ff0ef          	jal	3b0 <printint>
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bdd5                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dfdff0ef          	jal	3b0 <printint>
        i += 1;
 5b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bde9                	j	498 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	de3ff0ef          	jal	3b0 <printint>
        i += 2;
 5d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
        i += 2;
 5d8:	b5c1                	j	498 <vprintf+0x44>
 5da:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5dc:	008b8793          	addi	a5,s7,8
 5e0:	8cbe                	mv	s9,a5
 5e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e6:	03000593          	li	a1,48
 5ea:	855a                	mv	a0,s6
 5ec:	da7ff0ef          	jal	392 <putc>
  putc(fd, 'x');
 5f0:	07800593          	li	a1,120
 5f4:	855a                	mv	a0,s6
 5f6:	d9dff0ef          	jal	392 <putc>
 5fa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	00000b97          	auipc	s7,0x0
 600:	30cb8b93          	addi	s7,s7,780 # 908 <digits>
 604:	03c9d793          	srli	a5,s3,0x3c
 608:	97de                	add	a5,a5,s7
 60a:	0007c583          	lbu	a1,0(a5)
 60e:	855a                	mv	a0,s6
 610:	d83ff0ef          	jal	392 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 614:	0992                	slli	s3,s3,0x4
 616:	34fd                	addiw	s1,s1,-1
 618:	f4f5                	bnez	s1,604 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 61a:	8be6                	mv	s7,s9
      state = 0;
 61c:	4981                	li	s3,0
 61e:	6ca2                	ld	s9,8(sp)
 620:	bda5                	j	498 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 622:	008b8993          	addi	s3,s7,8
 626:	000bb483          	ld	s1,0(s7)
 62a:	cc91                	beqz	s1,646 <vprintf+0x1f2>
        for(; *s; s++)
 62c:	0004c583          	lbu	a1,0(s1)
 630:	c985                	beqz	a1,660 <vprintf+0x20c>
          putc(fd, *s);
 632:	855a                	mv	a0,s6
 634:	d5fff0ef          	jal	392 <putc>
        for(; *s; s++)
 638:	0485                	addi	s1,s1,1
 63a:	0004c583          	lbu	a1,0(s1)
 63e:	f9f5                	bnez	a1,632 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 640:	8bce                	mv	s7,s3
      state = 0;
 642:	4981                	li	s3,0
 644:	bd91                	j	498 <vprintf+0x44>
          s = "(null)";
 646:	00000497          	auipc	s1,0x0
 64a:	2ba48493          	addi	s1,s1,698 # 900 <malloc+0x126>
        for(; *s; s++)
 64e:	02800593          	li	a1,40
 652:	b7c5                	j	632 <vprintf+0x1de>
        putc(fd, '%');
 654:	85be                	mv	a1,a5
 656:	855a                	mv	a0,s6
 658:	d3bff0ef          	jal	392 <putc>
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd2d                	j	498 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	bd15                	j	498 <vprintf+0x44>
 666:	6906                	ld	s2,64(sp)
 668:	79e2                	ld	s3,56(sp)
 66a:	7a42                	ld	s4,48(sp)
 66c:	7aa2                	ld	s5,40(sp)
 66e:	7b02                	ld	s6,32(sp)
 670:	6be2                	ld	s7,24(sp)
 672:	6c42                	ld	s8,16(sp)
    }
  }
}
 674:	60e6                	ld	ra,88(sp)
 676:	6446                	ld	s0,80(sp)
 678:	64a6                	ld	s1,72(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret
      if(c0 == 'd'){
 67e:	06400713          	li	a4,100
 682:	e6e789e3          	beq	a5,a4,4f4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 686:	f9478693          	addi	a3,a5,-108
 68a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 68e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 690:	4701                	li	a4,0
      } else if(c0 == 'u'){
 692:	07500513          	li	a0,117
 696:	eaa786e3          	beq	a5,a0,542 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 69a:	f8b60513          	addi	a0,a2,-117
 69e:	e119                	bnez	a0,6a4 <vprintf+0x250>
 6a0:	ea069de3          	bnez	a3,55a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a4:	f8b58513          	addi	a0,a1,-117
 6a8:	e119                	bnez	a0,6ae <vprintf+0x25a>
 6aa:	ec0715e3          	bnez	a4,574 <vprintf+0x120>
      } else if(c0 == 'x'){
 6ae:	07800513          	li	a0,120
 6b2:	eca78ee3          	beq	a5,a0,58e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6b6:	f8860613          	addi	a2,a2,-120
 6ba:	e219                	bnez	a2,6c0 <vprintf+0x26c>
 6bc:	ee0695e3          	bnez	a3,5a6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c0:	f8858593          	addi	a1,a1,-120
 6c4:	e199                	bnez	a1,6ca <vprintf+0x276>
 6c6:	ee071de3          	bnez	a4,5c0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6ca:	07000713          	li	a4,112
 6ce:	f0e786e3          	beq	a5,a4,5da <vprintf+0x186>
      } else if(c0 == 's'){
 6d2:	07300713          	li	a4,115
 6d6:	f4e786e3          	beq	a5,a4,622 <vprintf+0x1ce>
      } else if(c0 == '%'){
 6da:	02500713          	li	a4,37
 6de:	f6e78be3          	beq	a5,a4,654 <vprintf+0x200>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	855a                	mv	a0,s6
 6e8:	cabff0ef          	jal	392 <putc>
        putc(fd, c0);
 6ec:	85a6                	mv	a1,s1
 6ee:	855a                	mv	a0,s6
 6f0:	ca3ff0ef          	jal	392 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b34d                	j	498 <vprintf+0x44>

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	8622                	mv	a2,s0
 712:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 716:	d3fff0ef          	jal	454 <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <printf>:

void
printf(const char *fmt, ...)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e40c                	sd	a1,8(s0)
 72c:	e810                	sd	a2,16(s0)
 72e:	ec14                	sd	a3,24(s0)
 730:	f018                	sd	a4,32(s0)
 732:	f41c                	sd	a5,40(s0)
 734:	03043823          	sd	a6,48(s0)
 738:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	00840613          	addi	a2,s0,8
 740:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 744:	85aa                	mv	a1,a0
 746:	4505                	li	a0,1
 748:	d0dff0ef          	jal	454 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	addi	sp,sp,-16
 756:	e406                	sd	ra,8(sp)
 758:	e022                	sd	s0,0(sp)
 75a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	00001797          	auipc	a5,0x1
 764:	8a07b783          	ld	a5,-1888(a5) # 1000 <freep>
 768:	a039                	j	776 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x20>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x30>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x16>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	slli	a6,a1,0x20
 78e:	01c85713          	srli	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	02e60563          	beq	a2,a4,7be <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	slli	a1,a2,0x20
 7a2:	01c5d713          	srli	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	02e68263          	beq	a3,a4,7cc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
}
 7b6:	60a2                	ld	ra,8(sp)
 7b8:	6402                	ld	s0,0(sp)
 7ba:	0141                	addi	sp,sp,16
 7bc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7be:	4618                	lw	a4,8(a2)
 7c0:	9f2d                	addw	a4,a4,a1
 7c2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	6310                	ld	a2,0(a4)
 7ca:	b7f9                	j	798 <free+0x44>
    p->s.size += bp->s.size;
 7cc:	ff852703          	lw	a4,-8(a0)
 7d0:	9f31                	addw	a4,a4,a2
 7d2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d4:	ff053683          	ld	a3,-16(a0)
 7d8:	bfd1                	j	7ac <free+0x58>

00000000000007da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7da:	7139                	addi	sp,sp,-64
 7dc:	fc06                	sd	ra,56(sp)
 7de:	f822                	sd	s0,48(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e6:	02051993          	slli	s3,a0,0x20
 7ea:	0209d993          	srli	s3,s3,0x20
 7ee:	09bd                	addi	s3,s3,15
 7f0:	0049d993          	srli	s3,s3,0x4
 7f4:	2985                	addiw	s3,s3,1
 7f6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c905                	beqz	a0,830 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	09377663          	bgeu	a4,s3,892 <malloc+0xb8>
 80a:	f426                	sd	s1,40(sp)
 80c:	e852                	sd	s4,16(sp)
 80e:	e456                	sd	s5,8(sp)
 810:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 812:	8a4e                	mv	s4,s3
 814:	6705                	lui	a4,0x1
 816:	00e9f363          	bgeu	s3,a4,81c <malloc+0x42>
 81a:	6a05                	lui	s4,0x1
 81c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 820:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 824:	00000497          	auipc	s1,0x0
 828:	7dc48493          	addi	s1,s1,2012 # 1000 <freep>
  if(p == (char*)-1)
 82c:	5afd                	li	s5,-1
 82e:	a83d                	j	86c <malloc+0x92>
 830:	f426                	sd	s1,40(sp)
 832:	e852                	sd	s4,16(sp)
 834:	e456                	sd	s5,8(sp)
 836:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 838:	00000797          	auipc	a5,0x0
 83c:	7d878793          	addi	a5,a5,2008 # 1010 <base>
 840:	00000717          	auipc	a4,0x0
 844:	7cf73023          	sd	a5,1984(a4) # 1000 <freep>
 848:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84e:	b7d1                	j	812 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	e118                	sd	a4,0(a0)
 854:	a899                	j	8aa <malloc+0xd0>
  hp->s.size = nu;
 856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85a:	0541                	addi	a0,a0,16
 85c:	ef9ff0ef          	jal	754 <free>
  return freep;
 860:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 862:	c125                	beqz	a0,8c2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	03277163          	bgeu	a4,s2,88a <malloc+0xb0>
    if(p == freep)
 86c:	6098                	ld	a4,0(s1)
 86e:	853e                	mv	a0,a5
 870:	fef71ae3          	bne	a4,a5,864 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	ab5ff0ef          	jal	32a <sbrk>
  if(p == (char*)-1)
 87a:	fd551ee3          	bne	a0,s5,856 <malloc+0x7c>
        return 0;
 87e:	4501                	li	a0,0
 880:	74a2                	ld	s1,40(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	a03d                	j	8b6 <malloc+0xdc>
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 892:	fae90fe3          	beq	s2,a4,850 <malloc+0x76>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	02071693          	slli	a3,a4,0x20
 8a0:	01c6d713          	srli	a4,a3,0x1c
 8a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74a73b23          	sd	a0,1878(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b2:	01078513          	addi	a0,a5,16
  }
}
 8b6:	70e2                	ld	ra,56(sp)
 8b8:	7442                	ld	s0,48(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6121                	addi	sp,sp,64
 8c0:	8082                	ret
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
 8ca:	b7f5                	j	8b6 <malloc+0xdc>
