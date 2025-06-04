
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if(matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	02a000ef          	jal	4c <matchhere>
  26:	e911                	bnez	a0,3a <matchstar+0x3a>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb81                	beqz	a5,3c <matchstar+0x3c>
  2e:	0485                	addi	s1,s1,1
  30:	ff2787e3          	beq	a5,s2,1e <matchstar+0x1e>
  34:	fe0a15e3          	bnez	s4,1e <matchstar+0x1e>
  38:	a011                	j	3c <matchstar+0x3c>
      return 1;
  3a:	4505                	li	a0,1
  return 0;
}
  3c:	70a2                	ld	ra,40(sp)
  3e:	7402                	ld	s0,32(sp)
  40:	64e2                	ld	s1,24(sp)
  42:	6942                	ld	s2,16(sp)
  44:	69a2                	ld	s3,8(sp)
  46:	6a02                	ld	s4,0(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret

000000000000004c <matchhere>:
  if(re[0] == '\0')
  4c:	00054703          	lbu	a4,0(a0)
  50:	cf39                	beqz	a4,ae <matchhere+0x62>
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  5a:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5c:	00154683          	lbu	a3,1(a0)
  60:	02a00613          	li	a2,42
  64:	02c68363          	beq	a3,a2,8a <matchhere+0x3e>
  if(re[0] == '$' && re[1] == '\0')
  68:	e681                	bnez	a3,70 <matchhere+0x24>
  6a:	fdc70693          	addi	a3,a4,-36
  6e:	c68d                	beqz	a3,98 <matchhere+0x4c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  70:	0005c683          	lbu	a3,0(a1)
  return 0;
  74:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  76:	c691                	beqz	a3,82 <matchhere+0x36>
  78:	02d70563          	beq	a4,a3,a2 <matchhere+0x56>
  7c:	fd270713          	addi	a4,a4,-46
  80:	c30d                	beqz	a4,a2 <matchhere+0x56>
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
    return matchstar(re[0], re+2, text);
  8a:	862e                	mv	a2,a1
  8c:	00250593          	addi	a1,a0,2
  90:	853a                	mv	a0,a4
  92:	f6fff0ef          	jal	0 <matchstar>
  96:	b7f5                	j	82 <matchhere+0x36>
    return *text == '\0';
  98:	0005c503          	lbu	a0,0(a1)
  9c:	00153513          	seqz	a0,a0
  a0:	b7cd                	j	82 <matchhere+0x36>
    return matchhere(re+1, text+1);
  a2:	0585                	addi	a1,a1,1
  a4:	00178513          	addi	a0,a5,1
  a8:	fa5ff0ef          	jal	4c <matchhere>
  ac:	bfd9                	j	82 <matchhere+0x36>
    return 1;
  ae:	4505                	li	a0,1
}
  b0:	8082                	ret

00000000000000b2 <match>:
{
  b2:	1101                	addi	sp,sp,-32
  b4:	ec06                	sd	ra,24(sp)
  b6:	e822                	sd	s0,16(sp)
  b8:	e426                	sd	s1,8(sp)
  ba:	e04a                	sd	s2,0(sp)
  bc:	1000                	addi	s0,sp,32
  be:	892a                	mv	s2,a0
  c0:	84ae                	mv	s1,a1
  if(re[0] == '^')
  c2:	00054703          	lbu	a4,0(a0)
  c6:	05e00793          	li	a5,94
  ca:	00f70c63          	beq	a4,a5,e2 <match+0x30>
    if(matchhere(re, text))
  ce:	85a6                	mv	a1,s1
  d0:	854a                	mv	a0,s2
  d2:	f7bff0ef          	jal	4c <matchhere>
  d6:	e911                	bnez	a0,ea <match+0x38>
  }while(*text++ != '\0');
  d8:	0485                	addi	s1,s1,1
  da:	fff4c783          	lbu	a5,-1(s1)
  de:	fbe5                	bnez	a5,ce <match+0x1c>
  e0:	a031                	j	ec <match+0x3a>
    return matchhere(re+1, text);
  e2:	0505                	addi	a0,a0,1
  e4:	f69ff0ef          	jal	4c <matchhere>
  e8:	a011                	j	ec <match+0x3a>
      return 1;
  ea:	4505                	li	a0,1
}
  ec:	60e2                	ld	ra,24(sp)
  ee:	6442                	ld	s0,16(sp)
  f0:	64a2                	ld	s1,8(sp)
  f2:	6902                	ld	s2,0(sp)
  f4:	6105                	addi	sp,sp,32
  f6:	8082                	ret

00000000000000f8 <grep>:
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	e862                	sd	s8,16(sp)
 10e:	e466                	sd	s9,8(sp)
 110:	e06a                	sd	s10,0(sp)
 112:	1080                	addi	s0,sp,96
 114:	8aaa                	mv	s5,a0
 116:	8cae                	mv	s9,a1
  m = 0;
 118:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 11a:	3ff00d13          	li	s10,1023
 11e:	00002b97          	auipc	s7,0x2
 122:	ef2b8b93          	addi	s7,s7,-270 # 2010 <buf>
    while((q = strchr(p, '\n')) != 0){
 126:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 128:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 12a:	a82d                	j	164 <grep+0x6c>
      p = q+1;
 12c:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 130:	85ce                	mv	a1,s3
 132:	854a                	mv	a0,s2
 134:	1dc000ef          	jal	310 <strchr>
 138:	84aa                	mv	s1,a0
 13a:	c11d                	beqz	a0,160 <grep+0x68>
      *q = 0;
 13c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 140:	85ca                	mv	a1,s2
 142:	8556                	mv	a0,s5
 144:	f6fff0ef          	jal	b2 <match>
 148:	d175                	beqz	a0,12c <grep+0x34>
        *q = '\n';
 14a:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 14e:	00148613          	addi	a2,s1,1
 152:	4126063b          	subw	a2,a2,s2
 156:	85ca                	mv	a1,s2
 158:	8562                	mv	a0,s8
 15a:	3fe000ef          	jal	558 <write>
 15e:	b7f9                	j	12c <grep+0x34>
    if(m > 0){
 160:	03604463          	bgtz	s6,188 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 164:	416d063b          	subw	a2,s10,s6
 168:	016b85b3          	add	a1,s7,s6
 16c:	8566                	mv	a0,s9
 16e:	392000ef          	jal	500 <read>
 172:	02a05c63          	blez	a0,1aa <grep+0xb2>
    m += n;
 176:	00ab0a3b          	addw	s4,s6,a0
 17a:	8b52                	mv	s6,s4
    buf[m] = '\0';
 17c:	014b87b3          	add	a5,s7,s4
 180:	00078023          	sb	zero,0(a5)
    p = buf;
 184:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 186:	b76d                	j	130 <grep+0x38>
      m -= p - buf;
 188:	00002797          	auipc	a5,0x2
 18c:	e8878793          	addi	a5,a5,-376 # 2010 <buf>
 190:	40f907b3          	sub	a5,s2,a5
 194:	40fa063b          	subw	a2,s4,a5
 198:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 19a:	85ca                	mv	a1,s2
 19c:	00002517          	auipc	a0,0x2
 1a0:	e7450513          	addi	a0,a0,-396 # 2010 <buf>
 1a4:	292000ef          	jal	436 <memmove>
 1a8:	bf75                	j	164 <grep+0x6c>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7179                	addi	sp,sp,-48
 1c8:	f406                	sd	ra,40(sp)
 1ca:	f022                	sd	s0,32(sp)
 1cc:	ec26                	sd	s1,24(sp)
 1ce:	e84a                	sd	s2,16(sp)
 1d0:	e44e                	sd	s3,8(sp)
 1d2:	e052                	sd	s4,0(sp)
 1d4:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d6:	4785                	li	a5,1
 1d8:	04a7d663          	bge	a5,a0,224 <main+0x5e>
  pattern = argv[1];
 1dc:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e0:	4789                	li	a5,2
 1e2:	04a7db63          	bge	a5,a0,238 <main+0x72>
 1e6:	01058913          	addi	s2,a1,16
 1ea:	ffd5099b          	addiw	s3,a0,-3
 1ee:	02099793          	slli	a5,s3,0x20
 1f2:	01d7d993          	srli	s3,a5,0x1d
 1f6:	05e1                	addi	a1,a1,24
 1f8:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fa:	4581                	li	a1,0
 1fc:	00093503          	ld	a0,0(s2)
 200:	350000ef          	jal	550 <open>
 204:	84aa                	mv	s1,a0
 206:	04054063          	bltz	a0,246 <main+0x80>
    grep(pattern, fd);
 20a:	85aa                	mv	a1,a0
 20c:	8552                	mv	a0,s4
 20e:	eebff0ef          	jal	f8 <grep>
    close(fd);
 212:	8526                	mv	a0,s1
 214:	36c000ef          	jal	580 <close>
  for(i = 2; i < argc; i++){
 218:	0921                	addi	s2,s2,8
 21a:	ff3910e3          	bne	s2,s3,1fa <main+0x34>
  exit(0);
 21e:	4501                	li	a0,0
 220:	2c8000ef          	jal	4e8 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 224:	00001597          	auipc	a1,0x1
 228:	8cc58593          	addi	a1,a1,-1844 # af0 <malloc+0x100>
 22c:	4509                	li	a0,2
 22e:	6e0000ef          	jal	90e <fprintf>
    exit(1);
 232:	4505                	li	a0,1
 234:	2b4000ef          	jal	4e8 <exit>
    grep(pattern, 0);
 238:	4581                	li	a1,0
 23a:	8552                	mv	a0,s4
 23c:	ebdff0ef          	jal	f8 <grep>
    exit(0);
 240:	4501                	li	a0,0
 242:	2a6000ef          	jal	4e8 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 246:	00093583          	ld	a1,0(s2)
 24a:	00001517          	auipc	a0,0x1
 24e:	8c650513          	addi	a0,a0,-1850 # b10 <malloc+0x120>
 252:	6e6000ef          	jal	938 <printf>
      exit(1);
 256:	4505                	li	a0,1
 258:	290000ef          	jal	4e8 <exit>

000000000000025c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  extern int main();
  main();
 264:	f63ff0ef          	jal	1c6 <main>
  exit(0);
 268:	4501                	li	a0,0
 26a:	27e000ef          	jal	4e8 <exit>

000000000000026e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 276:	87aa                	mv	a5,a0
 278:	0585                	addi	a1,a1,1
 27a:	0785                	addi	a5,a5,1
 27c:	fff5c703          	lbu	a4,-1(a1)
 280:	fee78fa3          	sb	a4,-1(a5)
 284:	fb75                	bnez	a4,278 <strcpy+0xa>
    ;
  return os;
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cb91                	beqz	a5,2ae <strcmp+0x20>
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00f71763          	bne	a4,a5,2ae <strcmp+0x20>
    p++, q++;
 2a4:	0505                	addi	a0,a0,1
 2a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	fbe5                	bnez	a5,29c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2ae:	0005c503          	lbu	a0,0(a1)
}
 2b2:	40a7853b          	subw	a0,a5,a0
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strlen>:

uint
strlen(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cf91                	beqz	a5,2e6 <strlen+0x28>
 2cc:	00150793          	addi	a5,a0,1
 2d0:	86be                	mv	a3,a5
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff7c703          	lbu	a4,-1(a5)
 2d8:	ff65                	bnez	a4,2d0 <strlen+0x12>
 2da:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  for(n = 0; s[n]; n++)
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <strlen+0x20>

00000000000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ca19                	beqz	a2,308 <memset+0x1e>
 2f4:	87aa                	mv	a5,a0
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x14>
  }
  return dst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  for(; *s; s++)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cf81                	beqz	a5,334 <strchr+0x24>
    if(*s == c)
 31e:	00f58763          	beq	a1,a5,32c <strchr+0x1c>
  for(; *s; s++)
 322:	0505                	addi	a0,a0,1
 324:	00054783          	lbu	a5,0(a0)
 328:	fbfd                	bnez	a5,31e <strchr+0xe>
      return (char*)s;
  return 0;
 32a:	4501                	li	a0,0
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  return 0;
 334:	4501                	li	a0,0
 336:	bfdd                	j	32c <strchr+0x1c>

0000000000000338 <gets>:

char*
gets(char *buf, int max)
{
 338:	711d                	addi	sp,sp,-96
 33a:	ec86                	sd	ra,88(sp)
 33c:	e8a2                	sd	s0,80(sp)
 33e:	e4a6                	sd	s1,72(sp)
 340:	e0ca                	sd	s2,64(sp)
 342:	fc4e                	sd	s3,56(sp)
 344:	f852                	sd	s4,48(sp)
 346:	f456                	sd	s5,40(sp)
 348:	f05a                	sd	s6,32(sp)
 34a:	ec5e                	sd	s7,24(sp)
 34c:	e862                	sd	s8,16(sp)
 34e:	1080                	addi	s0,sp,96
 350:	8baa                	mv	s7,a0
 352:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 354:	892a                	mv	s2,a0
 356:	4481                	li	s1,0
    cc = read(0, &c, 1);
 358:	faf40b13          	addi	s6,s0,-81
 35c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 35e:	8c26                	mv	s8,s1
 360:	0014899b          	addiw	s3,s1,1
 364:	84ce                	mv	s1,s3
 366:	0349d463          	bge	s3,s4,38e <gets+0x56>
    cc = read(0, &c, 1);
 36a:	8656                	mv	a2,s5
 36c:	85da                	mv	a1,s6
 36e:	4501                	li	a0,0
 370:	190000ef          	jal	500 <read>
    if(cc < 1)
 374:	00a05d63          	blez	a0,38e <gets+0x56>
      break;
    buf[i++] = c;
 378:	faf44783          	lbu	a5,-81(s0)
 37c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 380:	0905                	addi	s2,s2,1
 382:	ff678713          	addi	a4,a5,-10
 386:	c319                	beqz	a4,38c <gets+0x54>
 388:	17cd                	addi	a5,a5,-13
 38a:	fbf1                	bnez	a5,35e <gets+0x26>
    buf[i++] = c;
 38c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38e:	9c5e                	add	s8,s8,s7
 390:	000c0023          	sb	zero,0(s8)
  return buf;
}
 394:	855e                	mv	a0,s7
 396:	60e6                	ld	ra,88(sp)
 398:	6446                	ld	s0,80(sp)
 39a:	64a6                	ld	s1,72(sp)
 39c:	6906                	ld	s2,64(sp)
 39e:	79e2                	ld	s3,56(sp)
 3a0:	7a42                	ld	s4,48(sp)
 3a2:	7aa2                	ld	s5,40(sp)
 3a4:	7b02                	ld	s6,32(sp)
 3a6:	6be2                	ld	s7,24(sp)
 3a8:	6c42                	ld	s8,16(sp)
 3aa:	6125                	addi	sp,sp,96
 3ac:	8082                	ret

00000000000003ae <stat>:

int
stat(const char *n, struct stat *st)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	e04a                	sd	s2,0(sp)
 3b6:	1000                	addi	s0,sp,32
 3b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ba:	4581                	li	a1,0
 3bc:	194000ef          	jal	550 <open>
  if(fd < 0)
 3c0:	02054263          	bltz	a0,3e4 <stat+0x36>
 3c4:	e426                	sd	s1,8(sp)
 3c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c8:	85ca                	mv	a1,s2
 3ca:	14e000ef          	jal	518 <fstat>
 3ce:	892a                	mv	s2,a0
  close(fd);
 3d0:	8526                	mv	a0,s1
 3d2:	1ae000ef          	jal	580 <close>
  return r;
 3d6:	64a2                	ld	s1,8(sp)
}
 3d8:	854a                	mv	a0,s2
 3da:	60e2                	ld	ra,24(sp)
 3dc:	6442                	ld	s0,16(sp)
 3de:	6902                	ld	s2,0(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret
    return -1;
 3e4:	57fd                	li	a5,-1
 3e6:	893e                	mv	s2,a5
 3e8:	bfc5                	j	3d8 <stat+0x2a>

00000000000003ea <atoi>:

int
atoi(const char *s)
{
 3ea:	1141                	addi	sp,sp,-16
 3ec:	e406                	sd	ra,8(sp)
 3ee:	e022                	sd	s0,0(sp)
 3f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f2:	00054683          	lbu	a3,0(a0)
 3f6:	fd06879b          	addiw	a5,a3,-48
 3fa:	0ff7f793          	zext.b	a5,a5
 3fe:	4625                	li	a2,9
 400:	02f66963          	bltu	a2,a5,432 <atoi+0x48>
 404:	872a                	mv	a4,a0
  n = 0;
 406:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 408:	0705                	addi	a4,a4,1
 40a:	0025179b          	slliw	a5,a0,0x2
 40e:	9fa9                	addw	a5,a5,a0
 410:	0017979b          	slliw	a5,a5,0x1
 414:	9fb5                	addw	a5,a5,a3
 416:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 41a:	00074683          	lbu	a3,0(a4)
 41e:	fd06879b          	addiw	a5,a3,-48
 422:	0ff7f793          	zext.b	a5,a5
 426:	fef671e3          	bgeu	a2,a5,408 <atoi+0x1e>
  return n;
}
 42a:	60a2                	ld	ra,8(sp)
 42c:	6402                	ld	s0,0(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
  n = 0;
 432:	4501                	li	a0,0
 434:	bfdd                	j	42a <atoi+0x40>

0000000000000436 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 436:	1141                	addi	sp,sp,-16
 438:	e406                	sd	ra,8(sp)
 43a:	e022                	sd	s0,0(sp)
 43c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43e:	02b57563          	bgeu	a0,a1,468 <memmove+0x32>
    while(n-- > 0)
 442:	00c05f63          	blez	a2,460 <memmove+0x2a>
 446:	1602                	slli	a2,a2,0x20
 448:	9201                	srli	a2,a2,0x20
 44a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44e:	872a                	mv	a4,a0
      *dst++ = *src++;
 450:	0585                	addi	a1,a1,1
 452:	0705                	addi	a4,a4,1
 454:	fff5c683          	lbu	a3,-1(a1)
 458:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 45c:	fee79ae3          	bne	a5,a4,450 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
    while(n-- > 0)
 468:	fec05ce3          	blez	a2,460 <memmove+0x2a>
    dst += n;
 46c:	00c50733          	add	a4,a0,a2
    src += n;
 470:	95b2                	add	a1,a1,a2
 472:	fff6079b          	addiw	a5,a2,-1
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	fff7c793          	not	a5,a5
 47e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 480:	15fd                	addi	a1,a1,-1
 482:	177d                	addi	a4,a4,-1
 484:	0005c683          	lbu	a3,0(a1)
 488:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48c:	fef71ae3          	bne	a4,a5,480 <memmove+0x4a>
 490:	bfc1                	j	460 <memmove+0x2a>

0000000000000492 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 49a:	c61d                	beqz	a2,4c8 <memcmp+0x36>
 49c:	1602                	slli	a2,a2,0x20
 49e:	9201                	srli	a2,a2,0x20
 4a0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	0005c703          	lbu	a4,0(a1)
 4ac:	00e79863          	bne	a5,a4,4bc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4b0:	0505                	addi	a0,a0,1
    p2++;
 4b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b4:	fed518e3          	bne	a0,a3,4a4 <memcmp+0x12>
  }
  return 0;
 4b8:	4501                	li	a0,0
 4ba:	a019                	j	4c0 <memcmp+0x2e>
      return *p1 - *p2;
 4bc:	40e7853b          	subw	a0,a5,a4
}
 4c0:	60a2                	ld	ra,8(sp)
 4c2:	6402                	ld	s0,0(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret
  return 0;
 4c8:	4501                	li	a0,0
 4ca:	bfdd                	j	4c0 <memcmp+0x2e>

00000000000004cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d4:	f63ff0ef          	jal	436 <memmove>
}
 4d8:	60a2                	ld	ra,8(sp)
 4da:	6402                	ld	s0,0(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e0:	4885                	li	a7,1
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e8:	4889                	li	a7,2
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f0:	488d                	li	a7,3
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f8:	4891                	li	a7,4
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <read>:
.global read
read:
 li a7, SYS_read
 500:	4895                	li	a7,5
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 518:	48a1                	li	a7,8
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 520:	48a5                	li	a7,9
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <dup>:
.global dup
dup:
 li a7, SYS_dup
 528:	48a9                	li	a7,10
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 530:	48ad                	li	a7,11
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 538:	48b1                	li	a7,12
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 540:	48b5                	li	a7,13
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 548:	48b9                	li	a7,14
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <open>:
.global open
open:
 li a7, SYS_open
 550:	48bd                	li	a7,15
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <write>:
.global write
write:
 li a7, SYS_write
 558:	48c1                	li	a7,16
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 560:	48c5                	li	a7,17
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 568:	48c9                	li	a7,18
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <link>:
.global link
link:
 li a7, SYS_link
 570:	48cd                	li	a7,19
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 578:	48d1                	li	a7,20
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <close>:
.global close
close:
 li a7, SYS_close
 580:	48d5                	li	a7,21
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 588:	48d9                	li	a7,22
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 590:	48dd                	li	a7,23
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 598:	48e1                	li	a7,24
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 5a0:	48e5                	li	a7,25
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a8:	1101                	addi	sp,sp,-32
 5aa:	ec06                	sd	ra,24(sp)
 5ac:	e822                	sd	s0,16(sp)
 5ae:	1000                	addi	s0,sp,32
 5b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b4:	4605                	li	a2,1
 5b6:	fef40593          	addi	a1,s0,-17
 5ba:	f9fff0ef          	jal	558 <write>
}
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	6105                	addi	sp,sp,32
 5c4:	8082                	ret

00000000000005c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c6:	7139                	addi	sp,sp,-64
 5c8:	fc06                	sd	ra,56(sp)
 5ca:	f822                	sd	s0,48(sp)
 5cc:	f04a                	sd	s2,32(sp)
 5ce:	ec4e                	sd	s3,24(sp)
 5d0:	0080                	addi	s0,sp,64
 5d2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d4:	cac9                	beqz	a3,666 <printint+0xa0>
 5d6:	01f5d79b          	srliw	a5,a1,0x1f
 5da:	c7d1                	beqz	a5,666 <printint+0xa0>
    neg = 1;
    x = -xx;
 5dc:	40b005bb          	negw	a1,a1
    neg = 1;
 5e0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5e2:	fc040993          	addi	s3,s0,-64
  neg = 0;
 5e6:	86ce                	mv	a3,s3
  i = 0;
 5e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ea:	00000817          	auipc	a6,0x0
 5ee:	54680813          	addi	a6,a6,1350 # b30 <digits>
 5f2:	88ba                	mv	a7,a4
 5f4:	0017051b          	addiw	a0,a4,1
 5f8:	872a                	mv	a4,a0
 5fa:	02c5f7bb          	remuw	a5,a1,a2
 5fe:	1782                	slli	a5,a5,0x20
 600:	9381                	srli	a5,a5,0x20
 602:	97c2                	add	a5,a5,a6
 604:	0007c783          	lbu	a5,0(a5)
 608:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 60c:	87ae                	mv	a5,a1
 60e:	02c5d5bb          	divuw	a1,a1,a2
 612:	0685                	addi	a3,a3,1
 614:	fcc7ffe3          	bgeu	a5,a2,5f2 <printint+0x2c>
  if(neg)
 618:	00030c63          	beqz	t1,630 <printint+0x6a>
    buf[i++] = '-';
 61c:	fd050793          	addi	a5,a0,-48
 620:	00878533          	add	a0,a5,s0
 624:	02d00793          	li	a5,45
 628:	fef50823          	sb	a5,-16(a0)
 62c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 630:	02e05563          	blez	a4,65a <printint+0x94>
 634:	f426                	sd	s1,40(sp)
 636:	377d                	addiw	a4,a4,-1
 638:	00e984b3          	add	s1,s3,a4
 63c:	19fd                	addi	s3,s3,-1
 63e:	99ba                	add	s3,s3,a4
 640:	1702                	slli	a4,a4,0x20
 642:	9301                	srli	a4,a4,0x20
 644:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 648:	0004c583          	lbu	a1,0(s1)
 64c:	854a                	mv	a0,s2
 64e:	f5bff0ef          	jal	5a8 <putc>
  while(--i >= 0)
 652:	14fd                	addi	s1,s1,-1
 654:	ff349ae3          	bne	s1,s3,648 <printint+0x82>
 658:	74a2                	ld	s1,40(sp)
}
 65a:	70e2                	ld	ra,56(sp)
 65c:	7442                	ld	s0,48(sp)
 65e:	7902                	ld	s2,32(sp)
 660:	69e2                	ld	s3,24(sp)
 662:	6121                	addi	sp,sp,64
 664:	8082                	ret
  neg = 0;
 666:	4301                	li	t1,0
 668:	bfad                	j	5e2 <printint+0x1c>

000000000000066a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66a:	711d                	addi	sp,sp,-96
 66c:	ec86                	sd	ra,88(sp)
 66e:	e8a2                	sd	s0,80(sp)
 670:	e4a6                	sd	s1,72(sp)
 672:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 674:	0005c483          	lbu	s1,0(a1)
 678:	20048963          	beqz	s1,88a <vprintf+0x220>
 67c:	e0ca                	sd	s2,64(sp)
 67e:	fc4e                	sd	s3,56(sp)
 680:	f852                	sd	s4,48(sp)
 682:	f456                	sd	s5,40(sp)
 684:	f05a                	sd	s6,32(sp)
 686:	ec5e                	sd	s7,24(sp)
 688:	e862                	sd	s8,16(sp)
 68a:	8b2a                	mv	s6,a0
 68c:	8a2e                	mv	s4,a1
 68e:	8bb2                	mv	s7,a2
  state = 0;
 690:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 692:	4901                	li	s2,0
 694:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 696:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69a:	06400c13          	li	s8,100
 69e:	a00d                	j	6c0 <vprintf+0x56>
        putc(fd, c0);
 6a0:	85a6                	mv	a1,s1
 6a2:	855a                	mv	a0,s6
 6a4:	f05ff0ef          	jal	5a8 <putc>
 6a8:	a019                	j	6ae <vprintf+0x44>
    } else if(state == '%'){
 6aa:	03598363          	beq	s3,s5,6d0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6ae:	0019079b          	addiw	a5,s2,1
 6b2:	893e                	mv	s2,a5
 6b4:	873e                	mv	a4,a5
 6b6:	97d2                	add	a5,a5,s4
 6b8:	0007c483          	lbu	s1,0(a5)
 6bc:	1c048063          	beqz	s1,87c <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 6c0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6c4:	fe0993e3          	bnez	s3,6aa <vprintf+0x40>
      if(c0 == '%'){
 6c8:	fd579ce3          	bne	a5,s5,6a0 <vprintf+0x36>
        state = '%';
 6cc:	89be                	mv	s3,a5
 6ce:	b7c5                	j	6ae <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d0:	00ea06b3          	add	a3,s4,a4
 6d4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6d8:	1a060e63          	beqz	a2,894 <vprintf+0x22a>
      if(c0 == 'd'){
 6dc:	03878763          	beq	a5,s8,70a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6e0:	f9478693          	addi	a3,a5,-108
 6e4:	0016b693          	seqz	a3,a3
 6e8:	f9c60593          	addi	a1,a2,-100
 6ec:	e99d                	bnez	a1,722 <vprintf+0xb8>
 6ee:	ca95                	beqz	a3,722 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f0:	008b8493          	addi	s1,s7,8
 6f4:	4685                	li	a3,1
 6f6:	4629                	li	a2,10
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	ec9ff0ef          	jal	5c6 <printint>
        i += 1;
 702:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 706:	4981                	li	s3,0
 708:	b75d                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 70a:	008b8493          	addi	s1,s7,8
 70e:	4685                	li	a3,1
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	eafff0ef          	jal	5c6 <printint>
 71c:	8ba6                	mv	s7,s1
      state = 0;
 71e:	4981                	li	s3,0
 720:	b779                	j	6ae <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 722:	9752                	add	a4,a4,s4
 724:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 728:	f9460713          	addi	a4,a2,-108
 72c:	00173713          	seqz	a4,a4
 730:	8f75                	and	a4,a4,a3
 732:	f9c58513          	addi	a0,a1,-100
 736:	16051963          	bnez	a0,8a8 <vprintf+0x23e>
 73a:	16070763          	beqz	a4,8a8 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	008b8493          	addi	s1,s7,8
 742:	4685                	li	a3,1
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	e7bff0ef          	jal	5c6 <printint>
        i += 2;
 750:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 752:	8ba6                	mv	s7,s1
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	bfa1                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 758:	008b8493          	addi	s1,s7,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e61ff0ef          	jal	5c6 <printint>
 76a:	8ba6                	mv	s7,s1
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b781                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	008b8493          	addi	s1,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	e49ff0ef          	jal	5c6 <printint>
        i += 1;
 782:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	8ba6                	mv	s7,s1
      state = 0;
 786:	4981                	li	s3,0
 788:	b71d                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8493          	addi	s1,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	e2fff0ef          	jal	5c6 <printint>
        i += 2;
 79c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	8ba6                	mv	s7,s1
      state = 0;
 7a0:	4981                	li	s3,0
        i += 2;
 7a2:	b731                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7a4:	008b8493          	addi	s1,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e15ff0ef          	jal	5c6 <printint>
 7b6:	8ba6                	mv	s7,s1
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bdd5                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	008b8493          	addi	s1,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	dfdff0ef          	jal	5c6 <printint>
        i += 1;
 7ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	8ba6                	mv	s7,s1
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bde9                	j	6ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	008b8493          	addi	s1,s7,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	de3ff0ef          	jal	5c6 <printint>
        i += 2;
 7e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ea:	8ba6                	mv	s7,s1
      state = 0;
 7ec:	4981                	li	s3,0
        i += 2;
 7ee:	b5c1                	j	6ae <vprintf+0x44>
 7f0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7f2:	008b8793          	addi	a5,s7,8
 7f6:	8cbe                	mv	s9,a5
 7f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7fc:	03000593          	li	a1,48
 800:	855a                	mv	a0,s6
 802:	da7ff0ef          	jal	5a8 <putc>
  putc(fd, 'x');
 806:	07800593          	li	a1,120
 80a:	855a                	mv	a0,s6
 80c:	d9dff0ef          	jal	5a8 <putc>
 810:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 812:	00000b97          	auipc	s7,0x0
 816:	31eb8b93          	addi	s7,s7,798 # b30 <digits>
 81a:	03c9d793          	srli	a5,s3,0x3c
 81e:	97de                	add	a5,a5,s7
 820:	0007c583          	lbu	a1,0(a5)
 824:	855a                	mv	a0,s6
 826:	d83ff0ef          	jal	5a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82a:	0992                	slli	s3,s3,0x4
 82c:	34fd                	addiw	s1,s1,-1
 82e:	f4f5                	bnez	s1,81a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 830:	8be6                	mv	s7,s9
      state = 0;
 832:	4981                	li	s3,0
 834:	6ca2                	ld	s9,8(sp)
 836:	bda5                	j	6ae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 838:	008b8993          	addi	s3,s7,8
 83c:	000bb483          	ld	s1,0(s7)
 840:	cc91                	beqz	s1,85c <vprintf+0x1f2>
        for(; *s; s++)
 842:	0004c583          	lbu	a1,0(s1)
 846:	c985                	beqz	a1,876 <vprintf+0x20c>
          putc(fd, *s);
 848:	855a                	mv	a0,s6
 84a:	d5fff0ef          	jal	5a8 <putc>
        for(; *s; s++)
 84e:	0485                	addi	s1,s1,1
 850:	0004c583          	lbu	a1,0(s1)
 854:	f9f5                	bnez	a1,848 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 856:	8bce                	mv	s7,s3
      state = 0;
 858:	4981                	li	s3,0
 85a:	bd91                	j	6ae <vprintf+0x44>
          s = "(null)";
 85c:	00000497          	auipc	s1,0x0
 860:	2cc48493          	addi	s1,s1,716 # b28 <malloc+0x138>
        for(; *s; s++)
 864:	02800593          	li	a1,40
 868:	b7c5                	j	848 <vprintf+0x1de>
        putc(fd, '%');
 86a:	85be                	mv	a1,a5
 86c:	855a                	mv	a0,s6
 86e:	d3bff0ef          	jal	5a8 <putc>
      state = 0;
 872:	4981                	li	s3,0
 874:	bd2d                	j	6ae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 876:	8bce                	mv	s7,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	bd15                	j	6ae <vprintf+0x44>
 87c:	6906                	ld	s2,64(sp)
 87e:	79e2                	ld	s3,56(sp)
 880:	7a42                	ld	s4,48(sp)
 882:	7aa2                	ld	s5,40(sp)
 884:	7b02                	ld	s6,32(sp)
 886:	6be2                	ld	s7,24(sp)
 888:	6c42                	ld	s8,16(sp)
    }
  }
}
 88a:	60e6                	ld	ra,88(sp)
 88c:	6446                	ld	s0,80(sp)
 88e:	64a6                	ld	s1,72(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret
      if(c0 == 'd'){
 894:	06400713          	li	a4,100
 898:	e6e789e3          	beq	a5,a4,70a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 89c:	f9478693          	addi	a3,a5,-108
 8a0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8a4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8a6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8a8:	07500513          	li	a0,117
 8ac:	eaa786e3          	beq	a5,a0,758 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8b0:	f8b60513          	addi	a0,a2,-117
 8b4:	e119                	bnez	a0,8ba <vprintf+0x250>
 8b6:	ea069de3          	bnez	a3,770 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8ba:	f8b58513          	addi	a0,a1,-117
 8be:	e119                	bnez	a0,8c4 <vprintf+0x25a>
 8c0:	ec0715e3          	bnez	a4,78a <vprintf+0x120>
      } else if(c0 == 'x'){
 8c4:	07800513          	li	a0,120
 8c8:	eca78ee3          	beq	a5,a0,7a4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8cc:	f8860613          	addi	a2,a2,-120
 8d0:	e219                	bnez	a2,8d6 <vprintf+0x26c>
 8d2:	ee0695e3          	bnez	a3,7bc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8d6:	f8858593          	addi	a1,a1,-120
 8da:	e199                	bnez	a1,8e0 <vprintf+0x276>
 8dc:	ee071de3          	bnez	a4,7d6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 8e0:	07000713          	li	a4,112
 8e4:	f0e786e3          	beq	a5,a4,7f0 <vprintf+0x186>
      } else if(c0 == 's'){
 8e8:	07300713          	li	a4,115
 8ec:	f4e786e3          	beq	a5,a4,838 <vprintf+0x1ce>
      } else if(c0 == '%'){
 8f0:	02500713          	li	a4,37
 8f4:	f6e78be3          	beq	a5,a4,86a <vprintf+0x200>
        putc(fd, '%');
 8f8:	02500593          	li	a1,37
 8fc:	855a                	mv	a0,s6
 8fe:	cabff0ef          	jal	5a8 <putc>
        putc(fd, c0);
 902:	85a6                	mv	a1,s1
 904:	855a                	mv	a0,s6
 906:	ca3ff0ef          	jal	5a8 <putc>
      state = 0;
 90a:	4981                	li	s3,0
 90c:	b34d                	j	6ae <vprintf+0x44>

000000000000090e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90e:	715d                	addi	sp,sp,-80
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	addi	s0,sp,32
 916:	e010                	sd	a2,0(s0)
 918:	e414                	sd	a3,8(s0)
 91a:	e818                	sd	a4,16(s0)
 91c:	ec1c                	sd	a5,24(s0)
 91e:	03043023          	sd	a6,32(s0)
 922:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 926:	8622                	mv	a2,s0
 928:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 92c:	d3fff0ef          	jal	66a <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6161                	addi	sp,sp,80
 936:	8082                	ret

0000000000000938 <printf>:

void
printf(const char *fmt, ...)
{
 938:	711d                	addi	sp,sp,-96
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	addi	s0,sp,32
 940:	e40c                	sd	a1,8(s0)
 942:	e810                	sd	a2,16(s0)
 944:	ec14                	sd	a3,24(s0)
 946:	f018                	sd	a4,32(s0)
 948:	f41c                	sd	a5,40(s0)
 94a:	03043823          	sd	a6,48(s0)
 94e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	00840613          	addi	a2,s0,8
 956:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95a:	85aa                	mv	a1,a0
 95c:	4505                	li	a0,1
 95e:	d0dff0ef          	jal	66a <vprintf>
}
 962:	60e2                	ld	ra,24(sp)
 964:	6442                	ld	s0,16(sp)
 966:	6125                	addi	sp,sp,96
 968:	8082                	ret

000000000000096a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96a:	1141                	addi	sp,sp,-16
 96c:	e406                	sd	ra,8(sp)
 96e:	e022                	sd	s0,0(sp)
 970:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 972:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	00001797          	auipc	a5,0x1
 97a:	68a7b783          	ld	a5,1674(a5) # 2000 <freep>
 97e:	a039                	j	98c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	6398                	ld	a4,0(a5)
 982:	00e7e463          	bltu	a5,a4,98a <free+0x20>
 986:	00e6ea63          	bltu	a3,a4,99a <free+0x30>
{
 98a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	fed7fae3          	bgeu	a5,a3,980 <free+0x16>
 990:	6398                	ld	a4,0(a5)
 992:	00e6e463          	bltu	a3,a4,99a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	fee7eae3          	bltu	a5,a4,98a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 99a:	ff852583          	lw	a1,-8(a0)
 99e:	6390                	ld	a2,0(a5)
 9a0:	02059813          	slli	a6,a1,0x20
 9a4:	01c85713          	srli	a4,a6,0x1c
 9a8:	9736                	add	a4,a4,a3
 9aa:	02e60563          	beq	a2,a4,9d4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9ae:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9b2:	4790                	lw	a2,8(a5)
 9b4:	02061593          	slli	a1,a2,0x20
 9b8:	01c5d713          	srli	a4,a1,0x1c
 9bc:	973e                	add	a4,a4,a5
 9be:	02e68263          	beq	a3,a4,9e2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9c2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c4:	00001717          	auipc	a4,0x1
 9c8:	62f73e23          	sd	a5,1596(a4) # 2000 <freep>
}
 9cc:	60a2                	ld	ra,8(sp)
 9ce:	6402                	ld	s0,0(sp)
 9d0:	0141                	addi	sp,sp,16
 9d2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9d4:	4618                	lw	a4,8(a2)
 9d6:	9f2d                	addw	a4,a4,a1
 9d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9dc:	6398                	ld	a4,0(a5)
 9de:	6310                	ld	a2,0(a4)
 9e0:	b7f9                	j	9ae <free+0x44>
    p->s.size += bp->s.size;
 9e2:	ff852703          	lw	a4,-8(a0)
 9e6:	9f31                	addw	a4,a4,a2
 9e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9ea:	ff053683          	ld	a3,-16(a0)
 9ee:	bfd1                	j	9c2 <free+0x58>

00000000000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	7139                	addi	sp,sp,-64
 9f2:	fc06                	sd	ra,56(sp)
 9f4:	f822                	sd	s0,48(sp)
 9f6:	f04a                	sd	s2,32(sp)
 9f8:	ec4e                	sd	s3,24(sp)
 9fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fc:	02051993          	slli	s3,a0,0x20
 a00:	0209d993          	srli	s3,s3,0x20
 a04:	09bd                	addi	s3,s3,15
 a06:	0049d993          	srli	s3,s3,0x4
 a0a:	2985                	addiw	s3,s3,1
 a0c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0e:	00001517          	auipc	a0,0x1
 a12:	5f253503          	ld	a0,1522(a0) # 2000 <freep>
 a16:	c905                	beqz	a0,a46 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1a:	4798                	lw	a4,8(a5)
 a1c:	09377663          	bgeu	a4,s3,aa8 <malloc+0xb8>
 a20:	f426                	sd	s1,40(sp)
 a22:	e852                	sd	s4,16(sp)
 a24:	e456                	sd	s5,8(sp)
 a26:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a28:	8a4e                	mv	s4,s3
 a2a:	6705                	lui	a4,0x1
 a2c:	00e9f363          	bgeu	s3,a4,a32 <malloc+0x42>
 a30:	6a05                	lui	s4,0x1
 a32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3a:	00001497          	auipc	s1,0x1
 a3e:	5c648493          	addi	s1,s1,1478 # 2000 <freep>
  if(p == (char*)-1)
 a42:	5afd                	li	s5,-1
 a44:	a83d                	j	a82 <malloc+0x92>
 a46:	f426                	sd	s1,40(sp)
 a48:	e852                	sd	s4,16(sp)
 a4a:	e456                	sd	s5,8(sp)
 a4c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4e:	00002797          	auipc	a5,0x2
 a52:	9c278793          	addi	a5,a5,-1598 # 2410 <base>
 a56:	00001717          	auipc	a4,0x1
 a5a:	5af73523          	sd	a5,1450(a4) # 2000 <freep>
 a5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a64:	b7d1                	j	a28 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a66:	6398                	ld	a4,0(a5)
 a68:	e118                	sd	a4,0(a0)
 a6a:	a899                	j	ac0 <malloc+0xd0>
  hp->s.size = nu;
 a6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a70:	0541                	addi	a0,a0,16
 a72:	ef9ff0ef          	jal	96a <free>
  return freep;
 a76:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a78:	c125                	beqz	a0,ad8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7c:	4798                	lw	a4,8(a5)
 a7e:	03277163          	bgeu	a4,s2,aa0 <malloc+0xb0>
    if(p == freep)
 a82:	6098                	ld	a4,0(s1)
 a84:	853e                	mv	a0,a5
 a86:	fef71ae3          	bne	a4,a5,a7a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	aadff0ef          	jal	538 <sbrk>
  if(p == (char*)-1)
 a90:	fd551ee3          	bne	a0,s5,a6c <malloc+0x7c>
        return 0;
 a94:	4501                	li	a0,0
 a96:	74a2                	ld	s1,40(sp)
 a98:	6a42                	ld	s4,16(sp)
 a9a:	6aa2                	ld	s5,8(sp)
 a9c:	6b02                	ld	s6,0(sp)
 a9e:	a03d                	j	acc <malloc+0xdc>
 aa0:	74a2                	ld	s1,40(sp)
 aa2:	6a42                	ld	s4,16(sp)
 aa4:	6aa2                	ld	s5,8(sp)
 aa6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa8:	fae90fe3          	beq	s2,a4,a66 <malloc+0x76>
        p->s.size -= nunits;
 aac:	4137073b          	subw	a4,a4,s3
 ab0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab2:	02071693          	slli	a3,a4,0x20
 ab6:	01c6d713          	srli	a4,a3,0x1c
 aba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 abc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac0:	00001717          	auipc	a4,0x1
 ac4:	54a73023          	sd	a0,1344(a4) # 2000 <freep>
      return (void*)(p + 1);
 ac8:	01078513          	addi	a0,a5,16
  }
}
 acc:	70e2                	ld	ra,56(sp)
 ace:	7442                	ld	s0,48(sp)
 ad0:	7902                	ld	s2,32(sp)
 ad2:	69e2                	ld	s3,24(sp)
 ad4:	6121                	addi	sp,sp,64
 ad6:	8082                	ret
 ad8:	74a2                	ld	s1,40(sp)
 ada:	6a42                	ld	s4,16(sp)
 adc:	6aa2                	ld	s5,8(sp)
 ade:	6b02                	ld	s6,0(sp)
 ae0:	b7f5                	j	acc <malloc+0xdc>
