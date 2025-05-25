
user/_mkdir:     file format elf64-littleriscv


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
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	36c000ef          	jal	394 <mkdir>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2cc000ef          	jal	304 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	88058593          	addi	a1,a1,-1920 # 8c0 <malloc+0xf2>
  48:	4509                	li	a0,2
  4a:	6a2000ef          	jal	6ec <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2b4000ef          	jal	304 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	88258593          	addi	a1,a1,-1918 # 8d8 <malloc+0x10a>
  5e:	4509                	li	a0,2
  60:	68c000ef          	jal	6ec <fprintf>
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
  74:	290000ef          	jal	304 <exit>

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
  d4:	cf99                	beqz	a5,f2 <strlen+0x2a>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x12>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x22>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf81                	beqz	a5,140 <strchr+0x24>
    if(*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfdd                	j	138 <strchr+0x1c>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	7159                	addi	sp,sp,-112
 146:	f486                	sd	ra,104(sp)
 148:	f0a2                	sd	s0,96(sp)
 14a:	eca6                	sd	s1,88(sp)
 14c:	e8ca                	sd	s2,80(sp)
 14e:	e4ce                	sd	s3,72(sp)
 150:	e0d2                	sd	s4,64(sp)
 152:	fc56                	sd	s5,56(sp)
 154:	f85a                	sd	s6,48(sp)
 156:	f45e                	sd	s7,40(sp)
 158:	f062                	sd	s8,32(sp)
 15a:	ec66                	sd	s9,24(sp)
 15c:	e86a                	sd	s10,16(sp)
 15e:	1880                	addi	s0,sp,112
 160:	8caa                	mv	s9,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
 168:	f9f40b13          	addi	s6,s0,-97
 16c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4ba9                	li	s7,10
 170:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 172:	8d26                	mv	s10,s1
 174:	0014899b          	addiw	s3,s1,1
 178:	84ce                	mv	s1,s3
 17a:	0349d563          	bge	s3,s4,1a4 <gets+0x60>
    cc = read(0, &c, 1);
 17e:	8656                	mv	a2,s5
 180:	85da                	mv	a1,s6
 182:	4501                	li	a0,0
 184:	198000ef          	jal	31c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x60>
    buf[i++] = c;
 18c:	f9f44783          	lbu	a5,-97(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01778763          	beq	a5,s7,1a2 <gets+0x5e>
 198:	0905                	addi	s2,s2,1
 19a:	fd879ce3          	bne	a5,s8,172 <gets+0x2e>
    buf[i++] = c;
 19e:	8d4e                	mv	s10,s3
 1a0:	a011                	j	1a4 <gets+0x60>
 1a2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a4:	9d66                	add	s10,s10,s9
 1a6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1aa:	8566                	mv	a0,s9
 1ac:	70a6                	ld	ra,104(sp)
 1ae:	7406                	ld	s0,96(sp)
 1b0:	64e6                	ld	s1,88(sp)
 1b2:	6946                	ld	s2,80(sp)
 1b4:	69a6                	ld	s3,72(sp)
 1b6:	6a06                	ld	s4,64(sp)
 1b8:	7ae2                	ld	s5,56(sp)
 1ba:	7b42                	ld	s6,48(sp)
 1bc:	7ba2                	ld	s7,40(sp)
 1be:	7c02                	ld	s8,32(sp)
 1c0:	6ce2                	ld	s9,24(sp)
 1c2:	6d42                	ld	s10,16(sp)
 1c4:	6165                	addi	sp,sp,112
 1c6:	8082                	ret

00000000000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	e04a                	sd	s2,0(sp)
 1d0:	1000                	addi	s0,sp,32
 1d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	4581                	li	a1,0
 1d6:	196000ef          	jal	36c <open>
  if(fd < 0)
 1da:	02054263          	bltz	a0,1fe <stat+0x36>
 1de:	e426                	sd	s1,8(sp)
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	150000ef          	jal	334 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	1b0000ef          	jal	39c <close>
  return r;
 1f0:	64a2                	ld	s1,8(sp)
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfcd                	j	1f2 <stat+0x2a>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66963          	bltu	a2,a5,24a <atoi+0x48>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1e>
  return n;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfdd                	j	242 <atoi+0x40>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 256:	02b57563          	bgeu	a0,a1,280 <memmove+0x32>
    while(n-- > 0)
 25a:	00c05f63          	blez	a2,278 <memmove+0x2a>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec059e3          	blez	a2,278 <memmove+0x2a>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x4a>
 2a8:	bfc1                	j	278 <memmove+0x2a>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca0d                	beqz	a2,2e4 <memcmp+0x3a>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x16>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x32>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <memcmp+0x32>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	f5fff0ef          	jal	24e <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <kill>:
.global kill
kill:
 li a7, SYS_kill
 324:	4899                	li	a7,6
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exec>:
.global exec
exec:
 li a7, SYS_exec
 32c:	489d                	li	a7,7
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 334:	48a1                	li	a7,8
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33c:	48a5                	li	a7,9
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <dup>:
.global dup
dup:
 li a7, SYS_dup
 344:	48a9                	li	a7,10
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34c:	48ad                	li	a7,11
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 354:	48b1                	li	a7,12
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 35c:	48b5                	li	a7,13
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 364:	48b9                	li	a7,14
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <open>:
.global open
open:
 li a7, SYS_open
 36c:	48bd                	li	a7,15
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <write>:
.global write
write:
 li a7, SYS_write
 374:	48c1                	li	a7,16
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <link>:
.global link
link:
 li a7, SYS_link
 38c:	48cd                	li	a7,19
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 394:	48d1                	li	a7,20
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <close>:
.global close
close:
 li a7, SYS_close
 39c:	48d5                	li	a7,21
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	addi	a1,s0,-17
 3c6:	fafff0ef          	jal	374 <write>
}
 3ca:	60e2                	ld	ra,24(sp)
 3cc:	6442                	ld	s0,16(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret

00000000000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	7139                	addi	sp,sp,-64
 3d4:	fc06                	sd	ra,56(sp)
 3d6:	f822                	sd	s0,48(sp)
 3d8:	f426                	sd	s1,40(sp)
 3da:	f04a                	sd	s2,32(sp)
 3dc:	ec4e                	sd	s3,24(sp)
 3de:	0080                	addi	s0,sp,64
 3e0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e2:	c299                	beqz	a3,3e8 <printint+0x16>
 3e4:	0605ce63          	bltz	a1,460 <printint+0x8e>
  neg = 0;
 3e8:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3ea:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3ee:	869a                	mv	a3,t1
  i = 0;
 3f0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3f2:	00000817          	auipc	a6,0x0
 3f6:	50e80813          	addi	a6,a6,1294 # 900 <digits>
 3fa:	88be                	mv	a7,a5
 3fc:	0017851b          	addiw	a0,a5,1
 400:	87aa                	mv	a5,a0
 402:	02c5f73b          	remuw	a4,a1,a2
 406:	1702                	slli	a4,a4,0x20
 408:	9301                	srli	a4,a4,0x20
 40a:	9742                	add	a4,a4,a6
 40c:	00074703          	lbu	a4,0(a4)
 410:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 414:	872e                	mv	a4,a1
 416:	02c5d5bb          	divuw	a1,a1,a2
 41a:	0685                	addi	a3,a3,1
 41c:	fcc77fe3          	bgeu	a4,a2,3fa <printint+0x28>
  if(neg)
 420:	000e0c63          	beqz	t3,438 <printint+0x66>
    buf[i++] = '-';
 424:	fd050793          	addi	a5,a0,-48
 428:	00878533          	add	a0,a5,s0
 42c:	02d00793          	li	a5,45
 430:	fef50823          	sb	a5,-16(a0)
 434:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 438:	fff7899b          	addiw	s3,a5,-1
 43c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 440:	fff4c583          	lbu	a1,-1(s1)
 444:	854a                	mv	a0,s2
 446:	f6fff0ef          	jal	3b4 <putc>
  while(--i >= 0)
 44a:	39fd                	addiw	s3,s3,-1
 44c:	14fd                	addi	s1,s1,-1
 44e:	fe09d9e3          	bgez	s3,440 <printint+0x6e>
}
 452:	70e2                	ld	ra,56(sp)
 454:	7442                	ld	s0,48(sp)
 456:	74a2                	ld	s1,40(sp)
 458:	7902                	ld	s2,32(sp)
 45a:	69e2                	ld	s3,24(sp)
 45c:	6121                	addi	sp,sp,64
 45e:	8082                	ret
    x = -xx;
 460:	40b005bb          	negw	a1,a1
    neg = 1;
 464:	4e05                	li	t3,1
    x = -xx;
 466:	b751                	j	3ea <printint+0x18>

0000000000000468 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 468:	711d                	addi	sp,sp,-96
 46a:	ec86                	sd	ra,88(sp)
 46c:	e8a2                	sd	s0,80(sp)
 46e:	e4a6                	sd	s1,72(sp)
 470:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c483          	lbu	s1,0(a1)
 476:	26048663          	beqz	s1,6e2 <vprintf+0x27a>
 47a:	e0ca                	sd	s2,64(sp)
 47c:	fc4e                	sd	s3,56(sp)
 47e:	f852                	sd	s4,48(sp)
 480:	f456                	sd	s5,40(sp)
 482:	f05a                	sd	s6,32(sp)
 484:	ec5e                	sd	s7,24(sp)
 486:	e862                	sd	s8,16(sp)
 488:	e466                	sd	s9,8(sp)
 48a:	8b2a                	mv	s6,a0
 48c:	8a2e                	mv	s4,a1
 48e:	8bb2                	mv	s7,a2
  state = 0;
 490:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 492:	4901                	li	s2,0
 494:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 496:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 49e:	06c00c93          	li	s9,108
 4a2:	a00d                	j	4c4 <vprintf+0x5c>
        putc(fd, c0);
 4a4:	85a6                	mv	a1,s1
 4a6:	855a                	mv	a0,s6
 4a8:	f0dff0ef          	jal	3b4 <putc>
 4ac:	a019                	j	4b2 <vprintf+0x4a>
    } else if(state == '%'){
 4ae:	03598363          	beq	s3,s5,4d4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4b2:	0019079b          	addiw	a5,s2,1
 4b6:	893e                	mv	s2,a5
 4b8:	873e                	mv	a4,a5
 4ba:	97d2                	add	a5,a5,s4
 4bc:	0007c483          	lbu	s1,0(a5)
 4c0:	20048963          	beqz	s1,6d2 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4c4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c8:	fe0993e3          	bnez	s3,4ae <vprintf+0x46>
      if(c0 == '%'){
 4cc:	fd579ce3          	bne	a5,s5,4a4 <vprintf+0x3c>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7c5                	j	4b2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d4:	00ea06b3          	add	a3,s4,a4
 4d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4de:	c681                	beqz	a3,4e6 <vprintf+0x7e>
 4e0:	9752                	add	a4,a4,s4
 4e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e6:	03878e63          	beq	a5,s8,522 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	05978863          	beq	a5,s9,53a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ee:	07500713          	li	a4,117
 4f2:	0ee78263          	beq	a5,a4,5d6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f6:	07800713          	li	a4,120
 4fa:	12e78463          	beq	a5,a4,622 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4fe:	07000713          	li	a4,112
 502:	14e78963          	beq	a5,a4,654 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 506:	07300713          	li	a4,115
 50a:	18e78863          	beq	a5,a4,69a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 50e:	02500713          	li	a4,37
 512:	04e79463          	bne	a5,a4,55a <vprintf+0xf2>
        putc(fd, '%');
 516:	85ba                	mv	a1,a4
 518:	855a                	mv	a0,s6
 51a:	e9bff0ef          	jal	3b4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 51e:	4981                	li	s3,0
 520:	bf49                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 522:	008b8493          	addi	s1,s7,8
 526:	4685                	li	a3,1
 528:	4629                	li	a2,10
 52a:	000ba583          	lw	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	ea3ff0ef          	jal	3d2 <printint>
 534:	8ba6                	mv	s7,s1
      state = 0;
 536:	4981                	li	s3,0
 538:	bfad                	j	4b2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	06400793          	li	a5,100
 53e:	02f68963          	beq	a3,a5,570 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 542:	06c00793          	li	a5,108
 546:	04f68263          	beq	a3,a5,58a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 54a:	07500793          	li	a5,117
 54e:	0af68063          	beq	a3,a5,5ee <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 552:	07800793          	li	a5,120
 556:	0ef68263          	beq	a3,a5,63a <vprintf+0x1d2>
        putc(fd, '%');
 55a:	02500593          	li	a1,37
 55e:	855a                	mv	a0,s6
 560:	e55ff0ef          	jal	3b4 <putc>
        putc(fd, c0);
 564:	85a6                	mv	a1,s1
 566:	855a                	mv	a0,s6
 568:	e4dff0ef          	jal	3b4 <putc>
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b791                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	008b8493          	addi	s1,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e55ff0ef          	jal	3d2 <printint>
        i += 1;
 582:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
        i += 1;
 588:	b72d                	j	4b2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58a:	06400793          	li	a5,100
 58e:	02f60763          	beq	a2,a5,5bc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 592:	07500793          	li	a5,117
 596:	06f60963          	beq	a2,a5,608 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 59a:	07800793          	li	a5,120
 59e:	faf61ee3          	bne	a2,a5,55a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e23ff0ef          	jal	3d2 <printint>
        i += 2;
 5b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	bde5                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e09ff0ef          	jal	3d2 <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bdf9                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	defff0ef          	jal	3d2 <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b5d9                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	dd7ff0ef          	jal	3d2 <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
        i += 1;
 606:	b575                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	dbdff0ef          	jal	3d2 <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	bd49                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	da3ff0ef          	jal	3d2 <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	bdad                	j	4b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d8bff0ef          	jal	3d2 <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b585                	j	4b2 <vprintf+0x4a>
 654:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 656:	008b8d13          	addi	s10,s7,8
 65a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65e:	03000593          	li	a1,48
 662:	855a                	mv	a0,s6
 664:	d51ff0ef          	jal	3b4 <putc>
  putc(fd, 'x');
 668:	07800593          	li	a1,120
 66c:	855a                	mv	a0,s6
 66e:	d47ff0ef          	jal	3b4 <putc>
 672:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	00000b97          	auipc	s7,0x0
 678:	28cb8b93          	addi	s7,s7,652 # 900 <digits>
 67c:	03c9d793          	srli	a5,s3,0x3c
 680:	97de                	add	a5,a5,s7
 682:	0007c583          	lbu	a1,0(a5)
 686:	855a                	mv	a0,s6
 688:	d2dff0ef          	jal	3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68c:	0992                	slli	s3,s3,0x4
 68e:	34fd                	addiw	s1,s1,-1
 690:	f4f5                	bnez	s1,67c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 692:	8bea                	mv	s7,s10
      state = 0;
 694:	4981                	li	s3,0
 696:	6d02                	ld	s10,0(sp)
 698:	bd29                	j	4b2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 69a:	008b8993          	addi	s3,s7,8
 69e:	000bb483          	ld	s1,0(s7)
 6a2:	cc91                	beqz	s1,6be <vprintf+0x256>
        for(; *s; s++)
 6a4:	0004c583          	lbu	a1,0(s1)
 6a8:	c195                	beqz	a1,6cc <vprintf+0x264>
          putc(fd, *s);
 6aa:	855a                	mv	a0,s6
 6ac:	d09ff0ef          	jal	3b4 <putc>
        for(; *s; s++)
 6b0:	0485                	addi	s1,s1,1
 6b2:	0004c583          	lbu	a1,0(s1)
 6b6:	f9f5                	bnez	a1,6aa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	8bce                	mv	s7,s3
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bbdd                	j	4b2 <vprintf+0x4a>
          s = "(null)";
 6be:	00000497          	auipc	s1,0x0
 6c2:	23a48493          	addi	s1,s1,570 # 8f8 <malloc+0x12a>
        for(; *s; s++)
 6c6:	02800593          	li	a1,40
 6ca:	b7c5                	j	6aa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b3cd                	j	4b2 <vprintf+0x4a>
 6d2:	6906                	ld	s2,64(sp)
 6d4:	79e2                	ld	s3,56(sp)
 6d6:	7a42                	ld	s4,48(sp)
 6d8:	7aa2                	ld	s5,40(sp)
 6da:	7b02                	ld	s6,32(sp)
 6dc:	6be2                	ld	s7,24(sp)
 6de:	6c42                	ld	s8,16(sp)
 6e0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6e2:	60e6                	ld	ra,88(sp)
 6e4:	6446                	ld	s0,80(sp)
 6e6:	64a6                	ld	s1,72(sp)
 6e8:	6125                	addi	sp,sp,96
 6ea:	8082                	ret

00000000000006ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ec:	715d                	addi	sp,sp,-80
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	e010                	sd	a2,0(s0)
 6f6:	e414                	sd	a3,8(s0)
 6f8:	e818                	sd	a4,16(s0)
 6fa:	ec1c                	sd	a5,24(s0)
 6fc:	03043023          	sd	a6,32(s0)
 700:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 704:	8622                	mv	a2,s0
 706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70a:	d5fff0ef          	jal	468 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6161                	addi	sp,sp,80
 714:	8082                	ret

0000000000000716 <printf>:

void
printf(const char *fmt, ...)
{
 716:	711d                	addi	sp,sp,-96
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e40c                	sd	a1,8(s0)
 720:	e810                	sd	a2,16(s0)
 722:	ec14                	sd	a3,24(s0)
 724:	f018                	sd	a4,32(s0)
 726:	f41c                	sd	a5,40(s0)
 728:	03043823          	sd	a6,48(s0)
 72c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 730:	00840613          	addi	a2,s0,8
 734:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 738:	85aa                	mv	a1,a0
 73a:	4505                	li	a0,1
 73c:	d2dff0ef          	jal	468 <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret

0000000000000748 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 748:	1141                	addi	sp,sp,-16
 74a:	e406                	sd	ra,8(sp)
 74c:	e022                	sd	s0,0(sp)
 74e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 750:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	00001797          	auipc	a5,0x1
 758:	8ac7b783          	ld	a5,-1876(a5) # 1000 <freep>
 75c:	a02d                	j	786 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75e:	4618                	lw	a4,8(a2)
 760:	9f2d                	addw	a4,a4,a1
 762:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	6398                	ld	a4,0(a5)
 768:	6310                	ld	a2,0(a4)
 76a:	a83d                	j	7a8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 76c:	ff852703          	lw	a4,-8(a0)
 770:	9f31                	addw	a4,a4,a2
 772:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 774:	ff053683          	ld	a3,-16(a0)
 778:	a091                	j	7bc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	6398                	ld	a4,0(a5)
 77c:	00e7e463          	bltu	a5,a4,784 <free+0x3c>
 780:	00e6ea63          	bltu	a3,a4,794 <free+0x4c>
{
 784:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	fed7fae3          	bgeu	a5,a3,77a <free+0x32>
 78a:	6398                	ld	a4,0(a5)
 78c:	00e6e463          	bltu	a3,a4,794 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	fee7eae3          	bltu	a5,a4,784 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 794:	ff852583          	lw	a1,-8(a0)
 798:	6390                	ld	a2,0(a5)
 79a:	02059813          	slli	a6,a1,0x20
 79e:	01c85713          	srli	a4,a6,0x1c
 7a2:	9736                	add	a4,a4,a3
 7a4:	fae60de3          	beq	a2,a4,75e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ac:	4790                	lw	a2,8(a5)
 7ae:	02061593          	slli	a1,a2,0x20
 7b2:	01c5d713          	srli	a4,a1,0x1c
 7b6:	973e                	add	a4,a4,a5
 7b8:	fae68ae3          	beq	a3,a4,76c <free+0x24>
    p->s.ptr = bp->s.ptr;
 7bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7be:	00001717          	auipc	a4,0x1
 7c2:	84f73123          	sd	a5,-1982(a4) # 1000 <freep>
}
 7c6:	60a2                	ld	ra,8(sp)
 7c8:	6402                	ld	s0,0(sp)
 7ca:	0141                	addi	sp,sp,16
 7cc:	8082                	ret

00000000000007ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ce:	7139                	addi	sp,sp,-64
 7d0:	fc06                	sd	ra,56(sp)
 7d2:	f822                	sd	s0,48(sp)
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	ec4e                	sd	s3,24(sp)
 7d8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7da:	02051993          	slli	s3,a0,0x20
 7de:	0209d993          	srli	s3,s3,0x20
 7e2:	09bd                	addi	s3,s3,15
 7e4:	0049d993          	srli	s3,s3,0x4
 7e8:	2985                	addiw	s3,s3,1
 7ea:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ec:	00001517          	auipc	a0,0x1
 7f0:	81453503          	ld	a0,-2028(a0) # 1000 <freep>
 7f4:	c905                	beqz	a0,824 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	09377663          	bgeu	a4,s3,886 <malloc+0xb8>
 7fe:	f426                	sd	s1,40(sp)
 800:	e852                	sd	s4,16(sp)
 802:	e456                	sd	s5,8(sp)
 804:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 806:	8a4e                	mv	s4,s3
 808:	6705                	lui	a4,0x1
 80a:	00e9f363          	bgeu	s3,a4,810 <malloc+0x42>
 80e:	6a05                	lui	s4,0x1
 810:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 814:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 818:	00000497          	auipc	s1,0x0
 81c:	7e848493          	addi	s1,s1,2024 # 1000 <freep>
  if(p == (char*)-1)
 820:	5afd                	li	s5,-1
 822:	a83d                	j	860 <malloc+0x92>
 824:	f426                	sd	s1,40(sp)
 826:	e852                	sd	s4,16(sp)
 828:	e456                	sd	s5,8(sp)
 82a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 82c:	00000797          	auipc	a5,0x0
 830:	7e478793          	addi	a5,a5,2020 # 1010 <base>
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 842:	b7d1                	j	806 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 844:	6398                	ld	a4,0(a5)
 846:	e118                	sd	a4,0(a0)
 848:	a899                	j	89e <malloc+0xd0>
  hp->s.size = nu;
 84a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84e:	0541                	addi	a0,a0,16
 850:	ef9ff0ef          	jal	748 <free>
  return freep;
 854:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 856:	c125                	beqz	a0,8b6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	03277163          	bgeu	a4,s2,87e <malloc+0xb0>
    if(p == freep)
 860:	6098                	ld	a4,0(s1)
 862:	853e                	mv	a0,a5
 864:	fef71ae3          	bne	a4,a5,858 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 868:	8552                	mv	a0,s4
 86a:	aebff0ef          	jal	354 <sbrk>
  if(p == (char*)-1)
 86e:	fd551ee3          	bne	a0,s5,84a <malloc+0x7c>
        return 0;
 872:	4501                	li	a0,0
 874:	74a2                	ld	s1,40(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	a03d                	j	8aa <malloc+0xdc>
 87e:	74a2                	ld	s1,40(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 886:	fae90fe3          	beq	s2,a4,844 <malloc+0x76>
        p->s.size -= nunits;
 88a:	4137073b          	subw	a4,a4,s3
 88e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 890:	02071693          	slli	a3,a4,0x20
 894:	01c6d713          	srli	a4,a3,0x1c
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76a73123          	sd	a0,1890(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	addi	a0,a5,16
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	7902                	ld	s2,32(sp)
 8b0:	69e2                	ld	s3,24(sp)
 8b2:	6121                	addi	sp,sp,64
 8b4:	8082                	ret
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	b7f5                	j	8aa <malloc+0xdc>
