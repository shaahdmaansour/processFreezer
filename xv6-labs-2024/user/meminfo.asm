
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
   8:	3f6000ef          	jal	3fe <meminfo>
  
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
  34:	92050513          	addi	a0,a0,-1760 # 950 <malloc+0x130>
  38:	730000ef          	jal	768 <printf>
  printf("Total Memory: %d bytes\n", (int)total_bytes);
  3c:	0009859b          	sext.w	a1,s3
  40:	00001517          	auipc	a0,0x1
  44:	92850513          	addi	a0,a0,-1752 # 968 <malloc+0x148>
  48:	720000ef          	jal	768 <printf>
  printf("Used Memory:  %d bytes\n", (int)used_bytes);
  4c:	000a059b          	sext.w	a1,s4
  50:	00001517          	auipc	a0,0x1
  54:	93050513          	addi	a0,a0,-1744 # 980 <malloc+0x160>
  58:	710000ef          	jal	768 <printf>
  printf("Free Memory:  %d bytes\n", (int)free_bytes);
  5c:	0004859b          	sext.w	a1,s1
  60:	00001517          	auipc	a0,0x1
  64:	93850513          	addi	a0,a0,-1736 # 998 <malloc+0x178>
  68:	700000ef          	jal	768 <printf>
  
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
  86:	92e50513          	addi	a0,a0,-1746 # 9b0 <malloc+0x190>
  8a:	6de000ef          	jal	768 <printf>

  exit(0);
  8e:	4501                	li	a0,0
  90:	2be000ef          	jal	34e <exit>
  94:	ec26                	sd	s1,24(sp)
  96:	e84a                	sd	s2,16(sp)
  98:	e44e                	sd	s3,8(sp)
  9a:	e052                	sd	s4,0(sp)
    fprintf(2, "meminfo: failed to get memory statistics\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	88458593          	addi	a1,a1,-1916 # 920 <malloc+0x100>
  a4:	4509                	li	a0,2
  a6:	698000ef          	jal	73e <fprintf>
    exit(1);
  aa:	4505                	li	a0,1
  ac:	2a2000ef          	jal	34e <exit>

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
  be:	290000ef          	jal	34e <exit>

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
 11e:	cf99                	beqz	a5,13c <strlen+0x2a>
 120:	0505                	addi	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	86be                	mv	a3,a5
 126:	0785                	addi	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x12>
 12e:	40a6853b          	subw	a0,a3,a0
 132:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  for(n = 0; s[n]; n++)
 13c:	4501                	li	a0,0
 13e:	bfdd                	j	134 <strlen+0x22>

0000000000000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	1141                	addi	sp,sp,-16
 142:	e406                	sd	ra,8(sp)
 144:	e022                	sd	s0,0(sp)
 146:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 148:	ca19                	beqz	a2,15e <memset+0x1e>
 14a:	87aa                	mv	a5,a0
 14c:	1602                	slli	a2,a2,0x20
 14e:	9201                	srli	a2,a2,0x20
 150:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 154:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 158:	0785                	addi	a5,a5,1
 15a:	fee79de3          	bne	a5,a4,154 <memset+0x14>
  }
  return dst;
}
 15e:	60a2                	ld	ra,8(sp)
 160:	6402                	ld	s0,0(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	1141                	addi	sp,sp,-16
 168:	e406                	sd	ra,8(sp)
 16a:	e022                	sd	s0,0(sp)
 16c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cf81                	beqz	a5,18a <strchr+0x24>
    if(*s == c)
 174:	00f58763          	beq	a1,a5,182 <strchr+0x1c>
  for(; *s; s++)
 178:	0505                	addi	a0,a0,1
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbfd                	bnez	a5,174 <strchr+0xe>
      return (char*)s;
  return 0;
 180:	4501                	li	a0,0
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  return 0;
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strchr+0x1c>

000000000000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	7159                	addi	sp,sp,-112
 190:	f486                	sd	ra,104(sp)
 192:	f0a2                	sd	s0,96(sp)
 194:	eca6                	sd	s1,88(sp)
 196:	e8ca                	sd	s2,80(sp)
 198:	e4ce                	sd	s3,72(sp)
 19a:	e0d2                	sd	s4,64(sp)
 19c:	fc56                	sd	s5,56(sp)
 19e:	f85a                	sd	s6,48(sp)
 1a0:	f45e                	sd	s7,40(sp)
 1a2:	f062                	sd	s8,32(sp)
 1a4:	ec66                	sd	s9,24(sp)
 1a6:	e86a                	sd	s10,16(sp)
 1a8:	1880                	addi	s0,sp,112
 1aa:	8caa                	mv	s9,a0
 1ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ae:	892a                	mv	s2,a0
 1b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b2:	f9f40b13          	addi	s6,s0,-97
 1b6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b8:	4ba9                	li	s7,10
 1ba:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1bc:	8d26                	mv	s10,s1
 1be:	0014899b          	addiw	s3,s1,1
 1c2:	84ce                	mv	s1,s3
 1c4:	0349d563          	bge	s3,s4,1ee <gets+0x60>
    cc = read(0, &c, 1);
 1c8:	8656                	mv	a2,s5
 1ca:	85da                	mv	a1,s6
 1cc:	4501                	li	a0,0
 1ce:	198000ef          	jal	366 <read>
    if(cc < 1)
 1d2:	00a05e63          	blez	a0,1ee <gets+0x60>
    buf[i++] = c;
 1d6:	f9f44783          	lbu	a5,-97(s0)
 1da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1de:	01778763          	beq	a5,s7,1ec <gets+0x5e>
 1e2:	0905                	addi	s2,s2,1
 1e4:	fd879ce3          	bne	a5,s8,1bc <gets+0x2e>
    buf[i++] = c;
 1e8:	8d4e                	mv	s10,s3
 1ea:	a011                	j	1ee <gets+0x60>
 1ec:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1ee:	9d66                	add	s10,s10,s9
 1f0:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1f4:	8566                	mv	a0,s9
 1f6:	70a6                	ld	ra,104(sp)
 1f8:	7406                	ld	s0,96(sp)
 1fa:	64e6                	ld	s1,88(sp)
 1fc:	6946                	ld	s2,80(sp)
 1fe:	69a6                	ld	s3,72(sp)
 200:	6a06                	ld	s4,64(sp)
 202:	7ae2                	ld	s5,56(sp)
 204:	7b42                	ld	s6,48(sp)
 206:	7ba2                	ld	s7,40(sp)
 208:	7c02                	ld	s8,32(sp)
 20a:	6ce2                	ld	s9,24(sp)
 20c:	6d42                	ld	s10,16(sp)
 20e:	6165                	addi	sp,sp,112
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	196000ef          	jal	3b6 <open>
  if(fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	150000ef          	jal	37e <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	1b0000ef          	jal	3e6 <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 254:	00054683          	lbu	a3,0(a0)
 258:	fd06879b          	addiw	a5,a3,-48
 25c:	0ff7f793          	zext.b	a5,a5
 260:	4625                	li	a2,9
 262:	02f66963          	bltu	a2,a5,294 <atoi+0x48>
 266:	872a                	mv	a4,a0
  n = 0;
 268:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 26a:	0705                	addi	a4,a4,1
 26c:	0025179b          	slliw	a5,a0,0x2
 270:	9fa9                	addw	a5,a5,a0
 272:	0017979b          	slliw	a5,a5,0x1
 276:	9fb5                	addw	a5,a5,a3
 278:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27c:	00074683          	lbu	a3,0(a4)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	fef671e3          	bgeu	a2,a5,26a <atoi+0x1e>
  return n;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  n = 0;
 294:	4501                	li	a0,0
 296:	bfdd                	j	28c <atoi+0x40>

0000000000000298 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57563          	bgeu	a0,a1,2ca <memmove+0x32>
    while(n-- > 0)
 2a4:	00c05f63          	blez	a2,2c2 <memmove+0x2a>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b2:	0585                	addi	a1,a1,1
 2b4:	0705                	addi	a4,a4,1
 2b6:	fff5c683          	lbu	a3,-1(a1)
 2ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2be:	fee79ae3          	bne	a5,a4,2b2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
    dst += n;
 2ca:	00c50733          	add	a4,a0,a2
    src += n;
 2ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d0:	fec059e3          	blez	a2,2c2 <memmove+0x2a>
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	fff7c793          	not	a5,a5
 2e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e2:	15fd                	addi	a1,a1,-1
 2e4:	177d                	addi	a4,a4,-1
 2e6:	0005c683          	lbu	a3,0(a1)
 2ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ee:	fef71ae3          	bne	a4,a5,2e2 <memmove+0x4a>
 2f2:	bfc1                	j	2c2 <memmove+0x2a>

00000000000002f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ca0d                	beqz	a2,32e <memcmp+0x3a>
 2fe:	fff6069b          	addiw	a3,a2,-1
 302:	1682                	slli	a3,a3,0x20
 304:	9281                	srli	a3,a3,0x20
 306:	0685                	addi	a3,a3,1
 308:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30a:	00054783          	lbu	a5,0(a0)
 30e:	0005c703          	lbu	a4,0(a1)
 312:	00e79863          	bne	a5,a4,322 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 316:	0505                	addi	a0,a0,1
    p2++;
 318:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31a:	fed518e3          	bne	a0,a3,30a <memcmp+0x16>
  }
  return 0;
 31e:	4501                	li	a0,0
 320:	a019                	j	326 <memcmp+0x32>
      return *p1 - *p2;
 322:	40e7853b          	subw	a0,a5,a4
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfdd                	j	326 <memcmp+0x32>

0000000000000332 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33a:	f5fff0ef          	jal	298 <memmove>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 346:	4885                	li	a7,1
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exit>:
.global exit
exit:
 li a7, SYS_exit
 34e:	4889                	li	a7,2
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <wait>:
.global wait
wait:
 li a7, SYS_wait
 356:	488d                	li	a7,3
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35e:	4891                	li	a7,4
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <read>:
.global read
read:
 li a7, SYS_read
 366:	4895                	li	a7,5
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <kill>:
.global kill
kill:
 li a7, SYS_kill
 36e:	4899                	li	a7,6
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <exec>:
.global exec
exec:
 li a7, SYS_exec
 376:	489d                	li	a7,7
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37e:	48a1                	li	a7,8
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 386:	48a5                	li	a7,9
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <dup>:
.global dup
dup:
 li a7, SYS_dup
 38e:	48a9                	li	a7,10
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 396:	48ad                	li	a7,11
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39e:	48b1                	li	a7,12
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a6:	48b5                	li	a7,13
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ae:	48b9                	li	a7,14
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <open>:
.global open
open:
 li a7, SYS_open
 3b6:	48bd                	li	a7,15
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <link>:
.global link
link:
 li a7, SYS_link
 3d6:	48cd                	li	a7,19
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3de:	48d1                	li	a7,20
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <close>:
.global close
close:
 li a7, SYS_close
 3e6:	48d5                	li	a7,21
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 3ee:	48d9                	li	a7,22
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 3f6:	48dd                	li	a7,23
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 3fe:	48e1                	li	a7,24
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	fa7ff0ef          	jal	3be <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	7139                	addi	sp,sp,-64
 426:	fc06                	sd	ra,56(sp)
 428:	f822                	sd	s0,48(sp)
 42a:	f426                	sd	s1,40(sp)
 42c:	f04a                	sd	s2,32(sp)
 42e:	ec4e                	sd	s3,24(sp)
 430:	0080                	addi	s0,sp,64
 432:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 434:	c299                	beqz	a3,43a <printint+0x16>
 436:	0605ce63          	bltz	a1,4b2 <printint+0x8e>
  neg = 0;
 43a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 43c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 440:	869a                	mv	a3,t1
  i = 0;
 442:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 444:	00000817          	auipc	a6,0x0
 448:	58c80813          	addi	a6,a6,1420 # 9d0 <digits>
 44c:	88be                	mv	a7,a5
 44e:	0017851b          	addiw	a0,a5,1
 452:	87aa                	mv	a5,a0
 454:	02c5f73b          	remuw	a4,a1,a2
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	9742                	add	a4,a4,a6
 45e:	00074703          	lbu	a4,0(a4)
 462:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 466:	872e                	mv	a4,a1
 468:	02c5d5bb          	divuw	a1,a1,a2
 46c:	0685                	addi	a3,a3,1
 46e:	fcc77fe3          	bgeu	a4,a2,44c <printint+0x28>
  if(neg)
 472:	000e0c63          	beqz	t3,48a <printint+0x66>
    buf[i++] = '-';
 476:	fd050793          	addi	a5,a0,-48
 47a:	00878533          	add	a0,a5,s0
 47e:	02d00793          	li	a5,45
 482:	fef50823          	sb	a5,-16(a0)
 486:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 48a:	fff7899b          	addiw	s3,a5,-1
 48e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 492:	fff4c583          	lbu	a1,-1(s1)
 496:	854a                	mv	a0,s2
 498:	f6fff0ef          	jal	406 <putc>
  while(--i >= 0)
 49c:	39fd                	addiw	s3,s3,-1
 49e:	14fd                	addi	s1,s1,-1
 4a0:	fe09d9e3          	bgez	s3,492 <printint+0x6e>
}
 4a4:	70e2                	ld	ra,56(sp)
 4a6:	7442                	ld	s0,48(sp)
 4a8:	74a2                	ld	s1,40(sp)
 4aa:	7902                	ld	s2,32(sp)
 4ac:	69e2                	ld	s3,24(sp)
 4ae:	6121                	addi	sp,sp,64
 4b0:	8082                	ret
    x = -xx;
 4b2:	40b005bb          	negw	a1,a1
    neg = 1;
 4b6:	4e05                	li	t3,1
    x = -xx;
 4b8:	b751                	j	43c <printint+0x18>

00000000000004ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ba:	711d                	addi	sp,sp,-96
 4bc:	ec86                	sd	ra,88(sp)
 4be:	e8a2                	sd	s0,80(sp)
 4c0:	e4a6                	sd	s1,72(sp)
 4c2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c4:	0005c483          	lbu	s1,0(a1)
 4c8:	26048663          	beqz	s1,734 <vprintf+0x27a>
 4cc:	e0ca                	sd	s2,64(sp)
 4ce:	fc4e                	sd	s3,56(sp)
 4d0:	f852                	sd	s4,48(sp)
 4d2:	f456                	sd	s5,40(sp)
 4d4:	f05a                	sd	s6,32(sp)
 4d6:	ec5e                	sd	s7,24(sp)
 4d8:	e862                	sd	s8,16(sp)
 4da:	e466                	sd	s9,8(sp)
 4dc:	8b2a                	mv	s6,a0
 4de:	8a2e                	mv	s4,a1
 4e0:	8bb2                	mv	s7,a2
  state = 0;
 4e2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e4:	4901                	li	s2,0
 4e6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ec:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f0:	06c00c93          	li	s9,108
 4f4:	a00d                	j	516 <vprintf+0x5c>
        putc(fd, c0);
 4f6:	85a6                	mv	a1,s1
 4f8:	855a                	mv	a0,s6
 4fa:	f0dff0ef          	jal	406 <putc>
 4fe:	a019                	j	504 <vprintf+0x4a>
    } else if(state == '%'){
 500:	03598363          	beq	s3,s5,526 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 504:	0019079b          	addiw	a5,s2,1
 508:	893e                	mv	s2,a5
 50a:	873e                	mv	a4,a5
 50c:	97d2                	add	a5,a5,s4
 50e:	0007c483          	lbu	s1,0(a5)
 512:	20048963          	beqz	s1,724 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 516:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51a:	fe0993e3          	bnez	s3,500 <vprintf+0x46>
      if(c0 == '%'){
 51e:	fd579ce3          	bne	a5,s5,4f6 <vprintf+0x3c>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7c5                	j	504 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 526:	00ea06b3          	add	a3,s4,a4
 52a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 52e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 530:	c681                	beqz	a3,538 <vprintf+0x7e>
 532:	9752                	add	a4,a4,s4
 534:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 538:	03878e63          	beq	a5,s8,574 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	05978863          	beq	a5,s9,58c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 540:	07500713          	li	a4,117
 544:	0ee78263          	beq	a5,a4,628 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 548:	07800713          	li	a4,120
 54c:	12e78463          	beq	a5,a4,674 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 550:	07000713          	li	a4,112
 554:	14e78963          	beq	a5,a4,6a6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 558:	07300713          	li	a4,115
 55c:	18e78863          	beq	a5,a4,6ec <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 560:	02500713          	li	a4,37
 564:	04e79463          	bne	a5,a4,5ac <vprintf+0xf2>
        putc(fd, '%');
 568:	85ba                	mv	a1,a4
 56a:	855a                	mv	a0,s6
 56c:	e9bff0ef          	jal	406 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 570:	4981                	li	s3,0
 572:	bf49                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b8493          	addi	s1,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	ea3ff0ef          	jal	424 <printint>
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	bfad                	j	504 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	06400793          	li	a5,100
 590:	02f68963          	beq	a3,a5,5c2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 594:	06c00793          	li	a5,108
 598:	04f68263          	beq	a3,a5,5dc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 59c:	07500793          	li	a5,117
 5a0:	0af68063          	beq	a3,a5,640 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5a4:	07800793          	li	a5,120
 5a8:	0ef68263          	beq	a3,a5,68c <vprintf+0x1d2>
        putc(fd, '%');
 5ac:	02500593          	li	a1,37
 5b0:	855a                	mv	a0,s6
 5b2:	e55ff0ef          	jal	406 <putc>
        putc(fd, c0);
 5b6:	85a6                	mv	a1,s1
 5b8:	855a                	mv	a0,s6
 5ba:	e4dff0ef          	jal	406 <putc>
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b791                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e55ff0ef          	jal	424 <printint>
        i += 1;
 5d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
        i += 1;
 5da:	b72d                	j	504 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	06400793          	li	a5,100
 5e0:	02f60763          	beq	a2,a5,60e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e4:	07500793          	li	a5,117
 5e8:	06f60963          	beq	a2,a5,65a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	faf61ee3          	bne	a2,a5,5ac <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e23ff0ef          	jal	424 <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bde5                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8493          	addi	s1,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e09ff0ef          	jal	424 <printint>
        i += 2;
 620:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bdf9                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	defff0ef          	jal	424 <printint>
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b5d9                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	dd7ff0ef          	jal	424 <printint>
        i += 1;
 652:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	b575                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	dbdff0ef          	jal	424 <printint>
        i += 2;
 66c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bd49                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4681                	li	a3,0
 67a:	4641                	li	a2,16
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	da3ff0ef          	jal	424 <printint>
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
 68a:	bdad                	j	504 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8493          	addi	s1,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000ba583          	lw	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d8bff0ef          	jal	424 <printint>
        i += 1;
 69e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	b585                	j	504 <vprintf+0x4a>
 6a6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b8d13          	addi	s10,s7,8
 6ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b0:	03000593          	li	a1,48
 6b4:	855a                	mv	a0,s6
 6b6:	d51ff0ef          	jal	406 <putc>
  putc(fd, 'x');
 6ba:	07800593          	li	a1,120
 6be:	855a                	mv	a0,s6
 6c0:	d47ff0ef          	jal	406 <putc>
 6c4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	30ab8b93          	addi	s7,s7,778 # 9d0 <digits>
 6ce:	03c9d793          	srli	a5,s3,0x3c
 6d2:	97de                	add	a5,a5,s7
 6d4:	0007c583          	lbu	a1,0(a5)
 6d8:	855a                	mv	a0,s6
 6da:	d2dff0ef          	jal	406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6de:	0992                	slli	s3,s3,0x4
 6e0:	34fd                	addiw	s1,s1,-1
 6e2:	f4f5                	bnez	s1,6ce <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e4:	8bea                	mv	s7,s10
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	6d02                	ld	s10,0(sp)
 6ea:	bd29                	j	504 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ec:	008b8993          	addi	s3,s7,8
 6f0:	000bb483          	ld	s1,0(s7)
 6f4:	cc91                	beqz	s1,710 <vprintf+0x256>
        for(; *s; s++)
 6f6:	0004c583          	lbu	a1,0(s1)
 6fa:	c195                	beqz	a1,71e <vprintf+0x264>
          putc(fd, *s);
 6fc:	855a                	mv	a0,s6
 6fe:	d09ff0ef          	jal	406 <putc>
        for(; *s; s++)
 702:	0485                	addi	s1,s1,1
 704:	0004c583          	lbu	a1,0(s1)
 708:	f9f5                	bnez	a1,6fc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bbdd                	j	504 <vprintf+0x4a>
          s = "(null)";
 710:	00000497          	auipc	s1,0x0
 714:	2b848493          	addi	s1,s1,696 # 9c8 <malloc+0x1a8>
        for(; *s; s++)
 718:	02800593          	li	a1,40
 71c:	b7c5                	j	6fc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b3cd                	j	504 <vprintf+0x4a>
 724:	6906                	ld	s2,64(sp)
 726:	79e2                	ld	s3,56(sp)
 728:	7a42                	ld	s4,48(sp)
 72a:	7aa2                	ld	s5,40(sp)
 72c:	7b02                	ld	s6,32(sp)
 72e:	6be2                	ld	s7,24(sp)
 730:	6c42                	ld	s8,16(sp)
 732:	6ca2                	ld	s9,8(sp)
    }
  }
}
 734:	60e6                	ld	ra,88(sp)
 736:	6446                	ld	s0,80(sp)
 738:	64a6                	ld	s1,72(sp)
 73a:	6125                	addi	sp,sp,96
 73c:	8082                	ret

000000000000073e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73e:	715d                	addi	sp,sp,-80
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	e010                	sd	a2,0(s0)
 748:	e414                	sd	a3,8(s0)
 74a:	e818                	sd	a4,16(s0)
 74c:	ec1c                	sd	a5,24(s0)
 74e:	03043023          	sd	a6,32(s0)
 752:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	8622                	mv	a2,s0
 758:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75c:	d5fff0ef          	jal	4ba <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <printf>:

void
printf(const char *fmt, ...)
{
 768:	711d                	addi	sp,sp,-96
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e40c                	sd	a1,8(s0)
 772:	e810                	sd	a2,16(s0)
 774:	ec14                	sd	a3,24(s0)
 776:	f018                	sd	a4,32(s0)
 778:	f41c                	sd	a5,40(s0)
 77a:	03043823          	sd	a6,48(s0)
 77e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	00840613          	addi	a2,s0,8
 786:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78a:	85aa                	mv	a1,a0
 78c:	4505                	li	a0,1
 78e:	d2dff0ef          	jal	4ba <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	1141                	addi	sp,sp,-16
 79c:	e406                	sd	ra,8(sp)
 79e:	e022                	sd	s0,0(sp)
 7a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	00001797          	auipc	a5,0x1
 7aa:	85a7b783          	ld	a5,-1958(a5) # 1000 <freep>
 7ae:	a02d                	j	7d8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b0:	4618                	lw	a4,8(a2)
 7b2:	9f2d                	addw	a4,a4,a1
 7b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	6398                	ld	a4,0(a5)
 7ba:	6310                	ld	a2,0(a4)
 7bc:	a83d                	j	7fa <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7be:	ff852703          	lw	a4,-8(a0)
 7c2:	9f31                	addw	a4,a4,a2
 7c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c6:	ff053683          	ld	a3,-16(a0)
 7ca:	a091                	j	80e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x3c>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x4c>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x32>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059813          	slli	a6,a1,0x20
 7f0:	01c85713          	srli	a4,a6,0x1c
 7f4:	9736                	add	a4,a4,a3
 7f6:	fae60de3          	beq	a2,a4,7b0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061593          	slli	a1,a2,0x20
 804:	01c5d713          	srli	a4,a1,0x1c
 808:	973e                	add	a4,a4,a5
 80a:	fae68ae3          	beq	a3,a4,7be <free+0x24>
    p->s.ptr = bp->s.ptr;
 80e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
}
 818:	60a2                	ld	ra,8(sp)
 81a:	6402                	ld	s0,0(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret

0000000000000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	7139                	addi	sp,sp,-64
 822:	fc06                	sd	ra,56(sp)
 824:	f822                	sd	s0,48(sp)
 826:	f04a                	sd	s2,32(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	02051993          	slli	s3,a0,0x20
 830:	0209d993          	srli	s3,s3,0x20
 834:	09bd                	addi	s3,s3,15
 836:	0049d993          	srli	s3,s3,0x4
 83a:	2985                	addiw	s3,s3,1
 83c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 83e:	00000517          	auipc	a0,0x0
 842:	7c253503          	ld	a0,1986(a0) # 1000 <freep>
 846:	c905                	beqz	a0,876 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 848:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84a:	4798                	lw	a4,8(a5)
 84c:	09377663          	bgeu	a4,s3,8d8 <malloc+0xb8>
 850:	f426                	sd	s1,40(sp)
 852:	e852                	sd	s4,16(sp)
 854:	e456                	sd	s5,8(sp)
 856:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 858:	8a4e                	mv	s4,s3
 85a:	6705                	lui	a4,0x1
 85c:	00e9f363          	bgeu	s3,a4,862 <malloc+0x42>
 860:	6a05                	lui	s4,0x1
 862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86a:	00000497          	auipc	s1,0x0
 86e:	79648493          	addi	s1,s1,1942 # 1000 <freep>
  if(p == (char*)-1)
 872:	5afd                	li	s5,-1
 874:	a83d                	j	8b2 <malloc+0x92>
 876:	f426                	sd	s1,40(sp)
 878:	e852                	sd	s4,16(sp)
 87a:	e456                	sd	s5,8(sp)
 87c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 87e:	00000797          	auipc	a5,0x0
 882:	79278793          	addi	a5,a5,1938 # 1010 <base>
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
 88e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 890:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 894:	b7d1                	j	858 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	e118                	sd	a4,0(a0)
 89a:	a899                	j	8f0 <malloc+0xd0>
  hp->s.size = nu;
 89c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a0:	0541                	addi	a0,a0,16
 8a2:	ef9ff0ef          	jal	79a <free>
  return freep;
 8a6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a8:	c125                	beqz	a0,908 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	03277163          	bgeu	a4,s2,8d0 <malloc+0xb0>
    if(p == freep)
 8b2:	6098                	ld	a4,0(s1)
 8b4:	853e                	mv	a0,a5
 8b6:	fef71ae3          	bne	a4,a5,8aa <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ba:	8552                	mv	a0,s4
 8bc:	ae3ff0ef          	jal	39e <sbrk>
  if(p == (char*)-1)
 8c0:	fd551ee3          	bne	a0,s5,89c <malloc+0x7c>
        return 0;
 8c4:	4501                	li	a0,0
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
 8ce:	a03d                	j	8fc <malloc+0xdc>
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d8:	fae90fe3          	beq	s2,a4,896 <malloc+0x76>
        p->s.size -= nunits;
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e2:	02071693          	slli	a3,a4,0x20
 8e6:	01c6d713          	srli	a4,a3,0x1c
 8ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70a73823          	sd	a0,1808(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f8:	01078513          	addi	a0,a5,16
  }
}
 8fc:	70e2                	ld	ra,56(sp)
 8fe:	7442                	ld	s0,48(sp)
 900:	7902                	ld	s2,32(sp)
 902:	69e2                	ld	s3,24(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
 908:	74a2                	ld	s1,40(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	b7f5                	j	8fc <malloc+0xdc>
