
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	54010113          	addi	sp,sp,1344 # 8001b540 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5a7040ef          	jal	80004dbc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	61078793          	addi	a5,a5,1552 # 80023640 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	2c490913          	addi	s2,s2,708 # 8000a310 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	7ce050ef          	jal	80005824 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	053050ef          	jal	800058b8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	478050ef          	jal	800054f6 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	23650513          	addi	a0,a0,566 # 8000a310 <kmem>
    800000e2:	6be050ef          	jal	800057a0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	55650513          	addi	a0,a0,1366 # 80023640 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	20848493          	addi	s1,s1,520 # 8000a310 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	712050ef          	jal	80005824 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	1f450513          	addi	a0,a0,500 # 8000a310 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	792050ef          	jal	800058b8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	1d050513          	addi	a0,a0,464 # 8000a310 <kmem>
    80000148:	770050ef          	jal	800058b8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb9c1>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	221000ef          	jal	80000d2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	0000a717          	auipc	a4,0xa
    80000314:	fd070713          	addi	a4,a4,-48 # 8000a2e0 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	209000ef          	jal	80000d2c <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	6f5040ef          	jal	80005226 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	51c010ef          	jal	80001856 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	4ca040ef          	jal	80004808 <plicinithart>
  }

  scheduler();        
    80000342:	653000ef          	jal	80001194 <scheduler>
    consoleinit();
    80000346:	613040ef          	jal	80005158 <consoleinit>
    printfinit();
    8000034a:	1e6050ef          	jal	80005530 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	6d1040ef          	jal	80005226 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	6c5040ef          	jal	80005226 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	6b9040ef          	jal	80005226 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	0fb000ef          	jal	80000c78 <procinit>
    trapinit();      // trap vectors
    80000382:	4b0010ef          	jal	80001832 <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	4d0010ef          	jal	80001856 <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	464040ef          	jal	800047ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	47a040ef          	jal	80004808 <plicinithart>
    binit();         // buffer cache
    80000392:	3e7010ef          	jal	80001f78 <binit>
    iinit();         // inode table
    80000396:	1b2020ef          	jal	80002548 <iinit>
    fileinit();      // file table
    8000039a:	781020ef          	jal	8000331a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	55a040ef          	jal	800048f8 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	427000ef          	jal	80000fc8 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	f2f72a23          	sw	a5,-204(a4) # 8000a2e0 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:
  
  return kpgtbl;
}

// Initialize the one kernel_pagetable
void
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
typedef uint64 pte_t;
typedef uint64 *pagetable_t; // 512 PTEs

#endif // __ASSEMBLER__

#define PGSIZE 4096 // bytes per page
    800003be:	12000073          	sfence.vma
kvminit(void)
{
  kernel_pagetable = kvmmake();
}
    800003c2:	0000a797          	auipc	a5,0xa
    800003c6:	f267b783          	ld	a5,-218(a5) # 8000a2e8 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
#define PGSIZE 4096 // bytes per page
    800003d6:	12000073          	sfence.vma

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	84aa                	mv	s1,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
// pages. A page-table page contains 512 64-bit PTEs.
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
    80000402:	4b31                	li	s6,12
// pages. A page-table page contains 512 64-bit PTEs.
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
//   21..29 -- 9 bits of level-1 index.
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
//   12..20 -- 9 bits of level-0 index.
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
//    0..11 -- 12 bits of byte offset within the page.
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
//   30..38 -- 9 bits of level-2 index.
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
{
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
    if(*pte & PTE_V) {
    80000434:	70e2                	ld	ra,56(sp)
    80000436:	7442                	ld	s0,48(sp)
    80000438:	74a2                	ld	s1,40(sp)
    8000043a:	7902                	ld	s2,32(sp)
    8000043c:	69e2                	ld	s3,24(sp)
    8000043e:	6a42                	ld	s4,16(sp)
    80000440:	6aa2                	ld	s5,8(sp)
    80000442:	6b02                	ld	s6,0(sp)
    80000444:	6121                	addi	sp,sp,64
    80000446:	8082                	ret
// A 64-bit virtual address is split into five fields:
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	0a6050ef          	jal	800054f6 <panic>
walk(pagetable_t pagetable, uint64 va, int alloc)
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
  if(va >= MAXVA)
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
    panic("walk");
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
{
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    }
    80000484:	4501                	li	a0,0
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
    80000486:	8082                	ret
    } else {
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
  return &pagetable[PX(0, va)];
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
}
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
// Look up a virtual address, return the physical address,
    80000498:	611c                	ld	a5,0(a0)
// Can only be used to look up user pages.
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
uint64
    800004a0:	4501                	li	a0,0
// Can only be used to look up user pages.
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
  pte_t *pte;
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
walkaddr(pagetable_t pagetable, uint64 va)
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
{
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>

    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
  return pa;
}


// add a mapping to the kernel page table.
// only used when booting.
    800004ba:	715d                	addi	sp,sp,-80
    800004bc:	e486                	sd	ra,72(sp)
    800004be:	e0a2                	sd	s0,64(sp)
    800004c0:	fc26                	sd	s1,56(sp)
    800004c2:	f84a                	sd	s2,48(sp)
    800004c4:	f44e                	sd	s3,40(sp)
    800004c6:	f052                	sd	s4,32(sp)
    800004c8:	ec56                	sd	s5,24(sp)
    800004ca:	e85a                	sd	s6,16(sp)
    800004cc:	e45e                	sd	s7,8(sp)
    800004ce:	e062                	sd	s8,0(sp)
    800004d0:	0880                	addi	s0,sp,80
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa.
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
// allocate a needed page-table page.
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004f2:	4b85                	li	s7,1
  pte_t *pte;

  if((va % PGSIZE) != 0)
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
{
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
  pte_t *pte;
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
  if((va % PGSIZE) != 0)
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    panic("mappages: va not aligned");
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
  if((size % PGSIZE) != 0)
    8000051e:	9962                	add	s2,s2,s8
{
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	7cd040ef          	jal	800054f6 <panic>

    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	7c1040ef          	jal	800054f6 <panic>
// va and size MUST be page-aligned.
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	7b5040ef          	jal	800054f6 <panic>

    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	7a9040ef          	jal	800054f6 <panic>
  uint64 a, last;
    80000552:	557d                	li	a0,-1
    panic("mappages: size not aligned");

  if(size == 0)
    panic("mappages: size");
    80000554:	60a6                	ld	ra,72(sp)
    80000556:	6406                	ld	s0,64(sp)
    80000558:	74e2                	ld	s1,56(sp)
    8000055a:	7942                	ld	s2,48(sp)
    8000055c:	79a2                	ld	s3,40(sp)
    8000055e:	7a02                	ld	s4,32(sp)
    80000560:	6ae2                	ld	s5,24(sp)
    80000562:	6b42                	ld	s6,16(sp)
    80000564:	6ba2                	ld	s7,8(sp)
    80000566:	6c02                	ld	s8,0(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  if(size == 0)
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
  if(pte == 0)
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
    return 0;
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
    return 0;
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
  if((*pte & PTE_V) == 0)
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	763040ef          	jal	800054f6 <panic>

0000000080000598 <kvmmake>:
pagetable_t
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  pagetable_t kpgtbl;
    800005a4:	b5bff0ef          	jal	800000fe <kalloc>
    800005a8:	84aa                	mv	s1,a0

    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	ba1ff0ef          	jal	8000014e <memset>

    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	85b2                	mv	a1,a2
    800005bc:	8526                	mv	a0,s1
    800005be:	fb3ff0ef          	jal	80000570 <kvmmap>

    800005c2:	4719                	li	a4,6
    800005c4:	6685                	lui	a3,0x1
    800005c6:	10001637          	lui	a2,0x10001
    800005ca:	85b2                	mv	a1,a2
    800005cc:	8526                	mv	a0,s1
    800005ce:	fa3ff0ef          	jal	80000570 <kvmmap>

    800005d2:	4719                	li	a4,6
    800005d4:	040006b7          	lui	a3,0x4000
    800005d8:	0c000637          	lui	a2,0xc000
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f91ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    800005e4:	00007917          	auipc	s2,0x7
    800005e8:	a1c90913          	addi	s2,s2,-1508 # 80007000 <etext>
    800005ec:	4729                	li	a4,10
    800005ee:	80007697          	auipc	a3,0x80007
    800005f2:	a1268693          	addi	a3,a3,-1518 # 7000 <_entry-0x7fff9000>
    800005f6:	4605                	li	a2,1
    800005f8:	067e                	slli	a2,a2,0x1f
    800005fa:	85b2                	mv	a1,a2
    800005fc:	8526                	mv	a0,s1
    800005fe:	f73ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000630:	8526                	mv	a0,s1
    80000632:	5a8000ef          	jal	80000bda <proc_mapstacks>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000636:	8526                	mv	a0,s1
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6902                	ld	s2,0(sp)
    80000640:	6105                	addi	sp,sp,32
    80000642:	8082                	ret

0000000080000644 <kvminit>:

    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
  // allocate and map a kernel stack for each process.
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	0000a797          	auipc	a5,0xa
    80000654:	c8a7bc23          	sd	a0,-872(a5) # 8000a2e8 <kernel_pagetable>
  proc_mapstacks(kpgtbl);
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
  a = va;
  last = va + size - PGSIZE;
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if(*pte & PTE_V)
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    80000668:	03459793          	slli	a5,a1,0x34
    8000066c:	e39d                	bnez	a5,80000692 <uvmunmap+0x32>
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	8a2a                	mv	s4,a0
    8000067c:	892e                	mv	s2,a1
    8000067e:	8ab6                	mv	s5,a3
    a += PGSIZE;
    pa += PGSIZE;
  }
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
  return 0;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
    80000686:	4b85                	li	s7,1
  }
    80000688:	6b05                	lui	s6,0x1
    8000068a:	0735ff63          	bgeu	a1,s3,80000708 <uvmunmap+0xa8>
    8000068e:	fc26                	sd	s1,56(sp)
    80000690:	a0a9                	j	800006da <uvmunmap+0x7a>
    80000692:	fc26                	sd	s1,56(sp)
    80000694:	f84a                	sd	s2,48(sp)
    80000696:	f44e                	sd	s3,40(sp)
    80000698:	f052                	sd	s4,32(sp)
    8000069a:	ec56                	sd	s5,24(sp)
    8000069c:	e85a                	sd	s6,16(sp)
    8000069e:	e45e                	sd	s7,8(sp)
    a += PGSIZE;
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	64f040ef          	jal	800054f6 <panic>
}
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	643040ef          	jal	800054f6 <panic>
// Remove npages of mappings starting from va. va must be
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	637040ef          	jal	800054f6 <panic>
// Optionally free the physical memory.
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	62b040ef          	jal	800054f6 <panic>
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;
    800006d0:	0004b023          	sd	zero,0(s1)
  }
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
  return 0;
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>

    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
// page-aligned. The mappings must exist.
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
void
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
    800006fc:	8129                	srli	a0,a0,0xa
{
    800006fe:	0532                	slli	a0,a0,0xc
    80000700:	91dff0ef          	jal	8000001c <kfree>
    80000704:	b7f1                	j	800006d0 <uvmunmap+0x70>
    80000706:	74e2                	ld	s1,56(sp)
    80000708:	7942                	ld	s2,48(sp)
    8000070a:	79a2                	ld	s3,40(sp)
    8000070c:	7a02                	ld	s4,32(sp)
    8000070e:	6ae2                	ld	s5,24(sp)
    80000710:	6b42                	ld	s6,16(sp)
    80000712:	6ba2                	ld	s7,8(sp)
  int sz;

    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <uvmcreate>:
  if((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    sz = PGSIZE;
    if((pte = walk(pagetable, a, 0)) == 0)
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	1000                	addi	s0,sp,32
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
    80000726:	9d9ff0ef          	jal	800000fe <kalloc>
    8000072a:	84aa                	mv	s1,a0
      printf("va=%ld pte=%ld\n", a, *pte);
    8000072c:	c509                	beqz	a0,80000736 <uvmcreate+0x1a>
      panic("uvmunmap: not mapped");
    }
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
    if(PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    80000736:	8526                	mv	a0,s1
    80000738:	60e2                	ld	ra,24(sp)
    8000073a:	6442                	ld	s0,16(sp)
    8000073c:	64a2                	ld	s1,8(sp)
    8000073e:	6105                	addi	sp,sp,32
    80000740:	8082                	ret

0000000080000742 <uvmfirst>:
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	7179                	addi	sp,sp,-48
    80000744:	f406                	sd	ra,40(sp)
    80000746:	f022                	sd	s0,32(sp)
    80000748:	ec26                	sd	s1,24(sp)
    8000074a:	e84a                	sd	s2,16(sp)
    8000074c:	e44e                	sd	s3,8(sp)
    8000074e:	e052                	sd	s4,0(sp)
    80000750:	1800                	addi	s0,sp,48

// create an empty user page table.
// returns 0 if out of memory.
    80000752:	6785                	lui	a5,0x1
    80000754:	04f67063          	bgeu	a2,a5,80000794 <uvmfirst+0x52>
    80000758:	8a2a                	mv	s4,a0
    8000075a:	89ae                	mv	s3,a1
    8000075c:	84b2                	mv	s1,a2
pagetable_t
uvmcreate()
    8000075e:	9a1ff0ef          	jal	800000fe <kalloc>
    80000762:	892a                	mv	s2,a0
{
    80000764:	6605                	lui	a2,0x1
    80000766:	4581                	li	a1,0
    80000768:	9e7ff0ef          	jal	8000014e <memset>
  pagetable_t pagetable;
    8000076c:	4779                	li	a4,30
    8000076e:	86ca                	mv	a3,s2
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	8552                	mv	a0,s4
    80000776:	d45ff0ef          	jal	800004ba <mappages>
  pagetable = (pagetable_t) kalloc();
    8000077a:	8626                	mv	a2,s1
    8000077c:	85ce                	mv	a1,s3
    8000077e:	854a                	mv	a0,s2
    80000780:	a33ff0ef          	jal	800001b2 <memmove>
  if(pagetable == 0)
    80000784:	70a2                	ld	ra,40(sp)
    80000786:	7402                	ld	s0,32(sp)
    80000788:	64e2                	ld	s1,24(sp)
    8000078a:	6942                	ld	s2,16(sp)
    8000078c:	69a2                	ld	s3,8(sp)
    8000078e:	6a02                	ld	s4,0(sp)
    80000790:	6145                	addi	sp,sp,48
    80000792:	8082                	ret
pagetable_t
    80000794:	00007517          	auipc	a0,0x7
    80000798:	98450513          	addi	a0,a0,-1660 # 80007118 <etext+0x118>
    8000079c:	55b040ef          	jal	800054f6 <panic>

00000000800007a0 <uvmdealloc>:

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += sz){
    800007a0:	1101                	addi	sp,sp,-32
    800007a2:	ec06                	sd	ra,24(sp)
    800007a4:	e822                	sd	s0,16(sp)
    800007a6:	e426                	sd	s1,8(sp)
    800007a8:	1000                	addi	s0,sp,32
    sz = PGSIZE;
    mem = kalloc();
    800007aa:	84ae                	mv	s1,a1
    sz = PGSIZE;
    800007ac:	00b67d63          	bgeu	a2,a1,800007c6 <uvmdealloc+0x26>
    800007b0:	84b2                	mv	s1,a2
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
    800007b2:	6785                	lui	a5,0x1
    800007b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b6:	00f60733          	add	a4,a2,a5
    800007ba:	76fd                	lui	a3,0xfffff
    800007bc:	8f75                	and	a4,a4,a3
    800007be:	97ae                	add	a5,a5,a1
    800007c0:	8ff5                	and	a5,a5,a3
    800007c2:	00f76863          	bltu	a4,a5,800007d2 <uvmdealloc+0x32>
      return 0;
    }
#ifndef LAB_SYSCALL
    memset(mem, 0, sz);
#endif
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007c6:	8526                	mv	a0,s1
    800007c8:	60e2                	ld	ra,24(sp)
    800007ca:	6442                	ld	s0,16(sp)
    800007cc:	64a2                	ld	s1,8(sp)
    800007ce:	6105                	addi	sp,sp,32
    800007d0:	8082                	ret
      return 0;
    800007d2:	8f99                	sub	a5,a5,a4
    800007d4:	83b1                	srli	a5,a5,0xc
    }
    800007d6:	4685                	li	a3,1
    800007d8:	0007861b          	sext.w	a2,a5
    800007dc:	85ba                	mv	a1,a4
    800007de:	e83ff0ef          	jal	80000660 <uvmunmap>
    800007e2:	b7d5                	j	800007c6 <uvmdealloc+0x26>

00000000800007e4 <uvmalloc>:
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
    800007e4:	0ab66363          	bltu	a2,a1,8000088a <uvmalloc+0xa6>
// Load the user initcode into address 0 of pagetable,
    800007e8:	715d                	addi	sp,sp,-80
    800007ea:	e486                	sd	ra,72(sp)
    800007ec:	e0a2                	sd	s0,64(sp)
    800007ee:	f052                	sd	s4,32(sp)
    800007f0:	ec56                	sd	s5,24(sp)
    800007f2:	e85a                	sd	s6,16(sp)
    800007f4:	0880                	addi	s0,sp,80
    800007f6:	8b2a                	mv	s6,a0
    800007f8:	8ab2                	mv	s5,a2

    800007fa:	6785                	lui	a5,0x1
    800007fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fe:	95be                	add	a1,a1,a5
    80000800:	77fd                	lui	a5,0xfffff
    80000802:	00f5fa33          	and	s4,a1,a5
  if(sz >= PGSIZE)
    80000806:	08ca7463          	bgeu	s4,a2,8000088e <uvmalloc+0xaa>
    8000080a:	fc26                	sd	s1,56(sp)
    8000080c:	f84a                	sd	s2,48(sp)
    8000080e:	f44e                	sd	s3,40(sp)
    80000810:	e45e                	sd	s7,8(sp)
    80000812:	8952                	mv	s2,s4
}
    80000814:	6985                	lui	s3,0x1

    80000816:	0126eb93          	ori	s7,a3,18
    panic("uvmfirst: more than a page");
    8000081a:	8e5ff0ef          	jal	800000fe <kalloc>
    8000081e:	84aa                	mv	s1,a0
  mem = kalloc();
    80000820:	c515                	beqz	a0,8000084c <uvmalloc+0x68>
}
    80000822:	864e                	mv	a2,s3
    80000824:	4581                	li	a1,0
    80000826:	929ff0ef          	jal	8000014e <memset>

    8000082a:	875e                	mv	a4,s7
    8000082c:	86a6                	mv	a3,s1
    8000082e:	864e                	mv	a2,s3
    80000830:	85ca                	mv	a1,s2
    80000832:	855a                	mv	a0,s6
    80000834:	c87ff0ef          	jal	800004ba <mappages>
    80000838:	e91d                	bnez	a0,8000086e <uvmalloc+0x8a>
  if(sz >= PGSIZE)
    8000083a:	994e                	add	s2,s2,s3
    8000083c:	fd596fe3          	bltu	s2,s5,8000081a <uvmalloc+0x36>
{
    80000840:	8556                	mv	a0,s5
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	6ba2                	ld	s7,8(sp)
    8000084a:	a819                	j	80000860 <uvmalloc+0x7c>
  memset(mem, 0, PGSIZE);
    8000084c:	8652                	mv	a2,s4
    8000084e:	85ca                	mv	a1,s2
    80000850:	855a                	mv	a0,s6
    80000852:	f4fff0ef          	jal	800007a0 <uvmdealloc>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000856:	4501                	li	a0,0
    80000858:	74e2                	ld	s1,56(sp)
    8000085a:	7942                	ld	s2,48(sp)
    8000085c:	79a2                	ld	s3,40(sp)
    8000085e:	6ba2                	ld	s7,8(sp)
  char *mem;
    80000860:	60a6                	ld	ra,72(sp)
    80000862:	6406                	ld	s0,64(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret

    8000086e:	8526                	mv	a0,s1
    80000870:	facff0ef          	jal	8000001c <kfree>
// Allocate PTEs and physical memory to grow process from oldsz to
    80000874:	8652                	mv	a2,s4
    80000876:	85ca                	mv	a1,s2
    80000878:	855a                	mv	a0,s6
    8000087a:	f27ff0ef          	jal	800007a0 <uvmdealloc>
// newsz, which need not be page aligned.  Returns new size or 0 on error.
    8000087e:	4501                	li	a0,0
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	6ba2                	ld	s7,8(sp)
    80000888:	bfe1                	j	80000860 <uvmalloc+0x7c>
{
    8000088a:	852e                	mv	a0,a1
  char *mem;
    8000088c:	8082                	ret
{
    8000088e:	8532                	mv	a0,a2
    80000890:	bfc1                	j	80000860 <uvmalloc+0x7c>

0000000080000892 <freewalk>:
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
    80000892:	7179                	addi	sp,sp,-48
    80000894:	f406                	sd	ra,40(sp)
    80000896:	f022                	sd	s0,32(sp)
    80000898:	ec26                	sd	s1,24(sp)
    8000089a:	e84a                	sd	s2,16(sp)
    8000089c:	e44e                	sd	s3,8(sp)
    8000089e:	e052                	sd	s4,0(sp)
    800008a0:	1800                	addi	s0,sp,48
    800008a2:	8a2a                	mv	s4,a0
}

    800008a4:	84aa                	mv	s1,a0
    800008a6:	6905                	lui	s2,0x1
    800008a8:	992a                	add	s2,s2,a0
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
    800008aa:	4985                	li	s3,1
    800008ac:	a819                	j	800008c2 <freewalk+0x30>
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    800008ae:	83a9                	srli	a5,a5,0xa
uint64
    800008b0:	00c79513          	slli	a0,a5,0xc
    800008b4:	fdfff0ef          	jal	80000892 <freewalk>
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
    800008b8:	0004b023          	sd	zero,0(s1)

    800008bc:	04a1                	addi	s1,s1,8
    800008be:	01248f63          	beq	s1,s2,800008dc <freewalk+0x4a>
// Deallocate user pages to bring the process size from oldsz to
    800008c2:	609c                	ld	a5,0(s1)
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
    800008c4:	00f7f713          	andi	a4,a5,15
    800008c8:	ff3703e3          	beq	a4,s3,800008ae <freewalk+0x1c>
{
    800008cc:	8b85                	andi	a5,a5,1
    800008ce:	d7fd                	beqz	a5,800008bc <freewalk+0x2a>
  if(newsz >= oldsz)
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	86850513          	addi	a0,a0,-1944 # 80007138 <etext+0x138>
    800008d8:	41f040ef          	jal	800054f6 <panic>
    return oldsz;

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008dc:	8552                	mv	a0,s4
    800008de:	f3eff0ef          	jal	8000001c <kfree>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e2:	70a2                	ld	ra,40(sp)
    800008e4:	7402                	ld	s0,32(sp)
    800008e6:	64e2                	ld	s1,24(sp)
    800008e8:	6942                	ld	s2,16(sp)
    800008ea:	69a2                	ld	s3,8(sp)
    800008ec:	6a02                	ld	s4,0(sp)
    800008ee:	6145                	addi	sp,sp,48
    800008f0:	8082                	ret

00000000800008f2 <uvmfree>:
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
    800008fc:	84aa                	mv	s1,a0
// Recursively free page-table pages.
    800008fe:	e989                	bnez	a1,80000910 <uvmfree+0x1e>
// All leaf mappings must already have been removed.
void
    80000900:	8526                	mv	a0,s1
    80000902:	f91ff0ef          	jal	80000892 <freewalk>
freewalk(pagetable_t pagetable)
    80000906:	60e2                	ld	ra,24(sp)
    80000908:	6442                	ld	s0,16(sp)
    8000090a:	64a2                	ld	s1,8(sp)
    8000090c:	6105                	addi	sp,sp,32
    8000090e:	8082                	ret
// All leaf mappings must already have been removed.
    80000910:	6785                	lui	a5,0x1
    80000912:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000914:	95be                	add	a1,a1,a5
    80000916:	4685                	li	a3,1
    80000918:	00c5d613          	srli	a2,a1,0xc
    8000091c:	4581                	li	a1,0
    8000091e:	d43ff0ef          	jal	80000660 <uvmunmap>
    80000922:	bff9                	j	80000900 <uvmfree+0xe>

0000000080000924 <uvmcopy>:
      panic("freewalk: leaf");
    }
  }
  kfree((void*)pagetable);
}

    80000924:	ca4d                	beqz	a2,800009d6 <uvmcopy+0xb2>
    } else if(pte & PTE_V){
    80000926:	715d                	addi	sp,sp,-80
    80000928:	e486                	sd	ra,72(sp)
    8000092a:	e0a2                	sd	s0,64(sp)
    8000092c:	fc26                	sd	s1,56(sp)
    8000092e:	f84a                	sd	s2,48(sp)
    80000930:	f44e                	sd	s3,40(sp)
    80000932:	f052                	sd	s4,32(sp)
    80000934:	ec56                	sd	s5,24(sp)
    80000936:	e85a                	sd	s6,16(sp)
    80000938:	e45e                	sd	s7,8(sp)
    8000093a:	e062                	sd	s8,0(sp)
    8000093c:	0880                	addi	s0,sp,80
    8000093e:	8baa                	mv	s7,a0
    80000940:	8b2e                	mv	s6,a1
    80000942:	8ab2                	mv	s5,a2

    80000944:	4981                	li	s3,0
uvmfree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
}
    80000946:	6a05                	lui	s4,0x1
// Free user memory pages,
    80000948:	4601                	li	a2,0
    8000094a:	85ce                	mv	a1,s3
    8000094c:	855e                	mv	a0,s7
    8000094e:	a95ff0ef          	jal	800003e2 <walk>
    80000952:	cd1d                	beqz	a0,80000990 <uvmcopy+0x6c>
void
    80000954:	6118                	ld	a4,0(a0)
    80000956:	00177793          	andi	a5,a4,1
    8000095a:	c3a9                	beqz	a5,8000099c <uvmcopy+0x78>
{
    8000095c:	00a75593          	srli	a1,a4,0xa
    80000960:	00c59c13          	slli	s8,a1,0xc
  if(sz > 0)
    80000964:	3ff77493          	andi	s1,a4,1023
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000968:	f96ff0ef          	jal	800000fe <kalloc>
    8000096c:	892a                	mv	s2,a0
    8000096e:	c121                	beqz	a0,800009ae <uvmcopy+0x8a>
}
    80000970:	8652                	mv	a2,s4
    80000972:	85e2                	mv	a1,s8
    80000974:	83fff0ef          	jal	800001b2 <memmove>

    80000978:	8726                	mv	a4,s1
    8000097a:	86ca                	mv	a3,s2
    8000097c:	8652                	mv	a2,s4
    8000097e:	85ce                	mv	a1,s3
    80000980:	855a                	mv	a0,s6
    80000982:	b39ff0ef          	jal	800004ba <mappages>
    80000986:	e10d                	bnez	a0,800009a8 <uvmcopy+0x84>

    80000988:	99d2                	add	s3,s3,s4
    8000098a:	fb59efe3          	bltu	s3,s5,80000948 <uvmcopy+0x24>
    8000098e:	a805                	j	800009be <uvmcopy+0x9a>
// then free page-table pages.
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	35f040ef          	jal	800054f6 <panic>
uvmfree(pagetable_t pagetable, uint64 sz)
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	353040ef          	jal	800054f6 <panic>
// Given a parent process's page table, copy
    800009a8:	854a                	mv	a0,s2
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
    800009ae:	4685                	li	a3,1
    800009b0:	00c9d613          	srli	a2,s3,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	855a                	mv	a0,s6
    800009b8:	ca9ff0ef          	jal	80000660 <uvmunmap>
{
    800009bc:	557d                	li	a0,-1
  pte_t *pte;
    800009be:	60a6                	ld	ra,72(sp)
    800009c0:	6406                	ld	s0,64(sp)
    800009c2:	74e2                	ld	s1,56(sp)
    800009c4:	7942                	ld	s2,48(sp)
    800009c6:	79a2                	ld	s3,40(sp)
    800009c8:	7a02                	ld	s4,32(sp)
    800009ca:	6ae2                	ld	s5,24(sp)
    800009cc:	6b42                	ld	s6,16(sp)
    800009ce:	6ba2                	ld	s7,8(sp)
    800009d0:	6c02                	ld	s8,0(sp)
    800009d2:	6161                	addi	sp,sp,80
    800009d4:	8082                	ret
// returns 0 on success, -1 on failure.
    800009d6:	4501                	li	a0,0
  pte_t *pte;
    800009d8:	8082                	ret

00000000800009da <uvmclear>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    800009da:	1141                	addi	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	addi	s0,sp,16
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    800009e2:	4601                	li	a2,0
    800009e4:	9ffff0ef          	jal	800003e2 <walk>
      panic("uvmcopy: pte should exist");
    800009e8:	c901                	beqz	a0,800009f8 <uvmclear+0x1e>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    800009ea:	611c                	ld	a5,0(a0)
    800009ec:	9bbd                	andi	a5,a5,-17
    800009ee:	e11c                	sd	a5,0(a0)
    pa = PTE2PA(*pte);
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    if((*pte & PTE_V) == 0)
    800009f8:	00006517          	auipc	a0,0x6
    800009fc:	79050513          	addi	a0,a0,1936 # 80007188 <etext+0x188>
    80000a00:	2f7040ef          	jal	800054f6 <panic>

0000000080000a04 <copyout>:
      kfree(mem);
      goto err;
    }
  }
  return 0;

    80000a04:	c2d9                	beqz	a3,80000a8a <copyout+0x86>
      goto err;
    80000a06:	711d                	addi	sp,sp,-96
    80000a08:	ec86                	sd	ra,88(sp)
    80000a0a:	e8a2                	sd	s0,80(sp)
    80000a0c:	e4a6                	sd	s1,72(sp)
    80000a0e:	e0ca                	sd	s2,64(sp)
    80000a10:	fc4e                	sd	s3,56(sp)
    80000a12:	f852                	sd	s4,48(sp)
    80000a14:	f456                	sd	s5,40(sp)
    80000a16:	f05a                	sd	s6,32(sp)
    80000a18:	ec5e                	sd	s7,24(sp)
    80000a1a:	e862                	sd	s8,16(sp)
    80000a1c:	e466                	sd	s9,8(sp)
    80000a1e:	e06a                	sd	s10,0(sp)
    80000a20:	1080                	addi	s0,sp,96
    80000a22:	8c2a                	mv	s8,a0
    80000a24:	892e                	mv	s2,a1
    80000a26:	8ab2                	mv	s5,a2
    80000a28:	8a36                	mv	s4,a3
 err:
    80000a2a:	7cfd                	lui	s9,0xfffff
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a2c:	5bfd                	li	s7,-1
    80000a2e:	01abdb93          	srli	s7,s7,0x1a
  return -1;
}

    80000a32:	4d55                	li	s10,21
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
    80000a34:	6b05                	lui	s6,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x56>
void
    80000a38:	83a9                	srli	a5,a5,0xa
    80000a3a:	07b2                	slli	a5,a5,0xc
{
  pte_t *pte;
  
    80000a3c:	41390533          	sub	a0,s2,s3
    80000a40:	0004861b          	sext.w	a2,s1
    80000a44:	85d6                	mv	a1,s5
    80000a46:	953e                	add	a0,a0,a5
    80000a48:	f6aff0ef          	jal	800001b2 <memmove>
  pte = walk(pagetable, va, 0);
  if(pte == 0)
    80000a4c:	409a0a33          	sub	s4,s4,s1
    panic("uvmclear");
    80000a50:	9aa6                	add	s5,s5,s1
  *pte &= ~PTE_U;
    80000a52:	01698933          	add	s2,s3,s6

    80000a56:	020a0863          	beqz	s4,80000a86 <copyout+0x82>
 err:
    80000a5a:	019979b3          	and	s3,s2,s9
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a5e:	033be863          	bltu	s7,s3,80000a8e <copyout+0x8a>
}
    80000a62:	4601                	li	a2,0
    80000a64:	85ce                	mv	a1,s3
    80000a66:	8562                	mv	a0,s8
    80000a68:	97bff0ef          	jal	800003e2 <walk>

    80000a6c:	c121                	beqz	a0,80000aac <copyout+0xa8>
    80000a6e:	611c                	ld	a5,0(a0)
    80000a70:	0157f713          	andi	a4,a5,21
    80000a74:	03a71e63          	bne	a4,s10,80000ab0 <copyout+0xac>
uvmclear(pagetable_t pagetable, uint64 va)
    80000a78:	412984b3          	sub	s1,s3,s2
    80000a7c:	94da                	add	s1,s1,s6
{
    80000a7e:	fa9a7de3          	bgeu	s4,s1,80000a38 <copyout+0x34>
    80000a82:	84d2                	mv	s1,s4
    80000a84:	bf55                	j	80000a38 <copyout+0x34>
}

    80000a86:	4501                	li	a0,0
    80000a88:	a021                	j	80000a90 <copyout+0x8c>
    80000a8a:	4501                	li	a0,0
// Copy from kernel to user.
    80000a8c:	8082                	ret
  return -1;
    80000a8e:	557d                	li	a0,-1
// Copy from kernel to user.
    80000a90:	60e6                	ld	ra,88(sp)
    80000a92:	6446                	ld	s0,80(sp)
    80000a94:	64a6                	ld	s1,72(sp)
    80000a96:	6906                	ld	s2,64(sp)
    80000a98:	79e2                	ld	s3,56(sp)
    80000a9a:	7a42                	ld	s4,48(sp)
    80000a9c:	7aa2                	ld	s5,40(sp)
    80000a9e:	7b02                	ld	s6,32(sp)
    80000aa0:	6be2                	ld	s7,24(sp)
    80000aa2:	6c42                	ld	s8,16(sp)
    80000aa4:	6ca2                	ld	s9,8(sp)
    80000aa6:	6d02                	ld	s10,0(sp)
    80000aa8:	6125                	addi	sp,sp,96
    80000aaa:	8082                	ret
// used by exec for the user stack guard page.
    80000aac:	557d                	li	a0,-1
    80000aae:	b7cd                	j	80000a90 <copyout+0x8c>
    80000ab0:	557d                	li	a0,-1
    80000ab2:	bff9                	j	80000a90 <copyout+0x8c>

0000000080000ab4 <copyin>:
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    80000ab4:	c6a5                	beqz	a3,80000b1c <copyin+0x68>
  pte_t *pte;
    80000ab6:	715d                	addi	sp,sp,-80
    80000ab8:	e486                	sd	ra,72(sp)
    80000aba:	e0a2                	sd	s0,64(sp)
    80000abc:	fc26                	sd	s1,56(sp)
    80000abe:	f84a                	sd	s2,48(sp)
    80000ac0:	f44e                	sd	s3,40(sp)
    80000ac2:	f052                	sd	s4,32(sp)
    80000ac4:	ec56                	sd	s5,24(sp)
    80000ac6:	e85a                	sd	s6,16(sp)
    80000ac8:	e45e                	sd	s7,8(sp)
    80000aca:	e062                	sd	s8,0(sp)
    80000acc:	0880                	addi	s0,sp,80
    80000ace:	8b2a                	mv	s6,a0
    80000ad0:	8a2e                	mv	s4,a1
    80000ad2:	8c32                	mv	s8,a2
    80000ad4:	89b6                	mv	s3,a3
    if (va0 >= MAXVA)
    80000ad6:	7bfd                	lui	s7,0xfffff
      return -1;
    if((pte = walk(pagetable, va0, 0)) == 0) {
      // printf("copyout: pte should exist 0x%x %d\n", dstva, len);
      return -1;
    80000ad8:	6a85                	lui	s5,0x1
    80000ada:	a00d                	j	80000afc <copyin+0x48>
    }


    80000adc:	018505b3          	add	a1,a0,s8
    80000ae0:	0004861b          	sext.w	a2,s1
    80000ae4:	412585b3          	sub	a1,a1,s2
    80000ae8:	8552                	mv	a0,s4
    80000aea:	ec8ff0ef          	jal	800001b2 <memmove>
    // forbid copyout over read-only user text pages.
    if((*pte & PTE_W) == 0)
    80000aee:	409989b3          	sub	s3,s3,s1
      return -1;
    80000af2:	9a26                	add	s4,s4,s1
    
    80000af4:	01590c33          	add	s8,s2,s5
    va0 = PGROUNDDOWN(dstva);
    80000af8:	02098063          	beqz	s3,80000b18 <copyin+0x64>
    if (va0 >= MAXVA)
    80000afc:	017c7933          	and	s2,s8,s7
      return -1;
    80000b00:	85ca                	mv	a1,s2
    80000b02:	855a                	mv	a0,s6
    80000b04:	979ff0ef          	jal	8000047c <walkaddr>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b08:	cd01                	beqz	a0,80000b20 <copyin+0x6c>
      return -1;
    80000b0a:	418904b3          	sub	s1,s2,s8
    80000b0e:	94d6                	add	s1,s1,s5
    }
    80000b10:	fc99f6e3          	bgeu	s3,s1,80000adc <copyin+0x28>
    80000b14:	84ce                	mv	s1,s3
    80000b16:	b7d9                	j	80000adc <copyin+0x28>
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
    80000b18:	4501                	li	a0,0
    80000b1a:	a021                	j	80000b22 <copyin+0x6e>
    80000b1c:	4501                	li	a0,0
      return -1;
    80000b1e:	8082                	ret
      // printf("copyout: pte should exist 0x%x %d\n", dstva, len);
    80000b20:	557d                	li	a0,-1
      return -1;
    80000b22:	60a6                	ld	ra,72(sp)
    80000b24:	6406                	ld	s0,64(sp)
    80000b26:	74e2                	ld	s1,56(sp)
    80000b28:	7942                	ld	s2,48(sp)
    80000b2a:	79a2                	ld	s3,40(sp)
    80000b2c:	7a02                	ld	s4,32(sp)
    80000b2e:	6ae2                	ld	s5,24(sp)
    80000b30:	6b42                	ld	s6,16(sp)
    80000b32:	6ba2                	ld	s7,8(sp)
    80000b34:	6c02                	ld	s8,0(sp)
    80000b36:	6161                	addi	sp,sp,80
    80000b38:	8082                	ret

0000000080000b3a <copyinstr>:
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
    80000b3a:	715d                	addi	sp,sp,-80
    80000b3c:	e486                	sd	ra,72(sp)
    80000b3e:	e0a2                	sd	s0,64(sp)
    80000b40:	fc26                	sd	s1,56(sp)
    80000b42:	f84a                	sd	s2,48(sp)
    80000b44:	f44e                	sd	s3,40(sp)
    80000b46:	f052                	sd	s4,32(sp)
    80000b48:	ec56                	sd	s5,24(sp)
    80000b4a:	e85a                	sd	s6,16(sp)
    80000b4c:	e45e                	sd	s7,8(sp)
    80000b4e:	0880                	addi	s0,sp,80
    80000b50:	8aaa                	mv	s5,a0
    80000b52:	89ae                	mv	s3,a1
    80000b54:	8bb2                	mv	s7,a2
    80000b56:	84b6                	mv	s1,a3
  }
  return 0;
}

// Copy from user to kernel.
    80000b58:	7b7d                	lui	s6,0xfffff
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a02d                	j	80000b86 <copyinstr+0x4c>
  uint64 n, va0, pa0;
  
  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
    80000b5e:	00078023          	sb	zero,0(a5)
    80000b62:	4785                	li	a5,1
    srcva = va0 + PGSIZE;
  }
  return 0;
}

// Copy a null-terminated string from user to kernel.
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
    80000b6c:	60a6                	ld	ra,72(sp)
    80000b6e:	6406                	ld	s0,64(sp)
    80000b70:	74e2                	ld	s1,56(sp)
    80000b72:	7942                	ld	s2,48(sp)
    80000b74:	79a2                	ld	s3,40(sp)
    80000b76:	7a02                	ld	s4,32(sp)
    80000b78:	6ae2                	ld	s5,24(sp)
    80000b7a:	6b42                	ld	s6,16(sp)
    80000b7c:	6ba2                	ld	s7,8(sp)
    80000b7e:	6161                	addi	sp,sp,80
    80000b80:	8082                	ret
}
    80000b82:	01490bb3          	add	s7,s2,s4

    80000b86:	c4b1                	beqz	s1,80000bd2 <copyinstr+0x98>
// Copy from user to kernel.
    80000b88:	016bf933          	and	s2,s7,s6
// Copy len bytes to dst from virtual address srcva in a given page table.
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	8556                	mv	a0,s5
    80000b90:	8edff0ef          	jal	8000047c <walkaddr>
// Return 0 on success, -1 on error.
    80000b94:	c129                	beqz	a0,80000bd6 <copyinstr+0x9c>
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
    80000b96:	41790633          	sub	a2,s2,s7
    80000b9a:	9652                	add	a2,a2,s4
{
    80000b9c:	00c4f363          	bgeu	s1,a2,80000ba2 <copyinstr+0x68>
    80000ba0:	8626                	mv	a2,s1
  while(len > 0){
    80000ba2:	412b8bb3          	sub	s7,s7,s2
    80000ba6:	9baa                	add	s7,s7,a0
    va0 = PGROUNDDOWN(srcva);
    80000ba8:	de69                	beqz	a2,80000b82 <copyinstr+0x48>
    80000baa:	87ce                	mv	a5,s3
    pa0 = walkaddr(pagetable, va0);
    80000bac:	413b86b3          	sub	a3,s7,s3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	964e                	add	a2,a2,s3
    80000bb2:	85be                	mv	a1,a5
    pa0 = walkaddr(pagetable, va0);
    80000bb4:	00f68733          	add	a4,a3,a5
    80000bb8:	00074703          	lbu	a4,0(a4)
    80000bbc:	d34d                	beqz	a4,80000b5e <copyinstr+0x24>
      n = len;
    80000bbe:	00e78023          	sb	a4,0(a5)
    srcva = va0 + PGSIZE;
    80000bc2:	0785                	addi	a5,a5,1
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	fec797e3          	bne	a5,a2,80000bb2 <copyinstr+0x78>
    80000bc8:	14fd                	addi	s1,s1,-1
    80000bca:	94ce                	add	s1,s1,s3
    len -= n;
    80000bcc:	8c8d                	sub	s1,s1,a1
    80000bce:	89be                	mv	s3,a5
    80000bd0:	bf4d                	j	80000b82 <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	bf41                	j	80000b64 <copyinstr+0x2a>
int
    80000bd6:	557d                	li	a0,-1
    80000bd8:	bf51                	j	80000b6c <copyinstr+0x32>

0000000080000bda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bda:	715d                	addi	sp,sp,-80
    80000bdc:	e486                	sd	ra,72(sp)
    80000bde:	e0a2                	sd	s0,64(sp)
    80000be0:	fc26                	sd	s1,56(sp)
    80000be2:	f84a                	sd	s2,48(sp)
    80000be4:	f44e                	sd	s3,40(sp)
    80000be6:	f052                	sd	s4,32(sp)
    80000be8:	ec56                	sd	s5,24(sp)
    80000bea:	e85a                	sd	s6,16(sp)
    80000bec:	e45e                	sd	s7,8(sp)
    80000bee:	e062                	sd	s8,0(sp)
    80000bf0:	0880                	addi	s0,sp,80
    80000bf2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf4:	0000a497          	auipc	s1,0xa
    80000bf8:	b6c48493          	addi	s1,s1,-1172 # 8000a760 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000c02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f81965>
    80000c06:	4fa50937          	lui	s2,0x4fa50
    80000c0a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000c0e:	1902                	slli	s2,s2,0x20
    80000c10:	993e                	add	s2,s2,a5
    80000c12:	040009b7          	lui	s3,0x4000
    80000c16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c18:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c1a:	4b99                	li	s7,6
    80000c1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	0000fa97          	auipc	s5,0xf
    80000c22:	542a8a93          	addi	s5,s5,1346 # 80010160 <tickslock>
    char *pa = kalloc();
    80000c26:	cd8ff0ef          	jal	800000fe <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	c121                	beqz	a0,80000c6c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	418485b3          	sub	a1,s1,s8
    80000c32:	858d                	srai	a1,a1,0x3
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	875e                	mv	a4,s7
    80000c40:	86da                	mv	a3,s6
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	929ff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	16848493          	addi	s1,s1,360
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4c>
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
      panic("kalloc");
    80000c6c:	00006517          	auipc	a0,0x6
    80000c70:	52c50513          	addi	a0,a0,1324 # 80007198 <etext+0x198>
    80000c74:	083040ef          	jal	800054f6 <panic>

0000000080000c78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c78:	7139                	addi	sp,sp,-64
    80000c7a:	fc06                	sd	ra,56(sp)
    80000c7c:	f822                	sd	s0,48(sp)
    80000c7e:	f426                	sd	s1,40(sp)
    80000c80:	f04a                	sd	s2,32(sp)
    80000c82:	ec4e                	sd	s3,24(sp)
    80000c84:	e852                	sd	s4,16(sp)
    80000c86:	e456                	sd	s5,8(sp)
    80000c88:	e05a                	sd	s6,0(sp)
    80000c8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c8c:	00006597          	auipc	a1,0x6
    80000c90:	51458593          	addi	a1,a1,1300 # 800071a0 <etext+0x1a0>
    80000c94:	00009517          	auipc	a0,0x9
    80000c98:	69c50513          	addi	a0,a0,1692 # 8000a330 <pid_lock>
    80000c9c:	305040ef          	jal	800057a0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00009517          	auipc	a0,0x9
    80000cac:	6a050513          	addi	a0,a0,1696 # 8000a348 <wait_lock>
    80000cb0:	2f1040ef          	jal	800057a0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	0000a497          	auipc	s1,0xa
    80000cb8:	aac48493          	addi	s1,s1,-1364 # 8000a760 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	a4fa57b7          	lui	a5,0xa4fa5
    80000cca:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f81965>
    80000cce:	4fa50937          	lui	s2,0x4fa50
    80000cd2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	0000fa17          	auipc	s4,0xf
    80000ce6:	47ea0a13          	addi	s4,s4,1150 # 80010160 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	2b3040ef          	jal	800057a0 <initlock>
      p->state = UNUSED;
    80000cf2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	415487b3          	sub	a5,s1,s5
    80000cfa:	878d                	srai	a5,a5,0x3
    80000cfc:	032787b3          	mul	a5,a5,s2
    80000d00:	2785                	addiw	a5,a5,1
    80000d02:	00d7979b          	slliw	a5,a5,0xd
    80000d06:	40f987b3          	sub	a5,s3,a5
    80000d0a:	e0bc                	sd	a5,64(s1)
      p->frozen = 0;  // Initialize frozen flag
    80000d0c:	0204aa23          	sw	zero,52(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d10:	16848493          	addi	s1,s1,360
    80000d14:	fd449be3          	bne	s1,s4,80000cea <procinit+0x72>
  }
}
    80000d18:	70e2                	ld	ra,56(sp)
    80000d1a:	7442                	ld	s0,48(sp)
    80000d1c:	74a2                	ld	s1,40(sp)
    80000d1e:	7902                	ld	s2,32(sp)
    80000d20:	69e2                	ld	s3,24(sp)
    80000d22:	6a42                	ld	s4,16(sp)
    80000d24:	6aa2                	ld	s5,8(sp)
    80000d26:	6b02                	ld	s6,0(sp)
    80000d28:	6121                	addi	sp,sp,64
    80000d2a:	8082                	ret

0000000080000d2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d2c:	1141                	addi	sp,sp,-16
    80000d2e:	e406                	sd	ra,8(sp)
    80000d30:	e022                	sd	s0,0(sp)
    80000d32:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d34:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d36:	2501                	sext.w	a0,a0
    80000d38:	60a2                	ld	ra,8(sp)
    80000d3a:	6402                	ld	s0,0(sp)
    80000d3c:	0141                	addi	sp,sp,16
    80000d3e:	8082                	ret

0000000080000d40 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d40:	1141                	addi	sp,sp,-16
    80000d42:	e406                	sd	ra,8(sp)
    80000d44:	e022                	sd	s0,0(sp)
    80000d46:	0800                	addi	s0,sp,16
    80000d48:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d4a:	2781                	sext.w	a5,a5
    80000d4c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d4e:	00009517          	auipc	a0,0x9
    80000d52:	61250513          	addi	a0,a0,1554 # 8000a360 <cpus>
    80000d56:	953e                	add	a0,a0,a5
    80000d58:	60a2                	ld	ra,8(sp)
    80000d5a:	6402                	ld	s0,0(sp)
    80000d5c:	0141                	addi	sp,sp,16
    80000d5e:	8082                	ret

0000000080000d60 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d60:	1101                	addi	sp,sp,-32
    80000d62:	ec06                	sd	ra,24(sp)
    80000d64:	e822                	sd	s0,16(sp)
    80000d66:	e426                	sd	s1,8(sp)
    80000d68:	1000                	addi	s0,sp,32
  push_off();
    80000d6a:	27b040ef          	jal	800057e4 <push_off>
    80000d6e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d70:	2781                	sext.w	a5,a5
    80000d72:	079e                	slli	a5,a5,0x7
    80000d74:	00009717          	auipc	a4,0x9
    80000d78:	5bc70713          	addi	a4,a4,1468 # 8000a330 <pid_lock>
    80000d7c:	97ba                	add	a5,a5,a4
    80000d7e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d80:	2e9040ef          	jal	80005868 <pop_off>
  return p;
}
    80000d84:	8526                	mv	a0,s1
    80000d86:	60e2                	ld	ra,24(sp)
    80000d88:	6442                	ld	s0,16(sp)
    80000d8a:	64a2                	ld	s1,8(sp)
    80000d8c:	6105                	addi	sp,sp,32
    80000d8e:	8082                	ret

0000000080000d90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e406                	sd	ra,8(sp)
    80000d94:	e022                	sd	s0,0(sp)
    80000d96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d98:	fc9ff0ef          	jal	80000d60 <myproc>
    80000d9c:	31d040ef          	jal	800058b8 <release>

  if (first) {
    80000da0:	00009797          	auipc	a5,0x9
    80000da4:	4f07a783          	lw	a5,1264(a5) # 8000a290 <first.1>
    80000da8:	e799                	bnez	a5,80000db6 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000daa:	2c9000ef          	jal	80001872 <usertrapret>
}
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret
    fsinit(ROOTDEV);
    80000db6:	4505                	li	a0,1
    80000db8:	724010ef          	jal	800024dc <fsinit>
    first = 0;
    80000dbc:	00009797          	auipc	a5,0x9
    80000dc0:	4c07aa23          	sw	zero,1236(a5) # 8000a290 <first.1>
    __sync_synchronize();
    80000dc4:	0330000f          	fence	rw,rw
    80000dc8:	b7cd                	j	80000daa <forkret+0x1a>

0000000080000dca <allocpid>:
{
    80000dca:	1101                	addi	sp,sp,-32
    80000dcc:	ec06                	sd	ra,24(sp)
    80000dce:	e822                	sd	s0,16(sp)
    80000dd0:	e426                	sd	s1,8(sp)
    80000dd2:	e04a                	sd	s2,0(sp)
    80000dd4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dd6:	00009917          	auipc	s2,0x9
    80000dda:	55a90913          	addi	s2,s2,1370 # 8000a330 <pid_lock>
    80000dde:	854a                	mv	a0,s2
    80000de0:	245040ef          	jal	80005824 <acquire>
  pid = nextpid;
    80000de4:	00009797          	auipc	a5,0x9
    80000de8:	4b078793          	addi	a5,a5,1200 # 8000a294 <nextpid>
    80000dec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dee:	0014871b          	addiw	a4,s1,1
    80000df2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df4:	854a                	mv	a0,s2
    80000df6:	2c3040ef          	jal	800058b8 <release>
}
    80000dfa:	8526                	mv	a0,s1
    80000dfc:	60e2                	ld	ra,24(sp)
    80000dfe:	6442                	ld	s0,16(sp)
    80000e00:	64a2                	ld	s1,8(sp)
    80000e02:	6902                	ld	s2,0(sp)
    80000e04:	6105                	addi	sp,sp,32
    80000e06:	8082                	ret

0000000080000e08 <proc_pagetable>:
{
    80000e08:	1101                	addi	sp,sp,-32
    80000e0a:	ec06                	sd	ra,24(sp)
    80000e0c:	e822                	sd	s0,16(sp)
    80000e0e:	e426                	sd	s1,8(sp)
    80000e10:	e04a                	sd	s2,0(sp)
    80000e12:	1000                	addi	s0,sp,32
    80000e14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e16:	907ff0ef          	jal	8000071c <uvmcreate>
    80000e1a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e1c:	cd05                	beqz	a0,80000e54 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e1e:	4729                	li	a4,10
    80000e20:	00005697          	auipc	a3,0x5
    80000e24:	1e068693          	addi	a3,a3,480 # 80006000 <_trampoline>
    80000e28:	6605                	lui	a2,0x1
    80000e2a:	040005b7          	lui	a1,0x4000
    80000e2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e30:	05b2                	slli	a1,a1,0xc
    80000e32:	e88ff0ef          	jal	800004ba <mappages>
    80000e36:	02054663          	bltz	a0,80000e62 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e3a:	4719                	li	a4,6
    80000e3c:	05893683          	ld	a3,88(s2)
    80000e40:	6605                	lui	a2,0x1
    80000e42:	020005b7          	lui	a1,0x2000
    80000e46:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e48:	05b6                	slli	a1,a1,0xd
    80000e4a:	8526                	mv	a0,s1
    80000e4c:	e6eff0ef          	jal	800004ba <mappages>
    80000e50:	00054f63          	bltz	a0,80000e6e <proc_pagetable+0x66>
}
    80000e54:	8526                	mv	a0,s1
    80000e56:	60e2                	ld	ra,24(sp)
    80000e58:	6442                	ld	s0,16(sp)
    80000e5a:	64a2                	ld	s1,8(sp)
    80000e5c:	6902                	ld	s2,0(sp)
    80000e5e:	6105                	addi	sp,sp,32
    80000e60:	8082                	ret
    uvmfree(pagetable, 0);
    80000e62:	4581                	li	a1,0
    80000e64:	8526                	mv	a0,s1
    80000e66:	a8dff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e6a:	4481                	li	s1,0
    80000e6c:	b7e5                	j	80000e54 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e6e:	4681                	li	a3,0
    80000e70:	4605                	li	a2,1
    80000e72:	040005b7          	lui	a1,0x4000
    80000e76:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e78:	05b2                	slli	a1,a1,0xc
    80000e7a:	8526                	mv	a0,s1
    80000e7c:	fe4ff0ef          	jal	80000660 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e80:	4581                	li	a1,0
    80000e82:	8526                	mv	a0,s1
    80000e84:	a6fff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e88:	4481                	li	s1,0
    80000e8a:	b7e9                	j	80000e54 <proc_pagetable+0x4c>

0000000080000e8c <proc_freepagetable>:
{
    80000e8c:	1101                	addi	sp,sp,-32
    80000e8e:	ec06                	sd	ra,24(sp)
    80000e90:	e822                	sd	s0,16(sp)
    80000e92:	e426                	sd	s1,8(sp)
    80000e94:	e04a                	sd	s2,0(sp)
    80000e96:	1000                	addi	s0,sp,32
    80000e98:	84aa                	mv	s1,a0
    80000e9a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e9c:	4681                	li	a3,0
    80000e9e:	4605                	li	a2,1
    80000ea0:	040005b7          	lui	a1,0x4000
    80000ea4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea6:	05b2                	slli	a1,a1,0xc
    80000ea8:	fb8ff0ef          	jal	80000660 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000eac:	4681                	li	a3,0
    80000eae:	4605                	li	a2,1
    80000eb0:	020005b7          	lui	a1,0x2000
    80000eb4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eb6:	05b6                	slli	a1,a1,0xd
    80000eb8:	8526                	mv	a0,s1
    80000eba:	fa6ff0ef          	jal	80000660 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ebe:	85ca                	mv	a1,s2
    80000ec0:	8526                	mv	a0,s1
    80000ec2:	a31ff0ef          	jal	800008f2 <uvmfree>
}
    80000ec6:	60e2                	ld	ra,24(sp)
    80000ec8:	6442                	ld	s0,16(sp)
    80000eca:	64a2                	ld	s1,8(sp)
    80000ecc:	6902                	ld	s2,0(sp)
    80000ece:	6105                	addi	sp,sp,32
    80000ed0:	8082                	ret

0000000080000ed2 <freeproc>:
{
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	1000                	addi	s0,sp,32
    80000edc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ede:	6d28                	ld	a0,88(a0)
    80000ee0:	c119                	beqz	a0,80000ee6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ee2:	93aff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ee6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000eea:	68a8                	ld	a0,80(s1)
    80000eec:	c501                	beqz	a0,80000ef4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000eee:	64ac                	ld	a1,72(s1)
    80000ef0:	f9dff0ef          	jal	80000e8c <proc_freepagetable>
  p->pagetable = 0;
    80000ef4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ef8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000efc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f00:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f04:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f08:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f0c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f10:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f14:	0004ac23          	sw	zero,24(s1)
}
    80000f18:	60e2                	ld	ra,24(sp)
    80000f1a:	6442                	ld	s0,16(sp)
    80000f1c:	64a2                	ld	s1,8(sp)
    80000f1e:	6105                	addi	sp,sp,32
    80000f20:	8082                	ret

0000000080000f22 <allocproc>:
{
    80000f22:	1101                	addi	sp,sp,-32
    80000f24:	ec06                	sd	ra,24(sp)
    80000f26:	e822                	sd	s0,16(sp)
    80000f28:	e426                	sd	s1,8(sp)
    80000f2a:	e04a                	sd	s2,0(sp)
    80000f2c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2e:	0000a497          	auipc	s1,0xa
    80000f32:	83248493          	addi	s1,s1,-1998 # 8000a760 <proc>
    80000f36:	0000f917          	auipc	s2,0xf
    80000f3a:	22a90913          	addi	s2,s2,554 # 80010160 <tickslock>
    acquire(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	0e5040ef          	jal	80005824 <acquire>
    if(p->state == UNUSED) {
    80000f44:	4c9c                	lw	a5,24(s1)
    80000f46:	cb91                	beqz	a5,80000f5a <allocproc+0x38>
      release(&p->lock);
    80000f48:	8526                	mv	a0,s1
    80000f4a:	16f040ef          	jal	800058b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4e:	16848493          	addi	s1,s1,360
    80000f52:	ff2496e3          	bne	s1,s2,80000f3e <allocproc+0x1c>
  return 0;
    80000f56:	4481                	li	s1,0
    80000f58:	a089                	j	80000f9a <allocproc+0x78>
  p->pid = allocpid();
    80000f5a:	e71ff0ef          	jal	80000dca <allocpid>
    80000f5e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f60:	4785                	li	a5,1
    80000f62:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f64:	99aff0ef          	jal	800000fe <kalloc>
    80000f68:	892a                	mv	s2,a0
    80000f6a:	eca8                	sd	a0,88(s1)
    80000f6c:	cd15                	beqz	a0,80000fa8 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f6e:	8526                	mv	a0,s1
    80000f70:	e99ff0ef          	jal	80000e08 <proc_pagetable>
    80000f74:	892a                	mv	s2,a0
    80000f76:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f78:	c121                	beqz	a0,80000fb8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f7a:	07000613          	li	a2,112
    80000f7e:	4581                	li	a1,0
    80000f80:	06048513          	addi	a0,s1,96
    80000f84:	9caff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f88:	00000797          	auipc	a5,0x0
    80000f8c:	e0878793          	addi	a5,a5,-504 # 80000d90 <forkret>
    80000f90:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f92:	60bc                	ld	a5,64(s1)
    80000f94:	6705                	lui	a4,0x1
    80000f96:	97ba                	add	a5,a5,a4
    80000f98:	f4bc                	sd	a5,104(s1)
}
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	60e2                	ld	ra,24(sp)
    80000f9e:	6442                	ld	s0,16(sp)
    80000fa0:	64a2                	ld	s1,8(sp)
    80000fa2:	6902                	ld	s2,0(sp)
    80000fa4:	6105                	addi	sp,sp,32
    80000fa6:	8082                	ret
    freeproc(p);
    80000fa8:	8526                	mv	a0,s1
    80000faa:	f29ff0ef          	jal	80000ed2 <freeproc>
    release(&p->lock);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	109040ef          	jal	800058b8 <release>
    return 0;
    80000fb4:	84ca                	mv	s1,s2
    80000fb6:	b7d5                	j	80000f9a <allocproc+0x78>
    freeproc(p);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	f19ff0ef          	jal	80000ed2 <freeproc>
    release(&p->lock);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	0f9040ef          	jal	800058b8 <release>
    return 0;
    80000fc4:	84ca                	mv	s1,s2
    80000fc6:	bfd1                	j	80000f9a <allocproc+0x78>

0000000080000fc8 <userinit>:
{
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fd2:	f51ff0ef          	jal	80000f22 <allocproc>
    80000fd6:	84aa                	mv	s1,a0
  initproc = p;
    80000fd8:	00009797          	auipc	a5,0x9
    80000fdc:	30a7bc23          	sd	a0,792(a5) # 8000a2f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe0:	03400613          	li	a2,52
    80000fe4:	00009597          	auipc	a1,0x9
    80000fe8:	2bc58593          	addi	a1,a1,700 # 8000a2a0 <initcode>
    80000fec:	6928                	ld	a0,80(a0)
    80000fee:	f54ff0ef          	jal	80000742 <uvmfirst>
  p->sz = PGSIZE;
    80000ff2:	6785                	lui	a5,0x1
    80000ff4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff6:	6cb8                	ld	a4,88(s1)
    80000ff8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ffc:	6cb8                	ld	a4,88(s1)
    80000ffe:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001000:	4641                	li	a2,16
    80001002:	00006597          	auipc	a1,0x6
    80001006:	1be58593          	addi	a1,a1,446 # 800071c0 <etext+0x1c0>
    8000100a:	15848513          	addi	a0,s1,344
    8000100e:	a92ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    80001012:	00006517          	auipc	a0,0x6
    80001016:	1be50513          	addi	a0,a0,446 # 800071d0 <etext+0x1d0>
    8000101a:	5e7010ef          	jal	80002e00 <namei>
    8000101e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001022:	478d                	li	a5,3
    80001024:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001026:	8526                	mv	a0,s1
    80001028:	091040ef          	jal	800058b8 <release>
}
    8000102c:	60e2                	ld	ra,24(sp)
    8000102e:	6442                	ld	s0,16(sp)
    80001030:	64a2                	ld	s1,8(sp)
    80001032:	6105                	addi	sp,sp,32
    80001034:	8082                	ret

0000000080001036 <growproc>:
{
    80001036:	1101                	addi	sp,sp,-32
    80001038:	ec06                	sd	ra,24(sp)
    8000103a:	e822                	sd	s0,16(sp)
    8000103c:	e426                	sd	s1,8(sp)
    8000103e:	e04a                	sd	s2,0(sp)
    80001040:	1000                	addi	s0,sp,32
    80001042:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001044:	d1dff0ef          	jal	80000d60 <myproc>
    80001048:	84aa                	mv	s1,a0
  sz = p->sz;
    8000104a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000104c:	01204c63          	bgtz	s2,80001064 <growproc+0x2e>
  } else if(n < 0){
    80001050:	02094463          	bltz	s2,80001078 <growproc+0x42>
  p->sz = sz;
    80001054:	e4ac                	sd	a1,72(s1)
  return 0;
    80001056:	4501                	li	a0,0
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6902                	ld	s2,0(sp)
    80001060:	6105                	addi	sp,sp,32
    80001062:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001064:	4691                	li	a3,4
    80001066:	00b90633          	add	a2,s2,a1
    8000106a:	6928                	ld	a0,80(a0)
    8000106c:	f78ff0ef          	jal	800007e4 <uvmalloc>
    80001070:	85aa                	mv	a1,a0
    80001072:	f16d                	bnez	a0,80001054 <growproc+0x1e>
      return -1;
    80001074:	557d                	li	a0,-1
    80001076:	b7cd                	j	80001058 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001078:	00b90633          	add	a2,s2,a1
    8000107c:	6928                	ld	a0,80(a0)
    8000107e:	f22ff0ef          	jal	800007a0 <uvmdealloc>
    80001082:	85aa                	mv	a1,a0
    80001084:	bfc1                	j	80001054 <growproc+0x1e>

0000000080001086 <fork>:
{
    80001086:	7139                	addi	sp,sp,-64
    80001088:	fc06                	sd	ra,56(sp)
    8000108a:	f822                	sd	s0,48(sp)
    8000108c:	f04a                	sd	s2,32(sp)
    8000108e:	e456                	sd	s5,8(sp)
    80001090:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001092:	ccfff0ef          	jal	80000d60 <myproc>
    80001096:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001098:	e8bff0ef          	jal	80000f22 <allocproc>
    8000109c:	0e050a63          	beqz	a0,80001190 <fork+0x10a>
    800010a0:	e852                	sd	s4,16(sp)
    800010a2:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010a4:	048ab603          	ld	a2,72(s5)
    800010a8:	692c                	ld	a1,80(a0)
    800010aa:	050ab503          	ld	a0,80(s5)
    800010ae:	877ff0ef          	jal	80000924 <uvmcopy>
    800010b2:	04054a63          	bltz	a0,80001106 <fork+0x80>
    800010b6:	f426                	sd	s1,40(sp)
    800010b8:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010ba:	048ab783          	ld	a5,72(s5)
    800010be:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010c2:	058ab683          	ld	a3,88(s5)
    800010c6:	87b6                	mv	a5,a3
    800010c8:	058a3703          	ld	a4,88(s4)
    800010cc:	12068693          	addi	a3,a3,288
    800010d0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d4:	6788                	ld	a0,8(a5)
    800010d6:	6b8c                	ld	a1,16(a5)
    800010d8:	6f90                	ld	a2,24(a5)
    800010da:	01073023          	sd	a6,0(a4)
    800010de:	e708                	sd	a0,8(a4)
    800010e0:	eb0c                	sd	a1,16(a4)
    800010e2:	ef10                	sd	a2,24(a4)
    800010e4:	02078793          	addi	a5,a5,32
    800010e8:	02070713          	addi	a4,a4,32
    800010ec:	fed792e3          	bne	a5,a3,800010d0 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010f0:	058a3783          	ld	a5,88(s4)
    800010f4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f8:	0d0a8493          	addi	s1,s5,208
    800010fc:	0d0a0913          	addi	s2,s4,208
    80001100:	150a8993          	addi	s3,s5,336
    80001104:	a831                	j	80001120 <fork+0x9a>
    freeproc(np);
    80001106:	8552                	mv	a0,s4
    80001108:	dcbff0ef          	jal	80000ed2 <freeproc>
    release(&np->lock);
    8000110c:	8552                	mv	a0,s4
    8000110e:	7aa040ef          	jal	800058b8 <release>
    return -1;
    80001112:	597d                	li	s2,-1
    80001114:	6a42                	ld	s4,16(sp)
    80001116:	a0b5                	j	80001182 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001118:	04a1                	addi	s1,s1,8
    8000111a:	0921                	addi	s2,s2,8
    8000111c:	01348963          	beq	s1,s3,8000112e <fork+0xa8>
    if(p->ofile[i])
    80001120:	6088                	ld	a0,0(s1)
    80001122:	d97d                	beqz	a0,80001118 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001124:	278020ef          	jal	8000339c <filedup>
    80001128:	00a93023          	sd	a0,0(s2)
    8000112c:	b7f5                	j	80001118 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112e:	150ab503          	ld	a0,336(s5)
    80001132:	5a8010ef          	jal	800026da <idup>
    80001136:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000113a:	4641                	li	a2,16
    8000113c:	158a8593          	addi	a1,s5,344
    80001140:	158a0513          	addi	a0,s4,344
    80001144:	95cff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001148:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000114c:	8552                	mv	a0,s4
    8000114e:	76a040ef          	jal	800058b8 <release>
  acquire(&wait_lock);
    80001152:	00009497          	auipc	s1,0x9
    80001156:	1f648493          	addi	s1,s1,502 # 8000a348 <wait_lock>
    8000115a:	8526                	mv	a0,s1
    8000115c:	6c8040ef          	jal	80005824 <acquire>
  np->parent = p;
    80001160:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001164:	8526                	mv	a0,s1
    80001166:	752040ef          	jal	800058b8 <release>
  acquire(&np->lock);
    8000116a:	8552                	mv	a0,s4
    8000116c:	6b8040ef          	jal	80005824 <acquire>
  np->state = RUNNABLE;
    80001170:	478d                	li	a5,3
    80001172:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001176:	8552                	mv	a0,s4
    80001178:	740040ef          	jal	800058b8 <release>
  return pid;
    8000117c:	74a2                	ld	s1,40(sp)
    8000117e:	69e2                	ld	s3,24(sp)
    80001180:	6a42                	ld	s4,16(sp)
}
    80001182:	854a                	mv	a0,s2
    80001184:	70e2                	ld	ra,56(sp)
    80001186:	7442                	ld	s0,48(sp)
    80001188:	7902                	ld	s2,32(sp)
    8000118a:	6aa2                	ld	s5,8(sp)
    8000118c:	6121                	addi	sp,sp,64
    8000118e:	8082                	ret
    return -1;
    80001190:	597d                	li	s2,-1
    80001192:	bfc5                	j	80001182 <fork+0xfc>

0000000080001194 <scheduler>:
{
    80001194:	715d                	addi	sp,sp,-80
    80001196:	e486                	sd	ra,72(sp)
    80001198:	e0a2                	sd	s0,64(sp)
    8000119a:	fc26                	sd	s1,56(sp)
    8000119c:	f84a                	sd	s2,48(sp)
    8000119e:	f44e                	sd	s3,40(sp)
    800011a0:	f052                	sd	s4,32(sp)
    800011a2:	ec56                	sd	s5,24(sp)
    800011a4:	e85a                	sd	s6,16(sp)
    800011a6:	e45e                	sd	s7,8(sp)
    800011a8:	e062                	sd	s8,0(sp)
    800011aa:	0880                	addi	s0,sp,80
    800011ac:	8792                	mv	a5,tp
  int id = r_tp();
    800011ae:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b0:	00779b93          	slli	s7,a5,0x7
    800011b4:	00009717          	auipc	a4,0x9
    800011b8:	17c70713          	addi	a4,a4,380 # 8000a330 <pid_lock>
    800011bc:	975e                	add	a4,a4,s7
    800011be:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c2:	00009717          	auipc	a4,0x9
    800011c6:	1a670713          	addi	a4,a4,422 # 8000a368 <cpus+0x8>
    800011ca:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE) {
    800011cc:	498d                	li	s3,3
        c->proc = p;
    800011ce:	079e                	slli	a5,a5,0x7
    800011d0:	00009a17          	auipc	s4,0x9
    800011d4:	160a0a13          	addi	s4,s4,352 # 8000a330 <pid_lock>
    800011d8:	9a3e                	add	s4,s4,a5
        found = 1;
    800011da:	4c05                	li	s8,1
    800011dc:	a899                	j	80001232 <scheduler+0x9e>
        release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	6d8040ef          	jal	800058b8 <release>
        continue;
    800011e4:	a021                	j	800011ec <scheduler+0x58>
      release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	6d0040ef          	jal	800058b8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ec:	16848493          	addi	s1,s1,360
    800011f0:	03248763          	beq	s1,s2,8000121e <scheduler+0x8a>
      acquire(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	62e040ef          	jal	80005824 <acquire>
      if(p->frozen) {
    800011fa:	58dc                	lw	a5,52(s1)
    800011fc:	f3ed                	bnez	a5,800011de <scheduler+0x4a>
      if(p->state == RUNNABLE) {
    800011fe:	4c9c                	lw	a5,24(s1)
    80001200:	ff3793e3          	bne	a5,s3,800011e6 <scheduler+0x52>
        p->state = RUNNING;
    80001204:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001208:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000120c:	06048593          	addi	a1,s1,96
    80001210:	855e                	mv	a0,s7
    80001212:	5b6000ef          	jal	800017c8 <swtch>
        c->proc = 0;
    80001216:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000121a:	8ae2                	mv	s5,s8
    8000121c:	b7e9                	j	800011e6 <scheduler+0x52>
    if(found == 0) {
    8000121e:	000a9a63          	bnez	s5,80001232 <scheduler+0x9e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001222:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001226:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000122e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001232:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001236:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000123a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000123e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001240:	00009497          	auipc	s1,0x9
    80001244:	52048493          	addi	s1,s1,1312 # 8000a760 <proc>
        p->state = RUNNING;
    80001248:	4b11                	li	s6,4
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124a:	0000f917          	auipc	s2,0xf
    8000124e:	f1690913          	addi	s2,s2,-234 # 80010160 <tickslock>
    80001252:	b74d                	j	800011f4 <scheduler+0x60>

0000000080001254 <sched>:
{
    80001254:	7179                	addi	sp,sp,-48
    80001256:	f406                	sd	ra,40(sp)
    80001258:	f022                	sd	s0,32(sp)
    8000125a:	ec26                	sd	s1,24(sp)
    8000125c:	e84a                	sd	s2,16(sp)
    8000125e:	e44e                	sd	s3,8(sp)
    80001260:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001262:	affff0ef          	jal	80000d60 <myproc>
    80001266:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001268:	552040ef          	jal	800057ba <holding>
    8000126c:	c92d                	beqz	a0,800012de <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000126e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001270:	2781                	sext.w	a5,a5
    80001272:	079e                	slli	a5,a5,0x7
    80001274:	00009717          	auipc	a4,0x9
    80001278:	0bc70713          	addi	a4,a4,188 # 8000a330 <pid_lock>
    8000127c:	97ba                	add	a5,a5,a4
    8000127e:	0a87a703          	lw	a4,168(a5)
    80001282:	4785                	li	a5,1
    80001284:	06f71363          	bne	a4,a5,800012ea <sched+0x96>
  if(p->state == RUNNING)
    80001288:	4c98                	lw	a4,24(s1)
    8000128a:	4791                	li	a5,4
    8000128c:	06f70563          	beq	a4,a5,800012f6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001290:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001294:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001296:	e7b5                	bnez	a5,80001302 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001298:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000129a:	00009917          	auipc	s2,0x9
    8000129e:	09690913          	addi	s2,s2,150 # 8000a330 <pid_lock>
    800012a2:	2781                	sext.w	a5,a5
    800012a4:	079e                	slli	a5,a5,0x7
    800012a6:	97ca                	add	a5,a5,s2
    800012a8:	0ac7a983          	lw	s3,172(a5)
    800012ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012ae:	2781                	sext.w	a5,a5
    800012b0:	079e                	slli	a5,a5,0x7
    800012b2:	00009597          	auipc	a1,0x9
    800012b6:	0b658593          	addi	a1,a1,182 # 8000a368 <cpus+0x8>
    800012ba:	95be                	add	a1,a1,a5
    800012bc:	06048513          	addi	a0,s1,96
    800012c0:	508000ef          	jal	800017c8 <swtch>
    800012c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012c6:	2781                	sext.w	a5,a5
    800012c8:	079e                	slli	a5,a5,0x7
    800012ca:	993e                	add	s2,s2,a5
    800012cc:	0b392623          	sw	s3,172(s2)
}
    800012d0:	70a2                	ld	ra,40(sp)
    800012d2:	7402                	ld	s0,32(sp)
    800012d4:	64e2                	ld	s1,24(sp)
    800012d6:	6942                	ld	s2,16(sp)
    800012d8:	69a2                	ld	s3,8(sp)
    800012da:	6145                	addi	sp,sp,48
    800012dc:	8082                	ret
    panic("sched p->lock");
    800012de:	00006517          	auipc	a0,0x6
    800012e2:	efa50513          	addi	a0,a0,-262 # 800071d8 <etext+0x1d8>
    800012e6:	210040ef          	jal	800054f6 <panic>
    panic("sched locks");
    800012ea:	00006517          	auipc	a0,0x6
    800012ee:	efe50513          	addi	a0,a0,-258 # 800071e8 <etext+0x1e8>
    800012f2:	204040ef          	jal	800054f6 <panic>
    panic("sched running");
    800012f6:	00006517          	auipc	a0,0x6
    800012fa:	f0250513          	addi	a0,a0,-254 # 800071f8 <etext+0x1f8>
    800012fe:	1f8040ef          	jal	800054f6 <panic>
    panic("sched interruptible");
    80001302:	00006517          	auipc	a0,0x6
    80001306:	f0650513          	addi	a0,a0,-250 # 80007208 <etext+0x208>
    8000130a:	1ec040ef          	jal	800054f6 <panic>

000000008000130e <yield>:
{
    8000130e:	1101                	addi	sp,sp,-32
    80001310:	ec06                	sd	ra,24(sp)
    80001312:	e822                	sd	s0,16(sp)
    80001314:	e426                	sd	s1,8(sp)
    80001316:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001318:	a49ff0ef          	jal	80000d60 <myproc>
    8000131c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000131e:	506040ef          	jal	80005824 <acquire>
  p->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	cc9c                	sw	a5,24(s1)
  sched();
    80001326:	f2fff0ef          	jal	80001254 <sched>
  release(&p->lock);
    8000132a:	8526                	mv	a0,s1
    8000132c:	58c040ef          	jal	800058b8 <release>
}
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret

000000008000133a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000133a:	7179                	addi	sp,sp,-48
    8000133c:	f406                	sd	ra,40(sp)
    8000133e:	f022                	sd	s0,32(sp)
    80001340:	ec26                	sd	s1,24(sp)
    80001342:	e84a                	sd	s2,16(sp)
    80001344:	e44e                	sd	s3,8(sp)
    80001346:	1800                	addi	s0,sp,48
    80001348:	89aa                	mv	s3,a0
    8000134a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000134c:	a15ff0ef          	jal	80000d60 <myproc>
    80001350:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001352:	4d2040ef          	jal	80005824 <acquire>
  release(lk);
    80001356:	854a                	mv	a0,s2
    80001358:	560040ef          	jal	800058b8 <release>

  // Go to sleep.
  p->chan = chan;
    8000135c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001360:	4789                	li	a5,2
    80001362:	cc9c                	sw	a5,24(s1)

  sched();
    80001364:	ef1ff0ef          	jal	80001254 <sched>

  // Tidy up.
  p->chan = 0;
    80001368:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	54a040ef          	jal	800058b8 <release>
  acquire(lk);
    80001372:	854a                	mv	a0,s2
    80001374:	4b0040ef          	jal	80005824 <acquire>
}
    80001378:	70a2                	ld	ra,40(sp)
    8000137a:	7402                	ld	s0,32(sp)
    8000137c:	64e2                	ld	s1,24(sp)
    8000137e:	6942                	ld	s2,16(sp)
    80001380:	69a2                	ld	s3,8(sp)
    80001382:	6145                	addi	sp,sp,48
    80001384:	8082                	ret

0000000080001386 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001386:	7139                	addi	sp,sp,-64
    80001388:	fc06                	sd	ra,56(sp)
    8000138a:	f822                	sd	s0,48(sp)
    8000138c:	f426                	sd	s1,40(sp)
    8000138e:	f04a                	sd	s2,32(sp)
    80001390:	ec4e                	sd	s3,24(sp)
    80001392:	e852                	sd	s4,16(sp)
    80001394:	e456                	sd	s5,8(sp)
    80001396:	0080                	addi	s0,sp,64
    80001398:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	00009497          	auipc	s1,0x9
    8000139e:	3c648493          	addi	s1,s1,966 # 8000a760 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013a2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013a4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	0000f917          	auipc	s2,0xf
    800013aa:	dba90913          	addi	s2,s2,-582 # 80010160 <tickslock>
    800013ae:	a801                	j	800013be <wakeup+0x38>
      }
      release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	506040ef          	jal	800058b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	03248263          	beq	s1,s2,800013de <wakeup+0x58>
    if(p != myproc()){
    800013be:	9a3ff0ef          	jal	80000d60 <myproc>
    800013c2:	fea48ae3          	beq	s1,a0,800013b6 <wakeup+0x30>
      acquire(&p->lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	45c040ef          	jal	80005824 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013cc:	4c9c                	lw	a5,24(s1)
    800013ce:	ff3791e3          	bne	a5,s3,800013b0 <wakeup+0x2a>
    800013d2:	709c                	ld	a5,32(s1)
    800013d4:	fd479ee3          	bne	a5,s4,800013b0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013d8:	0154ac23          	sw	s5,24(s1)
    800013dc:	bfd1                	j	800013b0 <wakeup+0x2a>
    }
  }
}
    800013de:	70e2                	ld	ra,56(sp)
    800013e0:	7442                	ld	s0,48(sp)
    800013e2:	74a2                	ld	s1,40(sp)
    800013e4:	7902                	ld	s2,32(sp)
    800013e6:	69e2                	ld	s3,24(sp)
    800013e8:	6a42                	ld	s4,16(sp)
    800013ea:	6aa2                	ld	s5,8(sp)
    800013ec:	6121                	addi	sp,sp,64
    800013ee:	8082                	ret

00000000800013f0 <reparent>:
{
    800013f0:	7179                	addi	sp,sp,-48
    800013f2:	f406                	sd	ra,40(sp)
    800013f4:	f022                	sd	s0,32(sp)
    800013f6:	ec26                	sd	s1,24(sp)
    800013f8:	e84a                	sd	s2,16(sp)
    800013fa:	e44e                	sd	s3,8(sp)
    800013fc:	e052                	sd	s4,0(sp)
    800013fe:	1800                	addi	s0,sp,48
    80001400:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001402:	00009497          	auipc	s1,0x9
    80001406:	35e48493          	addi	s1,s1,862 # 8000a760 <proc>
      pp->parent = initproc;
    8000140a:	00009a17          	auipc	s4,0x9
    8000140e:	ee6a0a13          	addi	s4,s4,-282 # 8000a2f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001412:	0000f997          	auipc	s3,0xf
    80001416:	d4e98993          	addi	s3,s3,-690 # 80010160 <tickslock>
    8000141a:	a029                	j	80001424 <reparent+0x34>
    8000141c:	16848493          	addi	s1,s1,360
    80001420:	01348b63          	beq	s1,s3,80001436 <reparent+0x46>
    if(pp->parent == p){
    80001424:	7c9c                	ld	a5,56(s1)
    80001426:	ff279be3          	bne	a5,s2,8000141c <reparent+0x2c>
      pp->parent = initproc;
    8000142a:	000a3503          	ld	a0,0(s4)
    8000142e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001430:	f57ff0ef          	jal	80001386 <wakeup>
    80001434:	b7e5                	j	8000141c <reparent+0x2c>
}
    80001436:	70a2                	ld	ra,40(sp)
    80001438:	7402                	ld	s0,32(sp)
    8000143a:	64e2                	ld	s1,24(sp)
    8000143c:	6942                	ld	s2,16(sp)
    8000143e:	69a2                	ld	s3,8(sp)
    80001440:	6a02                	ld	s4,0(sp)
    80001442:	6145                	addi	sp,sp,48
    80001444:	8082                	ret

0000000080001446 <exit>:
{
    80001446:	7179                	addi	sp,sp,-48
    80001448:	f406                	sd	ra,40(sp)
    8000144a:	f022                	sd	s0,32(sp)
    8000144c:	ec26                	sd	s1,24(sp)
    8000144e:	e84a                	sd	s2,16(sp)
    80001450:	e44e                	sd	s3,8(sp)
    80001452:	e052                	sd	s4,0(sp)
    80001454:	1800                	addi	s0,sp,48
    80001456:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001458:	909ff0ef          	jal	80000d60 <myproc>
    8000145c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000145e:	00009797          	auipc	a5,0x9
    80001462:	e927b783          	ld	a5,-366(a5) # 8000a2f0 <initproc>
    80001466:	0d050493          	addi	s1,a0,208
    8000146a:	15050913          	addi	s2,a0,336
    8000146e:	00a79b63          	bne	a5,a0,80001484 <exit+0x3e>
    panic("init exiting");
    80001472:	00006517          	auipc	a0,0x6
    80001476:	dae50513          	addi	a0,a0,-594 # 80007220 <etext+0x220>
    8000147a:	07c040ef          	jal	800054f6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000147e:	04a1                	addi	s1,s1,8
    80001480:	01248963          	beq	s1,s2,80001492 <exit+0x4c>
    if(p->ofile[fd]){
    80001484:	6088                	ld	a0,0(s1)
    80001486:	dd65                	beqz	a0,8000147e <exit+0x38>
      fileclose(f);
    80001488:	75b010ef          	jal	800033e2 <fileclose>
      p->ofile[fd] = 0;
    8000148c:	0004b023          	sd	zero,0(s1)
    80001490:	b7fd                	j	8000147e <exit+0x38>
  begin_op();
    80001492:	331010ef          	jal	80002fc2 <begin_op>
  iput(p->cwd);
    80001496:	1509b503          	ld	a0,336(s3)
    8000149a:	3f8010ef          	jal	80002892 <iput>
  end_op();
    8000149e:	38f010ef          	jal	8000302c <end_op>
  p->cwd = 0;
    800014a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014a6:	00009497          	auipc	s1,0x9
    800014aa:	ea248493          	addi	s1,s1,-350 # 8000a348 <wait_lock>
    800014ae:	8526                	mv	a0,s1
    800014b0:	374040ef          	jal	80005824 <acquire>
  reparent(p);
    800014b4:	854e                	mv	a0,s3
    800014b6:	f3bff0ef          	jal	800013f0 <reparent>
  wakeup(p->parent);
    800014ba:	0389b503          	ld	a0,56(s3)
    800014be:	ec9ff0ef          	jal	80001386 <wakeup>
  acquire(&p->lock);
    800014c2:	854e                	mv	a0,s3
    800014c4:	360040ef          	jal	80005824 <acquire>
  p->xstate = status;
    800014c8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014cc:	4795                	li	a5,5
    800014ce:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014d2:	8526                	mv	a0,s1
    800014d4:	3e4040ef          	jal	800058b8 <release>
  sched();
    800014d8:	d7dff0ef          	jal	80001254 <sched>
  panic("zombie exit");
    800014dc:	00006517          	auipc	a0,0x6
    800014e0:	d5450513          	addi	a0,a0,-684 # 80007230 <etext+0x230>
    800014e4:	012040ef          	jal	800054f6 <panic>

00000000800014e8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014e8:	7179                	addi	sp,sp,-48
    800014ea:	f406                	sd	ra,40(sp)
    800014ec:	f022                	sd	s0,32(sp)
    800014ee:	ec26                	sd	s1,24(sp)
    800014f0:	e84a                	sd	s2,16(sp)
    800014f2:	e44e                	sd	s3,8(sp)
    800014f4:	1800                	addi	s0,sp,48
    800014f6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014f8:	00009497          	auipc	s1,0x9
    800014fc:	26848493          	addi	s1,s1,616 # 8000a760 <proc>
    80001500:	0000f997          	auipc	s3,0xf
    80001504:	c6098993          	addi	s3,s3,-928 # 80010160 <tickslock>
    acquire(&p->lock);
    80001508:	8526                	mv	a0,s1
    8000150a:	31a040ef          	jal	80005824 <acquire>
    if(p->pid == pid){
    8000150e:	589c                	lw	a5,48(s1)
    80001510:	01278b63          	beq	a5,s2,80001526 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	3a2040ef          	jal	800058b8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000151a:	16848493          	addi	s1,s1,360
    8000151e:	ff3495e3          	bne	s1,s3,80001508 <kill+0x20>
  }
  return -1;
    80001522:	557d                	li	a0,-1
    80001524:	a819                	j	8000153a <kill+0x52>
      p->killed = 1;
    80001526:	4785                	li	a5,1
    80001528:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000152a:	4c98                	lw	a4,24(s1)
    8000152c:	4789                	li	a5,2
    8000152e:	00f70d63          	beq	a4,a5,80001548 <kill+0x60>
      release(&p->lock);
    80001532:	8526                	mv	a0,s1
    80001534:	384040ef          	jal	800058b8 <release>
      return 0;
    80001538:	4501                	li	a0,0
}
    8000153a:	70a2                	ld	ra,40(sp)
    8000153c:	7402                	ld	s0,32(sp)
    8000153e:	64e2                	ld	s1,24(sp)
    80001540:	6942                	ld	s2,16(sp)
    80001542:	69a2                	ld	s3,8(sp)
    80001544:	6145                	addi	sp,sp,48
    80001546:	8082                	ret
        p->state = RUNNABLE;
    80001548:	478d                	li	a5,3
    8000154a:	cc9c                	sw	a5,24(s1)
    8000154c:	b7dd                	j	80001532 <kill+0x4a>

000000008000154e <setkilled>:

void
setkilled(struct proc *p)
{
    8000154e:	1101                	addi	sp,sp,-32
    80001550:	ec06                	sd	ra,24(sp)
    80001552:	e822                	sd	s0,16(sp)
    80001554:	e426                	sd	s1,8(sp)
    80001556:	1000                	addi	s0,sp,32
    80001558:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155a:	2ca040ef          	jal	80005824 <acquire>
  p->killed = 1;
    8000155e:	4785                	li	a5,1
    80001560:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001562:	8526                	mv	a0,s1
    80001564:	354040ef          	jal	800058b8 <release>
}
    80001568:	60e2                	ld	ra,24(sp)
    8000156a:	6442                	ld	s0,16(sp)
    8000156c:	64a2                	ld	s1,8(sp)
    8000156e:	6105                	addi	sp,sp,32
    80001570:	8082                	ret

0000000080001572 <killed>:

int
killed(struct proc *p)
{
    80001572:	1101                	addi	sp,sp,-32
    80001574:	ec06                	sd	ra,24(sp)
    80001576:	e822                	sd	s0,16(sp)
    80001578:	e426                	sd	s1,8(sp)
    8000157a:	e04a                	sd	s2,0(sp)
    8000157c:	1000                	addi	s0,sp,32
    8000157e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001580:	2a4040ef          	jal	80005824 <acquire>
  k = p->killed;
    80001584:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	32e040ef          	jal	800058b8 <release>
  return k;
}
    8000158e:	854a                	mv	a0,s2
    80001590:	60e2                	ld	ra,24(sp)
    80001592:	6442                	ld	s0,16(sp)
    80001594:	64a2                	ld	s1,8(sp)
    80001596:	6902                	ld	s2,0(sp)
    80001598:	6105                	addi	sp,sp,32
    8000159a:	8082                	ret

000000008000159c <wait>:
{
    8000159c:	715d                	addi	sp,sp,-80
    8000159e:	e486                	sd	ra,72(sp)
    800015a0:	e0a2                	sd	s0,64(sp)
    800015a2:	fc26                	sd	s1,56(sp)
    800015a4:	f84a                	sd	s2,48(sp)
    800015a6:	f44e                	sd	s3,40(sp)
    800015a8:	f052                	sd	s4,32(sp)
    800015aa:	ec56                	sd	s5,24(sp)
    800015ac:	e85a                	sd	s6,16(sp)
    800015ae:	e45e                	sd	s7,8(sp)
    800015b0:	0880                	addi	s0,sp,80
    800015b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b4:	facff0ef          	jal	80000d60 <myproc>
    800015b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ba:	00009517          	auipc	a0,0x9
    800015be:	d8e50513          	addi	a0,a0,-626 # 8000a348 <wait_lock>
    800015c2:	262040ef          	jal	80005824 <acquire>
        if(pp->state == ZOMBIE){
    800015c6:	4a15                	li	s4,5
        havekids = 1;
    800015c8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ca:	0000f997          	auipc	s3,0xf
    800015ce:	b9698993          	addi	s3,s3,-1130 # 80010160 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d2:	00009b97          	auipc	s7,0x9
    800015d6:	d76b8b93          	addi	s7,s7,-650 # 8000a348 <wait_lock>
    800015da:	a869                	j	80001674 <wait+0xd8>
          pid = pp->pid;
    800015dc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015e0:	000b0c63          	beqz	s6,800015f8 <wait+0x5c>
    800015e4:	4691                	li	a3,4
    800015e6:	02c48613          	addi	a2,s1,44
    800015ea:	85da                	mv	a1,s6
    800015ec:	05093503          	ld	a0,80(s2)
    800015f0:	c14ff0ef          	jal	80000a04 <copyout>
    800015f4:	02054a63          	bltz	a0,80001628 <wait+0x8c>
          freeproc(pp);
    800015f8:	8526                	mv	a0,s1
    800015fa:	8d9ff0ef          	jal	80000ed2 <freeproc>
          release(&pp->lock);
    800015fe:	8526                	mv	a0,s1
    80001600:	2b8040ef          	jal	800058b8 <release>
          release(&wait_lock);
    80001604:	00009517          	auipc	a0,0x9
    80001608:	d4450513          	addi	a0,a0,-700 # 8000a348 <wait_lock>
    8000160c:	2ac040ef          	jal	800058b8 <release>
}
    80001610:	854e                	mv	a0,s3
    80001612:	60a6                	ld	ra,72(sp)
    80001614:	6406                	ld	s0,64(sp)
    80001616:	74e2                	ld	s1,56(sp)
    80001618:	7942                	ld	s2,48(sp)
    8000161a:	79a2                	ld	s3,40(sp)
    8000161c:	7a02                	ld	s4,32(sp)
    8000161e:	6ae2                	ld	s5,24(sp)
    80001620:	6b42                	ld	s6,16(sp)
    80001622:	6ba2                	ld	s7,8(sp)
    80001624:	6161                	addi	sp,sp,80
    80001626:	8082                	ret
            release(&pp->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	28e040ef          	jal	800058b8 <release>
            release(&wait_lock);
    8000162e:	00009517          	auipc	a0,0x9
    80001632:	d1a50513          	addi	a0,a0,-742 # 8000a348 <wait_lock>
    80001636:	282040ef          	jal	800058b8 <release>
            return -1;
    8000163a:	59fd                	li	s3,-1
    8000163c:	bfd1                	j	80001610 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163e:	16848493          	addi	s1,s1,360
    80001642:	03348063          	beq	s1,s3,80001662 <wait+0xc6>
      if(pp->parent == p){
    80001646:	7c9c                	ld	a5,56(s1)
    80001648:	ff279be3          	bne	a5,s2,8000163e <wait+0xa2>
        acquire(&pp->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	1d6040ef          	jal	80005824 <acquire>
        if(pp->state == ZOMBIE){
    80001652:	4c9c                	lw	a5,24(s1)
    80001654:	f94784e3          	beq	a5,s4,800015dc <wait+0x40>
        release(&pp->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	25e040ef          	jal	800058b8 <release>
        havekids = 1;
    8000165e:	8756                	mv	a4,s5
    80001660:	bff9                	j	8000163e <wait+0xa2>
    if(!havekids || killed(p)){
    80001662:	cf19                	beqz	a4,80001680 <wait+0xe4>
    80001664:	854a                	mv	a0,s2
    80001666:	f0dff0ef          	jal	80001572 <killed>
    8000166a:	e919                	bnez	a0,80001680 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000166c:	85de                	mv	a1,s7
    8000166e:	854a                	mv	a0,s2
    80001670:	ccbff0ef          	jal	8000133a <sleep>
    havekids = 0;
    80001674:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001676:	00009497          	auipc	s1,0x9
    8000167a:	0ea48493          	addi	s1,s1,234 # 8000a760 <proc>
    8000167e:	b7e1                	j	80001646 <wait+0xaa>
      release(&wait_lock);
    80001680:	00009517          	auipc	a0,0x9
    80001684:	cc850513          	addi	a0,a0,-824 # 8000a348 <wait_lock>
    80001688:	230040ef          	jal	800058b8 <release>
      return -1;
    8000168c:	59fd                	li	s3,-1
    8000168e:	b749                	j	80001610 <wait+0x74>

0000000080001690 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001690:	7179                	addi	sp,sp,-48
    80001692:	f406                	sd	ra,40(sp)
    80001694:	f022                	sd	s0,32(sp)
    80001696:	ec26                	sd	s1,24(sp)
    80001698:	e84a                	sd	s2,16(sp)
    8000169a:	e44e                	sd	s3,8(sp)
    8000169c:	e052                	sd	s4,0(sp)
    8000169e:	1800                	addi	s0,sp,48
    800016a0:	84aa                	mv	s1,a0
    800016a2:	892e                	mv	s2,a1
    800016a4:	89b2                	mv	s3,a2
    800016a6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a8:	eb8ff0ef          	jal	80000d60 <myproc>
  if(user_dst){
    800016ac:	cc99                	beqz	s1,800016ca <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ae:	86d2                	mv	a3,s4
    800016b0:	864e                	mv	a2,s3
    800016b2:	85ca                	mv	a1,s2
    800016b4:	6928                	ld	a0,80(a0)
    800016b6:	b4eff0ef          	jal	80000a04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016ba:	70a2                	ld	ra,40(sp)
    800016bc:	7402                	ld	s0,32(sp)
    800016be:	64e2                	ld	s1,24(sp)
    800016c0:	6942                	ld	s2,16(sp)
    800016c2:	69a2                	ld	s3,8(sp)
    800016c4:	6a02                	ld	s4,0(sp)
    800016c6:	6145                	addi	sp,sp,48
    800016c8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ca:	000a061b          	sext.w	a2,s4
    800016ce:	85ce                	mv	a1,s3
    800016d0:	854a                	mv	a0,s2
    800016d2:	ae1fe0ef          	jal	800001b2 <memmove>
    return 0;
    800016d6:	8526                	mv	a0,s1
    800016d8:	b7cd                	j	800016ba <either_copyout+0x2a>

00000000800016da <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	892a                	mv	s2,a0
    800016ec:	84ae                	mv	s1,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	e6eff0ef          	jal	80000d60 <myproc>
  if(user_src){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	bb4ff0ef          	jal	80000ab4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove(dst, (char*)src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	a97fe0ef          	jal	800001b2 <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyin+0x2a>

0000000080001724 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001724:	715d                	addi	sp,sp,-80
    80001726:	e486                	sd	ra,72(sp)
    80001728:	e0a2                	sd	s0,64(sp)
    8000172a:	fc26                	sd	s1,56(sp)
    8000172c:	f84a                	sd	s2,48(sp)
    8000172e:	f44e                	sd	s3,40(sp)
    80001730:	f052                	sd	s4,32(sp)
    80001732:	ec56                	sd	s5,24(sp)
    80001734:	e85a                	sd	s6,16(sp)
    80001736:	e45e                	sd	s7,8(sp)
    80001738:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000173a:	00006517          	auipc	a0,0x6
    8000173e:	8de50513          	addi	a0,a0,-1826 # 80007018 <etext+0x18>
    80001742:	2e5030ef          	jal	80005226 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001746:	00009497          	auipc	s1,0x9
    8000174a:	17248493          	addi	s1,s1,370 # 8000a8b8 <proc+0x158>
    8000174e:	0000f917          	auipc	s2,0xf
    80001752:	b6a90913          	addi	s2,s2,-1174 # 800102b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001756:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001758:	00006997          	auipc	s3,0x6
    8000175c:	ae898993          	addi	s3,s3,-1304 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001760:	00006a97          	auipc	s5,0x6
    80001764:	ae8a8a93          	addi	s5,s5,-1304 # 80007248 <etext+0x248>
    printf("\n");
    80001768:	00006a17          	auipc	s4,0x6
    8000176c:	8b0a0a13          	addi	s4,s4,-1872 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001770:	00006b97          	auipc	s7,0x6
    80001774:	000b8b93          	mv	s7,s7
    80001778:	a829                	j	80001792 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000177a:	ed86a583          	lw	a1,-296(a3)
    8000177e:	8556                	mv	a0,s5
    80001780:	2a7030ef          	jal	80005226 <printf>
    printf("\n");
    80001784:	8552                	mv	a0,s4
    80001786:	2a1030ef          	jal	80005226 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000178a:	16848493          	addi	s1,s1,360
    8000178e:	03248263          	beq	s1,s2,800017b2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001792:	86a6                	mv	a3,s1
    80001794:	ec04a783          	lw	a5,-320(s1)
    80001798:	dbed                	beqz	a5,8000178a <procdump+0x66>
      state = "???";
    8000179a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000179c:	fcfb6fe3          	bltu	s6,a5,8000177a <procdump+0x56>
    800017a0:	02079713          	slli	a4,a5,0x20
    800017a4:	01d75793          	srli	a5,a4,0x1d
    800017a8:	97de                	add	a5,a5,s7
    800017aa:	6390                	ld	a2,0(a5)
    800017ac:	f679                	bnez	a2,8000177a <procdump+0x56>
      state = "???";
    800017ae:	864e                	mv	a2,s3
    800017b0:	b7e9                	j	8000177a <procdump+0x56>
  }
}
    800017b2:	60a6                	ld	ra,72(sp)
    800017b4:	6406                	ld	s0,64(sp)
    800017b6:	74e2                	ld	s1,56(sp)
    800017b8:	7942                	ld	s2,48(sp)
    800017ba:	79a2                	ld	s3,40(sp)
    800017bc:	7a02                	ld	s4,32(sp)
    800017be:	6ae2                	ld	s5,24(sp)
    800017c0:	6b42                	ld	s6,16(sp)
    800017c2:	6ba2                	ld	s7,8(sp)
    800017c4:	6161                	addi	sp,sp,80
    800017c6:	8082                	ret

00000000800017c8 <swtch>:
    800017c8:	00153023          	sd	ra,0(a0)
    800017cc:	00253423          	sd	sp,8(a0)
    800017d0:	e900                	sd	s0,16(a0)
    800017d2:	ed04                	sd	s1,24(a0)
    800017d4:	03253023          	sd	s2,32(a0)
    800017d8:	03353423          	sd	s3,40(a0)
    800017dc:	03453823          	sd	s4,48(a0)
    800017e0:	03553c23          	sd	s5,56(a0)
    800017e4:	05653023          	sd	s6,64(a0)
    800017e8:	05753423          	sd	s7,72(a0)
    800017ec:	05853823          	sd	s8,80(a0)
    800017f0:	05953c23          	sd	s9,88(a0)
    800017f4:	07a53023          	sd	s10,96(a0)
    800017f8:	07b53423          	sd	s11,104(a0)
    800017fc:	0005b083          	ld	ra,0(a1)
    80001800:	0085b103          	ld	sp,8(a1)
    80001804:	6980                	ld	s0,16(a1)
    80001806:	6d84                	ld	s1,24(a1)
    80001808:	0205b903          	ld	s2,32(a1)
    8000180c:	0285b983          	ld	s3,40(a1)
    80001810:	0305ba03          	ld	s4,48(a1)
    80001814:	0385ba83          	ld	s5,56(a1)
    80001818:	0405bb03          	ld	s6,64(a1)
    8000181c:	0485bb83          	ld	s7,72(a1)
    80001820:	0505bc03          	ld	s8,80(a1)
    80001824:	0585bc83          	ld	s9,88(a1)
    80001828:	0605bd03          	ld	s10,96(a1)
    8000182c:	0685bd83          	ld	s11,104(a1)
    80001830:	8082                	ret

0000000080001832 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001832:	1141                	addi	sp,sp,-16
    80001834:	e406                	sd	ra,8(sp)
    80001836:	e022                	sd	s0,0(sp)
    80001838:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000183a:	00006597          	auipc	a1,0x6
    8000183e:	a4e58593          	addi	a1,a1,-1458 # 80007288 <etext+0x288>
    80001842:	0000f517          	auipc	a0,0xf
    80001846:	91e50513          	addi	a0,a0,-1762 # 80010160 <tickslock>
    8000184a:	757030ef          	jal	800057a0 <initlock>
}
    8000184e:	60a2                	ld	ra,8(sp)
    80001850:	6402                	ld	s0,0(sp)
    80001852:	0141                	addi	sp,sp,16
    80001854:	8082                	ret

0000000080001856 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001856:	1141                	addi	sp,sp,-16
    80001858:	e406                	sd	ra,8(sp)
    8000185a:	e022                	sd	s0,0(sp)
    8000185c:	0800                	addi	s0,sp,16
// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void 
w_stvec(uint64 x)
{
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000185e:	00003797          	auipc	a5,0x3
    80001862:	f3278793          	addi	a5,a5,-206 # 80004790 <kernelvec>
    80001866:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000186a:	60a2                	ld	ra,8(sp)
    8000186c:	6402                	ld	s0,0(sp)
    8000186e:	0141                	addi	sp,sp,16
    80001870:	8082                	ret

0000000080001872 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001872:	1141                	addi	sp,sp,-16
    80001874:	e406                	sd	ra,8(sp)
    80001876:	e022                	sd	s0,0(sp)
    80001878:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000187a:	ce6ff0ef          	jal	80000d60 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000187e:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001882:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001884:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001888:	00004697          	auipc	a3,0x4
    8000188c:	77868693          	addi	a3,a3,1912 # 80006000 <_trampoline>
    80001890:	00004717          	auipc	a4,0x4
    80001894:	77070713          	addi	a4,a4,1904 # 80006000 <_trampoline>
    80001898:	8f15                	sub	a4,a4,a3
    8000189a:	040007b7          	lui	a5,0x4000
    8000189e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800018a0:	07b2                	slli	a5,a5,0xc
    800018a2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018a4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018aa:	18002673          	csrr	a2,satp
    800018ae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018b0:	6d30                	ld	a2,88(a0)
    800018b2:	6138                	ld	a4,64(a0)
    800018b4:	6585                	lui	a1,0x1
    800018b6:	972e                	add	a4,a4,a1
    800018b8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018ba:	6d38                	ld	a4,88(a0)
    800018bc:	00000617          	auipc	a2,0x0
    800018c0:	11060613          	addi	a2,a2,272 # 800019cc <usertrap>
    800018c4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018c6:	6d38                	ld	a4,88(a0)
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c8:	8612                	mv	a2,tp
    800018ca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018cc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018d0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018d4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018dc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018de:	6f18                	ld	a4,24(a4)
    800018e0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018e4:	6928                	ld	a0,80(a0)
    800018e6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018e8:	00004717          	auipc	a4,0x4
    800018ec:	7b470713          	addi	a4,a4,1972 # 8000609c <userret>
    800018f0:	8f15                	sub	a4,a4,a3
    800018f2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018f4:	577d                	li	a4,-1
    800018f6:	177e                	slli	a4,a4,0x3f
    800018f8:	8d59                	or	a0,a0,a4
    800018fa:	9782                	jalr	a5
}
    800018fc:	60a2                	ld	ra,8(sp)
    800018fe:	6402                	ld	s0,0(sp)
    80001900:	0141                	addi	sp,sp,16
    80001902:	8082                	ret

0000000080001904 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001904:	1101                	addi	sp,sp,-32
    80001906:	ec06                	sd	ra,24(sp)
    80001908:	e822                	sd	s0,16(sp)
    8000190a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000190c:	c20ff0ef          	jal	80000d2c <cpuid>
    80001910:	cd11                	beqz	a0,8000192c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001912:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001916:	000f4737          	lui	a4,0xf4
    8000191a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000191e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001920:	14d79073          	csrw	stimecmp,a5
}
    80001924:	60e2                	ld	ra,24(sp)
    80001926:	6442                	ld	s0,16(sp)
    80001928:	6105                	addi	sp,sp,32
    8000192a:	8082                	ret
    8000192c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000192e:	0000f497          	auipc	s1,0xf
    80001932:	83248493          	addi	s1,s1,-1998 # 80010160 <tickslock>
    80001936:	8526                	mv	a0,s1
    80001938:	6ed030ef          	jal	80005824 <acquire>
    ticks++;
    8000193c:	00009517          	auipc	a0,0x9
    80001940:	9bc50513          	addi	a0,a0,-1604 # 8000a2f8 <ticks>
    80001944:	411c                	lw	a5,0(a0)
    80001946:	2785                	addiw	a5,a5,1
    80001948:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000194a:	a3dff0ef          	jal	80001386 <wakeup>
    release(&tickslock);
    8000194e:	8526                	mv	a0,s1
    80001950:	769030ef          	jal	800058b8 <release>
    80001954:	64a2                	ld	s1,8(sp)
    80001956:	bf75                	j	80001912 <clockintr+0xe>

0000000080001958 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001960:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001964:	57fd                	li	a5,-1
    80001966:	17fe                	slli	a5,a5,0x3f
    80001968:	07a5                	addi	a5,a5,9
    8000196a:	00f70c63          	beq	a4,a5,80001982 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000196e:	57fd                	li	a5,-1
    80001970:	17fe                	slli	a5,a5,0x3f
    80001972:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001974:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001976:	04f70763          	beq	a4,a5,800019c4 <devintr+0x6c>
  }
}
    8000197a:	60e2                	ld	ra,24(sp)
    8000197c:	6442                	ld	s0,16(sp)
    8000197e:	6105                	addi	sp,sp,32
    80001980:	8082                	ret
    80001982:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001984:	6b9020ef          	jal	8000483c <plic_claim>
    80001988:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000198a:	47a9                	li	a5,10
    8000198c:	00f50963          	beq	a0,a5,8000199e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001990:	4785                	li	a5,1
    80001992:	00f50963          	beq	a0,a5,800019a4 <devintr+0x4c>
    return 1;
    80001996:	4505                	li	a0,1
    } else if(irq){
    80001998:	e889                	bnez	s1,800019aa <devintr+0x52>
    8000199a:	64a2                	ld	s1,8(sp)
    8000199c:	bff9                	j	8000197a <devintr+0x22>
      uartintr();
    8000199e:	5c7030ef          	jal	80005764 <uartintr>
    if(irq)
    800019a2:	a819                	j	800019b8 <devintr+0x60>
      virtio_disk_intr();
    800019a4:	328030ef          	jal	80004ccc <virtio_disk_intr>
    if(irq)
    800019a8:	a801                	j	800019b8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019aa:	85a6                	mv	a1,s1
    800019ac:	00006517          	auipc	a0,0x6
    800019b0:	8e450513          	addi	a0,a0,-1820 # 80007290 <etext+0x290>
    800019b4:	073030ef          	jal	80005226 <printf>
      plic_complete(irq);
    800019b8:	8526                	mv	a0,s1
    800019ba:	6a3020ef          	jal	8000485c <plic_complete>
    return 1;
    800019be:	4505                	li	a0,1
    800019c0:	64a2                	ld	s1,8(sp)
    800019c2:	bf65                	j	8000197a <devintr+0x22>
    clockintr();
    800019c4:	f41ff0ef          	jal	80001904 <clockintr>
    return 2;
    800019c8:	4509                	li	a0,2
    800019ca:	bf45                	j	8000197a <devintr+0x22>

00000000800019cc <usertrap>:
{
    800019cc:	1101                	addi	sp,sp,-32
    800019ce:	ec06                	sd	ra,24(sp)
    800019d0:	e822                	sd	s0,16(sp)
    800019d2:	e426                	sd	s1,8(sp)
    800019d4:	e04a                	sd	s2,0(sp)
    800019d6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019dc:	1007f793          	andi	a5,a5,256
    800019e0:	ef85                	bnez	a5,80001a18 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019e2:	00003797          	auipc	a5,0x3
    800019e6:	dae78793          	addi	a5,a5,-594 # 80004790 <kernelvec>
    800019ea:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019ee:	b72ff0ef          	jal	80000d60 <myproc>
    800019f2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019f4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019f6:	14102773          	csrr	a4,sepc
    800019fa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019fc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a00:	47a1                	li	a5,8
    80001a02:	02f70163          	beq	a4,a5,80001a24 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a06:	f53ff0ef          	jal	80001958 <devintr>
    80001a0a:	892a                	mv	s2,a0
    80001a0c:	c135                	beqz	a0,80001a70 <usertrap+0xa4>
  if(killed(p))
    80001a0e:	8526                	mv	a0,s1
    80001a10:	b63ff0ef          	jal	80001572 <killed>
    80001a14:	cd1d                	beqz	a0,80001a52 <usertrap+0x86>
    80001a16:	a81d                	j	80001a4c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a18:	00006517          	auipc	a0,0x6
    80001a1c:	89850513          	addi	a0,a0,-1896 # 800072b0 <etext+0x2b0>
    80001a20:	2d7030ef          	jal	800054f6 <panic>
    if(killed(p))
    80001a24:	b4fff0ef          	jal	80001572 <killed>
    80001a28:	e121                	bnez	a0,80001a68 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a2a:	6cb8                	ld	a4,88(s1)
    80001a2c:	6f1c                	ld	a5,24(a4)
    80001a2e:	0791                	addi	a5,a5,4
    80001a30:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a32:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a36:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a3a:	10079073          	csrw	sstatus,a5
    syscall();
    80001a3e:	240000ef          	jal	80001c7e <syscall>
  if(killed(p))
    80001a42:	8526                	mv	a0,s1
    80001a44:	b2fff0ef          	jal	80001572 <killed>
    80001a48:	c901                	beqz	a0,80001a58 <usertrap+0x8c>
    80001a4a:	4901                	li	s2,0
    exit(-1);
    80001a4c:	557d                	li	a0,-1
    80001a4e:	9f9ff0ef          	jal	80001446 <exit>
  if(which_dev == 2)
    80001a52:	4789                	li	a5,2
    80001a54:	04f90563          	beq	s2,a5,80001a9e <usertrap+0xd2>
  usertrapret();
    80001a58:	e1bff0ef          	jal	80001872 <usertrapret>
}
    80001a5c:	60e2                	ld	ra,24(sp)
    80001a5e:	6442                	ld	s0,16(sp)
    80001a60:	64a2                	ld	s1,8(sp)
    80001a62:	6902                	ld	s2,0(sp)
    80001a64:	6105                	addi	sp,sp,32
    80001a66:	8082                	ret
      exit(-1);
    80001a68:	557d                	li	a0,-1
    80001a6a:	9ddff0ef          	jal	80001446 <exit>
    80001a6e:	bf75                	j	80001a2a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a70:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a74:	5890                	lw	a2,48(s1)
    80001a76:	00006517          	auipc	a0,0x6
    80001a7a:	85a50513          	addi	a0,a0,-1958 # 800072d0 <etext+0x2d0>
    80001a7e:	7a8030ef          	jal	80005226 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a86:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	87650513          	addi	a0,a0,-1930 # 80007300 <etext+0x300>
    80001a92:	794030ef          	jal	80005226 <printf>
    setkilled(p);
    80001a96:	8526                	mv	a0,s1
    80001a98:	ab7ff0ef          	jal	8000154e <setkilled>
    80001a9c:	b75d                	j	80001a42 <usertrap+0x76>
    yield();
    80001a9e:	871ff0ef          	jal	8000130e <yield>
    80001aa2:	bf5d                	j	80001a58 <usertrap+0x8c>

0000000080001aa4 <kerneltrap>:
{
    80001aa4:	7179                	addi	sp,sp,-48
    80001aa6:	f406                	sd	ra,40(sp)
    80001aa8:	f022                	sd	s0,32(sp)
    80001aaa:	ec26                	sd	s1,24(sp)
    80001aac:	e84a                	sd	s2,16(sp)
    80001aae:	e44e                	sd	s3,8(sp)
    80001ab0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ab2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aba:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001abe:	1004f793          	andi	a5,s1,256
    80001ac2:	c795                	beqz	a5,80001aee <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ac8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001aca:	eb85                	bnez	a5,80001afa <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001acc:	e8dff0ef          	jal	80001958 <devintr>
    80001ad0:	c91d                	beqz	a0,80001b06 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ad2:	4789                	li	a5,2
    80001ad4:	04f50a63          	beq	a0,a5,80001b28 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ad8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001adc:	10049073          	csrw	sstatus,s1
}
    80001ae0:	70a2                	ld	ra,40(sp)
    80001ae2:	7402                	ld	s0,32(sp)
    80001ae4:	64e2                	ld	s1,24(sp)
    80001ae6:	6942                	ld	s2,16(sp)
    80001ae8:	69a2                	ld	s3,8(sp)
    80001aea:	6145                	addi	sp,sp,48
    80001aec:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001aee:	00006517          	auipc	a0,0x6
    80001af2:	83a50513          	addi	a0,a0,-1990 # 80007328 <etext+0x328>
    80001af6:	201030ef          	jal	800054f6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001afa:	00006517          	auipc	a0,0x6
    80001afe:	85650513          	addi	a0,a0,-1962 # 80007350 <etext+0x350>
    80001b02:	1f5030ef          	jal	800054f6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b06:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b0a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b0e:	85ce                	mv	a1,s3
    80001b10:	00006517          	auipc	a0,0x6
    80001b14:	86050513          	addi	a0,a0,-1952 # 80007370 <etext+0x370>
    80001b18:	70e030ef          	jal	80005226 <printf>
    panic("kerneltrap");
    80001b1c:	00006517          	auipc	a0,0x6
    80001b20:	87c50513          	addi	a0,a0,-1924 # 80007398 <etext+0x398>
    80001b24:	1d3030ef          	jal	800054f6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b28:	a38ff0ef          	jal	80000d60 <myproc>
    80001b2c:	d555                	beqz	a0,80001ad8 <kerneltrap+0x34>
    yield();
    80001b2e:	fe0ff0ef          	jal	8000130e <yield>
    80001b32:	b75d                	j	80001ad8 <kerneltrap+0x34>

0000000080001b34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b34:	1101                	addi	sp,sp,-32
    80001b36:	ec06                	sd	ra,24(sp)
    80001b38:	e822                	sd	s0,16(sp)
    80001b3a:	e426                	sd	s1,8(sp)
    80001b3c:	1000                	addi	s0,sp,32
    80001b3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b40:	a20ff0ef          	jal	80000d60 <myproc>
  switch (n) {
    80001b44:	4795                	li	a5,5
    80001b46:	0497e163          	bltu	a5,s1,80001b88 <argraw+0x54>
    80001b4a:	048a                	slli	s1,s1,0x2
    80001b4c:	00006717          	auipc	a4,0x6
    80001b50:	c5470713          	addi	a4,a4,-940 # 800077a0 <states.0+0x30>
    80001b54:	94ba                	add	s1,s1,a4
    80001b56:	409c                	lw	a5,0(s1)
    80001b58:	97ba                	add	a5,a5,a4
    80001b5a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b5c:	6d3c                	ld	a5,88(a0)
    80001b5e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b60:	60e2                	ld	ra,24(sp)
    80001b62:	6442                	ld	s0,16(sp)
    80001b64:	64a2                	ld	s1,8(sp)
    80001b66:	6105                	addi	sp,sp,32
    80001b68:	8082                	ret
    return p->trapframe->a1;
    80001b6a:	6d3c                	ld	a5,88(a0)
    80001b6c:	7fa8                	ld	a0,120(a5)
    80001b6e:	bfcd                	j	80001b60 <argraw+0x2c>
    return p->trapframe->a2;
    80001b70:	6d3c                	ld	a5,88(a0)
    80001b72:	63c8                	ld	a0,128(a5)
    80001b74:	b7f5                	j	80001b60 <argraw+0x2c>
    return p->trapframe->a3;
    80001b76:	6d3c                	ld	a5,88(a0)
    80001b78:	67c8                	ld	a0,136(a5)
    80001b7a:	b7dd                	j	80001b60 <argraw+0x2c>
    return p->trapframe->a4;
    80001b7c:	6d3c                	ld	a5,88(a0)
    80001b7e:	6bc8                	ld	a0,144(a5)
    80001b80:	b7c5                	j	80001b60 <argraw+0x2c>
    return p->trapframe->a5;
    80001b82:	6d3c                	ld	a5,88(a0)
    80001b84:	6fc8                	ld	a0,152(a5)
    80001b86:	bfe9                	j	80001b60 <argraw+0x2c>
  panic("argraw");
    80001b88:	00006517          	auipc	a0,0x6
    80001b8c:	82050513          	addi	a0,a0,-2016 # 800073a8 <etext+0x3a8>
    80001b90:	167030ef          	jal	800054f6 <panic>

0000000080001b94 <fetchaddr>:
{
    80001b94:	1101                	addi	sp,sp,-32
    80001b96:	ec06                	sd	ra,24(sp)
    80001b98:	e822                	sd	s0,16(sp)
    80001b9a:	e426                	sd	s1,8(sp)
    80001b9c:	e04a                	sd	s2,0(sp)
    80001b9e:	1000                	addi	s0,sp,32
    80001ba0:	84aa                	mv	s1,a0
    80001ba2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ba4:	9bcff0ef          	jal	80000d60 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba8:	653c                	ld	a5,72(a0)
    80001baa:	02f4f663          	bgeu	s1,a5,80001bd6 <fetchaddr+0x42>
    80001bae:	00848713          	addi	a4,s1,8
    80001bb2:	02e7e463          	bltu	a5,a4,80001bda <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bb6:	46a1                	li	a3,8
    80001bb8:	8626                	mv	a2,s1
    80001bba:	85ca                	mv	a1,s2
    80001bbc:	6928                	ld	a0,80(a0)
    80001bbe:	ef7fe0ef          	jal	80000ab4 <copyin>
    80001bc2:	00a03533          	snez	a0,a0
    80001bc6:	40a0053b          	negw	a0,a0
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6902                	ld	s2,0(sp)
    80001bd2:	6105                	addi	sp,sp,32
    80001bd4:	8082                	ret
    return -1;
    80001bd6:	557d                	li	a0,-1
    80001bd8:	bfcd                	j	80001bca <fetchaddr+0x36>
    80001bda:	557d                	li	a0,-1
    80001bdc:	b7fd                	j	80001bca <fetchaddr+0x36>

0000000080001bde <fetchstr>:
{
    80001bde:	7179                	addi	sp,sp,-48
    80001be0:	f406                	sd	ra,40(sp)
    80001be2:	f022                	sd	s0,32(sp)
    80001be4:	ec26                	sd	s1,24(sp)
    80001be6:	e84a                	sd	s2,16(sp)
    80001be8:	e44e                	sd	s3,8(sp)
    80001bea:	1800                	addi	s0,sp,48
    80001bec:	892a                	mv	s2,a0
    80001bee:	84ae                	mv	s1,a1
    80001bf0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bf2:	96eff0ef          	jal	80000d60 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bf6:	86ce                	mv	a3,s3
    80001bf8:	864a                	mv	a2,s2
    80001bfa:	85a6                	mv	a1,s1
    80001bfc:	6928                	ld	a0,80(a0)
    80001bfe:	f3dfe0ef          	jal	80000b3a <copyinstr>
    80001c02:	00054c63          	bltz	a0,80001c1a <fetchstr+0x3c>
  return strlen(buf);
    80001c06:	8526                	mv	a0,s1
    80001c08:	ecefe0ef          	jal	800002d6 <strlen>
}
    80001c0c:	70a2                	ld	ra,40(sp)
    80001c0e:	7402                	ld	s0,32(sp)
    80001c10:	64e2                	ld	s1,24(sp)
    80001c12:	6942                	ld	s2,16(sp)
    80001c14:	69a2                	ld	s3,8(sp)
    80001c16:	6145                	addi	sp,sp,48
    80001c18:	8082                	ret
    return -1;
    80001c1a:	557d                	li	a0,-1
    80001c1c:	bfc5                	j	80001c0c <fetchstr+0x2e>

0000000080001c1e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	1000                	addi	s0,sp,32
    80001c28:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c2a:	f0bff0ef          	jal	80001b34 <argraw>
    80001c2e:	c088                	sw	a0,0(s1)
}
    80001c30:	60e2                	ld	ra,24(sp)
    80001c32:	6442                	ld	s0,16(sp)
    80001c34:	64a2                	ld	s1,8(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret

0000000080001c3a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c3a:	1101                	addi	sp,sp,-32
    80001c3c:	ec06                	sd	ra,24(sp)
    80001c3e:	e822                	sd	s0,16(sp)
    80001c40:	e426                	sd	s1,8(sp)
    80001c42:	1000                	addi	s0,sp,32
    80001c44:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c46:	eefff0ef          	jal	80001b34 <argraw>
    80001c4a:	e088                	sd	a0,0(s1)
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret

0000000080001c56 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	e04a                	sd	s2,0(sp)
    80001c60:	1000                	addi	s0,sp,32
    80001c62:	84ae                	mv	s1,a1
    80001c64:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c66:	ecfff0ef          	jal	80001b34 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c6a:	864a                	mv	a2,s2
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	f71ff0ef          	jal	80001bde <fetchstr>
}
    80001c72:	60e2                	ld	ra,24(sp)
    80001c74:	6442                	ld	s0,16(sp)
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	6902                	ld	s2,0(sp)
    80001c7a:	6105                	addi	sp,sp,32
    80001c7c:	8082                	ret

0000000080001c7e <syscall>:
[SYS_unfreeze] sys_unfreeze,
};

void
syscall(void)
{
    80001c7e:	1101                	addi	sp,sp,-32
    80001c80:	ec06                	sd	ra,24(sp)
    80001c82:	e822                	sd	s0,16(sp)
    80001c84:	e426                	sd	s1,8(sp)
    80001c86:	e04a                	sd	s2,0(sp)
    80001c88:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c8a:	8d6ff0ef          	jal	80000d60 <myproc>
    80001c8e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c90:	05853903          	ld	s2,88(a0)
    80001c94:	0a893783          	ld	a5,168(s2)
    80001c98:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c9c:	37fd                	addiw	a5,a5,-1
    80001c9e:	4759                	li	a4,22
    80001ca0:	00f76f63          	bltu	a4,a5,80001cbe <syscall+0x40>
    80001ca4:	00369713          	slli	a4,a3,0x3
    80001ca8:	00006797          	auipc	a5,0x6
    80001cac:	b1078793          	addi	a5,a5,-1264 # 800077b8 <syscalls>
    80001cb0:	97ba                	add	a5,a5,a4
    80001cb2:	639c                	ld	a5,0(a5)
    80001cb4:	c789                	beqz	a5,80001cbe <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cb6:	9782                	jalr	a5
    80001cb8:	06a93823          	sd	a0,112(s2)
    80001cbc:	a829                	j	80001cd6 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cbe:	15848613          	addi	a2,s1,344
    80001cc2:	588c                	lw	a1,48(s1)
    80001cc4:	00005517          	auipc	a0,0x5
    80001cc8:	6ec50513          	addi	a0,a0,1772 # 800073b0 <etext+0x3b0>
    80001ccc:	55a030ef          	jal	80005226 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cd0:	6cbc                	ld	a5,88(s1)
    80001cd2:	577d                	li	a4,-1
    80001cd4:	fbb8                	sd	a4,112(a5)
  }
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6902                	ld	s2,0(sp)
    80001cde:	6105                	addi	sp,sp,32
    80001ce0:	8082                	ret

0000000080001ce2 <sys_exit>:

extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cea:	fec40593          	addi	a1,s0,-20
    80001cee:	4501                	li	a0,0
    80001cf0:	f2fff0ef          	jal	80001c1e <argint>
  exit(n);
    80001cf4:	fec42503          	lw	a0,-20(s0)
    80001cf8:	f4eff0ef          	jal	80001446 <exit>
  return 0;  // not reached
}
    80001cfc:	4501                	li	a0,0
    80001cfe:	60e2                	ld	ra,24(sp)
    80001d00:	6442                	ld	s0,16(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret

0000000080001d06 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d06:	1141                	addi	sp,sp,-16
    80001d08:	e406                	sd	ra,8(sp)
    80001d0a:	e022                	sd	s0,0(sp)
    80001d0c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d0e:	852ff0ef          	jal	80000d60 <myproc>
}
    80001d12:	5908                	lw	a0,48(a0)
    80001d14:	60a2                	ld	ra,8(sp)
    80001d16:	6402                	ld	s0,0(sp)
    80001d18:	0141                	addi	sp,sp,16
    80001d1a:	8082                	ret

0000000080001d1c <sys_fork>:

uint64
sys_fork(void)
{
    80001d1c:	1141                	addi	sp,sp,-16
    80001d1e:	e406                	sd	ra,8(sp)
    80001d20:	e022                	sd	s0,0(sp)
    80001d22:	0800                	addi	s0,sp,16
  return fork();
    80001d24:	b62ff0ef          	jal	80001086 <fork>
}
    80001d28:	60a2                	ld	ra,8(sp)
    80001d2a:	6402                	ld	s0,0(sp)
    80001d2c:	0141                	addi	sp,sp,16
    80001d2e:	8082                	ret

0000000080001d30 <sys_wait>:

uint64
sys_wait(void)
{
    80001d30:	1101                	addi	sp,sp,-32
    80001d32:	ec06                	sd	ra,24(sp)
    80001d34:	e822                	sd	s0,16(sp)
    80001d36:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d38:	fe840593          	addi	a1,s0,-24
    80001d3c:	4501                	li	a0,0
    80001d3e:	efdff0ef          	jal	80001c3a <argaddr>
  return wait(p);
    80001d42:	fe843503          	ld	a0,-24(s0)
    80001d46:	857ff0ef          	jal	8000159c <wait>
}
    80001d4a:	60e2                	ld	ra,24(sp)
    80001d4c:	6442                	ld	s0,16(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret

0000000080001d52 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d52:	7179                	addi	sp,sp,-48
    80001d54:	f406                	sd	ra,40(sp)
    80001d56:	f022                	sd	s0,32(sp)
    80001d58:	ec26                	sd	s1,24(sp)
    80001d5a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d5c:	fdc40593          	addi	a1,s0,-36
    80001d60:	4501                	li	a0,0
    80001d62:	ebdff0ef          	jal	80001c1e <argint>
  addr = myproc()->sz;
    80001d66:	ffbfe0ef          	jal	80000d60 <myproc>
    80001d6a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d6c:	fdc42503          	lw	a0,-36(s0)
    80001d70:	ac6ff0ef          	jal	80001036 <growproc>
    80001d74:	00054863          	bltz	a0,80001d84 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d78:	8526                	mv	a0,s1
    80001d7a:	70a2                	ld	ra,40(sp)
    80001d7c:	7402                	ld	s0,32(sp)
    80001d7e:	64e2                	ld	s1,24(sp)
    80001d80:	6145                	addi	sp,sp,48
    80001d82:	8082                	ret
    return -1;
    80001d84:	54fd                	li	s1,-1
    80001d86:	bfcd                	j	80001d78 <sys_sbrk+0x26>

0000000080001d88 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d88:	7139                	addi	sp,sp,-64
    80001d8a:	fc06                	sd	ra,56(sp)
    80001d8c:	f822                	sd	s0,48(sp)
    80001d8e:	f04a                	sd	s2,32(sp)
    80001d90:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d92:	fcc40593          	addi	a1,s0,-52
    80001d96:	4501                	li	a0,0
    80001d98:	e87ff0ef          	jal	80001c1e <argint>
  if(n < 0)
    80001d9c:	fcc42783          	lw	a5,-52(s0)
    80001da0:	0607c763          	bltz	a5,80001e0e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001da4:	0000e517          	auipc	a0,0xe
    80001da8:	3bc50513          	addi	a0,a0,956 # 80010160 <tickslock>
    80001dac:	279030ef          	jal	80005824 <acquire>
  ticks0 = ticks;
    80001db0:	00008917          	auipc	s2,0x8
    80001db4:	54892903          	lw	s2,1352(s2) # 8000a2f8 <ticks>
  while(ticks - ticks0 < n){
    80001db8:	fcc42783          	lw	a5,-52(s0)
    80001dbc:	cf8d                	beqz	a5,80001df6 <sys_sleep+0x6e>
    80001dbe:	f426                	sd	s1,40(sp)
    80001dc0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dc2:	0000e997          	auipc	s3,0xe
    80001dc6:	39e98993          	addi	s3,s3,926 # 80010160 <tickslock>
    80001dca:	00008497          	auipc	s1,0x8
    80001dce:	52e48493          	addi	s1,s1,1326 # 8000a2f8 <ticks>
    if(killed(myproc())){
    80001dd2:	f8ffe0ef          	jal	80000d60 <myproc>
    80001dd6:	f9cff0ef          	jal	80001572 <killed>
    80001dda:	ed0d                	bnez	a0,80001e14 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ddc:	85ce                	mv	a1,s3
    80001dde:	8526                	mv	a0,s1
    80001de0:	d5aff0ef          	jal	8000133a <sleep>
  while(ticks - ticks0 < n){
    80001de4:	409c                	lw	a5,0(s1)
    80001de6:	412787bb          	subw	a5,a5,s2
    80001dea:	fcc42703          	lw	a4,-52(s0)
    80001dee:	fee7e2e3          	bltu	a5,a4,80001dd2 <sys_sleep+0x4a>
    80001df2:	74a2                	ld	s1,40(sp)
    80001df4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001df6:	0000e517          	auipc	a0,0xe
    80001dfa:	36a50513          	addi	a0,a0,874 # 80010160 <tickslock>
    80001dfe:	2bb030ef          	jal	800058b8 <release>
  return 0;
    80001e02:	4501                	li	a0,0
}
    80001e04:	70e2                	ld	ra,56(sp)
    80001e06:	7442                	ld	s0,48(sp)
    80001e08:	7902                	ld	s2,32(sp)
    80001e0a:	6121                	addi	sp,sp,64
    80001e0c:	8082                	ret
    n = 0;
    80001e0e:	fc042623          	sw	zero,-52(s0)
    80001e12:	bf49                	j	80001da4 <sys_sleep+0x1c>
      release(&tickslock);
    80001e14:	0000e517          	auipc	a0,0xe
    80001e18:	34c50513          	addi	a0,a0,844 # 80010160 <tickslock>
    80001e1c:	29d030ef          	jal	800058b8 <release>
      return -1;
    80001e20:	557d                	li	a0,-1
    80001e22:	74a2                	ld	s1,40(sp)
    80001e24:	69e2                	ld	s3,24(sp)
    80001e26:	bff9                	j	80001e04 <sys_sleep+0x7c>

0000000080001e28 <sys_kill>:

uint64
sys_kill(void)
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e30:	fec40593          	addi	a1,s0,-20
    80001e34:	4501                	li	a0,0
    80001e36:	de9ff0ef          	jal	80001c1e <argint>
  return kill(pid);
    80001e3a:	fec42503          	lw	a0,-20(s0)
    80001e3e:	eaaff0ef          	jal	800014e8 <kill>
}
    80001e42:	60e2                	ld	ra,24(sp)
    80001e44:	6442                	ld	s0,16(sp)
    80001e46:	6105                	addi	sp,sp,32
    80001e48:	8082                	ret

0000000080001e4a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e4a:	1101                	addi	sp,sp,-32
    80001e4c:	ec06                	sd	ra,24(sp)
    80001e4e:	e822                	sd	s0,16(sp)
    80001e50:	e426                	sd	s1,8(sp)
    80001e52:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e54:	0000e517          	auipc	a0,0xe
    80001e58:	30c50513          	addi	a0,a0,780 # 80010160 <tickslock>
    80001e5c:	1c9030ef          	jal	80005824 <acquire>
  xticks = ticks;
    80001e60:	00008497          	auipc	s1,0x8
    80001e64:	4984a483          	lw	s1,1176(s1) # 8000a2f8 <ticks>
  release(&tickslock);
    80001e68:	0000e517          	auipc	a0,0xe
    80001e6c:	2f850513          	addi	a0,a0,760 # 80010160 <tickslock>
    80001e70:	249030ef          	jal	800058b8 <release>
  return xticks;
}
    80001e74:	02049513          	slli	a0,s1,0x20
    80001e78:	9101                	srli	a0,a0,0x20
    80001e7a:	60e2                	ld	ra,24(sp)
    80001e7c:	6442                	ld	s0,16(sp)
    80001e7e:	64a2                	ld	s1,8(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret

0000000080001e84 <sys_freeze>:

uint64
sys_freeze(void)
{
    80001e84:	7179                	addi	sp,sp,-48
    80001e86:	f406                	sd	ra,40(sp)
    80001e88:	f022                	sd	s0,32(sp)
    80001e8a:	ec26                	sd	s1,24(sp)
    80001e8c:	e84a                	sd	s2,16(sp)
    80001e8e:	1800                	addi	s0,sp,48
  int pid;
  argint(0, &pid);
    80001e90:	fdc40593          	addi	a1,s0,-36
    80001e94:	4501                	li	a0,0
    80001e96:	d89ff0ef          	jal	80001c1e <argint>
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001e9a:	00009497          	auipc	s1,0x9
    80001e9e:	8c648493          	addi	s1,s1,-1850 # 8000a760 <proc>
    80001ea2:	0000e917          	auipc	s2,0xe
    80001ea6:	2be90913          	addi	s2,s2,702 # 80010160 <tickslock>
    acquire(&p->lock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	179030ef          	jal	80005824 <acquire>
    if(p->pid == pid){
    80001eb0:	5898                	lw	a4,48(s1)
    80001eb2:	fdc42783          	lw	a5,-36(s0)
    80001eb6:	00f70b63          	beq	a4,a5,80001ecc <sys_freeze+0x48>
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	1fd030ef          	jal	800058b8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ec0:	16848493          	addi	s1,s1,360
    80001ec4:	ff2493e3          	bne	s1,s2,80001eaa <sys_freeze+0x26>
  }
  return -1;
    80001ec8:	557d                	li	a0,-1
    80001eca:	a821                	j	80001ee2 <sys_freeze+0x5e>
      if(p->state != ZOMBIE && p->state != UNUSED && !p->frozen){
    80001ecc:	4c9c                	lw	a5,24(s1)
    80001ece:	4715                	li	a4,5
    80001ed0:	00e78563          	beq	a5,a4,80001eda <sys_freeze+0x56>
    80001ed4:	c399                	beqz	a5,80001eda <sys_freeze+0x56>
    80001ed6:	58dc                	lw	a5,52(s1)
    80001ed8:	cb99                	beqz	a5,80001eee <sys_freeze+0x6a>
      release(&p->lock);
    80001eda:	8526                	mv	a0,s1
    80001edc:	1dd030ef          	jal	800058b8 <release>
      return -1;
    80001ee0:	557d                	li	a0,-1
}
    80001ee2:	70a2                	ld	ra,40(sp)
    80001ee4:	7402                	ld	s0,32(sp)
    80001ee6:	64e2                	ld	s1,24(sp)
    80001ee8:	6942                	ld	s2,16(sp)
    80001eea:	6145                	addi	sp,sp,48
    80001eec:	8082                	ret
        p->frozen = 1;  // set frozen flag
    80001eee:	4785                	li	a5,1
    80001ef0:	d8dc                	sw	a5,52(s1)
        release(&p->lock);
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	1c5030ef          	jal	800058b8 <release>
        return 0;
    80001ef8:	4501                	li	a0,0
    80001efa:	b7e5                	j	80001ee2 <sys_freeze+0x5e>

0000000080001efc <sys_unfreeze>:

uint64
sys_unfreeze(void)
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	1800                	addi	s0,sp,48
  int pid;
  argint(0, &pid);
    80001f08:	fdc40593          	addi	a1,s0,-36
    80001f0c:	4501                	li	a0,0
    80001f0e:	d11ff0ef          	jal	80001c1e <argint>
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001f12:	00009497          	auipc	s1,0x9
    80001f16:	84e48493          	addi	s1,s1,-1970 # 8000a760 <proc>
    80001f1a:	0000e917          	auipc	s2,0xe
    80001f1e:	24690913          	addi	s2,s2,582 # 80010160 <tickslock>
    acquire(&p->lock);
    80001f22:	8526                	mv	a0,s1
    80001f24:	101030ef          	jal	80005824 <acquire>
    if(p->pid == pid){
    80001f28:	5898                	lw	a4,48(s1)
    80001f2a:	fdc42783          	lw	a5,-36(s0)
    80001f2e:	00f70b63          	beq	a4,a5,80001f44 <sys_unfreeze+0x48>
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
    80001f32:	8526                	mv	a0,s1
    80001f34:	185030ef          	jal	800058b8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001f38:	16848493          	addi	s1,s1,360
    80001f3c:	ff2493e3          	bne	s1,s2,80001f22 <sys_unfreeze+0x26>
  }
  return -1;
    80001f40:	557d                	li	a0,-1
    80001f42:	a829                	j	80001f5c <sys_unfreeze+0x60>
      if(p->frozen){
    80001f44:	58dc                	lw	a5,52(s1)
    80001f46:	c785                	beqz	a5,80001f6e <sys_unfreeze+0x72>
        p->frozen = 0;  // clear frozen flag
    80001f48:	0204aa23          	sw	zero,52(s1)
        if(p->state == SLEEPING) {
    80001f4c:	4c98                	lw	a4,24(s1)
    80001f4e:	4789                	li	a5,2
    80001f50:	00f70c63          	beq	a4,a5,80001f68 <sys_unfreeze+0x6c>
        release(&p->lock);
    80001f54:	8526                	mv	a0,s1
    80001f56:	163030ef          	jal	800058b8 <release>
        return 0;
    80001f5a:	4501                	li	a0,0
}
    80001f5c:	70a2                	ld	ra,40(sp)
    80001f5e:	7402                	ld	s0,32(sp)
    80001f60:	64e2                	ld	s1,24(sp)
    80001f62:	6942                	ld	s2,16(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret
          p->state = RUNNABLE;
    80001f68:	478d                	li	a5,3
    80001f6a:	cc9c                	sw	a5,24(s1)
    80001f6c:	b7e5                	j	80001f54 <sys_unfreeze+0x58>
      release(&p->lock);
    80001f6e:	8526                	mv	a0,s1
    80001f70:	149030ef          	jal	800058b8 <release>
      return -1;
    80001f74:	557d                	li	a0,-1
    80001f76:	b7dd                	j	80001f5c <sys_unfreeze+0x60>

0000000080001f78 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f78:	7179                	addi	sp,sp,-48
    80001f7a:	f406                	sd	ra,40(sp)
    80001f7c:	f022                	sd	s0,32(sp)
    80001f7e:	ec26                	sd	s1,24(sp)
    80001f80:	e84a                	sd	s2,16(sp)
    80001f82:	e44e                	sd	s3,8(sp)
    80001f84:	e052                	sd	s4,0(sp)
    80001f86:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f88:	00005597          	auipc	a1,0x5
    80001f8c:	44858593          	addi	a1,a1,1096 # 800073d0 <etext+0x3d0>
    80001f90:	0000e517          	auipc	a0,0xe
    80001f94:	1e850513          	addi	a0,a0,488 # 80010178 <bcache>
    80001f98:	009030ef          	jal	800057a0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f9c:	00016797          	auipc	a5,0x16
    80001fa0:	1dc78793          	addi	a5,a5,476 # 80018178 <bcache+0x8000>
    80001fa4:	00016717          	auipc	a4,0x16
    80001fa8:	43c70713          	addi	a4,a4,1084 # 800183e0 <bcache+0x8268>
    80001fac:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fb0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fb4:	0000e497          	auipc	s1,0xe
    80001fb8:	1dc48493          	addi	s1,s1,476 # 80010190 <bcache+0x18>
    b->next = bcache.head.next;
    80001fbc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fbe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fc0:	00005a17          	auipc	s4,0x5
    80001fc4:	418a0a13          	addi	s4,s4,1048 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001fc8:	2b893783          	ld	a5,696(s2)
    80001fcc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fce:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fd2:	85d2                	mv	a1,s4
    80001fd4:	01048513          	addi	a0,s1,16
    80001fd8:	244010ef          	jal	8000321c <initsleeplock>
    bcache.head.next->prev = b;
    80001fdc:	2b893783          	ld	a5,696(s2)
    80001fe0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fe2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fe6:	45848493          	addi	s1,s1,1112
    80001fea:	fd349fe3          	bne	s1,s3,80001fc8 <binit+0x50>
  }
}
    80001fee:	70a2                	ld	ra,40(sp)
    80001ff0:	7402                	ld	s0,32(sp)
    80001ff2:	64e2                	ld	s1,24(sp)
    80001ff4:	6942                	ld	s2,16(sp)
    80001ff6:	69a2                	ld	s3,8(sp)
    80001ff8:	6a02                	ld	s4,0(sp)
    80001ffa:	6145                	addi	sp,sp,48
    80001ffc:	8082                	ret

0000000080001ffe <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001ffe:	7179                	addi	sp,sp,-48
    80002000:	f406                	sd	ra,40(sp)
    80002002:	f022                	sd	s0,32(sp)
    80002004:	ec26                	sd	s1,24(sp)
    80002006:	e84a                	sd	s2,16(sp)
    80002008:	e44e                	sd	s3,8(sp)
    8000200a:	1800                	addi	s0,sp,48
    8000200c:	892a                	mv	s2,a0
    8000200e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002010:	0000e517          	auipc	a0,0xe
    80002014:	16850513          	addi	a0,a0,360 # 80010178 <bcache>
    80002018:	00d030ef          	jal	80005824 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000201c:	00016497          	auipc	s1,0x16
    80002020:	4144b483          	ld	s1,1044(s1) # 80018430 <bcache+0x82b8>
    80002024:	00016797          	auipc	a5,0x16
    80002028:	3bc78793          	addi	a5,a5,956 # 800183e0 <bcache+0x8268>
    8000202c:	02f48b63          	beq	s1,a5,80002062 <bread+0x64>
    80002030:	873e                	mv	a4,a5
    80002032:	a021                	j	8000203a <bread+0x3c>
    80002034:	68a4                	ld	s1,80(s1)
    80002036:	02e48663          	beq	s1,a4,80002062 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000203a:	449c                	lw	a5,8(s1)
    8000203c:	ff279ce3          	bne	a5,s2,80002034 <bread+0x36>
    80002040:	44dc                	lw	a5,12(s1)
    80002042:	ff3799e3          	bne	a5,s3,80002034 <bread+0x36>
      b->refcnt++;
    80002046:	40bc                	lw	a5,64(s1)
    80002048:	2785                	addiw	a5,a5,1
    8000204a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000204c:	0000e517          	auipc	a0,0xe
    80002050:	12c50513          	addi	a0,a0,300 # 80010178 <bcache>
    80002054:	065030ef          	jal	800058b8 <release>
      acquiresleep(&b->lock);
    80002058:	01048513          	addi	a0,s1,16
    8000205c:	1f6010ef          	jal	80003252 <acquiresleep>
      return b;
    80002060:	a889                	j	800020b2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002062:	00016497          	auipc	s1,0x16
    80002066:	3c64b483          	ld	s1,966(s1) # 80018428 <bcache+0x82b0>
    8000206a:	00016797          	auipc	a5,0x16
    8000206e:	37678793          	addi	a5,a5,886 # 800183e0 <bcache+0x8268>
    80002072:	00f48863          	beq	s1,a5,80002082 <bread+0x84>
    80002076:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002078:	40bc                	lw	a5,64(s1)
    8000207a:	cb91                	beqz	a5,8000208e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000207c:	64a4                	ld	s1,72(s1)
    8000207e:	fee49de3          	bne	s1,a4,80002078 <bread+0x7a>
  panic("bget: no buffers");
    80002082:	00005517          	auipc	a0,0x5
    80002086:	35e50513          	addi	a0,a0,862 # 800073e0 <etext+0x3e0>
    8000208a:	46c030ef          	jal	800054f6 <panic>
      b->dev = dev;
    8000208e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002092:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002096:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000209a:	4785                	li	a5,1
    8000209c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000209e:	0000e517          	auipc	a0,0xe
    800020a2:	0da50513          	addi	a0,a0,218 # 80010178 <bcache>
    800020a6:	013030ef          	jal	800058b8 <release>
      acquiresleep(&b->lock);
    800020aa:	01048513          	addi	a0,s1,16
    800020ae:	1a4010ef          	jal	80003252 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020b2:	409c                	lw	a5,0(s1)
    800020b4:	cb89                	beqz	a5,800020c6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020b6:	8526                	mv	a0,s1
    800020b8:	70a2                	ld	ra,40(sp)
    800020ba:	7402                	ld	s0,32(sp)
    800020bc:	64e2                	ld	s1,24(sp)
    800020be:	6942                	ld	s2,16(sp)
    800020c0:	69a2                	ld	s3,8(sp)
    800020c2:	6145                	addi	sp,sp,48
    800020c4:	8082                	ret
    virtio_disk_rw(b, 0);
    800020c6:	4581                	li	a1,0
    800020c8:	8526                	mv	a0,s1
    800020ca:	1f7020ef          	jal	80004ac0 <virtio_disk_rw>
    b->valid = 1;
    800020ce:	4785                	li	a5,1
    800020d0:	c09c                	sw	a5,0(s1)
  return b;
    800020d2:	b7d5                	j	800020b6 <bread+0xb8>

00000000800020d4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020e0:	0541                	addi	a0,a0,16
    800020e2:	1ee010ef          	jal	800032d0 <holdingsleep>
    800020e6:	c911                	beqz	a0,800020fa <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020e8:	4585                	li	a1,1
    800020ea:	8526                	mv	a0,s1
    800020ec:	1d5020ef          	jal	80004ac0 <virtio_disk_rw>
}
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret
    panic("bwrite");
    800020fa:	00005517          	auipc	a0,0x5
    800020fe:	2fe50513          	addi	a0,a0,766 # 800073f8 <etext+0x3f8>
    80002102:	3f4030ef          	jal	800054f6 <panic>

0000000080002106 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	e04a                	sd	s2,0(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002114:	01050913          	addi	s2,a0,16
    80002118:	854a                	mv	a0,s2
    8000211a:	1b6010ef          	jal	800032d0 <holdingsleep>
    8000211e:	c125                	beqz	a0,8000217e <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002120:	854a                	mv	a0,s2
    80002122:	176010ef          	jal	80003298 <releasesleep>

  acquire(&bcache.lock);
    80002126:	0000e517          	auipc	a0,0xe
    8000212a:	05250513          	addi	a0,a0,82 # 80010178 <bcache>
    8000212e:	6f6030ef          	jal	80005824 <acquire>
  b->refcnt--;
    80002132:	40bc                	lw	a5,64(s1)
    80002134:	37fd                	addiw	a5,a5,-1
    80002136:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002138:	e79d                	bnez	a5,80002166 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000213a:	68b8                	ld	a4,80(s1)
    8000213c:	64bc                	ld	a5,72(s1)
    8000213e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002140:	68b8                	ld	a4,80(s1)
    80002142:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002144:	00016797          	auipc	a5,0x16
    80002148:	03478793          	addi	a5,a5,52 # 80018178 <bcache+0x8000>
    8000214c:	2b87b703          	ld	a4,696(a5)
    80002150:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002152:	00016717          	auipc	a4,0x16
    80002156:	28e70713          	addi	a4,a4,654 # 800183e0 <bcache+0x8268>
    8000215a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000215c:	2b87b703          	ld	a4,696(a5)
    80002160:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002162:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002166:	0000e517          	auipc	a0,0xe
    8000216a:	01250513          	addi	a0,a0,18 # 80010178 <bcache>
    8000216e:	74a030ef          	jal	800058b8 <release>
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	64a2                	ld	s1,8(sp)
    80002178:	6902                	ld	s2,0(sp)
    8000217a:	6105                	addi	sp,sp,32
    8000217c:	8082                	ret
    panic("brelse");
    8000217e:	00005517          	auipc	a0,0x5
    80002182:	28250513          	addi	a0,a0,642 # 80007400 <etext+0x400>
    80002186:	370030ef          	jal	800054f6 <panic>

000000008000218a <bpin>:

void
bpin(struct buf *b) {
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	e426                	sd	s1,8(sp)
    80002192:	1000                	addi	s0,sp,32
    80002194:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002196:	0000e517          	auipc	a0,0xe
    8000219a:	fe250513          	addi	a0,a0,-30 # 80010178 <bcache>
    8000219e:	686030ef          	jal	80005824 <acquire>
  b->refcnt++;
    800021a2:	40bc                	lw	a5,64(s1)
    800021a4:	2785                	addiw	a5,a5,1
    800021a6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021a8:	0000e517          	auipc	a0,0xe
    800021ac:	fd050513          	addi	a0,a0,-48 # 80010178 <bcache>
    800021b0:	708030ef          	jal	800058b8 <release>
}
    800021b4:	60e2                	ld	ra,24(sp)
    800021b6:	6442                	ld	s0,16(sp)
    800021b8:	64a2                	ld	s1,8(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <bunpin>:

void
bunpin(struct buf *b) {
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	1000                	addi	s0,sp,32
    800021c8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021ca:	0000e517          	auipc	a0,0xe
    800021ce:	fae50513          	addi	a0,a0,-82 # 80010178 <bcache>
    800021d2:	652030ef          	jal	80005824 <acquire>
  b->refcnt--;
    800021d6:	40bc                	lw	a5,64(s1)
    800021d8:	37fd                	addiw	a5,a5,-1
    800021da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021dc:	0000e517          	auipc	a0,0xe
    800021e0:	f9c50513          	addi	a0,a0,-100 # 80010178 <bcache>
    800021e4:	6d4030ef          	jal	800058b8 <release>
}
    800021e8:	60e2                	ld	ra,24(sp)
    800021ea:	6442                	ld	s0,16(sp)
    800021ec:	64a2                	ld	s1,8(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	e426                	sd	s1,8(sp)
    800021fa:	e04a                	sd	s2,0(sp)
    800021fc:	1000                	addi	s0,sp,32
    800021fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002200:	00d5d79b          	srliw	a5,a1,0xd
    80002204:	00016597          	auipc	a1,0x16
    80002208:	6505a583          	lw	a1,1616(a1) # 80018854 <sb+0x1c>
    8000220c:	9dbd                	addw	a1,a1,a5
    8000220e:	df1ff0ef          	jal	80001ffe <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002212:	0074f713          	andi	a4,s1,7
    80002216:	4785                	li	a5,1
    80002218:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000221c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000221e:	90d9                	srli	s1,s1,0x36
    80002220:	00950733          	add	a4,a0,s1
    80002224:	05874703          	lbu	a4,88(a4)
    80002228:	00e7f6b3          	and	a3,a5,a4
    8000222c:	c29d                	beqz	a3,80002252 <bfree+0x60>
    8000222e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002230:	94aa                	add	s1,s1,a0
    80002232:	fff7c793          	not	a5,a5
    80002236:	8f7d                	and	a4,a4,a5
    80002238:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000223c:	711000ef          	jal	8000314c <log_write>
  brelse(bp);
    80002240:	854a                	mv	a0,s2
    80002242:	ec5ff0ef          	jal	80002106 <brelse>
}
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	64a2                	ld	s1,8(sp)
    8000224c:	6902                	ld	s2,0(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret
    panic("freeing free block");
    80002252:	00005517          	auipc	a0,0x5
    80002256:	1b650513          	addi	a0,a0,438 # 80007408 <etext+0x408>
    8000225a:	29c030ef          	jal	800054f6 <panic>

000000008000225e <balloc>:
{
    8000225e:	715d                	addi	sp,sp,-80
    80002260:	e486                	sd	ra,72(sp)
    80002262:	e0a2                	sd	s0,64(sp)
    80002264:	fc26                	sd	s1,56(sp)
    80002266:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002268:	00016797          	auipc	a5,0x16
    8000226c:	5d47a783          	lw	a5,1492(a5) # 8001883c <sb+0x4>
    80002270:	0e078863          	beqz	a5,80002360 <balloc+0x102>
    80002274:	f84a                	sd	s2,48(sp)
    80002276:	f44e                	sd	s3,40(sp)
    80002278:	f052                	sd	s4,32(sp)
    8000227a:	ec56                	sd	s5,24(sp)
    8000227c:	e85a                	sd	s6,16(sp)
    8000227e:	e45e                	sd	s7,8(sp)
    80002280:	e062                	sd	s8,0(sp)
    80002282:	8baa                	mv	s7,a0
    80002284:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002286:	00016b17          	auipc	s6,0x16
    8000228a:	5b2b0b13          	addi	s6,s6,1458 # 80018838 <sb>
      m = 1 << (bi % 8);
    8000228e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002290:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002292:	6c09                	lui	s8,0x2
    80002294:	a09d                	j	800022fa <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002296:	97ca                	add	a5,a5,s2
    80002298:	8e55                	or	a2,a2,a3
    8000229a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000229e:	854a                	mv	a0,s2
    800022a0:	6ad000ef          	jal	8000314c <log_write>
        brelse(bp);
    800022a4:	854a                	mv	a0,s2
    800022a6:	e61ff0ef          	jal	80002106 <brelse>
  bp = bread(dev, bno);
    800022aa:	85a6                	mv	a1,s1
    800022ac:	855e                	mv	a0,s7
    800022ae:	d51ff0ef          	jal	80001ffe <bread>
    800022b2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022b4:	40000613          	li	a2,1024
    800022b8:	4581                	li	a1,0
    800022ba:	05850513          	addi	a0,a0,88
    800022be:	e91fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800022c2:	854a                	mv	a0,s2
    800022c4:	689000ef          	jal	8000314c <log_write>
  brelse(bp);
    800022c8:	854a                	mv	a0,s2
    800022ca:	e3dff0ef          	jal	80002106 <brelse>
}
    800022ce:	7942                	ld	s2,48(sp)
    800022d0:	79a2                	ld	s3,40(sp)
    800022d2:	7a02                	ld	s4,32(sp)
    800022d4:	6ae2                	ld	s5,24(sp)
    800022d6:	6b42                	ld	s6,16(sp)
    800022d8:	6ba2                	ld	s7,8(sp)
    800022da:	6c02                	ld	s8,0(sp)
}
    800022dc:	8526                	mv	a0,s1
    800022de:	60a6                	ld	ra,72(sp)
    800022e0:	6406                	ld	s0,64(sp)
    800022e2:	74e2                	ld	s1,56(sp)
    800022e4:	6161                	addi	sp,sp,80
    800022e6:	8082                	ret
    brelse(bp);
    800022e8:	854a                	mv	a0,s2
    800022ea:	e1dff0ef          	jal	80002106 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022ee:	015c0abb          	addw	s5,s8,s5
    800022f2:	004b2783          	lw	a5,4(s6)
    800022f6:	04fafe63          	bgeu	s5,a5,80002352 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800022fa:	41fad79b          	sraiw	a5,s5,0x1f
    800022fe:	0137d79b          	srliw	a5,a5,0x13
    80002302:	015787bb          	addw	a5,a5,s5
    80002306:	40d7d79b          	sraiw	a5,a5,0xd
    8000230a:	01cb2583          	lw	a1,28(s6)
    8000230e:	9dbd                	addw	a1,a1,a5
    80002310:	855e                	mv	a0,s7
    80002312:	cedff0ef          	jal	80001ffe <bread>
    80002316:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002318:	004b2503          	lw	a0,4(s6)
    8000231c:	84d6                	mv	s1,s5
    8000231e:	4701                	li	a4,0
    80002320:	fca4f4e3          	bgeu	s1,a0,800022e8 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002324:	00777693          	andi	a3,a4,7
    80002328:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000232c:	41f7579b          	sraiw	a5,a4,0x1f
    80002330:	01d7d79b          	srliw	a5,a5,0x1d
    80002334:	9fb9                	addw	a5,a5,a4
    80002336:	4037d79b          	sraiw	a5,a5,0x3
    8000233a:	00f90633          	add	a2,s2,a5
    8000233e:	05864603          	lbu	a2,88(a2)
    80002342:	00c6f5b3          	and	a1,a3,a2
    80002346:	d9a1                	beqz	a1,80002296 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002348:	2705                	addiw	a4,a4,1
    8000234a:	2485                	addiw	s1,s1,1
    8000234c:	fd471ae3          	bne	a4,s4,80002320 <balloc+0xc2>
    80002350:	bf61                	j	800022e8 <balloc+0x8a>
    80002352:	7942                	ld	s2,48(sp)
    80002354:	79a2                	ld	s3,40(sp)
    80002356:	7a02                	ld	s4,32(sp)
    80002358:	6ae2                	ld	s5,24(sp)
    8000235a:	6b42                	ld	s6,16(sp)
    8000235c:	6ba2                	ld	s7,8(sp)
    8000235e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002360:	00005517          	auipc	a0,0x5
    80002364:	0c050513          	addi	a0,a0,192 # 80007420 <etext+0x420>
    80002368:	6bf020ef          	jal	80005226 <printf>
  return 0;
    8000236c:	4481                	li	s1,0
    8000236e:	b7bd                	j	800022dc <balloc+0x7e>

0000000080002370 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002370:	7179                	addi	sp,sp,-48
    80002372:	f406                	sd	ra,40(sp)
    80002374:	f022                	sd	s0,32(sp)
    80002376:	ec26                	sd	s1,24(sp)
    80002378:	e84a                	sd	s2,16(sp)
    8000237a:	e44e                	sd	s3,8(sp)
    8000237c:	1800                	addi	s0,sp,48
    8000237e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002380:	47ad                	li	a5,11
    80002382:	02b7e363          	bltu	a5,a1,800023a8 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002386:	02059793          	slli	a5,a1,0x20
    8000238a:	01e7d593          	srli	a1,a5,0x1e
    8000238e:	00b504b3          	add	s1,a0,a1
    80002392:	0504a903          	lw	s2,80(s1)
    80002396:	06091363          	bnez	s2,800023fc <bmap+0x8c>
      addr = balloc(ip->dev);
    8000239a:	4108                	lw	a0,0(a0)
    8000239c:	ec3ff0ef          	jal	8000225e <balloc>
    800023a0:	892a                	mv	s2,a0
      if(addr == 0)
    800023a2:	cd29                	beqz	a0,800023fc <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800023a4:	c8a8                	sw	a0,80(s1)
    800023a6:	a899                	j	800023fc <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023a8:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800023ac:	0ff00793          	li	a5,255
    800023b0:	0697e963          	bltu	a5,s1,80002422 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023b4:	08052903          	lw	s2,128(a0)
    800023b8:	00091b63          	bnez	s2,800023ce <bmap+0x5e>
      addr = balloc(ip->dev);
    800023bc:	4108                	lw	a0,0(a0)
    800023be:	ea1ff0ef          	jal	8000225e <balloc>
    800023c2:	892a                	mv	s2,a0
      if(addr == 0)
    800023c4:	cd05                	beqz	a0,800023fc <bmap+0x8c>
    800023c6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023c8:	08a9a023          	sw	a0,128(s3)
    800023cc:	a011                	j	800023d0 <bmap+0x60>
    800023ce:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023d0:	85ca                	mv	a1,s2
    800023d2:	0009a503          	lw	a0,0(s3)
    800023d6:	c29ff0ef          	jal	80001ffe <bread>
    800023da:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023dc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023e0:	02049713          	slli	a4,s1,0x20
    800023e4:	01e75593          	srli	a1,a4,0x1e
    800023e8:	00b784b3          	add	s1,a5,a1
    800023ec:	0004a903          	lw	s2,0(s1)
    800023f0:	00090e63          	beqz	s2,8000240c <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023f4:	8552                	mv	a0,s4
    800023f6:	d11ff0ef          	jal	80002106 <brelse>
    return addr;
    800023fa:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023fc:	854a                	mv	a0,s2
    800023fe:	70a2                	ld	ra,40(sp)
    80002400:	7402                	ld	s0,32(sp)
    80002402:	64e2                	ld	s1,24(sp)
    80002404:	6942                	ld	s2,16(sp)
    80002406:	69a2                	ld	s3,8(sp)
    80002408:	6145                	addi	sp,sp,48
    8000240a:	8082                	ret
      addr = balloc(ip->dev);
    8000240c:	0009a503          	lw	a0,0(s3)
    80002410:	e4fff0ef          	jal	8000225e <balloc>
    80002414:	892a                	mv	s2,a0
      if(addr){
    80002416:	dd79                	beqz	a0,800023f4 <bmap+0x84>
        a[bn] = addr;
    80002418:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000241a:	8552                	mv	a0,s4
    8000241c:	531000ef          	jal	8000314c <log_write>
    80002420:	bfd1                	j	800023f4 <bmap+0x84>
    80002422:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002424:	00005517          	auipc	a0,0x5
    80002428:	01450513          	addi	a0,a0,20 # 80007438 <etext+0x438>
    8000242c:	0ca030ef          	jal	800054f6 <panic>

0000000080002430 <iget>:
{
    80002430:	7179                	addi	sp,sp,-48
    80002432:	f406                	sd	ra,40(sp)
    80002434:	f022                	sd	s0,32(sp)
    80002436:	ec26                	sd	s1,24(sp)
    80002438:	e84a                	sd	s2,16(sp)
    8000243a:	e44e                	sd	s3,8(sp)
    8000243c:	e052                	sd	s4,0(sp)
    8000243e:	1800                	addi	s0,sp,48
    80002440:	89aa                	mv	s3,a0
    80002442:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002444:	00016517          	auipc	a0,0x16
    80002448:	41450513          	addi	a0,a0,1044 # 80018858 <itable>
    8000244c:	3d8030ef          	jal	80005824 <acquire>
  empty = 0;
    80002450:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002452:	00016497          	auipc	s1,0x16
    80002456:	41e48493          	addi	s1,s1,1054 # 80018870 <itable+0x18>
    8000245a:	00018697          	auipc	a3,0x18
    8000245e:	ea668693          	addi	a3,a3,-346 # 8001a300 <log>
    80002462:	a039                	j	80002470 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002464:	02090963          	beqz	s2,80002496 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002468:	08848493          	addi	s1,s1,136
    8000246c:	02d48863          	beq	s1,a3,8000249c <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002470:	449c                	lw	a5,8(s1)
    80002472:	fef059e3          	blez	a5,80002464 <iget+0x34>
    80002476:	4098                	lw	a4,0(s1)
    80002478:	ff3716e3          	bne	a4,s3,80002464 <iget+0x34>
    8000247c:	40d8                	lw	a4,4(s1)
    8000247e:	ff4713e3          	bne	a4,s4,80002464 <iget+0x34>
      ip->ref++;
    80002482:	2785                	addiw	a5,a5,1
    80002484:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002486:	00016517          	auipc	a0,0x16
    8000248a:	3d250513          	addi	a0,a0,978 # 80018858 <itable>
    8000248e:	42a030ef          	jal	800058b8 <release>
      return ip;
    80002492:	8926                	mv	s2,s1
    80002494:	a02d                	j	800024be <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002496:	fbe9                	bnez	a5,80002468 <iget+0x38>
      empty = ip;
    80002498:	8926                	mv	s2,s1
    8000249a:	b7f9                	j	80002468 <iget+0x38>
  if(empty == 0)
    8000249c:	02090a63          	beqz	s2,800024d0 <iget+0xa0>
  ip->dev = dev;
    800024a0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024a4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024a8:	4785                	li	a5,1
    800024aa:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024ae:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024b2:	00016517          	auipc	a0,0x16
    800024b6:	3a650513          	addi	a0,a0,934 # 80018858 <itable>
    800024ba:	3fe030ef          	jal	800058b8 <release>
}
    800024be:	854a                	mv	a0,s2
    800024c0:	70a2                	ld	ra,40(sp)
    800024c2:	7402                	ld	s0,32(sp)
    800024c4:	64e2                	ld	s1,24(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	69a2                	ld	s3,8(sp)
    800024ca:	6a02                	ld	s4,0(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret
    panic("iget: no inodes");
    800024d0:	00005517          	auipc	a0,0x5
    800024d4:	f8050513          	addi	a0,a0,-128 # 80007450 <etext+0x450>
    800024d8:	01e030ef          	jal	800054f6 <panic>

00000000800024dc <fsinit>:
fsinit(int dev) {
    800024dc:	7179                	addi	sp,sp,-48
    800024de:	f406                	sd	ra,40(sp)
    800024e0:	f022                	sd	s0,32(sp)
    800024e2:	ec26                	sd	s1,24(sp)
    800024e4:	e84a                	sd	s2,16(sp)
    800024e6:	e44e                	sd	s3,8(sp)
    800024e8:	1800                	addi	s0,sp,48
    800024ea:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024ec:	4585                	li	a1,1
    800024ee:	b11ff0ef          	jal	80001ffe <bread>
    800024f2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024f4:	00016997          	auipc	s3,0x16
    800024f8:	34498993          	addi	s3,s3,836 # 80018838 <sb>
    800024fc:	02000613          	li	a2,32
    80002500:	05850593          	addi	a1,a0,88
    80002504:	854e                	mv	a0,s3
    80002506:	cadfd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    8000250a:	8526                	mv	a0,s1
    8000250c:	bfbff0ef          	jal	80002106 <brelse>
  if(sb.magic != FSMAGIC)
    80002510:	0009a703          	lw	a4,0(s3)
    80002514:	102037b7          	lui	a5,0x10203
    80002518:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000251c:	02f71063          	bne	a4,a5,8000253c <fsinit+0x60>
  initlog(dev, &sb);
    80002520:	00016597          	auipc	a1,0x16
    80002524:	31858593          	addi	a1,a1,792 # 80018838 <sb>
    80002528:	854a                	mv	a0,s2
    8000252a:	215000ef          	jal	80002f3e <initlog>
}
    8000252e:	70a2                	ld	ra,40(sp)
    80002530:	7402                	ld	s0,32(sp)
    80002532:	64e2                	ld	s1,24(sp)
    80002534:	6942                	ld	s2,16(sp)
    80002536:	69a2                	ld	s3,8(sp)
    80002538:	6145                	addi	sp,sp,48
    8000253a:	8082                	ret
    panic("invalid file system");
    8000253c:	00005517          	auipc	a0,0x5
    80002540:	f2450513          	addi	a0,a0,-220 # 80007460 <etext+0x460>
    80002544:	7b3020ef          	jal	800054f6 <panic>

0000000080002548 <iinit>:
{
    80002548:	7179                	addi	sp,sp,-48
    8000254a:	f406                	sd	ra,40(sp)
    8000254c:	f022                	sd	s0,32(sp)
    8000254e:	ec26                	sd	s1,24(sp)
    80002550:	e84a                	sd	s2,16(sp)
    80002552:	e44e                	sd	s3,8(sp)
    80002554:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002556:	00005597          	auipc	a1,0x5
    8000255a:	f2258593          	addi	a1,a1,-222 # 80007478 <etext+0x478>
    8000255e:	00016517          	auipc	a0,0x16
    80002562:	2fa50513          	addi	a0,a0,762 # 80018858 <itable>
    80002566:	23a030ef          	jal	800057a0 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000256a:	00016497          	auipc	s1,0x16
    8000256e:	31648493          	addi	s1,s1,790 # 80018880 <itable+0x28>
    80002572:	00018997          	auipc	s3,0x18
    80002576:	d9e98993          	addi	s3,s3,-610 # 8001a310 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000257a:	00005917          	auipc	s2,0x5
    8000257e:	f0690913          	addi	s2,s2,-250 # 80007480 <etext+0x480>
    80002582:	85ca                	mv	a1,s2
    80002584:	8526                	mv	a0,s1
    80002586:	497000ef          	jal	8000321c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000258a:	08848493          	addi	s1,s1,136
    8000258e:	ff349ae3          	bne	s1,s3,80002582 <iinit+0x3a>
}
    80002592:	70a2                	ld	ra,40(sp)
    80002594:	7402                	ld	s0,32(sp)
    80002596:	64e2                	ld	s1,24(sp)
    80002598:	6942                	ld	s2,16(sp)
    8000259a:	69a2                	ld	s3,8(sp)
    8000259c:	6145                	addi	sp,sp,48
    8000259e:	8082                	ret

00000000800025a0 <ialloc>:
{
    800025a0:	7139                	addi	sp,sp,-64
    800025a2:	fc06                	sd	ra,56(sp)
    800025a4:	f822                	sd	s0,48(sp)
    800025a6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025a8:	00016717          	auipc	a4,0x16
    800025ac:	29c72703          	lw	a4,668(a4) # 80018844 <sb+0xc>
    800025b0:	4785                	li	a5,1
    800025b2:	06e7f063          	bgeu	a5,a4,80002612 <ialloc+0x72>
    800025b6:	f426                	sd	s1,40(sp)
    800025b8:	f04a                	sd	s2,32(sp)
    800025ba:	ec4e                	sd	s3,24(sp)
    800025bc:	e852                	sd	s4,16(sp)
    800025be:	e456                	sd	s5,8(sp)
    800025c0:	e05a                	sd	s6,0(sp)
    800025c2:	8aaa                	mv	s5,a0
    800025c4:	8b2e                	mv	s6,a1
    800025c6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025c8:	00016a17          	auipc	s4,0x16
    800025cc:	270a0a13          	addi	s4,s4,624 # 80018838 <sb>
    800025d0:	00495593          	srli	a1,s2,0x4
    800025d4:	018a2783          	lw	a5,24(s4)
    800025d8:	9dbd                	addw	a1,a1,a5
    800025da:	8556                	mv	a0,s5
    800025dc:	a23ff0ef          	jal	80001ffe <bread>
    800025e0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025e2:	05850993          	addi	s3,a0,88
    800025e6:	00f97793          	andi	a5,s2,15
    800025ea:	079a                	slli	a5,a5,0x6
    800025ec:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025ee:	00099783          	lh	a5,0(s3)
    800025f2:	cb9d                	beqz	a5,80002628 <ialloc+0x88>
    brelse(bp);
    800025f4:	b13ff0ef          	jal	80002106 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025f8:	0905                	addi	s2,s2,1
    800025fa:	00ca2703          	lw	a4,12(s4)
    800025fe:	0009079b          	sext.w	a5,s2
    80002602:	fce7e7e3          	bltu	a5,a4,800025d0 <ialloc+0x30>
    80002606:	74a2                	ld	s1,40(sp)
    80002608:	7902                	ld	s2,32(sp)
    8000260a:	69e2                	ld	s3,24(sp)
    8000260c:	6a42                	ld	s4,16(sp)
    8000260e:	6aa2                	ld	s5,8(sp)
    80002610:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002612:	00005517          	auipc	a0,0x5
    80002616:	e7650513          	addi	a0,a0,-394 # 80007488 <etext+0x488>
    8000261a:	40d020ef          	jal	80005226 <printf>
  return 0;
    8000261e:	4501                	li	a0,0
}
    80002620:	70e2                	ld	ra,56(sp)
    80002622:	7442                	ld	s0,48(sp)
    80002624:	6121                	addi	sp,sp,64
    80002626:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002628:	04000613          	li	a2,64
    8000262c:	4581                	li	a1,0
    8000262e:	854e                	mv	a0,s3
    80002630:	b1ffd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002634:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002638:	8526                	mv	a0,s1
    8000263a:	313000ef          	jal	8000314c <log_write>
      brelse(bp);
    8000263e:	8526                	mv	a0,s1
    80002640:	ac7ff0ef          	jal	80002106 <brelse>
      return iget(dev, inum);
    80002644:	0009059b          	sext.w	a1,s2
    80002648:	8556                	mv	a0,s5
    8000264a:	de7ff0ef          	jal	80002430 <iget>
    8000264e:	74a2                	ld	s1,40(sp)
    80002650:	7902                	ld	s2,32(sp)
    80002652:	69e2                	ld	s3,24(sp)
    80002654:	6a42                	ld	s4,16(sp)
    80002656:	6aa2                	ld	s5,8(sp)
    80002658:	6b02                	ld	s6,0(sp)
    8000265a:	b7d9                	j	80002620 <ialloc+0x80>

000000008000265c <iupdate>:
{
    8000265c:	1101                	addi	sp,sp,-32
    8000265e:	ec06                	sd	ra,24(sp)
    80002660:	e822                	sd	s0,16(sp)
    80002662:	e426                	sd	s1,8(sp)
    80002664:	e04a                	sd	s2,0(sp)
    80002666:	1000                	addi	s0,sp,32
    80002668:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000266a:	415c                	lw	a5,4(a0)
    8000266c:	0047d79b          	srliw	a5,a5,0x4
    80002670:	00016597          	auipc	a1,0x16
    80002674:	1e05a583          	lw	a1,480(a1) # 80018850 <sb+0x18>
    80002678:	9dbd                	addw	a1,a1,a5
    8000267a:	4108                	lw	a0,0(a0)
    8000267c:	983ff0ef          	jal	80001ffe <bread>
    80002680:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002682:	05850793          	addi	a5,a0,88
    80002686:	40d8                	lw	a4,4(s1)
    80002688:	8b3d                	andi	a4,a4,15
    8000268a:	071a                	slli	a4,a4,0x6
    8000268c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000268e:	04449703          	lh	a4,68(s1)
    80002692:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002696:	04649703          	lh	a4,70(s1)
    8000269a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000269e:	04849703          	lh	a4,72(s1)
    800026a2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026a6:	04a49703          	lh	a4,74(s1)
    800026aa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026ae:	44f8                	lw	a4,76(s1)
    800026b0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026b2:	03400613          	li	a2,52
    800026b6:	05048593          	addi	a1,s1,80
    800026ba:	00c78513          	addi	a0,a5,12
    800026be:	af5fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    800026c2:	854a                	mv	a0,s2
    800026c4:	289000ef          	jal	8000314c <log_write>
  brelse(bp);
    800026c8:	854a                	mv	a0,s2
    800026ca:	a3dff0ef          	jal	80002106 <brelse>
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6902                	ld	s2,0(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <idup>:
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026e6:	00016517          	auipc	a0,0x16
    800026ea:	17250513          	addi	a0,a0,370 # 80018858 <itable>
    800026ee:	136030ef          	jal	80005824 <acquire>
  ip->ref++;
    800026f2:	449c                	lw	a5,8(s1)
    800026f4:	2785                	addiw	a5,a5,1
    800026f6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026f8:	00016517          	auipc	a0,0x16
    800026fc:	16050513          	addi	a0,a0,352 # 80018858 <itable>
    80002700:	1b8030ef          	jal	800058b8 <release>
}
    80002704:	8526                	mv	a0,s1
    80002706:	60e2                	ld	ra,24(sp)
    80002708:	6442                	ld	s0,16(sp)
    8000270a:	64a2                	ld	s1,8(sp)
    8000270c:	6105                	addi	sp,sp,32
    8000270e:	8082                	ret

0000000080002710 <ilock>:
{
    80002710:	1101                	addi	sp,sp,-32
    80002712:	ec06                	sd	ra,24(sp)
    80002714:	e822                	sd	s0,16(sp)
    80002716:	e426                	sd	s1,8(sp)
    80002718:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000271a:	cd19                	beqz	a0,80002738 <ilock+0x28>
    8000271c:	84aa                	mv	s1,a0
    8000271e:	451c                	lw	a5,8(a0)
    80002720:	00f05c63          	blez	a5,80002738 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002724:	0541                	addi	a0,a0,16
    80002726:	32d000ef          	jal	80003252 <acquiresleep>
  if(ip->valid == 0){
    8000272a:	40bc                	lw	a5,64(s1)
    8000272c:	cf89                	beqz	a5,80002746 <ilock+0x36>
}
    8000272e:	60e2                	ld	ra,24(sp)
    80002730:	6442                	ld	s0,16(sp)
    80002732:	64a2                	ld	s1,8(sp)
    80002734:	6105                	addi	sp,sp,32
    80002736:	8082                	ret
    80002738:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000273a:	00005517          	auipc	a0,0x5
    8000273e:	d6650513          	addi	a0,a0,-666 # 800074a0 <etext+0x4a0>
    80002742:	5b5020ef          	jal	800054f6 <panic>
    80002746:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002748:	40dc                	lw	a5,4(s1)
    8000274a:	0047d79b          	srliw	a5,a5,0x4
    8000274e:	00016597          	auipc	a1,0x16
    80002752:	1025a583          	lw	a1,258(a1) # 80018850 <sb+0x18>
    80002756:	9dbd                	addw	a1,a1,a5
    80002758:	4088                	lw	a0,0(s1)
    8000275a:	8a5ff0ef          	jal	80001ffe <bread>
    8000275e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002760:	05850593          	addi	a1,a0,88
    80002764:	40dc                	lw	a5,4(s1)
    80002766:	8bbd                	andi	a5,a5,15
    80002768:	079a                	slli	a5,a5,0x6
    8000276a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000276c:	00059783          	lh	a5,0(a1)
    80002770:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002774:	00259783          	lh	a5,2(a1)
    80002778:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000277c:	00459783          	lh	a5,4(a1)
    80002780:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002784:	00659783          	lh	a5,6(a1)
    80002788:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000278c:	459c                	lw	a5,8(a1)
    8000278e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002790:	03400613          	li	a2,52
    80002794:	05b1                	addi	a1,a1,12
    80002796:	05048513          	addi	a0,s1,80
    8000279a:	a19fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	967ff0ef          	jal	80002106 <brelse>
    ip->valid = 1;
    800027a4:	4785                	li	a5,1
    800027a6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027a8:	04449783          	lh	a5,68(s1)
    800027ac:	c399                	beqz	a5,800027b2 <ilock+0xa2>
    800027ae:	6902                	ld	s2,0(sp)
    800027b0:	bfbd                	j	8000272e <ilock+0x1e>
      panic("ilock: no type");
    800027b2:	00005517          	auipc	a0,0x5
    800027b6:	cf650513          	addi	a0,a0,-778 # 800074a8 <etext+0x4a8>
    800027ba:	53d020ef          	jal	800054f6 <panic>

00000000800027be <iunlock>:
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	e04a                	sd	s2,0(sp)
    800027c8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027ca:	c505                	beqz	a0,800027f2 <iunlock+0x34>
    800027cc:	84aa                	mv	s1,a0
    800027ce:	01050913          	addi	s2,a0,16
    800027d2:	854a                	mv	a0,s2
    800027d4:	2fd000ef          	jal	800032d0 <holdingsleep>
    800027d8:	cd09                	beqz	a0,800027f2 <iunlock+0x34>
    800027da:	449c                	lw	a5,8(s1)
    800027dc:	00f05b63          	blez	a5,800027f2 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027e0:	854a                	mv	a0,s2
    800027e2:	2b7000ef          	jal	80003298 <releasesleep>
}
    800027e6:	60e2                	ld	ra,24(sp)
    800027e8:	6442                	ld	s0,16(sp)
    800027ea:	64a2                	ld	s1,8(sp)
    800027ec:	6902                	ld	s2,0(sp)
    800027ee:	6105                	addi	sp,sp,32
    800027f0:	8082                	ret
    panic("iunlock");
    800027f2:	00005517          	auipc	a0,0x5
    800027f6:	cc650513          	addi	a0,a0,-826 # 800074b8 <etext+0x4b8>
    800027fa:	4fd020ef          	jal	800054f6 <panic>

00000000800027fe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027fe:	7179                	addi	sp,sp,-48
    80002800:	f406                	sd	ra,40(sp)
    80002802:	f022                	sd	s0,32(sp)
    80002804:	ec26                	sd	s1,24(sp)
    80002806:	e84a                	sd	s2,16(sp)
    80002808:	e44e                	sd	s3,8(sp)
    8000280a:	1800                	addi	s0,sp,48
    8000280c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000280e:	05050493          	addi	s1,a0,80
    80002812:	08050913          	addi	s2,a0,128
    80002816:	a021                	j	8000281e <itrunc+0x20>
    80002818:	0491                	addi	s1,s1,4
    8000281a:	01248b63          	beq	s1,s2,80002830 <itrunc+0x32>
    if(ip->addrs[i]){
    8000281e:	408c                	lw	a1,0(s1)
    80002820:	dde5                	beqz	a1,80002818 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002822:	0009a503          	lw	a0,0(s3)
    80002826:	9cdff0ef          	jal	800021f2 <bfree>
      ip->addrs[i] = 0;
    8000282a:	0004a023          	sw	zero,0(s1)
    8000282e:	b7ed                	j	80002818 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002830:	0809a583          	lw	a1,128(s3)
    80002834:	ed89                	bnez	a1,8000284e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002836:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000283a:	854e                	mv	a0,s3
    8000283c:	e21ff0ef          	jal	8000265c <iupdate>
}
    80002840:	70a2                	ld	ra,40(sp)
    80002842:	7402                	ld	s0,32(sp)
    80002844:	64e2                	ld	s1,24(sp)
    80002846:	6942                	ld	s2,16(sp)
    80002848:	69a2                	ld	s3,8(sp)
    8000284a:	6145                	addi	sp,sp,48
    8000284c:	8082                	ret
    8000284e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002850:	0009a503          	lw	a0,0(s3)
    80002854:	faaff0ef          	jal	80001ffe <bread>
    80002858:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000285a:	05850493          	addi	s1,a0,88
    8000285e:	45850913          	addi	s2,a0,1112
    80002862:	a021                	j	8000286a <itrunc+0x6c>
    80002864:	0491                	addi	s1,s1,4
    80002866:	01248963          	beq	s1,s2,80002878 <itrunc+0x7a>
      if(a[j])
    8000286a:	408c                	lw	a1,0(s1)
    8000286c:	dde5                	beqz	a1,80002864 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000286e:	0009a503          	lw	a0,0(s3)
    80002872:	981ff0ef          	jal	800021f2 <bfree>
    80002876:	b7fd                	j	80002864 <itrunc+0x66>
    brelse(bp);
    80002878:	8552                	mv	a0,s4
    8000287a:	88dff0ef          	jal	80002106 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000287e:	0809a583          	lw	a1,128(s3)
    80002882:	0009a503          	lw	a0,0(s3)
    80002886:	96dff0ef          	jal	800021f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000288a:	0809a023          	sw	zero,128(s3)
    8000288e:	6a02                	ld	s4,0(sp)
    80002890:	b75d                	j	80002836 <itrunc+0x38>

0000000080002892 <iput>:
{
    80002892:	1101                	addi	sp,sp,-32
    80002894:	ec06                	sd	ra,24(sp)
    80002896:	e822                	sd	s0,16(sp)
    80002898:	e426                	sd	s1,8(sp)
    8000289a:	1000                	addi	s0,sp,32
    8000289c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000289e:	00016517          	auipc	a0,0x16
    800028a2:	fba50513          	addi	a0,a0,-70 # 80018858 <itable>
    800028a6:	77f020ef          	jal	80005824 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028aa:	4498                	lw	a4,8(s1)
    800028ac:	4785                	li	a5,1
    800028ae:	02f70063          	beq	a4,a5,800028ce <iput+0x3c>
  ip->ref--;
    800028b2:	449c                	lw	a5,8(s1)
    800028b4:	37fd                	addiw	a5,a5,-1
    800028b6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028b8:	00016517          	auipc	a0,0x16
    800028bc:	fa050513          	addi	a0,a0,-96 # 80018858 <itable>
    800028c0:	7f9020ef          	jal	800058b8 <release>
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6105                	addi	sp,sp,32
    800028cc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ce:	40bc                	lw	a5,64(s1)
    800028d0:	d3ed                	beqz	a5,800028b2 <iput+0x20>
    800028d2:	04a49783          	lh	a5,74(s1)
    800028d6:	fff1                	bnez	a5,800028b2 <iput+0x20>
    800028d8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028da:	01048913          	addi	s2,s1,16
    800028de:	854a                	mv	a0,s2
    800028e0:	173000ef          	jal	80003252 <acquiresleep>
    release(&itable.lock);
    800028e4:	00016517          	auipc	a0,0x16
    800028e8:	f7450513          	addi	a0,a0,-140 # 80018858 <itable>
    800028ec:	7cd020ef          	jal	800058b8 <release>
    itrunc(ip);
    800028f0:	8526                	mv	a0,s1
    800028f2:	f0dff0ef          	jal	800027fe <itrunc>
    ip->type = 0;
    800028f6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028fa:	8526                	mv	a0,s1
    800028fc:	d61ff0ef          	jal	8000265c <iupdate>
    ip->valid = 0;
    80002900:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002904:	854a                	mv	a0,s2
    80002906:	193000ef          	jal	80003298 <releasesleep>
    acquire(&itable.lock);
    8000290a:	00016517          	auipc	a0,0x16
    8000290e:	f4e50513          	addi	a0,a0,-178 # 80018858 <itable>
    80002912:	713020ef          	jal	80005824 <acquire>
    80002916:	6902                	ld	s2,0(sp)
    80002918:	bf69                	j	800028b2 <iput+0x20>

000000008000291a <iunlockput>:
{
    8000291a:	1101                	addi	sp,sp,-32
    8000291c:	ec06                	sd	ra,24(sp)
    8000291e:	e822                	sd	s0,16(sp)
    80002920:	e426                	sd	s1,8(sp)
    80002922:	1000                	addi	s0,sp,32
    80002924:	84aa                	mv	s1,a0
  iunlock(ip);
    80002926:	e99ff0ef          	jal	800027be <iunlock>
  iput(ip);
    8000292a:	8526                	mv	a0,s1
    8000292c:	f67ff0ef          	jal	80002892 <iput>
}
    80002930:	60e2                	ld	ra,24(sp)
    80002932:	6442                	ld	s0,16(sp)
    80002934:	64a2                	ld	s1,8(sp)
    80002936:	6105                	addi	sp,sp,32
    80002938:	8082                	ret

000000008000293a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000293a:	1141                	addi	sp,sp,-16
    8000293c:	e406                	sd	ra,8(sp)
    8000293e:	e022                	sd	s0,0(sp)
    80002940:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002942:	411c                	lw	a5,0(a0)
    80002944:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002946:	415c                	lw	a5,4(a0)
    80002948:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000294a:	04451783          	lh	a5,68(a0)
    8000294e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002952:	04a51783          	lh	a5,74(a0)
    80002956:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000295a:	04c56783          	lwu	a5,76(a0)
    8000295e:	e99c                	sd	a5,16(a1)
}
    80002960:	60a2                	ld	ra,8(sp)
    80002962:	6402                	ld	s0,0(sp)
    80002964:	0141                	addi	sp,sp,16
    80002966:	8082                	ret

0000000080002968 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002968:	457c                	lw	a5,76(a0)
    8000296a:	0ed7e663          	bltu	a5,a3,80002a56 <readi+0xee>
{
    8000296e:	7159                	addi	sp,sp,-112
    80002970:	f486                	sd	ra,104(sp)
    80002972:	f0a2                	sd	s0,96(sp)
    80002974:	eca6                	sd	s1,88(sp)
    80002976:	e0d2                	sd	s4,64(sp)
    80002978:	fc56                	sd	s5,56(sp)
    8000297a:	f85a                	sd	s6,48(sp)
    8000297c:	f45e                	sd	s7,40(sp)
    8000297e:	1880                	addi	s0,sp,112
    80002980:	8b2a                	mv	s6,a0
    80002982:	8bae                	mv	s7,a1
    80002984:	8a32                	mv	s4,a2
    80002986:	84b6                	mv	s1,a3
    80002988:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000298a:	9f35                	addw	a4,a4,a3
    return 0;
    8000298c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000298e:	0ad76b63          	bltu	a4,a3,80002a44 <readi+0xdc>
    80002992:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002994:	00e7f463          	bgeu	a5,a4,8000299c <readi+0x34>
    n = ip->size - off;
    80002998:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000299c:	080a8b63          	beqz	s5,80002a32 <readi+0xca>
    800029a0:	e8ca                	sd	s2,80(sp)
    800029a2:	f062                	sd	s8,32(sp)
    800029a4:	ec66                	sd	s9,24(sp)
    800029a6:	e86a                	sd	s10,16(sp)
    800029a8:	e46e                	sd	s11,8(sp)
    800029aa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ac:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029b0:	5c7d                	li	s8,-1
    800029b2:	a80d                	j	800029e4 <readi+0x7c>
    800029b4:	020d1d93          	slli	s11,s10,0x20
    800029b8:	020ddd93          	srli	s11,s11,0x20
    800029bc:	05890613          	addi	a2,s2,88
    800029c0:	86ee                	mv	a3,s11
    800029c2:	963e                	add	a2,a2,a5
    800029c4:	85d2                	mv	a1,s4
    800029c6:	855e                	mv	a0,s7
    800029c8:	cc9fe0ef          	jal	80001690 <either_copyout>
    800029cc:	05850363          	beq	a0,s8,80002a12 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029d0:	854a                	mv	a0,s2
    800029d2:	f34ff0ef          	jal	80002106 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029d6:	013d09bb          	addw	s3,s10,s3
    800029da:	009d04bb          	addw	s1,s10,s1
    800029de:	9a6e                	add	s4,s4,s11
    800029e0:	0559f363          	bgeu	s3,s5,80002a26 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800029e4:	00a4d59b          	srliw	a1,s1,0xa
    800029e8:	855a                	mv	a0,s6
    800029ea:	987ff0ef          	jal	80002370 <bmap>
    800029ee:	85aa                	mv	a1,a0
    if(addr == 0)
    800029f0:	c139                	beqz	a0,80002a36 <readi+0xce>
    bp = bread(ip->dev, addr);
    800029f2:	000b2503          	lw	a0,0(s6)
    800029f6:	e08ff0ef          	jal	80001ffe <bread>
    800029fa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029fc:	3ff4f793          	andi	a5,s1,1023
    80002a00:	40fc873b          	subw	a4,s9,a5
    80002a04:	413a86bb          	subw	a3,s5,s3
    80002a08:	8d3a                	mv	s10,a4
    80002a0a:	fae6f5e3          	bgeu	a3,a4,800029b4 <readi+0x4c>
    80002a0e:	8d36                	mv	s10,a3
    80002a10:	b755                	j	800029b4 <readi+0x4c>
      brelse(bp);
    80002a12:	854a                	mv	a0,s2
    80002a14:	ef2ff0ef          	jal	80002106 <brelse>
      tot = -1;
    80002a18:	59fd                	li	s3,-1
      break;
    80002a1a:	6946                	ld	s2,80(sp)
    80002a1c:	7c02                	ld	s8,32(sp)
    80002a1e:	6ce2                	ld	s9,24(sp)
    80002a20:	6d42                	ld	s10,16(sp)
    80002a22:	6da2                	ld	s11,8(sp)
    80002a24:	a831                	j	80002a40 <readi+0xd8>
    80002a26:	6946                	ld	s2,80(sp)
    80002a28:	7c02                	ld	s8,32(sp)
    80002a2a:	6ce2                	ld	s9,24(sp)
    80002a2c:	6d42                	ld	s10,16(sp)
    80002a2e:	6da2                	ld	s11,8(sp)
    80002a30:	a801                	j	80002a40 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a32:	89d6                	mv	s3,s5
    80002a34:	a031                	j	80002a40 <readi+0xd8>
    80002a36:	6946                	ld	s2,80(sp)
    80002a38:	7c02                	ld	s8,32(sp)
    80002a3a:	6ce2                	ld	s9,24(sp)
    80002a3c:	6d42                	ld	s10,16(sp)
    80002a3e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a40:	854e                	mv	a0,s3
    80002a42:	69a6                	ld	s3,72(sp)
}
    80002a44:	70a6                	ld	ra,104(sp)
    80002a46:	7406                	ld	s0,96(sp)
    80002a48:	64e6                	ld	s1,88(sp)
    80002a4a:	6a06                	ld	s4,64(sp)
    80002a4c:	7ae2                	ld	s5,56(sp)
    80002a4e:	7b42                	ld	s6,48(sp)
    80002a50:	7ba2                	ld	s7,40(sp)
    80002a52:	6165                	addi	sp,sp,112
    80002a54:	8082                	ret
    return 0;
    80002a56:	4501                	li	a0,0
}
    80002a58:	8082                	ret

0000000080002a5a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a5a:	457c                	lw	a5,76(a0)
    80002a5c:	0ed7eb63          	bltu	a5,a3,80002b52 <writei+0xf8>
{
    80002a60:	7159                	addi	sp,sp,-112
    80002a62:	f486                	sd	ra,104(sp)
    80002a64:	f0a2                	sd	s0,96(sp)
    80002a66:	e8ca                	sd	s2,80(sp)
    80002a68:	e0d2                	sd	s4,64(sp)
    80002a6a:	fc56                	sd	s5,56(sp)
    80002a6c:	f85a                	sd	s6,48(sp)
    80002a6e:	f45e                	sd	s7,40(sp)
    80002a70:	1880                	addi	s0,sp,112
    80002a72:	8aaa                	mv	s5,a0
    80002a74:	8bae                	mv	s7,a1
    80002a76:	8a32                	mv	s4,a2
    80002a78:	8936                	mv	s2,a3
    80002a7a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a7c:	00e687bb          	addw	a5,a3,a4
    80002a80:	0cd7eb63          	bltu	a5,a3,80002b56 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a84:	00043737          	lui	a4,0x43
    80002a88:	0cf76963          	bltu	a4,a5,80002b5a <writei+0x100>
    80002a8c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a8e:	0a0b0a63          	beqz	s6,80002b42 <writei+0xe8>
    80002a92:	eca6                	sd	s1,88(sp)
    80002a94:	f062                	sd	s8,32(sp)
    80002a96:	ec66                	sd	s9,24(sp)
    80002a98:	e86a                	sd	s10,16(sp)
    80002a9a:	e46e                	sd	s11,8(sp)
    80002a9c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a9e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002aa2:	5c7d                	li	s8,-1
    80002aa4:	a825                	j	80002adc <writei+0x82>
    80002aa6:	020d1d93          	slli	s11,s10,0x20
    80002aaa:	020ddd93          	srli	s11,s11,0x20
    80002aae:	05848513          	addi	a0,s1,88
    80002ab2:	86ee                	mv	a3,s11
    80002ab4:	8652                	mv	a2,s4
    80002ab6:	85de                	mv	a1,s7
    80002ab8:	953e                	add	a0,a0,a5
    80002aba:	c21fe0ef          	jal	800016da <either_copyin>
    80002abe:	05850663          	beq	a0,s8,80002b0a <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	688000ef          	jal	8000314c <log_write>
    brelse(bp);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	e3cff0ef          	jal	80002106 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ace:	013d09bb          	addw	s3,s10,s3
    80002ad2:	012d093b          	addw	s2,s10,s2
    80002ad6:	9a6e                	add	s4,s4,s11
    80002ad8:	0369fc63          	bgeu	s3,s6,80002b10 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002adc:	00a9559b          	srliw	a1,s2,0xa
    80002ae0:	8556                	mv	a0,s5
    80002ae2:	88fff0ef          	jal	80002370 <bmap>
    80002ae6:	85aa                	mv	a1,a0
    if(addr == 0)
    80002ae8:	c505                	beqz	a0,80002b10 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002aea:	000aa503          	lw	a0,0(s5)
    80002aee:	d10ff0ef          	jal	80001ffe <bread>
    80002af2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002af4:	3ff97793          	andi	a5,s2,1023
    80002af8:	40fc873b          	subw	a4,s9,a5
    80002afc:	413b06bb          	subw	a3,s6,s3
    80002b00:	8d3a                	mv	s10,a4
    80002b02:	fae6f2e3          	bgeu	a3,a4,80002aa6 <writei+0x4c>
    80002b06:	8d36                	mv	s10,a3
    80002b08:	bf79                	j	80002aa6 <writei+0x4c>
      brelse(bp);
    80002b0a:	8526                	mv	a0,s1
    80002b0c:	dfaff0ef          	jal	80002106 <brelse>
  }

  if(off > ip->size)
    80002b10:	04caa783          	lw	a5,76(s5)
    80002b14:	0327f963          	bgeu	a5,s2,80002b46 <writei+0xec>
    ip->size = off;
    80002b18:	052aa623          	sw	s2,76(s5)
    80002b1c:	64e6                	ld	s1,88(sp)
    80002b1e:	7c02                	ld	s8,32(sp)
    80002b20:	6ce2                	ld	s9,24(sp)
    80002b22:	6d42                	ld	s10,16(sp)
    80002b24:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b26:	8556                	mv	a0,s5
    80002b28:	b35ff0ef          	jal	8000265c <iupdate>

  return tot;
    80002b2c:	854e                	mv	a0,s3
    80002b2e:	69a6                	ld	s3,72(sp)
}
    80002b30:	70a6                	ld	ra,104(sp)
    80002b32:	7406                	ld	s0,96(sp)
    80002b34:	6946                	ld	s2,80(sp)
    80002b36:	6a06                	ld	s4,64(sp)
    80002b38:	7ae2                	ld	s5,56(sp)
    80002b3a:	7b42                	ld	s6,48(sp)
    80002b3c:	7ba2                	ld	s7,40(sp)
    80002b3e:	6165                	addi	sp,sp,112
    80002b40:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b42:	89da                	mv	s3,s6
    80002b44:	b7cd                	j	80002b26 <writei+0xcc>
    80002b46:	64e6                	ld	s1,88(sp)
    80002b48:	7c02                	ld	s8,32(sp)
    80002b4a:	6ce2                	ld	s9,24(sp)
    80002b4c:	6d42                	ld	s10,16(sp)
    80002b4e:	6da2                	ld	s11,8(sp)
    80002b50:	bfd9                	j	80002b26 <writei+0xcc>
    return -1;
    80002b52:	557d                	li	a0,-1
}
    80002b54:	8082                	ret
    return -1;
    80002b56:	557d                	li	a0,-1
    80002b58:	bfe1                	j	80002b30 <writei+0xd6>
    return -1;
    80002b5a:	557d                	li	a0,-1
    80002b5c:	bfd1                	j	80002b30 <writei+0xd6>

0000000080002b5e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b5e:	1141                	addi	sp,sp,-16
    80002b60:	e406                	sd	ra,8(sp)
    80002b62:	e022                	sd	s0,0(sp)
    80002b64:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b66:	4639                	li	a2,14
    80002b68:	ebefd0ef          	jal	80000226 <strncmp>
}
    80002b6c:	60a2                	ld	ra,8(sp)
    80002b6e:	6402                	ld	s0,0(sp)
    80002b70:	0141                	addi	sp,sp,16
    80002b72:	8082                	ret

0000000080002b74 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b74:	711d                	addi	sp,sp,-96
    80002b76:	ec86                	sd	ra,88(sp)
    80002b78:	e8a2                	sd	s0,80(sp)
    80002b7a:	e4a6                	sd	s1,72(sp)
    80002b7c:	e0ca                	sd	s2,64(sp)
    80002b7e:	fc4e                	sd	s3,56(sp)
    80002b80:	f852                	sd	s4,48(sp)
    80002b82:	f456                	sd	s5,40(sp)
    80002b84:	f05a                	sd	s6,32(sp)
    80002b86:	ec5e                	sd	s7,24(sp)
    80002b88:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b8a:	04451703          	lh	a4,68(a0)
    80002b8e:	4785                	li	a5,1
    80002b90:	00f71f63          	bne	a4,a5,80002bae <dirlookup+0x3a>
    80002b94:	892a                	mv	s2,a0
    80002b96:	8aae                	mv	s5,a1
    80002b98:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b9a:	457c                	lw	a5,76(a0)
    80002b9c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b9e:	fa040a13          	addi	s4,s0,-96
    80002ba2:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002ba4:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ba8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002baa:	e39d                	bnez	a5,80002bd0 <dirlookup+0x5c>
    80002bac:	a8b9                	j	80002c0a <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002bae:	00005517          	auipc	a0,0x5
    80002bb2:	91250513          	addi	a0,a0,-1774 # 800074c0 <etext+0x4c0>
    80002bb6:	141020ef          	jal	800054f6 <panic>
      panic("dirlookup read");
    80002bba:	00005517          	auipc	a0,0x5
    80002bbe:	91e50513          	addi	a0,a0,-1762 # 800074d8 <etext+0x4d8>
    80002bc2:	135020ef          	jal	800054f6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bc6:	24c1                	addiw	s1,s1,16
    80002bc8:	04c92783          	lw	a5,76(s2)
    80002bcc:	02f4fe63          	bgeu	s1,a5,80002c08 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bd0:	874e                	mv	a4,s3
    80002bd2:	86a6                	mv	a3,s1
    80002bd4:	8652                	mv	a2,s4
    80002bd6:	4581                	li	a1,0
    80002bd8:	854a                	mv	a0,s2
    80002bda:	d8fff0ef          	jal	80002968 <readi>
    80002bde:	fd351ee3          	bne	a0,s3,80002bba <dirlookup+0x46>
    if(de.inum == 0)
    80002be2:	fa045783          	lhu	a5,-96(s0)
    80002be6:	d3e5                	beqz	a5,80002bc6 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002be8:	85da                	mv	a1,s6
    80002bea:	8556                	mv	a0,s5
    80002bec:	f73ff0ef          	jal	80002b5e <namecmp>
    80002bf0:	f979                	bnez	a0,80002bc6 <dirlookup+0x52>
      if(poff)
    80002bf2:	000b8463          	beqz	s7,80002bfa <dirlookup+0x86>
        *poff = off;
    80002bf6:	009ba023          	sw	s1,0(s7) # 80007770 <states.0>
      return iget(dp->dev, inum);
    80002bfa:	fa045583          	lhu	a1,-96(s0)
    80002bfe:	00092503          	lw	a0,0(s2)
    80002c02:	82fff0ef          	jal	80002430 <iget>
    80002c06:	a011                	j	80002c0a <dirlookup+0x96>
  return 0;
    80002c08:	4501                	li	a0,0
}
    80002c0a:	60e6                	ld	ra,88(sp)
    80002c0c:	6446                	ld	s0,80(sp)
    80002c0e:	64a6                	ld	s1,72(sp)
    80002c10:	6906                	ld	s2,64(sp)
    80002c12:	79e2                	ld	s3,56(sp)
    80002c14:	7a42                	ld	s4,48(sp)
    80002c16:	7aa2                	ld	s5,40(sp)
    80002c18:	7b02                	ld	s6,32(sp)
    80002c1a:	6be2                	ld	s7,24(sp)
    80002c1c:	6125                	addi	sp,sp,96
    80002c1e:	8082                	ret

0000000080002c20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c20:	711d                	addi	sp,sp,-96
    80002c22:	ec86                	sd	ra,88(sp)
    80002c24:	e8a2                	sd	s0,80(sp)
    80002c26:	e4a6                	sd	s1,72(sp)
    80002c28:	e0ca                	sd	s2,64(sp)
    80002c2a:	fc4e                	sd	s3,56(sp)
    80002c2c:	f852                	sd	s4,48(sp)
    80002c2e:	f456                	sd	s5,40(sp)
    80002c30:	f05a                	sd	s6,32(sp)
    80002c32:	ec5e                	sd	s7,24(sp)
    80002c34:	e862                	sd	s8,16(sp)
    80002c36:	e466                	sd	s9,8(sp)
    80002c38:	e06a                	sd	s10,0(sp)
    80002c3a:	1080                	addi	s0,sp,96
    80002c3c:	84aa                	mv	s1,a0
    80002c3e:	8b2e                	mv	s6,a1
    80002c40:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c42:	00054703          	lbu	a4,0(a0)
    80002c46:	02f00793          	li	a5,47
    80002c4a:	00f70f63          	beq	a4,a5,80002c68 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c4e:	912fe0ef          	jal	80000d60 <myproc>
    80002c52:	15053503          	ld	a0,336(a0)
    80002c56:	a85ff0ef          	jal	800026da <idup>
    80002c5a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c5c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c60:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002c62:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c64:	4b85                	li	s7,1
    80002c66:	a879                	j	80002d04 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002c68:	4585                	li	a1,1
    80002c6a:	852e                	mv	a0,a1
    80002c6c:	fc4ff0ef          	jal	80002430 <iget>
    80002c70:	8a2a                	mv	s4,a0
    80002c72:	b7ed                	j	80002c5c <namex+0x3c>
      iunlockput(ip);
    80002c74:	8552                	mv	a0,s4
    80002c76:	ca5ff0ef          	jal	8000291a <iunlockput>
      return 0;
    80002c7a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	60e6                	ld	ra,88(sp)
    80002c80:	6446                	ld	s0,80(sp)
    80002c82:	64a6                	ld	s1,72(sp)
    80002c84:	6906                	ld	s2,64(sp)
    80002c86:	79e2                	ld	s3,56(sp)
    80002c88:	7a42                	ld	s4,48(sp)
    80002c8a:	7aa2                	ld	s5,40(sp)
    80002c8c:	7b02                	ld	s6,32(sp)
    80002c8e:	6be2                	ld	s7,24(sp)
    80002c90:	6c42                	ld	s8,16(sp)
    80002c92:	6ca2                	ld	s9,8(sp)
    80002c94:	6d02                	ld	s10,0(sp)
    80002c96:	6125                	addi	sp,sp,96
    80002c98:	8082                	ret
      iunlock(ip);
    80002c9a:	8552                	mv	a0,s4
    80002c9c:	b23ff0ef          	jal	800027be <iunlock>
      return ip;
    80002ca0:	bff1                	j	80002c7c <namex+0x5c>
      iunlockput(ip);
    80002ca2:	8552                	mv	a0,s4
    80002ca4:	c77ff0ef          	jal	8000291a <iunlockput>
      return 0;
    80002ca8:	8a4e                	mv	s4,s3
    80002caa:	bfc9                	j	80002c7c <namex+0x5c>
  len = path - s;
    80002cac:	40998633          	sub	a2,s3,s1
    80002cb0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002cb4:	09ac5063          	bge	s8,s10,80002d34 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002cb8:	8666                	mv	a2,s9
    80002cba:	85a6                	mv	a1,s1
    80002cbc:	8556                	mv	a0,s5
    80002cbe:	cf4fd0ef          	jal	800001b2 <memmove>
    80002cc2:	84ce                	mv	s1,s3
  while(*path == '/')
    80002cc4:	0004c783          	lbu	a5,0(s1)
    80002cc8:	01279763          	bne	a5,s2,80002cd6 <namex+0xb6>
    path++;
    80002ccc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002cce:	0004c783          	lbu	a5,0(s1)
    80002cd2:	ff278de3          	beq	a5,s2,80002ccc <namex+0xac>
    ilock(ip);
    80002cd6:	8552                	mv	a0,s4
    80002cd8:	a39ff0ef          	jal	80002710 <ilock>
    if(ip->type != T_DIR){
    80002cdc:	044a1783          	lh	a5,68(s4)
    80002ce0:	f9779ae3          	bne	a5,s7,80002c74 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002ce4:	000b0563          	beqz	s6,80002cee <namex+0xce>
    80002ce8:	0004c783          	lbu	a5,0(s1)
    80002cec:	d7dd                	beqz	a5,80002c9a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002cee:	4601                	li	a2,0
    80002cf0:	85d6                	mv	a1,s5
    80002cf2:	8552                	mv	a0,s4
    80002cf4:	e81ff0ef          	jal	80002b74 <dirlookup>
    80002cf8:	89aa                	mv	s3,a0
    80002cfa:	d545                	beqz	a0,80002ca2 <namex+0x82>
    iunlockput(ip);
    80002cfc:	8552                	mv	a0,s4
    80002cfe:	c1dff0ef          	jal	8000291a <iunlockput>
    ip = next;
    80002d02:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d04:	0004c783          	lbu	a5,0(s1)
    80002d08:	01279763          	bne	a5,s2,80002d16 <namex+0xf6>
    path++;
    80002d0c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d0e:	0004c783          	lbu	a5,0(s1)
    80002d12:	ff278de3          	beq	a5,s2,80002d0c <namex+0xec>
  if(*path == 0)
    80002d16:	cb8d                	beqz	a5,80002d48 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002d18:	0004c783          	lbu	a5,0(s1)
    80002d1c:	89a6                	mv	s3,s1
  len = path - s;
    80002d1e:	4d01                	li	s10,0
    80002d20:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d22:	01278963          	beq	a5,s2,80002d34 <namex+0x114>
    80002d26:	d3d9                	beqz	a5,80002cac <namex+0x8c>
    path++;
    80002d28:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d2a:	0009c783          	lbu	a5,0(s3)
    80002d2e:	ff279ce3          	bne	a5,s2,80002d26 <namex+0x106>
    80002d32:	bfad                	j	80002cac <namex+0x8c>
    memmove(name, s, len);
    80002d34:	2601                	sext.w	a2,a2
    80002d36:	85a6                	mv	a1,s1
    80002d38:	8556                	mv	a0,s5
    80002d3a:	c78fd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002d3e:	9d56                	add	s10,s10,s5
    80002d40:	000d0023          	sb	zero,0(s10)
    80002d44:	84ce                	mv	s1,s3
    80002d46:	bfbd                	j	80002cc4 <namex+0xa4>
  if(nameiparent){
    80002d48:	f20b0ae3          	beqz	s6,80002c7c <namex+0x5c>
    iput(ip);
    80002d4c:	8552                	mv	a0,s4
    80002d4e:	b45ff0ef          	jal	80002892 <iput>
    return 0;
    80002d52:	4a01                	li	s4,0
    80002d54:	b725                	j	80002c7c <namex+0x5c>

0000000080002d56 <dirlink>:
{
    80002d56:	715d                	addi	sp,sp,-80
    80002d58:	e486                	sd	ra,72(sp)
    80002d5a:	e0a2                	sd	s0,64(sp)
    80002d5c:	f84a                	sd	s2,48(sp)
    80002d5e:	ec56                	sd	s5,24(sp)
    80002d60:	e85a                	sd	s6,16(sp)
    80002d62:	0880                	addi	s0,sp,80
    80002d64:	892a                	mv	s2,a0
    80002d66:	8aae                	mv	s5,a1
    80002d68:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d6a:	4601                	li	a2,0
    80002d6c:	e09ff0ef          	jal	80002b74 <dirlookup>
    80002d70:	ed1d                	bnez	a0,80002dae <dirlink+0x58>
    80002d72:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d74:	04c92483          	lw	s1,76(s2)
    80002d78:	c4b9                	beqz	s1,80002dc6 <dirlink+0x70>
    80002d7a:	f44e                	sd	s3,40(sp)
    80002d7c:	f052                	sd	s4,32(sp)
    80002d7e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d80:	fb040a13          	addi	s4,s0,-80
    80002d84:	49c1                	li	s3,16
    80002d86:	874e                	mv	a4,s3
    80002d88:	86a6                	mv	a3,s1
    80002d8a:	8652                	mv	a2,s4
    80002d8c:	4581                	li	a1,0
    80002d8e:	854a                	mv	a0,s2
    80002d90:	bd9ff0ef          	jal	80002968 <readi>
    80002d94:	03351163          	bne	a0,s3,80002db6 <dirlink+0x60>
    if(de.inum == 0)
    80002d98:	fb045783          	lhu	a5,-80(s0)
    80002d9c:	c39d                	beqz	a5,80002dc2 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d9e:	24c1                	addiw	s1,s1,16
    80002da0:	04c92783          	lw	a5,76(s2)
    80002da4:	fef4e1e3          	bltu	s1,a5,80002d86 <dirlink+0x30>
    80002da8:	79a2                	ld	s3,40(sp)
    80002daa:	7a02                	ld	s4,32(sp)
    80002dac:	a829                	j	80002dc6 <dirlink+0x70>
    iput(ip);
    80002dae:	ae5ff0ef          	jal	80002892 <iput>
    return -1;
    80002db2:	557d                	li	a0,-1
    80002db4:	a83d                	j	80002df2 <dirlink+0x9c>
      panic("dirlink read");
    80002db6:	00004517          	auipc	a0,0x4
    80002dba:	73250513          	addi	a0,a0,1842 # 800074e8 <etext+0x4e8>
    80002dbe:	738020ef          	jal	800054f6 <panic>
    80002dc2:	79a2                	ld	s3,40(sp)
    80002dc4:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002dc6:	4639                	li	a2,14
    80002dc8:	85d6                	mv	a1,s5
    80002dca:	fb240513          	addi	a0,s0,-78
    80002dce:	c92fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002dd2:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dd6:	4741                	li	a4,16
    80002dd8:	86a6                	mv	a3,s1
    80002dda:	fb040613          	addi	a2,s0,-80
    80002dde:	4581                	li	a1,0
    80002de0:	854a                	mv	a0,s2
    80002de2:	c79ff0ef          	jal	80002a5a <writei>
    80002de6:	1541                	addi	a0,a0,-16
    80002de8:	00a03533          	snez	a0,a0
    80002dec:	40a0053b          	negw	a0,a0
    80002df0:	74e2                	ld	s1,56(sp)
}
    80002df2:	60a6                	ld	ra,72(sp)
    80002df4:	6406                	ld	s0,64(sp)
    80002df6:	7942                	ld	s2,48(sp)
    80002df8:	6ae2                	ld	s5,24(sp)
    80002dfa:	6b42                	ld	s6,16(sp)
    80002dfc:	6161                	addi	sp,sp,80
    80002dfe:	8082                	ret

0000000080002e00 <namei>:

struct inode*
namei(char *path)
{
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e08:	fe040613          	addi	a2,s0,-32
    80002e0c:	4581                	li	a1,0
    80002e0e:	e13ff0ef          	jal	80002c20 <namex>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	6105                	addi	sp,sp,32
    80002e18:	8082                	ret

0000000080002e1a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e1a:	1141                	addi	sp,sp,-16
    80002e1c:	e406                	sd	ra,8(sp)
    80002e1e:	e022                	sd	s0,0(sp)
    80002e20:	0800                	addi	s0,sp,16
    80002e22:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e24:	4585                	li	a1,1
    80002e26:	dfbff0ef          	jal	80002c20 <namex>
}
    80002e2a:	60a2                	ld	ra,8(sp)
    80002e2c:	6402                	ld	s0,0(sp)
    80002e2e:	0141                	addi	sp,sp,16
    80002e30:	8082                	ret

0000000080002e32 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	e426                	sd	s1,8(sp)
    80002e3a:	e04a                	sd	s2,0(sp)
    80002e3c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e3e:	00017917          	auipc	s2,0x17
    80002e42:	4c290913          	addi	s2,s2,1218 # 8001a300 <log>
    80002e46:	01892583          	lw	a1,24(s2)
    80002e4a:	02892503          	lw	a0,40(s2)
    80002e4e:	9b0ff0ef          	jal	80001ffe <bread>
    80002e52:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e54:	02c92603          	lw	a2,44(s2)
    80002e58:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e5a:	00c05f63          	blez	a2,80002e78 <write_head+0x46>
    80002e5e:	00017717          	auipc	a4,0x17
    80002e62:	4d270713          	addi	a4,a4,1234 # 8001a330 <log+0x30>
    80002e66:	87aa                	mv	a5,a0
    80002e68:	060a                	slli	a2,a2,0x2
    80002e6a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e6c:	4314                	lw	a3,0(a4)
    80002e6e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e70:	0711                	addi	a4,a4,4
    80002e72:	0791                	addi	a5,a5,4
    80002e74:	fec79ce3          	bne	a5,a2,80002e6c <write_head+0x3a>
  }
  bwrite(buf);
    80002e78:	8526                	mv	a0,s1
    80002e7a:	a5aff0ef          	jal	800020d4 <bwrite>
  brelse(buf);
    80002e7e:	8526                	mv	a0,s1
    80002e80:	a86ff0ef          	jal	80002106 <brelse>
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6902                	ld	s2,0(sp)
    80002e8c:	6105                	addi	sp,sp,32
    80002e8e:	8082                	ret

0000000080002e90 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e90:	00017797          	auipc	a5,0x17
    80002e94:	49c7a783          	lw	a5,1180(a5) # 8001a32c <log+0x2c>
    80002e98:	0af05263          	blez	a5,80002f3c <install_trans+0xac>
{
    80002e9c:	715d                	addi	sp,sp,-80
    80002e9e:	e486                	sd	ra,72(sp)
    80002ea0:	e0a2                	sd	s0,64(sp)
    80002ea2:	fc26                	sd	s1,56(sp)
    80002ea4:	f84a                	sd	s2,48(sp)
    80002ea6:	f44e                	sd	s3,40(sp)
    80002ea8:	f052                	sd	s4,32(sp)
    80002eaa:	ec56                	sd	s5,24(sp)
    80002eac:	e85a                	sd	s6,16(sp)
    80002eae:	e45e                	sd	s7,8(sp)
    80002eb0:	0880                	addi	s0,sp,80
    80002eb2:	8b2a                	mv	s6,a0
    80002eb4:	00017a97          	auipc	s5,0x17
    80002eb8:	47ca8a93          	addi	s5,s5,1148 # 8001a330 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ebc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ebe:	00017997          	auipc	s3,0x17
    80002ec2:	44298993          	addi	s3,s3,1090 # 8001a300 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ec6:	40000b93          	li	s7,1024
    80002eca:	a829                	j	80002ee4 <install_trans+0x54>
    brelse(lbuf);
    80002ecc:	854a                	mv	a0,s2
    80002ece:	a38ff0ef          	jal	80002106 <brelse>
    brelse(dbuf);
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	a32ff0ef          	jal	80002106 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ed8:	2a05                	addiw	s4,s4,1
    80002eda:	0a91                	addi	s5,s5,4
    80002edc:	02c9a783          	lw	a5,44(s3)
    80002ee0:	04fa5363          	bge	s4,a5,80002f26 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ee4:	0189a583          	lw	a1,24(s3)
    80002ee8:	014585bb          	addw	a1,a1,s4
    80002eec:	2585                	addiw	a1,a1,1
    80002eee:	0289a503          	lw	a0,40(s3)
    80002ef2:	90cff0ef          	jal	80001ffe <bread>
    80002ef6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ef8:	000aa583          	lw	a1,0(s5)
    80002efc:	0289a503          	lw	a0,40(s3)
    80002f00:	8feff0ef          	jal	80001ffe <bread>
    80002f04:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f06:	865e                	mv	a2,s7
    80002f08:	05890593          	addi	a1,s2,88
    80002f0c:	05850513          	addi	a0,a0,88
    80002f10:	aa2fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f14:	8526                	mv	a0,s1
    80002f16:	9beff0ef          	jal	800020d4 <bwrite>
    if(recovering == 0)
    80002f1a:	fa0b19e3          	bnez	s6,80002ecc <install_trans+0x3c>
      bunpin(dbuf);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	a9eff0ef          	jal	800021be <bunpin>
    80002f24:	b765                	j	80002ecc <install_trans+0x3c>
}
    80002f26:	60a6                	ld	ra,72(sp)
    80002f28:	6406                	ld	s0,64(sp)
    80002f2a:	74e2                	ld	s1,56(sp)
    80002f2c:	7942                	ld	s2,48(sp)
    80002f2e:	79a2                	ld	s3,40(sp)
    80002f30:	7a02                	ld	s4,32(sp)
    80002f32:	6ae2                	ld	s5,24(sp)
    80002f34:	6b42                	ld	s6,16(sp)
    80002f36:	6ba2                	ld	s7,8(sp)
    80002f38:	6161                	addi	sp,sp,80
    80002f3a:	8082                	ret
    80002f3c:	8082                	ret

0000000080002f3e <initlog>:
{
    80002f3e:	7179                	addi	sp,sp,-48
    80002f40:	f406                	sd	ra,40(sp)
    80002f42:	f022                	sd	s0,32(sp)
    80002f44:	ec26                	sd	s1,24(sp)
    80002f46:	e84a                	sd	s2,16(sp)
    80002f48:	e44e                	sd	s3,8(sp)
    80002f4a:	1800                	addi	s0,sp,48
    80002f4c:	892a                	mv	s2,a0
    80002f4e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f50:	00017497          	auipc	s1,0x17
    80002f54:	3b048493          	addi	s1,s1,944 # 8001a300 <log>
    80002f58:	00004597          	auipc	a1,0x4
    80002f5c:	5a058593          	addi	a1,a1,1440 # 800074f8 <etext+0x4f8>
    80002f60:	8526                	mv	a0,s1
    80002f62:	03f020ef          	jal	800057a0 <initlock>
  log.start = sb->logstart;
    80002f66:	0149a583          	lw	a1,20(s3)
    80002f6a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f6c:	0109a783          	lw	a5,16(s3)
    80002f70:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f72:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f76:	854a                	mv	a0,s2
    80002f78:	886ff0ef          	jal	80001ffe <bread>
  log.lh.n = lh->n;
    80002f7c:	4d30                	lw	a2,88(a0)
    80002f7e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f80:	00c05f63          	blez	a2,80002f9e <initlog+0x60>
    80002f84:	87aa                	mv	a5,a0
    80002f86:	00017717          	auipc	a4,0x17
    80002f8a:	3aa70713          	addi	a4,a4,938 # 8001a330 <log+0x30>
    80002f8e:	060a                	slli	a2,a2,0x2
    80002f90:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002f92:	4ff4                	lw	a3,92(a5)
    80002f94:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f96:	0791                	addi	a5,a5,4
    80002f98:	0711                	addi	a4,a4,4
    80002f9a:	fec79ce3          	bne	a5,a2,80002f92 <initlog+0x54>
  brelse(buf);
    80002f9e:	968ff0ef          	jal	80002106 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fa2:	4505                	li	a0,1
    80002fa4:	eedff0ef          	jal	80002e90 <install_trans>
  log.lh.n = 0;
    80002fa8:	00017797          	auipc	a5,0x17
    80002fac:	3807a223          	sw	zero,900(a5) # 8001a32c <log+0x2c>
  write_head(); // clear the log
    80002fb0:	e83ff0ef          	jal	80002e32 <write_head>
}
    80002fb4:	70a2                	ld	ra,40(sp)
    80002fb6:	7402                	ld	s0,32(sp)
    80002fb8:	64e2                	ld	s1,24(sp)
    80002fba:	6942                	ld	s2,16(sp)
    80002fbc:	69a2                	ld	s3,8(sp)
    80002fbe:	6145                	addi	sp,sp,48
    80002fc0:	8082                	ret

0000000080002fc2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	e04a                	sd	s2,0(sp)
    80002fcc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002fce:	00017517          	auipc	a0,0x17
    80002fd2:	33250513          	addi	a0,a0,818 # 8001a300 <log>
    80002fd6:	04f020ef          	jal	80005824 <acquire>
  while(1){
    if(log.committing){
    80002fda:	00017497          	auipc	s1,0x17
    80002fde:	32648493          	addi	s1,s1,806 # 8001a300 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fe2:	4979                	li	s2,30
    80002fe4:	a029                	j	80002fee <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002fe6:	85a6                	mv	a1,s1
    80002fe8:	8526                	mv	a0,s1
    80002fea:	b50fe0ef          	jal	8000133a <sleep>
    if(log.committing){
    80002fee:	50dc                	lw	a5,36(s1)
    80002ff0:	fbfd                	bnez	a5,80002fe6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002ff2:	5098                	lw	a4,32(s1)
    80002ff4:	2705                	addiw	a4,a4,1
    80002ff6:	0027179b          	slliw	a5,a4,0x2
    80002ffa:	9fb9                	addw	a5,a5,a4
    80002ffc:	0017979b          	slliw	a5,a5,0x1
    80003000:	54d4                	lw	a3,44(s1)
    80003002:	9fb5                	addw	a5,a5,a3
    80003004:	00f95763          	bge	s2,a5,80003012 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003008:	85a6                	mv	a1,s1
    8000300a:	8526                	mv	a0,s1
    8000300c:	b2efe0ef          	jal	8000133a <sleep>
    80003010:	bff9                	j	80002fee <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003012:	00017517          	auipc	a0,0x17
    80003016:	2ee50513          	addi	a0,a0,750 # 8001a300 <log>
    8000301a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000301c:	09d020ef          	jal	800058b8 <release>
      break;
    }
  }
}
    80003020:	60e2                	ld	ra,24(sp)
    80003022:	6442                	ld	s0,16(sp)
    80003024:	64a2                	ld	s1,8(sp)
    80003026:	6902                	ld	s2,0(sp)
    80003028:	6105                	addi	sp,sp,32
    8000302a:	8082                	ret

000000008000302c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000302c:	7139                	addi	sp,sp,-64
    8000302e:	fc06                	sd	ra,56(sp)
    80003030:	f822                	sd	s0,48(sp)
    80003032:	f426                	sd	s1,40(sp)
    80003034:	f04a                	sd	s2,32(sp)
    80003036:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003038:	00017497          	auipc	s1,0x17
    8000303c:	2c848493          	addi	s1,s1,712 # 8001a300 <log>
    80003040:	8526                	mv	a0,s1
    80003042:	7e2020ef          	jal	80005824 <acquire>
  log.outstanding -= 1;
    80003046:	509c                	lw	a5,32(s1)
    80003048:	37fd                	addiw	a5,a5,-1
    8000304a:	893e                	mv	s2,a5
    8000304c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000304e:	50dc                	lw	a5,36(s1)
    80003050:	ef9d                	bnez	a5,8000308e <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003052:	04091863          	bnez	s2,800030a2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003056:	00017497          	auipc	s1,0x17
    8000305a:	2aa48493          	addi	s1,s1,682 # 8001a300 <log>
    8000305e:	4785                	li	a5,1
    80003060:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003062:	8526                	mv	a0,s1
    80003064:	055020ef          	jal	800058b8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003068:	54dc                	lw	a5,44(s1)
    8000306a:	04f04c63          	bgtz	a5,800030c2 <end_op+0x96>
    acquire(&log.lock);
    8000306e:	00017497          	auipc	s1,0x17
    80003072:	29248493          	addi	s1,s1,658 # 8001a300 <log>
    80003076:	8526                	mv	a0,s1
    80003078:	7ac020ef          	jal	80005824 <acquire>
    log.committing = 0;
    8000307c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003080:	8526                	mv	a0,s1
    80003082:	b04fe0ef          	jal	80001386 <wakeup>
    release(&log.lock);
    80003086:	8526                	mv	a0,s1
    80003088:	031020ef          	jal	800058b8 <release>
}
    8000308c:	a02d                	j	800030b6 <end_op+0x8a>
    8000308e:	ec4e                	sd	s3,24(sp)
    80003090:	e852                	sd	s4,16(sp)
    80003092:	e456                	sd	s5,8(sp)
    80003094:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003096:	00004517          	auipc	a0,0x4
    8000309a:	46a50513          	addi	a0,a0,1130 # 80007500 <etext+0x500>
    8000309e:	458020ef          	jal	800054f6 <panic>
    wakeup(&log);
    800030a2:	00017497          	auipc	s1,0x17
    800030a6:	25e48493          	addi	s1,s1,606 # 8001a300 <log>
    800030aa:	8526                	mv	a0,s1
    800030ac:	adafe0ef          	jal	80001386 <wakeup>
  release(&log.lock);
    800030b0:	8526                	mv	a0,s1
    800030b2:	007020ef          	jal	800058b8 <release>
}
    800030b6:	70e2                	ld	ra,56(sp)
    800030b8:	7442                	ld	s0,48(sp)
    800030ba:	74a2                	ld	s1,40(sp)
    800030bc:	7902                	ld	s2,32(sp)
    800030be:	6121                	addi	sp,sp,64
    800030c0:	8082                	ret
    800030c2:	ec4e                	sd	s3,24(sp)
    800030c4:	e852                	sd	s4,16(sp)
    800030c6:	e456                	sd	s5,8(sp)
    800030c8:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030ca:	00017a97          	auipc	s5,0x17
    800030ce:	266a8a93          	addi	s5,s5,614 # 8001a330 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030d2:	00017a17          	auipc	s4,0x17
    800030d6:	22ea0a13          	addi	s4,s4,558 # 8001a300 <log>
    memmove(to->data, from->data, BSIZE);
    800030da:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030de:	018a2583          	lw	a1,24(s4)
    800030e2:	012585bb          	addw	a1,a1,s2
    800030e6:	2585                	addiw	a1,a1,1
    800030e8:	028a2503          	lw	a0,40(s4)
    800030ec:	f13fe0ef          	jal	80001ffe <bread>
    800030f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800030f2:	000aa583          	lw	a1,0(s5)
    800030f6:	028a2503          	lw	a0,40(s4)
    800030fa:	f05fe0ef          	jal	80001ffe <bread>
    800030fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003100:	865a                	mv	a2,s6
    80003102:	05850593          	addi	a1,a0,88
    80003106:	05848513          	addi	a0,s1,88
    8000310a:	8a8fd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    8000310e:	8526                	mv	a0,s1
    80003110:	fc5fe0ef          	jal	800020d4 <bwrite>
    brelse(from);
    80003114:	854e                	mv	a0,s3
    80003116:	ff1fe0ef          	jal	80002106 <brelse>
    brelse(to);
    8000311a:	8526                	mv	a0,s1
    8000311c:	febfe0ef          	jal	80002106 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003120:	2905                	addiw	s2,s2,1
    80003122:	0a91                	addi	s5,s5,4
    80003124:	02ca2783          	lw	a5,44(s4)
    80003128:	faf94be3          	blt	s2,a5,800030de <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000312c:	d07ff0ef          	jal	80002e32 <write_head>
    install_trans(0); // Now install writes to home locations
    80003130:	4501                	li	a0,0
    80003132:	d5fff0ef          	jal	80002e90 <install_trans>
    log.lh.n = 0;
    80003136:	00017797          	auipc	a5,0x17
    8000313a:	1e07ab23          	sw	zero,502(a5) # 8001a32c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000313e:	cf5ff0ef          	jal	80002e32 <write_head>
    80003142:	69e2                	ld	s3,24(sp)
    80003144:	6a42                	ld	s4,16(sp)
    80003146:	6aa2                	ld	s5,8(sp)
    80003148:	6b02                	ld	s6,0(sp)
    8000314a:	b715                	j	8000306e <end_op+0x42>

000000008000314c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000314c:	1101                	addi	sp,sp,-32
    8000314e:	ec06                	sd	ra,24(sp)
    80003150:	e822                	sd	s0,16(sp)
    80003152:	e426                	sd	s1,8(sp)
    80003154:	e04a                	sd	s2,0(sp)
    80003156:	1000                	addi	s0,sp,32
    80003158:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000315a:	00017917          	auipc	s2,0x17
    8000315e:	1a690913          	addi	s2,s2,422 # 8001a300 <log>
    80003162:	854a                	mv	a0,s2
    80003164:	6c0020ef          	jal	80005824 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003168:	02c92603          	lw	a2,44(s2)
    8000316c:	47f5                	li	a5,29
    8000316e:	06c7c363          	blt	a5,a2,800031d4 <log_write+0x88>
    80003172:	00017797          	auipc	a5,0x17
    80003176:	1aa7a783          	lw	a5,426(a5) # 8001a31c <log+0x1c>
    8000317a:	37fd                	addiw	a5,a5,-1
    8000317c:	04f65c63          	bge	a2,a5,800031d4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003180:	00017797          	auipc	a5,0x17
    80003184:	1a07a783          	lw	a5,416(a5) # 8001a320 <log+0x20>
    80003188:	04f05c63          	blez	a5,800031e0 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000318c:	4781                	li	a5,0
    8000318e:	04c05f63          	blez	a2,800031ec <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003192:	44cc                	lw	a1,12(s1)
    80003194:	00017717          	auipc	a4,0x17
    80003198:	19c70713          	addi	a4,a4,412 # 8001a330 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000319c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000319e:	4314                	lw	a3,0(a4)
    800031a0:	04b68663          	beq	a3,a1,800031ec <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031a4:	2785                	addiw	a5,a5,1
    800031a6:	0711                	addi	a4,a4,4
    800031a8:	fef61be3          	bne	a2,a5,8000319e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031ac:	0621                	addi	a2,a2,8
    800031ae:	060a                	slli	a2,a2,0x2
    800031b0:	00017797          	auipc	a5,0x17
    800031b4:	15078793          	addi	a5,a5,336 # 8001a300 <log>
    800031b8:	97b2                	add	a5,a5,a2
    800031ba:	44d8                	lw	a4,12(s1)
    800031bc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031be:	8526                	mv	a0,s1
    800031c0:	fcbfe0ef          	jal	8000218a <bpin>
    log.lh.n++;
    800031c4:	00017717          	auipc	a4,0x17
    800031c8:	13c70713          	addi	a4,a4,316 # 8001a300 <log>
    800031cc:	575c                	lw	a5,44(a4)
    800031ce:	2785                	addiw	a5,a5,1
    800031d0:	d75c                	sw	a5,44(a4)
    800031d2:	a80d                	j	80003204 <log_write+0xb8>
    panic("too big a transaction");
    800031d4:	00004517          	auipc	a0,0x4
    800031d8:	33c50513          	addi	a0,a0,828 # 80007510 <etext+0x510>
    800031dc:	31a020ef          	jal	800054f6 <panic>
    panic("log_write outside of trans");
    800031e0:	00004517          	auipc	a0,0x4
    800031e4:	34850513          	addi	a0,a0,840 # 80007528 <etext+0x528>
    800031e8:	30e020ef          	jal	800054f6 <panic>
  log.lh.block[i] = b->blockno;
    800031ec:	00878693          	addi	a3,a5,8
    800031f0:	068a                	slli	a3,a3,0x2
    800031f2:	00017717          	auipc	a4,0x17
    800031f6:	10e70713          	addi	a4,a4,270 # 8001a300 <log>
    800031fa:	9736                	add	a4,a4,a3
    800031fc:	44d4                	lw	a3,12(s1)
    800031fe:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003200:	faf60fe3          	beq	a2,a5,800031be <log_write+0x72>
  }
  release(&log.lock);
    80003204:	00017517          	auipc	a0,0x17
    80003208:	0fc50513          	addi	a0,a0,252 # 8001a300 <log>
    8000320c:	6ac020ef          	jal	800058b8 <release>
}
    80003210:	60e2                	ld	ra,24(sp)
    80003212:	6442                	ld	s0,16(sp)
    80003214:	64a2                	ld	s1,8(sp)
    80003216:	6902                	ld	s2,0(sp)
    80003218:	6105                	addi	sp,sp,32
    8000321a:	8082                	ret

000000008000321c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000321c:	1101                	addi	sp,sp,-32
    8000321e:	ec06                	sd	ra,24(sp)
    80003220:	e822                	sd	s0,16(sp)
    80003222:	e426                	sd	s1,8(sp)
    80003224:	e04a                	sd	s2,0(sp)
    80003226:	1000                	addi	s0,sp,32
    80003228:	84aa                	mv	s1,a0
    8000322a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000322c:	00004597          	auipc	a1,0x4
    80003230:	31c58593          	addi	a1,a1,796 # 80007548 <etext+0x548>
    80003234:	0521                	addi	a0,a0,8
    80003236:	56a020ef          	jal	800057a0 <initlock>
  lk->name = name;
    8000323a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000323e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003242:	0204a423          	sw	zero,40(s1)
}
    80003246:	60e2                	ld	ra,24(sp)
    80003248:	6442                	ld	s0,16(sp)
    8000324a:	64a2                	ld	s1,8(sp)
    8000324c:	6902                	ld	s2,0(sp)
    8000324e:	6105                	addi	sp,sp,32
    80003250:	8082                	ret

0000000080003252 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	e04a                	sd	s2,0(sp)
    8000325c:	1000                	addi	s0,sp,32
    8000325e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003260:	00850913          	addi	s2,a0,8
    80003264:	854a                	mv	a0,s2
    80003266:	5be020ef          	jal	80005824 <acquire>
  while (lk->locked) {
    8000326a:	409c                	lw	a5,0(s1)
    8000326c:	c799                	beqz	a5,8000327a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000326e:	85ca                	mv	a1,s2
    80003270:	8526                	mv	a0,s1
    80003272:	8c8fe0ef          	jal	8000133a <sleep>
  while (lk->locked) {
    80003276:	409c                	lw	a5,0(s1)
    80003278:	fbfd                	bnez	a5,8000326e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000327a:	4785                	li	a5,1
    8000327c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000327e:	ae3fd0ef          	jal	80000d60 <myproc>
    80003282:	591c                	lw	a5,48(a0)
    80003284:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003286:	854a                	mv	a0,s2
    80003288:	630020ef          	jal	800058b8 <release>
}
    8000328c:	60e2                	ld	ra,24(sp)
    8000328e:	6442                	ld	s0,16(sp)
    80003290:	64a2                	ld	s1,8(sp)
    80003292:	6902                	ld	s2,0(sp)
    80003294:	6105                	addi	sp,sp,32
    80003296:	8082                	ret

0000000080003298 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003298:	1101                	addi	sp,sp,-32
    8000329a:	ec06                	sd	ra,24(sp)
    8000329c:	e822                	sd	s0,16(sp)
    8000329e:	e426                	sd	s1,8(sp)
    800032a0:	e04a                	sd	s2,0(sp)
    800032a2:	1000                	addi	s0,sp,32
    800032a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032a6:	00850913          	addi	s2,a0,8
    800032aa:	854a                	mv	a0,s2
    800032ac:	578020ef          	jal	80005824 <acquire>
  lk->locked = 0;
    800032b0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032b4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032b8:	8526                	mv	a0,s1
    800032ba:	8ccfe0ef          	jal	80001386 <wakeup>
  release(&lk->lk);
    800032be:	854a                	mv	a0,s2
    800032c0:	5f8020ef          	jal	800058b8 <release>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	1800                	addi	s0,sp,48
    800032dc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800032de:	00850913          	addi	s2,a0,8
    800032e2:	854a                	mv	a0,s2
    800032e4:	540020ef          	jal	80005824 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800032e8:	409c                	lw	a5,0(s1)
    800032ea:	ef81                	bnez	a5,80003302 <holdingsleep+0x32>
    800032ec:	4481                	li	s1,0
  release(&lk->lk);
    800032ee:	854a                	mv	a0,s2
    800032f0:	5c8020ef          	jal	800058b8 <release>
  return r;
}
    800032f4:	8526                	mv	a0,s1
    800032f6:	70a2                	ld	ra,40(sp)
    800032f8:	7402                	ld	s0,32(sp)
    800032fa:	64e2                	ld	s1,24(sp)
    800032fc:	6942                	ld	s2,16(sp)
    800032fe:	6145                	addi	sp,sp,48
    80003300:	8082                	ret
    80003302:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003304:	0284a983          	lw	s3,40(s1)
    80003308:	a59fd0ef          	jal	80000d60 <myproc>
    8000330c:	5904                	lw	s1,48(a0)
    8000330e:	413484b3          	sub	s1,s1,s3
    80003312:	0014b493          	seqz	s1,s1
    80003316:	69a2                	ld	s3,8(sp)
    80003318:	bfd9                	j	800032ee <holdingsleep+0x1e>

000000008000331a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000331a:	1141                	addi	sp,sp,-16
    8000331c:	e406                	sd	ra,8(sp)
    8000331e:	e022                	sd	s0,0(sp)
    80003320:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003322:	00004597          	auipc	a1,0x4
    80003326:	23658593          	addi	a1,a1,566 # 80007558 <etext+0x558>
    8000332a:	00017517          	auipc	a0,0x17
    8000332e:	11e50513          	addi	a0,a0,286 # 8001a448 <ftable>
    80003332:	46e020ef          	jal	800057a0 <initlock>
}
    80003336:	60a2                	ld	ra,8(sp)
    80003338:	6402                	ld	s0,0(sp)
    8000333a:	0141                	addi	sp,sp,16
    8000333c:	8082                	ret

000000008000333e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000333e:	1101                	addi	sp,sp,-32
    80003340:	ec06                	sd	ra,24(sp)
    80003342:	e822                	sd	s0,16(sp)
    80003344:	e426                	sd	s1,8(sp)
    80003346:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003348:	00017517          	auipc	a0,0x17
    8000334c:	10050513          	addi	a0,a0,256 # 8001a448 <ftable>
    80003350:	4d4020ef          	jal	80005824 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003354:	00017497          	auipc	s1,0x17
    80003358:	10c48493          	addi	s1,s1,268 # 8001a460 <ftable+0x18>
    8000335c:	00018717          	auipc	a4,0x18
    80003360:	0a470713          	addi	a4,a4,164 # 8001b400 <disk>
    if(f->ref == 0){
    80003364:	40dc                	lw	a5,4(s1)
    80003366:	cf89                	beqz	a5,80003380 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003368:	02848493          	addi	s1,s1,40
    8000336c:	fee49ce3          	bne	s1,a4,80003364 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003370:	00017517          	auipc	a0,0x17
    80003374:	0d850513          	addi	a0,a0,216 # 8001a448 <ftable>
    80003378:	540020ef          	jal	800058b8 <release>
  return 0;
    8000337c:	4481                	li	s1,0
    8000337e:	a809                	j	80003390 <filealloc+0x52>
      f->ref = 1;
    80003380:	4785                	li	a5,1
    80003382:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003384:	00017517          	auipc	a0,0x17
    80003388:	0c450513          	addi	a0,a0,196 # 8001a448 <ftable>
    8000338c:	52c020ef          	jal	800058b8 <release>
}
    80003390:	8526                	mv	a0,s1
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	64a2                	ld	s1,8(sp)
    80003398:	6105                	addi	sp,sp,32
    8000339a:	8082                	ret

000000008000339c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000339c:	1101                	addi	sp,sp,-32
    8000339e:	ec06                	sd	ra,24(sp)
    800033a0:	e822                	sd	s0,16(sp)
    800033a2:	e426                	sd	s1,8(sp)
    800033a4:	1000                	addi	s0,sp,32
    800033a6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033a8:	00017517          	auipc	a0,0x17
    800033ac:	0a050513          	addi	a0,a0,160 # 8001a448 <ftable>
    800033b0:	474020ef          	jal	80005824 <acquire>
  if(f->ref < 1)
    800033b4:	40dc                	lw	a5,4(s1)
    800033b6:	02f05063          	blez	a5,800033d6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033ba:	2785                	addiw	a5,a5,1
    800033bc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033be:	00017517          	auipc	a0,0x17
    800033c2:	08a50513          	addi	a0,a0,138 # 8001a448 <ftable>
    800033c6:	4f2020ef          	jal	800058b8 <release>
  return f;
}
    800033ca:	8526                	mv	a0,s1
    800033cc:	60e2                	ld	ra,24(sp)
    800033ce:	6442                	ld	s0,16(sp)
    800033d0:	64a2                	ld	s1,8(sp)
    800033d2:	6105                	addi	sp,sp,32
    800033d4:	8082                	ret
    panic("filedup");
    800033d6:	00004517          	auipc	a0,0x4
    800033da:	18a50513          	addi	a0,a0,394 # 80007560 <etext+0x560>
    800033de:	118020ef          	jal	800054f6 <panic>

00000000800033e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800033e2:	7139                	addi	sp,sp,-64
    800033e4:	fc06                	sd	ra,56(sp)
    800033e6:	f822                	sd	s0,48(sp)
    800033e8:	f426                	sd	s1,40(sp)
    800033ea:	0080                	addi	s0,sp,64
    800033ec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800033ee:	00017517          	auipc	a0,0x17
    800033f2:	05a50513          	addi	a0,a0,90 # 8001a448 <ftable>
    800033f6:	42e020ef          	jal	80005824 <acquire>
  if(f->ref < 1)
    800033fa:	40dc                	lw	a5,4(s1)
    800033fc:	04f05863          	blez	a5,8000344c <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80003400:	37fd                	addiw	a5,a5,-1
    80003402:	c0dc                	sw	a5,4(s1)
    80003404:	04f04e63          	bgtz	a5,80003460 <fileclose+0x7e>
    80003408:	f04a                	sd	s2,32(sp)
    8000340a:	ec4e                	sd	s3,24(sp)
    8000340c:	e852                	sd	s4,16(sp)
    8000340e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003410:	0004a903          	lw	s2,0(s1)
    80003414:	0094ca83          	lbu	s5,9(s1)
    80003418:	0104ba03          	ld	s4,16(s1)
    8000341c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003420:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003424:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003428:	00017517          	auipc	a0,0x17
    8000342c:	02050513          	addi	a0,a0,32 # 8001a448 <ftable>
    80003430:	488020ef          	jal	800058b8 <release>

  if(ff.type == FD_PIPE){
    80003434:	4785                	li	a5,1
    80003436:	04f90063          	beq	s2,a5,80003476 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000343a:	3979                	addiw	s2,s2,-2
    8000343c:	4785                	li	a5,1
    8000343e:	0527f563          	bgeu	a5,s2,80003488 <fileclose+0xa6>
    80003442:	7902                	ld	s2,32(sp)
    80003444:	69e2                	ld	s3,24(sp)
    80003446:	6a42                	ld	s4,16(sp)
    80003448:	6aa2                	ld	s5,8(sp)
    8000344a:	a00d                	j	8000346c <fileclose+0x8a>
    8000344c:	f04a                	sd	s2,32(sp)
    8000344e:	ec4e                	sd	s3,24(sp)
    80003450:	e852                	sd	s4,16(sp)
    80003452:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003454:	00004517          	auipc	a0,0x4
    80003458:	11450513          	addi	a0,a0,276 # 80007568 <etext+0x568>
    8000345c:	09a020ef          	jal	800054f6 <panic>
    release(&ftable.lock);
    80003460:	00017517          	auipc	a0,0x17
    80003464:	fe850513          	addi	a0,a0,-24 # 8001a448 <ftable>
    80003468:	450020ef          	jal	800058b8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000346c:	70e2                	ld	ra,56(sp)
    8000346e:	7442                	ld	s0,48(sp)
    80003470:	74a2                	ld	s1,40(sp)
    80003472:	6121                	addi	sp,sp,64
    80003474:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003476:	85d6                	mv	a1,s5
    80003478:	8552                	mv	a0,s4
    8000347a:	340000ef          	jal	800037ba <pipeclose>
    8000347e:	7902                	ld	s2,32(sp)
    80003480:	69e2                	ld	s3,24(sp)
    80003482:	6a42                	ld	s4,16(sp)
    80003484:	6aa2                	ld	s5,8(sp)
    80003486:	b7dd                	j	8000346c <fileclose+0x8a>
    begin_op();
    80003488:	b3bff0ef          	jal	80002fc2 <begin_op>
    iput(ff.ip);
    8000348c:	854e                	mv	a0,s3
    8000348e:	c04ff0ef          	jal	80002892 <iput>
    end_op();
    80003492:	b9bff0ef          	jal	8000302c <end_op>
    80003496:	7902                	ld	s2,32(sp)
    80003498:	69e2                	ld	s3,24(sp)
    8000349a:	6a42                	ld	s4,16(sp)
    8000349c:	6aa2                	ld	s5,8(sp)
    8000349e:	b7f9                	j	8000346c <fileclose+0x8a>

00000000800034a0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034a0:	715d                	addi	sp,sp,-80
    800034a2:	e486                	sd	ra,72(sp)
    800034a4:	e0a2                	sd	s0,64(sp)
    800034a6:	fc26                	sd	s1,56(sp)
    800034a8:	f44e                	sd	s3,40(sp)
    800034aa:	0880                	addi	s0,sp,80
    800034ac:	84aa                	mv	s1,a0
    800034ae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034b0:	8b1fd0ef          	jal	80000d60 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034b4:	409c                	lw	a5,0(s1)
    800034b6:	37f9                	addiw	a5,a5,-2
    800034b8:	4705                	li	a4,1
    800034ba:	04f76263          	bltu	a4,a5,800034fe <filestat+0x5e>
    800034be:	f84a                	sd	s2,48(sp)
    800034c0:	f052                	sd	s4,32(sp)
    800034c2:	892a                	mv	s2,a0
    ilock(f->ip);
    800034c4:	6c88                	ld	a0,24(s1)
    800034c6:	a4aff0ef          	jal	80002710 <ilock>
    stati(f->ip, &st);
    800034ca:	fb840a13          	addi	s4,s0,-72
    800034ce:	85d2                	mv	a1,s4
    800034d0:	6c88                	ld	a0,24(s1)
    800034d2:	c68ff0ef          	jal	8000293a <stati>
    iunlock(f->ip);
    800034d6:	6c88                	ld	a0,24(s1)
    800034d8:	ae6ff0ef          	jal	800027be <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034dc:	46e1                	li	a3,24
    800034de:	8652                	mv	a2,s4
    800034e0:	85ce                	mv	a1,s3
    800034e2:	05093503          	ld	a0,80(s2)
    800034e6:	d1efd0ef          	jal	80000a04 <copyout>
    800034ea:	41f5551b          	sraiw	a0,a0,0x1f
    800034ee:	7942                	ld	s2,48(sp)
    800034f0:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800034f2:	60a6                	ld	ra,72(sp)
    800034f4:	6406                	ld	s0,64(sp)
    800034f6:	74e2                	ld	s1,56(sp)
    800034f8:	79a2                	ld	s3,40(sp)
    800034fa:	6161                	addi	sp,sp,80
    800034fc:	8082                	ret
  return -1;
    800034fe:	557d                	li	a0,-1
    80003500:	bfcd                	j	800034f2 <filestat+0x52>

0000000080003502 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003502:	7179                	addi	sp,sp,-48
    80003504:	f406                	sd	ra,40(sp)
    80003506:	f022                	sd	s0,32(sp)
    80003508:	e84a                	sd	s2,16(sp)
    8000350a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000350c:	00854783          	lbu	a5,8(a0)
    80003510:	cfd1                	beqz	a5,800035ac <fileread+0xaa>
    80003512:	ec26                	sd	s1,24(sp)
    80003514:	e44e                	sd	s3,8(sp)
    80003516:	84aa                	mv	s1,a0
    80003518:	89ae                	mv	s3,a1
    8000351a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000351c:	411c                	lw	a5,0(a0)
    8000351e:	4705                	li	a4,1
    80003520:	04e78363          	beq	a5,a4,80003566 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003524:	470d                	li	a4,3
    80003526:	04e78763          	beq	a5,a4,80003574 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000352a:	4709                	li	a4,2
    8000352c:	06e79a63          	bne	a5,a4,800035a0 <fileread+0x9e>
    ilock(f->ip);
    80003530:	6d08                	ld	a0,24(a0)
    80003532:	9deff0ef          	jal	80002710 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003536:	874a                	mv	a4,s2
    80003538:	5094                	lw	a3,32(s1)
    8000353a:	864e                	mv	a2,s3
    8000353c:	4585                	li	a1,1
    8000353e:	6c88                	ld	a0,24(s1)
    80003540:	c28ff0ef          	jal	80002968 <readi>
    80003544:	892a                	mv	s2,a0
    80003546:	00a05563          	blez	a0,80003550 <fileread+0x4e>
      f->off += r;
    8000354a:	509c                	lw	a5,32(s1)
    8000354c:	9fa9                	addw	a5,a5,a0
    8000354e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003550:	6c88                	ld	a0,24(s1)
    80003552:	a6cff0ef          	jal	800027be <iunlock>
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000355a:	854a                	mv	a0,s2
    8000355c:	70a2                	ld	ra,40(sp)
    8000355e:	7402                	ld	s0,32(sp)
    80003560:	6942                	ld	s2,16(sp)
    80003562:	6145                	addi	sp,sp,48
    80003564:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003566:	6908                	ld	a0,16(a0)
    80003568:	3a2000ef          	jal	8000390a <piperead>
    8000356c:	892a                	mv	s2,a0
    8000356e:	64e2                	ld	s1,24(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	b7e5                	j	8000355a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003574:	02451783          	lh	a5,36(a0)
    80003578:	03079693          	slli	a3,a5,0x30
    8000357c:	92c1                	srli	a3,a3,0x30
    8000357e:	4725                	li	a4,9
    80003580:	02d76863          	bltu	a4,a3,800035b0 <fileread+0xae>
    80003584:	0792                	slli	a5,a5,0x4
    80003586:	00017717          	auipc	a4,0x17
    8000358a:	e2270713          	addi	a4,a4,-478 # 8001a3a8 <devsw>
    8000358e:	97ba                	add	a5,a5,a4
    80003590:	639c                	ld	a5,0(a5)
    80003592:	c39d                	beqz	a5,800035b8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003594:	4505                	li	a0,1
    80003596:	9782                	jalr	a5
    80003598:	892a                	mv	s2,a0
    8000359a:	64e2                	ld	s1,24(sp)
    8000359c:	69a2                	ld	s3,8(sp)
    8000359e:	bf75                	j	8000355a <fileread+0x58>
    panic("fileread");
    800035a0:	00004517          	auipc	a0,0x4
    800035a4:	fd850513          	addi	a0,a0,-40 # 80007578 <etext+0x578>
    800035a8:	74f010ef          	jal	800054f6 <panic>
    return -1;
    800035ac:	597d                	li	s2,-1
    800035ae:	b775                	j	8000355a <fileread+0x58>
      return -1;
    800035b0:	597d                	li	s2,-1
    800035b2:	64e2                	ld	s1,24(sp)
    800035b4:	69a2                	ld	s3,8(sp)
    800035b6:	b755                	j	8000355a <fileread+0x58>
    800035b8:	597d                	li	s2,-1
    800035ba:	64e2                	ld	s1,24(sp)
    800035bc:	69a2                	ld	s3,8(sp)
    800035be:	bf71                	j	8000355a <fileread+0x58>

00000000800035c0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035c0:	00954783          	lbu	a5,9(a0)
    800035c4:	10078e63          	beqz	a5,800036e0 <filewrite+0x120>
{
    800035c8:	711d                	addi	sp,sp,-96
    800035ca:	ec86                	sd	ra,88(sp)
    800035cc:	e8a2                	sd	s0,80(sp)
    800035ce:	e0ca                	sd	s2,64(sp)
    800035d0:	f456                	sd	s5,40(sp)
    800035d2:	f05a                	sd	s6,32(sp)
    800035d4:	1080                	addi	s0,sp,96
    800035d6:	892a                	mv	s2,a0
    800035d8:	8b2e                	mv	s6,a1
    800035da:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800035dc:	411c                	lw	a5,0(a0)
    800035de:	4705                	li	a4,1
    800035e0:	02e78963          	beq	a5,a4,80003612 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035e4:	470d                	li	a4,3
    800035e6:	02e78a63          	beq	a5,a4,8000361a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035ea:	4709                	li	a4,2
    800035ec:	0ce79e63          	bne	a5,a4,800036c8 <filewrite+0x108>
    800035f0:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035f2:	0ac05963          	blez	a2,800036a4 <filewrite+0xe4>
    800035f6:	e4a6                	sd	s1,72(sp)
    800035f8:	fc4e                	sd	s3,56(sp)
    800035fa:	ec5e                	sd	s7,24(sp)
    800035fc:	e862                	sd	s8,16(sp)
    800035fe:	e466                	sd	s9,8(sp)
    int i = 0;
    80003600:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003602:	6b85                	lui	s7,0x1
    80003604:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003608:	6c85                	lui	s9,0x1
    8000360a:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000360e:	4c05                	li	s8,1
    80003610:	a8ad                	j	8000368a <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003612:	6908                	ld	a0,16(a0)
    80003614:	1fe000ef          	jal	80003812 <pipewrite>
    80003618:	a04d                	j	800036ba <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000361a:	02451783          	lh	a5,36(a0)
    8000361e:	03079693          	slli	a3,a5,0x30
    80003622:	92c1                	srli	a3,a3,0x30
    80003624:	4725                	li	a4,9
    80003626:	0ad76f63          	bltu	a4,a3,800036e4 <filewrite+0x124>
    8000362a:	0792                	slli	a5,a5,0x4
    8000362c:	00017717          	auipc	a4,0x17
    80003630:	d7c70713          	addi	a4,a4,-644 # 8001a3a8 <devsw>
    80003634:	97ba                	add	a5,a5,a4
    80003636:	679c                	ld	a5,8(a5)
    80003638:	cbc5                	beqz	a5,800036e8 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    8000363a:	4505                	li	a0,1
    8000363c:	9782                	jalr	a5
    8000363e:	a8b5                	j	800036ba <filewrite+0xfa>
      if(n1 > max)
    80003640:	2981                	sext.w	s3,s3
      begin_op();
    80003642:	981ff0ef          	jal	80002fc2 <begin_op>
      ilock(f->ip);
    80003646:	01893503          	ld	a0,24(s2)
    8000364a:	8c6ff0ef          	jal	80002710 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000364e:	874e                	mv	a4,s3
    80003650:	02092683          	lw	a3,32(s2)
    80003654:	016a0633          	add	a2,s4,s6
    80003658:	85e2                	mv	a1,s8
    8000365a:	01893503          	ld	a0,24(s2)
    8000365e:	bfcff0ef          	jal	80002a5a <writei>
    80003662:	84aa                	mv	s1,a0
    80003664:	00a05763          	blez	a0,80003672 <filewrite+0xb2>
        f->off += r;
    80003668:	02092783          	lw	a5,32(s2)
    8000366c:	9fa9                	addw	a5,a5,a0
    8000366e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003672:	01893503          	ld	a0,24(s2)
    80003676:	948ff0ef          	jal	800027be <iunlock>
      end_op();
    8000367a:	9b3ff0ef          	jal	8000302c <end_op>

      if(r != n1){
    8000367e:	02999563          	bne	s3,s1,800036a8 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80003682:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003686:	015a5963          	bge	s4,s5,80003698 <filewrite+0xd8>
      int n1 = n - i;
    8000368a:	414a87bb          	subw	a5,s5,s4
    8000368e:	89be                	mv	s3,a5
      if(n1 > max)
    80003690:	fafbd8e3          	bge	s7,a5,80003640 <filewrite+0x80>
    80003694:	89e6                	mv	s3,s9
    80003696:	b76d                	j	80003640 <filewrite+0x80>
    80003698:	64a6                	ld	s1,72(sp)
    8000369a:	79e2                	ld	s3,56(sp)
    8000369c:	6be2                	ld	s7,24(sp)
    8000369e:	6c42                	ld	s8,16(sp)
    800036a0:	6ca2                	ld	s9,8(sp)
    800036a2:	a801                	j	800036b2 <filewrite+0xf2>
    int i = 0;
    800036a4:	4a01                	li	s4,0
    800036a6:	a031                	j	800036b2 <filewrite+0xf2>
    800036a8:	64a6                	ld	s1,72(sp)
    800036aa:	79e2                	ld	s3,56(sp)
    800036ac:	6be2                	ld	s7,24(sp)
    800036ae:	6c42                	ld	s8,16(sp)
    800036b0:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800036b2:	034a9d63          	bne	s5,s4,800036ec <filewrite+0x12c>
    800036b6:	8556                	mv	a0,s5
    800036b8:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036ba:	60e6                	ld	ra,88(sp)
    800036bc:	6446                	ld	s0,80(sp)
    800036be:	6906                	ld	s2,64(sp)
    800036c0:	7aa2                	ld	s5,40(sp)
    800036c2:	7b02                	ld	s6,32(sp)
    800036c4:	6125                	addi	sp,sp,96
    800036c6:	8082                	ret
    800036c8:	e4a6                	sd	s1,72(sp)
    800036ca:	fc4e                	sd	s3,56(sp)
    800036cc:	f852                	sd	s4,48(sp)
    800036ce:	ec5e                	sd	s7,24(sp)
    800036d0:	e862                	sd	s8,16(sp)
    800036d2:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800036d4:	00004517          	auipc	a0,0x4
    800036d8:	eb450513          	addi	a0,a0,-332 # 80007588 <etext+0x588>
    800036dc:	61b010ef          	jal	800054f6 <panic>
    return -1;
    800036e0:	557d                	li	a0,-1
}
    800036e2:	8082                	ret
      return -1;
    800036e4:	557d                	li	a0,-1
    800036e6:	bfd1                	j	800036ba <filewrite+0xfa>
    800036e8:	557d                	li	a0,-1
    800036ea:	bfc1                	j	800036ba <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800036ec:	557d                	li	a0,-1
    800036ee:	7a42                	ld	s4,48(sp)
    800036f0:	b7e9                	j	800036ba <filewrite+0xfa>

00000000800036f2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800036f2:	7179                	addi	sp,sp,-48
    800036f4:	f406                	sd	ra,40(sp)
    800036f6:	f022                	sd	s0,32(sp)
    800036f8:	ec26                	sd	s1,24(sp)
    800036fa:	e052                	sd	s4,0(sp)
    800036fc:	1800                	addi	s0,sp,48
    800036fe:	84aa                	mv	s1,a0
    80003700:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003702:	0005b023          	sd	zero,0(a1)
    80003706:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000370a:	c35ff0ef          	jal	8000333e <filealloc>
    8000370e:	e088                	sd	a0,0(s1)
    80003710:	c549                	beqz	a0,8000379a <pipealloc+0xa8>
    80003712:	c2dff0ef          	jal	8000333e <filealloc>
    80003716:	00aa3023          	sd	a0,0(s4)
    8000371a:	cd25                	beqz	a0,80003792 <pipealloc+0xa0>
    8000371c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000371e:	9e1fc0ef          	jal	800000fe <kalloc>
    80003722:	892a                	mv	s2,a0
    80003724:	c12d                	beqz	a0,80003786 <pipealloc+0x94>
    80003726:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003728:	4985                	li	s3,1
    8000372a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000372e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003732:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003736:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000373a:	00004597          	auipc	a1,0x4
    8000373e:	e5e58593          	addi	a1,a1,-418 # 80007598 <etext+0x598>
    80003742:	05e020ef          	jal	800057a0 <initlock>
  (*f0)->type = FD_PIPE;
    80003746:	609c                	ld	a5,0(s1)
    80003748:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000374c:	609c                	ld	a5,0(s1)
    8000374e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003752:	609c                	ld	a5,0(s1)
    80003754:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003758:	609c                	ld	a5,0(s1)
    8000375a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000375e:	000a3783          	ld	a5,0(s4)
    80003762:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003766:	000a3783          	ld	a5,0(s4)
    8000376a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000376e:	000a3783          	ld	a5,0(s4)
    80003772:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003776:	000a3783          	ld	a5,0(s4)
    8000377a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000377e:	4501                	li	a0,0
    80003780:	6942                	ld	s2,16(sp)
    80003782:	69a2                	ld	s3,8(sp)
    80003784:	a01d                	j	800037aa <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003786:	6088                	ld	a0,0(s1)
    80003788:	c119                	beqz	a0,8000378e <pipealloc+0x9c>
    8000378a:	6942                	ld	s2,16(sp)
    8000378c:	a029                	j	80003796 <pipealloc+0xa4>
    8000378e:	6942                	ld	s2,16(sp)
    80003790:	a029                	j	8000379a <pipealloc+0xa8>
    80003792:	6088                	ld	a0,0(s1)
    80003794:	c10d                	beqz	a0,800037b6 <pipealloc+0xc4>
    fileclose(*f0);
    80003796:	c4dff0ef          	jal	800033e2 <fileclose>
  if(*f1)
    8000379a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000379e:	557d                	li	a0,-1
  if(*f1)
    800037a0:	c789                	beqz	a5,800037aa <pipealloc+0xb8>
    fileclose(*f1);
    800037a2:	853e                	mv	a0,a5
    800037a4:	c3fff0ef          	jal	800033e2 <fileclose>
  return -1;
    800037a8:	557d                	li	a0,-1
}
    800037aa:	70a2                	ld	ra,40(sp)
    800037ac:	7402                	ld	s0,32(sp)
    800037ae:	64e2                	ld	s1,24(sp)
    800037b0:	6a02                	ld	s4,0(sp)
    800037b2:	6145                	addi	sp,sp,48
    800037b4:	8082                	ret
  return -1;
    800037b6:	557d                	li	a0,-1
    800037b8:	bfcd                	j	800037aa <pipealloc+0xb8>

00000000800037ba <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
    800037c8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037ca:	05a020ef          	jal	80005824 <acquire>
  if(writable){
    800037ce:	02090763          	beqz	s2,800037fc <pipeclose+0x42>
    pi->writeopen = 0;
    800037d2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037d6:	21848513          	addi	a0,s1,536
    800037da:	badfd0ef          	jal	80001386 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800037de:	2204b783          	ld	a5,544(s1)
    800037e2:	e785                	bnez	a5,8000380a <pipeclose+0x50>
    release(&pi->lock);
    800037e4:	8526                	mv	a0,s1
    800037e6:	0d2020ef          	jal	800058b8 <release>
    kfree((char*)pi);
    800037ea:	8526                	mv	a0,s1
    800037ec:	831fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret
    pi->readopen = 0;
    800037fc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003800:	21c48513          	addi	a0,s1,540
    80003804:	b83fd0ef          	jal	80001386 <wakeup>
    80003808:	bfd9                	j	800037de <pipeclose+0x24>
    release(&pi->lock);
    8000380a:	8526                	mv	a0,s1
    8000380c:	0ac020ef          	jal	800058b8 <release>
}
    80003810:	b7c5                	j	800037f0 <pipeclose+0x36>

0000000080003812 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003812:	7159                	addi	sp,sp,-112
    80003814:	f486                	sd	ra,104(sp)
    80003816:	f0a2                	sd	s0,96(sp)
    80003818:	eca6                	sd	s1,88(sp)
    8000381a:	e8ca                	sd	s2,80(sp)
    8000381c:	e4ce                	sd	s3,72(sp)
    8000381e:	e0d2                	sd	s4,64(sp)
    80003820:	fc56                	sd	s5,56(sp)
    80003822:	1880                	addi	s0,sp,112
    80003824:	84aa                	mv	s1,a0
    80003826:	8aae                	mv	s5,a1
    80003828:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000382a:	d36fd0ef          	jal	80000d60 <myproc>
    8000382e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003830:	8526                	mv	a0,s1
    80003832:	7f3010ef          	jal	80005824 <acquire>
  while(i < n){
    80003836:	0d405263          	blez	s4,800038fa <pipewrite+0xe8>
    8000383a:	f85a                	sd	s6,48(sp)
    8000383c:	f45e                	sd	s7,40(sp)
    8000383e:	f062                	sd	s8,32(sp)
    80003840:	ec66                	sd	s9,24(sp)
    80003842:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003844:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003846:	f9f40c13          	addi	s8,s0,-97
    8000384a:	4b85                	li	s7,1
    8000384c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000384e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003852:	21c48c93          	addi	s9,s1,540
    80003856:	a82d                	j	80003890 <pipewrite+0x7e>
      release(&pi->lock);
    80003858:	8526                	mv	a0,s1
    8000385a:	05e020ef          	jal	800058b8 <release>
      return -1;
    8000385e:	597d                	li	s2,-1
    80003860:	7b42                	ld	s6,48(sp)
    80003862:	7ba2                	ld	s7,40(sp)
    80003864:	7c02                	ld	s8,32(sp)
    80003866:	6ce2                	ld	s9,24(sp)
    80003868:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000386a:	854a                	mv	a0,s2
    8000386c:	70a6                	ld	ra,104(sp)
    8000386e:	7406                	ld	s0,96(sp)
    80003870:	64e6                	ld	s1,88(sp)
    80003872:	6946                	ld	s2,80(sp)
    80003874:	69a6                	ld	s3,72(sp)
    80003876:	6a06                	ld	s4,64(sp)
    80003878:	7ae2                	ld	s5,56(sp)
    8000387a:	6165                	addi	sp,sp,112
    8000387c:	8082                	ret
      wakeup(&pi->nread);
    8000387e:	856a                	mv	a0,s10
    80003880:	b07fd0ef          	jal	80001386 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003884:	85a6                	mv	a1,s1
    80003886:	8566                	mv	a0,s9
    80003888:	ab3fd0ef          	jal	8000133a <sleep>
  while(i < n){
    8000388c:	05495a63          	bge	s2,s4,800038e0 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003890:	2204a783          	lw	a5,544(s1)
    80003894:	d3f1                	beqz	a5,80003858 <pipewrite+0x46>
    80003896:	854e                	mv	a0,s3
    80003898:	cdbfd0ef          	jal	80001572 <killed>
    8000389c:	fd55                	bnez	a0,80003858 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000389e:	2184a783          	lw	a5,536(s1)
    800038a2:	21c4a703          	lw	a4,540(s1)
    800038a6:	2007879b          	addiw	a5,a5,512
    800038aa:	fcf70ae3          	beq	a4,a5,8000387e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038ae:	86de                	mv	a3,s7
    800038b0:	01590633          	add	a2,s2,s5
    800038b4:	85e2                	mv	a1,s8
    800038b6:	0509b503          	ld	a0,80(s3)
    800038ba:	9fafd0ef          	jal	80000ab4 <copyin>
    800038be:	05650063          	beq	a0,s6,800038fe <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038c2:	21c4a783          	lw	a5,540(s1)
    800038c6:	0017871b          	addiw	a4,a5,1
    800038ca:	20e4ae23          	sw	a4,540(s1)
    800038ce:	1ff7f793          	andi	a5,a5,511
    800038d2:	97a6                	add	a5,a5,s1
    800038d4:	f9f44703          	lbu	a4,-97(s0)
    800038d8:	00e78c23          	sb	a4,24(a5)
      i++;
    800038dc:	2905                	addiw	s2,s2,1
    800038de:	b77d                	j	8000388c <pipewrite+0x7a>
    800038e0:	7b42                	ld	s6,48(sp)
    800038e2:	7ba2                	ld	s7,40(sp)
    800038e4:	7c02                	ld	s8,32(sp)
    800038e6:	6ce2                	ld	s9,24(sp)
    800038e8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800038ea:	21848513          	addi	a0,s1,536
    800038ee:	a99fd0ef          	jal	80001386 <wakeup>
  release(&pi->lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	7c5010ef          	jal	800058b8 <release>
  return i;
    800038f8:	bf8d                	j	8000386a <pipewrite+0x58>
  int i = 0;
    800038fa:	4901                	li	s2,0
    800038fc:	b7fd                	j	800038ea <pipewrite+0xd8>
    800038fe:	7b42                	ld	s6,48(sp)
    80003900:	7ba2                	ld	s7,40(sp)
    80003902:	7c02                	ld	s8,32(sp)
    80003904:	6ce2                	ld	s9,24(sp)
    80003906:	6d42                	ld	s10,16(sp)
    80003908:	b7cd                	j	800038ea <pipewrite+0xd8>

000000008000390a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000390a:	711d                	addi	sp,sp,-96
    8000390c:	ec86                	sd	ra,88(sp)
    8000390e:	e8a2                	sd	s0,80(sp)
    80003910:	e4a6                	sd	s1,72(sp)
    80003912:	e0ca                	sd	s2,64(sp)
    80003914:	fc4e                	sd	s3,56(sp)
    80003916:	f852                	sd	s4,48(sp)
    80003918:	f456                	sd	s5,40(sp)
    8000391a:	1080                	addi	s0,sp,96
    8000391c:	84aa                	mv	s1,a0
    8000391e:	892e                	mv	s2,a1
    80003920:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003922:	c3efd0ef          	jal	80000d60 <myproc>
    80003926:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003928:	8526                	mv	a0,s1
    8000392a:	6fb010ef          	jal	80005824 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000392e:	2184a703          	lw	a4,536(s1)
    80003932:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003936:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000393a:	02f71763          	bne	a4,a5,80003968 <piperead+0x5e>
    8000393e:	2244a783          	lw	a5,548(s1)
    80003942:	cf85                	beqz	a5,8000397a <piperead+0x70>
    if(killed(pr)){
    80003944:	8552                	mv	a0,s4
    80003946:	c2dfd0ef          	jal	80001572 <killed>
    8000394a:	e11d                	bnez	a0,80003970 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000394c:	85a6                	mv	a1,s1
    8000394e:	854e                	mv	a0,s3
    80003950:	9ebfd0ef          	jal	8000133a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003954:	2184a703          	lw	a4,536(s1)
    80003958:	21c4a783          	lw	a5,540(s1)
    8000395c:	fef701e3          	beq	a4,a5,8000393e <piperead+0x34>
    80003960:	f05a                	sd	s6,32(sp)
    80003962:	ec5e                	sd	s7,24(sp)
    80003964:	e862                	sd	s8,16(sp)
    80003966:	a829                	j	80003980 <piperead+0x76>
    80003968:	f05a                	sd	s6,32(sp)
    8000396a:	ec5e                	sd	s7,24(sp)
    8000396c:	e862                	sd	s8,16(sp)
    8000396e:	a809                	j	80003980 <piperead+0x76>
      release(&pi->lock);
    80003970:	8526                	mv	a0,s1
    80003972:	747010ef          	jal	800058b8 <release>
      return -1;
    80003976:	59fd                	li	s3,-1
    80003978:	a0a5                	j	800039e0 <piperead+0xd6>
    8000397a:	f05a                	sd	s6,32(sp)
    8000397c:	ec5e                	sd	s7,24(sp)
    8000397e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003980:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003982:	faf40c13          	addi	s8,s0,-81
    80003986:	4b85                	li	s7,1
    80003988:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000398a:	05505163          	blez	s5,800039cc <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000398e:	2184a783          	lw	a5,536(s1)
    80003992:	21c4a703          	lw	a4,540(s1)
    80003996:	02f70b63          	beq	a4,a5,800039cc <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000399a:	0017871b          	addiw	a4,a5,1
    8000399e:	20e4ac23          	sw	a4,536(s1)
    800039a2:	1ff7f793          	andi	a5,a5,511
    800039a6:	97a6                	add	a5,a5,s1
    800039a8:	0187c783          	lbu	a5,24(a5)
    800039ac:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039b0:	86de                	mv	a3,s7
    800039b2:	8662                	mv	a2,s8
    800039b4:	85ca                	mv	a1,s2
    800039b6:	050a3503          	ld	a0,80(s4)
    800039ba:	84afd0ef          	jal	80000a04 <copyout>
    800039be:	01650763          	beq	a0,s6,800039cc <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039c2:	2985                	addiw	s3,s3,1
    800039c4:	0905                	addi	s2,s2,1
    800039c6:	fd3a94e3          	bne	s5,s3,8000398e <piperead+0x84>
    800039ca:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039cc:	21c48513          	addi	a0,s1,540
    800039d0:	9b7fd0ef          	jal	80001386 <wakeup>
  release(&pi->lock);
    800039d4:	8526                	mv	a0,s1
    800039d6:	6e3010ef          	jal	800058b8 <release>
    800039da:	7b02                	ld	s6,32(sp)
    800039dc:	6be2                	ld	s7,24(sp)
    800039de:	6c42                	ld	s8,16(sp)
  return i;
}
    800039e0:	854e                	mv	a0,s3
    800039e2:	60e6                	ld	ra,88(sp)
    800039e4:	6446                	ld	s0,80(sp)
    800039e6:	64a6                	ld	s1,72(sp)
    800039e8:	6906                	ld	s2,64(sp)
    800039ea:	79e2                	ld	s3,56(sp)
    800039ec:	7a42                	ld	s4,48(sp)
    800039ee:	7aa2                	ld	s5,40(sp)
    800039f0:	6125                	addi	sp,sp,96
    800039f2:	8082                	ret

00000000800039f4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800039f4:	1141                	addi	sp,sp,-16
    800039f6:	e406                	sd	ra,8(sp)
    800039f8:	e022                	sd	s0,0(sp)
    800039fa:	0800                	addi	s0,sp,16
    800039fc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800039fe:	0035151b          	slliw	a0,a0,0x3
    80003a02:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003a04:	8b89                	andi	a5,a5,2
    80003a06:	c399                	beqz	a5,80003a0c <flags2perm+0x18>
      perm |= PTE_W;
    80003a08:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a0c:	60a2                	ld	ra,8(sp)
    80003a0e:	6402                	ld	s0,0(sp)
    80003a10:	0141                	addi	sp,sp,16
    80003a12:	8082                	ret

0000000080003a14 <exec>:

int
exec(char *path, char **argv)
{
    80003a14:	de010113          	addi	sp,sp,-544
    80003a18:	20113c23          	sd	ra,536(sp)
    80003a1c:	20813823          	sd	s0,528(sp)
    80003a20:	20913423          	sd	s1,520(sp)
    80003a24:	21213023          	sd	s2,512(sp)
    80003a28:	1400                	addi	s0,sp,544
    80003a2a:	892a                	mv	s2,a0
    80003a2c:	dea43823          	sd	a0,-528(s0)
    80003a30:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a34:	b2cfd0ef          	jal	80000d60 <myproc>
    80003a38:	84aa                	mv	s1,a0

  begin_op();
    80003a3a:	d88ff0ef          	jal	80002fc2 <begin_op>

  if((ip = namei(path)) == 0){
    80003a3e:	854a                	mv	a0,s2
    80003a40:	bc0ff0ef          	jal	80002e00 <namei>
    80003a44:	cd21                	beqz	a0,80003a9c <exec+0x88>
    80003a46:	fbd2                	sd	s4,496(sp)
    80003a48:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a4a:	cc7fe0ef          	jal	80002710 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a4e:	04000713          	li	a4,64
    80003a52:	4681                	li	a3,0
    80003a54:	e5040613          	addi	a2,s0,-432
    80003a58:	4581                	li	a1,0
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	f0dfe0ef          	jal	80002968 <readi>
    80003a60:	04000793          	li	a5,64
    80003a64:	00f51a63          	bne	a0,a5,80003a78 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a68:	e5042703          	lw	a4,-432(s0)
    80003a6c:	464c47b7          	lui	a5,0x464c4
    80003a70:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a74:	02f70863          	beq	a4,a5,80003aa4 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a78:	8552                	mv	a0,s4
    80003a7a:	ea1fe0ef          	jal	8000291a <iunlockput>
    end_op();
    80003a7e:	daeff0ef          	jal	8000302c <end_op>
  }
  return -1;
    80003a82:	557d                	li	a0,-1
    80003a84:	7a5e                	ld	s4,496(sp)
}
    80003a86:	21813083          	ld	ra,536(sp)
    80003a8a:	21013403          	ld	s0,528(sp)
    80003a8e:	20813483          	ld	s1,520(sp)
    80003a92:	20013903          	ld	s2,512(sp)
    80003a96:	22010113          	addi	sp,sp,544
    80003a9a:	8082                	ret
    end_op();
    80003a9c:	d90ff0ef          	jal	8000302c <end_op>
    return -1;
    80003aa0:	557d                	li	a0,-1
    80003aa2:	b7d5                	j	80003a86 <exec+0x72>
    80003aa4:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	b60fd0ef          	jal	80000e08 <proc_pagetable>
    80003aac:	8b2a                	mv	s6,a0
    80003aae:	26050d63          	beqz	a0,80003d28 <exec+0x314>
    80003ab2:	ffce                	sd	s3,504(sp)
    80003ab4:	f7d6                	sd	s5,488(sp)
    80003ab6:	efde                	sd	s7,472(sp)
    80003ab8:	ebe2                	sd	s8,464(sp)
    80003aba:	e7e6                	sd	s9,456(sp)
    80003abc:	e3ea                	sd	s10,448(sp)
    80003abe:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ac0:	e7042683          	lw	a3,-400(s0)
    80003ac4:	e8845783          	lhu	a5,-376(s0)
    80003ac8:	0e078763          	beqz	a5,80003bb6 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003acc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ace:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ad0:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003ad4:	6c85                	lui	s9,0x1
    80003ad6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ada:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ade:	6a85                	lui	s5,0x1
    80003ae0:	a085                	j	80003b40 <exec+0x12c>
      panic("loadseg: address should exist");
    80003ae2:	00004517          	auipc	a0,0x4
    80003ae6:	abe50513          	addi	a0,a0,-1346 # 800075a0 <etext+0x5a0>
    80003aea:	20d010ef          	jal	800054f6 <panic>
    if(sz - i < PGSIZE)
    80003aee:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003af0:	874a                	mv	a4,s2
    80003af2:	009c06bb          	addw	a3,s8,s1
    80003af6:	4581                	li	a1,0
    80003af8:	8552                	mv	a0,s4
    80003afa:	e6ffe0ef          	jal	80002968 <readi>
    80003afe:	22a91963          	bne	s2,a0,80003d30 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b02:	009a84bb          	addw	s1,s5,s1
    80003b06:	0334f263          	bgeu	s1,s3,80003b2a <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003b0a:	02049593          	slli	a1,s1,0x20
    80003b0e:	9181                	srli	a1,a1,0x20
    80003b10:	95de                	add	a1,a1,s7
    80003b12:	855a                	mv	a0,s6
    80003b14:	969fc0ef          	jal	8000047c <walkaddr>
    80003b18:	862a                	mv	a2,a0
    if(pa == 0)
    80003b1a:	d561                	beqz	a0,80003ae2 <exec+0xce>
    if(sz - i < PGSIZE)
    80003b1c:	409987bb          	subw	a5,s3,s1
    80003b20:	893e                	mv	s2,a5
    80003b22:	fcfcf6e3          	bgeu	s9,a5,80003aee <exec+0xda>
    80003b26:	8956                	mv	s2,s5
    80003b28:	b7d9                	j	80003aee <exec+0xda>
    sz = sz1;
    80003b2a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2e:	2d05                	addiw	s10,s10,1
    80003b30:	e0843783          	ld	a5,-504(s0)
    80003b34:	0387869b          	addiw	a3,a5,56
    80003b38:	e8845783          	lhu	a5,-376(s0)
    80003b3c:	06fd5e63          	bge	s10,a5,80003bb8 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b40:	e0d43423          	sd	a3,-504(s0)
    80003b44:	876e                	mv	a4,s11
    80003b46:	e1840613          	addi	a2,s0,-488
    80003b4a:	4581                	li	a1,0
    80003b4c:	8552                	mv	a0,s4
    80003b4e:	e1bfe0ef          	jal	80002968 <readi>
    80003b52:	1db51d63          	bne	a0,s11,80003d2c <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003b56:	e1842783          	lw	a5,-488(s0)
    80003b5a:	4705                	li	a4,1
    80003b5c:	fce799e3          	bne	a5,a4,80003b2e <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003b60:	e4043483          	ld	s1,-448(s0)
    80003b64:	e3843783          	ld	a5,-456(s0)
    80003b68:	1ef4e263          	bltu	s1,a5,80003d4c <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b6c:	e2843783          	ld	a5,-472(s0)
    80003b70:	94be                	add	s1,s1,a5
    80003b72:	1ef4e063          	bltu	s1,a5,80003d52 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003b76:	de843703          	ld	a4,-536(s0)
    80003b7a:	8ff9                	and	a5,a5,a4
    80003b7c:	1c079e63          	bnez	a5,80003d58 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b80:	e1c42503          	lw	a0,-484(s0)
    80003b84:	e71ff0ef          	jal	800039f4 <flags2perm>
    80003b88:	86aa                	mv	a3,a0
    80003b8a:	8626                	mv	a2,s1
    80003b8c:	85ca                	mv	a1,s2
    80003b8e:	855a                	mv	a0,s6
    80003b90:	c55fc0ef          	jal	800007e4 <uvmalloc>
    80003b94:	dea43c23          	sd	a0,-520(s0)
    80003b98:	1c050363          	beqz	a0,80003d5e <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b9c:	e2843b83          	ld	s7,-472(s0)
    80003ba0:	e2042c03          	lw	s8,-480(s0)
    80003ba4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003ba8:	00098463          	beqz	s3,80003bb0 <exec+0x19c>
    80003bac:	4481                	li	s1,0
    80003bae:	bfb1                	j	80003b0a <exec+0xf6>
    sz = sz1;
    80003bb0:	df843903          	ld	s2,-520(s0)
    80003bb4:	bfad                	j	80003b2e <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bb6:	4901                	li	s2,0
  iunlockput(ip);
    80003bb8:	8552                	mv	a0,s4
    80003bba:	d61fe0ef          	jal	8000291a <iunlockput>
  end_op();
    80003bbe:	c6eff0ef          	jal	8000302c <end_op>
  p = myproc();
    80003bc2:	99efd0ef          	jal	80000d60 <myproc>
    80003bc6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bc8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003bcc:	6985                	lui	s3,0x1
    80003bce:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bd0:	99ca                	add	s3,s3,s2
    80003bd2:	77fd                	lui	a5,0xfffff
    80003bd4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bd8:	4691                	li	a3,4
    80003bda:	660d                	lui	a2,0x3
    80003bdc:	964e                	add	a2,a2,s3
    80003bde:	85ce                	mv	a1,s3
    80003be0:	855a                	mv	a0,s6
    80003be2:	c03fc0ef          	jal	800007e4 <uvmalloc>
    80003be6:	8a2a                	mv	s4,a0
    80003be8:	e105                	bnez	a0,80003c08 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003bea:	85ce                	mv	a1,s3
    80003bec:	855a                	mv	a0,s6
    80003bee:	a9efd0ef          	jal	80000e8c <proc_freepagetable>
  return -1;
    80003bf2:	557d                	li	a0,-1
    80003bf4:	79fe                	ld	s3,504(sp)
    80003bf6:	7a5e                	ld	s4,496(sp)
    80003bf8:	7abe                	ld	s5,488(sp)
    80003bfa:	7b1e                	ld	s6,480(sp)
    80003bfc:	6bfe                	ld	s7,472(sp)
    80003bfe:	6c5e                	ld	s8,464(sp)
    80003c00:	6cbe                	ld	s9,456(sp)
    80003c02:	6d1e                	ld	s10,448(sp)
    80003c04:	7dfa                	ld	s11,440(sp)
    80003c06:	b541                	j	80003a86 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c08:	75f5                	lui	a1,0xffffd
    80003c0a:	95aa                	add	a1,a1,a0
    80003c0c:	855a                	mv	a0,s6
    80003c0e:	dcdfc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c12:	7bf9                	lui	s7,0xffffe
    80003c14:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c16:	e0043783          	ld	a5,-512(s0)
    80003c1a:	6388                	ld	a0,0(a5)
  sp = sz;
    80003c1c:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c1e:	4481                	li	s1,0
    ustack[argc] = sp;
    80003c20:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003c24:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003c28:	cd21                	beqz	a0,80003c80 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003c2a:	eacfc0ef          	jal	800002d6 <strlen>
    80003c2e:	0015079b          	addiw	a5,a0,1
    80003c32:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c36:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c3a:	13796563          	bltu	s2,s7,80003d64 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c3e:	e0043d83          	ld	s11,-512(s0)
    80003c42:	000db983          	ld	s3,0(s11)
    80003c46:	854e                	mv	a0,s3
    80003c48:	e8efc0ef          	jal	800002d6 <strlen>
    80003c4c:	0015069b          	addiw	a3,a0,1
    80003c50:	864e                	mv	a2,s3
    80003c52:	85ca                	mv	a1,s2
    80003c54:	855a                	mv	a0,s6
    80003c56:	daffc0ef          	jal	80000a04 <copyout>
    80003c5a:	10054763          	bltz	a0,80003d68 <exec+0x354>
    ustack[argc] = sp;
    80003c5e:	00349793          	slli	a5,s1,0x3
    80003c62:	97e6                	add	a5,a5,s9
    80003c64:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb9c0>
  for(argc = 0; argv[argc]; argc++) {
    80003c68:	0485                	addi	s1,s1,1
    80003c6a:	008d8793          	addi	a5,s11,8
    80003c6e:	e0f43023          	sd	a5,-512(s0)
    80003c72:	008db503          	ld	a0,8(s11)
    80003c76:	c509                	beqz	a0,80003c80 <exec+0x26c>
    if(argc >= MAXARG)
    80003c78:	fb8499e3          	bne	s1,s8,80003c2a <exec+0x216>
  sz = sz1;
    80003c7c:	89d2                	mv	s3,s4
    80003c7e:	b7b5                	j	80003bea <exec+0x1d6>
  ustack[argc] = 0;
    80003c80:	00349793          	slli	a5,s1,0x3
    80003c84:	f9078793          	addi	a5,a5,-112
    80003c88:	97a2                	add	a5,a5,s0
    80003c8a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c8e:	00148693          	addi	a3,s1,1
    80003c92:	068e                	slli	a3,a3,0x3
    80003c94:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c98:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c9c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003c9e:	f57966e3          	bltu	s2,s7,80003bea <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003ca2:	e9040613          	addi	a2,s0,-368
    80003ca6:	85ca                	mv	a1,s2
    80003ca8:	855a                	mv	a0,s6
    80003caa:	d5bfc0ef          	jal	80000a04 <copyout>
    80003cae:	f2054ee3          	bltz	a0,80003bea <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003cb2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cb6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cba:	df043783          	ld	a5,-528(s0)
    80003cbe:	0007c703          	lbu	a4,0(a5)
    80003cc2:	cf11                	beqz	a4,80003cde <exec+0x2ca>
    80003cc4:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003cc6:	02f00693          	li	a3,47
    80003cca:	a029                	j	80003cd4 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003ccc:	0785                	addi	a5,a5,1
    80003cce:	fff7c703          	lbu	a4,-1(a5)
    80003cd2:	c711                	beqz	a4,80003cde <exec+0x2ca>
    if(*s == '/')
    80003cd4:	fed71ce3          	bne	a4,a3,80003ccc <exec+0x2b8>
      last = s+1;
    80003cd8:	def43823          	sd	a5,-528(s0)
    80003cdc:	bfc5                	j	80003ccc <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cde:	4641                	li	a2,16
    80003ce0:	df043583          	ld	a1,-528(s0)
    80003ce4:	158a8513          	addi	a0,s5,344
    80003ce8:	db8fc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003cec:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003cf0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003cf4:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cf8:	058ab783          	ld	a5,88(s5)
    80003cfc:	e6843703          	ld	a4,-408(s0)
    80003d00:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d02:	058ab783          	ld	a5,88(s5)
    80003d06:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d0a:	85ea                	mv	a1,s10
    80003d0c:	980fd0ef          	jal	80000e8c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d10:	0004851b          	sext.w	a0,s1
    80003d14:	79fe                	ld	s3,504(sp)
    80003d16:	7a5e                	ld	s4,496(sp)
    80003d18:	7abe                	ld	s5,488(sp)
    80003d1a:	7b1e                	ld	s6,480(sp)
    80003d1c:	6bfe                	ld	s7,472(sp)
    80003d1e:	6c5e                	ld	s8,464(sp)
    80003d20:	6cbe                	ld	s9,456(sp)
    80003d22:	6d1e                	ld	s10,448(sp)
    80003d24:	7dfa                	ld	s11,440(sp)
    80003d26:	b385                	j	80003a86 <exec+0x72>
    80003d28:	7b1e                	ld	s6,480(sp)
    80003d2a:	b3b9                	j	80003a78 <exec+0x64>
    80003d2c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d30:	df843583          	ld	a1,-520(s0)
    80003d34:	855a                	mv	a0,s6
    80003d36:	956fd0ef          	jal	80000e8c <proc_freepagetable>
  if(ip){
    80003d3a:	79fe                	ld	s3,504(sp)
    80003d3c:	7abe                	ld	s5,488(sp)
    80003d3e:	7b1e                	ld	s6,480(sp)
    80003d40:	6bfe                	ld	s7,472(sp)
    80003d42:	6c5e                	ld	s8,464(sp)
    80003d44:	6cbe                	ld	s9,456(sp)
    80003d46:	6d1e                	ld	s10,448(sp)
    80003d48:	7dfa                	ld	s11,440(sp)
    80003d4a:	b33d                	j	80003a78 <exec+0x64>
    80003d4c:	df243c23          	sd	s2,-520(s0)
    80003d50:	b7c5                	j	80003d30 <exec+0x31c>
    80003d52:	df243c23          	sd	s2,-520(s0)
    80003d56:	bfe9                	j	80003d30 <exec+0x31c>
    80003d58:	df243c23          	sd	s2,-520(s0)
    80003d5c:	bfd1                	j	80003d30 <exec+0x31c>
    80003d5e:	df243c23          	sd	s2,-520(s0)
    80003d62:	b7f9                	j	80003d30 <exec+0x31c>
  sz = sz1;
    80003d64:	89d2                	mv	s3,s4
    80003d66:	b551                	j	80003bea <exec+0x1d6>
    80003d68:	89d2                	mv	s3,s4
    80003d6a:	b541                	j	80003bea <exec+0x1d6>

0000000080003d6c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d6c:	7179                	addi	sp,sp,-48
    80003d6e:	f406                	sd	ra,40(sp)
    80003d70:	f022                	sd	s0,32(sp)
    80003d72:	ec26                	sd	s1,24(sp)
    80003d74:	e84a                	sd	s2,16(sp)
    80003d76:	1800                	addi	s0,sp,48
    80003d78:	892e                	mv	s2,a1
    80003d7a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d7c:	fdc40593          	addi	a1,s0,-36
    80003d80:	e9ffd0ef          	jal	80001c1e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d84:	fdc42703          	lw	a4,-36(s0)
    80003d88:	47bd                	li	a5,15
    80003d8a:	02e7e963          	bltu	a5,a4,80003dbc <argfd+0x50>
    80003d8e:	fd3fc0ef          	jal	80000d60 <myproc>
    80003d92:	fdc42703          	lw	a4,-36(s0)
    80003d96:	01a70793          	addi	a5,a4,26
    80003d9a:	078e                	slli	a5,a5,0x3
    80003d9c:	953e                	add	a0,a0,a5
    80003d9e:	611c                	ld	a5,0(a0)
    80003da0:	c385                	beqz	a5,80003dc0 <argfd+0x54>
    return -1;
  if(pfd)
    80003da2:	00090463          	beqz	s2,80003daa <argfd+0x3e>
    *pfd = fd;
    80003da6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003daa:	4501                	li	a0,0
  if(pf)
    80003dac:	c091                	beqz	s1,80003db0 <argfd+0x44>
    *pf = f;
    80003dae:	e09c                	sd	a5,0(s1)
}
    80003db0:	70a2                	ld	ra,40(sp)
    80003db2:	7402                	ld	s0,32(sp)
    80003db4:	64e2                	ld	s1,24(sp)
    80003db6:	6942                	ld	s2,16(sp)
    80003db8:	6145                	addi	sp,sp,48
    80003dba:	8082                	ret
    return -1;
    80003dbc:	557d                	li	a0,-1
    80003dbe:	bfcd                	j	80003db0 <argfd+0x44>
    80003dc0:	557d                	li	a0,-1
    80003dc2:	b7fd                	j	80003db0 <argfd+0x44>

0000000080003dc4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003dc4:	1101                	addi	sp,sp,-32
    80003dc6:	ec06                	sd	ra,24(sp)
    80003dc8:	e822                	sd	s0,16(sp)
    80003dca:	e426                	sd	s1,8(sp)
    80003dcc:	1000                	addi	s0,sp,32
    80003dce:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003dd0:	f91fc0ef          	jal	80000d60 <myproc>
    80003dd4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003dd6:	0d050793          	addi	a5,a0,208
    80003dda:	4501                	li	a0,0
    80003ddc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003dde:	6398                	ld	a4,0(a5)
    80003de0:	cb19                	beqz	a4,80003df6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003de2:	2505                	addiw	a0,a0,1
    80003de4:	07a1                	addi	a5,a5,8
    80003de6:	fed51ce3          	bne	a0,a3,80003dde <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003dea:	557d                	li	a0,-1
}
    80003dec:	60e2                	ld	ra,24(sp)
    80003dee:	6442                	ld	s0,16(sp)
    80003df0:	64a2                	ld	s1,8(sp)
    80003df2:	6105                	addi	sp,sp,32
    80003df4:	8082                	ret
      p->ofile[fd] = f;
    80003df6:	01a50793          	addi	a5,a0,26
    80003dfa:	078e                	slli	a5,a5,0x3
    80003dfc:	963e                	add	a2,a2,a5
    80003dfe:	e204                	sd	s1,0(a2)
      return fd;
    80003e00:	b7f5                	j	80003dec <fdalloc+0x28>

0000000080003e02 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e02:	715d                	addi	sp,sp,-80
    80003e04:	e486                	sd	ra,72(sp)
    80003e06:	e0a2                	sd	s0,64(sp)
    80003e08:	fc26                	sd	s1,56(sp)
    80003e0a:	f84a                	sd	s2,48(sp)
    80003e0c:	f44e                	sd	s3,40(sp)
    80003e0e:	ec56                	sd	s5,24(sp)
    80003e10:	e85a                	sd	s6,16(sp)
    80003e12:	0880                	addi	s0,sp,80
    80003e14:	8b2e                	mv	s6,a1
    80003e16:	89b2                	mv	s3,a2
    80003e18:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e1a:	fb040593          	addi	a1,s0,-80
    80003e1e:	ffdfe0ef          	jal	80002e1a <nameiparent>
    80003e22:	84aa                	mv	s1,a0
    80003e24:	10050a63          	beqz	a0,80003f38 <create+0x136>
    return 0;

  ilock(dp);
    80003e28:	8e9fe0ef          	jal	80002710 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e2c:	4601                	li	a2,0
    80003e2e:	fb040593          	addi	a1,s0,-80
    80003e32:	8526                	mv	a0,s1
    80003e34:	d41fe0ef          	jal	80002b74 <dirlookup>
    80003e38:	8aaa                	mv	s5,a0
    80003e3a:	c129                	beqz	a0,80003e7c <create+0x7a>
    iunlockput(dp);
    80003e3c:	8526                	mv	a0,s1
    80003e3e:	addfe0ef          	jal	8000291a <iunlockput>
    ilock(ip);
    80003e42:	8556                	mv	a0,s5
    80003e44:	8cdfe0ef          	jal	80002710 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e48:	4789                	li	a5,2
    80003e4a:	02fb1463          	bne	s6,a5,80003e72 <create+0x70>
    80003e4e:	044ad783          	lhu	a5,68(s5)
    80003e52:	37f9                	addiw	a5,a5,-2
    80003e54:	17c2                	slli	a5,a5,0x30
    80003e56:	93c1                	srli	a5,a5,0x30
    80003e58:	4705                	li	a4,1
    80003e5a:	00f76c63          	bltu	a4,a5,80003e72 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e5e:	8556                	mv	a0,s5
    80003e60:	60a6                	ld	ra,72(sp)
    80003e62:	6406                	ld	s0,64(sp)
    80003e64:	74e2                	ld	s1,56(sp)
    80003e66:	7942                	ld	s2,48(sp)
    80003e68:	79a2                	ld	s3,40(sp)
    80003e6a:	6ae2                	ld	s5,24(sp)
    80003e6c:	6b42                	ld	s6,16(sp)
    80003e6e:	6161                	addi	sp,sp,80
    80003e70:	8082                	ret
    iunlockput(ip);
    80003e72:	8556                	mv	a0,s5
    80003e74:	aa7fe0ef          	jal	8000291a <iunlockput>
    return 0;
    80003e78:	4a81                	li	s5,0
    80003e7a:	b7d5                	j	80003e5e <create+0x5c>
    80003e7c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e7e:	85da                	mv	a1,s6
    80003e80:	4088                	lw	a0,0(s1)
    80003e82:	f1efe0ef          	jal	800025a0 <ialloc>
    80003e86:	8a2a                	mv	s4,a0
    80003e88:	cd15                	beqz	a0,80003ec4 <create+0xc2>
  ilock(ip);
    80003e8a:	887fe0ef          	jal	80002710 <ilock>
  ip->major = major;
    80003e8e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e92:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e96:	4905                	li	s2,1
    80003e98:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e9c:	8552                	mv	a0,s4
    80003e9e:	fbefe0ef          	jal	8000265c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ea2:	032b0763          	beq	s6,s2,80003ed0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ea6:	004a2603          	lw	a2,4(s4)
    80003eaa:	fb040593          	addi	a1,s0,-80
    80003eae:	8526                	mv	a0,s1
    80003eb0:	ea7fe0ef          	jal	80002d56 <dirlink>
    80003eb4:	06054563          	bltz	a0,80003f1e <create+0x11c>
  iunlockput(dp);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	a61fe0ef          	jal	8000291a <iunlockput>
  return ip;
    80003ebe:	8ad2                	mv	s5,s4
    80003ec0:	7a02                	ld	s4,32(sp)
    80003ec2:	bf71                	j	80003e5e <create+0x5c>
    iunlockput(dp);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	a55fe0ef          	jal	8000291a <iunlockput>
    return 0;
    80003eca:	8ad2                	mv	s5,s4
    80003ecc:	7a02                	ld	s4,32(sp)
    80003ece:	bf41                	j	80003e5e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003ed0:	004a2603          	lw	a2,4(s4)
    80003ed4:	00003597          	auipc	a1,0x3
    80003ed8:	6ec58593          	addi	a1,a1,1772 # 800075c0 <etext+0x5c0>
    80003edc:	8552                	mv	a0,s4
    80003ede:	e79fe0ef          	jal	80002d56 <dirlink>
    80003ee2:	02054e63          	bltz	a0,80003f1e <create+0x11c>
    80003ee6:	40d0                	lw	a2,4(s1)
    80003ee8:	00003597          	auipc	a1,0x3
    80003eec:	6e058593          	addi	a1,a1,1760 # 800075c8 <etext+0x5c8>
    80003ef0:	8552                	mv	a0,s4
    80003ef2:	e65fe0ef          	jal	80002d56 <dirlink>
    80003ef6:	02054463          	bltz	a0,80003f1e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003efa:	004a2603          	lw	a2,4(s4)
    80003efe:	fb040593          	addi	a1,s0,-80
    80003f02:	8526                	mv	a0,s1
    80003f04:	e53fe0ef          	jal	80002d56 <dirlink>
    80003f08:	00054b63          	bltz	a0,80003f1e <create+0x11c>
    dp->nlink++;  // for ".."
    80003f0c:	04a4d783          	lhu	a5,74(s1)
    80003f10:	2785                	addiw	a5,a5,1
    80003f12:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f16:	8526                	mv	a0,s1
    80003f18:	f44fe0ef          	jal	8000265c <iupdate>
    80003f1c:	bf71                	j	80003eb8 <create+0xb6>
  ip->nlink = 0;
    80003f1e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f22:	8552                	mv	a0,s4
    80003f24:	f38fe0ef          	jal	8000265c <iupdate>
  iunlockput(ip);
    80003f28:	8552                	mv	a0,s4
    80003f2a:	9f1fe0ef          	jal	8000291a <iunlockput>
  iunlockput(dp);
    80003f2e:	8526                	mv	a0,s1
    80003f30:	9ebfe0ef          	jal	8000291a <iunlockput>
  return 0;
    80003f34:	7a02                	ld	s4,32(sp)
    80003f36:	b725                	j	80003e5e <create+0x5c>
    return 0;
    80003f38:	8aaa                	mv	s5,a0
    80003f3a:	b715                	j	80003e5e <create+0x5c>

0000000080003f3c <sys_dup>:
{
    80003f3c:	7179                	addi	sp,sp,-48
    80003f3e:	f406                	sd	ra,40(sp)
    80003f40:	f022                	sd	s0,32(sp)
    80003f42:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f44:	fd840613          	addi	a2,s0,-40
    80003f48:	4581                	li	a1,0
    80003f4a:	4501                	li	a0,0
    80003f4c:	e21ff0ef          	jal	80003d6c <argfd>
    return -1;
    80003f50:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f52:	02054363          	bltz	a0,80003f78 <sys_dup+0x3c>
    80003f56:	ec26                	sd	s1,24(sp)
    80003f58:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f5a:	fd843903          	ld	s2,-40(s0)
    80003f5e:	854a                	mv	a0,s2
    80003f60:	e65ff0ef          	jal	80003dc4 <fdalloc>
    80003f64:	84aa                	mv	s1,a0
    return -1;
    80003f66:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f68:	00054d63          	bltz	a0,80003f82 <sys_dup+0x46>
  filedup(f);
    80003f6c:	854a                	mv	a0,s2
    80003f6e:	c2eff0ef          	jal	8000339c <filedup>
  return fd;
    80003f72:	87a6                	mv	a5,s1
    80003f74:	64e2                	ld	s1,24(sp)
    80003f76:	6942                	ld	s2,16(sp)
}
    80003f78:	853e                	mv	a0,a5
    80003f7a:	70a2                	ld	ra,40(sp)
    80003f7c:	7402                	ld	s0,32(sp)
    80003f7e:	6145                	addi	sp,sp,48
    80003f80:	8082                	ret
    80003f82:	64e2                	ld	s1,24(sp)
    80003f84:	6942                	ld	s2,16(sp)
    80003f86:	bfcd                	j	80003f78 <sys_dup+0x3c>

0000000080003f88 <sys_read>:
{
    80003f88:	7179                	addi	sp,sp,-48
    80003f8a:	f406                	sd	ra,40(sp)
    80003f8c:	f022                	sd	s0,32(sp)
    80003f8e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f90:	fd840593          	addi	a1,s0,-40
    80003f94:	4505                	li	a0,1
    80003f96:	ca5fd0ef          	jal	80001c3a <argaddr>
  argint(2, &n);
    80003f9a:	fe440593          	addi	a1,s0,-28
    80003f9e:	4509                	li	a0,2
    80003fa0:	c7ffd0ef          	jal	80001c1e <argint>
  if(argfd(0, 0, &f) < 0)
    80003fa4:	fe840613          	addi	a2,s0,-24
    80003fa8:	4581                	li	a1,0
    80003faa:	4501                	li	a0,0
    80003fac:	dc1ff0ef          	jal	80003d6c <argfd>
    80003fb0:	87aa                	mv	a5,a0
    return -1;
    80003fb2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fb4:	0007ca63          	bltz	a5,80003fc8 <sys_read+0x40>
  return fileread(f, p, n);
    80003fb8:	fe442603          	lw	a2,-28(s0)
    80003fbc:	fd843583          	ld	a1,-40(s0)
    80003fc0:	fe843503          	ld	a0,-24(s0)
    80003fc4:	d3eff0ef          	jal	80003502 <fileread>
}
    80003fc8:	70a2                	ld	ra,40(sp)
    80003fca:	7402                	ld	s0,32(sp)
    80003fcc:	6145                	addi	sp,sp,48
    80003fce:	8082                	ret

0000000080003fd0 <sys_write>:
{
    80003fd0:	7179                	addi	sp,sp,-48
    80003fd2:	f406                	sd	ra,40(sp)
    80003fd4:	f022                	sd	s0,32(sp)
    80003fd6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fd8:	fd840593          	addi	a1,s0,-40
    80003fdc:	4505                	li	a0,1
    80003fde:	c5dfd0ef          	jal	80001c3a <argaddr>
  argint(2, &n);
    80003fe2:	fe440593          	addi	a1,s0,-28
    80003fe6:	4509                	li	a0,2
    80003fe8:	c37fd0ef          	jal	80001c1e <argint>
  if(argfd(0, 0, &f) < 0)
    80003fec:	fe840613          	addi	a2,s0,-24
    80003ff0:	4581                	li	a1,0
    80003ff2:	4501                	li	a0,0
    80003ff4:	d79ff0ef          	jal	80003d6c <argfd>
    80003ff8:	87aa                	mv	a5,a0
    return -1;
    80003ffa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ffc:	0007ca63          	bltz	a5,80004010 <sys_write+0x40>
  return filewrite(f, p, n);
    80004000:	fe442603          	lw	a2,-28(s0)
    80004004:	fd843583          	ld	a1,-40(s0)
    80004008:	fe843503          	ld	a0,-24(s0)
    8000400c:	db4ff0ef          	jal	800035c0 <filewrite>
}
    80004010:	70a2                	ld	ra,40(sp)
    80004012:	7402                	ld	s0,32(sp)
    80004014:	6145                	addi	sp,sp,48
    80004016:	8082                	ret

0000000080004018 <sys_close>:
{
    80004018:	1101                	addi	sp,sp,-32
    8000401a:	ec06                	sd	ra,24(sp)
    8000401c:	e822                	sd	s0,16(sp)
    8000401e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004020:	fe040613          	addi	a2,s0,-32
    80004024:	fec40593          	addi	a1,s0,-20
    80004028:	4501                	li	a0,0
    8000402a:	d43ff0ef          	jal	80003d6c <argfd>
    return -1;
    8000402e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004030:	02054063          	bltz	a0,80004050 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004034:	d2dfc0ef          	jal	80000d60 <myproc>
    80004038:	fec42783          	lw	a5,-20(s0)
    8000403c:	07e9                	addi	a5,a5,26
    8000403e:	078e                	slli	a5,a5,0x3
    80004040:	953e                	add	a0,a0,a5
    80004042:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004046:	fe043503          	ld	a0,-32(s0)
    8000404a:	b98ff0ef          	jal	800033e2 <fileclose>
  return 0;
    8000404e:	4781                	li	a5,0
}
    80004050:	853e                	mv	a0,a5
    80004052:	60e2                	ld	ra,24(sp)
    80004054:	6442                	ld	s0,16(sp)
    80004056:	6105                	addi	sp,sp,32
    80004058:	8082                	ret

000000008000405a <sys_fstat>:
{
    8000405a:	1101                	addi	sp,sp,-32
    8000405c:	ec06                	sd	ra,24(sp)
    8000405e:	e822                	sd	s0,16(sp)
    80004060:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004062:	fe040593          	addi	a1,s0,-32
    80004066:	4505                	li	a0,1
    80004068:	bd3fd0ef          	jal	80001c3a <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000406c:	fe840613          	addi	a2,s0,-24
    80004070:	4581                	li	a1,0
    80004072:	4501                	li	a0,0
    80004074:	cf9ff0ef          	jal	80003d6c <argfd>
    80004078:	87aa                	mv	a5,a0
    return -1;
    8000407a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000407c:	0007c863          	bltz	a5,8000408c <sys_fstat+0x32>
  return filestat(f, st);
    80004080:	fe043583          	ld	a1,-32(s0)
    80004084:	fe843503          	ld	a0,-24(s0)
    80004088:	c18ff0ef          	jal	800034a0 <filestat>
}
    8000408c:	60e2                	ld	ra,24(sp)
    8000408e:	6442                	ld	s0,16(sp)
    80004090:	6105                	addi	sp,sp,32
    80004092:	8082                	ret

0000000080004094 <sys_link>:
{
    80004094:	7169                	addi	sp,sp,-304
    80004096:	f606                	sd	ra,296(sp)
    80004098:	f222                	sd	s0,288(sp)
    8000409a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000409c:	08000613          	li	a2,128
    800040a0:	ed040593          	addi	a1,s0,-304
    800040a4:	4501                	li	a0,0
    800040a6:	bb1fd0ef          	jal	80001c56 <argstr>
    return -1;
    800040aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ac:	0c054e63          	bltz	a0,80004188 <sys_link+0xf4>
    800040b0:	08000613          	li	a2,128
    800040b4:	f5040593          	addi	a1,s0,-176
    800040b8:	4505                	li	a0,1
    800040ba:	b9dfd0ef          	jal	80001c56 <argstr>
    return -1;
    800040be:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040c0:	0c054463          	bltz	a0,80004188 <sys_link+0xf4>
    800040c4:	ee26                	sd	s1,280(sp)
  begin_op();
    800040c6:	efdfe0ef          	jal	80002fc2 <begin_op>
  if((ip = namei(old)) == 0){
    800040ca:	ed040513          	addi	a0,s0,-304
    800040ce:	d33fe0ef          	jal	80002e00 <namei>
    800040d2:	84aa                	mv	s1,a0
    800040d4:	c53d                	beqz	a0,80004142 <sys_link+0xae>
  ilock(ip);
    800040d6:	e3afe0ef          	jal	80002710 <ilock>
  if(ip->type == T_DIR){
    800040da:	04449703          	lh	a4,68(s1)
    800040de:	4785                	li	a5,1
    800040e0:	06f70663          	beq	a4,a5,8000414c <sys_link+0xb8>
    800040e4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800040e6:	04a4d783          	lhu	a5,74(s1)
    800040ea:	2785                	addiw	a5,a5,1
    800040ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040f0:	8526                	mv	a0,s1
    800040f2:	d6afe0ef          	jal	8000265c <iupdate>
  iunlock(ip);
    800040f6:	8526                	mv	a0,s1
    800040f8:	ec6fe0ef          	jal	800027be <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800040fc:	fd040593          	addi	a1,s0,-48
    80004100:	f5040513          	addi	a0,s0,-176
    80004104:	d17fe0ef          	jal	80002e1a <nameiparent>
    80004108:	892a                	mv	s2,a0
    8000410a:	cd21                	beqz	a0,80004162 <sys_link+0xce>
  ilock(dp);
    8000410c:	e04fe0ef          	jal	80002710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004110:	00092703          	lw	a4,0(s2)
    80004114:	409c                	lw	a5,0(s1)
    80004116:	04f71363          	bne	a4,a5,8000415c <sys_link+0xc8>
    8000411a:	40d0                	lw	a2,4(s1)
    8000411c:	fd040593          	addi	a1,s0,-48
    80004120:	854a                	mv	a0,s2
    80004122:	c35fe0ef          	jal	80002d56 <dirlink>
    80004126:	02054b63          	bltz	a0,8000415c <sys_link+0xc8>
  iunlockput(dp);
    8000412a:	854a                	mv	a0,s2
    8000412c:	feefe0ef          	jal	8000291a <iunlockput>
  iput(ip);
    80004130:	8526                	mv	a0,s1
    80004132:	f60fe0ef          	jal	80002892 <iput>
  end_op();
    80004136:	ef7fe0ef          	jal	8000302c <end_op>
  return 0;
    8000413a:	4781                	li	a5,0
    8000413c:	64f2                	ld	s1,280(sp)
    8000413e:	6952                	ld	s2,272(sp)
    80004140:	a0a1                	j	80004188 <sys_link+0xf4>
    end_op();
    80004142:	eebfe0ef          	jal	8000302c <end_op>
    return -1;
    80004146:	57fd                	li	a5,-1
    80004148:	64f2                	ld	s1,280(sp)
    8000414a:	a83d                	j	80004188 <sys_link+0xf4>
    iunlockput(ip);
    8000414c:	8526                	mv	a0,s1
    8000414e:	fccfe0ef          	jal	8000291a <iunlockput>
    end_op();
    80004152:	edbfe0ef          	jal	8000302c <end_op>
    return -1;
    80004156:	57fd                	li	a5,-1
    80004158:	64f2                	ld	s1,280(sp)
    8000415a:	a03d                	j	80004188 <sys_link+0xf4>
    iunlockput(dp);
    8000415c:	854a                	mv	a0,s2
    8000415e:	fbcfe0ef          	jal	8000291a <iunlockput>
  ilock(ip);
    80004162:	8526                	mv	a0,s1
    80004164:	dacfe0ef          	jal	80002710 <ilock>
  ip->nlink--;
    80004168:	04a4d783          	lhu	a5,74(s1)
    8000416c:	37fd                	addiw	a5,a5,-1
    8000416e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004172:	8526                	mv	a0,s1
    80004174:	ce8fe0ef          	jal	8000265c <iupdate>
  iunlockput(ip);
    80004178:	8526                	mv	a0,s1
    8000417a:	fa0fe0ef          	jal	8000291a <iunlockput>
  end_op();
    8000417e:	eaffe0ef          	jal	8000302c <end_op>
  return -1;
    80004182:	57fd                	li	a5,-1
    80004184:	64f2                	ld	s1,280(sp)
    80004186:	6952                	ld	s2,272(sp)
}
    80004188:	853e                	mv	a0,a5
    8000418a:	70b2                	ld	ra,296(sp)
    8000418c:	7412                	ld	s0,288(sp)
    8000418e:	6155                	addi	sp,sp,304
    80004190:	8082                	ret

0000000080004192 <sys_unlink>:
{
    80004192:	7111                	addi	sp,sp,-256
    80004194:	fd86                	sd	ra,248(sp)
    80004196:	f9a2                	sd	s0,240(sp)
    80004198:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000419a:	08000613          	li	a2,128
    8000419e:	f2040593          	addi	a1,s0,-224
    800041a2:	4501                	li	a0,0
    800041a4:	ab3fd0ef          	jal	80001c56 <argstr>
    800041a8:	16054663          	bltz	a0,80004314 <sys_unlink+0x182>
    800041ac:	f5a6                	sd	s1,232(sp)
  begin_op();
    800041ae:	e15fe0ef          	jal	80002fc2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041b2:	fa040593          	addi	a1,s0,-96
    800041b6:	f2040513          	addi	a0,s0,-224
    800041ba:	c61fe0ef          	jal	80002e1a <nameiparent>
    800041be:	84aa                	mv	s1,a0
    800041c0:	c955                	beqz	a0,80004274 <sys_unlink+0xe2>
  ilock(dp);
    800041c2:	d4efe0ef          	jal	80002710 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041c6:	00003597          	auipc	a1,0x3
    800041ca:	3fa58593          	addi	a1,a1,1018 # 800075c0 <etext+0x5c0>
    800041ce:	fa040513          	addi	a0,s0,-96
    800041d2:	98dfe0ef          	jal	80002b5e <namecmp>
    800041d6:	12050463          	beqz	a0,800042fe <sys_unlink+0x16c>
    800041da:	00003597          	auipc	a1,0x3
    800041de:	3ee58593          	addi	a1,a1,1006 # 800075c8 <etext+0x5c8>
    800041e2:	fa040513          	addi	a0,s0,-96
    800041e6:	979fe0ef          	jal	80002b5e <namecmp>
    800041ea:	10050a63          	beqz	a0,800042fe <sys_unlink+0x16c>
    800041ee:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800041f0:	f1c40613          	addi	a2,s0,-228
    800041f4:	fa040593          	addi	a1,s0,-96
    800041f8:	8526                	mv	a0,s1
    800041fa:	97bfe0ef          	jal	80002b74 <dirlookup>
    800041fe:	892a                	mv	s2,a0
    80004200:	0e050e63          	beqz	a0,800042fc <sys_unlink+0x16a>
    80004204:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004206:	d0afe0ef          	jal	80002710 <ilock>
  if(ip->nlink < 1)
    8000420a:	04a91783          	lh	a5,74(s2)
    8000420e:	06f05863          	blez	a5,8000427e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004212:	04491703          	lh	a4,68(s2)
    80004216:	4785                	li	a5,1
    80004218:	06f70b63          	beq	a4,a5,8000428e <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000421c:	fb040993          	addi	s3,s0,-80
    80004220:	4641                	li	a2,16
    80004222:	4581                	li	a1,0
    80004224:	854e                	mv	a0,s3
    80004226:	f29fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000422a:	4741                	li	a4,16
    8000422c:	f1c42683          	lw	a3,-228(s0)
    80004230:	864e                	mv	a2,s3
    80004232:	4581                	li	a1,0
    80004234:	8526                	mv	a0,s1
    80004236:	825fe0ef          	jal	80002a5a <writei>
    8000423a:	47c1                	li	a5,16
    8000423c:	08f51f63          	bne	a0,a5,800042da <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004240:	04491703          	lh	a4,68(s2)
    80004244:	4785                	li	a5,1
    80004246:	0af70263          	beq	a4,a5,800042ea <sys_unlink+0x158>
  iunlockput(dp);
    8000424a:	8526                	mv	a0,s1
    8000424c:	ecefe0ef          	jal	8000291a <iunlockput>
  ip->nlink--;
    80004250:	04a95783          	lhu	a5,74(s2)
    80004254:	37fd                	addiw	a5,a5,-1
    80004256:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000425a:	854a                	mv	a0,s2
    8000425c:	c00fe0ef          	jal	8000265c <iupdate>
  iunlockput(ip);
    80004260:	854a                	mv	a0,s2
    80004262:	eb8fe0ef          	jal	8000291a <iunlockput>
  end_op();
    80004266:	dc7fe0ef          	jal	8000302c <end_op>
  return 0;
    8000426a:	4501                	li	a0,0
    8000426c:	74ae                	ld	s1,232(sp)
    8000426e:	790e                	ld	s2,224(sp)
    80004270:	69ee                	ld	s3,216(sp)
    80004272:	a869                	j	8000430c <sys_unlink+0x17a>
    end_op();
    80004274:	db9fe0ef          	jal	8000302c <end_op>
    return -1;
    80004278:	557d                	li	a0,-1
    8000427a:	74ae                	ld	s1,232(sp)
    8000427c:	a841                	j	8000430c <sys_unlink+0x17a>
    8000427e:	e9d2                	sd	s4,208(sp)
    80004280:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004282:	00003517          	auipc	a0,0x3
    80004286:	34e50513          	addi	a0,a0,846 # 800075d0 <etext+0x5d0>
    8000428a:	26c010ef          	jal	800054f6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000428e:	04c92703          	lw	a4,76(s2)
    80004292:	02000793          	li	a5,32
    80004296:	f8e7f3e3          	bgeu	a5,a4,8000421c <sys_unlink+0x8a>
    8000429a:	e9d2                	sd	s4,208(sp)
    8000429c:	e5d6                	sd	s5,200(sp)
    8000429e:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042a0:	f0840a93          	addi	s5,s0,-248
    800042a4:	4a41                	li	s4,16
    800042a6:	8752                	mv	a4,s4
    800042a8:	86ce                	mv	a3,s3
    800042aa:	8656                	mv	a2,s5
    800042ac:	4581                	li	a1,0
    800042ae:	854a                	mv	a0,s2
    800042b0:	eb8fe0ef          	jal	80002968 <readi>
    800042b4:	01451d63          	bne	a0,s4,800042ce <sys_unlink+0x13c>
    if(de.inum != 0)
    800042b8:	f0845783          	lhu	a5,-248(s0)
    800042bc:	efb1                	bnez	a5,80004318 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042be:	29c1                	addiw	s3,s3,16
    800042c0:	04c92783          	lw	a5,76(s2)
    800042c4:	fef9e1e3          	bltu	s3,a5,800042a6 <sys_unlink+0x114>
    800042c8:	6a4e                	ld	s4,208(sp)
    800042ca:	6aae                	ld	s5,200(sp)
    800042cc:	bf81                	j	8000421c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800042ce:	00003517          	auipc	a0,0x3
    800042d2:	31a50513          	addi	a0,a0,794 # 800075e8 <etext+0x5e8>
    800042d6:	220010ef          	jal	800054f6 <panic>
    800042da:	e9d2                	sd	s4,208(sp)
    800042dc:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800042de:	00003517          	auipc	a0,0x3
    800042e2:	32250513          	addi	a0,a0,802 # 80007600 <etext+0x600>
    800042e6:	210010ef          	jal	800054f6 <panic>
    dp->nlink--;
    800042ea:	04a4d783          	lhu	a5,74(s1)
    800042ee:	37fd                	addiw	a5,a5,-1
    800042f0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800042f4:	8526                	mv	a0,s1
    800042f6:	b66fe0ef          	jal	8000265c <iupdate>
    800042fa:	bf81                	j	8000424a <sys_unlink+0xb8>
    800042fc:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800042fe:	8526                	mv	a0,s1
    80004300:	e1afe0ef          	jal	8000291a <iunlockput>
  end_op();
    80004304:	d29fe0ef          	jal	8000302c <end_op>
  return -1;
    80004308:	557d                	li	a0,-1
    8000430a:	74ae                	ld	s1,232(sp)
}
    8000430c:	70ee                	ld	ra,248(sp)
    8000430e:	744e                	ld	s0,240(sp)
    80004310:	6111                	addi	sp,sp,256
    80004312:	8082                	ret
    return -1;
    80004314:	557d                	li	a0,-1
    80004316:	bfdd                	j	8000430c <sys_unlink+0x17a>
    iunlockput(ip);
    80004318:	854a                	mv	a0,s2
    8000431a:	e00fe0ef          	jal	8000291a <iunlockput>
    goto bad;
    8000431e:	790e                	ld	s2,224(sp)
    80004320:	69ee                	ld	s3,216(sp)
    80004322:	6a4e                	ld	s4,208(sp)
    80004324:	6aae                	ld	s5,200(sp)
    80004326:	bfe1                	j	800042fe <sys_unlink+0x16c>

0000000080004328 <sys_open>:

uint64
sys_open(void)
{
    80004328:	7131                	addi	sp,sp,-192
    8000432a:	fd06                	sd	ra,184(sp)
    8000432c:	f922                	sd	s0,176(sp)
    8000432e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004330:	f4c40593          	addi	a1,s0,-180
    80004334:	4505                	li	a0,1
    80004336:	8e9fd0ef          	jal	80001c1e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000433a:	08000613          	li	a2,128
    8000433e:	f5040593          	addi	a1,s0,-176
    80004342:	4501                	li	a0,0
    80004344:	913fd0ef          	jal	80001c56 <argstr>
    80004348:	87aa                	mv	a5,a0
    return -1;
    8000434a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000434c:	0a07c363          	bltz	a5,800043f2 <sys_open+0xca>
    80004350:	f526                	sd	s1,168(sp)

  begin_op();
    80004352:	c71fe0ef          	jal	80002fc2 <begin_op>

  if(omode & O_CREATE){
    80004356:	f4c42783          	lw	a5,-180(s0)
    8000435a:	2007f793          	andi	a5,a5,512
    8000435e:	c3dd                	beqz	a5,80004404 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004360:	4681                	li	a3,0
    80004362:	4601                	li	a2,0
    80004364:	4589                	li	a1,2
    80004366:	f5040513          	addi	a0,s0,-176
    8000436a:	a99ff0ef          	jal	80003e02 <create>
    8000436e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004370:	c549                	beqz	a0,800043fa <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004372:	04449703          	lh	a4,68(s1)
    80004376:	478d                	li	a5,3
    80004378:	00f71763          	bne	a4,a5,80004386 <sys_open+0x5e>
    8000437c:	0464d703          	lhu	a4,70(s1)
    80004380:	47a5                	li	a5,9
    80004382:	0ae7ee63          	bltu	a5,a4,8000443e <sys_open+0x116>
    80004386:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004388:	fb7fe0ef          	jal	8000333e <filealloc>
    8000438c:	892a                	mv	s2,a0
    8000438e:	c561                	beqz	a0,80004456 <sys_open+0x12e>
    80004390:	ed4e                	sd	s3,152(sp)
    80004392:	a33ff0ef          	jal	80003dc4 <fdalloc>
    80004396:	89aa                	mv	s3,a0
    80004398:	0a054b63          	bltz	a0,8000444e <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000439c:	04449703          	lh	a4,68(s1)
    800043a0:	478d                	li	a5,3
    800043a2:	0cf70363          	beq	a4,a5,80004468 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043a6:	4789                	li	a5,2
    800043a8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043ac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043b0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043b4:	f4c42783          	lw	a5,-180(s0)
    800043b8:	0017f713          	andi	a4,a5,1
    800043bc:	00174713          	xori	a4,a4,1
    800043c0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043c4:	0037f713          	andi	a4,a5,3
    800043c8:	00e03733          	snez	a4,a4
    800043cc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043d0:	4007f793          	andi	a5,a5,1024
    800043d4:	c791                	beqz	a5,800043e0 <sys_open+0xb8>
    800043d6:	04449703          	lh	a4,68(s1)
    800043da:	4789                	li	a5,2
    800043dc:	08f70d63          	beq	a4,a5,80004476 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800043e0:	8526                	mv	a0,s1
    800043e2:	bdcfe0ef          	jal	800027be <iunlock>
  end_op();
    800043e6:	c47fe0ef          	jal	8000302c <end_op>

  return fd;
    800043ea:	854e                	mv	a0,s3
    800043ec:	74aa                	ld	s1,168(sp)
    800043ee:	790a                	ld	s2,160(sp)
    800043f0:	69ea                	ld	s3,152(sp)
}
    800043f2:	70ea                	ld	ra,184(sp)
    800043f4:	744a                	ld	s0,176(sp)
    800043f6:	6129                	addi	sp,sp,192
    800043f8:	8082                	ret
      end_op();
    800043fa:	c33fe0ef          	jal	8000302c <end_op>
      return -1;
    800043fe:	557d                	li	a0,-1
    80004400:	74aa                	ld	s1,168(sp)
    80004402:	bfc5                	j	800043f2 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004404:	f5040513          	addi	a0,s0,-176
    80004408:	9f9fe0ef          	jal	80002e00 <namei>
    8000440c:	84aa                	mv	s1,a0
    8000440e:	c11d                	beqz	a0,80004434 <sys_open+0x10c>
    ilock(ip);
    80004410:	b00fe0ef          	jal	80002710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004414:	04449703          	lh	a4,68(s1)
    80004418:	4785                	li	a5,1
    8000441a:	f4f71ce3          	bne	a4,a5,80004372 <sys_open+0x4a>
    8000441e:	f4c42783          	lw	a5,-180(s0)
    80004422:	d3b5                	beqz	a5,80004386 <sys_open+0x5e>
      iunlockput(ip);
    80004424:	8526                	mv	a0,s1
    80004426:	cf4fe0ef          	jal	8000291a <iunlockput>
      end_op();
    8000442a:	c03fe0ef          	jal	8000302c <end_op>
      return -1;
    8000442e:	557d                	li	a0,-1
    80004430:	74aa                	ld	s1,168(sp)
    80004432:	b7c1                	j	800043f2 <sys_open+0xca>
      end_op();
    80004434:	bf9fe0ef          	jal	8000302c <end_op>
      return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	74aa                	ld	s1,168(sp)
    8000443c:	bf5d                	j	800043f2 <sys_open+0xca>
    iunlockput(ip);
    8000443e:	8526                	mv	a0,s1
    80004440:	cdafe0ef          	jal	8000291a <iunlockput>
    end_op();
    80004444:	be9fe0ef          	jal	8000302c <end_op>
    return -1;
    80004448:	557d                	li	a0,-1
    8000444a:	74aa                	ld	s1,168(sp)
    8000444c:	b75d                	j	800043f2 <sys_open+0xca>
      fileclose(f);
    8000444e:	854a                	mv	a0,s2
    80004450:	f93fe0ef          	jal	800033e2 <fileclose>
    80004454:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004456:	8526                	mv	a0,s1
    80004458:	cc2fe0ef          	jal	8000291a <iunlockput>
    end_op();
    8000445c:	bd1fe0ef          	jal	8000302c <end_op>
    return -1;
    80004460:	557d                	li	a0,-1
    80004462:	74aa                	ld	s1,168(sp)
    80004464:	790a                	ld	s2,160(sp)
    80004466:	b771                	j	800043f2 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004468:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000446c:	04649783          	lh	a5,70(s1)
    80004470:	02f91223          	sh	a5,36(s2)
    80004474:	bf35                	j	800043b0 <sys_open+0x88>
    itrunc(ip);
    80004476:	8526                	mv	a0,s1
    80004478:	b86fe0ef          	jal	800027fe <itrunc>
    8000447c:	b795                	j	800043e0 <sys_open+0xb8>

000000008000447e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000447e:	7175                	addi	sp,sp,-144
    80004480:	e506                	sd	ra,136(sp)
    80004482:	e122                	sd	s0,128(sp)
    80004484:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004486:	b3dfe0ef          	jal	80002fc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000448a:	08000613          	li	a2,128
    8000448e:	f7040593          	addi	a1,s0,-144
    80004492:	4501                	li	a0,0
    80004494:	fc2fd0ef          	jal	80001c56 <argstr>
    80004498:	02054363          	bltz	a0,800044be <sys_mkdir+0x40>
    8000449c:	4681                	li	a3,0
    8000449e:	4601                	li	a2,0
    800044a0:	4585                	li	a1,1
    800044a2:	f7040513          	addi	a0,s0,-144
    800044a6:	95dff0ef          	jal	80003e02 <create>
    800044aa:	c911                	beqz	a0,800044be <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044ac:	c6efe0ef          	jal	8000291a <iunlockput>
  end_op();
    800044b0:	b7dfe0ef          	jal	8000302c <end_op>
  return 0;
    800044b4:	4501                	li	a0,0
}
    800044b6:	60aa                	ld	ra,136(sp)
    800044b8:	640a                	ld	s0,128(sp)
    800044ba:	6149                	addi	sp,sp,144
    800044bc:	8082                	ret
    end_op();
    800044be:	b6ffe0ef          	jal	8000302c <end_op>
    return -1;
    800044c2:	557d                	li	a0,-1
    800044c4:	bfcd                	j	800044b6 <sys_mkdir+0x38>

00000000800044c6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044c6:	7135                	addi	sp,sp,-160
    800044c8:	ed06                	sd	ra,152(sp)
    800044ca:	e922                	sd	s0,144(sp)
    800044cc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044ce:	af5fe0ef          	jal	80002fc2 <begin_op>
  argint(1, &major);
    800044d2:	f6c40593          	addi	a1,s0,-148
    800044d6:	4505                	li	a0,1
    800044d8:	f46fd0ef          	jal	80001c1e <argint>
  argint(2, &minor);
    800044dc:	f6840593          	addi	a1,s0,-152
    800044e0:	4509                	li	a0,2
    800044e2:	f3cfd0ef          	jal	80001c1e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044e6:	08000613          	li	a2,128
    800044ea:	f7040593          	addi	a1,s0,-144
    800044ee:	4501                	li	a0,0
    800044f0:	f66fd0ef          	jal	80001c56 <argstr>
    800044f4:	02054563          	bltz	a0,8000451e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800044f8:	f6841683          	lh	a3,-152(s0)
    800044fc:	f6c41603          	lh	a2,-148(s0)
    80004500:	458d                	li	a1,3
    80004502:	f7040513          	addi	a0,s0,-144
    80004506:	8fdff0ef          	jal	80003e02 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000450a:	c911                	beqz	a0,8000451e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000450c:	c0efe0ef          	jal	8000291a <iunlockput>
  end_op();
    80004510:	b1dfe0ef          	jal	8000302c <end_op>
  return 0;
    80004514:	4501                	li	a0,0
}
    80004516:	60ea                	ld	ra,152(sp)
    80004518:	644a                	ld	s0,144(sp)
    8000451a:	610d                	addi	sp,sp,160
    8000451c:	8082                	ret
    end_op();
    8000451e:	b0ffe0ef          	jal	8000302c <end_op>
    return -1;
    80004522:	557d                	li	a0,-1
    80004524:	bfcd                	j	80004516 <sys_mknod+0x50>

0000000080004526 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004526:	7135                	addi	sp,sp,-160
    80004528:	ed06                	sd	ra,152(sp)
    8000452a:	e922                	sd	s0,144(sp)
    8000452c:	e14a                	sd	s2,128(sp)
    8000452e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004530:	831fc0ef          	jal	80000d60 <myproc>
    80004534:	892a                	mv	s2,a0
  
  begin_op();
    80004536:	a8dfe0ef          	jal	80002fc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000453a:	08000613          	li	a2,128
    8000453e:	f6040593          	addi	a1,s0,-160
    80004542:	4501                	li	a0,0
    80004544:	f12fd0ef          	jal	80001c56 <argstr>
    80004548:	04054363          	bltz	a0,8000458e <sys_chdir+0x68>
    8000454c:	e526                	sd	s1,136(sp)
    8000454e:	f6040513          	addi	a0,s0,-160
    80004552:	8affe0ef          	jal	80002e00 <namei>
    80004556:	84aa                	mv	s1,a0
    80004558:	c915                	beqz	a0,8000458c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000455a:	9b6fe0ef          	jal	80002710 <ilock>
  if(ip->type != T_DIR){
    8000455e:	04449703          	lh	a4,68(s1)
    80004562:	4785                	li	a5,1
    80004564:	02f71963          	bne	a4,a5,80004596 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004568:	8526                	mv	a0,s1
    8000456a:	a54fe0ef          	jal	800027be <iunlock>
  iput(p->cwd);
    8000456e:	15093503          	ld	a0,336(s2)
    80004572:	b20fe0ef          	jal	80002892 <iput>
  end_op();
    80004576:	ab7fe0ef          	jal	8000302c <end_op>
  p->cwd = ip;
    8000457a:	14993823          	sd	s1,336(s2)
  return 0;
    8000457e:	4501                	li	a0,0
    80004580:	64aa                	ld	s1,136(sp)
}
    80004582:	60ea                	ld	ra,152(sp)
    80004584:	644a                	ld	s0,144(sp)
    80004586:	690a                	ld	s2,128(sp)
    80004588:	610d                	addi	sp,sp,160
    8000458a:	8082                	ret
    8000458c:	64aa                	ld	s1,136(sp)
    end_op();
    8000458e:	a9ffe0ef          	jal	8000302c <end_op>
    return -1;
    80004592:	557d                	li	a0,-1
    80004594:	b7fd                	j	80004582 <sys_chdir+0x5c>
    iunlockput(ip);
    80004596:	8526                	mv	a0,s1
    80004598:	b82fe0ef          	jal	8000291a <iunlockput>
    end_op();
    8000459c:	a91fe0ef          	jal	8000302c <end_op>
    return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	64aa                	ld	s1,136(sp)
    800045a4:	bff9                	j	80004582 <sys_chdir+0x5c>

00000000800045a6 <sys_exec>:

uint64
sys_exec(void)
{
    800045a6:	7105                	addi	sp,sp,-480
    800045a8:	ef86                	sd	ra,472(sp)
    800045aa:	eba2                	sd	s0,464(sp)
    800045ac:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045ae:	e2840593          	addi	a1,s0,-472
    800045b2:	4505                	li	a0,1
    800045b4:	e86fd0ef          	jal	80001c3a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045b8:	08000613          	li	a2,128
    800045bc:	f3040593          	addi	a1,s0,-208
    800045c0:	4501                	li	a0,0
    800045c2:	e94fd0ef          	jal	80001c56 <argstr>
    800045c6:	87aa                	mv	a5,a0
    return -1;
    800045c8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045ca:	0e07c063          	bltz	a5,800046aa <sys_exec+0x104>
    800045ce:	e7a6                	sd	s1,456(sp)
    800045d0:	e3ca                	sd	s2,448(sp)
    800045d2:	ff4e                	sd	s3,440(sp)
    800045d4:	fb52                	sd	s4,432(sp)
    800045d6:	f756                	sd	s5,424(sp)
    800045d8:	f35a                	sd	s6,416(sp)
    800045da:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045dc:	e3040a13          	addi	s4,s0,-464
    800045e0:	10000613          	li	a2,256
    800045e4:	4581                	li	a1,0
    800045e6:	8552                	mv	a0,s4
    800045e8:	b67fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045ec:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800045ee:	89d2                	mv	s3,s4
    800045f0:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045f2:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800045f6:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800045f8:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045fc:	00391513          	slli	a0,s2,0x3
    80004600:	85d6                	mv	a1,s5
    80004602:	e2843783          	ld	a5,-472(s0)
    80004606:	953e                	add	a0,a0,a5
    80004608:	d8cfd0ef          	jal	80001b94 <fetchaddr>
    8000460c:	02054663          	bltz	a0,80004638 <sys_exec+0x92>
    if(uarg == 0){
    80004610:	e2043783          	ld	a5,-480(s0)
    80004614:	c7a1                	beqz	a5,8000465c <sys_exec+0xb6>
    argv[i] = kalloc();
    80004616:	ae9fb0ef          	jal	800000fe <kalloc>
    8000461a:	85aa                	mv	a1,a0
    8000461c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004620:	cd01                	beqz	a0,80004638 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004622:	865a                	mv	a2,s6
    80004624:	e2043503          	ld	a0,-480(s0)
    80004628:	db6fd0ef          	jal	80001bde <fetchstr>
    8000462c:	00054663          	bltz	a0,80004638 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004630:	0905                	addi	s2,s2,1
    80004632:	09a1                	addi	s3,s3,8
    80004634:	fd7914e3          	bne	s2,s7,800045fc <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004638:	100a0a13          	addi	s4,s4,256
    8000463c:	6088                	ld	a0,0(s1)
    8000463e:	cd31                	beqz	a0,8000469a <sys_exec+0xf4>
    kfree(argv[i]);
    80004640:	9ddfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004644:	04a1                	addi	s1,s1,8
    80004646:	ff449be3          	bne	s1,s4,8000463c <sys_exec+0x96>
  return -1;
    8000464a:	557d                	li	a0,-1
    8000464c:	64be                	ld	s1,456(sp)
    8000464e:	691e                	ld	s2,448(sp)
    80004650:	79fa                	ld	s3,440(sp)
    80004652:	7a5a                	ld	s4,432(sp)
    80004654:	7aba                	ld	s5,424(sp)
    80004656:	7b1a                	ld	s6,416(sp)
    80004658:	6bfa                	ld	s7,408(sp)
    8000465a:	a881                	j	800046aa <sys_exec+0x104>
      argv[i] = 0;
    8000465c:	0009079b          	sext.w	a5,s2
    80004660:	e3040593          	addi	a1,s0,-464
    80004664:	078e                	slli	a5,a5,0x3
    80004666:	97ae                	add	a5,a5,a1
    80004668:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000466c:	f3040513          	addi	a0,s0,-208
    80004670:	ba4ff0ef          	jal	80003a14 <exec>
    80004674:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004676:	100a0a13          	addi	s4,s4,256
    8000467a:	6088                	ld	a0,0(s1)
    8000467c:	c511                	beqz	a0,80004688 <sys_exec+0xe2>
    kfree(argv[i]);
    8000467e:	99ffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004682:	04a1                	addi	s1,s1,8
    80004684:	ff449be3          	bne	s1,s4,8000467a <sys_exec+0xd4>
  return ret;
    80004688:	854a                	mv	a0,s2
    8000468a:	64be                	ld	s1,456(sp)
    8000468c:	691e                	ld	s2,448(sp)
    8000468e:	79fa                	ld	s3,440(sp)
    80004690:	7a5a                	ld	s4,432(sp)
    80004692:	7aba                	ld	s5,424(sp)
    80004694:	7b1a                	ld	s6,416(sp)
    80004696:	6bfa                	ld	s7,408(sp)
    80004698:	a809                	j	800046aa <sys_exec+0x104>
  return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	64be                	ld	s1,456(sp)
    8000469e:	691e                	ld	s2,448(sp)
    800046a0:	79fa                	ld	s3,440(sp)
    800046a2:	7a5a                	ld	s4,432(sp)
    800046a4:	7aba                	ld	s5,424(sp)
    800046a6:	7b1a                	ld	s6,416(sp)
    800046a8:	6bfa                	ld	s7,408(sp)
}
    800046aa:	60fe                	ld	ra,472(sp)
    800046ac:	645e                	ld	s0,464(sp)
    800046ae:	613d                	addi	sp,sp,480
    800046b0:	8082                	ret

00000000800046b2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800046b2:	7139                	addi	sp,sp,-64
    800046b4:	fc06                	sd	ra,56(sp)
    800046b6:	f822                	sd	s0,48(sp)
    800046b8:	f426                	sd	s1,40(sp)
    800046ba:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046bc:	ea4fc0ef          	jal	80000d60 <myproc>
    800046c0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046c2:	fd840593          	addi	a1,s0,-40
    800046c6:	4501                	li	a0,0
    800046c8:	d72fd0ef          	jal	80001c3a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046cc:	fc840593          	addi	a1,s0,-56
    800046d0:	fd040513          	addi	a0,s0,-48
    800046d4:	81eff0ef          	jal	800036f2 <pipealloc>
    return -1;
    800046d8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046da:	0a054463          	bltz	a0,80004782 <sys_pipe+0xd0>
  fd0 = -1;
    800046de:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046e2:	fd043503          	ld	a0,-48(s0)
    800046e6:	edeff0ef          	jal	80003dc4 <fdalloc>
    800046ea:	fca42223          	sw	a0,-60(s0)
    800046ee:	08054163          	bltz	a0,80004770 <sys_pipe+0xbe>
    800046f2:	fc843503          	ld	a0,-56(s0)
    800046f6:	eceff0ef          	jal	80003dc4 <fdalloc>
    800046fa:	fca42023          	sw	a0,-64(s0)
    800046fe:	06054063          	bltz	a0,8000475e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004702:	4691                	li	a3,4
    80004704:	fc440613          	addi	a2,s0,-60
    80004708:	fd843583          	ld	a1,-40(s0)
    8000470c:	68a8                	ld	a0,80(s1)
    8000470e:	af6fc0ef          	jal	80000a04 <copyout>
    80004712:	00054e63          	bltz	a0,8000472e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004716:	4691                	li	a3,4
    80004718:	fc040613          	addi	a2,s0,-64
    8000471c:	fd843583          	ld	a1,-40(s0)
    80004720:	95b6                	add	a1,a1,a3
    80004722:	68a8                	ld	a0,80(s1)
    80004724:	ae0fc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004728:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000472a:	04055c63          	bgez	a0,80004782 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000472e:	fc442783          	lw	a5,-60(s0)
    80004732:	07e9                	addi	a5,a5,26
    80004734:	078e                	slli	a5,a5,0x3
    80004736:	97a6                	add	a5,a5,s1
    80004738:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000473c:	fc042783          	lw	a5,-64(s0)
    80004740:	07e9                	addi	a5,a5,26
    80004742:	078e                	slli	a5,a5,0x3
    80004744:	94be                	add	s1,s1,a5
    80004746:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000474a:	fd043503          	ld	a0,-48(s0)
    8000474e:	c95fe0ef          	jal	800033e2 <fileclose>
    fileclose(wf);
    80004752:	fc843503          	ld	a0,-56(s0)
    80004756:	c8dfe0ef          	jal	800033e2 <fileclose>
    return -1;
    8000475a:	57fd                	li	a5,-1
    8000475c:	a01d                	j	80004782 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000475e:	fc442783          	lw	a5,-60(s0)
    80004762:	0007c763          	bltz	a5,80004770 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004766:	07e9                	addi	a5,a5,26
    80004768:	078e                	slli	a5,a5,0x3
    8000476a:	97a6                	add	a5,a5,s1
    8000476c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004770:	fd043503          	ld	a0,-48(s0)
    80004774:	c6ffe0ef          	jal	800033e2 <fileclose>
    fileclose(wf);
    80004778:	fc843503          	ld	a0,-56(s0)
    8000477c:	c67fe0ef          	jal	800033e2 <fileclose>
    return -1;
    80004780:	57fd                	li	a5,-1
}
    80004782:	853e                	mv	a0,a5
    80004784:	70e2                	ld	ra,56(sp)
    80004786:	7442                	ld	s0,48(sp)
    80004788:	74a2                	ld	s1,40(sp)
    8000478a:	6121                	addi	sp,sp,64
    8000478c:	8082                	ret
	...

0000000080004790 <kernelvec>:
    80004790:	7111                	addi	sp,sp,-256
    80004792:	e006                	sd	ra,0(sp)
    80004794:	e40a                	sd	sp,8(sp)
    80004796:	e80e                	sd	gp,16(sp)
    80004798:	ec12                	sd	tp,24(sp)
    8000479a:	f016                	sd	t0,32(sp)
    8000479c:	f41a                	sd	t1,40(sp)
    8000479e:	f81e                	sd	t2,48(sp)
    800047a0:	e4aa                	sd	a0,72(sp)
    800047a2:	e8ae                	sd	a1,80(sp)
    800047a4:	ecb2                	sd	a2,88(sp)
    800047a6:	f0b6                	sd	a3,96(sp)
    800047a8:	f4ba                	sd	a4,104(sp)
    800047aa:	f8be                	sd	a5,112(sp)
    800047ac:	fcc2                	sd	a6,120(sp)
    800047ae:	e146                	sd	a7,128(sp)
    800047b0:	edf2                	sd	t3,216(sp)
    800047b2:	f1f6                	sd	t4,224(sp)
    800047b4:	f5fa                	sd	t5,232(sp)
    800047b6:	f9fe                	sd	t6,240(sp)
    800047b8:	aecfd0ef          	jal	80001aa4 <kerneltrap>
    800047bc:	6082                	ld	ra,0(sp)
    800047be:	6122                	ld	sp,8(sp)
    800047c0:	61c2                	ld	gp,16(sp)
    800047c2:	7282                	ld	t0,32(sp)
    800047c4:	7322                	ld	t1,40(sp)
    800047c6:	73c2                	ld	t2,48(sp)
    800047c8:	6526                	ld	a0,72(sp)
    800047ca:	65c6                	ld	a1,80(sp)
    800047cc:	6666                	ld	a2,88(sp)
    800047ce:	7686                	ld	a3,96(sp)
    800047d0:	7726                	ld	a4,104(sp)
    800047d2:	77c6                	ld	a5,112(sp)
    800047d4:	7866                	ld	a6,120(sp)
    800047d6:	688a                	ld	a7,128(sp)
    800047d8:	6e6e                	ld	t3,216(sp)
    800047da:	7e8e                	ld	t4,224(sp)
    800047dc:	7f2e                	ld	t5,232(sp)
    800047de:	7fce                	ld	t6,240(sp)
    800047e0:	6111                	addi	sp,sp,256
    800047e2:	10200073          	sret
	...

00000000800047ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047ee:	1141                	addi	sp,sp,-16
    800047f0:	e406                	sd	ra,8(sp)
    800047f2:	e022                	sd	s0,0(sp)
    800047f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800047f6:	0c000737          	lui	a4,0xc000
    800047fa:	4785                	li	a5,1
    800047fc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800047fe:	c35c                	sw	a5,4(a4)
}
    80004800:	60a2                	ld	ra,8(sp)
    80004802:	6402                	ld	s0,0(sp)
    80004804:	0141                	addi	sp,sp,16
    80004806:	8082                	ret

0000000080004808 <plicinithart>:

void
plicinithart(void)
{
    80004808:	1141                	addi	sp,sp,-16
    8000480a:	e406                	sd	ra,8(sp)
    8000480c:	e022                	sd	s0,0(sp)
    8000480e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004810:	d1cfc0ef          	jal	80000d2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004814:	0085171b          	slliw	a4,a0,0x8
    80004818:	0c0027b7          	lui	a5,0xc002
    8000481c:	97ba                	add	a5,a5,a4
    8000481e:	40200713          	li	a4,1026
    80004822:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004826:	00d5151b          	slliw	a0,a0,0xd
    8000482a:	0c2017b7          	lui	a5,0xc201
    8000482e:	97aa                	add	a5,a5,a0
    80004830:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004834:	60a2                	ld	ra,8(sp)
    80004836:	6402                	ld	s0,0(sp)
    80004838:	0141                	addi	sp,sp,16
    8000483a:	8082                	ret

000000008000483c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000483c:	1141                	addi	sp,sp,-16
    8000483e:	e406                	sd	ra,8(sp)
    80004840:	e022                	sd	s0,0(sp)
    80004842:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004844:	ce8fc0ef          	jal	80000d2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004848:	00d5151b          	slliw	a0,a0,0xd
    8000484c:	0c2017b7          	lui	a5,0xc201
    80004850:	97aa                	add	a5,a5,a0
  return irq;
}
    80004852:	43c8                	lw	a0,4(a5)
    80004854:	60a2                	ld	ra,8(sp)
    80004856:	6402                	ld	s0,0(sp)
    80004858:	0141                	addi	sp,sp,16
    8000485a:	8082                	ret

000000008000485c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	e426                	sd	s1,8(sp)
    80004864:	1000                	addi	s0,sp,32
    80004866:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004868:	cc4fc0ef          	jal	80000d2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000486c:	00d5179b          	slliw	a5,a0,0xd
    80004870:	0c201737          	lui	a4,0xc201
    80004874:	97ba                	add	a5,a5,a4
    80004876:	c3c4                	sw	s1,4(a5)
}
    80004878:	60e2                	ld	ra,24(sp)
    8000487a:	6442                	ld	s0,16(sp)
    8000487c:	64a2                	ld	s1,8(sp)
    8000487e:	6105                	addi	sp,sp,32
    80004880:	8082                	ret

0000000080004882 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004882:	1141                	addi	sp,sp,-16
    80004884:	e406                	sd	ra,8(sp)
    80004886:	e022                	sd	s0,0(sp)
    80004888:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000488a:	479d                	li	a5,7
    8000488c:	04a7ca63          	blt	a5,a0,800048e0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004890:	00017797          	auipc	a5,0x17
    80004894:	b7078793          	addi	a5,a5,-1168 # 8001b400 <disk>
    80004898:	97aa                	add	a5,a5,a0
    8000489a:	0187c783          	lbu	a5,24(a5)
    8000489e:	e7b9                	bnez	a5,800048ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048a0:	00451693          	slli	a3,a0,0x4
    800048a4:	00017797          	auipc	a5,0x17
    800048a8:	b5c78793          	addi	a5,a5,-1188 # 8001b400 <disk>
    800048ac:	6398                	ld	a4,0(a5)
    800048ae:	9736                	add	a4,a4,a3
    800048b0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800048b4:	6398                	ld	a4,0(a5)
    800048b6:	9736                	add	a4,a4,a3
    800048b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048c4:	97aa                	add	a5,a5,a0
    800048c6:	4705                	li	a4,1
    800048c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800048cc:	00017517          	auipc	a0,0x17
    800048d0:	b4c50513          	addi	a0,a0,-1204 # 8001b418 <disk+0x18>
    800048d4:	ab3fc0ef          	jal	80001386 <wakeup>
}
    800048d8:	60a2                	ld	ra,8(sp)
    800048da:	6402                	ld	s0,0(sp)
    800048dc:	0141                	addi	sp,sp,16
    800048de:	8082                	ret
    panic("free_desc 1");
    800048e0:	00003517          	auipc	a0,0x3
    800048e4:	d3050513          	addi	a0,a0,-720 # 80007610 <etext+0x610>
    800048e8:	40f000ef          	jal	800054f6 <panic>
    panic("free_desc 2");
    800048ec:	00003517          	auipc	a0,0x3
    800048f0:	d3450513          	addi	a0,a0,-716 # 80007620 <etext+0x620>
    800048f4:	403000ef          	jal	800054f6 <panic>

00000000800048f8 <virtio_disk_init>:
{
    800048f8:	1101                	addi	sp,sp,-32
    800048fa:	ec06                	sd	ra,24(sp)
    800048fc:	e822                	sd	s0,16(sp)
    800048fe:	e426                	sd	s1,8(sp)
    80004900:	e04a                	sd	s2,0(sp)
    80004902:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004904:	00003597          	auipc	a1,0x3
    80004908:	d2c58593          	addi	a1,a1,-724 # 80007630 <etext+0x630>
    8000490c:	00017517          	auipc	a0,0x17
    80004910:	c1c50513          	addi	a0,a0,-996 # 8001b528 <disk+0x128>
    80004914:	68d000ef          	jal	800057a0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004918:	100017b7          	lui	a5,0x10001
    8000491c:	4398                	lw	a4,0(a5)
    8000491e:	2701                	sext.w	a4,a4
    80004920:	747277b7          	lui	a5,0x74727
    80004924:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004928:	14f71863          	bne	a4,a5,80004a78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000492c:	100017b7          	lui	a5,0x10001
    80004930:	43dc                	lw	a5,4(a5)
    80004932:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004934:	4709                	li	a4,2
    80004936:	14e79163          	bne	a5,a4,80004a78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000493a:	100017b7          	lui	a5,0x10001
    8000493e:	479c                	lw	a5,8(a5)
    80004940:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004942:	12e79b63          	bne	a5,a4,80004a78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004946:	100017b7          	lui	a5,0x10001
    8000494a:	47d8                	lw	a4,12(a5)
    8000494c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000494e:	554d47b7          	lui	a5,0x554d4
    80004952:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004956:	12f71163          	bne	a4,a5,80004a78 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000495a:	100017b7          	lui	a5,0x10001
    8000495e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004962:	4705                	li	a4,1
    80004964:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004966:	470d                	li	a4,3
    80004968:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000496a:	10001737          	lui	a4,0x10001
    8000496e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004970:	c7ffe6b7          	lui	a3,0xc7ffe
    80004974:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb11f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004978:	8f75                	and	a4,a4,a3
    8000497a:	100016b7          	lui	a3,0x10001
    8000497e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004980:	472d                	li	a4,11
    80004982:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004984:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004988:	439c                	lw	a5,0(a5)
    8000498a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000498e:	8ba1                	andi	a5,a5,8
    80004990:	0e078a63          	beqz	a5,80004a84 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004994:	100017b7          	lui	a5,0x10001
    80004998:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000499c:	43fc                	lw	a5,68(a5)
    8000499e:	2781                	sext.w	a5,a5
    800049a0:	0e079863          	bnez	a5,80004a90 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049a4:	100017b7          	lui	a5,0x10001
    800049a8:	5bdc                	lw	a5,52(a5)
    800049aa:	2781                	sext.w	a5,a5
  if(max == 0)
    800049ac:	0e078863          	beqz	a5,80004a9c <virtio_disk_init+0x1a4>
  if(max < NUM)
    800049b0:	471d                	li	a4,7
    800049b2:	0ef77b63          	bgeu	a4,a5,80004aa8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800049b6:	f48fb0ef          	jal	800000fe <kalloc>
    800049ba:	00017497          	auipc	s1,0x17
    800049be:	a4648493          	addi	s1,s1,-1466 # 8001b400 <disk>
    800049c2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049c4:	f3afb0ef          	jal	800000fe <kalloc>
    800049c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049ca:	f34fb0ef          	jal	800000fe <kalloc>
    800049ce:	87aa                	mv	a5,a0
    800049d0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049d2:	6088                	ld	a0,0(s1)
    800049d4:	0e050063          	beqz	a0,80004ab4 <virtio_disk_init+0x1bc>
    800049d8:	00017717          	auipc	a4,0x17
    800049dc:	a3073703          	ld	a4,-1488(a4) # 8001b408 <disk+0x8>
    800049e0:	cb71                	beqz	a4,80004ab4 <virtio_disk_init+0x1bc>
    800049e2:	cbe9                	beqz	a5,80004ab4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800049e4:	6605                	lui	a2,0x1
    800049e6:	4581                	li	a1,0
    800049e8:	f66fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800049ec:	00017497          	auipc	s1,0x17
    800049f0:	a1448493          	addi	s1,s1,-1516 # 8001b400 <disk>
    800049f4:	6605                	lui	a2,0x1
    800049f6:	4581                	li	a1,0
    800049f8:	6488                	ld	a0,8(s1)
    800049fa:	f54fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800049fe:	6605                	lui	a2,0x1
    80004a00:	4581                	li	a1,0
    80004a02:	6888                	ld	a0,16(s1)
    80004a04:	f4afb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a08:	100017b7          	lui	a5,0x10001
    80004a0c:	4721                	li	a4,8
    80004a0e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a10:	4098                	lw	a4,0(s1)
    80004a12:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a16:	40d8                	lw	a4,4(s1)
    80004a18:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a1c:	649c                	ld	a5,8(s1)
    80004a1e:	0007869b          	sext.w	a3,a5
    80004a22:	10001737          	lui	a4,0x10001
    80004a26:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a2a:	9781                	srai	a5,a5,0x20
    80004a2c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a30:	689c                	ld	a5,16(s1)
    80004a32:	0007869b          	sext.w	a3,a5
    80004a36:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a3a:	9781                	srai	a5,a5,0x20
    80004a3c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a40:	4785                	li	a5,1
    80004a42:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a44:	00f48c23          	sb	a5,24(s1)
    80004a48:	00f48ca3          	sb	a5,25(s1)
    80004a4c:	00f48d23          	sb	a5,26(s1)
    80004a50:	00f48da3          	sb	a5,27(s1)
    80004a54:	00f48e23          	sb	a5,28(s1)
    80004a58:	00f48ea3          	sb	a5,29(s1)
    80004a5c:	00f48f23          	sb	a5,30(s1)
    80004a60:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a64:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a68:	07272823          	sw	s2,112(a4)
}
    80004a6c:	60e2                	ld	ra,24(sp)
    80004a6e:	6442                	ld	s0,16(sp)
    80004a70:	64a2                	ld	s1,8(sp)
    80004a72:	6902                	ld	s2,0(sp)
    80004a74:	6105                	addi	sp,sp,32
    80004a76:	8082                	ret
    panic("could not find virtio disk");
    80004a78:	00003517          	auipc	a0,0x3
    80004a7c:	bc850513          	addi	a0,a0,-1080 # 80007640 <etext+0x640>
    80004a80:	277000ef          	jal	800054f6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a84:	00003517          	auipc	a0,0x3
    80004a88:	bdc50513          	addi	a0,a0,-1060 # 80007660 <etext+0x660>
    80004a8c:	26b000ef          	jal	800054f6 <panic>
    panic("virtio disk should not be ready");
    80004a90:	00003517          	auipc	a0,0x3
    80004a94:	bf050513          	addi	a0,a0,-1040 # 80007680 <etext+0x680>
    80004a98:	25f000ef          	jal	800054f6 <panic>
    panic("virtio disk has no queue 0");
    80004a9c:	00003517          	auipc	a0,0x3
    80004aa0:	c0450513          	addi	a0,a0,-1020 # 800076a0 <etext+0x6a0>
    80004aa4:	253000ef          	jal	800054f6 <panic>
    panic("virtio disk max queue too short");
    80004aa8:	00003517          	auipc	a0,0x3
    80004aac:	c1850513          	addi	a0,a0,-1000 # 800076c0 <etext+0x6c0>
    80004ab0:	247000ef          	jal	800054f6 <panic>
    panic("virtio disk kalloc");
    80004ab4:	00003517          	auipc	a0,0x3
    80004ab8:	c2c50513          	addi	a0,a0,-980 # 800076e0 <etext+0x6e0>
    80004abc:	23b000ef          	jal	800054f6 <panic>

0000000080004ac0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ac0:	711d                	addi	sp,sp,-96
    80004ac2:	ec86                	sd	ra,88(sp)
    80004ac4:	e8a2                	sd	s0,80(sp)
    80004ac6:	e4a6                	sd	s1,72(sp)
    80004ac8:	e0ca                	sd	s2,64(sp)
    80004aca:	fc4e                	sd	s3,56(sp)
    80004acc:	f852                	sd	s4,48(sp)
    80004ace:	f456                	sd	s5,40(sp)
    80004ad0:	f05a                	sd	s6,32(sp)
    80004ad2:	ec5e                	sd	s7,24(sp)
    80004ad4:	e862                	sd	s8,16(sp)
    80004ad6:	1080                	addi	s0,sp,96
    80004ad8:	89aa                	mv	s3,a0
    80004ada:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004adc:	00c52b83          	lw	s7,12(a0)
    80004ae0:	001b9b9b          	slliw	s7,s7,0x1
    80004ae4:	1b82                	slli	s7,s7,0x20
    80004ae6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004aea:	00017517          	auipc	a0,0x17
    80004aee:	a3e50513          	addi	a0,a0,-1474 # 8001b528 <disk+0x128>
    80004af2:	533000ef          	jal	80005824 <acquire>
  for(int i = 0; i < NUM; i++){
    80004af6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004af8:	00017a97          	auipc	s5,0x17
    80004afc:	908a8a93          	addi	s5,s5,-1784 # 8001b400 <disk>
  for(int i = 0; i < 3; i++){
    80004b00:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004b02:	5c7d                	li	s8,-1
    80004b04:	a095                	j	80004b68 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004b06:	00fa8733          	add	a4,s5,a5
    80004b0a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004b0e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b10:	0207c563          	bltz	a5,80004b3a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004b14:	2905                	addiw	s2,s2,1
    80004b16:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b18:	05490c63          	beq	s2,s4,80004b70 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004b1c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b1e:	00017717          	auipc	a4,0x17
    80004b22:	8e270713          	addi	a4,a4,-1822 # 8001b400 <disk>
    80004b26:	4781                	li	a5,0
    if(disk.free[i]){
    80004b28:	01874683          	lbu	a3,24(a4)
    80004b2c:	fee9                	bnez	a3,80004b06 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004b2e:	2785                	addiw	a5,a5,1
    80004b30:	0705                	addi	a4,a4,1
    80004b32:	fe979be3          	bne	a5,s1,80004b28 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004b36:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004b3a:	01205d63          	blez	s2,80004b54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004b3e:	fa042503          	lw	a0,-96(s0)
    80004b42:	d41ff0ef          	jal	80004882 <free_desc>
      for(int j = 0; j < i; j++)
    80004b46:	4785                	li	a5,1
    80004b48:	0127d663          	bge	a5,s2,80004b54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004b4c:	fa442503          	lw	a0,-92(s0)
    80004b50:	d33ff0ef          	jal	80004882 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b54:	00017597          	auipc	a1,0x17
    80004b58:	9d458593          	addi	a1,a1,-1580 # 8001b528 <disk+0x128>
    80004b5c:	00017517          	auipc	a0,0x17
    80004b60:	8bc50513          	addi	a0,a0,-1860 # 8001b418 <disk+0x18>
    80004b64:	fd6fc0ef          	jal	8000133a <sleep>
  for(int i = 0; i < 3; i++){
    80004b68:	fa040613          	addi	a2,s0,-96
    80004b6c:	4901                	li	s2,0
    80004b6e:	b77d                	j	80004b1c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b70:	fa042503          	lw	a0,-96(s0)
    80004b74:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b78:	00017797          	auipc	a5,0x17
    80004b7c:	88878793          	addi	a5,a5,-1912 # 8001b400 <disk>
    80004b80:	00a50713          	addi	a4,a0,10
    80004b84:	0712                	slli	a4,a4,0x4
    80004b86:	973e                	add	a4,a4,a5
    80004b88:	01603633          	snez	a2,s6
    80004b8c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b8e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b92:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b96:	6398                	ld	a4,0(a5)
    80004b98:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b9a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004b9e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ba0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ba2:	6390                	ld	a2,0(a5)
    80004ba4:	00d605b3          	add	a1,a2,a3
    80004ba8:	4741                	li	a4,16
    80004baa:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004bac:	4805                	li	a6,1
    80004bae:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004bb2:	fa442703          	lw	a4,-92(s0)
    80004bb6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bba:	0712                	slli	a4,a4,0x4
    80004bbc:	963a                	add	a2,a2,a4
    80004bbe:	05898593          	addi	a1,s3,88
    80004bc2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004bc4:	0007b883          	ld	a7,0(a5)
    80004bc8:	9746                	add	a4,a4,a7
    80004bca:	40000613          	li	a2,1024
    80004bce:	c710                	sw	a2,8(a4)
  if(write)
    80004bd0:	001b3613          	seqz	a2,s6
    80004bd4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bd8:	01066633          	or	a2,a2,a6
    80004bdc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004be0:	fa842583          	lw	a1,-88(s0)
    80004be4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004be8:	00250613          	addi	a2,a0,2
    80004bec:	0612                	slli	a2,a2,0x4
    80004bee:	963e                	add	a2,a2,a5
    80004bf0:	577d                	li	a4,-1
    80004bf2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004bf6:	0592                	slli	a1,a1,0x4
    80004bf8:	98ae                	add	a7,a7,a1
    80004bfa:	03068713          	addi	a4,a3,48
    80004bfe:	973e                	add	a4,a4,a5
    80004c00:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c04:	6398                	ld	a4,0(a5)
    80004c06:	972e                	add	a4,a4,a1
    80004c08:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c0c:	4689                	li	a3,2
    80004c0e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c12:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c16:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004c1a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c1e:	6794                	ld	a3,8(a5)
    80004c20:	0026d703          	lhu	a4,2(a3)
    80004c24:	8b1d                	andi	a4,a4,7
    80004c26:	0706                	slli	a4,a4,0x1
    80004c28:	96ba                	add	a3,a3,a4
    80004c2a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c2e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c32:	6798                	ld	a4,8(a5)
    80004c34:	00275783          	lhu	a5,2(a4)
    80004c38:	2785                	addiw	a5,a5,1
    80004c3a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c3e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c42:	100017b7          	lui	a5,0x10001
    80004c46:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c4a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004c4e:	00017917          	auipc	s2,0x17
    80004c52:	8da90913          	addi	s2,s2,-1830 # 8001b528 <disk+0x128>
  while(b->disk == 1) {
    80004c56:	84c2                	mv	s1,a6
    80004c58:	01079a63          	bne	a5,a6,80004c6c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004c5c:	85ca                	mv	a1,s2
    80004c5e:	854e                	mv	a0,s3
    80004c60:	edafc0ef          	jal	8000133a <sleep>
  while(b->disk == 1) {
    80004c64:	0049a783          	lw	a5,4(s3)
    80004c68:	fe978ae3          	beq	a5,s1,80004c5c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004c6c:	fa042903          	lw	s2,-96(s0)
    80004c70:	00290713          	addi	a4,s2,2
    80004c74:	0712                	slli	a4,a4,0x4
    80004c76:	00016797          	auipc	a5,0x16
    80004c7a:	78a78793          	addi	a5,a5,1930 # 8001b400 <disk>
    80004c7e:	97ba                	add	a5,a5,a4
    80004c80:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c84:	00016997          	auipc	s3,0x16
    80004c88:	77c98993          	addi	s3,s3,1916 # 8001b400 <disk>
    80004c8c:	00491713          	slli	a4,s2,0x4
    80004c90:	0009b783          	ld	a5,0(s3)
    80004c94:	97ba                	add	a5,a5,a4
    80004c96:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ca0:	be3ff0ef          	jal	80004882 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ca4:	8885                	andi	s1,s1,1
    80004ca6:	f0fd                	bnez	s1,80004c8c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ca8:	00017517          	auipc	a0,0x17
    80004cac:	88050513          	addi	a0,a0,-1920 # 8001b528 <disk+0x128>
    80004cb0:	409000ef          	jal	800058b8 <release>
}
    80004cb4:	60e6                	ld	ra,88(sp)
    80004cb6:	6446                	ld	s0,80(sp)
    80004cb8:	64a6                	ld	s1,72(sp)
    80004cba:	6906                	ld	s2,64(sp)
    80004cbc:	79e2                	ld	s3,56(sp)
    80004cbe:	7a42                	ld	s4,48(sp)
    80004cc0:	7aa2                	ld	s5,40(sp)
    80004cc2:	7b02                	ld	s6,32(sp)
    80004cc4:	6be2                	ld	s7,24(sp)
    80004cc6:	6c42                	ld	s8,16(sp)
    80004cc8:	6125                	addi	sp,sp,96
    80004cca:	8082                	ret

0000000080004ccc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ccc:	1101                	addi	sp,sp,-32
    80004cce:	ec06                	sd	ra,24(sp)
    80004cd0:	e822                	sd	s0,16(sp)
    80004cd2:	e426                	sd	s1,8(sp)
    80004cd4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004cd6:	00016497          	auipc	s1,0x16
    80004cda:	72a48493          	addi	s1,s1,1834 # 8001b400 <disk>
    80004cde:	00017517          	auipc	a0,0x17
    80004ce2:	84a50513          	addi	a0,a0,-1974 # 8001b528 <disk+0x128>
    80004ce6:	33f000ef          	jal	80005824 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004cea:	100017b7          	lui	a5,0x10001
    80004cee:	53bc                	lw	a5,96(a5)
    80004cf0:	8b8d                	andi	a5,a5,3
    80004cf2:	10001737          	lui	a4,0x10001
    80004cf6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004cf8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004cfc:	689c                	ld	a5,16(s1)
    80004cfe:	0204d703          	lhu	a4,32(s1)
    80004d02:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d06:	04f70663          	beq	a4,a5,80004d52 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d0a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d0e:	6898                	ld	a4,16(s1)
    80004d10:	0204d783          	lhu	a5,32(s1)
    80004d14:	8b9d                	andi	a5,a5,7
    80004d16:	078e                	slli	a5,a5,0x3
    80004d18:	97ba                	add	a5,a5,a4
    80004d1a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d1c:	00278713          	addi	a4,a5,2
    80004d20:	0712                	slli	a4,a4,0x4
    80004d22:	9726                	add	a4,a4,s1
    80004d24:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004d28:	e321                	bnez	a4,80004d68 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d2a:	0789                	addi	a5,a5,2
    80004d2c:	0792                	slli	a5,a5,0x4
    80004d2e:	97a6                	add	a5,a5,s1
    80004d30:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d32:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d36:	e50fc0ef          	jal	80001386 <wakeup>

    disk.used_idx += 1;
    80004d3a:	0204d783          	lhu	a5,32(s1)
    80004d3e:	2785                	addiw	a5,a5,1
    80004d40:	17c2                	slli	a5,a5,0x30
    80004d42:	93c1                	srli	a5,a5,0x30
    80004d44:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d48:	6898                	ld	a4,16(s1)
    80004d4a:	00275703          	lhu	a4,2(a4)
    80004d4e:	faf71ee3          	bne	a4,a5,80004d0a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d52:	00016517          	auipc	a0,0x16
    80004d56:	7d650513          	addi	a0,a0,2006 # 8001b528 <disk+0x128>
    80004d5a:	35f000ef          	jal	800058b8 <release>
}
    80004d5e:	60e2                	ld	ra,24(sp)
    80004d60:	6442                	ld	s0,16(sp)
    80004d62:	64a2                	ld	s1,8(sp)
    80004d64:	6105                	addi	sp,sp,32
    80004d66:	8082                	ret
      panic("virtio_disk_intr status");
    80004d68:	00003517          	auipc	a0,0x3
    80004d6c:	99050513          	addi	a0,a0,-1648 # 800076f8 <etext+0x6f8>
    80004d70:	786000ef          	jal	800054f6 <panic>

0000000080004d74 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d74:	1141                	addi	sp,sp,-16
    80004d76:	e406                	sd	ra,8(sp)
    80004d78:	e022                	sd	s0,0(sp)
    80004d7a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d7c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d80:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d84:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d88:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d8c:	577d                	li	a4,-1
    80004d8e:	177e                	slli	a4,a4,0x3f
    80004d90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d92:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d96:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004d9a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004d9e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004da2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004da6:	000f4737          	lui	a4,0xf4
    80004daa:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004dae:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004db0:	14d79073          	csrw	stimecmp,a5
}
    80004db4:	60a2                	ld	ra,8(sp)
    80004db6:	6402                	ld	s0,0(sp)
    80004db8:	0141                	addi	sp,sp,16
    80004dba:	8082                	ret

0000000080004dbc <start>:
{
    80004dbc:	1141                	addi	sp,sp,-16
    80004dbe:	e406                	sd	ra,8(sp)
    80004dc0:	e022                	sd	s0,0(sp)
    80004dc2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004dc4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004dc8:	7779                	lui	a4,0xffffe
    80004dca:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb1bf>
    80004dce:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004dd0:	6705                	lui	a4,0x1
    80004dd2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004dd6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004dd8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ddc:	ffffb797          	auipc	a5,0xffffb
    80004de0:	52878793          	addi	a5,a5,1320 # 80000304 <main>
    80004de4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004de8:	4781                	li	a5,0
    80004dea:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004dee:	67c1                	lui	a5,0x10
    80004df0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004df2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004df6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004dfa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004dfe:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e02:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e06:	57fd                	li	a5,-1
    80004e08:	83a9                	srli	a5,a5,0xa
    80004e0a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e0e:	47bd                	li	a5,15
    80004e10:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e14:	f61ff0ef          	jal	80004d74 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e18:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e1c:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80004e1e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e20:	30200073          	mret
}
    80004e24:	60a2                	ld	ra,8(sp)
    80004e26:	6402                	ld	s0,0(sp)
    80004e28:	0141                	addi	sp,sp,16
    80004e2a:	8082                	ret

0000000080004e2c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e2c:	711d                	addi	sp,sp,-96
    80004e2e:	ec86                	sd	ra,88(sp)
    80004e30:	e8a2                	sd	s0,80(sp)
    80004e32:	e0ca                	sd	s2,64(sp)
    80004e34:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004e36:	04c05863          	blez	a2,80004e86 <consolewrite+0x5a>
    80004e3a:	e4a6                	sd	s1,72(sp)
    80004e3c:	fc4e                	sd	s3,56(sp)
    80004e3e:	f852                	sd	s4,48(sp)
    80004e40:	f456                	sd	s5,40(sp)
    80004e42:	f05a                	sd	s6,32(sp)
    80004e44:	ec5e                	sd	s7,24(sp)
    80004e46:	8a2a                	mv	s4,a0
    80004e48:	84ae                	mv	s1,a1
    80004e4a:	89b2                	mv	s3,a2
    80004e4c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e4e:	faf40b93          	addi	s7,s0,-81
    80004e52:	4b05                	li	s6,1
    80004e54:	5afd                	li	s5,-1
    80004e56:	86da                	mv	a3,s6
    80004e58:	8626                	mv	a2,s1
    80004e5a:	85d2                	mv	a1,s4
    80004e5c:	855e                	mv	a0,s7
    80004e5e:	87dfc0ef          	jal	800016da <either_copyin>
    80004e62:	03550463          	beq	a0,s5,80004e8a <consolewrite+0x5e>
      break;
    uartputc(c);
    80004e66:	faf44503          	lbu	a0,-81(s0)
    80004e6a:	02d000ef          	jal	80005696 <uartputc>
  for(i = 0; i < n; i++){
    80004e6e:	2905                	addiw	s2,s2,1
    80004e70:	0485                	addi	s1,s1,1
    80004e72:	ff2992e3          	bne	s3,s2,80004e56 <consolewrite+0x2a>
    80004e76:	894e                	mv	s2,s3
    80004e78:	64a6                	ld	s1,72(sp)
    80004e7a:	79e2                	ld	s3,56(sp)
    80004e7c:	7a42                	ld	s4,48(sp)
    80004e7e:	7aa2                	ld	s5,40(sp)
    80004e80:	7b02                	ld	s6,32(sp)
    80004e82:	6be2                	ld	s7,24(sp)
    80004e84:	a809                	j	80004e96 <consolewrite+0x6a>
    80004e86:	4901                	li	s2,0
    80004e88:	a039                	j	80004e96 <consolewrite+0x6a>
    80004e8a:	64a6                	ld	s1,72(sp)
    80004e8c:	79e2                	ld	s3,56(sp)
    80004e8e:	7a42                	ld	s4,48(sp)
    80004e90:	7aa2                	ld	s5,40(sp)
    80004e92:	7b02                	ld	s6,32(sp)
    80004e94:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004e96:	854a                	mv	a0,s2
    80004e98:	60e6                	ld	ra,88(sp)
    80004e9a:	6446                	ld	s0,80(sp)
    80004e9c:	6906                	ld	s2,64(sp)
    80004e9e:	6125                	addi	sp,sp,96
    80004ea0:	8082                	ret

0000000080004ea2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004ea2:	711d                	addi	sp,sp,-96
    80004ea4:	ec86                	sd	ra,88(sp)
    80004ea6:	e8a2                	sd	s0,80(sp)
    80004ea8:	e4a6                	sd	s1,72(sp)
    80004eaa:	e0ca                	sd	s2,64(sp)
    80004eac:	fc4e                	sd	s3,56(sp)
    80004eae:	f852                	sd	s4,48(sp)
    80004eb0:	f456                	sd	s5,40(sp)
    80004eb2:	f05a                	sd	s6,32(sp)
    80004eb4:	1080                	addi	s0,sp,96
    80004eb6:	8aaa                	mv	s5,a0
    80004eb8:	8a2e                	mv	s4,a1
    80004eba:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004ebc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004ebe:	0001e517          	auipc	a0,0x1e
    80004ec2:	68250513          	addi	a0,a0,1666 # 80023540 <cons>
    80004ec6:	15f000ef          	jal	80005824 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004eca:	0001e497          	auipc	s1,0x1e
    80004ece:	67648493          	addi	s1,s1,1654 # 80023540 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ed2:	0001e917          	auipc	s2,0x1e
    80004ed6:	70690913          	addi	s2,s2,1798 # 800235d8 <cons+0x98>
  while(n > 0){
    80004eda:	0b305b63          	blez	s3,80004f90 <consoleread+0xee>
    while(cons.r == cons.w){
    80004ede:	0984a783          	lw	a5,152(s1)
    80004ee2:	09c4a703          	lw	a4,156(s1)
    80004ee6:	0af71063          	bne	a4,a5,80004f86 <consoleread+0xe4>
      if(killed(myproc())){
    80004eea:	e77fb0ef          	jal	80000d60 <myproc>
    80004eee:	e84fc0ef          	jal	80001572 <killed>
    80004ef2:	e12d                	bnez	a0,80004f54 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004ef4:	85a6                	mv	a1,s1
    80004ef6:	854a                	mv	a0,s2
    80004ef8:	c42fc0ef          	jal	8000133a <sleep>
    while(cons.r == cons.w){
    80004efc:	0984a783          	lw	a5,152(s1)
    80004f00:	09c4a703          	lw	a4,156(s1)
    80004f04:	fef703e3          	beq	a4,a5,80004eea <consoleread+0x48>
    80004f08:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f0a:	0001e717          	auipc	a4,0x1e
    80004f0e:	63670713          	addi	a4,a4,1590 # 80023540 <cons>
    80004f12:	0017869b          	addiw	a3,a5,1
    80004f16:	08d72c23          	sw	a3,152(a4)
    80004f1a:	07f7f693          	andi	a3,a5,127
    80004f1e:	9736                	add	a4,a4,a3
    80004f20:	01874703          	lbu	a4,24(a4)
    80004f24:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f28:	4691                	li	a3,4
    80004f2a:	04db8663          	beq	s7,a3,80004f76 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f2e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f32:	4685                	li	a3,1
    80004f34:	faf40613          	addi	a2,s0,-81
    80004f38:	85d2                	mv	a1,s4
    80004f3a:	8556                	mv	a0,s5
    80004f3c:	f54fc0ef          	jal	80001690 <either_copyout>
    80004f40:	57fd                	li	a5,-1
    80004f42:	04f50663          	beq	a0,a5,80004f8e <consoleread+0xec>
      break;

    dst++;
    80004f46:	0a05                	addi	s4,s4,1
    --n;
    80004f48:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f4a:	47a9                	li	a5,10
    80004f4c:	04fb8b63          	beq	s7,a5,80004fa2 <consoleread+0x100>
    80004f50:	6be2                	ld	s7,24(sp)
    80004f52:	b761                	j	80004eda <consoleread+0x38>
        release(&cons.lock);
    80004f54:	0001e517          	auipc	a0,0x1e
    80004f58:	5ec50513          	addi	a0,a0,1516 # 80023540 <cons>
    80004f5c:	15d000ef          	jal	800058b8 <release>
        return -1;
    80004f60:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f62:	60e6                	ld	ra,88(sp)
    80004f64:	6446                	ld	s0,80(sp)
    80004f66:	64a6                	ld	s1,72(sp)
    80004f68:	6906                	ld	s2,64(sp)
    80004f6a:	79e2                	ld	s3,56(sp)
    80004f6c:	7a42                	ld	s4,48(sp)
    80004f6e:	7aa2                	ld	s5,40(sp)
    80004f70:	7b02                	ld	s6,32(sp)
    80004f72:	6125                	addi	sp,sp,96
    80004f74:	8082                	ret
      if(n < target){
    80004f76:	0169fa63          	bgeu	s3,s6,80004f8a <consoleread+0xe8>
        cons.r--;
    80004f7a:	0001e717          	auipc	a4,0x1e
    80004f7e:	64f72f23          	sw	a5,1630(a4) # 800235d8 <cons+0x98>
    80004f82:	6be2                	ld	s7,24(sp)
    80004f84:	a031                	j	80004f90 <consoleread+0xee>
    80004f86:	ec5e                	sd	s7,24(sp)
    80004f88:	b749                	j	80004f0a <consoleread+0x68>
    80004f8a:	6be2                	ld	s7,24(sp)
    80004f8c:	a011                	j	80004f90 <consoleread+0xee>
    80004f8e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f90:	0001e517          	auipc	a0,0x1e
    80004f94:	5b050513          	addi	a0,a0,1456 # 80023540 <cons>
    80004f98:	121000ef          	jal	800058b8 <release>
  return target - n;
    80004f9c:	413b053b          	subw	a0,s6,s3
    80004fa0:	b7c9                	j	80004f62 <consoleread+0xc0>
    80004fa2:	6be2                	ld	s7,24(sp)
    80004fa4:	b7f5                	j	80004f90 <consoleread+0xee>

0000000080004fa6 <consputc>:
{
    80004fa6:	1141                	addi	sp,sp,-16
    80004fa8:	e406                	sd	ra,8(sp)
    80004faa:	e022                	sd	s0,0(sp)
    80004fac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fae:	10000793          	li	a5,256
    80004fb2:	00f50863          	beq	a0,a5,80004fc2 <consputc+0x1c>
    uartputc_sync(c);
    80004fb6:	5fe000ef          	jal	800055b4 <uartputc_sync>
}
    80004fba:	60a2                	ld	ra,8(sp)
    80004fbc:	6402                	ld	s0,0(sp)
    80004fbe:	0141                	addi	sp,sp,16
    80004fc0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fc2:	4521                	li	a0,8
    80004fc4:	5f0000ef          	jal	800055b4 <uartputc_sync>
    80004fc8:	02000513          	li	a0,32
    80004fcc:	5e8000ef          	jal	800055b4 <uartputc_sync>
    80004fd0:	4521                	li	a0,8
    80004fd2:	5e2000ef          	jal	800055b4 <uartputc_sync>
    80004fd6:	b7d5                	j	80004fba <consputc+0x14>

0000000080004fd8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004fd8:	7179                	addi	sp,sp,-48
    80004fda:	f406                	sd	ra,40(sp)
    80004fdc:	f022                	sd	s0,32(sp)
    80004fde:	ec26                	sd	s1,24(sp)
    80004fe0:	1800                	addi	s0,sp,48
    80004fe2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004fe4:	0001e517          	auipc	a0,0x1e
    80004fe8:	55c50513          	addi	a0,a0,1372 # 80023540 <cons>
    80004fec:	039000ef          	jal	80005824 <acquire>

  switch(c){
    80004ff0:	47d5                	li	a5,21
    80004ff2:	08f48e63          	beq	s1,a5,8000508e <consoleintr+0xb6>
    80004ff6:	0297c563          	blt	a5,s1,80005020 <consoleintr+0x48>
    80004ffa:	47a1                	li	a5,8
    80004ffc:	0ef48863          	beq	s1,a5,800050ec <consoleintr+0x114>
    80005000:	47c1                	li	a5,16
    80005002:	10f49963          	bne	s1,a5,80005114 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005006:	f1efc0ef          	jal	80001724 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000500a:	0001e517          	auipc	a0,0x1e
    8000500e:	53650513          	addi	a0,a0,1334 # 80023540 <cons>
    80005012:	0a7000ef          	jal	800058b8 <release>
}
    80005016:	70a2                	ld	ra,40(sp)
    80005018:	7402                	ld	s0,32(sp)
    8000501a:	64e2                	ld	s1,24(sp)
    8000501c:	6145                	addi	sp,sp,48
    8000501e:	8082                	ret
  switch(c){
    80005020:	07f00793          	li	a5,127
    80005024:	0cf48463          	beq	s1,a5,800050ec <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005028:	0001e717          	auipc	a4,0x1e
    8000502c:	51870713          	addi	a4,a4,1304 # 80023540 <cons>
    80005030:	0a072783          	lw	a5,160(a4)
    80005034:	09872703          	lw	a4,152(a4)
    80005038:	9f99                	subw	a5,a5,a4
    8000503a:	07f00713          	li	a4,127
    8000503e:	fcf766e3          	bltu	a4,a5,8000500a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005042:	47b5                	li	a5,13
    80005044:	0cf48b63          	beq	s1,a5,8000511a <consoleintr+0x142>
      consputc(c);
    80005048:	8526                	mv	a0,s1
    8000504a:	f5dff0ef          	jal	80004fa6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000504e:	0001e797          	auipc	a5,0x1e
    80005052:	4f278793          	addi	a5,a5,1266 # 80023540 <cons>
    80005056:	0a07a683          	lw	a3,160(a5)
    8000505a:	0016871b          	addiw	a4,a3,1
    8000505e:	863a                	mv	a2,a4
    80005060:	0ae7a023          	sw	a4,160(a5)
    80005064:	07f6f693          	andi	a3,a3,127
    80005068:	97b6                	add	a5,a5,a3
    8000506a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000506e:	47a9                	li	a5,10
    80005070:	0cf48963          	beq	s1,a5,80005142 <consoleintr+0x16a>
    80005074:	4791                	li	a5,4
    80005076:	0cf48663          	beq	s1,a5,80005142 <consoleintr+0x16a>
    8000507a:	0001e797          	auipc	a5,0x1e
    8000507e:	55e7a783          	lw	a5,1374(a5) # 800235d8 <cons+0x98>
    80005082:	9f1d                	subw	a4,a4,a5
    80005084:	08000793          	li	a5,128
    80005088:	f8f711e3          	bne	a4,a5,8000500a <consoleintr+0x32>
    8000508c:	a85d                	j	80005142 <consoleintr+0x16a>
    8000508e:	e84a                	sd	s2,16(sp)
    80005090:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005092:	0001e717          	auipc	a4,0x1e
    80005096:	4ae70713          	addi	a4,a4,1198 # 80023540 <cons>
    8000509a:	0a072783          	lw	a5,160(a4)
    8000509e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050a2:	0001e497          	auipc	s1,0x1e
    800050a6:	49e48493          	addi	s1,s1,1182 # 80023540 <cons>
    while(cons.e != cons.w &&
    800050aa:	4929                	li	s2,10
      consputc(BACKSPACE);
    800050ac:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800050b0:	02f70863          	beq	a4,a5,800050e0 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050b4:	37fd                	addiw	a5,a5,-1
    800050b6:	07f7f713          	andi	a4,a5,127
    800050ba:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050bc:	01874703          	lbu	a4,24(a4)
    800050c0:	03270363          	beq	a4,s2,800050e6 <consoleintr+0x10e>
      cons.e--;
    800050c4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050c8:	854e                	mv	a0,s3
    800050ca:	eddff0ef          	jal	80004fa6 <consputc>
    while(cons.e != cons.w &&
    800050ce:	0a04a783          	lw	a5,160(s1)
    800050d2:	09c4a703          	lw	a4,156(s1)
    800050d6:	fcf71fe3          	bne	a4,a5,800050b4 <consoleintr+0xdc>
    800050da:	6942                	ld	s2,16(sp)
    800050dc:	69a2                	ld	s3,8(sp)
    800050de:	b735                	j	8000500a <consoleintr+0x32>
    800050e0:	6942                	ld	s2,16(sp)
    800050e2:	69a2                	ld	s3,8(sp)
    800050e4:	b71d                	j	8000500a <consoleintr+0x32>
    800050e6:	6942                	ld	s2,16(sp)
    800050e8:	69a2                	ld	s3,8(sp)
    800050ea:	b705                	j	8000500a <consoleintr+0x32>
    if(cons.e != cons.w){
    800050ec:	0001e717          	auipc	a4,0x1e
    800050f0:	45470713          	addi	a4,a4,1108 # 80023540 <cons>
    800050f4:	0a072783          	lw	a5,160(a4)
    800050f8:	09c72703          	lw	a4,156(a4)
    800050fc:	f0f707e3          	beq	a4,a5,8000500a <consoleintr+0x32>
      cons.e--;
    80005100:	37fd                	addiw	a5,a5,-1
    80005102:	0001e717          	auipc	a4,0x1e
    80005106:	4cf72f23          	sw	a5,1246(a4) # 800235e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000510a:	10000513          	li	a0,256
    8000510e:	e99ff0ef          	jal	80004fa6 <consputc>
    80005112:	bde5                	j	8000500a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005114:	ee048be3          	beqz	s1,8000500a <consoleintr+0x32>
    80005118:	bf01                	j	80005028 <consoleintr+0x50>
      consputc(c);
    8000511a:	4529                	li	a0,10
    8000511c:	e8bff0ef          	jal	80004fa6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005120:	0001e797          	auipc	a5,0x1e
    80005124:	42078793          	addi	a5,a5,1056 # 80023540 <cons>
    80005128:	0a07a703          	lw	a4,160(a5)
    8000512c:	0017069b          	addiw	a3,a4,1
    80005130:	8636                	mv	a2,a3
    80005132:	0ad7a023          	sw	a3,160(a5)
    80005136:	07f77713          	andi	a4,a4,127
    8000513a:	97ba                	add	a5,a5,a4
    8000513c:	4729                	li	a4,10
    8000513e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005142:	0001e797          	auipc	a5,0x1e
    80005146:	48c7ad23          	sw	a2,1178(a5) # 800235dc <cons+0x9c>
        wakeup(&cons.r);
    8000514a:	0001e517          	auipc	a0,0x1e
    8000514e:	48e50513          	addi	a0,a0,1166 # 800235d8 <cons+0x98>
    80005152:	a34fc0ef          	jal	80001386 <wakeup>
    80005156:	bd55                	j	8000500a <consoleintr+0x32>

0000000080005158 <consoleinit>:

void
consoleinit(void)
{
    80005158:	1141                	addi	sp,sp,-16
    8000515a:	e406                	sd	ra,8(sp)
    8000515c:	e022                	sd	s0,0(sp)
    8000515e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005160:	00002597          	auipc	a1,0x2
    80005164:	5b058593          	addi	a1,a1,1456 # 80007710 <etext+0x710>
    80005168:	0001e517          	auipc	a0,0x1e
    8000516c:	3d850513          	addi	a0,a0,984 # 80023540 <cons>
    80005170:	630000ef          	jal	800057a0 <initlock>

  uartinit();
    80005174:	3ea000ef          	jal	8000555e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005178:	00015797          	auipc	a5,0x15
    8000517c:	23078793          	addi	a5,a5,560 # 8001a3a8 <devsw>
    80005180:	00000717          	auipc	a4,0x0
    80005184:	d2270713          	addi	a4,a4,-734 # 80004ea2 <consoleread>
    80005188:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000518a:	00000717          	auipc	a4,0x0
    8000518e:	ca270713          	addi	a4,a4,-862 # 80004e2c <consolewrite>
    80005192:	ef98                	sd	a4,24(a5)
}
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000519c:	7179                	addi	sp,sp,-48
    8000519e:	f406                	sd	ra,40(sp)
    800051a0:	f022                	sd	s0,32(sp)
    800051a2:	ec26                	sd	s1,24(sp)
    800051a4:	e84a                	sd	s2,16(sp)
    800051a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051a8:	c219                	beqz	a2,800051ae <printint+0x12>
    800051aa:	06054a63          	bltz	a0,8000521e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800051ae:	4e01                	li	t3,0

  i = 0;
    800051b0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800051b4:	869a                	mv	a3,t1
  i = 0;
    800051b6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051b8:	00002817          	auipc	a6,0x2
    800051bc:	6c080813          	addi	a6,a6,1728 # 80007878 <digits>
    800051c0:	88be                	mv	a7,a5
    800051c2:	0017861b          	addiw	a2,a5,1
    800051c6:	87b2                	mv	a5,a2
    800051c8:	02b57733          	remu	a4,a0,a1
    800051cc:	9742                	add	a4,a4,a6
    800051ce:	00074703          	lbu	a4,0(a4)
    800051d2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051d6:	872a                	mv	a4,a0
    800051d8:	02b55533          	divu	a0,a0,a1
    800051dc:	0685                	addi	a3,a3,1
    800051de:	feb771e3          	bgeu	a4,a1,800051c0 <printint+0x24>

  if(sign)
    800051e2:	000e0c63          	beqz	t3,800051fa <printint+0x5e>
    buf[i++] = '-';
    800051e6:	fe060793          	addi	a5,a2,-32
    800051ea:	00878633          	add	a2,a5,s0
    800051ee:	02d00793          	li	a5,45
    800051f2:	fef60823          	sb	a5,-16(a2)
    800051f6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800051fa:	fff7891b          	addiw	s2,a5,-1
    800051fe:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005202:	fff4c503          	lbu	a0,-1(s1)
    80005206:	da1ff0ef          	jal	80004fa6 <consputc>
  while(--i >= 0)
    8000520a:	397d                	addiw	s2,s2,-1
    8000520c:	14fd                	addi	s1,s1,-1
    8000520e:	fe095ae3          	bgez	s2,80005202 <printint+0x66>
}
    80005212:	70a2                	ld	ra,40(sp)
    80005214:	7402                	ld	s0,32(sp)
    80005216:	64e2                	ld	s1,24(sp)
    80005218:	6942                	ld	s2,16(sp)
    8000521a:	6145                	addi	sp,sp,48
    8000521c:	8082                	ret
    x = -xx;
    8000521e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005222:	4e05                	li	t3,1
    x = -xx;
    80005224:	b771                	j	800051b0 <printint+0x14>

0000000080005226 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005226:	7155                	addi	sp,sp,-208
    80005228:	e506                	sd	ra,136(sp)
    8000522a:	e122                	sd	s0,128(sp)
    8000522c:	f0d2                	sd	s4,96(sp)
    8000522e:	0900                	addi	s0,sp,144
    80005230:	8a2a                	mv	s4,a0
    80005232:	e40c                	sd	a1,8(s0)
    80005234:	e810                	sd	a2,16(s0)
    80005236:	ec14                	sd	a3,24(s0)
    80005238:	f018                	sd	a4,32(s0)
    8000523a:	f41c                	sd	a5,40(s0)
    8000523c:	03043823          	sd	a6,48(s0)
    80005240:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005244:	0001e797          	auipc	a5,0x1e
    80005248:	3bc7a783          	lw	a5,956(a5) # 80023600 <pr+0x18>
    8000524c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005250:	e3a1                	bnez	a5,80005290 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005252:	00840793          	addi	a5,s0,8
    80005256:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000525a:	00054503          	lbu	a0,0(a0)
    8000525e:	26050663          	beqz	a0,800054ca <printf+0x2a4>
    80005262:	fca6                	sd	s1,120(sp)
    80005264:	f8ca                	sd	s2,112(sp)
    80005266:	f4ce                	sd	s3,104(sp)
    80005268:	ecd6                	sd	s5,88(sp)
    8000526a:	e8da                	sd	s6,80(sp)
    8000526c:	e0e2                	sd	s8,64(sp)
    8000526e:	fc66                	sd	s9,56(sp)
    80005270:	f86a                	sd	s10,48(sp)
    80005272:	f46e                	sd	s11,40(sp)
    80005274:	4981                	li	s3,0
    if(cx != '%'){
    80005276:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000527a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000527e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005282:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005286:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000528a:	07000d93          	li	s11,112
    8000528e:	a80d                	j	800052c0 <printf+0x9a>
    acquire(&pr.lock);
    80005290:	0001e517          	auipc	a0,0x1e
    80005294:	35850513          	addi	a0,a0,856 # 800235e8 <pr>
    80005298:	58c000ef          	jal	80005824 <acquire>
  va_start(ap, fmt);
    8000529c:	00840793          	addi	a5,s0,8
    800052a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052a4:	000a4503          	lbu	a0,0(s4)
    800052a8:	fd4d                	bnez	a0,80005262 <printf+0x3c>
    800052aa:	ac3d                	j	800054e8 <printf+0x2c2>
      consputc(cx);
    800052ac:	cfbff0ef          	jal	80004fa6 <consputc>
      continue;
    800052b0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052b2:	2485                	addiw	s1,s1,1
    800052b4:	89a6                	mv	s3,s1
    800052b6:	94d2                	add	s1,s1,s4
    800052b8:	0004c503          	lbu	a0,0(s1)
    800052bc:	1e050b63          	beqz	a0,800054b2 <printf+0x28c>
    if(cx != '%'){
    800052c0:	ff5516e3          	bne	a0,s5,800052ac <printf+0x86>
    i++;
    800052c4:	0019879b          	addiw	a5,s3,1
    800052c8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800052ca:	00fa0733          	add	a4,s4,a5
    800052ce:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052d2:	1e090063          	beqz	s2,800054b2 <printf+0x28c>
    800052d6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800052da:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800052dc:	c701                	beqz	a4,800052e4 <printf+0xbe>
    800052de:	97d2                	add	a5,a5,s4
    800052e0:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800052e4:	03690763          	beq	s2,s6,80005312 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    800052e8:	05890163          	beq	s2,s8,8000532a <printf+0x104>
    } else if(c0 == 'u'){
    800052ec:	0d990b63          	beq	s2,s9,800053c2 <printf+0x19c>
    } else if(c0 == 'x'){
    800052f0:	13a90163          	beq	s2,s10,80005412 <printf+0x1ec>
    } else if(c0 == 'p'){
    800052f4:	13b90b63          	beq	s2,s11,8000542a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800052f8:	07300793          	li	a5,115
    800052fc:	16f90a63          	beq	s2,a5,80005470 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005300:	1b590463          	beq	s2,s5,800054a8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005304:	8556                	mv	a0,s5
    80005306:	ca1ff0ef          	jal	80004fa6 <consputc>
      consputc(c0);
    8000530a:	854a                	mv	a0,s2
    8000530c:	c9bff0ef          	jal	80004fa6 <consputc>
    80005310:	b74d                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005312:	f8843783          	ld	a5,-120(s0)
    80005316:	00878713          	addi	a4,a5,8
    8000531a:	f8e43423          	sd	a4,-120(s0)
    8000531e:	4605                	li	a2,1
    80005320:	45a9                	li	a1,10
    80005322:	4388                	lw	a0,0(a5)
    80005324:	e79ff0ef          	jal	8000519c <printint>
    80005328:	b769                	j	800052b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000532a:	03670663          	beq	a4,s6,80005356 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000532e:	05870263          	beq	a4,s8,80005372 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005332:	0b970463          	beq	a4,s9,800053da <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005336:	fda717e3          	bne	a4,s10,80005304 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000533a:	f8843783          	ld	a5,-120(s0)
    8000533e:	00878713          	addi	a4,a5,8
    80005342:	f8e43423          	sd	a4,-120(s0)
    80005346:	4601                	li	a2,0
    80005348:	45c1                	li	a1,16
    8000534a:	6388                	ld	a0,0(a5)
    8000534c:	e51ff0ef          	jal	8000519c <printint>
      i += 1;
    80005350:	0029849b          	addiw	s1,s3,2
    80005354:	bfb9                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005356:	f8843783          	ld	a5,-120(s0)
    8000535a:	00878713          	addi	a4,a5,8
    8000535e:	f8e43423          	sd	a4,-120(s0)
    80005362:	4605                	li	a2,1
    80005364:	45a9                	li	a1,10
    80005366:	6388                	ld	a0,0(a5)
    80005368:	e35ff0ef          	jal	8000519c <printint>
      i += 1;
    8000536c:	0029849b          	addiw	s1,s3,2
    80005370:	b789                	j	800052b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005372:	06400793          	li	a5,100
    80005376:	02f68863          	beq	a3,a5,800053a6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000537a:	07500793          	li	a5,117
    8000537e:	06f68c63          	beq	a3,a5,800053f6 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005382:	07800793          	li	a5,120
    80005386:	f6f69fe3          	bne	a3,a5,80005304 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000538a:	f8843783          	ld	a5,-120(s0)
    8000538e:	00878713          	addi	a4,a5,8
    80005392:	f8e43423          	sd	a4,-120(s0)
    80005396:	4601                	li	a2,0
    80005398:	45c1                	li	a1,16
    8000539a:	6388                	ld	a0,0(a5)
    8000539c:	e01ff0ef          	jal	8000519c <printint>
      i += 2;
    800053a0:	0039849b          	addiw	s1,s3,3
    800053a4:	b739                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053a6:	f8843783          	ld	a5,-120(s0)
    800053aa:	00878713          	addi	a4,a5,8
    800053ae:	f8e43423          	sd	a4,-120(s0)
    800053b2:	4605                	li	a2,1
    800053b4:	45a9                	li	a1,10
    800053b6:	6388                	ld	a0,0(a5)
    800053b8:	de5ff0ef          	jal	8000519c <printint>
      i += 2;
    800053bc:	0039849b          	addiw	s1,s3,3
    800053c0:	bdcd                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800053c2:	f8843783          	ld	a5,-120(s0)
    800053c6:	00878713          	addi	a4,a5,8
    800053ca:	f8e43423          	sd	a4,-120(s0)
    800053ce:	4601                	li	a2,0
    800053d0:	45a9                	li	a1,10
    800053d2:	4388                	lw	a0,0(a5)
    800053d4:	dc9ff0ef          	jal	8000519c <printint>
    800053d8:	bde9                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053da:	f8843783          	ld	a5,-120(s0)
    800053de:	00878713          	addi	a4,a5,8
    800053e2:	f8e43423          	sd	a4,-120(s0)
    800053e6:	4601                	li	a2,0
    800053e8:	45a9                	li	a1,10
    800053ea:	6388                	ld	a0,0(a5)
    800053ec:	db1ff0ef          	jal	8000519c <printint>
      i += 1;
    800053f0:	0029849b          	addiw	s1,s3,2
    800053f4:	bd7d                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053f6:	f8843783          	ld	a5,-120(s0)
    800053fa:	00878713          	addi	a4,a5,8
    800053fe:	f8e43423          	sd	a4,-120(s0)
    80005402:	4601                	li	a2,0
    80005404:	45a9                	li	a1,10
    80005406:	6388                	ld	a0,0(a5)
    80005408:	d95ff0ef          	jal	8000519c <printint>
      i += 2;
    8000540c:	0039849b          	addiw	s1,s3,3
    80005410:	b54d                	j	800052b2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005412:	f8843783          	ld	a5,-120(s0)
    80005416:	00878713          	addi	a4,a5,8
    8000541a:	f8e43423          	sd	a4,-120(s0)
    8000541e:	4601                	li	a2,0
    80005420:	45c1                	li	a1,16
    80005422:	4388                	lw	a0,0(a5)
    80005424:	d79ff0ef          	jal	8000519c <printint>
    80005428:	b569                	j	800052b2 <printf+0x8c>
    8000542a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000542c:	f8843783          	ld	a5,-120(s0)
    80005430:	00878713          	addi	a4,a5,8
    80005434:	f8e43423          	sd	a4,-120(s0)
    80005438:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000543c:	03000513          	li	a0,48
    80005440:	b67ff0ef          	jal	80004fa6 <consputc>
  consputc('x');
    80005444:	07800513          	li	a0,120
    80005448:	b5fff0ef          	jal	80004fa6 <consputc>
    8000544c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000544e:	00002b97          	auipc	s7,0x2
    80005452:	42ab8b93          	addi	s7,s7,1066 # 80007878 <digits>
    80005456:	03c9d793          	srli	a5,s3,0x3c
    8000545a:	97de                	add	a5,a5,s7
    8000545c:	0007c503          	lbu	a0,0(a5)
    80005460:	b47ff0ef          	jal	80004fa6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005464:	0992                	slli	s3,s3,0x4
    80005466:	397d                	addiw	s2,s2,-1
    80005468:	fe0917e3          	bnez	s2,80005456 <printf+0x230>
    8000546c:	6ba6                	ld	s7,72(sp)
    8000546e:	b591                	j	800052b2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005470:	f8843783          	ld	a5,-120(s0)
    80005474:	00878713          	addi	a4,a5,8
    80005478:	f8e43423          	sd	a4,-120(s0)
    8000547c:	0007b903          	ld	s2,0(a5)
    80005480:	00090d63          	beqz	s2,8000549a <printf+0x274>
      for(; *s; s++)
    80005484:	00094503          	lbu	a0,0(s2)
    80005488:	e20505e3          	beqz	a0,800052b2 <printf+0x8c>
        consputc(*s);
    8000548c:	b1bff0ef          	jal	80004fa6 <consputc>
      for(; *s; s++)
    80005490:	0905                	addi	s2,s2,1
    80005492:	00094503          	lbu	a0,0(s2)
    80005496:	f97d                	bnez	a0,8000548c <printf+0x266>
    80005498:	bd29                	j	800052b2 <printf+0x8c>
        s = "(null)";
    8000549a:	00002917          	auipc	s2,0x2
    8000549e:	27e90913          	addi	s2,s2,638 # 80007718 <etext+0x718>
      for(; *s; s++)
    800054a2:	02800513          	li	a0,40
    800054a6:	b7dd                	j	8000548c <printf+0x266>
      consputc('%');
    800054a8:	02500513          	li	a0,37
    800054ac:	afbff0ef          	jal	80004fa6 <consputc>
    800054b0:	b509                	j	800052b2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800054b2:	f7843783          	ld	a5,-136(s0)
    800054b6:	e385                	bnez	a5,800054d6 <printf+0x2b0>
    800054b8:	74e6                	ld	s1,120(sp)
    800054ba:	7946                	ld	s2,112(sp)
    800054bc:	79a6                	ld	s3,104(sp)
    800054be:	6ae6                	ld	s5,88(sp)
    800054c0:	6b46                	ld	s6,80(sp)
    800054c2:	6c06                	ld	s8,64(sp)
    800054c4:	7ce2                	ld	s9,56(sp)
    800054c6:	7d42                	ld	s10,48(sp)
    800054c8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800054ca:	4501                	li	a0,0
    800054cc:	60aa                	ld	ra,136(sp)
    800054ce:	640a                	ld	s0,128(sp)
    800054d0:	7a06                	ld	s4,96(sp)
    800054d2:	6169                	addi	sp,sp,208
    800054d4:	8082                	ret
    800054d6:	74e6                	ld	s1,120(sp)
    800054d8:	7946                	ld	s2,112(sp)
    800054da:	79a6                	ld	s3,104(sp)
    800054dc:	6ae6                	ld	s5,88(sp)
    800054de:	6b46                	ld	s6,80(sp)
    800054e0:	6c06                	ld	s8,64(sp)
    800054e2:	7ce2                	ld	s9,56(sp)
    800054e4:	7d42                	ld	s10,48(sp)
    800054e6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800054e8:	0001e517          	auipc	a0,0x1e
    800054ec:	10050513          	addi	a0,a0,256 # 800235e8 <pr>
    800054f0:	3c8000ef          	jal	800058b8 <release>
    800054f4:	bfd9                	j	800054ca <printf+0x2a4>

00000000800054f6 <panic>:

void
panic(char *s)
{
    800054f6:	1101                	addi	sp,sp,-32
    800054f8:	ec06                	sd	ra,24(sp)
    800054fa:	e822                	sd	s0,16(sp)
    800054fc:	e426                	sd	s1,8(sp)
    800054fe:	1000                	addi	s0,sp,32
    80005500:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005502:	0001e797          	auipc	a5,0x1e
    80005506:	0e07af23          	sw	zero,254(a5) # 80023600 <pr+0x18>
  printf("panic: ");
    8000550a:	00002517          	auipc	a0,0x2
    8000550e:	21650513          	addi	a0,a0,534 # 80007720 <etext+0x720>
    80005512:	d15ff0ef          	jal	80005226 <printf>
  printf("%s\n", s);
    80005516:	85a6                	mv	a1,s1
    80005518:	00002517          	auipc	a0,0x2
    8000551c:	21050513          	addi	a0,a0,528 # 80007728 <etext+0x728>
    80005520:	d07ff0ef          	jal	80005226 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005524:	4785                	li	a5,1
    80005526:	00005717          	auipc	a4,0x5
    8000552a:	dcf72b23          	sw	a5,-554(a4) # 8000a2fc <panicked>
  for(;;)
    8000552e:	a001                	j	8000552e <panic+0x38>

0000000080005530 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005530:	1101                	addi	sp,sp,-32
    80005532:	ec06                	sd	ra,24(sp)
    80005534:	e822                	sd	s0,16(sp)
    80005536:	e426                	sd	s1,8(sp)
    80005538:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000553a:	0001e497          	auipc	s1,0x1e
    8000553e:	0ae48493          	addi	s1,s1,174 # 800235e8 <pr>
    80005542:	00002597          	auipc	a1,0x2
    80005546:	1ee58593          	addi	a1,a1,494 # 80007730 <etext+0x730>
    8000554a:	8526                	mv	a0,s1
    8000554c:	254000ef          	jal	800057a0 <initlock>
  pr.locking = 1;
    80005550:	4785                	li	a5,1
    80005552:	cc9c                	sw	a5,24(s1)
}
    80005554:	60e2                	ld	ra,24(sp)
    80005556:	6442                	ld	s0,16(sp)
    80005558:	64a2                	ld	s1,8(sp)
    8000555a:	6105                	addi	sp,sp,32
    8000555c:	8082                	ret

000000008000555e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000555e:	1141                	addi	sp,sp,-16
    80005560:	e406                	sd	ra,8(sp)
    80005562:	e022                	sd	s0,0(sp)
    80005564:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005566:	100007b7          	lui	a5,0x10000
    8000556a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000556e:	10000737          	lui	a4,0x10000
    80005572:	f8000693          	li	a3,-128
    80005576:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000557a:	468d                	li	a3,3
    8000557c:	10000637          	lui	a2,0x10000
    80005580:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005584:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005588:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000558c:	8732                	mv	a4,a2
    8000558e:	461d                	li	a2,7
    80005590:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005594:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005598:	00002597          	auipc	a1,0x2
    8000559c:	1a058593          	addi	a1,a1,416 # 80007738 <etext+0x738>
    800055a0:	0001e517          	auipc	a0,0x1e
    800055a4:	06850513          	addi	a0,a0,104 # 80023608 <uart_tx_lock>
    800055a8:	1f8000ef          	jal	800057a0 <initlock>
}
    800055ac:	60a2                	ld	ra,8(sp)
    800055ae:	6402                	ld	s0,0(sp)
    800055b0:	0141                	addi	sp,sp,16
    800055b2:	8082                	ret

00000000800055b4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800055b4:	1101                	addi	sp,sp,-32
    800055b6:	ec06                	sd	ra,24(sp)
    800055b8:	e822                	sd	s0,16(sp)
    800055ba:	e426                	sd	s1,8(sp)
    800055bc:	1000                	addi	s0,sp,32
    800055be:	84aa                	mv	s1,a0
  push_off();
    800055c0:	224000ef          	jal	800057e4 <push_off>

  if(panicked){
    800055c4:	00005797          	auipc	a5,0x5
    800055c8:	d387a783          	lw	a5,-712(a5) # 8000a2fc <panicked>
    800055cc:	e795                	bnez	a5,800055f8 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800055ce:	10000737          	lui	a4,0x10000
    800055d2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800055d4:	00074783          	lbu	a5,0(a4)
    800055d8:	0207f793          	andi	a5,a5,32
    800055dc:	dfe5                	beqz	a5,800055d4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800055de:	0ff4f513          	zext.b	a0,s1
    800055e2:	100007b7          	lui	a5,0x10000
    800055e6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800055ea:	27e000ef          	jal	80005868 <pop_off>
}
    800055ee:	60e2                	ld	ra,24(sp)
    800055f0:	6442                	ld	s0,16(sp)
    800055f2:	64a2                	ld	s1,8(sp)
    800055f4:	6105                	addi	sp,sp,32
    800055f6:	8082                	ret
    for(;;)
    800055f8:	a001                	j	800055f8 <uartputc_sync+0x44>

00000000800055fa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800055fa:	00005797          	auipc	a5,0x5
    800055fe:	d067b783          	ld	a5,-762(a5) # 8000a300 <uart_tx_r>
    80005602:	00005717          	auipc	a4,0x5
    80005606:	d0673703          	ld	a4,-762(a4) # 8000a308 <uart_tx_w>
    8000560a:	08f70163          	beq	a4,a5,8000568c <uartstart+0x92>
{
    8000560e:	7139                	addi	sp,sp,-64
    80005610:	fc06                	sd	ra,56(sp)
    80005612:	f822                	sd	s0,48(sp)
    80005614:	f426                	sd	s1,40(sp)
    80005616:	f04a                	sd	s2,32(sp)
    80005618:	ec4e                	sd	s3,24(sp)
    8000561a:	e852                	sd	s4,16(sp)
    8000561c:	e456                	sd	s5,8(sp)
    8000561e:	e05a                	sd	s6,0(sp)
    80005620:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005622:	10000937          	lui	s2,0x10000
    80005626:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005628:	0001ea97          	auipc	s5,0x1e
    8000562c:	fe0a8a93          	addi	s5,s5,-32 # 80023608 <uart_tx_lock>
    uart_tx_r += 1;
    80005630:	00005497          	auipc	s1,0x5
    80005634:	cd048493          	addi	s1,s1,-816 # 8000a300 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005638:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000563c:	00005997          	auipc	s3,0x5
    80005640:	ccc98993          	addi	s3,s3,-820 # 8000a308 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005644:	00094703          	lbu	a4,0(s2)
    80005648:	02077713          	andi	a4,a4,32
    8000564c:	c715                	beqz	a4,80005678 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000564e:	01f7f713          	andi	a4,a5,31
    80005652:	9756                	add	a4,a4,s5
    80005654:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005658:	0785                	addi	a5,a5,1
    8000565a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000565c:	8526                	mv	a0,s1
    8000565e:	d29fb0ef          	jal	80001386 <wakeup>
    WriteReg(THR, c);
    80005662:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005666:	609c                	ld	a5,0(s1)
    80005668:	0009b703          	ld	a4,0(s3)
    8000566c:	fcf71ce3          	bne	a4,a5,80005644 <uartstart+0x4a>
      ReadReg(ISR);
    80005670:	100007b7          	lui	a5,0x10000
    80005674:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005678:	70e2                	ld	ra,56(sp)
    8000567a:	7442                	ld	s0,48(sp)
    8000567c:	74a2                	ld	s1,40(sp)
    8000567e:	7902                	ld	s2,32(sp)
    80005680:	69e2                	ld	s3,24(sp)
    80005682:	6a42                	ld	s4,16(sp)
    80005684:	6aa2                	ld	s5,8(sp)
    80005686:	6b02                	ld	s6,0(sp)
    80005688:	6121                	addi	sp,sp,64
    8000568a:	8082                	ret
      ReadReg(ISR);
    8000568c:	100007b7          	lui	a5,0x10000
    80005690:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005694:	8082                	ret

0000000080005696 <uartputc>:
{
    80005696:	7179                	addi	sp,sp,-48
    80005698:	f406                	sd	ra,40(sp)
    8000569a:	f022                	sd	s0,32(sp)
    8000569c:	ec26                	sd	s1,24(sp)
    8000569e:	e84a                	sd	s2,16(sp)
    800056a0:	e44e                	sd	s3,8(sp)
    800056a2:	e052                	sd	s4,0(sp)
    800056a4:	1800                	addi	s0,sp,48
    800056a6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800056a8:	0001e517          	auipc	a0,0x1e
    800056ac:	f6050513          	addi	a0,a0,-160 # 80023608 <uart_tx_lock>
    800056b0:	174000ef          	jal	80005824 <acquire>
  if(panicked){
    800056b4:	00005797          	auipc	a5,0x5
    800056b8:	c487a783          	lw	a5,-952(a5) # 8000a2fc <panicked>
    800056bc:	efbd                	bnez	a5,8000573a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056be:	00005717          	auipc	a4,0x5
    800056c2:	c4a73703          	ld	a4,-950(a4) # 8000a308 <uart_tx_w>
    800056c6:	00005797          	auipc	a5,0x5
    800056ca:	c3a7b783          	ld	a5,-966(a5) # 8000a300 <uart_tx_r>
    800056ce:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800056d2:	0001e997          	auipc	s3,0x1e
    800056d6:	f3698993          	addi	s3,s3,-202 # 80023608 <uart_tx_lock>
    800056da:	00005497          	auipc	s1,0x5
    800056de:	c2648493          	addi	s1,s1,-986 # 8000a300 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056e2:	00005917          	auipc	s2,0x5
    800056e6:	c2690913          	addi	s2,s2,-986 # 8000a308 <uart_tx_w>
    800056ea:	00e79d63          	bne	a5,a4,80005704 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800056ee:	85ce                	mv	a1,s3
    800056f0:	8526                	mv	a0,s1
    800056f2:	c49fb0ef          	jal	8000133a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056f6:	00093703          	ld	a4,0(s2)
    800056fa:	609c                	ld	a5,0(s1)
    800056fc:	02078793          	addi	a5,a5,32
    80005700:	fee787e3          	beq	a5,a4,800056ee <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005704:	0001e497          	auipc	s1,0x1e
    80005708:	f0448493          	addi	s1,s1,-252 # 80023608 <uart_tx_lock>
    8000570c:	01f77793          	andi	a5,a4,31
    80005710:	97a6                	add	a5,a5,s1
    80005712:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005716:	0705                	addi	a4,a4,1
    80005718:	00005797          	auipc	a5,0x5
    8000571c:	bee7b823          	sd	a4,-1040(a5) # 8000a308 <uart_tx_w>
  uartstart();
    80005720:	edbff0ef          	jal	800055fa <uartstart>
  release(&uart_tx_lock);
    80005724:	8526                	mv	a0,s1
    80005726:	192000ef          	jal	800058b8 <release>
}
    8000572a:	70a2                	ld	ra,40(sp)
    8000572c:	7402                	ld	s0,32(sp)
    8000572e:	64e2                	ld	s1,24(sp)
    80005730:	6942                	ld	s2,16(sp)
    80005732:	69a2                	ld	s3,8(sp)
    80005734:	6a02                	ld	s4,0(sp)
    80005736:	6145                	addi	sp,sp,48
    80005738:	8082                	ret
    for(;;)
    8000573a:	a001                	j	8000573a <uartputc+0xa4>

000000008000573c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000573c:	1141                	addi	sp,sp,-16
    8000573e:	e406                	sd	ra,8(sp)
    80005740:	e022                	sd	s0,0(sp)
    80005742:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005744:	100007b7          	lui	a5,0x10000
    80005748:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000574c:	8b85                	andi	a5,a5,1
    8000574e:	cb89                	beqz	a5,80005760 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005750:	100007b7          	lui	a5,0x10000
    80005754:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005758:	60a2                	ld	ra,8(sp)
    8000575a:	6402                	ld	s0,0(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret
    return -1;
    80005760:	557d                	li	a0,-1
    80005762:	bfdd                	j	80005758 <uartgetc+0x1c>

0000000080005764 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005764:	1101                	addi	sp,sp,-32
    80005766:	ec06                	sd	ra,24(sp)
    80005768:	e822                	sd	s0,16(sp)
    8000576a:	e426                	sd	s1,8(sp)
    8000576c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000576e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005770:	fcdff0ef          	jal	8000573c <uartgetc>
    if(c == -1)
    80005774:	00950563          	beq	a0,s1,8000577e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005778:	861ff0ef          	jal	80004fd8 <consoleintr>
  while(1){
    8000577c:	bfd5                	j	80005770 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000577e:	0001e497          	auipc	s1,0x1e
    80005782:	e8a48493          	addi	s1,s1,-374 # 80023608 <uart_tx_lock>
    80005786:	8526                	mv	a0,s1
    80005788:	09c000ef          	jal	80005824 <acquire>
  uartstart();
    8000578c:	e6fff0ef          	jal	800055fa <uartstart>
  release(&uart_tx_lock);
    80005790:	8526                	mv	a0,s1
    80005792:	126000ef          	jal	800058b8 <release>
}
    80005796:	60e2                	ld	ra,24(sp)
    80005798:	6442                	ld	s0,16(sp)
    8000579a:	64a2                	ld	s1,8(sp)
    8000579c:	6105                	addi	sp,sp,32
    8000579e:	8082                	ret

00000000800057a0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057a0:	1141                	addi	sp,sp,-16
    800057a2:	e406                	sd	ra,8(sp)
    800057a4:	e022                	sd	s0,0(sp)
    800057a6:	0800                	addi	s0,sp,16
  lk->name = name;
    800057a8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057aa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057ae:	00053823          	sd	zero,16(a0)
}
    800057b2:	60a2                	ld	ra,8(sp)
    800057b4:	6402                	ld	s0,0(sp)
    800057b6:	0141                	addi	sp,sp,16
    800057b8:	8082                	ret

00000000800057ba <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800057ba:	411c                	lw	a5,0(a0)
    800057bc:	e399                	bnez	a5,800057c2 <holding+0x8>
    800057be:	4501                	li	a0,0
  return r;
}
    800057c0:	8082                	ret
{
    800057c2:	1101                	addi	sp,sp,-32
    800057c4:	ec06                	sd	ra,24(sp)
    800057c6:	e822                	sd	s0,16(sp)
    800057c8:	e426                	sd	s1,8(sp)
    800057ca:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800057cc:	6904                	ld	s1,16(a0)
    800057ce:	d72fb0ef          	jal	80000d40 <mycpu>
    800057d2:	40a48533          	sub	a0,s1,a0
    800057d6:	00153513          	seqz	a0,a0
}
    800057da:	60e2                	ld	ra,24(sp)
    800057dc:	6442                	ld	s0,16(sp)
    800057de:	64a2                	ld	s1,8(sp)
    800057e0:	6105                	addi	sp,sp,32
    800057e2:	8082                	ret

00000000800057e4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800057e4:	1101                	addi	sp,sp,-32
    800057e6:	ec06                	sd	ra,24(sp)
    800057e8:	e822                	sd	s0,16(sp)
    800057ea:	e426                	sd	s1,8(sp)
    800057ec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057ee:	100024f3          	csrr	s1,sstatus
    800057f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800057f6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057f8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800057fc:	d44fb0ef          	jal	80000d40 <mycpu>
    80005800:	5d3c                	lw	a5,120(a0)
    80005802:	cb99                	beqz	a5,80005818 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005804:	d3cfb0ef          	jal	80000d40 <mycpu>
    80005808:	5d3c                	lw	a5,120(a0)
    8000580a:	2785                	addiw	a5,a5,1
    8000580c:	dd3c                	sw	a5,120(a0)
}
    8000580e:	60e2                	ld	ra,24(sp)
    80005810:	6442                	ld	s0,16(sp)
    80005812:	64a2                	ld	s1,8(sp)
    80005814:	6105                	addi	sp,sp,32
    80005816:	8082                	ret
    mycpu()->intena = old;
    80005818:	d28fb0ef          	jal	80000d40 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000581c:	8085                	srli	s1,s1,0x1
    8000581e:	8885                	andi	s1,s1,1
    80005820:	dd64                	sw	s1,124(a0)
    80005822:	b7cd                	j	80005804 <push_off+0x20>

0000000080005824 <acquire>:
{
    80005824:	1101                	addi	sp,sp,-32
    80005826:	ec06                	sd	ra,24(sp)
    80005828:	e822                	sd	s0,16(sp)
    8000582a:	e426                	sd	s1,8(sp)
    8000582c:	1000                	addi	s0,sp,32
    8000582e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005830:	fb5ff0ef          	jal	800057e4 <push_off>
  if(holding(lk))
    80005834:	8526                	mv	a0,s1
    80005836:	f85ff0ef          	jal	800057ba <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000583a:	4705                	li	a4,1
  if(holding(lk))
    8000583c:	e105                	bnez	a0,8000585c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000583e:	87ba                	mv	a5,a4
    80005840:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005844:	2781                	sext.w	a5,a5
    80005846:	ffe5                	bnez	a5,8000583e <acquire+0x1a>
  __sync_synchronize();
    80005848:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000584c:	cf4fb0ef          	jal	80000d40 <mycpu>
    80005850:	e888                	sd	a0,16(s1)
}
    80005852:	60e2                	ld	ra,24(sp)
    80005854:	6442                	ld	s0,16(sp)
    80005856:	64a2                	ld	s1,8(sp)
    80005858:	6105                	addi	sp,sp,32
    8000585a:	8082                	ret
    panic("acquire");
    8000585c:	00002517          	auipc	a0,0x2
    80005860:	ee450513          	addi	a0,a0,-284 # 80007740 <etext+0x740>
    80005864:	c93ff0ef          	jal	800054f6 <panic>

0000000080005868 <pop_off>:

void
pop_off(void)
{
    80005868:	1141                	addi	sp,sp,-16
    8000586a:	e406                	sd	ra,8(sp)
    8000586c:	e022                	sd	s0,0(sp)
    8000586e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005870:	cd0fb0ef          	jal	80000d40 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005874:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005878:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000587a:	e39d                	bnez	a5,800058a0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000587c:	5d3c                	lw	a5,120(a0)
    8000587e:	02f05763          	blez	a5,800058ac <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005882:	37fd                	addiw	a5,a5,-1
    80005884:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005886:	eb89                	bnez	a5,80005898 <pop_off+0x30>
    80005888:	5d7c                	lw	a5,124(a0)
    8000588a:	c799                	beqz	a5,80005898 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000588c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005890:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005894:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005898:	60a2                	ld	ra,8(sp)
    8000589a:	6402                	ld	s0,0(sp)
    8000589c:	0141                	addi	sp,sp,16
    8000589e:	8082                	ret
    panic("pop_off - interruptible");
    800058a0:	00002517          	auipc	a0,0x2
    800058a4:	ea850513          	addi	a0,a0,-344 # 80007748 <etext+0x748>
    800058a8:	c4fff0ef          	jal	800054f6 <panic>
    panic("pop_off");
    800058ac:	00002517          	auipc	a0,0x2
    800058b0:	eb450513          	addi	a0,a0,-332 # 80007760 <etext+0x760>
    800058b4:	c43ff0ef          	jal	800054f6 <panic>

00000000800058b8 <release>:
{
    800058b8:	1101                	addi	sp,sp,-32
    800058ba:	ec06                	sd	ra,24(sp)
    800058bc:	e822                	sd	s0,16(sp)
    800058be:	e426                	sd	s1,8(sp)
    800058c0:	1000                	addi	s0,sp,32
    800058c2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800058c4:	ef7ff0ef          	jal	800057ba <holding>
    800058c8:	c105                	beqz	a0,800058e8 <release+0x30>
  lk->cpu = 0;
    800058ca:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800058ce:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800058d2:	0310000f          	fence	rw,w
    800058d6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800058da:	f8fff0ef          	jal	80005868 <pop_off>
}
    800058de:	60e2                	ld	ra,24(sp)
    800058e0:	6442                	ld	s0,16(sp)
    800058e2:	64a2                	ld	s1,8(sp)
    800058e4:	6105                	addi	sp,sp,32
    800058e6:	8082                	ret
    panic("release");
    800058e8:	00002517          	auipc	a0,0x2
    800058ec:	e8050513          	addi	a0,a0,-384 # 80007768 <etext+0x768>
    800058f0:	c07ff0ef          	jal	800054f6 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
