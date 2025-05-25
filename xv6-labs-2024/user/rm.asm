
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
  44:	8b058593          	addi	a1,a1,-1872 # 8f0 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	6c6000ef          	jal	710 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2a2000ef          	jal	2f2 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8b258593          	addi	a1,a1,-1870 # 908 <malloc+0x116>
  5e:	4509                	li	a0,2
  60:	6b0000ef          	jal	710 <fprintf>
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

00000000000003a2 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 3a2:	48e1                	li	a7,24
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	fef40593          	addi	a1,s0,-17
 3bc:	fa7ff0ef          	jal	362 <write>
}
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret

00000000000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	7139                	addi	sp,sp,-64
 3ca:	fc06                	sd	ra,56(sp)
 3cc:	f822                	sd	s0,48(sp)
 3ce:	f04a                	sd	s2,32(sp)
 3d0:	ec4e                	sd	s3,24(sp)
 3d2:	0080                	addi	s0,sp,64
 3d4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d6:	cac9                	beqz	a3,468 <printint+0xa0>
 3d8:	01f5d79b          	srliw	a5,a1,0x1f
 3dc:	c7d1                	beqz	a5,468 <printint+0xa0>
    neg = 1;
    x = -xx;
 3de:	40b005bb          	negw	a1,a1
    neg = 1;
 3e2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e4:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3e8:	86ce                	mv	a3,s3
  i = 0;
 3ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	54480813          	addi	a6,a6,1348 # 930 <digits>
 3f4:	88ba                	mv	a7,a4
 3f6:	0017051b          	addiw	a0,a4,1
 3fa:	872a                	mv	a4,a0
 3fc:	02c5f7bb          	remuw	a5,a1,a2
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	97c2                	add	a5,a5,a6
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40e:	87ae                	mv	a5,a1
 410:	02c5d5bb          	divuw	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fcc7ffe3          	bgeu	a5,a2,3f4 <printint+0x2c>
  if(neg)
 41a:	00030c63          	beqz	t1,432 <printint+0x6a>
    buf[i++] = '-';
 41e:	fd050793          	addi	a5,a0,-48
 422:	00878533          	add	a0,a5,s0
 426:	02d00793          	li	a5,45
 42a:	fef50823          	sb	a5,-16(a0)
 42e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 432:	02e05563          	blez	a4,45c <printint+0x94>
 436:	f426                	sd	s1,40(sp)
 438:	377d                	addiw	a4,a4,-1
 43a:	00e984b3          	add	s1,s3,a4
 43e:	19fd                	addi	s3,s3,-1
 440:	99ba                	add	s3,s3,a4
 442:	1702                	slli	a4,a4,0x20
 444:	9301                	srli	a4,a4,0x20
 446:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44a:	0004c583          	lbu	a1,0(s1)
 44e:	854a                	mv	a0,s2
 450:	f5bff0ef          	jal	3aa <putc>
  while(--i >= 0)
 454:	14fd                	addi	s1,s1,-1
 456:	ff349ae3          	bne	s1,s3,44a <printint+0x82>
 45a:	74a2                	ld	s1,40(sp)
}
 45c:	70e2                	ld	ra,56(sp)
 45e:	7442                	ld	s0,48(sp)
 460:	7902                	ld	s2,32(sp)
 462:	69e2                	ld	s3,24(sp)
 464:	6121                	addi	sp,sp,64
 466:	8082                	ret
  neg = 0;
 468:	4301                	li	t1,0
 46a:	bfad                	j	3e4 <printint+0x1c>

000000000000046c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46c:	711d                	addi	sp,sp,-96
 46e:	ec86                	sd	ra,88(sp)
 470:	e8a2                	sd	s0,80(sp)
 472:	e4a6                	sd	s1,72(sp)
 474:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 476:	0005c483          	lbu	s1,0(a1)
 47a:	20048963          	beqz	s1,68c <vprintf+0x220>
 47e:	e0ca                	sd	s2,64(sp)
 480:	fc4e                	sd	s3,56(sp)
 482:	f852                	sd	s4,48(sp)
 484:	f456                	sd	s5,40(sp)
 486:	f05a                	sd	s6,32(sp)
 488:	ec5e                	sd	s7,24(sp)
 48a:	e862                	sd	s8,16(sp)
 48c:	8b2a                	mv	s6,a0
 48e:	8a2e                	mv	s4,a1
 490:	8bb2                	mv	s7,a2
  state = 0;
 492:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 494:	4901                	li	s2,0
 496:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 498:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49c:	06400c13          	li	s8,100
 4a0:	a00d                	j	4c2 <vprintf+0x56>
        putc(fd, c0);
 4a2:	85a6                	mv	a1,s1
 4a4:	855a                	mv	a0,s6
 4a6:	f05ff0ef          	jal	3aa <putc>
 4aa:	a019                	j	4b0 <vprintf+0x44>
    } else if(state == '%'){
 4ac:	03598363          	beq	s3,s5,4d2 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b0:	0019079b          	addiw	a5,s2,1
 4b4:	893e                	mv	s2,a5
 4b6:	873e                	mv	a4,a5
 4b8:	97d2                	add	a5,a5,s4
 4ba:	0007c483          	lbu	s1,0(a5)
 4be:	1c048063          	beqz	s1,67e <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4c2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c6:	fe0993e3          	bnez	s3,4ac <vprintf+0x40>
      if(c0 == '%'){
 4ca:	fd579ce3          	bne	a5,s5,4a2 <vprintf+0x36>
        state = '%';
 4ce:	89be                	mv	s3,a5
 4d0:	b7c5                	j	4b0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d2:	00ea06b3          	add	a3,s4,a4
 4d6:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4da:	1a060e63          	beqz	a2,696 <vprintf+0x22a>
      if(c0 == 'd'){
 4de:	03878763          	beq	a5,s8,50c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e2:	f9478693          	addi	a3,a5,-108
 4e6:	0016b693          	seqz	a3,a3
 4ea:	f9c60593          	addi	a1,a2,-100
 4ee:	e99d                	bnez	a1,524 <vprintf+0xb8>
 4f0:	ca95                	beqz	a3,524 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f2:	008b8493          	addi	s1,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	ec9ff0ef          	jal	3c8 <printint>
        i += 1;
 504:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 506:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 508:	4981                	li	s3,0
 50a:	b75d                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b8493          	addi	s1,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	eafff0ef          	jal	3c8 <printint>
 51e:	8ba6                	mv	s7,s1
      state = 0;
 520:	4981                	li	s3,0
 522:	b779                	j	4b0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	9752                	add	a4,a4,s4
 526:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52a:	f9460713          	addi	a4,a2,-108
 52e:	00173713          	seqz	a4,a4
 532:	8f75                	and	a4,a4,a3
 534:	f9c58513          	addi	a0,a1,-100
 538:	16051963          	bnez	a0,6aa <vprintf+0x23e>
 53c:	16070763          	beqz	a4,6aa <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 540:	008b8493          	addi	s1,s7,8
 544:	4685                	li	a3,1
 546:	4629                	li	a2,10
 548:	000ba583          	lw	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e7bff0ef          	jal	3c8 <printint>
        i += 2;
 552:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
        i += 2;
 558:	bfa1                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4681                	li	a3,0
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e61ff0ef          	jal	3c8 <printint>
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	b781                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e49ff0ef          	jal	3c8 <printint>
        i += 1;
 584:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	b71d                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e2fff0ef          	jal	3c8 <printint>
        i += 2;
 59e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	b731                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e15ff0ef          	jal	3c8 <printint>
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bdd5                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	dfdff0ef          	jal	3c8 <printint>
        i += 1;
 5d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bde9                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	de3ff0ef          	jal	3c8 <printint>
        i += 2;
 5ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	b5c1                	j	4b0 <vprintf+0x44>
 5f2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b8793          	addi	a5,s7,8
 5f8:	8cbe                	mv	s9,a5
 5fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fe:	03000593          	li	a1,48
 602:	855a                	mv	a0,s6
 604:	da7ff0ef          	jal	3aa <putc>
  putc(fd, 'x');
 608:	07800593          	li	a1,120
 60c:	855a                	mv	a0,s6
 60e:	d9dff0ef          	jal	3aa <putc>
 612:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 614:	00000b97          	auipc	s7,0x0
 618:	31cb8b93          	addi	s7,s7,796 # 930 <digits>
 61c:	03c9d793          	srli	a5,s3,0x3c
 620:	97de                	add	a5,a5,s7
 622:	0007c583          	lbu	a1,0(a5)
 626:	855a                	mv	a0,s6
 628:	d83ff0ef          	jal	3aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62c:	0992                	slli	s3,s3,0x4
 62e:	34fd                	addiw	s1,s1,-1
 630:	f4f5                	bnez	s1,61c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 632:	8be6                	mv	s7,s9
      state = 0;
 634:	4981                	li	s3,0
 636:	6ca2                	ld	s9,8(sp)
 638:	bda5                	j	4b0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 63a:	008b8993          	addi	s3,s7,8
 63e:	000bb483          	ld	s1,0(s7)
 642:	cc91                	beqz	s1,65e <vprintf+0x1f2>
        for(; *s; s++)
 644:	0004c583          	lbu	a1,0(s1)
 648:	c985                	beqz	a1,678 <vprintf+0x20c>
          putc(fd, *s);
 64a:	855a                	mv	a0,s6
 64c:	d5fff0ef          	jal	3aa <putc>
        for(; *s; s++)
 650:	0485                	addi	s1,s1,1
 652:	0004c583          	lbu	a1,0(s1)
 656:	f9f5                	bnez	a1,64a <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd91                	j	4b0 <vprintf+0x44>
          s = "(null)";
 65e:	00000497          	auipc	s1,0x0
 662:	2ca48493          	addi	s1,s1,714 # 928 <malloc+0x136>
        for(; *s; s++)
 666:	02800593          	li	a1,40
 66a:	b7c5                	j	64a <vprintf+0x1de>
        putc(fd, '%');
 66c:	85be                	mv	a1,a5
 66e:	855a                	mv	a0,s6
 670:	d3bff0ef          	jal	3aa <putc>
      state = 0;
 674:	4981                	li	s3,0
 676:	bd2d                	j	4b0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd15                	j	4b0 <vprintf+0x44>
 67e:	6906                	ld	s2,64(sp)
 680:	79e2                	ld	s3,56(sp)
 682:	7a42                	ld	s4,48(sp)
 684:	7aa2                	ld	s5,40(sp)
 686:	7b02                	ld	s6,32(sp)
 688:	6be2                	ld	s7,24(sp)
 68a:	6c42                	ld	s8,16(sp)
    }
  }
}
 68c:	60e6                	ld	ra,88(sp)
 68e:	6446                	ld	s0,80(sp)
 690:	64a6                	ld	s1,72(sp)
 692:	6125                	addi	sp,sp,96
 694:	8082                	ret
      if(c0 == 'd'){
 696:	06400713          	li	a4,100
 69a:	e6e789e3          	beq	a5,a4,50c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 69e:	f9478693          	addi	a3,a5,-108
 6a2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6a6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6aa:	07500513          	li	a0,117
 6ae:	eaa786e3          	beq	a5,a0,55a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6b2:	f8b60513          	addi	a0,a2,-117
 6b6:	e119                	bnez	a0,6bc <vprintf+0x250>
 6b8:	ea069de3          	bnez	a3,572 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6bc:	f8b58513          	addi	a0,a1,-117
 6c0:	e119                	bnez	a0,6c6 <vprintf+0x25a>
 6c2:	ec0715e3          	bnez	a4,58c <vprintf+0x120>
      } else if(c0 == 'x'){
 6c6:	07800513          	li	a0,120
 6ca:	eca78ee3          	beq	a5,a0,5a6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ce:	f8860613          	addi	a2,a2,-120
 6d2:	e219                	bnez	a2,6d8 <vprintf+0x26c>
 6d4:	ee0695e3          	bnez	a3,5be <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d8:	f8858593          	addi	a1,a1,-120
 6dc:	e199                	bnez	a1,6e2 <vprintf+0x276>
 6de:	ee071de3          	bnez	a4,5d8 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6e2:	07000713          	li	a4,112
 6e6:	f0e786e3          	beq	a5,a4,5f2 <vprintf+0x186>
      } else if(c0 == 's'){
 6ea:	07300713          	li	a4,115
 6ee:	f4e786e3          	beq	a5,a4,63a <vprintf+0x1ce>
      } else if(c0 == '%'){
 6f2:	02500713          	li	a4,37
 6f6:	f6e78be3          	beq	a5,a4,66c <vprintf+0x200>
        putc(fd, '%');
 6fa:	02500593          	li	a1,37
 6fe:	855a                	mv	a0,s6
 700:	cabff0ef          	jal	3aa <putc>
        putc(fd, c0);
 704:	85a6                	mv	a1,s1
 706:	855a                	mv	a0,s6
 708:	ca3ff0ef          	jal	3aa <putc>
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b34d                	j	4b0 <vprintf+0x44>

0000000000000710 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 710:	715d                	addi	sp,sp,-80
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	addi	s0,sp,32
 718:	e010                	sd	a2,0(s0)
 71a:	e414                	sd	a3,8(s0)
 71c:	e818                	sd	a4,16(s0)
 71e:	ec1c                	sd	a5,24(s0)
 720:	03043023          	sd	a6,32(s0)
 724:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	8622                	mv	a2,s0
 72a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72e:	d3fff0ef          	jal	46c <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <printf>:

void
printf(const char *fmt, ...)
{
 73a:	711d                	addi	sp,sp,-96
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e40c                	sd	a1,8(s0)
 744:	e810                	sd	a2,16(s0)
 746:	ec14                	sd	a3,24(s0)
 748:	f018                	sd	a4,32(s0)
 74a:	f41c                	sd	a5,40(s0)
 74c:	03043823          	sd	a6,48(s0)
 750:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	00840613          	addi	a2,s0,8
 758:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75c:	85aa                	mv	a1,a0
 75e:	4505                	li	a0,1
 760:	d0dff0ef          	jal	46c <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e406                	sd	ra,8(sp)
 770:	e022                	sd	s0,0(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8887b783          	ld	a5,-1912(a5) # 1000 <freep>
 780:	a039                	j	78e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x20>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x30>
{
 78c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x16>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059813          	slli	a6,a1,0x20
 7a6:	01c85713          	srli	a4,a6,0x1c
 7aa:	9736                	add	a4,a4,a3
 7ac:	02e60563          	beq	a2,a4,7d6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061593          	slli	a1,a2,0x20
 7ba:	01c5d713          	srli	a4,a1,0x1c
 7be:	973e                	add	a4,a4,a5
 7c0:	02e68263          	beq	a3,a4,7e4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	60a2                	ld	ra,8(sp)
 7d0:	6402                	ld	s0,0(sp)
 7d2:	0141                	addi	sp,sp,16
 7d4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7d6:	4618                	lw	a4,8(a2)
 7d8:	9f2d                	addw	a4,a4,a1
 7da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7de:	6398                	ld	a4,0(a5)
 7e0:	6310                	ld	a2,0(a4)
 7e2:	b7f9                	j	7b0 <free+0x44>
    p->s.size += bp->s.size;
 7e4:	ff852703          	lw	a4,-8(a0)
 7e8:	9f31                	addw	a4,a4,a2
 7ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ec:	ff053683          	ld	a3,-16(a0)
 7f0:	bfd1                	j	7c4 <free+0x58>

00000000000007f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f2:	7139                	addi	sp,sp,-64
 7f4:	fc06                	sd	ra,56(sp)
 7f6:	f822                	sd	s0,48(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fe:	02051993          	slli	s3,a0,0x20
 802:	0209d993          	srli	s3,s3,0x20
 806:	09bd                	addi	s3,s3,15
 808:	0049d993          	srli	s3,s3,0x4
 80c:	2985                	addiw	s3,s3,1
 80e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 810:	00000517          	auipc	a0,0x0
 814:	7f053503          	ld	a0,2032(a0) # 1000 <freep>
 818:	c905                	beqz	a0,848 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	09377663          	bgeu	a4,s3,8aa <malloc+0xb8>
 822:	f426                	sd	s1,40(sp)
 824:	e852                	sd	s4,16(sp)
 826:	e456                	sd	s5,8(sp)
 828:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 82a:	8a4e                	mv	s4,s3
 82c:	6705                	lui	a4,0x1
 82e:	00e9f363          	bgeu	s3,a4,834 <malloc+0x42>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000497          	auipc	s1,0x0
 840:	7c448493          	addi	s1,s1,1988 # 1000 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a83d                	j	884 <malloc+0x92>
 848:	f426                	sd	s1,40(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 850:	00000797          	auipc	a5,0x0
 854:	7c078793          	addi	a5,a5,1984 # 1010 <base>
 858:	00000717          	auipc	a4,0x0
 85c:	7af73423          	sd	a5,1960(a4) # 1000 <freep>
 860:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 862:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 866:	b7d1                	j	82a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	e118                	sd	a4,0(a0)
 86c:	a899                	j	8c2 <malloc+0xd0>
  hp->s.size = nu;
 86e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 872:	0541                	addi	a0,a0,16
 874:	ef9ff0ef          	jal	76c <free>
  return freep;
 878:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 87a:	c125                	beqz	a0,8da <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	03277163          	bgeu	a4,s2,8a2 <malloc+0xb0>
    if(p == freep)
 884:	6098                	ld	a4,0(s1)
 886:	853e                	mv	a0,a5
 888:	fef71ae3          	bne	a4,a5,87c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 88c:	8552                	mv	a0,s4
 88e:	ab5ff0ef          	jal	342 <sbrk>
  if(p == (char*)-1)
 892:	fd551ee3          	bne	a0,s5,86e <malloc+0x7c>
        return 0;
 896:	4501                	li	a0,0
 898:	74a2                	ld	s1,40(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	a03d                	j	8ce <malloc+0xdc>
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8aa:	fae90fe3          	beq	s2,a4,868 <malloc+0x76>
        p->s.size -= nunits;
 8ae:	4137073b          	subw	a4,a4,s3
 8b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b4:	02071693          	slli	a3,a4,0x20
 8b8:	01c6d713          	srli	a4,a3,0x1c
 8bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72a73f23          	sd	a0,1854(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ca:	01078513          	addi	a0,a5,16
  }
}
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	7902                	ld	s2,32(sp)
 8d4:	69e2                	ld	s3,24(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
 8da:	74a2                	ld	s1,40(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
 8e2:	b7f5                	j	8ce <malloc+0xdc>
