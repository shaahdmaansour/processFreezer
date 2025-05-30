
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	96278793          	addi	a5,a5,-1694 # 980 <malloc+0x130>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	91c50513          	addi	a0,a0,-1764 # 950 <malloc+0x100>
  3c:	75c000ef          	jal	798 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	12c000ef          	jal	178 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	32a000ef          	jal	37e <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	90450513          	addi	a0,a0,-1788 # 968 <malloc+0x118>
  6c:	72c000ef          	jal	798 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	36c000ef          	jal	3ee <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	35e000ef          	jal	3f6 <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	37c000ef          	jal	41e <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	8d250513          	addi	a0,a0,-1838 # 978 <malloc+0x128>
  ae:	6ea000ef          	jal	798 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	336000ef          	jal	3ee <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2d0000ef          	jal	39e <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	346000ef          	jal	41e <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2b0000ef          	jal	38e <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2a2000ef          	jal	386 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f0:	f11ff0ef          	jal	0 <main>
  exit(0);
  f4:	4501                	li	a0,0
  f6:	290000ef          	jal	386 <exit>

00000000000000fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0xa>
    ;
  return os;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb91                	beqz	a5,13a <strcmp+0x20>
 128:	0005c703          	lbu	a4,0(a1)
 12c:	00f71763          	bne	a4,a5,13a <strcmp+0x20>
    p++, q++;
 130:	0505                	addi	a0,a0,1
 132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	fbe5                	bnez	a5,128 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 13a:	0005c503          	lbu	a0,0(a1)
}
 13e:	40a7853b          	subw	a0,a5,a0
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf99                	beqz	a5,174 <strlen+0x2a>
 158:	0505                	addi	a0,a0,1
 15a:	87aa                	mv	a5,a0
 15c:	86be                	mv	a3,a5
 15e:	0785                	addi	a5,a5,1
 160:	fff7c703          	lbu	a4,-1(a5)
 164:	ff65                	bnez	a4,15c <strlen+0x12>
 166:	40a6853b          	subw	a0,a3,a0
 16a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret
  for(n = 0; s[n]; n++)
 174:	4501                	li	a0,0
 176:	bfdd                	j	16c <strlen+0x22>

0000000000000178 <memset>:

void*
memset(void *dst, int c, uint n)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 180:	ca19                	beqz	a2,196 <memset+0x1e>
 182:	87aa                	mv	a5,a0
 184:	1602                	slli	a2,a2,0x20
 186:	9201                	srli	a2,a2,0x20
 188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x14>
  }
  return dst;
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strchr>:

char*
strchr(const char *s, char c)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cf81                	beqz	a5,1c2 <strchr+0x24>
    if(*s == c)
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1c>
  for(; *s; s++)
 1b0:	0505                	addi	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xe>
      return (char*)s;
  return 0;
 1b8:	4501                	li	a0,0
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  return 0;
 1c2:	4501                	li	a0,0
 1c4:	bfdd                	j	1ba <strchr+0x1c>

00000000000001c6 <gets>:

char*
gets(char *buf, int max)
{
 1c6:	7159                	addi	sp,sp,-112
 1c8:	f486                	sd	ra,104(sp)
 1ca:	f0a2                	sd	s0,96(sp)
 1cc:	eca6                	sd	s1,88(sp)
 1ce:	e8ca                	sd	s2,80(sp)
 1d0:	e4ce                	sd	s3,72(sp)
 1d2:	e0d2                	sd	s4,64(sp)
 1d4:	fc56                	sd	s5,56(sp)
 1d6:	f85a                	sd	s6,48(sp)
 1d8:	f45e                	sd	s7,40(sp)
 1da:	f062                	sd	s8,32(sp)
 1dc:	ec66                	sd	s9,24(sp)
 1de:	e86a                	sd	s10,16(sp)
 1e0:	1880                	addi	s0,sp,112
 1e2:	8caa                	mv	s9,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ea:	f9f40b13          	addi	s6,s0,-97
 1ee:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f0:	4ba9                	li	s7,10
 1f2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f4:	8d26                	mv	s10,s1
 1f6:	0014899b          	addiw	s3,s1,1
 1fa:	84ce                	mv	s1,s3
 1fc:	0349d563          	bge	s3,s4,226 <gets+0x60>
    cc = read(0, &c, 1);
 200:	8656                	mv	a2,s5
 202:	85da                	mv	a1,s6
 204:	4501                	li	a0,0
 206:	198000ef          	jal	39e <read>
    if(cc < 1)
 20a:	00a05e63          	blez	a0,226 <gets+0x60>
    buf[i++] = c;
 20e:	f9f44783          	lbu	a5,-97(s0)
 212:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 216:	01778763          	beq	a5,s7,224 <gets+0x5e>
 21a:	0905                	addi	s2,s2,1
 21c:	fd879ce3          	bne	a5,s8,1f4 <gets+0x2e>
    buf[i++] = c;
 220:	8d4e                	mv	s10,s3
 222:	a011                	j	226 <gets+0x60>
 224:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 226:	9d66                	add	s10,s10,s9
 228:	000d0023          	sb	zero,0(s10)
  return buf;
}
 22c:	8566                	mv	a0,s9
 22e:	70a6                	ld	ra,104(sp)
 230:	7406                	ld	s0,96(sp)
 232:	64e6                	ld	s1,88(sp)
 234:	6946                	ld	s2,80(sp)
 236:	69a6                	ld	s3,72(sp)
 238:	6a06                	ld	s4,64(sp)
 23a:	7ae2                	ld	s5,56(sp)
 23c:	7b42                	ld	s6,48(sp)
 23e:	7ba2                	ld	s7,40(sp)
 240:	7c02                	ld	s8,32(sp)
 242:	6ce2                	ld	s9,24(sp)
 244:	6d42                	ld	s10,16(sp)
 246:	6165                	addi	sp,sp,112
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	addi	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	196000ef          	jal	3ee <open>
  if(fd < 0)
 25c:	02054263          	bltz	a0,280 <stat+0x36>
 260:	e426                	sd	s1,8(sp)
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	150000ef          	jal	3b6 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	1b0000ef          	jal	41e <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x2a>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66963          	bltu	a2,a5,2cc <atoi+0x48>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1e>
  return n;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <atoi+0x40>

00000000000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d8:	02b57563          	bgeu	a0,a1,302 <memmove+0x32>
    while(n-- > 0)
 2dc:	00c05f63          	blez	a2,2fa <memmove+0x2a>
 2e0:	1602                	slli	a2,a2,0x20
 2e2:	9201                	srli	a2,a2,0x20
 2e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ea:	0585                	addi	a1,a1,1
 2ec:	0705                	addi	a4,a4,1
 2ee:	fff5c683          	lbu	a3,-1(a1)
 2f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
    dst += n;
 302:	00c50733          	add	a4,a0,a2
    src += n;
 306:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 308:	fec059e3          	blez	a2,2fa <memmove+0x2a>
 30c:	fff6079b          	addiw	a5,a2,-1
 310:	1782                	slli	a5,a5,0x20
 312:	9381                	srli	a5,a5,0x20
 314:	fff7c793          	not	a5,a5
 318:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31a:	15fd                	addi	a1,a1,-1
 31c:	177d                	addi	a4,a4,-1
 31e:	0005c683          	lbu	a3,0(a1)
 322:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 326:	fef71ae3          	bne	a4,a5,31a <memmove+0x4a>
 32a:	bfc1                	j	2fa <memmove+0x2a>

000000000000032c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ca0d                	beqz	a2,366 <memcmp+0x3a>
 336:	fff6069b          	addiw	a3,a2,-1
 33a:	1682                	slli	a3,a3,0x20
 33c:	9281                	srli	a3,a3,0x20
 33e:	0685                	addi	a3,a3,1
 340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x16>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x32>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfdd                	j	35e <memcmp+0x32>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	f5fff0ef          	jal	2d0 <memmove>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37e:	4885                	li	a7,1
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exit>:
.global exit
exit:
 li a7, SYS_exit
 386:	4889                	li	a7,2
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <wait>:
.global wait
wait:
 li a7, SYS_wait
 38e:	488d                	li	a7,3
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 396:	4891                	li	a7,4
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <read>:
.global read
read:
 li a7, SYS_read
 39e:	4895                	li	a7,5
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a6:	4899                	li	a7,6
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ae:	489d                	li	a7,7
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b6:	48a1                	li	a7,8
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3be:	48a5                	li	a7,9
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c6:	48a9                	li	a7,10
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ce:	48ad                	li	a7,11
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d6:	48b1                	li	a7,12
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3de:	48b5                	li	a7,13
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e6:	48b9                	li	a7,14
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <open>:
.global open
open:
 li a7, SYS_open
 3ee:	48bd                	li	a7,15
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fe:	48c5                	li	a7,17
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 406:	48c9                	li	a7,18
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <link>:
.global link
link:
 li a7, SYS_link
 40e:	48cd                	li	a7,19
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 416:	48d1                	li	a7,20
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <close>:
.global close
close:
 li a7, SYS_close
 41e:	48d5                	li	a7,21
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 426:	48d9                	li	a7,22
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 42e:	48dd                	li	a7,23
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	fafff0ef          	jal	3f6 <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	7139                	addi	sp,sp,-64
 456:	fc06                	sd	ra,56(sp)
 458:	f822                	sd	s0,48(sp)
 45a:	f426                	sd	s1,40(sp)
 45c:	f04a                	sd	s2,32(sp)
 45e:	ec4e                	sd	s3,24(sp)
 460:	0080                	addi	s0,sp,64
 462:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c299                	beqz	a3,46a <printint+0x16>
 466:	0605ce63          	bltz	a1,4e2 <printint+0x8e>
  neg = 0;
 46a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 470:	869a                	mv	a3,t1
  i = 0;
 472:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 474:	00000817          	auipc	a6,0x0
 478:	52480813          	addi	a6,a6,1316 # 998 <digits>
 47c:	88be                	mv	a7,a5
 47e:	0017851b          	addiw	a0,a5,1
 482:	87aa                	mv	a5,a0
 484:	02c5f73b          	remuw	a4,a1,a2
 488:	1702                	slli	a4,a4,0x20
 48a:	9301                	srli	a4,a4,0x20
 48c:	9742                	add	a4,a4,a6
 48e:	00074703          	lbu	a4,0(a4)
 492:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 496:	872e                	mv	a4,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fcc77fe3          	bgeu	a4,a2,47c <printint+0x28>
  if(neg)
 4a2:	000e0c63          	beqz	t3,4ba <printint+0x66>
    buf[i++] = '-';
 4a6:	fd050793          	addi	a5,a0,-48
 4aa:	00878533          	add	a0,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef50823          	sb	a5,-16(a0)
 4b6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ba:	fff7899b          	addiw	s3,a5,-1
 4be:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4c2:	fff4c583          	lbu	a1,-1(s1)
 4c6:	854a                	mv	a0,s2
 4c8:	f6fff0ef          	jal	436 <putc>
  while(--i >= 0)
 4cc:	39fd                	addiw	s3,s3,-1
 4ce:	14fd                	addi	s1,s1,-1
 4d0:	fe09d9e3          	bgez	s3,4c2 <printint+0x6e>
}
 4d4:	70e2                	ld	ra,56(sp)
 4d6:	7442                	ld	s0,48(sp)
 4d8:	74a2                	ld	s1,40(sp)
 4da:	7902                	ld	s2,32(sp)
 4dc:	69e2                	ld	s3,24(sp)
 4de:	6121                	addi	sp,sp,64
 4e0:	8082                	ret
    x = -xx;
 4e2:	40b005bb          	negw	a1,a1
    neg = 1;
 4e6:	4e05                	li	t3,1
    x = -xx;
 4e8:	b751                	j	46c <printint+0x18>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	711d                	addi	sp,sp,-96
 4ec:	ec86                	sd	ra,88(sp)
 4ee:	e8a2                	sd	s0,80(sp)
 4f0:	e4a6                	sd	s1,72(sp)
 4f2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f4:	0005c483          	lbu	s1,0(a1)
 4f8:	26048663          	beqz	s1,764 <vprintf+0x27a>
 4fc:	e0ca                	sd	s2,64(sp)
 4fe:	fc4e                	sd	s3,56(sp)
 500:	f852                	sd	s4,48(sp)
 502:	f456                	sd	s5,40(sp)
 504:	f05a                	sd	s6,32(sp)
 506:	ec5e                	sd	s7,24(sp)
 508:	e862                	sd	s8,16(sp)
 50a:	e466                	sd	s9,8(sp)
 50c:	8b2a                	mv	s6,a0
 50e:	8a2e                	mv	s4,a1
 510:	8bb2                	mv	s7,a2
  state = 0;
 512:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 514:	4901                	li	s2,0
 516:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 518:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 520:	06c00c93          	li	s9,108
 524:	a00d                	j	546 <vprintf+0x5c>
        putc(fd, c0);
 526:	85a6                	mv	a1,s1
 528:	855a                	mv	a0,s6
 52a:	f0dff0ef          	jal	436 <putc>
 52e:	a019                	j	534 <vprintf+0x4a>
    } else if(state == '%'){
 530:	03598363          	beq	s3,s5,556 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 534:	0019079b          	addiw	a5,s2,1
 538:	893e                	mv	s2,a5
 53a:	873e                	mv	a4,a5
 53c:	97d2                	add	a5,a5,s4
 53e:	0007c483          	lbu	s1,0(a5)
 542:	20048963          	beqz	s1,754 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 546:	0004879b          	sext.w	a5,s1
    if(state == 0){
 54a:	fe0993e3          	bnez	s3,530 <vprintf+0x46>
      if(c0 == '%'){
 54e:	fd579ce3          	bne	a5,s5,526 <vprintf+0x3c>
        state = '%';
 552:	89be                	mv	s3,a5
 554:	b7c5                	j	534 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 556:	00ea06b3          	add	a3,s4,a4
 55a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 55e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 560:	c681                	beqz	a3,568 <vprintf+0x7e>
 562:	9752                	add	a4,a4,s4
 564:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 568:	03878e63          	beq	a5,s8,5a4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 56c:	05978863          	beq	a5,s9,5bc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 570:	07500713          	li	a4,117
 574:	0ee78263          	beq	a5,a4,658 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 578:	07800713          	li	a4,120
 57c:	12e78463          	beq	a5,a4,6a4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 580:	07000713          	li	a4,112
 584:	14e78963          	beq	a5,a4,6d6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 588:	07300713          	li	a4,115
 58c:	18e78863          	beq	a5,a4,71c <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 590:	02500713          	li	a4,37
 594:	04e79463          	bne	a5,a4,5dc <vprintf+0xf2>
        putc(fd, '%');
 598:	85ba                	mv	a1,a4
 59a:	855a                	mv	a0,s6
 59c:	e9bff0ef          	jal	436 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bf49                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	ea3ff0ef          	jal	454 <printint>
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bfad                	j	534 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5bc:	06400793          	li	a5,100
 5c0:	02f68963          	beq	a3,a5,5f2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c4:	06c00793          	li	a5,108
 5c8:	04f68263          	beq	a3,a5,60c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5cc:	07500793          	li	a5,117
 5d0:	0af68063          	beq	a3,a5,670 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5d4:	07800793          	li	a5,120
 5d8:	0ef68263          	beq	a3,a5,6bc <vprintf+0x1d2>
        putc(fd, '%');
 5dc:	02500593          	li	a1,37
 5e0:	855a                	mv	a0,s6
 5e2:	e55ff0ef          	jal	436 <putc>
        putc(fd, c0);
 5e6:	85a6                	mv	a1,s1
 5e8:	855a                	mv	a0,s6
 5ea:	e4dff0ef          	jal	436 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b791                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e55ff0ef          	jal	454 <printint>
        i += 1;
 604:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 1;
 60a:	b72d                	j	534 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60c:	06400793          	li	a5,100
 610:	02f60763          	beq	a2,a5,63e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 614:	07500793          	li	a5,117
 618:	06f60963          	beq	a2,a5,68a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 61c:	07800793          	li	a5,120
 620:	faf61ee3          	bne	a2,a5,5dc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4641                	li	a2,16
 62c:	000ba583          	lw	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e23ff0ef          	jal	454 <printint>
        i += 2;
 636:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
        i += 2;
 63c:	bde5                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	008b8493          	addi	s1,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e09ff0ef          	jal	454 <printint>
        i += 2;
 650:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bdf9                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 658:	008b8493          	addi	s1,s7,8
 65c:	4681                	li	a3,0
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	defff0ef          	jal	454 <printint>
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b5d9                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	dd7ff0ef          	jal	454 <printint>
        i += 1;
 682:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
        i += 1;
 688:	b575                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dbdff0ef          	jal	454 <printint>
        i += 2;
 69c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 2;
 6a2:	bd49                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6a4:	008b8493          	addi	s1,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4641                	li	a2,16
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	da3ff0ef          	jal	454 <printint>
 6b6:	8ba6                	mv	s7,s1
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bdad                	j	534 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	008b8493          	addi	s1,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d8bff0ef          	jal	454 <printint>
        i += 1;
 6ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
        i += 1;
 6d4:	b585                	j	534 <vprintf+0x4a>
 6d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d8:	008b8d13          	addi	s10,s7,8
 6dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	855a                	mv	a0,s6
 6e6:	d51ff0ef          	jal	436 <putc>
  putc(fd, 'x');
 6ea:	07800593          	li	a1,120
 6ee:	855a                	mv	a0,s6
 6f0:	d47ff0ef          	jal	436 <putc>
 6f4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	00000b97          	auipc	s7,0x0
 6fa:	2a2b8b93          	addi	s7,s7,674 # 998 <digits>
 6fe:	03c9d793          	srli	a5,s3,0x3c
 702:	97de                	add	a5,a5,s7
 704:	0007c583          	lbu	a1,0(a5)
 708:	855a                	mv	a0,s6
 70a:	d2dff0ef          	jal	436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	34fd                	addiw	s1,s1,-1
 712:	f4f5                	bnez	s1,6fe <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 714:	8bea                	mv	s7,s10
      state = 0;
 716:	4981                	li	s3,0
 718:	6d02                	ld	s10,0(sp)
 71a:	bd29                	j	534 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 71c:	008b8993          	addi	s3,s7,8
 720:	000bb483          	ld	s1,0(s7)
 724:	cc91                	beqz	s1,740 <vprintf+0x256>
        for(; *s; s++)
 726:	0004c583          	lbu	a1,0(s1)
 72a:	c195                	beqz	a1,74e <vprintf+0x264>
          putc(fd, *s);
 72c:	855a                	mv	a0,s6
 72e:	d09ff0ef          	jal	436 <putc>
        for(; *s; s++)
 732:	0485                	addi	s1,s1,1
 734:	0004c583          	lbu	a1,0(s1)
 738:	f9f5                	bnez	a1,72c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbdd                	j	534 <vprintf+0x4a>
          s = "(null)";
 740:	00000497          	auipc	s1,0x0
 744:	25048493          	addi	s1,s1,592 # 990 <malloc+0x140>
        for(; *s; s++)
 748:	02800593          	li	a1,40
 74c:	b7c5                	j	72c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	b3cd                	j	534 <vprintf+0x4a>
 754:	6906                	ld	s2,64(sp)
 756:	79e2                	ld	s3,56(sp)
 758:	7a42                	ld	s4,48(sp)
 75a:	7aa2                	ld	s5,40(sp)
 75c:	7b02                	ld	s6,32(sp)
 75e:	6be2                	ld	s7,24(sp)
 760:	6c42                	ld	s8,16(sp)
 762:	6ca2                	ld	s9,8(sp)
    }
  }
}
 764:	60e6                	ld	ra,88(sp)
 766:	6446                	ld	s0,80(sp)
 768:	64a6                	ld	s1,72(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76e:	715d                	addi	sp,sp,-80
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e010                	sd	a2,0(s0)
 778:	e414                	sd	a3,8(s0)
 77a:	e818                	sd	a4,16(s0)
 77c:	ec1c                	sd	a5,24(s0)
 77e:	03043023          	sd	a6,32(s0)
 782:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	8622                	mv	a2,s0
 788:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78c:	d5fff0ef          	jal	4ea <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	d2dff0ef          	jal	4ea <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e406                	sd	ra,8(sp)
 7ce:	e022                	sd	s0,0(sp)
 7d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	00001797          	auipc	a5,0x1
 7da:	82a7b783          	ld	a5,-2006(a5) # 1000 <freep>
 7de:	a02d                	j	808 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e0:	4618                	lw	a4,8(a2)
 7e2:	9f2d                	addw	a4,a4,a1
 7e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	6398                	ld	a4,0(a5)
 7ea:	6310                	ld	a2,0(a4)
 7ec:	a83d                	j	82a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ee:	ff852703          	lw	a4,-8(a0)
 7f2:	9f31                	addw	a4,a4,a2
 7f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f6:	ff053683          	ld	a3,-16(a0)
 7fa:	a091                	j	83e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	6398                	ld	a4,0(a5)
 7fe:	00e7e463          	bltu	a5,a4,806 <free+0x3c>
 802:	00e6ea63          	bltu	a3,a4,816 <free+0x4c>
{
 806:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	fed7fae3          	bgeu	a5,a3,7fc <free+0x32>
 80c:	6398                	ld	a4,0(a5)
 80e:	00e6e463          	bltu	a3,a4,816 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	fee7eae3          	bltu	a5,a4,806 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 816:	ff852583          	lw	a1,-8(a0)
 81a:	6390                	ld	a2,0(a5)
 81c:	02059813          	slli	a6,a1,0x20
 820:	01c85713          	srli	a4,a6,0x1c
 824:	9736                	add	a4,a4,a3
 826:	fae60de3          	beq	a2,a4,7e0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 82a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82e:	4790                	lw	a2,8(a5)
 830:	02061593          	slli	a1,a2,0x20
 834:	01c5d713          	srli	a4,a1,0x1c
 838:	973e                	add	a4,a4,a5
 83a:	fae68ae3          	beq	a3,a4,7ee <free+0x24>
    p->s.ptr = bp->s.ptr;
 83e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 840:	00000717          	auipc	a4,0x0
 844:	7cf73023          	sd	a5,1984(a4) # 1000 <freep>
}
 848:	60a2                	ld	ra,8(sp)
 84a:	6402                	ld	s0,0(sp)
 84c:	0141                	addi	sp,sp,16
 84e:	8082                	ret

0000000000000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	7139                	addi	sp,sp,-64
 852:	fc06                	sd	ra,56(sp)
 854:	f822                	sd	s0,48(sp)
 856:	f04a                	sd	s2,32(sp)
 858:	ec4e                	sd	s3,24(sp)
 85a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85c:	02051993          	slli	s3,a0,0x20
 860:	0209d993          	srli	s3,s3,0x20
 864:	09bd                	addi	s3,s3,15
 866:	0049d993          	srli	s3,s3,0x4
 86a:	2985                	addiw	s3,s3,1
 86c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 86e:	00000517          	auipc	a0,0x0
 872:	79253503          	ld	a0,1938(a0) # 1000 <freep>
 876:	c905                	beqz	a0,8a6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87a:	4798                	lw	a4,8(a5)
 87c:	09377663          	bgeu	a4,s3,908 <malloc+0xb8>
 880:	f426                	sd	s1,40(sp)
 882:	e852                	sd	s4,16(sp)
 884:	e456                	sd	s5,8(sp)
 886:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 888:	8a4e                	mv	s4,s3
 88a:	6705                	lui	a4,0x1
 88c:	00e9f363          	bgeu	s3,a4,892 <malloc+0x42>
 890:	6a05                	lui	s4,0x1
 892:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 896:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89a:	00000497          	auipc	s1,0x0
 89e:	76648493          	addi	s1,s1,1894 # 1000 <freep>
  if(p == (char*)-1)
 8a2:	5afd                	li	s5,-1
 8a4:	a83d                	j	8e2 <malloc+0x92>
 8a6:	f426                	sd	s1,40(sp)
 8a8:	e852                	sd	s4,16(sp)
 8aa:	e456                	sd	s5,8(sp)
 8ac:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ae:	00000797          	auipc	a5,0x0
 8b2:	76278793          	addi	a5,a5,1890 # 1010 <base>
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74f73523          	sd	a5,1866(a4) # 1000 <freep>
 8be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c4:	b7d1                	j	888 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	e118                	sd	a4,0(a0)
 8ca:	a899                	j	920 <malloc+0xd0>
  hp->s.size = nu;
 8cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d0:	0541                	addi	a0,a0,16
 8d2:	ef9ff0ef          	jal	7ca <free>
  return freep;
 8d6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8d8:	c125                	beqz	a0,938 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8dc:	4798                	lw	a4,8(a5)
 8de:	03277163          	bgeu	a4,s2,900 <malloc+0xb0>
    if(p == freep)
 8e2:	6098                	ld	a4,0(s1)
 8e4:	853e                	mv	a0,a5
 8e6:	fef71ae3          	bne	a4,a5,8da <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ea:	8552                	mv	a0,s4
 8ec:	aebff0ef          	jal	3d6 <sbrk>
  if(p == (char*)-1)
 8f0:	fd551ee3          	bne	a0,s5,8cc <malloc+0x7c>
        return 0;
 8f4:	4501                	li	a0,0
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	a03d                	j	92c <malloc+0xdc>
 900:	74a2                	ld	s1,40(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 908:	fae90fe3          	beq	s2,a4,8c6 <malloc+0x76>
        p->s.size -= nunits;
 90c:	4137073b          	subw	a4,a4,s3
 910:	c798                	sw	a4,8(a5)
        p += p->s.size;
 912:	02071693          	slli	a3,a4,0x20
 916:	01c6d713          	srli	a4,a3,0x1c
 91a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 920:	00000717          	auipc	a4,0x0
 924:	6ea73023          	sd	a0,1760(a4) # 1000 <freep>
      return (void*)(p + 1);
 928:	01078513          	addi	a0,a5,16
  }
}
 92c:	70e2                	ld	ra,56(sp)
 92e:	7442                	ld	s0,48(sp)
 930:	7902                	ld	s2,32(sp)
 932:	69e2                	ld	s3,24(sp)
 934:	6121                	addi	sp,sp,64
 936:	8082                	ret
 938:	74a2                	ld	s1,40(sp)
 93a:	6a42                	ld	s4,16(sp)
 93c:	6aa2                	ld	s5,8(sp)
 93e:	6b02                	ld	s6,0(sp)
 940:	b7f5                	j	92c <malloc+0xdc>
