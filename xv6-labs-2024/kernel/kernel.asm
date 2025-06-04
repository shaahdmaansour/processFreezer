
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	57010113          	addi	sp,sp,1392 # 8001b570 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	617040ef          	jal	80004e2c <start>

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
    80000034:	64078793          	addi	a5,a5,1600 # 80023670 <end>
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
    80000050:	2f490913          	addi	s2,s2,756 # 8000a340 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	03f050ef          	jal	80005894 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	0c3050ef          	jal	80005928 <release>
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
    8000007e:	4e8050ef          	jal	80005566 <panic>

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
    800000de:	26650513          	addi	a0,a0,614 # 8000a340 <kmem>
    800000e2:	72e050ef          	jal	80005810 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	58650513          	addi	a0,a0,1414 # 80023670 <end>
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
    8000010c:	23848493          	addi	s1,s1,568 # 8000a340 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	782050ef          	jal	80005894 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	22450513          	addi	a0,a0,548 # 8000a340 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	003050ef          	jal	80005928 <release>

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
    80000144:	20050513          	addi	a0,a0,512 # 8000a340 <kmem>
    80000148:	7e0050ef          	jal	80005928 <release>
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
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb991>
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
    80000314:	00070713          	mv	a4,a4
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
    80000332:	765040ef          	jal	80005296 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	51c010ef          	jal	80001856 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	53a040ef          	jal	80004878 <plicinithart>
  }

  scheduler();        
    80000342:	653000ef          	jal	80001194 <scheduler>
    consoleinit();
    80000346:	683040ef          	jal	800051c8 <consoleinit>
    printfinit();
    8000034a:	256050ef          	jal	800055a0 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	741040ef          	jal	80005296 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	735040ef          	jal	80005296 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	729040ef          	jal	80005296 <printf>
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
    8000038a:	4d4040ef          	jal	8000485e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	4ea040ef          	jal	80004878 <plicinithart>
    binit();         // buffer cache
    80000392:	44d010ef          	jal	80001fde <binit>
    iinit();         // inode table
    80000396:	218020ef          	jal	800025ae <iinit>
    fileinit();      // file table
    8000039a:	7e7020ef          	jal	80003380 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	5ca040ef          	jal	80004968 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	427000ef          	jal	80000fc8 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	f6f72223          	sw	a5,-156(a4) # 8000a310 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
    800003be:	12000073          	sfence.vma
    800003c2:	0000a797          	auipc	a5,0xa
    800003c6:	f567b783          	ld	a5,-170(a5) # 8000a318 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
    800003d2:	18079073          	csrw	satp,a5
    800003d6:	12000073          	sfence.vma
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
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
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    80000402:	4b31                	li	s6,12
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
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
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	116050ef          	jal	80005566 <panic>
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    80000484:	4501                	li	a0,0
    80000486:	8082                	ret
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
    80000498:	611c                	ld	a5,0(a0)
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
    800004a0:	4501                	li	a0,0
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>
    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
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
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
    800004f2:	4b85                	li	s7,1
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
    8000051e:	9962                	add	s2,s2,s8
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	03c050ef          	jal	80005566 <panic>
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	030050ef          	jal	80005566 <panic>
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	024050ef          	jal	80005566 <panic>
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	018050ef          	jal	80005566 <panic>
    80000552:	557d                	li	a0,-1
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
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	7d3040ef          	jal	80005566 <panic>

0000000080000598 <kvmmake>:
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
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
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
    80000630:	8526                	mv	a0,s1
    80000632:	5a8000ef          	jal	80000bda <proc_mapstacks>
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
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	0000a797          	auipc	a5,0xa
    80000654:	cca7b423          	sd	a0,-824(a5) # 8000a318 <kernel_pagetable>
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
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
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
    80000686:	4b85                	li	s7,1
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
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	6bf040ef          	jal	80005566 <panic>
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	6b3040ef          	jal	80005566 <panic>
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	6a7040ef          	jal	80005566 <panic>
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	69b040ef          	jal	80005566 <panic>
    800006d0:	0004b023          	sd	zero,0(s1)
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>
    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
    800006fc:	8129                	srli	a0,a0,0xa
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
    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <uvmcreate>:
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	1000                	addi	s0,sp,32
    80000726:	9d9ff0ef          	jal	800000fe <kalloc>
    8000072a:	84aa                	mv	s1,a0
    8000072c:	c509                	beqz	a0,80000736 <uvmcreate+0x1a>
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
    80000736:	8526                	mv	a0,s1
    80000738:	60e2                	ld	ra,24(sp)
    8000073a:	6442                	ld	s0,16(sp)
    8000073c:	64a2                	ld	s1,8(sp)
    8000073e:	6105                	addi	sp,sp,32
    80000740:	8082                	ret

0000000080000742 <uvmfirst>:
    80000742:	7179                	addi	sp,sp,-48
    80000744:	f406                	sd	ra,40(sp)
    80000746:	f022                	sd	s0,32(sp)
    80000748:	ec26                	sd	s1,24(sp)
    8000074a:	e84a                	sd	s2,16(sp)
    8000074c:	e44e                	sd	s3,8(sp)
    8000074e:	e052                	sd	s4,0(sp)
    80000750:	1800                	addi	s0,sp,48
    80000752:	6785                	lui	a5,0x1
    80000754:	04f67063          	bgeu	a2,a5,80000794 <uvmfirst+0x52>
    80000758:	8a2a                	mv	s4,a0
    8000075a:	89ae                	mv	s3,a1
    8000075c:	84b2                	mv	s1,a2
    8000075e:	9a1ff0ef          	jal	800000fe <kalloc>
    80000762:	892a                	mv	s2,a0
    80000764:	6605                	lui	a2,0x1
    80000766:	4581                	li	a1,0
    80000768:	9e7ff0ef          	jal	8000014e <memset>
    8000076c:	4779                	li	a4,30
    8000076e:	86ca                	mv	a3,s2
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	8552                	mv	a0,s4
    80000776:	d45ff0ef          	jal	800004ba <mappages>
    8000077a:	8626                	mv	a2,s1
    8000077c:	85ce                	mv	a1,s3
    8000077e:	854a                	mv	a0,s2
    80000780:	a33ff0ef          	jal	800001b2 <memmove>
    80000784:	70a2                	ld	ra,40(sp)
    80000786:	7402                	ld	s0,32(sp)
    80000788:	64e2                	ld	s1,24(sp)
    8000078a:	6942                	ld	s2,16(sp)
    8000078c:	69a2                	ld	s3,8(sp)
    8000078e:	6a02                	ld	s4,0(sp)
    80000790:	6145                	addi	sp,sp,48
    80000792:	8082                	ret
    80000794:	00007517          	auipc	a0,0x7
    80000798:	98450513          	addi	a0,a0,-1660 # 80007118 <etext+0x118>
    8000079c:	5cb040ef          	jal	80005566 <panic>

00000000800007a0 <uvmdealloc>:
    800007a0:	1101                	addi	sp,sp,-32
    800007a2:	ec06                	sd	ra,24(sp)
    800007a4:	e822                	sd	s0,16(sp)
    800007a6:	e426                	sd	s1,8(sp)
    800007a8:	1000                	addi	s0,sp,32
    800007aa:	84ae                	mv	s1,a1
    800007ac:	00b67d63          	bgeu	a2,a1,800007c6 <uvmdealloc+0x26>
    800007b0:	84b2                	mv	s1,a2
    800007b2:	6785                	lui	a5,0x1
    800007b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b6:	00f60733          	add	a4,a2,a5
    800007ba:	76fd                	lui	a3,0xfffff
    800007bc:	8f75                	and	a4,a4,a3
    800007be:	97ae                	add	a5,a5,a1
    800007c0:	8ff5                	and	a5,a5,a3
    800007c2:	00f76863          	bltu	a4,a5,800007d2 <uvmdealloc+0x32>
    800007c6:	8526                	mv	a0,s1
    800007c8:	60e2                	ld	ra,24(sp)
    800007ca:	6442                	ld	s0,16(sp)
    800007cc:	64a2                	ld	s1,8(sp)
    800007ce:	6105                	addi	sp,sp,32
    800007d0:	8082                	ret
    800007d2:	8f99                	sub	a5,a5,a4
    800007d4:	83b1                	srli	a5,a5,0xc
    800007d6:	4685                	li	a3,1
    800007d8:	0007861b          	sext.w	a2,a5
    800007dc:	85ba                	mv	a1,a4
    800007de:	e83ff0ef          	jal	80000660 <uvmunmap>
    800007e2:	b7d5                	j	800007c6 <uvmdealloc+0x26>

00000000800007e4 <uvmalloc>:
    800007e4:	0ab66363          	bltu	a2,a1,8000088a <uvmalloc+0xa6>
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
    80000806:	08ca7463          	bgeu	s4,a2,8000088e <uvmalloc+0xaa>
    8000080a:	fc26                	sd	s1,56(sp)
    8000080c:	f84a                	sd	s2,48(sp)
    8000080e:	f44e                	sd	s3,40(sp)
    80000810:	e45e                	sd	s7,8(sp)
    80000812:	8952                	mv	s2,s4
    80000814:	6985                	lui	s3,0x1
    80000816:	0126eb93          	ori	s7,a3,18
    8000081a:	8e5ff0ef          	jal	800000fe <kalloc>
    8000081e:	84aa                	mv	s1,a0
    80000820:	c515                	beqz	a0,8000084c <uvmalloc+0x68>
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
    8000083a:	994e                	add	s2,s2,s3
    8000083c:	fd596fe3          	bltu	s2,s5,8000081a <uvmalloc+0x36>
    80000840:	8556                	mv	a0,s5
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	6ba2                	ld	s7,8(sp)
    8000084a:	a819                	j	80000860 <uvmalloc+0x7c>
    8000084c:	8652                	mv	a2,s4
    8000084e:	85ca                	mv	a1,s2
    80000850:	855a                	mv	a0,s6
    80000852:	f4fff0ef          	jal	800007a0 <uvmdealloc>
    80000856:	4501                	li	a0,0
    80000858:	74e2                	ld	s1,56(sp)
    8000085a:	7942                	ld	s2,48(sp)
    8000085c:	79a2                	ld	s3,40(sp)
    8000085e:	6ba2                	ld	s7,8(sp)
    80000860:	60a6                	ld	ra,72(sp)
    80000862:	6406                	ld	s0,64(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret
    8000086e:	8526                	mv	a0,s1
    80000870:	facff0ef          	jal	8000001c <kfree>
    80000874:	8652                	mv	a2,s4
    80000876:	85ca                	mv	a1,s2
    80000878:	855a                	mv	a0,s6
    8000087a:	f27ff0ef          	jal	800007a0 <uvmdealloc>
    8000087e:	4501                	li	a0,0
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	6ba2                	ld	s7,8(sp)
    80000888:	bfe1                	j	80000860 <uvmalloc+0x7c>
    8000088a:	852e                	mv	a0,a1
    8000088c:	8082                	ret
    8000088e:	8532                	mv	a0,a2
    80000890:	bfc1                	j	80000860 <uvmalloc+0x7c>

0000000080000892 <freewalk>:
    80000892:	7179                	addi	sp,sp,-48
    80000894:	f406                	sd	ra,40(sp)
    80000896:	f022                	sd	s0,32(sp)
    80000898:	ec26                	sd	s1,24(sp)
    8000089a:	e84a                	sd	s2,16(sp)
    8000089c:	e44e                	sd	s3,8(sp)
    8000089e:	e052                	sd	s4,0(sp)
    800008a0:	1800                	addi	s0,sp,48
    800008a2:	8a2a                	mv	s4,a0
    800008a4:	84aa                	mv	s1,a0
    800008a6:	6905                	lui	s2,0x1
    800008a8:	992a                	add	s2,s2,a0
    800008aa:	4985                	li	s3,1
    800008ac:	a819                	j	800008c2 <freewalk+0x30>
    800008ae:	83a9                	srli	a5,a5,0xa
    800008b0:	00c79513          	slli	a0,a5,0xc
    800008b4:	fdfff0ef          	jal	80000892 <freewalk>
    800008b8:	0004b023          	sd	zero,0(s1)
    800008bc:	04a1                	addi	s1,s1,8
    800008be:	01248f63          	beq	s1,s2,800008dc <freewalk+0x4a>
    800008c2:	609c                	ld	a5,0(s1)
    800008c4:	00f7f713          	andi	a4,a5,15
    800008c8:	ff3703e3          	beq	a4,s3,800008ae <freewalk+0x1c>
    800008cc:	8b85                	andi	a5,a5,1
    800008ce:	d7fd                	beqz	a5,800008bc <freewalk+0x2a>
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	86850513          	addi	a0,a0,-1944 # 80007138 <etext+0x138>
    800008d8:	48f040ef          	jal	80005566 <panic>
    800008dc:	8552                	mv	a0,s4
    800008de:	f3eff0ef          	jal	8000001c <kfree>
    800008e2:	70a2                	ld	ra,40(sp)
    800008e4:	7402                	ld	s0,32(sp)
    800008e6:	64e2                	ld	s1,24(sp)
    800008e8:	6942                	ld	s2,16(sp)
    800008ea:	69a2                	ld	s3,8(sp)
    800008ec:	6a02                	ld	s4,0(sp)
    800008ee:	6145                	addi	sp,sp,48
    800008f0:	8082                	ret

00000000800008f2 <uvmfree>:
    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
    800008fc:	84aa                	mv	s1,a0
    800008fe:	e989                	bnez	a1,80000910 <uvmfree+0x1e>
    80000900:	8526                	mv	a0,s1
    80000902:	f91ff0ef          	jal	80000892 <freewalk>
    80000906:	60e2                	ld	ra,24(sp)
    80000908:	6442                	ld	s0,16(sp)
    8000090a:	64a2                	ld	s1,8(sp)
    8000090c:	6105                	addi	sp,sp,32
    8000090e:	8082                	ret
    80000910:	6785                	lui	a5,0x1
    80000912:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000914:	95be                	add	a1,a1,a5
    80000916:	4685                	li	a3,1
    80000918:	00c5d613          	srli	a2,a1,0xc
    8000091c:	4581                	li	a1,0
    8000091e:	d43ff0ef          	jal	80000660 <uvmunmap>
    80000922:	bff9                	j	80000900 <uvmfree+0xe>

0000000080000924 <uvmcopy>:
    80000924:	ca4d                	beqz	a2,800009d6 <uvmcopy+0xb2>
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
    80000946:	6a05                	lui	s4,0x1
    80000948:	4601                	li	a2,0
    8000094a:	85ce                	mv	a1,s3
    8000094c:	855e                	mv	a0,s7
    8000094e:	a95ff0ef          	jal	800003e2 <walk>
    80000952:	cd1d                	beqz	a0,80000990 <uvmcopy+0x6c>
    80000954:	6118                	ld	a4,0(a0)
    80000956:	00177793          	andi	a5,a4,1
    8000095a:	c3a9                	beqz	a5,8000099c <uvmcopy+0x78>
    8000095c:	00a75593          	srli	a1,a4,0xa
    80000960:	00c59c13          	slli	s8,a1,0xc
    80000964:	3ff77493          	andi	s1,a4,1023
    80000968:	f96ff0ef          	jal	800000fe <kalloc>
    8000096c:	892a                	mv	s2,a0
    8000096e:	c121                	beqz	a0,800009ae <uvmcopy+0x8a>
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
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	3cf040ef          	jal	80005566 <panic>
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	3c3040ef          	jal	80005566 <panic>
    800009a8:	854a                	mv	a0,s2
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
    800009ae:	4685                	li	a3,1
    800009b0:	00c9d613          	srli	a2,s3,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	855a                	mv	a0,s6
    800009b8:	ca9ff0ef          	jal	80000660 <uvmunmap>
    800009bc:	557d                	li	a0,-1
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
    800009d6:	4501                	li	a0,0
    800009d8:	8082                	ret

00000000800009da <uvmclear>:
    800009da:	1141                	addi	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	addi	s0,sp,16
    800009e2:	4601                	li	a2,0
    800009e4:	9ffff0ef          	jal	800003e2 <walk>
    800009e8:	c901                	beqz	a0,800009f8 <uvmclear+0x1e>
    800009ea:	611c                	ld	a5,0(a0)
    800009ec:	9bbd                	andi	a5,a5,-17
    800009ee:	e11c                	sd	a5,0(a0)
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    800009f8:	00006517          	auipc	a0,0x6
    800009fc:	79050513          	addi	a0,a0,1936 # 80007188 <etext+0x188>
    80000a00:	367040ef          	jal	80005566 <panic>

0000000080000a04 <copyout>:
    80000a04:	c2d9                	beqz	a3,80000a8a <copyout+0x86>
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
    80000a2a:	7cfd                	lui	s9,0xfffff
    80000a2c:	5bfd                	li	s7,-1
    80000a2e:	01abdb93          	srli	s7,s7,0x1a
    80000a32:	4d55                	li	s10,21
    80000a34:	6b05                	lui	s6,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x56>
    80000a38:	83a9                	srli	a5,a5,0xa
    80000a3a:	07b2                	slli	a5,a5,0xc
    80000a3c:	41390533          	sub	a0,s2,s3
    80000a40:	0004861b          	sext.w	a2,s1
    80000a44:	85d6                	mv	a1,s5
    80000a46:	953e                	add	a0,a0,a5
    80000a48:	f6aff0ef          	jal	800001b2 <memmove>
    80000a4c:	409a0a33          	sub	s4,s4,s1
    80000a50:	9aa6                	add	s5,s5,s1
    80000a52:	01698933          	add	s2,s3,s6
    80000a56:	020a0863          	beqz	s4,80000a86 <copyout+0x82>
    80000a5a:	019979b3          	and	s3,s2,s9
    80000a5e:	033be863          	bltu	s7,s3,80000a8e <copyout+0x8a>
    80000a62:	4601                	li	a2,0
    80000a64:	85ce                	mv	a1,s3
    80000a66:	8562                	mv	a0,s8
    80000a68:	97bff0ef          	jal	800003e2 <walk>
    80000a6c:	c121                	beqz	a0,80000aac <copyout+0xa8>
    80000a6e:	611c                	ld	a5,0(a0)
    80000a70:	0157f713          	andi	a4,a5,21
    80000a74:	03a71e63          	bne	a4,s10,80000ab0 <copyout+0xac>
    80000a78:	412984b3          	sub	s1,s3,s2
    80000a7c:	94da                	add	s1,s1,s6
    80000a7e:	fa9a7de3          	bgeu	s4,s1,80000a38 <copyout+0x34>
    80000a82:	84d2                	mv	s1,s4
    80000a84:	bf55                	j	80000a38 <copyout+0x34>
    80000a86:	4501                	li	a0,0
    80000a88:	a021                	j	80000a90 <copyout+0x8c>
    80000a8a:	4501                	li	a0,0
    80000a8c:	8082                	ret
    80000a8e:	557d                	li	a0,-1
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
    80000aac:	557d                	li	a0,-1
    80000aae:	b7cd                	j	80000a90 <copyout+0x8c>
    80000ab0:	557d                	li	a0,-1
    80000ab2:	bff9                	j	80000a90 <copyout+0x8c>

0000000080000ab4 <copyin>:
    80000ab4:	c6a5                	beqz	a3,80000b1c <copyin+0x68>
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
    80000ad6:	7bfd                	lui	s7,0xfffff
    80000ad8:	6a85                	lui	s5,0x1
    80000ada:	a00d                	j	80000afc <copyin+0x48>
    80000adc:	018505b3          	add	a1,a0,s8
    80000ae0:	0004861b          	sext.w	a2,s1
    80000ae4:	412585b3          	sub	a1,a1,s2
    80000ae8:	8552                	mv	a0,s4
    80000aea:	ec8ff0ef          	jal	800001b2 <memmove>
    80000aee:	409989b3          	sub	s3,s3,s1
    80000af2:	9a26                	add	s4,s4,s1
    80000af4:	01590c33          	add	s8,s2,s5
    80000af8:	02098063          	beqz	s3,80000b18 <copyin+0x64>
    80000afc:	017c7933          	and	s2,s8,s7
    80000b00:	85ca                	mv	a1,s2
    80000b02:	855a                	mv	a0,s6
    80000b04:	979ff0ef          	jal	8000047c <walkaddr>
    80000b08:	cd01                	beqz	a0,80000b20 <copyin+0x6c>
    80000b0a:	418904b3          	sub	s1,s2,s8
    80000b0e:	94d6                	add	s1,s1,s5
    80000b10:	fc99f6e3          	bgeu	s3,s1,80000adc <copyin+0x28>
    80000b14:	84ce                	mv	s1,s3
    80000b16:	b7d9                	j	80000adc <copyin+0x28>
    80000b18:	4501                	li	a0,0
    80000b1a:	a021                	j	80000b22 <copyin+0x6e>
    80000b1c:	4501                	li	a0,0
    80000b1e:	8082                	ret
    80000b20:	557d                	li	a0,-1
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
    80000b58:	7b7d                	lui	s6,0xfffff
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a02d                	j	80000b86 <copyinstr+0x4c>
    80000b5e:	00078023          	sb	zero,0(a5)
    80000b62:	4785                	li	a5,1
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
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
    80000b82:	01490bb3          	add	s7,s2,s4
    80000b86:	c4b1                	beqz	s1,80000bd2 <copyinstr+0x98>
    80000b88:	016bf933          	and	s2,s7,s6
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	8556                	mv	a0,s5
    80000b90:	8edff0ef          	jal	8000047c <walkaddr>
    80000b94:	c129                	beqz	a0,80000bd6 <copyinstr+0x9c>
    80000b96:	41790633          	sub	a2,s2,s7
    80000b9a:	9652                	add	a2,a2,s4
    80000b9c:	00c4f363          	bgeu	s1,a2,80000ba2 <copyinstr+0x68>
    80000ba0:	8626                	mv	a2,s1
    80000ba2:	412b8bb3          	sub	s7,s7,s2
    80000ba6:	9baa                	add	s7,s7,a0
    80000ba8:	de69                	beqz	a2,80000b82 <copyinstr+0x48>
    80000baa:	87ce                	mv	a5,s3
    80000bac:	413b86b3          	sub	a3,s7,s3
    80000bb0:	964e                	add	a2,a2,s3
    80000bb2:	85be                	mv	a1,a5
    80000bb4:	00f68733          	add	a4,a3,a5
    80000bb8:	00074703          	lbu	a4,0(a4)
    80000bbc:	d34d                	beqz	a4,80000b5e <copyinstr+0x24>
    80000bbe:	00e78023          	sb	a4,0(a5)
    80000bc2:	0785                	addi	a5,a5,1
    80000bc4:	fec797e3          	bne	a5,a2,80000bb2 <copyinstr+0x78>
    80000bc8:	14fd                	addi	s1,s1,-1
    80000bca:	94ce                	add	s1,s1,s3
    80000bcc:	8c8d                	sub	s1,s1,a1
    80000bce:	89be                	mv	s3,a5
    80000bd0:	bf4d                	j	80000b82 <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	bf41                	j	80000b64 <copyinstr+0x2a>
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
    80000bf8:	b9c48493          	addi	s1,s1,-1124 # 8000a790 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000c02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f81935>
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
    80000c22:	572a8a93          	addi	s5,s5,1394 # 80010190 <tickslock>
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
    80000c74:	0f3040ef          	jal	80005566 <panic>

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
    80000c98:	6cc50513          	addi	a0,a0,1740 # 8000a360 <pid_lock>
    80000c9c:	375040ef          	jal	80005810 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00009517          	auipc	a0,0x9
    80000cac:	6d050513          	addi	a0,a0,1744 # 8000a378 <wait_lock>
    80000cb0:	361040ef          	jal	80005810 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	0000a497          	auipc	s1,0xa
    80000cb8:	adc48493          	addi	s1,s1,-1316 # 8000a790 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	a4fa57b7          	lui	a5,0xa4fa5
    80000cca:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f81935>
    80000cce:	4fa50937          	lui	s2,0x4fa50
    80000cd2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	0000fa17          	auipc	s4,0xf
    80000ce6:	4aea0a13          	addi	s4,s4,1198 # 80010190 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	323040ef          	jal	80005810 <initlock>
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
    80000d52:	64250513          	addi	a0,a0,1602 # 8000a390 <cpus>
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
    80000d6a:	2eb040ef          	jal	80005854 <push_off>
    80000d6e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d70:	2781                	sext.w	a5,a5
    80000d72:	079e                	slli	a5,a5,0x7
    80000d74:	00009717          	auipc	a4,0x9
    80000d78:	5ec70713          	addi	a4,a4,1516 # 8000a360 <pid_lock>
    80000d7c:	97ba                	add	a5,a5,a4
    80000d7e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d80:	359040ef          	jal	800058d8 <pop_off>
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
    80000d9c:	38d040ef          	jal	80005928 <release>

  if (first) {
    80000da0:	00009797          	auipc	a5,0x9
    80000da4:	5207a783          	lw	a5,1312(a5) # 8000a2c0 <first.1>
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
    80000db8:	78a010ef          	jal	80002542 <fsinit>
    first = 0;
    80000dbc:	00009797          	auipc	a5,0x9
    80000dc0:	5007a223          	sw	zero,1284(a5) # 8000a2c0 <first.1>
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
    80000dda:	58a90913          	addi	s2,s2,1418 # 8000a360 <pid_lock>
    80000dde:	854a                	mv	a0,s2
    80000de0:	2b5040ef          	jal	80005894 <acquire>
  pid = nextpid;
    80000de4:	00009797          	auipc	a5,0x9
    80000de8:	4e078793          	addi	a5,a5,1248 # 8000a2c4 <nextpid>
    80000dec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dee:	0014871b          	addiw	a4,s1,1
    80000df2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df4:	854a                	mv	a0,s2
    80000df6:	333040ef          	jal	80005928 <release>
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
    80000f32:	86248493          	addi	s1,s1,-1950 # 8000a790 <proc>
    80000f36:	0000f917          	auipc	s2,0xf
    80000f3a:	25a90913          	addi	s2,s2,602 # 80010190 <tickslock>
    acquire(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	155040ef          	jal	80005894 <acquire>
    if(p->state == UNUSED) {
    80000f44:	4c9c                	lw	a5,24(s1)
    80000f46:	cb91                	beqz	a5,80000f5a <allocproc+0x38>
      release(&p->lock);
    80000f48:	8526                	mv	a0,s1
    80000f4a:	1df040ef          	jal	80005928 <release>
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
    80000fb0:	179040ef          	jal	80005928 <release>
    return 0;
    80000fb4:	84ca                	mv	s1,s2
    80000fb6:	b7d5                	j	80000f9a <allocproc+0x78>
    freeproc(p);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	f19ff0ef          	jal	80000ed2 <freeproc>
    release(&p->lock);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	169040ef          	jal	80005928 <release>
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
    80000fdc:	34a7b423          	sd	a0,840(a5) # 8000a320 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe0:	03400613          	li	a2,52
    80000fe4:	00009597          	auipc	a1,0x9
    80000fe8:	2ec58593          	addi	a1,a1,748 # 8000a2d0 <initcode>
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
    8000101a:	64d010ef          	jal	80002e66 <namei>
    8000101e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001022:	478d                	li	a5,3
    80001024:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001026:	8526                	mv	a0,s1
    80001028:	101040ef          	jal	80005928 <release>
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
    8000110e:	01b040ef          	jal	80005928 <release>
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
    80001124:	2de020ef          	jal	80003402 <filedup>
    80001128:	00a93023          	sd	a0,0(s2)
    8000112c:	b7f5                	j	80001118 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112e:	150ab503          	ld	a0,336(s5)
    80001132:	60e010ef          	jal	80002740 <idup>
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
    8000114e:	7da040ef          	jal	80005928 <release>
  acquire(&wait_lock);
    80001152:	00009497          	auipc	s1,0x9
    80001156:	22648493          	addi	s1,s1,550 # 8000a378 <wait_lock>
    8000115a:	8526                	mv	a0,s1
    8000115c:	738040ef          	jal	80005894 <acquire>
  np->parent = p;
    80001160:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001164:	8526                	mv	a0,s1
    80001166:	7c2040ef          	jal	80005928 <release>
  acquire(&np->lock);
    8000116a:	8552                	mv	a0,s4
    8000116c:	728040ef          	jal	80005894 <acquire>
  np->state = RUNNABLE;
    80001170:	478d                	li	a5,3
    80001172:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001176:	8552                	mv	a0,s4
    80001178:	7b0040ef          	jal	80005928 <release>
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
    800011b8:	1ac70713          	addi	a4,a4,428 # 8000a360 <pid_lock>
    800011bc:	975e                	add	a4,a4,s7
    800011be:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c2:	00009717          	auipc	a4,0x9
    800011c6:	1d670713          	addi	a4,a4,470 # 8000a398 <cpus+0x8>
    800011ca:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE) {
    800011cc:	498d                	li	s3,3
        c->proc = p;
    800011ce:	079e                	slli	a5,a5,0x7
    800011d0:	00009a17          	auipc	s4,0x9
    800011d4:	190a0a13          	addi	s4,s4,400 # 8000a360 <pid_lock>
    800011d8:	9a3e                	add	s4,s4,a5
        found = 1;
    800011da:	4c05                	li	s8,1
    800011dc:	a899                	j	80001232 <scheduler+0x9e>
        release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	748040ef          	jal	80005928 <release>
        continue;
    800011e4:	a021                	j	800011ec <scheduler+0x58>
      release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	740040ef          	jal	80005928 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ec:	16848493          	addi	s1,s1,360
    800011f0:	03248763          	beq	s1,s2,8000121e <scheduler+0x8a>
      acquire(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	69e040ef          	jal	80005894 <acquire>
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
    80001244:	55048493          	addi	s1,s1,1360 # 8000a790 <proc>
        p->state = RUNNING;
    80001248:	4b11                	li	s6,4
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124a:	0000f917          	auipc	s2,0xf
    8000124e:	f4690913          	addi	s2,s2,-186 # 80010190 <tickslock>
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
    80001268:	5c2040ef          	jal	8000582a <holding>
    8000126c:	c92d                	beqz	a0,800012de <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000126e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001270:	2781                	sext.w	a5,a5
    80001272:	079e                	slli	a5,a5,0x7
    80001274:	00009717          	auipc	a4,0x9
    80001278:	0ec70713          	addi	a4,a4,236 # 8000a360 <pid_lock>
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
    8000129e:	0c690913          	addi	s2,s2,198 # 8000a360 <pid_lock>
    800012a2:	2781                	sext.w	a5,a5
    800012a4:	079e                	slli	a5,a5,0x7
    800012a6:	97ca                	add	a5,a5,s2
    800012a8:	0ac7a983          	lw	s3,172(a5)
    800012ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012ae:	2781                	sext.w	a5,a5
    800012b0:	079e                	slli	a5,a5,0x7
    800012b2:	00009597          	auipc	a1,0x9
    800012b6:	0e658593          	addi	a1,a1,230 # 8000a398 <cpus+0x8>
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
    800012e6:	280040ef          	jal	80005566 <panic>
    panic("sched locks");
    800012ea:	00006517          	auipc	a0,0x6
    800012ee:	efe50513          	addi	a0,a0,-258 # 800071e8 <etext+0x1e8>
    800012f2:	274040ef          	jal	80005566 <panic>
    panic("sched running");
    800012f6:	00006517          	auipc	a0,0x6
    800012fa:	f0250513          	addi	a0,a0,-254 # 800071f8 <etext+0x1f8>
    800012fe:	268040ef          	jal	80005566 <panic>
    panic("sched interruptible");
    80001302:	00006517          	auipc	a0,0x6
    80001306:	f0650513          	addi	a0,a0,-250 # 80007208 <etext+0x208>
    8000130a:	25c040ef          	jal	80005566 <panic>

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
    8000131e:	576040ef          	jal	80005894 <acquire>
  p->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	cc9c                	sw	a5,24(s1)
  sched();
    80001326:	f2fff0ef          	jal	80001254 <sched>
  release(&p->lock);
    8000132a:	8526                	mv	a0,s1
    8000132c:	5fc040ef          	jal	80005928 <release>
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
    80001352:	542040ef          	jal	80005894 <acquire>
  release(lk);
    80001356:	854a                	mv	a0,s2
    80001358:	5d0040ef          	jal	80005928 <release>

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
    8000136e:	5ba040ef          	jal	80005928 <release>
  acquire(lk);
    80001372:	854a                	mv	a0,s2
    80001374:	520040ef          	jal	80005894 <acquire>
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
    8000139e:	3f648493          	addi	s1,s1,1014 # 8000a790 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013a2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013a4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	0000f917          	auipc	s2,0xf
    800013aa:	dea90913          	addi	s2,s2,-534 # 80010190 <tickslock>
    800013ae:	a801                	j	800013be <wakeup+0x38>
      }
      release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	576040ef          	jal	80005928 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	03248263          	beq	s1,s2,800013de <wakeup+0x58>
    if(p != myproc()){
    800013be:	9a3ff0ef          	jal	80000d60 <myproc>
    800013c2:	fea48ae3          	beq	s1,a0,800013b6 <wakeup+0x30>
      acquire(&p->lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	4cc040ef          	jal	80005894 <acquire>
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
    80001406:	38e48493          	addi	s1,s1,910 # 8000a790 <proc>
      pp->parent = initproc;
    8000140a:	00009a17          	auipc	s4,0x9
    8000140e:	f16a0a13          	addi	s4,s4,-234 # 8000a320 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001412:	0000f997          	auipc	s3,0xf
    80001416:	d7e98993          	addi	s3,s3,-642 # 80010190 <tickslock>
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
    80001462:	ec27b783          	ld	a5,-318(a5) # 8000a320 <initproc>
    80001466:	0d050493          	addi	s1,a0,208
    8000146a:	15050913          	addi	s2,a0,336
    8000146e:	00a79b63          	bne	a5,a0,80001484 <exit+0x3e>
    panic("init exiting");
    80001472:	00006517          	auipc	a0,0x6
    80001476:	dae50513          	addi	a0,a0,-594 # 80007220 <etext+0x220>
    8000147a:	0ec040ef          	jal	80005566 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000147e:	04a1                	addi	s1,s1,8
    80001480:	01248963          	beq	s1,s2,80001492 <exit+0x4c>
    if(p->ofile[fd]){
    80001484:	6088                	ld	a0,0(s1)
    80001486:	dd65                	beqz	a0,8000147e <exit+0x38>
      fileclose(f);
    80001488:	7c1010ef          	jal	80003448 <fileclose>
      p->ofile[fd] = 0;
    8000148c:	0004b023          	sd	zero,0(s1)
    80001490:	b7fd                	j	8000147e <exit+0x38>
  begin_op();
    80001492:	397010ef          	jal	80003028 <begin_op>
  iput(p->cwd);
    80001496:	1509b503          	ld	a0,336(s3)
    8000149a:	45e010ef          	jal	800028f8 <iput>
  end_op();
    8000149e:	3f5010ef          	jal	80003092 <end_op>
  p->cwd = 0;
    800014a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014a6:	00009497          	auipc	s1,0x9
    800014aa:	ed248493          	addi	s1,s1,-302 # 8000a378 <wait_lock>
    800014ae:	8526                	mv	a0,s1
    800014b0:	3e4040ef          	jal	80005894 <acquire>
  reparent(p);
    800014b4:	854e                	mv	a0,s3
    800014b6:	f3bff0ef          	jal	800013f0 <reparent>
  wakeup(p->parent);
    800014ba:	0389b503          	ld	a0,56(s3)
    800014be:	ec9ff0ef          	jal	80001386 <wakeup>
  acquire(&p->lock);
    800014c2:	854e                	mv	a0,s3
    800014c4:	3d0040ef          	jal	80005894 <acquire>
  p->xstate = status;
    800014c8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014cc:	4795                	li	a5,5
    800014ce:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014d2:	8526                	mv	a0,s1
    800014d4:	454040ef          	jal	80005928 <release>
  sched();
    800014d8:	d7dff0ef          	jal	80001254 <sched>
  panic("zombie exit");
    800014dc:	00006517          	auipc	a0,0x6
    800014e0:	d5450513          	addi	a0,a0,-684 # 80007230 <etext+0x230>
    800014e4:	082040ef          	jal	80005566 <panic>

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
    800014fc:	29848493          	addi	s1,s1,664 # 8000a790 <proc>
    80001500:	0000f997          	auipc	s3,0xf
    80001504:	c9098993          	addi	s3,s3,-880 # 80010190 <tickslock>
    acquire(&p->lock);
    80001508:	8526                	mv	a0,s1
    8000150a:	38a040ef          	jal	80005894 <acquire>
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
    80001516:	412040ef          	jal	80005928 <release>
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
    80001534:	3f4040ef          	jal	80005928 <release>
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
    8000155a:	33a040ef          	jal	80005894 <acquire>
  p->killed = 1;
    8000155e:	4785                	li	a5,1
    80001560:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001562:	8526                	mv	a0,s1
    80001564:	3c4040ef          	jal	80005928 <release>
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
    80001580:	314040ef          	jal	80005894 <acquire>
  k = p->killed;
    80001584:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	39e040ef          	jal	80005928 <release>
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
    800015be:	dbe50513          	addi	a0,a0,-578 # 8000a378 <wait_lock>
    800015c2:	2d2040ef          	jal	80005894 <acquire>
        if(pp->state == ZOMBIE){
    800015c6:	4a15                	li	s4,5
        havekids = 1;
    800015c8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ca:	0000f997          	auipc	s3,0xf
    800015ce:	bc698993          	addi	s3,s3,-1082 # 80010190 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d2:	00009b97          	auipc	s7,0x9
    800015d6:	da6b8b93          	addi	s7,s7,-602 # 8000a378 <wait_lock>
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
    80001600:	328040ef          	jal	80005928 <release>
          release(&wait_lock);
    80001604:	00009517          	auipc	a0,0x9
    80001608:	d7450513          	addi	a0,a0,-652 # 8000a378 <wait_lock>
    8000160c:	31c040ef          	jal	80005928 <release>
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
    8000162a:	2fe040ef          	jal	80005928 <release>
            release(&wait_lock);
    8000162e:	00009517          	auipc	a0,0x9
    80001632:	d4a50513          	addi	a0,a0,-694 # 8000a378 <wait_lock>
    80001636:	2f2040ef          	jal	80005928 <release>
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
    8000164e:	246040ef          	jal	80005894 <acquire>
        if(pp->state == ZOMBIE){
    80001652:	4c9c                	lw	a5,24(s1)
    80001654:	f94784e3          	beq	a5,s4,800015dc <wait+0x40>
        release(&pp->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	2ce040ef          	jal	80005928 <release>
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
    8000167a:	11a48493          	addi	s1,s1,282 # 8000a790 <proc>
    8000167e:	b7e1                	j	80001646 <wait+0xaa>
      release(&wait_lock);
    80001680:	00009517          	auipc	a0,0x9
    80001684:	cf850513          	addi	a0,a0,-776 # 8000a378 <wait_lock>
    80001688:	2a0040ef          	jal	80005928 <release>
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
    80001742:	355030ef          	jal	80005296 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001746:	00009497          	auipc	s1,0x9
    8000174a:	1a248493          	addi	s1,s1,418 # 8000a8e8 <proc+0x158>
    8000174e:	0000f917          	auipc	s2,0xf
    80001752:	b9a90913          	addi	s2,s2,-1126 # 800102e8 <bcache+0x140>
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
    80001780:	317030ef          	jal	80005296 <printf>
    printf("\n");
    80001784:	8552                	mv	a0,s4
    80001786:	311030ef          	jal	80005296 <printf>
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
    80001832:	1141                	addi	sp,sp,-16
    80001834:	e406                	sd	ra,8(sp)
    80001836:	e022                	sd	s0,0(sp)
    80001838:	0800                	addi	s0,sp,16
    8000183a:	00006597          	auipc	a1,0x6
    8000183e:	a4e58593          	addi	a1,a1,-1458 # 80007288 <etext+0x288>
    80001842:	0000f517          	auipc	a0,0xf
    80001846:	94e50513          	addi	a0,a0,-1714 # 80010190 <tickslock>
    8000184a:	7c7030ef          	jal	80005810 <initlock>
    8000184e:	60a2                	ld	ra,8(sp)
    80001850:	6402                	ld	s0,0(sp)
    80001852:	0141                	addi	sp,sp,16
    80001854:	8082                	ret

0000000080001856 <trapinithart>:
    80001856:	1141                	addi	sp,sp,-16
    80001858:	e406                	sd	ra,8(sp)
    8000185a:	e022                	sd	s0,0(sp)
    8000185c:	0800                	addi	s0,sp,16
    8000185e:	00003797          	auipc	a5,0x3
    80001862:	fa278793          	addi	a5,a5,-94 # 80004800 <kernelvec>
    80001866:	10579073          	csrw	stvec,a5
    8000186a:	60a2                	ld	ra,8(sp)
    8000186c:	6402                	ld	s0,0(sp)
    8000186e:	0141                	addi	sp,sp,16
    80001870:	8082                	ret

0000000080001872 <usertrapret>:
    80001872:	1141                	addi	sp,sp,-16
    80001874:	e406                	sd	ra,8(sp)
    80001876:	e022                	sd	s0,0(sp)
    80001878:	0800                	addi	s0,sp,16
    8000187a:	ce6ff0ef          	jal	80000d60 <myproc>
    8000187e:	100027f3          	csrr	a5,sstatus
    80001882:	9bf5                	andi	a5,a5,-3
    80001884:	10079073          	csrw	sstatus,a5
    80001888:	00004697          	auipc	a3,0x4
    8000188c:	77868693          	addi	a3,a3,1912 # 80006000 <_trampoline>
    80001890:	00004717          	auipc	a4,0x4
    80001894:	77070713          	addi	a4,a4,1904 # 80006000 <_trampoline>
    80001898:	8f15                	sub	a4,a4,a3
    8000189a:	040007b7          	lui	a5,0x4000
    8000189e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800018a0:	07b2                	slli	a5,a5,0xc
    800018a2:	973e                	add	a4,a4,a5
    800018a4:	10571073          	csrw	stvec,a4
    800018a8:	6d38                	ld	a4,88(a0)
    800018aa:	18002673          	csrr	a2,satp
    800018ae:	e310                	sd	a2,0(a4)
    800018b0:	6d30                	ld	a2,88(a0)
    800018b2:	6138                	ld	a4,64(a0)
    800018b4:	6585                	lui	a1,0x1
    800018b6:	972e                	add	a4,a4,a1
    800018b8:	e618                	sd	a4,8(a2)
    800018ba:	6d38                	ld	a4,88(a0)
    800018bc:	00000617          	auipc	a2,0x0
    800018c0:	11060613          	addi	a2,a2,272 # 800019cc <usertrap>
    800018c4:	eb10                	sd	a2,16(a4)
    800018c6:	6d38                	ld	a4,88(a0)
    800018c8:	8612                	mv	a2,tp
    800018ca:	f310                	sd	a2,32(a4)
    800018cc:	10002773          	csrr	a4,sstatus
    800018d0:	eff77713          	andi	a4,a4,-257
    800018d4:	02076713          	ori	a4,a4,32
    800018d8:	10071073          	csrw	sstatus,a4
    800018dc:	6d38                	ld	a4,88(a0)
    800018de:	6f18                	ld	a4,24(a4)
    800018e0:	14171073          	csrw	sepc,a4
    800018e4:	6928                	ld	a0,80(a0)
    800018e6:	8131                	srli	a0,a0,0xc
    800018e8:	00004717          	auipc	a4,0x4
    800018ec:	7b470713          	addi	a4,a4,1972 # 8000609c <userret>
    800018f0:	8f15                	sub	a4,a4,a3
    800018f2:	97ba                	add	a5,a5,a4
    800018f4:	577d                	li	a4,-1
    800018f6:	177e                	slli	a4,a4,0x3f
    800018f8:	8d59                	or	a0,a0,a4
    800018fa:	9782                	jalr	a5
    800018fc:	60a2                	ld	ra,8(sp)
    800018fe:	6402                	ld	s0,0(sp)
    80001900:	0141                	addi	sp,sp,16
    80001902:	8082                	ret

0000000080001904 <clockintr>:
    80001904:	1101                	addi	sp,sp,-32
    80001906:	ec06                	sd	ra,24(sp)
    80001908:	e822                	sd	s0,16(sp)
    8000190a:	1000                	addi	s0,sp,32
    8000190c:	c20ff0ef          	jal	80000d2c <cpuid>
    80001910:	cd11                	beqz	a0,8000192c <clockintr+0x28>
    80001912:	c01027f3          	rdtime	a5
    80001916:	000f4737          	lui	a4,0xf4
    8000191a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000191e:	97ba                	add	a5,a5,a4
    80001920:	14d79073          	csrw	stimecmp,a5
    80001924:	60e2                	ld	ra,24(sp)
    80001926:	6442                	ld	s0,16(sp)
    80001928:	6105                	addi	sp,sp,32
    8000192a:	8082                	ret
    8000192c:	e426                	sd	s1,8(sp)
    8000192e:	0000f497          	auipc	s1,0xf
    80001932:	86248493          	addi	s1,s1,-1950 # 80010190 <tickslock>
    80001936:	8526                	mv	a0,s1
    80001938:	75d030ef          	jal	80005894 <acquire>
    8000193c:	00009517          	auipc	a0,0x9
    80001940:	9ec50513          	addi	a0,a0,-1556 # 8000a328 <ticks>
    80001944:	411c                	lw	a5,0(a0)
    80001946:	2785                	addiw	a5,a5,1
    80001948:	c11c                	sw	a5,0(a0)
    8000194a:	a3dff0ef          	jal	80001386 <wakeup>
    8000194e:	8526                	mv	a0,s1
    80001950:	7d9030ef          	jal	80005928 <release>
    80001954:	64a2                	ld	s1,8(sp)
    80001956:	bf75                	j	80001912 <clockintr+0xe>

0000000080001958 <devintr>:
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	1000                	addi	s0,sp,32
    80001960:	14202773          	csrr	a4,scause
    80001964:	57fd                	li	a5,-1
    80001966:	17fe                	slli	a5,a5,0x3f
    80001968:	07a5                	addi	a5,a5,9
    8000196a:	00f70c63          	beq	a4,a5,80001982 <devintr+0x2a>
    8000196e:	57fd                	li	a5,-1
    80001970:	17fe                	slli	a5,a5,0x3f
    80001972:	0795                	addi	a5,a5,5
    80001974:	4501                	li	a0,0
    80001976:	04f70763          	beq	a4,a5,800019c4 <devintr+0x6c>
    8000197a:	60e2                	ld	ra,24(sp)
    8000197c:	6442                	ld	s0,16(sp)
    8000197e:	6105                	addi	sp,sp,32
    80001980:	8082                	ret
    80001982:	e426                	sd	s1,8(sp)
    80001984:	729020ef          	jal	800048ac <plic_claim>
    80001988:	84aa                	mv	s1,a0
    8000198a:	47a9                	li	a5,10
    8000198c:	00f50963          	beq	a0,a5,8000199e <devintr+0x46>
    80001990:	4785                	li	a5,1
    80001992:	00f50963          	beq	a0,a5,800019a4 <devintr+0x4c>
    80001996:	4505                	li	a0,1
    80001998:	e889                	bnez	s1,800019aa <devintr+0x52>
    8000199a:	64a2                	ld	s1,8(sp)
    8000199c:	bff9                	j	8000197a <devintr+0x22>
    8000199e:	637030ef          	jal	800057d4 <uartintr>
    800019a2:	a819                	j	800019b8 <devintr+0x60>
    800019a4:	398030ef          	jal	80004d3c <virtio_disk_intr>
    800019a8:	a801                	j	800019b8 <devintr+0x60>
    800019aa:	85a6                	mv	a1,s1
    800019ac:	00006517          	auipc	a0,0x6
    800019b0:	8e450513          	addi	a0,a0,-1820 # 80007290 <etext+0x290>
    800019b4:	0e3030ef          	jal	80005296 <printf>
    800019b8:	8526                	mv	a0,s1
    800019ba:	713020ef          	jal	800048cc <plic_complete>
    800019be:	4505                	li	a0,1
    800019c0:	64a2                	ld	s1,8(sp)
    800019c2:	bf65                	j	8000197a <devintr+0x22>
    800019c4:	f41ff0ef          	jal	80001904 <clockintr>
    800019c8:	4509                	li	a0,2
    800019ca:	bf45                	j	8000197a <devintr+0x22>

00000000800019cc <usertrap>:
    800019cc:	1101                	addi	sp,sp,-32
    800019ce:	ec06                	sd	ra,24(sp)
    800019d0:	e822                	sd	s0,16(sp)
    800019d2:	e426                	sd	s1,8(sp)
    800019d4:	e04a                	sd	s2,0(sp)
    800019d6:	1000                	addi	s0,sp,32
    800019d8:	100027f3          	csrr	a5,sstatus
    800019dc:	1007f793          	andi	a5,a5,256
    800019e0:	ef85                	bnez	a5,80001a18 <usertrap+0x4c>
    800019e2:	00003797          	auipc	a5,0x3
    800019e6:	e1e78793          	addi	a5,a5,-482 # 80004800 <kernelvec>
    800019ea:	10579073          	csrw	stvec,a5
    800019ee:	b72ff0ef          	jal	80000d60 <myproc>
    800019f2:	84aa                	mv	s1,a0
    800019f4:	6d3c                	ld	a5,88(a0)
    800019f6:	14102773          	csrr	a4,sepc
    800019fa:	ef98                	sd	a4,24(a5)
    800019fc:	14202773          	csrr	a4,scause
    80001a00:	47a1                	li	a5,8
    80001a02:	02f70163          	beq	a4,a5,80001a24 <usertrap+0x58>
    80001a06:	f53ff0ef          	jal	80001958 <devintr>
    80001a0a:	892a                	mv	s2,a0
    80001a0c:	c135                	beqz	a0,80001a70 <usertrap+0xa4>
    80001a0e:	8526                	mv	a0,s1
    80001a10:	b63ff0ef          	jal	80001572 <killed>
    80001a14:	cd1d                	beqz	a0,80001a52 <usertrap+0x86>
    80001a16:	a81d                	j	80001a4c <usertrap+0x80>
    80001a18:	00006517          	auipc	a0,0x6
    80001a1c:	89850513          	addi	a0,a0,-1896 # 800072b0 <etext+0x2b0>
    80001a20:	347030ef          	jal	80005566 <panic>
    80001a24:	b4fff0ef          	jal	80001572 <killed>
    80001a28:	e121                	bnez	a0,80001a68 <usertrap+0x9c>
    80001a2a:	6cb8                	ld	a4,88(s1)
    80001a2c:	6f1c                	ld	a5,24(a4)
    80001a2e:	0791                	addi	a5,a5,4
    80001a30:	ef1c                	sd	a5,24(a4)
    80001a32:	100027f3          	csrr	a5,sstatus
    80001a36:	0027e793          	ori	a5,a5,2
    80001a3a:	10079073          	csrw	sstatus,a5
    80001a3e:	240000ef          	jal	80001c7e <syscall>
    80001a42:	8526                	mv	a0,s1
    80001a44:	b2fff0ef          	jal	80001572 <killed>
    80001a48:	c901                	beqz	a0,80001a58 <usertrap+0x8c>
    80001a4a:	4901                	li	s2,0
    80001a4c:	557d                	li	a0,-1
    80001a4e:	9f9ff0ef          	jal	80001446 <exit>
    80001a52:	4789                	li	a5,2
    80001a54:	04f90563          	beq	s2,a5,80001a9e <usertrap+0xd2>
    80001a58:	e1bff0ef          	jal	80001872 <usertrapret>
    80001a5c:	60e2                	ld	ra,24(sp)
    80001a5e:	6442                	ld	s0,16(sp)
    80001a60:	64a2                	ld	s1,8(sp)
    80001a62:	6902                	ld	s2,0(sp)
    80001a64:	6105                	addi	sp,sp,32
    80001a66:	8082                	ret
    80001a68:	557d                	li	a0,-1
    80001a6a:	9ddff0ef          	jal	80001446 <exit>
    80001a6e:	bf75                	j	80001a2a <usertrap+0x5e>
    80001a70:	142025f3          	csrr	a1,scause
    80001a74:	5890                	lw	a2,48(s1)
    80001a76:	00006517          	auipc	a0,0x6
    80001a7a:	85a50513          	addi	a0,a0,-1958 # 800072d0 <etext+0x2d0>
    80001a7e:	019030ef          	jal	80005296 <printf>
    80001a82:	141025f3          	csrr	a1,sepc
    80001a86:	14302673          	csrr	a2,stval
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	87650513          	addi	a0,a0,-1930 # 80007300 <etext+0x300>
    80001a92:	005030ef          	jal	80005296 <printf>
    80001a96:	8526                	mv	a0,s1
    80001a98:	ab7ff0ef          	jal	8000154e <setkilled>
    80001a9c:	b75d                	j	80001a42 <usertrap+0x76>
    80001a9e:	871ff0ef          	jal	8000130e <yield>
    80001aa2:	bf5d                	j	80001a58 <usertrap+0x8c>

0000000080001aa4 <kerneltrap>:
    80001aa4:	7179                	addi	sp,sp,-48
    80001aa6:	f406                	sd	ra,40(sp)
    80001aa8:	f022                	sd	s0,32(sp)
    80001aaa:	ec26                	sd	s1,24(sp)
    80001aac:	e84a                	sd	s2,16(sp)
    80001aae:	e44e                	sd	s3,8(sp)
    80001ab0:	1800                	addi	s0,sp,48
    80001ab2:	14102973          	csrr	s2,sepc
    80001ab6:	100024f3          	csrr	s1,sstatus
    80001aba:	142029f3          	csrr	s3,scause
    80001abe:	1004f793          	andi	a5,s1,256
    80001ac2:	c795                	beqz	a5,80001aee <kerneltrap+0x4a>
    80001ac4:	100027f3          	csrr	a5,sstatus
    80001ac8:	8b89                	andi	a5,a5,2
    80001aca:	eb85                	bnez	a5,80001afa <kerneltrap+0x56>
    80001acc:	e8dff0ef          	jal	80001958 <devintr>
    80001ad0:	c91d                	beqz	a0,80001b06 <kerneltrap+0x62>
    80001ad2:	4789                	li	a5,2
    80001ad4:	04f50a63          	beq	a0,a5,80001b28 <kerneltrap+0x84>
    80001ad8:	14191073          	csrw	sepc,s2
    80001adc:	10049073          	csrw	sstatus,s1
    80001ae0:	70a2                	ld	ra,40(sp)
    80001ae2:	7402                	ld	s0,32(sp)
    80001ae4:	64e2                	ld	s1,24(sp)
    80001ae6:	6942                	ld	s2,16(sp)
    80001ae8:	69a2                	ld	s3,8(sp)
    80001aea:	6145                	addi	sp,sp,48
    80001aec:	8082                	ret
    80001aee:	00006517          	auipc	a0,0x6
    80001af2:	83a50513          	addi	a0,a0,-1990 # 80007328 <etext+0x328>
    80001af6:	271030ef          	jal	80005566 <panic>
    80001afa:	00006517          	auipc	a0,0x6
    80001afe:	85650513          	addi	a0,a0,-1962 # 80007350 <etext+0x350>
    80001b02:	265030ef          	jal	80005566 <panic>
    80001b06:	14102673          	csrr	a2,sepc
    80001b0a:	143026f3          	csrr	a3,stval
    80001b0e:	85ce                	mv	a1,s3
    80001b10:	00006517          	auipc	a0,0x6
    80001b14:	86050513          	addi	a0,a0,-1952 # 80007370 <etext+0x370>
    80001b18:	77e030ef          	jal	80005296 <printf>
    80001b1c:	00006517          	auipc	a0,0x6
    80001b20:	87c50513          	addi	a0,a0,-1924 # 80007398 <etext+0x398>
    80001b24:	243030ef          	jal	80005566 <panic>
    80001b28:	a38ff0ef          	jal	80000d60 <myproc>
    80001b2c:	d555                	beqz	a0,80001ad8 <kerneltrap+0x34>
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
    80001b90:	1d7030ef          	jal	80005566 <panic>

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
[SYS_meminfo] sys_meminfo,
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
    80001c9e:	475d                	li	a4,23
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
    80001ccc:	5ca030ef          	jal	80005296 <printf>
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
  struct run *freelist;
} kmem;

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
    80001da8:	3ec50513          	addi	a0,a0,1004 # 80010190 <tickslock>
    80001dac:	2e9030ef          	jal	80005894 <acquire>
  ticks0 = ticks;
    80001db0:	00008917          	auipc	s2,0x8
    80001db4:	57892903          	lw	s2,1400(s2) # 8000a328 <ticks>
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
    80001dc6:	3ce98993          	addi	s3,s3,974 # 80010190 <tickslock>
    80001dca:	00008497          	auipc	s1,0x8
    80001dce:	55e48493          	addi	s1,s1,1374 # 8000a328 <ticks>
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
    80001dfa:	39a50513          	addi	a0,a0,922 # 80010190 <tickslock>
    80001dfe:	32b030ef          	jal	80005928 <release>
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
    80001e18:	37c50513          	addi	a0,a0,892 # 80010190 <tickslock>
    80001e1c:	30d030ef          	jal	80005928 <release>
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
    80001e58:	33c50513          	addi	a0,a0,828 # 80010190 <tickslock>
    80001e5c:	239030ef          	jal	80005894 <acquire>
  xticks = ticks;
    80001e60:	00008497          	auipc	s1,0x8
    80001e64:	4c84a483          	lw	s1,1224(s1) # 8000a328 <ticks>
  release(&tickslock);
    80001e68:	0000e517          	auipc	a0,0xe
    80001e6c:	32850513          	addi	a0,a0,808 # 80010190 <tickslock>
    80001e70:	2b9030ef          	jal	80005928 <release>
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
    80001e9e:	8f648493          	addi	s1,s1,-1802 # 8000a790 <proc>
    80001ea2:	0000e917          	auipc	s2,0xe
    80001ea6:	2ee90913          	addi	s2,s2,750 # 80010190 <tickslock>
    acquire(&p->lock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	1e9030ef          	jal	80005894 <acquire>
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
    80001ebc:	26d030ef          	jal	80005928 <release>
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
    80001edc:	24d030ef          	jal	80005928 <release>
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
    80001ef4:	235030ef          	jal	80005928 <release>
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
    80001f16:	87e48493          	addi	s1,s1,-1922 # 8000a790 <proc>
    80001f1a:	0000e917          	auipc	s2,0xe
    80001f1e:	27690913          	addi	s2,s2,630 # 80010190 <tickslock>
    acquire(&p->lock);
    80001f22:	8526                	mv	a0,s1
    80001f24:	171030ef          	jal	80005894 <acquire>
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
    80001f34:	1f5030ef          	jal	80005928 <release>
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
    80001f56:	1d3030ef          	jal	80005928 <release>
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
    80001f70:	1b9030ef          	jal	80005928 <release>
      return -1;
    80001f74:	557d                	li	a0,-1
    80001f76:	b7dd                	j	80001f5c <sys_unfreeze+0x60>

0000000080001f78 <sys_meminfo>:
// Returns a 64-bit value where:
// - Upper 32 bits contain total free pages
// - Lower 32 bits contain total used pages
uint64
sys_meminfo(void)
{
    80001f78:	1101                	addi	sp,sp,-32
    80001f7a:	ec06                	sd	ra,24(sp)
    80001f7c:	e822                	sd	s0,16(sp)
    80001f7e:	e426                	sd	s1,8(sp)
    80001f80:	e04a                	sd	s2,0(sp)
    80001f82:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 free_pages = 0;
  uint64 used_pages = 0;
  uint64 total_pages = (PHYSTOP - (uint64)end) / PGSIZE;
    80001f84:	4945                	li	s2,17
    80001f86:	096e                	slli	s2,s2,0x1b
    80001f88:	00021797          	auipc	a5,0x21
    80001f8c:	6e878793          	addi	a5,a5,1768 # 80023670 <end>
    80001f90:	40f90933          	sub	s2,s2,a5
    80001f94:	00c95913          	srli	s2,s2,0xc

  // Count free pages
  acquire(&kmem.lock);
    80001f98:	00008517          	auipc	a0,0x8
    80001f9c:	3a850513          	addi	a0,a0,936 # 8000a340 <kmem>
    80001fa0:	0f5030ef          	jal	80005894 <acquire>
  for(r = kmem.freelist; r; r = r->next)
    80001fa4:	00008797          	auipc	a5,0x8
    80001fa8:	3b47b783          	ld	a5,948(a5) # 8000a358 <kmem+0x18>
    80001fac:	c79d                	beqz	a5,80001fda <sys_meminfo+0x62>
  uint64 free_pages = 0;
    80001fae:	4481                	li	s1,0
    free_pages++;
    80001fb0:	0485                	addi	s1,s1,1
  for(r = kmem.freelist; r; r = r->next)
    80001fb2:	639c                	ld	a5,0(a5)
    80001fb4:	fff5                	bnez	a5,80001fb0 <sys_meminfo+0x38>
  release(&kmem.lock);
    80001fb6:	00008517          	auipc	a0,0x8
    80001fba:	38a50513          	addi	a0,a0,906 # 8000a340 <kmem>
    80001fbe:	16b030ef          	jal	80005928 <release>

  // Calculate used pages
  used_pages = total_pages - free_pages;

  // Pack the values into a 64-bit return value
  return (free_pages << 32) | used_pages;
    80001fc2:	02049513          	slli	a0,s1,0x20
  used_pages = total_pages - free_pages;
    80001fc6:	40990933          	sub	s2,s2,s1
}
    80001fca:	01256533          	or	a0,a0,s2
    80001fce:	60e2                	ld	ra,24(sp)
    80001fd0:	6442                	ld	s0,16(sp)
    80001fd2:	64a2                	ld	s1,8(sp)
    80001fd4:	6902                	ld	s2,0(sp)
    80001fd6:	6105                	addi	sp,sp,32
    80001fd8:	8082                	ret
  uint64 free_pages = 0;
    80001fda:	4481                	li	s1,0
    80001fdc:	bfe9                	j	80001fb6 <sys_meminfo+0x3e>

0000000080001fde <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fde:	7179                	addi	sp,sp,-48
    80001fe0:	f406                	sd	ra,40(sp)
    80001fe2:	f022                	sd	s0,32(sp)
    80001fe4:	ec26                	sd	s1,24(sp)
    80001fe6:	e84a                	sd	s2,16(sp)
    80001fe8:	e44e                	sd	s3,8(sp)
    80001fea:	e052                	sd	s4,0(sp)
    80001fec:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fee:	00005597          	auipc	a1,0x5
    80001ff2:	3e258593          	addi	a1,a1,994 # 800073d0 <etext+0x3d0>
    80001ff6:	0000e517          	auipc	a0,0xe
    80001ffa:	1b250513          	addi	a0,a0,434 # 800101a8 <bcache>
    80001ffe:	013030ef          	jal	80005810 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002002:	00016797          	auipc	a5,0x16
    80002006:	1a678793          	addi	a5,a5,422 # 800181a8 <bcache+0x8000>
    8000200a:	00016717          	auipc	a4,0x16
    8000200e:	40670713          	addi	a4,a4,1030 # 80018410 <bcache+0x8268>
    80002012:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002016:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000201a:	0000e497          	auipc	s1,0xe
    8000201e:	1a648493          	addi	s1,s1,422 # 800101c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002022:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002024:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002026:	00005a17          	auipc	s4,0x5
    8000202a:	3b2a0a13          	addi	s4,s4,946 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    8000202e:	2b893783          	ld	a5,696(s2)
    80002032:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002034:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002038:	85d2                	mv	a1,s4
    8000203a:	01048513          	addi	a0,s1,16
    8000203e:	244010ef          	jal	80003282 <initsleeplock>
    bcache.head.next->prev = b;
    80002042:	2b893783          	ld	a5,696(s2)
    80002046:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002048:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000204c:	45848493          	addi	s1,s1,1112
    80002050:	fd349fe3          	bne	s1,s3,8000202e <binit+0x50>
  }
}
    80002054:	70a2                	ld	ra,40(sp)
    80002056:	7402                	ld	s0,32(sp)
    80002058:	64e2                	ld	s1,24(sp)
    8000205a:	6942                	ld	s2,16(sp)
    8000205c:	69a2                	ld	s3,8(sp)
    8000205e:	6a02                	ld	s4,0(sp)
    80002060:	6145                	addi	sp,sp,48
    80002062:	8082                	ret

0000000080002064 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002064:	7179                	addi	sp,sp,-48
    80002066:	f406                	sd	ra,40(sp)
    80002068:	f022                	sd	s0,32(sp)
    8000206a:	ec26                	sd	s1,24(sp)
    8000206c:	e84a                	sd	s2,16(sp)
    8000206e:	e44e                	sd	s3,8(sp)
    80002070:	1800                	addi	s0,sp,48
    80002072:	892a                	mv	s2,a0
    80002074:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002076:	0000e517          	auipc	a0,0xe
    8000207a:	13250513          	addi	a0,a0,306 # 800101a8 <bcache>
    8000207e:	017030ef          	jal	80005894 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002082:	00016497          	auipc	s1,0x16
    80002086:	3de4b483          	ld	s1,990(s1) # 80018460 <bcache+0x82b8>
    8000208a:	00016797          	auipc	a5,0x16
    8000208e:	38678793          	addi	a5,a5,902 # 80018410 <bcache+0x8268>
    80002092:	02f48b63          	beq	s1,a5,800020c8 <bread+0x64>
    80002096:	873e                	mv	a4,a5
    80002098:	a021                	j	800020a0 <bread+0x3c>
    8000209a:	68a4                	ld	s1,80(s1)
    8000209c:	02e48663          	beq	s1,a4,800020c8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020a0:	449c                	lw	a5,8(s1)
    800020a2:	ff279ce3          	bne	a5,s2,8000209a <bread+0x36>
    800020a6:	44dc                	lw	a5,12(s1)
    800020a8:	ff3799e3          	bne	a5,s3,8000209a <bread+0x36>
      b->refcnt++;
    800020ac:	40bc                	lw	a5,64(s1)
    800020ae:	2785                	addiw	a5,a5,1
    800020b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020b2:	0000e517          	auipc	a0,0xe
    800020b6:	0f650513          	addi	a0,a0,246 # 800101a8 <bcache>
    800020ba:	06f030ef          	jal	80005928 <release>
      acquiresleep(&b->lock);
    800020be:	01048513          	addi	a0,s1,16
    800020c2:	1f6010ef          	jal	800032b8 <acquiresleep>
      return b;
    800020c6:	a889                	j	80002118 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020c8:	00016497          	auipc	s1,0x16
    800020cc:	3904b483          	ld	s1,912(s1) # 80018458 <bcache+0x82b0>
    800020d0:	00016797          	auipc	a5,0x16
    800020d4:	34078793          	addi	a5,a5,832 # 80018410 <bcache+0x8268>
    800020d8:	00f48863          	beq	s1,a5,800020e8 <bread+0x84>
    800020dc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020de:	40bc                	lw	a5,64(s1)
    800020e0:	cb91                	beqz	a5,800020f4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020e2:	64a4                	ld	s1,72(s1)
    800020e4:	fee49de3          	bne	s1,a4,800020de <bread+0x7a>
  panic("bget: no buffers");
    800020e8:	00005517          	auipc	a0,0x5
    800020ec:	2f850513          	addi	a0,a0,760 # 800073e0 <etext+0x3e0>
    800020f0:	476030ef          	jal	80005566 <panic>
      b->dev = dev;
    800020f4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020f8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020fc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002100:	4785                	li	a5,1
    80002102:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002104:	0000e517          	auipc	a0,0xe
    80002108:	0a450513          	addi	a0,a0,164 # 800101a8 <bcache>
    8000210c:	01d030ef          	jal	80005928 <release>
      acquiresleep(&b->lock);
    80002110:	01048513          	addi	a0,s1,16
    80002114:	1a4010ef          	jal	800032b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002118:	409c                	lw	a5,0(s1)
    8000211a:	cb89                	beqz	a5,8000212c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000211c:	8526                	mv	a0,s1
    8000211e:	70a2                	ld	ra,40(sp)
    80002120:	7402                	ld	s0,32(sp)
    80002122:	64e2                	ld	s1,24(sp)
    80002124:	6942                	ld	s2,16(sp)
    80002126:	69a2                	ld	s3,8(sp)
    80002128:	6145                	addi	sp,sp,48
    8000212a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000212c:	4581                	li	a1,0
    8000212e:	8526                	mv	a0,s1
    80002130:	201020ef          	jal	80004b30 <virtio_disk_rw>
    b->valid = 1;
    80002134:	4785                	li	a5,1
    80002136:	c09c                	sw	a5,0(s1)
  return b;
    80002138:	b7d5                	j	8000211c <bread+0xb8>

000000008000213a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	e426                	sd	s1,8(sp)
    80002142:	1000                	addi	s0,sp,32
    80002144:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002146:	0541                	addi	a0,a0,16
    80002148:	1ee010ef          	jal	80003336 <holdingsleep>
    8000214c:	c911                	beqz	a0,80002160 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000214e:	4585                	li	a1,1
    80002150:	8526                	mv	a0,s1
    80002152:	1df020ef          	jal	80004b30 <virtio_disk_rw>
}
    80002156:	60e2                	ld	ra,24(sp)
    80002158:	6442                	ld	s0,16(sp)
    8000215a:	64a2                	ld	s1,8(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    panic("bwrite");
    80002160:	00005517          	auipc	a0,0x5
    80002164:	29850513          	addi	a0,a0,664 # 800073f8 <etext+0x3f8>
    80002168:	3fe030ef          	jal	80005566 <panic>

000000008000216c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	e426                	sd	s1,8(sp)
    80002174:	e04a                	sd	s2,0(sp)
    80002176:	1000                	addi	s0,sp,32
    80002178:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000217a:	01050913          	addi	s2,a0,16
    8000217e:	854a                	mv	a0,s2
    80002180:	1b6010ef          	jal	80003336 <holdingsleep>
    80002184:	c125                	beqz	a0,800021e4 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002186:	854a                	mv	a0,s2
    80002188:	176010ef          	jal	800032fe <releasesleep>

  acquire(&bcache.lock);
    8000218c:	0000e517          	auipc	a0,0xe
    80002190:	01c50513          	addi	a0,a0,28 # 800101a8 <bcache>
    80002194:	700030ef          	jal	80005894 <acquire>
  b->refcnt--;
    80002198:	40bc                	lw	a5,64(s1)
    8000219a:	37fd                	addiw	a5,a5,-1
    8000219c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000219e:	e79d                	bnez	a5,800021cc <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021a0:	68b8                	ld	a4,80(s1)
    800021a2:	64bc                	ld	a5,72(s1)
    800021a4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021a6:	68b8                	ld	a4,80(s1)
    800021a8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021aa:	00016797          	auipc	a5,0x16
    800021ae:	ffe78793          	addi	a5,a5,-2 # 800181a8 <bcache+0x8000>
    800021b2:	2b87b703          	ld	a4,696(a5)
    800021b6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800021b8:	00016717          	auipc	a4,0x16
    800021bc:	25870713          	addi	a4,a4,600 # 80018410 <bcache+0x8268>
    800021c0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021c2:	2b87b703          	ld	a4,696(a5)
    800021c6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021c8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021cc:	0000e517          	auipc	a0,0xe
    800021d0:	fdc50513          	addi	a0,a0,-36 # 800101a8 <bcache>
    800021d4:	754030ef          	jal	80005928 <release>
}
    800021d8:	60e2                	ld	ra,24(sp)
    800021da:	6442                	ld	s0,16(sp)
    800021dc:	64a2                	ld	s1,8(sp)
    800021de:	6902                	ld	s2,0(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret
    panic("brelse");
    800021e4:	00005517          	auipc	a0,0x5
    800021e8:	21c50513          	addi	a0,a0,540 # 80007400 <etext+0x400>
    800021ec:	37a030ef          	jal	80005566 <panic>

00000000800021f0 <bpin>:

void
bpin(struct buf *b) {
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	1000                	addi	s0,sp,32
    800021fa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021fc:	0000e517          	auipc	a0,0xe
    80002200:	fac50513          	addi	a0,a0,-84 # 800101a8 <bcache>
    80002204:	690030ef          	jal	80005894 <acquire>
  b->refcnt++;
    80002208:	40bc                	lw	a5,64(s1)
    8000220a:	2785                	addiw	a5,a5,1
    8000220c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000220e:	0000e517          	auipc	a0,0xe
    80002212:	f9a50513          	addi	a0,a0,-102 # 800101a8 <bcache>
    80002216:	712030ef          	jal	80005928 <release>
}
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	64a2                	ld	s1,8(sp)
    80002220:	6105                	addi	sp,sp,32
    80002222:	8082                	ret

0000000080002224 <bunpin>:

void
bunpin(struct buf *b) {
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	e426                	sd	s1,8(sp)
    8000222c:	1000                	addi	s0,sp,32
    8000222e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002230:	0000e517          	auipc	a0,0xe
    80002234:	f7850513          	addi	a0,a0,-136 # 800101a8 <bcache>
    80002238:	65c030ef          	jal	80005894 <acquire>
  b->refcnt--;
    8000223c:	40bc                	lw	a5,64(s1)
    8000223e:	37fd                	addiw	a5,a5,-1
    80002240:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002242:	0000e517          	auipc	a0,0xe
    80002246:	f6650513          	addi	a0,a0,-154 # 800101a8 <bcache>
    8000224a:	6de030ef          	jal	80005928 <release>
}
    8000224e:	60e2                	ld	ra,24(sp)
    80002250:	6442                	ld	s0,16(sp)
    80002252:	64a2                	ld	s1,8(sp)
    80002254:	6105                	addi	sp,sp,32
    80002256:	8082                	ret

0000000080002258 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	e426                	sd	s1,8(sp)
    80002260:	e04a                	sd	s2,0(sp)
    80002262:	1000                	addi	s0,sp,32
    80002264:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002266:	00d5d79b          	srliw	a5,a1,0xd
    8000226a:	00016597          	auipc	a1,0x16
    8000226e:	61a5a583          	lw	a1,1562(a1) # 80018884 <sb+0x1c>
    80002272:	9dbd                	addw	a1,a1,a5
    80002274:	df1ff0ef          	jal	80002064 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002278:	0074f713          	andi	a4,s1,7
    8000227c:	4785                	li	a5,1
    8000227e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002282:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002284:	90d9                	srli	s1,s1,0x36
    80002286:	00950733          	add	a4,a0,s1
    8000228a:	05874703          	lbu	a4,88(a4)
    8000228e:	00e7f6b3          	and	a3,a5,a4
    80002292:	c29d                	beqz	a3,800022b8 <bfree+0x60>
    80002294:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002296:	94aa                	add	s1,s1,a0
    80002298:	fff7c793          	not	a5,a5
    8000229c:	8f7d                	and	a4,a4,a5
    8000229e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022a2:	711000ef          	jal	800031b2 <log_write>
  brelse(bp);
    800022a6:	854a                	mv	a0,s2
    800022a8:	ec5ff0ef          	jal	8000216c <brelse>
}
    800022ac:	60e2                	ld	ra,24(sp)
    800022ae:	6442                	ld	s0,16(sp)
    800022b0:	64a2                	ld	s1,8(sp)
    800022b2:	6902                	ld	s2,0(sp)
    800022b4:	6105                	addi	sp,sp,32
    800022b6:	8082                	ret
    panic("freeing free block");
    800022b8:	00005517          	auipc	a0,0x5
    800022bc:	15050513          	addi	a0,a0,336 # 80007408 <etext+0x408>
    800022c0:	2a6030ef          	jal	80005566 <panic>

00000000800022c4 <balloc>:
{
    800022c4:	715d                	addi	sp,sp,-80
    800022c6:	e486                	sd	ra,72(sp)
    800022c8:	e0a2                	sd	s0,64(sp)
    800022ca:	fc26                	sd	s1,56(sp)
    800022cc:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800022ce:	00016797          	auipc	a5,0x16
    800022d2:	59e7a783          	lw	a5,1438(a5) # 8001886c <sb+0x4>
    800022d6:	0e078863          	beqz	a5,800023c6 <balloc+0x102>
    800022da:	f84a                	sd	s2,48(sp)
    800022dc:	f44e                	sd	s3,40(sp)
    800022de:	f052                	sd	s4,32(sp)
    800022e0:	ec56                	sd	s5,24(sp)
    800022e2:	e85a                	sd	s6,16(sp)
    800022e4:	e45e                	sd	s7,8(sp)
    800022e6:	e062                	sd	s8,0(sp)
    800022e8:	8baa                	mv	s7,a0
    800022ea:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022ec:	00016b17          	auipc	s6,0x16
    800022f0:	57cb0b13          	addi	s6,s6,1404 # 80018868 <sb>
      m = 1 << (bi % 8);
    800022f4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022f8:	6c09                	lui	s8,0x2
    800022fa:	a09d                	j	80002360 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022fc:	97ca                	add	a5,a5,s2
    800022fe:	8e55                	or	a2,a2,a3
    80002300:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002304:	854a                	mv	a0,s2
    80002306:	6ad000ef          	jal	800031b2 <log_write>
        brelse(bp);
    8000230a:	854a                	mv	a0,s2
    8000230c:	e61ff0ef          	jal	8000216c <brelse>
  bp = bread(dev, bno);
    80002310:	85a6                	mv	a1,s1
    80002312:	855e                	mv	a0,s7
    80002314:	d51ff0ef          	jal	80002064 <bread>
    80002318:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000231a:	40000613          	li	a2,1024
    8000231e:	4581                	li	a1,0
    80002320:	05850513          	addi	a0,a0,88
    80002324:	e2bfd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002328:	854a                	mv	a0,s2
    8000232a:	689000ef          	jal	800031b2 <log_write>
  brelse(bp);
    8000232e:	854a                	mv	a0,s2
    80002330:	e3dff0ef          	jal	8000216c <brelse>
}
    80002334:	7942                	ld	s2,48(sp)
    80002336:	79a2                	ld	s3,40(sp)
    80002338:	7a02                	ld	s4,32(sp)
    8000233a:	6ae2                	ld	s5,24(sp)
    8000233c:	6b42                	ld	s6,16(sp)
    8000233e:	6ba2                	ld	s7,8(sp)
    80002340:	6c02                	ld	s8,0(sp)
}
    80002342:	8526                	mv	a0,s1
    80002344:	60a6                	ld	ra,72(sp)
    80002346:	6406                	ld	s0,64(sp)
    80002348:	74e2                	ld	s1,56(sp)
    8000234a:	6161                	addi	sp,sp,80
    8000234c:	8082                	ret
    brelse(bp);
    8000234e:	854a                	mv	a0,s2
    80002350:	e1dff0ef          	jal	8000216c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002354:	015c0abb          	addw	s5,s8,s5
    80002358:	004b2783          	lw	a5,4(s6)
    8000235c:	04fafe63          	bgeu	s5,a5,800023b8 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80002360:	41fad79b          	sraiw	a5,s5,0x1f
    80002364:	0137d79b          	srliw	a5,a5,0x13
    80002368:	015787bb          	addw	a5,a5,s5
    8000236c:	40d7d79b          	sraiw	a5,a5,0xd
    80002370:	01cb2583          	lw	a1,28(s6)
    80002374:	9dbd                	addw	a1,a1,a5
    80002376:	855e                	mv	a0,s7
    80002378:	cedff0ef          	jal	80002064 <bread>
    8000237c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000237e:	004b2503          	lw	a0,4(s6)
    80002382:	84d6                	mv	s1,s5
    80002384:	4701                	li	a4,0
    80002386:	fca4f4e3          	bgeu	s1,a0,8000234e <balloc+0x8a>
      m = 1 << (bi % 8);
    8000238a:	00777693          	andi	a3,a4,7
    8000238e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002392:	41f7579b          	sraiw	a5,a4,0x1f
    80002396:	01d7d79b          	srliw	a5,a5,0x1d
    8000239a:	9fb9                	addw	a5,a5,a4
    8000239c:	4037d79b          	sraiw	a5,a5,0x3
    800023a0:	00f90633          	add	a2,s2,a5
    800023a4:	05864603          	lbu	a2,88(a2)
    800023a8:	00c6f5b3          	and	a1,a3,a2
    800023ac:	d9a1                	beqz	a1,800022fc <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023ae:	2705                	addiw	a4,a4,1
    800023b0:	2485                	addiw	s1,s1,1
    800023b2:	fd471ae3          	bne	a4,s4,80002386 <balloc+0xc2>
    800023b6:	bf61                	j	8000234e <balloc+0x8a>
    800023b8:	7942                	ld	s2,48(sp)
    800023ba:	79a2                	ld	s3,40(sp)
    800023bc:	7a02                	ld	s4,32(sp)
    800023be:	6ae2                	ld	s5,24(sp)
    800023c0:	6b42                	ld	s6,16(sp)
    800023c2:	6ba2                	ld	s7,8(sp)
    800023c4:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800023c6:	00005517          	auipc	a0,0x5
    800023ca:	05a50513          	addi	a0,a0,90 # 80007420 <etext+0x420>
    800023ce:	6c9020ef          	jal	80005296 <printf>
  return 0;
    800023d2:	4481                	li	s1,0
    800023d4:	b7bd                	j	80002342 <balloc+0x7e>

00000000800023d6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023d6:	7179                	addi	sp,sp,-48
    800023d8:	f406                	sd	ra,40(sp)
    800023da:	f022                	sd	s0,32(sp)
    800023dc:	ec26                	sd	s1,24(sp)
    800023de:	e84a                	sd	s2,16(sp)
    800023e0:	e44e                	sd	s3,8(sp)
    800023e2:	1800                	addi	s0,sp,48
    800023e4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023e6:	47ad                	li	a5,11
    800023e8:	02b7e363          	bltu	a5,a1,8000240e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800023ec:	02059793          	slli	a5,a1,0x20
    800023f0:	01e7d593          	srli	a1,a5,0x1e
    800023f4:	00b504b3          	add	s1,a0,a1
    800023f8:	0504a903          	lw	s2,80(s1)
    800023fc:	06091363          	bnez	s2,80002462 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002400:	4108                	lw	a0,0(a0)
    80002402:	ec3ff0ef          	jal	800022c4 <balloc>
    80002406:	892a                	mv	s2,a0
      if(addr == 0)
    80002408:	cd29                	beqz	a0,80002462 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000240a:	c8a8                	sw	a0,80(s1)
    8000240c:	a899                	j	80002462 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000240e:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002412:	0ff00793          	li	a5,255
    80002416:	0697e963          	bltu	a5,s1,80002488 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000241a:	08052903          	lw	s2,128(a0)
    8000241e:	00091b63          	bnez	s2,80002434 <bmap+0x5e>
      addr = balloc(ip->dev);
    80002422:	4108                	lw	a0,0(a0)
    80002424:	ea1ff0ef          	jal	800022c4 <balloc>
    80002428:	892a                	mv	s2,a0
      if(addr == 0)
    8000242a:	cd05                	beqz	a0,80002462 <bmap+0x8c>
    8000242c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000242e:	08a9a023          	sw	a0,128(s3)
    80002432:	a011                	j	80002436 <bmap+0x60>
    80002434:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002436:	85ca                	mv	a1,s2
    80002438:	0009a503          	lw	a0,0(s3)
    8000243c:	c29ff0ef          	jal	80002064 <bread>
    80002440:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002442:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002446:	02049713          	slli	a4,s1,0x20
    8000244a:	01e75593          	srli	a1,a4,0x1e
    8000244e:	00b784b3          	add	s1,a5,a1
    80002452:	0004a903          	lw	s2,0(s1)
    80002456:	00090e63          	beqz	s2,80002472 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000245a:	8552                	mv	a0,s4
    8000245c:	d11ff0ef          	jal	8000216c <brelse>
    return addr;
    80002460:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002462:	854a                	mv	a0,s2
    80002464:	70a2                	ld	ra,40(sp)
    80002466:	7402                	ld	s0,32(sp)
    80002468:	64e2                	ld	s1,24(sp)
    8000246a:	6942                	ld	s2,16(sp)
    8000246c:	69a2                	ld	s3,8(sp)
    8000246e:	6145                	addi	sp,sp,48
    80002470:	8082                	ret
      addr = balloc(ip->dev);
    80002472:	0009a503          	lw	a0,0(s3)
    80002476:	e4fff0ef          	jal	800022c4 <balloc>
    8000247a:	892a                	mv	s2,a0
      if(addr){
    8000247c:	dd79                	beqz	a0,8000245a <bmap+0x84>
        a[bn] = addr;
    8000247e:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002480:	8552                	mv	a0,s4
    80002482:	531000ef          	jal	800031b2 <log_write>
    80002486:	bfd1                	j	8000245a <bmap+0x84>
    80002488:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000248a:	00005517          	auipc	a0,0x5
    8000248e:	fae50513          	addi	a0,a0,-82 # 80007438 <etext+0x438>
    80002492:	0d4030ef          	jal	80005566 <panic>

0000000080002496 <iget>:
{
    80002496:	7179                	addi	sp,sp,-48
    80002498:	f406                	sd	ra,40(sp)
    8000249a:	f022                	sd	s0,32(sp)
    8000249c:	ec26                	sd	s1,24(sp)
    8000249e:	e84a                	sd	s2,16(sp)
    800024a0:	e44e                	sd	s3,8(sp)
    800024a2:	e052                	sd	s4,0(sp)
    800024a4:	1800                	addi	s0,sp,48
    800024a6:	89aa                	mv	s3,a0
    800024a8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024aa:	00016517          	auipc	a0,0x16
    800024ae:	3de50513          	addi	a0,a0,990 # 80018888 <itable>
    800024b2:	3e2030ef          	jal	80005894 <acquire>
  empty = 0;
    800024b6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024b8:	00016497          	auipc	s1,0x16
    800024bc:	3e848493          	addi	s1,s1,1000 # 800188a0 <itable+0x18>
    800024c0:	00018697          	auipc	a3,0x18
    800024c4:	e7068693          	addi	a3,a3,-400 # 8001a330 <log>
    800024c8:	a039                	j	800024d6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ca:	02090963          	beqz	s2,800024fc <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ce:	08848493          	addi	s1,s1,136
    800024d2:	02d48863          	beq	s1,a3,80002502 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024d6:	449c                	lw	a5,8(s1)
    800024d8:	fef059e3          	blez	a5,800024ca <iget+0x34>
    800024dc:	4098                	lw	a4,0(s1)
    800024de:	ff3716e3          	bne	a4,s3,800024ca <iget+0x34>
    800024e2:	40d8                	lw	a4,4(s1)
    800024e4:	ff4713e3          	bne	a4,s4,800024ca <iget+0x34>
      ip->ref++;
    800024e8:	2785                	addiw	a5,a5,1
    800024ea:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024ec:	00016517          	auipc	a0,0x16
    800024f0:	39c50513          	addi	a0,a0,924 # 80018888 <itable>
    800024f4:	434030ef          	jal	80005928 <release>
      return ip;
    800024f8:	8926                	mv	s2,s1
    800024fa:	a02d                	j	80002524 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024fc:	fbe9                	bnez	a5,800024ce <iget+0x38>
      empty = ip;
    800024fe:	8926                	mv	s2,s1
    80002500:	b7f9                	j	800024ce <iget+0x38>
  if(empty == 0)
    80002502:	02090a63          	beqz	s2,80002536 <iget+0xa0>
  ip->dev = dev;
    80002506:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000250a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000250e:	4785                	li	a5,1
    80002510:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002514:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002518:	00016517          	auipc	a0,0x16
    8000251c:	37050513          	addi	a0,a0,880 # 80018888 <itable>
    80002520:	408030ef          	jal	80005928 <release>
}
    80002524:	854a                	mv	a0,s2
    80002526:	70a2                	ld	ra,40(sp)
    80002528:	7402                	ld	s0,32(sp)
    8000252a:	64e2                	ld	s1,24(sp)
    8000252c:	6942                	ld	s2,16(sp)
    8000252e:	69a2                	ld	s3,8(sp)
    80002530:	6a02                	ld	s4,0(sp)
    80002532:	6145                	addi	sp,sp,48
    80002534:	8082                	ret
    panic("iget: no inodes");
    80002536:	00005517          	auipc	a0,0x5
    8000253a:	f1a50513          	addi	a0,a0,-230 # 80007450 <etext+0x450>
    8000253e:	028030ef          	jal	80005566 <panic>

0000000080002542 <fsinit>:
fsinit(int dev) {
    80002542:	7179                	addi	sp,sp,-48
    80002544:	f406                	sd	ra,40(sp)
    80002546:	f022                	sd	s0,32(sp)
    80002548:	ec26                	sd	s1,24(sp)
    8000254a:	e84a                	sd	s2,16(sp)
    8000254c:	e44e                	sd	s3,8(sp)
    8000254e:	1800                	addi	s0,sp,48
    80002550:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002552:	4585                	li	a1,1
    80002554:	b11ff0ef          	jal	80002064 <bread>
    80002558:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000255a:	00016997          	auipc	s3,0x16
    8000255e:	30e98993          	addi	s3,s3,782 # 80018868 <sb>
    80002562:	02000613          	li	a2,32
    80002566:	05850593          	addi	a1,a0,88
    8000256a:	854e                	mv	a0,s3
    8000256c:	c47fd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    80002570:	8526                	mv	a0,s1
    80002572:	bfbff0ef          	jal	8000216c <brelse>
  if(sb.magic != FSMAGIC)
    80002576:	0009a703          	lw	a4,0(s3)
    8000257a:	102037b7          	lui	a5,0x10203
    8000257e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002582:	02f71063          	bne	a4,a5,800025a2 <fsinit+0x60>
  initlog(dev, &sb);
    80002586:	00016597          	auipc	a1,0x16
    8000258a:	2e258593          	addi	a1,a1,738 # 80018868 <sb>
    8000258e:	854a                	mv	a0,s2
    80002590:	215000ef          	jal	80002fa4 <initlog>
}
    80002594:	70a2                	ld	ra,40(sp)
    80002596:	7402                	ld	s0,32(sp)
    80002598:	64e2                	ld	s1,24(sp)
    8000259a:	6942                	ld	s2,16(sp)
    8000259c:	69a2                	ld	s3,8(sp)
    8000259e:	6145                	addi	sp,sp,48
    800025a0:	8082                	ret
    panic("invalid file system");
    800025a2:	00005517          	auipc	a0,0x5
    800025a6:	ebe50513          	addi	a0,a0,-322 # 80007460 <etext+0x460>
    800025aa:	7bd020ef          	jal	80005566 <panic>

00000000800025ae <iinit>:
{
    800025ae:	7179                	addi	sp,sp,-48
    800025b0:	f406                	sd	ra,40(sp)
    800025b2:	f022                	sd	s0,32(sp)
    800025b4:	ec26                	sd	s1,24(sp)
    800025b6:	e84a                	sd	s2,16(sp)
    800025b8:	e44e                	sd	s3,8(sp)
    800025ba:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025bc:	00005597          	auipc	a1,0x5
    800025c0:	ebc58593          	addi	a1,a1,-324 # 80007478 <etext+0x478>
    800025c4:	00016517          	auipc	a0,0x16
    800025c8:	2c450513          	addi	a0,a0,708 # 80018888 <itable>
    800025cc:	244030ef          	jal	80005810 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025d0:	00016497          	auipc	s1,0x16
    800025d4:	2e048493          	addi	s1,s1,736 # 800188b0 <itable+0x28>
    800025d8:	00018997          	auipc	s3,0x18
    800025dc:	d6898993          	addi	s3,s3,-664 # 8001a340 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025e0:	00005917          	auipc	s2,0x5
    800025e4:	ea090913          	addi	s2,s2,-352 # 80007480 <etext+0x480>
    800025e8:	85ca                	mv	a1,s2
    800025ea:	8526                	mv	a0,s1
    800025ec:	497000ef          	jal	80003282 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025f0:	08848493          	addi	s1,s1,136
    800025f4:	ff349ae3          	bne	s1,s3,800025e8 <iinit+0x3a>
}
    800025f8:	70a2                	ld	ra,40(sp)
    800025fa:	7402                	ld	s0,32(sp)
    800025fc:	64e2                	ld	s1,24(sp)
    800025fe:	6942                	ld	s2,16(sp)
    80002600:	69a2                	ld	s3,8(sp)
    80002602:	6145                	addi	sp,sp,48
    80002604:	8082                	ret

0000000080002606 <ialloc>:
{
    80002606:	7139                	addi	sp,sp,-64
    80002608:	fc06                	sd	ra,56(sp)
    8000260a:	f822                	sd	s0,48(sp)
    8000260c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000260e:	00016717          	auipc	a4,0x16
    80002612:	26672703          	lw	a4,614(a4) # 80018874 <sb+0xc>
    80002616:	4785                	li	a5,1
    80002618:	06e7f063          	bgeu	a5,a4,80002678 <ialloc+0x72>
    8000261c:	f426                	sd	s1,40(sp)
    8000261e:	f04a                	sd	s2,32(sp)
    80002620:	ec4e                	sd	s3,24(sp)
    80002622:	e852                	sd	s4,16(sp)
    80002624:	e456                	sd	s5,8(sp)
    80002626:	e05a                	sd	s6,0(sp)
    80002628:	8aaa                	mv	s5,a0
    8000262a:	8b2e                	mv	s6,a1
    8000262c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000262e:	00016a17          	auipc	s4,0x16
    80002632:	23aa0a13          	addi	s4,s4,570 # 80018868 <sb>
    80002636:	00495593          	srli	a1,s2,0x4
    8000263a:	018a2783          	lw	a5,24(s4)
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	8556                	mv	a0,s5
    80002642:	a23ff0ef          	jal	80002064 <bread>
    80002646:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002648:	05850993          	addi	s3,a0,88
    8000264c:	00f97793          	andi	a5,s2,15
    80002650:	079a                	slli	a5,a5,0x6
    80002652:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002654:	00099783          	lh	a5,0(s3)
    80002658:	cb9d                	beqz	a5,8000268e <ialloc+0x88>
    brelse(bp);
    8000265a:	b13ff0ef          	jal	8000216c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000265e:	0905                	addi	s2,s2,1
    80002660:	00ca2703          	lw	a4,12(s4)
    80002664:	0009079b          	sext.w	a5,s2
    80002668:	fce7e7e3          	bltu	a5,a4,80002636 <ialloc+0x30>
    8000266c:	74a2                	ld	s1,40(sp)
    8000266e:	7902                	ld	s2,32(sp)
    80002670:	69e2                	ld	s3,24(sp)
    80002672:	6a42                	ld	s4,16(sp)
    80002674:	6aa2                	ld	s5,8(sp)
    80002676:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002678:	00005517          	auipc	a0,0x5
    8000267c:	e1050513          	addi	a0,a0,-496 # 80007488 <etext+0x488>
    80002680:	417020ef          	jal	80005296 <printf>
  return 0;
    80002684:	4501                	li	a0,0
}
    80002686:	70e2                	ld	ra,56(sp)
    80002688:	7442                	ld	s0,48(sp)
    8000268a:	6121                	addi	sp,sp,64
    8000268c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000268e:	04000613          	li	a2,64
    80002692:	4581                	li	a1,0
    80002694:	854e                	mv	a0,s3
    80002696:	ab9fd0ef          	jal	8000014e <memset>
      dip->type = type;
    8000269a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000269e:	8526                	mv	a0,s1
    800026a0:	313000ef          	jal	800031b2 <log_write>
      brelse(bp);
    800026a4:	8526                	mv	a0,s1
    800026a6:	ac7ff0ef          	jal	8000216c <brelse>
      return iget(dev, inum);
    800026aa:	0009059b          	sext.w	a1,s2
    800026ae:	8556                	mv	a0,s5
    800026b0:	de7ff0ef          	jal	80002496 <iget>
    800026b4:	74a2                	ld	s1,40(sp)
    800026b6:	7902                	ld	s2,32(sp)
    800026b8:	69e2                	ld	s3,24(sp)
    800026ba:	6a42                	ld	s4,16(sp)
    800026bc:	6aa2                	ld	s5,8(sp)
    800026be:	6b02                	ld	s6,0(sp)
    800026c0:	b7d9                	j	80002686 <ialloc+0x80>

00000000800026c2 <iupdate>:
{
    800026c2:	1101                	addi	sp,sp,-32
    800026c4:	ec06                	sd	ra,24(sp)
    800026c6:	e822                	sd	s0,16(sp)
    800026c8:	e426                	sd	s1,8(sp)
    800026ca:	e04a                	sd	s2,0(sp)
    800026cc:	1000                	addi	s0,sp,32
    800026ce:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026d0:	415c                	lw	a5,4(a0)
    800026d2:	0047d79b          	srliw	a5,a5,0x4
    800026d6:	00016597          	auipc	a1,0x16
    800026da:	1aa5a583          	lw	a1,426(a1) # 80018880 <sb+0x18>
    800026de:	9dbd                	addw	a1,a1,a5
    800026e0:	4108                	lw	a0,0(a0)
    800026e2:	983ff0ef          	jal	80002064 <bread>
    800026e6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026e8:	05850793          	addi	a5,a0,88
    800026ec:	40d8                	lw	a4,4(s1)
    800026ee:	8b3d                	andi	a4,a4,15
    800026f0:	071a                	slli	a4,a4,0x6
    800026f2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026f4:	04449703          	lh	a4,68(s1)
    800026f8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026fc:	04649703          	lh	a4,70(s1)
    80002700:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002704:	04849703          	lh	a4,72(s1)
    80002708:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000270c:	04a49703          	lh	a4,74(s1)
    80002710:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002714:	44f8                	lw	a4,76(s1)
    80002716:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002718:	03400613          	li	a2,52
    8000271c:	05048593          	addi	a1,s1,80
    80002720:	00c78513          	addi	a0,a5,12
    80002724:	a8ffd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    80002728:	854a                	mv	a0,s2
    8000272a:	289000ef          	jal	800031b2 <log_write>
  brelse(bp);
    8000272e:	854a                	mv	a0,s2
    80002730:	a3dff0ef          	jal	8000216c <brelse>
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6902                	ld	s2,0(sp)
    8000273c:	6105                	addi	sp,sp,32
    8000273e:	8082                	ret

0000000080002740 <idup>:
{
    80002740:	1101                	addi	sp,sp,-32
    80002742:	ec06                	sd	ra,24(sp)
    80002744:	e822                	sd	s0,16(sp)
    80002746:	e426                	sd	s1,8(sp)
    80002748:	1000                	addi	s0,sp,32
    8000274a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000274c:	00016517          	auipc	a0,0x16
    80002750:	13c50513          	addi	a0,a0,316 # 80018888 <itable>
    80002754:	140030ef          	jal	80005894 <acquire>
  ip->ref++;
    80002758:	449c                	lw	a5,8(s1)
    8000275a:	2785                	addiw	a5,a5,1
    8000275c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000275e:	00016517          	auipc	a0,0x16
    80002762:	12a50513          	addi	a0,a0,298 # 80018888 <itable>
    80002766:	1c2030ef          	jal	80005928 <release>
}
    8000276a:	8526                	mv	a0,s1
    8000276c:	60e2                	ld	ra,24(sp)
    8000276e:	6442                	ld	s0,16(sp)
    80002770:	64a2                	ld	s1,8(sp)
    80002772:	6105                	addi	sp,sp,32
    80002774:	8082                	ret

0000000080002776 <ilock>:
{
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002780:	cd19                	beqz	a0,8000279e <ilock+0x28>
    80002782:	84aa                	mv	s1,a0
    80002784:	451c                	lw	a5,8(a0)
    80002786:	00f05c63          	blez	a5,8000279e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000278a:	0541                	addi	a0,a0,16
    8000278c:	32d000ef          	jal	800032b8 <acquiresleep>
  if(ip->valid == 0){
    80002790:	40bc                	lw	a5,64(s1)
    80002792:	cf89                	beqz	a5,800027ac <ilock+0x36>
}
    80002794:	60e2                	ld	ra,24(sp)
    80002796:	6442                	ld	s0,16(sp)
    80002798:	64a2                	ld	s1,8(sp)
    8000279a:	6105                	addi	sp,sp,32
    8000279c:	8082                	ret
    8000279e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027a0:	00005517          	auipc	a0,0x5
    800027a4:	d0050513          	addi	a0,a0,-768 # 800074a0 <etext+0x4a0>
    800027a8:	5bf020ef          	jal	80005566 <panic>
    800027ac:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027ae:	40dc                	lw	a5,4(s1)
    800027b0:	0047d79b          	srliw	a5,a5,0x4
    800027b4:	00016597          	auipc	a1,0x16
    800027b8:	0cc5a583          	lw	a1,204(a1) # 80018880 <sb+0x18>
    800027bc:	9dbd                	addw	a1,a1,a5
    800027be:	4088                	lw	a0,0(s1)
    800027c0:	8a5ff0ef          	jal	80002064 <bread>
    800027c4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027c6:	05850593          	addi	a1,a0,88
    800027ca:	40dc                	lw	a5,4(s1)
    800027cc:	8bbd                	andi	a5,a5,15
    800027ce:	079a                	slli	a5,a5,0x6
    800027d0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027d2:	00059783          	lh	a5,0(a1)
    800027d6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027da:	00259783          	lh	a5,2(a1)
    800027de:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027e2:	00459783          	lh	a5,4(a1)
    800027e6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027ea:	00659783          	lh	a5,6(a1)
    800027ee:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027f2:	459c                	lw	a5,8(a1)
    800027f4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027f6:	03400613          	li	a2,52
    800027fa:	05b1                	addi	a1,a1,12
    800027fc:	05048513          	addi	a0,s1,80
    80002800:	9b3fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    80002804:	854a                	mv	a0,s2
    80002806:	967ff0ef          	jal	8000216c <brelse>
    ip->valid = 1;
    8000280a:	4785                	li	a5,1
    8000280c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000280e:	04449783          	lh	a5,68(s1)
    80002812:	c399                	beqz	a5,80002818 <ilock+0xa2>
    80002814:	6902                	ld	s2,0(sp)
    80002816:	bfbd                	j	80002794 <ilock+0x1e>
      panic("ilock: no type");
    80002818:	00005517          	auipc	a0,0x5
    8000281c:	c9050513          	addi	a0,a0,-880 # 800074a8 <etext+0x4a8>
    80002820:	547020ef          	jal	80005566 <panic>

0000000080002824 <iunlock>:
{
    80002824:	1101                	addi	sp,sp,-32
    80002826:	ec06                	sd	ra,24(sp)
    80002828:	e822                	sd	s0,16(sp)
    8000282a:	e426                	sd	s1,8(sp)
    8000282c:	e04a                	sd	s2,0(sp)
    8000282e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002830:	c505                	beqz	a0,80002858 <iunlock+0x34>
    80002832:	84aa                	mv	s1,a0
    80002834:	01050913          	addi	s2,a0,16
    80002838:	854a                	mv	a0,s2
    8000283a:	2fd000ef          	jal	80003336 <holdingsleep>
    8000283e:	cd09                	beqz	a0,80002858 <iunlock+0x34>
    80002840:	449c                	lw	a5,8(s1)
    80002842:	00f05b63          	blez	a5,80002858 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002846:	854a                	mv	a0,s2
    80002848:	2b7000ef          	jal	800032fe <releasesleep>
}
    8000284c:	60e2                	ld	ra,24(sp)
    8000284e:	6442                	ld	s0,16(sp)
    80002850:	64a2                	ld	s1,8(sp)
    80002852:	6902                	ld	s2,0(sp)
    80002854:	6105                	addi	sp,sp,32
    80002856:	8082                	ret
    panic("iunlock");
    80002858:	00005517          	auipc	a0,0x5
    8000285c:	c6050513          	addi	a0,a0,-928 # 800074b8 <etext+0x4b8>
    80002860:	507020ef          	jal	80005566 <panic>

0000000080002864 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002864:	7179                	addi	sp,sp,-48
    80002866:	f406                	sd	ra,40(sp)
    80002868:	f022                	sd	s0,32(sp)
    8000286a:	ec26                	sd	s1,24(sp)
    8000286c:	e84a                	sd	s2,16(sp)
    8000286e:	e44e                	sd	s3,8(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002874:	05050493          	addi	s1,a0,80
    80002878:	08050913          	addi	s2,a0,128
    8000287c:	a021                	j	80002884 <itrunc+0x20>
    8000287e:	0491                	addi	s1,s1,4
    80002880:	01248b63          	beq	s1,s2,80002896 <itrunc+0x32>
    if(ip->addrs[i]){
    80002884:	408c                	lw	a1,0(s1)
    80002886:	dde5                	beqz	a1,8000287e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002888:	0009a503          	lw	a0,0(s3)
    8000288c:	9cdff0ef          	jal	80002258 <bfree>
      ip->addrs[i] = 0;
    80002890:	0004a023          	sw	zero,0(s1)
    80002894:	b7ed                	j	8000287e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002896:	0809a583          	lw	a1,128(s3)
    8000289a:	ed89                	bnez	a1,800028b4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000289c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800028a0:	854e                	mv	a0,s3
    800028a2:	e21ff0ef          	jal	800026c2 <iupdate>
}
    800028a6:	70a2                	ld	ra,40(sp)
    800028a8:	7402                	ld	s0,32(sp)
    800028aa:	64e2                	ld	s1,24(sp)
    800028ac:	6942                	ld	s2,16(sp)
    800028ae:	69a2                	ld	s3,8(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
    800028b4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028b6:	0009a503          	lw	a0,0(s3)
    800028ba:	faaff0ef          	jal	80002064 <bread>
    800028be:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028c0:	05850493          	addi	s1,a0,88
    800028c4:	45850913          	addi	s2,a0,1112
    800028c8:	a021                	j	800028d0 <itrunc+0x6c>
    800028ca:	0491                	addi	s1,s1,4
    800028cc:	01248963          	beq	s1,s2,800028de <itrunc+0x7a>
      if(a[j])
    800028d0:	408c                	lw	a1,0(s1)
    800028d2:	dde5                	beqz	a1,800028ca <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028d4:	0009a503          	lw	a0,0(s3)
    800028d8:	981ff0ef          	jal	80002258 <bfree>
    800028dc:	b7fd                	j	800028ca <itrunc+0x66>
    brelse(bp);
    800028de:	8552                	mv	a0,s4
    800028e0:	88dff0ef          	jal	8000216c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028e4:	0809a583          	lw	a1,128(s3)
    800028e8:	0009a503          	lw	a0,0(s3)
    800028ec:	96dff0ef          	jal	80002258 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028f0:	0809a023          	sw	zero,128(s3)
    800028f4:	6a02                	ld	s4,0(sp)
    800028f6:	b75d                	j	8000289c <itrunc+0x38>

00000000800028f8 <iput>:
{
    800028f8:	1101                	addi	sp,sp,-32
    800028fa:	ec06                	sd	ra,24(sp)
    800028fc:	e822                	sd	s0,16(sp)
    800028fe:	e426                	sd	s1,8(sp)
    80002900:	1000                	addi	s0,sp,32
    80002902:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002904:	00016517          	auipc	a0,0x16
    80002908:	f8450513          	addi	a0,a0,-124 # 80018888 <itable>
    8000290c:	789020ef          	jal	80005894 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002910:	4498                	lw	a4,8(s1)
    80002912:	4785                	li	a5,1
    80002914:	02f70063          	beq	a4,a5,80002934 <iput+0x3c>
  ip->ref--;
    80002918:	449c                	lw	a5,8(s1)
    8000291a:	37fd                	addiw	a5,a5,-1
    8000291c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000291e:	00016517          	auipc	a0,0x16
    80002922:	f6a50513          	addi	a0,a0,-150 # 80018888 <itable>
    80002926:	002030ef          	jal	80005928 <release>
}
    8000292a:	60e2                	ld	ra,24(sp)
    8000292c:	6442                	ld	s0,16(sp)
    8000292e:	64a2                	ld	s1,8(sp)
    80002930:	6105                	addi	sp,sp,32
    80002932:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002934:	40bc                	lw	a5,64(s1)
    80002936:	d3ed                	beqz	a5,80002918 <iput+0x20>
    80002938:	04a49783          	lh	a5,74(s1)
    8000293c:	fff1                	bnez	a5,80002918 <iput+0x20>
    8000293e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002940:	01048913          	addi	s2,s1,16
    80002944:	854a                	mv	a0,s2
    80002946:	173000ef          	jal	800032b8 <acquiresleep>
    release(&itable.lock);
    8000294a:	00016517          	auipc	a0,0x16
    8000294e:	f3e50513          	addi	a0,a0,-194 # 80018888 <itable>
    80002952:	7d7020ef          	jal	80005928 <release>
    itrunc(ip);
    80002956:	8526                	mv	a0,s1
    80002958:	f0dff0ef          	jal	80002864 <itrunc>
    ip->type = 0;
    8000295c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002960:	8526                	mv	a0,s1
    80002962:	d61ff0ef          	jal	800026c2 <iupdate>
    ip->valid = 0;
    80002966:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000296a:	854a                	mv	a0,s2
    8000296c:	193000ef          	jal	800032fe <releasesleep>
    acquire(&itable.lock);
    80002970:	00016517          	auipc	a0,0x16
    80002974:	f1850513          	addi	a0,a0,-232 # 80018888 <itable>
    80002978:	71d020ef          	jal	80005894 <acquire>
    8000297c:	6902                	ld	s2,0(sp)
    8000297e:	bf69                	j	80002918 <iput+0x20>

0000000080002980 <iunlockput>:
{
    80002980:	1101                	addi	sp,sp,-32
    80002982:	ec06                	sd	ra,24(sp)
    80002984:	e822                	sd	s0,16(sp)
    80002986:	e426                	sd	s1,8(sp)
    80002988:	1000                	addi	s0,sp,32
    8000298a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000298c:	e99ff0ef          	jal	80002824 <iunlock>
  iput(ip);
    80002990:	8526                	mv	a0,s1
    80002992:	f67ff0ef          	jal	800028f8 <iput>
}
    80002996:	60e2                	ld	ra,24(sp)
    80002998:	6442                	ld	s0,16(sp)
    8000299a:	64a2                	ld	s1,8(sp)
    8000299c:	6105                	addi	sp,sp,32
    8000299e:	8082                	ret

00000000800029a0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029a0:	1141                	addi	sp,sp,-16
    800029a2:	e406                	sd	ra,8(sp)
    800029a4:	e022                	sd	s0,0(sp)
    800029a6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029a8:	411c                	lw	a5,0(a0)
    800029aa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029ac:	415c                	lw	a5,4(a0)
    800029ae:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029b0:	04451783          	lh	a5,68(a0)
    800029b4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029b8:	04a51783          	lh	a5,74(a0)
    800029bc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029c0:	04c56783          	lwu	a5,76(a0)
    800029c4:	e99c                	sd	a5,16(a1)
}
    800029c6:	60a2                	ld	ra,8(sp)
    800029c8:	6402                	ld	s0,0(sp)
    800029ca:	0141                	addi	sp,sp,16
    800029cc:	8082                	ret

00000000800029ce <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029ce:	457c                	lw	a5,76(a0)
    800029d0:	0ed7e663          	bltu	a5,a3,80002abc <readi+0xee>
{
    800029d4:	7159                	addi	sp,sp,-112
    800029d6:	f486                	sd	ra,104(sp)
    800029d8:	f0a2                	sd	s0,96(sp)
    800029da:	eca6                	sd	s1,88(sp)
    800029dc:	e0d2                	sd	s4,64(sp)
    800029de:	fc56                	sd	s5,56(sp)
    800029e0:	f85a                	sd	s6,48(sp)
    800029e2:	f45e                	sd	s7,40(sp)
    800029e4:	1880                	addi	s0,sp,112
    800029e6:	8b2a                	mv	s6,a0
    800029e8:	8bae                	mv	s7,a1
    800029ea:	8a32                	mv	s4,a2
    800029ec:	84b6                	mv	s1,a3
    800029ee:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029f0:	9f35                	addw	a4,a4,a3
    return 0;
    800029f2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029f4:	0ad76b63          	bltu	a4,a3,80002aaa <readi+0xdc>
    800029f8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029fa:	00e7f463          	bgeu	a5,a4,80002a02 <readi+0x34>
    n = ip->size - off;
    800029fe:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a02:	080a8b63          	beqz	s5,80002a98 <readi+0xca>
    80002a06:	e8ca                	sd	s2,80(sp)
    80002a08:	f062                	sd	s8,32(sp)
    80002a0a:	ec66                	sd	s9,24(sp)
    80002a0c:	e86a                	sd	s10,16(sp)
    80002a0e:	e46e                	sd	s11,8(sp)
    80002a10:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a12:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a16:	5c7d                	li	s8,-1
    80002a18:	a80d                	j	80002a4a <readi+0x7c>
    80002a1a:	020d1d93          	slli	s11,s10,0x20
    80002a1e:	020ddd93          	srli	s11,s11,0x20
    80002a22:	05890613          	addi	a2,s2,88
    80002a26:	86ee                	mv	a3,s11
    80002a28:	963e                	add	a2,a2,a5
    80002a2a:	85d2                	mv	a1,s4
    80002a2c:	855e                	mv	a0,s7
    80002a2e:	c63fe0ef          	jal	80001690 <either_copyout>
    80002a32:	05850363          	beq	a0,s8,80002a78 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a36:	854a                	mv	a0,s2
    80002a38:	f34ff0ef          	jal	8000216c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a3c:	013d09bb          	addw	s3,s10,s3
    80002a40:	009d04bb          	addw	s1,s10,s1
    80002a44:	9a6e                	add	s4,s4,s11
    80002a46:	0559f363          	bgeu	s3,s5,80002a8c <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a4a:	00a4d59b          	srliw	a1,s1,0xa
    80002a4e:	855a                	mv	a0,s6
    80002a50:	987ff0ef          	jal	800023d6 <bmap>
    80002a54:	85aa                	mv	a1,a0
    if(addr == 0)
    80002a56:	c139                	beqz	a0,80002a9c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002a58:	000b2503          	lw	a0,0(s6)
    80002a5c:	e08ff0ef          	jal	80002064 <bread>
    80002a60:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a62:	3ff4f793          	andi	a5,s1,1023
    80002a66:	40fc873b          	subw	a4,s9,a5
    80002a6a:	413a86bb          	subw	a3,s5,s3
    80002a6e:	8d3a                	mv	s10,a4
    80002a70:	fae6f5e3          	bgeu	a3,a4,80002a1a <readi+0x4c>
    80002a74:	8d36                	mv	s10,a3
    80002a76:	b755                	j	80002a1a <readi+0x4c>
      brelse(bp);
    80002a78:	854a                	mv	a0,s2
    80002a7a:	ef2ff0ef          	jal	8000216c <brelse>
      tot = -1;
    80002a7e:	59fd                	li	s3,-1
      break;
    80002a80:	6946                	ld	s2,80(sp)
    80002a82:	7c02                	ld	s8,32(sp)
    80002a84:	6ce2                	ld	s9,24(sp)
    80002a86:	6d42                	ld	s10,16(sp)
    80002a88:	6da2                	ld	s11,8(sp)
    80002a8a:	a831                	j	80002aa6 <readi+0xd8>
    80002a8c:	6946                	ld	s2,80(sp)
    80002a8e:	7c02                	ld	s8,32(sp)
    80002a90:	6ce2                	ld	s9,24(sp)
    80002a92:	6d42                	ld	s10,16(sp)
    80002a94:	6da2                	ld	s11,8(sp)
    80002a96:	a801                	j	80002aa6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a98:	89d6                	mv	s3,s5
    80002a9a:	a031                	j	80002aa6 <readi+0xd8>
    80002a9c:	6946                	ld	s2,80(sp)
    80002a9e:	7c02                	ld	s8,32(sp)
    80002aa0:	6ce2                	ld	s9,24(sp)
    80002aa2:	6d42                	ld	s10,16(sp)
    80002aa4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002aa6:	854e                	mv	a0,s3
    80002aa8:	69a6                	ld	s3,72(sp)
}
    80002aaa:	70a6                	ld	ra,104(sp)
    80002aac:	7406                	ld	s0,96(sp)
    80002aae:	64e6                	ld	s1,88(sp)
    80002ab0:	6a06                	ld	s4,64(sp)
    80002ab2:	7ae2                	ld	s5,56(sp)
    80002ab4:	7b42                	ld	s6,48(sp)
    80002ab6:	7ba2                	ld	s7,40(sp)
    80002ab8:	6165                	addi	sp,sp,112
    80002aba:	8082                	ret
    return 0;
    80002abc:	4501                	li	a0,0
}
    80002abe:	8082                	ret

0000000080002ac0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ac0:	457c                	lw	a5,76(a0)
    80002ac2:	0ed7eb63          	bltu	a5,a3,80002bb8 <writei+0xf8>
{
    80002ac6:	7159                	addi	sp,sp,-112
    80002ac8:	f486                	sd	ra,104(sp)
    80002aca:	f0a2                	sd	s0,96(sp)
    80002acc:	e8ca                	sd	s2,80(sp)
    80002ace:	e0d2                	sd	s4,64(sp)
    80002ad0:	fc56                	sd	s5,56(sp)
    80002ad2:	f85a                	sd	s6,48(sp)
    80002ad4:	f45e                	sd	s7,40(sp)
    80002ad6:	1880                	addi	s0,sp,112
    80002ad8:	8aaa                	mv	s5,a0
    80002ada:	8bae                	mv	s7,a1
    80002adc:	8a32                	mv	s4,a2
    80002ade:	8936                	mv	s2,a3
    80002ae0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ae2:	00e687bb          	addw	a5,a3,a4
    80002ae6:	0cd7eb63          	bltu	a5,a3,80002bbc <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002aea:	00043737          	lui	a4,0x43
    80002aee:	0cf76963          	bltu	a4,a5,80002bc0 <writei+0x100>
    80002af2:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002af4:	0a0b0a63          	beqz	s6,80002ba8 <writei+0xe8>
    80002af8:	eca6                	sd	s1,88(sp)
    80002afa:	f062                	sd	s8,32(sp)
    80002afc:	ec66                	sd	s9,24(sp)
    80002afe:	e86a                	sd	s10,16(sp)
    80002b00:	e46e                	sd	s11,8(sp)
    80002b02:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b04:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b08:	5c7d                	li	s8,-1
    80002b0a:	a825                	j	80002b42 <writei+0x82>
    80002b0c:	020d1d93          	slli	s11,s10,0x20
    80002b10:	020ddd93          	srli	s11,s11,0x20
    80002b14:	05848513          	addi	a0,s1,88
    80002b18:	86ee                	mv	a3,s11
    80002b1a:	8652                	mv	a2,s4
    80002b1c:	85de                	mv	a1,s7
    80002b1e:	953e                	add	a0,a0,a5
    80002b20:	bbbfe0ef          	jal	800016da <either_copyin>
    80002b24:	05850663          	beq	a0,s8,80002b70 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b28:	8526                	mv	a0,s1
    80002b2a:	688000ef          	jal	800031b2 <log_write>
    brelse(bp);
    80002b2e:	8526                	mv	a0,s1
    80002b30:	e3cff0ef          	jal	8000216c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b34:	013d09bb          	addw	s3,s10,s3
    80002b38:	012d093b          	addw	s2,s10,s2
    80002b3c:	9a6e                	add	s4,s4,s11
    80002b3e:	0369fc63          	bgeu	s3,s6,80002b76 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002b42:	00a9559b          	srliw	a1,s2,0xa
    80002b46:	8556                	mv	a0,s5
    80002b48:	88fff0ef          	jal	800023d6 <bmap>
    80002b4c:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b4e:	c505                	beqz	a0,80002b76 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002b50:	000aa503          	lw	a0,0(s5)
    80002b54:	d10ff0ef          	jal	80002064 <bread>
    80002b58:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b5a:	3ff97793          	andi	a5,s2,1023
    80002b5e:	40fc873b          	subw	a4,s9,a5
    80002b62:	413b06bb          	subw	a3,s6,s3
    80002b66:	8d3a                	mv	s10,a4
    80002b68:	fae6f2e3          	bgeu	a3,a4,80002b0c <writei+0x4c>
    80002b6c:	8d36                	mv	s10,a3
    80002b6e:	bf79                	j	80002b0c <writei+0x4c>
      brelse(bp);
    80002b70:	8526                	mv	a0,s1
    80002b72:	dfaff0ef          	jal	8000216c <brelse>
  }

  if(off > ip->size)
    80002b76:	04caa783          	lw	a5,76(s5)
    80002b7a:	0327f963          	bgeu	a5,s2,80002bac <writei+0xec>
    ip->size = off;
    80002b7e:	052aa623          	sw	s2,76(s5)
    80002b82:	64e6                	ld	s1,88(sp)
    80002b84:	7c02                	ld	s8,32(sp)
    80002b86:	6ce2                	ld	s9,24(sp)
    80002b88:	6d42                	ld	s10,16(sp)
    80002b8a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b8c:	8556                	mv	a0,s5
    80002b8e:	b35ff0ef          	jal	800026c2 <iupdate>

  return tot;
    80002b92:	854e                	mv	a0,s3
    80002b94:	69a6                	ld	s3,72(sp)
}
    80002b96:	70a6                	ld	ra,104(sp)
    80002b98:	7406                	ld	s0,96(sp)
    80002b9a:	6946                	ld	s2,80(sp)
    80002b9c:	6a06                	ld	s4,64(sp)
    80002b9e:	7ae2                	ld	s5,56(sp)
    80002ba0:	7b42                	ld	s6,48(sp)
    80002ba2:	7ba2                	ld	s7,40(sp)
    80002ba4:	6165                	addi	sp,sp,112
    80002ba6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ba8:	89da                	mv	s3,s6
    80002baa:	b7cd                	j	80002b8c <writei+0xcc>
    80002bac:	64e6                	ld	s1,88(sp)
    80002bae:	7c02                	ld	s8,32(sp)
    80002bb0:	6ce2                	ld	s9,24(sp)
    80002bb2:	6d42                	ld	s10,16(sp)
    80002bb4:	6da2                	ld	s11,8(sp)
    80002bb6:	bfd9                	j	80002b8c <writei+0xcc>
    return -1;
    80002bb8:	557d                	li	a0,-1
}
    80002bba:	8082                	ret
    return -1;
    80002bbc:	557d                	li	a0,-1
    80002bbe:	bfe1                	j	80002b96 <writei+0xd6>
    return -1;
    80002bc0:	557d                	li	a0,-1
    80002bc2:	bfd1                	j	80002b96 <writei+0xd6>

0000000080002bc4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bc4:	1141                	addi	sp,sp,-16
    80002bc6:	e406                	sd	ra,8(sp)
    80002bc8:	e022                	sd	s0,0(sp)
    80002bca:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bcc:	4639                	li	a2,14
    80002bce:	e58fd0ef          	jal	80000226 <strncmp>
}
    80002bd2:	60a2                	ld	ra,8(sp)
    80002bd4:	6402                	ld	s0,0(sp)
    80002bd6:	0141                	addi	sp,sp,16
    80002bd8:	8082                	ret

0000000080002bda <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bda:	711d                	addi	sp,sp,-96
    80002bdc:	ec86                	sd	ra,88(sp)
    80002bde:	e8a2                	sd	s0,80(sp)
    80002be0:	e4a6                	sd	s1,72(sp)
    80002be2:	e0ca                	sd	s2,64(sp)
    80002be4:	fc4e                	sd	s3,56(sp)
    80002be6:	f852                	sd	s4,48(sp)
    80002be8:	f456                	sd	s5,40(sp)
    80002bea:	f05a                	sd	s6,32(sp)
    80002bec:	ec5e                	sd	s7,24(sp)
    80002bee:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bf0:	04451703          	lh	a4,68(a0)
    80002bf4:	4785                	li	a5,1
    80002bf6:	00f71f63          	bne	a4,a5,80002c14 <dirlookup+0x3a>
    80002bfa:	892a                	mv	s2,a0
    80002bfc:	8aae                	mv	s5,a1
    80002bfe:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c00:	457c                	lw	a5,76(a0)
    80002c02:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c04:	fa040a13          	addi	s4,s0,-96
    80002c08:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002c0a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c0e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c10:	e39d                	bnez	a5,80002c36 <dirlookup+0x5c>
    80002c12:	a8b9                	j	80002c70 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002c14:	00005517          	auipc	a0,0x5
    80002c18:	8ac50513          	addi	a0,a0,-1876 # 800074c0 <etext+0x4c0>
    80002c1c:	14b020ef          	jal	80005566 <panic>
      panic("dirlookup read");
    80002c20:	00005517          	auipc	a0,0x5
    80002c24:	8b850513          	addi	a0,a0,-1864 # 800074d8 <etext+0x4d8>
    80002c28:	13f020ef          	jal	80005566 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c2c:	24c1                	addiw	s1,s1,16
    80002c2e:	04c92783          	lw	a5,76(s2)
    80002c32:	02f4fe63          	bgeu	s1,a5,80002c6e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c36:	874e                	mv	a4,s3
    80002c38:	86a6                	mv	a3,s1
    80002c3a:	8652                	mv	a2,s4
    80002c3c:	4581                	li	a1,0
    80002c3e:	854a                	mv	a0,s2
    80002c40:	d8fff0ef          	jal	800029ce <readi>
    80002c44:	fd351ee3          	bne	a0,s3,80002c20 <dirlookup+0x46>
    if(de.inum == 0)
    80002c48:	fa045783          	lhu	a5,-96(s0)
    80002c4c:	d3e5                	beqz	a5,80002c2c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002c4e:	85da                	mv	a1,s6
    80002c50:	8556                	mv	a0,s5
    80002c52:	f73ff0ef          	jal	80002bc4 <namecmp>
    80002c56:	f979                	bnez	a0,80002c2c <dirlookup+0x52>
      if(poff)
    80002c58:	000b8463          	beqz	s7,80002c60 <dirlookup+0x86>
        *poff = off;
    80002c5c:	009ba023          	sw	s1,0(s7) # 80007770 <states.0>
      return iget(dp->dev, inum);
    80002c60:	fa045583          	lhu	a1,-96(s0)
    80002c64:	00092503          	lw	a0,0(s2)
    80002c68:	82fff0ef          	jal	80002496 <iget>
    80002c6c:	a011                	j	80002c70 <dirlookup+0x96>
  return 0;
    80002c6e:	4501                	li	a0,0
}
    80002c70:	60e6                	ld	ra,88(sp)
    80002c72:	6446                	ld	s0,80(sp)
    80002c74:	64a6                	ld	s1,72(sp)
    80002c76:	6906                	ld	s2,64(sp)
    80002c78:	79e2                	ld	s3,56(sp)
    80002c7a:	7a42                	ld	s4,48(sp)
    80002c7c:	7aa2                	ld	s5,40(sp)
    80002c7e:	7b02                	ld	s6,32(sp)
    80002c80:	6be2                	ld	s7,24(sp)
    80002c82:	6125                	addi	sp,sp,96
    80002c84:	8082                	ret

0000000080002c86 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c86:	711d                	addi	sp,sp,-96
    80002c88:	ec86                	sd	ra,88(sp)
    80002c8a:	e8a2                	sd	s0,80(sp)
    80002c8c:	e4a6                	sd	s1,72(sp)
    80002c8e:	e0ca                	sd	s2,64(sp)
    80002c90:	fc4e                	sd	s3,56(sp)
    80002c92:	f852                	sd	s4,48(sp)
    80002c94:	f456                	sd	s5,40(sp)
    80002c96:	f05a                	sd	s6,32(sp)
    80002c98:	ec5e                	sd	s7,24(sp)
    80002c9a:	e862                	sd	s8,16(sp)
    80002c9c:	e466                	sd	s9,8(sp)
    80002c9e:	e06a                	sd	s10,0(sp)
    80002ca0:	1080                	addi	s0,sp,96
    80002ca2:	84aa                	mv	s1,a0
    80002ca4:	8b2e                	mv	s6,a1
    80002ca6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002ca8:	00054703          	lbu	a4,0(a0)
    80002cac:	02f00793          	li	a5,47
    80002cb0:	00f70f63          	beq	a4,a5,80002cce <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002cb4:	8acfe0ef          	jal	80000d60 <myproc>
    80002cb8:	15053503          	ld	a0,336(a0)
    80002cbc:	a85ff0ef          	jal	80002740 <idup>
    80002cc0:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cc2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cc6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002cc8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cca:	4b85                	li	s7,1
    80002ccc:	a879                	j	80002d6a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002cce:	4585                	li	a1,1
    80002cd0:	852e                	mv	a0,a1
    80002cd2:	fc4ff0ef          	jal	80002496 <iget>
    80002cd6:	8a2a                	mv	s4,a0
    80002cd8:	b7ed                	j	80002cc2 <namex+0x3c>
      iunlockput(ip);
    80002cda:	8552                	mv	a0,s4
    80002cdc:	ca5ff0ef          	jal	80002980 <iunlockput>
      return 0;
    80002ce0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002ce2:	8552                	mv	a0,s4
    80002ce4:	60e6                	ld	ra,88(sp)
    80002ce6:	6446                	ld	s0,80(sp)
    80002ce8:	64a6                	ld	s1,72(sp)
    80002cea:	6906                	ld	s2,64(sp)
    80002cec:	79e2                	ld	s3,56(sp)
    80002cee:	7a42                	ld	s4,48(sp)
    80002cf0:	7aa2                	ld	s5,40(sp)
    80002cf2:	7b02                	ld	s6,32(sp)
    80002cf4:	6be2                	ld	s7,24(sp)
    80002cf6:	6c42                	ld	s8,16(sp)
    80002cf8:	6ca2                	ld	s9,8(sp)
    80002cfa:	6d02                	ld	s10,0(sp)
    80002cfc:	6125                	addi	sp,sp,96
    80002cfe:	8082                	ret
      iunlock(ip);
    80002d00:	8552                	mv	a0,s4
    80002d02:	b23ff0ef          	jal	80002824 <iunlock>
      return ip;
    80002d06:	bff1                	j	80002ce2 <namex+0x5c>
      iunlockput(ip);
    80002d08:	8552                	mv	a0,s4
    80002d0a:	c77ff0ef          	jal	80002980 <iunlockput>
      return 0;
    80002d0e:	8a4e                	mv	s4,s3
    80002d10:	bfc9                	j	80002ce2 <namex+0x5c>
  len = path - s;
    80002d12:	40998633          	sub	a2,s3,s1
    80002d16:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002d1a:	09ac5063          	bge	s8,s10,80002d9a <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002d1e:	8666                	mv	a2,s9
    80002d20:	85a6                	mv	a1,s1
    80002d22:	8556                	mv	a0,s5
    80002d24:	c8efd0ef          	jal	800001b2 <memmove>
    80002d28:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d2a:	0004c783          	lbu	a5,0(s1)
    80002d2e:	01279763          	bne	a5,s2,80002d3c <namex+0xb6>
    path++;
    80002d32:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d34:	0004c783          	lbu	a5,0(s1)
    80002d38:	ff278de3          	beq	a5,s2,80002d32 <namex+0xac>
    ilock(ip);
    80002d3c:	8552                	mv	a0,s4
    80002d3e:	a39ff0ef          	jal	80002776 <ilock>
    if(ip->type != T_DIR){
    80002d42:	044a1783          	lh	a5,68(s4)
    80002d46:	f9779ae3          	bne	a5,s7,80002cda <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002d4a:	000b0563          	beqz	s6,80002d54 <namex+0xce>
    80002d4e:	0004c783          	lbu	a5,0(s1)
    80002d52:	d7dd                	beqz	a5,80002d00 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d54:	4601                	li	a2,0
    80002d56:	85d6                	mv	a1,s5
    80002d58:	8552                	mv	a0,s4
    80002d5a:	e81ff0ef          	jal	80002bda <dirlookup>
    80002d5e:	89aa                	mv	s3,a0
    80002d60:	d545                	beqz	a0,80002d08 <namex+0x82>
    iunlockput(ip);
    80002d62:	8552                	mv	a0,s4
    80002d64:	c1dff0ef          	jal	80002980 <iunlockput>
    ip = next;
    80002d68:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d6a:	0004c783          	lbu	a5,0(s1)
    80002d6e:	01279763          	bne	a5,s2,80002d7c <namex+0xf6>
    path++;
    80002d72:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d74:	0004c783          	lbu	a5,0(s1)
    80002d78:	ff278de3          	beq	a5,s2,80002d72 <namex+0xec>
  if(*path == 0)
    80002d7c:	cb8d                	beqz	a5,80002dae <namex+0x128>
  while(*path != '/' && *path != 0)
    80002d7e:	0004c783          	lbu	a5,0(s1)
    80002d82:	89a6                	mv	s3,s1
  len = path - s;
    80002d84:	4d01                	li	s10,0
    80002d86:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d88:	01278963          	beq	a5,s2,80002d9a <namex+0x114>
    80002d8c:	d3d9                	beqz	a5,80002d12 <namex+0x8c>
    path++;
    80002d8e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d90:	0009c783          	lbu	a5,0(s3)
    80002d94:	ff279ce3          	bne	a5,s2,80002d8c <namex+0x106>
    80002d98:	bfad                	j	80002d12 <namex+0x8c>
    memmove(name, s, len);
    80002d9a:	2601                	sext.w	a2,a2
    80002d9c:	85a6                	mv	a1,s1
    80002d9e:	8556                	mv	a0,s5
    80002da0:	c12fd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002da4:	9d56                	add	s10,s10,s5
    80002da6:	000d0023          	sb	zero,0(s10)
    80002daa:	84ce                	mv	s1,s3
    80002dac:	bfbd                	j	80002d2a <namex+0xa4>
  if(nameiparent){
    80002dae:	f20b0ae3          	beqz	s6,80002ce2 <namex+0x5c>
    iput(ip);
    80002db2:	8552                	mv	a0,s4
    80002db4:	b45ff0ef          	jal	800028f8 <iput>
    return 0;
    80002db8:	4a01                	li	s4,0
    80002dba:	b725                	j	80002ce2 <namex+0x5c>

0000000080002dbc <dirlink>:
{
    80002dbc:	715d                	addi	sp,sp,-80
    80002dbe:	e486                	sd	ra,72(sp)
    80002dc0:	e0a2                	sd	s0,64(sp)
    80002dc2:	f84a                	sd	s2,48(sp)
    80002dc4:	ec56                	sd	s5,24(sp)
    80002dc6:	e85a                	sd	s6,16(sp)
    80002dc8:	0880                	addi	s0,sp,80
    80002dca:	892a                	mv	s2,a0
    80002dcc:	8aae                	mv	s5,a1
    80002dce:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dd0:	4601                	li	a2,0
    80002dd2:	e09ff0ef          	jal	80002bda <dirlookup>
    80002dd6:	ed1d                	bnez	a0,80002e14 <dirlink+0x58>
    80002dd8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dda:	04c92483          	lw	s1,76(s2)
    80002dde:	c4b9                	beqz	s1,80002e2c <dirlink+0x70>
    80002de0:	f44e                	sd	s3,40(sp)
    80002de2:	f052                	sd	s4,32(sp)
    80002de4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002de6:	fb040a13          	addi	s4,s0,-80
    80002dea:	49c1                	li	s3,16
    80002dec:	874e                	mv	a4,s3
    80002dee:	86a6                	mv	a3,s1
    80002df0:	8652                	mv	a2,s4
    80002df2:	4581                	li	a1,0
    80002df4:	854a                	mv	a0,s2
    80002df6:	bd9ff0ef          	jal	800029ce <readi>
    80002dfa:	03351163          	bne	a0,s3,80002e1c <dirlink+0x60>
    if(de.inum == 0)
    80002dfe:	fb045783          	lhu	a5,-80(s0)
    80002e02:	c39d                	beqz	a5,80002e28 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e04:	24c1                	addiw	s1,s1,16
    80002e06:	04c92783          	lw	a5,76(s2)
    80002e0a:	fef4e1e3          	bltu	s1,a5,80002dec <dirlink+0x30>
    80002e0e:	79a2                	ld	s3,40(sp)
    80002e10:	7a02                	ld	s4,32(sp)
    80002e12:	a829                	j	80002e2c <dirlink+0x70>
    iput(ip);
    80002e14:	ae5ff0ef          	jal	800028f8 <iput>
    return -1;
    80002e18:	557d                	li	a0,-1
    80002e1a:	a83d                	j	80002e58 <dirlink+0x9c>
      panic("dirlink read");
    80002e1c:	00004517          	auipc	a0,0x4
    80002e20:	6cc50513          	addi	a0,a0,1740 # 800074e8 <etext+0x4e8>
    80002e24:	742020ef          	jal	80005566 <panic>
    80002e28:	79a2                	ld	s3,40(sp)
    80002e2a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002e2c:	4639                	li	a2,14
    80002e2e:	85d6                	mv	a1,s5
    80002e30:	fb240513          	addi	a0,s0,-78
    80002e34:	c2cfd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002e38:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e3c:	4741                	li	a4,16
    80002e3e:	86a6                	mv	a3,s1
    80002e40:	fb040613          	addi	a2,s0,-80
    80002e44:	4581                	li	a1,0
    80002e46:	854a                	mv	a0,s2
    80002e48:	c79ff0ef          	jal	80002ac0 <writei>
    80002e4c:	1541                	addi	a0,a0,-16
    80002e4e:	00a03533          	snez	a0,a0
    80002e52:	40a0053b          	negw	a0,a0
    80002e56:	74e2                	ld	s1,56(sp)
}
    80002e58:	60a6                	ld	ra,72(sp)
    80002e5a:	6406                	ld	s0,64(sp)
    80002e5c:	7942                	ld	s2,48(sp)
    80002e5e:	6ae2                	ld	s5,24(sp)
    80002e60:	6b42                	ld	s6,16(sp)
    80002e62:	6161                	addi	sp,sp,80
    80002e64:	8082                	ret

0000000080002e66 <namei>:

struct inode*
namei(char *path)
{
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e6e:	fe040613          	addi	a2,s0,-32
    80002e72:	4581                	li	a1,0
    80002e74:	e13ff0ef          	jal	80002c86 <namex>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	6105                	addi	sp,sp,32
    80002e7e:	8082                	ret

0000000080002e80 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e80:	1141                	addi	sp,sp,-16
    80002e82:	e406                	sd	ra,8(sp)
    80002e84:	e022                	sd	s0,0(sp)
    80002e86:	0800                	addi	s0,sp,16
    80002e88:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e8a:	4585                	li	a1,1
    80002e8c:	dfbff0ef          	jal	80002c86 <namex>
}
    80002e90:	60a2                	ld	ra,8(sp)
    80002e92:	6402                	ld	s0,0(sp)
    80002e94:	0141                	addi	sp,sp,16
    80002e96:	8082                	ret

0000000080002e98 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	e426                	sd	s1,8(sp)
    80002ea0:	e04a                	sd	s2,0(sp)
    80002ea2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002ea4:	00017917          	auipc	s2,0x17
    80002ea8:	48c90913          	addi	s2,s2,1164 # 8001a330 <log>
    80002eac:	01892583          	lw	a1,24(s2)
    80002eb0:	02892503          	lw	a0,40(s2)
    80002eb4:	9b0ff0ef          	jal	80002064 <bread>
    80002eb8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002eba:	02c92603          	lw	a2,44(s2)
    80002ebe:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002ec0:	00c05f63          	blez	a2,80002ede <write_head+0x46>
    80002ec4:	00017717          	auipc	a4,0x17
    80002ec8:	49c70713          	addi	a4,a4,1180 # 8001a360 <log+0x30>
    80002ecc:	87aa                	mv	a5,a0
    80002ece:	060a                	slli	a2,a2,0x2
    80002ed0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ed2:	4314                	lw	a3,0(a4)
    80002ed4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ed6:	0711                	addi	a4,a4,4
    80002ed8:	0791                	addi	a5,a5,4
    80002eda:	fec79ce3          	bne	a5,a2,80002ed2 <write_head+0x3a>
  }
  bwrite(buf);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	a5aff0ef          	jal	8000213a <bwrite>
  brelse(buf);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	a86ff0ef          	jal	8000216c <brelse>
}
    80002eea:	60e2                	ld	ra,24(sp)
    80002eec:	6442                	ld	s0,16(sp)
    80002eee:	64a2                	ld	s1,8(sp)
    80002ef0:	6902                	ld	s2,0(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret

0000000080002ef6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef6:	00017797          	auipc	a5,0x17
    80002efa:	4667a783          	lw	a5,1126(a5) # 8001a35c <log+0x2c>
    80002efe:	0af05263          	blez	a5,80002fa2 <install_trans+0xac>
{
    80002f02:	715d                	addi	sp,sp,-80
    80002f04:	e486                	sd	ra,72(sp)
    80002f06:	e0a2                	sd	s0,64(sp)
    80002f08:	fc26                	sd	s1,56(sp)
    80002f0a:	f84a                	sd	s2,48(sp)
    80002f0c:	f44e                	sd	s3,40(sp)
    80002f0e:	f052                	sd	s4,32(sp)
    80002f10:	ec56                	sd	s5,24(sp)
    80002f12:	e85a                	sd	s6,16(sp)
    80002f14:	e45e                	sd	s7,8(sp)
    80002f16:	0880                	addi	s0,sp,80
    80002f18:	8b2a                	mv	s6,a0
    80002f1a:	00017a97          	auipc	s5,0x17
    80002f1e:	446a8a93          	addi	s5,s5,1094 # 8001a360 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f22:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f24:	00017997          	auipc	s3,0x17
    80002f28:	40c98993          	addi	s3,s3,1036 # 8001a330 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f2c:	40000b93          	li	s7,1024
    80002f30:	a829                	j	80002f4a <install_trans+0x54>
    brelse(lbuf);
    80002f32:	854a                	mv	a0,s2
    80002f34:	a38ff0ef          	jal	8000216c <brelse>
    brelse(dbuf);
    80002f38:	8526                	mv	a0,s1
    80002f3a:	a32ff0ef          	jal	8000216c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f3e:	2a05                	addiw	s4,s4,1
    80002f40:	0a91                	addi	s5,s5,4
    80002f42:	02c9a783          	lw	a5,44(s3)
    80002f46:	04fa5363          	bge	s4,a5,80002f8c <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f4a:	0189a583          	lw	a1,24(s3)
    80002f4e:	014585bb          	addw	a1,a1,s4
    80002f52:	2585                	addiw	a1,a1,1
    80002f54:	0289a503          	lw	a0,40(s3)
    80002f58:	90cff0ef          	jal	80002064 <bread>
    80002f5c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f5e:	000aa583          	lw	a1,0(s5)
    80002f62:	0289a503          	lw	a0,40(s3)
    80002f66:	8feff0ef          	jal	80002064 <bread>
    80002f6a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f6c:	865e                	mv	a2,s7
    80002f6e:	05890593          	addi	a1,s2,88
    80002f72:	05850513          	addi	a0,a0,88
    80002f76:	a3cfd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f7a:	8526                	mv	a0,s1
    80002f7c:	9beff0ef          	jal	8000213a <bwrite>
    if(recovering == 0)
    80002f80:	fa0b19e3          	bnez	s6,80002f32 <install_trans+0x3c>
      bunpin(dbuf);
    80002f84:	8526                	mv	a0,s1
    80002f86:	a9eff0ef          	jal	80002224 <bunpin>
    80002f8a:	b765                	j	80002f32 <install_trans+0x3c>
}
    80002f8c:	60a6                	ld	ra,72(sp)
    80002f8e:	6406                	ld	s0,64(sp)
    80002f90:	74e2                	ld	s1,56(sp)
    80002f92:	7942                	ld	s2,48(sp)
    80002f94:	79a2                	ld	s3,40(sp)
    80002f96:	7a02                	ld	s4,32(sp)
    80002f98:	6ae2                	ld	s5,24(sp)
    80002f9a:	6b42                	ld	s6,16(sp)
    80002f9c:	6ba2                	ld	s7,8(sp)
    80002f9e:	6161                	addi	sp,sp,80
    80002fa0:	8082                	ret
    80002fa2:	8082                	ret

0000000080002fa4 <initlog>:
{
    80002fa4:	7179                	addi	sp,sp,-48
    80002fa6:	f406                	sd	ra,40(sp)
    80002fa8:	f022                	sd	s0,32(sp)
    80002faa:	ec26                	sd	s1,24(sp)
    80002fac:	e84a                	sd	s2,16(sp)
    80002fae:	e44e                	sd	s3,8(sp)
    80002fb0:	1800                	addi	s0,sp,48
    80002fb2:	892a                	mv	s2,a0
    80002fb4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002fb6:	00017497          	auipc	s1,0x17
    80002fba:	37a48493          	addi	s1,s1,890 # 8001a330 <log>
    80002fbe:	00004597          	auipc	a1,0x4
    80002fc2:	53a58593          	addi	a1,a1,1338 # 800074f8 <etext+0x4f8>
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	049020ef          	jal	80005810 <initlock>
  log.start = sb->logstart;
    80002fcc:	0149a583          	lw	a1,20(s3)
    80002fd0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fd2:	0109a783          	lw	a5,16(s3)
    80002fd6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fd8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fdc:	854a                	mv	a0,s2
    80002fde:	886ff0ef          	jal	80002064 <bread>
  log.lh.n = lh->n;
    80002fe2:	4d30                	lw	a2,88(a0)
    80002fe4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fe6:	00c05f63          	blez	a2,80003004 <initlog+0x60>
    80002fea:	87aa                	mv	a5,a0
    80002fec:	00017717          	auipc	a4,0x17
    80002ff0:	37470713          	addi	a4,a4,884 # 8001a360 <log+0x30>
    80002ff4:	060a                	slli	a2,a2,0x2
    80002ff6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002ff8:	4ff4                	lw	a3,92(a5)
    80002ffa:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002ffc:	0791                	addi	a5,a5,4
    80002ffe:	0711                	addi	a4,a4,4
    80003000:	fec79ce3          	bne	a5,a2,80002ff8 <initlog+0x54>
  brelse(buf);
    80003004:	968ff0ef          	jal	8000216c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003008:	4505                	li	a0,1
    8000300a:	eedff0ef          	jal	80002ef6 <install_trans>
  log.lh.n = 0;
    8000300e:	00017797          	auipc	a5,0x17
    80003012:	3407a723          	sw	zero,846(a5) # 8001a35c <log+0x2c>
  write_head(); // clear the log
    80003016:	e83ff0ef          	jal	80002e98 <write_head>
}
    8000301a:	70a2                	ld	ra,40(sp)
    8000301c:	7402                	ld	s0,32(sp)
    8000301e:	64e2                	ld	s1,24(sp)
    80003020:	6942                	ld	s2,16(sp)
    80003022:	69a2                	ld	s3,8(sp)
    80003024:	6145                	addi	sp,sp,48
    80003026:	8082                	ret

0000000080003028 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003028:	1101                	addi	sp,sp,-32
    8000302a:	ec06                	sd	ra,24(sp)
    8000302c:	e822                	sd	s0,16(sp)
    8000302e:	e426                	sd	s1,8(sp)
    80003030:	e04a                	sd	s2,0(sp)
    80003032:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003034:	00017517          	auipc	a0,0x17
    80003038:	2fc50513          	addi	a0,a0,764 # 8001a330 <log>
    8000303c:	059020ef          	jal	80005894 <acquire>
  while(1){
    if(log.committing){
    80003040:	00017497          	auipc	s1,0x17
    80003044:	2f048493          	addi	s1,s1,752 # 8001a330 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003048:	4979                	li	s2,30
    8000304a:	a029                	j	80003054 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000304c:	85a6                	mv	a1,s1
    8000304e:	8526                	mv	a0,s1
    80003050:	aeafe0ef          	jal	8000133a <sleep>
    if(log.committing){
    80003054:	50dc                	lw	a5,36(s1)
    80003056:	fbfd                	bnez	a5,8000304c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003058:	5098                	lw	a4,32(s1)
    8000305a:	2705                	addiw	a4,a4,1
    8000305c:	0027179b          	slliw	a5,a4,0x2
    80003060:	9fb9                	addw	a5,a5,a4
    80003062:	0017979b          	slliw	a5,a5,0x1
    80003066:	54d4                	lw	a3,44(s1)
    80003068:	9fb5                	addw	a5,a5,a3
    8000306a:	00f95763          	bge	s2,a5,80003078 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000306e:	85a6                	mv	a1,s1
    80003070:	8526                	mv	a0,s1
    80003072:	ac8fe0ef          	jal	8000133a <sleep>
    80003076:	bff9                	j	80003054 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003078:	00017517          	auipc	a0,0x17
    8000307c:	2b850513          	addi	a0,a0,696 # 8001a330 <log>
    80003080:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003082:	0a7020ef          	jal	80005928 <release>
      break;
    }
  }
}
    80003086:	60e2                	ld	ra,24(sp)
    80003088:	6442                	ld	s0,16(sp)
    8000308a:	64a2                	ld	s1,8(sp)
    8000308c:	6902                	ld	s2,0(sp)
    8000308e:	6105                	addi	sp,sp,32
    80003090:	8082                	ret

0000000080003092 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003092:	7139                	addi	sp,sp,-64
    80003094:	fc06                	sd	ra,56(sp)
    80003096:	f822                	sd	s0,48(sp)
    80003098:	f426                	sd	s1,40(sp)
    8000309a:	f04a                	sd	s2,32(sp)
    8000309c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000309e:	00017497          	auipc	s1,0x17
    800030a2:	29248493          	addi	s1,s1,658 # 8001a330 <log>
    800030a6:	8526                	mv	a0,s1
    800030a8:	7ec020ef          	jal	80005894 <acquire>
  log.outstanding -= 1;
    800030ac:	509c                	lw	a5,32(s1)
    800030ae:	37fd                	addiw	a5,a5,-1
    800030b0:	893e                	mv	s2,a5
    800030b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800030b4:	50dc                	lw	a5,36(s1)
    800030b6:	ef9d                	bnez	a5,800030f4 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    800030b8:	04091863          	bnez	s2,80003108 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800030bc:	00017497          	auipc	s1,0x17
    800030c0:	27448493          	addi	s1,s1,628 # 8001a330 <log>
    800030c4:	4785                	li	a5,1
    800030c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030c8:	8526                	mv	a0,s1
    800030ca:	05f020ef          	jal	80005928 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030ce:	54dc                	lw	a5,44(s1)
    800030d0:	04f04c63          	bgtz	a5,80003128 <end_op+0x96>
    acquire(&log.lock);
    800030d4:	00017497          	auipc	s1,0x17
    800030d8:	25c48493          	addi	s1,s1,604 # 8001a330 <log>
    800030dc:	8526                	mv	a0,s1
    800030de:	7b6020ef          	jal	80005894 <acquire>
    log.committing = 0;
    800030e2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030e6:	8526                	mv	a0,s1
    800030e8:	a9efe0ef          	jal	80001386 <wakeup>
    release(&log.lock);
    800030ec:	8526                	mv	a0,s1
    800030ee:	03b020ef          	jal	80005928 <release>
}
    800030f2:	a02d                	j	8000311c <end_op+0x8a>
    800030f4:	ec4e                	sd	s3,24(sp)
    800030f6:	e852                	sd	s4,16(sp)
    800030f8:	e456                	sd	s5,8(sp)
    800030fa:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800030fc:	00004517          	auipc	a0,0x4
    80003100:	40450513          	addi	a0,a0,1028 # 80007500 <etext+0x500>
    80003104:	462020ef          	jal	80005566 <panic>
    wakeup(&log);
    80003108:	00017497          	auipc	s1,0x17
    8000310c:	22848493          	addi	s1,s1,552 # 8001a330 <log>
    80003110:	8526                	mv	a0,s1
    80003112:	a74fe0ef          	jal	80001386 <wakeup>
  release(&log.lock);
    80003116:	8526                	mv	a0,s1
    80003118:	011020ef          	jal	80005928 <release>
}
    8000311c:	70e2                	ld	ra,56(sp)
    8000311e:	7442                	ld	s0,48(sp)
    80003120:	74a2                	ld	s1,40(sp)
    80003122:	7902                	ld	s2,32(sp)
    80003124:	6121                	addi	sp,sp,64
    80003126:	8082                	ret
    80003128:	ec4e                	sd	s3,24(sp)
    8000312a:	e852                	sd	s4,16(sp)
    8000312c:	e456                	sd	s5,8(sp)
    8000312e:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003130:	00017a97          	auipc	s5,0x17
    80003134:	230a8a93          	addi	s5,s5,560 # 8001a360 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003138:	00017a17          	auipc	s4,0x17
    8000313c:	1f8a0a13          	addi	s4,s4,504 # 8001a330 <log>
    memmove(to->data, from->data, BSIZE);
    80003140:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003144:	018a2583          	lw	a1,24(s4)
    80003148:	012585bb          	addw	a1,a1,s2
    8000314c:	2585                	addiw	a1,a1,1
    8000314e:	028a2503          	lw	a0,40(s4)
    80003152:	f13fe0ef          	jal	80002064 <bread>
    80003156:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003158:	000aa583          	lw	a1,0(s5)
    8000315c:	028a2503          	lw	a0,40(s4)
    80003160:	f05fe0ef          	jal	80002064 <bread>
    80003164:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003166:	865a                	mv	a2,s6
    80003168:	05850593          	addi	a1,a0,88
    8000316c:	05848513          	addi	a0,s1,88
    80003170:	842fd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    80003174:	8526                	mv	a0,s1
    80003176:	fc5fe0ef          	jal	8000213a <bwrite>
    brelse(from);
    8000317a:	854e                	mv	a0,s3
    8000317c:	ff1fe0ef          	jal	8000216c <brelse>
    brelse(to);
    80003180:	8526                	mv	a0,s1
    80003182:	febfe0ef          	jal	8000216c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003186:	2905                	addiw	s2,s2,1
    80003188:	0a91                	addi	s5,s5,4
    8000318a:	02ca2783          	lw	a5,44(s4)
    8000318e:	faf94be3          	blt	s2,a5,80003144 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003192:	d07ff0ef          	jal	80002e98 <write_head>
    install_trans(0); // Now install writes to home locations
    80003196:	4501                	li	a0,0
    80003198:	d5fff0ef          	jal	80002ef6 <install_trans>
    log.lh.n = 0;
    8000319c:	00017797          	auipc	a5,0x17
    800031a0:	1c07a023          	sw	zero,448(a5) # 8001a35c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800031a4:	cf5ff0ef          	jal	80002e98 <write_head>
    800031a8:	69e2                	ld	s3,24(sp)
    800031aa:	6a42                	ld	s4,16(sp)
    800031ac:	6aa2                	ld	s5,8(sp)
    800031ae:	6b02                	ld	s6,0(sp)
    800031b0:	b715                	j	800030d4 <end_op+0x42>

00000000800031b2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800031b2:	1101                	addi	sp,sp,-32
    800031b4:	ec06                	sd	ra,24(sp)
    800031b6:	e822                	sd	s0,16(sp)
    800031b8:	e426                	sd	s1,8(sp)
    800031ba:	e04a                	sd	s2,0(sp)
    800031bc:	1000                	addi	s0,sp,32
    800031be:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031c0:	00017917          	auipc	s2,0x17
    800031c4:	17090913          	addi	s2,s2,368 # 8001a330 <log>
    800031c8:	854a                	mv	a0,s2
    800031ca:	6ca020ef          	jal	80005894 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031ce:	02c92603          	lw	a2,44(s2)
    800031d2:	47f5                	li	a5,29
    800031d4:	06c7c363          	blt	a5,a2,8000323a <log_write+0x88>
    800031d8:	00017797          	auipc	a5,0x17
    800031dc:	1747a783          	lw	a5,372(a5) # 8001a34c <log+0x1c>
    800031e0:	37fd                	addiw	a5,a5,-1
    800031e2:	04f65c63          	bge	a2,a5,8000323a <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031e6:	00017797          	auipc	a5,0x17
    800031ea:	16a7a783          	lw	a5,362(a5) # 8001a350 <log+0x20>
    800031ee:	04f05c63          	blez	a5,80003246 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031f2:	4781                	li	a5,0
    800031f4:	04c05f63          	blez	a2,80003252 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031f8:	44cc                	lw	a1,12(s1)
    800031fa:	00017717          	auipc	a4,0x17
    800031fe:	16670713          	addi	a4,a4,358 # 8001a360 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003202:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003204:	4314                	lw	a3,0(a4)
    80003206:	04b68663          	beq	a3,a1,80003252 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000320a:	2785                	addiw	a5,a5,1
    8000320c:	0711                	addi	a4,a4,4
    8000320e:	fef61be3          	bne	a2,a5,80003204 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003212:	0621                	addi	a2,a2,8
    80003214:	060a                	slli	a2,a2,0x2
    80003216:	00017797          	auipc	a5,0x17
    8000321a:	11a78793          	addi	a5,a5,282 # 8001a330 <log>
    8000321e:	97b2                	add	a5,a5,a2
    80003220:	44d8                	lw	a4,12(s1)
    80003222:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003224:	8526                	mv	a0,s1
    80003226:	fcbfe0ef          	jal	800021f0 <bpin>
    log.lh.n++;
    8000322a:	00017717          	auipc	a4,0x17
    8000322e:	10670713          	addi	a4,a4,262 # 8001a330 <log>
    80003232:	575c                	lw	a5,44(a4)
    80003234:	2785                	addiw	a5,a5,1
    80003236:	d75c                	sw	a5,44(a4)
    80003238:	a80d                	j	8000326a <log_write+0xb8>
    panic("too big a transaction");
    8000323a:	00004517          	auipc	a0,0x4
    8000323e:	2d650513          	addi	a0,a0,726 # 80007510 <etext+0x510>
    80003242:	324020ef          	jal	80005566 <panic>
    panic("log_write outside of trans");
    80003246:	00004517          	auipc	a0,0x4
    8000324a:	2e250513          	addi	a0,a0,738 # 80007528 <etext+0x528>
    8000324e:	318020ef          	jal	80005566 <panic>
  log.lh.block[i] = b->blockno;
    80003252:	00878693          	addi	a3,a5,8
    80003256:	068a                	slli	a3,a3,0x2
    80003258:	00017717          	auipc	a4,0x17
    8000325c:	0d870713          	addi	a4,a4,216 # 8001a330 <log>
    80003260:	9736                	add	a4,a4,a3
    80003262:	44d4                	lw	a3,12(s1)
    80003264:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003266:	faf60fe3          	beq	a2,a5,80003224 <log_write+0x72>
  }
  release(&log.lock);
    8000326a:	00017517          	auipc	a0,0x17
    8000326e:	0c650513          	addi	a0,a0,198 # 8001a330 <log>
    80003272:	6b6020ef          	jal	80005928 <release>
}
    80003276:	60e2                	ld	ra,24(sp)
    80003278:	6442                	ld	s0,16(sp)
    8000327a:	64a2                	ld	s1,8(sp)
    8000327c:	6902                	ld	s2,0(sp)
    8000327e:	6105                	addi	sp,sp,32
    80003280:	8082                	ret

0000000080003282 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003282:	1101                	addi	sp,sp,-32
    80003284:	ec06                	sd	ra,24(sp)
    80003286:	e822                	sd	s0,16(sp)
    80003288:	e426                	sd	s1,8(sp)
    8000328a:	e04a                	sd	s2,0(sp)
    8000328c:	1000                	addi	s0,sp,32
    8000328e:	84aa                	mv	s1,a0
    80003290:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003292:	00004597          	auipc	a1,0x4
    80003296:	2b658593          	addi	a1,a1,694 # 80007548 <etext+0x548>
    8000329a:	0521                	addi	a0,a0,8
    8000329c:	574020ef          	jal	80005810 <initlock>
  lk->name = name;
    800032a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032a8:	0204a423          	sw	zero,40(s1)
}
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	64a2                	ld	s1,8(sp)
    800032b2:	6902                	ld	s2,0(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret

00000000800032b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032b8:	1101                	addi	sp,sp,-32
    800032ba:	ec06                	sd	ra,24(sp)
    800032bc:	e822                	sd	s0,16(sp)
    800032be:	e426                	sd	s1,8(sp)
    800032c0:	e04a                	sd	s2,0(sp)
    800032c2:	1000                	addi	s0,sp,32
    800032c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032c6:	00850913          	addi	s2,a0,8
    800032ca:	854a                	mv	a0,s2
    800032cc:	5c8020ef          	jal	80005894 <acquire>
  while (lk->locked) {
    800032d0:	409c                	lw	a5,0(s1)
    800032d2:	c799                	beqz	a5,800032e0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032d4:	85ca                	mv	a1,s2
    800032d6:	8526                	mv	a0,s1
    800032d8:	862fe0ef          	jal	8000133a <sleep>
  while (lk->locked) {
    800032dc:	409c                	lw	a5,0(s1)
    800032de:	fbfd                	bnez	a5,800032d4 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032e0:	4785                	li	a5,1
    800032e2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032e4:	a7dfd0ef          	jal	80000d60 <myproc>
    800032e8:	591c                	lw	a5,48(a0)
    800032ea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032ec:	854a                	mv	a0,s2
    800032ee:	63a020ef          	jal	80005928 <release>
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	64a2                	ld	s1,8(sp)
    800032f8:	6902                	ld	s2,0(sp)
    800032fa:	6105                	addi	sp,sp,32
    800032fc:	8082                	ret

00000000800032fe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032fe:	1101                	addi	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	e426                	sd	s1,8(sp)
    80003306:	e04a                	sd	s2,0(sp)
    80003308:	1000                	addi	s0,sp,32
    8000330a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000330c:	00850913          	addi	s2,a0,8
    80003310:	854a                	mv	a0,s2
    80003312:	582020ef          	jal	80005894 <acquire>
  lk->locked = 0;
    80003316:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000331a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000331e:	8526                	mv	a0,s1
    80003320:	866fe0ef          	jal	80001386 <wakeup>
  release(&lk->lk);
    80003324:	854a                	mv	a0,s2
    80003326:	602020ef          	jal	80005928 <release>
}
    8000332a:	60e2                	ld	ra,24(sp)
    8000332c:	6442                	ld	s0,16(sp)
    8000332e:	64a2                	ld	s1,8(sp)
    80003330:	6902                	ld	s2,0(sp)
    80003332:	6105                	addi	sp,sp,32
    80003334:	8082                	ret

0000000080003336 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003336:	7179                	addi	sp,sp,-48
    80003338:	f406                	sd	ra,40(sp)
    8000333a:	f022                	sd	s0,32(sp)
    8000333c:	ec26                	sd	s1,24(sp)
    8000333e:	e84a                	sd	s2,16(sp)
    80003340:	1800                	addi	s0,sp,48
    80003342:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003344:	00850913          	addi	s2,a0,8
    80003348:	854a                	mv	a0,s2
    8000334a:	54a020ef          	jal	80005894 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000334e:	409c                	lw	a5,0(s1)
    80003350:	ef81                	bnez	a5,80003368 <holdingsleep+0x32>
    80003352:	4481                	li	s1,0
  release(&lk->lk);
    80003354:	854a                	mv	a0,s2
    80003356:	5d2020ef          	jal	80005928 <release>
  return r;
}
    8000335a:	8526                	mv	a0,s1
    8000335c:	70a2                	ld	ra,40(sp)
    8000335e:	7402                	ld	s0,32(sp)
    80003360:	64e2                	ld	s1,24(sp)
    80003362:	6942                	ld	s2,16(sp)
    80003364:	6145                	addi	sp,sp,48
    80003366:	8082                	ret
    80003368:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000336a:	0284a983          	lw	s3,40(s1)
    8000336e:	9f3fd0ef          	jal	80000d60 <myproc>
    80003372:	5904                	lw	s1,48(a0)
    80003374:	413484b3          	sub	s1,s1,s3
    80003378:	0014b493          	seqz	s1,s1
    8000337c:	69a2                	ld	s3,8(sp)
    8000337e:	bfd9                	j	80003354 <holdingsleep+0x1e>

0000000080003380 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003380:	1141                	addi	sp,sp,-16
    80003382:	e406                	sd	ra,8(sp)
    80003384:	e022                	sd	s0,0(sp)
    80003386:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003388:	00004597          	auipc	a1,0x4
    8000338c:	1d058593          	addi	a1,a1,464 # 80007558 <etext+0x558>
    80003390:	00017517          	auipc	a0,0x17
    80003394:	0e850513          	addi	a0,a0,232 # 8001a478 <ftable>
    80003398:	478020ef          	jal	80005810 <initlock>
}
    8000339c:	60a2                	ld	ra,8(sp)
    8000339e:	6402                	ld	s0,0(sp)
    800033a0:	0141                	addi	sp,sp,16
    800033a2:	8082                	ret

00000000800033a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	e426                	sd	s1,8(sp)
    800033ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033ae:	00017517          	auipc	a0,0x17
    800033b2:	0ca50513          	addi	a0,a0,202 # 8001a478 <ftable>
    800033b6:	4de020ef          	jal	80005894 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033ba:	00017497          	auipc	s1,0x17
    800033be:	0d648493          	addi	s1,s1,214 # 8001a490 <ftable+0x18>
    800033c2:	00018717          	auipc	a4,0x18
    800033c6:	06e70713          	addi	a4,a4,110 # 8001b430 <disk>
    if(f->ref == 0){
    800033ca:	40dc                	lw	a5,4(s1)
    800033cc:	cf89                	beqz	a5,800033e6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033ce:	02848493          	addi	s1,s1,40
    800033d2:	fee49ce3          	bne	s1,a4,800033ca <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033d6:	00017517          	auipc	a0,0x17
    800033da:	0a250513          	addi	a0,a0,162 # 8001a478 <ftable>
    800033de:	54a020ef          	jal	80005928 <release>
  return 0;
    800033e2:	4481                	li	s1,0
    800033e4:	a809                	j	800033f6 <filealloc+0x52>
      f->ref = 1;
    800033e6:	4785                	li	a5,1
    800033e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033ea:	00017517          	auipc	a0,0x17
    800033ee:	08e50513          	addi	a0,a0,142 # 8001a478 <ftable>
    800033f2:	536020ef          	jal	80005928 <release>
}
    800033f6:	8526                	mv	a0,s1
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	64a2                	ld	s1,8(sp)
    800033fe:	6105                	addi	sp,sp,32
    80003400:	8082                	ret

0000000080003402 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	e426                	sd	s1,8(sp)
    8000340a:	1000                	addi	s0,sp,32
    8000340c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000340e:	00017517          	auipc	a0,0x17
    80003412:	06a50513          	addi	a0,a0,106 # 8001a478 <ftable>
    80003416:	47e020ef          	jal	80005894 <acquire>
  if(f->ref < 1)
    8000341a:	40dc                	lw	a5,4(s1)
    8000341c:	02f05063          	blez	a5,8000343c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003420:	2785                	addiw	a5,a5,1
    80003422:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003424:	00017517          	auipc	a0,0x17
    80003428:	05450513          	addi	a0,a0,84 # 8001a478 <ftable>
    8000342c:	4fc020ef          	jal	80005928 <release>
  return f;
}
    80003430:	8526                	mv	a0,s1
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret
    panic("filedup");
    8000343c:	00004517          	auipc	a0,0x4
    80003440:	12450513          	addi	a0,a0,292 # 80007560 <etext+0x560>
    80003444:	122020ef          	jal	80005566 <panic>

0000000080003448 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003448:	7139                	addi	sp,sp,-64
    8000344a:	fc06                	sd	ra,56(sp)
    8000344c:	f822                	sd	s0,48(sp)
    8000344e:	f426                	sd	s1,40(sp)
    80003450:	0080                	addi	s0,sp,64
    80003452:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003454:	00017517          	auipc	a0,0x17
    80003458:	02450513          	addi	a0,a0,36 # 8001a478 <ftable>
    8000345c:	438020ef          	jal	80005894 <acquire>
  if(f->ref < 1)
    80003460:	40dc                	lw	a5,4(s1)
    80003462:	04f05863          	blez	a5,800034b2 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80003466:	37fd                	addiw	a5,a5,-1
    80003468:	c0dc                	sw	a5,4(s1)
    8000346a:	04f04e63          	bgtz	a5,800034c6 <fileclose+0x7e>
    8000346e:	f04a                	sd	s2,32(sp)
    80003470:	ec4e                	sd	s3,24(sp)
    80003472:	e852                	sd	s4,16(sp)
    80003474:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003476:	0004a903          	lw	s2,0(s1)
    8000347a:	0094ca83          	lbu	s5,9(s1)
    8000347e:	0104ba03          	ld	s4,16(s1)
    80003482:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003486:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000348a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000348e:	00017517          	auipc	a0,0x17
    80003492:	fea50513          	addi	a0,a0,-22 # 8001a478 <ftable>
    80003496:	492020ef          	jal	80005928 <release>

  if(ff.type == FD_PIPE){
    8000349a:	4785                	li	a5,1
    8000349c:	04f90063          	beq	s2,a5,800034dc <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034a0:	3979                	addiw	s2,s2,-2
    800034a2:	4785                	li	a5,1
    800034a4:	0527f563          	bgeu	a5,s2,800034ee <fileclose+0xa6>
    800034a8:	7902                	ld	s2,32(sp)
    800034aa:	69e2                	ld	s3,24(sp)
    800034ac:	6a42                	ld	s4,16(sp)
    800034ae:	6aa2                	ld	s5,8(sp)
    800034b0:	a00d                	j	800034d2 <fileclose+0x8a>
    800034b2:	f04a                	sd	s2,32(sp)
    800034b4:	ec4e                	sd	s3,24(sp)
    800034b6:	e852                	sd	s4,16(sp)
    800034b8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034ba:	00004517          	auipc	a0,0x4
    800034be:	0ae50513          	addi	a0,a0,174 # 80007568 <etext+0x568>
    800034c2:	0a4020ef          	jal	80005566 <panic>
    release(&ftable.lock);
    800034c6:	00017517          	auipc	a0,0x17
    800034ca:	fb250513          	addi	a0,a0,-78 # 8001a478 <ftable>
    800034ce:	45a020ef          	jal	80005928 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034d2:	70e2                	ld	ra,56(sp)
    800034d4:	7442                	ld	s0,48(sp)
    800034d6:	74a2                	ld	s1,40(sp)
    800034d8:	6121                	addi	sp,sp,64
    800034da:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034dc:	85d6                	mv	a1,s5
    800034de:	8552                	mv	a0,s4
    800034e0:	340000ef          	jal	80003820 <pipeclose>
    800034e4:	7902                	ld	s2,32(sp)
    800034e6:	69e2                	ld	s3,24(sp)
    800034e8:	6a42                	ld	s4,16(sp)
    800034ea:	6aa2                	ld	s5,8(sp)
    800034ec:	b7dd                	j	800034d2 <fileclose+0x8a>
    begin_op();
    800034ee:	b3bff0ef          	jal	80003028 <begin_op>
    iput(ff.ip);
    800034f2:	854e                	mv	a0,s3
    800034f4:	c04ff0ef          	jal	800028f8 <iput>
    end_op();
    800034f8:	b9bff0ef          	jal	80003092 <end_op>
    800034fc:	7902                	ld	s2,32(sp)
    800034fe:	69e2                	ld	s3,24(sp)
    80003500:	6a42                	ld	s4,16(sp)
    80003502:	6aa2                	ld	s5,8(sp)
    80003504:	b7f9                	j	800034d2 <fileclose+0x8a>

0000000080003506 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003506:	715d                	addi	sp,sp,-80
    80003508:	e486                	sd	ra,72(sp)
    8000350a:	e0a2                	sd	s0,64(sp)
    8000350c:	fc26                	sd	s1,56(sp)
    8000350e:	f44e                	sd	s3,40(sp)
    80003510:	0880                	addi	s0,sp,80
    80003512:	84aa                	mv	s1,a0
    80003514:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003516:	84bfd0ef          	jal	80000d60 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000351a:	409c                	lw	a5,0(s1)
    8000351c:	37f9                	addiw	a5,a5,-2
    8000351e:	4705                	li	a4,1
    80003520:	04f76263          	bltu	a4,a5,80003564 <filestat+0x5e>
    80003524:	f84a                	sd	s2,48(sp)
    80003526:	f052                	sd	s4,32(sp)
    80003528:	892a                	mv	s2,a0
    ilock(f->ip);
    8000352a:	6c88                	ld	a0,24(s1)
    8000352c:	a4aff0ef          	jal	80002776 <ilock>
    stati(f->ip, &st);
    80003530:	fb840a13          	addi	s4,s0,-72
    80003534:	85d2                	mv	a1,s4
    80003536:	6c88                	ld	a0,24(s1)
    80003538:	c68ff0ef          	jal	800029a0 <stati>
    iunlock(f->ip);
    8000353c:	6c88                	ld	a0,24(s1)
    8000353e:	ae6ff0ef          	jal	80002824 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003542:	46e1                	li	a3,24
    80003544:	8652                	mv	a2,s4
    80003546:	85ce                	mv	a1,s3
    80003548:	05093503          	ld	a0,80(s2)
    8000354c:	cb8fd0ef          	jal	80000a04 <copyout>
    80003550:	41f5551b          	sraiw	a0,a0,0x1f
    80003554:	7942                	ld	s2,48(sp)
    80003556:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003558:	60a6                	ld	ra,72(sp)
    8000355a:	6406                	ld	s0,64(sp)
    8000355c:	74e2                	ld	s1,56(sp)
    8000355e:	79a2                	ld	s3,40(sp)
    80003560:	6161                	addi	sp,sp,80
    80003562:	8082                	ret
  return -1;
    80003564:	557d                	li	a0,-1
    80003566:	bfcd                	j	80003558 <filestat+0x52>

0000000080003568 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003568:	7179                	addi	sp,sp,-48
    8000356a:	f406                	sd	ra,40(sp)
    8000356c:	f022                	sd	s0,32(sp)
    8000356e:	e84a                	sd	s2,16(sp)
    80003570:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003572:	00854783          	lbu	a5,8(a0)
    80003576:	cfd1                	beqz	a5,80003612 <fileread+0xaa>
    80003578:	ec26                	sd	s1,24(sp)
    8000357a:	e44e                	sd	s3,8(sp)
    8000357c:	84aa                	mv	s1,a0
    8000357e:	89ae                	mv	s3,a1
    80003580:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003582:	411c                	lw	a5,0(a0)
    80003584:	4705                	li	a4,1
    80003586:	04e78363          	beq	a5,a4,800035cc <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000358a:	470d                	li	a4,3
    8000358c:	04e78763          	beq	a5,a4,800035da <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003590:	4709                	li	a4,2
    80003592:	06e79a63          	bne	a5,a4,80003606 <fileread+0x9e>
    ilock(f->ip);
    80003596:	6d08                	ld	a0,24(a0)
    80003598:	9deff0ef          	jal	80002776 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000359c:	874a                	mv	a4,s2
    8000359e:	5094                	lw	a3,32(s1)
    800035a0:	864e                	mv	a2,s3
    800035a2:	4585                	li	a1,1
    800035a4:	6c88                	ld	a0,24(s1)
    800035a6:	c28ff0ef          	jal	800029ce <readi>
    800035aa:	892a                	mv	s2,a0
    800035ac:	00a05563          	blez	a0,800035b6 <fileread+0x4e>
      f->off += r;
    800035b0:	509c                	lw	a5,32(s1)
    800035b2:	9fa9                	addw	a5,a5,a0
    800035b4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035b6:	6c88                	ld	a0,24(s1)
    800035b8:	a6cff0ef          	jal	80002824 <iunlock>
    800035bc:	64e2                	ld	s1,24(sp)
    800035be:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035c0:	854a                	mv	a0,s2
    800035c2:	70a2                	ld	ra,40(sp)
    800035c4:	7402                	ld	s0,32(sp)
    800035c6:	6942                	ld	s2,16(sp)
    800035c8:	6145                	addi	sp,sp,48
    800035ca:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035cc:	6908                	ld	a0,16(a0)
    800035ce:	3a2000ef          	jal	80003970 <piperead>
    800035d2:	892a                	mv	s2,a0
    800035d4:	64e2                	ld	s1,24(sp)
    800035d6:	69a2                	ld	s3,8(sp)
    800035d8:	b7e5                	j	800035c0 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035da:	02451783          	lh	a5,36(a0)
    800035de:	03079693          	slli	a3,a5,0x30
    800035e2:	92c1                	srli	a3,a3,0x30
    800035e4:	4725                	li	a4,9
    800035e6:	02d76863          	bltu	a4,a3,80003616 <fileread+0xae>
    800035ea:	0792                	slli	a5,a5,0x4
    800035ec:	00017717          	auipc	a4,0x17
    800035f0:	dec70713          	addi	a4,a4,-532 # 8001a3d8 <devsw>
    800035f4:	97ba                	add	a5,a5,a4
    800035f6:	639c                	ld	a5,0(a5)
    800035f8:	c39d                	beqz	a5,8000361e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035fa:	4505                	li	a0,1
    800035fc:	9782                	jalr	a5
    800035fe:	892a                	mv	s2,a0
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	69a2                	ld	s3,8(sp)
    80003604:	bf75                	j	800035c0 <fileread+0x58>
    panic("fileread");
    80003606:	00004517          	auipc	a0,0x4
    8000360a:	f7250513          	addi	a0,a0,-142 # 80007578 <etext+0x578>
    8000360e:	759010ef          	jal	80005566 <panic>
    return -1;
    80003612:	597d                	li	s2,-1
    80003614:	b775                	j	800035c0 <fileread+0x58>
      return -1;
    80003616:	597d                	li	s2,-1
    80003618:	64e2                	ld	s1,24(sp)
    8000361a:	69a2                	ld	s3,8(sp)
    8000361c:	b755                	j	800035c0 <fileread+0x58>
    8000361e:	597d                	li	s2,-1
    80003620:	64e2                	ld	s1,24(sp)
    80003622:	69a2                	ld	s3,8(sp)
    80003624:	bf71                	j	800035c0 <fileread+0x58>

0000000080003626 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003626:	00954783          	lbu	a5,9(a0)
    8000362a:	10078e63          	beqz	a5,80003746 <filewrite+0x120>
{
    8000362e:	711d                	addi	sp,sp,-96
    80003630:	ec86                	sd	ra,88(sp)
    80003632:	e8a2                	sd	s0,80(sp)
    80003634:	e0ca                	sd	s2,64(sp)
    80003636:	f456                	sd	s5,40(sp)
    80003638:	f05a                	sd	s6,32(sp)
    8000363a:	1080                	addi	s0,sp,96
    8000363c:	892a                	mv	s2,a0
    8000363e:	8b2e                	mv	s6,a1
    80003640:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003642:	411c                	lw	a5,0(a0)
    80003644:	4705                	li	a4,1
    80003646:	02e78963          	beq	a5,a4,80003678 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000364a:	470d                	li	a4,3
    8000364c:	02e78a63          	beq	a5,a4,80003680 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003650:	4709                	li	a4,2
    80003652:	0ce79e63          	bne	a5,a4,8000372e <filewrite+0x108>
    80003656:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003658:	0ac05963          	blez	a2,8000370a <filewrite+0xe4>
    8000365c:	e4a6                	sd	s1,72(sp)
    8000365e:	fc4e                	sd	s3,56(sp)
    80003660:	ec5e                	sd	s7,24(sp)
    80003662:	e862                	sd	s8,16(sp)
    80003664:	e466                	sd	s9,8(sp)
    int i = 0;
    80003666:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003668:	6b85                	lui	s7,0x1
    8000366a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000366e:	6c85                	lui	s9,0x1
    80003670:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003674:	4c05                	li	s8,1
    80003676:	a8ad                	j	800036f0 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003678:	6908                	ld	a0,16(a0)
    8000367a:	1fe000ef          	jal	80003878 <pipewrite>
    8000367e:	a04d                	j	80003720 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003680:	02451783          	lh	a5,36(a0)
    80003684:	03079693          	slli	a3,a5,0x30
    80003688:	92c1                	srli	a3,a3,0x30
    8000368a:	4725                	li	a4,9
    8000368c:	0ad76f63          	bltu	a4,a3,8000374a <filewrite+0x124>
    80003690:	0792                	slli	a5,a5,0x4
    80003692:	00017717          	auipc	a4,0x17
    80003696:	d4670713          	addi	a4,a4,-698 # 8001a3d8 <devsw>
    8000369a:	97ba                	add	a5,a5,a4
    8000369c:	679c                	ld	a5,8(a5)
    8000369e:	cbc5                	beqz	a5,8000374e <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800036a0:	4505                	li	a0,1
    800036a2:	9782                	jalr	a5
    800036a4:	a8b5                	j	80003720 <filewrite+0xfa>
      if(n1 > max)
    800036a6:	2981                	sext.w	s3,s3
      begin_op();
    800036a8:	981ff0ef          	jal	80003028 <begin_op>
      ilock(f->ip);
    800036ac:	01893503          	ld	a0,24(s2)
    800036b0:	8c6ff0ef          	jal	80002776 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036b4:	874e                	mv	a4,s3
    800036b6:	02092683          	lw	a3,32(s2)
    800036ba:	016a0633          	add	a2,s4,s6
    800036be:	85e2                	mv	a1,s8
    800036c0:	01893503          	ld	a0,24(s2)
    800036c4:	bfcff0ef          	jal	80002ac0 <writei>
    800036c8:	84aa                	mv	s1,a0
    800036ca:	00a05763          	blez	a0,800036d8 <filewrite+0xb2>
        f->off += r;
    800036ce:	02092783          	lw	a5,32(s2)
    800036d2:	9fa9                	addw	a5,a5,a0
    800036d4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036d8:	01893503          	ld	a0,24(s2)
    800036dc:	948ff0ef          	jal	80002824 <iunlock>
      end_op();
    800036e0:	9b3ff0ef          	jal	80003092 <end_op>

      if(r != n1){
    800036e4:	02999563          	bne	s3,s1,8000370e <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    800036e8:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800036ec:	015a5963          	bge	s4,s5,800036fe <filewrite+0xd8>
      int n1 = n - i;
    800036f0:	414a87bb          	subw	a5,s5,s4
    800036f4:	89be                	mv	s3,a5
      if(n1 > max)
    800036f6:	fafbd8e3          	bge	s7,a5,800036a6 <filewrite+0x80>
    800036fa:	89e6                	mv	s3,s9
    800036fc:	b76d                	j	800036a6 <filewrite+0x80>
    800036fe:	64a6                	ld	s1,72(sp)
    80003700:	79e2                	ld	s3,56(sp)
    80003702:	6be2                	ld	s7,24(sp)
    80003704:	6c42                	ld	s8,16(sp)
    80003706:	6ca2                	ld	s9,8(sp)
    80003708:	a801                	j	80003718 <filewrite+0xf2>
    int i = 0;
    8000370a:	4a01                	li	s4,0
    8000370c:	a031                	j	80003718 <filewrite+0xf2>
    8000370e:	64a6                	ld	s1,72(sp)
    80003710:	79e2                	ld	s3,56(sp)
    80003712:	6be2                	ld	s7,24(sp)
    80003714:	6c42                	ld	s8,16(sp)
    80003716:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003718:	034a9d63          	bne	s5,s4,80003752 <filewrite+0x12c>
    8000371c:	8556                	mv	a0,s5
    8000371e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003720:	60e6                	ld	ra,88(sp)
    80003722:	6446                	ld	s0,80(sp)
    80003724:	6906                	ld	s2,64(sp)
    80003726:	7aa2                	ld	s5,40(sp)
    80003728:	7b02                	ld	s6,32(sp)
    8000372a:	6125                	addi	sp,sp,96
    8000372c:	8082                	ret
    8000372e:	e4a6                	sd	s1,72(sp)
    80003730:	fc4e                	sd	s3,56(sp)
    80003732:	f852                	sd	s4,48(sp)
    80003734:	ec5e                	sd	s7,24(sp)
    80003736:	e862                	sd	s8,16(sp)
    80003738:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000373a:	00004517          	auipc	a0,0x4
    8000373e:	e4e50513          	addi	a0,a0,-434 # 80007588 <etext+0x588>
    80003742:	625010ef          	jal	80005566 <panic>
    return -1;
    80003746:	557d                	li	a0,-1
}
    80003748:	8082                	ret
      return -1;
    8000374a:	557d                	li	a0,-1
    8000374c:	bfd1                	j	80003720 <filewrite+0xfa>
    8000374e:	557d                	li	a0,-1
    80003750:	bfc1                	j	80003720 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80003752:	557d                	li	a0,-1
    80003754:	7a42                	ld	s4,48(sp)
    80003756:	b7e9                	j	80003720 <filewrite+0xfa>

0000000080003758 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003758:	7179                	addi	sp,sp,-48
    8000375a:	f406                	sd	ra,40(sp)
    8000375c:	f022                	sd	s0,32(sp)
    8000375e:	ec26                	sd	s1,24(sp)
    80003760:	e052                	sd	s4,0(sp)
    80003762:	1800                	addi	s0,sp,48
    80003764:	84aa                	mv	s1,a0
    80003766:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003768:	0005b023          	sd	zero,0(a1)
    8000376c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003770:	c35ff0ef          	jal	800033a4 <filealloc>
    80003774:	e088                	sd	a0,0(s1)
    80003776:	c549                	beqz	a0,80003800 <pipealloc+0xa8>
    80003778:	c2dff0ef          	jal	800033a4 <filealloc>
    8000377c:	00aa3023          	sd	a0,0(s4)
    80003780:	cd25                	beqz	a0,800037f8 <pipealloc+0xa0>
    80003782:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003784:	97bfc0ef          	jal	800000fe <kalloc>
    80003788:	892a                	mv	s2,a0
    8000378a:	c12d                	beqz	a0,800037ec <pipealloc+0x94>
    8000378c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000378e:	4985                	li	s3,1
    80003790:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003794:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003798:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000379c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037a0:	00004597          	auipc	a1,0x4
    800037a4:	df858593          	addi	a1,a1,-520 # 80007598 <etext+0x598>
    800037a8:	068020ef          	jal	80005810 <initlock>
  (*f0)->type = FD_PIPE;
    800037ac:	609c                	ld	a5,0(s1)
    800037ae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037b2:	609c                	ld	a5,0(s1)
    800037b4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037b8:	609c                	ld	a5,0(s1)
    800037ba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037be:	609c                	ld	a5,0(s1)
    800037c0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800037c4:	000a3783          	ld	a5,0(s4)
    800037c8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037cc:	000a3783          	ld	a5,0(s4)
    800037d0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037d4:	000a3783          	ld	a5,0(s4)
    800037d8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037dc:	000a3783          	ld	a5,0(s4)
    800037e0:	0127b823          	sd	s2,16(a5)
  return 0;
    800037e4:	4501                	li	a0,0
    800037e6:	6942                	ld	s2,16(sp)
    800037e8:	69a2                	ld	s3,8(sp)
    800037ea:	a01d                	j	80003810 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037ec:	6088                	ld	a0,0(s1)
    800037ee:	c119                	beqz	a0,800037f4 <pipealloc+0x9c>
    800037f0:	6942                	ld	s2,16(sp)
    800037f2:	a029                	j	800037fc <pipealloc+0xa4>
    800037f4:	6942                	ld	s2,16(sp)
    800037f6:	a029                	j	80003800 <pipealloc+0xa8>
    800037f8:	6088                	ld	a0,0(s1)
    800037fa:	c10d                	beqz	a0,8000381c <pipealloc+0xc4>
    fileclose(*f0);
    800037fc:	c4dff0ef          	jal	80003448 <fileclose>
  if(*f1)
    80003800:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003804:	557d                	li	a0,-1
  if(*f1)
    80003806:	c789                	beqz	a5,80003810 <pipealloc+0xb8>
    fileclose(*f1);
    80003808:	853e                	mv	a0,a5
    8000380a:	c3fff0ef          	jal	80003448 <fileclose>
  return -1;
    8000380e:	557d                	li	a0,-1
}
    80003810:	70a2                	ld	ra,40(sp)
    80003812:	7402                	ld	s0,32(sp)
    80003814:	64e2                	ld	s1,24(sp)
    80003816:	6a02                	ld	s4,0(sp)
    80003818:	6145                	addi	sp,sp,48
    8000381a:	8082                	ret
  return -1;
    8000381c:	557d                	li	a0,-1
    8000381e:	bfcd                	j	80003810 <pipealloc+0xb8>

0000000080003820 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003820:	1101                	addi	sp,sp,-32
    80003822:	ec06                	sd	ra,24(sp)
    80003824:	e822                	sd	s0,16(sp)
    80003826:	e426                	sd	s1,8(sp)
    80003828:	e04a                	sd	s2,0(sp)
    8000382a:	1000                	addi	s0,sp,32
    8000382c:	84aa                	mv	s1,a0
    8000382e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003830:	064020ef          	jal	80005894 <acquire>
  if(writable){
    80003834:	02090763          	beqz	s2,80003862 <pipeclose+0x42>
    pi->writeopen = 0;
    80003838:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000383c:	21848513          	addi	a0,s1,536
    80003840:	b47fd0ef          	jal	80001386 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003844:	2204b783          	ld	a5,544(s1)
    80003848:	e785                	bnez	a5,80003870 <pipeclose+0x50>
    release(&pi->lock);
    8000384a:	8526                	mv	a0,s1
    8000384c:	0dc020ef          	jal	80005928 <release>
    kfree((char*)pi);
    80003850:	8526                	mv	a0,s1
    80003852:	fcafc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003856:	60e2                	ld	ra,24(sp)
    80003858:	6442                	ld	s0,16(sp)
    8000385a:	64a2                	ld	s1,8(sp)
    8000385c:	6902                	ld	s2,0(sp)
    8000385e:	6105                	addi	sp,sp,32
    80003860:	8082                	ret
    pi->readopen = 0;
    80003862:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003866:	21c48513          	addi	a0,s1,540
    8000386a:	b1dfd0ef          	jal	80001386 <wakeup>
    8000386e:	bfd9                	j	80003844 <pipeclose+0x24>
    release(&pi->lock);
    80003870:	8526                	mv	a0,s1
    80003872:	0b6020ef          	jal	80005928 <release>
}
    80003876:	b7c5                	j	80003856 <pipeclose+0x36>

0000000080003878 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003878:	7159                	addi	sp,sp,-112
    8000387a:	f486                	sd	ra,104(sp)
    8000387c:	f0a2                	sd	s0,96(sp)
    8000387e:	eca6                	sd	s1,88(sp)
    80003880:	e8ca                	sd	s2,80(sp)
    80003882:	e4ce                	sd	s3,72(sp)
    80003884:	e0d2                	sd	s4,64(sp)
    80003886:	fc56                	sd	s5,56(sp)
    80003888:	1880                	addi	s0,sp,112
    8000388a:	84aa                	mv	s1,a0
    8000388c:	8aae                	mv	s5,a1
    8000388e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003890:	cd0fd0ef          	jal	80000d60 <myproc>
    80003894:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003896:	8526                	mv	a0,s1
    80003898:	7fd010ef          	jal	80005894 <acquire>
  while(i < n){
    8000389c:	0d405263          	blez	s4,80003960 <pipewrite+0xe8>
    800038a0:	f85a                	sd	s6,48(sp)
    800038a2:	f45e                	sd	s7,40(sp)
    800038a4:	f062                	sd	s8,32(sp)
    800038a6:	ec66                	sd	s9,24(sp)
    800038a8:	e86a                	sd	s10,16(sp)
  int i = 0;
    800038aa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038ac:	f9f40c13          	addi	s8,s0,-97
    800038b0:	4b85                	li	s7,1
    800038b2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038b4:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038b8:	21c48c93          	addi	s9,s1,540
    800038bc:	a82d                	j	800038f6 <pipewrite+0x7e>
      release(&pi->lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	068020ef          	jal	80005928 <release>
      return -1;
    800038c4:	597d                	li	s2,-1
    800038c6:	7b42                	ld	s6,48(sp)
    800038c8:	7ba2                	ld	s7,40(sp)
    800038ca:	7c02                	ld	s8,32(sp)
    800038cc:	6ce2                	ld	s9,24(sp)
    800038ce:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038d0:	854a                	mv	a0,s2
    800038d2:	70a6                	ld	ra,104(sp)
    800038d4:	7406                	ld	s0,96(sp)
    800038d6:	64e6                	ld	s1,88(sp)
    800038d8:	6946                	ld	s2,80(sp)
    800038da:	69a6                	ld	s3,72(sp)
    800038dc:	6a06                	ld	s4,64(sp)
    800038de:	7ae2                	ld	s5,56(sp)
    800038e0:	6165                	addi	sp,sp,112
    800038e2:	8082                	ret
      wakeup(&pi->nread);
    800038e4:	856a                	mv	a0,s10
    800038e6:	aa1fd0ef          	jal	80001386 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038ea:	85a6                	mv	a1,s1
    800038ec:	8566                	mv	a0,s9
    800038ee:	a4dfd0ef          	jal	8000133a <sleep>
  while(i < n){
    800038f2:	05495a63          	bge	s2,s4,80003946 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800038f6:	2204a783          	lw	a5,544(s1)
    800038fa:	d3f1                	beqz	a5,800038be <pipewrite+0x46>
    800038fc:	854e                	mv	a0,s3
    800038fe:	c75fd0ef          	jal	80001572 <killed>
    80003902:	fd55                	bnez	a0,800038be <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003904:	2184a783          	lw	a5,536(s1)
    80003908:	21c4a703          	lw	a4,540(s1)
    8000390c:	2007879b          	addiw	a5,a5,512
    80003910:	fcf70ae3          	beq	a4,a5,800038e4 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003914:	86de                	mv	a3,s7
    80003916:	01590633          	add	a2,s2,s5
    8000391a:	85e2                	mv	a1,s8
    8000391c:	0509b503          	ld	a0,80(s3)
    80003920:	994fd0ef          	jal	80000ab4 <copyin>
    80003924:	05650063          	beq	a0,s6,80003964 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003928:	21c4a783          	lw	a5,540(s1)
    8000392c:	0017871b          	addiw	a4,a5,1
    80003930:	20e4ae23          	sw	a4,540(s1)
    80003934:	1ff7f793          	andi	a5,a5,511
    80003938:	97a6                	add	a5,a5,s1
    8000393a:	f9f44703          	lbu	a4,-97(s0)
    8000393e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003942:	2905                	addiw	s2,s2,1
    80003944:	b77d                	j	800038f2 <pipewrite+0x7a>
    80003946:	7b42                	ld	s6,48(sp)
    80003948:	7ba2                	ld	s7,40(sp)
    8000394a:	7c02                	ld	s8,32(sp)
    8000394c:	6ce2                	ld	s9,24(sp)
    8000394e:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003950:	21848513          	addi	a0,s1,536
    80003954:	a33fd0ef          	jal	80001386 <wakeup>
  release(&pi->lock);
    80003958:	8526                	mv	a0,s1
    8000395a:	7cf010ef          	jal	80005928 <release>
  return i;
    8000395e:	bf8d                	j	800038d0 <pipewrite+0x58>
  int i = 0;
    80003960:	4901                	li	s2,0
    80003962:	b7fd                	j	80003950 <pipewrite+0xd8>
    80003964:	7b42                	ld	s6,48(sp)
    80003966:	7ba2                	ld	s7,40(sp)
    80003968:	7c02                	ld	s8,32(sp)
    8000396a:	6ce2                	ld	s9,24(sp)
    8000396c:	6d42                	ld	s10,16(sp)
    8000396e:	b7cd                	j	80003950 <pipewrite+0xd8>

0000000080003970 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003970:	711d                	addi	sp,sp,-96
    80003972:	ec86                	sd	ra,88(sp)
    80003974:	e8a2                	sd	s0,80(sp)
    80003976:	e4a6                	sd	s1,72(sp)
    80003978:	e0ca                	sd	s2,64(sp)
    8000397a:	fc4e                	sd	s3,56(sp)
    8000397c:	f852                	sd	s4,48(sp)
    8000397e:	f456                	sd	s5,40(sp)
    80003980:	1080                	addi	s0,sp,96
    80003982:	84aa                	mv	s1,a0
    80003984:	892e                	mv	s2,a1
    80003986:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003988:	bd8fd0ef          	jal	80000d60 <myproc>
    8000398c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	705010ef          	jal	80005894 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003994:	2184a703          	lw	a4,536(s1)
    80003998:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000399c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039a0:	02f71763          	bne	a4,a5,800039ce <piperead+0x5e>
    800039a4:	2244a783          	lw	a5,548(s1)
    800039a8:	cf85                	beqz	a5,800039e0 <piperead+0x70>
    if(killed(pr)){
    800039aa:	8552                	mv	a0,s4
    800039ac:	bc7fd0ef          	jal	80001572 <killed>
    800039b0:	e11d                	bnez	a0,800039d6 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039b2:	85a6                	mv	a1,s1
    800039b4:	854e                	mv	a0,s3
    800039b6:	985fd0ef          	jal	8000133a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ba:	2184a703          	lw	a4,536(s1)
    800039be:	21c4a783          	lw	a5,540(s1)
    800039c2:	fef701e3          	beq	a4,a5,800039a4 <piperead+0x34>
    800039c6:	f05a                	sd	s6,32(sp)
    800039c8:	ec5e                	sd	s7,24(sp)
    800039ca:	e862                	sd	s8,16(sp)
    800039cc:	a829                	j	800039e6 <piperead+0x76>
    800039ce:	f05a                	sd	s6,32(sp)
    800039d0:	ec5e                	sd	s7,24(sp)
    800039d2:	e862                	sd	s8,16(sp)
    800039d4:	a809                	j	800039e6 <piperead+0x76>
      release(&pi->lock);
    800039d6:	8526                	mv	a0,s1
    800039d8:	751010ef          	jal	80005928 <release>
      return -1;
    800039dc:	59fd                	li	s3,-1
    800039de:	a0a5                	j	80003a46 <piperead+0xd6>
    800039e0:	f05a                	sd	s6,32(sp)
    800039e2:	ec5e                	sd	s7,24(sp)
    800039e4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039e8:	faf40c13          	addi	s8,s0,-81
    800039ec:	4b85                	li	s7,1
    800039ee:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039f0:	05505163          	blez	s5,80003a32 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    800039f4:	2184a783          	lw	a5,536(s1)
    800039f8:	21c4a703          	lw	a4,540(s1)
    800039fc:	02f70b63          	beq	a4,a5,80003a32 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a00:	0017871b          	addiw	a4,a5,1
    80003a04:	20e4ac23          	sw	a4,536(s1)
    80003a08:	1ff7f793          	andi	a5,a5,511
    80003a0c:	97a6                	add	a5,a5,s1
    80003a0e:	0187c783          	lbu	a5,24(a5)
    80003a12:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a16:	86de                	mv	a3,s7
    80003a18:	8662                	mv	a2,s8
    80003a1a:	85ca                	mv	a1,s2
    80003a1c:	050a3503          	ld	a0,80(s4)
    80003a20:	fe5fc0ef          	jal	80000a04 <copyout>
    80003a24:	01650763          	beq	a0,s6,80003a32 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a28:	2985                	addiw	s3,s3,1
    80003a2a:	0905                	addi	s2,s2,1
    80003a2c:	fd3a94e3          	bne	s5,s3,800039f4 <piperead+0x84>
    80003a30:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a32:	21c48513          	addi	a0,s1,540
    80003a36:	951fd0ef          	jal	80001386 <wakeup>
  release(&pi->lock);
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	6ed010ef          	jal	80005928 <release>
    80003a40:	7b02                	ld	s6,32(sp)
    80003a42:	6be2                	ld	s7,24(sp)
    80003a44:	6c42                	ld	s8,16(sp)
  return i;
}
    80003a46:	854e                	mv	a0,s3
    80003a48:	60e6                	ld	ra,88(sp)
    80003a4a:	6446                	ld	s0,80(sp)
    80003a4c:	64a6                	ld	s1,72(sp)
    80003a4e:	6906                	ld	s2,64(sp)
    80003a50:	79e2                	ld	s3,56(sp)
    80003a52:	7a42                	ld	s4,48(sp)
    80003a54:	7aa2                	ld	s5,40(sp)
    80003a56:	6125                	addi	sp,sp,96
    80003a58:	8082                	ret

0000000080003a5a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a5a:	1141                	addi	sp,sp,-16
    80003a5c:	e406                	sd	ra,8(sp)
    80003a5e:	e022                	sd	s0,0(sp)
    80003a60:	0800                	addi	s0,sp,16
    80003a62:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a64:	0035151b          	slliw	a0,a0,0x3
    80003a68:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003a6a:	8b89                	andi	a5,a5,2
    80003a6c:	c399                	beqz	a5,80003a72 <flags2perm+0x18>
      perm |= PTE_W;
    80003a6e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a72:	60a2                	ld	ra,8(sp)
    80003a74:	6402                	ld	s0,0(sp)
    80003a76:	0141                	addi	sp,sp,16
    80003a78:	8082                	ret

0000000080003a7a <exec>:

int
exec(char *path, char **argv)
{
    80003a7a:	de010113          	addi	sp,sp,-544
    80003a7e:	20113c23          	sd	ra,536(sp)
    80003a82:	20813823          	sd	s0,528(sp)
    80003a86:	20913423          	sd	s1,520(sp)
    80003a8a:	21213023          	sd	s2,512(sp)
    80003a8e:	1400                	addi	s0,sp,544
    80003a90:	892a                	mv	s2,a0
    80003a92:	dea43823          	sd	a0,-528(s0)
    80003a96:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a9a:	ac6fd0ef          	jal	80000d60 <myproc>
    80003a9e:	84aa                	mv	s1,a0

  begin_op();
    80003aa0:	d88ff0ef          	jal	80003028 <begin_op>

  if((ip = namei(path)) == 0){
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	bc0ff0ef          	jal	80002e66 <namei>
    80003aaa:	cd21                	beqz	a0,80003b02 <exec+0x88>
    80003aac:	fbd2                	sd	s4,496(sp)
    80003aae:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ab0:	cc7fe0ef          	jal	80002776 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ab4:	04000713          	li	a4,64
    80003ab8:	4681                	li	a3,0
    80003aba:	e5040613          	addi	a2,s0,-432
    80003abe:	4581                	li	a1,0
    80003ac0:	8552                	mv	a0,s4
    80003ac2:	f0dfe0ef          	jal	800029ce <readi>
    80003ac6:	04000793          	li	a5,64
    80003aca:	00f51a63          	bne	a0,a5,80003ade <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003ace:	e5042703          	lw	a4,-432(s0)
    80003ad2:	464c47b7          	lui	a5,0x464c4
    80003ad6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ada:	02f70863          	beq	a4,a5,80003b0a <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ade:	8552                	mv	a0,s4
    80003ae0:	ea1fe0ef          	jal	80002980 <iunlockput>
    end_op();
    80003ae4:	daeff0ef          	jal	80003092 <end_op>
  }
  return -1;
    80003ae8:	557d                	li	a0,-1
    80003aea:	7a5e                	ld	s4,496(sp)
}
    80003aec:	21813083          	ld	ra,536(sp)
    80003af0:	21013403          	ld	s0,528(sp)
    80003af4:	20813483          	ld	s1,520(sp)
    80003af8:	20013903          	ld	s2,512(sp)
    80003afc:	22010113          	addi	sp,sp,544
    80003b00:	8082                	ret
    end_op();
    80003b02:	d90ff0ef          	jal	80003092 <end_op>
    return -1;
    80003b06:	557d                	li	a0,-1
    80003b08:	b7d5                	j	80003aec <exec+0x72>
    80003b0a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	afafd0ef          	jal	80000e08 <proc_pagetable>
    80003b12:	8b2a                	mv	s6,a0
    80003b14:	26050d63          	beqz	a0,80003d8e <exec+0x314>
    80003b18:	ffce                	sd	s3,504(sp)
    80003b1a:	f7d6                	sd	s5,488(sp)
    80003b1c:	efde                	sd	s7,472(sp)
    80003b1e:	ebe2                	sd	s8,464(sp)
    80003b20:	e7e6                	sd	s9,456(sp)
    80003b22:	e3ea                	sd	s10,448(sp)
    80003b24:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b26:	e7042683          	lw	a3,-400(s0)
    80003b2a:	e8845783          	lhu	a5,-376(s0)
    80003b2e:	0e078763          	beqz	a5,80003c1c <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b32:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b34:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b36:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003b3a:	6c85                	lui	s9,0x1
    80003b3c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b40:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b44:	6a85                	lui	s5,0x1
    80003b46:	a085                	j	80003ba6 <exec+0x12c>
      panic("loadseg: address should exist");
    80003b48:	00004517          	auipc	a0,0x4
    80003b4c:	a5850513          	addi	a0,a0,-1448 # 800075a0 <etext+0x5a0>
    80003b50:	217010ef          	jal	80005566 <panic>
    if(sz - i < PGSIZE)
    80003b54:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b56:	874a                	mv	a4,s2
    80003b58:	009c06bb          	addw	a3,s8,s1
    80003b5c:	4581                	li	a1,0
    80003b5e:	8552                	mv	a0,s4
    80003b60:	e6ffe0ef          	jal	800029ce <readi>
    80003b64:	22a91963          	bne	s2,a0,80003d96 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b68:	009a84bb          	addw	s1,s5,s1
    80003b6c:	0334f263          	bgeu	s1,s3,80003b90 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003b70:	02049593          	slli	a1,s1,0x20
    80003b74:	9181                	srli	a1,a1,0x20
    80003b76:	95de                	add	a1,a1,s7
    80003b78:	855a                	mv	a0,s6
    80003b7a:	903fc0ef          	jal	8000047c <walkaddr>
    80003b7e:	862a                	mv	a2,a0
    if(pa == 0)
    80003b80:	d561                	beqz	a0,80003b48 <exec+0xce>
    if(sz - i < PGSIZE)
    80003b82:	409987bb          	subw	a5,s3,s1
    80003b86:	893e                	mv	s2,a5
    80003b88:	fcfcf6e3          	bgeu	s9,a5,80003b54 <exec+0xda>
    80003b8c:	8956                	mv	s2,s5
    80003b8e:	b7d9                	j	80003b54 <exec+0xda>
    sz = sz1;
    80003b90:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b94:	2d05                	addiw	s10,s10,1
    80003b96:	e0843783          	ld	a5,-504(s0)
    80003b9a:	0387869b          	addiw	a3,a5,56
    80003b9e:	e8845783          	lhu	a5,-376(s0)
    80003ba2:	06fd5e63          	bge	s10,a5,80003c1e <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ba6:	e0d43423          	sd	a3,-504(s0)
    80003baa:	876e                	mv	a4,s11
    80003bac:	e1840613          	addi	a2,s0,-488
    80003bb0:	4581                	li	a1,0
    80003bb2:	8552                	mv	a0,s4
    80003bb4:	e1bfe0ef          	jal	800029ce <readi>
    80003bb8:	1db51d63          	bne	a0,s11,80003d92 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003bbc:	e1842783          	lw	a5,-488(s0)
    80003bc0:	4705                	li	a4,1
    80003bc2:	fce799e3          	bne	a5,a4,80003b94 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003bc6:	e4043483          	ld	s1,-448(s0)
    80003bca:	e3843783          	ld	a5,-456(s0)
    80003bce:	1ef4e263          	bltu	s1,a5,80003db2 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bd2:	e2843783          	ld	a5,-472(s0)
    80003bd6:	94be                	add	s1,s1,a5
    80003bd8:	1ef4e063          	bltu	s1,a5,80003db8 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003bdc:	de843703          	ld	a4,-536(s0)
    80003be0:	8ff9                	and	a5,a5,a4
    80003be2:	1c079e63          	bnez	a5,80003dbe <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003be6:	e1c42503          	lw	a0,-484(s0)
    80003bea:	e71ff0ef          	jal	80003a5a <flags2perm>
    80003bee:	86aa                	mv	a3,a0
    80003bf0:	8626                	mv	a2,s1
    80003bf2:	85ca                	mv	a1,s2
    80003bf4:	855a                	mv	a0,s6
    80003bf6:	beffc0ef          	jal	800007e4 <uvmalloc>
    80003bfa:	dea43c23          	sd	a0,-520(s0)
    80003bfe:	1c050363          	beqz	a0,80003dc4 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c02:	e2843b83          	ld	s7,-472(s0)
    80003c06:	e2042c03          	lw	s8,-480(s0)
    80003c0a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c0e:	00098463          	beqz	s3,80003c16 <exec+0x19c>
    80003c12:	4481                	li	s1,0
    80003c14:	bfb1                	j	80003b70 <exec+0xf6>
    sz = sz1;
    80003c16:	df843903          	ld	s2,-520(s0)
    80003c1a:	bfad                	j	80003b94 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c1c:	4901                	li	s2,0
  iunlockput(ip);
    80003c1e:	8552                	mv	a0,s4
    80003c20:	d61fe0ef          	jal	80002980 <iunlockput>
  end_op();
    80003c24:	c6eff0ef          	jal	80003092 <end_op>
  p = myproc();
    80003c28:	938fd0ef          	jal	80000d60 <myproc>
    80003c2c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c2e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003c32:	6985                	lui	s3,0x1
    80003c34:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c36:	99ca                	add	s3,s3,s2
    80003c38:	77fd                	lui	a5,0xfffff
    80003c3a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c3e:	4691                	li	a3,4
    80003c40:	660d                	lui	a2,0x3
    80003c42:	964e                	add	a2,a2,s3
    80003c44:	85ce                	mv	a1,s3
    80003c46:	855a                	mv	a0,s6
    80003c48:	b9dfc0ef          	jal	800007e4 <uvmalloc>
    80003c4c:	8a2a                	mv	s4,a0
    80003c4e:	e105                	bnez	a0,80003c6e <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003c50:	85ce                	mv	a1,s3
    80003c52:	855a                	mv	a0,s6
    80003c54:	a38fd0ef          	jal	80000e8c <proc_freepagetable>
  return -1;
    80003c58:	557d                	li	a0,-1
    80003c5a:	79fe                	ld	s3,504(sp)
    80003c5c:	7a5e                	ld	s4,496(sp)
    80003c5e:	7abe                	ld	s5,488(sp)
    80003c60:	7b1e                	ld	s6,480(sp)
    80003c62:	6bfe                	ld	s7,472(sp)
    80003c64:	6c5e                	ld	s8,464(sp)
    80003c66:	6cbe                	ld	s9,456(sp)
    80003c68:	6d1e                	ld	s10,448(sp)
    80003c6a:	7dfa                	ld	s11,440(sp)
    80003c6c:	b541                	j	80003aec <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c6e:	75f5                	lui	a1,0xffffd
    80003c70:	95aa                	add	a1,a1,a0
    80003c72:	855a                	mv	a0,s6
    80003c74:	d67fc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c78:	7bf9                	lui	s7,0xffffe
    80003c7a:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c7c:	e0043783          	ld	a5,-512(s0)
    80003c80:	6388                	ld	a0,0(a5)
  sp = sz;
    80003c82:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c84:	4481                	li	s1,0
    ustack[argc] = sp;
    80003c86:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003c8a:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003c8e:	cd21                	beqz	a0,80003ce6 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003c90:	e46fc0ef          	jal	800002d6 <strlen>
    80003c94:	0015079b          	addiw	a5,a0,1
    80003c98:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c9c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ca0:	13796563          	bltu	s2,s7,80003dca <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ca4:	e0043d83          	ld	s11,-512(s0)
    80003ca8:	000db983          	ld	s3,0(s11)
    80003cac:	854e                	mv	a0,s3
    80003cae:	e28fc0ef          	jal	800002d6 <strlen>
    80003cb2:	0015069b          	addiw	a3,a0,1
    80003cb6:	864e                	mv	a2,s3
    80003cb8:	85ca                	mv	a1,s2
    80003cba:	855a                	mv	a0,s6
    80003cbc:	d49fc0ef          	jal	80000a04 <copyout>
    80003cc0:	10054763          	bltz	a0,80003dce <exec+0x354>
    ustack[argc] = sp;
    80003cc4:	00349793          	slli	a5,s1,0x3
    80003cc8:	97e6                	add	a5,a5,s9
    80003cca:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb990>
  for(argc = 0; argv[argc]; argc++) {
    80003cce:	0485                	addi	s1,s1,1
    80003cd0:	008d8793          	addi	a5,s11,8
    80003cd4:	e0f43023          	sd	a5,-512(s0)
    80003cd8:	008db503          	ld	a0,8(s11)
    80003cdc:	c509                	beqz	a0,80003ce6 <exec+0x26c>
    if(argc >= MAXARG)
    80003cde:	fb8499e3          	bne	s1,s8,80003c90 <exec+0x216>
  sz = sz1;
    80003ce2:	89d2                	mv	s3,s4
    80003ce4:	b7b5                	j	80003c50 <exec+0x1d6>
  ustack[argc] = 0;
    80003ce6:	00349793          	slli	a5,s1,0x3
    80003cea:	f9078793          	addi	a5,a5,-112
    80003cee:	97a2                	add	a5,a5,s0
    80003cf0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cf4:	00148693          	addi	a3,s1,1
    80003cf8:	068e                	slli	a3,a3,0x3
    80003cfa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cfe:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d02:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003d04:	f57966e3          	bltu	s2,s7,80003c50 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d08:	e9040613          	addi	a2,s0,-368
    80003d0c:	85ca                	mv	a1,s2
    80003d0e:	855a                	mv	a0,s6
    80003d10:	cf5fc0ef          	jal	80000a04 <copyout>
    80003d14:	f2054ee3          	bltz	a0,80003c50 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003d18:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d1c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d20:	df043783          	ld	a5,-528(s0)
    80003d24:	0007c703          	lbu	a4,0(a5)
    80003d28:	cf11                	beqz	a4,80003d44 <exec+0x2ca>
    80003d2a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d2c:	02f00693          	li	a3,47
    80003d30:	a029                	j	80003d3a <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003d32:	0785                	addi	a5,a5,1
    80003d34:	fff7c703          	lbu	a4,-1(a5)
    80003d38:	c711                	beqz	a4,80003d44 <exec+0x2ca>
    if(*s == '/')
    80003d3a:	fed71ce3          	bne	a4,a3,80003d32 <exec+0x2b8>
      last = s+1;
    80003d3e:	def43823          	sd	a5,-528(s0)
    80003d42:	bfc5                	j	80003d32 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d44:	4641                	li	a2,16
    80003d46:	df043583          	ld	a1,-528(s0)
    80003d4a:	158a8513          	addi	a0,s5,344
    80003d4e:	d52fc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d52:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d56:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d5a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d5e:	058ab783          	ld	a5,88(s5)
    80003d62:	e6843703          	ld	a4,-408(s0)
    80003d66:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d68:	058ab783          	ld	a5,88(s5)
    80003d6c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d70:	85ea                	mv	a1,s10
    80003d72:	91afd0ef          	jal	80000e8c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d76:	0004851b          	sext.w	a0,s1
    80003d7a:	79fe                	ld	s3,504(sp)
    80003d7c:	7a5e                	ld	s4,496(sp)
    80003d7e:	7abe                	ld	s5,488(sp)
    80003d80:	7b1e                	ld	s6,480(sp)
    80003d82:	6bfe                	ld	s7,472(sp)
    80003d84:	6c5e                	ld	s8,464(sp)
    80003d86:	6cbe                	ld	s9,456(sp)
    80003d88:	6d1e                	ld	s10,448(sp)
    80003d8a:	7dfa                	ld	s11,440(sp)
    80003d8c:	b385                	j	80003aec <exec+0x72>
    80003d8e:	7b1e                	ld	s6,480(sp)
    80003d90:	b3b9                	j	80003ade <exec+0x64>
    80003d92:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d96:	df843583          	ld	a1,-520(s0)
    80003d9a:	855a                	mv	a0,s6
    80003d9c:	8f0fd0ef          	jal	80000e8c <proc_freepagetable>
  if(ip){
    80003da0:	79fe                	ld	s3,504(sp)
    80003da2:	7abe                	ld	s5,488(sp)
    80003da4:	7b1e                	ld	s6,480(sp)
    80003da6:	6bfe                	ld	s7,472(sp)
    80003da8:	6c5e                	ld	s8,464(sp)
    80003daa:	6cbe                	ld	s9,456(sp)
    80003dac:	6d1e                	ld	s10,448(sp)
    80003dae:	7dfa                	ld	s11,440(sp)
    80003db0:	b33d                	j	80003ade <exec+0x64>
    80003db2:	df243c23          	sd	s2,-520(s0)
    80003db6:	b7c5                	j	80003d96 <exec+0x31c>
    80003db8:	df243c23          	sd	s2,-520(s0)
    80003dbc:	bfe9                	j	80003d96 <exec+0x31c>
    80003dbe:	df243c23          	sd	s2,-520(s0)
    80003dc2:	bfd1                	j	80003d96 <exec+0x31c>
    80003dc4:	df243c23          	sd	s2,-520(s0)
    80003dc8:	b7f9                	j	80003d96 <exec+0x31c>
  sz = sz1;
    80003dca:	89d2                	mv	s3,s4
    80003dcc:	b551                	j	80003c50 <exec+0x1d6>
    80003dce:	89d2                	mv	s3,s4
    80003dd0:	b541                	j	80003c50 <exec+0x1d6>

0000000080003dd2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dd2:	7179                	addi	sp,sp,-48
    80003dd4:	f406                	sd	ra,40(sp)
    80003dd6:	f022                	sd	s0,32(sp)
    80003dd8:	ec26                	sd	s1,24(sp)
    80003dda:	e84a                	sd	s2,16(sp)
    80003ddc:	1800                	addi	s0,sp,48
    80003dde:	892e                	mv	s2,a1
    80003de0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003de2:	fdc40593          	addi	a1,s0,-36
    80003de6:	e39fd0ef          	jal	80001c1e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003dea:	fdc42703          	lw	a4,-36(s0)
    80003dee:	47bd                	li	a5,15
    80003df0:	02e7e963          	bltu	a5,a4,80003e22 <argfd+0x50>
    80003df4:	f6dfc0ef          	jal	80000d60 <myproc>
    80003df8:	fdc42703          	lw	a4,-36(s0)
    80003dfc:	01a70793          	addi	a5,a4,26
    80003e00:	078e                	slli	a5,a5,0x3
    80003e02:	953e                	add	a0,a0,a5
    80003e04:	611c                	ld	a5,0(a0)
    80003e06:	c385                	beqz	a5,80003e26 <argfd+0x54>
    return -1;
  if(pfd)
    80003e08:	00090463          	beqz	s2,80003e10 <argfd+0x3e>
    *pfd = fd;
    80003e0c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e10:	4501                	li	a0,0
  if(pf)
    80003e12:	c091                	beqz	s1,80003e16 <argfd+0x44>
    *pf = f;
    80003e14:	e09c                	sd	a5,0(s1)
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	6145                	addi	sp,sp,48
    80003e20:	8082                	ret
    return -1;
    80003e22:	557d                	li	a0,-1
    80003e24:	bfcd                	j	80003e16 <argfd+0x44>
    80003e26:	557d                	li	a0,-1
    80003e28:	b7fd                	j	80003e16 <argfd+0x44>

0000000080003e2a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e2a:	1101                	addi	sp,sp,-32
    80003e2c:	ec06                	sd	ra,24(sp)
    80003e2e:	e822                	sd	s0,16(sp)
    80003e30:	e426                	sd	s1,8(sp)
    80003e32:	1000                	addi	s0,sp,32
    80003e34:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e36:	f2bfc0ef          	jal	80000d60 <myproc>
    80003e3a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e3c:	0d050793          	addi	a5,a0,208
    80003e40:	4501                	li	a0,0
    80003e42:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e44:	6398                	ld	a4,0(a5)
    80003e46:	cb19                	beqz	a4,80003e5c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e48:	2505                	addiw	a0,a0,1
    80003e4a:	07a1                	addi	a5,a5,8
    80003e4c:	fed51ce3          	bne	a0,a3,80003e44 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e50:	557d                	li	a0,-1
}
    80003e52:	60e2                	ld	ra,24(sp)
    80003e54:	6442                	ld	s0,16(sp)
    80003e56:	64a2                	ld	s1,8(sp)
    80003e58:	6105                	addi	sp,sp,32
    80003e5a:	8082                	ret
      p->ofile[fd] = f;
    80003e5c:	01a50793          	addi	a5,a0,26
    80003e60:	078e                	slli	a5,a5,0x3
    80003e62:	963e                	add	a2,a2,a5
    80003e64:	e204                	sd	s1,0(a2)
      return fd;
    80003e66:	b7f5                	j	80003e52 <fdalloc+0x28>

0000000080003e68 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e68:	715d                	addi	sp,sp,-80
    80003e6a:	e486                	sd	ra,72(sp)
    80003e6c:	e0a2                	sd	s0,64(sp)
    80003e6e:	fc26                	sd	s1,56(sp)
    80003e70:	f84a                	sd	s2,48(sp)
    80003e72:	f44e                	sd	s3,40(sp)
    80003e74:	ec56                	sd	s5,24(sp)
    80003e76:	e85a                	sd	s6,16(sp)
    80003e78:	0880                	addi	s0,sp,80
    80003e7a:	8b2e                	mv	s6,a1
    80003e7c:	89b2                	mv	s3,a2
    80003e7e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e80:	fb040593          	addi	a1,s0,-80
    80003e84:	ffdfe0ef          	jal	80002e80 <nameiparent>
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	10050a63          	beqz	a0,80003f9e <create+0x136>
    return 0;

  ilock(dp);
    80003e8e:	8e9fe0ef          	jal	80002776 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e92:	4601                	li	a2,0
    80003e94:	fb040593          	addi	a1,s0,-80
    80003e98:	8526                	mv	a0,s1
    80003e9a:	d41fe0ef          	jal	80002bda <dirlookup>
    80003e9e:	8aaa                	mv	s5,a0
    80003ea0:	c129                	beqz	a0,80003ee2 <create+0x7a>
    iunlockput(dp);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	addfe0ef          	jal	80002980 <iunlockput>
    ilock(ip);
    80003ea8:	8556                	mv	a0,s5
    80003eaa:	8cdfe0ef          	jal	80002776 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eae:	4789                	li	a5,2
    80003eb0:	02fb1463          	bne	s6,a5,80003ed8 <create+0x70>
    80003eb4:	044ad783          	lhu	a5,68(s5)
    80003eb8:	37f9                	addiw	a5,a5,-2
    80003eba:	17c2                	slli	a5,a5,0x30
    80003ebc:	93c1                	srli	a5,a5,0x30
    80003ebe:	4705                	li	a4,1
    80003ec0:	00f76c63          	bltu	a4,a5,80003ed8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ec4:	8556                	mv	a0,s5
    80003ec6:	60a6                	ld	ra,72(sp)
    80003ec8:	6406                	ld	s0,64(sp)
    80003eca:	74e2                	ld	s1,56(sp)
    80003ecc:	7942                	ld	s2,48(sp)
    80003ece:	79a2                	ld	s3,40(sp)
    80003ed0:	6ae2                	ld	s5,24(sp)
    80003ed2:	6b42                	ld	s6,16(sp)
    80003ed4:	6161                	addi	sp,sp,80
    80003ed6:	8082                	ret
    iunlockput(ip);
    80003ed8:	8556                	mv	a0,s5
    80003eda:	aa7fe0ef          	jal	80002980 <iunlockput>
    return 0;
    80003ede:	4a81                	li	s5,0
    80003ee0:	b7d5                	j	80003ec4 <create+0x5c>
    80003ee2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ee4:	85da                	mv	a1,s6
    80003ee6:	4088                	lw	a0,0(s1)
    80003ee8:	f1efe0ef          	jal	80002606 <ialloc>
    80003eec:	8a2a                	mv	s4,a0
    80003eee:	cd15                	beqz	a0,80003f2a <create+0xc2>
  ilock(ip);
    80003ef0:	887fe0ef          	jal	80002776 <ilock>
  ip->major = major;
    80003ef4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ef8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003efc:	4905                	li	s2,1
    80003efe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f02:	8552                	mv	a0,s4
    80003f04:	fbefe0ef          	jal	800026c2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f08:	032b0763          	beq	s6,s2,80003f36 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f0c:	004a2603          	lw	a2,4(s4)
    80003f10:	fb040593          	addi	a1,s0,-80
    80003f14:	8526                	mv	a0,s1
    80003f16:	ea7fe0ef          	jal	80002dbc <dirlink>
    80003f1a:	06054563          	bltz	a0,80003f84 <create+0x11c>
  iunlockput(dp);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	a61fe0ef          	jal	80002980 <iunlockput>
  return ip;
    80003f24:	8ad2                	mv	s5,s4
    80003f26:	7a02                	ld	s4,32(sp)
    80003f28:	bf71                	j	80003ec4 <create+0x5c>
    iunlockput(dp);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	a55fe0ef          	jal	80002980 <iunlockput>
    return 0;
    80003f30:	8ad2                	mv	s5,s4
    80003f32:	7a02                	ld	s4,32(sp)
    80003f34:	bf41                	j	80003ec4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f36:	004a2603          	lw	a2,4(s4)
    80003f3a:	00003597          	auipc	a1,0x3
    80003f3e:	68658593          	addi	a1,a1,1670 # 800075c0 <etext+0x5c0>
    80003f42:	8552                	mv	a0,s4
    80003f44:	e79fe0ef          	jal	80002dbc <dirlink>
    80003f48:	02054e63          	bltz	a0,80003f84 <create+0x11c>
    80003f4c:	40d0                	lw	a2,4(s1)
    80003f4e:	00003597          	auipc	a1,0x3
    80003f52:	67a58593          	addi	a1,a1,1658 # 800075c8 <etext+0x5c8>
    80003f56:	8552                	mv	a0,s4
    80003f58:	e65fe0ef          	jal	80002dbc <dirlink>
    80003f5c:	02054463          	bltz	a0,80003f84 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f60:	004a2603          	lw	a2,4(s4)
    80003f64:	fb040593          	addi	a1,s0,-80
    80003f68:	8526                	mv	a0,s1
    80003f6a:	e53fe0ef          	jal	80002dbc <dirlink>
    80003f6e:	00054b63          	bltz	a0,80003f84 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f72:	04a4d783          	lhu	a5,74(s1)
    80003f76:	2785                	addiw	a5,a5,1
    80003f78:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	f44fe0ef          	jal	800026c2 <iupdate>
    80003f82:	bf71                	j	80003f1e <create+0xb6>
  ip->nlink = 0;
    80003f84:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	f38fe0ef          	jal	800026c2 <iupdate>
  iunlockput(ip);
    80003f8e:	8552                	mv	a0,s4
    80003f90:	9f1fe0ef          	jal	80002980 <iunlockput>
  iunlockput(dp);
    80003f94:	8526                	mv	a0,s1
    80003f96:	9ebfe0ef          	jal	80002980 <iunlockput>
  return 0;
    80003f9a:	7a02                	ld	s4,32(sp)
    80003f9c:	b725                	j	80003ec4 <create+0x5c>
    return 0;
    80003f9e:	8aaa                	mv	s5,a0
    80003fa0:	b715                	j	80003ec4 <create+0x5c>

0000000080003fa2 <sys_dup>:
{
    80003fa2:	7179                	addi	sp,sp,-48
    80003fa4:	f406                	sd	ra,40(sp)
    80003fa6:	f022                	sd	s0,32(sp)
    80003fa8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003faa:	fd840613          	addi	a2,s0,-40
    80003fae:	4581                	li	a1,0
    80003fb0:	4501                	li	a0,0
    80003fb2:	e21ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80003fb6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fb8:	02054363          	bltz	a0,80003fde <sys_dup+0x3c>
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003fc0:	fd843903          	ld	s2,-40(s0)
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	e65ff0ef          	jal	80003e2a <fdalloc>
    80003fca:	84aa                	mv	s1,a0
    return -1;
    80003fcc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fce:	00054d63          	bltz	a0,80003fe8 <sys_dup+0x46>
  filedup(f);
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	c2eff0ef          	jal	80003402 <filedup>
  return fd;
    80003fd8:	87a6                	mv	a5,s1
    80003fda:	64e2                	ld	s1,24(sp)
    80003fdc:	6942                	ld	s2,16(sp)
}
    80003fde:	853e                	mv	a0,a5
    80003fe0:	70a2                	ld	ra,40(sp)
    80003fe2:	7402                	ld	s0,32(sp)
    80003fe4:	6145                	addi	sp,sp,48
    80003fe6:	8082                	ret
    80003fe8:	64e2                	ld	s1,24(sp)
    80003fea:	6942                	ld	s2,16(sp)
    80003fec:	bfcd                	j	80003fde <sys_dup+0x3c>

0000000080003fee <sys_read>:
{
    80003fee:	7179                	addi	sp,sp,-48
    80003ff0:	f406                	sd	ra,40(sp)
    80003ff2:	f022                	sd	s0,32(sp)
    80003ff4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff6:	fd840593          	addi	a1,s0,-40
    80003ffa:	4505                	li	a0,1
    80003ffc:	c3ffd0ef          	jal	80001c3a <argaddr>
  argint(2, &n);
    80004000:	fe440593          	addi	a1,s0,-28
    80004004:	4509                	li	a0,2
    80004006:	c19fd0ef          	jal	80001c1e <argint>
  if(argfd(0, 0, &f) < 0)
    8000400a:	fe840613          	addi	a2,s0,-24
    8000400e:	4581                	li	a1,0
    80004010:	4501                	li	a0,0
    80004012:	dc1ff0ef          	jal	80003dd2 <argfd>
    80004016:	87aa                	mv	a5,a0
    return -1;
    80004018:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401a:	0007ca63          	bltz	a5,8000402e <sys_read+0x40>
  return fileread(f, p, n);
    8000401e:	fe442603          	lw	a2,-28(s0)
    80004022:	fd843583          	ld	a1,-40(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	d3eff0ef          	jal	80003568 <fileread>
}
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret

0000000080004036 <sys_write>:
{
    80004036:	7179                	addi	sp,sp,-48
    80004038:	f406                	sd	ra,40(sp)
    8000403a:	f022                	sd	s0,32(sp)
    8000403c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000403e:	fd840593          	addi	a1,s0,-40
    80004042:	4505                	li	a0,1
    80004044:	bf7fd0ef          	jal	80001c3a <argaddr>
  argint(2, &n);
    80004048:	fe440593          	addi	a1,s0,-28
    8000404c:	4509                	li	a0,2
    8000404e:	bd1fd0ef          	jal	80001c1e <argint>
  if(argfd(0, 0, &f) < 0)
    80004052:	fe840613          	addi	a2,s0,-24
    80004056:	4581                	li	a1,0
    80004058:	4501                	li	a0,0
    8000405a:	d79ff0ef          	jal	80003dd2 <argfd>
    8000405e:	87aa                	mv	a5,a0
    return -1;
    80004060:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004062:	0007ca63          	bltz	a5,80004076 <sys_write+0x40>
  return filewrite(f, p, n);
    80004066:	fe442603          	lw	a2,-28(s0)
    8000406a:	fd843583          	ld	a1,-40(s0)
    8000406e:	fe843503          	ld	a0,-24(s0)
    80004072:	db4ff0ef          	jal	80003626 <filewrite>
}
    80004076:	70a2                	ld	ra,40(sp)
    80004078:	7402                	ld	s0,32(sp)
    8000407a:	6145                	addi	sp,sp,48
    8000407c:	8082                	ret

000000008000407e <sys_close>:
{
    8000407e:	1101                	addi	sp,sp,-32
    80004080:	ec06                	sd	ra,24(sp)
    80004082:	e822                	sd	s0,16(sp)
    80004084:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004086:	fe040613          	addi	a2,s0,-32
    8000408a:	fec40593          	addi	a1,s0,-20
    8000408e:	4501                	li	a0,0
    80004090:	d43ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80004094:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004096:	02054063          	bltz	a0,800040b6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000409a:	cc7fc0ef          	jal	80000d60 <myproc>
    8000409e:	fec42783          	lw	a5,-20(s0)
    800040a2:	07e9                	addi	a5,a5,26
    800040a4:	078e                	slli	a5,a5,0x3
    800040a6:	953e                	add	a0,a0,a5
    800040a8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040ac:	fe043503          	ld	a0,-32(s0)
    800040b0:	b98ff0ef          	jal	80003448 <fileclose>
  return 0;
    800040b4:	4781                	li	a5,0
}
    800040b6:	853e                	mv	a0,a5
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	6105                	addi	sp,sp,32
    800040be:	8082                	ret

00000000800040c0 <sys_fstat>:
{
    800040c0:	1101                	addi	sp,sp,-32
    800040c2:	ec06                	sd	ra,24(sp)
    800040c4:	e822                	sd	s0,16(sp)
    800040c6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040c8:	fe040593          	addi	a1,s0,-32
    800040cc:	4505                	li	a0,1
    800040ce:	b6dfd0ef          	jal	80001c3a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040d2:	fe840613          	addi	a2,s0,-24
    800040d6:	4581                	li	a1,0
    800040d8:	4501                	li	a0,0
    800040da:	cf9ff0ef          	jal	80003dd2 <argfd>
    800040de:	87aa                	mv	a5,a0
    return -1;
    800040e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040e2:	0007c863          	bltz	a5,800040f2 <sys_fstat+0x32>
  return filestat(f, st);
    800040e6:	fe043583          	ld	a1,-32(s0)
    800040ea:	fe843503          	ld	a0,-24(s0)
    800040ee:	c18ff0ef          	jal	80003506 <filestat>
}
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	6105                	addi	sp,sp,32
    800040f8:	8082                	ret

00000000800040fa <sys_link>:
{
    800040fa:	7169                	addi	sp,sp,-304
    800040fc:	f606                	sd	ra,296(sp)
    800040fe:	f222                	sd	s0,288(sp)
    80004100:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004102:	08000613          	li	a2,128
    80004106:	ed040593          	addi	a1,s0,-304
    8000410a:	4501                	li	a0,0
    8000410c:	b4bfd0ef          	jal	80001c56 <argstr>
    return -1;
    80004110:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004112:	0c054e63          	bltz	a0,800041ee <sys_link+0xf4>
    80004116:	08000613          	li	a2,128
    8000411a:	f5040593          	addi	a1,s0,-176
    8000411e:	4505                	li	a0,1
    80004120:	b37fd0ef          	jal	80001c56 <argstr>
    return -1;
    80004124:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004126:	0c054463          	bltz	a0,800041ee <sys_link+0xf4>
    8000412a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000412c:	efdfe0ef          	jal	80003028 <begin_op>
  if((ip = namei(old)) == 0){
    80004130:	ed040513          	addi	a0,s0,-304
    80004134:	d33fe0ef          	jal	80002e66 <namei>
    80004138:	84aa                	mv	s1,a0
    8000413a:	c53d                	beqz	a0,800041a8 <sys_link+0xae>
  ilock(ip);
    8000413c:	e3afe0ef          	jal	80002776 <ilock>
  if(ip->type == T_DIR){
    80004140:	04449703          	lh	a4,68(s1)
    80004144:	4785                	li	a5,1
    80004146:	06f70663          	beq	a4,a5,800041b2 <sys_link+0xb8>
    8000414a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000414c:	04a4d783          	lhu	a5,74(s1)
    80004150:	2785                	addiw	a5,a5,1
    80004152:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004156:	8526                	mv	a0,s1
    80004158:	d6afe0ef          	jal	800026c2 <iupdate>
  iunlock(ip);
    8000415c:	8526                	mv	a0,s1
    8000415e:	ec6fe0ef          	jal	80002824 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004162:	fd040593          	addi	a1,s0,-48
    80004166:	f5040513          	addi	a0,s0,-176
    8000416a:	d17fe0ef          	jal	80002e80 <nameiparent>
    8000416e:	892a                	mv	s2,a0
    80004170:	cd21                	beqz	a0,800041c8 <sys_link+0xce>
  ilock(dp);
    80004172:	e04fe0ef          	jal	80002776 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004176:	00092703          	lw	a4,0(s2)
    8000417a:	409c                	lw	a5,0(s1)
    8000417c:	04f71363          	bne	a4,a5,800041c2 <sys_link+0xc8>
    80004180:	40d0                	lw	a2,4(s1)
    80004182:	fd040593          	addi	a1,s0,-48
    80004186:	854a                	mv	a0,s2
    80004188:	c35fe0ef          	jal	80002dbc <dirlink>
    8000418c:	02054b63          	bltz	a0,800041c2 <sys_link+0xc8>
  iunlockput(dp);
    80004190:	854a                	mv	a0,s2
    80004192:	feefe0ef          	jal	80002980 <iunlockput>
  iput(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	f60fe0ef          	jal	800028f8 <iput>
  end_op();
    8000419c:	ef7fe0ef          	jal	80003092 <end_op>
  return 0;
    800041a0:	4781                	li	a5,0
    800041a2:	64f2                	ld	s1,280(sp)
    800041a4:	6952                	ld	s2,272(sp)
    800041a6:	a0a1                	j	800041ee <sys_link+0xf4>
    end_op();
    800041a8:	eebfe0ef          	jal	80003092 <end_op>
    return -1;
    800041ac:	57fd                	li	a5,-1
    800041ae:	64f2                	ld	s1,280(sp)
    800041b0:	a83d                	j	800041ee <sys_link+0xf4>
    iunlockput(ip);
    800041b2:	8526                	mv	a0,s1
    800041b4:	fccfe0ef          	jal	80002980 <iunlockput>
    end_op();
    800041b8:	edbfe0ef          	jal	80003092 <end_op>
    return -1;
    800041bc:	57fd                	li	a5,-1
    800041be:	64f2                	ld	s1,280(sp)
    800041c0:	a03d                	j	800041ee <sys_link+0xf4>
    iunlockput(dp);
    800041c2:	854a                	mv	a0,s2
    800041c4:	fbcfe0ef          	jal	80002980 <iunlockput>
  ilock(ip);
    800041c8:	8526                	mv	a0,s1
    800041ca:	dacfe0ef          	jal	80002776 <ilock>
  ip->nlink--;
    800041ce:	04a4d783          	lhu	a5,74(s1)
    800041d2:	37fd                	addiw	a5,a5,-1
    800041d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041d8:	8526                	mv	a0,s1
    800041da:	ce8fe0ef          	jal	800026c2 <iupdate>
  iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	fa0fe0ef          	jal	80002980 <iunlockput>
  end_op();
    800041e4:	eaffe0ef          	jal	80003092 <end_op>
  return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	6952                	ld	s2,272(sp)
}
    800041ee:	853e                	mv	a0,a5
    800041f0:	70b2                	ld	ra,296(sp)
    800041f2:	7412                	ld	s0,288(sp)
    800041f4:	6155                	addi	sp,sp,304
    800041f6:	8082                	ret

00000000800041f8 <sys_unlink>:
{
    800041f8:	7111                	addi	sp,sp,-256
    800041fa:	fd86                	sd	ra,248(sp)
    800041fc:	f9a2                	sd	s0,240(sp)
    800041fe:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004200:	08000613          	li	a2,128
    80004204:	f2040593          	addi	a1,s0,-224
    80004208:	4501                	li	a0,0
    8000420a:	a4dfd0ef          	jal	80001c56 <argstr>
    8000420e:	16054663          	bltz	a0,8000437a <sys_unlink+0x182>
    80004212:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004214:	e15fe0ef          	jal	80003028 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004218:	fa040593          	addi	a1,s0,-96
    8000421c:	f2040513          	addi	a0,s0,-224
    80004220:	c61fe0ef          	jal	80002e80 <nameiparent>
    80004224:	84aa                	mv	s1,a0
    80004226:	c955                	beqz	a0,800042da <sys_unlink+0xe2>
  ilock(dp);
    80004228:	d4efe0ef          	jal	80002776 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000422c:	00003597          	auipc	a1,0x3
    80004230:	39458593          	addi	a1,a1,916 # 800075c0 <etext+0x5c0>
    80004234:	fa040513          	addi	a0,s0,-96
    80004238:	98dfe0ef          	jal	80002bc4 <namecmp>
    8000423c:	12050463          	beqz	a0,80004364 <sys_unlink+0x16c>
    80004240:	00003597          	auipc	a1,0x3
    80004244:	38858593          	addi	a1,a1,904 # 800075c8 <etext+0x5c8>
    80004248:	fa040513          	addi	a0,s0,-96
    8000424c:	979fe0ef          	jal	80002bc4 <namecmp>
    80004250:	10050a63          	beqz	a0,80004364 <sys_unlink+0x16c>
    80004254:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004256:	f1c40613          	addi	a2,s0,-228
    8000425a:	fa040593          	addi	a1,s0,-96
    8000425e:	8526                	mv	a0,s1
    80004260:	97bfe0ef          	jal	80002bda <dirlookup>
    80004264:	892a                	mv	s2,a0
    80004266:	0e050e63          	beqz	a0,80004362 <sys_unlink+0x16a>
    8000426a:	edce                	sd	s3,216(sp)
  ilock(ip);
    8000426c:	d0afe0ef          	jal	80002776 <ilock>
  if(ip->nlink < 1)
    80004270:	04a91783          	lh	a5,74(s2)
    80004274:	06f05863          	blez	a5,800042e4 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004278:	04491703          	lh	a4,68(s2)
    8000427c:	4785                	li	a5,1
    8000427e:	06f70b63          	beq	a4,a5,800042f4 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004282:	fb040993          	addi	s3,s0,-80
    80004286:	4641                	li	a2,16
    80004288:	4581                	li	a1,0
    8000428a:	854e                	mv	a0,s3
    8000428c:	ec3fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004290:	4741                	li	a4,16
    80004292:	f1c42683          	lw	a3,-228(s0)
    80004296:	864e                	mv	a2,s3
    80004298:	4581                	li	a1,0
    8000429a:	8526                	mv	a0,s1
    8000429c:	825fe0ef          	jal	80002ac0 <writei>
    800042a0:	47c1                	li	a5,16
    800042a2:	08f51f63          	bne	a0,a5,80004340 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    800042a6:	04491703          	lh	a4,68(s2)
    800042aa:	4785                	li	a5,1
    800042ac:	0af70263          	beq	a4,a5,80004350 <sys_unlink+0x158>
  iunlockput(dp);
    800042b0:	8526                	mv	a0,s1
    800042b2:	ecefe0ef          	jal	80002980 <iunlockput>
  ip->nlink--;
    800042b6:	04a95783          	lhu	a5,74(s2)
    800042ba:	37fd                	addiw	a5,a5,-1
    800042bc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042c0:	854a                	mv	a0,s2
    800042c2:	c00fe0ef          	jal	800026c2 <iupdate>
  iunlockput(ip);
    800042c6:	854a                	mv	a0,s2
    800042c8:	eb8fe0ef          	jal	80002980 <iunlockput>
  end_op();
    800042cc:	dc7fe0ef          	jal	80003092 <end_op>
  return 0;
    800042d0:	4501                	li	a0,0
    800042d2:	74ae                	ld	s1,232(sp)
    800042d4:	790e                	ld	s2,224(sp)
    800042d6:	69ee                	ld	s3,216(sp)
    800042d8:	a869                	j	80004372 <sys_unlink+0x17a>
    end_op();
    800042da:	db9fe0ef          	jal	80003092 <end_op>
    return -1;
    800042de:	557d                	li	a0,-1
    800042e0:	74ae                	ld	s1,232(sp)
    800042e2:	a841                	j	80004372 <sys_unlink+0x17a>
    800042e4:	e9d2                	sd	s4,208(sp)
    800042e6:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800042e8:	00003517          	auipc	a0,0x3
    800042ec:	2e850513          	addi	a0,a0,744 # 800075d0 <etext+0x5d0>
    800042f0:	276010ef          	jal	80005566 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042f4:	04c92703          	lw	a4,76(s2)
    800042f8:	02000793          	li	a5,32
    800042fc:	f8e7f3e3          	bgeu	a5,a4,80004282 <sys_unlink+0x8a>
    80004300:	e9d2                	sd	s4,208(sp)
    80004302:	e5d6                	sd	s5,200(sp)
    80004304:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004306:	f0840a93          	addi	s5,s0,-248
    8000430a:	4a41                	li	s4,16
    8000430c:	8752                	mv	a4,s4
    8000430e:	86ce                	mv	a3,s3
    80004310:	8656                	mv	a2,s5
    80004312:	4581                	li	a1,0
    80004314:	854a                	mv	a0,s2
    80004316:	eb8fe0ef          	jal	800029ce <readi>
    8000431a:	01451d63          	bne	a0,s4,80004334 <sys_unlink+0x13c>
    if(de.inum != 0)
    8000431e:	f0845783          	lhu	a5,-248(s0)
    80004322:	efb1                	bnez	a5,8000437e <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004324:	29c1                	addiw	s3,s3,16
    80004326:	04c92783          	lw	a5,76(s2)
    8000432a:	fef9e1e3          	bltu	s3,a5,8000430c <sys_unlink+0x114>
    8000432e:	6a4e                	ld	s4,208(sp)
    80004330:	6aae                	ld	s5,200(sp)
    80004332:	bf81                	j	80004282 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004334:	00003517          	auipc	a0,0x3
    80004338:	2b450513          	addi	a0,a0,692 # 800075e8 <etext+0x5e8>
    8000433c:	22a010ef          	jal	80005566 <panic>
    80004340:	e9d2                	sd	s4,208(sp)
    80004342:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004344:	00003517          	auipc	a0,0x3
    80004348:	2bc50513          	addi	a0,a0,700 # 80007600 <etext+0x600>
    8000434c:	21a010ef          	jal	80005566 <panic>
    dp->nlink--;
    80004350:	04a4d783          	lhu	a5,74(s1)
    80004354:	37fd                	addiw	a5,a5,-1
    80004356:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000435a:	8526                	mv	a0,s1
    8000435c:	b66fe0ef          	jal	800026c2 <iupdate>
    80004360:	bf81                	j	800042b0 <sys_unlink+0xb8>
    80004362:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004364:	8526                	mv	a0,s1
    80004366:	e1afe0ef          	jal	80002980 <iunlockput>
  end_op();
    8000436a:	d29fe0ef          	jal	80003092 <end_op>
  return -1;
    8000436e:	557d                	li	a0,-1
    80004370:	74ae                	ld	s1,232(sp)
}
    80004372:	70ee                	ld	ra,248(sp)
    80004374:	744e                	ld	s0,240(sp)
    80004376:	6111                	addi	sp,sp,256
    80004378:	8082                	ret
    return -1;
    8000437a:	557d                	li	a0,-1
    8000437c:	bfdd                	j	80004372 <sys_unlink+0x17a>
    iunlockput(ip);
    8000437e:	854a                	mv	a0,s2
    80004380:	e00fe0ef          	jal	80002980 <iunlockput>
    goto bad;
    80004384:	790e                	ld	s2,224(sp)
    80004386:	69ee                	ld	s3,216(sp)
    80004388:	6a4e                	ld	s4,208(sp)
    8000438a:	6aae                	ld	s5,200(sp)
    8000438c:	bfe1                	j	80004364 <sys_unlink+0x16c>

000000008000438e <sys_open>:

uint64
sys_open(void)
{
    8000438e:	7131                	addi	sp,sp,-192
    80004390:	fd06                	sd	ra,184(sp)
    80004392:	f922                	sd	s0,176(sp)
    80004394:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004396:	f4c40593          	addi	a1,s0,-180
    8000439a:	4505                	li	a0,1
    8000439c:	883fd0ef          	jal	80001c1e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043a0:	08000613          	li	a2,128
    800043a4:	f5040593          	addi	a1,s0,-176
    800043a8:	4501                	li	a0,0
    800043aa:	8adfd0ef          	jal	80001c56 <argstr>
    800043ae:	87aa                	mv	a5,a0
    return -1;
    800043b0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043b2:	0a07c363          	bltz	a5,80004458 <sys_open+0xca>
    800043b6:	f526                	sd	s1,168(sp)

  begin_op();
    800043b8:	c71fe0ef          	jal	80003028 <begin_op>

  if(omode & O_CREATE){
    800043bc:	f4c42783          	lw	a5,-180(s0)
    800043c0:	2007f793          	andi	a5,a5,512
    800043c4:	c3dd                	beqz	a5,8000446a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800043c6:	4681                	li	a3,0
    800043c8:	4601                	li	a2,0
    800043ca:	4589                	li	a1,2
    800043cc:	f5040513          	addi	a0,s0,-176
    800043d0:	a99ff0ef          	jal	80003e68 <create>
    800043d4:	84aa                	mv	s1,a0
    if(ip == 0){
    800043d6:	c549                	beqz	a0,80004460 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043d8:	04449703          	lh	a4,68(s1)
    800043dc:	478d                	li	a5,3
    800043de:	00f71763          	bne	a4,a5,800043ec <sys_open+0x5e>
    800043e2:	0464d703          	lhu	a4,70(s1)
    800043e6:	47a5                	li	a5,9
    800043e8:	0ae7ee63          	bltu	a5,a4,800044a4 <sys_open+0x116>
    800043ec:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043ee:	fb7fe0ef          	jal	800033a4 <filealloc>
    800043f2:	892a                	mv	s2,a0
    800043f4:	c561                	beqz	a0,800044bc <sys_open+0x12e>
    800043f6:	ed4e                	sd	s3,152(sp)
    800043f8:	a33ff0ef          	jal	80003e2a <fdalloc>
    800043fc:	89aa                	mv	s3,a0
    800043fe:	0a054b63          	bltz	a0,800044b4 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004402:	04449703          	lh	a4,68(s1)
    80004406:	478d                	li	a5,3
    80004408:	0cf70363          	beq	a4,a5,800044ce <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000440c:	4789                	li	a5,2
    8000440e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004412:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004416:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000441a:	f4c42783          	lw	a5,-180(s0)
    8000441e:	0017f713          	andi	a4,a5,1
    80004422:	00174713          	xori	a4,a4,1
    80004426:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000442a:	0037f713          	andi	a4,a5,3
    8000442e:	00e03733          	snez	a4,a4
    80004432:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004436:	4007f793          	andi	a5,a5,1024
    8000443a:	c791                	beqz	a5,80004446 <sys_open+0xb8>
    8000443c:	04449703          	lh	a4,68(s1)
    80004440:	4789                	li	a5,2
    80004442:	08f70d63          	beq	a4,a5,800044dc <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004446:	8526                	mv	a0,s1
    80004448:	bdcfe0ef          	jal	80002824 <iunlock>
  end_op();
    8000444c:	c47fe0ef          	jal	80003092 <end_op>

  return fd;
    80004450:	854e                	mv	a0,s3
    80004452:	74aa                	ld	s1,168(sp)
    80004454:	790a                	ld	s2,160(sp)
    80004456:	69ea                	ld	s3,152(sp)
}
    80004458:	70ea                	ld	ra,184(sp)
    8000445a:	744a                	ld	s0,176(sp)
    8000445c:	6129                	addi	sp,sp,192
    8000445e:	8082                	ret
      end_op();
    80004460:	c33fe0ef          	jal	80003092 <end_op>
      return -1;
    80004464:	557d                	li	a0,-1
    80004466:	74aa                	ld	s1,168(sp)
    80004468:	bfc5                	j	80004458 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000446a:	f5040513          	addi	a0,s0,-176
    8000446e:	9f9fe0ef          	jal	80002e66 <namei>
    80004472:	84aa                	mv	s1,a0
    80004474:	c11d                	beqz	a0,8000449a <sys_open+0x10c>
    ilock(ip);
    80004476:	b00fe0ef          	jal	80002776 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000447a:	04449703          	lh	a4,68(s1)
    8000447e:	4785                	li	a5,1
    80004480:	f4f71ce3          	bne	a4,a5,800043d8 <sys_open+0x4a>
    80004484:	f4c42783          	lw	a5,-180(s0)
    80004488:	d3b5                	beqz	a5,800043ec <sys_open+0x5e>
      iunlockput(ip);
    8000448a:	8526                	mv	a0,s1
    8000448c:	cf4fe0ef          	jal	80002980 <iunlockput>
      end_op();
    80004490:	c03fe0ef          	jal	80003092 <end_op>
      return -1;
    80004494:	557d                	li	a0,-1
    80004496:	74aa                	ld	s1,168(sp)
    80004498:	b7c1                	j	80004458 <sys_open+0xca>
      end_op();
    8000449a:	bf9fe0ef          	jal	80003092 <end_op>
      return -1;
    8000449e:	557d                	li	a0,-1
    800044a0:	74aa                	ld	s1,168(sp)
    800044a2:	bf5d                	j	80004458 <sys_open+0xca>
    iunlockput(ip);
    800044a4:	8526                	mv	a0,s1
    800044a6:	cdafe0ef          	jal	80002980 <iunlockput>
    end_op();
    800044aa:	be9fe0ef          	jal	80003092 <end_op>
    return -1;
    800044ae:	557d                	li	a0,-1
    800044b0:	74aa                	ld	s1,168(sp)
    800044b2:	b75d                	j	80004458 <sys_open+0xca>
      fileclose(f);
    800044b4:	854a                	mv	a0,s2
    800044b6:	f93fe0ef          	jal	80003448 <fileclose>
    800044ba:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044bc:	8526                	mv	a0,s1
    800044be:	cc2fe0ef          	jal	80002980 <iunlockput>
    end_op();
    800044c2:	bd1fe0ef          	jal	80003092 <end_op>
    return -1;
    800044c6:	557d                	li	a0,-1
    800044c8:	74aa                	ld	s1,168(sp)
    800044ca:	790a                	ld	s2,160(sp)
    800044cc:	b771                	j	80004458 <sys_open+0xca>
    f->type = FD_DEVICE;
    800044ce:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044d2:	04649783          	lh	a5,70(s1)
    800044d6:	02f91223          	sh	a5,36(s2)
    800044da:	bf35                	j	80004416 <sys_open+0x88>
    itrunc(ip);
    800044dc:	8526                	mv	a0,s1
    800044de:	b86fe0ef          	jal	80002864 <itrunc>
    800044e2:	b795                	j	80004446 <sys_open+0xb8>

00000000800044e4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044e4:	7175                	addi	sp,sp,-144
    800044e6:	e506                	sd	ra,136(sp)
    800044e8:	e122                	sd	s0,128(sp)
    800044ea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800044ec:	b3dfe0ef          	jal	80003028 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800044f0:	08000613          	li	a2,128
    800044f4:	f7040593          	addi	a1,s0,-144
    800044f8:	4501                	li	a0,0
    800044fa:	f5cfd0ef          	jal	80001c56 <argstr>
    800044fe:	02054363          	bltz	a0,80004524 <sys_mkdir+0x40>
    80004502:	4681                	li	a3,0
    80004504:	4601                	li	a2,0
    80004506:	4585                	li	a1,1
    80004508:	f7040513          	addi	a0,s0,-144
    8000450c:	95dff0ef          	jal	80003e68 <create>
    80004510:	c911                	beqz	a0,80004524 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004512:	c6efe0ef          	jal	80002980 <iunlockput>
  end_op();
    80004516:	b7dfe0ef          	jal	80003092 <end_op>
  return 0;
    8000451a:	4501                	li	a0,0
}
    8000451c:	60aa                	ld	ra,136(sp)
    8000451e:	640a                	ld	s0,128(sp)
    80004520:	6149                	addi	sp,sp,144
    80004522:	8082                	ret
    end_op();
    80004524:	b6ffe0ef          	jal	80003092 <end_op>
    return -1;
    80004528:	557d                	li	a0,-1
    8000452a:	bfcd                	j	8000451c <sys_mkdir+0x38>

000000008000452c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000452c:	7135                	addi	sp,sp,-160
    8000452e:	ed06                	sd	ra,152(sp)
    80004530:	e922                	sd	s0,144(sp)
    80004532:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004534:	af5fe0ef          	jal	80003028 <begin_op>
  argint(1, &major);
    80004538:	f6c40593          	addi	a1,s0,-148
    8000453c:	4505                	li	a0,1
    8000453e:	ee0fd0ef          	jal	80001c1e <argint>
  argint(2, &minor);
    80004542:	f6840593          	addi	a1,s0,-152
    80004546:	4509                	li	a0,2
    80004548:	ed6fd0ef          	jal	80001c1e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000454c:	08000613          	li	a2,128
    80004550:	f7040593          	addi	a1,s0,-144
    80004554:	4501                	li	a0,0
    80004556:	f00fd0ef          	jal	80001c56 <argstr>
    8000455a:	02054563          	bltz	a0,80004584 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000455e:	f6841683          	lh	a3,-152(s0)
    80004562:	f6c41603          	lh	a2,-148(s0)
    80004566:	458d                	li	a1,3
    80004568:	f7040513          	addi	a0,s0,-144
    8000456c:	8fdff0ef          	jal	80003e68 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004570:	c911                	beqz	a0,80004584 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004572:	c0efe0ef          	jal	80002980 <iunlockput>
  end_op();
    80004576:	b1dfe0ef          	jal	80003092 <end_op>
  return 0;
    8000457a:	4501                	li	a0,0
}
    8000457c:	60ea                	ld	ra,152(sp)
    8000457e:	644a                	ld	s0,144(sp)
    80004580:	610d                	addi	sp,sp,160
    80004582:	8082                	ret
    end_op();
    80004584:	b0ffe0ef          	jal	80003092 <end_op>
    return -1;
    80004588:	557d                	li	a0,-1
    8000458a:	bfcd                	j	8000457c <sys_mknod+0x50>

000000008000458c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000458c:	7135                	addi	sp,sp,-160
    8000458e:	ed06                	sd	ra,152(sp)
    80004590:	e922                	sd	s0,144(sp)
    80004592:	e14a                	sd	s2,128(sp)
    80004594:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004596:	fcafc0ef          	jal	80000d60 <myproc>
    8000459a:	892a                	mv	s2,a0
  
  begin_op();
    8000459c:	a8dfe0ef          	jal	80003028 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045a0:	08000613          	li	a2,128
    800045a4:	f6040593          	addi	a1,s0,-160
    800045a8:	4501                	li	a0,0
    800045aa:	eacfd0ef          	jal	80001c56 <argstr>
    800045ae:	04054363          	bltz	a0,800045f4 <sys_chdir+0x68>
    800045b2:	e526                	sd	s1,136(sp)
    800045b4:	f6040513          	addi	a0,s0,-160
    800045b8:	8affe0ef          	jal	80002e66 <namei>
    800045bc:	84aa                	mv	s1,a0
    800045be:	c915                	beqz	a0,800045f2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045c0:	9b6fe0ef          	jal	80002776 <ilock>
  if(ip->type != T_DIR){
    800045c4:	04449703          	lh	a4,68(s1)
    800045c8:	4785                	li	a5,1
    800045ca:	02f71963          	bne	a4,a5,800045fc <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045ce:	8526                	mv	a0,s1
    800045d0:	a54fe0ef          	jal	80002824 <iunlock>
  iput(p->cwd);
    800045d4:	15093503          	ld	a0,336(s2)
    800045d8:	b20fe0ef          	jal	800028f8 <iput>
  end_op();
    800045dc:	ab7fe0ef          	jal	80003092 <end_op>
  p->cwd = ip;
    800045e0:	14993823          	sd	s1,336(s2)
  return 0;
    800045e4:	4501                	li	a0,0
    800045e6:	64aa                	ld	s1,136(sp)
}
    800045e8:	60ea                	ld	ra,152(sp)
    800045ea:	644a                	ld	s0,144(sp)
    800045ec:	690a                	ld	s2,128(sp)
    800045ee:	610d                	addi	sp,sp,160
    800045f0:	8082                	ret
    800045f2:	64aa                	ld	s1,136(sp)
    end_op();
    800045f4:	a9ffe0ef          	jal	80003092 <end_op>
    return -1;
    800045f8:	557d                	li	a0,-1
    800045fa:	b7fd                	j	800045e8 <sys_chdir+0x5c>
    iunlockput(ip);
    800045fc:	8526                	mv	a0,s1
    800045fe:	b82fe0ef          	jal	80002980 <iunlockput>
    end_op();
    80004602:	a91fe0ef          	jal	80003092 <end_op>
    return -1;
    80004606:	557d                	li	a0,-1
    80004608:	64aa                	ld	s1,136(sp)
    8000460a:	bff9                	j	800045e8 <sys_chdir+0x5c>

000000008000460c <sys_exec>:

uint64
sys_exec(void)
{
    8000460c:	7105                	addi	sp,sp,-480
    8000460e:	ef86                	sd	ra,472(sp)
    80004610:	eba2                	sd	s0,464(sp)
    80004612:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004614:	e2840593          	addi	a1,s0,-472
    80004618:	4505                	li	a0,1
    8000461a:	e20fd0ef          	jal	80001c3a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000461e:	08000613          	li	a2,128
    80004622:	f3040593          	addi	a1,s0,-208
    80004626:	4501                	li	a0,0
    80004628:	e2efd0ef          	jal	80001c56 <argstr>
    8000462c:	87aa                	mv	a5,a0
    return -1;
    8000462e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004630:	0e07c063          	bltz	a5,80004710 <sys_exec+0x104>
    80004634:	e7a6                	sd	s1,456(sp)
    80004636:	e3ca                	sd	s2,448(sp)
    80004638:	ff4e                	sd	s3,440(sp)
    8000463a:	fb52                	sd	s4,432(sp)
    8000463c:	f756                	sd	s5,424(sp)
    8000463e:	f35a                	sd	s6,416(sp)
    80004640:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004642:	e3040a13          	addi	s4,s0,-464
    80004646:	10000613          	li	a2,256
    8000464a:	4581                	li	a1,0
    8000464c:	8552                	mv	a0,s4
    8000464e:	b01fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004652:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004654:	89d2                	mv	s3,s4
    80004656:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004658:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000465c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000465e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004662:	00391513          	slli	a0,s2,0x3
    80004666:	85d6                	mv	a1,s5
    80004668:	e2843783          	ld	a5,-472(s0)
    8000466c:	953e                	add	a0,a0,a5
    8000466e:	d26fd0ef          	jal	80001b94 <fetchaddr>
    80004672:	02054663          	bltz	a0,8000469e <sys_exec+0x92>
    if(uarg == 0){
    80004676:	e2043783          	ld	a5,-480(s0)
    8000467a:	c7a1                	beqz	a5,800046c2 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000467c:	a83fb0ef          	jal	800000fe <kalloc>
    80004680:	85aa                	mv	a1,a0
    80004682:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004686:	cd01                	beqz	a0,8000469e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004688:	865a                	mv	a2,s6
    8000468a:	e2043503          	ld	a0,-480(s0)
    8000468e:	d50fd0ef          	jal	80001bde <fetchstr>
    80004692:	00054663          	bltz	a0,8000469e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004696:	0905                	addi	s2,s2,1
    80004698:	09a1                	addi	s3,s3,8
    8000469a:	fd7914e3          	bne	s2,s7,80004662 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000469e:	100a0a13          	addi	s4,s4,256
    800046a2:	6088                	ld	a0,0(s1)
    800046a4:	cd31                	beqz	a0,80004700 <sys_exec+0xf4>
    kfree(argv[i]);
    800046a6:	977fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046aa:	04a1                	addi	s1,s1,8
    800046ac:	ff449be3          	bne	s1,s4,800046a2 <sys_exec+0x96>
  return -1;
    800046b0:	557d                	li	a0,-1
    800046b2:	64be                	ld	s1,456(sp)
    800046b4:	691e                	ld	s2,448(sp)
    800046b6:	79fa                	ld	s3,440(sp)
    800046b8:	7a5a                	ld	s4,432(sp)
    800046ba:	7aba                	ld	s5,424(sp)
    800046bc:	7b1a                	ld	s6,416(sp)
    800046be:	6bfa                	ld	s7,408(sp)
    800046c0:	a881                	j	80004710 <sys_exec+0x104>
      argv[i] = 0;
    800046c2:	0009079b          	sext.w	a5,s2
    800046c6:	e3040593          	addi	a1,s0,-464
    800046ca:	078e                	slli	a5,a5,0x3
    800046cc:	97ae                	add	a5,a5,a1
    800046ce:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800046d2:	f3040513          	addi	a0,s0,-208
    800046d6:	ba4ff0ef          	jal	80003a7a <exec>
    800046da:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046dc:	100a0a13          	addi	s4,s4,256
    800046e0:	6088                	ld	a0,0(s1)
    800046e2:	c511                	beqz	a0,800046ee <sys_exec+0xe2>
    kfree(argv[i]);
    800046e4:	939fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046e8:	04a1                	addi	s1,s1,8
    800046ea:	ff449be3          	bne	s1,s4,800046e0 <sys_exec+0xd4>
  return ret;
    800046ee:	854a                	mv	a0,s2
    800046f0:	64be                	ld	s1,456(sp)
    800046f2:	691e                	ld	s2,448(sp)
    800046f4:	79fa                	ld	s3,440(sp)
    800046f6:	7a5a                	ld	s4,432(sp)
    800046f8:	7aba                	ld	s5,424(sp)
    800046fa:	7b1a                	ld	s6,416(sp)
    800046fc:	6bfa                	ld	s7,408(sp)
    800046fe:	a809                	j	80004710 <sys_exec+0x104>
  return -1;
    80004700:	557d                	li	a0,-1
    80004702:	64be                	ld	s1,456(sp)
    80004704:	691e                	ld	s2,448(sp)
    80004706:	79fa                	ld	s3,440(sp)
    80004708:	7a5a                	ld	s4,432(sp)
    8000470a:	7aba                	ld	s5,424(sp)
    8000470c:	7b1a                	ld	s6,416(sp)
    8000470e:	6bfa                	ld	s7,408(sp)
}
    80004710:	60fe                	ld	ra,472(sp)
    80004712:	645e                	ld	s0,464(sp)
    80004714:	613d                	addi	sp,sp,480
    80004716:	8082                	ret

0000000080004718 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004718:	7139                	addi	sp,sp,-64
    8000471a:	fc06                	sd	ra,56(sp)
    8000471c:	f822                	sd	s0,48(sp)
    8000471e:	f426                	sd	s1,40(sp)
    80004720:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004722:	e3efc0ef          	jal	80000d60 <myproc>
    80004726:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004728:	fd840593          	addi	a1,s0,-40
    8000472c:	4501                	li	a0,0
    8000472e:	d0cfd0ef          	jal	80001c3a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004732:	fc840593          	addi	a1,s0,-56
    80004736:	fd040513          	addi	a0,s0,-48
    8000473a:	81eff0ef          	jal	80003758 <pipealloc>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004740:	0a054463          	bltz	a0,800047e8 <sys_pipe+0xd0>
  fd0 = -1;
    80004744:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004748:	fd043503          	ld	a0,-48(s0)
    8000474c:	edeff0ef          	jal	80003e2a <fdalloc>
    80004750:	fca42223          	sw	a0,-60(s0)
    80004754:	08054163          	bltz	a0,800047d6 <sys_pipe+0xbe>
    80004758:	fc843503          	ld	a0,-56(s0)
    8000475c:	eceff0ef          	jal	80003e2a <fdalloc>
    80004760:	fca42023          	sw	a0,-64(s0)
    80004764:	06054063          	bltz	a0,800047c4 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004768:	4691                	li	a3,4
    8000476a:	fc440613          	addi	a2,s0,-60
    8000476e:	fd843583          	ld	a1,-40(s0)
    80004772:	68a8                	ld	a0,80(s1)
    80004774:	a90fc0ef          	jal	80000a04 <copyout>
    80004778:	00054e63          	bltz	a0,80004794 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000477c:	4691                	li	a3,4
    8000477e:	fc040613          	addi	a2,s0,-64
    80004782:	fd843583          	ld	a1,-40(s0)
    80004786:	95b6                	add	a1,a1,a3
    80004788:	68a8                	ld	a0,80(s1)
    8000478a:	a7afc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000478e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004790:	04055c63          	bgez	a0,800047e8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004794:	fc442783          	lw	a5,-60(s0)
    80004798:	07e9                	addi	a5,a5,26
    8000479a:	078e                	slli	a5,a5,0x3
    8000479c:	97a6                	add	a5,a5,s1
    8000479e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047a2:	fc042783          	lw	a5,-64(s0)
    800047a6:	07e9                	addi	a5,a5,26
    800047a8:	078e                	slli	a5,a5,0x3
    800047aa:	94be                	add	s1,s1,a5
    800047ac:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047b0:	fd043503          	ld	a0,-48(s0)
    800047b4:	c95fe0ef          	jal	80003448 <fileclose>
    fileclose(wf);
    800047b8:	fc843503          	ld	a0,-56(s0)
    800047bc:	c8dfe0ef          	jal	80003448 <fileclose>
    return -1;
    800047c0:	57fd                	li	a5,-1
    800047c2:	a01d                	j	800047e8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047c4:	fc442783          	lw	a5,-60(s0)
    800047c8:	0007c763          	bltz	a5,800047d6 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047cc:	07e9                	addi	a5,a5,26
    800047ce:	078e                	slli	a5,a5,0x3
    800047d0:	97a6                	add	a5,a5,s1
    800047d2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047d6:	fd043503          	ld	a0,-48(s0)
    800047da:	c6ffe0ef          	jal	80003448 <fileclose>
    fileclose(wf);
    800047de:	fc843503          	ld	a0,-56(s0)
    800047e2:	c67fe0ef          	jal	80003448 <fileclose>
    return -1;
    800047e6:	57fd                	li	a5,-1
}
    800047e8:	853e                	mv	a0,a5
    800047ea:	70e2                	ld	ra,56(sp)
    800047ec:	7442                	ld	s0,48(sp)
    800047ee:	74a2                	ld	s1,40(sp)
    800047f0:	6121                	addi	sp,sp,64
    800047f2:	8082                	ret
	...

0000000080004800 <kernelvec>:
    80004800:	7111                	addi	sp,sp,-256
    80004802:	e006                	sd	ra,0(sp)
    80004804:	e40a                	sd	sp,8(sp)
    80004806:	e80e                	sd	gp,16(sp)
    80004808:	ec12                	sd	tp,24(sp)
    8000480a:	f016                	sd	t0,32(sp)
    8000480c:	f41a                	sd	t1,40(sp)
    8000480e:	f81e                	sd	t2,48(sp)
    80004810:	e4aa                	sd	a0,72(sp)
    80004812:	e8ae                	sd	a1,80(sp)
    80004814:	ecb2                	sd	a2,88(sp)
    80004816:	f0b6                	sd	a3,96(sp)
    80004818:	f4ba                	sd	a4,104(sp)
    8000481a:	f8be                	sd	a5,112(sp)
    8000481c:	fcc2                	sd	a6,120(sp)
    8000481e:	e146                	sd	a7,128(sp)
    80004820:	edf2                	sd	t3,216(sp)
    80004822:	f1f6                	sd	t4,224(sp)
    80004824:	f5fa                	sd	t5,232(sp)
    80004826:	f9fe                	sd	t6,240(sp)
    80004828:	a7cfd0ef          	jal	80001aa4 <kerneltrap>
    8000482c:	6082                	ld	ra,0(sp)
    8000482e:	6122                	ld	sp,8(sp)
    80004830:	61c2                	ld	gp,16(sp)
    80004832:	7282                	ld	t0,32(sp)
    80004834:	7322                	ld	t1,40(sp)
    80004836:	73c2                	ld	t2,48(sp)
    80004838:	6526                	ld	a0,72(sp)
    8000483a:	65c6                	ld	a1,80(sp)
    8000483c:	6666                	ld	a2,88(sp)
    8000483e:	7686                	ld	a3,96(sp)
    80004840:	7726                	ld	a4,104(sp)
    80004842:	77c6                	ld	a5,112(sp)
    80004844:	7866                	ld	a6,120(sp)
    80004846:	688a                	ld	a7,128(sp)
    80004848:	6e6e                	ld	t3,216(sp)
    8000484a:	7e8e                	ld	t4,224(sp)
    8000484c:	7f2e                	ld	t5,232(sp)
    8000484e:	7fce                	ld	t6,240(sp)
    80004850:	6111                	addi	sp,sp,256
    80004852:	10200073          	sret
	...

000000008000485e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000485e:	1141                	addi	sp,sp,-16
    80004860:	e406                	sd	ra,8(sp)
    80004862:	e022                	sd	s0,0(sp)
    80004864:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004866:	0c000737          	lui	a4,0xc000
    8000486a:	4785                	li	a5,1
    8000486c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000486e:	c35c                	sw	a5,4(a4)
}
    80004870:	60a2                	ld	ra,8(sp)
    80004872:	6402                	ld	s0,0(sp)
    80004874:	0141                	addi	sp,sp,16
    80004876:	8082                	ret

0000000080004878 <plicinithart>:

void
plicinithart(void)
{
    80004878:	1141                	addi	sp,sp,-16
    8000487a:	e406                	sd	ra,8(sp)
    8000487c:	e022                	sd	s0,0(sp)
    8000487e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004880:	cacfc0ef          	jal	80000d2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004884:	0085171b          	slliw	a4,a0,0x8
    80004888:	0c0027b7          	lui	a5,0xc002
    8000488c:	97ba                	add	a5,a5,a4
    8000488e:	40200713          	li	a4,1026
    80004892:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004896:	00d5151b          	slliw	a0,a0,0xd
    8000489a:	0c2017b7          	lui	a5,0xc201
    8000489e:	97aa                	add	a5,a5,a0
    800048a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048a4:	60a2                	ld	ra,8(sp)
    800048a6:	6402                	ld	s0,0(sp)
    800048a8:	0141                	addi	sp,sp,16
    800048aa:	8082                	ret

00000000800048ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048ac:	1141                	addi	sp,sp,-16
    800048ae:	e406                	sd	ra,8(sp)
    800048b0:	e022                	sd	s0,0(sp)
    800048b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048b4:	c78fc0ef          	jal	80000d2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048b8:	00d5151b          	slliw	a0,a0,0xd
    800048bc:	0c2017b7          	lui	a5,0xc201
    800048c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800048c2:	43c8                	lw	a0,4(a5)
    800048c4:	60a2                	ld	ra,8(sp)
    800048c6:	6402                	ld	s0,0(sp)
    800048c8:	0141                	addi	sp,sp,16
    800048ca:	8082                	ret

00000000800048cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800048cc:	1101                	addi	sp,sp,-32
    800048ce:	ec06                	sd	ra,24(sp)
    800048d0:	e822                	sd	s0,16(sp)
    800048d2:	e426                	sd	s1,8(sp)
    800048d4:	1000                	addi	s0,sp,32
    800048d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048d8:	c54fc0ef          	jal	80000d2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048dc:	00d5179b          	slliw	a5,a0,0xd
    800048e0:	0c201737          	lui	a4,0xc201
    800048e4:	97ba                	add	a5,a5,a4
    800048e6:	c3c4                	sw	s1,4(a5)
}
    800048e8:	60e2                	ld	ra,24(sp)
    800048ea:	6442                	ld	s0,16(sp)
    800048ec:	64a2                	ld	s1,8(sp)
    800048ee:	6105                	addi	sp,sp,32
    800048f0:	8082                	ret

00000000800048f2 <free_desc>:
    800048f2:	1141                	addi	sp,sp,-16
    800048f4:	e406                	sd	ra,8(sp)
    800048f6:	e022                	sd	s0,0(sp)
    800048f8:	0800                	addi	s0,sp,16
    800048fa:	479d                	li	a5,7
    800048fc:	04a7ca63          	blt	a5,a0,80004950 <free_desc+0x5e>
    80004900:	00017797          	auipc	a5,0x17
    80004904:	b3078793          	addi	a5,a5,-1232 # 8001b430 <disk>
    80004908:	97aa                	add	a5,a5,a0
    8000490a:	0187c783          	lbu	a5,24(a5)
    8000490e:	e7b9                	bnez	a5,8000495c <free_desc+0x6a>
    80004910:	00451693          	slli	a3,a0,0x4
    80004914:	00017797          	auipc	a5,0x17
    80004918:	b1c78793          	addi	a5,a5,-1252 # 8001b430 <disk>
    8000491c:	6398                	ld	a4,0(a5)
    8000491e:	9736                	add	a4,a4,a3
    80004920:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
    80004924:	6398                	ld	a4,0(a5)
    80004926:	9736                	add	a4,a4,a3
    80004928:	00072423          	sw	zero,8(a4)
    8000492c:	00071623          	sh	zero,12(a4)
    80004930:	00071723          	sh	zero,14(a4)
    80004934:	97aa                	add	a5,a5,a0
    80004936:	4705                	li	a4,1
    80004938:	00e78c23          	sb	a4,24(a5)
    8000493c:	00017517          	auipc	a0,0x17
    80004940:	b0c50513          	addi	a0,a0,-1268 # 8001b448 <disk+0x18>
    80004944:	a43fc0ef          	jal	80001386 <wakeup>
    80004948:	60a2                	ld	ra,8(sp)
    8000494a:	6402                	ld	s0,0(sp)
    8000494c:	0141                	addi	sp,sp,16
    8000494e:	8082                	ret
    80004950:	00003517          	auipc	a0,0x3
    80004954:	cc050513          	addi	a0,a0,-832 # 80007610 <etext+0x610>
    80004958:	40f000ef          	jal	80005566 <panic>
    8000495c:	00003517          	auipc	a0,0x3
    80004960:	cc450513          	addi	a0,a0,-828 # 80007620 <etext+0x620>
    80004964:	403000ef          	jal	80005566 <panic>

0000000080004968 <virtio_disk_init>:
    80004968:	1101                	addi	sp,sp,-32
    8000496a:	ec06                	sd	ra,24(sp)
    8000496c:	e822                	sd	s0,16(sp)
    8000496e:	e426                	sd	s1,8(sp)
    80004970:	e04a                	sd	s2,0(sp)
    80004972:	1000                	addi	s0,sp,32
    80004974:	00003597          	auipc	a1,0x3
    80004978:	cbc58593          	addi	a1,a1,-836 # 80007630 <etext+0x630>
    8000497c:	00017517          	auipc	a0,0x17
    80004980:	bdc50513          	addi	a0,a0,-1060 # 8001b558 <disk+0x128>
    80004984:	68d000ef          	jal	80005810 <initlock>
    80004988:	100017b7          	lui	a5,0x10001
    8000498c:	4398                	lw	a4,0(a5)
    8000498e:	2701                	sext.w	a4,a4
    80004990:	747277b7          	lui	a5,0x74727
    80004994:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004998:	14f71863          	bne	a4,a5,80004ae8 <virtio_disk_init+0x180>
    8000499c:	100017b7          	lui	a5,0x10001
    800049a0:	43dc                	lw	a5,4(a5)
    800049a2:	2781                	sext.w	a5,a5
    800049a4:	4709                	li	a4,2
    800049a6:	14e79163          	bne	a5,a4,80004ae8 <virtio_disk_init+0x180>
    800049aa:	100017b7          	lui	a5,0x10001
    800049ae:	479c                	lw	a5,8(a5)
    800049b0:	2781                	sext.w	a5,a5
    800049b2:	12e79b63          	bne	a5,a4,80004ae8 <virtio_disk_init+0x180>
    800049b6:	100017b7          	lui	a5,0x10001
    800049ba:	47d8                	lw	a4,12(a5)
    800049bc:	2701                	sext.w	a4,a4
    800049be:	554d47b7          	lui	a5,0x554d4
    800049c2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800049c6:	12f71163          	bne	a4,a5,80004ae8 <virtio_disk_init+0x180>
    800049ca:	100017b7          	lui	a5,0x10001
    800049ce:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    800049d2:	4705                	li	a4,1
    800049d4:	dbb8                	sw	a4,112(a5)
    800049d6:	470d                	li	a4,3
    800049d8:	dbb8                	sw	a4,112(a5)
    800049da:	10001737          	lui	a4,0x10001
    800049de:	4b18                	lw	a4,16(a4)
    800049e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800049e4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb0ef>
    800049e8:	8f75                	and	a4,a4,a3
    800049ea:	100016b7          	lui	a3,0x10001
    800049ee:	d298                	sw	a4,32(a3)
    800049f0:	472d                	li	a4,11
    800049f2:	dbb8                	sw	a4,112(a5)
    800049f4:	07078793          	addi	a5,a5,112
    800049f8:	439c                	lw	a5,0(a5)
    800049fa:	0007891b          	sext.w	s2,a5
    800049fe:	8ba1                	andi	a5,a5,8
    80004a00:	0e078a63          	beqz	a5,80004af4 <virtio_disk_init+0x18c>
    80004a04:	100017b7          	lui	a5,0x10001
    80004a08:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80004a0c:	43fc                	lw	a5,68(a5)
    80004a0e:	2781                	sext.w	a5,a5
    80004a10:	0e079863          	bnez	a5,80004b00 <virtio_disk_init+0x198>
    80004a14:	100017b7          	lui	a5,0x10001
    80004a18:	5bdc                	lw	a5,52(a5)
    80004a1a:	2781                	sext.w	a5,a5
    80004a1c:	0e078863          	beqz	a5,80004b0c <virtio_disk_init+0x1a4>
    80004a20:	471d                	li	a4,7
    80004a22:	0ef77b63          	bgeu	a4,a5,80004b18 <virtio_disk_init+0x1b0>
    80004a26:	ed8fb0ef          	jal	800000fe <kalloc>
    80004a2a:	00017497          	auipc	s1,0x17
    80004a2e:	a0648493          	addi	s1,s1,-1530 # 8001b430 <disk>
    80004a32:	e088                	sd	a0,0(s1)
    80004a34:	ecafb0ef          	jal	800000fe <kalloc>
    80004a38:	e488                	sd	a0,8(s1)
    80004a3a:	ec4fb0ef          	jal	800000fe <kalloc>
    80004a3e:	87aa                	mv	a5,a0
    80004a40:	e888                	sd	a0,16(s1)
    80004a42:	6088                	ld	a0,0(s1)
    80004a44:	0e050063          	beqz	a0,80004b24 <virtio_disk_init+0x1bc>
    80004a48:	00017717          	auipc	a4,0x17
    80004a4c:	9f073703          	ld	a4,-1552(a4) # 8001b438 <disk+0x8>
    80004a50:	cb71                	beqz	a4,80004b24 <virtio_disk_init+0x1bc>
    80004a52:	cbe9                	beqz	a5,80004b24 <virtio_disk_init+0x1bc>
    80004a54:	6605                	lui	a2,0x1
    80004a56:	4581                	li	a1,0
    80004a58:	ef6fb0ef          	jal	8000014e <memset>
    80004a5c:	00017497          	auipc	s1,0x17
    80004a60:	9d448493          	addi	s1,s1,-1580 # 8001b430 <disk>
    80004a64:	6605                	lui	a2,0x1
    80004a66:	4581                	li	a1,0
    80004a68:	6488                	ld	a0,8(s1)
    80004a6a:	ee4fb0ef          	jal	8000014e <memset>
    80004a6e:	6605                	lui	a2,0x1
    80004a70:	4581                	li	a1,0
    80004a72:	6888                	ld	a0,16(s1)
    80004a74:	edafb0ef          	jal	8000014e <memset>
    80004a78:	100017b7          	lui	a5,0x10001
    80004a7c:	4721                	li	a4,8
    80004a7e:	df98                	sw	a4,56(a5)
    80004a80:	4098                	lw	a4,0(s1)
    80004a82:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    80004a86:	40d8                	lw	a4,4(s1)
    80004a88:	08e7a223          	sw	a4,132(a5)
    80004a8c:	649c                	ld	a5,8(s1)
    80004a8e:	0007869b          	sext.w	a3,a5
    80004a92:	10001737          	lui	a4,0x10001
    80004a96:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
    80004a9a:	9781                	srai	a5,a5,0x20
    80004a9c:	08f72a23          	sw	a5,148(a4)
    80004aa0:	689c                	ld	a5,16(s1)
    80004aa2:	0007869b          	sext.w	a3,a5
    80004aa6:	0ad72023          	sw	a3,160(a4)
    80004aaa:	9781                	srai	a5,a5,0x20
    80004aac:	0af72223          	sw	a5,164(a4)
    80004ab0:	4785                	li	a5,1
    80004ab2:	c37c                	sw	a5,68(a4)
    80004ab4:	00f48c23          	sb	a5,24(s1)
    80004ab8:	00f48ca3          	sb	a5,25(s1)
    80004abc:	00f48d23          	sb	a5,26(s1)
    80004ac0:	00f48da3          	sb	a5,27(s1)
    80004ac4:	00f48e23          	sb	a5,28(s1)
    80004ac8:	00f48ea3          	sb	a5,29(s1)
    80004acc:	00f48f23          	sb	a5,30(s1)
    80004ad0:	00f48fa3          	sb	a5,31(s1)
    80004ad4:	00496913          	ori	s2,s2,4
    80004ad8:	07272823          	sw	s2,112(a4)
    80004adc:	60e2                	ld	ra,24(sp)
    80004ade:	6442                	ld	s0,16(sp)
    80004ae0:	64a2                	ld	s1,8(sp)
    80004ae2:	6902                	ld	s2,0(sp)
    80004ae4:	6105                	addi	sp,sp,32
    80004ae6:	8082                	ret
    80004ae8:	00003517          	auipc	a0,0x3
    80004aec:	b5850513          	addi	a0,a0,-1192 # 80007640 <etext+0x640>
    80004af0:	277000ef          	jal	80005566 <panic>
    80004af4:	00003517          	auipc	a0,0x3
    80004af8:	b6c50513          	addi	a0,a0,-1172 # 80007660 <etext+0x660>
    80004afc:	26b000ef          	jal	80005566 <panic>
    80004b00:	00003517          	auipc	a0,0x3
    80004b04:	b8050513          	addi	a0,a0,-1152 # 80007680 <etext+0x680>
    80004b08:	25f000ef          	jal	80005566 <panic>
    80004b0c:	00003517          	auipc	a0,0x3
    80004b10:	b9450513          	addi	a0,a0,-1132 # 800076a0 <etext+0x6a0>
    80004b14:	253000ef          	jal	80005566 <panic>
    80004b18:	00003517          	auipc	a0,0x3
    80004b1c:	ba850513          	addi	a0,a0,-1112 # 800076c0 <etext+0x6c0>
    80004b20:	247000ef          	jal	80005566 <panic>
    80004b24:	00003517          	auipc	a0,0x3
    80004b28:	bbc50513          	addi	a0,a0,-1092 # 800076e0 <etext+0x6e0>
    80004b2c:	23b000ef          	jal	80005566 <panic>

0000000080004b30 <virtio_disk_rw>:
    80004b30:	711d                	addi	sp,sp,-96
    80004b32:	ec86                	sd	ra,88(sp)
    80004b34:	e8a2                	sd	s0,80(sp)
    80004b36:	e4a6                	sd	s1,72(sp)
    80004b38:	e0ca                	sd	s2,64(sp)
    80004b3a:	fc4e                	sd	s3,56(sp)
    80004b3c:	f852                	sd	s4,48(sp)
    80004b3e:	f456                	sd	s5,40(sp)
    80004b40:	f05a                	sd	s6,32(sp)
    80004b42:	ec5e                	sd	s7,24(sp)
    80004b44:	e862                	sd	s8,16(sp)
    80004b46:	1080                	addi	s0,sp,96
    80004b48:	89aa                	mv	s3,a0
    80004b4a:	8b2e                	mv	s6,a1
    80004b4c:	00c52b83          	lw	s7,12(a0)
    80004b50:	001b9b9b          	slliw	s7,s7,0x1
    80004b54:	1b82                	slli	s7,s7,0x20
    80004b56:	020bdb93          	srli	s7,s7,0x20
    80004b5a:	00017517          	auipc	a0,0x17
    80004b5e:	9fe50513          	addi	a0,a0,-1538 # 8001b558 <disk+0x128>
    80004b62:	533000ef          	jal	80005894 <acquire>
    80004b66:	44a1                	li	s1,8
    80004b68:	00017a97          	auipc	s5,0x17
    80004b6c:	8c8a8a93          	addi	s5,s5,-1848 # 8001b430 <disk>
    80004b70:	4a0d                	li	s4,3
    80004b72:	5c7d                	li	s8,-1
    80004b74:	a095                	j	80004bd8 <virtio_disk_rw+0xa8>
    80004b76:	00fa8733          	add	a4,s5,a5
    80004b7a:	00070c23          	sb	zero,24(a4)
    80004b7e:	c19c                	sw	a5,0(a1)
    80004b80:	0207c563          	bltz	a5,80004baa <virtio_disk_rw+0x7a>
    80004b84:	2905                	addiw	s2,s2,1
    80004b86:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b88:	05490c63          	beq	s2,s4,80004be0 <virtio_disk_rw+0xb0>
    80004b8c:	85b2                	mv	a1,a2
    80004b8e:	00017717          	auipc	a4,0x17
    80004b92:	8a270713          	addi	a4,a4,-1886 # 8001b430 <disk>
    80004b96:	4781                	li	a5,0
    80004b98:	01874683          	lbu	a3,24(a4)
    80004b9c:	fee9                	bnez	a3,80004b76 <virtio_disk_rw+0x46>
    80004b9e:	2785                	addiw	a5,a5,1
    80004ba0:	0705                	addi	a4,a4,1
    80004ba2:	fe979be3          	bne	a5,s1,80004b98 <virtio_disk_rw+0x68>
    80004ba6:	0185a023          	sw	s8,0(a1)
    80004baa:	01205d63          	blez	s2,80004bc4 <virtio_disk_rw+0x94>
    80004bae:	fa042503          	lw	a0,-96(s0)
    80004bb2:	d41ff0ef          	jal	800048f2 <free_desc>
    80004bb6:	4785                	li	a5,1
    80004bb8:	0127d663          	bge	a5,s2,80004bc4 <virtio_disk_rw+0x94>
    80004bbc:	fa442503          	lw	a0,-92(s0)
    80004bc0:	d33ff0ef          	jal	800048f2 <free_desc>
    80004bc4:	00017597          	auipc	a1,0x17
    80004bc8:	99458593          	addi	a1,a1,-1644 # 8001b558 <disk+0x128>
    80004bcc:	00017517          	auipc	a0,0x17
    80004bd0:	87c50513          	addi	a0,a0,-1924 # 8001b448 <disk+0x18>
    80004bd4:	f66fc0ef          	jal	8000133a <sleep>
    80004bd8:	fa040613          	addi	a2,s0,-96
    80004bdc:	4901                	li	s2,0
    80004bde:	b77d                	j	80004b8c <virtio_disk_rw+0x5c>
    80004be0:	fa042503          	lw	a0,-96(s0)
    80004be4:	00451693          	slli	a3,a0,0x4
    80004be8:	00017797          	auipc	a5,0x17
    80004bec:	84878793          	addi	a5,a5,-1976 # 8001b430 <disk>
    80004bf0:	00a50713          	addi	a4,a0,10
    80004bf4:	0712                	slli	a4,a4,0x4
    80004bf6:	973e                	add	a4,a4,a5
    80004bf8:	01603633          	snez	a2,s6
    80004bfc:	c710                	sw	a2,8(a4)
    80004bfe:	00072623          	sw	zero,12(a4)
    80004c02:	01773823          	sd	s7,16(a4)
    80004c06:	6398                	ld	a4,0(a5)
    80004c08:	9736                	add	a4,a4,a3
    80004c0a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004c0e:	963e                	add	a2,a2,a5
    80004c10:	e310                	sd	a2,0(a4)
    80004c12:	6390                	ld	a2,0(a5)
    80004c14:	00d605b3          	add	a1,a2,a3
    80004c18:	4741                	li	a4,16
    80004c1a:	c598                	sw	a4,8(a1)
    80004c1c:	4805                	li	a6,1
    80004c1e:	01059623          	sh	a6,12(a1)
    80004c22:	fa442703          	lw	a4,-92(s0)
    80004c26:	00e59723          	sh	a4,14(a1)
    80004c2a:	0712                	slli	a4,a4,0x4
    80004c2c:	963a                	add	a2,a2,a4
    80004c2e:	05898593          	addi	a1,s3,88
    80004c32:	e20c                	sd	a1,0(a2)
    80004c34:	0007b883          	ld	a7,0(a5)
    80004c38:	9746                	add	a4,a4,a7
    80004c3a:	40000613          	li	a2,1024
    80004c3e:	c710                	sw	a2,8(a4)
    80004c40:	001b3613          	seqz	a2,s6
    80004c44:	0016161b          	slliw	a2,a2,0x1
    80004c48:	01066633          	or	a2,a2,a6
    80004c4c:	00c71623          	sh	a2,12(a4)
    80004c50:	fa842583          	lw	a1,-88(s0)
    80004c54:	00b71723          	sh	a1,14(a4)
    80004c58:	00250613          	addi	a2,a0,2
    80004c5c:	0612                	slli	a2,a2,0x4
    80004c5e:	963e                	add	a2,a2,a5
    80004c60:	577d                	li	a4,-1
    80004c62:	00e60823          	sb	a4,16(a2)
    80004c66:	0592                	slli	a1,a1,0x4
    80004c68:	98ae                	add	a7,a7,a1
    80004c6a:	03068713          	addi	a4,a3,48
    80004c6e:	973e                	add	a4,a4,a5
    80004c70:	00e8b023          	sd	a4,0(a7)
    80004c74:	6398                	ld	a4,0(a5)
    80004c76:	972e                	add	a4,a4,a1
    80004c78:	01072423          	sw	a6,8(a4)
    80004c7c:	4689                	li	a3,2
    80004c7e:	00d71623          	sh	a3,12(a4)
    80004c82:	00071723          	sh	zero,14(a4)
    80004c86:	0109a223          	sw	a6,4(s3)
    80004c8a:	01363423          	sd	s3,8(a2)
    80004c8e:	6794                	ld	a3,8(a5)
    80004c90:	0026d703          	lhu	a4,2(a3)
    80004c94:	8b1d                	andi	a4,a4,7
    80004c96:	0706                	slli	a4,a4,0x1
    80004c98:	96ba                	add	a3,a3,a4
    80004c9a:	00a69223          	sh	a0,4(a3)
    80004c9e:	0330000f          	fence	rw,rw
    80004ca2:	6798                	ld	a4,8(a5)
    80004ca4:	00275783          	lhu	a5,2(a4)
    80004ca8:	2785                	addiw	a5,a5,1
    80004caa:	00f71123          	sh	a5,2(a4)
    80004cae:	0330000f          	fence	rw,rw
    80004cb2:	100017b7          	lui	a5,0x10001
    80004cb6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80004cba:	0049a783          	lw	a5,4(s3)
    80004cbe:	00017917          	auipc	s2,0x17
    80004cc2:	89a90913          	addi	s2,s2,-1894 # 8001b558 <disk+0x128>
    80004cc6:	84c2                	mv	s1,a6
    80004cc8:	01079a63          	bne	a5,a6,80004cdc <virtio_disk_rw+0x1ac>
    80004ccc:	85ca                	mv	a1,s2
    80004cce:	854e                	mv	a0,s3
    80004cd0:	e6afc0ef          	jal	8000133a <sleep>
    80004cd4:	0049a783          	lw	a5,4(s3)
    80004cd8:	fe978ae3          	beq	a5,s1,80004ccc <virtio_disk_rw+0x19c>
    80004cdc:	fa042903          	lw	s2,-96(s0)
    80004ce0:	00290713          	addi	a4,s2,2
    80004ce4:	0712                	slli	a4,a4,0x4
    80004ce6:	00016797          	auipc	a5,0x16
    80004cea:	74a78793          	addi	a5,a5,1866 # 8001b430 <disk>
    80004cee:	97ba                	add	a5,a5,a4
    80004cf0:	0007b423          	sd	zero,8(a5)
    80004cf4:	00016997          	auipc	s3,0x16
    80004cf8:	73c98993          	addi	s3,s3,1852 # 8001b430 <disk>
    80004cfc:	00491713          	slli	a4,s2,0x4
    80004d00:	0009b783          	ld	a5,0(s3)
    80004d04:	97ba                	add	a5,a5,a4
    80004d06:	00c7d483          	lhu	s1,12(a5)
    80004d0a:	854a                	mv	a0,s2
    80004d0c:	00e7d903          	lhu	s2,14(a5)
    80004d10:	be3ff0ef          	jal	800048f2 <free_desc>
    80004d14:	8885                	andi	s1,s1,1
    80004d16:	f0fd                	bnez	s1,80004cfc <virtio_disk_rw+0x1cc>
    80004d18:	00017517          	auipc	a0,0x17
    80004d1c:	84050513          	addi	a0,a0,-1984 # 8001b558 <disk+0x128>
    80004d20:	409000ef          	jal	80005928 <release>
    80004d24:	60e6                	ld	ra,88(sp)
    80004d26:	6446                	ld	s0,80(sp)
    80004d28:	64a6                	ld	s1,72(sp)
    80004d2a:	6906                	ld	s2,64(sp)
    80004d2c:	79e2                	ld	s3,56(sp)
    80004d2e:	7a42                	ld	s4,48(sp)
    80004d30:	7aa2                	ld	s5,40(sp)
    80004d32:	7b02                	ld	s6,32(sp)
    80004d34:	6be2                	ld	s7,24(sp)
    80004d36:	6c42                	ld	s8,16(sp)
    80004d38:	6125                	addi	sp,sp,96
    80004d3a:	8082                	ret

0000000080004d3c <virtio_disk_intr>:
    80004d3c:	1101                	addi	sp,sp,-32
    80004d3e:	ec06                	sd	ra,24(sp)
    80004d40:	e822                	sd	s0,16(sp)
    80004d42:	e426                	sd	s1,8(sp)
    80004d44:	1000                	addi	s0,sp,32
    80004d46:	00016497          	auipc	s1,0x16
    80004d4a:	6ea48493          	addi	s1,s1,1770 # 8001b430 <disk>
    80004d4e:	00017517          	auipc	a0,0x17
    80004d52:	80a50513          	addi	a0,a0,-2038 # 8001b558 <disk+0x128>
    80004d56:	33f000ef          	jal	80005894 <acquire>
    80004d5a:	100017b7          	lui	a5,0x10001
    80004d5e:	53bc                	lw	a5,96(a5)
    80004d60:	8b8d                	andi	a5,a5,3
    80004d62:	10001737          	lui	a4,0x10001
    80004d66:	d37c                	sw	a5,100(a4)
    80004d68:	0330000f          	fence	rw,rw
    80004d6c:	689c                	ld	a5,16(s1)
    80004d6e:	0204d703          	lhu	a4,32(s1)
    80004d72:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d76:	04f70663          	beq	a4,a5,80004dc2 <virtio_disk_intr+0x86>
    80004d7a:	0330000f          	fence	rw,rw
    80004d7e:	6898                	ld	a4,16(s1)
    80004d80:	0204d783          	lhu	a5,32(s1)
    80004d84:	8b9d                	andi	a5,a5,7
    80004d86:	078e                	slli	a5,a5,0x3
    80004d88:	97ba                	add	a5,a5,a4
    80004d8a:	43dc                	lw	a5,4(a5)
    80004d8c:	00278713          	addi	a4,a5,2
    80004d90:	0712                	slli	a4,a4,0x4
    80004d92:	9726                	add	a4,a4,s1
    80004d94:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004d98:	e321                	bnez	a4,80004dd8 <virtio_disk_intr+0x9c>
    80004d9a:	0789                	addi	a5,a5,2
    80004d9c:	0792                	slli	a5,a5,0x4
    80004d9e:	97a6                	add	a5,a5,s1
    80004da0:	6788                	ld	a0,8(a5)
    80004da2:	00052223          	sw	zero,4(a0)
    80004da6:	de0fc0ef          	jal	80001386 <wakeup>
    80004daa:	0204d783          	lhu	a5,32(s1)
    80004dae:	2785                	addiw	a5,a5,1
    80004db0:	17c2                	slli	a5,a5,0x30
    80004db2:	93c1                	srli	a5,a5,0x30
    80004db4:	02f49023          	sh	a5,32(s1)
    80004db8:	6898                	ld	a4,16(s1)
    80004dba:	00275703          	lhu	a4,2(a4)
    80004dbe:	faf71ee3          	bne	a4,a5,80004d7a <virtio_disk_intr+0x3e>
    80004dc2:	00016517          	auipc	a0,0x16
    80004dc6:	79650513          	addi	a0,a0,1942 # 8001b558 <disk+0x128>
    80004dca:	35f000ef          	jal	80005928 <release>
    80004dce:	60e2                	ld	ra,24(sp)
    80004dd0:	6442                	ld	s0,16(sp)
    80004dd2:	64a2                	ld	s1,8(sp)
    80004dd4:	6105                	addi	sp,sp,32
    80004dd6:	8082                	ret
    80004dd8:	00003517          	auipc	a0,0x3
    80004ddc:	92050513          	addi	a0,a0,-1760 # 800076f8 <etext+0x6f8>
    80004de0:	786000ef          	jal	80005566 <panic>

0000000080004de4 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004de4:	1141                	addi	sp,sp,-16
    80004de6:	e406                	sd	ra,8(sp)
    80004de8:	e022                	sd	s0,0(sp)
    80004dea:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004dec:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004df0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004df4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004df8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004dfc:	577d                	li	a4,-1
    80004dfe:	177e                	slli	a4,a4,0x3f
    80004e00:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e02:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e06:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e0e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e12:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e16:	000f4737          	lui	a4,0xf4
    80004e1a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e1e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e20:	14d79073          	csrw	stimecmp,a5
}
    80004e24:	60a2                	ld	ra,8(sp)
    80004e26:	6402                	ld	s0,0(sp)
    80004e28:	0141                	addi	sp,sp,16
    80004e2a:	8082                	ret

0000000080004e2c <start>:
{
    80004e2c:	1141                	addi	sp,sp,-16
    80004e2e:	e406                	sd	ra,8(sp)
    80004e30:	e022                	sd	s0,0(sp)
    80004e32:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e34:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e38:	7779                	lui	a4,0xffffe
    80004e3a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb18f>
    80004e3e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e40:	6705                	lui	a4,0x1
    80004e42:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e46:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e48:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e4c:	ffffb797          	auipc	a5,0xffffb
    80004e50:	4b878793          	addi	a5,a5,1208 # 80000304 <main>
    80004e54:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e58:	4781                	li	a5,0
    80004e5a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e5e:	67c1                	lui	a5,0x10
    80004e60:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e62:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e66:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e72:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e76:	57fd                	li	a5,-1
    80004e78:	83a9                	srli	a5,a5,0xa
    80004e7a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e7e:	47bd                	li	a5,15
    80004e80:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e84:	f61ff0ef          	jal	80004de4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e88:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e8c:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80004e8e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e90:	30200073          	mret
}
    80004e94:	60a2                	ld	ra,8(sp)
    80004e96:	6402                	ld	s0,0(sp)
    80004e98:	0141                	addi	sp,sp,16
    80004e9a:	8082                	ret

0000000080004e9c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e9c:	711d                	addi	sp,sp,-96
    80004e9e:	ec86                	sd	ra,88(sp)
    80004ea0:	e8a2                	sd	s0,80(sp)
    80004ea2:	e0ca                	sd	s2,64(sp)
    80004ea4:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004ea6:	04c05863          	blez	a2,80004ef6 <consolewrite+0x5a>
    80004eaa:	e4a6                	sd	s1,72(sp)
    80004eac:	fc4e                	sd	s3,56(sp)
    80004eae:	f852                	sd	s4,48(sp)
    80004eb0:	f456                	sd	s5,40(sp)
    80004eb2:	f05a                	sd	s6,32(sp)
    80004eb4:	ec5e                	sd	s7,24(sp)
    80004eb6:	8a2a                	mv	s4,a0
    80004eb8:	84ae                	mv	s1,a1
    80004eba:	89b2                	mv	s3,a2
    80004ebc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004ebe:	faf40b93          	addi	s7,s0,-81
    80004ec2:	4b05                	li	s6,1
    80004ec4:	5afd                	li	s5,-1
    80004ec6:	86da                	mv	a3,s6
    80004ec8:	8626                	mv	a2,s1
    80004eca:	85d2                	mv	a1,s4
    80004ecc:	855e                	mv	a0,s7
    80004ece:	80dfc0ef          	jal	800016da <either_copyin>
    80004ed2:	03550463          	beq	a0,s5,80004efa <consolewrite+0x5e>
      break;
    uartputc(c);
    80004ed6:	faf44503          	lbu	a0,-81(s0)
    80004eda:	02d000ef          	jal	80005706 <uartputc>
  for(i = 0; i < n; i++){
    80004ede:	2905                	addiw	s2,s2,1
    80004ee0:	0485                	addi	s1,s1,1
    80004ee2:	ff2992e3          	bne	s3,s2,80004ec6 <consolewrite+0x2a>
    80004ee6:	894e                	mv	s2,s3
    80004ee8:	64a6                	ld	s1,72(sp)
    80004eea:	79e2                	ld	s3,56(sp)
    80004eec:	7a42                	ld	s4,48(sp)
    80004eee:	7aa2                	ld	s5,40(sp)
    80004ef0:	7b02                	ld	s6,32(sp)
    80004ef2:	6be2                	ld	s7,24(sp)
    80004ef4:	a809                	j	80004f06 <consolewrite+0x6a>
    80004ef6:	4901                	li	s2,0
    80004ef8:	a039                	j	80004f06 <consolewrite+0x6a>
    80004efa:	64a6                	ld	s1,72(sp)
    80004efc:	79e2                	ld	s3,56(sp)
    80004efe:	7a42                	ld	s4,48(sp)
    80004f00:	7aa2                	ld	s5,40(sp)
    80004f02:	7b02                	ld	s6,32(sp)
    80004f04:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004f06:	854a                	mv	a0,s2
    80004f08:	60e6                	ld	ra,88(sp)
    80004f0a:	6446                	ld	s0,80(sp)
    80004f0c:	6906                	ld	s2,64(sp)
    80004f0e:	6125                	addi	sp,sp,96
    80004f10:	8082                	ret

0000000080004f12 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f12:	711d                	addi	sp,sp,-96
    80004f14:	ec86                	sd	ra,88(sp)
    80004f16:	e8a2                	sd	s0,80(sp)
    80004f18:	e4a6                	sd	s1,72(sp)
    80004f1a:	e0ca                	sd	s2,64(sp)
    80004f1c:	fc4e                	sd	s3,56(sp)
    80004f1e:	f852                	sd	s4,48(sp)
    80004f20:	f456                	sd	s5,40(sp)
    80004f22:	f05a                	sd	s6,32(sp)
    80004f24:	1080                	addi	s0,sp,96
    80004f26:	8aaa                	mv	s5,a0
    80004f28:	8a2e                	mv	s4,a1
    80004f2a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f2c:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004f2e:	0001e517          	auipc	a0,0x1e
    80004f32:	64250513          	addi	a0,a0,1602 # 80023570 <cons>
    80004f36:	15f000ef          	jal	80005894 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f3a:	0001e497          	auipc	s1,0x1e
    80004f3e:	63648493          	addi	s1,s1,1590 # 80023570 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f42:	0001e917          	auipc	s2,0x1e
    80004f46:	6c690913          	addi	s2,s2,1734 # 80023608 <cons+0x98>
  while(n > 0){
    80004f4a:	0b305b63          	blez	s3,80005000 <consoleread+0xee>
    while(cons.r == cons.w){
    80004f4e:	0984a783          	lw	a5,152(s1)
    80004f52:	09c4a703          	lw	a4,156(s1)
    80004f56:	0af71063          	bne	a4,a5,80004ff6 <consoleread+0xe4>
      if(killed(myproc())){
    80004f5a:	e07fb0ef          	jal	80000d60 <myproc>
    80004f5e:	e14fc0ef          	jal	80001572 <killed>
    80004f62:	e12d                	bnez	a0,80004fc4 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004f64:	85a6                	mv	a1,s1
    80004f66:	854a                	mv	a0,s2
    80004f68:	bd2fc0ef          	jal	8000133a <sleep>
    while(cons.r == cons.w){
    80004f6c:	0984a783          	lw	a5,152(s1)
    80004f70:	09c4a703          	lw	a4,156(s1)
    80004f74:	fef703e3          	beq	a4,a5,80004f5a <consoleread+0x48>
    80004f78:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f7a:	0001e717          	auipc	a4,0x1e
    80004f7e:	5f670713          	addi	a4,a4,1526 # 80023570 <cons>
    80004f82:	0017869b          	addiw	a3,a5,1
    80004f86:	08d72c23          	sw	a3,152(a4)
    80004f8a:	07f7f693          	andi	a3,a5,127
    80004f8e:	9736                	add	a4,a4,a3
    80004f90:	01874703          	lbu	a4,24(a4)
    80004f94:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f98:	4691                	li	a3,4
    80004f9a:	04db8663          	beq	s7,a3,80004fe6 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f9e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004fa2:	4685                	li	a3,1
    80004fa4:	faf40613          	addi	a2,s0,-81
    80004fa8:	85d2                	mv	a1,s4
    80004faa:	8556                	mv	a0,s5
    80004fac:	ee4fc0ef          	jal	80001690 <either_copyout>
    80004fb0:	57fd                	li	a5,-1
    80004fb2:	04f50663          	beq	a0,a5,80004ffe <consoleread+0xec>
      break;

    dst++;
    80004fb6:	0a05                	addi	s4,s4,1
    --n;
    80004fb8:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004fba:	47a9                	li	a5,10
    80004fbc:	04fb8b63          	beq	s7,a5,80005012 <consoleread+0x100>
    80004fc0:	6be2                	ld	s7,24(sp)
    80004fc2:	b761                	j	80004f4a <consoleread+0x38>
        release(&cons.lock);
    80004fc4:	0001e517          	auipc	a0,0x1e
    80004fc8:	5ac50513          	addi	a0,a0,1452 # 80023570 <cons>
    80004fcc:	15d000ef          	jal	80005928 <release>
        return -1;
    80004fd0:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004fd2:	60e6                	ld	ra,88(sp)
    80004fd4:	6446                	ld	s0,80(sp)
    80004fd6:	64a6                	ld	s1,72(sp)
    80004fd8:	6906                	ld	s2,64(sp)
    80004fda:	79e2                	ld	s3,56(sp)
    80004fdc:	7a42                	ld	s4,48(sp)
    80004fde:	7aa2                	ld	s5,40(sp)
    80004fe0:	7b02                	ld	s6,32(sp)
    80004fe2:	6125                	addi	sp,sp,96
    80004fe4:	8082                	ret
      if(n < target){
    80004fe6:	0169fa63          	bgeu	s3,s6,80004ffa <consoleread+0xe8>
        cons.r--;
    80004fea:	0001e717          	auipc	a4,0x1e
    80004fee:	60f72f23          	sw	a5,1566(a4) # 80023608 <cons+0x98>
    80004ff2:	6be2                	ld	s7,24(sp)
    80004ff4:	a031                	j	80005000 <consoleread+0xee>
    80004ff6:	ec5e                	sd	s7,24(sp)
    80004ff8:	b749                	j	80004f7a <consoleread+0x68>
    80004ffa:	6be2                	ld	s7,24(sp)
    80004ffc:	a011                	j	80005000 <consoleread+0xee>
    80004ffe:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005000:	0001e517          	auipc	a0,0x1e
    80005004:	57050513          	addi	a0,a0,1392 # 80023570 <cons>
    80005008:	121000ef          	jal	80005928 <release>
  return target - n;
    8000500c:	413b053b          	subw	a0,s6,s3
    80005010:	b7c9                	j	80004fd2 <consoleread+0xc0>
    80005012:	6be2                	ld	s7,24(sp)
    80005014:	b7f5                	j	80005000 <consoleread+0xee>

0000000080005016 <consputc>:
{
    80005016:	1141                	addi	sp,sp,-16
    80005018:	e406                	sd	ra,8(sp)
    8000501a:	e022                	sd	s0,0(sp)
    8000501c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000501e:	10000793          	li	a5,256
    80005022:	00f50863          	beq	a0,a5,80005032 <consputc+0x1c>
    uartputc_sync(c);
    80005026:	5fe000ef          	jal	80005624 <uartputc_sync>
}
    8000502a:	60a2                	ld	ra,8(sp)
    8000502c:	6402                	ld	s0,0(sp)
    8000502e:	0141                	addi	sp,sp,16
    80005030:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005032:	4521                	li	a0,8
    80005034:	5f0000ef          	jal	80005624 <uartputc_sync>
    80005038:	02000513          	li	a0,32
    8000503c:	5e8000ef          	jal	80005624 <uartputc_sync>
    80005040:	4521                	li	a0,8
    80005042:	5e2000ef          	jal	80005624 <uartputc_sync>
    80005046:	b7d5                	j	8000502a <consputc+0x14>

0000000080005048 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005048:	7179                	addi	sp,sp,-48
    8000504a:	f406                	sd	ra,40(sp)
    8000504c:	f022                	sd	s0,32(sp)
    8000504e:	ec26                	sd	s1,24(sp)
    80005050:	1800                	addi	s0,sp,48
    80005052:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005054:	0001e517          	auipc	a0,0x1e
    80005058:	51c50513          	addi	a0,a0,1308 # 80023570 <cons>
    8000505c:	039000ef          	jal	80005894 <acquire>

  switch(c){
    80005060:	47d5                	li	a5,21
    80005062:	08f48e63          	beq	s1,a5,800050fe <consoleintr+0xb6>
    80005066:	0297c563          	blt	a5,s1,80005090 <consoleintr+0x48>
    8000506a:	47a1                	li	a5,8
    8000506c:	0ef48863          	beq	s1,a5,8000515c <consoleintr+0x114>
    80005070:	47c1                	li	a5,16
    80005072:	10f49963          	bne	s1,a5,80005184 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005076:	eaefc0ef          	jal	80001724 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000507a:	0001e517          	auipc	a0,0x1e
    8000507e:	4f650513          	addi	a0,a0,1270 # 80023570 <cons>
    80005082:	0a7000ef          	jal	80005928 <release>
}
    80005086:	70a2                	ld	ra,40(sp)
    80005088:	7402                	ld	s0,32(sp)
    8000508a:	64e2                	ld	s1,24(sp)
    8000508c:	6145                	addi	sp,sp,48
    8000508e:	8082                	ret
  switch(c){
    80005090:	07f00793          	li	a5,127
    80005094:	0cf48463          	beq	s1,a5,8000515c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005098:	0001e717          	auipc	a4,0x1e
    8000509c:	4d870713          	addi	a4,a4,1240 # 80023570 <cons>
    800050a0:	0a072783          	lw	a5,160(a4)
    800050a4:	09872703          	lw	a4,152(a4)
    800050a8:	9f99                	subw	a5,a5,a4
    800050aa:	07f00713          	li	a4,127
    800050ae:	fcf766e3          	bltu	a4,a5,8000507a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800050b2:	47b5                	li	a5,13
    800050b4:	0cf48b63          	beq	s1,a5,8000518a <consoleintr+0x142>
      consputc(c);
    800050b8:	8526                	mv	a0,s1
    800050ba:	f5dff0ef          	jal	80005016 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050be:	0001e797          	auipc	a5,0x1e
    800050c2:	4b278793          	addi	a5,a5,1202 # 80023570 <cons>
    800050c6:	0a07a683          	lw	a3,160(a5)
    800050ca:	0016871b          	addiw	a4,a3,1
    800050ce:	863a                	mv	a2,a4
    800050d0:	0ae7a023          	sw	a4,160(a5)
    800050d4:	07f6f693          	andi	a3,a3,127
    800050d8:	97b6                	add	a5,a5,a3
    800050da:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800050de:	47a9                	li	a5,10
    800050e0:	0cf48963          	beq	s1,a5,800051b2 <consoleintr+0x16a>
    800050e4:	4791                	li	a5,4
    800050e6:	0cf48663          	beq	s1,a5,800051b2 <consoleintr+0x16a>
    800050ea:	0001e797          	auipc	a5,0x1e
    800050ee:	51e7a783          	lw	a5,1310(a5) # 80023608 <cons+0x98>
    800050f2:	9f1d                	subw	a4,a4,a5
    800050f4:	08000793          	li	a5,128
    800050f8:	f8f711e3          	bne	a4,a5,8000507a <consoleintr+0x32>
    800050fc:	a85d                	j	800051b2 <consoleintr+0x16a>
    800050fe:	e84a                	sd	s2,16(sp)
    80005100:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005102:	0001e717          	auipc	a4,0x1e
    80005106:	46e70713          	addi	a4,a4,1134 # 80023570 <cons>
    8000510a:	0a072783          	lw	a5,160(a4)
    8000510e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005112:	0001e497          	auipc	s1,0x1e
    80005116:	45e48493          	addi	s1,s1,1118 # 80023570 <cons>
    while(cons.e != cons.w &&
    8000511a:	4929                	li	s2,10
      consputc(BACKSPACE);
    8000511c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005120:	02f70863          	beq	a4,a5,80005150 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005124:	37fd                	addiw	a5,a5,-1
    80005126:	07f7f713          	andi	a4,a5,127
    8000512a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000512c:	01874703          	lbu	a4,24(a4)
    80005130:	03270363          	beq	a4,s2,80005156 <consoleintr+0x10e>
      cons.e--;
    80005134:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005138:	854e                	mv	a0,s3
    8000513a:	eddff0ef          	jal	80005016 <consputc>
    while(cons.e != cons.w &&
    8000513e:	0a04a783          	lw	a5,160(s1)
    80005142:	09c4a703          	lw	a4,156(s1)
    80005146:	fcf71fe3          	bne	a4,a5,80005124 <consoleintr+0xdc>
    8000514a:	6942                	ld	s2,16(sp)
    8000514c:	69a2                	ld	s3,8(sp)
    8000514e:	b735                	j	8000507a <consoleintr+0x32>
    80005150:	6942                	ld	s2,16(sp)
    80005152:	69a2                	ld	s3,8(sp)
    80005154:	b71d                	j	8000507a <consoleintr+0x32>
    80005156:	6942                	ld	s2,16(sp)
    80005158:	69a2                	ld	s3,8(sp)
    8000515a:	b705                	j	8000507a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000515c:	0001e717          	auipc	a4,0x1e
    80005160:	41470713          	addi	a4,a4,1044 # 80023570 <cons>
    80005164:	0a072783          	lw	a5,160(a4)
    80005168:	09c72703          	lw	a4,156(a4)
    8000516c:	f0f707e3          	beq	a4,a5,8000507a <consoleintr+0x32>
      cons.e--;
    80005170:	37fd                	addiw	a5,a5,-1
    80005172:	0001e717          	auipc	a4,0x1e
    80005176:	48f72f23          	sw	a5,1182(a4) # 80023610 <cons+0xa0>
      consputc(BACKSPACE);
    8000517a:	10000513          	li	a0,256
    8000517e:	e99ff0ef          	jal	80005016 <consputc>
    80005182:	bde5                	j	8000507a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005184:	ee048be3          	beqz	s1,8000507a <consoleintr+0x32>
    80005188:	bf01                	j	80005098 <consoleintr+0x50>
      consputc(c);
    8000518a:	4529                	li	a0,10
    8000518c:	e8bff0ef          	jal	80005016 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005190:	0001e797          	auipc	a5,0x1e
    80005194:	3e078793          	addi	a5,a5,992 # 80023570 <cons>
    80005198:	0a07a703          	lw	a4,160(a5)
    8000519c:	0017069b          	addiw	a3,a4,1
    800051a0:	8636                	mv	a2,a3
    800051a2:	0ad7a023          	sw	a3,160(a5)
    800051a6:	07f77713          	andi	a4,a4,127
    800051aa:	97ba                	add	a5,a5,a4
    800051ac:	4729                	li	a4,10
    800051ae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800051b2:	0001e797          	auipc	a5,0x1e
    800051b6:	44c7ad23          	sw	a2,1114(a5) # 8002360c <cons+0x9c>
        wakeup(&cons.r);
    800051ba:	0001e517          	auipc	a0,0x1e
    800051be:	44e50513          	addi	a0,a0,1102 # 80023608 <cons+0x98>
    800051c2:	9c4fc0ef          	jal	80001386 <wakeup>
    800051c6:	bd55                	j	8000507a <consoleintr+0x32>

00000000800051c8 <consoleinit>:

void
consoleinit(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800051d0:	00002597          	auipc	a1,0x2
    800051d4:	54058593          	addi	a1,a1,1344 # 80007710 <etext+0x710>
    800051d8:	0001e517          	auipc	a0,0x1e
    800051dc:	39850513          	addi	a0,a0,920 # 80023570 <cons>
    800051e0:	630000ef          	jal	80005810 <initlock>

  uartinit();
    800051e4:	3ea000ef          	jal	800055ce <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800051e8:	00015797          	auipc	a5,0x15
    800051ec:	1f078793          	addi	a5,a5,496 # 8001a3d8 <devsw>
    800051f0:	00000717          	auipc	a4,0x0
    800051f4:	d2270713          	addi	a4,a4,-734 # 80004f12 <consoleread>
    800051f8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800051fa:	00000717          	auipc	a4,0x0
    800051fe:	ca270713          	addi	a4,a4,-862 # 80004e9c <consolewrite>
    80005202:	ef98                	sd	a4,24(a5)
}
    80005204:	60a2                	ld	ra,8(sp)
    80005206:	6402                	ld	s0,0(sp)
    80005208:	0141                	addi	sp,sp,16
    8000520a:	8082                	ret

000000008000520c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000520c:	7179                	addi	sp,sp,-48
    8000520e:	f406                	sd	ra,40(sp)
    80005210:	f022                	sd	s0,32(sp)
    80005212:	ec26                	sd	s1,24(sp)
    80005214:	e84a                	sd	s2,16(sp)
    80005216:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005218:	c219                	beqz	a2,8000521e <printint+0x12>
    8000521a:	06054a63          	bltz	a0,8000528e <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000521e:	4e01                	li	t3,0

  i = 0;
    80005220:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005224:	869a                	mv	a3,t1
  i = 0;
    80005226:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005228:	00002817          	auipc	a6,0x2
    8000522c:	65880813          	addi	a6,a6,1624 # 80007880 <digits>
    80005230:	88be                	mv	a7,a5
    80005232:	0017861b          	addiw	a2,a5,1
    80005236:	87b2                	mv	a5,a2
    80005238:	02b57733          	remu	a4,a0,a1
    8000523c:	9742                	add	a4,a4,a6
    8000523e:	00074703          	lbu	a4,0(a4)
    80005242:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005246:	872a                	mv	a4,a0
    80005248:	02b55533          	divu	a0,a0,a1
    8000524c:	0685                	addi	a3,a3,1
    8000524e:	feb771e3          	bgeu	a4,a1,80005230 <printint+0x24>

  if(sign)
    80005252:	000e0c63          	beqz	t3,8000526a <printint+0x5e>
    buf[i++] = '-';
    80005256:	fe060793          	addi	a5,a2,-32
    8000525a:	00878633          	add	a2,a5,s0
    8000525e:	02d00793          	li	a5,45
    80005262:	fef60823          	sb	a5,-16(a2)
    80005266:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000526a:	fff7891b          	addiw	s2,a5,-1
    8000526e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005272:	fff4c503          	lbu	a0,-1(s1)
    80005276:	da1ff0ef          	jal	80005016 <consputc>
  while(--i >= 0)
    8000527a:	397d                	addiw	s2,s2,-1
    8000527c:	14fd                	addi	s1,s1,-1
    8000527e:	fe095ae3          	bgez	s2,80005272 <printint+0x66>
}
    80005282:	70a2                	ld	ra,40(sp)
    80005284:	7402                	ld	s0,32(sp)
    80005286:	64e2                	ld	s1,24(sp)
    80005288:	6942                	ld	s2,16(sp)
    8000528a:	6145                	addi	sp,sp,48
    8000528c:	8082                	ret
    x = -xx;
    8000528e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005292:	4e05                	li	t3,1
    x = -xx;
    80005294:	b771                	j	80005220 <printint+0x14>

0000000080005296 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005296:	7155                	addi	sp,sp,-208
    80005298:	e506                	sd	ra,136(sp)
    8000529a:	e122                	sd	s0,128(sp)
    8000529c:	f0d2                	sd	s4,96(sp)
    8000529e:	0900                	addi	s0,sp,144
    800052a0:	8a2a                	mv	s4,a0
    800052a2:	e40c                	sd	a1,8(s0)
    800052a4:	e810                	sd	a2,16(s0)
    800052a6:	ec14                	sd	a3,24(s0)
    800052a8:	f018                	sd	a4,32(s0)
    800052aa:	f41c                	sd	a5,40(s0)
    800052ac:	03043823          	sd	a6,48(s0)
    800052b0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800052b4:	0001e797          	auipc	a5,0x1e
    800052b8:	37c7a783          	lw	a5,892(a5) # 80023630 <pr+0x18>
    800052bc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800052c0:	e3a1                	bnez	a5,80005300 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800052c2:	00840793          	addi	a5,s0,8
    800052c6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052ca:	00054503          	lbu	a0,0(a0)
    800052ce:	26050663          	beqz	a0,8000553a <printf+0x2a4>
    800052d2:	fca6                	sd	s1,120(sp)
    800052d4:	f8ca                	sd	s2,112(sp)
    800052d6:	f4ce                	sd	s3,104(sp)
    800052d8:	ecd6                	sd	s5,88(sp)
    800052da:	e8da                	sd	s6,80(sp)
    800052dc:	e0e2                	sd	s8,64(sp)
    800052de:	fc66                	sd	s9,56(sp)
    800052e0:	f86a                	sd	s10,48(sp)
    800052e2:	f46e                	sd	s11,40(sp)
    800052e4:	4981                	li	s3,0
    if(cx != '%'){
    800052e6:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800052ea:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800052ee:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800052f2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052f6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052fa:	07000d93          	li	s11,112
    800052fe:	a80d                	j	80005330 <printf+0x9a>
    acquire(&pr.lock);
    80005300:	0001e517          	auipc	a0,0x1e
    80005304:	31850513          	addi	a0,a0,792 # 80023618 <pr>
    80005308:	58c000ef          	jal	80005894 <acquire>
  va_start(ap, fmt);
    8000530c:	00840793          	addi	a5,s0,8
    80005310:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005314:	000a4503          	lbu	a0,0(s4)
    80005318:	fd4d                	bnez	a0,800052d2 <printf+0x3c>
    8000531a:	ac3d                	j	80005558 <printf+0x2c2>
      consputc(cx);
    8000531c:	cfbff0ef          	jal	80005016 <consputc>
      continue;
    80005320:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005322:	2485                	addiw	s1,s1,1
    80005324:	89a6                	mv	s3,s1
    80005326:	94d2                	add	s1,s1,s4
    80005328:	0004c503          	lbu	a0,0(s1)
    8000532c:	1e050b63          	beqz	a0,80005522 <printf+0x28c>
    if(cx != '%'){
    80005330:	ff5516e3          	bne	a0,s5,8000531c <printf+0x86>
    i++;
    80005334:	0019879b          	addiw	a5,s3,1
    80005338:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000533a:	00fa0733          	add	a4,s4,a5
    8000533e:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005342:	1e090063          	beqz	s2,80005522 <printf+0x28c>
    80005346:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8000534a:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8000534c:	c701                	beqz	a4,80005354 <printf+0xbe>
    8000534e:	97d2                	add	a5,a5,s4
    80005350:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005354:	03690763          	beq	s2,s6,80005382 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005358:	05890163          	beq	s2,s8,8000539a <printf+0x104>
    } else if(c0 == 'u'){
    8000535c:	0d990b63          	beq	s2,s9,80005432 <printf+0x19c>
    } else if(c0 == 'x'){
    80005360:	13a90163          	beq	s2,s10,80005482 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005364:	13b90b63          	beq	s2,s11,8000549a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005368:	07300793          	li	a5,115
    8000536c:	16f90a63          	beq	s2,a5,800054e0 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005370:	1b590463          	beq	s2,s5,80005518 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005374:	8556                	mv	a0,s5
    80005376:	ca1ff0ef          	jal	80005016 <consputc>
      consputc(c0);
    8000537a:	854a                	mv	a0,s2
    8000537c:	c9bff0ef          	jal	80005016 <consputc>
    80005380:	b74d                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005382:	f8843783          	ld	a5,-120(s0)
    80005386:	00878713          	addi	a4,a5,8
    8000538a:	f8e43423          	sd	a4,-120(s0)
    8000538e:	4605                	li	a2,1
    80005390:	45a9                	li	a1,10
    80005392:	4388                	lw	a0,0(a5)
    80005394:	e79ff0ef          	jal	8000520c <printint>
    80005398:	b769                	j	80005322 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000539a:	03670663          	beq	a4,s6,800053c6 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000539e:	05870263          	beq	a4,s8,800053e2 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800053a2:	0b970463          	beq	a4,s9,8000544a <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800053a6:	fda717e3          	bne	a4,s10,80005374 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800053aa:	f8843783          	ld	a5,-120(s0)
    800053ae:	00878713          	addi	a4,a5,8
    800053b2:	f8e43423          	sd	a4,-120(s0)
    800053b6:	4601                	li	a2,0
    800053b8:	45c1                	li	a1,16
    800053ba:	6388                	ld	a0,0(a5)
    800053bc:	e51ff0ef          	jal	8000520c <printint>
      i += 1;
    800053c0:	0029849b          	addiw	s1,s3,2
    800053c4:	bfb9                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053c6:	f8843783          	ld	a5,-120(s0)
    800053ca:	00878713          	addi	a4,a5,8
    800053ce:	f8e43423          	sd	a4,-120(s0)
    800053d2:	4605                	li	a2,1
    800053d4:	45a9                	li	a1,10
    800053d6:	6388                	ld	a0,0(a5)
    800053d8:	e35ff0ef          	jal	8000520c <printint>
      i += 1;
    800053dc:	0029849b          	addiw	s1,s3,2
    800053e0:	b789                	j	80005322 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053e2:	06400793          	li	a5,100
    800053e6:	02f68863          	beq	a3,a5,80005416 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800053ea:	07500793          	li	a5,117
    800053ee:	06f68c63          	beq	a3,a5,80005466 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800053f2:	07800793          	li	a5,120
    800053f6:	f6f69fe3          	bne	a3,a5,80005374 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800053fa:	f8843783          	ld	a5,-120(s0)
    800053fe:	00878713          	addi	a4,a5,8
    80005402:	f8e43423          	sd	a4,-120(s0)
    80005406:	4601                	li	a2,0
    80005408:	45c1                	li	a1,16
    8000540a:	6388                	ld	a0,0(a5)
    8000540c:	e01ff0ef          	jal	8000520c <printint>
      i += 2;
    80005410:	0039849b          	addiw	s1,s3,3
    80005414:	b739                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005416:	f8843783          	ld	a5,-120(s0)
    8000541a:	00878713          	addi	a4,a5,8
    8000541e:	f8e43423          	sd	a4,-120(s0)
    80005422:	4605                	li	a2,1
    80005424:	45a9                	li	a1,10
    80005426:	6388                	ld	a0,0(a5)
    80005428:	de5ff0ef          	jal	8000520c <printint>
      i += 2;
    8000542c:	0039849b          	addiw	s1,s3,3
    80005430:	bdcd                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80005432:	f8843783          	ld	a5,-120(s0)
    80005436:	00878713          	addi	a4,a5,8
    8000543a:	f8e43423          	sd	a4,-120(s0)
    8000543e:	4601                	li	a2,0
    80005440:	45a9                	li	a1,10
    80005442:	4388                	lw	a0,0(a5)
    80005444:	dc9ff0ef          	jal	8000520c <printint>
    80005448:	bde9                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000544a:	f8843783          	ld	a5,-120(s0)
    8000544e:	00878713          	addi	a4,a5,8
    80005452:	f8e43423          	sd	a4,-120(s0)
    80005456:	4601                	li	a2,0
    80005458:	45a9                	li	a1,10
    8000545a:	6388                	ld	a0,0(a5)
    8000545c:	db1ff0ef          	jal	8000520c <printint>
      i += 1;
    80005460:	0029849b          	addiw	s1,s3,2
    80005464:	bd7d                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005466:	f8843783          	ld	a5,-120(s0)
    8000546a:	00878713          	addi	a4,a5,8
    8000546e:	f8e43423          	sd	a4,-120(s0)
    80005472:	4601                	li	a2,0
    80005474:	45a9                	li	a1,10
    80005476:	6388                	ld	a0,0(a5)
    80005478:	d95ff0ef          	jal	8000520c <printint>
      i += 2;
    8000547c:	0039849b          	addiw	s1,s3,3
    80005480:	b54d                	j	80005322 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005482:	f8843783          	ld	a5,-120(s0)
    80005486:	00878713          	addi	a4,a5,8
    8000548a:	f8e43423          	sd	a4,-120(s0)
    8000548e:	4601                	li	a2,0
    80005490:	45c1                	li	a1,16
    80005492:	4388                	lw	a0,0(a5)
    80005494:	d79ff0ef          	jal	8000520c <printint>
    80005498:	b569                	j	80005322 <printf+0x8c>
    8000549a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000549c:	f8843783          	ld	a5,-120(s0)
    800054a0:	00878713          	addi	a4,a5,8
    800054a4:	f8e43423          	sd	a4,-120(s0)
    800054a8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800054ac:	03000513          	li	a0,48
    800054b0:	b67ff0ef          	jal	80005016 <consputc>
  consputc('x');
    800054b4:	07800513          	li	a0,120
    800054b8:	b5fff0ef          	jal	80005016 <consputc>
    800054bc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054be:	00002b97          	auipc	s7,0x2
    800054c2:	3c2b8b93          	addi	s7,s7,962 # 80007880 <digits>
    800054c6:	03c9d793          	srli	a5,s3,0x3c
    800054ca:	97de                	add	a5,a5,s7
    800054cc:	0007c503          	lbu	a0,0(a5)
    800054d0:	b47ff0ef          	jal	80005016 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800054d4:	0992                	slli	s3,s3,0x4
    800054d6:	397d                	addiw	s2,s2,-1
    800054d8:	fe0917e3          	bnez	s2,800054c6 <printf+0x230>
    800054dc:	6ba6                	ld	s7,72(sp)
    800054de:	b591                	j	80005322 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800054e0:	f8843783          	ld	a5,-120(s0)
    800054e4:	00878713          	addi	a4,a5,8
    800054e8:	f8e43423          	sd	a4,-120(s0)
    800054ec:	0007b903          	ld	s2,0(a5)
    800054f0:	00090d63          	beqz	s2,8000550a <printf+0x274>
      for(; *s; s++)
    800054f4:	00094503          	lbu	a0,0(s2)
    800054f8:	e20505e3          	beqz	a0,80005322 <printf+0x8c>
        consputc(*s);
    800054fc:	b1bff0ef          	jal	80005016 <consputc>
      for(; *s; s++)
    80005500:	0905                	addi	s2,s2,1
    80005502:	00094503          	lbu	a0,0(s2)
    80005506:	f97d                	bnez	a0,800054fc <printf+0x266>
    80005508:	bd29                	j	80005322 <printf+0x8c>
        s = "(null)";
    8000550a:	00002917          	auipc	s2,0x2
    8000550e:	20e90913          	addi	s2,s2,526 # 80007718 <etext+0x718>
      for(; *s; s++)
    80005512:	02800513          	li	a0,40
    80005516:	b7dd                	j	800054fc <printf+0x266>
      consputc('%');
    80005518:	02500513          	li	a0,37
    8000551c:	afbff0ef          	jal	80005016 <consputc>
    80005520:	b509                	j	80005322 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005522:	f7843783          	ld	a5,-136(s0)
    80005526:	e385                	bnez	a5,80005546 <printf+0x2b0>
    80005528:	74e6                	ld	s1,120(sp)
    8000552a:	7946                	ld	s2,112(sp)
    8000552c:	79a6                	ld	s3,104(sp)
    8000552e:	6ae6                	ld	s5,88(sp)
    80005530:	6b46                	ld	s6,80(sp)
    80005532:	6c06                	ld	s8,64(sp)
    80005534:	7ce2                	ld	s9,56(sp)
    80005536:	7d42                	ld	s10,48(sp)
    80005538:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8000553a:	4501                	li	a0,0
    8000553c:	60aa                	ld	ra,136(sp)
    8000553e:	640a                	ld	s0,128(sp)
    80005540:	7a06                	ld	s4,96(sp)
    80005542:	6169                	addi	sp,sp,208
    80005544:	8082                	ret
    80005546:	74e6                	ld	s1,120(sp)
    80005548:	7946                	ld	s2,112(sp)
    8000554a:	79a6                	ld	s3,104(sp)
    8000554c:	6ae6                	ld	s5,88(sp)
    8000554e:	6b46                	ld	s6,80(sp)
    80005550:	6c06                	ld	s8,64(sp)
    80005552:	7ce2                	ld	s9,56(sp)
    80005554:	7d42                	ld	s10,48(sp)
    80005556:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005558:	0001e517          	auipc	a0,0x1e
    8000555c:	0c050513          	addi	a0,a0,192 # 80023618 <pr>
    80005560:	3c8000ef          	jal	80005928 <release>
    80005564:	bfd9                	j	8000553a <printf+0x2a4>

0000000080005566 <panic>:

void
panic(char *s)
{
    80005566:	1101                	addi	sp,sp,-32
    80005568:	ec06                	sd	ra,24(sp)
    8000556a:	e822                	sd	s0,16(sp)
    8000556c:	e426                	sd	s1,8(sp)
    8000556e:	1000                	addi	s0,sp,32
    80005570:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005572:	0001e797          	auipc	a5,0x1e
    80005576:	0a07af23          	sw	zero,190(a5) # 80023630 <pr+0x18>
  printf("panic: ");
    8000557a:	00002517          	auipc	a0,0x2
    8000557e:	1a650513          	addi	a0,a0,422 # 80007720 <etext+0x720>
    80005582:	d15ff0ef          	jal	80005296 <printf>
  printf("%s\n", s);
    80005586:	85a6                	mv	a1,s1
    80005588:	00002517          	auipc	a0,0x2
    8000558c:	1a050513          	addi	a0,a0,416 # 80007728 <etext+0x728>
    80005590:	d07ff0ef          	jal	80005296 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005594:	4785                	li	a5,1
    80005596:	00005717          	auipc	a4,0x5
    8000559a:	d8f72b23          	sw	a5,-618(a4) # 8000a32c <panicked>
  for(;;)
    8000559e:	a001                	j	8000559e <panic+0x38>

00000000800055a0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800055a0:	1101                	addi	sp,sp,-32
    800055a2:	ec06                	sd	ra,24(sp)
    800055a4:	e822                	sd	s0,16(sp)
    800055a6:	e426                	sd	s1,8(sp)
    800055a8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800055aa:	0001e497          	auipc	s1,0x1e
    800055ae:	06e48493          	addi	s1,s1,110 # 80023618 <pr>
    800055b2:	00002597          	auipc	a1,0x2
    800055b6:	17e58593          	addi	a1,a1,382 # 80007730 <etext+0x730>
    800055ba:	8526                	mv	a0,s1
    800055bc:	254000ef          	jal	80005810 <initlock>
  pr.locking = 1;
    800055c0:	4785                	li	a5,1
    800055c2:	cc9c                	sw	a5,24(s1)
}
    800055c4:	60e2                	ld	ra,24(sp)
    800055c6:	6442                	ld	s0,16(sp)
    800055c8:	64a2                	ld	s1,8(sp)
    800055ca:	6105                	addi	sp,sp,32
    800055cc:	8082                	ret

00000000800055ce <uartinit>:
    800055ce:	1141                	addi	sp,sp,-16
    800055d0:	e406                	sd	ra,8(sp)
    800055d2:	e022                	sd	s0,0(sp)
    800055d4:	0800                	addi	s0,sp,16
    800055d6:	100007b7          	lui	a5,0x10000
    800055da:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800055de:	10000737          	lui	a4,0x10000
    800055e2:	f8000693          	li	a3,-128
    800055e6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>
    800055ea:	468d                	li	a3,3
    800055ec:	10000637          	lui	a2,0x10000
    800055f0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>
    800055f4:	000780a3          	sb	zero,1(a5)
    800055f8:	00d701a3          	sb	a3,3(a4)
    800055fc:	8732                	mv	a4,a2
    800055fe:	461d                	li	a2,7
    80005600:	00c70123          	sb	a2,2(a4)
    80005604:	00d780a3          	sb	a3,1(a5)
    80005608:	00002597          	auipc	a1,0x2
    8000560c:	13058593          	addi	a1,a1,304 # 80007738 <etext+0x738>
    80005610:	0001e517          	auipc	a0,0x1e
    80005614:	02850513          	addi	a0,a0,40 # 80023638 <uart_tx_lock>
    80005618:	1f8000ef          	jal	80005810 <initlock>
    8000561c:	60a2                	ld	ra,8(sp)
    8000561e:	6402                	ld	s0,0(sp)
    80005620:	0141                	addi	sp,sp,16
    80005622:	8082                	ret

0000000080005624 <uartputc_sync>:
    80005624:	1101                	addi	sp,sp,-32
    80005626:	ec06                	sd	ra,24(sp)
    80005628:	e822                	sd	s0,16(sp)
    8000562a:	e426                	sd	s1,8(sp)
    8000562c:	1000                	addi	s0,sp,32
    8000562e:	84aa                	mv	s1,a0
    80005630:	224000ef          	jal	80005854 <push_off>
    80005634:	00005797          	auipc	a5,0x5
    80005638:	cf87a783          	lw	a5,-776(a5) # 8000a32c <panicked>
    8000563c:	e795                	bnez	a5,80005668 <uartputc_sync+0x44>
    8000563e:	10000737          	lui	a4,0x10000
    80005642:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005644:	00074783          	lbu	a5,0(a4)
    80005648:	0207f793          	andi	a5,a5,32
    8000564c:	dfe5                	beqz	a5,80005644 <uartputc_sync+0x20>
    8000564e:	0ff4f513          	zext.b	a0,s1
    80005652:	100007b7          	lui	a5,0x10000
    80005656:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000565a:	27e000ef          	jal	800058d8 <pop_off>
    8000565e:	60e2                	ld	ra,24(sp)
    80005660:	6442                	ld	s0,16(sp)
    80005662:	64a2                	ld	s1,8(sp)
    80005664:	6105                	addi	sp,sp,32
    80005666:	8082                	ret
    80005668:	a001                	j	80005668 <uartputc_sync+0x44>

000000008000566a <uartstart>:
    8000566a:	00005797          	auipc	a5,0x5
    8000566e:	cc67b783          	ld	a5,-826(a5) # 8000a330 <uart_tx_r>
    80005672:	00005717          	auipc	a4,0x5
    80005676:	cc673703          	ld	a4,-826(a4) # 8000a338 <uart_tx_w>
    8000567a:	08f70163          	beq	a4,a5,800056fc <uartstart+0x92>
    8000567e:	7139                	addi	sp,sp,-64
    80005680:	fc06                	sd	ra,56(sp)
    80005682:	f822                	sd	s0,48(sp)
    80005684:	f426                	sd	s1,40(sp)
    80005686:	f04a                	sd	s2,32(sp)
    80005688:	ec4e                	sd	s3,24(sp)
    8000568a:	e852                	sd	s4,16(sp)
    8000568c:	e456                	sd	s5,8(sp)
    8000568e:	e05a                	sd	s6,0(sp)
    80005690:	0080                	addi	s0,sp,64
    80005692:	10000937          	lui	s2,0x10000
    80005696:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
    80005698:	0001ea97          	auipc	s5,0x1e
    8000569c:	fa0a8a93          	addi	s5,s5,-96 # 80023638 <uart_tx_lock>
    800056a0:	00005497          	auipc	s1,0x5
    800056a4:	c9048493          	addi	s1,s1,-880 # 8000a330 <uart_tx_r>
    800056a8:	10000a37          	lui	s4,0x10000
    800056ac:	00005997          	auipc	s3,0x5
    800056b0:	c8c98993          	addi	s3,s3,-884 # 8000a338 <uart_tx_w>
    800056b4:	00094703          	lbu	a4,0(s2)
    800056b8:	02077713          	andi	a4,a4,32
    800056bc:	c715                	beqz	a4,800056e8 <uartstart+0x7e>
    800056be:	01f7f713          	andi	a4,a5,31
    800056c2:	9756                	add	a4,a4,s5
    800056c4:	01874b03          	lbu	s6,24(a4)
    800056c8:	0785                	addi	a5,a5,1
    800056ca:	e09c                	sd	a5,0(s1)
    800056cc:	8526                	mv	a0,s1
    800056ce:	cb9fb0ef          	jal	80001386 <wakeup>
    800056d2:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    800056d6:	609c                	ld	a5,0(s1)
    800056d8:	0009b703          	ld	a4,0(s3)
    800056dc:	fcf71ce3          	bne	a4,a5,800056b4 <uartstart+0x4a>
    800056e0:	100007b7          	lui	a5,0x10000
    800056e4:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
    800056e8:	70e2                	ld	ra,56(sp)
    800056ea:	7442                	ld	s0,48(sp)
    800056ec:	74a2                	ld	s1,40(sp)
    800056ee:	7902                	ld	s2,32(sp)
    800056f0:	69e2                	ld	s3,24(sp)
    800056f2:	6a42                	ld	s4,16(sp)
    800056f4:	6aa2                	ld	s5,8(sp)
    800056f6:	6b02                	ld	s6,0(sp)
    800056f8:	6121                	addi	sp,sp,64
    800056fa:	8082                	ret
    800056fc:	100007b7          	lui	a5,0x10000
    80005700:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
    80005704:	8082                	ret

0000000080005706 <uartputc>:
    80005706:	7179                	addi	sp,sp,-48
    80005708:	f406                	sd	ra,40(sp)
    8000570a:	f022                	sd	s0,32(sp)
    8000570c:	ec26                	sd	s1,24(sp)
    8000570e:	e84a                	sd	s2,16(sp)
    80005710:	e44e                	sd	s3,8(sp)
    80005712:	e052                	sd	s4,0(sp)
    80005714:	1800                	addi	s0,sp,48
    80005716:	8a2a                	mv	s4,a0
    80005718:	0001e517          	auipc	a0,0x1e
    8000571c:	f2050513          	addi	a0,a0,-224 # 80023638 <uart_tx_lock>
    80005720:	174000ef          	jal	80005894 <acquire>
    80005724:	00005797          	auipc	a5,0x5
    80005728:	c087a783          	lw	a5,-1016(a5) # 8000a32c <panicked>
    8000572c:	efbd                	bnez	a5,800057aa <uartputc+0xa4>
    8000572e:	00005717          	auipc	a4,0x5
    80005732:	c0a73703          	ld	a4,-1014(a4) # 8000a338 <uart_tx_w>
    80005736:	00005797          	auipc	a5,0x5
    8000573a:	bfa7b783          	ld	a5,-1030(a5) # 8000a330 <uart_tx_r>
    8000573e:	02078793          	addi	a5,a5,32
    80005742:	0001e997          	auipc	s3,0x1e
    80005746:	ef698993          	addi	s3,s3,-266 # 80023638 <uart_tx_lock>
    8000574a:	00005497          	auipc	s1,0x5
    8000574e:	be648493          	addi	s1,s1,-1050 # 8000a330 <uart_tx_r>
    80005752:	00005917          	auipc	s2,0x5
    80005756:	be690913          	addi	s2,s2,-1050 # 8000a338 <uart_tx_w>
    8000575a:	00e79d63          	bne	a5,a4,80005774 <uartputc+0x6e>
    8000575e:	85ce                	mv	a1,s3
    80005760:	8526                	mv	a0,s1
    80005762:	bd9fb0ef          	jal	8000133a <sleep>
    80005766:	00093703          	ld	a4,0(s2)
    8000576a:	609c                	ld	a5,0(s1)
    8000576c:	02078793          	addi	a5,a5,32
    80005770:	fee787e3          	beq	a5,a4,8000575e <uartputc+0x58>
    80005774:	0001e497          	auipc	s1,0x1e
    80005778:	ec448493          	addi	s1,s1,-316 # 80023638 <uart_tx_lock>
    8000577c:	01f77793          	andi	a5,a4,31
    80005780:	97a6                	add	a5,a5,s1
    80005782:	01478c23          	sb	s4,24(a5)
    80005786:	0705                	addi	a4,a4,1
    80005788:	00005797          	auipc	a5,0x5
    8000578c:	bae7b823          	sd	a4,-1104(a5) # 8000a338 <uart_tx_w>
    80005790:	edbff0ef          	jal	8000566a <uartstart>
    80005794:	8526                	mv	a0,s1
    80005796:	192000ef          	jal	80005928 <release>
    8000579a:	70a2                	ld	ra,40(sp)
    8000579c:	7402                	ld	s0,32(sp)
    8000579e:	64e2                	ld	s1,24(sp)
    800057a0:	6942                	ld	s2,16(sp)
    800057a2:	69a2                	ld	s3,8(sp)
    800057a4:	6a02                	ld	s4,0(sp)
    800057a6:	6145                	addi	sp,sp,48
    800057a8:	8082                	ret
    800057aa:	a001                	j	800057aa <uartputc+0xa4>

00000000800057ac <uartgetc>:
    800057ac:	1141                	addi	sp,sp,-16
    800057ae:	e406                	sd	ra,8(sp)
    800057b0:	e022                	sd	s0,0(sp)
    800057b2:	0800                	addi	s0,sp,16
    800057b4:	100007b7          	lui	a5,0x10000
    800057b8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800057bc:	8b85                	andi	a5,a5,1
    800057be:	cb89                	beqz	a5,800057d0 <uartgetc+0x24>
    800057c0:	100007b7          	lui	a5,0x10000
    800057c4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800057c8:	60a2                	ld	ra,8(sp)
    800057ca:	6402                	ld	s0,0(sp)
    800057cc:	0141                	addi	sp,sp,16
    800057ce:	8082                	ret
    800057d0:	557d                	li	a0,-1
    800057d2:	bfdd                	j	800057c8 <uartgetc+0x1c>

00000000800057d4 <uartintr>:
    800057d4:	1101                	addi	sp,sp,-32
    800057d6:	ec06                	sd	ra,24(sp)
    800057d8:	e822                	sd	s0,16(sp)
    800057da:	e426                	sd	s1,8(sp)
    800057dc:	1000                	addi	s0,sp,32
    800057de:	54fd                	li	s1,-1
    800057e0:	fcdff0ef          	jal	800057ac <uartgetc>
    800057e4:	00950563          	beq	a0,s1,800057ee <uartintr+0x1a>
    800057e8:	861ff0ef          	jal	80005048 <consoleintr>
    800057ec:	bfd5                	j	800057e0 <uartintr+0xc>
    800057ee:	0001e497          	auipc	s1,0x1e
    800057f2:	e4a48493          	addi	s1,s1,-438 # 80023638 <uart_tx_lock>
    800057f6:	8526                	mv	a0,s1
    800057f8:	09c000ef          	jal	80005894 <acquire>
    800057fc:	e6fff0ef          	jal	8000566a <uartstart>
    80005800:	8526                	mv	a0,s1
    80005802:	126000ef          	jal	80005928 <release>
    80005806:	60e2                	ld	ra,24(sp)
    80005808:	6442                	ld	s0,16(sp)
    8000580a:	64a2                	ld	s1,8(sp)
    8000580c:	6105                	addi	sp,sp,32
    8000580e:	8082                	ret

0000000080005810 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005810:	1141                	addi	sp,sp,-16
    80005812:	e406                	sd	ra,8(sp)
    80005814:	e022                	sd	s0,0(sp)
    80005816:	0800                	addi	s0,sp,16
  lk->name = name;
    80005818:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000581a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000581e:	00053823          	sd	zero,16(a0)
}
    80005822:	60a2                	ld	ra,8(sp)
    80005824:	6402                	ld	s0,0(sp)
    80005826:	0141                	addi	sp,sp,16
    80005828:	8082                	ret

000000008000582a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000582a:	411c                	lw	a5,0(a0)
    8000582c:	e399                	bnez	a5,80005832 <holding+0x8>
    8000582e:	4501                	li	a0,0
  return r;
}
    80005830:	8082                	ret
{
    80005832:	1101                	addi	sp,sp,-32
    80005834:	ec06                	sd	ra,24(sp)
    80005836:	e822                	sd	s0,16(sp)
    80005838:	e426                	sd	s1,8(sp)
    8000583a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000583c:	6904                	ld	s1,16(a0)
    8000583e:	d02fb0ef          	jal	80000d40 <mycpu>
    80005842:	40a48533          	sub	a0,s1,a0
    80005846:	00153513          	seqz	a0,a0
}
    8000584a:	60e2                	ld	ra,24(sp)
    8000584c:	6442                	ld	s0,16(sp)
    8000584e:	64a2                	ld	s1,8(sp)
    80005850:	6105                	addi	sp,sp,32
    80005852:	8082                	ret

0000000080005854 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005854:	1101                	addi	sp,sp,-32
    80005856:	ec06                	sd	ra,24(sp)
    80005858:	e822                	sd	s0,16(sp)
    8000585a:	e426                	sd	s1,8(sp)
    8000585c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000585e:	100024f3          	csrr	s1,sstatus
    80005862:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005866:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005868:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000586c:	cd4fb0ef          	jal	80000d40 <mycpu>
    80005870:	5d3c                	lw	a5,120(a0)
    80005872:	cb99                	beqz	a5,80005888 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005874:	cccfb0ef          	jal	80000d40 <mycpu>
    80005878:	5d3c                	lw	a5,120(a0)
    8000587a:	2785                	addiw	a5,a5,1
    8000587c:	dd3c                	sw	a5,120(a0)
}
    8000587e:	60e2                	ld	ra,24(sp)
    80005880:	6442                	ld	s0,16(sp)
    80005882:	64a2                	ld	s1,8(sp)
    80005884:	6105                	addi	sp,sp,32
    80005886:	8082                	ret
    mycpu()->intena = old;
    80005888:	cb8fb0ef          	jal	80000d40 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000588c:	8085                	srli	s1,s1,0x1
    8000588e:	8885                	andi	s1,s1,1
    80005890:	dd64                	sw	s1,124(a0)
    80005892:	b7cd                	j	80005874 <push_off+0x20>

0000000080005894 <acquire>:
{
    80005894:	1101                	addi	sp,sp,-32
    80005896:	ec06                	sd	ra,24(sp)
    80005898:	e822                	sd	s0,16(sp)
    8000589a:	e426                	sd	s1,8(sp)
    8000589c:	1000                	addi	s0,sp,32
    8000589e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058a0:	fb5ff0ef          	jal	80005854 <push_off>
  if(holding(lk))
    800058a4:	8526                	mv	a0,s1
    800058a6:	f85ff0ef          	jal	8000582a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058aa:	4705                	li	a4,1
  if(holding(lk))
    800058ac:	e105                	bnez	a0,800058cc <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058ae:	87ba                	mv	a5,a4
    800058b0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058b4:	2781                	sext.w	a5,a5
    800058b6:	ffe5                	bnez	a5,800058ae <acquire+0x1a>
  __sync_synchronize();
    800058b8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800058bc:	c84fb0ef          	jal	80000d40 <mycpu>
    800058c0:	e888                	sd	a0,16(s1)
}
    800058c2:	60e2                	ld	ra,24(sp)
    800058c4:	6442                	ld	s0,16(sp)
    800058c6:	64a2                	ld	s1,8(sp)
    800058c8:	6105                	addi	sp,sp,32
    800058ca:	8082                	ret
    panic("acquire");
    800058cc:	00002517          	auipc	a0,0x2
    800058d0:	e7450513          	addi	a0,a0,-396 # 80007740 <etext+0x740>
    800058d4:	c93ff0ef          	jal	80005566 <panic>

00000000800058d8 <pop_off>:

void
pop_off(void)
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e406                	sd	ra,8(sp)
    800058dc:	e022                	sd	s0,0(sp)
    800058de:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800058e0:	c60fb0ef          	jal	80000d40 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058e4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800058e8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800058ea:	e39d                	bnez	a5,80005910 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800058ec:	5d3c                	lw	a5,120(a0)
    800058ee:	02f05763          	blez	a5,8000591c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800058f2:	37fd                	addiw	a5,a5,-1
    800058f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058f6:	eb89                	bnez	a5,80005908 <pop_off+0x30>
    800058f8:	5d7c                	lw	a5,124(a0)
    800058fa:	c799                	beqz	a5,80005908 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005900:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005904:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005908:	60a2                	ld	ra,8(sp)
    8000590a:	6402                	ld	s0,0(sp)
    8000590c:	0141                	addi	sp,sp,16
    8000590e:	8082                	ret
    panic("pop_off - interruptible");
    80005910:	00002517          	auipc	a0,0x2
    80005914:	e3850513          	addi	a0,a0,-456 # 80007748 <etext+0x748>
    80005918:	c4fff0ef          	jal	80005566 <panic>
    panic("pop_off");
    8000591c:	00002517          	auipc	a0,0x2
    80005920:	e4450513          	addi	a0,a0,-444 # 80007760 <etext+0x760>
    80005924:	c43ff0ef          	jal	80005566 <panic>

0000000080005928 <release>:
{
    80005928:	1101                	addi	sp,sp,-32
    8000592a:	ec06                	sd	ra,24(sp)
    8000592c:	e822                	sd	s0,16(sp)
    8000592e:	e426                	sd	s1,8(sp)
    80005930:	1000                	addi	s0,sp,32
    80005932:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005934:	ef7ff0ef          	jal	8000582a <holding>
    80005938:	c105                	beqz	a0,80005958 <release+0x30>
  lk->cpu = 0;
    8000593a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000593e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005942:	0310000f          	fence	rw,w
    80005946:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000594a:	f8fff0ef          	jal	800058d8 <pop_off>
}
    8000594e:	60e2                	ld	ra,24(sp)
    80005950:	6442                	ld	s0,16(sp)
    80005952:	64a2                	ld	s1,8(sp)
    80005954:	6105                	addi	sp,sp,32
    80005956:	8082                	ret
    panic("release");
    80005958:	00002517          	auipc	a0,0x2
    8000595c:	e1050513          	addi	a0,a0,-496 # 80007768 <etext+0x768>
    80005960:	c07ff0ef          	jal	80005566 <panic>
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
