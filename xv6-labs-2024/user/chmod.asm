
user/_chmod:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    int mode;
    char *path;

    if (argc != 3)
   8:	478d                	li	a5,3
   a:	04f51563          	bne	a0,a5,54 <main+0x54>
        exit(1);
    }

    // Simple octal mode parsing (e.g., 755, 644)
    mode = 0;
    for (char *p = argv[1]; *p; p++)
   e:	0085b803          	ld	a6,8(a1)
  12:	00084783          	lbu	a5,0(a6)
  16:	c7a5                	beqz	a5,7e <main+0x7e>
  18:	8642                	mv	a2,a6
    mode = 0;
  1a:	4681                	li	a3,0
    {
        if (*p < '0' || *p > '7')
  1c:	451d                	li	a0,7
  1e:	fd07871b          	addiw	a4,a5,-48
  22:	0ff77713          	zext.b	a4,a4
  26:	04e56163          	bltu	a0,a4,68 <main+0x68>
        {
            printf("chmod: invalid mode %s\n", argv[1]);
            exit(1);
        }
        mode = mode * 8 + (*p - '0');
  2a:	0036969b          	slliw	a3,a3,0x3
  2e:	fd07879b          	addiw	a5,a5,-48
  32:	9ebd                	addw	a3,a3,a5
    for (char *p = argv[1]; *p; p++)
  34:	0605                	addi	a2,a2,1
  36:	00064783          	lbu	a5,0(a2)
  3a:	f3f5                	bnez	a5,1e <main+0x1e>
  3c:	e426                	sd	s1,8(sp)
    }

    path = argv[2];
  3e:	699c                	ld	a5,16(a1)
  40:	84be                	mv	s1,a5

    if (chmod(path, mode) < 0)
  42:	85b6                	mv	a1,a3
  44:	853e                	mv	a0,a5
  46:	38c000ef          	jal	3d2 <chmod>
  4a:	02054c63          	bltz	a0,82 <main+0x82>
    {
        printf("chmod: %s failed\n", path);
        exit(1);
    }

    exit(0);
  4e:	4501                	li	a0,0
  50:	2d2000ef          	jal	322 <exit>
  54:	e426                	sd	s1,8(sp)
        printf("Usage: chmod mode file\n");
  56:	00001517          	auipc	a0,0x1
  5a:	8ca50513          	addi	a0,a0,-1846 # 920 <malloc+0xfe>
  5e:	70c000ef          	jal	76a <printf>
        exit(1);
  62:	4505                	li	a0,1
  64:	2be000ef          	jal	322 <exit>
  68:	e426                	sd	s1,8(sp)
            printf("chmod: invalid mode %s\n", argv[1]);
  6a:	85c2                	mv	a1,a6
  6c:	00001517          	auipc	a0,0x1
  70:	8cc50513          	addi	a0,a0,-1844 # 938 <malloc+0x116>
  74:	6f6000ef          	jal	76a <printf>
            exit(1);
  78:	4505                	li	a0,1
  7a:	2a8000ef          	jal	322 <exit>
    mode = 0;
  7e:	4681                	li	a3,0
  80:	bf75                	j	3c <main+0x3c>
        printf("chmod: %s failed\n", path);
  82:	85a6                	mv	a1,s1
  84:	00001517          	auipc	a0,0x1
  88:	8cc50513          	addi	a0,a0,-1844 # 950 <malloc+0x12e>
  8c:	6de000ef          	jal	76a <printf>
        exit(1);
  90:	4505                	li	a0,1
  92:	290000ef          	jal	322 <exit>

0000000000000096 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  9e:	f63ff0ef          	jal	0 <main>
  exit(0);
  a2:	4501                	li	a0,0
  a4:	27e000ef          	jal	322 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e406                	sd	ra,8(sp)
  ac:	e022                	sd	s0,0(sp)
  ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	87aa                	mv	a5,a0
  b2:	0585                	addi	a1,a1,1
  b4:	0785                	addi	a5,a5,1
  b6:	fff5c703          	lbu	a4,-1(a1)
  ba:	fee78fa3          	sb	a4,-1(a5)
  be:	fb75                	bnez	a4,b2 <strcpy+0xa>
    ;
  return os;
}
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb91                	beqz	a5,e8 <strcmp+0x20>
  d6:	0005c703          	lbu	a4,0(a1)
  da:	00f71763          	bne	a4,a5,e8 <strcmp+0x20>
    p++, q++;
  de:	0505                	addi	a0,a0,1
  e0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbe5                	bnez	a5,d6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  e8:	0005c503          	lbu	a0,0(a1)
}
  ec:	40a7853b          	subw	a0,a5,a0
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strlen>:

uint
strlen(const char *s)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cf91                	beqz	a5,120 <strlen+0x28>
 106:	00150793          	addi	a5,a0,1
 10a:	86be                	mv	a3,a5
 10c:	0785                	addi	a5,a5,1
 10e:	fff7c703          	lbu	a4,-1(a5)
 112:	ff65                	bnez	a4,10a <strlen+0x12>
 114:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  for(n = 0; s[n]; n++)
 120:	4501                	li	a0,0
 122:	bfdd                	j	118 <strlen+0x20>

0000000000000124 <memset>:

void*
memset(void *dst, int c, uint n)
{
 124:	1141                	addi	sp,sp,-16
 126:	e406                	sd	ra,8(sp)
 128:	e022                	sd	s0,0(sp)
 12a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12c:	ca19                	beqz	a2,142 <memset+0x1e>
 12e:	87aa                	mv	a5,a0
 130:	1602                	slli	a2,a2,0x20
 132:	9201                	srli	a2,a2,0x20
 134:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 138:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13c:	0785                	addi	a5,a5,1
 13e:	fee79de3          	bne	a5,a4,138 <memset+0x14>
  }
  return dst;
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  for(; *s; s++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf81                	beqz	a5,16e <strchr+0x24>
    if(*s == c)
 158:	00f58763          	beq	a1,a5,166 <strchr+0x1c>
  for(; *s; s++)
 15c:	0505                	addi	a0,a0,1
 15e:	00054783          	lbu	a5,0(a0)
 162:	fbfd                	bnez	a5,158 <strchr+0xe>
      return (char*)s;
  return 0;
 164:	4501                	li	a0,0
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret
  return 0;
 16e:	4501                	li	a0,0
 170:	bfdd                	j	166 <strchr+0x1c>

0000000000000172 <gets>:

char*
gets(char *buf, int max)
{
 172:	711d                	addi	sp,sp,-96
 174:	ec86                	sd	ra,88(sp)
 176:	e8a2                	sd	s0,80(sp)
 178:	e4a6                	sd	s1,72(sp)
 17a:	e0ca                	sd	s2,64(sp)
 17c:	fc4e                	sd	s3,56(sp)
 17e:	f852                	sd	s4,48(sp)
 180:	f456                	sd	s5,40(sp)
 182:	f05a                	sd	s6,32(sp)
 184:	ec5e                	sd	s7,24(sp)
 186:	e862                	sd	s8,16(sp)
 188:	1080                	addi	s0,sp,96
 18a:	8baa                	mv	s7,a0
 18c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	892a                	mv	s2,a0
 190:	4481                	li	s1,0
    cc = read(0, &c, 1);
 192:	faf40b13          	addi	s6,s0,-81
 196:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 198:	8c26                	mv	s8,s1
 19a:	0014899b          	addiw	s3,s1,1
 19e:	84ce                	mv	s1,s3
 1a0:	0349d463          	bge	s3,s4,1c8 <gets+0x56>
    cc = read(0, &c, 1);
 1a4:	8656                	mv	a2,s5
 1a6:	85da                	mv	a1,s6
 1a8:	4501                	li	a0,0
 1aa:	190000ef          	jal	33a <read>
    if(cc < 1)
 1ae:	00a05d63          	blez	a0,1c8 <gets+0x56>
      break;
    buf[i++] = c;
 1b2:	faf44783          	lbu	a5,-81(s0)
 1b6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ba:	0905                	addi	s2,s2,1
 1bc:	ff678713          	addi	a4,a5,-10
 1c0:	c319                	beqz	a4,1c6 <gets+0x54>
 1c2:	17cd                	addi	a5,a5,-13
 1c4:	fbf1                	bnez	a5,198 <gets+0x26>
    buf[i++] = c;
 1c6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1c8:	9c5e                	add	s8,s8,s7
 1ca:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1ce:	855e                	mv	a0,s7
 1d0:	60e6                	ld	ra,88(sp)
 1d2:	6446                	ld	s0,80(sp)
 1d4:	64a6                	ld	s1,72(sp)
 1d6:	6906                	ld	s2,64(sp)
 1d8:	79e2                	ld	s3,56(sp)
 1da:	7a42                	ld	s4,48(sp)
 1dc:	7aa2                	ld	s5,40(sp)
 1de:	7b02                	ld	s6,32(sp)
 1e0:	6be2                	ld	s7,24(sp)
 1e2:	6c42                	ld	s8,16(sp)
 1e4:	6125                	addi	sp,sp,96
 1e6:	8082                	ret

00000000000001e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e8:	1101                	addi	sp,sp,-32
 1ea:	ec06                	sd	ra,24(sp)
 1ec:	e822                	sd	s0,16(sp)
 1ee:	e04a                	sd	s2,0(sp)
 1f0:	1000                	addi	s0,sp,32
 1f2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	4581                	li	a1,0
 1f6:	194000ef          	jal	38a <open>
  if(fd < 0)
 1fa:	02054263          	bltz	a0,21e <stat+0x36>
 1fe:	e426                	sd	s1,8(sp)
 200:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 202:	85ca                	mv	a1,s2
 204:	14e000ef          	jal	352 <fstat>
 208:	892a                	mv	s2,a0
  close(fd);
 20a:	8526                	mv	a0,s1
 20c:	1ae000ef          	jal	3ba <close>
  return r;
 210:	64a2                	ld	s1,8(sp)
}
 212:	854a                	mv	a0,s2
 214:	60e2                	ld	ra,24(sp)
 216:	6442                	ld	s0,16(sp)
 218:	6902                	ld	s2,0(sp)
 21a:	6105                	addi	sp,sp,32
 21c:	8082                	ret
    return -1;
 21e:	57fd                	li	a5,-1
 220:	893e                	mv	s2,a5
 222:	bfc5                	j	212 <stat+0x2a>

0000000000000224 <atoi>:

int
atoi(const char *s)
{
 224:	1141                	addi	sp,sp,-16
 226:	e406                	sd	ra,8(sp)
 228:	e022                	sd	s0,0(sp)
 22a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22c:	00054683          	lbu	a3,0(a0)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	4625                	li	a2,9
 23a:	02f66963          	bltu	a2,a5,26c <atoi+0x48>
 23e:	872a                	mv	a4,a0
  n = 0;
 240:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 242:	0705                	addi	a4,a4,1
 244:	0025179b          	slliw	a5,a0,0x2
 248:	9fa9                	addw	a5,a5,a0
 24a:	0017979b          	slliw	a5,a5,0x1
 24e:	9fb5                	addw	a5,a5,a3
 250:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 254:	00074683          	lbu	a3,0(a4)
 258:	fd06879b          	addiw	a5,a3,-48
 25c:	0ff7f793          	zext.b	a5,a5
 260:	fef671e3          	bgeu	a2,a5,242 <atoi+0x1e>
  return n;
}
 264:	60a2                	ld	ra,8(sp)
 266:	6402                	ld	s0,0(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
  n = 0;
 26c:	4501                	li	a0,0
 26e:	bfdd                	j	264 <atoi+0x40>

0000000000000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 278:	02b57563          	bgeu	a0,a1,2a2 <memmove+0x32>
    while(n-- > 0)
 27c:	00c05f63          	blez	a2,29a <memmove+0x2a>
 280:	1602                	slli	a2,a2,0x20
 282:	9201                	srli	a2,a2,0x20
 284:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 288:	872a                	mv	a4,a0
      *dst++ = *src++;
 28a:	0585                	addi	a1,a1,1
 28c:	0705                	addi	a4,a4,1
 28e:	fff5c683          	lbu	a3,-1(a1)
 292:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 296:	fee79ae3          	bne	a5,a4,28a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
    while(n-- > 0)
 2a2:	fec05ce3          	blez	a2,29a <memmove+0x2a>
    dst += n;
 2a6:	00c50733          	add	a4,a0,a2
    src += n;
 2aa:	95b2                	add	a1,a1,a2
 2ac:	fff6079b          	addiw	a5,a2,-1
 2b0:	1782                	slli	a5,a5,0x20
 2b2:	9381                	srli	a5,a5,0x20
 2b4:	fff7c793          	not	a5,a5
 2b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ba:	15fd                	addi	a1,a1,-1
 2bc:	177d                	addi	a4,a4,-1
 2be:	0005c683          	lbu	a3,0(a1)
 2c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c6:	fef71ae3          	bne	a4,a5,2ba <memmove+0x4a>
 2ca:	bfc1                	j	29a <memmove+0x2a>

00000000000002cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d4:	c61d                	beqz	a2,302 <memcmp+0x36>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	0005c703          	lbu	a4,0(a1)
 2e6:	00e79863          	bne	a5,a4,2f6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ea:	0505                	addi	a0,a0,1
    p2++;
 2ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ee:	fed518e3          	bne	a0,a3,2de <memcmp+0x12>
  }
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	a019                	j	2fa <memcmp+0x2e>
      return *p1 - *p2;
 2f6:	40e7853b          	subw	a0,a5,a4
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfdd                	j	2fa <memcmp+0x2e>

0000000000000306 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30e:	f63ff0ef          	jal	270 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <kill>:
.global kill
kill:
 li a7, SYS_kill
 342:	4899                	li	a7,6
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exec>:
.global exec
exec:
 li a7, SYS_exec
 34a:	489d                	li	a7,7
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 352:	48a1                	li	a7,8
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39a:	48c5                	li	a7,17
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a2:	48c9                	li	a7,18
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 3d2:	48e1                	li	a7,24
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3da:	1101                	addi	sp,sp,-32
 3dc:	ec06                	sd	ra,24(sp)
 3de:	e822                	sd	s0,16(sp)
 3e0:	1000                	addi	s0,sp,32
 3e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e6:	4605                	li	a2,1
 3e8:	fef40593          	addi	a1,s0,-17
 3ec:	fa7ff0ef          	jal	392 <write>
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6105                	addi	sp,sp,32
 3f6:	8082                	ret

00000000000003f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f8:	7139                	addi	sp,sp,-64
 3fa:	fc06                	sd	ra,56(sp)
 3fc:	f822                	sd	s0,48(sp)
 3fe:	f04a                	sd	s2,32(sp)
 400:	ec4e                	sd	s3,24(sp)
 402:	0080                	addi	s0,sp,64
 404:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 406:	cac9                	beqz	a3,498 <printint+0xa0>
 408:	01f5d79b          	srliw	a5,a1,0x1f
 40c:	c7d1                	beqz	a5,498 <printint+0xa0>
    neg = 1;
    x = -xx;
 40e:	40b005bb          	negw	a1,a1
    neg = 1;
 412:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 414:	fc040993          	addi	s3,s0,-64
  neg = 0;
 418:	86ce                	mv	a3,s3
  i = 0;
 41a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41c:	00000817          	auipc	a6,0x0
 420:	55480813          	addi	a6,a6,1364 # 970 <digits>
 424:	88ba                	mv	a7,a4
 426:	0017051b          	addiw	a0,a4,1
 42a:	872a                	mv	a4,a0
 42c:	02c5f7bb          	remuw	a5,a1,a2
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	97c2                	add	a5,a5,a6
 436:	0007c783          	lbu	a5,0(a5)
 43a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43e:	87ae                	mv	a5,a1
 440:	02c5d5bb          	divuw	a1,a1,a2
 444:	0685                	addi	a3,a3,1
 446:	fcc7ffe3          	bgeu	a5,a2,424 <printint+0x2c>
  if(neg)
 44a:	00030c63          	beqz	t1,462 <printint+0x6a>
    buf[i++] = '-';
 44e:	fd050793          	addi	a5,a0,-48
 452:	00878533          	add	a0,a5,s0
 456:	02d00793          	li	a5,45
 45a:	fef50823          	sb	a5,-16(a0)
 45e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 462:	02e05563          	blez	a4,48c <printint+0x94>
 466:	f426                	sd	s1,40(sp)
 468:	377d                	addiw	a4,a4,-1
 46a:	00e984b3          	add	s1,s3,a4
 46e:	19fd                	addi	s3,s3,-1
 470:	99ba                	add	s3,s3,a4
 472:	1702                	slli	a4,a4,0x20
 474:	9301                	srli	a4,a4,0x20
 476:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47a:	0004c583          	lbu	a1,0(s1)
 47e:	854a                	mv	a0,s2
 480:	f5bff0ef          	jal	3da <putc>
  while(--i >= 0)
 484:	14fd                	addi	s1,s1,-1
 486:	ff349ae3          	bne	s1,s3,47a <printint+0x82>
 48a:	74a2                	ld	s1,40(sp)
}
 48c:	70e2                	ld	ra,56(sp)
 48e:	7442                	ld	s0,48(sp)
 490:	7902                	ld	s2,32(sp)
 492:	69e2                	ld	s3,24(sp)
 494:	6121                	addi	sp,sp,64
 496:	8082                	ret
  neg = 0;
 498:	4301                	li	t1,0
 49a:	bfad                	j	414 <printint+0x1c>

000000000000049c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49c:	711d                	addi	sp,sp,-96
 49e:	ec86                	sd	ra,88(sp)
 4a0:	e8a2                	sd	s0,80(sp)
 4a2:	e4a6                	sd	s1,72(sp)
 4a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a6:	0005c483          	lbu	s1,0(a1)
 4aa:	20048963          	beqz	s1,6bc <vprintf+0x220>
 4ae:	e0ca                	sd	s2,64(sp)
 4b0:	fc4e                	sd	s3,56(sp)
 4b2:	f852                	sd	s4,48(sp)
 4b4:	f456                	sd	s5,40(sp)
 4b6:	f05a                	sd	s6,32(sp)
 4b8:	ec5e                	sd	s7,24(sp)
 4ba:	e862                	sd	s8,16(sp)
 4bc:	8b2a                	mv	s6,a0
 4be:	8a2e                	mv	s4,a1
 4c0:	8bb2                	mv	s7,a2
  state = 0;
 4c2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c4:	4901                	li	s2,0
 4c6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4cc:	06400c13          	li	s8,100
 4d0:	a00d                	j	4f2 <vprintf+0x56>
        putc(fd, c0);
 4d2:	85a6                	mv	a1,s1
 4d4:	855a                	mv	a0,s6
 4d6:	f05ff0ef          	jal	3da <putc>
 4da:	a019                	j	4e0 <vprintf+0x44>
    } else if(state == '%'){
 4dc:	03598363          	beq	s3,s5,502 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4e0:	0019079b          	addiw	a5,s2,1
 4e4:	893e                	mv	s2,a5
 4e6:	873e                	mv	a4,a5
 4e8:	97d2                	add	a5,a5,s4
 4ea:	0007c483          	lbu	s1,0(a5)
 4ee:	1c048063          	beqz	s1,6ae <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 4f2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4f6:	fe0993e3          	bnez	s3,4dc <vprintf+0x40>
      if(c0 == '%'){
 4fa:	fd579ce3          	bne	a5,s5,4d2 <vprintf+0x36>
        state = '%';
 4fe:	89be                	mv	s3,a5
 500:	b7c5                	j	4e0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 502:	00ea06b3          	add	a3,s4,a4
 506:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	1a060e63          	beqz	a2,6c6 <vprintf+0x22a>
      if(c0 == 'd'){
 50e:	03878763          	beq	a5,s8,53c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 512:	f9478693          	addi	a3,a5,-108
 516:	0016b693          	seqz	a3,a3
 51a:	f9c60593          	addi	a1,a2,-100
 51e:	e99d                	bnez	a1,554 <vprintf+0xb8>
 520:	ca95                	beqz	a3,554 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 522:	008b8493          	addi	s1,s7,8
 526:	4685                	li	a3,1
 528:	4629                	li	a2,10
 52a:	000ba583          	lw	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	ec9ff0ef          	jal	3f8 <printint>
        i += 1;
 534:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 536:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 538:	4981                	li	s3,0
 53a:	b75d                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 53c:	008b8493          	addi	s1,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	eafff0ef          	jal	3f8 <printint>
 54e:	8ba6                	mv	s7,s1
      state = 0;
 550:	4981                	li	s3,0
 552:	b779                	j	4e0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 554:	9752                	add	a4,a4,s4
 556:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	f9460713          	addi	a4,a2,-108
 55e:	00173713          	seqz	a4,a4
 562:	8f75                	and	a4,a4,a3
 564:	f9c58513          	addi	a0,a1,-100
 568:	16051963          	bnez	a0,6da <vprintf+0x23e>
 56c:	16070763          	beqz	a4,6da <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	008b8493          	addi	s1,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e7bff0ef          	jal	3f8 <printint>
        i += 2;
 582:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
        i += 2;
 588:	bfa1                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e61ff0ef          	jal	3f8 <printint>
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b781                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e49ff0ef          	jal	3f8 <printint>
        i += 1;
 5b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b71d                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e2fff0ef          	jal	3f8 <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	b731                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e15ff0ef          	jal	3f8 <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bdd5                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	dfdff0ef          	jal	3f8 <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	bde9                	j	4e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	de3ff0ef          	jal	3f8 <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	b5c1                	j	4e0 <vprintf+0x44>
 622:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 624:	008b8793          	addi	a5,s7,8
 628:	8cbe                	mv	s9,a5
 62a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62e:	03000593          	li	a1,48
 632:	855a                	mv	a0,s6
 634:	da7ff0ef          	jal	3da <putc>
  putc(fd, 'x');
 638:	07800593          	li	a1,120
 63c:	855a                	mv	a0,s6
 63e:	d9dff0ef          	jal	3da <putc>
 642:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 644:	00000b97          	auipc	s7,0x0
 648:	32cb8b93          	addi	s7,s7,812 # 970 <digits>
 64c:	03c9d793          	srli	a5,s3,0x3c
 650:	97de                	add	a5,a5,s7
 652:	0007c583          	lbu	a1,0(a5)
 656:	855a                	mv	a0,s6
 658:	d83ff0ef          	jal	3da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	34fd                	addiw	s1,s1,-1
 660:	f4f5                	bnez	s1,64c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 662:	8be6                	mv	s7,s9
      state = 0;
 664:	4981                	li	s3,0
 666:	6ca2                	ld	s9,8(sp)
 668:	bda5                	j	4e0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb483          	ld	s1,0(s7)
 672:	cc91                	beqz	s1,68e <vprintf+0x1f2>
        for(; *s; s++)
 674:	0004c583          	lbu	a1,0(s1)
 678:	c985                	beqz	a1,6a8 <vprintf+0x20c>
          putc(fd, *s);
 67a:	855a                	mv	a0,s6
 67c:	d5fff0ef          	jal	3da <putc>
        for(; *s; s++)
 680:	0485                	addi	s1,s1,1
 682:	0004c583          	lbu	a1,0(s1)
 686:	f9f5                	bnez	a1,67a <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd91                	j	4e0 <vprintf+0x44>
          s = "(null)";
 68e:	00000497          	auipc	s1,0x0
 692:	2da48493          	addi	s1,s1,730 # 968 <malloc+0x146>
        for(; *s; s++)
 696:	02800593          	li	a1,40
 69a:	b7c5                	j	67a <vprintf+0x1de>
        putc(fd, '%');
 69c:	85be                	mv	a1,a5
 69e:	855a                	mv	a0,s6
 6a0:	d3bff0ef          	jal	3da <putc>
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd2d                	j	4e0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd15                	j	4e0 <vprintf+0x44>
 6ae:	6906                	ld	s2,64(sp)
 6b0:	79e2                	ld	s3,56(sp)
 6b2:	7a42                	ld	s4,48(sp)
 6b4:	7aa2                	ld	s5,40(sp)
 6b6:	7b02                	ld	s6,32(sp)
 6b8:	6be2                	ld	s7,24(sp)
 6ba:	6c42                	ld	s8,16(sp)
    }
  }
}
 6bc:	60e6                	ld	ra,88(sp)
 6be:	6446                	ld	s0,80(sp)
 6c0:	64a6                	ld	s1,72(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret
      if(c0 == 'd'){
 6c6:	06400713          	li	a4,100
 6ca:	e6e789e3          	beq	a5,a4,53c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	f9478693          	addi	a3,a5,-108
 6d2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6d6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6da:	07500513          	li	a0,117
 6de:	eaa786e3          	beq	a5,a0,58a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6e2:	f8b60513          	addi	a0,a2,-117
 6e6:	e119                	bnez	a0,6ec <vprintf+0x250>
 6e8:	ea069de3          	bnez	a3,5a2 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ec:	f8b58513          	addi	a0,a1,-117
 6f0:	e119                	bnez	a0,6f6 <vprintf+0x25a>
 6f2:	ec0715e3          	bnez	a4,5bc <vprintf+0x120>
      } else if(c0 == 'x'){
 6f6:	07800513          	li	a0,120
 6fa:	eca78ee3          	beq	a5,a0,5d6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6fe:	f8860613          	addi	a2,a2,-120
 702:	e219                	bnez	a2,708 <vprintf+0x26c>
 704:	ee0695e3          	bnez	a3,5ee <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	f8858593          	addi	a1,a1,-120
 70c:	e199                	bnez	a1,712 <vprintf+0x276>
 70e:	ee071de3          	bnez	a4,608 <vprintf+0x16c>
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	f0e786e3          	beq	a5,a4,622 <vprintf+0x186>
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	f4e786e3          	beq	a5,a4,66a <vprintf+0x1ce>
      } else if(c0 == '%'){
 722:	02500713          	li	a4,37
 726:	f6e78be3          	beq	a5,a4,69c <vprintf+0x200>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	855a                	mv	a0,s6
 730:	cabff0ef          	jal	3da <putc>
        putc(fd, c0);
 734:	85a6                	mv	a1,s1
 736:	855a                	mv	a0,s6
 738:	ca3ff0ef          	jal	3da <putc>
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b34d                	j	4e0 <vprintf+0x44>

0000000000000740 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 740:	715d                	addi	sp,sp,-80
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e010                	sd	a2,0(s0)
 74a:	e414                	sd	a3,8(s0)
 74c:	e818                	sd	a4,16(s0)
 74e:	ec1c                	sd	a5,24(s0)
 750:	03043023          	sd	a6,32(s0)
 754:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	8622                	mv	a2,s0
 75a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75e:	d3fff0ef          	jal	49c <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	711d                	addi	sp,sp,-96
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e40c                	sd	a1,8(s0)
 774:	e810                	sd	a2,16(s0)
 776:	ec14                	sd	a3,24(s0)
 778:	f018                	sd	a4,32(s0)
 77a:	f41c                	sd	a5,40(s0)
 77c:	03043823          	sd	a6,48(s0)
 780:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	00840613          	addi	a2,s0,8
 788:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78c:	85aa                	mv	a1,a0
 78e:	4505                	li	a0,1
 790:	d0dff0ef          	jal	49c <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	1141                	addi	sp,sp,-16
 79e:	e406                	sd	ra,8(sp)
 7a0:	e022                	sd	s0,0(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8587b783          	ld	a5,-1960(a5) # 1000 <freep>
 7b0:	a039                	j	7be <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e7e463          	bltu	a5,a4,7bc <free+0x20>
 7b8:	00e6ea63          	bltu	a3,a4,7cc <free+0x30>
{
 7bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fed7fae3          	bgeu	a5,a3,7b2 <free+0x16>
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e6e463          	bltu	a3,a4,7cc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	fee7eae3          	bltu	a5,a4,7bc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7cc:	ff852583          	lw	a1,-8(a0)
 7d0:	6390                	ld	a2,0(a5)
 7d2:	02059813          	slli	a6,a1,0x20
 7d6:	01c85713          	srli	a4,a6,0x1c
 7da:	9736                	add	a4,a4,a3
 7dc:	02e60563          	beq	a2,a4,806 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7e4:	4790                	lw	a2,8(a5)
 7e6:	02061593          	slli	a1,a2,0x20
 7ea:	01c5d713          	srli	a4,a1,0x1c
 7ee:	973e                	add	a4,a4,a5
 7f0:	02e68263          	beq	a3,a4,814 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
}
 7fe:	60a2                	ld	ra,8(sp)
 800:	6402                	ld	s0,0(sp)
 802:	0141                	addi	sp,sp,16
 804:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 806:	4618                	lw	a4,8(a2)
 808:	9f2d                	addw	a4,a4,a1
 80a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	6310                	ld	a2,0(a4)
 812:	b7f9                	j	7e0 <free+0x44>
    p->s.size += bp->s.size;
 814:	ff852703          	lw	a4,-8(a0)
 818:	9f31                	addw	a4,a4,a2
 81a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81c:	ff053683          	ld	a3,-16(a0)
 820:	bfd1                	j	7f4 <free+0x58>

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f04a                	sd	s2,32(sp)
 82a:	ec4e                	sd	s3,24(sp)
 82c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	02051993          	slli	s3,a0,0x20
 832:	0209d993          	srli	s3,s3,0x20
 836:	09bd                	addi	s3,s3,15
 838:	0049d993          	srli	s3,s3,0x4
 83c:	2985                	addiw	s3,s3,1
 83e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 840:	00000517          	auipc	a0,0x0
 844:	7c053503          	ld	a0,1984(a0) # 1000 <freep>
 848:	c905                	beqz	a0,878 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	09377663          	bgeu	a4,s3,8da <malloc+0xb8>
 852:	f426                	sd	s1,40(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 85a:	8a4e                	mv	s4,s3
 85c:	6705                	lui	a4,0x1
 85e:	00e9f363          	bgeu	s3,a4,864 <malloc+0x42>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86c:	00000497          	auipc	s1,0x0
 870:	79448493          	addi	s1,s1,1940 # 1000 <freep>
  if(p == (char*)-1)
 874:	5afd                	li	s5,-1
 876:	a83d                	j	8b4 <malloc+0x92>
 878:	f426                	sd	s1,40(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	79078793          	addi	a5,a5,1936 # 1010 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	76f73c23          	sd	a5,1912(a4) # 1000 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 896:	b7d1                	j	85a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	a899                	j	8f2 <malloc+0xd0>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	ef9ff0ef          	jal	79c <free>
  return freep;
 8a8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8aa:	c125                	beqz	a0,90a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	03277163          	bgeu	a4,s2,8d2 <malloc+0xb0>
    if(p == freep)
 8b4:	6098                	ld	a4,0(s1)
 8b6:	853e                	mv	a0,a5
 8b8:	fef71ae3          	bne	a4,a5,8ac <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8bc:	8552                	mv	a0,s4
 8be:	ab5ff0ef          	jal	372 <sbrk>
  if(p == (char*)-1)
 8c2:	fd551ee3          	bne	a0,s5,89e <malloc+0x7c>
        return 0;
 8c6:	4501                	li	a0,0
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	a03d                	j	8fe <malloc+0xdc>
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8da:	fae90fe3          	beq	s2,a4,898 <malloc+0x76>
        p->s.size -= nunits;
 8de:	4137073b          	subw	a4,a4,s3
 8e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e4:	02071693          	slli	a3,a4,0x20
 8e8:	01c6d713          	srli	a4,a3,0x1c
 8ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70a73723          	sd	a0,1806(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fa:	01078513          	addi	a0,a5,16
  }
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	7902                	ld	s2,32(sp)
 904:	69e2                	ld	s3,24(sp)
 906:	6121                	addi	sp,sp,64
 908:	8082                	ret
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	b7f5                	j	8fe <malloc+0xdc>
