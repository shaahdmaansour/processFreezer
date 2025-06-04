
user/_ptree_binary:     file format elf64-littleriscv


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
   8:	324000ef          	jal	32c <fork>
  if (pid1 == 0) {
   c:	ed1d                	bnez	a0,4a <main+0x4a>
    int pid_left1 = fork();
   e:	31e000ef          	jal	32c <fork>
    if (pid_left1 == 0) {
  12:	e519                	bnez	a0,20 <main+0x20>
      sleep(2);
  14:	4509                	li	a0,2
  16:	376000ef          	jal	38c <sleep>
      exit(0);
  1a:	4501                	li	a0,0
  1c:	318000ef          	jal	334 <exit>
    }
    
    int pid_left2 = fork();
  20:	30c000ef          	jal	32c <fork>
    if (pid_left2 == 0) {
  24:	e519                	bnez	a0,32 <main+0x32>
      sleep(2);
  26:	4509                	li	a0,2
  28:	364000ef          	jal	38c <sleep>
      exit(0);
  2c:	4501                	li	a0,0
  2e:	306000ef          	jal	334 <exit>
    }
    
    sleep(2);
  32:	4509                	li	a0,2
  34:	358000ef          	jal	38c <sleep>
    wait(0);
  38:	4501                	li	a0,0
  3a:	302000ef          	jal	33c <wait>
    wait(0);
  3e:	4501                	li	a0,0
  40:	2fc000ef          	jal	33c <wait>
    exit(0);
  44:	4501                	li	a0,0
  46:	2ee000ef          	jal	334 <exit>
  }
  
  int pid2 = fork();
  4a:	2e2000ef          	jal	32c <fork>
  if (pid2 == 0) {
  4e:	ed1d                	bnez	a0,8c <main+0x8c>
    int pid_right1 = fork();
  50:	2dc000ef          	jal	32c <fork>
    if (pid_right1 == 0) {
  54:	e519                	bnez	a0,62 <main+0x62>
      sleep(2);
  56:	4509                	li	a0,2
  58:	334000ef          	jal	38c <sleep>
      exit(0);
  5c:	4501                	li	a0,0
  5e:	2d6000ef          	jal	334 <exit>
    }
    
    int pid_right2 = fork();
  62:	2ca000ef          	jal	32c <fork>
    if (pid_right2 == 0) {
  66:	e519                	bnez	a0,74 <main+0x74>
      sleep(2);
  68:	4509                	li	a0,2
  6a:	322000ef          	jal	38c <sleep>
      exit(0);
  6e:	4501                	li	a0,0
  70:	2c4000ef          	jal	334 <exit>
    }
    
    sleep(2);
  74:	4509                	li	a0,2
  76:	316000ef          	jal	38c <sleep>
    wait(0);
  7a:	4501                	li	a0,0
  7c:	2c0000ef          	jal	33c <wait>
    wait(0);
  80:	4501                	li	a0,0
  82:	2ba000ef          	jal	33c <wait>
    exit(0);
  86:	4501                	li	a0,0
  88:	2ac000ef          	jal	334 <exit>
  }
  
  sleep(1);
  8c:	4505                	li	a0,1
  8e:	2fe000ef          	jal	38c <sleep>
  ptree();
  92:	35a000ef          	jal	3ec <ptree>
  
  wait(0);
  96:	4501                	li	a0,0
  98:	2a4000ef          	jal	33c <wait>
  wait(0);
  9c:	4501                	li	a0,0
  9e:	29e000ef          	jal	33c <wait>
  exit(0);
  a2:	4501                	li	a0,0
  a4:	290000ef          	jal	334 <exit>

00000000000000a8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e406                	sd	ra,8(sp)
  ac:	e022                	sd	s0,0(sp)
  ae:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b0:	f51ff0ef          	jal	0 <main>
  exit(0);
  b4:	4501                	li	a0,0
  b6:	27e000ef          	jal	334 <exit>

00000000000000ba <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c2:	87aa                	mv	a5,a0
  c4:	0585                	addi	a1,a1,1
  c6:	0785                	addi	a5,a5,1
  c8:	fff5c703          	lbu	a4,-1(a1)
  cc:	fee78fa3          	sb	a4,-1(a5)
  d0:	fb75                	bnez	a4,c4 <strcpy+0xa>
    ;
  return os;
}
  d2:	60a2                	ld	ra,8(sp)
  d4:	6402                	ld	s0,0(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cb91                	beqz	a5,fa <strcmp+0x20>
  e8:	0005c703          	lbu	a4,0(a1)
  ec:	00f71763          	bne	a4,a5,fa <strcmp+0x20>
    p++, q++;
  f0:	0505                	addi	a0,a0,1
  f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	fbe5                	bnez	a5,e8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  fa:	0005c503          	lbu	a0,0(a1)
}
  fe:	40a7853b          	subw	a0,a5,a0
 102:	60a2                	ld	ra,8(sp)
 104:	6402                	ld	s0,0(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret

000000000000010a <strlen>:

uint
strlen(const char *s)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cf91                	beqz	a5,132 <strlen+0x28>
 118:	00150793          	addi	a5,a0,1
 11c:	86be                	mv	a3,a5
 11e:	0785                	addi	a5,a5,1
 120:	fff7c703          	lbu	a4,-1(a5)
 124:	ff65                	bnez	a4,11c <strlen+0x12>
 126:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
  for(n = 0; s[n]; n++)
 132:	4501                	li	a0,0
 134:	bfdd                	j	12a <strlen+0x20>

0000000000000136 <memset>:

void*
memset(void *dst, int c, uint n)
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 13e:	ca19                	beqz	a2,154 <memset+0x1e>
 140:	87aa                	mv	a5,a0
 142:	1602                	slli	a2,a2,0x20
 144:	9201                	srli	a2,a2,0x20
 146:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 14a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14e:	0785                	addi	a5,a5,1
 150:	fee79de3          	bne	a5,a4,14a <memset+0x14>
  }
  return dst;
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strchr>:

char*
strchr(const char *s, char c)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  for(; *s; s++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cf81                	beqz	a5,180 <strchr+0x24>
    if(*s == c)
 16a:	00f58763          	beq	a1,a5,178 <strchr+0x1c>
  for(; *s; s++)
 16e:	0505                	addi	a0,a0,1
 170:	00054783          	lbu	a5,0(a0)
 174:	fbfd                	bnez	a5,16a <strchr+0xe>
      return (char*)s;
  return 0;
 176:	4501                	li	a0,0
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  return 0;
 180:	4501                	li	a0,0
 182:	bfdd                	j	178 <strchr+0x1c>

0000000000000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	711d                	addi	sp,sp,-96
 186:	ec86                	sd	ra,88(sp)
 188:	e8a2                	sd	s0,80(sp)
 18a:	e4a6                	sd	s1,72(sp)
 18c:	e0ca                	sd	s2,64(sp)
 18e:	fc4e                	sd	s3,56(sp)
 190:	f852                	sd	s4,48(sp)
 192:	f456                	sd	s5,40(sp)
 194:	f05a                	sd	s6,32(sp)
 196:	ec5e                	sd	s7,24(sp)
 198:	e862                	sd	s8,16(sp)
 19a:	1080                	addi	s0,sp,96
 19c:	8baa                	mv	s7,a0
 19e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	892a                	mv	s2,a0
 1a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1a4:	faf40b13          	addi	s6,s0,-81
 1a8:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1aa:	8c26                	mv	s8,s1
 1ac:	0014899b          	addiw	s3,s1,1
 1b0:	84ce                	mv	s1,s3
 1b2:	0349d463          	bge	s3,s4,1da <gets+0x56>
    cc = read(0, &c, 1);
 1b6:	8656                	mv	a2,s5
 1b8:	85da                	mv	a1,s6
 1ba:	4501                	li	a0,0
 1bc:	190000ef          	jal	34c <read>
    if(cc < 1)
 1c0:	00a05d63          	blez	a0,1da <gets+0x56>
      break;
    buf[i++] = c;
 1c4:	faf44783          	lbu	a5,-81(s0)
 1c8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1cc:	0905                	addi	s2,s2,1
 1ce:	ff678713          	addi	a4,a5,-10
 1d2:	c319                	beqz	a4,1d8 <gets+0x54>
 1d4:	17cd                	addi	a5,a5,-13
 1d6:	fbf1                	bnez	a5,1aa <gets+0x26>
    buf[i++] = c;
 1d8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1da:	9c5e                	add	s8,s8,s7
 1dc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1e0:	855e                	mv	a0,s7
 1e2:	60e6                	ld	ra,88(sp)
 1e4:	6446                	ld	s0,80(sp)
 1e6:	64a6                	ld	s1,72(sp)
 1e8:	6906                	ld	s2,64(sp)
 1ea:	79e2                	ld	s3,56(sp)
 1ec:	7a42                	ld	s4,48(sp)
 1ee:	7aa2                	ld	s5,40(sp)
 1f0:	7b02                	ld	s6,32(sp)
 1f2:	6be2                	ld	s7,24(sp)
 1f4:	6c42                	ld	s8,16(sp)
 1f6:	6125                	addi	sp,sp,96
 1f8:	8082                	ret

00000000000001fa <stat>:

int
stat(const char *n, struct stat *st)
{
 1fa:	1101                	addi	sp,sp,-32
 1fc:	ec06                	sd	ra,24(sp)
 1fe:	e822                	sd	s0,16(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	4581                	li	a1,0
 208:	194000ef          	jal	39c <open>
  if(fd < 0)
 20c:	02054263          	bltz	a0,230 <stat+0x36>
 210:	e426                	sd	s1,8(sp)
 212:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 214:	85ca                	mv	a1,s2
 216:	14e000ef          	jal	364 <fstat>
 21a:	892a                	mv	s2,a0
  close(fd);
 21c:	8526                	mv	a0,s1
 21e:	1ae000ef          	jal	3cc <close>
  return r;
 222:	64a2                	ld	s1,8(sp)
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	6902                	ld	s2,0(sp)
 22c:	6105                	addi	sp,sp,32
 22e:	8082                	ret
    return -1;
 230:	57fd                	li	a5,-1
 232:	893e                	mv	s2,a5
 234:	bfc5                	j	224 <stat+0x2a>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23e:	00054683          	lbu	a3,0(a0)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	4625                	li	a2,9
 24c:	02f66963          	bltu	a2,a5,27e <atoi+0x48>
 250:	872a                	mv	a4,a0
  n = 0;
 252:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 254:	0705                	addi	a4,a4,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb5                	addw	a5,a5,a3
 262:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 266:	00074683          	lbu	a3,0(a4)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	fef671e3          	bgeu	a2,a5,254 <atoi+0x1e>
  return n;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  n = 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <atoi+0x40>

0000000000000282 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28a:	02b57563          	bgeu	a0,a1,2b4 <memmove+0x32>
    while(n-- > 0)
 28e:	00c05f63          	blez	a2,2ac <memmove+0x2a>
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29a:	872a                	mv	a4,a0
      *dst++ = *src++;
 29c:	0585                	addi	a1,a1,1
 29e:	0705                	addi	a4,a4,1
 2a0:	fff5c683          	lbu	a3,-1(a1)
 2a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a8:	fee79ae3          	bne	a5,a4,29c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
    while(n-- > 0)
 2b4:	fec05ce3          	blez	a2,2ac <memmove+0x2a>
    dst += n;
 2b8:	00c50733          	add	a4,a0,a2
    src += n;
 2bc:	95b2                	add	a1,a1,a2
 2be:	fff6079b          	addiw	a5,a2,-1
 2c2:	1782                	slli	a5,a5,0x20
 2c4:	9381                	srli	a5,a5,0x20
 2c6:	fff7c793          	not	a5,a5
 2ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2cc:	15fd                	addi	a1,a1,-1
 2ce:	177d                	addi	a4,a4,-1
 2d0:	0005c683          	lbu	a3,0(a1)
 2d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d8:	fef71ae3          	bne	a4,a5,2cc <memmove+0x4a>
 2dc:	bfc1                	j	2ac <memmove+0x2a>

00000000000002de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e6:	c61d                	beqz	a2,314 <memcmp+0x36>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	0005c703          	lbu	a4,0(a1)
 2f8:	00e79863          	bne	a5,a4,308 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2fc:	0505                	addi	a0,a0,1
    p2++;
 2fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 300:	fed518e3          	bne	a0,a3,2f0 <memcmp+0x12>
  }
  return 0;
 304:	4501                	li	a0,0
 306:	a019                	j	30c <memcmp+0x2e>
      return *p1 - *p2;
 308:	40e7853b          	subw	a0,a5,a4
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <memcmp+0x2e>

0000000000000318 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 320:	f63ff0ef          	jal	282 <memmove>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <kill>:
.global kill
kill:
 li a7, SYS_kill
 354:	4899                	li	a7,6
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <exec>:
.global exec
exec:
 li a7, SYS_exec
 35c:	489d                	li	a7,7
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 364:	48a1                	li	a7,8
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36c:	48a5                	li	a7,9
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <dup>:
.global dup
dup:
 li a7, SYS_dup
 374:	48a9                	li	a7,10
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37c:	48ad                	li	a7,11
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 384:	48b1                	li	a7,12
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38c:	48b5                	li	a7,13
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 394:	48b9                	li	a7,14
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <open>:
.global open
open:
 li a7, SYS_open
 39c:	48bd                	li	a7,15
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <write>:
.global write
write:
 li a7, SYS_write
 3a4:	48c1                	li	a7,16
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ac:	48c5                	li	a7,17
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b4:	48c9                	li	a7,18
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <link>:
.global link
link:
 li a7, SYS_link
 3bc:	48cd                	li	a7,19
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c4:	48d1                	li	a7,20
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <close>:
.global close
close:
 li a7, SYS_close
 3cc:	48d5                	li	a7,21
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3d4:	48d9                	li	a7,22
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3dc:	48dd                	li	a7,23
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 3e4:	48e1                	li	a7,24
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3ec:	48e5                	li	a7,25
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	1000                	addi	s0,sp,32
 3fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 400:	4605                	li	a2,1
 402:	fef40593          	addi	a1,s0,-17
 406:	f9fff0ef          	jal	3a4 <write>
}
 40a:	60e2                	ld	ra,24(sp)
 40c:	6442                	ld	s0,16(sp)
 40e:	6105                	addi	sp,sp,32
 410:	8082                	ret

0000000000000412 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 412:	7139                	addi	sp,sp,-64
 414:	fc06                	sd	ra,56(sp)
 416:	f822                	sd	s0,48(sp)
 418:	f04a                	sd	s2,32(sp)
 41a:	ec4e                	sd	s3,24(sp)
 41c:	0080                	addi	s0,sp,64
 41e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	cac9                	beqz	a3,4b2 <printint+0xa0>
 422:	01f5d79b          	srliw	a5,a1,0x1f
 426:	c7d1                	beqz	a5,4b2 <printint+0xa0>
    neg = 1;
    x = -xx;
 428:	40b005bb          	negw	a1,a1
    neg = 1;
 42c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 42e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 432:	86ce                	mv	a3,s3
  i = 0;
 434:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 436:	00000817          	auipc	a6,0x0
 43a:	50280813          	addi	a6,a6,1282 # 938 <digits>
 43e:	88ba                	mv	a7,a4
 440:	0017051b          	addiw	a0,a4,1
 444:	872a                	mv	a4,a0
 446:	02c5f7bb          	remuw	a5,a1,a2
 44a:	1782                	slli	a5,a5,0x20
 44c:	9381                	srli	a5,a5,0x20
 44e:	97c2                	add	a5,a5,a6
 450:	0007c783          	lbu	a5,0(a5)
 454:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 458:	87ae                	mv	a5,a1
 45a:	02c5d5bb          	divuw	a1,a1,a2
 45e:	0685                	addi	a3,a3,1
 460:	fcc7ffe3          	bgeu	a5,a2,43e <printint+0x2c>
  if(neg)
 464:	00030c63          	beqz	t1,47c <printint+0x6a>
    buf[i++] = '-';
 468:	fd050793          	addi	a5,a0,-48
 46c:	00878533          	add	a0,a5,s0
 470:	02d00793          	li	a5,45
 474:	fef50823          	sb	a5,-16(a0)
 478:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 47c:	02e05563          	blez	a4,4a6 <printint+0x94>
 480:	f426                	sd	s1,40(sp)
 482:	377d                	addiw	a4,a4,-1
 484:	00e984b3          	add	s1,s3,a4
 488:	19fd                	addi	s3,s3,-1
 48a:	99ba                	add	s3,s3,a4
 48c:	1702                	slli	a4,a4,0x20
 48e:	9301                	srli	a4,a4,0x20
 490:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 494:	0004c583          	lbu	a1,0(s1)
 498:	854a                	mv	a0,s2
 49a:	f5bff0ef          	jal	3f4 <putc>
  while(--i >= 0)
 49e:	14fd                	addi	s1,s1,-1
 4a0:	ff349ae3          	bne	s1,s3,494 <printint+0x82>
 4a4:	74a2                	ld	s1,40(sp)
}
 4a6:	70e2                	ld	ra,56(sp)
 4a8:	7442                	ld	s0,48(sp)
 4aa:	7902                	ld	s2,32(sp)
 4ac:	69e2                	ld	s3,24(sp)
 4ae:	6121                	addi	sp,sp,64
 4b0:	8082                	ret
  neg = 0;
 4b2:	4301                	li	t1,0
 4b4:	bfad                	j	42e <printint+0x1c>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	20048963          	beqz	s1,6d6 <vprintf+0x220>
 4c8:	e0ca                	sd	s2,64(sp)
 4ca:	fc4e                	sd	s3,56(sp)
 4cc:	f852                	sd	s4,48(sp)
 4ce:	f456                	sd	s5,40(sp)
 4d0:	f05a                	sd	s6,32(sp)
 4d2:	ec5e                	sd	s7,24(sp)
 4d4:	e862                	sd	s8,16(sp)
 4d6:	8b2a                	mv	s6,a0
 4d8:	8a2e                	mv	s4,a1
 4da:	8bb2                	mv	s7,a2
  state = 0;
 4dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4de:	4901                	li	s2,0
 4e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e6:	06400c13          	li	s8,100
 4ea:	a00d                	j	50c <vprintf+0x56>
        putc(fd, c0);
 4ec:	85a6                	mv	a1,s1
 4ee:	855a                	mv	a0,s6
 4f0:	f05ff0ef          	jal	3f4 <putc>
 4f4:	a019                	j	4fa <vprintf+0x44>
    } else if(state == '%'){
 4f6:	03598363          	beq	s3,s5,51c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4fa:	0019079b          	addiw	a5,s2,1
 4fe:	893e                	mv	s2,a5
 500:	873e                	mv	a4,a5
 502:	97d2                	add	a5,a5,s4
 504:	0007c483          	lbu	s1,0(a5)
 508:	1c048063          	beqz	s1,6c8 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 50c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 510:	fe0993e3          	bnez	s3,4f6 <vprintf+0x40>
      if(c0 == '%'){
 514:	fd579ce3          	bne	a5,s5,4ec <vprintf+0x36>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7c5                	j	4fa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 51c:	00ea06b3          	add	a3,s4,a4
 520:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	1a060e63          	beqz	a2,6e0 <vprintf+0x22a>
      if(c0 == 'd'){
 528:	03878763          	beq	a5,s8,556 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 52c:	f9478693          	addi	a3,a5,-108
 530:	0016b693          	seqz	a3,a3
 534:	f9c60593          	addi	a1,a2,-100
 538:	e99d                	bnez	a1,56e <vprintf+0xb8>
 53a:	ca95                	beqz	a3,56e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8493          	addi	s1,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	ec9ff0ef          	jal	412 <printint>
        i += 1;
 54e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 552:	4981                	li	s3,0
 554:	b75d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	eafff0ef          	jal	412 <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b779                	j	4fa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 56e:	9752                	add	a4,a4,s4
 570:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	f9460713          	addi	a4,a2,-108
 578:	00173713          	seqz	a4,a4
 57c:	8f75                	and	a4,a4,a3
 57e:	f9c58513          	addi	a0,a1,-100
 582:	16051963          	bnez	a0,6f4 <vprintf+0x23e>
 586:	16070763          	beqz	a4,6f4 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e7bff0ef          	jal	412 <printint>
        i += 2;
 59c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bfa1                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e61ff0ef          	jal	412 <printint>
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b781                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e49ff0ef          	jal	412 <printint>
        i += 1;
 5ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b71d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e2fff0ef          	jal	412 <printint>
        i += 2;
 5e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b731                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e15ff0ef          	jal	412 <printint>
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	bdd5                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	dfdff0ef          	jal	412 <printint>
        i += 1;
 61a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bde9                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	de3ff0ef          	jal	412 <printint>
        i += 2;
 634:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b5c1                	j	4fa <vprintf+0x44>
 63c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 63e:	008b8793          	addi	a5,s7,8
 642:	8cbe                	mv	s9,a5
 644:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	855a                	mv	a0,s6
 64e:	da7ff0ef          	jal	3f4 <putc>
  putc(fd, 'x');
 652:	07800593          	li	a1,120
 656:	855a                	mv	a0,s6
 658:	d9dff0ef          	jal	3f4 <putc>
 65c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	2dab8b93          	addi	s7,s7,730 # 938 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	855a                	mv	a0,s6
 672:	d83ff0ef          	jal	3f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	34fd                	addiw	s1,s1,-1
 67a:	f4f5                	bnez	s1,666 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 67c:	8be6                	mv	s7,s9
      state = 0;
 67e:	4981                	li	s3,0
 680:	6ca2                	ld	s9,8(sp)
 682:	bda5                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 684:	008b8993          	addi	s3,s7,8
 688:	000bb483          	ld	s1,0(s7)
 68c:	cc91                	beqz	s1,6a8 <vprintf+0x1f2>
        for(; *s; s++)
 68e:	0004c583          	lbu	a1,0(s1)
 692:	c985                	beqz	a1,6c2 <vprintf+0x20c>
          putc(fd, *s);
 694:	855a                	mv	a0,s6
 696:	d5fff0ef          	jal	3f4 <putc>
        for(; *s; s++)
 69a:	0485                	addi	s1,s1,1
 69c:	0004c583          	lbu	a1,0(s1)
 6a0:	f9f5                	bnez	a1,694 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	8bce                	mv	s7,s3
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd91                	j	4fa <vprintf+0x44>
          s = "(null)";
 6a8:	00000497          	auipc	s1,0x0
 6ac:	28848493          	addi	s1,s1,648 # 930 <malloc+0xf4>
        for(; *s; s++)
 6b0:	02800593          	li	a1,40
 6b4:	b7c5                	j	694 <vprintf+0x1de>
        putc(fd, '%');
 6b6:	85be                	mv	a1,a5
 6b8:	855a                	mv	a0,s6
 6ba:	d3bff0ef          	jal	3f4 <putc>
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bd2d                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bd15                	j	4fa <vprintf+0x44>
 6c8:	6906                	ld	s2,64(sp)
 6ca:	79e2                	ld	s3,56(sp)
 6cc:	7a42                	ld	s4,48(sp)
 6ce:	7aa2                	ld	s5,40(sp)
 6d0:	7b02                	ld	s6,32(sp)
 6d2:	6be2                	ld	s7,24(sp)
 6d4:	6c42                	ld	s8,16(sp)
    }
  }
}
 6d6:	60e6                	ld	ra,88(sp)
 6d8:	6446                	ld	s0,80(sp)
 6da:	64a6                	ld	s1,72(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret
      if(c0 == 'd'){
 6e0:	06400713          	li	a4,100
 6e4:	e6e789e3          	beq	a5,a4,556 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6e8:	f9478693          	addi	a3,a5,-108
 6ec:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6f0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6f4:	07500513          	li	a0,117
 6f8:	eaa786e3          	beq	a5,a0,5a4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6fc:	f8b60513          	addi	a0,a2,-117
 700:	e119                	bnez	a0,706 <vprintf+0x250>
 702:	ea069de3          	bnez	a3,5bc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 706:	f8b58513          	addi	a0,a1,-117
 70a:	e119                	bnez	a0,710 <vprintf+0x25a>
 70c:	ec0715e3          	bnez	a4,5d6 <vprintf+0x120>
      } else if(c0 == 'x'){
 710:	07800513          	li	a0,120
 714:	eca78ee3          	beq	a5,a0,5f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 718:	f8860613          	addi	a2,a2,-120
 71c:	e219                	bnez	a2,722 <vprintf+0x26c>
 71e:	ee0695e3          	bnez	a3,608 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 722:	f8858593          	addi	a1,a1,-120
 726:	e199                	bnez	a1,72c <vprintf+0x276>
 728:	ee071de3          	bnez	a4,622 <vprintf+0x16c>
      } else if(c0 == 'p'){
 72c:	07000713          	li	a4,112
 730:	f0e786e3          	beq	a5,a4,63c <vprintf+0x186>
      } else if(c0 == 's'){
 734:	07300713          	li	a4,115
 738:	f4e786e3          	beq	a5,a4,684 <vprintf+0x1ce>
      } else if(c0 == '%'){
 73c:	02500713          	li	a4,37
 740:	f6e78be3          	beq	a5,a4,6b6 <vprintf+0x200>
        putc(fd, '%');
 744:	02500593          	li	a1,37
 748:	855a                	mv	a0,s6
 74a:	cabff0ef          	jal	3f4 <putc>
        putc(fd, c0);
 74e:	85a6                	mv	a1,s1
 750:	855a                	mv	a0,s6
 752:	ca3ff0ef          	jal	3f4 <putc>
      state = 0;
 756:	4981                	li	s3,0
 758:	b34d                	j	4fa <vprintf+0x44>

000000000000075a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75a:	715d                	addi	sp,sp,-80
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e010                	sd	a2,0(s0)
 764:	e414                	sd	a3,8(s0)
 766:	e818                	sd	a4,16(s0)
 768:	ec1c                	sd	a5,24(s0)
 76a:	03043023          	sd	a6,32(s0)
 76e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	8622                	mv	a2,s0
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	d3fff0ef          	jal	4b6 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6161                	addi	sp,sp,80
 782:	8082                	ret

0000000000000784 <printf>:

void
printf(const char *fmt, ...)
{
 784:	711d                	addi	sp,sp,-96
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e40c                	sd	a1,8(s0)
 78e:	e810                	sd	a2,16(s0)
 790:	ec14                	sd	a3,24(s0)
 792:	f018                	sd	a4,32(s0)
 794:	f41c                	sd	a5,40(s0)
 796:	03043823          	sd	a6,48(s0)
 79a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	00840613          	addi	a2,s0,8
 7a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a6:	85aa                	mv	a1,a0
 7a8:	4505                	li	a0,1
 7aa:	d0dff0ef          	jal	4b6 <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6125                	addi	sp,sp,96
 7b4:	8082                	ret

00000000000007b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	1141                	addi	sp,sp,-16
 7b8:	e406                	sd	ra,8(sp)
 7ba:	e022                	sd	s0,0(sp)
 7bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	00001797          	auipc	a5,0x1
 7c6:	83e7b783          	ld	a5,-1986(a5) # 1000 <freep>
 7ca:	a039                	j	7d8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x20>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x30>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x16>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059813          	slli	a6,a1,0x20
 7f0:	01c85713          	srli	a4,a6,0x1c
 7f4:	9736                	add	a4,a4,a3
 7f6:	02e60563          	beq	a2,a4,820 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061593          	slli	a1,a2,0x20
 804:	01c5d713          	srli	a4,a1,0x1c
 808:	973e                	add	a4,a4,a5
 80a:	02e68263          	beq	a3,a4,82e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
}
 818:	60a2                	ld	ra,8(sp)
 81a:	6402                	ld	s0,0(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9f2d                	addw	a4,a4,a1
 824:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6310                	ld	a2,0(a4)
 82c:	b7f9                	j	7fa <free+0x44>
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9f31                	addw	a4,a4,a2
 834:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053683          	ld	a3,-16(a0)
 83a:	bfd1                	j	80e <free+0x58>

000000000000083c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f04a                	sd	s2,32(sp)
 844:	ec4e                	sd	s3,24(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051993          	slli	s3,a0,0x20
 84c:	0209d993          	srli	s3,s3,0x20
 850:	09bd                	addi	s3,s3,15
 852:	0049d993          	srli	s3,s3,0x4
 856:	2985                	addiw	s3,s3,1
 858:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 85a:	00000517          	auipc	a0,0x0
 85e:	7a653503          	ld	a0,1958(a0) # 1000 <freep>
 862:	c905                	beqz	a0,892 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	09377663          	bgeu	a4,s3,8f4 <malloc+0xb8>
 86c:	f426                	sd	s1,40(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 874:	8a4e                	mv	s4,s3
 876:	6705                	lui	a4,0x1
 878:	00e9f363          	bgeu	s3,a4,87e <malloc+0x42>
 87c:	6a05                	lui	s4,0x1
 87e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 882:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 886:	00000497          	auipc	s1,0x0
 88a:	77a48493          	addi	s1,s1,1914 # 1000 <freep>
  if(p == (char*)-1)
 88e:	5afd                	li	s5,-1
 890:	a83d                	j	8ce <malloc+0x92>
 892:	f426                	sd	s1,40(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89a:	00000797          	auipc	a5,0x0
 89e:	77678793          	addi	a5,a5,1910 # 1010 <base>
 8a2:	00000717          	auipc	a4,0x0
 8a6:	74f73f23          	sd	a5,1886(a4) # 1000 <freep>
 8aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b0:	b7d1                	j	874 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	e118                	sd	a4,0(a0)
 8b6:	a899                	j	90c <malloc+0xd0>
  hp->s.size = nu;
 8b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8bc:	0541                	addi	a0,a0,16
 8be:	ef9ff0ef          	jal	7b6 <free>
  return freep;
 8c2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c4:	c125                	beqz	a0,924 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	03277163          	bgeu	a4,s2,8ec <malloc+0xb0>
    if(p == freep)
 8ce:	6098                	ld	a4,0(s1)
 8d0:	853e                	mv	a0,a5
 8d2:	fef71ae3          	bne	a4,a5,8c6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d6:	8552                	mv	a0,s4
 8d8:	aadff0ef          	jal	384 <sbrk>
  if(p == (char*)-1)
 8dc:	fd551ee3          	bne	a0,s5,8b8 <malloc+0x7c>
        return 0;
 8e0:	4501                	li	a0,0
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	a03d                	j	918 <malloc+0xdc>
 8ec:	74a2                	ld	s1,40(sp)
 8ee:	6a42                	ld	s4,16(sp)
 8f0:	6aa2                	ld	s5,8(sp)
 8f2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f4:	fae90fe3          	beq	s2,a4,8b2 <malloc+0x76>
        p->s.size -= nunits;
 8f8:	4137073b          	subw	a4,a4,s3
 8fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fe:	02071693          	slli	a3,a4,0x20
 902:	01c6d713          	srli	a4,a3,0x1c
 906:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 908:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90c:	00000717          	auipc	a4,0x0
 910:	6ea73a23          	sd	a0,1780(a4) # 1000 <freep>
      return (void*)(p + 1);
 914:	01078513          	addi	a0,a5,16
  }
}
 918:	70e2                	ld	ra,56(sp)
 91a:	7442                	ld	s0,48(sp)
 91c:	7902                	ld	s2,32(sp)
 91e:	69e2                	ld	s3,24(sp)
 920:	6121                	addi	sp,sp,64
 922:	8082                	ret
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
 92c:	b7f5                	j	918 <malloc+0xdc>
