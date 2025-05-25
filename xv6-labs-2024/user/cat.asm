
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	372000ef          	jal	39a <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	3ba000ef          	jal	3f2 <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	94058593          	addi	a1,a1,-1728 # 980 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	756000ef          	jal	7a0 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	332000ef          	jal	382 <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	92e58593          	addi	a1,a1,-1746 # 998 <malloc+0x116>
  72:	4509                	li	a0,2
  74:	72c000ef          	jal	7a0 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	308000ef          	jal	382 <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	33e000ef          	jal	3ea <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	35e000ef          	jal	41a <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2ba000ef          	jal	382 <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2a8000ef          	jal	382 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	8ce58593          	addi	a1,a1,-1842 # 9b0 <malloc+0x12e>
  ea:	4509                	li	a0,2
  ec:	6b4000ef          	jal	7a0 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	290000ef          	jal	382 <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  fe:	f81ff0ef          	jal	7e <main>
  exit(0);
 102:	4501                	li	a0,0
 104:	27e000ef          	jal	382 <exit>

0000000000000108 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	87aa                	mv	a5,a0
 112:	0585                	addi	a1,a1,1
 114:	0785                	addi	a5,a5,1
 116:	fff5c703          	lbu	a4,-1(a1)
 11a:	fee78fa3          	sb	a4,-1(a5)
 11e:	fb75                	bnez	a4,112 <strcpy+0xa>
    ;
  return os;
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb91                	beqz	a5,148 <strcmp+0x20>
 136:	0005c703          	lbu	a4,0(a1)
 13a:	00f71763          	bne	a4,a5,148 <strcmp+0x20>
    p++, q++;
 13e:	0505                	addi	a0,a0,1
 140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	fbe5                	bnez	a5,136 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 148:	0005c503          	lbu	a0,0(a1)
}
 14c:	40a7853b          	subw	a0,a5,a0
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x28>
 166:	00150793          	addi	a5,a0,1
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x12>
 174:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfdd                	j	178 <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ca19                	beqz	a2,1a2 <memset+0x1e>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x14>
  }
  return dst;
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf81                	beqz	a5,1ce <strchr+0x24>
    if(*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1c>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xe>
      return (char*)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  return 0;
 1ce:	4501                	li	a0,0
 1d0:	bfdd                	j	1c6 <strchr+0x1c>

00000000000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	711d                	addi	sp,sp,-96
 1d4:	ec86                	sd	ra,88(sp)
 1d6:	e8a2                	sd	s0,80(sp)
 1d8:	e4a6                	sd	s1,72(sp)
 1da:	e0ca                	sd	s2,64(sp)
 1dc:	fc4e                	sd	s3,56(sp)
 1de:	f852                	sd	s4,48(sp)
 1e0:	f456                	sd	s5,40(sp)
 1e2:	f05a                	sd	s6,32(sp)
 1e4:	ec5e                	sd	s7,24(sp)
 1e6:	e862                	sd	s8,16(sp)
 1e8:	1080                	addi	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f2:	faf40b13          	addi	s6,s0,-81
 1f6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f8:	8c26                	mv	s8,s1
 1fa:	0014899b          	addiw	s3,s1,1
 1fe:	84ce                	mv	s1,s3
 200:	0349d463          	bge	s3,s4,228 <gets+0x56>
    cc = read(0, &c, 1);
 204:	8656                	mv	a2,s5
 206:	85da                	mv	a1,s6
 208:	4501                	li	a0,0
 20a:	190000ef          	jal	39a <read>
    if(cc < 1)
 20e:	00a05d63          	blez	a0,228 <gets+0x56>
      break;
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	0905                	addi	s2,s2,1
 21c:	ff678713          	addi	a4,a5,-10
 220:	c319                	beqz	a4,226 <gets+0x54>
 222:	17cd                	addi	a5,a5,-13
 224:	fbf1                	bnez	a5,1f8 <gets+0x26>
    buf[i++] = c;
 226:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 228:	9c5e                	add	s8,s8,s7
 22a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22e:	855e                	mv	a0,s7
 230:	60e6                	ld	ra,88(sp)
 232:	6446                	ld	s0,80(sp)
 234:	64a6                	ld	s1,72(sp)
 236:	6906                	ld	s2,64(sp)
 238:	79e2                	ld	s3,56(sp)
 23a:	7a42                	ld	s4,48(sp)
 23c:	7aa2                	ld	s5,40(sp)
 23e:	7b02                	ld	s6,32(sp)
 240:	6be2                	ld	s7,24(sp)
 242:	6c42                	ld	s8,16(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	194000ef          	jal	3ea <open>
  if(fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	14e000ef          	jal	3b2 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	1ae000ef          	jal	41a <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	57fd                	li	a5,-1
 280:	893e                	mv	s2,a5
 282:	bfc5                	j	272 <stat+0x2a>

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
    while(n-- > 0)
 302:	fec05ce3          	blez	a2,2fa <memmove+0x2a>
    dst += n;
 306:	00c50733          	add	a4,a0,a2
    src += n;
 30a:	95b2                	add	a1,a1,a2
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
 334:	c61d                	beqz	a2,362 <memcmp+0x36>
 336:	1602                	slli	a2,a2,0x20
 338:	9201                	srli	a2,a2,0x20
 33a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33e:	00054783          	lbu	a5,0(a0)
 342:	0005c703          	lbu	a4,0(a1)
 346:	00e79863          	bne	a5,a4,356 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 34a:	0505                	addi	a0,a0,1
    p2++;
 34c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34e:	fed518e3          	bne	a0,a3,33e <memcmp+0x12>
  }
  return 0;
 352:	4501                	li	a0,0
 354:	a019                	j	35a <memcmp+0x2e>
      return *p1 - *p2;
 356:	40e7853b          	subw	a0,a5,a4
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <memcmp+0x2e>

0000000000000366 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36e:	f63ff0ef          	jal	2d0 <memmove>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37a:	4885                	li	a7,1
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exit>:
.global exit
exit:
 li a7, SYS_exit
 382:	4889                	li	a7,2
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <wait>:
.global wait
wait:
 li a7, SYS_wait
 38a:	488d                	li	a7,3
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 392:	4891                	li	a7,4
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <read>:
.global read
read:
 li a7, SYS_read
 39a:	4895                	li	a7,5
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <close>:
.global close
close:
 li a7, SYS_close
 41a:	48d5                	li	a7,21
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 422:	48d9                	li	a7,22
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 42a:	48dd                	li	a7,23
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 432:	48e1                	li	a7,24
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	fa7ff0ef          	jal	3f2 <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	addi	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 458:	7139                	addi	sp,sp,-64
 45a:	fc06                	sd	ra,56(sp)
 45c:	f822                	sd	s0,48(sp)
 45e:	f04a                	sd	s2,32(sp)
 460:	ec4e                	sd	s3,24(sp)
 462:	0080                	addi	s0,sp,64
 464:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 466:	cac9                	beqz	a3,4f8 <printint+0xa0>
 468:	01f5d79b          	srliw	a5,a1,0x1f
 46c:	c7d1                	beqz	a5,4f8 <printint+0xa0>
    neg = 1;
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 474:	fc040993          	addi	s3,s0,-64
  neg = 0;
 478:	86ce                	mv	a3,s3
  i = 0;
 47a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47c:	00000817          	auipc	a6,0x0
 480:	55480813          	addi	a6,a6,1364 # 9d0 <digits>
 484:	88ba                	mv	a7,a4
 486:	0017051b          	addiw	a0,a4,1
 48a:	872a                	mv	a4,a0
 48c:	02c5f7bb          	remuw	a5,a1,a2
 490:	1782                	slli	a5,a5,0x20
 492:	9381                	srli	a5,a5,0x20
 494:	97c2                	add	a5,a5,a6
 496:	0007c783          	lbu	a5,0(a5)
 49a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49e:	87ae                	mv	a5,a1
 4a0:	02c5d5bb          	divuw	a1,a1,a2
 4a4:	0685                	addi	a3,a3,1
 4a6:	fcc7ffe3          	bgeu	a5,a2,484 <printint+0x2c>
  if(neg)
 4aa:	00030c63          	beqz	t1,4c2 <printint+0x6a>
    buf[i++] = '-';
 4ae:	fd050793          	addi	a5,a0,-48
 4b2:	00878533          	add	a0,a5,s0
 4b6:	02d00793          	li	a5,45
 4ba:	fef50823          	sb	a5,-16(a0)
 4be:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4c2:	02e05563          	blez	a4,4ec <printint+0x94>
 4c6:	f426                	sd	s1,40(sp)
 4c8:	377d                	addiw	a4,a4,-1
 4ca:	00e984b3          	add	s1,s3,a4
 4ce:	19fd                	addi	s3,s3,-1
 4d0:	99ba                	add	s3,s3,a4
 4d2:	1702                	slli	a4,a4,0x20
 4d4:	9301                	srli	a4,a4,0x20
 4d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4da:	0004c583          	lbu	a1,0(s1)
 4de:	854a                	mv	a0,s2
 4e0:	f5bff0ef          	jal	43a <putc>
  while(--i >= 0)
 4e4:	14fd                	addi	s1,s1,-1
 4e6:	ff349ae3          	bne	s1,s3,4da <printint+0x82>
 4ea:	74a2                	ld	s1,40(sp)
}
 4ec:	70e2                	ld	ra,56(sp)
 4ee:	7442                	ld	s0,48(sp)
 4f0:	7902                	ld	s2,32(sp)
 4f2:	69e2                	ld	s3,24(sp)
 4f4:	6121                	addi	sp,sp,64
 4f6:	8082                	ret
  neg = 0;
 4f8:	4301                	li	t1,0
 4fa:	bfad                	j	474 <printint+0x1c>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	711d                	addi	sp,sp,-96
 4fe:	ec86                	sd	ra,88(sp)
 500:	e8a2                	sd	s0,80(sp)
 502:	e4a6                	sd	s1,72(sp)
 504:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c483          	lbu	s1,0(a1)
 50a:	20048963          	beqz	s1,71c <vprintf+0x220>
 50e:	e0ca                	sd	s2,64(sp)
 510:	fc4e                	sd	s3,56(sp)
 512:	f852                	sd	s4,48(sp)
 514:	f456                	sd	s5,40(sp)
 516:	f05a                	sd	s6,32(sp)
 518:	ec5e                	sd	s7,24(sp)
 51a:	e862                	sd	s8,16(sp)
 51c:	8b2a                	mv	s6,a0
 51e:	8a2e                	mv	s4,a1
 520:	8bb2                	mv	s7,a2
  state = 0;
 522:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 524:	4901                	li	s2,0
 526:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 528:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52c:	06400c13          	li	s8,100
 530:	a00d                	j	552 <vprintf+0x56>
        putc(fd, c0);
 532:	85a6                	mv	a1,s1
 534:	855a                	mv	a0,s6
 536:	f05ff0ef          	jal	43a <putc>
 53a:	a019                	j	540 <vprintf+0x44>
    } else if(state == '%'){
 53c:	03598363          	beq	s3,s5,562 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 540:	0019079b          	addiw	a5,s2,1
 544:	893e                	mv	s2,a5
 546:	873e                	mv	a4,a5
 548:	97d2                	add	a5,a5,s4
 54a:	0007c483          	lbu	s1,0(a5)
 54e:	1c048063          	beqz	s1,70e <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 552:	0004879b          	sext.w	a5,s1
    if(state == 0){
 556:	fe0993e3          	bnez	s3,53c <vprintf+0x40>
      if(c0 == '%'){
 55a:	fd579ce3          	bne	a5,s5,532 <vprintf+0x36>
        state = '%';
 55e:	89be                	mv	s3,a5
 560:	b7c5                	j	540 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 562:	00ea06b3          	add	a3,s4,a4
 566:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 56a:	1a060e63          	beqz	a2,726 <vprintf+0x22a>
      if(c0 == 'd'){
 56e:	03878763          	beq	a5,s8,59c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 572:	f9478693          	addi	a3,a5,-108
 576:	0016b693          	seqz	a3,a3
 57a:	f9c60593          	addi	a1,a2,-100
 57e:	e99d                	bnez	a1,5b4 <vprintf+0xb8>
 580:	ca95                	beqz	a3,5b4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	008b8493          	addi	s1,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000ba583          	lw	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	ec9ff0ef          	jal	458 <printint>
        i += 1;
 594:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 598:	4981                	li	s3,0
 59a:	b75d                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	eafff0ef          	jal	458 <printint>
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b779                	j	540 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5b4:	9752                	add	a4,a4,s4
 5b6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ba:	f9460713          	addi	a4,a2,-108
 5be:	00173713          	seqz	a4,a4
 5c2:	8f75                	and	a4,a4,a3
 5c4:	f9c58513          	addi	a0,a1,-100
 5c8:	16051963          	bnez	a0,73a <vprintf+0x23e>
 5cc:	16070763          	beqz	a4,73a <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4685                	li	a3,1
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e7bff0ef          	jal	458 <printint>
        i += 2;
 5e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	bfa1                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e61ff0ef          	jal	458 <printint>
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b781                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e49ff0ef          	jal	458 <printint>
        i += 1;
 614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
 61a:	b71d                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e2fff0ef          	jal	458 <printint>
        i += 2;
 62e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	b731                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 636:	008b8493          	addi	s1,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e15ff0ef          	jal	458 <printint>
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bdd5                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	008b8493          	addi	s1,s7,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	dfdff0ef          	jal	458 <printint>
        i += 1;
 660:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
 666:	bde9                	j	540 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	de3ff0ef          	jal	458 <printint>
        i += 2;
 67a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	b5c1                	j	540 <vprintf+0x44>
 682:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 684:	008b8793          	addi	a5,s7,8
 688:	8cbe                	mv	s9,a5
 68a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68e:	03000593          	li	a1,48
 692:	855a                	mv	a0,s6
 694:	da7ff0ef          	jal	43a <putc>
  putc(fd, 'x');
 698:	07800593          	li	a1,120
 69c:	855a                	mv	a0,s6
 69e:	d9dff0ef          	jal	43a <putc>
 6a2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	00000b97          	auipc	s7,0x0
 6a8:	32cb8b93          	addi	s7,s7,812 # 9d0 <digits>
 6ac:	03c9d793          	srli	a5,s3,0x3c
 6b0:	97de                	add	a5,a5,s7
 6b2:	0007c583          	lbu	a1,0(a5)
 6b6:	855a                	mv	a0,s6
 6b8:	d83ff0ef          	jal	43a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6bc:	0992                	slli	s3,s3,0x4
 6be:	34fd                	addiw	s1,s1,-1
 6c0:	f4f5                	bnez	s1,6ac <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6c2:	8be6                	mv	s7,s9
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	6ca2                	ld	s9,8(sp)
 6c8:	bda5                	j	540 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	008b8993          	addi	s3,s7,8
 6ce:	000bb483          	ld	s1,0(s7)
 6d2:	cc91                	beqz	s1,6ee <vprintf+0x1f2>
        for(; *s; s++)
 6d4:	0004c583          	lbu	a1,0(s1)
 6d8:	c985                	beqz	a1,708 <vprintf+0x20c>
          putc(fd, *s);
 6da:	855a                	mv	a0,s6
 6dc:	d5fff0ef          	jal	43a <putc>
        for(; *s; s++)
 6e0:	0485                	addi	s1,s1,1
 6e2:	0004c583          	lbu	a1,0(s1)
 6e6:	f9f5                	bnez	a1,6da <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bd91                	j	540 <vprintf+0x44>
          s = "(null)";
 6ee:	00000497          	auipc	s1,0x0
 6f2:	2da48493          	addi	s1,s1,730 # 9c8 <malloc+0x146>
        for(; *s; s++)
 6f6:	02800593          	li	a1,40
 6fa:	b7c5                	j	6da <vprintf+0x1de>
        putc(fd, '%');
 6fc:	85be                	mv	a1,a5
 6fe:	855a                	mv	a0,s6
 700:	d3bff0ef          	jal	43a <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	bd2d                	j	540 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bd15                	j	540 <vprintf+0x44>
 70e:	6906                	ld	s2,64(sp)
 710:	79e2                	ld	s3,56(sp)
 712:	7a42                	ld	s4,48(sp)
 714:	7aa2                	ld	s5,40(sp)
 716:	7b02                	ld	s6,32(sp)
 718:	6be2                	ld	s7,24(sp)
 71a:	6c42                	ld	s8,16(sp)
    }
  }
}
 71c:	60e6                	ld	ra,88(sp)
 71e:	6446                	ld	s0,80(sp)
 720:	64a6                	ld	s1,72(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret
      if(c0 == 'd'){
 726:	06400713          	li	a4,100
 72a:	e6e789e3          	beq	a5,a4,59c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 72e:	f9478693          	addi	a3,a5,-108
 732:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 736:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	4701                	li	a4,0
      } else if(c0 == 'u'){
 73a:	07500513          	li	a0,117
 73e:	eaa786e3          	beq	a5,a0,5ea <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 742:	f8b60513          	addi	a0,a2,-117
 746:	e119                	bnez	a0,74c <vprintf+0x250>
 748:	ea069de3          	bnez	a3,602 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74c:	f8b58513          	addi	a0,a1,-117
 750:	e119                	bnez	a0,756 <vprintf+0x25a>
 752:	ec0715e3          	bnez	a4,61c <vprintf+0x120>
      } else if(c0 == 'x'){
 756:	07800513          	li	a0,120
 75a:	eca78ee3          	beq	a5,a0,636 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	f8860613          	addi	a2,a2,-120
 762:	e219                	bnez	a2,768 <vprintf+0x26c>
 764:	ee0695e3          	bnez	a3,64e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 768:	f8858593          	addi	a1,a1,-120
 76c:	e199                	bnez	a1,772 <vprintf+0x276>
 76e:	ee071de3          	bnez	a4,668 <vprintf+0x16c>
      } else if(c0 == 'p'){
 772:	07000713          	li	a4,112
 776:	f0e786e3          	beq	a5,a4,682 <vprintf+0x186>
      } else if(c0 == 's'){
 77a:	07300713          	li	a4,115
 77e:	f4e786e3          	beq	a5,a4,6ca <vprintf+0x1ce>
      } else if(c0 == '%'){
 782:	02500713          	li	a4,37
 786:	f6e78be3          	beq	a5,a4,6fc <vprintf+0x200>
        putc(fd, '%');
 78a:	02500593          	li	a1,37
 78e:	855a                	mv	a0,s6
 790:	cabff0ef          	jal	43a <putc>
        putc(fd, c0);
 794:	85a6                	mv	a1,s1
 796:	855a                	mv	a0,s6
 798:	ca3ff0ef          	jal	43a <putc>
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b34d                	j	540 <vprintf+0x44>

00000000000007a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a0:	715d                	addi	sp,sp,-80
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e010                	sd	a2,0(s0)
 7aa:	e414                	sd	a3,8(s0)
 7ac:	e818                	sd	a4,16(s0)
 7ae:	ec1c                	sd	a5,24(s0)
 7b0:	03043023          	sd	a6,32(s0)
 7b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	8622                	mv	a2,s0
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	d3fff0ef          	jal	4fc <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	d0dff0ef          	jal	4fc <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	1141                	addi	sp,sp,-16
 7fe:	e406                	sd	ra,8(sp)
 800:	e022                	sd	s0,0(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	7f87b783          	ld	a5,2040(a5) # 1000 <freep>
 810:	a039                	j	81e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x20>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x30>
{
 81c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x16>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059813          	slli	a6,a1,0x20
 836:	01c85713          	srli	a4,a6,0x1c
 83a:	9736                	add	a4,a4,a3
 83c:	02e60563          	beq	a2,a4,866 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 844:	4790                	lw	a2,8(a5)
 846:	02061593          	slli	a1,a2,0x20
 84a:	01c5d713          	srli	a4,a1,0x1c
 84e:	973e                	add	a4,a4,a5
 850:	02e68263          	beq	a3,a4,874 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 854:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
}
 85e:	60a2                	ld	ra,8(sp)
 860:	6402                	ld	s0,0(sp)
 862:	0141                	addi	sp,sp,16
 864:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	b7f9                	j	840 <free+0x44>
    p->s.size += bp->s.size;
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	bfd1                	j	854 <free+0x58>

0000000000000882 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051993          	slli	s3,a0,0x20
 892:	0209d993          	srli	s3,s3,0x20
 896:	09bd                	addi	s3,s3,15
 898:	0049d993          	srli	s3,s3,0x4
 89c:	2985                	addiw	s3,s3,1
 89e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a0:	00000517          	auipc	a0,0x0
 8a4:	76053503          	ld	a0,1888(a0) # 1000 <freep>
 8a8:	c905                	beqz	a0,8d8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	09377663          	bgeu	a4,s3,93a <malloc+0xb8>
 8b2:	f426                	sd	s1,40(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ba:	8a4e                	mv	s4,s3
 8bc:	6705                	lui	a4,0x1
 8be:	00e9f363          	bgeu	s3,a4,8c4 <malloc+0x42>
 8c2:	6a05                	lui	s4,0x1
 8c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8cc:	00000497          	auipc	s1,0x0
 8d0:	73448493          	addi	s1,s1,1844 # 1000 <freep>
  if(p == (char*)-1)
 8d4:	5afd                	li	s5,-1
 8d6:	a83d                	j	914 <malloc+0x92>
 8d8:	f426                	sd	s1,40(sp)
 8da:	e852                	sd	s4,16(sp)
 8dc:	e456                	sd	s5,8(sp)
 8de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e0:	00001797          	auipc	a5,0x1
 8e4:	93078793          	addi	a5,a5,-1744 # 1210 <base>
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70f73c23          	sd	a5,1816(a4) # 1000 <freep>
 8f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f6:	b7d1                	j	8ba <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8f8:	6398                	ld	a4,0(a5)
 8fa:	e118                	sd	a4,0(a0)
 8fc:	a899                	j	952 <malloc+0xd0>
  hp->s.size = nu;
 8fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 902:	0541                	addi	a0,a0,16
 904:	ef9ff0ef          	jal	7fc <free>
  return freep;
 908:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 90a:	c125                	beqz	a0,96a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	03277163          	bgeu	a4,s2,932 <malloc+0xb0>
    if(p == freep)
 914:	6098                	ld	a4,0(s1)
 916:	853e                	mv	a0,a5
 918:	fef71ae3          	bne	a4,a5,90c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 91c:	8552                	mv	a0,s4
 91e:	ab5ff0ef          	jal	3d2 <sbrk>
  if(p == (char*)-1)
 922:	fd551ee3          	bne	a0,s5,8fe <malloc+0x7c>
        return 0;
 926:	4501                	li	a0,0
 928:	74a2                	ld	s1,40(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	a03d                	j	95e <malloc+0xdc>
 932:	74a2                	ld	s1,40(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93a:	fae90fe3          	beq	s2,a4,8f8 <malloc+0x76>
        p->s.size -= nunits;
 93e:	4137073b          	subw	a4,a4,s3
 942:	c798                	sw	a4,8(a5)
        p += p->s.size;
 944:	02071693          	slli	a3,a4,0x20
 948:	01c6d713          	srli	a4,a3,0x1c
 94c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 952:	00000717          	auipc	a4,0x0
 956:	6aa73723          	sd	a0,1710(a4) # 1000 <freep>
      return (void*)(p + 1);
 95a:	01078513          	addi	a0,a5,16
  }
}
 95e:	70e2                	ld	ra,56(sp)
 960:	7442                	ld	s0,48(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	b7f5                	j	95e <malloc+0xdc>
