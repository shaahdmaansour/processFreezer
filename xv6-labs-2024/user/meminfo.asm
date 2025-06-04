
user/_meminfo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  uint64 mem_stats = meminfo();
   8:	3e4000ef          	jal	3ec <meminfo>
  
  if(mem_stats == -1) {
   c:	57fd                	li	a5,-1
   e:	08f50363          	beq	a0,a5,94 <main+0x94>
  12:	ec26                	sd	s1,24(sp)
  14:	e84a                	sd	s2,16(sp)
  16:	e44e                	sd	s3,8(sp)
  18:	e052                	sd	s4,0(sp)
    exit(1);
  }

  // Extract free and used pages from the 64-bit value
  uint64 free_pages = mem_stats >> 32;
  uint64 used_pages = mem_stats & 0xFFFFFFFF;
  1a:	02051913          	slli	s2,a0,0x20
  1e:	02095913          	srli	s2,s2,0x20
  uint64 free_pages = mem_stats >> 32;
  22:	9101                	srli	a0,a0,0x20
  
  // Convert to bytes (multiply by PGSIZE)
  uint64 free_bytes = free_pages * 4096;
  24:	00c51493          	slli	s1,a0,0xc
  uint64 used_bytes = used_pages * 4096;
  28:	00c91a13          	slli	s4,s2,0xc
  uint64 total_bytes = free_bytes + used_bytes;
  2c:	014489b3          	add	s3,s1,s4

  // Print memory statistics
  printf("Memory Statistics:\n");
  30:	00001517          	auipc	a0,0x1
  34:	94050513          	addi	a0,a0,-1728 # 970 <malloc+0x12c>
  38:	754000ef          	jal	78c <printf>
  printf("Total Memory: %d bytes\n", (int)total_bytes);
  3c:	0009859b          	sext.w	a1,s3
  40:	00001517          	auipc	a0,0x1
  44:	94850513          	addi	a0,a0,-1720 # 988 <malloc+0x144>
  48:	744000ef          	jal	78c <printf>
  printf("Used Memory:  %d bytes\n", (int)used_bytes);
  4c:	000a059b          	sext.w	a1,s4
  50:	00001517          	auipc	a0,0x1
  54:	95050513          	addi	a0,a0,-1712 # 9a0 <malloc+0x15c>
  58:	734000ef          	jal	78c <printf>
  printf("Free Memory:  %d bytes\n", (int)free_bytes);
  5c:	0004859b          	sext.w	a1,s1
  60:	00001517          	auipc	a0,0x1
  64:	95850513          	addi	a0,a0,-1704 # 9b8 <malloc+0x174>
  68:	724000ef          	jal	78c <printf>
  
  // Calculate and print memory usage percentage
  int usage_percent;
  if (total_bytes == 0) {
    usage_percent = 0;  // If no memory, usage is 0%
  6c:	4581                	li	a1,0
  if (total_bytes == 0) {
  6e:	00098a63          	beqz	s3,82 <main+0x82>
  } else {
    usage_percent = (int)((used_bytes * 100) / total_bytes);
  72:	000647b7          	lui	a5,0x64
  76:	02f90933          	mul	s2,s2,a5
  7a:	03395933          	divu	s2,s2,s3
  7e:	0009059b          	sext.w	a1,s2
  }
  printf("Memory Usage: %d%%\n", usage_percent);
  82:	00001517          	auipc	a0,0x1
  86:	94e50513          	addi	a0,a0,-1714 # 9d0 <malloc+0x18c>
  8a:	702000ef          	jal	78c <printf>

  exit(0);
  8e:	4501                	li	a0,0
  90:	2ac000ef          	jal	33c <exit>
  94:	ec26                	sd	s1,24(sp)
  96:	e84a                	sd	s2,16(sp)
  98:	e44e                	sd	s3,8(sp)
  9a:	e052                	sd	s4,0(sp)
    fprintf(2, "meminfo: failed to get memory statistics\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	8a458593          	addi	a1,a1,-1884 # 940 <malloc+0xfc>
  a4:	4509                	li	a0,2
  a6:	6bc000ef          	jal	762 <fprintf>
    exit(1);
  aa:	4505                	li	a0,1
  ac:	290000ef          	jal	33c <exit>

00000000000000b0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b8:	f49ff0ef          	jal	0 <main>
  exit(0);
  bc:	4501                	li	a0,0
  be:	27e000ef          	jal	33c <exit>

00000000000000c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	87aa                	mv	a5,a0
  cc:	0585                	addi	a1,a1,1
  ce:	0785                	addi	a5,a5,1 # 64001 <base+0x62ff1>
  d0:	fff5c703          	lbu	a4,-1(a1)
  d4:	fee78fa3          	sb	a4,-1(a5)
  d8:	fb75                	bnez	a4,cc <strcpy+0xa>
    ;
  return os;
}
  da:	60a2                	ld	ra,8(sp)
  dc:	6402                	ld	s0,0(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cb91                	beqz	a5,102 <strcmp+0x20>
  f0:	0005c703          	lbu	a4,0(a1)
  f4:	00f71763          	bne	a4,a5,102 <strcmp+0x20>
    p++, q++;
  f8:	0505                	addi	a0,a0,1
  fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbe5                	bnez	a5,f0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 102:	0005c503          	lbu	a0,0(a1)
}
 106:	40a7853b          	subw	a0,a5,a0
 10a:	60a2                	ld	ra,8(sp)
 10c:	6402                	ld	s0,0(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strlen>:

uint
strlen(const char *s)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x28>
 120:	00150793          	addi	a5,a0,1
 124:	86be                	mv	a3,a5
 126:	0785                	addi	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x12>
 12e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 132:	60a2                	ld	ra,8(sp)
 134:	6402                	ld	s0,0(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfdd                	j	132 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 146:	ca19                	beqz	a2,15c <memset+0x1e>
 148:	87aa                	mv	a5,a0
 14a:	1602                	slli	a2,a2,0x20
 14c:	9201                	srli	a2,a2,0x20
 14e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 156:	0785                	addi	a5,a5,1
 158:	fee79de3          	bne	a5,a4,152 <memset+0x14>
  }
  return dst;
}
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf81                	beqz	a5,188 <strchr+0x24>
    if(*s == c)
 172:	00f58763          	beq	a1,a5,180 <strchr+0x1c>
  for(; *s; s++)
 176:	0505                	addi	a0,a0,1
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbfd                	bnez	a5,172 <strchr+0xe>
      return (char*)s;
  return 0;
 17e:	4501                	li	a0,0
}
 180:	60a2                	ld	ra,8(sp)
 182:	6402                	ld	s0,0(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret
  return 0;
 188:	4501                	li	a0,0
 18a:	bfdd                	j	180 <strchr+0x1c>

000000000000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	711d                	addi	sp,sp,-96
 18e:	ec86                	sd	ra,88(sp)
 190:	e8a2                	sd	s0,80(sp)
 192:	e4a6                	sd	s1,72(sp)
 194:	e0ca                	sd	s2,64(sp)
 196:	fc4e                	sd	s3,56(sp)
 198:	f852                	sd	s4,48(sp)
 19a:	f456                	sd	s5,40(sp)
 19c:	f05a                	sd	s6,32(sp)
 19e:	ec5e                	sd	s7,24(sp)
 1a0:	e862                	sd	s8,16(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ac:	faf40b13          	addi	s6,s0,-81
 1b0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1b2:	8c26                	mv	s8,s1
 1b4:	0014899b          	addiw	s3,s1,1
 1b8:	84ce                	mv	s1,s3
 1ba:	0349d463          	bge	s3,s4,1e2 <gets+0x56>
    cc = read(0, &c, 1);
 1be:	8656                	mv	a2,s5
 1c0:	85da                	mv	a1,s6
 1c2:	4501                	li	a0,0
 1c4:	190000ef          	jal	354 <read>
    if(cc < 1)
 1c8:	00a05d63          	blez	a0,1e2 <gets+0x56>
      break;
    buf[i++] = c;
 1cc:	faf44783          	lbu	a5,-81(s0)
 1d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d4:	0905                	addi	s2,s2,1
 1d6:	ff678713          	addi	a4,a5,-10
 1da:	c319                	beqz	a4,1e0 <gets+0x54>
 1dc:	17cd                	addi	a5,a5,-13
 1de:	fbf1                	bnez	a5,1b2 <gets+0x26>
    buf[i++] = c;
 1e0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1e2:	9c5e                	add	s8,s8,s7
 1e4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1e8:	855e                	mv	a0,s7
 1ea:	60e6                	ld	ra,88(sp)
 1ec:	6446                	ld	s0,80(sp)
 1ee:	64a6                	ld	s1,72(sp)
 1f0:	6906                	ld	s2,64(sp)
 1f2:	79e2                	ld	s3,56(sp)
 1f4:	7a42                	ld	s4,48(sp)
 1f6:	7aa2                	ld	s5,40(sp)
 1f8:	7b02                	ld	s6,32(sp)
 1fa:	6be2                	ld	s7,24(sp)
 1fc:	6c42                	ld	s8,16(sp)
 1fe:	6125                	addi	sp,sp,96
 200:	8082                	ret

0000000000000202 <stat>:

int
stat(const char *n, struct stat *st)
{
 202:	1101                	addi	sp,sp,-32
 204:	ec06                	sd	ra,24(sp)
 206:	e822                	sd	s0,16(sp)
 208:	e04a                	sd	s2,0(sp)
 20a:	1000                	addi	s0,sp,32
 20c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	4581                	li	a1,0
 210:	194000ef          	jal	3a4 <open>
  if(fd < 0)
 214:	02054263          	bltz	a0,238 <stat+0x36>
 218:	e426                	sd	s1,8(sp)
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	14e000ef          	jal	36c <fstat>
 222:	892a                	mv	s2,a0
  close(fd);
 224:	8526                	mv	a0,s1
 226:	1ae000ef          	jal	3d4 <close>
  return r;
 22a:	64a2                	ld	s1,8(sp)
}
 22c:	854a                	mv	a0,s2
 22e:	60e2                	ld	ra,24(sp)
 230:	6442                	ld	s0,16(sp)
 232:	6902                	ld	s2,0(sp)
 234:	6105                	addi	sp,sp,32
 236:	8082                	ret
    return -1;
 238:	57fd                	li	a5,-1
 23a:	893e                	mv	s2,a5
 23c:	bfc5                	j	22c <stat+0x2a>

000000000000023e <atoi>:

int
atoi(const char *s)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 246:	00054683          	lbu	a3,0(a0)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	4625                	li	a2,9
 254:	02f66963          	bltu	a2,a5,286 <atoi+0x48>
 258:	872a                	mv	a4,a0
  n = 0;
 25a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 25c:	0705                	addi	a4,a4,1
 25e:	0025179b          	slliw	a5,a0,0x2
 262:	9fa9                	addw	a5,a5,a0
 264:	0017979b          	slliw	a5,a5,0x1
 268:	9fb5                	addw	a5,a5,a3
 26a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26e:	00074683          	lbu	a3,0(a4)
 272:	fd06879b          	addiw	a5,a3,-48
 276:	0ff7f793          	zext.b	a5,a5
 27a:	fef671e3          	bgeu	a2,a5,25c <atoi+0x1e>
  return n;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
  n = 0;
 286:	4501                	li	a0,0
 288:	bfdd                	j	27e <atoi+0x40>

000000000000028a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 292:	02b57563          	bgeu	a0,a1,2bc <memmove+0x32>
    while(n-- > 0)
 296:	00c05f63          	blez	a2,2b4 <memmove+0x2a>
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a4:	0585                	addi	a1,a1,1
 2a6:	0705                	addi	a4,a4,1
 2a8:	fff5c683          	lbu	a3,-1(a1)
 2ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b0:	fee79ae3          	bne	a5,a4,2a4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
    while(n-- > 0)
 2bc:	fec05ce3          	blez	a2,2b4 <memmove+0x2a>
    dst += n;
 2c0:	00c50733          	add	a4,a0,a2
    src += n;
 2c4:	95b2                	add	a1,a1,a2
 2c6:	fff6079b          	addiw	a5,a2,-1
 2ca:	1782                	slli	a5,a5,0x20
 2cc:	9381                	srli	a5,a5,0x20
 2ce:	fff7c793          	not	a5,a5
 2d2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d4:	15fd                	addi	a1,a1,-1
 2d6:	177d                	addi	a4,a4,-1
 2d8:	0005c683          	lbu	a3,0(a1)
 2dc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e0:	fef71ae3          	bne	a4,a5,2d4 <memmove+0x4a>
 2e4:	bfc1                	j	2b4 <memmove+0x2a>

00000000000002e6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ee:	c61d                	beqz	a2,31c <memcmp+0x36>
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00e79863          	bne	a5,a4,310 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 304:	0505                	addi	a0,a0,1
    p2++;
 306:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 308:	fed518e3          	bne	a0,a3,2f8 <memcmp+0x12>
  }
  return 0;
 30c:	4501                	li	a0,0
 30e:	a019                	j	314 <memcmp+0x2e>
      return *p1 - *p2;
 310:	40e7853b          	subw	a0,a5,a4
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  return 0;
 31c:	4501                	li	a0,0
 31e:	bfdd                	j	314 <memcmp+0x2e>

0000000000000320 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 328:	f63ff0ef          	jal	28a <memmove>
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 334:	4885                	li	a7,1
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exit>:
.global exit
exit:
 li a7, SYS_exit
 33c:	4889                	li	a7,2
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <wait>:
.global wait
wait:
 li a7, SYS_wait
 344:	488d                	li	a7,3
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 34c:	4891                	li	a7,4
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <read>:
.global read
read:
 li a7, SYS_read
 354:	4895                	li	a7,5
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <kill>:
.global kill
kill:
 li a7, SYS_kill
 35c:	4899                	li	a7,6
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exec>:
.global exec
exec:
 li a7, SYS_exec
 364:	489d                	li	a7,7
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <open>:
.global open
open:
 li a7, SYS_open
 3a4:	48bd                	li	a7,15
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b4:	48c5                	li	a7,17
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3bc:	48c9                	li	a7,18
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <link>:
.global link
link:
 li a7, SYS_link
 3c4:	48cd                	li	a7,19
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3cc:	48d1                	li	a7,20
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3dc:	48d9                	li	a7,22
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3e4:	48dd                	li	a7,23
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 3ec:	48e1                	li	a7,24
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3f4:	48e5                	li	a7,25
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fc:	1101                	addi	sp,sp,-32
 3fe:	ec06                	sd	ra,24(sp)
 400:	e822                	sd	s0,16(sp)
 402:	1000                	addi	s0,sp,32
 404:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 408:	4605                	li	a2,1
 40a:	fef40593          	addi	a1,s0,-17
 40e:	f9fff0ef          	jal	3ac <write>
}
 412:	60e2                	ld	ra,24(sp)
 414:	6442                	ld	s0,16(sp)
 416:	6105                	addi	sp,sp,32
 418:	8082                	ret

000000000000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	7139                	addi	sp,sp,-64
 41c:	fc06                	sd	ra,56(sp)
 41e:	f822                	sd	s0,48(sp)
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	0080                	addi	s0,sp,64
 426:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 428:	cac9                	beqz	a3,4ba <printint+0xa0>
 42a:	01f5d79b          	srliw	a5,a1,0x1f
 42e:	c7d1                	beqz	a5,4ba <printint+0xa0>
    neg = 1;
    x = -xx;
 430:	40b005bb          	negw	a1,a1
    neg = 1;
 434:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 436:	fc040993          	addi	s3,s0,-64
  neg = 0;
 43a:	86ce                	mv	a3,s3
  i = 0;
 43c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43e:	00000817          	auipc	a6,0x0
 442:	5b280813          	addi	a6,a6,1458 # 9f0 <digits>
 446:	88ba                	mv	a7,a4
 448:	0017051b          	addiw	a0,a4,1
 44c:	872a                	mv	a4,a0
 44e:	02c5f7bb          	remuw	a5,a1,a2
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	97c2                	add	a5,a5,a6
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 460:	87ae                	mv	a5,a1
 462:	02c5d5bb          	divuw	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fcc7ffe3          	bgeu	a5,a2,446 <printint+0x2c>
  if(neg)
 46c:	00030c63          	beqz	t1,484 <printint+0x6a>
    buf[i++] = '-';
 470:	fd050793          	addi	a5,a0,-48
 474:	00878533          	add	a0,a5,s0
 478:	02d00793          	li	a5,45
 47c:	fef50823          	sb	a5,-16(a0)
 480:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 484:	02e05563          	blez	a4,4ae <printint+0x94>
 488:	f426                	sd	s1,40(sp)
 48a:	377d                	addiw	a4,a4,-1
 48c:	00e984b3          	add	s1,s3,a4
 490:	19fd                	addi	s3,s3,-1
 492:	99ba                	add	s3,s3,a4
 494:	1702                	slli	a4,a4,0x20
 496:	9301                	srli	a4,a4,0x20
 498:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49c:	0004c583          	lbu	a1,0(s1)
 4a0:	854a                	mv	a0,s2
 4a2:	f5bff0ef          	jal	3fc <putc>
  while(--i >= 0)
 4a6:	14fd                	addi	s1,s1,-1
 4a8:	ff349ae3          	bne	s1,s3,49c <printint+0x82>
 4ac:	74a2                	ld	s1,40(sp)
}
 4ae:	70e2                	ld	ra,56(sp)
 4b0:	7442                	ld	s0,48(sp)
 4b2:	7902                	ld	s2,32(sp)
 4b4:	69e2                	ld	s3,24(sp)
 4b6:	6121                	addi	sp,sp,64
 4b8:	8082                	ret
  neg = 0;
 4ba:	4301                	li	t1,0
 4bc:	bfad                	j	436 <printint+0x1c>

00000000000004be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4be:	711d                	addi	sp,sp,-96
 4c0:	ec86                	sd	ra,88(sp)
 4c2:	e8a2                	sd	s0,80(sp)
 4c4:	e4a6                	sd	s1,72(sp)
 4c6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c8:	0005c483          	lbu	s1,0(a1)
 4cc:	20048963          	beqz	s1,6de <vprintf+0x220>
 4d0:	e0ca                	sd	s2,64(sp)
 4d2:	fc4e                	sd	s3,56(sp)
 4d4:	f852                	sd	s4,48(sp)
 4d6:	f456                	sd	s5,40(sp)
 4d8:	f05a                	sd	s6,32(sp)
 4da:	ec5e                	sd	s7,24(sp)
 4dc:	e862                	sd	s8,16(sp)
 4de:	8b2a                	mv	s6,a0
 4e0:	8a2e                	mv	s4,a1
 4e2:	8bb2                	mv	s7,a2
  state = 0;
 4e4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e6:	4901                	li	s2,0
 4e8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ea:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ee:	06400c13          	li	s8,100
 4f2:	a00d                	j	514 <vprintf+0x56>
        putc(fd, c0);
 4f4:	85a6                	mv	a1,s1
 4f6:	855a                	mv	a0,s6
 4f8:	f05ff0ef          	jal	3fc <putc>
 4fc:	a019                	j	502 <vprintf+0x44>
    } else if(state == '%'){
 4fe:	03598363          	beq	s3,s5,524 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 502:	0019079b          	addiw	a5,s2,1
 506:	893e                	mv	s2,a5
 508:	873e                	mv	a4,a5
 50a:	97d2                	add	a5,a5,s4
 50c:	0007c483          	lbu	s1,0(a5)
 510:	1c048063          	beqz	s1,6d0 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 514:	0004879b          	sext.w	a5,s1
    if(state == 0){
 518:	fe0993e3          	bnez	s3,4fe <vprintf+0x40>
      if(c0 == '%'){
 51c:	fd579ce3          	bne	a5,s5,4f4 <vprintf+0x36>
        state = '%';
 520:	89be                	mv	s3,a5
 522:	b7c5                	j	502 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 524:	00ea06b3          	add	a3,s4,a4
 528:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 52c:	1a060e63          	beqz	a2,6e8 <vprintf+0x22a>
      if(c0 == 'd'){
 530:	03878763          	beq	a5,s8,55e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 534:	f9478693          	addi	a3,a5,-108
 538:	0016b693          	seqz	a3,a3
 53c:	f9c60593          	addi	a1,a2,-100
 540:	e99d                	bnez	a1,576 <vprintf+0xb8>
 542:	ca95                	beqz	a3,576 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	008b8493          	addi	s1,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	ec9ff0ef          	jal	41a <printint>
        i += 1;
 556:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 558:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b75d                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 55e:	008b8493          	addi	s1,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	eafff0ef          	jal	41a <printint>
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
 574:	b779                	j	502 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 576:	9752                	add	a4,a4,s4
 578:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 57c:	f9460713          	addi	a4,a2,-108
 580:	00173713          	seqz	a4,a4
 584:	8f75                	and	a4,a4,a3
 586:	f9c58513          	addi	a0,a1,-100
 58a:	16051963          	bnez	a0,6fc <vprintf+0x23e>
 58e:	16070763          	beqz	a4,6fc <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e7bff0ef          	jal	41a <printint>
        i += 2;
 5a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
        i += 2;
 5aa:	bfa1                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e61ff0ef          	jal	41a <printint>
 5be:	8ba6                	mv	s7,s1
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b781                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e49ff0ef          	jal	41a <printint>
        i += 1;
 5d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b71d                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e2fff0ef          	jal	41a <printint>
        i += 2;
 5f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	b731                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e15ff0ef          	jal	41a <printint>
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bdd5                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dfdff0ef          	jal	41a <printint>
        i += 1;
 622:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	bde9                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	de3ff0ef          	jal	41a <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b5c1                	j	502 <vprintf+0x44>
 644:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 646:	008b8793          	addi	a5,s7,8
 64a:	8cbe                	mv	s9,a5
 64c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 650:	03000593          	li	a1,48
 654:	855a                	mv	a0,s6
 656:	da7ff0ef          	jal	3fc <putc>
  putc(fd, 'x');
 65a:	07800593          	li	a1,120
 65e:	855a                	mv	a0,s6
 660:	d9dff0ef          	jal	3fc <putc>
 664:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	38ab8b93          	addi	s7,s7,906 # 9f0 <digits>
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	855a                	mv	a0,s6
 67a:	d83ff0ef          	jal	3fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67e:	0992                	slli	s3,s3,0x4
 680:	34fd                	addiw	s1,s1,-1
 682:	f4f5                	bnez	s1,66e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 684:	8be6                	mv	s7,s9
      state = 0;
 686:	4981                	li	s3,0
 688:	6ca2                	ld	s9,8(sp)
 68a:	bda5                	j	502 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 68c:	008b8993          	addi	s3,s7,8
 690:	000bb483          	ld	s1,0(s7)
 694:	cc91                	beqz	s1,6b0 <vprintf+0x1f2>
        for(; *s; s++)
 696:	0004c583          	lbu	a1,0(s1)
 69a:	c985                	beqz	a1,6ca <vprintf+0x20c>
          putc(fd, *s);
 69c:	855a                	mv	a0,s6
 69e:	d5fff0ef          	jal	3fc <putc>
        for(; *s; s++)
 6a2:	0485                	addi	s1,s1,1
 6a4:	0004c583          	lbu	a1,0(s1)
 6a8:	f9f5                	bnez	a1,69c <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 6aa:	8bce                	mv	s7,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bd91                	j	502 <vprintf+0x44>
          s = "(null)";
 6b0:	00000497          	auipc	s1,0x0
 6b4:	33848493          	addi	s1,s1,824 # 9e8 <malloc+0x1a4>
        for(; *s; s++)
 6b8:	02800593          	li	a1,40
 6bc:	b7c5                	j	69c <vprintf+0x1de>
        putc(fd, '%');
 6be:	85be                	mv	a1,a5
 6c0:	855a                	mv	a0,s6
 6c2:	d3bff0ef          	jal	3fc <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd2d                	j	502 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd15                	j	502 <vprintf+0x44>
 6d0:	6906                	ld	s2,64(sp)
 6d2:	79e2                	ld	s3,56(sp)
 6d4:	7a42                	ld	s4,48(sp)
 6d6:	7aa2                	ld	s5,40(sp)
 6d8:	7b02                	ld	s6,32(sp)
 6da:	6be2                	ld	s7,24(sp)
 6dc:	6c42                	ld	s8,16(sp)
    }
  }
}
 6de:	60e6                	ld	ra,88(sp)
 6e0:	6446                	ld	s0,80(sp)
 6e2:	64a6                	ld	s1,72(sp)
 6e4:	6125                	addi	sp,sp,96
 6e6:	8082                	ret
      if(c0 == 'd'){
 6e8:	06400713          	li	a4,100
 6ec:	e6e789e3          	beq	a5,a4,55e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	f9478693          	addi	a3,a5,-108
 6f4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6f8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fa:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6fc:	07500513          	li	a0,117
 700:	eaa786e3          	beq	a5,a0,5ac <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 704:	f8b60513          	addi	a0,a2,-117
 708:	e119                	bnez	a0,70e <vprintf+0x250>
 70a:	ea069de3          	bnez	a3,5c4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 70e:	f8b58513          	addi	a0,a1,-117
 712:	e119                	bnez	a0,718 <vprintf+0x25a>
 714:	ec0715e3          	bnez	a4,5de <vprintf+0x120>
      } else if(c0 == 'x'){
 718:	07800513          	li	a0,120
 71c:	eca78ee3          	beq	a5,a0,5f8 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 720:	f8860613          	addi	a2,a2,-120
 724:	e219                	bnez	a2,72a <vprintf+0x26c>
 726:	ee0695e3          	bnez	a3,610 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 72a:	f8858593          	addi	a1,a1,-120
 72e:	e199                	bnez	a1,734 <vprintf+0x276>
 730:	ee071de3          	bnez	a4,62a <vprintf+0x16c>
      } else if(c0 == 'p'){
 734:	07000713          	li	a4,112
 738:	f0e786e3          	beq	a5,a4,644 <vprintf+0x186>
      } else if(c0 == 's'){
 73c:	07300713          	li	a4,115
 740:	f4e786e3          	beq	a5,a4,68c <vprintf+0x1ce>
      } else if(c0 == '%'){
 744:	02500713          	li	a4,37
 748:	f6e78be3          	beq	a5,a4,6be <vprintf+0x200>
        putc(fd, '%');
 74c:	02500593          	li	a1,37
 750:	855a                	mv	a0,s6
 752:	cabff0ef          	jal	3fc <putc>
        putc(fd, c0);
 756:	85a6                	mv	a1,s1
 758:	855a                	mv	a0,s6
 75a:	ca3ff0ef          	jal	3fc <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	b34d                	j	502 <vprintf+0x44>

0000000000000762 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 762:	715d                	addi	sp,sp,-80
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e010                	sd	a2,0(s0)
 76c:	e414                	sd	a3,8(s0)
 76e:	e818                	sd	a4,16(s0)
 770:	ec1c                	sd	a5,24(s0)
 772:	03043023          	sd	a6,32(s0)
 776:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	8622                	mv	a2,s0
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	d3fff0ef          	jal	4be <vprintf>
}
 784:	60e2                	ld	ra,24(sp)
 786:	6442                	ld	s0,16(sp)
 788:	6161                	addi	sp,sp,80
 78a:	8082                	ret

000000000000078c <printf>:

void
printf(const char *fmt, ...)
{
 78c:	711d                	addi	sp,sp,-96
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e40c                	sd	a1,8(s0)
 796:	e810                	sd	a2,16(s0)
 798:	ec14                	sd	a3,24(s0)
 79a:	f018                	sd	a4,32(s0)
 79c:	f41c                	sd	a5,40(s0)
 79e:	03043823          	sd	a6,48(s0)
 7a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	00840613          	addi	a2,s0,8
 7aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ae:	85aa                	mv	a1,a0
 7b0:	4505                	li	a0,1
 7b2:	d0dff0ef          	jal	4be <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6125                	addi	sp,sp,96
 7bc:	8082                	ret

00000000000007be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7be:	1141                	addi	sp,sp,-16
 7c0:	e406                	sd	ra,8(sp)
 7c2:	e022                	sd	s0,0(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a039                	j	7e0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e7e463          	bltu	a5,a4,7de <free+0x20>
 7da:	00e6ea63          	bltu	a3,a4,7ee <free+0x30>
{
 7de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	fed7fae3          	bgeu	a5,a3,7d4 <free+0x16>
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e6e463          	bltu	a3,a4,7ee <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	fee7eae3          	bltu	a5,a4,7de <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ee:	ff852583          	lw	a1,-8(a0)
 7f2:	6390                	ld	a2,0(a5)
 7f4:	02059813          	slli	a6,a1,0x20
 7f8:	01c85713          	srli	a4,a6,0x1c
 7fc:	9736                	add	a4,a4,a3
 7fe:	02e60563          	beq	a2,a4,828 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 806:	4790                	lw	a2,8(a5)
 808:	02061593          	slli	a1,a2,0x20
 80c:	01c5d713          	srli	a4,a1,0x1c
 810:	973e                	add	a4,a4,a5
 812:	02e68263          	beq	a3,a4,836 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 816:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
}
 820:	60a2                	ld	ra,8(sp)
 822:	6402                	ld	s0,0(sp)
 824:	0141                	addi	sp,sp,16
 826:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 828:	4618                	lw	a4,8(a2)
 82a:	9f2d                	addw	a4,a4,a1
 82c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	6310                	ld	a2,0(a4)
 834:	b7f9                	j	802 <free+0x44>
    p->s.size += bp->s.size;
 836:	ff852703          	lw	a4,-8(a0)
 83a:	9f31                	addw	a4,a4,a2
 83c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83e:	ff053683          	ld	a3,-16(a0)
 842:	bfd1                	j	816 <free+0x58>

0000000000000844 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f04a                	sd	s2,32(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051993          	slli	s3,a0,0x20
 854:	0209d993          	srli	s3,s3,0x20
 858:	09bd                	addi	s3,s3,15
 85a:	0049d993          	srli	s3,s3,0x4
 85e:	2985                	addiw	s3,s3,1
 860:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 862:	00000517          	auipc	a0,0x0
 866:	79e53503          	ld	a0,1950(a0) # 1000 <freep>
 86a:	c905                	beqz	a0,89a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	09377663          	bgeu	a4,s3,8fc <malloc+0xb8>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	6705                	lui	a4,0x1
 880:	00e9f363          	bgeu	s3,a4,886 <malloc+0x42>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88e:	00000497          	auipc	s1,0x0
 892:	77248493          	addi	s1,s1,1906 # 1000 <freep>
  if(p == (char*)-1)
 896:	5afd                	li	s5,-1
 898:	a83d                	j	8d6 <malloc+0x92>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b8:	b7d1                	j	87c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a899                	j	914 <malloc+0xd0>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	ef9ff0ef          	jal	7be <free>
  return freep;
 8ca:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8cc:	c125                	beqz	a0,92c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	03277163          	bgeu	a4,s2,8f4 <malloc+0xb0>
    if(p == freep)
 8d6:	6098                	ld	a4,0(s1)
 8d8:	853e                	mv	a0,a5
 8da:	fef71ae3          	bne	a4,a5,8ce <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	aadff0ef          	jal	38c <sbrk>
  if(p == (char*)-1)
 8e4:	fd551ee3          	bne	a0,s5,8c0 <malloc+0x7c>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	a03d                	j	920 <malloc+0xdc>
 8f4:	74a2                	ld	s1,40(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fc:	fae90fe3          	beq	s2,a4,8ba <malloc+0x76>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	slli	a3,a4,0x20
 90a:	01c6d713          	srli	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void*)(p + 1);
 91c:	01078513          	addi	a0,a5,16
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	7902                	ld	s2,32(sp)
 926:	69e2                	ld	s3,24(sp)
 928:	6121                	addi	sp,sp,64
 92a:	8082                	ret
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	b7f5                	j	920 <malloc+0xdc>
