
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtmode>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtmode(int mode, int type)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  static char buf[11];

  // For device files, the mode field contains the minor device number
  if (type == T_DEVICE)
   8:	478d                	li	a5,3
   a:	0ef58963          	beq	a1,a5,fc <fmtmode+0xfc>
    strcpy(buf + 1, "rw-rw-rw-");
    buf[10] = 0;
    return buf;
  }

  buf[0] = (type == T_DIR) ? 'd' : '-';
   e:	4705                	li	a4,1
  10:	02d00793          	li	a5,45
  14:	14e58b63          	beq	a1,a4,16a <fmtmode+0x16a>
  18:	00002717          	auipc	a4,0x2
  1c:	fef70c23          	sb	a5,-8(a4) # 2010 <buf.1>
  buf[1] = (mode & S_IRUSR) ? 'r' : '-';
  20:	10057793          	andi	a5,a0,256
  24:	02d00713          	li	a4,45
  28:	c399                	beqz	a5,2e <fmtmode+0x2e>
  2a:	07200713          	li	a4,114
  2e:	00002797          	auipc	a5,0x2
  32:	fee781a3          	sb	a4,-29(a5) # 2011 <buf.1+0x1>
  buf[2] = (mode & S_IWUSR) ? 'w' : '-';
  36:	08057793          	andi	a5,a0,128
  3a:	02d00713          	li	a4,45
  3e:	c399                	beqz	a5,44 <fmtmode+0x44>
  40:	07700713          	li	a4,119
  44:	00002797          	auipc	a5,0x2
  48:	fce78723          	sb	a4,-50(a5) # 2012 <buf.1+0x2>
  buf[3] = (mode & S_IXUSR) ? 'x' : '-';
  4c:	04057793          	andi	a5,a0,64
  50:	02d00713          	li	a4,45
  54:	c399                	beqz	a5,5a <fmtmode+0x5a>
  56:	07800713          	li	a4,120
  5a:	00002797          	auipc	a5,0x2
  5e:	fae78ca3          	sb	a4,-71(a5) # 2013 <buf.1+0x3>
  buf[4] = (mode & S_IRGRP) ? 'r' : '-';
  62:	02057793          	andi	a5,a0,32
  66:	02d00713          	li	a4,45
  6a:	c399                	beqz	a5,70 <fmtmode+0x70>
  6c:	07200713          	li	a4,114
  70:	00002797          	auipc	a5,0x2
  74:	fae78223          	sb	a4,-92(a5) # 2014 <buf.1+0x4>
  buf[5] = (mode & S_IWGRP) ? 'w' : '-';
  78:	01057793          	andi	a5,a0,16
  7c:	02d00713          	li	a4,45
  80:	c399                	beqz	a5,86 <fmtmode+0x86>
  82:	07700713          	li	a4,119
  86:	00002797          	auipc	a5,0x2
  8a:	f8e787a3          	sb	a4,-113(a5) # 2015 <buf.1+0x5>
  buf[6] = (mode & S_IXGRP) ? 'x' : '-';
  8e:	00857793          	andi	a5,a0,8
  92:	02d00713          	li	a4,45
  96:	c399                	beqz	a5,9c <fmtmode+0x9c>
  98:	07800713          	li	a4,120
  9c:	00002797          	auipc	a5,0x2
  a0:	f6e78d23          	sb	a4,-134(a5) # 2016 <buf.1+0x6>
  buf[7] = (mode & S_IROTH) ? 'r' : '-';
  a4:	00457793          	andi	a5,a0,4
  a8:	02d00713          	li	a4,45
  ac:	c399                	beqz	a5,b2 <fmtmode+0xb2>
  ae:	07200713          	li	a4,114
  b2:	00002797          	auipc	a5,0x2
  b6:	f6e782a3          	sb	a4,-155(a5) # 2017 <buf.1+0x7>
  buf[8] = (mode & S_IWOTH) ? 'w' : '-';
  ba:	00257793          	andi	a5,a0,2
  be:	02d00713          	li	a4,45
  c2:	c399                	beqz	a5,c8 <fmtmode+0xc8>
  c4:	07700713          	li	a4,119
  c8:	00002797          	auipc	a5,0x2
  cc:	f4e78823          	sb	a4,-176(a5) # 2018 <buf.1+0x8>
  buf[9] = (mode & S_IXOTH) ? 'x' : '-';
  d0:	8905                	andi	a0,a0,1
  d2:	02d00713          	li	a4,45
  d6:	c119                	beqz	a0,dc <fmtmode+0xdc>
  d8:	07800713          	li	a4,120
  dc:	00002797          	auipc	a5,0x2
  e0:	f3478793          	addi	a5,a5,-204 # 2010 <buf.1>
  e4:	00e784a3          	sb	a4,9(a5)
  buf[10] = 0;
  e8:	00078523          	sb	zero,10(a5)

  return buf;
}
  ec:	00002517          	auipc	a0,0x2
  f0:	f2450513          	addi	a0,a0,-220 # 2010 <buf.1>
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
    buf[0] = 'c'; // character device
  fc:	06300793          	li	a5,99
 100:	00002717          	auipc	a4,0x2
 104:	f0f70823          	sb	a5,-240(a4) # 2010 <buf.1>
    strcpy(buf + 1, "rw-rw-rw-");
 108:	00002797          	auipc	a5,0x2
 10c:	f0978793          	addi	a5,a5,-247 # 2011 <buf.1+0x1>
 110:	00001717          	auipc	a4,0x1
 114:	b7070713          	addi	a4,a4,-1168 # c80 <malloc+0xfa>
 118:	00074e83          	lbu	t4,0(a4)
 11c:	00174e03          	lbu	t3,1(a4)
 120:	00274303          	lbu	t1,2(a4)
 124:	00374883          	lbu	a7,3(a4)
 128:	00474803          	lbu	a6,4(a4)
 12c:	00574503          	lbu	a0,5(a4)
 130:	00674583          	lbu	a1,6(a4)
 134:	00774603          	lbu	a2,7(a4)
 138:	00874683          	lbu	a3,8(a4)
 13c:	01d78023          	sb	t4,0(a5)
 140:	01c780a3          	sb	t3,1(a5)
 144:	00678123          	sb	t1,2(a5)
 148:	011781a3          	sb	a7,3(a5)
 14c:	01078223          	sb	a6,4(a5)
 150:	00a782a3          	sb	a0,5(a5)
 154:	00b78323          	sb	a1,6(a5)
 158:	00c783a3          	sb	a2,7(a5)
 15c:	00d78423          	sb	a3,8(a5)
 160:	00974703          	lbu	a4,9(a4)
 164:	00e784a3          	sb	a4,9(a5)
    return buf;
 168:	b751                	j	ec <fmtmode+0xec>
  buf[0] = (type == T_DIR) ? 'd' : '-';
 16a:	06400793          	li	a5,100
 16e:	b56d                	j	18 <fmtmode+0x18>

0000000000000170 <fmtname>:

char *
fmtname(char *path)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e426                	sd	s1,8(sp)
 178:	1000                	addi	s0,sp,32
 17a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
 17c:	2e0000ef          	jal	45c <strlen>
 180:	02051793          	slli	a5,a0,0x20
 184:	9381                	srli	a5,a5,0x20
 186:	97a6                	add	a5,a5,s1
 188:	02f00693          	li	a3,47
 18c:	0097e963          	bltu	a5,s1,19e <fmtname+0x2e>
 190:	0007c703          	lbu	a4,0(a5)
 194:	00d70563          	beq	a4,a3,19e <fmtname+0x2e>
 198:	17fd                	addi	a5,a5,-1
 19a:	fe97fbe3          	bgeu	a5,s1,190 <fmtname+0x20>
    ;
  p++;
 19e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
 1a2:	8526                	mv	a0,s1
 1a4:	2b8000ef          	jal	45c <strlen>
 1a8:	47b5                	li	a5,13
 1aa:	00a7f863          	bgeu	a5,a0,1ba <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  return buf;
}
 1ae:	8526                	mv	a0,s1
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
 1ba:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
 1bc:	8526                	mv	a0,s1
 1be:	29e000ef          	jal	45c <strlen>
 1c2:	862a                	mv	a2,a0
 1c4:	85a6                	mv	a1,s1
 1c6:	00002517          	auipc	a0,0x2
 1ca:	e5a50513          	addi	a0,a0,-422 # 2020 <buf.0>
 1ce:	406000ef          	jal	5d4 <memmove>
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
 1d2:	8526                	mv	a0,s1
 1d4:	288000ef          	jal	45c <strlen>
 1d8:	892a                	mv	s2,a0
 1da:	8526                	mv	a0,s1
 1dc:	280000ef          	jal	45c <strlen>
 1e0:	02091793          	slli	a5,s2,0x20
 1e4:	9381                	srli	a5,a5,0x20
 1e6:	4639                	li	a2,14
 1e8:	9e09                	subw	a2,a2,a0
 1ea:	02000593          	li	a1,32
 1ee:	00002517          	auipc	a0,0x2
 1f2:	e3250513          	addi	a0,a0,-462 # 2020 <buf.0>
 1f6:	953e                	add	a0,a0,a5
 1f8:	290000ef          	jal	488 <memset>
  return buf;
 1fc:	00002497          	auipc	s1,0x2
 200:	e2448493          	addi	s1,s1,-476 # 2020 <buf.0>
 204:	6902                	ld	s2,0(sp)
 206:	b765                	j	1ae <fmtname+0x3e>

0000000000000208 <ls>:

void ls(char *path)
{
 208:	da010113          	addi	sp,sp,-608
 20c:	24113c23          	sd	ra,600(sp)
 210:	24813823          	sd	s0,592(sp)
 214:	23313c23          	sd	s3,568(sp)
 218:	1480                	addi	s0,sp,608
 21a:	89aa                	mv	s3,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0)
 21c:	4581                	li	a1,0
 21e:	4d0000ef          	jal	6ee <open>
 222:	06054f63          	bltz	a0,2a0 <ls+0x98>
 226:	24913423          	sd	s1,584(sp)
 22a:	84aa                	mv	s1,a0
  {
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0)
 22c:	da040593          	addi	a1,s0,-608
 230:	486000ef          	jal	6b6 <fstat>
 234:	06054f63          	bltz	a0,2b2 <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type)
 238:	da841583          	lh	a1,-600(s0)
 23c:	4785                	li	a5,1
 23e:	08f58863          	beq	a1,a5,2ce <ls+0xc6>
 242:	ffe5879b          	addiw	a5,a1,-2
 246:	17c2                	slli	a5,a5,0x30
 248:	93c1                	srli	a5,a5,0x30
 24a:	4705                	li	a4,1
 24c:	02f76c63          	bltu	a4,a5,284 <ls+0x7c>
 250:	25213023          	sd	s2,576(sp)
  {
  case T_DEVICE:
  case T_FILE:
    printf("%s %s %d %d %d\n", fmtmode(st.mode, st.type), fmtname(path), st.type, st.ino, (int)st.size);
 254:	db841503          	lh	a0,-584(s0)
 258:	da9ff0ef          	jal	0 <fmtmode>
 25c:	892a                	mv	s2,a0
 25e:	854e                	mv	a0,s3
 260:	f11ff0ef          	jal	170 <fmtname>
 264:	862a                	mv	a2,a0
 266:	db042783          	lw	a5,-592(s0)
 26a:	da442703          	lw	a4,-604(s0)
 26e:	da841683          	lh	a3,-600(s0)
 272:	85ca                	mv	a1,s2
 274:	00001517          	auipc	a0,0x1
 278:	a4c50513          	addi	a0,a0,-1460 # cc0 <malloc+0x13a>
 27c:	053000ef          	jal	ace <printf>
    break;
 280:	24013903          	ld	s2,576(sp)
      }
      printf("%s %s %d %d %d\n", fmtmode(st.mode, st.type), fmtname(buf), st.type, st.ino, (int)st.size);
    }
    break;
  }
  close(fd);
 284:	8526                	mv	a0,s1
 286:	498000ef          	jal	71e <close>
 28a:	24813483          	ld	s1,584(sp)
}
 28e:	25813083          	ld	ra,600(sp)
 292:	25013403          	ld	s0,592(sp)
 296:	23813983          	ld	s3,568(sp)
 29a:	26010113          	addi	sp,sp,608
 29e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 2a0:	864e                	mv	a2,s3
 2a2:	00001597          	auipc	a1,0x1
 2a6:	9ee58593          	addi	a1,a1,-1554 # c90 <malloc+0x10a>
 2aa:	4509                	li	a0,2
 2ac:	7f8000ef          	jal	aa4 <fprintf>
    return;
 2b0:	bff9                	j	28e <ls+0x86>
    fprintf(2, "ls: cannot stat %s\n", path);
 2b2:	864e                	mv	a2,s3
 2b4:	00001597          	auipc	a1,0x1
 2b8:	9f458593          	addi	a1,a1,-1548 # ca8 <malloc+0x122>
 2bc:	4509                	li	a0,2
 2be:	7e6000ef          	jal	aa4 <fprintf>
    close(fd);
 2c2:	8526                	mv	a0,s1
 2c4:	45a000ef          	jal	71e <close>
    return;
 2c8:	24813483          	ld	s1,584(sp)
 2cc:	b7c9                	j	28e <ls+0x86>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 2ce:	854e                	mv	a0,s3
 2d0:	18c000ef          	jal	45c <strlen>
 2d4:	2541                	addiw	a0,a0,16
 2d6:	20000793          	li	a5,512
 2da:	00a7f963          	bgeu	a5,a0,2ec <ls+0xe4>
      printf("ls: path too long\n");
 2de:	00001517          	auipc	a0,0x1
 2e2:	9f250513          	addi	a0,a0,-1550 # cd0 <malloc+0x14a>
 2e6:	7e8000ef          	jal	ace <printf>
      break;
 2ea:	bf69                	j	284 <ls+0x7c>
 2ec:	25213023          	sd	s2,576(sp)
 2f0:	23413823          	sd	s4,560(sp)
    strcpy(buf, path);
 2f4:	85ce                	mv	a1,s3
 2f6:	dd040513          	addi	a0,s0,-560
 2fa:	112000ef          	jal	40c <strcpy>
    p = buf + strlen(buf);
 2fe:	dd040513          	addi	a0,s0,-560
 302:	15a000ef          	jal	45c <strlen>
 306:	1502                	slli	a0,a0,0x20
 308:	9101                	srli	a0,a0,0x20
 30a:	dd040793          	addi	a5,s0,-560
 30e:	00a78733          	add	a4,a5,a0
 312:	89ba                	mv	s3,a4
    *p++ = '/';
 314:	00170793          	addi	a5,a4,1
 318:	8a3e                	mv	s4,a5
 31a:	02f00793          	li	a5,47
 31e:	00f70023          	sb	a5,0(a4)
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 322:	a809                	j	334 <ls+0x12c>
        printf("ls: cannot stat %s\n", buf);
 324:	dd040593          	addi	a1,s0,-560
 328:	00001517          	auipc	a0,0x1
 32c:	98050513          	addi	a0,a0,-1664 # ca8 <malloc+0x122>
 330:	79e000ef          	jal	ace <printf>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 334:	4641                	li	a2,16
 336:	dc040593          	addi	a1,s0,-576
 33a:	8526                	mv	a0,s1
 33c:	362000ef          	jal	69e <read>
 340:	47c1                	li	a5,16
 342:	06f51063          	bne	a0,a5,3a2 <ls+0x19a>
      if (de.inum == 0)
 346:	dc045783          	lhu	a5,-576(s0)
 34a:	d7ed                	beqz	a5,334 <ls+0x12c>
      memmove(p, de.name, DIRSIZ);
 34c:	4639                	li	a2,14
 34e:	dc240593          	addi	a1,s0,-574
 352:	8552                	mv	a0,s4
 354:	280000ef          	jal	5d4 <memmove>
      p[DIRSIZ] = 0;
 358:	000987a3          	sb	zero,15(s3)
      if (stat(buf, &st) < 0)
 35c:	da040593          	addi	a1,s0,-608
 360:	dd040513          	addi	a0,s0,-560
 364:	1e8000ef          	jal	54c <stat>
 368:	fa054ee3          	bltz	a0,324 <ls+0x11c>
      printf("%s %s %d %d %d\n", fmtmode(st.mode, st.type), fmtname(buf), st.type, st.ino, (int)st.size);
 36c:	da841583          	lh	a1,-600(s0)
 370:	db841503          	lh	a0,-584(s0)
 374:	c8dff0ef          	jal	0 <fmtmode>
 378:	892a                	mv	s2,a0
 37a:	dd040793          	addi	a5,s0,-560
 37e:	853e                	mv	a0,a5
 380:	df1ff0ef          	jal	170 <fmtname>
 384:	862a                	mv	a2,a0
 386:	db042783          	lw	a5,-592(s0)
 38a:	da442703          	lw	a4,-604(s0)
 38e:	da841683          	lh	a3,-600(s0)
 392:	85ca                	mv	a1,s2
 394:	00001517          	auipc	a0,0x1
 398:	92c50513          	addi	a0,a0,-1748 # cc0 <malloc+0x13a>
 39c:	732000ef          	jal	ace <printf>
 3a0:	bf51                	j	334 <ls+0x12c>
 3a2:	24013903          	ld	s2,576(sp)
 3a6:	23013a03          	ld	s4,560(sp)
 3aa:	bde9                	j	284 <ls+0x7c>

00000000000003ac <main>:

int main(int argc, char *argv[])
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2)
 3b4:	4785                	li	a5,1
 3b6:	02a7d763          	bge	a5,a0,3e4 <main+0x38>
 3ba:	e426                	sd	s1,8(sp)
 3bc:	e04a                	sd	s2,0(sp)
 3be:	00858493          	addi	s1,a1,8
 3c2:	ffe5091b          	addiw	s2,a0,-2
 3c6:	02091793          	slli	a5,s2,0x20
 3ca:	01d7d913          	srli	s2,a5,0x1d
 3ce:	05c1                	addi	a1,a1,16
 3d0:	992e                	add	s2,s2,a1
  {
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
 3d2:	6088                	ld	a0,0(s1)
 3d4:	e35ff0ef          	jal	208 <ls>
  for (i = 1; i < argc; i++)
 3d8:	04a1                	addi	s1,s1,8
 3da:	ff249ce3          	bne	s1,s2,3d2 <main+0x26>
  exit(0);
 3de:	4501                	li	a0,0
 3e0:	2a6000ef          	jal	686 <exit>
 3e4:	e426                	sd	s1,8(sp)
 3e6:	e04a                	sd	s2,0(sp)
    ls(".");
 3e8:	00001517          	auipc	a0,0x1
 3ec:	90050513          	addi	a0,a0,-1792 # ce8 <malloc+0x162>
 3f0:	e19ff0ef          	jal	208 <ls>
    exit(0);
 3f4:	4501                	li	a0,0
 3f6:	290000ef          	jal	686 <exit>

00000000000003fa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e406                	sd	ra,8(sp)
 3fe:	e022                	sd	s0,0(sp)
 400:	0800                	addi	s0,sp,16
  extern int main();
  main();
 402:	fabff0ef          	jal	3ac <main>
  exit(0);
 406:	4501                	li	a0,0
 408:	27e000ef          	jal	686 <exit>

000000000000040c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e406                	sd	ra,8(sp)
 410:	e022                	sd	s0,0(sp)
 412:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 414:	87aa                	mv	a5,a0
 416:	0585                	addi	a1,a1,1
 418:	0785                	addi	a5,a5,1
 41a:	fff5c703          	lbu	a4,-1(a1)
 41e:	fee78fa3          	sb	a4,-1(a5)
 422:	fb75                	bnez	a4,416 <strcpy+0xa>
    ;
  return os;
}
 424:	60a2                	ld	ra,8(sp)
 426:	6402                	ld	s0,0(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 434:	00054783          	lbu	a5,0(a0)
 438:	cb91                	beqz	a5,44c <strcmp+0x20>
 43a:	0005c703          	lbu	a4,0(a1)
 43e:	00f71763          	bne	a4,a5,44c <strcmp+0x20>
    p++, q++;
 442:	0505                	addi	a0,a0,1
 444:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 446:	00054783          	lbu	a5,0(a0)
 44a:	fbe5                	bnez	a5,43a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 44c:	0005c503          	lbu	a0,0(a1)
}
 450:	40a7853b          	subw	a0,a5,a0
 454:	60a2                	ld	ra,8(sp)
 456:	6402                	ld	s0,0(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret

000000000000045c <strlen>:

uint
strlen(const char *s)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e406                	sd	ra,8(sp)
 460:	e022                	sd	s0,0(sp)
 462:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 464:	00054783          	lbu	a5,0(a0)
 468:	cf91                	beqz	a5,484 <strlen+0x28>
 46a:	00150793          	addi	a5,a0,1
 46e:	86be                	mv	a3,a5
 470:	0785                	addi	a5,a5,1
 472:	fff7c703          	lbu	a4,-1(a5)
 476:	ff65                	bnez	a4,46e <strlen+0x12>
 478:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 47c:	60a2                	ld	ra,8(sp)
 47e:	6402                	ld	s0,0(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  for(n = 0; s[n]; n++)
 484:	4501                	li	a0,0
 486:	bfdd                	j	47c <strlen+0x20>

0000000000000488 <memset>:

void*
memset(void *dst, int c, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 490:	ca19                	beqz	a2,4a6 <memset+0x1e>
 492:	87aa                	mv	a5,a0
 494:	1602                	slli	a2,a2,0x20
 496:	9201                	srli	a2,a2,0x20
 498:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 49c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4a0:	0785                	addi	a5,a5,1
 4a2:	fee79de3          	bne	a5,a4,49c <memset+0x14>
  }
  return dst;
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret

00000000000004ae <strchr>:

char*
strchr(const char *s, char c)
{
 4ae:	1141                	addi	sp,sp,-16
 4b0:	e406                	sd	ra,8(sp)
 4b2:	e022                	sd	s0,0(sp)
 4b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4b6:	00054783          	lbu	a5,0(a0)
 4ba:	cf81                	beqz	a5,4d2 <strchr+0x24>
    if(*s == c)
 4bc:	00f58763          	beq	a1,a5,4ca <strchr+0x1c>
  for(; *s; s++)
 4c0:	0505                	addi	a0,a0,1
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	fbfd                	bnez	a5,4bc <strchr+0xe>
      return (char*)s;
  return 0;
 4c8:	4501                	li	a0,0
}
 4ca:	60a2                	ld	ra,8(sp)
 4cc:	6402                	ld	s0,0(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret
  return 0;
 4d2:	4501                	li	a0,0
 4d4:	bfdd                	j	4ca <strchr+0x1c>

00000000000004d6 <gets>:

char*
gets(char *buf, int max)
{
 4d6:	711d                	addi	sp,sp,-96
 4d8:	ec86                	sd	ra,88(sp)
 4da:	e8a2                	sd	s0,80(sp)
 4dc:	e4a6                	sd	s1,72(sp)
 4de:	e0ca                	sd	s2,64(sp)
 4e0:	fc4e                	sd	s3,56(sp)
 4e2:	f852                	sd	s4,48(sp)
 4e4:	f456                	sd	s5,40(sp)
 4e6:	f05a                	sd	s6,32(sp)
 4e8:	ec5e                	sd	s7,24(sp)
 4ea:	e862                	sd	s8,16(sp)
 4ec:	1080                	addi	s0,sp,96
 4ee:	8baa                	mv	s7,a0
 4f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4f2:	892a                	mv	s2,a0
 4f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 4f6:	faf40b13          	addi	s6,s0,-81
 4fa:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 4fc:	8c26                	mv	s8,s1
 4fe:	0014899b          	addiw	s3,s1,1
 502:	84ce                	mv	s1,s3
 504:	0349d463          	bge	s3,s4,52c <gets+0x56>
    cc = read(0, &c, 1);
 508:	8656                	mv	a2,s5
 50a:	85da                	mv	a1,s6
 50c:	4501                	li	a0,0
 50e:	190000ef          	jal	69e <read>
    if(cc < 1)
 512:	00a05d63          	blez	a0,52c <gets+0x56>
      break;
    buf[i++] = c;
 516:	faf44783          	lbu	a5,-81(s0)
 51a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 51e:	0905                	addi	s2,s2,1
 520:	ff678713          	addi	a4,a5,-10
 524:	c319                	beqz	a4,52a <gets+0x54>
 526:	17cd                	addi	a5,a5,-13
 528:	fbf1                	bnez	a5,4fc <gets+0x26>
    buf[i++] = c;
 52a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 52c:	9c5e                	add	s8,s8,s7
 52e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 532:	855e                	mv	a0,s7
 534:	60e6                	ld	ra,88(sp)
 536:	6446                	ld	s0,80(sp)
 538:	64a6                	ld	s1,72(sp)
 53a:	6906                	ld	s2,64(sp)
 53c:	79e2                	ld	s3,56(sp)
 53e:	7a42                	ld	s4,48(sp)
 540:	7aa2                	ld	s5,40(sp)
 542:	7b02                	ld	s6,32(sp)
 544:	6be2                	ld	s7,24(sp)
 546:	6c42                	ld	s8,16(sp)
 548:	6125                	addi	sp,sp,96
 54a:	8082                	ret

000000000000054c <stat>:

int
stat(const char *n, struct stat *st)
{
 54c:	1101                	addi	sp,sp,-32
 54e:	ec06                	sd	ra,24(sp)
 550:	e822                	sd	s0,16(sp)
 552:	e04a                	sd	s2,0(sp)
 554:	1000                	addi	s0,sp,32
 556:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 558:	4581                	li	a1,0
 55a:	194000ef          	jal	6ee <open>
  if(fd < 0)
 55e:	02054263          	bltz	a0,582 <stat+0x36>
 562:	e426                	sd	s1,8(sp)
 564:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 566:	85ca                	mv	a1,s2
 568:	14e000ef          	jal	6b6 <fstat>
 56c:	892a                	mv	s2,a0
  close(fd);
 56e:	8526                	mv	a0,s1
 570:	1ae000ef          	jal	71e <close>
  return r;
 574:	64a2                	ld	s1,8(sp)
}
 576:	854a                	mv	a0,s2
 578:	60e2                	ld	ra,24(sp)
 57a:	6442                	ld	s0,16(sp)
 57c:	6902                	ld	s2,0(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret
    return -1;
 582:	57fd                	li	a5,-1
 584:	893e                	mv	s2,a5
 586:	bfc5                	j	576 <stat+0x2a>

0000000000000588 <atoi>:

int
atoi(const char *s)
{
 588:	1141                	addi	sp,sp,-16
 58a:	e406                	sd	ra,8(sp)
 58c:	e022                	sd	s0,0(sp)
 58e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 590:	00054683          	lbu	a3,0(a0)
 594:	fd06879b          	addiw	a5,a3,-48
 598:	0ff7f793          	zext.b	a5,a5
 59c:	4625                	li	a2,9
 59e:	02f66963          	bltu	a2,a5,5d0 <atoi+0x48>
 5a2:	872a                	mv	a4,a0
  n = 0;
 5a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5a6:	0705                	addi	a4,a4,1
 5a8:	0025179b          	slliw	a5,a0,0x2
 5ac:	9fa9                	addw	a5,a5,a0
 5ae:	0017979b          	slliw	a5,a5,0x1
 5b2:	9fb5                	addw	a5,a5,a3
 5b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5b8:	00074683          	lbu	a3,0(a4)
 5bc:	fd06879b          	addiw	a5,a3,-48
 5c0:	0ff7f793          	zext.b	a5,a5
 5c4:	fef671e3          	bgeu	a2,a5,5a6 <atoi+0x1e>
  return n;
}
 5c8:	60a2                	ld	ra,8(sp)
 5ca:	6402                	ld	s0,0(sp)
 5cc:	0141                	addi	sp,sp,16
 5ce:	8082                	ret
  n = 0;
 5d0:	4501                	li	a0,0
 5d2:	bfdd                	j	5c8 <atoi+0x40>

00000000000005d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5d4:	1141                	addi	sp,sp,-16
 5d6:	e406                	sd	ra,8(sp)
 5d8:	e022                	sd	s0,0(sp)
 5da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5dc:	02b57563          	bgeu	a0,a1,606 <memmove+0x32>
    while(n-- > 0)
 5e0:	00c05f63          	blez	a2,5fe <memmove+0x2a>
 5e4:	1602                	slli	a2,a2,0x20
 5e6:	9201                	srli	a2,a2,0x20
 5e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 5ee:	0585                	addi	a1,a1,1
 5f0:	0705                	addi	a4,a4,1
 5f2:	fff5c683          	lbu	a3,-1(a1)
 5f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5fa:	fee79ae3          	bne	a5,a4,5ee <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5fe:	60a2                	ld	ra,8(sp)
 600:	6402                	ld	s0,0(sp)
 602:	0141                	addi	sp,sp,16
 604:	8082                	ret
    while(n-- > 0)
 606:	fec05ce3          	blez	a2,5fe <memmove+0x2a>
    dst += n;
 60a:	00c50733          	add	a4,a0,a2
    src += n;
 60e:	95b2                	add	a1,a1,a2
 610:	fff6079b          	addiw	a5,a2,-1
 614:	1782                	slli	a5,a5,0x20
 616:	9381                	srli	a5,a5,0x20
 618:	fff7c793          	not	a5,a5
 61c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 61e:	15fd                	addi	a1,a1,-1
 620:	177d                	addi	a4,a4,-1
 622:	0005c683          	lbu	a3,0(a1)
 626:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 62a:	fef71ae3          	bne	a4,a5,61e <memmove+0x4a>
 62e:	bfc1                	j	5fe <memmove+0x2a>

0000000000000630 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 630:	1141                	addi	sp,sp,-16
 632:	e406                	sd	ra,8(sp)
 634:	e022                	sd	s0,0(sp)
 636:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 638:	c61d                	beqz	a2,666 <memcmp+0x36>
 63a:	1602                	slli	a2,a2,0x20
 63c:	9201                	srli	a2,a2,0x20
 63e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 642:	00054783          	lbu	a5,0(a0)
 646:	0005c703          	lbu	a4,0(a1)
 64a:	00e79863          	bne	a5,a4,65a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 64e:	0505                	addi	a0,a0,1
    p2++;
 650:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 652:	fed518e3          	bne	a0,a3,642 <memcmp+0x12>
  }
  return 0;
 656:	4501                	li	a0,0
 658:	a019                	j	65e <memcmp+0x2e>
      return *p1 - *p2;
 65a:	40e7853b          	subw	a0,a5,a4
}
 65e:	60a2                	ld	ra,8(sp)
 660:	6402                	ld	s0,0(sp)
 662:	0141                	addi	sp,sp,16
 664:	8082                	ret
  return 0;
 666:	4501                	li	a0,0
 668:	bfdd                	j	65e <memcmp+0x2e>

000000000000066a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 66a:	1141                	addi	sp,sp,-16
 66c:	e406                	sd	ra,8(sp)
 66e:	e022                	sd	s0,0(sp)
 670:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 672:	f63ff0ef          	jal	5d4 <memmove>
}
 676:	60a2                	ld	ra,8(sp)
 678:	6402                	ld	s0,0(sp)
 67a:	0141                	addi	sp,sp,16
 67c:	8082                	ret

000000000000067e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 67e:	4885                	li	a7,1
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <exit>:
.global exit
exit:
 li a7, SYS_exit
 686:	4889                	li	a7,2
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <wait>:
.global wait
wait:
 li a7, SYS_wait
 68e:	488d                	li	a7,3
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 696:	4891                	li	a7,4
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <read>:
.global read
read:
 li a7, SYS_read
 69e:	4895                	li	a7,5
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6a6:	4899                	li	a7,6
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 6ae:	489d                	li	a7,7
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b6:	48a1                	li	a7,8
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6be:	48a5                	li	a7,9
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c6:	48a9                	li	a7,10
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ce:	48ad                	li	a7,11
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d6:	48b1                	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6de:	48b5                	li	a7,13
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e6:	48b9                	li	a7,14
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <open>:
.global open
open:
 li a7, SYS_open
 6ee:	48bd                	li	a7,15
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <write>:
.global write
write:
 li a7, SYS_write
 6f6:	48c1                	li	a7,16
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6fe:	48c5                	li	a7,17
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 706:	48c9                	li	a7,18
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <link>:
.global link
link:
 li a7, SYS_link
 70e:	48cd                	li	a7,19
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 716:	48d1                	li	a7,20
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <close>:
.global close
close:
 li a7, SYS_close
 71e:	48d5                	li	a7,21
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 726:	48d9                	li	a7,22
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 72e:	48dd                	li	a7,23
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 736:	48e1                	li	a7,24
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 73e:	1101                	addi	sp,sp,-32
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 74a:	4605                	li	a2,1
 74c:	fef40593          	addi	a1,s0,-17
 750:	fa7ff0ef          	jal	6f6 <write>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6105                	addi	sp,sp,32
 75a:	8082                	ret

000000000000075c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f04a                	sd	s2,32(sp)
 764:	ec4e                	sd	s3,24(sp)
 766:	0080                	addi	s0,sp,64
 768:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 76a:	cac9                	beqz	a3,7fc <printint+0xa0>
 76c:	01f5d79b          	srliw	a5,a1,0x1f
 770:	c7d1                	beqz	a5,7fc <printint+0xa0>
    neg = 1;
    x = -xx;
 772:	40b005bb          	negw	a1,a1
    neg = 1;
 776:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 778:	fc040993          	addi	s3,s0,-64
  neg = 0;
 77c:	86ce                	mv	a3,s3
  i = 0;
 77e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 780:	00000817          	auipc	a6,0x0
 784:	57880813          	addi	a6,a6,1400 # cf8 <digits>
 788:	88ba                	mv	a7,a4
 78a:	0017051b          	addiw	a0,a4,1
 78e:	872a                	mv	a4,a0
 790:	02c5f7bb          	remuw	a5,a1,a2
 794:	1782                	slli	a5,a5,0x20
 796:	9381                	srli	a5,a5,0x20
 798:	97c2                	add	a5,a5,a6
 79a:	0007c783          	lbu	a5,0(a5)
 79e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7a2:	87ae                	mv	a5,a1
 7a4:	02c5d5bb          	divuw	a1,a1,a2
 7a8:	0685                	addi	a3,a3,1
 7aa:	fcc7ffe3          	bgeu	a5,a2,788 <printint+0x2c>
  if(neg)
 7ae:	00030c63          	beqz	t1,7c6 <printint+0x6a>
    buf[i++] = '-';
 7b2:	fd050793          	addi	a5,a0,-48
 7b6:	00878533          	add	a0,a5,s0
 7ba:	02d00793          	li	a5,45
 7be:	fef50823          	sb	a5,-16(a0)
 7c2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 7c6:	02e05563          	blez	a4,7f0 <printint+0x94>
 7ca:	f426                	sd	s1,40(sp)
 7cc:	377d                	addiw	a4,a4,-1
 7ce:	00e984b3          	add	s1,s3,a4
 7d2:	19fd                	addi	s3,s3,-1
 7d4:	99ba                	add	s3,s3,a4
 7d6:	1702                	slli	a4,a4,0x20
 7d8:	9301                	srli	a4,a4,0x20
 7da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7de:	0004c583          	lbu	a1,0(s1)
 7e2:	854a                	mv	a0,s2
 7e4:	f5bff0ef          	jal	73e <putc>
  while(--i >= 0)
 7e8:	14fd                	addi	s1,s1,-1
 7ea:	ff349ae3          	bne	s1,s3,7de <printint+0x82>
 7ee:	74a2                	ld	s1,40(sp)
}
 7f0:	70e2                	ld	ra,56(sp)
 7f2:	7442                	ld	s0,48(sp)
 7f4:	7902                	ld	s2,32(sp)
 7f6:	69e2                	ld	s3,24(sp)
 7f8:	6121                	addi	sp,sp,64
 7fa:	8082                	ret
  neg = 0;
 7fc:	4301                	li	t1,0
 7fe:	bfad                	j	778 <printint+0x1c>

0000000000000800 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 800:	711d                	addi	sp,sp,-96
 802:	ec86                	sd	ra,88(sp)
 804:	e8a2                	sd	s0,80(sp)
 806:	e4a6                	sd	s1,72(sp)
 808:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 80a:	0005c483          	lbu	s1,0(a1)
 80e:	20048963          	beqz	s1,a20 <vprintf+0x220>
 812:	e0ca                	sd	s2,64(sp)
 814:	fc4e                	sd	s3,56(sp)
 816:	f852                	sd	s4,48(sp)
 818:	f456                	sd	s5,40(sp)
 81a:	f05a                	sd	s6,32(sp)
 81c:	ec5e                	sd	s7,24(sp)
 81e:	e862                	sd	s8,16(sp)
 820:	8b2a                	mv	s6,a0
 822:	8a2e                	mv	s4,a1
 824:	8bb2                	mv	s7,a2
  state = 0;
 826:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 828:	4901                	li	s2,0
 82a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 82c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 830:	06400c13          	li	s8,100
 834:	a00d                	j	856 <vprintf+0x56>
        putc(fd, c0);
 836:	85a6                	mv	a1,s1
 838:	855a                	mv	a0,s6
 83a:	f05ff0ef          	jal	73e <putc>
 83e:	a019                	j	844 <vprintf+0x44>
    } else if(state == '%'){
 840:	03598363          	beq	s3,s5,866 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 844:	0019079b          	addiw	a5,s2,1
 848:	893e                	mv	s2,a5
 84a:	873e                	mv	a4,a5
 84c:	97d2                	add	a5,a5,s4
 84e:	0007c483          	lbu	s1,0(a5)
 852:	1c048063          	beqz	s1,a12 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 856:	0004879b          	sext.w	a5,s1
    if(state == 0){
 85a:	fe0993e3          	bnez	s3,840 <vprintf+0x40>
      if(c0 == '%'){
 85e:	fd579ce3          	bne	a5,s5,836 <vprintf+0x36>
        state = '%';
 862:	89be                	mv	s3,a5
 864:	b7c5                	j	844 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 866:	00ea06b3          	add	a3,s4,a4
 86a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 86e:	1a060e63          	beqz	a2,a2a <vprintf+0x22a>
      if(c0 == 'd'){
 872:	03878763          	beq	a5,s8,8a0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 876:	f9478693          	addi	a3,a5,-108
 87a:	0016b693          	seqz	a3,a3
 87e:	f9c60593          	addi	a1,a2,-100
 882:	e99d                	bnez	a1,8b8 <vprintf+0xb8>
 884:	ca95                	beqz	a3,8b8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 886:	008b8493          	addi	s1,s7,8
 88a:	4685                	li	a3,1
 88c:	4629                	li	a2,10
 88e:	000ba583          	lw	a1,0(s7)
 892:	855a                	mv	a0,s6
 894:	ec9ff0ef          	jal	75c <printint>
        i += 1;
 898:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 89a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b75d                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 8a0:	008b8493          	addi	s1,s7,8
 8a4:	4685                	li	a3,1
 8a6:	4629                	li	a2,10
 8a8:	000ba583          	lw	a1,0(s7)
 8ac:	855a                	mv	a0,s6
 8ae:	eafff0ef          	jal	75c <printint>
 8b2:	8ba6                	mv	s7,s1
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b779                	j	844 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 8b8:	9752                	add	a4,a4,s4
 8ba:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8be:	f9460713          	addi	a4,a2,-108
 8c2:	00173713          	seqz	a4,a4
 8c6:	8f75                	and	a4,a4,a3
 8c8:	f9c58513          	addi	a0,a1,-100
 8cc:	16051963          	bnez	a0,a3e <vprintf+0x23e>
 8d0:	16070763          	beqz	a4,a3e <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8d4:	008b8493          	addi	s1,s7,8
 8d8:	4685                	li	a3,1
 8da:	4629                	li	a2,10
 8dc:	000ba583          	lw	a1,0(s7)
 8e0:	855a                	mv	a0,s6
 8e2:	e7bff0ef          	jal	75c <printint>
        i += 2;
 8e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e8:	8ba6                	mv	s7,s1
      state = 0;
 8ea:	4981                	li	s3,0
        i += 2;
 8ec:	bfa1                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 8ee:	008b8493          	addi	s1,s7,8
 8f2:	4681                	li	a3,0
 8f4:	4629                	li	a2,10
 8f6:	000ba583          	lw	a1,0(s7)
 8fa:	855a                	mv	a0,s6
 8fc:	e61ff0ef          	jal	75c <printint>
 900:	8ba6                	mv	s7,s1
      state = 0;
 902:	4981                	li	s3,0
 904:	b781                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 906:	008b8493          	addi	s1,s7,8
 90a:	4681                	li	a3,0
 90c:	4629                	li	a2,10
 90e:	000ba583          	lw	a1,0(s7)
 912:	855a                	mv	a0,s6
 914:	e49ff0ef          	jal	75c <printint>
        i += 1;
 918:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 91a:	8ba6                	mv	s7,s1
      state = 0;
 91c:	4981                	li	s3,0
 91e:	b71d                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 920:	008b8493          	addi	s1,s7,8
 924:	4681                	li	a3,0
 926:	4629                	li	a2,10
 928:	000ba583          	lw	a1,0(s7)
 92c:	855a                	mv	a0,s6
 92e:	e2fff0ef          	jal	75c <printint>
        i += 2;
 932:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 934:	8ba6                	mv	s7,s1
      state = 0;
 936:	4981                	li	s3,0
        i += 2;
 938:	b731                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 93a:	008b8493          	addi	s1,s7,8
 93e:	4681                	li	a3,0
 940:	4641                	li	a2,16
 942:	000ba583          	lw	a1,0(s7)
 946:	855a                	mv	a0,s6
 948:	e15ff0ef          	jal	75c <printint>
 94c:	8ba6                	mv	s7,s1
      state = 0;
 94e:	4981                	li	s3,0
 950:	bdd5                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 952:	008b8493          	addi	s1,s7,8
 956:	4681                	li	a3,0
 958:	4641                	li	a2,16
 95a:	000ba583          	lw	a1,0(s7)
 95e:	855a                	mv	a0,s6
 960:	dfdff0ef          	jal	75c <printint>
        i += 1;
 964:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 966:	8ba6                	mv	s7,s1
      state = 0;
 968:	4981                	li	s3,0
 96a:	bde9                	j	844 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 96c:	008b8493          	addi	s1,s7,8
 970:	4681                	li	a3,0
 972:	4641                	li	a2,16
 974:	000ba583          	lw	a1,0(s7)
 978:	855a                	mv	a0,s6
 97a:	de3ff0ef          	jal	75c <printint>
        i += 2;
 97e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 980:	8ba6                	mv	s7,s1
      state = 0;
 982:	4981                	li	s3,0
        i += 2;
 984:	b5c1                	j	844 <vprintf+0x44>
 986:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 988:	008b8793          	addi	a5,s7,8
 98c:	8cbe                	mv	s9,a5
 98e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 992:	03000593          	li	a1,48
 996:	855a                	mv	a0,s6
 998:	da7ff0ef          	jal	73e <putc>
  putc(fd, 'x');
 99c:	07800593          	li	a1,120
 9a0:	855a                	mv	a0,s6
 9a2:	d9dff0ef          	jal	73e <putc>
 9a6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a8:	00000b97          	auipc	s7,0x0
 9ac:	350b8b93          	addi	s7,s7,848 # cf8 <digits>
 9b0:	03c9d793          	srli	a5,s3,0x3c
 9b4:	97de                	add	a5,a5,s7
 9b6:	0007c583          	lbu	a1,0(a5)
 9ba:	855a                	mv	a0,s6
 9bc:	d83ff0ef          	jal	73e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c0:	0992                	slli	s3,s3,0x4
 9c2:	34fd                	addiw	s1,s1,-1
 9c4:	f4f5                	bnez	s1,9b0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 9c6:	8be6                	mv	s7,s9
      state = 0;
 9c8:	4981                	li	s3,0
 9ca:	6ca2                	ld	s9,8(sp)
 9cc:	bda5                	j	844 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 9ce:	008b8993          	addi	s3,s7,8
 9d2:	000bb483          	ld	s1,0(s7)
 9d6:	cc91                	beqz	s1,9f2 <vprintf+0x1f2>
        for(; *s; s++)
 9d8:	0004c583          	lbu	a1,0(s1)
 9dc:	c985                	beqz	a1,a0c <vprintf+0x20c>
          putc(fd, *s);
 9de:	855a                	mv	a0,s6
 9e0:	d5fff0ef          	jal	73e <putc>
        for(; *s; s++)
 9e4:	0485                	addi	s1,s1,1
 9e6:	0004c583          	lbu	a1,0(s1)
 9ea:	f9f5                	bnez	a1,9de <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 9ec:	8bce                	mv	s7,s3
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	bd91                	j	844 <vprintf+0x44>
          s = "(null)";
 9f2:	00000497          	auipc	s1,0x0
 9f6:	2fe48493          	addi	s1,s1,766 # cf0 <malloc+0x16a>
        for(; *s; s++)
 9fa:	02800593          	li	a1,40
 9fe:	b7c5                	j	9de <vprintf+0x1de>
        putc(fd, '%');
 a00:	85be                	mv	a1,a5
 a02:	855a                	mv	a0,s6
 a04:	d3bff0ef          	jal	73e <putc>
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	bd2d                	j	844 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 a0c:	8bce                	mv	s7,s3
      state = 0;
 a0e:	4981                	li	s3,0
 a10:	bd15                	j	844 <vprintf+0x44>
 a12:	6906                	ld	s2,64(sp)
 a14:	79e2                	ld	s3,56(sp)
 a16:	7a42                	ld	s4,48(sp)
 a18:	7aa2                	ld	s5,40(sp)
 a1a:	7b02                	ld	s6,32(sp)
 a1c:	6be2                	ld	s7,24(sp)
 a1e:	6c42                	ld	s8,16(sp)
    }
  }
}
 a20:	60e6                	ld	ra,88(sp)
 a22:	6446                	ld	s0,80(sp)
 a24:	64a6                	ld	s1,72(sp)
 a26:	6125                	addi	sp,sp,96
 a28:	8082                	ret
      if(c0 == 'd'){
 a2a:	06400713          	li	a4,100
 a2e:	e6e789e3          	beq	a5,a4,8a0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 a32:	f9478693          	addi	a3,a5,-108
 a36:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 a3a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a3c:	4701                	li	a4,0
      } else if(c0 == 'u'){
 a3e:	07500513          	li	a0,117
 a42:	eaa786e3          	beq	a5,a0,8ee <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 a46:	f8b60513          	addi	a0,a2,-117
 a4a:	e119                	bnez	a0,a50 <vprintf+0x250>
 a4c:	ea069de3          	bnez	a3,906 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a50:	f8b58513          	addi	a0,a1,-117
 a54:	e119                	bnez	a0,a5a <vprintf+0x25a>
 a56:	ec0715e3          	bnez	a4,920 <vprintf+0x120>
      } else if(c0 == 'x'){
 a5a:	07800513          	li	a0,120
 a5e:	eca78ee3          	beq	a5,a0,93a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 a62:	f8860613          	addi	a2,a2,-120
 a66:	e219                	bnez	a2,a6c <vprintf+0x26c>
 a68:	ee0695e3          	bnez	a3,952 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a6c:	f8858593          	addi	a1,a1,-120
 a70:	e199                	bnez	a1,a76 <vprintf+0x276>
 a72:	ee071de3          	bnez	a4,96c <vprintf+0x16c>
      } else if(c0 == 'p'){
 a76:	07000713          	li	a4,112
 a7a:	f0e786e3          	beq	a5,a4,986 <vprintf+0x186>
      } else if(c0 == 's'){
 a7e:	07300713          	li	a4,115
 a82:	f4e786e3          	beq	a5,a4,9ce <vprintf+0x1ce>
      } else if(c0 == '%'){
 a86:	02500713          	li	a4,37
 a8a:	f6e78be3          	beq	a5,a4,a00 <vprintf+0x200>
        putc(fd, '%');
 a8e:	02500593          	li	a1,37
 a92:	855a                	mv	a0,s6
 a94:	cabff0ef          	jal	73e <putc>
        putc(fd, c0);
 a98:	85a6                	mv	a1,s1
 a9a:	855a                	mv	a0,s6
 a9c:	ca3ff0ef          	jal	73e <putc>
      state = 0;
 aa0:	4981                	li	s3,0
 aa2:	b34d                	j	844 <vprintf+0x44>

0000000000000aa4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 aa4:	715d                	addi	sp,sp,-80
 aa6:	ec06                	sd	ra,24(sp)
 aa8:	e822                	sd	s0,16(sp)
 aaa:	1000                	addi	s0,sp,32
 aac:	e010                	sd	a2,0(s0)
 aae:	e414                	sd	a3,8(s0)
 ab0:	e818                	sd	a4,16(s0)
 ab2:	ec1c                	sd	a5,24(s0)
 ab4:	03043023          	sd	a6,32(s0)
 ab8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 abc:	8622                	mv	a2,s0
 abe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ac2:	d3fff0ef          	jal	800 <vprintf>
}
 ac6:	60e2                	ld	ra,24(sp)
 ac8:	6442                	ld	s0,16(sp)
 aca:	6161                	addi	sp,sp,80
 acc:	8082                	ret

0000000000000ace <printf>:

void
printf(const char *fmt, ...)
{
 ace:	711d                	addi	sp,sp,-96
 ad0:	ec06                	sd	ra,24(sp)
 ad2:	e822                	sd	s0,16(sp)
 ad4:	1000                	addi	s0,sp,32
 ad6:	e40c                	sd	a1,8(s0)
 ad8:	e810                	sd	a2,16(s0)
 ada:	ec14                	sd	a3,24(s0)
 adc:	f018                	sd	a4,32(s0)
 ade:	f41c                	sd	a5,40(s0)
 ae0:	03043823          	sd	a6,48(s0)
 ae4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ae8:	00840613          	addi	a2,s0,8
 aec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 af0:	85aa                	mv	a1,a0
 af2:	4505                	li	a0,1
 af4:	d0dff0ef          	jal	800 <vprintf>
}
 af8:	60e2                	ld	ra,24(sp)
 afa:	6442                	ld	s0,16(sp)
 afc:	6125                	addi	sp,sp,96
 afe:	8082                	ret

0000000000000b00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b00:	1141                	addi	sp,sp,-16
 b02:	e406                	sd	ra,8(sp)
 b04:	e022                	sd	s0,0(sp)
 b06:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b08:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0c:	00001797          	auipc	a5,0x1
 b10:	4f47b783          	ld	a5,1268(a5) # 2000 <freep>
 b14:	a039                	j	b22 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b16:	6398                	ld	a4,0(a5)
 b18:	00e7e463          	bltu	a5,a4,b20 <free+0x20>
 b1c:	00e6ea63          	bltu	a3,a4,b30 <free+0x30>
{
 b20:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b22:	fed7fae3          	bgeu	a5,a3,b16 <free+0x16>
 b26:	6398                	ld	a4,0(a5)
 b28:	00e6e463          	bltu	a3,a4,b30 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b2c:	fee7eae3          	bltu	a5,a4,b20 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b30:	ff852583          	lw	a1,-8(a0)
 b34:	6390                	ld	a2,0(a5)
 b36:	02059813          	slli	a6,a1,0x20
 b3a:	01c85713          	srli	a4,a6,0x1c
 b3e:	9736                	add	a4,a4,a3
 b40:	02e60563          	beq	a2,a4,b6a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b44:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b48:	4790                	lw	a2,8(a5)
 b4a:	02061593          	slli	a1,a2,0x20
 b4e:	01c5d713          	srli	a4,a1,0x1c
 b52:	973e                	add	a4,a4,a5
 b54:	02e68263          	beq	a3,a4,b78 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b58:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b5a:	00001717          	auipc	a4,0x1
 b5e:	4af73323          	sd	a5,1190(a4) # 2000 <freep>
}
 b62:	60a2                	ld	ra,8(sp)
 b64:	6402                	ld	s0,0(sp)
 b66:	0141                	addi	sp,sp,16
 b68:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 b6a:	4618                	lw	a4,8(a2)
 b6c:	9f2d                	addw	a4,a4,a1
 b6e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b72:	6398                	ld	a4,0(a5)
 b74:	6310                	ld	a2,0(a4)
 b76:	b7f9                	j	b44 <free+0x44>
    p->s.size += bp->s.size;
 b78:	ff852703          	lw	a4,-8(a0)
 b7c:	9f31                	addw	a4,a4,a2
 b7e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b80:	ff053683          	ld	a3,-16(a0)
 b84:	bfd1                	j	b58 <free+0x58>

0000000000000b86 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b86:	7139                	addi	sp,sp,-64
 b88:	fc06                	sd	ra,56(sp)
 b8a:	f822                	sd	s0,48(sp)
 b8c:	f04a                	sd	s2,32(sp)
 b8e:	ec4e                	sd	s3,24(sp)
 b90:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b92:	02051993          	slli	s3,a0,0x20
 b96:	0209d993          	srli	s3,s3,0x20
 b9a:	09bd                	addi	s3,s3,15
 b9c:	0049d993          	srli	s3,s3,0x4
 ba0:	2985                	addiw	s3,s3,1
 ba2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ba4:	00001517          	auipc	a0,0x1
 ba8:	45c53503          	ld	a0,1116(a0) # 2000 <freep>
 bac:	c905                	beqz	a0,bdc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb0:	4798                	lw	a4,8(a5)
 bb2:	09377663          	bgeu	a4,s3,c3e <malloc+0xb8>
 bb6:	f426                	sd	s1,40(sp)
 bb8:	e852                	sd	s4,16(sp)
 bba:	e456                	sd	s5,8(sp)
 bbc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bbe:	8a4e                	mv	s4,s3
 bc0:	6705                	lui	a4,0x1
 bc2:	00e9f363          	bgeu	s3,a4,bc8 <malloc+0x42>
 bc6:	6a05                	lui	s4,0x1
 bc8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bcc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd0:	00001497          	auipc	s1,0x1
 bd4:	43048493          	addi	s1,s1,1072 # 2000 <freep>
  if(p == (char*)-1)
 bd8:	5afd                	li	s5,-1
 bda:	a83d                	j	c18 <malloc+0x92>
 bdc:	f426                	sd	s1,40(sp)
 bde:	e852                	sd	s4,16(sp)
 be0:	e456                	sd	s5,8(sp)
 be2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 be4:	00001797          	auipc	a5,0x1
 be8:	44c78793          	addi	a5,a5,1100 # 2030 <base>
 bec:	00001717          	auipc	a4,0x1
 bf0:	40f73a23          	sd	a5,1044(a4) # 2000 <freep>
 bf4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bf6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bfa:	b7d1                	j	bbe <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 bfc:	6398                	ld	a4,0(a5)
 bfe:	e118                	sd	a4,0(a0)
 c00:	a899                	j	c56 <malloc+0xd0>
  hp->s.size = nu;
 c02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c06:	0541                	addi	a0,a0,16
 c08:	ef9ff0ef          	jal	b00 <free>
  return freep;
 c0c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 c0e:	c125                	beqz	a0,c6e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c12:	4798                	lw	a4,8(a5)
 c14:	03277163          	bgeu	a4,s2,c36 <malloc+0xb0>
    if(p == freep)
 c18:	6098                	ld	a4,0(s1)
 c1a:	853e                	mv	a0,a5
 c1c:	fef71ae3          	bne	a4,a5,c10 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 c20:	8552                	mv	a0,s4
 c22:	ab5ff0ef          	jal	6d6 <sbrk>
  if(p == (char*)-1)
 c26:	fd551ee3          	bne	a0,s5,c02 <malloc+0x7c>
        return 0;
 c2a:	4501                	li	a0,0
 c2c:	74a2                	ld	s1,40(sp)
 c2e:	6a42                	ld	s4,16(sp)
 c30:	6aa2                	ld	s5,8(sp)
 c32:	6b02                	ld	s6,0(sp)
 c34:	a03d                	j	c62 <malloc+0xdc>
 c36:	74a2                	ld	s1,40(sp)
 c38:	6a42                	ld	s4,16(sp)
 c3a:	6aa2                	ld	s5,8(sp)
 c3c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c3e:	fae90fe3          	beq	s2,a4,bfc <malloc+0x76>
        p->s.size -= nunits;
 c42:	4137073b          	subw	a4,a4,s3
 c46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c48:	02071693          	slli	a3,a4,0x20
 c4c:	01c6d713          	srli	a4,a3,0x1c
 c50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c56:	00001717          	auipc	a4,0x1
 c5a:	3aa73523          	sd	a0,938(a4) # 2000 <freep>
      return (void*)(p + 1);
 c5e:	01078513          	addi	a0,a5,16
  }
}
 c62:	70e2                	ld	ra,56(sp)
 c64:	7442                	ld	s0,48(sp)
 c66:	7902                	ld	s2,32(sp)
 c68:	69e2                	ld	s3,24(sp)
 c6a:	6121                	addi	sp,sp,64
 c6c:	8082                	ret
 c6e:	74a2                	ld	s1,40(sp)
 c70:	6a42                	ld	s4,16(sp)
 c72:	6aa2                	ld	s5,8(sp)
 c74:	6b02                	ld	s6,0(sp)
 c76:	b7f5                	j	c62 <malloc+0xdc>
