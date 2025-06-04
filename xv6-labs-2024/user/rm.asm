
user/_rm:     file format elf64-littleriscv


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
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	34a000ef          	jal	372 <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2ba000ef          	jal	2f2 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8b058593          	addi	a1,a1,-1872 # 8f0 <malloc+0xf6>
  48:	4509                	li	a0,2
  4a:	6ce000ef          	jal	718 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2a2000ef          	jal	2f2 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8b258593          	addi	a1,a1,-1870 # 908 <malloc+0x10e>
  5e:	4509                	li	a0,2
  60:	6b8000ef          	jal	718 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	27e000ef          	jal	2f2 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0xa>
    ;
  return os;
}
  90:	60a2                	ld	ra,8(sp)
  92:	6402                	ld	s0,0(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x20>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x20>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x28>
  d6:	00150793          	addi	a5,a0,1
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x12>
  e4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1e>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x14>
  }
  return dst;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf81                	beqz	a5,13e <strchr+0x24>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1c>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xe>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strchr+0x1c>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	e862                	sd	s8,16(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
 162:	faf40b13          	addi	s6,s0,-81
 166:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 168:	8c26                	mv	s8,s1
 16a:	0014899b          	addiw	s3,s1,1
 16e:	84ce                	mv	s1,s3
 170:	0349d463          	bge	s3,s4,198 <gets+0x56>
    cc = read(0, &c, 1);
 174:	8656                	mv	a2,s5
 176:	85da                	mv	a1,s6
 178:	4501                	li	a0,0
 17a:	190000ef          	jal	30a <read>
    if(cc < 1)
 17e:	00a05d63          	blez	a0,198 <gets+0x56>
      break;
    buf[i++] = c;
 182:	faf44783          	lbu	a5,-81(s0)
 186:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18a:	0905                	addi	s2,s2,1
 18c:	ff678713          	addi	a4,a5,-10
 190:	c319                	beqz	a4,196 <gets+0x54>
 192:	17cd                	addi	a5,a5,-13
 194:	fbf1                	bnez	a5,168 <gets+0x26>
    buf[i++] = c;
 196:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 198:	9c5e                	add	s8,s8,s7
 19a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 19e:	855e                	mv	a0,s7
 1a0:	60e6                	ld	ra,88(sp)
 1a2:	6446                	ld	s0,80(sp)
 1a4:	64a6                	ld	s1,72(sp)
 1a6:	6906                	ld	s2,64(sp)
 1a8:	79e2                	ld	s3,56(sp)
 1aa:	7a42                	ld	s4,48(sp)
 1ac:	7aa2                	ld	s5,40(sp)
 1ae:	7b02                	ld	s6,32(sp)
 1b0:	6be2                	ld	s7,24(sp)
 1b2:	6c42                	ld	s8,16(sp)
 1b4:	6125                	addi	sp,sp,96
 1b6:	8082                	ret

00000000000001b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ec06                	sd	ra,24(sp)
 1bc:	e822                	sd	s0,16(sp)
 1be:	e04a                	sd	s2,0(sp)
 1c0:	1000                	addi	s0,sp,32
 1c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c4:	4581                	li	a1,0
 1c6:	194000ef          	jal	35a <open>
  if(fd < 0)
 1ca:	02054263          	bltz	a0,1ee <stat+0x36>
 1ce:	e426                	sd	s1,8(sp)
 1d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d2:	85ca                	mv	a1,s2
 1d4:	14e000ef          	jal	322 <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	1ae000ef          	jal	38a <close>
  return r;
 1e0:	64a2                	ld	s1,8(sp)
}
 1e2:	854a                	mv	a0,s2
 1e4:	60e2                	ld	ra,24(sp)
 1e6:	6442                	ld	s0,16(sp)
 1e8:	6902                	ld	s2,0(sp)
 1ea:	6105                	addi	sp,sp,32
 1ec:	8082                	ret
    return -1;
 1ee:	57fd                	li	a5,-1
 1f0:	893e                	mv	s2,a5
 1f2:	bfc5                	j	1e2 <stat+0x2a>

00000000000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e406                	sd	ra,8(sp)
 1f8:	e022                	sd	s0,0(sp)
 1fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fc:	00054683          	lbu	a3,0(a0)
 200:	fd06879b          	addiw	a5,a3,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	4625                	li	a2,9
 20a:	02f66963          	bltu	a2,a5,23c <atoi+0x48>
 20e:	872a                	mv	a4,a0
  n = 0;
 210:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 212:	0705                	addi	a4,a4,1
 214:	0025179b          	slliw	a5,a0,0x2
 218:	9fa9                	addw	a5,a5,a0
 21a:	0017979b          	slliw	a5,a5,0x1
 21e:	9fb5                	addw	a5,a5,a3
 220:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 224:	00074683          	lbu	a3,0(a4)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	fef671e3          	bgeu	a2,a5,212 <atoi+0x1e>
  return n;
}
 234:	60a2                	ld	ra,8(sp)
 236:	6402                	ld	s0,0(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfdd                	j	234 <atoi+0x40>

0000000000000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 248:	02b57563          	bgeu	a0,a1,272 <memmove+0x32>
    while(n-- > 0)
 24c:	00c05f63          	blez	a2,26a <memmove+0x2a>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 258:	872a                	mv	a4,a0
      *dst++ = *src++;
 25a:	0585                	addi	a1,a1,1
 25c:	0705                	addi	a4,a4,1
 25e:	fff5c683          	lbu	a3,-1(a1)
 262:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
    while(n-- > 0)
 272:	fec05ce3          	blez	a2,26a <memmove+0x2a>
    dst += n;
 276:	00c50733          	add	a4,a0,a2
    src += n;
 27a:	95b2                	add	a1,a1,a2
 27c:	fff6079b          	addiw	a5,a2,-1
 280:	1782                	slli	a5,a5,0x20
 282:	9381                	srli	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	addi	a1,a1,-1
 28c:	177d                	addi	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 296:	fef71ae3          	bne	a4,a5,28a <memmove+0x4a>
 29a:	bfc1                	j	26a <memmove+0x2a>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	c61d                	beqz	a2,2d2 <memcmp+0x36>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	0005c703          	lbu	a4,0(a1)
 2b6:	00e79863          	bne	a5,a4,2c6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ba:	0505                	addi	a0,a0,1
    p2++;
 2bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2be:	fed518e3          	bne	a0,a3,2ae <memcmp+0x12>
  }
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	a019                	j	2ca <memcmp+0x2e>
      return *p1 - *p2;
 2c6:	40e7853b          	subw	a0,a5,a4
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfdd                	j	2ca <memcmp+0x2e>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2de:	f63ff0ef          	jal	240 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ea:	4885                	li	a7,1
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f2:	4889                	li	a7,2
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fa:	488d                	li	a7,3
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 302:	4891                	li	a7,4
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <read>:
.global read
read:
 li a7, SYS_read
 30a:	4895                	li	a7,5
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <kill>:
.global kill
kill:
 li a7, SYS_kill
 312:	4899                	li	a7,6
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <exec>:
.global exec
exec:
 li a7, SYS_exec
 31a:	489d                	li	a7,7
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 322:	48a1                	li	a7,8
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32a:	48a5                	li	a7,9
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <dup>:
.global dup
dup:
 li a7, SYS_dup
 332:	48a9                	li	a7,10
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33a:	48ad                	li	a7,11
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 342:	48b1                	li	a7,12
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34a:	48b5                	li	a7,13
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 352:	48b9                	li	a7,14
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <open>:
.global open
open:
 li a7, SYS_open
 35a:	48bd                	li	a7,15
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <link>:
.global link
link:
 li a7, SYS_link
 37a:	48cd                	li	a7,19
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 382:	48d1                	li	a7,20
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <close>:
.global close
close:
 li a7, SYS_close
 38a:	48d5                	li	a7,21
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 392:	48d9                	li	a7,22
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 39a:	48dd                	li	a7,23
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 3a2:	48e1                	li	a7,24
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3aa:	48e5                	li	a7,25
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	addi	a1,s0,-17
 3c4:	f9fff0ef          	jal	362 <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f04a                	sd	s2,32(sp)
 3d8:	ec4e                	sd	s3,24(sp)
 3da:	0080                	addi	s0,sp,64
 3dc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	cac9                	beqz	a3,470 <printint+0xa0>
 3e0:	01f5d79b          	srliw	a5,a1,0x1f
 3e4:	c7d1                	beqz	a5,470 <printint+0xa0>
    neg = 1;
    x = -xx;
 3e6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ea:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ec:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3f0:	86ce                	mv	a3,s3
  i = 0;
 3f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f4:	00000817          	auipc	a6,0x0
 3f8:	53c80813          	addi	a6,a6,1340 # 930 <digits>
 3fc:	88ba                	mv	a7,a4
 3fe:	0017051b          	addiw	a0,a4,1
 402:	872a                	mv	a4,a0
 404:	02c5f7bb          	remuw	a5,a1,a2
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	97c2                	add	a5,a5,a6
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	87ae                	mv	a5,a1
 418:	02c5d5bb          	divuw	a1,a1,a2
 41c:	0685                	addi	a3,a3,1
 41e:	fcc7ffe3          	bgeu	a5,a2,3fc <printint+0x2c>
  if(neg)
 422:	00030c63          	beqz	t1,43a <printint+0x6a>
    buf[i++] = '-';
 426:	fd050793          	addi	a5,a0,-48
 42a:	00878533          	add	a0,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef50823          	sb	a5,-16(a0)
 436:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 43a:	02e05563          	blez	a4,464 <printint+0x94>
 43e:	f426                	sd	s1,40(sp)
 440:	377d                	addiw	a4,a4,-1
 442:	00e984b3          	add	s1,s3,a4
 446:	19fd                	addi	s3,s3,-1
 448:	99ba                	add	s3,s3,a4
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	0004c583          	lbu	a1,0(s1)
 456:	854a                	mv	a0,s2
 458:	f5bff0ef          	jal	3b2 <putc>
  while(--i >= 0)
 45c:	14fd                	addi	s1,s1,-1
 45e:	ff349ae3          	bne	s1,s3,452 <printint+0x82>
 462:	74a2                	ld	s1,40(sp)
}
 464:	70e2                	ld	ra,56(sp)
 466:	7442                	ld	s0,48(sp)
 468:	7902                	ld	s2,32(sp)
 46a:	69e2                	ld	s3,24(sp)
 46c:	6121                	addi	sp,sp,64
 46e:	8082                	ret
  neg = 0;
 470:	4301                	li	t1,0
 472:	bfad                	j	3ec <printint+0x1c>

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	711d                	addi	sp,sp,-96
 476:	ec86                	sd	ra,88(sp)
 478:	e8a2                	sd	s0,80(sp)
 47a:	e4a6                	sd	s1,72(sp)
 47c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c483          	lbu	s1,0(a1)
 482:	20048963          	beqz	s1,694 <vprintf+0x220>
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	e862                	sd	s8,16(sp)
 494:	8b2a                	mv	s6,a0
 496:	8a2e                	mv	s4,a1
 498:	8bb2                	mv	s7,a2
  state = 0;
 49a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49c:	4901                	li	s2,0
 49e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a4:	06400c13          	li	s8,100
 4a8:	a00d                	j	4ca <vprintf+0x56>
        putc(fd, c0);
 4aa:	85a6                	mv	a1,s1
 4ac:	855a                	mv	a0,s6
 4ae:	f05ff0ef          	jal	3b2 <putc>
 4b2:	a019                	j	4b8 <vprintf+0x44>
    } else if(state == '%'){
 4b4:	03598363          	beq	s3,s5,4da <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b8:	0019079b          	addiw	a5,s2,1
 4bc:	893e                	mv	s2,a5
 4be:	873e                	mv	a4,a5
 4c0:	97d2                	add	a5,a5,s4
 4c2:	0007c483          	lbu	s1,0(a5)
 4c6:	1c048063          	beqz	s1,686 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4ca:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ce:	fe0993e3          	bnez	s3,4b4 <vprintf+0x40>
      if(c0 == '%'){
 4d2:	fd579ce3          	bne	a5,s5,4aa <vprintf+0x36>
        state = '%';
 4d6:	89be                	mv	s3,a5
 4d8:	b7c5                	j	4b8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4da:	00ea06b3          	add	a3,s4,a4
 4de:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4e2:	1a060e63          	beqz	a2,69e <vprintf+0x22a>
      if(c0 == 'd'){
 4e6:	03878763          	beq	a5,s8,514 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	f9478693          	addi	a3,a5,-108
 4ee:	0016b693          	seqz	a3,a3
 4f2:	f9c60593          	addi	a1,a2,-100
 4f6:	e99d                	bnez	a1,52c <vprintf+0xb8>
 4f8:	ca95                	beqz	a3,52c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fa:	008b8493          	addi	s1,s7,8
 4fe:	4685                	li	a3,1
 500:	4629                	li	a2,10
 502:	000ba583          	lw	a1,0(s7)
 506:	855a                	mv	a0,s6
 508:	ec9ff0ef          	jal	3d0 <printint>
        i += 1;
 50c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 510:	4981                	li	s3,0
 512:	b75d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b8493          	addi	s1,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	eafff0ef          	jal	3d0 <printint>
 526:	8ba6                	mv	s7,s1
      state = 0;
 528:	4981                	li	s3,0
 52a:	b779                	j	4b8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 52c:	9752                	add	a4,a4,s4
 52e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 532:	f9460713          	addi	a4,a2,-108
 536:	00173713          	seqz	a4,a4
 53a:	8f75                	and	a4,a4,a3
 53c:	f9c58513          	addi	a0,a1,-100
 540:	16051963          	bnez	a0,6b2 <vprintf+0x23e>
 544:	16070763          	beqz	a4,6b2 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	008b8493          	addi	s1,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e7bff0ef          	jal	3d0 <printint>
        i += 2;
 55a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	8ba6                	mv	s7,s1
      state = 0;
 55e:	4981                	li	s3,0
        i += 2;
 560:	bfa1                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 562:	008b8493          	addi	s1,s7,8
 566:	4681                	li	a3,0
 568:	4629                	li	a2,10
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e61ff0ef          	jal	3d0 <printint>
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b781                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e49ff0ef          	jal	3d0 <printint>
        i += 1;
 58c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	b71d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	008b8493          	addi	s1,s7,8
 598:	4681                	li	a3,0
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e2fff0ef          	jal	3d0 <printint>
        i += 2;
 5a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	b731                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4641                	li	a2,16
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e15ff0ef          	jal	3d0 <printint>
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bdd5                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	dfdff0ef          	jal	3d0 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bde9                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	de3ff0ef          	jal	3d0 <printint>
        i += 2;
 5f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	b5c1                	j	4b8 <vprintf+0x44>
 5fa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5fc:	008b8793          	addi	a5,s7,8
 600:	8cbe                	mv	s9,a5
 602:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 606:	03000593          	li	a1,48
 60a:	855a                	mv	a0,s6
 60c:	da7ff0ef          	jal	3b2 <putc>
  putc(fd, 'x');
 610:	07800593          	li	a1,120
 614:	855a                	mv	a0,s6
 616:	d9dff0ef          	jal	3b2 <putc>
 61a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	00000b97          	auipc	s7,0x0
 620:	314b8b93          	addi	s7,s7,788 # 930 <digits>
 624:	03c9d793          	srli	a5,s3,0x3c
 628:	97de                	add	a5,a5,s7
 62a:	0007c583          	lbu	a1,0(a5)
 62e:	855a                	mv	a0,s6
 630:	d83ff0ef          	jal	3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 634:	0992                	slli	s3,s3,0x4
 636:	34fd                	addiw	s1,s1,-1
 638:	f4f5                	bnez	s1,624 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 63a:	8be6                	mv	s7,s9
      state = 0;
 63c:	4981                	li	s3,0
 63e:	6ca2                	ld	s9,8(sp)
 640:	bda5                	j	4b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 642:	008b8993          	addi	s3,s7,8
 646:	000bb483          	ld	s1,0(s7)
 64a:	cc91                	beqz	s1,666 <vprintf+0x1f2>
        for(; *s; s++)
 64c:	0004c583          	lbu	a1,0(s1)
 650:	c985                	beqz	a1,680 <vprintf+0x20c>
          putc(fd, *s);
 652:	855a                	mv	a0,s6
 654:	d5fff0ef          	jal	3b2 <putc>
        for(; *s; s++)
 658:	0485                	addi	s1,s1,1
 65a:	0004c583          	lbu	a1,0(s1)
 65e:	f9f5                	bnez	a1,652 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	bd91                	j	4b8 <vprintf+0x44>
          s = "(null)";
 666:	00000497          	auipc	s1,0x0
 66a:	2c248493          	addi	s1,s1,706 # 928 <malloc+0x12e>
        for(; *s; s++)
 66e:	02800593          	li	a1,40
 672:	b7c5                	j	652 <vprintf+0x1de>
        putc(fd, '%');
 674:	85be                	mv	a1,a5
 676:	855a                	mv	a0,s6
 678:	d3bff0ef          	jal	3b2 <putc>
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd2d                	j	4b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	bd15                	j	4b8 <vprintf+0x44>
 686:	6906                	ld	s2,64(sp)
 688:	79e2                	ld	s3,56(sp)
 68a:	7a42                	ld	s4,48(sp)
 68c:	7aa2                	ld	s5,40(sp)
 68e:	7b02                	ld	s6,32(sp)
 690:	6be2                	ld	s7,24(sp)
 692:	6c42                	ld	s8,16(sp)
    }
  }
}
 694:	60e6                	ld	ra,88(sp)
 696:	6446                	ld	s0,80(sp)
 698:	64a6                	ld	s1,72(sp)
 69a:	6125                	addi	sp,sp,96
 69c:	8082                	ret
      if(c0 == 'd'){
 69e:	06400713          	li	a4,100
 6a2:	e6e789e3          	beq	a5,a4,514 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6a6:	f9478693          	addi	a3,a5,-108
 6aa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6ae:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6b2:	07500513          	li	a0,117
 6b6:	eaa786e3          	beq	a5,a0,562 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ba:	f8b60513          	addi	a0,a2,-117
 6be:	e119                	bnez	a0,6c4 <vprintf+0x250>
 6c0:	ea069de3          	bnez	a3,57a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c4:	f8b58513          	addi	a0,a1,-117
 6c8:	e119                	bnez	a0,6ce <vprintf+0x25a>
 6ca:	ec0715e3          	bnez	a4,594 <vprintf+0x120>
      } else if(c0 == 'x'){
 6ce:	07800513          	li	a0,120
 6d2:	eca78ee3          	beq	a5,a0,5ae <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6d6:	f8860613          	addi	a2,a2,-120
 6da:	e219                	bnez	a2,6e0 <vprintf+0x26c>
 6dc:	ee0695e3          	bnez	a3,5c6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e0:	f8858593          	addi	a1,a1,-120
 6e4:	e199                	bnez	a1,6ea <vprintf+0x276>
 6e6:	ee071de3          	bnez	a4,5e0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6ea:	07000713          	li	a4,112
 6ee:	f0e786e3          	beq	a5,a4,5fa <vprintf+0x186>
      } else if(c0 == 's'){
 6f2:	07300713          	li	a4,115
 6f6:	f4e786e3          	beq	a5,a4,642 <vprintf+0x1ce>
      } else if(c0 == '%'){
 6fa:	02500713          	li	a4,37
 6fe:	f6e78be3          	beq	a5,a4,674 <vprintf+0x200>
        putc(fd, '%');
 702:	02500593          	li	a1,37
 706:	855a                	mv	a0,s6
 708:	cabff0ef          	jal	3b2 <putc>
        putc(fd, c0);
 70c:	85a6                	mv	a1,s1
 70e:	855a                	mv	a0,s6
 710:	ca3ff0ef          	jal	3b2 <putc>
      state = 0;
 714:	4981                	li	s3,0
 716:	b34d                	j	4b8 <vprintf+0x44>

0000000000000718 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 718:	715d                	addi	sp,sp,-80
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	addi	s0,sp,32
 720:	e010                	sd	a2,0(s0)
 722:	e414                	sd	a3,8(s0)
 724:	e818                	sd	a4,16(s0)
 726:	ec1c                	sd	a5,24(s0)
 728:	03043023          	sd	a6,32(s0)
 72c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 730:	8622                	mv	a2,s0
 732:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 736:	d3fff0ef          	jal	474 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6161                	addi	sp,sp,80
 740:	8082                	ret

0000000000000742 <printf>:

void
printf(const char *fmt, ...)
{
 742:	711d                	addi	sp,sp,-96
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e40c                	sd	a1,8(s0)
 74c:	e810                	sd	a2,16(s0)
 74e:	ec14                	sd	a3,24(s0)
 750:	f018                	sd	a4,32(s0)
 752:	f41c                	sd	a5,40(s0)
 754:	03043823          	sd	a6,48(s0)
 758:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	00840613          	addi	a2,s0,8
 760:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 764:	85aa                	mv	a1,a0
 766:	4505                	li	a0,1
 768:	d0dff0ef          	jal	474 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6125                	addi	sp,sp,96
 772:	8082                	ret

0000000000000774 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 774:	1141                	addi	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	00001797          	auipc	a5,0x1
 784:	8807b783          	ld	a5,-1920(a5) # 1000 <freep>
 788:	a039                	j	796 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	6398                	ld	a4,0(a5)
 78c:	00e7e463          	bltu	a5,a4,794 <free+0x20>
 790:	00e6ea63          	bltu	a3,a4,7a4 <free+0x30>
{
 794:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	fed7fae3          	bgeu	a5,a3,78a <free+0x16>
 79a:	6398                	ld	a4,0(a5)
 79c:	00e6e463          	bltu	a3,a4,7a4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	fee7eae3          	bltu	a5,a4,794 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a4:	ff852583          	lw	a1,-8(a0)
 7a8:	6390                	ld	a2,0(a5)
 7aa:	02059813          	slli	a6,a1,0x20
 7ae:	01c85713          	srli	a4,a6,0x1c
 7b2:	9736                	add	a4,a4,a3
 7b4:	02e60563          	beq	a2,a4,7de <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7bc:	4790                	lw	a2,8(a5)
 7be:	02061593          	slli	a1,a2,0x20
 7c2:	01c5d713          	srli	a4,a1,0x1c
 7c6:	973e                	add	a4,a4,a5
 7c8:	02e68263          	beq	a3,a4,7ec <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ce:	00001717          	auipc	a4,0x1
 7d2:	82f73923          	sd	a5,-1998(a4) # 1000 <freep>
}
 7d6:	60a2                	ld	ra,8(sp)
 7d8:	6402                	ld	s0,0(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7de:	4618                	lw	a4,8(a2)
 7e0:	9f2d                	addw	a4,a4,a1
 7e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	6310                	ld	a2,0(a4)
 7ea:	b7f9                	j	7b8 <free+0x44>
    p->s.size += bp->s.size;
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9f31                	addw	a4,a4,a2
 7f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f4:	ff053683          	ld	a3,-16(a0)
 7f8:	bfd1                	j	7cc <free+0x58>

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f04a                	sd	s2,32(sp)
 802:	ec4e                	sd	s3,24(sp)
 804:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 806:	02051993          	slli	s3,a0,0x20
 80a:	0209d993          	srli	s3,s3,0x20
 80e:	09bd                	addi	s3,s3,15
 810:	0049d993          	srli	s3,s3,0x4
 814:	2985                	addiw	s3,s3,1
 816:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 818:	00000517          	auipc	a0,0x0
 81c:	7e853503          	ld	a0,2024(a0) # 1000 <freep>
 820:	c905                	beqz	a0,850 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 824:	4798                	lw	a4,8(a5)
 826:	09377663          	bgeu	a4,s3,8b2 <malloc+0xb8>
 82a:	f426                	sd	s1,40(sp)
 82c:	e852                	sd	s4,16(sp)
 82e:	e456                	sd	s5,8(sp)
 830:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 832:	8a4e                	mv	s4,s3
 834:	6705                	lui	a4,0x1
 836:	00e9f363          	bgeu	s3,a4,83c <malloc+0x42>
 83a:	6a05                	lui	s4,0x1
 83c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 840:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 844:	00000497          	auipc	s1,0x0
 848:	7bc48493          	addi	s1,s1,1980 # 1000 <freep>
  if(p == (char*)-1)
 84c:	5afd                	li	s5,-1
 84e:	a83d                	j	88c <malloc+0x92>
 850:	f426                	sd	s1,40(sp)
 852:	e852                	sd	s4,16(sp)
 854:	e456                	sd	s5,8(sp)
 856:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 858:	00000797          	auipc	a5,0x0
 85c:	7b878793          	addi	a5,a5,1976 # 1010 <base>
 860:	00000717          	auipc	a4,0x0
 864:	7af73023          	sd	a5,1952(a4) # 1000 <freep>
 868:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 86e:	b7d1                	j	832 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	e118                	sd	a4,0(a0)
 874:	a899                	j	8ca <malloc+0xd0>
  hp->s.size = nu;
 876:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87a:	0541                	addi	a0,a0,16
 87c:	ef9ff0ef          	jal	774 <free>
  return freep;
 880:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 882:	c125                	beqz	a0,8e2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	03277163          	bgeu	a4,s2,8aa <malloc+0xb0>
    if(p == freep)
 88c:	6098                	ld	a4,0(s1)
 88e:	853e                	mv	a0,a5
 890:	fef71ae3          	bne	a4,a5,884 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 894:	8552                	mv	a0,s4
 896:	aadff0ef          	jal	342 <sbrk>
  if(p == (char*)-1)
 89a:	fd551ee3          	bne	a0,s5,876 <malloc+0x7c>
        return 0;
 89e:	4501                	li	a0,0
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	a03d                	j	8d6 <malloc+0xdc>
 8aa:	74a2                	ld	s1,40(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b2:	fae90fe3          	beq	s2,a4,870 <malloc+0x76>
        p->s.size -= nunits;
 8b6:	4137073b          	subw	a4,a4,s3
 8ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8bc:	02071693          	slli	a3,a4,0x20
 8c0:	01c6d713          	srli	a4,a3,0x1c
 8c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72a73b23          	sd	a0,1846(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d2:	01078513          	addi	a0,a5,16
  }
}
 8d6:	70e2                	ld	ra,56(sp)
 8d8:	7442                	ld	s0,48(sp)
 8da:	7902                	ld	s2,32(sp)
 8dc:	69e2                	ld	s3,24(sp)
 8de:	6121                	addi	sp,sp,64
 8e0:	8082                	ret
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	b7f5                	j	8d6 <malloc+0xdc>
