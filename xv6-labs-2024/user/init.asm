
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	93250513          	addi	a0,a0,-1742 # 940 <malloc+0xf8>
  16:	39a000ef          	jal	3b0 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	368000ef          	jal	388 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	362000ef          	jal	388 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	91e90913          	addi	s2,s2,-1762 # 948 <malloc+0x100>
  32:	854a                	mv	a0,s2
  34:	75c000ef          	jal	790 <printf>
    pid = fork();
  38:	308000ef          	jal	340 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	30a000ef          	jal	350 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	94650513          	addi	a0,a0,-1722 # 998 <malloc+0x150>
  5a:	736000ef          	jal	790 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2e8000ef          	jal	348 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8d850513          	addi	a0,a0,-1832 # 940 <malloc+0xf8>
  70:	350000ef          	jal	3c0 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8ca50513          	addi	a0,a0,-1846 # 940 <malloc+0xf8>
  7e:	332000ef          	jal	3b0 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8dc50513          	addi	a0,a0,-1828 # 960 <malloc+0x118>
  8c:	704000ef          	jal	790 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2b6000ef          	jal	348 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8da50513          	addi	a0,a0,-1830 # 978 <malloc+0x130>
  a6:	2ca000ef          	jal	370 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8d650513          	addi	a0,a0,-1834 # 980 <malloc+0x138>
  b2:	6de000ef          	jal	790 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	290000ef          	jal	348 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	27e000ef          	jal	348 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf91                	beqz	a5,146 <strlen+0x28>
 12c:	00150793          	addi	a5,a0,1
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for(n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strlen+0x20>

000000000000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 152:	ca19                	beqz	a2,168 <memset+0x1e>
 154:	87aa                	mv	a5,a0
 156:	1602                	slli	a2,a2,0x20
 158:	9201                	srli	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x14>
  }
  return dst;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	1141                	addi	sp,sp,-16
 172:	e406                	sd	ra,8(sp)
 174:	e022                	sd	s0,0(sp)
 176:	0800                	addi	s0,sp,16
  for(; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cf81                	beqz	a5,194 <strchr+0x24>
    if(*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1c>
  for(; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xe>
      return (char*)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  return 0;
 194:	4501                	li	a0,0
 196:	bfdd                	j	18c <strchr+0x1c>

0000000000000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	711d                	addi	sp,sp,-96
 19a:	ec86                	sd	ra,88(sp)
 19c:	e8a2                	sd	s0,80(sp)
 19e:	e4a6                	sd	s1,72(sp)
 1a0:	e0ca                	sd	s2,64(sp)
 1a2:	fc4e                	sd	s3,56(sp)
 1a4:	f852                	sd	s4,48(sp)
 1a6:	f456                	sd	s5,40(sp)
 1a8:	f05a                	sd	s6,32(sp)
 1aa:	ec5e                	sd	s7,24(sp)
 1ac:	e862                	sd	s8,16(sp)
 1ae:	1080                	addi	s0,sp,96
 1b0:	8baa                	mv	s7,a0
 1b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	892a                	mv	s2,a0
 1b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b8:	faf40b13          	addi	s6,s0,-81
 1bc:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1be:	8c26                	mv	s8,s1
 1c0:	0014899b          	addiw	s3,s1,1
 1c4:	84ce                	mv	s1,s3
 1c6:	0349d463          	bge	s3,s4,1ee <gets+0x56>
    cc = read(0, &c, 1);
 1ca:	8656                	mv	a2,s5
 1cc:	85da                	mv	a1,s6
 1ce:	4501                	li	a0,0
 1d0:	190000ef          	jal	360 <read>
    if(cc < 1)
 1d4:	00a05d63          	blez	a0,1ee <gets+0x56>
      break;
    buf[i++] = c;
 1d8:	faf44783          	lbu	a5,-81(s0)
 1dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e0:	0905                	addi	s2,s2,1
 1e2:	ff678713          	addi	a4,a5,-10
 1e6:	c319                	beqz	a4,1ec <gets+0x54>
 1e8:	17cd                	addi	a5,a5,-13
 1ea:	fbf1                	bnez	a5,1be <gets+0x26>
    buf[i++] = c;
 1ec:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ee:	9c5e                	add	s8,s8,s7
 1f0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f4:	855e                	mv	a0,s7
 1f6:	60e6                	ld	ra,88(sp)
 1f8:	6446                	ld	s0,80(sp)
 1fa:	64a6                	ld	s1,72(sp)
 1fc:	6906                	ld	s2,64(sp)
 1fe:	79e2                	ld	s3,56(sp)
 200:	7a42                	ld	s4,48(sp)
 202:	7aa2                	ld	s5,40(sp)
 204:	7b02                	ld	s6,32(sp)
 206:	6be2                	ld	s7,24(sp)
 208:	6c42                	ld	s8,16(sp)
 20a:	6125                	addi	sp,sp,96
 20c:	8082                	ret

000000000000020e <stat>:

int
stat(const char *n, struct stat *st)
{
 20e:	1101                	addi	sp,sp,-32
 210:	ec06                	sd	ra,24(sp)
 212:	e822                	sd	s0,16(sp)
 214:	e04a                	sd	s2,0(sp)
 216:	1000                	addi	s0,sp,32
 218:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21a:	4581                	li	a1,0
 21c:	194000ef          	jal	3b0 <open>
  if(fd < 0)
 220:	02054263          	bltz	a0,244 <stat+0x36>
 224:	e426                	sd	s1,8(sp)
 226:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 228:	85ca                	mv	a1,s2
 22a:	14e000ef          	jal	378 <fstat>
 22e:	892a                	mv	s2,a0
  close(fd);
 230:	8526                	mv	a0,s1
 232:	1ae000ef          	jal	3e0 <close>
  return r;
 236:	64a2                	ld	s1,8(sp)
}
 238:	854a                	mv	a0,s2
 23a:	60e2                	ld	ra,24(sp)
 23c:	6442                	ld	s0,16(sp)
 23e:	6902                	ld	s2,0(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret
    return -1;
 244:	57fd                	li	a5,-1
 246:	893e                	mv	s2,a5
 248:	bfc5                	j	238 <stat+0x2a>

000000000000024a <atoi>:

int
atoi(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66963          	bltu	a2,a5,292 <atoi+0x48>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1e>
  return n;
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  n = 0;
 292:	4501                	li	a0,0
 294:	bfdd                	j	28a <atoi+0x40>

0000000000000296 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29e:	02b57563          	bgeu	a0,a1,2c8 <memmove+0x32>
    while(n-- > 0)
 2a2:	00c05f63          	blez	a2,2c0 <memmove+0x2a>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b0:	0585                	addi	a1,a1,1
 2b2:	0705                	addi	a4,a4,1
 2b4:	fff5c683          	lbu	a3,-1(a1)
 2b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2bc:	fee79ae3          	bne	a5,a4,2b0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    while(n-- > 0)
 2c8:	fec05ce3          	blez	a2,2c0 <memmove+0x2a>
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	fff7c793          	not	a5,a5
 2de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e0:	15fd                	addi	a1,a1,-1
 2e2:	177d                	addi	a4,a4,-1
 2e4:	0005c683          	lbu	a3,0(a1)
 2e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ec:	fef71ae3          	bne	a4,a5,2e0 <memmove+0x4a>
 2f0:	bfc1                	j	2c0 <memmove+0x2a>

00000000000002f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fa:	c61d                	beqz	a2,328 <memcmp+0x36>
 2fc:	1602                	slli	a2,a2,0x20
 2fe:	9201                	srli	a2,a2,0x20
 300:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 304:	00054783          	lbu	a5,0(a0)
 308:	0005c703          	lbu	a4,0(a1)
 30c:	00e79863          	bne	a5,a4,31c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 310:	0505                	addi	a0,a0,1
    p2++;
 312:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 314:	fed518e3          	bne	a0,a3,304 <memcmp+0x12>
  }
  return 0;
 318:	4501                	li	a0,0
 31a:	a019                	j	320 <memcmp+0x2e>
      return *p1 - *p2;
 31c:	40e7853b          	subw	a0,a5,a4
}
 320:	60a2                	ld	ra,8(sp)
 322:	6402                	ld	s0,0(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfdd                	j	320 <memcmp+0x2e>

000000000000032c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 334:	f63ff0ef          	jal	296 <memmove>
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 340:	4885                	li	a7,1
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exit>:
.global exit
exit:
 li a7, SYS_exit
 348:	4889                	li	a7,2
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <wait>:
.global wait
wait:
 li a7, SYS_wait
 350:	488d                	li	a7,3
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 358:	4891                	li	a7,4
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <read>:
.global read
read:
 li a7, SYS_read
 360:	4895                	li	a7,5
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kill>:
.global kill
kill:
 li a7, SYS_kill
 368:	4899                	li	a7,6
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exec>:
.global exec
exec:
 li a7, SYS_exec
 370:	489d                	li	a7,7
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <open>:
.global open
open:
 li a7, SYS_open
 3b0:	48bd                	li	a7,15
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c0:	48c5                	li	a7,17
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c8:	48c9                	li	a7,18
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <link>:
.global link
link:
 li a7, SYS_link
 3d0:	48cd                	li	a7,19
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d8:	48d1                	li	a7,20
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <close>:
.global close
close:
 li a7, SYS_close
 3e0:	48d5                	li	a7,21
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3e8:	48d9                	li	a7,22
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3f0:	48dd                	li	a7,23
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 3f8:	48e1                	li	a7,24
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	1000                	addi	s0,sp,32
 408:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40c:	4605                	li	a2,1
 40e:	fef40593          	addi	a1,s0,-17
 412:	fa7ff0ef          	jal	3b8 <write>
}
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6105                	addi	sp,sp,32
 41c:	8082                	ret

000000000000041e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	7139                	addi	sp,sp,-64
 420:	fc06                	sd	ra,56(sp)
 422:	f822                	sd	s0,48(sp)
 424:	f04a                	sd	s2,32(sp)
 426:	ec4e                	sd	s3,24(sp)
 428:	0080                	addi	s0,sp,64
 42a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42c:	cac9                	beqz	a3,4be <printint+0xa0>
 42e:	01f5d79b          	srliw	a5,a1,0x1f
 432:	c7d1                	beqz	a5,4be <printint+0xa0>
    neg = 1;
    x = -xx;
 434:	40b005bb          	negw	a1,a1
    neg = 1;
 438:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 43e:	86ce                	mv	a3,s3
  i = 0;
 440:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 442:	00000817          	auipc	a6,0x0
 446:	57e80813          	addi	a6,a6,1406 # 9c0 <digits>
 44a:	88ba                	mv	a7,a4
 44c:	0017051b          	addiw	a0,a4,1
 450:	872a                	mv	a4,a0
 452:	02c5f7bb          	remuw	a5,a1,a2
 456:	1782                	slli	a5,a5,0x20
 458:	9381                	srli	a5,a5,0x20
 45a:	97c2                	add	a5,a5,a6
 45c:	0007c783          	lbu	a5,0(a5)
 460:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 464:	87ae                	mv	a5,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fcc7ffe3          	bgeu	a5,a2,44a <printint+0x2c>
  if(neg)
 470:	00030c63          	beqz	t1,488 <printint+0x6a>
    buf[i++] = '-';
 474:	fd050793          	addi	a5,a0,-48
 478:	00878533          	add	a0,a5,s0
 47c:	02d00793          	li	a5,45
 480:	fef50823          	sb	a5,-16(a0)
 484:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 488:	02e05563          	blez	a4,4b2 <printint+0x94>
 48c:	f426                	sd	s1,40(sp)
 48e:	377d                	addiw	a4,a4,-1
 490:	00e984b3          	add	s1,s3,a4
 494:	19fd                	addi	s3,s3,-1
 496:	99ba                	add	s3,s3,a4
 498:	1702                	slli	a4,a4,0x20
 49a:	9301                	srli	a4,a4,0x20
 49c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a0:	0004c583          	lbu	a1,0(s1)
 4a4:	854a                	mv	a0,s2
 4a6:	f5bff0ef          	jal	400 <putc>
  while(--i >= 0)
 4aa:	14fd                	addi	s1,s1,-1
 4ac:	ff349ae3          	bne	s1,s3,4a0 <printint+0x82>
 4b0:	74a2                	ld	s1,40(sp)
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
 4ba:	6121                	addi	sp,sp,64
 4bc:	8082                	ret
  neg = 0;
 4be:	4301                	li	t1,0
 4c0:	bfad                	j	43a <printint+0x1c>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	711d                	addi	sp,sp,-96
 4c4:	ec86                	sd	ra,88(sp)
 4c6:	e8a2                	sd	s0,80(sp)
 4c8:	e4a6                	sd	s1,72(sp)
 4ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4cc:	0005c483          	lbu	s1,0(a1)
 4d0:	20048963          	beqz	s1,6e2 <vprintf+0x220>
 4d4:	e0ca                	sd	s2,64(sp)
 4d6:	fc4e                	sd	s3,56(sp)
 4d8:	f852                	sd	s4,48(sp)
 4da:	f456                	sd	s5,40(sp)
 4dc:	f05a                	sd	s6,32(sp)
 4de:	ec5e                	sd	s7,24(sp)
 4e0:	e862                	sd	s8,16(sp)
 4e2:	8b2a                	mv	s6,a0
 4e4:	8a2e                	mv	s4,a1
 4e6:	8bb2                	mv	s7,a2
  state = 0;
 4e8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ea:	4901                	li	s2,0
 4ec:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ee:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f2:	06400c13          	li	s8,100
 4f6:	a00d                	j	518 <vprintf+0x56>
        putc(fd, c0);
 4f8:	85a6                	mv	a1,s1
 4fa:	855a                	mv	a0,s6
 4fc:	f05ff0ef          	jal	400 <putc>
 500:	a019                	j	506 <vprintf+0x44>
    } else if(state == '%'){
 502:	03598363          	beq	s3,s5,528 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 506:	0019079b          	addiw	a5,s2,1
 50a:	893e                	mv	s2,a5
 50c:	873e                	mv	a4,a5
 50e:	97d2                	add	a5,a5,s4
 510:	0007c483          	lbu	s1,0(a5)
 514:	1c048063          	beqz	s1,6d4 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 518:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51c:	fe0993e3          	bnez	s3,502 <vprintf+0x40>
      if(c0 == '%'){
 520:	fd579ce3          	bne	a5,s5,4f8 <vprintf+0x36>
        state = '%';
 524:	89be                	mv	s3,a5
 526:	b7c5                	j	506 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 528:	00ea06b3          	add	a3,s4,a4
 52c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 530:	1a060e63          	beqz	a2,6ec <vprintf+0x22a>
      if(c0 == 'd'){
 534:	03878763          	beq	a5,s8,562 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 538:	f9478693          	addi	a3,a5,-108
 53c:	0016b693          	seqz	a3,a3
 540:	f9c60593          	addi	a1,a2,-100
 544:	e99d                	bnez	a1,57a <vprintf+0xb8>
 546:	ca95                	beqz	a3,57a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	008b8493          	addi	s1,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	ec9ff0ef          	jal	41e <printint>
        i += 1;
 55a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 55e:	4981                	li	s3,0
 560:	b75d                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 562:	008b8493          	addi	s1,s7,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	eafff0ef          	jal	41e <printint>
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b779                	j	506 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 57a:	9752                	add	a4,a4,s4
 57c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 580:	f9460713          	addi	a4,a2,-108
 584:	00173713          	seqz	a4,a4
 588:	8f75                	and	a4,a4,a3
 58a:	f9c58513          	addi	a0,a1,-100
 58e:	16051963          	bnez	a0,700 <vprintf+0x23e>
 592:	16070763          	beqz	a4,700 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8493          	addi	s1,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e7bff0ef          	jal	41e <printint>
        i += 2;
 5a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8ba6                	mv	s7,s1
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	bfa1                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e61ff0ef          	jal	41e <printint>
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b781                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e49ff0ef          	jal	41e <printint>
        i += 1;
 5da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b71d                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e2fff0ef          	jal	41e <printint>
        i += 2;
 5f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	b731                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e15ff0ef          	jal	41e <printint>
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	bdd5                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dfdff0ef          	jal	41e <printint>
        i += 1;
 626:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bde9                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000ba583          	lw	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	de3ff0ef          	jal	41e <printint>
        i += 2;
 640:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
        i += 2;
 646:	b5c1                	j	506 <vprintf+0x44>
 648:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64a:	008b8793          	addi	a5,s7,8
 64e:	8cbe                	mv	s9,a5
 650:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 654:	03000593          	li	a1,48
 658:	855a                	mv	a0,s6
 65a:	da7ff0ef          	jal	400 <putc>
  putc(fd, 'x');
 65e:	07800593          	li	a1,120
 662:	855a                	mv	a0,s6
 664:	d9dff0ef          	jal	400 <putc>
 668:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66a:	00000b97          	auipc	s7,0x0
 66e:	356b8b93          	addi	s7,s7,854 # 9c0 <digits>
 672:	03c9d793          	srli	a5,s3,0x3c
 676:	97de                	add	a5,a5,s7
 678:	0007c583          	lbu	a1,0(a5)
 67c:	855a                	mv	a0,s6
 67e:	d83ff0ef          	jal	400 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 682:	0992                	slli	s3,s3,0x4
 684:	34fd                	addiw	s1,s1,-1
 686:	f4f5                	bnez	s1,672 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 688:	8be6                	mv	s7,s9
      state = 0;
 68a:	4981                	li	s3,0
 68c:	6ca2                	ld	s9,8(sp)
 68e:	bda5                	j	506 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 690:	008b8993          	addi	s3,s7,8
 694:	000bb483          	ld	s1,0(s7)
 698:	cc91                	beqz	s1,6b4 <vprintf+0x1f2>
        for(; *s; s++)
 69a:	0004c583          	lbu	a1,0(s1)
 69e:	c985                	beqz	a1,6ce <vprintf+0x20c>
          putc(fd, *s);
 6a0:	855a                	mv	a0,s6
 6a2:	d5fff0ef          	jal	400 <putc>
        for(; *s; s++)
 6a6:	0485                	addi	s1,s1,1
 6a8:	0004c583          	lbu	a1,0(s1)
 6ac:	f9f5                	bnez	a1,6a0 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd91                	j	506 <vprintf+0x44>
          s = "(null)";
 6b4:	00000497          	auipc	s1,0x0
 6b8:	30448493          	addi	s1,s1,772 # 9b8 <malloc+0x170>
        for(; *s; s++)
 6bc:	02800593          	li	a1,40
 6c0:	b7c5                	j	6a0 <vprintf+0x1de>
        putc(fd, '%');
 6c2:	85be                	mv	a1,a5
 6c4:	855a                	mv	a0,s6
 6c6:	d3bff0ef          	jal	400 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd2d                	j	506 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd15                	j	506 <vprintf+0x44>
 6d4:	6906                	ld	s2,64(sp)
 6d6:	79e2                	ld	s3,56(sp)
 6d8:	7a42                	ld	s4,48(sp)
 6da:	7aa2                	ld	s5,40(sp)
 6dc:	7b02                	ld	s6,32(sp)
 6de:	6be2                	ld	s7,24(sp)
 6e0:	6c42                	ld	s8,16(sp)
    }
  }
}
 6e2:	60e6                	ld	ra,88(sp)
 6e4:	6446                	ld	s0,80(sp)
 6e6:	64a6                	ld	s1,72(sp)
 6e8:	6125                	addi	sp,sp,96
 6ea:	8082                	ret
      if(c0 == 'd'){
 6ec:	06400713          	li	a4,100
 6f0:	e6e789e3          	beq	a5,a4,562 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6f4:	f9478693          	addi	a3,a5,-108
 6f8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6fc:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fe:	4701                	li	a4,0
      } else if(c0 == 'u'){
 700:	07500513          	li	a0,117
 704:	eaa786e3          	beq	a5,a0,5b0 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 708:	f8b60513          	addi	a0,a2,-117
 70c:	e119                	bnez	a0,712 <vprintf+0x250>
 70e:	ea069de3          	bnez	a3,5c8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 712:	f8b58513          	addi	a0,a1,-117
 716:	e119                	bnez	a0,71c <vprintf+0x25a>
 718:	ec0715e3          	bnez	a4,5e2 <vprintf+0x120>
      } else if(c0 == 'x'){
 71c:	07800513          	li	a0,120
 720:	eca78ee3          	beq	a5,a0,5fc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 724:	f8860613          	addi	a2,a2,-120
 728:	e219                	bnez	a2,72e <vprintf+0x26c>
 72a:	ee0695e3          	bnez	a3,614 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 72e:	f8858593          	addi	a1,a1,-120
 732:	e199                	bnez	a1,738 <vprintf+0x276>
 734:	ee071de3          	bnez	a4,62e <vprintf+0x16c>
      } else if(c0 == 'p'){
 738:	07000713          	li	a4,112
 73c:	f0e786e3          	beq	a5,a4,648 <vprintf+0x186>
      } else if(c0 == 's'){
 740:	07300713          	li	a4,115
 744:	f4e786e3          	beq	a5,a4,690 <vprintf+0x1ce>
      } else if(c0 == '%'){
 748:	02500713          	li	a4,37
 74c:	f6e78be3          	beq	a5,a4,6c2 <vprintf+0x200>
        putc(fd, '%');
 750:	02500593          	li	a1,37
 754:	855a                	mv	a0,s6
 756:	cabff0ef          	jal	400 <putc>
        putc(fd, c0);
 75a:	85a6                	mv	a1,s1
 75c:	855a                	mv	a0,s6
 75e:	ca3ff0ef          	jal	400 <putc>
      state = 0;
 762:	4981                	li	s3,0
 764:	b34d                	j	506 <vprintf+0x44>

0000000000000766 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 766:	715d                	addi	sp,sp,-80
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e010                	sd	a2,0(s0)
 770:	e414                	sd	a3,8(s0)
 772:	e818                	sd	a4,16(s0)
 774:	ec1c                	sd	a5,24(s0)
 776:	03043023          	sd	a6,32(s0)
 77a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	8622                	mv	a2,s0
 780:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 784:	d3fff0ef          	jal	4c2 <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6161                	addi	sp,sp,80
 78e:	8082                	ret

0000000000000790 <printf>:

void
printf(const char *fmt, ...)
{
 790:	711d                	addi	sp,sp,-96
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	e40c                	sd	a1,8(s0)
 79a:	e810                	sd	a2,16(s0)
 79c:	ec14                	sd	a3,24(s0)
 79e:	f018                	sd	a4,32(s0)
 7a0:	f41c                	sd	a5,40(s0)
 7a2:	03043823          	sd	a6,48(s0)
 7a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7aa:	00840613          	addi	a2,s0,8
 7ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b2:	85aa                	mv	a1,a0
 7b4:	4505                	li	a0,1
 7b6:	d0dff0ef          	jal	4c2 <vprintf>
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6125                	addi	sp,sp,96
 7c0:	8082                	ret

00000000000007c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c2:	1141                	addi	sp,sp,-16
 7c4:	e406                	sd	ra,8(sp)
 7c6:	e022                	sd	s0,0(sp)
 7c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	00001797          	auipc	a5,0x1
 7d2:	8427b783          	ld	a5,-1982(a5) # 1010 <freep>
 7d6:	a039                	j	7e4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e7e463          	bltu	a5,a4,7e2 <free+0x20>
 7de:	00e6ea63          	bltu	a3,a4,7f2 <free+0x30>
{
 7e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	fed7fae3          	bgeu	a5,a3,7d8 <free+0x16>
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e6e463          	bltu	a3,a4,7f2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	fee7eae3          	bltu	a5,a4,7e2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f2:	ff852583          	lw	a1,-8(a0)
 7f6:	6390                	ld	a2,0(a5)
 7f8:	02059813          	slli	a6,a1,0x20
 7fc:	01c85713          	srli	a4,a6,0x1c
 800:	9736                	add	a4,a4,a3
 802:	02e60563          	beq	a2,a4,82c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 80a:	4790                	lw	a2,8(a5)
 80c:	02061593          	slli	a1,a2,0x20
 810:	01c5d713          	srli	a4,a1,0x1c
 814:	973e                	add	a4,a4,a5
 816:	02e68263          	beq	a3,a4,83a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 81a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 81c:	00000717          	auipc	a4,0x0
 820:	7ef73a23          	sd	a5,2036(a4) # 1010 <freep>
}
 824:	60a2                	ld	ra,8(sp)
 826:	6402                	ld	s0,0(sp)
 828:	0141                	addi	sp,sp,16
 82a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9f2d                	addw	a4,a4,a1
 830:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6310                	ld	a2,0(a4)
 838:	b7f9                	j	806 <free+0x44>
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9f31                	addw	a4,a4,a2
 840:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053683          	ld	a3,-16(a0)
 846:	bfd1                	j	81a <free+0x58>

0000000000000848 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 848:	7139                	addi	sp,sp,-64
 84a:	fc06                	sd	ra,56(sp)
 84c:	f822                	sd	s0,48(sp)
 84e:	f04a                	sd	s2,32(sp)
 850:	ec4e                	sd	s3,24(sp)
 852:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 854:	02051993          	slli	s3,a0,0x20
 858:	0209d993          	srli	s3,s3,0x20
 85c:	09bd                	addi	s3,s3,15
 85e:	0049d993          	srli	s3,s3,0x4
 862:	2985                	addiw	s3,s3,1
 864:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 866:	00000517          	auipc	a0,0x0
 86a:	7aa53503          	ld	a0,1962(a0) # 1010 <freep>
 86e:	c905                	beqz	a0,89e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	09377663          	bgeu	a4,s3,900 <malloc+0xb8>
 878:	f426                	sd	s1,40(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 880:	8a4e                	mv	s4,s3
 882:	6705                	lui	a4,0x1
 884:	00e9f363          	bgeu	s3,a4,88a <malloc+0x42>
 888:	6a05                	lui	s4,0x1
 88a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 892:	00000497          	auipc	s1,0x0
 896:	77e48493          	addi	s1,s1,1918 # 1010 <freep>
  if(p == (char*)-1)
 89a:	5afd                	li	s5,-1
 89c:	a83d                	j	8da <malloc+0x92>
 89e:	f426                	sd	s1,40(sp)
 8a0:	e852                	sd	s4,16(sp)
 8a2:	e456                	sd	s5,8(sp)
 8a4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a6:	00000797          	auipc	a5,0x0
 8aa:	77a78793          	addi	a5,a5,1914 # 1020 <base>
 8ae:	00000717          	auipc	a4,0x0
 8b2:	76f73123          	sd	a5,1890(a4) # 1010 <freep>
 8b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8bc:	b7d1                	j	880 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	e118                	sd	a4,0(a0)
 8c2:	a899                	j	918 <malloc+0xd0>
  hp->s.size = nu;
 8c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c8:	0541                	addi	a0,a0,16
 8ca:	ef9ff0ef          	jal	7c2 <free>
  return freep;
 8ce:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8d0:	c125                	beqz	a0,930 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	03277163          	bgeu	a4,s2,8f8 <malloc+0xb0>
    if(p == freep)
 8da:	6098                	ld	a4,0(s1)
 8dc:	853e                	mv	a0,a5
 8de:	fef71ae3          	bne	a4,a5,8d2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8e2:	8552                	mv	a0,s4
 8e4:	ab5ff0ef          	jal	398 <sbrk>
  if(p == (char*)-1)
 8e8:	fd551ee3          	bne	a0,s5,8c4 <malloc+0x7c>
        return 0;
 8ec:	4501                	li	a0,0
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
 8f6:	a03d                	j	924 <malloc+0xdc>
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 900:	fae90fe3          	beq	s2,a4,8be <malloc+0x76>
        p->s.size -= nunits;
 904:	4137073b          	subw	a4,a4,s3
 908:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90a:	02071693          	slli	a3,a4,0x20
 90e:	01c6d713          	srli	a4,a3,0x1c
 912:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 914:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 918:	00000717          	auipc	a4,0x0
 91c:	6ea73c23          	sd	a0,1784(a4) # 1010 <freep>
      return (void*)(p + 1);
 920:	01078513          	addi	a0,a5,16
  }
}
 924:	70e2                	ld	ra,56(sp)
 926:	7442                	ld	s0,48(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6121                	addi	sp,sp,64
 92e:	8082                	ret
 930:	74a2                	ld	s1,40(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	b7f5                	j	924 <malloc+0xdc>
