
user/_ptree_mixed:     file format elf64-littleriscv


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
   8:	342000ef          	jal	34a <fork>
  if (pid1 == 0) {
   c:	e90d                	bnez	a0,3e <main+0x3e>
    int pid_deep = fork();
   e:	33c000ef          	jal	34a <fork>
    if (pid_deep == 0) {
  12:	e105                	bnez	a0,32 <main+0x32>
      int pid_deeper = fork();
  14:	336000ef          	jal	34a <fork>
      if (pid_deeper == 0) {
  18:	e519                	bnez	a0,26 <main+0x26>
        sleep(3);
  1a:	450d                	li	a0,3
  1c:	38e000ef          	jal	3aa <sleep>
        exit(0);
  20:	4501                	li	a0,0
  22:	330000ef          	jal	352 <exit>
      }
      wait(0);
  26:	4501                	li	a0,0
  28:	332000ef          	jal	35a <wait>
      exit(0);
  2c:	4501                	li	a0,0
  2e:	324000ef          	jal	352 <exit>
    }
    wait(0);
  32:	4501                	li	a0,0
  34:	326000ef          	jal	35a <wait>
    exit(0);
  38:	4501                	li	a0,0
  3a:	318000ef          	jal	352 <exit>
  }
  
  int pid2 = fork();
  3e:	30c000ef          	jal	34a <fork>
  if (pid2 == 0) {
  42:	e921                	bnez	a0,92 <main+0x92>
    int pid_wide1 = fork();
  44:	306000ef          	jal	34a <fork>
    if (pid_wide1 == 0) {
  48:	e519                	bnez	a0,56 <main+0x56>
      sleep(3);
  4a:	450d                	li	a0,3
  4c:	35e000ef          	jal	3aa <sleep>
      exit(0);
  50:	4501                	li	a0,0
  52:	300000ef          	jal	352 <exit>
    }
    
    int pid_wide2 = fork();
  56:	2f4000ef          	jal	34a <fork>
    if (pid_wide2 == 0) {
  5a:	e519                	bnez	a0,68 <main+0x68>
      sleep(3);
  5c:	450d                	li	a0,3
  5e:	34c000ef          	jal	3aa <sleep>
      exit(0);
  62:	4501                	li	a0,0
  64:	2ee000ef          	jal	352 <exit>
    }
    
    int pid_wide3 = fork();
  68:	2e2000ef          	jal	34a <fork>
    if (pid_wide3 == 0) {
  6c:	e519                	bnez	a0,7a <main+0x7a>
      sleep(3);
  6e:	450d                	li	a0,3
  70:	33a000ef          	jal	3aa <sleep>
      exit(0);
  74:	4501                	li	a0,0
  76:	2dc000ef          	jal	352 <exit>
    }
    
    wait(0);
  7a:	4501                	li	a0,0
  7c:	2de000ef          	jal	35a <wait>
    wait(0);
  80:	4501                	li	a0,0
  82:	2d8000ef          	jal	35a <wait>
    wait(0);
  86:	4501                	li	a0,0
  88:	2d2000ef          	jal	35a <wait>
    exit(0);
  8c:	4501                	li	a0,0
  8e:	2c4000ef          	jal	352 <exit>
  }
  
  int pid3 = fork();
  92:	2b8000ef          	jal	34a <fork>
  if (pid3 == 0) {
  96:	e519                	bnez	a0,a4 <main+0xa4>
    sleep(3);
  98:	450d                	li	a0,3
  9a:	310000ef          	jal	3aa <sleep>
    exit(0);
  9e:	4501                	li	a0,0
  a0:	2b2000ef          	jal	352 <exit>
  }
  
  sleep(1);
  a4:	4505                	li	a0,1
  a6:	304000ef          	jal	3aa <sleep>
  ptree();
  aa:	360000ef          	jal	40a <ptree>
  
  wait(0);
  ae:	4501                	li	a0,0
  b0:	2aa000ef          	jal	35a <wait>
  wait(0);
  b4:	4501                	li	a0,0
  b6:	2a4000ef          	jal	35a <wait>
  wait(0);
  ba:	4501                	li	a0,0
  bc:	29e000ef          	jal	35a <wait>
  exit(0);
  c0:	4501                	li	a0,0
  c2:	290000ef          	jal	352 <exit>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ce:	f33ff0ef          	jal	0 <main>
  exit(0);
  d2:	4501                	li	a0,0
  d4:	27e000ef          	jal	352 <exit>

00000000000000d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	87aa                	mv	a5,a0
  e2:	0585                	addi	a1,a1,1
  e4:	0785                	addi	a5,a5,1
  e6:	fff5c703          	lbu	a4,-1(a1)
  ea:	fee78fa3          	sb	a4,-1(a5)
  ee:	fb75                	bnez	a4,e2 <strcpy+0xa>
    ;
  return os;
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb91                	beqz	a5,118 <strcmp+0x20>
 106:	0005c703          	lbu	a4,0(a1)
 10a:	00f71763          	bne	a4,a5,118 <strcmp+0x20>
    p++, q++;
 10e:	0505                	addi	a0,a0,1
 110:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 112:	00054783          	lbu	a5,0(a0)
 116:	fbe5                	bnez	a5,106 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 118:	0005c503          	lbu	a0,0(a1)
}
 11c:	40a7853b          	subw	a0,a5,a0
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strlen>:

uint
strlen(const char *s)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cf91                	beqz	a5,150 <strlen+0x28>
 136:	00150793          	addi	a5,a0,1
 13a:	86be                	mv	a3,a5
 13c:	0785                	addi	a5,a5,1
 13e:	fff7c703          	lbu	a4,-1(a5)
 142:	ff65                	bnez	a4,13a <strlen+0x12>
 144:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for(n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfdd                	j	148 <strlen+0x20>

0000000000000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15c:	ca19                	beqz	a2,172 <memset+0x1e>
 15e:	87aa                	mv	a5,a0
 160:	1602                	slli	a2,a2,0x20
 162:	9201                	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x14>
  }
  return dst;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  for(; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf81                	beqz	a5,19e <strchr+0x24>
    if(*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1c>
  for(; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xe>
      return (char*)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfdd                	j	196 <strchr+0x1c>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	e862                	sd	s8,16(sp)
 1b8:	1080                	addi	s0,sp,96
 1ba:	8baa                	mv	s7,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c2:	faf40b13          	addi	s6,s0,-81
 1c6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1c8:	8c26                	mv	s8,s1
 1ca:	0014899b          	addiw	s3,s1,1
 1ce:	84ce                	mv	s1,s3
 1d0:	0349d463          	bge	s3,s4,1f8 <gets+0x56>
    cc = read(0, &c, 1);
 1d4:	8656                	mv	a2,s5
 1d6:	85da                	mv	a1,s6
 1d8:	4501                	li	a0,0
 1da:	190000ef          	jal	36a <read>
    if(cc < 1)
 1de:	00a05d63          	blez	a0,1f8 <gets+0x56>
      break;
    buf[i++] = c;
 1e2:	faf44783          	lbu	a5,-81(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	0905                	addi	s2,s2,1
 1ec:	ff678713          	addi	a4,a5,-10
 1f0:	c319                	beqz	a4,1f6 <gets+0x54>
 1f2:	17cd                	addi	a5,a5,-13
 1f4:	fbf1                	bnez	a5,1c8 <gets+0x26>
    buf[i++] = c;
 1f6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f8:	9c5e                	add	s8,s8,s7
 1fa:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1fe:	855e                	mv	a0,s7
 200:	60e6                	ld	ra,88(sp)
 202:	6446                	ld	s0,80(sp)
 204:	64a6                	ld	s1,72(sp)
 206:	6906                	ld	s2,64(sp)
 208:	79e2                	ld	s3,56(sp)
 20a:	7a42                	ld	s4,48(sp)
 20c:	7aa2                	ld	s5,40(sp)
 20e:	7b02                	ld	s6,32(sp)
 210:	6be2                	ld	s7,24(sp)
 212:	6c42                	ld	s8,16(sp)
 214:	6125                	addi	sp,sp,96
 216:	8082                	ret

0000000000000218 <stat>:

int
stat(const char *n, struct stat *st)
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e04a                	sd	s2,0(sp)
 220:	1000                	addi	s0,sp,32
 222:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	4581                	li	a1,0
 226:	194000ef          	jal	3ba <open>
  if(fd < 0)
 22a:	02054263          	bltz	a0,24e <stat+0x36>
 22e:	e426                	sd	s1,8(sp)
 230:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 232:	85ca                	mv	a1,s2
 234:	14e000ef          	jal	382 <fstat>
 238:	892a                	mv	s2,a0
  close(fd);
 23a:	8526                	mv	a0,s1
 23c:	1ae000ef          	jal	3ea <close>
  return r;
 240:	64a2                	ld	s1,8(sp)
}
 242:	854a                	mv	a0,s2
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	6902                	ld	s2,0(sp)
 24a:	6105                	addi	sp,sp,32
 24c:	8082                	ret
    return -1;
 24e:	57fd                	li	a5,-1
 250:	893e                	mv	s2,a5
 252:	bfc5                	j	242 <stat+0x2a>

0000000000000254 <atoi>:

int
atoi(const char *s)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054683          	lbu	a3,0(a0)
 260:	fd06879b          	addiw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	4625                	li	a2,9
 26a:	02f66963          	bltu	a2,a5,29c <atoi+0x48>
 26e:	872a                	mv	a4,a0
  n = 0;
 270:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 272:	0705                	addi	a4,a4,1
 274:	0025179b          	slliw	a5,a0,0x2
 278:	9fa9                	addw	a5,a5,a0
 27a:	0017979b          	slliw	a5,a5,0x1
 27e:	9fb5                	addw	a5,a5,a3
 280:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 284:	00074683          	lbu	a3,0(a4)
 288:	fd06879b          	addiw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	fef671e3          	bgeu	a2,a5,272 <atoi+0x1e>
  return n;
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <atoi+0x40>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a8:	02b57563          	bgeu	a0,a1,2d2 <memmove+0x32>
    while(n-- > 0)
 2ac:	00c05f63          	blez	a2,2ca <memmove+0x2a>
 2b0:	1602                	slli	a2,a2,0x20
 2b2:	9201                	srli	a2,a2,0x20
 2b4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ba:	0585                	addi	a1,a1,1
 2bc:	0705                	addi	a4,a4,1
 2be:	fff5c683          	lbu	a3,-1(a1)
 2c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c6:	fee79ae3          	bne	a5,a4,2ba <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    while(n-- > 0)
 2d2:	fec05ce3          	blez	a2,2ca <memmove+0x2a>
    dst += n;
 2d6:	00c50733          	add	a4,a0,a2
    src += n;
 2da:	95b2                	add	a1,a1,a2
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f6:	fef71ae3          	bne	a4,a5,2ea <memmove+0x4a>
 2fa:	bfc1                	j	2ca <memmove+0x2a>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 304:	c61d                	beqz	a2,332 <memcmp+0x36>
 306:	1602                	slli	a2,a2,0x20
 308:	9201                	srli	a2,a2,0x20
 30a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 30e:	00054783          	lbu	a5,0(a0)
 312:	0005c703          	lbu	a4,0(a1)
 316:	00e79863          	bne	a5,a4,326 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 31a:	0505                	addi	a0,a0,1
    p2++;
 31c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31e:	fed518e3          	bne	a0,a3,30e <memcmp+0x12>
  }
  return 0;
 322:	4501                	li	a0,0
 324:	a019                	j	32a <memcmp+0x2e>
      return *p1 - *p2;
 326:	40e7853b          	subw	a0,a5,a4
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <memcmp+0x2e>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	f63ff0ef          	jal	2a0 <memmove>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34a:	4885                	li	a7,1
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <exit>:
.global exit
exit:
 li a7, SYS_exit
 352:	4889                	li	a7,2
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <wait>:
.global wait
wait:
 li a7, SYS_wait
 35a:	488d                	li	a7,3
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 362:	4891                	li	a7,4
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <read>:
.global read
read:
 li a7, SYS_read
 36a:	4895                	li	a7,5
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38a:	48a5                	li	a7,9
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <dup>:
.global dup
dup:
 li a7, SYS_dup
 392:	48a9                	li	a7,10
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39a:	48ad                	li	a7,11
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a2:	48b1                	li	a7,12
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3aa:	48b5                	li	a7,13
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b2:	48b9                	li	a7,14
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <write>:
.global write
write:
 li a7, SYS_write
 3c2:	48c1                	li	a7,16
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ca:	48c5                	li	a7,17
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d2:	48c9                	li	a7,18
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <close>:
.global close
close:
 li a7, SYS_close
 3ea:	48d5                	li	a7,21
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3f2:	48d9                	li	a7,22
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3fa:	48dd                	li	a7,23
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 402:	48e1                	li	a7,24
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 40a:	48e5                	li	a7,25
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41e:	4605                	li	a2,1
 420:	fef40593          	addi	a1,s0,-17
 424:	f9fff0ef          	jal	3c2 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f04a                	sd	s2,32(sp)
 438:	ec4e                	sd	s3,24(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	cac9                	beqz	a3,4d0 <printint+0xa0>
 440:	01f5d79b          	srliw	a5,a1,0x1f
 444:	c7d1                	beqz	a5,4d0 <printint+0xa0>
    neg = 1;
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 44c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 450:	86ce                	mv	a3,s3
  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	00000817          	auipc	a6,0x0
 458:	50480813          	addi	a6,a6,1284 # 958 <digits>
 45c:	88ba                	mv	a7,a4
 45e:	0017051b          	addiw	a0,a4,1
 462:	872a                	mv	a4,a0
 464:	02c5f7bb          	remuw	a5,a1,a2
 468:	1782                	slli	a5,a5,0x20
 46a:	9381                	srli	a5,a5,0x20
 46c:	97c2                	add	a5,a5,a6
 46e:	0007c783          	lbu	a5,0(a5)
 472:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 476:	87ae                	mv	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fcc7ffe3          	bgeu	a5,a2,45c <printint+0x2c>
  if(neg)
 482:	00030c63          	beqz	t1,49a <printint+0x6a>
    buf[i++] = '-';
 486:	fd050793          	addi	a5,a0,-48
 48a:	00878533          	add	a0,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef50823          	sb	a5,-16(a0)
 496:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 49a:	02e05563          	blez	a4,4c4 <printint+0x94>
 49e:	f426                	sd	s1,40(sp)
 4a0:	377d                	addiw	a4,a4,-1
 4a2:	00e984b3          	add	s1,s3,a4
 4a6:	19fd                	addi	s3,s3,-1
 4a8:	99ba                	add	s3,s3,a4
 4aa:	1702                	slli	a4,a4,0x20
 4ac:	9301                	srli	a4,a4,0x20
 4ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b2:	0004c583          	lbu	a1,0(s1)
 4b6:	854a                	mv	a0,s2
 4b8:	f5bff0ef          	jal	412 <putc>
  while(--i >= 0)
 4bc:	14fd                	addi	s1,s1,-1
 4be:	ff349ae3          	bne	s1,s3,4b2 <printint+0x82>
 4c2:	74a2                	ld	s1,40(sp)
}
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
 4cc:	6121                	addi	sp,sp,64
 4ce:	8082                	ret
  neg = 0;
 4d0:	4301                	li	t1,0
 4d2:	bfad                	j	44c <printint+0x1c>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	711d                	addi	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e4a6                	sd	s1,72(sp)
 4dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c483          	lbu	s1,0(a1)
 4e2:	20048963          	beqz	s1,6f4 <vprintf+0x220>
 4e6:	e0ca                	sd	s2,64(sp)
 4e8:	fc4e                	sd	s3,56(sp)
 4ea:	f852                	sd	s4,48(sp)
 4ec:	f456                	sd	s5,40(sp)
 4ee:	f05a                	sd	s6,32(sp)
 4f0:	ec5e                	sd	s7,24(sp)
 4f2:	e862                	sd	s8,16(sp)
 4f4:	8b2a                	mv	s6,a0
 4f6:	8a2e                	mv	s4,a1
 4f8:	8bb2                	mv	s7,a2
  state = 0;
 4fa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fc:	4901                	li	s2,0
 4fe:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 500:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 504:	06400c13          	li	s8,100
 508:	a00d                	j	52a <vprintf+0x56>
        putc(fd, c0);
 50a:	85a6                	mv	a1,s1
 50c:	855a                	mv	a0,s6
 50e:	f05ff0ef          	jal	412 <putc>
 512:	a019                	j	518 <vprintf+0x44>
    } else if(state == '%'){
 514:	03598363          	beq	s3,s5,53a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 518:	0019079b          	addiw	a5,s2,1
 51c:	893e                	mv	s2,a5
 51e:	873e                	mv	a4,a5
 520:	97d2                	add	a5,a5,s4
 522:	0007c483          	lbu	s1,0(a5)
 526:	1c048063          	beqz	s1,6e6 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 52a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 52e:	fe0993e3          	bnez	s3,514 <vprintf+0x40>
      if(c0 == '%'){
 532:	fd579ce3          	bne	a5,s5,50a <vprintf+0x36>
        state = '%';
 536:	89be                	mv	s3,a5
 538:	b7c5                	j	518 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 53a:	00ea06b3          	add	a3,s4,a4
 53e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 542:	1a060e63          	beqz	a2,6fe <vprintf+0x22a>
      if(c0 == 'd'){
 546:	03878763          	beq	a5,s8,574 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 54a:	f9478693          	addi	a3,a5,-108
 54e:	0016b693          	seqz	a3,a3
 552:	f9c60593          	addi	a1,a2,-100
 556:	e99d                	bnez	a1,58c <vprintf+0xb8>
 558:	ca95                	beqz	a3,58c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	ec9ff0ef          	jal	430 <printint>
        i += 1;
 56c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 570:	4981                	li	s3,0
 572:	b75d                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b8493          	addi	s1,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	eafff0ef          	jal	430 <printint>
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	b779                	j	518 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 58c:	9752                	add	a4,a4,s4
 58e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 592:	f9460713          	addi	a4,a2,-108
 596:	00173713          	seqz	a4,a4
 59a:	8f75                	and	a4,a4,a3
 59c:	f9c58513          	addi	a0,a1,-100
 5a0:	16051963          	bnez	a0,712 <vprintf+0x23e>
 5a4:	16070763          	beqz	a4,712 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e7bff0ef          	jal	430 <printint>
        i += 2;
 5ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	bfa1                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e61ff0ef          	jal	430 <printint>
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b781                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e49ff0ef          	jal	430 <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b71d                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e2fff0ef          	jal	430 <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	b731                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e15ff0ef          	jal	430 <printint>
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
 624:	bdd5                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	008b8493          	addi	s1,s7,8
 62a:	4681                	li	a3,0
 62c:	4641                	li	a2,16
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	dfdff0ef          	jal	430 <printint>
        i += 1;
 638:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bde9                	j	518 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	de3ff0ef          	jal	430 <printint>
        i += 2;
 652:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	b5c1                	j	518 <vprintf+0x44>
 65a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 65c:	008b8793          	addi	a5,s7,8
 660:	8cbe                	mv	s9,a5
 662:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 666:	03000593          	li	a1,48
 66a:	855a                	mv	a0,s6
 66c:	da7ff0ef          	jal	412 <putc>
  putc(fd, 'x');
 670:	07800593          	li	a1,120
 674:	855a                	mv	a0,s6
 676:	d9dff0ef          	jal	412 <putc>
 67a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	00000b97          	auipc	s7,0x0
 680:	2dcb8b93          	addi	s7,s7,732 # 958 <digits>
 684:	03c9d793          	srli	a5,s3,0x3c
 688:	97de                	add	a5,a5,s7
 68a:	0007c583          	lbu	a1,0(a5)
 68e:	855a                	mv	a0,s6
 690:	d83ff0ef          	jal	412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 694:	0992                	slli	s3,s3,0x4
 696:	34fd                	addiw	s1,s1,-1
 698:	f4f5                	bnez	s1,684 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 69a:	8be6                	mv	s7,s9
      state = 0;
 69c:	4981                	li	s3,0
 69e:	6ca2                	ld	s9,8(sp)
 6a0:	bda5                	j	518 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	008b8993          	addi	s3,s7,8
 6a6:	000bb483          	ld	s1,0(s7)
 6aa:	cc91                	beqz	s1,6c6 <vprintf+0x1f2>
        for(; *s; s++)
 6ac:	0004c583          	lbu	a1,0(s1)
 6b0:	c985                	beqz	a1,6e0 <vprintf+0x20c>
          putc(fd, *s);
 6b2:	855a                	mv	a0,s6
 6b4:	d5fff0ef          	jal	412 <putc>
        for(; *s; s++)
 6b8:	0485                	addi	s1,s1,1
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	f9f5                	bnez	a1,6b2 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bd91                	j	518 <vprintf+0x44>
          s = "(null)";
 6c6:	00000497          	auipc	s1,0x0
 6ca:	28a48493          	addi	s1,s1,650 # 950 <malloc+0xf6>
        for(; *s; s++)
 6ce:	02800593          	li	a1,40
 6d2:	b7c5                	j	6b2 <vprintf+0x1de>
        putc(fd, '%');
 6d4:	85be                	mv	a1,a5
 6d6:	855a                	mv	a0,s6
 6d8:	d3bff0ef          	jal	412 <putc>
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bd2d                	j	518 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	8bce                	mv	s7,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd15                	j	518 <vprintf+0x44>
 6e6:	6906                	ld	s2,64(sp)
 6e8:	79e2                	ld	s3,56(sp)
 6ea:	7a42                	ld	s4,48(sp)
 6ec:	7aa2                	ld	s5,40(sp)
 6ee:	7b02                	ld	s6,32(sp)
 6f0:	6be2                	ld	s7,24(sp)
 6f2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f4:	60e6                	ld	ra,88(sp)
 6f6:	6446                	ld	s0,80(sp)
 6f8:	64a6                	ld	s1,72(sp)
 6fa:	6125                	addi	sp,sp,96
 6fc:	8082                	ret
      if(c0 == 'd'){
 6fe:	06400713          	li	a4,100
 702:	e6e789e3          	beq	a5,a4,574 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 706:	f9478693          	addi	a3,a5,-108
 70a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 70e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 710:	4701                	li	a4,0
      } else if(c0 == 'u'){
 712:	07500513          	li	a0,117
 716:	eaa786e3          	beq	a5,a0,5c2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 71a:	f8b60513          	addi	a0,a2,-117
 71e:	e119                	bnez	a0,724 <vprintf+0x250>
 720:	ea069de3          	bnez	a3,5da <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 724:	f8b58513          	addi	a0,a1,-117
 728:	e119                	bnez	a0,72e <vprintf+0x25a>
 72a:	ec0715e3          	bnez	a4,5f4 <vprintf+0x120>
      } else if(c0 == 'x'){
 72e:	07800513          	li	a0,120
 732:	eca78ee3          	beq	a5,a0,60e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 736:	f8860613          	addi	a2,a2,-120
 73a:	e219                	bnez	a2,740 <vprintf+0x26c>
 73c:	ee0695e3          	bnez	a3,626 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 740:	f8858593          	addi	a1,a1,-120
 744:	e199                	bnez	a1,74a <vprintf+0x276>
 746:	ee071de3          	bnez	a4,640 <vprintf+0x16c>
      } else if(c0 == 'p'){
 74a:	07000713          	li	a4,112
 74e:	f0e786e3          	beq	a5,a4,65a <vprintf+0x186>
      } else if(c0 == 's'){
 752:	07300713          	li	a4,115
 756:	f4e786e3          	beq	a5,a4,6a2 <vprintf+0x1ce>
      } else if(c0 == '%'){
 75a:	02500713          	li	a4,37
 75e:	f6e78be3          	beq	a5,a4,6d4 <vprintf+0x200>
        putc(fd, '%');
 762:	02500593          	li	a1,37
 766:	855a                	mv	a0,s6
 768:	cabff0ef          	jal	412 <putc>
        putc(fd, c0);
 76c:	85a6                	mv	a1,s1
 76e:	855a                	mv	a0,s6
 770:	ca3ff0ef          	jal	412 <putc>
      state = 0;
 774:	4981                	li	s3,0
 776:	b34d                	j	518 <vprintf+0x44>

0000000000000778 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 778:	715d                	addi	sp,sp,-80
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e010                	sd	a2,0(s0)
 782:	e414                	sd	a3,8(s0)
 784:	e818                	sd	a4,16(s0)
 786:	ec1c                	sd	a5,24(s0)
 788:	03043023          	sd	a6,32(s0)
 78c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	8622                	mv	a2,s0
 792:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 796:	d3fff0ef          	jal	4d4 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6161                	addi	sp,sp,80
 7a0:	8082                	ret

00000000000007a2 <printf>:

void
printf(const char *fmt, ...)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e40c                	sd	a1,8(s0)
 7ac:	e810                	sd	a2,16(s0)
 7ae:	ec14                	sd	a3,24(s0)
 7b0:	f018                	sd	a4,32(s0)
 7b2:	f41c                	sd	a5,40(s0)
 7b4:	03043823          	sd	a6,48(s0)
 7b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	00840613          	addi	a2,s0,8
 7c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c4:	85aa                	mv	a1,a0
 7c6:	4505                	li	a0,1
 7c8:	d0dff0ef          	jal	4d4 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret

00000000000007d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d4:	1141                	addi	sp,sp,-16
 7d6:	e406                	sd	ra,8(sp)
 7d8:	e022                	sd	s0,0(sp)
 7da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	00001797          	auipc	a5,0x1
 7e4:	8207b783          	ld	a5,-2016(a5) # 1000 <freep>
 7e8:	a039                	j	7f6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x20>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x30>
{
 7f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x16>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059813          	slli	a6,a1,0x20
 80e:	01c85713          	srli	a4,a6,0x1c
 812:	9736                	add	a4,a4,a3
 814:	02e60563          	beq	a2,a4,83e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 81c:	4790                	lw	a2,8(a5)
 81e:	02061593          	slli	a1,a2,0x20
 822:	01c5d713          	srli	a4,a1,0x1c
 826:	973e                	add	a4,a4,a5
 828:	02e68263          	beq	a3,a4,84c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 82c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
}
 836:	60a2                	ld	ra,8(sp)
 838:	6402                	ld	s0,0(sp)
 83a:	0141                	addi	sp,sp,16
 83c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 83e:	4618                	lw	a4,8(a2)
 840:	9f2d                	addw	a4,a4,a1
 842:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	6310                	ld	a2,0(a4)
 84a:	b7f9                	j	818 <free+0x44>
    p->s.size += bp->s.size;
 84c:	ff852703          	lw	a4,-8(a0)
 850:	9f31                	addw	a4,a4,a2
 852:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 854:	ff053683          	ld	a3,-16(a0)
 858:	bfd1                	j	82c <free+0x58>

000000000000085a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85a:	7139                	addi	sp,sp,-64
 85c:	fc06                	sd	ra,56(sp)
 85e:	f822                	sd	s0,48(sp)
 860:	f04a                	sd	s2,32(sp)
 862:	ec4e                	sd	s3,24(sp)
 864:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 866:	02051993          	slli	s3,a0,0x20
 86a:	0209d993          	srli	s3,s3,0x20
 86e:	09bd                	addi	s3,s3,15
 870:	0049d993          	srli	s3,s3,0x4
 874:	2985                	addiw	s3,s3,1
 876:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 878:	00000517          	auipc	a0,0x0
 87c:	78853503          	ld	a0,1928(a0) # 1000 <freep>
 880:	c905                	beqz	a0,8b0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	09377663          	bgeu	a4,s3,912 <malloc+0xb8>
 88a:	f426                	sd	s1,40(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 892:	8a4e                	mv	s4,s3
 894:	6705                	lui	a4,0x1
 896:	00e9f363          	bgeu	s3,a4,89c <malloc+0x42>
 89a:	6a05                	lui	s4,0x1
 89c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a4:	00000497          	auipc	s1,0x0
 8a8:	75c48493          	addi	s1,s1,1884 # 1000 <freep>
  if(p == (char*)-1)
 8ac:	5afd                	li	s5,-1
 8ae:	a83d                	j	8ec <malloc+0x92>
 8b0:	f426                	sd	s1,40(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	75878793          	addi	a5,a5,1880 # 1010 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ce:	b7d1                	j	892 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	a899                	j	92a <malloc+0xd0>
  hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8da:	0541                	addi	a0,a0,16
 8dc:	ef9ff0ef          	jal	7d4 <free>
  return freep;
 8e0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8e2:	c125                	beqz	a0,942 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	03277163          	bgeu	a4,s2,90a <malloc+0xb0>
    if(p == freep)
 8ec:	6098                	ld	a4,0(s1)
 8ee:	853e                	mv	a0,a5
 8f0:	fef71ae3          	bne	a4,a5,8e4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	aadff0ef          	jal	3a2 <sbrk>
  if(p == (char*)-1)
 8fa:	fd551ee3          	bne	a0,s5,8d6 <malloc+0x7c>
        return 0;
 8fe:	4501                	li	a0,0
 900:	74a2                	ld	s1,40(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	a03d                	j	936 <malloc+0xdc>
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 912:	fae90fe3          	beq	s2,a4,8d0 <malloc+0x76>
        p->s.size -= nunits;
 916:	4137073b          	subw	a4,a4,s3
 91a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91c:	02071693          	slli	a3,a4,0x20
 920:	01c6d713          	srli	a4,a3,0x1c
 924:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 926:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92a:	00000717          	auipc	a4,0x0
 92e:	6ca73b23          	sd	a0,1750(a4) # 1000 <freep>
      return (void*)(p + 1);
 932:	01078513          	addi	a0,a5,16
  }
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	7902                	ld	s2,32(sp)
 93c:	69e2                	ld	s3,24(sp)
 93e:	6121                	addi	sp,sp,64
 940:	8082                	ret
 942:	74a2                	ld	s1,40(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	b7f5                	j	936 <malloc+0xdc>
