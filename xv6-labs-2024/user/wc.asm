
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	20000d93          	li	s11,512
  32:	00001d17          	auipc	s10,0x1
  36:	fded0d13          	addi	s10,s10,-34 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	9a4a0a13          	addi	s4,s4,-1628 # 9e0 <malloc+0xf8>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c8000ef          	jal	210 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866e                	mv	a2,s11
  72:	85ea                	mv	a1,s10
  74:	f8843503          	ld	a0,-120(s0)
  78:	388000ef          	jal	400 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x118>
  a6:	78a000ef          	jal	830 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	92850513          	addi	a0,a0,-1752 # 9f0 <malloc+0x108>
  d0:	760000ef          	jal	830 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	312000ef          	jal	3e8 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	348000ef          	jal	450 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	364000ef          	jal	480 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2c0000ef          	jal	3e8 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8b658593          	addi	a1,a1,-1866 # 9e8 <malloc+0x100>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2a6000ef          	jal	3e8 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8c650513          	addi	a0,a0,-1850 # a10 <malloc+0x128>
 152:	6de000ef          	jal	830 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	290000ef          	jal	3e8 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	27e000ef          	jal	3e8 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0xa>
    ;
  return os;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x20>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x20>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf91                	beqz	a5,1e6 <strlen+0x28>
 1cc:	00150793          	addi	a5,a0,1
 1d0:	86be                	mv	a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	ff65                	bnez	a4,1d0 <strlen+0x12>
 1da:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  for(n = 0; s[n]; n++)
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <strlen+0x20>

00000000000001ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f2:	ca19                	beqz	a2,208 <memset+0x1e>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x14>
  }
  return dst;
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  for(; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf81                	beqz	a5,234 <strchr+0x24>
    if(*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1c>
  for(; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xe>
      return (char*)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <strchr+0x1c>

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	711d                	addi	sp,sp,-96
 23a:	ec86                	sd	ra,88(sp)
 23c:	e8a2                	sd	s0,80(sp)
 23e:	e4a6                	sd	s1,72(sp)
 240:	e0ca                	sd	s2,64(sp)
 242:	fc4e                	sd	s3,56(sp)
 244:	f852                	sd	s4,48(sp)
 246:	f456                	sd	s5,40(sp)
 248:	f05a                	sd	s6,32(sp)
 24a:	ec5e                	sd	s7,24(sp)
 24c:	e862                	sd	s8,16(sp)
 24e:	1080                	addi	s0,sp,96
 250:	8baa                	mv	s7,a0
 252:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 254:	892a                	mv	s2,a0
 256:	4481                	li	s1,0
    cc = read(0, &c, 1);
 258:	faf40b13          	addi	s6,s0,-81
 25c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 25e:	8c26                	mv	s8,s1
 260:	0014899b          	addiw	s3,s1,1
 264:	84ce                	mv	s1,s3
 266:	0349d463          	bge	s3,s4,28e <gets+0x56>
    cc = read(0, &c, 1);
 26a:	8656                	mv	a2,s5
 26c:	85da                	mv	a1,s6
 26e:	4501                	li	a0,0
 270:	190000ef          	jal	400 <read>
    if(cc < 1)
 274:	00a05d63          	blez	a0,28e <gets+0x56>
      break;
    buf[i++] = c;
 278:	faf44783          	lbu	a5,-81(s0)
 27c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 280:	0905                	addi	s2,s2,1
 282:	ff678713          	addi	a4,a5,-10
 286:	c319                	beqz	a4,28c <gets+0x54>
 288:	17cd                	addi	a5,a5,-13
 28a:	fbf1                	bnez	a5,25e <gets+0x26>
    buf[i++] = c;
 28c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 28e:	9c5e                	add	s8,s8,s7
 290:	000c0023          	sb	zero,0(s8)
  return buf;
}
 294:	855e                	mv	a0,s7
 296:	60e6                	ld	ra,88(sp)
 298:	6446                	ld	s0,80(sp)
 29a:	64a6                	ld	s1,72(sp)
 29c:	6906                	ld	s2,64(sp)
 29e:	79e2                	ld	s3,56(sp)
 2a0:	7a42                	ld	s4,48(sp)
 2a2:	7aa2                	ld	s5,40(sp)
 2a4:	7b02                	ld	s6,32(sp)
 2a6:	6be2                	ld	s7,24(sp)
 2a8:	6c42                	ld	s8,16(sp)
 2aa:	6125                	addi	sp,sp,96
 2ac:	8082                	ret

00000000000002ae <stat>:

int
stat(const char *n, struct stat *st)
{
 2ae:	1101                	addi	sp,sp,-32
 2b0:	ec06                	sd	ra,24(sp)
 2b2:	e822                	sd	s0,16(sp)
 2b4:	e04a                	sd	s2,0(sp)
 2b6:	1000                	addi	s0,sp,32
 2b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	4581                	li	a1,0
 2bc:	194000ef          	jal	450 <open>
  if(fd < 0)
 2c0:	02054263          	bltz	a0,2e4 <stat+0x36>
 2c4:	e426                	sd	s1,8(sp)
 2c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c8:	85ca                	mv	a1,s2
 2ca:	14e000ef          	jal	418 <fstat>
 2ce:	892a                	mv	s2,a0
  close(fd);
 2d0:	8526                	mv	a0,s1
 2d2:	1ae000ef          	jal	480 <close>
  return r;
 2d6:	64a2                	ld	s1,8(sp)
}
 2d8:	854a                	mv	a0,s2
 2da:	60e2                	ld	ra,24(sp)
 2dc:	6442                	ld	s0,16(sp)
 2de:	6902                	ld	s2,0(sp)
 2e0:	6105                	addi	sp,sp,32
 2e2:	8082                	ret
    return -1;
 2e4:	57fd                	li	a5,-1
 2e6:	893e                	mv	s2,a5
 2e8:	bfc5                	j	2d8 <stat+0x2a>

00000000000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	00054683          	lbu	a3,0(a0)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	4625                	li	a2,9
 300:	02f66963          	bltu	a2,a5,332 <atoi+0x48>
 304:	872a                	mv	a4,a0
  n = 0;
 306:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 308:	0705                	addi	a4,a4,1
 30a:	0025179b          	slliw	a5,a0,0x2
 30e:	9fa9                	addw	a5,a5,a0
 310:	0017979b          	slliw	a5,a5,0x1
 314:	9fb5                	addw	a5,a5,a3
 316:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31a:	00074683          	lbu	a3,0(a4)
 31e:	fd06879b          	addiw	a5,a3,-48
 322:	0ff7f793          	zext.b	a5,a5
 326:	fef671e3          	bgeu	a2,a5,308 <atoi+0x1e>
  return n;
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  n = 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <atoi+0x40>

0000000000000336 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33e:	02b57563          	bgeu	a0,a1,368 <memmove+0x32>
    while(n-- > 0)
 342:	00c05f63          	blez	a2,360 <memmove+0x2a>
 346:	1602                	slli	a2,a2,0x20
 348:	9201                	srli	a2,a2,0x20
 34a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34e:	872a                	mv	a4,a0
      *dst++ = *src++;
 350:	0585                	addi	a1,a1,1
 352:	0705                	addi	a4,a4,1
 354:	fff5c683          	lbu	a3,-1(a1)
 358:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35c:	fee79ae3          	bne	a5,a4,350 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
    while(n-- > 0)
 368:	fec05ce3          	blez	a2,360 <memmove+0x2a>
    dst += n;
 36c:	00c50733          	add	a4,a0,a2
    src += n;
 370:	95b2                	add	a1,a1,a2
 372:	fff6079b          	addiw	a5,a2,-1
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	fff7c793          	not	a5,a5
 37e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 380:	15fd                	addi	a1,a1,-1
 382:	177d                	addi	a4,a4,-1
 384:	0005c683          	lbu	a3,0(a1)
 388:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38c:	fef71ae3          	bne	a4,a5,380 <memmove+0x4a>
 390:	bfc1                	j	360 <memmove+0x2a>

0000000000000392 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 39a:	c61d                	beqz	a2,3c8 <memcmp+0x36>
 39c:	1602                	slli	a2,a2,0x20
 39e:	9201                	srli	a2,a2,0x20
 3a0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	0005c703          	lbu	a4,0(a1)
 3ac:	00e79863          	bne	a5,a4,3bc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3b0:	0505                	addi	a0,a0,1
    p2++;
 3b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b4:	fed518e3          	bne	a0,a3,3a4 <memcmp+0x12>
  }
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	a019                	j	3c0 <memcmp+0x2e>
      return *p1 - *p2;
 3bc:	40e7853b          	subw	a0,a5,a4
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	bfdd                	j	3c0 <memcmp+0x2e>

00000000000003cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d4:	f63ff0ef          	jal	336 <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <kill>:
.global kill
kill:
 li a7, SYS_kill
 408:	4899                	li	a7,6
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exec>:
.global exec
exec:
 li a7, SYS_exec
 410:	489d                	li	a7,7
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 420:	48a5                	li	a7,9
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <dup>:
.global dup
dup:
 li a7, SYS_dup
 428:	48a9                	li	a7,10
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 430:	48ad                	li	a7,11
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 438:	48b1                	li	a7,12
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 440:	48b5                	li	a7,13
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 448:	48b9                	li	a7,14
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <open>:
.global open
open:
 li a7, SYS_open
 450:	48bd                	li	a7,15
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	48c1                	li	a7,16
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 460:	48c5                	li	a7,17
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 468:	48c9                	li	a7,18
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <link>:
.global link
link:
 li a7, SYS_link
 470:	48cd                	li	a7,19
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 478:	48d1                	li	a7,20
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <close>:
.global close
close:
 li a7, SYS_close
 480:	48d5                	li	a7,21
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 488:	48d9                	li	a7,22
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 490:	48dd                	li	a7,23
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 498:	48e1                	li	a7,24
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	fa7ff0ef          	jal	458 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	0080                	addi	s0,sp,64
 4ca:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	cac9                	beqz	a3,55e <printint+0xa0>
 4ce:	01f5d79b          	srliw	a5,a1,0x1f
 4d2:	c7d1                	beqz	a5,55e <printint+0xa0>
    neg = 1;
    x = -xx;
 4d4:	40b005bb          	negw	a1,a1
    neg = 1;
 4d8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4da:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4de:	86ce                	mv	a3,s3
  i = 0;
 4e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e2:	00000817          	auipc	a6,0x0
 4e6:	54e80813          	addi	a6,a6,1358 # a30 <digits>
 4ea:	88ba                	mv	a7,a4
 4ec:	0017051b          	addiw	a0,a4,1
 4f0:	872a                	mv	a4,a0
 4f2:	02c5f7bb          	remuw	a5,a1,a2
 4f6:	1782                	slli	a5,a5,0x20
 4f8:	9381                	srli	a5,a5,0x20
 4fa:	97c2                	add	a5,a5,a6
 4fc:	0007c783          	lbu	a5,0(a5)
 500:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 504:	87ae                	mv	a5,a1
 506:	02c5d5bb          	divuw	a1,a1,a2
 50a:	0685                	addi	a3,a3,1
 50c:	fcc7ffe3          	bgeu	a5,a2,4ea <printint+0x2c>
  if(neg)
 510:	00030c63          	beqz	t1,528 <printint+0x6a>
    buf[i++] = '-';
 514:	fd050793          	addi	a5,a0,-48
 518:	00878533          	add	a0,a5,s0
 51c:	02d00793          	li	a5,45
 520:	fef50823          	sb	a5,-16(a0)
 524:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 528:	02e05563          	blez	a4,552 <printint+0x94>
 52c:	f426                	sd	s1,40(sp)
 52e:	377d                	addiw	a4,a4,-1
 530:	00e984b3          	add	s1,s3,a4
 534:	19fd                	addi	s3,s3,-1
 536:	99ba                	add	s3,s3,a4
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	0004c583          	lbu	a1,0(s1)
 544:	854a                	mv	a0,s2
 546:	f5bff0ef          	jal	4a0 <putc>
  while(--i >= 0)
 54a:	14fd                	addi	s1,s1,-1
 54c:	ff349ae3          	bne	s1,s3,540 <printint+0x82>
 550:	74a2                	ld	s1,40(sp)
}
 552:	70e2                	ld	ra,56(sp)
 554:	7442                	ld	s0,48(sp)
 556:	7902                	ld	s2,32(sp)
 558:	69e2                	ld	s3,24(sp)
 55a:	6121                	addi	sp,sp,64
 55c:	8082                	ret
  neg = 0;
 55e:	4301                	li	t1,0
 560:	bfad                	j	4da <printint+0x1c>

0000000000000562 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 562:	711d                	addi	sp,sp,-96
 564:	ec86                	sd	ra,88(sp)
 566:	e8a2                	sd	s0,80(sp)
 568:	e4a6                	sd	s1,72(sp)
 56a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 56c:	0005c483          	lbu	s1,0(a1)
 570:	20048963          	beqz	s1,782 <vprintf+0x220>
 574:	e0ca                	sd	s2,64(sp)
 576:	fc4e                	sd	s3,56(sp)
 578:	f852                	sd	s4,48(sp)
 57a:	f456                	sd	s5,40(sp)
 57c:	f05a                	sd	s6,32(sp)
 57e:	ec5e                	sd	s7,24(sp)
 580:	e862                	sd	s8,16(sp)
 582:	8b2a                	mv	s6,a0
 584:	8a2e                	mv	s4,a1
 586:	8bb2                	mv	s7,a2
  state = 0;
 588:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 58a:	4901                	li	s2,0
 58c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 592:	06400c13          	li	s8,100
 596:	a00d                	j	5b8 <vprintf+0x56>
        putc(fd, c0);
 598:	85a6                	mv	a1,s1
 59a:	855a                	mv	a0,s6
 59c:	f05ff0ef          	jal	4a0 <putc>
 5a0:	a019                	j	5a6 <vprintf+0x44>
    } else if(state == '%'){
 5a2:	03598363          	beq	s3,s5,5c8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5a6:	0019079b          	addiw	a5,s2,1
 5aa:	893e                	mv	s2,a5
 5ac:	873e                	mv	a4,a5
 5ae:	97d2                	add	a5,a5,s4
 5b0:	0007c483          	lbu	s1,0(a5)
 5b4:	1c048063          	beqz	s1,774 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 5b8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5bc:	fe0993e3          	bnez	s3,5a2 <vprintf+0x40>
      if(c0 == '%'){
 5c0:	fd579ce3          	bne	a5,s5,598 <vprintf+0x36>
        state = '%';
 5c4:	89be                	mv	s3,a5
 5c6:	b7c5                	j	5a6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c8:	00ea06b3          	add	a3,s4,a4
 5cc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5d0:	1a060e63          	beqz	a2,78c <vprintf+0x22a>
      if(c0 == 'd'){
 5d4:	03878763          	beq	a5,s8,602 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	f9478693          	addi	a3,a5,-108
 5dc:	0016b693          	seqz	a3,a3
 5e0:	f9c60593          	addi	a1,a2,-100
 5e4:	e99d                	bnez	a1,61a <vprintf+0xb8>
 5e6:	ca95                	beqz	a3,61a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	ec9ff0ef          	jal	4be <printint>
        i += 1;
 5fa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fc:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b75d                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	eafff0ef          	jal	4be <printint>
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	b779                	j	5a6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 61a:	9752                	add	a4,a4,s4
 61c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 620:	f9460713          	addi	a4,a2,-108
 624:	00173713          	seqz	a4,a4
 628:	8f75                	and	a4,a4,a3
 62a:	f9c58513          	addi	a0,a1,-100
 62e:	16051963          	bnez	a0,7a0 <vprintf+0x23e>
 632:	16070763          	beqz	a4,7a0 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8493          	addi	s1,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e7bff0ef          	jal	4be <printint>
        i += 2;
 648:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bfa1                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e61ff0ef          	jal	4be <printint>
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
 666:	b781                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4629                	li	a2,10
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e49ff0ef          	jal	4be <printint>
        i += 1;
 67a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
 680:	b71d                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8493          	addi	s1,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e2fff0ef          	jal	4be <printint>
        i += 2;
 694:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	b731                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e15ff0ef          	jal	4be <printint>
 6ae:	8ba6                	mv	s7,s1
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bdd5                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	008b8493          	addi	s1,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dfdff0ef          	jal	4be <printint>
        i += 1;
 6c6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	8ba6                	mv	s7,s1
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bde9                	j	5a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8493          	addi	s1,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	de3ff0ef          	jal	4be <printint>
        i += 2;
 6e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8ba6                	mv	s7,s1
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	b5c1                	j	5a6 <vprintf+0x44>
 6e8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ea:	008b8793          	addi	a5,s7,8
 6ee:	8cbe                	mv	s9,a5
 6f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f4:	03000593          	li	a1,48
 6f8:	855a                	mv	a0,s6
 6fa:	da7ff0ef          	jal	4a0 <putc>
  putc(fd, 'x');
 6fe:	07800593          	li	a1,120
 702:	855a                	mv	a0,s6
 704:	d9dff0ef          	jal	4a0 <putc>
 708:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	00000b97          	auipc	s7,0x0
 70e:	326b8b93          	addi	s7,s7,806 # a30 <digits>
 712:	03c9d793          	srli	a5,s3,0x3c
 716:	97de                	add	a5,a5,s7
 718:	0007c583          	lbu	a1,0(a5)
 71c:	855a                	mv	a0,s6
 71e:	d83ff0ef          	jal	4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 722:	0992                	slli	s3,s3,0x4
 724:	34fd                	addiw	s1,s1,-1
 726:	f4f5                	bnez	s1,712 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 728:	8be6                	mv	s7,s9
      state = 0;
 72a:	4981                	li	s3,0
 72c:	6ca2                	ld	s9,8(sp)
 72e:	bda5                	j	5a6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 730:	008b8993          	addi	s3,s7,8
 734:	000bb483          	ld	s1,0(s7)
 738:	cc91                	beqz	s1,754 <vprintf+0x1f2>
        for(; *s; s++)
 73a:	0004c583          	lbu	a1,0(s1)
 73e:	c985                	beqz	a1,76e <vprintf+0x20c>
          putc(fd, *s);
 740:	855a                	mv	a0,s6
 742:	d5fff0ef          	jal	4a0 <putc>
        for(; *s; s++)
 746:	0485                	addi	s1,s1,1
 748:	0004c583          	lbu	a1,0(s1)
 74c:	f9f5                	bnez	a1,740 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	bd91                	j	5a6 <vprintf+0x44>
          s = "(null)";
 754:	00000497          	auipc	s1,0x0
 758:	2d448493          	addi	s1,s1,724 # a28 <malloc+0x140>
        for(; *s; s++)
 75c:	02800593          	li	a1,40
 760:	b7c5                	j	740 <vprintf+0x1de>
        putc(fd, '%');
 762:	85be                	mv	a1,a5
 764:	855a                	mv	a0,s6
 766:	d3bff0ef          	jal	4a0 <putc>
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bd2d                	j	5a6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bd15                	j	5a6 <vprintf+0x44>
 774:	6906                	ld	s2,64(sp)
 776:	79e2                	ld	s3,56(sp)
 778:	7a42                	ld	s4,48(sp)
 77a:	7aa2                	ld	s5,40(sp)
 77c:	7b02                	ld	s6,32(sp)
 77e:	6be2                	ld	s7,24(sp)
 780:	6c42                	ld	s8,16(sp)
    }
  }
}
 782:	60e6                	ld	ra,88(sp)
 784:	6446                	ld	s0,80(sp)
 786:	64a6                	ld	s1,72(sp)
 788:	6125                	addi	sp,sp,96
 78a:	8082                	ret
      if(c0 == 'd'){
 78c:	06400713          	li	a4,100
 790:	e6e789e3          	beq	a5,a4,602 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 794:	f9478693          	addi	a3,a5,-108
 798:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 79c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 79e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7a0:	07500513          	li	a0,117
 7a4:	eaa786e3          	beq	a5,a0,650 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7a8:	f8b60513          	addi	a0,a2,-117
 7ac:	e119                	bnez	a0,7b2 <vprintf+0x250>
 7ae:	ea069de3          	bnez	a3,668 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b2:	f8b58513          	addi	a0,a1,-117
 7b6:	e119                	bnez	a0,7bc <vprintf+0x25a>
 7b8:	ec0715e3          	bnez	a4,682 <vprintf+0x120>
      } else if(c0 == 'x'){
 7bc:	07800513          	li	a0,120
 7c0:	eca78ee3          	beq	a5,a0,69c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7c4:	f8860613          	addi	a2,a2,-120
 7c8:	e219                	bnez	a2,7ce <vprintf+0x26c>
 7ca:	ee0695e3          	bnez	a3,6b4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ce:	f8858593          	addi	a1,a1,-120
 7d2:	e199                	bnez	a1,7d8 <vprintf+0x276>
 7d4:	ee071de3          	bnez	a4,6ce <vprintf+0x16c>
      } else if(c0 == 'p'){
 7d8:	07000713          	li	a4,112
 7dc:	f0e786e3          	beq	a5,a4,6e8 <vprintf+0x186>
      } else if(c0 == 's'){
 7e0:	07300713          	li	a4,115
 7e4:	f4e786e3          	beq	a5,a4,730 <vprintf+0x1ce>
      } else if(c0 == '%'){
 7e8:	02500713          	li	a4,37
 7ec:	f6e78be3          	beq	a5,a4,762 <vprintf+0x200>
        putc(fd, '%');
 7f0:	02500593          	li	a1,37
 7f4:	855a                	mv	a0,s6
 7f6:	cabff0ef          	jal	4a0 <putc>
        putc(fd, c0);
 7fa:	85a6                	mv	a1,s1
 7fc:	855a                	mv	a0,s6
 7fe:	ca3ff0ef          	jal	4a0 <putc>
      state = 0;
 802:	4981                	li	s3,0
 804:	b34d                	j	5a6 <vprintf+0x44>

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	8622                	mv	a2,s0
 820:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 824:	d3fff0ef          	jal	562 <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6161                	addi	sp,sp,80
 82e:	8082                	ret

0000000000000830 <printf>:

void
printf(const char *fmt, ...)
{
 830:	711d                	addi	sp,sp,-96
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e40c                	sd	a1,8(s0)
 83a:	e810                	sd	a2,16(s0)
 83c:	ec14                	sd	a3,24(s0)
 83e:	f018                	sd	a4,32(s0)
 840:	f41c                	sd	a5,40(s0)
 842:	03043823          	sd	a6,48(s0)
 846:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	00840613          	addi	a2,s0,8
 84e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 852:	85aa                	mv	a1,a0
 854:	4505                	li	a0,1
 856:	d0dff0ef          	jal	562 <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6125                	addi	sp,sp,96
 860:	8082                	ret

0000000000000862 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 862:	1141                	addi	sp,sp,-16
 864:	e406                	sd	ra,8(sp)
 866:	e022                	sd	s0,0(sp)
 868:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	00000797          	auipc	a5,0x0
 872:	7927b783          	ld	a5,1938(a5) # 1000 <freep>
 876:	a039                	j	884 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 878:	6398                	ld	a4,0(a5)
 87a:	00e7e463          	bltu	a5,a4,882 <free+0x20>
 87e:	00e6ea63          	bltu	a3,a4,892 <free+0x30>
{
 882:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	fed7fae3          	bgeu	a5,a3,878 <free+0x16>
 888:	6398                	ld	a4,0(a5)
 88a:	00e6e463          	bltu	a3,a4,892 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	fee7eae3          	bltu	a5,a4,882 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 892:	ff852583          	lw	a1,-8(a0)
 896:	6390                	ld	a2,0(a5)
 898:	02059813          	slli	a6,a1,0x20
 89c:	01c85713          	srli	a4,a6,0x1c
 8a0:	9736                	add	a4,a4,a3
 8a2:	02e60563          	beq	a2,a4,8cc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8aa:	4790                	lw	a2,8(a5)
 8ac:	02061593          	slli	a1,a2,0x20
 8b0:	01c5d713          	srli	a4,a1,0x1c
 8b4:	973e                	add	a4,a4,a5
 8b6:	02e68263          	beq	a3,a4,8da <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74f73223          	sd	a5,1860(a4) # 1000 <freep>
}
 8c4:	60a2                	ld	ra,8(sp)
 8c6:	6402                	ld	s0,0(sp)
 8c8:	0141                	addi	sp,sp,16
 8ca:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8cc:	4618                	lw	a4,8(a2)
 8ce:	9f2d                	addw	a4,a4,a1
 8d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	6310                	ld	a2,0(a4)
 8d8:	b7f9                	j	8a6 <free+0x44>
    p->s.size += bp->s.size;
 8da:	ff852703          	lw	a4,-8(a0)
 8de:	9f31                	addw	a4,a4,a2
 8e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e2:	ff053683          	ld	a3,-16(a0)
 8e6:	bfd1                	j	8ba <free+0x58>

00000000000008e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e8:	7139                	addi	sp,sp,-64
 8ea:	fc06                	sd	ra,56(sp)
 8ec:	f822                	sd	s0,48(sp)
 8ee:	f04a                	sd	s2,32(sp)
 8f0:	ec4e                	sd	s3,24(sp)
 8f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f4:	02051993          	slli	s3,a0,0x20
 8f8:	0209d993          	srli	s3,s3,0x20
 8fc:	09bd                	addi	s3,s3,15
 8fe:	0049d993          	srli	s3,s3,0x4
 902:	2985                	addiw	s3,s3,1
 904:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 906:	00000517          	auipc	a0,0x0
 90a:	6fa53503          	ld	a0,1786(a0) # 1000 <freep>
 90e:	c905                	beqz	a0,93e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 912:	4798                	lw	a4,8(a5)
 914:	09377663          	bgeu	a4,s3,9a0 <malloc+0xb8>
 918:	f426                	sd	s1,40(sp)
 91a:	e852                	sd	s4,16(sp)
 91c:	e456                	sd	s5,8(sp)
 91e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 920:	8a4e                	mv	s4,s3
 922:	6705                	lui	a4,0x1
 924:	00e9f363          	bgeu	s3,a4,92a <malloc+0x42>
 928:	6a05                	lui	s4,0x1
 92a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 932:	00000497          	auipc	s1,0x0
 936:	6ce48493          	addi	s1,s1,1742 # 1000 <freep>
  if(p == (char*)-1)
 93a:	5afd                	li	s5,-1
 93c:	a83d                	j	97a <malloc+0x92>
 93e:	f426                	sd	s1,40(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 946:	00001797          	auipc	a5,0x1
 94a:	8ca78793          	addi	a5,a5,-1846 # 1210 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	6af73923          	sd	a5,1714(a4) # 1000 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95c:	b7d1                	j	920 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 95e:	6398                	ld	a4,0(a5)
 960:	e118                	sd	a4,0(a0)
 962:	a899                	j	9b8 <malloc+0xd0>
  hp->s.size = nu;
 964:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 968:	0541                	addi	a0,a0,16
 96a:	ef9ff0ef          	jal	862 <free>
  return freep;
 96e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 970:	c125                	beqz	a0,9d0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 974:	4798                	lw	a4,8(a5)
 976:	03277163          	bgeu	a4,s2,998 <malloc+0xb0>
    if(p == freep)
 97a:	6098                	ld	a4,0(s1)
 97c:	853e                	mv	a0,a5
 97e:	fef71ae3          	bne	a4,a5,972 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 982:	8552                	mv	a0,s4
 984:	ab5ff0ef          	jal	438 <sbrk>
  if(p == (char*)-1)
 988:	fd551ee3          	bne	a0,s5,964 <malloc+0x7c>
        return 0;
 98c:	4501                	li	a0,0
 98e:	74a2                	ld	s1,40(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
 996:	a03d                	j	9c4 <malloc+0xdc>
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9a0:	fae90fe3          	beq	s2,a4,95e <malloc+0x76>
        p->s.size -= nunits;
 9a4:	4137073b          	subw	a4,a4,s3
 9a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9aa:	02071693          	slli	a3,a4,0x20
 9ae:	01c6d713          	srli	a4,a3,0x1c
 9b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64a73423          	sd	a0,1608(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c0:	01078513          	addi	a0,a5,16
  }
}
 9c4:	70e2                	ld	ra,56(sp)
 9c6:	7442                	ld	s0,48(sp)
 9c8:	7902                	ld	s2,32(sp)
 9ca:	69e2                	ld	s3,24(sp)
 9cc:	6121                	addi	sp,sp,64
 9ce:	8082                	ret
 9d0:	74a2                	ld	s1,40(sp)
 9d2:	6a42                	ld	s4,16(sp)
 9d4:	6aa2                	ld	s5,8(sp)
 9d6:	6b02                	ld	s6,0(sp)
 9d8:	b7f5                	j	9c4 <malloc+0xdc>
