
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2ae000ef          	jal	2ba <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	286000ef          	jal	2ba <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	60e2                	ld	ra,24(sp)
  42:	6442                	ld	s0,16(sp)
  44:	64a2                	ld	s1,8(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
  4a:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  4c:	8526                	mv	a0,s1
  4e:	26c000ef          	jal	2ba <strlen>
  52:	862a                	mv	a2,a0
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	fba50513          	addi	a0,a0,-70 # 1010 <buf.0>
  5e:	3d4000ef          	jal	432 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  62:	8526                	mv	a0,s1
  64:	256000ef          	jal	2ba <strlen>
  68:	892a                	mv	s2,a0
  6a:	8526                	mv	a0,s1
  6c:	24e000ef          	jal	2ba <strlen>
  70:	02091793          	slli	a5,s2,0x20
  74:	9381                	srli	a5,a5,0x20
  76:	4639                	li	a2,14
  78:	9e09                	subw	a2,a2,a0
  7a:	02000593          	li	a1,32
  7e:	00001517          	auipc	a0,0x1
  82:	f9250513          	addi	a0,a0,-110 # 1010 <buf.0>
  86:	953e                	add	a0,a0,a5
  88:	25e000ef          	jal	2e6 <memset>
  return buf;
  8c:	00001497          	auipc	s1,0x1
  90:	f8448493          	addi	s1,s1,-124 # 1010 <buf.0>
  94:	6902                	ld	s2,0(sp)
  96:	b765                	j	3e <fmtname+0x3e>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	da010113          	addi	sp,sp,-608
  9c:	24113c23          	sd	ra,600(sp)
  a0:	24813823          	sd	s0,592(sp)
  a4:	25213023          	sd	s2,576(sp)
  a8:	1480                	addi	s0,sp,608
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	49e000ef          	jal	54c <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	da840593          	addi	a1,s0,-600
  c0:	454000ef          	jal	514 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	db041783          	lh	a5,-592(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	db842703          	lw	a4,-584(s0)
  e8:	dac42683          	lw	a3,-596(s0)
  ec:	db041603          	lh	a2,-592(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a2050513          	addi	a0,a0,-1504 # b10 <malloc+0x124>
  f8:	03d000ef          	jal	934 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	47e000ef          	jal	57c <close>
 102:	24813483          	ld	s1,584(sp)
}
 106:	25813083          	ld	ra,600(sp)
 10a:	25013403          	ld	s0,592(sp)
 10e:	24013903          	ld	s2,576(sp)
 112:	26010113          	addi	sp,sp,608
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	9c658593          	addi	a1,a1,-1594 # ae0 <malloc+0xf4>
 122:	4509                	li	a0,2
 124:	7e6000ef          	jal	90a <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9cc58593          	addi	a1,a1,-1588 # af8 <malloc+0x10c>
 134:	4509                	li	a0,2
 136:	7d4000ef          	jal	90a <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	440000ef          	jal	57c <close>
    return;
 140:	24813483          	ld	s1,584(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	172000ef          	jal	2ba <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	9ca50513          	addi	a0,a0,-1590 # b20 <malloc+0x134>
 15e:	7d6000ef          	jal	934 <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 168:	85ca                	mv	a1,s2
 16a:	dd040513          	addi	a0,s0,-560
 16e:	0fc000ef          	jal	26a <strcpy>
    p = buf+strlen(buf);
 172:	dd040513          	addi	a0,s0,-560
 176:	144000ef          	jal	2ba <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	dd040793          	addi	a5,s0,-560
 182:	00a78733          	add	a4,a5,a0
 186:	893a                	mv	s2,a4
    *p++ = '/';
 188:	00170793          	addi	a5,a4,1
 18c:	89be                	mv	s3,a5
 18e:	02f00793          	li	a5,47
 192:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 196:	a809                	j	1a8 <ls+0x110>
        printf("ls: cannot stat %s\n", buf);
 198:	dd040593          	addi	a1,s0,-560
 19c:	00001517          	auipc	a0,0x1
 1a0:	95c50513          	addi	a0,a0,-1700 # af8 <malloc+0x10c>
 1a4:	790000ef          	jal	934 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	34c000ef          	jal	4fc <read>
 1b4:	47c1                	li	a5,16
 1b6:	04f51763          	bne	a0,a5,204 <ls+0x16c>
      if(de.inum == 0)
 1ba:	dc045783          	lhu	a5,-576(s0)
 1be:	d7ed                	beqz	a5,1a8 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	dc240593          	addi	a1,s0,-574
 1c6:	854e                	mv	a0,s3
 1c8:	26a000ef          	jal	432 <memmove>
      p[DIRSIZ] = 0;
 1cc:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1d0:	da840593          	addi	a1,s0,-600
 1d4:	dd040513          	addi	a0,s0,-560
 1d8:	1d2000ef          	jal	3aa <stat>
 1dc:	fa054ee3          	bltz	a0,198 <ls+0x100>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1e0:	dd040513          	addi	a0,s0,-560
 1e4:	e1dff0ef          	jal	0 <fmtname>
 1e8:	85aa                	mv	a1,a0
 1ea:	db842703          	lw	a4,-584(s0)
 1ee:	dac42683          	lw	a3,-596(s0)
 1f2:	db041603          	lh	a2,-592(s0)
 1f6:	00001517          	auipc	a0,0x1
 1fa:	91a50513          	addi	a0,a0,-1766 # b10 <malloc+0x124>
 1fe:	736000ef          	jal	934 <printf>
 202:	b75d                	j	1a8 <ls+0x110>
 204:	23813983          	ld	s3,568(sp)
 208:	bdd5                	j	fc <ls+0x64>

000000000000020a <main>:

int
main(int argc, char *argv[])
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 212:	4785                	li	a5,1
 214:	02a7d763          	bge	a5,a0,242 <main+0x38>
 218:	e426                	sd	s1,8(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	00858493          	addi	s1,a1,8
 220:	ffe5091b          	addiw	s2,a0,-2
 224:	02091793          	slli	a5,s2,0x20
 228:	01d7d913          	srli	s2,a5,0x1d
 22c:	05c1                	addi	a1,a1,16
 22e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 230:	6088                	ld	a0,0(s1)
 232:	e67ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 236:	04a1                	addi	s1,s1,8
 238:	ff249ce3          	bne	s1,s2,230 <main+0x26>
  exit(0);
 23c:	4501                	li	a0,0
 23e:	2a6000ef          	jal	4e4 <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	8f250513          	addi	a0,a0,-1806 # b38 <malloc+0x14c>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	290000ef          	jal	4e4 <exit>

0000000000000258 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 260:	fabff0ef          	jal	20a <main>
  exit(0);
 264:	4501                	li	a0,0
 266:	27e000ef          	jal	4e4 <exit>

000000000000026a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0xa>
    ;
  return os;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	cb91                	beqz	a5,2aa <strcmp+0x20>
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00f71763          	bne	a4,a5,2aa <strcmp+0x20>
    p++, q++;
 2a0:	0505                	addi	a0,a0,1
 2a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbe5                	bnez	a5,298 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2aa:	0005c503          	lbu	a0,0(a1)
}
 2ae:	40a7853b          	subw	a0,a5,a0
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strlen>:

uint
strlen(const char *s)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cf91                	beqz	a5,2e2 <strlen+0x28>
 2c8:	00150793          	addi	a5,a0,1
 2cc:	86be                	mv	a3,a5
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff7c703          	lbu	a4,-1(a5)
 2d4:	ff65                	bnez	a4,2cc <strlen+0x12>
 2d6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  for(n = 0; s[n]; n++)
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <strlen+0x20>

00000000000002e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ca19                	beqz	a2,304 <memset+0x1e>
 2f0:	87aa                	mv	a5,a0
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fe:	0785                	addi	a5,a5,1
 300:	fee79de3          	bne	a5,a4,2fa <memset+0x14>
  }
  return dst;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strchr>:

char*
strchr(const char *s, char c)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cf81                	beqz	a5,330 <strchr+0x24>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1c>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xe>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfdd                	j	328 <strchr+0x1c>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	e862                	sd	s8,16(sp)
 34a:	1080                	addi	s0,sp,96
 34c:	8baa                	mv	s7,a0
 34e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	892a                	mv	s2,a0
 352:	4481                	li	s1,0
    cc = read(0, &c, 1);
 354:	faf40b13          	addi	s6,s0,-81
 358:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 35a:	8c26                	mv	s8,s1
 35c:	0014899b          	addiw	s3,s1,1
 360:	84ce                	mv	s1,s3
 362:	0349d463          	bge	s3,s4,38a <gets+0x56>
    cc = read(0, &c, 1);
 366:	8656                	mv	a2,s5
 368:	85da                	mv	a1,s6
 36a:	4501                	li	a0,0
 36c:	190000ef          	jal	4fc <read>
    if(cc < 1)
 370:	00a05d63          	blez	a0,38a <gets+0x56>
      break;
    buf[i++] = c;
 374:	faf44783          	lbu	a5,-81(s0)
 378:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37c:	0905                	addi	s2,s2,1
 37e:	ff678713          	addi	a4,a5,-10
 382:	c319                	beqz	a4,388 <gets+0x54>
 384:	17cd                	addi	a5,a5,-13
 386:	fbf1                	bnez	a5,35a <gets+0x26>
    buf[i++] = c;
 388:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38a:	9c5e                	add	s8,s8,s7
 38c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 390:	855e                	mv	a0,s7
 392:	60e6                	ld	ra,88(sp)
 394:	6446                	ld	s0,80(sp)
 396:	64a6                	ld	s1,72(sp)
 398:	6906                	ld	s2,64(sp)
 39a:	79e2                	ld	s3,56(sp)
 39c:	7a42                	ld	s4,48(sp)
 39e:	7aa2                	ld	s5,40(sp)
 3a0:	7b02                	ld	s6,32(sp)
 3a2:	6be2                	ld	s7,24(sp)
 3a4:	6c42                	ld	s8,16(sp)
 3a6:	6125                	addi	sp,sp,96
 3a8:	8082                	ret

00000000000003aa <stat>:

int
stat(const char *n, struct stat *st)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	4581                	li	a1,0
 3b8:	194000ef          	jal	54c <open>
  if(fd < 0)
 3bc:	02054263          	bltz	a0,3e0 <stat+0x36>
 3c0:	e426                	sd	s1,8(sp)
 3c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c4:	85ca                	mv	a1,s2
 3c6:	14e000ef          	jal	514 <fstat>
 3ca:	892a                	mv	s2,a0
  close(fd);
 3cc:	8526                	mv	a0,s1
 3ce:	1ae000ef          	jal	57c <close>
  return r;
 3d2:	64a2                	ld	s1,8(sp)
}
 3d4:	854a                	mv	a0,s2
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6902                	ld	s2,0(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret
    return -1;
 3e0:	57fd                	li	a5,-1
 3e2:	893e                	mv	s2,a5
 3e4:	bfc5                	j	3d4 <stat+0x2a>

00000000000003e6 <atoi>:

int
atoi(const char *s)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e406                	sd	ra,8(sp)
 3ea:	e022                	sd	s0,0(sp)
 3ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ee:	00054683          	lbu	a3,0(a0)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	4625                	li	a2,9
 3fc:	02f66963          	bltu	a2,a5,42e <atoi+0x48>
 400:	872a                	mv	a4,a0
  n = 0;
 402:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 404:	0705                	addi	a4,a4,1
 406:	0025179b          	slliw	a5,a0,0x2
 40a:	9fa9                	addw	a5,a5,a0
 40c:	0017979b          	slliw	a5,a5,0x1
 410:	9fb5                	addw	a5,a5,a3
 412:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 416:	00074683          	lbu	a3,0(a4)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	fef671e3          	bgeu	a2,a5,404 <atoi+0x1e>
  return n;
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  n = 0;
 42e:	4501                	li	a0,0
 430:	bfdd                	j	426 <atoi+0x40>

0000000000000432 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43a:	02b57563          	bgeu	a0,a1,464 <memmove+0x32>
    while(n-- > 0)
 43e:	00c05f63          	blez	a2,45c <memmove+0x2a>
 442:	1602                	slli	a2,a2,0x20
 444:	9201                	srli	a2,a2,0x20
 446:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44a:	872a                	mv	a4,a0
      *dst++ = *src++;
 44c:	0585                	addi	a1,a1,1
 44e:	0705                	addi	a4,a4,1
 450:	fff5c683          	lbu	a3,-1(a1)
 454:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 458:	fee79ae3          	bne	a5,a4,44c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45c:	60a2                	ld	ra,8(sp)
 45e:	6402                	ld	s0,0(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
    while(n-- > 0)
 464:	fec05ce3          	blez	a2,45c <memmove+0x2a>
    dst += n;
 468:	00c50733          	add	a4,a0,a2
    src += n;
 46c:	95b2                	add	a1,a1,a2
 46e:	fff6079b          	addiw	a5,a2,-1
 472:	1782                	slli	a5,a5,0x20
 474:	9381                	srli	a5,a5,0x20
 476:	fff7c793          	not	a5,a5
 47a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47c:	15fd                	addi	a1,a1,-1
 47e:	177d                	addi	a4,a4,-1
 480:	0005c683          	lbu	a3,0(a1)
 484:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 488:	fef71ae3          	bne	a4,a5,47c <memmove+0x4a>
 48c:	bfc1                	j	45c <memmove+0x2a>

000000000000048e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 496:	c61d                	beqz	a2,4c4 <memcmp+0x36>
 498:	1602                	slli	a2,a2,0x20
 49a:	9201                	srli	a2,a2,0x20
 49c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a0:	00054783          	lbu	a5,0(a0)
 4a4:	0005c703          	lbu	a4,0(a1)
 4a8:	00e79863          	bne	a5,a4,4b8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ac:	0505                	addi	a0,a0,1
    p2++;
 4ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b0:	fed518e3          	bne	a0,a3,4a0 <memcmp+0x12>
  }
  return 0;
 4b4:	4501                	li	a0,0
 4b6:	a019                	j	4bc <memcmp+0x2e>
      return *p1 - *p2;
 4b8:	40e7853b          	subw	a0,a5,a4
}
 4bc:	60a2                	ld	ra,8(sp)
 4be:	6402                	ld	s0,0(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
  return 0;
 4c4:	4501                	li	a0,0
 4c6:	bfdd                	j	4bc <memcmp+0x2e>

00000000000004c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e406                	sd	ra,8(sp)
 4cc:	e022                	sd	s0,0(sp)
 4ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d0:	f63ff0ef          	jal	432 <memmove>
}
 4d4:	60a2                	ld	ra,8(sp)
 4d6:	6402                	ld	s0,0(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4dc:	4885                	li	a7,1
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e4:	4889                	li	a7,2
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ec:	488d                	li	a7,3
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f4:	4891                	li	a7,4
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <read>:
.global read
read:
 li a7, SYS_read
 4fc:	4895                	li	a7,5
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <kill>:
.global kill
kill:
 li a7, SYS_kill
 504:	4899                	li	a7,6
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <exec>:
.global exec
exec:
 li a7, SYS_exec
 50c:	489d                	li	a7,7
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 514:	48a1                	li	a7,8
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51c:	48a5                	li	a7,9
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <dup>:
.global dup
dup:
 li a7, SYS_dup
 524:	48a9                	li	a7,10
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52c:	48ad                	li	a7,11
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 534:	48b1                	li	a7,12
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53c:	48b5                	li	a7,13
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 544:	48b9                	li	a7,14
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <open>:
.global open
open:
 li a7, SYS_open
 54c:	48bd                	li	a7,15
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <write>:
.global write
write:
 li a7, SYS_write
 554:	48c1                	li	a7,16
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55c:	48c5                	li	a7,17
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 564:	48c9                	li	a7,18
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <link>:
.global link
link:
 li a7, SYS_link
 56c:	48cd                	li	a7,19
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 574:	48d1                	li	a7,20
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <close>:
.global close
close:
 li a7, SYS_close
 57c:	48d5                	li	a7,21
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 584:	48d9                	li	a7,22
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 58c:	48dd                	li	a7,23
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 594:	48e1                	li	a7,24
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 59c:	48e5                	li	a7,25
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a4:	1101                	addi	sp,sp,-32
 5a6:	ec06                	sd	ra,24(sp)
 5a8:	e822                	sd	s0,16(sp)
 5aa:	1000                	addi	s0,sp,32
 5ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b0:	4605                	li	a2,1
 5b2:	fef40593          	addi	a1,s0,-17
 5b6:	f9fff0ef          	jal	554 <write>
}
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret

00000000000005c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c2:	7139                	addi	sp,sp,-64
 5c4:	fc06                	sd	ra,56(sp)
 5c6:	f822                	sd	s0,48(sp)
 5c8:	f04a                	sd	s2,32(sp)
 5ca:	ec4e                	sd	s3,24(sp)
 5cc:	0080                	addi	s0,sp,64
 5ce:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d0:	cac9                	beqz	a3,662 <printint+0xa0>
 5d2:	01f5d79b          	srliw	a5,a1,0x1f
 5d6:	c7d1                	beqz	a5,662 <printint+0xa0>
    neg = 1;
    x = -xx;
 5d8:	40b005bb          	negw	a1,a1
    neg = 1;
 5dc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5de:	fc040993          	addi	s3,s0,-64
  neg = 0;
 5e2:	86ce                	mv	a3,s3
  i = 0;
 5e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e6:	00000817          	auipc	a6,0x0
 5ea:	56280813          	addi	a6,a6,1378 # b48 <digits>
 5ee:	88ba                	mv	a7,a4
 5f0:	0017051b          	addiw	a0,a4,1
 5f4:	872a                	mv	a4,a0
 5f6:	02c5f7bb          	remuw	a5,a1,a2
 5fa:	1782                	slli	a5,a5,0x20
 5fc:	9381                	srli	a5,a5,0x20
 5fe:	97c2                	add	a5,a5,a6
 600:	0007c783          	lbu	a5,0(a5)
 604:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 608:	87ae                	mv	a5,a1
 60a:	02c5d5bb          	divuw	a1,a1,a2
 60e:	0685                	addi	a3,a3,1
 610:	fcc7ffe3          	bgeu	a5,a2,5ee <printint+0x2c>
  if(neg)
 614:	00030c63          	beqz	t1,62c <printint+0x6a>
    buf[i++] = '-';
 618:	fd050793          	addi	a5,a0,-48
 61c:	00878533          	add	a0,a5,s0
 620:	02d00793          	li	a5,45
 624:	fef50823          	sb	a5,-16(a0)
 628:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 62c:	02e05563          	blez	a4,656 <printint+0x94>
 630:	f426                	sd	s1,40(sp)
 632:	377d                	addiw	a4,a4,-1
 634:	00e984b3          	add	s1,s3,a4
 638:	19fd                	addi	s3,s3,-1
 63a:	99ba                	add	s3,s3,a4
 63c:	1702                	slli	a4,a4,0x20
 63e:	9301                	srli	a4,a4,0x20
 640:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 644:	0004c583          	lbu	a1,0(s1)
 648:	854a                	mv	a0,s2
 64a:	f5bff0ef          	jal	5a4 <putc>
  while(--i >= 0)
 64e:	14fd                	addi	s1,s1,-1
 650:	ff349ae3          	bne	s1,s3,644 <printint+0x82>
 654:	74a2                	ld	s1,40(sp)
}
 656:	70e2                	ld	ra,56(sp)
 658:	7442                	ld	s0,48(sp)
 65a:	7902                	ld	s2,32(sp)
 65c:	69e2                	ld	s3,24(sp)
 65e:	6121                	addi	sp,sp,64
 660:	8082                	ret
  neg = 0;
 662:	4301                	li	t1,0
 664:	bfad                	j	5de <printint+0x1c>

0000000000000666 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 666:	711d                	addi	sp,sp,-96
 668:	ec86                	sd	ra,88(sp)
 66a:	e8a2                	sd	s0,80(sp)
 66c:	e4a6                	sd	s1,72(sp)
 66e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 670:	0005c483          	lbu	s1,0(a1)
 674:	20048963          	beqz	s1,886 <vprintf+0x220>
 678:	e0ca                	sd	s2,64(sp)
 67a:	fc4e                	sd	s3,56(sp)
 67c:	f852                	sd	s4,48(sp)
 67e:	f456                	sd	s5,40(sp)
 680:	f05a                	sd	s6,32(sp)
 682:	ec5e                	sd	s7,24(sp)
 684:	e862                	sd	s8,16(sp)
 686:	8b2a                	mv	s6,a0
 688:	8a2e                	mv	s4,a1
 68a:	8bb2                	mv	s7,a2
  state = 0;
 68c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 68e:	4901                	li	s2,0
 690:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 692:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 696:	06400c13          	li	s8,100
 69a:	a00d                	j	6bc <vprintf+0x56>
        putc(fd, c0);
 69c:	85a6                	mv	a1,s1
 69e:	855a                	mv	a0,s6
 6a0:	f05ff0ef          	jal	5a4 <putc>
 6a4:	a019                	j	6aa <vprintf+0x44>
    } else if(state == '%'){
 6a6:	03598363          	beq	s3,s5,6cc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6aa:	0019079b          	addiw	a5,s2,1
 6ae:	893e                	mv	s2,a5
 6b0:	873e                	mv	a4,a5
 6b2:	97d2                	add	a5,a5,s4
 6b4:	0007c483          	lbu	s1,0(a5)
 6b8:	1c048063          	beqz	s1,878 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 6bc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6c0:	fe0993e3          	bnez	s3,6a6 <vprintf+0x40>
      if(c0 == '%'){
 6c4:	fd579ce3          	bne	a5,s5,69c <vprintf+0x36>
        state = '%';
 6c8:	89be                	mv	s3,a5
 6ca:	b7c5                	j	6aa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6cc:	00ea06b3          	add	a3,s4,a4
 6d0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6d4:	1a060e63          	beqz	a2,890 <vprintf+0x22a>
      if(c0 == 'd'){
 6d8:	03878763          	beq	a5,s8,706 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6dc:	f9478693          	addi	a3,a5,-108
 6e0:	0016b693          	seqz	a3,a3
 6e4:	f9c60593          	addi	a1,a2,-100
 6e8:	e99d                	bnez	a1,71e <vprintf+0xb8>
 6ea:	ca95                	beqz	a3,71e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4685                	li	a3,1
 6f2:	4629                	li	a2,10
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	ec9ff0ef          	jal	5c2 <printint>
        i += 1;
 6fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 700:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 702:	4981                	li	s3,0
 704:	b75d                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 706:	008b8493          	addi	s1,s7,8
 70a:	4685                	li	a3,1
 70c:	4629                	li	a2,10
 70e:	000ba583          	lw	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	eafff0ef          	jal	5c2 <printint>
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b779                	j	6aa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 71e:	9752                	add	a4,a4,s4
 720:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 724:	f9460713          	addi	a4,a2,-108
 728:	00173713          	seqz	a4,a4
 72c:	8f75                	and	a4,a4,a3
 72e:	f9c58513          	addi	a0,a1,-100
 732:	16051963          	bnez	a0,8a4 <vprintf+0x23e>
 736:	16070763          	beqz	a4,8a4 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73a:	008b8493          	addi	s1,s7,8
 73e:	4685                	li	a3,1
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	e7bff0ef          	jal	5c2 <printint>
        i += 2;
 74c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 74e:	8ba6                	mv	s7,s1
      state = 0;
 750:	4981                	li	s3,0
        i += 2;
 752:	bfa1                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 754:	008b8493          	addi	s1,s7,8
 758:	4681                	li	a3,0
 75a:	4629                	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	e61ff0ef          	jal	5c2 <printint>
 766:	8ba6                	mv	s7,s1
      state = 0;
 768:	4981                	li	s3,0
 76a:	b781                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	008b8493          	addi	s1,s7,8
 770:	4681                	li	a3,0
 772:	4629                	li	a2,10
 774:	000ba583          	lw	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	e49ff0ef          	jal	5c2 <printint>
        i += 1;
 77e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 780:	8ba6                	mv	s7,s1
      state = 0;
 782:	4981                	li	s3,0
 784:	b71d                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 786:	008b8493          	addi	s1,s7,8
 78a:	4681                	li	a3,0
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	e2fff0ef          	jal	5c2 <printint>
        i += 2;
 798:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	8ba6                	mv	s7,s1
      state = 0;
 79c:	4981                	li	s3,0
        i += 2;
 79e:	b731                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7a0:	008b8493          	addi	s1,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4641                	li	a2,16
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	e15ff0ef          	jal	5c2 <printint>
 7b2:	8ba6                	mv	s7,s1
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	bdd5                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	008b8493          	addi	s1,s7,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	dfdff0ef          	jal	5c2 <printint>
        i += 1;
 7ca:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7cc:	8ba6                	mv	s7,s1
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bde9                	j	6aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d2:	008b8493          	addi	s1,s7,8
 7d6:	4681                	li	a3,0
 7d8:	4641                	li	a2,16
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	de3ff0ef          	jal	5c2 <printint>
        i += 2;
 7e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	8ba6                	mv	s7,s1
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	b5c1                	j	6aa <vprintf+0x44>
 7ec:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7ee:	008b8793          	addi	a5,s7,8
 7f2:	8cbe                	mv	s9,a5
 7f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f8:	03000593          	li	a1,48
 7fc:	855a                	mv	a0,s6
 7fe:	da7ff0ef          	jal	5a4 <putc>
  putc(fd, 'x');
 802:	07800593          	li	a1,120
 806:	855a                	mv	a0,s6
 808:	d9dff0ef          	jal	5a4 <putc>
 80c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80e:	00000b97          	auipc	s7,0x0
 812:	33ab8b93          	addi	s7,s7,826 # b48 <digits>
 816:	03c9d793          	srli	a5,s3,0x3c
 81a:	97de                	add	a5,a5,s7
 81c:	0007c583          	lbu	a1,0(a5)
 820:	855a                	mv	a0,s6
 822:	d83ff0ef          	jal	5a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 826:	0992                	slli	s3,s3,0x4
 828:	34fd                	addiw	s1,s1,-1
 82a:	f4f5                	bnez	s1,816 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 82c:	8be6                	mv	s7,s9
      state = 0;
 82e:	4981                	li	s3,0
 830:	6ca2                	ld	s9,8(sp)
 832:	bda5                	j	6aa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 834:	008b8993          	addi	s3,s7,8
 838:	000bb483          	ld	s1,0(s7)
 83c:	cc91                	beqz	s1,858 <vprintf+0x1f2>
        for(; *s; s++)
 83e:	0004c583          	lbu	a1,0(s1)
 842:	c985                	beqz	a1,872 <vprintf+0x20c>
          putc(fd, *s);
 844:	855a                	mv	a0,s6
 846:	d5fff0ef          	jal	5a4 <putc>
        for(; *s; s++)
 84a:	0485                	addi	s1,s1,1
 84c:	0004c583          	lbu	a1,0(s1)
 850:	f9f5                	bnez	a1,844 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 852:	8bce                	mv	s7,s3
      state = 0;
 854:	4981                	li	s3,0
 856:	bd91                	j	6aa <vprintf+0x44>
          s = "(null)";
 858:	00000497          	auipc	s1,0x0
 85c:	2e848493          	addi	s1,s1,744 # b40 <malloc+0x154>
        for(; *s; s++)
 860:	02800593          	li	a1,40
 864:	b7c5                	j	844 <vprintf+0x1de>
        putc(fd, '%');
 866:	85be                	mv	a1,a5
 868:	855a                	mv	a0,s6
 86a:	d3bff0ef          	jal	5a4 <putc>
      state = 0;
 86e:	4981                	li	s3,0
 870:	bd2d                	j	6aa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 872:	8bce                	mv	s7,s3
      state = 0;
 874:	4981                	li	s3,0
 876:	bd15                	j	6aa <vprintf+0x44>
 878:	6906                	ld	s2,64(sp)
 87a:	79e2                	ld	s3,56(sp)
 87c:	7a42                	ld	s4,48(sp)
 87e:	7aa2                	ld	s5,40(sp)
 880:	7b02                	ld	s6,32(sp)
 882:	6be2                	ld	s7,24(sp)
 884:	6c42                	ld	s8,16(sp)
    }
  }
}
 886:	60e6                	ld	ra,88(sp)
 888:	6446                	ld	s0,80(sp)
 88a:	64a6                	ld	s1,72(sp)
 88c:	6125                	addi	sp,sp,96
 88e:	8082                	ret
      if(c0 == 'd'){
 890:	06400713          	li	a4,100
 894:	e6e789e3          	beq	a5,a4,706 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 898:	f9478693          	addi	a3,a5,-108
 89c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8a0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8a2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8a4:	07500513          	li	a0,117
 8a8:	eaa786e3          	beq	a5,a0,754 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8ac:	f8b60513          	addi	a0,a2,-117
 8b0:	e119                	bnez	a0,8b6 <vprintf+0x250>
 8b2:	ea069de3          	bnez	a3,76c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8b6:	f8b58513          	addi	a0,a1,-117
 8ba:	e119                	bnez	a0,8c0 <vprintf+0x25a>
 8bc:	ec0715e3          	bnez	a4,786 <vprintf+0x120>
      } else if(c0 == 'x'){
 8c0:	07800513          	li	a0,120
 8c4:	eca78ee3          	beq	a5,a0,7a0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8c8:	f8860613          	addi	a2,a2,-120
 8cc:	e219                	bnez	a2,8d2 <vprintf+0x26c>
 8ce:	ee0695e3          	bnez	a3,7b8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8d2:	f8858593          	addi	a1,a1,-120
 8d6:	e199                	bnez	a1,8dc <vprintf+0x276>
 8d8:	ee071de3          	bnez	a4,7d2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 8dc:	07000713          	li	a4,112
 8e0:	f0e786e3          	beq	a5,a4,7ec <vprintf+0x186>
      } else if(c0 == 's'){
 8e4:	07300713          	li	a4,115
 8e8:	f4e786e3          	beq	a5,a4,834 <vprintf+0x1ce>
      } else if(c0 == '%'){
 8ec:	02500713          	li	a4,37
 8f0:	f6e78be3          	beq	a5,a4,866 <vprintf+0x200>
        putc(fd, '%');
 8f4:	02500593          	li	a1,37
 8f8:	855a                	mv	a0,s6
 8fa:	cabff0ef          	jal	5a4 <putc>
        putc(fd, c0);
 8fe:	85a6                	mv	a1,s1
 900:	855a                	mv	a0,s6
 902:	ca3ff0ef          	jal	5a4 <putc>
      state = 0;
 906:	4981                	li	s3,0
 908:	b34d                	j	6aa <vprintf+0x44>

000000000000090a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90a:	715d                	addi	sp,sp,-80
 90c:	ec06                	sd	ra,24(sp)
 90e:	e822                	sd	s0,16(sp)
 910:	1000                	addi	s0,sp,32
 912:	e010                	sd	a2,0(s0)
 914:	e414                	sd	a3,8(s0)
 916:	e818                	sd	a4,16(s0)
 918:	ec1c                	sd	a5,24(s0)
 91a:	03043023          	sd	a6,32(s0)
 91e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 922:	8622                	mv	a2,s0
 924:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 928:	d3fff0ef          	jal	666 <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6161                	addi	sp,sp,80
 932:	8082                	ret

0000000000000934 <printf>:

void
printf(const char *fmt, ...)
{
 934:	711d                	addi	sp,sp,-96
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	1000                	addi	s0,sp,32
 93c:	e40c                	sd	a1,8(s0)
 93e:	e810                	sd	a2,16(s0)
 940:	ec14                	sd	a3,24(s0)
 942:	f018                	sd	a4,32(s0)
 944:	f41c                	sd	a5,40(s0)
 946:	03043823          	sd	a6,48(s0)
 94a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	00840613          	addi	a2,s0,8
 952:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 956:	85aa                	mv	a1,a0
 958:	4505                	li	a0,1
 95a:	d0dff0ef          	jal	666 <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6125                	addi	sp,sp,96
 964:	8082                	ret

0000000000000966 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 966:	1141                	addi	sp,sp,-16
 968:	e406                	sd	ra,8(sp)
 96a:	e022                	sd	s0,0(sp)
 96c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 96e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	00000797          	auipc	a5,0x0
 976:	68e7b783          	ld	a5,1678(a5) # 1000 <freep>
 97a:	a039                	j	988 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x20>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x30>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x16>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059813          	slli	a6,a1,0x20
 9a0:	01c85713          	srli	a4,a6,0x1c
 9a4:	9736                	add	a4,a4,a3
 9a6:	02e60563          	beq	a2,a4,9d0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061593          	slli	a1,a2,0x20
 9b4:	01c5d713          	srli	a4,a1,0x1c
 9b8:	973e                	add	a4,a4,a5
 9ba:	02e68263          	beq	a3,a4,9de <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73023          	sd	a5,1600(a4) # 1000 <freep>
}
 9c8:	60a2                	ld	ra,8(sp)
 9ca:	6402                	ld	s0,0(sp)
 9cc:	0141                	addi	sp,sp,16
 9ce:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9d0:	4618                	lw	a4,8(a2)
 9d2:	9f2d                	addw	a4,a4,a1
 9d4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d8:	6398                	ld	a4,0(a5)
 9da:	6310                	ld	a2,0(a4)
 9dc:	b7f9                	j	9aa <free+0x44>
    p->s.size += bp->s.size;
 9de:	ff852703          	lw	a4,-8(a0)
 9e2:	9f31                	addw	a4,a4,a2
 9e4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9e6:	ff053683          	ld	a3,-16(a0)
 9ea:	bfd1                	j	9be <free+0x58>

00000000000009ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ec:	7139                	addi	sp,sp,-64
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	f04a                	sd	s2,32(sp)
 9f4:	ec4e                	sd	s3,24(sp)
 9f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f8:	02051993          	slli	s3,a0,0x20
 9fc:	0209d993          	srli	s3,s3,0x20
 a00:	09bd                	addi	s3,s3,15
 a02:	0049d993          	srli	s3,s3,0x4
 a06:	2985                	addiw	s3,s3,1
 a08:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0a:	00000517          	auipc	a0,0x0
 a0e:	5f653503          	ld	a0,1526(a0) # 1000 <freep>
 a12:	c905                	beqz	a0,a42 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	09377663          	bgeu	a4,s3,aa4 <malloc+0xb8>
 a1c:	f426                	sd	s1,40(sp)
 a1e:	e852                	sd	s4,16(sp)
 a20:	e456                	sd	s5,8(sp)
 a22:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a24:	8a4e                	mv	s4,s3
 a26:	6705                	lui	a4,0x1
 a28:	00e9f363          	bgeu	s3,a4,a2e <malloc+0x42>
 a2c:	6a05                	lui	s4,0x1
 a2e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a32:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a36:	00000497          	auipc	s1,0x0
 a3a:	5ca48493          	addi	s1,s1,1482 # 1000 <freep>
  if(p == (char*)-1)
 a3e:	5afd                	li	s5,-1
 a40:	a83d                	j	a7e <malloc+0x92>
 a42:	f426                	sd	s1,40(sp)
 a44:	e852                	sd	s4,16(sp)
 a46:	e456                	sd	s5,8(sp)
 a48:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4a:	00000797          	auipc	a5,0x0
 a4e:	5d678793          	addi	a5,a5,1494 # 1020 <base>
 a52:	00000717          	auipc	a4,0x0
 a56:	5af73723          	sd	a5,1454(a4) # 1000 <freep>
 a5a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a60:	b7d1                	j	a24 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a62:	6398                	ld	a4,0(a5)
 a64:	e118                	sd	a4,0(a0)
 a66:	a899                	j	abc <malloc+0xd0>
  hp->s.size = nu;
 a68:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6c:	0541                	addi	a0,a0,16
 a6e:	ef9ff0ef          	jal	966 <free>
  return freep;
 a72:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a74:	c125                	beqz	a0,ad4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a78:	4798                	lw	a4,8(a5)
 a7a:	03277163          	bgeu	a4,s2,a9c <malloc+0xb0>
    if(p == freep)
 a7e:	6098                	ld	a4,0(s1)
 a80:	853e                	mv	a0,a5
 a82:	fef71ae3          	bne	a4,a5,a76 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a86:	8552                	mv	a0,s4
 a88:	aadff0ef          	jal	534 <sbrk>
  if(p == (char*)-1)
 a8c:	fd551ee3          	bne	a0,s5,a68 <malloc+0x7c>
        return 0;
 a90:	4501                	li	a0,0
 a92:	74a2                	ld	s1,40(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
 a9a:	a03d                	j	ac8 <malloc+0xdc>
 a9c:	74a2                	ld	s1,40(sp)
 a9e:	6a42                	ld	s4,16(sp)
 aa0:	6aa2                	ld	s5,8(sp)
 aa2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa4:	fae90fe3          	beq	s2,a4,a62 <malloc+0x76>
        p->s.size -= nunits;
 aa8:	4137073b          	subw	a4,a4,s3
 aac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aae:	02071693          	slli	a3,a4,0x20
 ab2:	01c6d713          	srli	a4,a3,0x1c
 ab6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abc:	00000717          	auipc	a4,0x0
 ac0:	54a73223          	sd	a0,1348(a4) # 1000 <freep>
      return (void*)(p + 1);
 ac4:	01078513          	addi	a0,a5,16
  }
}
 ac8:	70e2                	ld	ra,56(sp)
 aca:	7442                	ld	s0,48(sp)
 acc:	7902                	ld	s2,32(sp)
 ace:	69e2                	ld	s3,24(sp)
 ad0:	6121                	addi	sp,sp,64
 ad2:	8082                	ret
 ad4:	74a2                	ld	s1,40(sp)
 ad6:	6a42                	ld	s4,16(sp)
 ad8:	6aa2                	ld	s5,8(sp)
 ada:	6b02                	ld	s6,0(sp)
 adc:	b7f5                	j	ac8 <malloc+0xdc>
