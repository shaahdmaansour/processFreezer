
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	5e010113          	addi	sp,sp,1504 # 8001b5e0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	771040ef          	jal	80004f86 <start>

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
    80000028:	00023797          	auipc	a5,0x23
    8000002c:	6b878793          	addi	a5,a5,1720 # 800236e0 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	47c5                	li	a5,17
    80000036:	07ee                	slli	a5,a5,0x1b
    80000038:	17fd                	addi	a5,a5,-1
    8000003a:	00a7b7b3          	sltu	a5,a5,a0
    8000003e:	8fd9                	or	a5,a5,a4
    80000040:	ef95                	bnez	a5,8000007c <kfree+0x60>
    80000042:	84aa                	mv	s1,a0
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	eb95                	bnez	a5,8000007c <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	110000ef          	jal	8000015e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000052:	0000a917          	auipc	s2,0xa
    80000056:	35e90913          	addi	s2,s2,862 # 8000a3b0 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	1e1050ef          	jal	80005a3c <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	265050ef          	jal	80005ad0 <release>
}
    80000070:	60e2                	ld	ra,24(sp)
    80000072:	6442                	ld	s0,16(sp)
    80000074:	64a2                	ld	s1,8(sp)
    80000076:	6902                	ld	s2,0(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret
    panic("kfree");
    8000007c:	00007517          	auipc	a0,0x7
    80000080:	f8450513          	addi	a0,a0,-124 # 80007000 <etext>
    80000084:	67a050ef          	jal	800056fe <panic>

0000000080000088 <freerange>:
{
    80000088:	7179                	addi	sp,sp,-48
    8000008a:	f406                	sd	ra,40(sp)
    8000008c:	f022                	sd	s0,32(sp)
    8000008e:	ec26                	sd	s1,24(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	00e504b3          	add	s1,a0,a4
    8000009c:	777d                	lui	a4,0xfffff
    8000009e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a0:	94be                	add	s1,s1,a5
    800000a2:	0295e263          	bltu	a1,s1,800000c6 <freerange+0x3e>
    800000a6:	e84a                	sd	s2,16(sp)
    800000a8:	e44e                	sd	s3,8(sp)
    800000aa:	e052                	sd	s4,0(sp)
    800000ac:	892e                	mv	s2,a1
    kfree(p);
    800000ae:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	89be                	mv	s3,a5
    kfree(p);
    800000b2:	01448533          	add	a0,s1,s4
    800000b6:	f67ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	94ce                	add	s1,s1,s3
    800000bc:	fe997be3          	bgeu	s2,s1,800000b2 <freerange+0x2a>
    800000c0:	6942                	ld	s2,16(sp)
    800000c2:	69a2                	ld	s3,8(sp)
    800000c4:	6a02                	ld	s4,0(sp)
}
    800000c6:	70a2                	ld	ra,40(sp)
    800000c8:	7402                	ld	s0,32(sp)
    800000ca:	64e2                	ld	s1,24(sp)
    800000cc:	6145                	addi	sp,sp,48
    800000ce:	8082                	ret

00000000800000d0 <kinit>:
{
    800000d0:	1141                	addi	sp,sp,-16
    800000d2:	e406                	sd	ra,8(sp)
    800000d4:	e022                	sd	s0,0(sp)
    800000d6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d8:	00007597          	auipc	a1,0x7
    800000dc:	f3858593          	addi	a1,a1,-200 # 80007010 <etext+0x10>
    800000e0:	0000a517          	auipc	a0,0xa
    800000e4:	2d050513          	addi	a0,a0,720 # 8000a3b0 <kmem>
    800000e8:	0cb050ef          	jal	800059b2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00023517          	auipc	a0,0x23
    800000f4:	5f050513          	addi	a0,a0,1520 # 800236e0 <end>
    800000f8:	f91ff0ef          	jal	80000088 <freerange>
}
    800000fc:	60a2                	ld	ra,8(sp)
    800000fe:	6402                	ld	s0,0(sp)
    80000100:	0141                	addi	sp,sp,16
    80000102:	8082                	ret

0000000080000104 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000104:	1101                	addi	sp,sp,-32
    80000106:	ec06                	sd	ra,24(sp)
    80000108:	e822                	sd	s0,16(sp)
    8000010a:	e426                	sd	s1,8(sp)
    8000010c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000010e:	0000a517          	auipc	a0,0xa
    80000112:	2a250513          	addi	a0,a0,674 # 8000a3b0 <kmem>
    80000116:	127050ef          	jal	80005a3c <acquire>
  r = kmem.freelist;
    8000011a:	0000a497          	auipc	s1,0xa
    8000011e:	2ae4b483          	ld	s1,686(s1) # 8000a3c8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	0000a717          	auipc	a4,0xa
    8000012a:	2af73123          	sd	a5,674(a4) # 8000a3c8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	0000a517          	auipc	a0,0xa
    80000132:	28250513          	addi	a0,a0,642 # 8000a3b0 <kmem>
    80000136:	19b050ef          	jal	80005ad0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000013a:	6605                	lui	a2,0x1
    8000013c:	4595                	li	a1,5
    8000013e:	8526                	mv	a0,s1
    80000140:	01e000ef          	jal	8000015e <memset>
  return (void*)r;
}
    80000144:	8526                	mv	a0,s1
    80000146:	60e2                	ld	ra,24(sp)
    80000148:	6442                	ld	s0,16(sp)
    8000014a:	64a2                	ld	s1,8(sp)
    8000014c:	6105                	addi	sp,sp,32
    8000014e:	8082                	ret
  release(&kmem.lock);
    80000150:	0000a517          	auipc	a0,0xa
    80000154:	26050513          	addi	a0,a0,608 # 8000a3b0 <kmem>
    80000158:	179050ef          	jal	80005ad0 <release>
  if(r)
    8000015c:	b7e5                	j	80000144 <kalloc+0x40>

000000008000015e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000015e:	1141                	addi	sp,sp,-16
    80000160:	e406                	sd	ra,8(sp)
    80000162:	e022                	sd	s0,0(sp)
    80000164:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000166:	ca19                	beqz	a2,8000017c <memset+0x1e>
    80000168:	87aa                	mv	a5,a0
    8000016a:	1602                	slli	a2,a2,0x20
    8000016c:	9201                	srli	a2,a2,0x20
    8000016e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000176:	0785                	addi	a5,a5,1
    80000178:	fee79de3          	bne	a5,a4,80000172 <memset+0x14>
  }
  return dst;
}
    8000017c:	60a2                	ld	ra,8(sp)
    8000017e:	6402                	ld	s0,0(sp)
    80000180:	0141                	addi	sp,sp,16
    80000182:	8082                	ret

0000000080000184 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000184:	1141                	addi	sp,sp,-16
    80000186:	e406                	sd	ra,8(sp)
    80000188:	e022                	sd	s0,0(sp)
    8000018a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000018c:	c61d                	beqz	a2,800001ba <memcmp+0x36>
    8000018e:	1602                	slli	a2,a2,0x20
    80000190:	9201                	srli	a2,a2,0x20
    80000192:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000196:	00054783          	lbu	a5,0(a0)
    8000019a:	0005c703          	lbu	a4,0(a1)
    8000019e:	00e79863          	bne	a5,a4,800001ae <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800001a2:	0505                	addi	a0,a0,1
    800001a4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001a6:	fed518e3          	bne	a0,a3,80000196 <memcmp+0x12>
  }

  return 0;
    800001aa:	4501                	li	a0,0
    800001ac:	a019                	j	800001b2 <memcmp+0x2e>
      return *s1 - *s2;
    800001ae:	40e7853b          	subw	a0,a5,a4
}
    800001b2:	60a2                	ld	ra,8(sp)
    800001b4:	6402                	ld	s0,0(sp)
    800001b6:	0141                	addi	sp,sp,16
    800001b8:	8082                	ret
  return 0;
    800001ba:	4501                	li	a0,0
    800001bc:	bfdd                	j	800001b2 <memcmp+0x2e>

00000000800001be <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001be:	1141                	addi	sp,sp,-16
    800001c0:	e406                	sd	ra,8(sp)
    800001c2:	e022                	sd	s0,0(sp)
    800001c4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001c6:	c205                	beqz	a2,800001e6 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001c8:	02a5e363          	bltu	a1,a0,800001ee <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001cc:	1602                	slli	a2,a2,0x20
    800001ce:	9201                	srli	a2,a2,0x20
    800001d0:	00c587b3          	add	a5,a1,a2
{
    800001d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d6:	0585                	addi	a1,a1,1
    800001d8:	0705                	addi	a4,a4,1
    800001da:	fff5c683          	lbu	a3,-1(a1)
    800001de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001e2:	feb79ae3          	bne	a5,a1,800001d6 <memmove+0x18>

  return dst;
}
    800001e6:	60a2                	ld	ra,8(sp)
    800001e8:	6402                	ld	s0,0(sp)
    800001ea:	0141                	addi	sp,sp,16
    800001ec:	8082                	ret
  if(s < d && s + n > d){
    800001ee:	02061693          	slli	a3,a2,0x20
    800001f2:	9281                	srli	a3,a3,0x20
    800001f4:	00d58733          	add	a4,a1,a3
    800001f8:	fce57ae3          	bgeu	a0,a4,800001cc <memmove+0xe>
    d += n;
    800001fc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001fe:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000202:	1782                	slli	a5,a5,0x20
    80000204:	9381                	srli	a5,a5,0x20
    80000206:	fff7c793          	not	a5,a5
    8000020a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000020c:	177d                	addi	a4,a4,-1
    8000020e:	16fd                	addi	a3,a3,-1
    80000210:	00074603          	lbu	a2,0(a4)
    80000214:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000218:	fee79ae3          	bne	a5,a4,8000020c <memmove+0x4e>
    8000021c:	b7e9                	j	800001e6 <memmove+0x28>

000000008000021e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e406                	sd	ra,8(sp)
    80000222:	e022                	sd	s0,0(sp)
    80000224:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000226:	f99ff0ef          	jal	800001be <memmove>
}
    8000022a:	60a2                	ld	ra,8(sp)
    8000022c:	6402                	ld	s0,0(sp)
    8000022e:	0141                	addi	sp,sp,16
    80000230:	8082                	ret

0000000080000232 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000023a:	ce11                	beqz	a2,80000256 <strncmp+0x24>
    8000023c:	00054783          	lbu	a5,0(a0)
    80000240:	cf89                	beqz	a5,8000025a <strncmp+0x28>
    80000242:	0005c703          	lbu	a4,0(a1)
    80000246:	00f71a63          	bne	a4,a5,8000025a <strncmp+0x28>
    n--, p++, q++;
    8000024a:	367d                	addiw	a2,a2,-1
    8000024c:	0505                	addi	a0,a0,1
    8000024e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000250:	f675                	bnez	a2,8000023c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000252:	4501                	li	a0,0
    80000254:	a801                	j	80000264 <strncmp+0x32>
    80000256:	4501                	li	a0,0
    80000258:	a031                	j	80000264 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000025a:	00054503          	lbu	a0,0(a0)
    8000025e:	0005c783          	lbu	a5,0(a1)
    80000262:	9d1d                	subw	a0,a0,a5
}
    80000264:	60a2                	ld	ra,8(sp)
    80000266:	6402                	ld	s0,0(sp)
    80000268:	0141                	addi	sp,sp,16
    8000026a:	8082                	ret

000000008000026c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000026c:	1141                	addi	sp,sp,-16
    8000026e:	e406                	sd	ra,8(sp)
    80000270:	e022                	sd	s0,0(sp)
    80000272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000274:	87aa                	mv	a5,a0
    80000276:	a011                	j	8000027a <strncpy+0xe>
    80000278:	8636                	mv	a2,a3
    8000027a:	02c05863          	blez	a2,800002aa <strncpy+0x3e>
    8000027e:	fff6069b          	addiw	a3,a2,-1
    80000282:	8836                	mv	a6,a3
    80000284:	0785                	addi	a5,a5,1
    80000286:	0005c703          	lbu	a4,0(a1)
    8000028a:	fee78fa3          	sb	a4,-1(a5)
    8000028e:	0585                	addi	a1,a1,1
    80000290:	f765                	bnez	a4,80000278 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000292:	873e                	mv	a4,a5
    80000294:	01005b63          	blez	a6,800002aa <strncpy+0x3e>
    80000298:	9fb1                	addw	a5,a5,a2
    8000029a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a2:	40e786bb          	subw	a3,a5,a4
    800002a6:	fed04be3          	bgtz	a3,8000029c <strncpy+0x30>
  return os;
}
    800002aa:	60a2                	ld	ra,8(sp)
    800002ac:	6402                	ld	s0,0(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e406                	sd	ra,8(sp)
    800002b6:	e022                	sd	s0,0(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2e>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x2a>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x18>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	60a2                	ld	ra,8(sp)
    800002e2:	6402                	ld	s0,0(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <strlen>:

int
strlen(const char *s)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f0:	00054783          	lbu	a5,0(a0)
    800002f4:	cf91                	beqz	a5,80000310 <strlen+0x28>
    800002f6:	00150793          	addi	a5,a0,1
    800002fa:	86be                	mv	a3,a5
    800002fc:	0785                	addi	a5,a5,1
    800002fe:	fff7c703          	lbu	a4,-1(a5)
    80000302:	ff65                	bnez	a4,800002fa <strlen+0x12>
    80000304:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000308:	60a2                	ld	ra,8(sp)
    8000030a:	6402                	ld	s0,0(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000310:	4501                	li	a0,0
    80000312:	bfdd                	j	80000308 <strlen+0x20>

0000000080000314 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e406                	sd	ra,8(sp)
    80000318:	e022                	sd	s0,0(sp)
    8000031a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000031c:	237000ef          	jal	80000d52 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	0000a717          	auipc	a4,0xa
    80000324:	06070713          	addi	a4,a4,96 # 8000a380 <started>
  if(cpuid() == 0){
    80000328:	c51d                	beqz	a0,80000356 <main+0x42>
    while(started == 0)
    8000032a:	431c                	lw	a5,0(a4)
    8000032c:	2781                	sext.w	a5,a5
    8000032e:	dff5                	beqz	a5,8000032a <main+0x16>
      ;
    __sync_synchronize();
    80000330:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000334:	21f000ef          	jal	80000d52 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	0ac050ef          	jal	800053ee <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	53a010ef          	jal	80001884 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	67a040ef          	jal	800049c8 <plicinithart>
  }

  scheduler();        
    80000352:	66b000ef          	jal	800011bc <scheduler>
    consoleinit();
    80000356:	7bf040ef          	jal	80005314 <consoleinit>
    printfinit();
    8000035a:	3de050ef          	jal	80005738 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	088050ef          	jal	800053ee <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	07c050ef          	jal	800053ee <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	070050ef          	jal	800053ee <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	10b000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000392:	4ce010ef          	jal	80001860 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	4ee010ef          	jal	80001884 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	614040ef          	jal	800049ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	62a040ef          	jal	800049c8 <plicinithart>
    binit();         // buffer cache
    800003a2:	58d010ef          	jal	8000212e <binit>
    iinit();         // inode table
    800003a6:	348020ef          	jal	800026ee <iinit>
    fileinit();      // file table
    800003aa:	12e030ef          	jal	800034d8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	70a040ef          	jal	80004ab8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	43f000ef          	jal	80000ff0 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	0000a717          	auipc	a4,0xa
    800003c0:	fcf72223          	sw	a5,-60(a4) # 8000a380 <started>
    800003c4:	b779                	j	80000352 <main+0x3e>

00000000800003c6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003c6:	1141                	addi	sp,sp,-16
    800003c8:	e406                	sd	ra,8(sp)
    800003ca:	e022                	sd	s0,0(sp)
    800003cc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ce:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003d2:	0000a797          	auipc	a5,0xa
    800003d6:	fb67b783          	ld	a5,-74(a5) # 8000a388 <kernel_pagetable>
    800003da:	83b1                	srli	a5,a5,0xc
    800003dc:	577d                	li	a4,-1
    800003de:	177e                	slli	a4,a4,0x3f
    800003e0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003e2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003e6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ea:	60a2                	ld	ra,8(sp)
    800003ec:	6402                	ld	s0,0(sp)
    800003ee:	0141                	addi	sp,sp,16
    800003f0:	8082                	ret

00000000800003f2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003f2:	7139                	addi	sp,sp,-64
    800003f4:	fc06                	sd	ra,56(sp)
    800003f6:	f822                	sd	s0,48(sp)
    800003f8:	f426                	sd	s1,40(sp)
    800003fa:	f04a                	sd	s2,32(sp)
    800003fc:	ec4e                	sd	s3,24(sp)
    800003fe:	e852                	sd	s4,16(sp)
    80000400:	e456                	sd	s5,8(sp)
    80000402:	e05a                	sd	s6,0(sp)
    80000404:	0080                	addi	s0,sp,64
    80000406:	84aa                	mv	s1,a0
    80000408:	89ae                	mv	s3,a1
    8000040a:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000040c:	57fd                	li	a5,-1
    8000040e:	83e9                	srli	a5,a5,0x1a
    80000410:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000412:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000414:	04b7e263          	bltu	a5,a1,80000458 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000418:	0149d933          	srl	s2,s3,s4
    8000041c:	1ff97913          	andi	s2,s2,511
    80000420:	090e                	slli	s2,s2,0x3
    80000422:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000424:	00093483          	ld	s1,0(s2)
    80000428:	0014f793          	andi	a5,s1,1
    8000042c:	cf85                	beqz	a5,80000464 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000042e:	80a9                	srli	s1,s1,0xa
    80000430:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000432:	3a5d                	addiw	s4,s4,-9
    80000434:	ff5a12e3          	bne	s4,s5,80000418 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
    panic("walk");
    80000458:	00007517          	auipc	a0,0x7
    8000045c:	bf850513          	addi	a0,a0,-1032 # 80007050 <etext+0x50>
    80000460:	29e050ef          	jal	800056fe <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000464:	020b0263          	beqz	s6,80000488 <walk+0x96>
    80000468:	c9dff0ef          	jal	80000104 <kalloc>
    8000046c:	84aa                	mv	s1,a0
    8000046e:	d979                	beqz	a0,80000444 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000470:	6605                	lui	a2,0x1
    80000472:	4581                	li	a1,0
    80000474:	cebff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000478:	00c4d793          	srli	a5,s1,0xc
    8000047c:	07aa                	slli	a5,a5,0xa
    8000047e:	0017e793          	ori	a5,a5,1
    80000482:	00f93023          	sd	a5,0(s2)
    80000486:	b775                	j	80000432 <walk+0x40>
        return 0;
    80000488:	4501                	li	a0,0
    8000048a:	bf6d                	j	80000444 <walk+0x52>

000000008000048c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000048c:	57fd                	li	a5,-1
    8000048e:	83e9                	srli	a5,a5,0x1a
    80000490:	00b7f463          	bgeu	a5,a1,80000498 <walkaddr+0xc>
    return 0;
    80000494:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000496:	8082                	ret
{
    80000498:	1141                	addi	sp,sp,-16
    8000049a:	e406                	sd	ra,8(sp)
    8000049c:	e022                	sd	s0,0(sp)
    8000049e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004a0:	4601                	li	a2,0
    800004a2:	f51ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    800004a6:	c901                	beqz	a0,800004b6 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800004a8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004aa:	0117f693          	andi	a3,a5,17
    800004ae:	4745                	li	a4,17
    return 0;
    800004b0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004b2:	00e68663          	beq	a3,a4,800004be <walkaddr+0x32>
}
    800004b6:	60a2                	ld	ra,8(sp)
    800004b8:	6402                	ld	s0,0(sp)
    800004ba:	0141                	addi	sp,sp,16
    800004bc:	8082                	ret
  pa = PTE2PA(*pte);
    800004be:	83a9                	srli	a5,a5,0xa
    800004c0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004c4:	bfcd                	j	800004b6 <walkaddr+0x2a>

00000000800004c6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c6:	715d                	addi	sp,sp,-80
    800004c8:	e486                	sd	ra,72(sp)
    800004ca:	e0a2                	sd	s0,64(sp)
    800004cc:	fc26                	sd	s1,56(sp)
    800004ce:	f84a                	sd	s2,48(sp)
    800004d0:	f44e                	sd	s3,40(sp)
    800004d2:	f052                	sd	s4,32(sp)
    800004d4:	ec56                	sd	s5,24(sp)
    800004d6:	e85a                	sd	s6,16(sp)
    800004d8:	e45e                	sd	s7,8(sp)
    800004da:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004dc:	03459793          	slli	a5,a1,0x34
    800004e0:	eba1                	bnez	a5,80000530 <mappages+0x6a>
    800004e2:	8a2a                	mv	s4,a0
    800004e4:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e6:	03461793          	slli	a5,a2,0x34
    800004ea:	eba9                	bnez	a5,8000053c <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ec:	ce31                	beqz	a2,80000548 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ee:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800004f2:	80060613          	addi	a2,a2,-2048
    800004f6:	00b60933          	add	s2,a2,a1
  a = va;
    800004fa:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	4b05                	li	s6,1
    800004fe:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000502:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80000504:	865a                	mv	a2,s6
    80000506:	85a6                	mv	a1,s1
    80000508:	8552                	mv	a0,s4
    8000050a:	ee9ff0ef          	jal	800003f2 <walk>
    8000050e:	c929                	beqz	a0,80000560 <mappages+0x9a>
    if(*pte & PTE_V)
    80000510:	611c                	ld	a5,0(a0)
    80000512:	8b85                	andi	a5,a5,1
    80000514:	e3a1                	bnez	a5,80000554 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000516:	013487b3          	add	a5,s1,s3
    8000051a:	83b1                	srli	a5,a5,0xc
    8000051c:	07aa                	slli	a5,a5,0xa
    8000051e:	0157e7b3          	or	a5,a5,s5
    80000522:	0017e793          	ori	a5,a5,1
    80000526:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000528:	05248863          	beq	s1,s2,80000578 <mappages+0xb2>
    a += PGSIZE;
    8000052c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000052e:	bfd9                	j	80000504 <mappages+0x3e>
    panic("mappages: va not aligned");
    80000530:	00007517          	auipc	a0,0x7
    80000534:	b2850513          	addi	a0,a0,-1240 # 80007058 <etext+0x58>
    80000538:	1c6050ef          	jal	800056fe <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	1ba050ef          	jal	800056fe <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	1ae050ef          	jal	800056fe <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	1a2050ef          	jal	800056fe <panic>
      return -1;
    80000560:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000562:	60a6                	ld	ra,72(sp)
    80000564:	6406                	ld	s0,64(sp)
    80000566:	74e2                	ld	s1,56(sp)
    80000568:	7942                	ld	s2,48(sp)
    8000056a:	79a2                	ld	s3,40(sp)
    8000056c:	7a02                	ld	s4,32(sp)
    8000056e:	6ae2                	ld	s5,24(sp)
    80000570:	6b42                	ld	s6,16(sp)
    80000572:	6ba2                	ld	s7,8(sp)
    80000574:	6161                	addi	sp,sp,80
    80000576:	8082                	ret
  return 0;
    80000578:	4501                	li	a0,0
    8000057a:	b7e5                	j	80000562 <mappages+0x9c>

000000008000057c <kvmmap>:
{
    8000057c:	1141                	addi	sp,sp,-16
    8000057e:	e406                	sd	ra,8(sp)
    80000580:	e022                	sd	s0,0(sp)
    80000582:	0800                	addi	s0,sp,16
    80000584:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000586:	86b2                	mv	a3,a2
    80000588:	863e                	mv	a2,a5
    8000058a:	f3dff0ef          	jal	800004c6 <mappages>
    8000058e:	e509                	bnez	a0,80000598 <kvmmap+0x1c>
}
    80000590:	60a2                	ld	ra,8(sp)
    80000592:	6402                	ld	s0,0(sp)
    80000594:	0141                	addi	sp,sp,16
    80000596:	8082                	ret
    panic("kvmmap");
    80000598:	00007517          	auipc	a0,0x7
    8000059c:	b2050513          	addi	a0,a0,-1248 # 800070b8 <etext+0xb8>
    800005a0:	15e050ef          	jal	800056fe <panic>

00000000800005a4 <kvmmake>:
{
    800005a4:	1101                	addi	sp,sp,-32
    800005a6:	ec06                	sd	ra,24(sp)
    800005a8:	e822                	sd	s0,16(sp)
    800005aa:	e426                	sd	s1,8(sp)
    800005ac:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005ae:	b57ff0ef          	jal	80000104 <kalloc>
    800005b2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005b4:	6605                	lui	a2,0x1
    800005b6:	4581                	li	a1,0
    800005b8:	ba7ff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	6685                	lui	a3,0x1
    800005c0:	10000637          	lui	a2,0x10000
    800005c4:	85b2                	mv	a1,a2
    800005c6:	8526                	mv	a0,s1
    800005c8:	fb5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005cc:	4719                	li	a4,6
    800005ce:	6685                	lui	a3,0x1
    800005d0:	10001637          	lui	a2,0x10001
    800005d4:	85b2                	mv	a1,a2
    800005d6:	8526                	mv	a0,s1
    800005d8:	fa5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005dc:	4719                	li	a4,6
    800005de:	040006b7          	lui	a3,0x4000
    800005e2:	0c000637          	lui	a2,0xc000
    800005e6:	85b2                	mv	a1,a2
    800005e8:	8526                	mv	a0,s1
    800005ea:	f93ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ee:	4729                	li	a4,10
    800005f0:	80007697          	auipc	a3,0x80007
    800005f4:	a1068693          	addi	a3,a3,-1520 # 7000 <_entry-0x7fff9000>
    800005f8:	4605                	li	a2,1
    800005fa:	067e                	slli	a2,a2,0x1f
    800005fc:	85b2                	mv	a1,a2
    800005fe:	8526                	mv	a0,s1
    80000600:	f7dff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000604:	4719                	li	a4,6
    80000606:	00007697          	auipc	a3,0x7
    8000060a:	9fa68693          	addi	a3,a3,-1542 # 80007000 <etext>
    8000060e:	47c5                	li	a5,17
    80000610:	07ee                	slli	a5,a5,0x1b
    80000612:	40d786b3          	sub	a3,a5,a3
    80000616:	00007617          	auipc	a2,0x7
    8000061a:	9ea60613          	addi	a2,a2,-1558 # 80007000 <etext>
    8000061e:	85b2                	mv	a1,a2
    80000620:	8526                	mv	a0,s1
    80000622:	f5bff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000626:	4729                	li	a4,10
    80000628:	6685                	lui	a3,0x1
    8000062a:	00006617          	auipc	a2,0x6
    8000062e:	9d660613          	addi	a2,a2,-1578 # 80006000 <_trampoline>
    80000632:	040005b7          	lui	a1,0x4000
    80000636:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000638:	05b2                	slli	a1,a1,0xc
    8000063a:	8526                	mv	a0,s1
    8000063c:	f41ff0ef          	jal	8000057c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000640:	8526                	mv	a0,s1
    80000642:	5b2000ef          	jal	80000bf4 <proc_mapstacks>
}
    80000646:	8526                	mv	a0,s1
    80000648:	60e2                	ld	ra,24(sp)
    8000064a:	6442                	ld	s0,16(sp)
    8000064c:	64a2                	ld	s1,8(sp)
    8000064e:	6105                	addi	sp,sp,32
    80000650:	8082                	ret

0000000080000652 <kvminit>:
{
    80000652:	1141                	addi	sp,sp,-16
    80000654:	e406                	sd	ra,8(sp)
    80000656:	e022                	sd	s0,0(sp)
    80000658:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000065a:	f4bff0ef          	jal	800005a4 <kvmmake>
    8000065e:	0000a797          	auipc	a5,0xa
    80000662:	d2a7b523          	sd	a0,-726(a5) # 8000a388 <kernel_pagetable>
}
    80000666:	60a2                	ld	ra,8(sp)
    80000668:	6402                	ld	s0,0(sp)
    8000066a:	0141                	addi	sp,sp,16
    8000066c:	8082                	ret

000000008000066e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000066e:	715d                	addi	sp,sp,-80
    80000670:	e486                	sd	ra,72(sp)
    80000672:	e0a2                	sd	s0,64(sp)
    80000674:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000676:	03459793          	slli	a5,a1,0x34
    8000067a:	e39d                	bnez	a5,800006a0 <uvmunmap+0x32>
    8000067c:	f84a                	sd	s2,48(sp)
    8000067e:	f44e                	sd	s3,40(sp)
    80000680:	f052                	sd	s4,32(sp)
    80000682:	ec56                	sd	s5,24(sp)
    80000684:	e85a                	sd	s6,16(sp)
    80000686:	e45e                	sd	s7,8(sp)
    80000688:	8a2a                	mv	s4,a0
    8000068a:	892e                	mv	s2,a1
    8000068c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000068e:	0632                	slli	a2,a2,0xc
    80000690:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000694:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000696:	6b05                	lui	s6,0x1
    80000698:	0735ff63          	bgeu	a1,s3,80000716 <uvmunmap+0xa8>
    8000069c:	fc26                	sd	s1,56(sp)
    8000069e:	a0a9                	j	800006e8 <uvmunmap+0x7a>
    800006a0:	fc26                	sd	s1,56(sp)
    800006a2:	f84a                	sd	s2,48(sp)
    800006a4:	f44e                	sd	s3,40(sp)
    800006a6:	f052                	sd	s4,32(sp)
    800006a8:	ec56                	sd	s5,24(sp)
    800006aa:	e85a                	sd	s6,16(sp)
    800006ac:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006ae:	00007517          	auipc	a0,0x7
    800006b2:	a1250513          	addi	a0,a0,-1518 # 800070c0 <etext+0xc0>
    800006b6:	048050ef          	jal	800056fe <panic>
      panic("uvmunmap: walk");
    800006ba:	00007517          	auipc	a0,0x7
    800006be:	a1e50513          	addi	a0,a0,-1506 # 800070d8 <etext+0xd8>
    800006c2:	03c050ef          	jal	800056fe <panic>
      panic("uvmunmap: not mapped");
    800006c6:	00007517          	auipc	a0,0x7
    800006ca:	a2250513          	addi	a0,a0,-1502 # 800070e8 <etext+0xe8>
    800006ce:	030050ef          	jal	800056fe <panic>
      panic("uvmunmap: not a leaf");
    800006d2:	00007517          	auipc	a0,0x7
    800006d6:	a2e50513          	addi	a0,a0,-1490 # 80007100 <etext+0x100>
    800006da:	024050ef          	jal	800056fe <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006de:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006e2:	995a                	add	s2,s2,s6
    800006e4:	03397863          	bgeu	s2,s3,80000714 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006e8:	4601                	li	a2,0
    800006ea:	85ca                	mv	a1,s2
    800006ec:	8552                	mv	a0,s4
    800006ee:	d05ff0ef          	jal	800003f2 <walk>
    800006f2:	84aa                	mv	s1,a0
    800006f4:	d179                	beqz	a0,800006ba <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006f6:	6108                	ld	a0,0(a0)
    800006f8:	00157793          	andi	a5,a0,1
    800006fc:	d7e9                	beqz	a5,800006c6 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006fe:	3ff57793          	andi	a5,a0,1023
    80000702:	fd7788e3          	beq	a5,s7,800006d2 <uvmunmap+0x64>
    if(do_free){
    80000706:	fc0a8ce3          	beqz	s5,800006de <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000070a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000070c:	0532                	slli	a0,a0,0xc
    8000070e:	90fff0ef          	jal	8000001c <kfree>
    80000712:	b7f1                	j	800006de <uvmunmap+0x70>
    80000714:	74e2                	ld	s1,56(sp)
    80000716:	7942                	ld	s2,48(sp)
    80000718:	79a2                	ld	s3,40(sp)
    8000071a:	7a02                	ld	s4,32(sp)
    8000071c:	6ae2                	ld	s5,24(sp)
    8000071e:	6b42                	ld	s6,16(sp)
    80000720:	6ba2                	ld	s7,8(sp)
  }
}
    80000722:	60a6                	ld	ra,72(sp)
    80000724:	6406                	ld	s0,64(sp)
    80000726:	6161                	addi	sp,sp,80
    80000728:	8082                	ret

000000008000072a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000072a:	1101                	addi	sp,sp,-32
    8000072c:	ec06                	sd	ra,24(sp)
    8000072e:	e822                	sd	s0,16(sp)
    80000730:	e426                	sd	s1,8(sp)
    80000732:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000734:	9d1ff0ef          	jal	80000104 <kalloc>
    80000738:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000073a:	c509                	beqz	a0,80000744 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000073c:	6605                	lui	a2,0x1
    8000073e:	4581                	li	a1,0
    80000740:	a1fff0ef          	jal	8000015e <memset>
  return pagetable;
}
    80000744:	8526                	mv	a0,s1
    80000746:	60e2                	ld	ra,24(sp)
    80000748:	6442                	ld	s0,16(sp)
    8000074a:	64a2                	ld	s1,8(sp)
    8000074c:	6105                	addi	sp,sp,32
    8000074e:	8082                	ret

0000000080000750 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000750:	7179                	addi	sp,sp,-48
    80000752:	f406                	sd	ra,40(sp)
    80000754:	f022                	sd	s0,32(sp)
    80000756:	ec26                	sd	s1,24(sp)
    80000758:	e84a                	sd	s2,16(sp)
    8000075a:	e44e                	sd	s3,8(sp)
    8000075c:	e052                	sd	s4,0(sp)
    8000075e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000760:	6785                	lui	a5,0x1
    80000762:	04f67063          	bgeu	a2,a5,800007a2 <uvmfirst+0x52>
    80000766:	89aa                	mv	s3,a0
    80000768:	8a2e                	mv	s4,a1
    8000076a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000076c:	999ff0ef          	jal	80000104 <kalloc>
    80000770:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000772:	6605                	lui	a2,0x1
    80000774:	4581                	li	a1,0
    80000776:	9e9ff0ef          	jal	8000015e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000077a:	4779                	li	a4,30
    8000077c:	86ca                	mv	a3,s2
    8000077e:	6605                	lui	a2,0x1
    80000780:	4581                	li	a1,0
    80000782:	854e                	mv	a0,s3
    80000784:	d43ff0ef          	jal	800004c6 <mappages>
  memmove(mem, src, sz);
    80000788:	8626                	mv	a2,s1
    8000078a:	85d2                	mv	a1,s4
    8000078c:	854a                	mv	a0,s2
    8000078e:	a31ff0ef          	jal	800001be <memmove>
}
    80000792:	70a2                	ld	ra,40(sp)
    80000794:	7402                	ld	s0,32(sp)
    80000796:	64e2                	ld	s1,24(sp)
    80000798:	6942                	ld	s2,16(sp)
    8000079a:	69a2                	ld	s3,8(sp)
    8000079c:	6a02                	ld	s4,0(sp)
    8000079e:	6145                	addi	sp,sp,48
    800007a0:	8082                	ret
    panic("uvmfirst: more than a page");
    800007a2:	00007517          	auipc	a0,0x7
    800007a6:	97650513          	addi	a0,a0,-1674 # 80007118 <etext+0x118>
    800007aa:	755040ef          	jal	800056fe <panic>

00000000800007ae <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007ae:	1101                	addi	sp,sp,-32
    800007b0:	ec06                	sd	ra,24(sp)
    800007b2:	e822                	sd	s0,16(sp)
    800007b4:	e426                	sd	s1,8(sp)
    800007b6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007b8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ba:	00b67d63          	bgeu	a2,a1,800007d4 <uvmdealloc+0x26>
    800007be:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007c0:	6785                	lui	a5,0x1
    800007c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007c4:	00f60733          	add	a4,a2,a5
    800007c8:	76fd                	lui	a3,0xfffff
    800007ca:	8f75                	and	a4,a4,a3
    800007cc:	97ae                	add	a5,a5,a1
    800007ce:	8ff5                	and	a5,a5,a3
    800007d0:	00f76863          	bltu	a4,a5,800007e0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007d4:	8526                	mv	a0,s1
    800007d6:	60e2                	ld	ra,24(sp)
    800007d8:	6442                	ld	s0,16(sp)
    800007da:	64a2                	ld	s1,8(sp)
    800007dc:	6105                	addi	sp,sp,32
    800007de:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007e0:	8f99                	sub	a5,a5,a4
    800007e2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007e4:	4685                	li	a3,1
    800007e6:	0007861b          	sext.w	a2,a5
    800007ea:	85ba                	mv	a1,a4
    800007ec:	e83ff0ef          	jal	8000066e <uvmunmap>
    800007f0:	b7d5                	j	800007d4 <uvmdealloc+0x26>

00000000800007f2 <uvmalloc>:
  if(newsz < oldsz)
    800007f2:	0ab66163          	bltu	a2,a1,80000894 <uvmalloc+0xa2>
{
    800007f6:	715d                	addi	sp,sp,-80
    800007f8:	e486                	sd	ra,72(sp)
    800007fa:	e0a2                	sd	s0,64(sp)
    800007fc:	f84a                	sd	s2,48(sp)
    800007fe:	f052                	sd	s4,32(sp)
    80000800:	ec56                	sd	s5,24(sp)
    80000802:	e45e                	sd	s7,8(sp)
    80000804:	0880                	addi	s0,sp,80
    80000806:	8aaa                	mv	s5,a0
    80000808:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000080a:	6785                	lui	a5,0x1
    8000080c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000080e:	95be                	add	a1,a1,a5
    80000810:	77fd                	lui	a5,0xfffff
    80000812:	00f5f933          	and	s2,a1,a5
    80000816:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000818:	08c97063          	bgeu	s2,a2,80000898 <uvmalloc+0xa6>
    8000081c:	fc26                	sd	s1,56(sp)
    8000081e:	f44e                	sd	s3,40(sp)
    80000820:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80000822:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000824:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000828:	8ddff0ef          	jal	80000104 <kalloc>
    8000082c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000082e:	c50d                	beqz	a0,80000858 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    80000830:	864e                	mv	a2,s3
    80000832:	4581                	li	a1,0
    80000834:	92bff0ef          	jal	8000015e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000838:	875a                	mv	a4,s6
    8000083a:	86a6                	mv	a3,s1
    8000083c:	864e                	mv	a2,s3
    8000083e:	85ca                	mv	a1,s2
    80000840:	8556                	mv	a0,s5
    80000842:	c85ff0ef          	jal	800004c6 <mappages>
    80000846:	e915                	bnez	a0,8000087a <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000848:	994e                	add	s2,s2,s3
    8000084a:	fd496fe3          	bltu	s2,s4,80000828 <uvmalloc+0x36>
  return newsz;
    8000084e:	8552                	mv	a0,s4
    80000850:	74e2                	ld	s1,56(sp)
    80000852:	79a2                	ld	s3,40(sp)
    80000854:	6b42                	ld	s6,16(sp)
    80000856:	a811                	j	8000086a <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80000858:	865e                	mv	a2,s7
    8000085a:	85ca                	mv	a1,s2
    8000085c:	8556                	mv	a0,s5
    8000085e:	f51ff0ef          	jal	800007ae <uvmdealloc>
      return 0;
    80000862:	4501                	li	a0,0
    80000864:	74e2                	ld	s1,56(sp)
    80000866:	79a2                	ld	s3,40(sp)
    80000868:	6b42                	ld	s6,16(sp)
}
    8000086a:	60a6                	ld	ra,72(sp)
    8000086c:	6406                	ld	s0,64(sp)
    8000086e:	7942                	ld	s2,48(sp)
    80000870:	7a02                	ld	s4,32(sp)
    80000872:	6ae2                	ld	s5,24(sp)
    80000874:	6ba2                	ld	s7,8(sp)
    80000876:	6161                	addi	sp,sp,80
    80000878:	8082                	ret
      kfree(mem);
    8000087a:	8526                	mv	a0,s1
    8000087c:	fa0ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000880:	865e                	mv	a2,s7
    80000882:	85ca                	mv	a1,s2
    80000884:	8556                	mv	a0,s5
    80000886:	f29ff0ef          	jal	800007ae <uvmdealloc>
      return 0;
    8000088a:	4501                	li	a0,0
    8000088c:	74e2                	ld	s1,56(sp)
    8000088e:	79a2                	ld	s3,40(sp)
    80000890:	6b42                	ld	s6,16(sp)
    80000892:	bfe1                	j	8000086a <uvmalloc+0x78>
    return oldsz;
    80000894:	852e                	mv	a0,a1
}
    80000896:	8082                	ret
  return newsz;
    80000898:	8532                	mv	a0,a2
    8000089a:	bfc1                	j	8000086a <uvmalloc+0x78>

000000008000089c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000089c:	7179                	addi	sp,sp,-48
    8000089e:	f406                	sd	ra,40(sp)
    800008a0:	f022                	sd	s0,32(sp)
    800008a2:	ec26                	sd	s1,24(sp)
    800008a4:	e84a                	sd	s2,16(sp)
    800008a6:	e44e                	sd	s3,8(sp)
    800008a8:	1800                	addi	s0,sp,48
    800008aa:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008ac:	84aa                	mv	s1,a0
    800008ae:	6905                	lui	s2,0x1
    800008b0:	992a                	add	s2,s2,a0
    800008b2:	a811                	j	800008c6 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800008b4:	00007517          	auipc	a0,0x7
    800008b8:	88450513          	addi	a0,a0,-1916 # 80007138 <etext+0x138>
    800008bc:	643040ef          	jal	800056fe <panic>
  for(int i = 0; i < 512; i++){
    800008c0:	04a1                	addi	s1,s1,8
    800008c2:	03248163          	beq	s1,s2,800008e4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800008c6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c8:	0017f713          	andi	a4,a5,1
    800008cc:	db75                	beqz	a4,800008c0 <freewalk+0x24>
    800008ce:	00e7f713          	andi	a4,a5,14
    800008d2:	f36d                	bnez	a4,800008b4 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800008d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008d6:	00c79513          	slli	a0,a5,0xc
    800008da:	fc3ff0ef          	jal	8000089c <freewalk>
      pagetable[i] = 0;
    800008de:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008e2:	bff9                	j	800008c0 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800008e4:	854e                	mv	a0,s3
    800008e6:	f36ff0ef          	jal	8000001c <kfree>
}
    800008ea:	70a2                	ld	ra,40(sp)
    800008ec:	7402                	ld	s0,32(sp)
    800008ee:	64e2                	ld	s1,24(sp)
    800008f0:	6942                	ld	s2,16(sp)
    800008f2:	69a2                	ld	s3,8(sp)
    800008f4:	6145                	addi	sp,sp,48
    800008f6:	8082                	ret

00000000800008f8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008f8:	1101                	addi	sp,sp,-32
    800008fa:	ec06                	sd	ra,24(sp)
    800008fc:	e822                	sd	s0,16(sp)
    800008fe:	e426                	sd	s1,8(sp)
    80000900:	1000                	addi	s0,sp,32
    80000902:	84aa                	mv	s1,a0
  if(sz > 0)
    80000904:	e989                	bnez	a1,80000916 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000906:	8526                	mv	a0,s1
    80000908:	f95ff0ef          	jal	8000089c <freewalk>
}
    8000090c:	60e2                	ld	ra,24(sp)
    8000090e:	6442                	ld	s0,16(sp)
    80000910:	64a2                	ld	s1,8(sp)
    80000912:	6105                	addi	sp,sp,32
    80000914:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000916:	6785                	lui	a5,0x1
    80000918:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091a:	95be                	add	a1,a1,a5
    8000091c:	4685                	li	a3,1
    8000091e:	00c5d613          	srli	a2,a1,0xc
    80000922:	4581                	li	a1,0
    80000924:	d4bff0ef          	jal	8000066e <uvmunmap>
    80000928:	bff9                	j	80000906 <uvmfree+0xe>

000000008000092a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000092a:	c64d                	beqz	a2,800009d4 <uvmcopy+0xaa>
{
    8000092c:	715d                	addi	sp,sp,-80
    8000092e:	e486                	sd	ra,72(sp)
    80000930:	e0a2                	sd	s0,64(sp)
    80000932:	fc26                	sd	s1,56(sp)
    80000934:	f84a                	sd	s2,48(sp)
    80000936:	f44e                	sd	s3,40(sp)
    80000938:	f052                	sd	s4,32(sp)
    8000093a:	ec56                	sd	s5,24(sp)
    8000093c:	e85a                	sd	s6,16(sp)
    8000093e:	e45e                	sd	s7,8(sp)
    80000940:	0880                	addi	s0,sp,80
    80000942:	8b2a                	mv	s6,a0
    80000944:	8aae                	mv	s5,a1
    80000946:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000948:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000094a:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000094c:	4601                	li	a2,0
    8000094e:	85ca                	mv	a1,s2
    80000950:	855a                	mv	a0,s6
    80000952:	aa1ff0ef          	jal	800003f2 <walk>
    80000956:	cd0d                	beqz	a0,80000990 <uvmcopy+0x66>
    if((*pte & PTE_V) == 0)
    80000958:	00053b83          	ld	s7,0(a0)
    8000095c:	001bf793          	andi	a5,s7,1
    80000960:	cf95                	beqz	a5,8000099c <uvmcopy+0x72>
    if((mem = kalloc()) == 0)
    80000962:	fa2ff0ef          	jal	80000104 <kalloc>
    80000966:	84aa                	mv	s1,a0
    80000968:	c139                	beqz	a0,800009ae <uvmcopy+0x84>
    pa = PTE2PA(*pte);
    8000096a:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    8000096e:	864e                	mv	a2,s3
    80000970:	05b2                	slli	a1,a1,0xc
    80000972:	84dff0ef          	jal	800001be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000976:	3ffbf713          	andi	a4,s7,1023
    8000097a:	86a6                	mv	a3,s1
    8000097c:	864e                	mv	a2,s3
    8000097e:	85ca                	mv	a1,s2
    80000980:	8556                	mv	a0,s5
    80000982:	b45ff0ef          	jal	800004c6 <mappages>
    80000986:	e10d                	bnez	a0,800009a8 <uvmcopy+0x7e>
  for(i = 0; i < sz; i += PGSIZE){
    80000988:	994e                	add	s2,s2,s3
    8000098a:	fd4961e3          	bltu	s2,s4,8000094c <uvmcopy+0x22>
    8000098e:	a805                	j	800009be <uvmcopy+0x94>
      panic("uvmcopy: pte should exist");
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	567040ef          	jal	800056fe <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	55b040ef          	jal	800056fe <panic>
      kfree(mem);
    800009a8:	8526                	mv	a0,s1
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009ae:	4685                	li	a3,1
    800009b0:	00c95613          	srli	a2,s2,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	8556                	mv	a0,s5
    800009b8:	cb7ff0ef          	jal	8000066e <uvmunmap>
  return -1;
    800009bc:	557d                	li	a0,-1
}
    800009be:	60a6                	ld	ra,72(sp)
    800009c0:	6406                	ld	s0,64(sp)
    800009c2:	74e2                	ld	s1,56(sp)
    800009c4:	7942                	ld	s2,48(sp)
    800009c6:	79a2                	ld	s3,40(sp)
    800009c8:	7a02                	ld	s4,32(sp)
    800009ca:	6ae2                	ld	s5,24(sp)
    800009cc:	6b42                	ld	s6,16(sp)
    800009ce:	6ba2                	ld	s7,8(sp)
    800009d0:	6161                	addi	sp,sp,80
    800009d2:	8082                	ret
  return 0;
    800009d4:	4501                	li	a0,0
}
    800009d6:	8082                	ret

00000000800009d8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009d8:	1141                	addi	sp,sp,-16
    800009da:	e406                	sd	ra,8(sp)
    800009dc:	e022                	sd	s0,0(sp)
    800009de:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e0:	4601                	li	a2,0
    800009e2:	a11ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    800009e6:	c901                	beqz	a0,800009f6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009e8:	611c                	ld	a5,0(a0)
    800009ea:	9bbd                	andi	a5,a5,-17
    800009ec:	e11c                	sd	a5,0(a0)
}
    800009ee:	60a2                	ld	ra,8(sp)
    800009f0:	6402                	ld	s0,0(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    panic("uvmclear");
    800009f6:	00006517          	auipc	a0,0x6
    800009fa:	79250513          	addi	a0,a0,1938 # 80007188 <etext+0x188>
    800009fe:	501040ef          	jal	800056fe <panic>

0000000080000a02 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a02:	c2d9                	beqz	a3,80000a88 <copyout+0x86>
{
    80000a04:	711d                	addi	sp,sp,-96
    80000a06:	ec86                	sd	ra,88(sp)
    80000a08:	e8a2                	sd	s0,80(sp)
    80000a0a:	e4a6                	sd	s1,72(sp)
    80000a0c:	e0ca                	sd	s2,64(sp)
    80000a0e:	fc4e                	sd	s3,56(sp)
    80000a10:	f852                	sd	s4,48(sp)
    80000a12:	f456                	sd	s5,40(sp)
    80000a14:	f05a                	sd	s6,32(sp)
    80000a16:	ec5e                	sd	s7,24(sp)
    80000a18:	e862                	sd	s8,16(sp)
    80000a1a:	e466                	sd	s9,8(sp)
    80000a1c:	e06a                	sd	s10,0(sp)
    80000a1e:	1080                	addi	s0,sp,96
    80000a20:	8c2a                	mv	s8,a0
    80000a22:	892e                	mv	s2,a1
    80000a24:	8ab2                	mv	s5,a2
    80000a26:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a28:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000a2a:	5bfd                	li	s7,-1
    80000a2c:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a30:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000a32:	6b05                	lui	s6,0x1
    80000a34:	a015                	j	80000a58 <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000a36:	83a9                	srli	a5,a5,0xa
    80000a38:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3a:	41390533          	sub	a0,s2,s3
    80000a3e:	0004861b          	sext.w	a2,s1
    80000a42:	85d6                	mv	a1,s5
    80000a44:	953e                	add	a0,a0,a5
    80000a46:	f78ff0ef          	jal	800001be <memmove>

    len -= n;
    80000a4a:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a4e:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a50:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000a54:	020a0863          	beqz	s4,80000a84 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000a58:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000a5c:	033be863          	bltu	s7,s3,80000a8c <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000a60:	4601                	li	a2,0
    80000a62:	85ce                	mv	a1,s3
    80000a64:	8562                	mv	a0,s8
    80000a66:	98dff0ef          	jal	800003f2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a6a:	c11d                	beqz	a0,80000a90 <copyout+0x8e>
    80000a6c:	611c                	ld	a5,0(a0)
    80000a6e:	0157f713          	andi	a4,a5,21
    80000a72:	03a71163          	bne	a4,s10,80000a94 <copyout+0x92>
    n = PGSIZE - (dstva - va0);
    80000a76:	412984b3          	sub	s1,s3,s2
    80000a7a:	94da                	add	s1,s1,s6
    if(n > len)
    80000a7c:	fa9a7de3          	bgeu	s4,s1,80000a36 <copyout+0x34>
    80000a80:	84d2                	mv	s1,s4
    80000a82:	bf55                	j	80000a36 <copyout+0x34>
  }
  return 0;
    80000a84:	4501                	li	a0,0
    80000a86:	a801                	j	80000a96 <copyout+0x94>
    80000a88:	4501                	li	a0,0
}
    80000a8a:	8082                	ret
      return -1;
    80000a8c:	557d                	li	a0,-1
    80000a8e:	a021                	j	80000a96 <copyout+0x94>
      return -1;
    80000a90:	557d                	li	a0,-1
    80000a92:	a011                	j	80000a96 <copyout+0x94>
    80000a94:	557d                	li	a0,-1
}
    80000a96:	60e6                	ld	ra,88(sp)
    80000a98:	6446                	ld	s0,80(sp)
    80000a9a:	64a6                	ld	s1,72(sp)
    80000a9c:	6906                	ld	s2,64(sp)
    80000a9e:	79e2                	ld	s3,56(sp)
    80000aa0:	7a42                	ld	s4,48(sp)
    80000aa2:	7aa2                	ld	s5,40(sp)
    80000aa4:	7b02                	ld	s6,32(sp)
    80000aa6:	6be2                	ld	s7,24(sp)
    80000aa8:	6c42                	ld	s8,16(sp)
    80000aaa:	6ca2                	ld	s9,8(sp)
    80000aac:	6d02                	ld	s10,0(sp)
    80000aae:	6125                	addi	sp,sp,96
    80000ab0:	8082                	ret

0000000080000ab2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ab2:	c6a5                	beqz	a3,80000b1a <copyin+0x68>
{
    80000ab4:	715d                	addi	sp,sp,-80
    80000ab6:	e486                	sd	ra,72(sp)
    80000ab8:	e0a2                	sd	s0,64(sp)
    80000aba:	fc26                	sd	s1,56(sp)
    80000abc:	f84a                	sd	s2,48(sp)
    80000abe:	f44e                	sd	s3,40(sp)
    80000ac0:	f052                	sd	s4,32(sp)
    80000ac2:	ec56                	sd	s5,24(sp)
    80000ac4:	e85a                	sd	s6,16(sp)
    80000ac6:	e45e                	sd	s7,8(sp)
    80000ac8:	e062                	sd	s8,0(sp)
    80000aca:	0880                	addi	s0,sp,80
    80000acc:	8b2a                	mv	s6,a0
    80000ace:	8a2e                	mv	s4,a1
    80000ad0:	8c32                	mv	s8,a2
    80000ad2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad6:	6a85                	lui	s5,0x1
    80000ad8:	a00d                	j	80000afa <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ada:	018505b3          	add	a1,a0,s8
    80000ade:	0004861b          	sext.w	a2,s1
    80000ae2:	412585b3          	sub	a1,a1,s2
    80000ae6:	8552                	mv	a0,s4
    80000ae8:	ed6ff0ef          	jal	800001be <memmove>

    len -= n;
    80000aec:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000af0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000af2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af6:	02098063          	beqz	s3,80000b16 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000afa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000afe:	85ca                	mv	a1,s2
    80000b00:	855a                	mv	a0,s6
    80000b02:	98bff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0)
    80000b06:	cd01                	beqz	a0,80000b1e <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b08:	418904b3          	sub	s1,s2,s8
    80000b0c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b0e:	fc99f6e3          	bgeu	s3,s1,80000ada <copyin+0x28>
    80000b12:	84ce                	mv	s1,s3
    80000b14:	b7d9                	j	80000ada <copyin+0x28>
  }
  return 0;
    80000b16:	4501                	li	a0,0
    80000b18:	a021                	j	80000b20 <copyin+0x6e>
    80000b1a:	4501                	li	a0,0
}
    80000b1c:	8082                	ret
      return -1;
    80000b1e:	557d                	li	a0,-1
}
    80000b20:	60a6                	ld	ra,72(sp)
    80000b22:	6406                	ld	s0,64(sp)
    80000b24:	74e2                	ld	s1,56(sp)
    80000b26:	7942                	ld	s2,48(sp)
    80000b28:	79a2                	ld	s3,40(sp)
    80000b2a:	7a02                	ld	s4,32(sp)
    80000b2c:	6ae2                	ld	s5,24(sp)
    80000b2e:	6b42                	ld	s6,16(sp)
    80000b30:	6ba2                	ld	s7,8(sp)
    80000b32:	6c02                	ld	s8,0(sp)
    80000b34:	6161                	addi	sp,sp,80
    80000b36:	8082                	ret

0000000080000b38 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b38:	cac5                	beqz	a3,80000be8 <copyinstr+0xb0>
{
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
    80000b52:	84ae                	mv	s1,a1
    80000b54:	8bb2                	mv	s7,a2
    80000b56:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b58:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a82d                	j	80000b96 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80000b62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
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
    80000b82:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80000b86:	9726                	add	a4,a4,s1
      --max;
    80000b88:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80000b8c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b90:	04e58463          	beq	a1,a4,80000bd8 <copyinstr+0xa0>
{
    80000b94:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80000b96:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b9a:	85ca                	mv	a1,s2
    80000b9c:	8556                	mv	a0,s5
    80000b9e:	8efff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0)
    80000ba2:	cd0d                	beqz	a0,80000bdc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ba4:	417906b3          	sub	a3,s2,s7
    80000ba8:	96d2                	add	a3,a3,s4
    if(n > max)
    80000baa:	00d9f363          	bgeu	s3,a3,80000bb0 <copyinstr+0x78>
    80000bae:	86ce                	mv	a3,s3
    while(n > 0){
    80000bb0:	ca85                	beqz	a3,80000be0 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000bb2:	01750633          	add	a2,a0,s7
    80000bb6:	41260633          	sub	a2,a2,s2
    80000bba:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000bbc:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000bbe:	96a6                	add	a3,a3,s1
    80000bc0:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bc2:	00f60733          	add	a4,a2,a5
    80000bc6:	00074703          	lbu	a4,0(a4)
    80000bca:	db51                	beqz	a4,80000b5e <copyinstr+0x26>
        *dst = *p;
    80000bcc:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bd0:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bd2:	fed797e3          	bne	a5,a3,80000bc0 <copyinstr+0x88>
    80000bd6:	b775                	j	80000b82 <copyinstr+0x4a>
    80000bd8:	4781                	li	a5,0
    80000bda:	b769                	j	80000b64 <copyinstr+0x2c>
      return -1;
    80000bdc:	557d                	li	a0,-1
    80000bde:	b779                	j	80000b6c <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000be0:	6b85                	lui	s7,0x1
    80000be2:	9bca                	add	s7,s7,s2
    80000be4:	87a6                	mv	a5,s1
    80000be6:	b77d                	j	80000b94 <copyinstr+0x5c>
  int got_null = 0;
    80000be8:	4781                	li	a5,0
  if(got_null){
    80000bea:	0017c793          	xori	a5,a5,1
    80000bee:	40f0053b          	negw	a0,a5
}
    80000bf2:	8082                	ret

0000000080000bf4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bf4:	715d                	addi	sp,sp,-80
    80000bf6:	e486                	sd	ra,72(sp)
    80000bf8:	e0a2                	sd	s0,64(sp)
    80000bfa:	fc26                	sd	s1,56(sp)
    80000bfc:	f84a                	sd	s2,48(sp)
    80000bfe:	f44e                	sd	s3,40(sp)
    80000c00:	f052                	sd	s4,32(sp)
    80000c02:	ec56                	sd	s5,24(sp)
    80000c04:	e85a                	sd	s6,16(sp)
    80000c06:	e45e                	sd	s7,8(sp)
    80000c08:	e062                	sd	s8,0(sp)
    80000c0a:	0880                	addi	s0,sp,80
    80000c0c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c0e:	0000a497          	auipc	s1,0xa
    80000c12:	bf248493          	addi	s1,s1,-1038 # 8000a800 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c16:	8c26                	mv	s8,s1
    80000c18:	000a57b7          	lui	a5,0xa5
    80000c1c:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000c20:	07b2                	slli	a5,a5,0xc
    80000c22:	fa578793          	addi	a5,a5,-91
    80000c26:	4fa50937          	lui	s2,0x4fa50
    80000c2a:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000c2e:	1902                	slli	s2,s2,0x20
    80000c30:	993e                	add	s2,s2,a5
    80000c32:	040009b7          	lui	s3,0x4000
    80000c36:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c38:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3a:	4b99                	li	s7,6
    80000c3c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c3e:	0000fa97          	auipc	s5,0xf
    80000c42:	5c2a8a93          	addi	s5,s5,1474 # 80010200 <tickslock>
    char *pa = kalloc();
    80000c46:	cbeff0ef          	jal	80000104 <kalloc>
    80000c4a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c4c:	c121                	beqz	a0,80000c8c <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80000c4e:	418485b3          	sub	a1,s1,s8
    80000c52:	858d                	srai	a1,a1,0x3
    80000c54:	032585b3          	mul	a1,a1,s2
    80000c58:	05b6                	slli	a1,a1,0xd
    80000c5a:	6789                	lui	a5,0x2
    80000c5c:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c5e:	875e                	mv	a4,s7
    80000c60:	86da                	mv	a3,s6
    80000c62:	40b985b3          	sub	a1,s3,a1
    80000c66:	8552                	mv	a0,s4
    80000c68:	915ff0ef          	jal	8000057c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c6c:	16848493          	addi	s1,s1,360
    80000c70:	fd549be3          	bne	s1,s5,80000c46 <proc_mapstacks+0x52>
  }
}
    80000c74:	60a6                	ld	ra,72(sp)
    80000c76:	6406                	ld	s0,64(sp)
    80000c78:	74e2                	ld	s1,56(sp)
    80000c7a:	7942                	ld	s2,48(sp)
    80000c7c:	79a2                	ld	s3,40(sp)
    80000c7e:	7a02                	ld	s4,32(sp)
    80000c80:	6ae2                	ld	s5,24(sp)
    80000c82:	6b42                	ld	s6,16(sp)
    80000c84:	6ba2                	ld	s7,8(sp)
    80000c86:	6c02                	ld	s8,0(sp)
    80000c88:	6161                	addi	sp,sp,80
    80000c8a:	8082                	ret
      panic("kalloc");
    80000c8c:	00006517          	auipc	a0,0x6
    80000c90:	50c50513          	addi	a0,a0,1292 # 80007198 <etext+0x198>
    80000c94:	26b040ef          	jal	800056fe <panic>

0000000080000c98 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c98:	7139                	addi	sp,sp,-64
    80000c9a:	fc06                	sd	ra,56(sp)
    80000c9c:	f822                	sd	s0,48(sp)
    80000c9e:	f426                	sd	s1,40(sp)
    80000ca0:	f04a                	sd	s2,32(sp)
    80000ca2:	ec4e                	sd	s3,24(sp)
    80000ca4:	e852                	sd	s4,16(sp)
    80000ca6:	e456                	sd	s5,8(sp)
    80000ca8:	e05a                	sd	s6,0(sp)
    80000caa:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	4f458593          	addi	a1,a1,1268 # 800071a0 <etext+0x1a0>
    80000cb4:	00009517          	auipc	a0,0x9
    80000cb8:	71c50513          	addi	a0,a0,1820 # 8000a3d0 <pid_lock>
    80000cbc:	4f7040ef          	jal	800059b2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	4e858593          	addi	a1,a1,1256 # 800071a8 <etext+0x1a8>
    80000cc8:	00009517          	auipc	a0,0x9
    80000ccc:	72050513          	addi	a0,a0,1824 # 8000a3e8 <wait_lock>
    80000cd0:	4e3040ef          	jal	800059b2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	b2c48493          	addi	s1,s1,-1236 # 8000a800 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00006b17          	auipc	s6,0x6
    80000ce0:	4dcb0b13          	addi	s6,s6,1244 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	000a57b7          	lui	a5,0xa5
    80000cea:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000cee:	07b2                	slli	a5,a5,0xc
    80000cf0:	fa578793          	addi	a5,a5,-91
    80000cf4:	4fa50937          	lui	s2,0x4fa50
    80000cf8:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000cfc:	1902                	slli	s2,s2,0x20
    80000cfe:	993e                	add	s2,s2,a5
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	0000fa17          	auipc	s4,0xf
    80000d0c:	4f8a0a13          	addi	s4,s4,1272 # 80010200 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	49f040ef          	jal	800059b2 <initlock>
      p->state = UNUSED;
    80000d18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	878d                	srai	a5,a5,0x3
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	07b6                	slli	a5,a5,0xd
    80000d28:	6709                	lui	a4,0x2
    80000d2a:	9fb9                	addw	a5,a5,a4
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	e0bc                	sd	a5,64(s1)
      p->frozen = 0;  // Initialize frozen flag
    80000d32:	0204aa23          	sw	zero,52(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	16848493          	addi	s1,s1,360
    80000d3a:	fd449be3          	bne	s1,s4,80000d10 <procinit+0x78>
  }
}
    80000d3e:	70e2                	ld	ra,56(sp)
    80000d40:	7442                	ld	s0,48(sp)
    80000d42:	74a2                	ld	s1,40(sp)
    80000d44:	7902                	ld	s2,32(sp)
    80000d46:	69e2                	ld	s3,24(sp)
    80000d48:	6a42                	ld	s4,16(sp)
    80000d4a:	6aa2                	ld	s5,8(sp)
    80000d4c:	6b02                	ld	s6,0(sp)
    80000d4e:	6121                	addi	sp,sp,64
    80000d50:	8082                	ret

0000000080000d52 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d52:	1141                	addi	sp,sp,-16
    80000d54:	e406                	sd	ra,8(sp)
    80000d56:	e022                	sd	s0,0(sp)
    80000d58:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d5a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d5c:	2501                	sext.w	a0,a0
    80000d5e:	60a2                	ld	ra,8(sp)
    80000d60:	6402                	ld	s0,0(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret

0000000080000d66 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d66:	1141                	addi	sp,sp,-16
    80000d68:	e406                	sd	ra,8(sp)
    80000d6a:	e022                	sd	s0,0(sp)
    80000d6c:	0800                	addi	s0,sp,16
    80000d6e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d70:	2781                	sext.w	a5,a5
    80000d72:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d74:	00009517          	auipc	a0,0x9
    80000d78:	68c50513          	addi	a0,a0,1676 # 8000a400 <cpus>
    80000d7c:	953e                	add	a0,a0,a5
    80000d7e:	60a2                	ld	ra,8(sp)
    80000d80:	6402                	ld	s0,0(sp)
    80000d82:	0141                	addi	sp,sp,16
    80000d84:	8082                	ret

0000000080000d86 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d86:	1101                	addi	sp,sp,-32
    80000d88:	ec06                	sd	ra,24(sp)
    80000d8a:	e822                	sd	s0,16(sp)
    80000d8c:	e426                	sd	s1,8(sp)
    80000d8e:	1000                	addi	s0,sp,32
  push_off();
    80000d90:	469040ef          	jal	800059f8 <push_off>
    80000d94:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d96:	2781                	sext.w	a5,a5
    80000d98:	079e                	slli	a5,a5,0x7
    80000d9a:	00009717          	auipc	a4,0x9
    80000d9e:	63670713          	addi	a4,a4,1590 # 8000a3d0 <pid_lock>
    80000da2:	97ba                	add	a5,a5,a4
    80000da4:	7b9c                	ld	a5,48(a5)
    80000da6:	84be                	mv	s1,a5
  pop_off();
    80000da8:	4d9040ef          	jal	80005a80 <pop_off>
  return p;
}
    80000dac:	8526                	mv	a0,s1
    80000dae:	60e2                	ld	ra,24(sp)
    80000db0:	6442                	ld	s0,16(sp)
    80000db2:	64a2                	ld	s1,8(sp)
    80000db4:	6105                	addi	sp,sp,32
    80000db6:	8082                	ret

0000000080000db8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000dc0:	fc7ff0ef          	jal	80000d86 <myproc>
    80000dc4:	50d040ef          	jal	80005ad0 <release>

  if (first) {
    80000dc8:	00009797          	auipc	a5,0x9
    80000dcc:	5687a783          	lw	a5,1384(a5) # 8000a330 <first.1>
    80000dd0:	e799                	bnez	a5,80000dde <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000dd2:	2cf000ef          	jal	800018a0 <usertrapret>
}
    80000dd6:	60a2                	ld	ra,8(sp)
    80000dd8:	6402                	ld	s0,0(sp)
    80000dda:	0141                	addi	sp,sp,16
    80000ddc:	8082                	ret
    fsinit(ROOTDEV);
    80000dde:	4505                	li	a0,1
    80000de0:	0a5010ef          	jal	80002684 <fsinit>
    first = 0;
    80000de4:	00009797          	auipc	a5,0x9
    80000de8:	5407a623          	sw	zero,1356(a5) # 8000a330 <first.1>
    __sync_synchronize();
    80000dec:	0330000f          	fence	rw,rw
    80000df0:	b7cd                	j	80000dd2 <forkret+0x1a>

0000000080000df2 <allocpid>:
{
    80000df2:	1101                	addi	sp,sp,-32
    80000df4:	ec06                	sd	ra,24(sp)
    80000df6:	e822                	sd	s0,16(sp)
    80000df8:	e426                	sd	s1,8(sp)
    80000dfa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dfc:	00009517          	auipc	a0,0x9
    80000e00:	5d450513          	addi	a0,a0,1492 # 8000a3d0 <pid_lock>
    80000e04:	439040ef          	jal	80005a3c <acquire>
  pid = nextpid;
    80000e08:	00009797          	auipc	a5,0x9
    80000e0c:	52c78793          	addi	a5,a5,1324 # 8000a334 <nextpid>
    80000e10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e12:	0014871b          	addiw	a4,s1,1
    80000e16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e18:	00009517          	auipc	a0,0x9
    80000e1c:	5b850513          	addi	a0,a0,1464 # 8000a3d0 <pid_lock>
    80000e20:	4b1040ef          	jal	80005ad0 <release>
}
    80000e24:	8526                	mv	a0,s1
    80000e26:	60e2                	ld	ra,24(sp)
    80000e28:	6442                	ld	s0,16(sp)
    80000e2a:	64a2                	ld	s1,8(sp)
    80000e2c:	6105                	addi	sp,sp,32
    80000e2e:	8082                	ret

0000000080000e30 <proc_pagetable>:
{
    80000e30:	1101                	addi	sp,sp,-32
    80000e32:	ec06                	sd	ra,24(sp)
    80000e34:	e822                	sd	s0,16(sp)
    80000e36:	e426                	sd	s1,8(sp)
    80000e38:	e04a                	sd	s2,0(sp)
    80000e3a:	1000                	addi	s0,sp,32
    80000e3c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e3e:	8edff0ef          	jal	8000072a <uvmcreate>
    80000e42:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e44:	cd05                	beqz	a0,80000e7c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e46:	4729                	li	a4,10
    80000e48:	00005697          	auipc	a3,0x5
    80000e4c:	1b868693          	addi	a3,a3,440 # 80006000 <_trampoline>
    80000e50:	6605                	lui	a2,0x1
    80000e52:	040005b7          	lui	a1,0x4000
    80000e56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e58:	05b2                	slli	a1,a1,0xc
    80000e5a:	e6cff0ef          	jal	800004c6 <mappages>
    80000e5e:	02054663          	bltz	a0,80000e8a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e62:	4719                	li	a4,6
    80000e64:	05893683          	ld	a3,88(s2)
    80000e68:	6605                	lui	a2,0x1
    80000e6a:	020005b7          	lui	a1,0x2000
    80000e6e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e70:	05b6                	slli	a1,a1,0xd
    80000e72:	8526                	mv	a0,s1
    80000e74:	e52ff0ef          	jal	800004c6 <mappages>
    80000e78:	00054f63          	bltz	a0,80000e96 <proc_pagetable+0x66>
}
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	60e2                	ld	ra,24(sp)
    80000e80:	6442                	ld	s0,16(sp)
    80000e82:	64a2                	ld	s1,8(sp)
    80000e84:	6902                	ld	s2,0(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret
    uvmfree(pagetable, 0);
    80000e8a:	4581                	li	a1,0
    80000e8c:	8526                	mv	a0,s1
    80000e8e:	a6bff0ef          	jal	800008f8 <uvmfree>
    return 0;
    80000e92:	4481                	li	s1,0
    80000e94:	b7e5                	j	80000e7c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e96:	4681                	li	a3,0
    80000e98:	4605                	li	a2,1
    80000e9a:	040005b7          	lui	a1,0x4000
    80000e9e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea0:	05b2                	slli	a1,a1,0xc
    80000ea2:	8526                	mv	a0,s1
    80000ea4:	fcaff0ef          	jal	8000066e <uvmunmap>
    uvmfree(pagetable, 0);
    80000ea8:	4581                	li	a1,0
    80000eaa:	8526                	mv	a0,s1
    80000eac:	a4dff0ef          	jal	800008f8 <uvmfree>
    return 0;
    80000eb0:	4481                	li	s1,0
    80000eb2:	b7e9                	j	80000e7c <proc_pagetable+0x4c>

0000000080000eb4 <proc_freepagetable>:
{
    80000eb4:	1101                	addi	sp,sp,-32
    80000eb6:	ec06                	sd	ra,24(sp)
    80000eb8:	e822                	sd	s0,16(sp)
    80000eba:	e426                	sd	s1,8(sp)
    80000ebc:	e04a                	sd	s2,0(sp)
    80000ebe:	1000                	addi	s0,sp,32
    80000ec0:	84aa                	mv	s1,a0
    80000ec2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ec4:	4681                	li	a3,0
    80000ec6:	4605                	li	a2,1
    80000ec8:	040005b7          	lui	a1,0x4000
    80000ecc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ece:	05b2                	slli	a1,a1,0xc
    80000ed0:	f9eff0ef          	jal	8000066e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ed4:	4681                	li	a3,0
    80000ed6:	4605                	li	a2,1
    80000ed8:	020005b7          	lui	a1,0x2000
    80000edc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ede:	05b6                	slli	a1,a1,0xd
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	f8cff0ef          	jal	8000066e <uvmunmap>
  uvmfree(pagetable, sz);
    80000ee6:	85ca                	mv	a1,s2
    80000ee8:	8526                	mv	a0,s1
    80000eea:	a0fff0ef          	jal	800008f8 <uvmfree>
}
    80000eee:	60e2                	ld	ra,24(sp)
    80000ef0:	6442                	ld	s0,16(sp)
    80000ef2:	64a2                	ld	s1,8(sp)
    80000ef4:	6902                	ld	s2,0(sp)
    80000ef6:	6105                	addi	sp,sp,32
    80000ef8:	8082                	ret

0000000080000efa <freeproc>:
{
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	1000                	addi	s0,sp,32
    80000f04:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f06:	6d28                	ld	a0,88(a0)
    80000f08:	c119                	beqz	a0,80000f0e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f0a:	912ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f0e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f12:	68a8                	ld	a0,80(s1)
    80000f14:	c501                	beqz	a0,80000f1c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f16:	64ac                	ld	a1,72(s1)
    80000f18:	f9dff0ef          	jal	80000eb4 <proc_freepagetable>
  p->pagetable = 0;
    80000f1c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f20:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f24:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f28:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f2c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f30:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f34:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f38:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f3c:	0004ac23          	sw	zero,24(s1)
}
    80000f40:	60e2                	ld	ra,24(sp)
    80000f42:	6442                	ld	s0,16(sp)
    80000f44:	64a2                	ld	s1,8(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret

0000000080000f4a <allocproc>:
{
    80000f4a:	1101                	addi	sp,sp,-32
    80000f4c:	ec06                	sd	ra,24(sp)
    80000f4e:	e822                	sd	s0,16(sp)
    80000f50:	e426                	sd	s1,8(sp)
    80000f52:	e04a                	sd	s2,0(sp)
    80000f54:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f56:	0000a497          	auipc	s1,0xa
    80000f5a:	8aa48493          	addi	s1,s1,-1878 # 8000a800 <proc>
    80000f5e:	0000f917          	auipc	s2,0xf
    80000f62:	2a290913          	addi	s2,s2,674 # 80010200 <tickslock>
    acquire(&p->lock);
    80000f66:	8526                	mv	a0,s1
    80000f68:	2d5040ef          	jal	80005a3c <acquire>
    if(p->state == UNUSED) {
    80000f6c:	4c9c                	lw	a5,24(s1)
    80000f6e:	cb91                	beqz	a5,80000f82 <allocproc+0x38>
      release(&p->lock);
    80000f70:	8526                	mv	a0,s1
    80000f72:	35f040ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f76:	16848493          	addi	s1,s1,360
    80000f7a:	ff2496e3          	bne	s1,s2,80000f66 <allocproc+0x1c>
  return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	a089                	j	80000fc2 <allocproc+0x78>
  p->pid = allocpid();
    80000f82:	e71ff0ef          	jal	80000df2 <allocpid>
    80000f86:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f88:	4785                	li	a5,1
    80000f8a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f8c:	978ff0ef          	jal	80000104 <kalloc>
    80000f90:	892a                	mv	s2,a0
    80000f92:	eca8                	sd	a0,88(s1)
    80000f94:	cd15                	beqz	a0,80000fd0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f96:	8526                	mv	a0,s1
    80000f98:	e99ff0ef          	jal	80000e30 <proc_pagetable>
    80000f9c:	892a                	mv	s2,a0
    80000f9e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fa0:	c121                	beqz	a0,80000fe0 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fa2:	07000613          	li	a2,112
    80000fa6:	4581                	li	a1,0
    80000fa8:	06048513          	addi	a0,s1,96
    80000fac:	9b2ff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    80000fb0:	00000797          	auipc	a5,0x0
    80000fb4:	e0878793          	addi	a5,a5,-504 # 80000db8 <forkret>
    80000fb8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fba:	60bc                	ld	a5,64(s1)
    80000fbc:	6705                	lui	a4,0x1
    80000fbe:	97ba                	add	a5,a5,a4
    80000fc0:	f4bc                	sd	a5,104(s1)
}
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	60e2                	ld	ra,24(sp)
    80000fc6:	6442                	ld	s0,16(sp)
    80000fc8:	64a2                	ld	s1,8(sp)
    80000fca:	6902                	ld	s2,0(sp)
    80000fcc:	6105                	addi	sp,sp,32
    80000fce:	8082                	ret
    freeproc(p);
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	f29ff0ef          	jal	80000efa <freeproc>
    release(&p->lock);
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	2f9040ef          	jal	80005ad0 <release>
    return 0;
    80000fdc:	84ca                	mv	s1,s2
    80000fde:	b7d5                	j	80000fc2 <allocproc+0x78>
    freeproc(p);
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	f19ff0ef          	jal	80000efa <freeproc>
    release(&p->lock);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	2e9040ef          	jal	80005ad0 <release>
    return 0;
    80000fec:	84ca                	mv	s1,s2
    80000fee:	bfd1                	j	80000fc2 <allocproc+0x78>

0000000080000ff0 <userinit>:
{
    80000ff0:	1101                	addi	sp,sp,-32
    80000ff2:	ec06                	sd	ra,24(sp)
    80000ff4:	e822                	sd	s0,16(sp)
    80000ff6:	e426                	sd	s1,8(sp)
    80000ff8:	1000                	addi	s0,sp,32
  p = allocproc();
    80000ffa:	f51ff0ef          	jal	80000f4a <allocproc>
    80000ffe:	84aa                	mv	s1,a0
  initproc = p;
    80001000:	00009797          	auipc	a5,0x9
    80001004:	38a7b823          	sd	a0,912(a5) # 8000a390 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001008:	03400613          	li	a2,52
    8000100c:	00009597          	auipc	a1,0x9
    80001010:	33458593          	addi	a1,a1,820 # 8000a340 <initcode>
    80001014:	6928                	ld	a0,80(a0)
    80001016:	f3aff0ef          	jal	80000750 <uvmfirst>
  p->sz = PGSIZE;
    8000101a:	6785                	lui	a5,0x1
    8000101c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000101e:	6cb8                	ld	a4,88(s1)
    80001020:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001024:	6cb8                	ld	a4,88(s1)
    80001026:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001028:	4641                	li	a2,16
    8000102a:	00006597          	auipc	a1,0x6
    8000102e:	19658593          	addi	a1,a1,406 # 800071c0 <etext+0x1c0>
    80001032:	15848513          	addi	a0,s1,344
    80001036:	a7cff0ef          	jal	800002b2 <safestrcpy>
  p->cwd = namei("/");
    8000103a:	00006517          	auipc	a0,0x6
    8000103e:	19650513          	addi	a0,a0,406 # 800071d0 <etext+0x1d0>
    80001042:	76b010ef          	jal	80002fac <namei>
    80001046:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000104a:	478d                	li	a5,3
    8000104c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000104e:	8526                	mv	a0,s1
    80001050:	281040ef          	jal	80005ad0 <release>
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <growproc>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
    8000106a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000106c:	d1bff0ef          	jal	80000d86 <myproc>
    80001070:	84aa                	mv	s1,a0
  sz = p->sz;
    80001072:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001074:	01204c63          	bgtz	s2,8000108c <growproc+0x2e>
  } else if(n < 0){
    80001078:	02094463          	bltz	s2,800010a0 <growproc+0x42>
  p->sz = sz;
    8000107c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000107e:	4501                	li	a0,0
}
    80001080:	60e2                	ld	ra,24(sp)
    80001082:	6442                	ld	s0,16(sp)
    80001084:	64a2                	ld	s1,8(sp)
    80001086:	6902                	ld	s2,0(sp)
    80001088:	6105                	addi	sp,sp,32
    8000108a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000108c:	4691                	li	a3,4
    8000108e:	00b90633          	add	a2,s2,a1
    80001092:	6928                	ld	a0,80(a0)
    80001094:	f5eff0ef          	jal	800007f2 <uvmalloc>
    80001098:	85aa                	mv	a1,a0
    8000109a:	f16d                	bnez	a0,8000107c <growproc+0x1e>
      return -1;
    8000109c:	557d                	li	a0,-1
    8000109e:	b7cd                	j	80001080 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010a0:	00b90633          	add	a2,s2,a1
    800010a4:	6928                	ld	a0,80(a0)
    800010a6:	f08ff0ef          	jal	800007ae <uvmdealloc>
    800010aa:	85aa                	mv	a1,a0
    800010ac:	bfc1                	j	8000107c <growproc+0x1e>

00000000800010ae <fork>:
{
    800010ae:	7139                	addi	sp,sp,-64
    800010b0:	fc06                	sd	ra,56(sp)
    800010b2:	f822                	sd	s0,48(sp)
    800010b4:	f426                	sd	s1,40(sp)
    800010b6:	e456                	sd	s5,8(sp)
    800010b8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ba:	ccdff0ef          	jal	80000d86 <myproc>
    800010be:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010c0:	e8bff0ef          	jal	80000f4a <allocproc>
    800010c4:	0e050a63          	beqz	a0,800011b8 <fork+0x10a>
    800010c8:	e852                	sd	s4,16(sp)
    800010ca:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010cc:	048ab603          	ld	a2,72(s5)
    800010d0:	692c                	ld	a1,80(a0)
    800010d2:	050ab503          	ld	a0,80(s5)
    800010d6:	855ff0ef          	jal	8000092a <uvmcopy>
    800010da:	04054863          	bltz	a0,8000112a <fork+0x7c>
    800010de:	f04a                	sd	s2,32(sp)
    800010e0:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010e2:	048ab783          	ld	a5,72(s5)
    800010e6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010ea:	058ab683          	ld	a3,88(s5)
    800010ee:	87b6                	mv	a5,a3
    800010f0:	058a3703          	ld	a4,88(s4)
    800010f4:	12068693          	addi	a3,a3,288
    800010f8:	6388                	ld	a0,0(a5)
    800010fa:	678c                	ld	a1,8(a5)
    800010fc:	6b90                	ld	a2,16(a5)
    800010fe:	e308                	sd	a0,0(a4)
    80001100:	e70c                	sd	a1,8(a4)
    80001102:	eb10                	sd	a2,16(a4)
    80001104:	6f90                	ld	a2,24(a5)
    80001106:	ef10                	sd	a2,24(a4)
    80001108:	02078793          	addi	a5,a5,32 # 1020 <_entry-0x7fffefe0>
    8000110c:	02070713          	addi	a4,a4,32
    80001110:	fed794e3          	bne	a5,a3,800010f8 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001114:	058a3783          	ld	a5,88(s4)
    80001118:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000111c:	0d0a8493          	addi	s1,s5,208
    80001120:	0d0a0913          	addi	s2,s4,208
    80001124:	150a8993          	addi	s3,s5,336
    80001128:	a831                	j	80001144 <fork+0x96>
    freeproc(np);
    8000112a:	8552                	mv	a0,s4
    8000112c:	dcfff0ef          	jal	80000efa <freeproc>
    release(&np->lock);
    80001130:	8552                	mv	a0,s4
    80001132:	19f040ef          	jal	80005ad0 <release>
    return -1;
    80001136:	54fd                	li	s1,-1
    80001138:	6a42                	ld	s4,16(sp)
    8000113a:	a885                	j	800011aa <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000113c:	04a1                	addi	s1,s1,8
    8000113e:	0921                	addi	s2,s2,8
    80001140:	01348963          	beq	s1,s3,80001152 <fork+0xa4>
    if(p->ofile[i])
    80001144:	6088                	ld	a0,0(s1)
    80001146:	d97d                	beqz	a0,8000113c <fork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001148:	412020ef          	jal	8000355a <filedup>
    8000114c:	00a93023          	sd	a0,0(s2)
    80001150:	b7f5                	j	8000113c <fork+0x8e>
  np->cwd = idup(p->cwd);
    80001152:	150ab503          	ld	a0,336(s5)
    80001156:	72a010ef          	jal	80002880 <idup>
    8000115a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000115e:	4641                	li	a2,16
    80001160:	158a8593          	addi	a1,s5,344
    80001164:	158a0513          	addi	a0,s4,344
    80001168:	94aff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    8000116c:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001170:	8552                	mv	a0,s4
    80001172:	15f040ef          	jal	80005ad0 <release>
  acquire(&wait_lock);
    80001176:	00009517          	auipc	a0,0x9
    8000117a:	27250513          	addi	a0,a0,626 # 8000a3e8 <wait_lock>
    8000117e:	0bf040ef          	jal	80005a3c <acquire>
  np->parent = p;
    80001182:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001186:	00009517          	auipc	a0,0x9
    8000118a:	26250513          	addi	a0,a0,610 # 8000a3e8 <wait_lock>
    8000118e:	143040ef          	jal	80005ad0 <release>
  acquire(&np->lock);
    80001192:	8552                	mv	a0,s4
    80001194:	0a9040ef          	jal	80005a3c <acquire>
  np->state = RUNNABLE;
    80001198:	478d                	li	a5,3
    8000119a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000119e:	8552                	mv	a0,s4
    800011a0:	131040ef          	jal	80005ad0 <release>
  return pid;
    800011a4:	7902                	ld	s2,32(sp)
    800011a6:	69e2                	ld	s3,24(sp)
    800011a8:	6a42                	ld	s4,16(sp)
}
    800011aa:	8526                	mv	a0,s1
    800011ac:	70e2                	ld	ra,56(sp)
    800011ae:	7442                	ld	s0,48(sp)
    800011b0:	74a2                	ld	s1,40(sp)
    800011b2:	6aa2                	ld	s5,8(sp)
    800011b4:	6121                	addi	sp,sp,64
    800011b6:	8082                	ret
    return -1;
    800011b8:	54fd                	li	s1,-1
    800011ba:	bfc5                	j	800011aa <fork+0xfc>

00000000800011bc <scheduler>:
{
    800011bc:	715d                	addi	sp,sp,-80
    800011be:	e486                	sd	ra,72(sp)
    800011c0:	e0a2                	sd	s0,64(sp)
    800011c2:	fc26                	sd	s1,56(sp)
    800011c4:	f84a                	sd	s2,48(sp)
    800011c6:	f44e                	sd	s3,40(sp)
    800011c8:	f052                	sd	s4,32(sp)
    800011ca:	ec56                	sd	s5,24(sp)
    800011cc:	e85a                	sd	s6,16(sp)
    800011ce:	e45e                	sd	s7,8(sp)
    800011d0:	e062                	sd	s8,0(sp)
    800011d2:	0880                	addi	s0,sp,80
    800011d4:	8792                	mv	a5,tp
  int id = r_tp();
    800011d6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011d8:	00779b93          	slli	s7,a5,0x7
    800011dc:	00009717          	auipc	a4,0x9
    800011e0:	1f470713          	addi	a4,a4,500 # 8000a3d0 <pid_lock>
    800011e4:	975e                	add	a4,a4,s7
    800011e6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011ea:	00009717          	auipc	a4,0x9
    800011ee:	21e70713          	addi	a4,a4,542 # 8000a408 <cpus+0x8>
    800011f2:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE) {
    800011f4:	498d                	li	s3,3
        c->proc = p;
    800011f6:	079e                	slli	a5,a5,0x7
    800011f8:	00009a17          	auipc	s4,0x9
    800011fc:	1d8a0a13          	addi	s4,s4,472 # 8000a3d0 <pid_lock>
    80001200:	9a3e                	add	s4,s4,a5
        found = 1;
    80001202:	4c05                	li	s8,1
    80001204:	a899                	j	8000125a <scheduler+0x9e>
        release(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	0c9040ef          	jal	80005ad0 <release>
        continue;
    8000120c:	a021                	j	80001214 <scheduler+0x58>
      release(&p->lock);
    8000120e:	8526                	mv	a0,s1
    80001210:	0c1040ef          	jal	80005ad0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001214:	16848493          	addi	s1,s1,360
    80001218:	03248763          	beq	s1,s2,80001246 <scheduler+0x8a>
      acquire(&p->lock);
    8000121c:	8526                	mv	a0,s1
    8000121e:	01f040ef          	jal	80005a3c <acquire>
      if(p->frozen) {
    80001222:	58dc                	lw	a5,52(s1)
    80001224:	f3ed                	bnez	a5,80001206 <scheduler+0x4a>
      if(p->state == RUNNABLE) {
    80001226:	4c9c                	lw	a5,24(s1)
    80001228:	ff3793e3          	bne	a5,s3,8000120e <scheduler+0x52>
        p->state = RUNNING;
    8000122c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001230:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001234:	06048593          	addi	a1,s1,96
    80001238:	855e                	mv	a0,s7
    8000123a:	5bc000ef          	jal	800017f6 <swtch>
        c->proc = 0;
    8000123e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001242:	8ae2                	mv	s5,s8
    80001244:	b7e9                	j	8000120e <scheduler+0x52>
    if(found == 0) {
    80001246:	000a9a63          	bnez	s5,8000125a <scheduler+0x9e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000124a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000124e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001252:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001256:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000125a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000125e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001262:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001266:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001268:	00009497          	auipc	s1,0x9
    8000126c:	59848493          	addi	s1,s1,1432 # 8000a800 <proc>
        p->state = RUNNING;
    80001270:	4b11                	li	s6,4
    for(p = proc; p < &proc[NPROC]; p++) {
    80001272:	0000f917          	auipc	s2,0xf
    80001276:	f8e90913          	addi	s2,s2,-114 # 80010200 <tickslock>
    8000127a:	b74d                	j	8000121c <scheduler+0x60>

000000008000127c <sched>:
{
    8000127c:	7179                	addi	sp,sp,-48
    8000127e:	f406                	sd	ra,40(sp)
    80001280:	f022                	sd	s0,32(sp)
    80001282:	ec26                	sd	s1,24(sp)
    80001284:	e84a                	sd	s2,16(sp)
    80001286:	e44e                	sd	s3,8(sp)
    80001288:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000128a:	afdff0ef          	jal	80000d86 <myproc>
    8000128e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001290:	73c040ef          	jal	800059cc <holding>
    80001294:	c935                	beqz	a0,80001308 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001296:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	00009717          	auipc	a4,0x9
    800012a0:	13470713          	addi	a4,a4,308 # 8000a3d0 <pid_lock>
    800012a4:	97ba                	add	a5,a5,a4
    800012a6:	0a87a703          	lw	a4,168(a5)
    800012aa:	4785                	li	a5,1
    800012ac:	06f71463          	bne	a4,a5,80001314 <sched+0x98>
  if(p->state == RUNNING)
    800012b0:	4c98                	lw	a4,24(s1)
    800012b2:	4791                	li	a5,4
    800012b4:	06f70663          	beq	a4,a5,80001320 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012bc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012be:	e7bd                	bnez	a5,8000132c <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012c2:	00009917          	auipc	s2,0x9
    800012c6:	10e90913          	addi	s2,s2,270 # 8000a3d0 <pid_lock>
    800012ca:	2781                	sext.w	a5,a5
    800012cc:	079e                	slli	a5,a5,0x7
    800012ce:	97ca                	add	a5,a5,s2
    800012d0:	0ac7a983          	lw	s3,172(a5)
    800012d4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012d6:	2781                	sext.w	a5,a5
    800012d8:	079e                	slli	a5,a5,0x7
    800012da:	07a1                	addi	a5,a5,8
    800012dc:	00009597          	auipc	a1,0x9
    800012e0:	12458593          	addi	a1,a1,292 # 8000a400 <cpus>
    800012e4:	95be                	add	a1,a1,a5
    800012e6:	06048513          	addi	a0,s1,96
    800012ea:	50c000ef          	jal	800017f6 <swtch>
    800012ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012f0:	2781                	sext.w	a5,a5
    800012f2:	079e                	slli	a5,a5,0x7
    800012f4:	993e                	add	s2,s2,a5
    800012f6:	0b392623          	sw	s3,172(s2)
}
    800012fa:	70a2                	ld	ra,40(sp)
    800012fc:	7402                	ld	s0,32(sp)
    800012fe:	64e2                	ld	s1,24(sp)
    80001300:	6942                	ld	s2,16(sp)
    80001302:	69a2                	ld	s3,8(sp)
    80001304:	6145                	addi	sp,sp,48
    80001306:	8082                	ret
    panic("sched p->lock");
    80001308:	00006517          	auipc	a0,0x6
    8000130c:	ed050513          	addi	a0,a0,-304 # 800071d8 <etext+0x1d8>
    80001310:	3ee040ef          	jal	800056fe <panic>
    panic("sched locks");
    80001314:	00006517          	auipc	a0,0x6
    80001318:	ed450513          	addi	a0,a0,-300 # 800071e8 <etext+0x1e8>
    8000131c:	3e2040ef          	jal	800056fe <panic>
    panic("sched running");
    80001320:	00006517          	auipc	a0,0x6
    80001324:	ed850513          	addi	a0,a0,-296 # 800071f8 <etext+0x1f8>
    80001328:	3d6040ef          	jal	800056fe <panic>
    panic("sched interruptible");
    8000132c:	00006517          	auipc	a0,0x6
    80001330:	edc50513          	addi	a0,a0,-292 # 80007208 <etext+0x208>
    80001334:	3ca040ef          	jal	800056fe <panic>

0000000080001338 <yield>:
{
    80001338:	1101                	addi	sp,sp,-32
    8000133a:	ec06                	sd	ra,24(sp)
    8000133c:	e822                	sd	s0,16(sp)
    8000133e:	e426                	sd	s1,8(sp)
    80001340:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001342:	a45ff0ef          	jal	80000d86 <myproc>
    80001346:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001348:	6f4040ef          	jal	80005a3c <acquire>
  p->state = RUNNABLE;
    8000134c:	478d                	li	a5,3
    8000134e:	cc9c                	sw	a5,24(s1)
  sched();
    80001350:	f2dff0ef          	jal	8000127c <sched>
  release(&p->lock);
    80001354:	8526                	mv	a0,s1
    80001356:	77a040ef          	jal	80005ad0 <release>
}
    8000135a:	60e2                	ld	ra,24(sp)
    8000135c:	6442                	ld	s0,16(sp)
    8000135e:	64a2                	ld	s1,8(sp)
    80001360:	6105                	addi	sp,sp,32
    80001362:	8082                	ret

0000000080001364 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001364:	7179                	addi	sp,sp,-48
    80001366:	f406                	sd	ra,40(sp)
    80001368:	f022                	sd	s0,32(sp)
    8000136a:	ec26                	sd	s1,24(sp)
    8000136c:	e84a                	sd	s2,16(sp)
    8000136e:	e44e                	sd	s3,8(sp)
    80001370:	1800                	addi	s0,sp,48
    80001372:	89aa                	mv	s3,a0
    80001374:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001376:	a11ff0ef          	jal	80000d86 <myproc>
    8000137a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000137c:	6c0040ef          	jal	80005a3c <acquire>
  release(lk);
    80001380:	854a                	mv	a0,s2
    80001382:	74e040ef          	jal	80005ad0 <release>

  // Go to sleep.
  p->chan = chan;
    80001386:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000138a:	4789                	li	a5,2
    8000138c:	cc9c                	sw	a5,24(s1)

  sched();
    8000138e:	eefff0ef          	jal	8000127c <sched>

  // Tidy up.
  p->chan = 0;
    80001392:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001396:	8526                	mv	a0,s1
    80001398:	738040ef          	jal	80005ad0 <release>
  acquire(lk);
    8000139c:	854a                	mv	a0,s2
    8000139e:	69e040ef          	jal	80005a3c <acquire>
}
    800013a2:	70a2                	ld	ra,40(sp)
    800013a4:	7402                	ld	s0,32(sp)
    800013a6:	64e2                	ld	s1,24(sp)
    800013a8:	6942                	ld	s2,16(sp)
    800013aa:	69a2                	ld	s3,8(sp)
    800013ac:	6145                	addi	sp,sp,48
    800013ae:	8082                	ret

00000000800013b0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013b0:	7139                	addi	sp,sp,-64
    800013b2:	fc06                	sd	ra,56(sp)
    800013b4:	f822                	sd	s0,48(sp)
    800013b6:	f426                	sd	s1,40(sp)
    800013b8:	f04a                	sd	s2,32(sp)
    800013ba:	ec4e                	sd	s3,24(sp)
    800013bc:	e852                	sd	s4,16(sp)
    800013be:	e456                	sd	s5,8(sp)
    800013c0:	0080                	addi	s0,sp,64
    800013c2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013c4:	00009497          	auipc	s1,0x9
    800013c8:	43c48493          	addi	s1,s1,1084 # 8000a800 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013cc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013ce:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d0:	0000f917          	auipc	s2,0xf
    800013d4:	e3090913          	addi	s2,s2,-464 # 80010200 <tickslock>
    800013d8:	a801                	j	800013e8 <wakeup+0x38>
      }
      release(&p->lock);
    800013da:	8526                	mv	a0,s1
    800013dc:	6f4040ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e0:	16848493          	addi	s1,s1,360
    800013e4:	03248263          	beq	s1,s2,80001408 <wakeup+0x58>
    if(p != myproc()){
    800013e8:	99fff0ef          	jal	80000d86 <myproc>
    800013ec:	fe950ae3          	beq	a0,s1,800013e0 <wakeup+0x30>
      acquire(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	64a040ef          	jal	80005a3c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013f6:	4c9c                	lw	a5,24(s1)
    800013f8:	ff3791e3          	bne	a5,s3,800013da <wakeup+0x2a>
    800013fc:	709c                	ld	a5,32(s1)
    800013fe:	fd479ee3          	bne	a5,s4,800013da <wakeup+0x2a>
        p->state = RUNNABLE;
    80001402:	0154ac23          	sw	s5,24(s1)
    80001406:	bfd1                	j	800013da <wakeup+0x2a>
    }
  }
}
    80001408:	70e2                	ld	ra,56(sp)
    8000140a:	7442                	ld	s0,48(sp)
    8000140c:	74a2                	ld	s1,40(sp)
    8000140e:	7902                	ld	s2,32(sp)
    80001410:	69e2                	ld	s3,24(sp)
    80001412:	6a42                	ld	s4,16(sp)
    80001414:	6aa2                	ld	s5,8(sp)
    80001416:	6121                	addi	sp,sp,64
    80001418:	8082                	ret

000000008000141a <reparent>:
{
    8000141a:	7179                	addi	sp,sp,-48
    8000141c:	f406                	sd	ra,40(sp)
    8000141e:	f022                	sd	s0,32(sp)
    80001420:	ec26                	sd	s1,24(sp)
    80001422:	e84a                	sd	s2,16(sp)
    80001424:	e44e                	sd	s3,8(sp)
    80001426:	e052                	sd	s4,0(sp)
    80001428:	1800                	addi	s0,sp,48
    8000142a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000142c:	00009497          	auipc	s1,0x9
    80001430:	3d448493          	addi	s1,s1,980 # 8000a800 <proc>
      pp->parent = initproc;
    80001434:	00009a17          	auipc	s4,0x9
    80001438:	f5ca0a13          	addi	s4,s4,-164 # 8000a390 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143c:	0000f997          	auipc	s3,0xf
    80001440:	dc498993          	addi	s3,s3,-572 # 80010200 <tickslock>
    80001444:	a029                	j	8000144e <reparent+0x34>
    80001446:	16848493          	addi	s1,s1,360
    8000144a:	01348b63          	beq	s1,s3,80001460 <reparent+0x46>
    if(pp->parent == p){
    8000144e:	7c9c                	ld	a5,56(s1)
    80001450:	ff279be3          	bne	a5,s2,80001446 <reparent+0x2c>
      pp->parent = initproc;
    80001454:	000a3503          	ld	a0,0(s4)
    80001458:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000145a:	f57ff0ef          	jal	800013b0 <wakeup>
    8000145e:	b7e5                	j	80001446 <reparent+0x2c>
}
    80001460:	70a2                	ld	ra,40(sp)
    80001462:	7402                	ld	s0,32(sp)
    80001464:	64e2                	ld	s1,24(sp)
    80001466:	6942                	ld	s2,16(sp)
    80001468:	69a2                	ld	s3,8(sp)
    8000146a:	6a02                	ld	s4,0(sp)
    8000146c:	6145                	addi	sp,sp,48
    8000146e:	8082                	ret

0000000080001470 <exit>:
{
    80001470:	7179                	addi	sp,sp,-48
    80001472:	f406                	sd	ra,40(sp)
    80001474:	f022                	sd	s0,32(sp)
    80001476:	ec26                	sd	s1,24(sp)
    80001478:	e84a                	sd	s2,16(sp)
    8000147a:	e44e                	sd	s3,8(sp)
    8000147c:	e052                	sd	s4,0(sp)
    8000147e:	1800                	addi	s0,sp,48
    80001480:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001482:	905ff0ef          	jal	80000d86 <myproc>
    80001486:	89aa                	mv	s3,a0
  if(p == initproc)
    80001488:	00009797          	auipc	a5,0x9
    8000148c:	f087b783          	ld	a5,-248(a5) # 8000a390 <initproc>
    80001490:	0d050493          	addi	s1,a0,208
    80001494:	15050913          	addi	s2,a0,336
    80001498:	00a79b63          	bne	a5,a0,800014ae <exit+0x3e>
    panic("init exiting");
    8000149c:	00006517          	auipc	a0,0x6
    800014a0:	d8450513          	addi	a0,a0,-636 # 80007220 <etext+0x220>
    800014a4:	25a040ef          	jal	800056fe <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014a8:	04a1                	addi	s1,s1,8
    800014aa:	01248963          	beq	s1,s2,800014bc <exit+0x4c>
    if(p->ofile[fd]){
    800014ae:	6088                	ld	a0,0(s1)
    800014b0:	dd65                	beqz	a0,800014a8 <exit+0x38>
      fileclose(f);
    800014b2:	0ee020ef          	jal	800035a0 <fileclose>
      p->ofile[fd] = 0;
    800014b6:	0004b023          	sd	zero,0(s1)
    800014ba:	b7fd                	j	800014a8 <exit+0x38>
  begin_op();
    800014bc:	4b3010ef          	jal	8000316e <begin_op>
  iput(p->cwd);
    800014c0:	1509b503          	ld	a0,336(s3)
    800014c4:	574010ef          	jal	80002a38 <iput>
  end_op();
    800014c8:	517010ef          	jal	800031de <end_op>
  p->cwd = 0;
    800014cc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014d0:	00009517          	auipc	a0,0x9
    800014d4:	f1850513          	addi	a0,a0,-232 # 8000a3e8 <wait_lock>
    800014d8:	564040ef          	jal	80005a3c <acquire>
  reparent(p);
    800014dc:	854e                	mv	a0,s3
    800014de:	f3dff0ef          	jal	8000141a <reparent>
  wakeup(p->parent);
    800014e2:	0389b503          	ld	a0,56(s3)
    800014e6:	ecbff0ef          	jal	800013b0 <wakeup>
  acquire(&p->lock);
    800014ea:	854e                	mv	a0,s3
    800014ec:	550040ef          	jal	80005a3c <acquire>
  p->xstate = status;
    800014f0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014f4:	4795                	li	a5,5
    800014f6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014fa:	00009517          	auipc	a0,0x9
    800014fe:	eee50513          	addi	a0,a0,-274 # 8000a3e8 <wait_lock>
    80001502:	5ce040ef          	jal	80005ad0 <release>
  sched();
    80001506:	d77ff0ef          	jal	8000127c <sched>
  panic("zombie exit");
    8000150a:	00006517          	auipc	a0,0x6
    8000150e:	d2650513          	addi	a0,a0,-730 # 80007230 <etext+0x230>
    80001512:	1ec040ef          	jal	800056fe <panic>

0000000080001516 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001516:	7179                	addi	sp,sp,-48
    80001518:	f406                	sd	ra,40(sp)
    8000151a:	f022                	sd	s0,32(sp)
    8000151c:	ec26                	sd	s1,24(sp)
    8000151e:	e84a                	sd	s2,16(sp)
    80001520:	e44e                	sd	s3,8(sp)
    80001522:	1800                	addi	s0,sp,48
    80001524:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001526:	00009497          	auipc	s1,0x9
    8000152a:	2da48493          	addi	s1,s1,730 # 8000a800 <proc>
    8000152e:	0000f997          	auipc	s3,0xf
    80001532:	cd298993          	addi	s3,s3,-814 # 80010200 <tickslock>
    acquire(&p->lock);
    80001536:	8526                	mv	a0,s1
    80001538:	504040ef          	jal	80005a3c <acquire>
    if(p->pid == pid){
    8000153c:	589c                	lw	a5,48(s1)
    8000153e:	01278b63          	beq	a5,s2,80001554 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	58c040ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001548:	16848493          	addi	s1,s1,360
    8000154c:	ff3495e3          	bne	s1,s3,80001536 <kill+0x20>
  }
  return -1;
    80001550:	557d                	li	a0,-1
    80001552:	a819                	j	80001568 <kill+0x52>
      p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001558:	4c98                	lw	a4,24(s1)
    8000155a:	4789                	li	a5,2
    8000155c:	00f70d63          	beq	a4,a5,80001576 <kill+0x60>
      release(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	56e040ef          	jal	80005ad0 <release>
      return 0;
    80001566:	4501                	li	a0,0
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret
        p->state = RUNNABLE;
    80001576:	478d                	li	a5,3
    80001578:	cc9c                	sw	a5,24(s1)
    8000157a:	b7dd                	j	80001560 <kill+0x4a>

000000008000157c <setkilled>:

void
setkilled(struct proc *p)
{
    8000157c:	1101                	addi	sp,sp,-32
    8000157e:	ec06                	sd	ra,24(sp)
    80001580:	e822                	sd	s0,16(sp)
    80001582:	e426                	sd	s1,8(sp)
    80001584:	1000                	addi	s0,sp,32
    80001586:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001588:	4b4040ef          	jal	80005a3c <acquire>
  p->killed = 1;
    8000158c:	4785                	li	a5,1
    8000158e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001590:	8526                	mv	a0,s1
    80001592:	53e040ef          	jal	80005ad0 <release>
}
    80001596:	60e2                	ld	ra,24(sp)
    80001598:	6442                	ld	s0,16(sp)
    8000159a:	64a2                	ld	s1,8(sp)
    8000159c:	6105                	addi	sp,sp,32
    8000159e:	8082                	ret

00000000800015a0 <killed>:

int
killed(struct proc *p)
{
    800015a0:	1101                	addi	sp,sp,-32
    800015a2:	ec06                	sd	ra,24(sp)
    800015a4:	e822                	sd	s0,16(sp)
    800015a6:	e426                	sd	s1,8(sp)
    800015a8:	e04a                	sd	s2,0(sp)
    800015aa:	1000                	addi	s0,sp,32
    800015ac:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015ae:	48e040ef          	jal	80005a3c <acquire>
  k = p->killed;
    800015b2:	549c                	lw	a5,40(s1)
    800015b4:	893e                	mv	s2,a5
  release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	518040ef          	jal	80005ad0 <release>
  return k;
}
    800015bc:	854a                	mv	a0,s2
    800015be:	60e2                	ld	ra,24(sp)
    800015c0:	6442                	ld	s0,16(sp)
    800015c2:	64a2                	ld	s1,8(sp)
    800015c4:	6902                	ld	s2,0(sp)
    800015c6:	6105                	addi	sp,sp,32
    800015c8:	8082                	ret

00000000800015ca <wait>:
{
    800015ca:	715d                	addi	sp,sp,-80
    800015cc:	e486                	sd	ra,72(sp)
    800015ce:	e0a2                	sd	s0,64(sp)
    800015d0:	fc26                	sd	s1,56(sp)
    800015d2:	f84a                	sd	s2,48(sp)
    800015d4:	f44e                	sd	s3,40(sp)
    800015d6:	f052                	sd	s4,32(sp)
    800015d8:	ec56                	sd	s5,24(sp)
    800015da:	e85a                	sd	s6,16(sp)
    800015dc:	e45e                	sd	s7,8(sp)
    800015de:	0880                	addi	s0,sp,80
    800015e0:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800015e2:	fa4ff0ef          	jal	80000d86 <myproc>
    800015e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e8:	00009517          	auipc	a0,0x9
    800015ec:	e0050513          	addi	a0,a0,-512 # 8000a3e8 <wait_lock>
    800015f0:	44c040ef          	jal	80005a3c <acquire>
        if(pp->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
        havekids = 1;
    800015f6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f8:	0000f997          	auipc	s3,0xf
    800015fc:	c0898993          	addi	s3,s3,-1016 # 80010200 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	00009b17          	auipc	s6,0x9
    80001604:	de8b0b13          	addi	s6,s6,-536 # 8000a3e8 <wait_lock>
    80001608:	a869                	j	800016a2 <wait+0xd8>
          pid = pp->pid;
    8000160a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000160e:	000b8c63          	beqz	s7,80001626 <wait+0x5c>
    80001612:	4691                	li	a3,4
    80001614:	02c48613          	addi	a2,s1,44
    80001618:	85de                	mv	a1,s7
    8000161a:	05093503          	ld	a0,80(s2)
    8000161e:	be4ff0ef          	jal	80000a02 <copyout>
    80001622:	02054a63          	bltz	a0,80001656 <wait+0x8c>
          freeproc(pp);
    80001626:	8526                	mv	a0,s1
    80001628:	8d3ff0ef          	jal	80000efa <freeproc>
          release(&pp->lock);
    8000162c:	8526                	mv	a0,s1
    8000162e:	4a2040ef          	jal	80005ad0 <release>
          release(&wait_lock);
    80001632:	00009517          	auipc	a0,0x9
    80001636:	db650513          	addi	a0,a0,-586 # 8000a3e8 <wait_lock>
    8000163a:	496040ef          	jal	80005ad0 <release>
}
    8000163e:	854e                	mv	a0,s3
    80001640:	60a6                	ld	ra,72(sp)
    80001642:	6406                	ld	s0,64(sp)
    80001644:	74e2                	ld	s1,56(sp)
    80001646:	7942                	ld	s2,48(sp)
    80001648:	79a2                	ld	s3,40(sp)
    8000164a:	7a02                	ld	s4,32(sp)
    8000164c:	6ae2                	ld	s5,24(sp)
    8000164e:	6b42                	ld	s6,16(sp)
    80001650:	6ba2                	ld	s7,8(sp)
    80001652:	6161                	addi	sp,sp,80
    80001654:	8082                	ret
            release(&pp->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	478040ef          	jal	80005ad0 <release>
            release(&wait_lock);
    8000165c:	00009517          	auipc	a0,0x9
    80001660:	d8c50513          	addi	a0,a0,-628 # 8000a3e8 <wait_lock>
    80001664:	46c040ef          	jal	80005ad0 <release>
            return -1;
    80001668:	59fd                	li	s3,-1
    8000166a:	bfd1                	j	8000163e <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000166c:	16848493          	addi	s1,s1,360
    80001670:	03348063          	beq	s1,s3,80001690 <wait+0xc6>
      if(pp->parent == p){
    80001674:	7c9c                	ld	a5,56(s1)
    80001676:	ff279be3          	bne	a5,s2,8000166c <wait+0xa2>
        acquire(&pp->lock);
    8000167a:	8526                	mv	a0,s1
    8000167c:	3c0040ef          	jal	80005a3c <acquire>
        if(pp->state == ZOMBIE){
    80001680:	4c9c                	lw	a5,24(s1)
    80001682:	f94784e3          	beq	a5,s4,8000160a <wait+0x40>
        release(&pp->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	448040ef          	jal	80005ad0 <release>
        havekids = 1;
    8000168c:	8756                	mv	a4,s5
    8000168e:	bff9                	j	8000166c <wait+0xa2>
    if(!havekids || killed(p)){
    80001690:	cf19                	beqz	a4,800016ae <wait+0xe4>
    80001692:	854a                	mv	a0,s2
    80001694:	f0dff0ef          	jal	800015a0 <killed>
    80001698:	e919                	bnez	a0,800016ae <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000169a:	85da                	mv	a1,s6
    8000169c:	854a                	mv	a0,s2
    8000169e:	cc7ff0ef          	jal	80001364 <sleep>
    havekids = 0;
    800016a2:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a4:	00009497          	auipc	s1,0x9
    800016a8:	15c48493          	addi	s1,s1,348 # 8000a800 <proc>
    800016ac:	b7e1                	j	80001674 <wait+0xaa>
      release(&wait_lock);
    800016ae:	00009517          	auipc	a0,0x9
    800016b2:	d3a50513          	addi	a0,a0,-710 # 8000a3e8 <wait_lock>
    800016b6:	41a040ef          	jal	80005ad0 <release>
      return -1;
    800016ba:	59fd                	li	s3,-1
    800016bc:	b749                	j	8000163e <wait+0x74>

00000000800016be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016be:	7179                	addi	sp,sp,-48
    800016c0:	f406                	sd	ra,40(sp)
    800016c2:	f022                	sd	s0,32(sp)
    800016c4:	ec26                	sd	s1,24(sp)
    800016c6:	e84a                	sd	s2,16(sp)
    800016c8:	e44e                	sd	s3,8(sp)
    800016ca:	e052                	sd	s4,0(sp)
    800016cc:	1800                	addi	s0,sp,48
    800016ce:	84aa                	mv	s1,a0
    800016d0:	8a2e                	mv	s4,a1
    800016d2:	89b2                	mv	s3,a2
    800016d4:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800016d6:	eb0ff0ef          	jal	80000d86 <myproc>
  if(user_dst){
    800016da:	cc99                	beqz	s1,800016f8 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016dc:	86ca                	mv	a3,s2
    800016de:	864e                	mv	a2,s3
    800016e0:	85d2                	mv	a1,s4
    800016e2:	6928                	ld	a0,80(a0)
    800016e4:	b1eff0ef          	jal	80000a02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016e8:	70a2                	ld	ra,40(sp)
    800016ea:	7402                	ld	s0,32(sp)
    800016ec:	64e2                	ld	s1,24(sp)
    800016ee:	6942                	ld	s2,16(sp)
    800016f0:	69a2                	ld	s3,8(sp)
    800016f2:	6a02                	ld	s4,0(sp)
    800016f4:	6145                	addi	sp,sp,48
    800016f6:	8082                	ret
    memmove((char *)dst, src, len);
    800016f8:	0009061b          	sext.w	a2,s2
    800016fc:	85ce                	mv	a1,s3
    800016fe:	8552                	mv	a0,s4
    80001700:	abffe0ef          	jal	800001be <memmove>
    return 0;
    80001704:	8526                	mv	a0,s1
    80001706:	b7cd                	j	800016e8 <either_copyout+0x2a>

0000000080001708 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001708:	7179                	addi	sp,sp,-48
    8000170a:	f406                	sd	ra,40(sp)
    8000170c:	f022                	sd	s0,32(sp)
    8000170e:	ec26                	sd	s1,24(sp)
    80001710:	e84a                	sd	s2,16(sp)
    80001712:	e44e                	sd	s3,8(sp)
    80001714:	e052                	sd	s4,0(sp)
    80001716:	1800                	addi	s0,sp,48
    80001718:	8a2a                	mv	s4,a0
    8000171a:	84ae                	mv	s1,a1
    8000171c:	89b2                	mv	s3,a2
    8000171e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001720:	e66ff0ef          	jal	80000d86 <myproc>
  if(user_src){
    80001724:	cc99                	beqz	s1,80001742 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001726:	86ca                	mv	a3,s2
    80001728:	864e                	mv	a2,s3
    8000172a:	85d2                	mv	a1,s4
    8000172c:	6928                	ld	a0,80(a0)
    8000172e:	b84ff0ef          	jal	80000ab2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001732:	70a2                	ld	ra,40(sp)
    80001734:	7402                	ld	s0,32(sp)
    80001736:	64e2                	ld	s1,24(sp)
    80001738:	6942                	ld	s2,16(sp)
    8000173a:	69a2                	ld	s3,8(sp)
    8000173c:	6a02                	ld	s4,0(sp)
    8000173e:	6145                	addi	sp,sp,48
    80001740:	8082                	ret
    memmove(dst, (char*)src, len);
    80001742:	0009061b          	sext.w	a2,s2
    80001746:	85ce                	mv	a1,s3
    80001748:	8552                	mv	a0,s4
    8000174a:	a75fe0ef          	jal	800001be <memmove>
    return 0;
    8000174e:	8526                	mv	a0,s1
    80001750:	b7cd                	j	80001732 <either_copyin+0x2a>

0000000080001752 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001752:	715d                	addi	sp,sp,-80
    80001754:	e486                	sd	ra,72(sp)
    80001756:	e0a2                	sd	s0,64(sp)
    80001758:	fc26                	sd	s1,56(sp)
    8000175a:	f84a                	sd	s2,48(sp)
    8000175c:	f44e                	sd	s3,40(sp)
    8000175e:	f052                	sd	s4,32(sp)
    80001760:	ec56                	sd	s5,24(sp)
    80001762:	e85a                	sd	s6,16(sp)
    80001764:	e45e                	sd	s7,8(sp)
    80001766:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001768:	00006517          	auipc	a0,0x6
    8000176c:	8b050513          	addi	a0,a0,-1872 # 80007018 <etext+0x18>
    80001770:	47f030ef          	jal	800053ee <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001774:	00009497          	auipc	s1,0x9
    80001778:	1e448493          	addi	s1,s1,484 # 8000a958 <proc+0x158>
    8000177c:	0000f917          	auipc	s2,0xf
    80001780:	bdc90913          	addi	s2,s2,-1060 # 80010358 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001784:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001786:	00006997          	auipc	s3,0x6
    8000178a:	aba98993          	addi	s3,s3,-1350 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    8000178e:	00006a97          	auipc	s5,0x6
    80001792:	abaa8a93          	addi	s5,s5,-1350 # 80007248 <etext+0x248>
    printf("\n");
    80001796:	00006a17          	auipc	s4,0x6
    8000179a:	882a0a13          	addi	s4,s4,-1918 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000179e:	00006b97          	auipc	s7,0x6
    800017a2:	012b8b93          	addi	s7,s7,18 # 800077b0 <states.0>
    800017a6:	a829                	j	800017c0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017a8:	ed86a583          	lw	a1,-296(a3)
    800017ac:	8556                	mv	a0,s5
    800017ae:	441030ef          	jal	800053ee <printf>
    printf("\n");
    800017b2:	8552                	mv	a0,s4
    800017b4:	43b030ef          	jal	800053ee <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b8:	16848493          	addi	s1,s1,360
    800017bc:	03248263          	beq	s1,s2,800017e0 <procdump+0x8e>
    if(p->state == UNUSED)
    800017c0:	86a6                	mv	a3,s1
    800017c2:	ec04a783          	lw	a5,-320(s1)
    800017c6:	dbed                	beqz	a5,800017b8 <procdump+0x66>
      state = "???";
    800017c8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ca:	fcfb6fe3          	bltu	s6,a5,800017a8 <procdump+0x56>
    800017ce:	02079713          	slli	a4,a5,0x20
    800017d2:	01d75793          	srli	a5,a4,0x1d
    800017d6:	97de                	add	a5,a5,s7
    800017d8:	6390                	ld	a2,0(a5)
    800017da:	f679                	bnez	a2,800017a8 <procdump+0x56>
      state = "???";
    800017dc:	864e                	mv	a2,s3
    800017de:	b7e9                	j	800017a8 <procdump+0x56>
  }
}
    800017e0:	60a6                	ld	ra,72(sp)
    800017e2:	6406                	ld	s0,64(sp)
    800017e4:	74e2                	ld	s1,56(sp)
    800017e6:	7942                	ld	s2,48(sp)
    800017e8:	79a2                	ld	s3,40(sp)
    800017ea:	7a02                	ld	s4,32(sp)
    800017ec:	6ae2                	ld	s5,24(sp)
    800017ee:	6b42                	ld	s6,16(sp)
    800017f0:	6ba2                	ld	s7,8(sp)
    800017f2:	6161                	addi	sp,sp,80
    800017f4:	8082                	ret

00000000800017f6 <swtch>:
    800017f6:	00153023          	sd	ra,0(a0)
    800017fa:	00253423          	sd	sp,8(a0)
    800017fe:	e900                	sd	s0,16(a0)
    80001800:	ed04                	sd	s1,24(a0)
    80001802:	03253023          	sd	s2,32(a0)
    80001806:	03353423          	sd	s3,40(a0)
    8000180a:	03453823          	sd	s4,48(a0)
    8000180e:	03553c23          	sd	s5,56(a0)
    80001812:	05653023          	sd	s6,64(a0)
    80001816:	05753423          	sd	s7,72(a0)
    8000181a:	05853823          	sd	s8,80(a0)
    8000181e:	05953c23          	sd	s9,88(a0)
    80001822:	07a53023          	sd	s10,96(a0)
    80001826:	07b53423          	sd	s11,104(a0)
    8000182a:	0005b083          	ld	ra,0(a1)
    8000182e:	0085b103          	ld	sp,8(a1)
    80001832:	6980                	ld	s0,16(a1)
    80001834:	6d84                	ld	s1,24(a1)
    80001836:	0205b903          	ld	s2,32(a1)
    8000183a:	0285b983          	ld	s3,40(a1)
    8000183e:	0305ba03          	ld	s4,48(a1)
    80001842:	0385ba83          	ld	s5,56(a1)
    80001846:	0405bb03          	ld	s6,64(a1)
    8000184a:	0485bb83          	ld	s7,72(a1)
    8000184e:	0505bc03          	ld	s8,80(a1)
    80001852:	0585bc83          	ld	s9,88(a1)
    80001856:	0605bd03          	ld	s10,96(a1)
    8000185a:	0685bd83          	ld	s11,104(a1)
    8000185e:	8082                	ret

0000000080001860 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001860:	1141                	addi	sp,sp,-16
    80001862:	e406                	sd	ra,8(sp)
    80001864:	e022                	sd	s0,0(sp)
    80001866:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001868:	00006597          	auipc	a1,0x6
    8000186c:	a2058593          	addi	a1,a1,-1504 # 80007288 <etext+0x288>
    80001870:	0000f517          	auipc	a0,0xf
    80001874:	99050513          	addi	a0,a0,-1648 # 80010200 <tickslock>
    80001878:	13a040ef          	jal	800059b2 <initlock>
}
    8000187c:	60a2                	ld	ra,8(sp)
    8000187e:	6402                	ld	s0,0(sp)
    80001880:	0141                	addi	sp,sp,16
    80001882:	8082                	ret

0000000080001884 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001884:	1141                	addi	sp,sp,-16
    80001886:	e406                	sd	ra,8(sp)
    80001888:	e022                	sd	s0,0(sp)
    8000188a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000188c:	00003797          	auipc	a5,0x3
    80001890:	0c478793          	addi	a5,a5,196 # 80004950 <kernelvec>
    80001894:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001898:	60a2                	ld	ra,8(sp)
    8000189a:	6402                	ld	s0,0(sp)
    8000189c:	0141                	addi	sp,sp,16
    8000189e:	8082                	ret

00000000800018a0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018a0:	1141                	addi	sp,sp,-16
    800018a2:	e406                	sd	ra,8(sp)
    800018a4:	e022                	sd	s0,0(sp)
    800018a6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018a8:	cdeff0ef          	jal	80000d86 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018b0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018b2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018b6:	00004697          	auipc	a3,0x4
    800018ba:	74a68693          	addi	a3,a3,1866 # 80006000 <_trampoline>
    800018be:	00004717          	auipc	a4,0x4
    800018c2:	74270713          	addi	a4,a4,1858 # 80006000 <_trampoline>
    800018c6:	8f15                	sub	a4,a4,a3
    800018c8:	040007b7          	lui	a5,0x4000
    800018cc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800018ce:	07b2                	slli	a5,a5,0xc
    800018d0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018d2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018d6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018d8:	18002673          	csrr	a2,satp
    800018dc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018de:	6d30                	ld	a2,88(a0)
    800018e0:	6138                	ld	a4,64(a0)
    800018e2:	6585                	lui	a1,0x1
    800018e4:	972e                	add	a4,a4,a1
    800018e6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018e8:	6d38                	ld	a4,88(a0)
    800018ea:	00000617          	auipc	a2,0x0
    800018ee:	11460613          	addi	a2,a2,276 # 800019fe <usertrap>
    800018f2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018f4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018f6:	8612                	mv	a2,tp
    800018f8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018fa:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018fe:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001902:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001906:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000190a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000190c:	6f18                	ld	a4,24(a4)
    8000190e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001912:	6928                	ld	a0,80(a0)
    80001914:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001916:	00004717          	auipc	a4,0x4
    8000191a:	78670713          	addi	a4,a4,1926 # 8000609c <userret>
    8000191e:	8f15                	sub	a4,a4,a3
    80001920:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001922:	577d                	li	a4,-1
    80001924:	177e                	slli	a4,a4,0x3f
    80001926:	8d59                	or	a0,a0,a4
    80001928:	9782                	jalr	a5
}
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret

0000000080001932 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001932:	1141                	addi	sp,sp,-16
    80001934:	e406                	sd	ra,8(sp)
    80001936:	e022                	sd	s0,0(sp)
    80001938:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000193a:	c18ff0ef          	jal	80000d52 <cpuid>
    8000193e:	cd11                	beqz	a0,8000195a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001940:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001944:	000f4737          	lui	a4,0xf4
    80001948:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000194c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000194e:	14d79073          	csrw	stimecmp,a5
}
    80001952:	60a2                	ld	ra,8(sp)
    80001954:	6402                	ld	s0,0(sp)
    80001956:	0141                	addi	sp,sp,16
    80001958:	8082                	ret
    acquire(&tickslock);
    8000195a:	0000f517          	auipc	a0,0xf
    8000195e:	8a650513          	addi	a0,a0,-1882 # 80010200 <tickslock>
    80001962:	0da040ef          	jal	80005a3c <acquire>
    ticks++;
    80001966:	00009717          	auipc	a4,0x9
    8000196a:	a3270713          	addi	a4,a4,-1486 # 8000a398 <ticks>
    8000196e:	431c                	lw	a5,0(a4)
    80001970:	2785                	addiw	a5,a5,1
    80001972:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001974:	853a                	mv	a0,a4
    80001976:	a3bff0ef          	jal	800013b0 <wakeup>
    release(&tickslock);
    8000197a:	0000f517          	auipc	a0,0xf
    8000197e:	88650513          	addi	a0,a0,-1914 # 80010200 <tickslock>
    80001982:	14e040ef          	jal	80005ad0 <release>
    80001986:	bf6d                	j	80001940 <clockintr+0xe>

0000000080001988 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001990:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001994:	57fd                	li	a5,-1
    80001996:	17fe                	slli	a5,a5,0x3f
    80001998:	07a5                	addi	a5,a5,9
    8000199a:	00f70c63          	beq	a4,a5,800019b2 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000199e:	57fd                	li	a5,-1
    800019a0:	17fe                	slli	a5,a5,0x3f
    800019a2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019a4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019a6:	04f70863          	beq	a4,a5,800019f6 <devintr+0x6e>
  }
}
    800019aa:	60e2                	ld	ra,24(sp)
    800019ac:	6442                	ld	s0,16(sp)
    800019ae:	6105                	addi	sp,sp,32
    800019b0:	8082                	ret
    800019b2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019b4:	048030ef          	jal	800049fc <plic_claim>
    800019b8:	872a                	mv	a4,a0
    800019ba:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019bc:	47a9                	li	a5,10
    800019be:	00f50963          	beq	a0,a5,800019d0 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    800019c2:	4785                	li	a5,1
    800019c4:	00f50963          	beq	a0,a5,800019d6 <devintr+0x4e>
    return 1;
    800019c8:	4505                	li	a0,1
    } else if(irq){
    800019ca:	eb09                	bnez	a4,800019dc <devintr+0x54>
    800019cc:	64a2                	ld	s1,8(sp)
    800019ce:	bff1                	j	800019aa <devintr+0x22>
      uartintr();
    800019d0:	7a3030ef          	jal	80005972 <uartintr>
    if(irq)
    800019d4:	a819                	j	800019ea <devintr+0x62>
      virtio_disk_intr();
    800019d6:	4bc030ef          	jal	80004e92 <virtio_disk_intr>
    if(irq)
    800019da:	a801                	j	800019ea <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800019dc:	85ba                	mv	a1,a4
    800019de:	00006517          	auipc	a0,0x6
    800019e2:	8b250513          	addi	a0,a0,-1870 # 80007290 <etext+0x290>
    800019e6:	209030ef          	jal	800053ee <printf>
      plic_complete(irq);
    800019ea:	8526                	mv	a0,s1
    800019ec:	030030ef          	jal	80004a1c <plic_complete>
    return 1;
    800019f0:	4505                	li	a0,1
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	bf5d                	j	800019aa <devintr+0x22>
    clockintr();
    800019f6:	f3dff0ef          	jal	80001932 <clockintr>
    return 2;
    800019fa:	4509                	li	a0,2
    800019fc:	b77d                	j	800019aa <devintr+0x22>

00000000800019fe <usertrap>:
{
    800019fe:	1101                	addi	sp,sp,-32
    80001a00:	ec06                	sd	ra,24(sp)
    80001a02:	e822                	sd	s0,16(sp)
    80001a04:	e426                	sd	s1,8(sp)
    80001a06:	e04a                	sd	s2,0(sp)
    80001a08:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a0a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a0e:	1007f793          	andi	a5,a5,256
    80001a12:	ef85                	bnez	a5,80001a4a <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a14:	00003797          	auipc	a5,0x3
    80001a18:	f3c78793          	addi	a5,a5,-196 # 80004950 <kernelvec>
    80001a1c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a20:	b66ff0ef          	jal	80000d86 <myproc>
    80001a24:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a26:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a28:	14102773          	csrr	a4,sepc
    80001a2c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a2e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a32:	47a1                	li	a5,8
    80001a34:	02f70163          	beq	a4,a5,80001a56 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a38:	f51ff0ef          	jal	80001988 <devintr>
    80001a3c:	892a                	mv	s2,a0
    80001a3e:	c135                	beqz	a0,80001aa2 <usertrap+0xa4>
  if(killed(p))
    80001a40:	8526                	mv	a0,s1
    80001a42:	b5fff0ef          	jal	800015a0 <killed>
    80001a46:	cd1d                	beqz	a0,80001a84 <usertrap+0x86>
    80001a48:	a81d                	j	80001a7e <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a4a:	00006517          	auipc	a0,0x6
    80001a4e:	86650513          	addi	a0,a0,-1946 # 800072b0 <etext+0x2b0>
    80001a52:	4ad030ef          	jal	800056fe <panic>
    if(killed(p))
    80001a56:	b4bff0ef          	jal	800015a0 <killed>
    80001a5a:	e121                	bnez	a0,80001a9a <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a5c:	6cb8                	ld	a4,88(s1)
    80001a5e:	6f1c                	ld	a5,24(a4)
    80001a60:	0791                	addi	a5,a5,4
    80001a62:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a6c:	10079073          	csrw	sstatus,a5
    syscall();
    80001a70:	242000ef          	jal	80001cb2 <syscall>
  if(killed(p))
    80001a74:	8526                	mv	a0,s1
    80001a76:	b2bff0ef          	jal	800015a0 <killed>
    80001a7a:	c901                	beqz	a0,80001a8a <usertrap+0x8c>
    80001a7c:	4901                	li	s2,0
    exit(-1);
    80001a7e:	557d                	li	a0,-1
    80001a80:	9f1ff0ef          	jal	80001470 <exit>
  if(which_dev == 2)
    80001a84:	4789                	li	a5,2
    80001a86:	04f90563          	beq	s2,a5,80001ad0 <usertrap+0xd2>
  usertrapret();
    80001a8a:	e17ff0ef          	jal	800018a0 <usertrapret>
}
    80001a8e:	60e2                	ld	ra,24(sp)
    80001a90:	6442                	ld	s0,16(sp)
    80001a92:	64a2                	ld	s1,8(sp)
    80001a94:	6902                	ld	s2,0(sp)
    80001a96:	6105                	addi	sp,sp,32
    80001a98:	8082                	ret
      exit(-1);
    80001a9a:	557d                	li	a0,-1
    80001a9c:	9d5ff0ef          	jal	80001470 <exit>
    80001aa0:	bf75                	j	80001a5c <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001aa6:	5890                	lw	a2,48(s1)
    80001aa8:	00006517          	auipc	a0,0x6
    80001aac:	82850513          	addi	a0,a0,-2008 # 800072d0 <etext+0x2d0>
    80001ab0:	13f030ef          	jal	800053ee <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ab4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ab8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001abc:	00006517          	auipc	a0,0x6
    80001ac0:	84450513          	addi	a0,a0,-1980 # 80007300 <etext+0x300>
    80001ac4:	12b030ef          	jal	800053ee <printf>
    setkilled(p);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	ab3ff0ef          	jal	8000157c <setkilled>
    80001ace:	b75d                	j	80001a74 <usertrap+0x76>
    yield();
    80001ad0:	869ff0ef          	jal	80001338 <yield>
    80001ad4:	bf5d                	j	80001a8a <usertrap+0x8c>

0000000080001ad6 <kerneltrap>:
{
    80001ad6:	7179                	addi	sp,sp,-48
    80001ad8:	f406                	sd	ra,40(sp)
    80001ada:	f022                	sd	s0,32(sp)
    80001adc:	ec26                	sd	s1,24(sp)
    80001ade:	e84a                	sd	s2,16(sp)
    80001ae0:	e44e                	sd	s3,8(sp)
    80001ae2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ae4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ae8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aec:	142027f3          	csrr	a5,scause
    80001af0:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001af2:	1004f793          	andi	a5,s1,256
    80001af6:	c795                	beqz	a5,80001b22 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001afc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001afe:	eb85                	bnez	a5,80001b2e <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001b00:	e89ff0ef          	jal	80001988 <devintr>
    80001b04:	c91d                	beqz	a0,80001b3a <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001b06:	4789                	li	a5,2
    80001b08:	04f50a63          	beq	a0,a5,80001b5c <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b0c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b10:	10049073          	csrw	sstatus,s1
}
    80001b14:	70a2                	ld	ra,40(sp)
    80001b16:	7402                	ld	s0,32(sp)
    80001b18:	64e2                	ld	s1,24(sp)
    80001b1a:	6942                	ld	s2,16(sp)
    80001b1c:	69a2                	ld	s3,8(sp)
    80001b1e:	6145                	addi	sp,sp,48
    80001b20:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b22:	00006517          	auipc	a0,0x6
    80001b26:	80650513          	addi	a0,a0,-2042 # 80007328 <etext+0x328>
    80001b2a:	3d5030ef          	jal	800056fe <panic>
    panic("kerneltrap: interrupts enabled");
    80001b2e:	00006517          	auipc	a0,0x6
    80001b32:	82250513          	addi	a0,a0,-2014 # 80007350 <etext+0x350>
    80001b36:	3c9030ef          	jal	800056fe <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b3a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b3e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b42:	85ce                	mv	a1,s3
    80001b44:	00006517          	auipc	a0,0x6
    80001b48:	82c50513          	addi	a0,a0,-2004 # 80007370 <etext+0x370>
    80001b4c:	0a3030ef          	jal	800053ee <printf>
    panic("kerneltrap");
    80001b50:	00006517          	auipc	a0,0x6
    80001b54:	84850513          	addi	a0,a0,-1976 # 80007398 <etext+0x398>
    80001b58:	3a7030ef          	jal	800056fe <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b5c:	a2aff0ef          	jal	80000d86 <myproc>
    80001b60:	d555                	beqz	a0,80001b0c <kerneltrap+0x36>
    yield();
    80001b62:	fd6ff0ef          	jal	80001338 <yield>
    80001b66:	b75d                	j	80001b0c <kerneltrap+0x36>

0000000080001b68 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b68:	1101                	addi	sp,sp,-32
    80001b6a:	ec06                	sd	ra,24(sp)
    80001b6c:	e822                	sd	s0,16(sp)
    80001b6e:	e426                	sd	s1,8(sp)
    80001b70:	1000                	addi	s0,sp,32
    80001b72:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b74:	a12ff0ef          	jal	80000d86 <myproc>
  switch (n) {
    80001b78:	4795                	li	a5,5
    80001b7a:	0497e163          	bltu	a5,s1,80001bbc <argraw+0x54>
    80001b7e:	048a                	slli	s1,s1,0x2
    80001b80:	00006717          	auipc	a4,0x6
    80001b84:	c6070713          	addi	a4,a4,-928 # 800077e0 <states.0+0x30>
    80001b88:	94ba                	add	s1,s1,a4
    80001b8a:	409c                	lw	a5,0(s1)
    80001b8c:	97ba                	add	a5,a5,a4
    80001b8e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b90:	6d3c                	ld	a5,88(a0)
    80001b92:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret
    return p->trapframe->a1;
    80001b9e:	6d3c                	ld	a5,88(a0)
    80001ba0:	7fa8                	ld	a0,120(a5)
    80001ba2:	bfcd                	j	80001b94 <argraw+0x2c>
    return p->trapframe->a2;
    80001ba4:	6d3c                	ld	a5,88(a0)
    80001ba6:	63c8                	ld	a0,128(a5)
    80001ba8:	b7f5                	j	80001b94 <argraw+0x2c>
    return p->trapframe->a3;
    80001baa:	6d3c                	ld	a5,88(a0)
    80001bac:	67c8                	ld	a0,136(a5)
    80001bae:	b7dd                	j	80001b94 <argraw+0x2c>
    return p->trapframe->a4;
    80001bb0:	6d3c                	ld	a5,88(a0)
    80001bb2:	6bc8                	ld	a0,144(a5)
    80001bb4:	b7c5                	j	80001b94 <argraw+0x2c>
    return p->trapframe->a5;
    80001bb6:	6d3c                	ld	a5,88(a0)
    80001bb8:	6fc8                	ld	a0,152(a5)
    80001bba:	bfe9                	j	80001b94 <argraw+0x2c>
  panic("argraw");
    80001bbc:	00005517          	auipc	a0,0x5
    80001bc0:	7ec50513          	addi	a0,a0,2028 # 800073a8 <etext+0x3a8>
    80001bc4:	33b030ef          	jal	800056fe <panic>

0000000080001bc8 <fetchaddr>:
{
    80001bc8:	1101                	addi	sp,sp,-32
    80001bca:	ec06                	sd	ra,24(sp)
    80001bcc:	e822                	sd	s0,16(sp)
    80001bce:	e426                	sd	s1,8(sp)
    80001bd0:	e04a                	sd	s2,0(sp)
    80001bd2:	1000                	addi	s0,sp,32
    80001bd4:	84aa                	mv	s1,a0
    80001bd6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001bd8:	9aeff0ef          	jal	80000d86 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001bdc:	653c                	ld	a5,72(a0)
    80001bde:	02f4f663          	bgeu	s1,a5,80001c0a <fetchaddr+0x42>
    80001be2:	00848713          	addi	a4,s1,8
    80001be6:	02e7e463          	bltu	a5,a4,80001c0e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bea:	46a1                	li	a3,8
    80001bec:	8626                	mv	a2,s1
    80001bee:	85ca                	mv	a1,s2
    80001bf0:	6928                	ld	a0,80(a0)
    80001bf2:	ec1fe0ef          	jal	80000ab2 <copyin>
    80001bf6:	00a03533          	snez	a0,a0
    80001bfa:	40a0053b          	negw	a0,a0
}
    80001bfe:	60e2                	ld	ra,24(sp)
    80001c00:	6442                	ld	s0,16(sp)
    80001c02:	64a2                	ld	s1,8(sp)
    80001c04:	6902                	ld	s2,0(sp)
    80001c06:	6105                	addi	sp,sp,32
    80001c08:	8082                	ret
    return -1;
    80001c0a:	557d                	li	a0,-1
    80001c0c:	bfcd                	j	80001bfe <fetchaddr+0x36>
    80001c0e:	557d                	li	a0,-1
    80001c10:	b7fd                	j	80001bfe <fetchaddr+0x36>

0000000080001c12 <fetchstr>:
{
    80001c12:	7179                	addi	sp,sp,-48
    80001c14:	f406                	sd	ra,40(sp)
    80001c16:	f022                	sd	s0,32(sp)
    80001c18:	ec26                	sd	s1,24(sp)
    80001c1a:	e84a                	sd	s2,16(sp)
    80001c1c:	e44e                	sd	s3,8(sp)
    80001c1e:	1800                	addi	s0,sp,48
    80001c20:	89aa                	mv	s3,a0
    80001c22:	84ae                	mv	s1,a1
    80001c24:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001c26:	960ff0ef          	jal	80000d86 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c2a:	86ca                	mv	a3,s2
    80001c2c:	864e                	mv	a2,s3
    80001c2e:	85a6                	mv	a1,s1
    80001c30:	6928                	ld	a0,80(a0)
    80001c32:	f07fe0ef          	jal	80000b38 <copyinstr>
    80001c36:	00054c63          	bltz	a0,80001c4e <fetchstr+0x3c>
  return strlen(buf);
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	eacfe0ef          	jal	800002e8 <strlen>
}
    80001c40:	70a2                	ld	ra,40(sp)
    80001c42:	7402                	ld	s0,32(sp)
    80001c44:	64e2                	ld	s1,24(sp)
    80001c46:	6942                	ld	s2,16(sp)
    80001c48:	69a2                	ld	s3,8(sp)
    80001c4a:	6145                	addi	sp,sp,48
    80001c4c:	8082                	ret
    return -1;
    80001c4e:	557d                	li	a0,-1
    80001c50:	bfc5                	j	80001c40 <fetchstr+0x2e>

0000000080001c52 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c52:	1101                	addi	sp,sp,-32
    80001c54:	ec06                	sd	ra,24(sp)
    80001c56:	e822                	sd	s0,16(sp)
    80001c58:	e426                	sd	s1,8(sp)
    80001c5a:	1000                	addi	s0,sp,32
    80001c5c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c5e:	f0bff0ef          	jal	80001b68 <argraw>
    80001c62:	c088                	sw	a0,0(s1)
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	1000                	addi	s0,sp,32
    80001c78:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c7a:	eefff0ef          	jal	80001b68 <argraw>
    80001c7e:	e088                	sd	a0,0(s1)
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6105                	addi	sp,sp,32
    80001c88:	8082                	ret

0000000080001c8a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	e04a                	sd	s2,0(sp)
    80001c94:	1000                	addi	s0,sp,32
    80001c96:	892e                	mv	s2,a1
    80001c98:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001c9a:	ecfff0ef          	jal	80001b68 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c9e:	8626                	mv	a2,s1
    80001ca0:	85ca                	mv	a1,s2
    80001ca2:	f71ff0ef          	jal	80001c12 <fetchstr>
}
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6902                	ld	s2,0(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret

0000000080001cb2 <syscall>:
[SYS_ptree]   sys_ptree,
};

void
syscall(void)
{
    80001cb2:	1101                	addi	sp,sp,-32
    80001cb4:	ec06                	sd	ra,24(sp)
    80001cb6:	e822                	sd	s0,16(sp)
    80001cb8:	e426                	sd	s1,8(sp)
    80001cba:	e04a                	sd	s2,0(sp)
    80001cbc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001cbe:	8c8ff0ef          	jal	80000d86 <myproc>
    80001cc2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001cc4:	05853903          	ld	s2,88(a0)
    80001cc8:	0a893783          	ld	a5,168(s2)
    80001ccc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001cd0:	37fd                	addiw	a5,a5,-1
    80001cd2:	4761                	li	a4,24
    80001cd4:	00f76f63          	bltu	a4,a5,80001cf2 <syscall+0x40>
    80001cd8:	00369713          	slli	a4,a3,0x3
    80001cdc:	00006797          	auipc	a5,0x6
    80001ce0:	b1c78793          	addi	a5,a5,-1252 # 800077f8 <syscalls>
    80001ce4:	97ba                	add	a5,a5,a4
    80001ce6:	639c                	ld	a5,0(a5)
    80001ce8:	c789                	beqz	a5,80001cf2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cea:	9782                	jalr	a5
    80001cec:	06a93823          	sd	a0,112(s2)
    80001cf0:	a829                	j	80001d0a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cf2:	15848613          	addi	a2,s1,344
    80001cf6:	588c                	lw	a1,48(s1)
    80001cf8:	00005517          	auipc	a0,0x5
    80001cfc:	6b850513          	addi	a0,a0,1720 # 800073b0 <etext+0x3b0>
    80001d00:	6ee030ef          	jal	800053ee <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d04:	6cbc                	ld	a5,88(s1)
    80001d06:	577d                	li	a4,-1
    80001d08:	fbb8                	sd	a4,112(a5)
  }
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6902                	ld	s2,0(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret

0000000080001d16 <sys_exit>:
  struct run *freelist;
} kmem;

uint64
sys_exit(void)
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d1e:	fec40593          	addi	a1,s0,-20
    80001d22:	4501                	li	a0,0
    80001d24:	f2fff0ef          	jal	80001c52 <argint>
  exit(n);
    80001d28:	fec42503          	lw	a0,-20(s0)
    80001d2c:	f44ff0ef          	jal	80001470 <exit>
  return 0;  // not reached
}
    80001d30:	4501                	li	a0,0
    80001d32:	60e2                	ld	ra,24(sp)
    80001d34:	6442                	ld	s0,16(sp)
    80001d36:	6105                	addi	sp,sp,32
    80001d38:	8082                	ret

0000000080001d3a <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d3a:	1141                	addi	sp,sp,-16
    80001d3c:	e406                	sd	ra,8(sp)
    80001d3e:	e022                	sd	s0,0(sp)
    80001d40:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d42:	844ff0ef          	jal	80000d86 <myproc>
}
    80001d46:	5908                	lw	a0,48(a0)
    80001d48:	60a2                	ld	ra,8(sp)
    80001d4a:	6402                	ld	s0,0(sp)
    80001d4c:	0141                	addi	sp,sp,16
    80001d4e:	8082                	ret

0000000080001d50 <sys_fork>:

uint64
sys_fork(void)
{
    80001d50:	1141                	addi	sp,sp,-16
    80001d52:	e406                	sd	ra,8(sp)
    80001d54:	e022                	sd	s0,0(sp)
    80001d56:	0800                	addi	s0,sp,16
  return fork();
    80001d58:	b56ff0ef          	jal	800010ae <fork>
}
    80001d5c:	60a2                	ld	ra,8(sp)
    80001d5e:	6402                	ld	s0,0(sp)
    80001d60:	0141                	addi	sp,sp,16
    80001d62:	8082                	ret

0000000080001d64 <sys_wait>:

uint64
sys_wait(void)
{
    80001d64:	1101                	addi	sp,sp,-32
    80001d66:	ec06                	sd	ra,24(sp)
    80001d68:	e822                	sd	s0,16(sp)
    80001d6a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d6c:	fe840593          	addi	a1,s0,-24
    80001d70:	4501                	li	a0,0
    80001d72:	efdff0ef          	jal	80001c6e <argaddr>
  return wait(p);
    80001d76:	fe843503          	ld	a0,-24(s0)
    80001d7a:	851ff0ef          	jal	800015ca <wait>
}
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	6105                	addi	sp,sp,32
    80001d84:	8082                	ret

0000000080001d86 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d86:	7179                	addi	sp,sp,-48
    80001d88:	f406                	sd	ra,40(sp)
    80001d8a:	f022                	sd	s0,32(sp)
    80001d8c:	ec26                	sd	s1,24(sp)
    80001d8e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d90:	fdc40593          	addi	a1,s0,-36
    80001d94:	4501                	li	a0,0
    80001d96:	ebdff0ef          	jal	80001c52 <argint>
  addr = myproc()->sz;
    80001d9a:	fedfe0ef          	jal	80000d86 <myproc>
    80001d9e:	653c                	ld	a5,72(a0)
    80001da0:	84be                	mv	s1,a5
  if(growproc(n) < 0)
    80001da2:	fdc42503          	lw	a0,-36(s0)
    80001da6:	ab8ff0ef          	jal	8000105e <growproc>
    80001daa:	00054863          	bltz	a0,80001dba <sys_sbrk+0x34>
    return -1;
  return addr;
}
    80001dae:	8526                	mv	a0,s1
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	64e2                	ld	s1,24(sp)
    80001db6:	6145                	addi	sp,sp,48
    80001db8:	8082                	ret
    return -1;
    80001dba:	57fd                	li	a5,-1
    80001dbc:	84be                	mv	s1,a5
    80001dbe:	bfc5                	j	80001dae <sys_sbrk+0x28>

0000000080001dc0 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001dc0:	7139                	addi	sp,sp,-64
    80001dc2:	fc06                	sd	ra,56(sp)
    80001dc4:	f822                	sd	s0,48(sp)
    80001dc6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001dc8:	fcc40593          	addi	a1,s0,-52
    80001dcc:	4501                	li	a0,0
    80001dce:	e85ff0ef          	jal	80001c52 <argint>
  if(n < 0)
    80001dd2:	fcc42783          	lw	a5,-52(s0)
    80001dd6:	0607c863          	bltz	a5,80001e46 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001dda:	0000e517          	auipc	a0,0xe
    80001dde:	42650513          	addi	a0,a0,1062 # 80010200 <tickslock>
    80001de2:	45b030ef          	jal	80005a3c <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001de6:	fcc42783          	lw	a5,-52(s0)
    80001dea:	c3b9                	beqz	a5,80001e30 <sys_sleep+0x70>
    80001dec:	f426                	sd	s1,40(sp)
    80001dee:	f04a                	sd	s2,32(sp)
    80001df0:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001df2:	00008997          	auipc	s3,0x8
    80001df6:	5a69a983          	lw	s3,1446(s3) # 8000a398 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dfa:	0000e917          	auipc	s2,0xe
    80001dfe:	40690913          	addi	s2,s2,1030 # 80010200 <tickslock>
    80001e02:	00008497          	auipc	s1,0x8
    80001e06:	59648493          	addi	s1,s1,1430 # 8000a398 <ticks>
    if(killed(myproc())){
    80001e0a:	f7dfe0ef          	jal	80000d86 <myproc>
    80001e0e:	f92ff0ef          	jal	800015a0 <killed>
    80001e12:	ed0d                	bnez	a0,80001e4c <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e14:	85ca                	mv	a1,s2
    80001e16:	8526                	mv	a0,s1
    80001e18:	d4cff0ef          	jal	80001364 <sleep>
  while(ticks - ticks0 < n){
    80001e1c:	409c                	lw	a5,0(s1)
    80001e1e:	413787bb          	subw	a5,a5,s3
    80001e22:	fcc42703          	lw	a4,-52(s0)
    80001e26:	fee7e2e3          	bltu	a5,a4,80001e0a <sys_sleep+0x4a>
    80001e2a:	74a2                	ld	s1,40(sp)
    80001e2c:	7902                	ld	s2,32(sp)
    80001e2e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e30:	0000e517          	auipc	a0,0xe
    80001e34:	3d050513          	addi	a0,a0,976 # 80010200 <tickslock>
    80001e38:	499030ef          	jal	80005ad0 <release>
  return 0;
    80001e3c:	4501                	li	a0,0
}
    80001e3e:	70e2                	ld	ra,56(sp)
    80001e40:	7442                	ld	s0,48(sp)
    80001e42:	6121                	addi	sp,sp,64
    80001e44:	8082                	ret
    n = 0;
    80001e46:	fc042623          	sw	zero,-52(s0)
    80001e4a:	bf41                	j	80001dda <sys_sleep+0x1a>
      release(&tickslock);
    80001e4c:	0000e517          	auipc	a0,0xe
    80001e50:	3b450513          	addi	a0,a0,948 # 80010200 <tickslock>
    80001e54:	47d030ef          	jal	80005ad0 <release>
      return -1;
    80001e58:	557d                	li	a0,-1
    80001e5a:	74a2                	ld	s1,40(sp)
    80001e5c:	7902                	ld	s2,32(sp)
    80001e5e:	69e2                	ld	s3,24(sp)
    80001e60:	bff9                	j	80001e3e <sys_sleep+0x7e>

0000000080001e62 <sys_kill>:

uint64
sys_kill(void)
{
    80001e62:	1101                	addi	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e6a:	fec40593          	addi	a1,s0,-20
    80001e6e:	4501                	li	a0,0
    80001e70:	de3ff0ef          	jal	80001c52 <argint>
  return kill(pid);
    80001e74:	fec42503          	lw	a0,-20(s0)
    80001e78:	e9eff0ef          	jal	80001516 <kill>
}
    80001e7c:	60e2                	ld	ra,24(sp)
    80001e7e:	6442                	ld	s0,16(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret

0000000080001e84 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e84:	1101                	addi	sp,sp,-32
    80001e86:	ec06                	sd	ra,24(sp)
    80001e88:	e822                	sd	s0,16(sp)
    80001e8a:	e426                	sd	s1,8(sp)
    80001e8c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e8e:	0000e517          	auipc	a0,0xe
    80001e92:	37250513          	addi	a0,a0,882 # 80010200 <tickslock>
    80001e96:	3a7030ef          	jal	80005a3c <acquire>
  xticks = ticks;
    80001e9a:	00008797          	auipc	a5,0x8
    80001e9e:	4fe7a783          	lw	a5,1278(a5) # 8000a398 <ticks>
    80001ea2:	84be                	mv	s1,a5
  release(&tickslock);
    80001ea4:	0000e517          	auipc	a0,0xe
    80001ea8:	35c50513          	addi	a0,a0,860 # 80010200 <tickslock>
    80001eac:	425030ef          	jal	80005ad0 <release>
  return xticks;
}
    80001eb0:	02049513          	slli	a0,s1,0x20
    80001eb4:	9101                	srli	a0,a0,0x20
    80001eb6:	60e2                	ld	ra,24(sp)
    80001eb8:	6442                	ld	s0,16(sp)
    80001eba:	64a2                	ld	s1,8(sp)
    80001ebc:	6105                	addi	sp,sp,32
    80001ebe:	8082                	ret

0000000080001ec0 <sys_freeze>:

uint64
sys_freeze(void)
{
    80001ec0:	7179                	addi	sp,sp,-48
    80001ec2:	f406                	sd	ra,40(sp)
    80001ec4:	f022                	sd	s0,32(sp)
    80001ec6:	ec26                	sd	s1,24(sp)
    80001ec8:	e84a                	sd	s2,16(sp)
    80001eca:	1800                	addi	s0,sp,48
  int pid;
  argint(0, &pid);
    80001ecc:	fdc40593          	addi	a1,s0,-36
    80001ed0:	4501                	li	a0,0
    80001ed2:	d81ff0ef          	jal	80001c52 <argint>
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001ed6:	00009497          	auipc	s1,0x9
    80001eda:	92a48493          	addi	s1,s1,-1750 # 8000a800 <proc>
    80001ede:	0000e917          	auipc	s2,0xe
    80001ee2:	32290913          	addi	s2,s2,802 # 80010200 <tickslock>
    acquire(&p->lock);
    80001ee6:	8526                	mv	a0,s1
    80001ee8:	355030ef          	jal	80005a3c <acquire>
    if(p->pid == pid){
    80001eec:	5898                	lw	a4,48(s1)
    80001eee:	fdc42783          	lw	a5,-36(s0)
    80001ef2:	00f70b63          	beq	a4,a5,80001f08 <sys_freeze+0x48>
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	3d9030ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001efc:	16848493          	addi	s1,s1,360
    80001f00:	ff2493e3          	bne	s1,s2,80001ee6 <sys_freeze+0x26>
  }
  return -1;
    80001f04:	557d                	li	a0,-1
    80001f06:	a821                	j	80001f1e <sys_freeze+0x5e>
      if(p->state != ZOMBIE && p->state != UNUSED && !p->frozen){
    80001f08:	4c9c                	lw	a5,24(s1)
    80001f0a:	ffb78713          	addi	a4,a5,-5
    80001f0e:	c701                	beqz	a4,80001f16 <sys_freeze+0x56>
    80001f10:	c399                	beqz	a5,80001f16 <sys_freeze+0x56>
    80001f12:	58dc                	lw	a5,52(s1)
    80001f14:	cb99                	beqz	a5,80001f2a <sys_freeze+0x6a>
      release(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	3b9030ef          	jal	80005ad0 <release>
      return -1;
    80001f1c:	557d                	li	a0,-1
}
    80001f1e:	70a2                	ld	ra,40(sp)
    80001f20:	7402                	ld	s0,32(sp)
    80001f22:	64e2                	ld	s1,24(sp)
    80001f24:	6942                	ld	s2,16(sp)
    80001f26:	6145                	addi	sp,sp,48
    80001f28:	8082                	ret
        p->frozen = 1;  // set frozen flag
    80001f2a:	4785                	li	a5,1
    80001f2c:	d8dc                	sw	a5,52(s1)
        release(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	3a1030ef          	jal	80005ad0 <release>
        return 0;
    80001f34:	4501                	li	a0,0
    80001f36:	b7e5                	j	80001f1e <sys_freeze+0x5e>

0000000080001f38 <sys_unfreeze>:

uint64
sys_unfreeze(void)
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	1800                	addi	s0,sp,48
  int pid;
  argint(0, &pid);
    80001f44:	fdc40593          	addi	a1,s0,-36
    80001f48:	4501                	li	a0,0
    80001f4a:	d09ff0ef          	jal	80001c52 <argint>
  
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001f4e:	00009497          	auipc	s1,0x9
    80001f52:	8b248493          	addi	s1,s1,-1870 # 8000a800 <proc>
    80001f56:	0000e917          	auipc	s2,0xe
    80001f5a:	2aa90913          	addi	s2,s2,682 # 80010200 <tickslock>
    acquire(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	2dd030ef          	jal	80005a3c <acquire>
    if(p->pid == pid){
    80001f64:	5898                	lw	a4,48(s1)
    80001f66:	fdc42783          	lw	a5,-36(s0)
    80001f6a:	00f70b63          	beq	a4,a5,80001f80 <sys_unfreeze+0x48>
        return 0;
      }
      release(&p->lock);
      return -1;
    }
    release(&p->lock);
    80001f6e:	8526                	mv	a0,s1
    80001f70:	361030ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001f74:	16848493          	addi	s1,s1,360
    80001f78:	ff2493e3          	bne	s1,s2,80001f5e <sys_unfreeze+0x26>
  }
  return -1;
    80001f7c:	557d                	li	a0,-1
    80001f7e:	a829                	j	80001f98 <sys_unfreeze+0x60>
      if(p->frozen){
    80001f80:	58dc                	lw	a5,52(s1)
    80001f82:	c785                	beqz	a5,80001faa <sys_unfreeze+0x72>
        p->frozen = 0;  // clear frozen flag
    80001f84:	0204aa23          	sw	zero,52(s1)
        if(p->state == SLEEPING) {
    80001f88:	4c98                	lw	a4,24(s1)
    80001f8a:	4789                	li	a5,2
    80001f8c:	00f70c63          	beq	a4,a5,80001fa4 <sys_unfreeze+0x6c>
        release(&p->lock);
    80001f90:	8526                	mv	a0,s1
    80001f92:	33f030ef          	jal	80005ad0 <release>
        return 0;
    80001f96:	4501                	li	a0,0
}
    80001f98:	70a2                	ld	ra,40(sp)
    80001f9a:	7402                	ld	s0,32(sp)
    80001f9c:	64e2                	ld	s1,24(sp)
    80001f9e:	6942                	ld	s2,16(sp)
    80001fa0:	6145                	addi	sp,sp,48
    80001fa2:	8082                	ret
          p->state = RUNNABLE;
    80001fa4:	478d                	li	a5,3
    80001fa6:	cc9c                	sw	a5,24(s1)
    80001fa8:	b7e5                	j	80001f90 <sys_unfreeze+0x58>
      release(&p->lock);
    80001faa:	8526                	mv	a0,s1
    80001fac:	325030ef          	jal	80005ad0 <release>
      return -1;
    80001fb0:	557d                	li	a0,-1
    80001fb2:	b7dd                	j	80001f98 <sys_unfreeze+0x60>

0000000080001fb4 <sys_meminfo>:
// Returns a 64-bit value where:
// - Upper 32 bits contain total free pages
// - Lower 32 bits contain total used pages
uint64
sys_meminfo(void)
{
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	e04a                	sd	s2,0(sp)
    80001fbe:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 free_pages = 0;
  uint64 used_pages = 0;
  uint64 total_pages = (PHYSTOP - (uint64)end) / PGSIZE;
    80001fc0:	4945                	li	s2,17
    80001fc2:	096e                	slli	s2,s2,0x1b
    80001fc4:	00021797          	auipc	a5,0x21
    80001fc8:	71c78793          	addi	a5,a5,1820 # 800236e0 <end>
    80001fcc:	40f90933          	sub	s2,s2,a5
    80001fd0:	00c95913          	srli	s2,s2,0xc

  // Count free pages
  acquire(&kmem.lock);
    80001fd4:	00008517          	auipc	a0,0x8
    80001fd8:	3dc50513          	addi	a0,a0,988 # 8000a3b0 <kmem>
    80001fdc:	261030ef          	jal	80005a3c <acquire>
  for(r = kmem.freelist; r; r = r->next)
    80001fe0:	00008797          	auipc	a5,0x8
    80001fe4:	3e87b783          	ld	a5,1000(a5) # 8000a3c8 <kmem+0x18>
    80001fe8:	c79d                	beqz	a5,80002016 <sys_meminfo+0x62>
  uint64 free_pages = 0;
    80001fea:	4481                	li	s1,0
    free_pages++;
    80001fec:	0485                	addi	s1,s1,1
  for(r = kmem.freelist; r; r = r->next)
    80001fee:	639c                	ld	a5,0(a5)
    80001ff0:	fff5                	bnez	a5,80001fec <sys_meminfo+0x38>
  release(&kmem.lock);
    80001ff2:	00008517          	auipc	a0,0x8
    80001ff6:	3be50513          	addi	a0,a0,958 # 8000a3b0 <kmem>
    80001ffa:	2d7030ef          	jal	80005ad0 <release>

  // Calculate used pages
  used_pages = total_pages - free_pages;

  // Pack the values into a 64-bit return value
  return (free_pages << 32) | used_pages;
    80001ffe:	02049513          	slli	a0,s1,0x20
  used_pages = total_pages - free_pages;
    80002002:	40990933          	sub	s2,s2,s1
}
    80002006:	01256533          	or	a0,a0,s2
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6902                	ld	s2,0(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret
  uint64 free_pages = 0;
    80002016:	4481                	li	s1,0
    80002018:	bfe9                	j	80001ff2 <sys_meminfo+0x3e>

000000008000201a <print_ptree_recursive>:

// Helper function to print process tree recursively
void
print_ptree_recursive(struct proc *p, int depth)
{
    8000201a:	7139                	addi	sp,sp,-64
    8000201c:	fc06                	sd	ra,56(sp)
    8000201e:	f822                	sd	s0,48(sp)
    80002020:	f426                	sd	s1,40(sp)
    80002022:	f04a                	sd	s2,32(sp)
    80002024:	ec4e                	sd	s3,24(sp)
    80002026:	e456                	sd	s5,8(sp)
    80002028:	0080                	addi	s0,sp,64
    8000202a:	89aa                	mv	s3,a0
    8000202c:	8aae                	mv	s5,a1
  struct proc *child;
  int i;

  // Print current process with indentation (2 spaces per depth level)
  for(i = 0; i < depth * 2; i++) {
    8000202e:	02b05163          	blez	a1,80002050 <print_ptree_recursive+0x36>
    80002032:	e852                	sd	s4,16(sp)
    80002034:	00159a1b          	slliw	s4,a1,0x1
    80002038:	4481                	li	s1,0
    printf(" ");
    8000203a:	00005917          	auipc	s2,0x5
    8000203e:	39690913          	addi	s2,s2,918 # 800073d0 <etext+0x3d0>
    80002042:	854a                	mv	a0,s2
    80002044:	3aa030ef          	jal	800053ee <printf>
  for(i = 0; i < depth * 2; i++) {
    80002048:	2485                	addiw	s1,s1,1
    8000204a:	ff449ce3          	bne	s1,s4,80002042 <print_ptree_recursive+0x28>
    8000204e:	6a42                	ld	s4,16(sp)
  }
  printf("%s pid=%d ppid=%d\n", p->name, p->pid, p->parent ? p->parent->pid : 0);
    80002050:	15898593          	addi	a1,s3,344
    80002054:	0309a603          	lw	a2,48(s3)
    80002058:	0389b783          	ld	a5,56(s3)
    8000205c:	4681                	li	a3,0
    8000205e:	c391                	beqz	a5,80002062 <print_ptree_recursive+0x48>
    80002060:	5b94                	lw	a3,48(a5)
    80002062:	00005517          	auipc	a0,0x5
    80002066:	37650513          	addi	a0,a0,886 # 800073d8 <etext+0x3d8>
    8000206a:	384030ef          	jal	800053ee <printf>

  // Find and print children
  for(child = proc; child < &proc[NPROC]; child++) {
    8000206e:	00008497          	auipc	s1,0x8
    80002072:	79248493          	addi	s1,s1,1938 # 8000a800 <proc>
    80002076:	0000e917          	auipc	s2,0xe
    8000207a:	18a90913          	addi	s2,s2,394 # 80010200 <tickslock>
    8000207e:	a801                	j	8000208e <print_ptree_recursive+0x74>
    acquire(&child->lock);
    if(child->state != UNUSED && child->parent == p) {
      release(&child->lock);
      print_ptree_recursive(child, depth + 1);
    } else {
      release(&child->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	24f030ef          	jal	80005ad0 <release>
  for(child = proc; child < &proc[NPROC]; child++) {
    80002086:	16848493          	addi	s1,s1,360
    8000208a:	03248363          	beq	s1,s2,800020b0 <print_ptree_recursive+0x96>
    acquire(&child->lock);
    8000208e:	8526                	mv	a0,s1
    80002090:	1ad030ef          	jal	80005a3c <acquire>
    if(child->state != UNUSED && child->parent == p) {
    80002094:	4c9c                	lw	a5,24(s1)
    80002096:	d7ed                	beqz	a5,80002080 <print_ptree_recursive+0x66>
    80002098:	7c9c                	ld	a5,56(s1)
    8000209a:	ff3793e3          	bne	a5,s3,80002080 <print_ptree_recursive+0x66>
      release(&child->lock);
    8000209e:	8526                	mv	a0,s1
    800020a0:	231030ef          	jal	80005ad0 <release>
      print_ptree_recursive(child, depth + 1);
    800020a4:	001a859b          	addiw	a1,s5,1
    800020a8:	8526                	mv	a0,s1
    800020aa:	f71ff0ef          	jal	8000201a <print_ptree_recursive>
    800020ae:	bfe1                	j	80002086 <print_ptree_recursive+0x6c>
    }
  }
}
    800020b0:	70e2                	ld	ra,56(sp)
    800020b2:	7442                	ld	s0,48(sp)
    800020b4:	74a2                	ld	s1,40(sp)
    800020b6:	7902                	ld	s2,32(sp)
    800020b8:	69e2                	ld	s3,24(sp)
    800020ba:	6aa2                	ld	s5,8(sp)
    800020bc:	6121                	addi	sp,sp,64
    800020be:	8082                	ret

00000000800020c0 <sys_ptree>:

uint64
sys_ptree(void)
{
    800020c0:	7179                	addi	sp,sp,-48
    800020c2:	f406                	sd	ra,40(sp)
    800020c4:	f022                	sd	s0,32(sp)
    800020c6:	ec26                	sd	s1,24(sp)
    800020c8:	e84a                	sd	s2,16(sp)
    800020ca:	e44e                	sd	s3,8(sp)
    800020cc:	1800                	addi	s0,sp,48
  struct proc *init_proc = 0;
  struct proc *p;

  // Find the init process (PID 1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800020ce:	00008497          	auipc	s1,0x8
    800020d2:	73248493          	addi	s1,s1,1842 # 8000a800 <proc>
    acquire(&p->lock);
    if(p->pid == 1 && p->state != UNUSED) {
    800020d6:	4905                	li	s2,1
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d8:	0000e997          	auipc	s3,0xe
    800020dc:	12898993          	addi	s3,s3,296 # 80010200 <tickslock>
    800020e0:	a801                	j	800020f0 <sys_ptree+0x30>
      init_proc = p;
      release(&p->lock);
      break;
    }
    release(&p->lock);
    800020e2:	8526                	mv	a0,s1
    800020e4:	1ed030ef          	jal	80005ad0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020e8:	16848493          	addi	s1,s1,360
    800020ec:	03348963          	beq	s1,s3,8000211e <sys_ptree+0x5e>
    acquire(&p->lock);
    800020f0:	8526                	mv	a0,s1
    800020f2:	14b030ef          	jal	80005a3c <acquire>
    if(p->pid == 1 && p->state != UNUSED) {
    800020f6:	589c                	lw	a5,48(s1)
    800020f8:	ff2795e3          	bne	a5,s2,800020e2 <sys_ptree+0x22>
    800020fc:	4c9c                	lw	a5,24(s1)
    800020fe:	d3f5                	beqz	a5,800020e2 <sys_ptree+0x22>
      release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	1cf030ef          	jal	80005ad0 <release>
    printf("ptree: init process not found\n");
    return -1;
  }

  // Print the process tree starting from init
  print_ptree_recursive(init_proc, 0);
    80002106:	4581                	li	a1,0
    80002108:	8526                	mv	a0,s1
    8000210a:	f11ff0ef          	jal	8000201a <print_ptree_recursive>
  return 0;
    8000210e:	4501                	li	a0,0
}
    80002110:	70a2                	ld	ra,40(sp)
    80002112:	7402                	ld	s0,32(sp)
    80002114:	64e2                	ld	s1,24(sp)
    80002116:	6942                	ld	s2,16(sp)
    80002118:	69a2                	ld	s3,8(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    printf("ptree: init process not found\n");
    8000211e:	00005517          	auipc	a0,0x5
    80002122:	2d250513          	addi	a0,a0,722 # 800073f0 <etext+0x3f0>
    80002126:	2c8030ef          	jal	800053ee <printf>
    return -1;
    8000212a:	557d                	li	a0,-1
    8000212c:	b7d5                	j	80002110 <sys_ptree+0x50>

000000008000212e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	e84a                	sd	s2,16(sp)
    80002138:	e44e                	sd	s3,8(sp)
    8000213a:	e052                	sd	s4,0(sp)
    8000213c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000213e:	00005597          	auipc	a1,0x5
    80002142:	2d258593          	addi	a1,a1,722 # 80007410 <etext+0x410>
    80002146:	0000e517          	auipc	a0,0xe
    8000214a:	0d250513          	addi	a0,a0,210 # 80010218 <bcache>
    8000214e:	065030ef          	jal	800059b2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002152:	00016797          	auipc	a5,0x16
    80002156:	0c678793          	addi	a5,a5,198 # 80018218 <bcache+0x8000>
    8000215a:	00016717          	auipc	a4,0x16
    8000215e:	32670713          	addi	a4,a4,806 # 80018480 <bcache+0x8268>
    80002162:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002166:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000216a:	0000e497          	auipc	s1,0xe
    8000216e:	0c648493          	addi	s1,s1,198 # 80010230 <bcache+0x18>
    b->next = bcache.head.next;
    80002172:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002174:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002176:	00005a17          	auipc	s4,0x5
    8000217a:	2a2a0a13          	addi	s4,s4,674 # 80007418 <etext+0x418>
    b->next = bcache.head.next;
    8000217e:	2b893783          	ld	a5,696(s2)
    80002182:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002184:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002188:	85d2                	mv	a1,s4
    8000218a:	01048513          	addi	a0,s1,16
    8000218e:	24c010ef          	jal	800033da <initsleeplock>
    bcache.head.next->prev = b;
    80002192:	2b893783          	ld	a5,696(s2)
    80002196:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002198:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000219c:	45848493          	addi	s1,s1,1112
    800021a0:	fd349fe3          	bne	s1,s3,8000217e <binit+0x50>
  }
}
    800021a4:	70a2                	ld	ra,40(sp)
    800021a6:	7402                	ld	s0,32(sp)
    800021a8:	64e2                	ld	s1,24(sp)
    800021aa:	6942                	ld	s2,16(sp)
    800021ac:	69a2                	ld	s3,8(sp)
    800021ae:	6a02                	ld	s4,0(sp)
    800021b0:	6145                	addi	sp,sp,48
    800021b2:	8082                	ret

00000000800021b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800021b4:	7179                	addi	sp,sp,-48
    800021b6:	f406                	sd	ra,40(sp)
    800021b8:	f022                	sd	s0,32(sp)
    800021ba:	ec26                	sd	s1,24(sp)
    800021bc:	e84a                	sd	s2,16(sp)
    800021be:	e44e                	sd	s3,8(sp)
    800021c0:	1800                	addi	s0,sp,48
    800021c2:	892a                	mv	s2,a0
    800021c4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800021c6:	0000e517          	auipc	a0,0xe
    800021ca:	05250513          	addi	a0,a0,82 # 80010218 <bcache>
    800021ce:	06f030ef          	jal	80005a3c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800021d2:	00016497          	auipc	s1,0x16
    800021d6:	2fe4b483          	ld	s1,766(s1) # 800184d0 <bcache+0x82b8>
    800021da:	00016797          	auipc	a5,0x16
    800021de:	2a678793          	addi	a5,a5,678 # 80018480 <bcache+0x8268>
    800021e2:	02f48b63          	beq	s1,a5,80002218 <bread+0x64>
    800021e6:	873e                	mv	a4,a5
    800021e8:	a021                	j	800021f0 <bread+0x3c>
    800021ea:	68a4                	ld	s1,80(s1)
    800021ec:	02e48663          	beq	s1,a4,80002218 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800021f0:	449c                	lw	a5,8(s1)
    800021f2:	ff279ce3          	bne	a5,s2,800021ea <bread+0x36>
    800021f6:	44dc                	lw	a5,12(s1)
    800021f8:	ff3799e3          	bne	a5,s3,800021ea <bread+0x36>
      b->refcnt++;
    800021fc:	40bc                	lw	a5,64(s1)
    800021fe:	2785                	addiw	a5,a5,1
    80002200:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002202:	0000e517          	auipc	a0,0xe
    80002206:	01650513          	addi	a0,a0,22 # 80010218 <bcache>
    8000220a:	0c7030ef          	jal	80005ad0 <release>
      acquiresleep(&b->lock);
    8000220e:	01048513          	addi	a0,s1,16
    80002212:	1fe010ef          	jal	80003410 <acquiresleep>
      return b;
    80002216:	a889                	j	80002268 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002218:	00016497          	auipc	s1,0x16
    8000221c:	2b04b483          	ld	s1,688(s1) # 800184c8 <bcache+0x82b0>
    80002220:	00016797          	auipc	a5,0x16
    80002224:	26078793          	addi	a5,a5,608 # 80018480 <bcache+0x8268>
    80002228:	00f48863          	beq	s1,a5,80002238 <bread+0x84>
    8000222c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000222e:	40bc                	lw	a5,64(s1)
    80002230:	cb91                	beqz	a5,80002244 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002232:	64a4                	ld	s1,72(s1)
    80002234:	fee49de3          	bne	s1,a4,8000222e <bread+0x7a>
  panic("bget: no buffers");
    80002238:	00005517          	auipc	a0,0x5
    8000223c:	1e850513          	addi	a0,a0,488 # 80007420 <etext+0x420>
    80002240:	4be030ef          	jal	800056fe <panic>
      b->dev = dev;
    80002244:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002248:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000224c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002250:	4785                	li	a5,1
    80002252:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002254:	0000e517          	auipc	a0,0xe
    80002258:	fc450513          	addi	a0,a0,-60 # 80010218 <bcache>
    8000225c:	075030ef          	jal	80005ad0 <release>
      acquiresleep(&b->lock);
    80002260:	01048513          	addi	a0,s1,16
    80002264:	1ac010ef          	jal	80003410 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002268:	409c                	lw	a5,0(s1)
    8000226a:	cb89                	beqz	a5,8000227c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000226c:	8526                	mv	a0,s1
    8000226e:	70a2                	ld	ra,40(sp)
    80002270:	7402                	ld	s0,32(sp)
    80002272:	64e2                	ld	s1,24(sp)
    80002274:	6942                	ld	s2,16(sp)
    80002276:	69a2                	ld	s3,8(sp)
    80002278:	6145                	addi	sp,sp,48
    8000227a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000227c:	4581                	li	a1,0
    8000227e:	8526                	mv	a0,s1
    80002280:	201020ef          	jal	80004c80 <virtio_disk_rw>
    b->valid = 1;
    80002284:	4785                	li	a5,1
    80002286:	c09c                	sw	a5,0(s1)
  return b;
    80002288:	b7d5                	j	8000226c <bread+0xb8>

000000008000228a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	e426                	sd	s1,8(sp)
    80002292:	1000                	addi	s0,sp,32
    80002294:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002296:	0541                	addi	a0,a0,16
    80002298:	1f6010ef          	jal	8000348e <holdingsleep>
    8000229c:	c911                	beqz	a0,800022b0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000229e:	4585                	li	a1,1
    800022a0:	8526                	mv	a0,s1
    800022a2:	1df020ef          	jal	80004c80 <virtio_disk_rw>
}
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	64a2                	ld	s1,8(sp)
    800022ac:	6105                	addi	sp,sp,32
    800022ae:	8082                	ret
    panic("bwrite");
    800022b0:	00005517          	auipc	a0,0x5
    800022b4:	18850513          	addi	a0,a0,392 # 80007438 <etext+0x438>
    800022b8:	446030ef          	jal	800056fe <panic>

00000000800022bc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	e04a                	sd	s2,0(sp)
    800022c6:	1000                	addi	s0,sp,32
    800022c8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800022ca:	01050913          	addi	s2,a0,16
    800022ce:	854a                	mv	a0,s2
    800022d0:	1be010ef          	jal	8000348e <holdingsleep>
    800022d4:	c125                	beqz	a0,80002334 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800022d6:	854a                	mv	a0,s2
    800022d8:	17e010ef          	jal	80003456 <releasesleep>

  acquire(&bcache.lock);
    800022dc:	0000e517          	auipc	a0,0xe
    800022e0:	f3c50513          	addi	a0,a0,-196 # 80010218 <bcache>
    800022e4:	758030ef          	jal	80005a3c <acquire>
  b->refcnt--;
    800022e8:	40bc                	lw	a5,64(s1)
    800022ea:	37fd                	addiw	a5,a5,-1
    800022ec:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800022ee:	e79d                	bnez	a5,8000231c <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800022f0:	68b8                	ld	a4,80(s1)
    800022f2:	64bc                	ld	a5,72(s1)
    800022f4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800022f6:	68b8                	ld	a4,80(s1)
    800022f8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800022fa:	00016797          	auipc	a5,0x16
    800022fe:	f1e78793          	addi	a5,a5,-226 # 80018218 <bcache+0x8000>
    80002302:	2b87b703          	ld	a4,696(a5)
    80002306:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002308:	00016717          	auipc	a4,0x16
    8000230c:	17870713          	addi	a4,a4,376 # 80018480 <bcache+0x8268>
    80002310:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002312:	2b87b703          	ld	a4,696(a5)
    80002316:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002318:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000231c:	0000e517          	auipc	a0,0xe
    80002320:	efc50513          	addi	a0,a0,-260 # 80010218 <bcache>
    80002324:	7ac030ef          	jal	80005ad0 <release>
}
    80002328:	60e2                	ld	ra,24(sp)
    8000232a:	6442                	ld	s0,16(sp)
    8000232c:	64a2                	ld	s1,8(sp)
    8000232e:	6902                	ld	s2,0(sp)
    80002330:	6105                	addi	sp,sp,32
    80002332:	8082                	ret
    panic("brelse");
    80002334:	00005517          	auipc	a0,0x5
    80002338:	10c50513          	addi	a0,a0,268 # 80007440 <etext+0x440>
    8000233c:	3c2030ef          	jal	800056fe <panic>

0000000080002340 <bpin>:

void
bpin(struct buf *b) {
    80002340:	1101                	addi	sp,sp,-32
    80002342:	ec06                	sd	ra,24(sp)
    80002344:	e822                	sd	s0,16(sp)
    80002346:	e426                	sd	s1,8(sp)
    80002348:	1000                	addi	s0,sp,32
    8000234a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000234c:	0000e517          	auipc	a0,0xe
    80002350:	ecc50513          	addi	a0,a0,-308 # 80010218 <bcache>
    80002354:	6e8030ef          	jal	80005a3c <acquire>
  b->refcnt++;
    80002358:	40bc                	lw	a5,64(s1)
    8000235a:	2785                	addiw	a5,a5,1
    8000235c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000235e:	0000e517          	auipc	a0,0xe
    80002362:	eba50513          	addi	a0,a0,-326 # 80010218 <bcache>
    80002366:	76a030ef          	jal	80005ad0 <release>
}
    8000236a:	60e2                	ld	ra,24(sp)
    8000236c:	6442                	ld	s0,16(sp)
    8000236e:	64a2                	ld	s1,8(sp)
    80002370:	6105                	addi	sp,sp,32
    80002372:	8082                	ret

0000000080002374 <bunpin>:

void
bunpin(struct buf *b) {
    80002374:	1101                	addi	sp,sp,-32
    80002376:	ec06                	sd	ra,24(sp)
    80002378:	e822                	sd	s0,16(sp)
    8000237a:	e426                	sd	s1,8(sp)
    8000237c:	1000                	addi	s0,sp,32
    8000237e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002380:	0000e517          	auipc	a0,0xe
    80002384:	e9850513          	addi	a0,a0,-360 # 80010218 <bcache>
    80002388:	6b4030ef          	jal	80005a3c <acquire>
  b->refcnt--;
    8000238c:	40bc                	lw	a5,64(s1)
    8000238e:	37fd                	addiw	a5,a5,-1
    80002390:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002392:	0000e517          	auipc	a0,0xe
    80002396:	e8650513          	addi	a0,a0,-378 # 80010218 <bcache>
    8000239a:	736030ef          	jal	80005ad0 <release>
}
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	64a2                	ld	s1,8(sp)
    800023a4:	6105                	addi	sp,sp,32
    800023a6:	8082                	ret

00000000800023a8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800023a8:	1101                	addi	sp,sp,-32
    800023aa:	ec06                	sd	ra,24(sp)
    800023ac:	e822                	sd	s0,16(sp)
    800023ae:	e426                	sd	s1,8(sp)
    800023b0:	e04a                	sd	s2,0(sp)
    800023b2:	1000                	addi	s0,sp,32
    800023b4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800023b6:	00d5d79b          	srliw	a5,a1,0xd
    800023ba:	00016597          	auipc	a1,0x16
    800023be:	53a5a583          	lw	a1,1338(a1) # 800188f4 <sb+0x1c>
    800023c2:	9dbd                	addw	a1,a1,a5
    800023c4:	df1ff0ef          	jal	800021b4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800023c8:	0074f713          	andi	a4,s1,7
    800023cc:	4785                	li	a5,1
    800023ce:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800023d2:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800023d4:	90d9                	srli	s1,s1,0x36
    800023d6:	00950733          	add	a4,a0,s1
    800023da:	05874703          	lbu	a4,88(a4)
    800023de:	00e7f6b3          	and	a3,a5,a4
    800023e2:	c29d                	beqz	a3,80002408 <bfree+0x60>
    800023e4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800023e6:	94aa                	add	s1,s1,a0
    800023e8:	fff7c793          	not	a5,a5
    800023ec:	8f7d                	and	a4,a4,a5
    800023ee:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800023f2:	717000ef          	jal	80003308 <log_write>
  brelse(bp);
    800023f6:	854a                	mv	a0,s2
    800023f8:	ec5ff0ef          	jal	800022bc <brelse>
}
    800023fc:	60e2                	ld	ra,24(sp)
    800023fe:	6442                	ld	s0,16(sp)
    80002400:	64a2                	ld	s1,8(sp)
    80002402:	6902                	ld	s2,0(sp)
    80002404:	6105                	addi	sp,sp,32
    80002406:	8082                	ret
    panic("freeing free block");
    80002408:	00005517          	auipc	a0,0x5
    8000240c:	04050513          	addi	a0,a0,64 # 80007448 <etext+0x448>
    80002410:	2ee030ef          	jal	800056fe <panic>

0000000080002414 <balloc>:
{
    80002414:	715d                	addi	sp,sp,-80
    80002416:	e486                	sd	ra,72(sp)
    80002418:	e0a2                	sd	s0,64(sp)
    8000241a:	fc26                	sd	s1,56(sp)
    8000241c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000241e:	00016797          	auipc	a5,0x16
    80002422:	4be7a783          	lw	a5,1214(a5) # 800188dc <sb+0x4>
    80002426:	0e078263          	beqz	a5,8000250a <balloc+0xf6>
    8000242a:	f84a                	sd	s2,48(sp)
    8000242c:	f44e                	sd	s3,40(sp)
    8000242e:	f052                	sd	s4,32(sp)
    80002430:	ec56                	sd	s5,24(sp)
    80002432:	e85a                	sd	s6,16(sp)
    80002434:	e45e                	sd	s7,8(sp)
    80002436:	e062                	sd	s8,0(sp)
    80002438:	8baa                	mv	s7,a0
    8000243a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000243c:	00016b17          	auipc	s6,0x16
    80002440:	49cb0b13          	addi	s6,s6,1180 # 800188d8 <sb>
      m = 1 << (bi % 8);
    80002444:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002446:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002448:	6c09                	lui	s8,0x2
    8000244a:	a09d                	j	800024b0 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000244c:	97ca                	add	a5,a5,s2
    8000244e:	8e55                	or	a2,a2,a3
    80002450:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002454:	854a                	mv	a0,s2
    80002456:	6b3000ef          	jal	80003308 <log_write>
        brelse(bp);
    8000245a:	854a                	mv	a0,s2
    8000245c:	e61ff0ef          	jal	800022bc <brelse>
  bp = bread(dev, bno);
    80002460:	85a6                	mv	a1,s1
    80002462:	855e                	mv	a0,s7
    80002464:	d51ff0ef          	jal	800021b4 <bread>
    80002468:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000246a:	40000613          	li	a2,1024
    8000246e:	4581                	li	a1,0
    80002470:	05850513          	addi	a0,a0,88
    80002474:	cebfd0ef          	jal	8000015e <memset>
  log_write(bp);
    80002478:	854a                	mv	a0,s2
    8000247a:	68f000ef          	jal	80003308 <log_write>
  brelse(bp);
    8000247e:	854a                	mv	a0,s2
    80002480:	e3dff0ef          	jal	800022bc <brelse>
}
    80002484:	7942                	ld	s2,48(sp)
    80002486:	79a2                	ld	s3,40(sp)
    80002488:	7a02                	ld	s4,32(sp)
    8000248a:	6ae2                	ld	s5,24(sp)
    8000248c:	6b42                	ld	s6,16(sp)
    8000248e:	6ba2                	ld	s7,8(sp)
    80002490:	6c02                	ld	s8,0(sp)
}
    80002492:	8526                	mv	a0,s1
    80002494:	60a6                	ld	ra,72(sp)
    80002496:	6406                	ld	s0,64(sp)
    80002498:	74e2                	ld	s1,56(sp)
    8000249a:	6161                	addi	sp,sp,80
    8000249c:	8082                	ret
    brelse(bp);
    8000249e:	854a                	mv	a0,s2
    800024a0:	e1dff0ef          	jal	800022bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800024a4:	015c0abb          	addw	s5,s8,s5
    800024a8:	004b2783          	lw	a5,4(s6)
    800024ac:	04faf863          	bgeu	s5,a5,800024fc <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800024b0:	40dad59b          	sraiw	a1,s5,0xd
    800024b4:	01cb2783          	lw	a5,28(s6)
    800024b8:	9dbd                	addw	a1,a1,a5
    800024ba:	855e                	mv	a0,s7
    800024bc:	cf9ff0ef          	jal	800021b4 <bread>
    800024c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c2:	004b2503          	lw	a0,4(s6)
    800024c6:	84d6                	mv	s1,s5
    800024c8:	4701                	li	a4,0
    800024ca:	fca4fae3          	bgeu	s1,a0,8000249e <balloc+0x8a>
      m = 1 << (bi % 8);
    800024ce:	00777693          	andi	a3,a4,7
    800024d2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800024d6:	41f7579b          	sraiw	a5,a4,0x1f
    800024da:	01d7d79b          	srliw	a5,a5,0x1d
    800024de:	9fb9                	addw	a5,a5,a4
    800024e0:	4037d79b          	sraiw	a5,a5,0x3
    800024e4:	00f90633          	add	a2,s2,a5
    800024e8:	05864603          	lbu	a2,88(a2)
    800024ec:	00c6f5b3          	and	a1,a3,a2
    800024f0:	ddb1                	beqz	a1,8000244c <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024f2:	2705                	addiw	a4,a4,1
    800024f4:	2485                	addiw	s1,s1,1
    800024f6:	fd471ae3          	bne	a4,s4,800024ca <balloc+0xb6>
    800024fa:	b755                	j	8000249e <balloc+0x8a>
    800024fc:	7942                	ld	s2,48(sp)
    800024fe:	79a2                	ld	s3,40(sp)
    80002500:	7a02                	ld	s4,32(sp)
    80002502:	6ae2                	ld	s5,24(sp)
    80002504:	6b42                	ld	s6,16(sp)
    80002506:	6ba2                	ld	s7,8(sp)
    80002508:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000250a:	00005517          	auipc	a0,0x5
    8000250e:	f5650513          	addi	a0,a0,-170 # 80007460 <etext+0x460>
    80002512:	6dd020ef          	jal	800053ee <printf>
  return 0;
    80002516:	4481                	li	s1,0
    80002518:	bfad                	j	80002492 <balloc+0x7e>

000000008000251a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000251a:	7179                	addi	sp,sp,-48
    8000251c:	f406                	sd	ra,40(sp)
    8000251e:	f022                	sd	s0,32(sp)
    80002520:	ec26                	sd	s1,24(sp)
    80002522:	e84a                	sd	s2,16(sp)
    80002524:	e44e                	sd	s3,8(sp)
    80002526:	1800                	addi	s0,sp,48
    80002528:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000252a:	47ad                	li	a5,11
    8000252c:	02b7e363          	bltu	a5,a1,80002552 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002530:	02059793          	slli	a5,a1,0x20
    80002534:	01e7d593          	srli	a1,a5,0x1e
    80002538:	00b509b3          	add	s3,a0,a1
    8000253c:	0509a483          	lw	s1,80(s3)
    80002540:	e0b5                	bnez	s1,800025a4 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002542:	4108                	lw	a0,0(a0)
    80002544:	ed1ff0ef          	jal	80002414 <balloc>
    80002548:	84aa                	mv	s1,a0
      if(addr == 0)
    8000254a:	cd29                	beqz	a0,800025a4 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000254c:	04a9a823          	sw	a0,80(s3)
    80002550:	a891                	j	800025a4 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002552:	ff45879b          	addiw	a5,a1,-12
    80002556:	873e                	mv	a4,a5
    80002558:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000255a:	0ff00793          	li	a5,255
    8000255e:	06e7e763          	bltu	a5,a4,800025cc <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002562:	08052483          	lw	s1,128(a0)
    80002566:	e891                	bnez	s1,8000257a <bmap+0x60>
      addr = balloc(ip->dev);
    80002568:	4108                	lw	a0,0(a0)
    8000256a:	eabff0ef          	jal	80002414 <balloc>
    8000256e:	84aa                	mv	s1,a0
      if(addr == 0)
    80002570:	c915                	beqz	a0,800025a4 <bmap+0x8a>
    80002572:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002574:	08a92023          	sw	a0,128(s2)
    80002578:	a011                	j	8000257c <bmap+0x62>
    8000257a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000257c:	85a6                	mv	a1,s1
    8000257e:	00092503          	lw	a0,0(s2)
    80002582:	c33ff0ef          	jal	800021b4 <bread>
    80002586:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002588:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000258c:	02099713          	slli	a4,s3,0x20
    80002590:	01e75593          	srli	a1,a4,0x1e
    80002594:	97ae                	add	a5,a5,a1
    80002596:	89be                	mv	s3,a5
    80002598:	4384                	lw	s1,0(a5)
    8000259a:	cc89                	beqz	s1,800025b4 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000259c:	8552                	mv	a0,s4
    8000259e:	d1fff0ef          	jal	800022bc <brelse>
    return addr;
    800025a2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800025a4:	8526                	mv	a0,s1
    800025a6:	70a2                	ld	ra,40(sp)
    800025a8:	7402                	ld	s0,32(sp)
    800025aa:	64e2                	ld	s1,24(sp)
    800025ac:	6942                	ld	s2,16(sp)
    800025ae:	69a2                	ld	s3,8(sp)
    800025b0:	6145                	addi	sp,sp,48
    800025b2:	8082                	ret
      addr = balloc(ip->dev);
    800025b4:	00092503          	lw	a0,0(s2)
    800025b8:	e5dff0ef          	jal	80002414 <balloc>
    800025bc:	84aa                	mv	s1,a0
      if(addr){
    800025be:	dd79                	beqz	a0,8000259c <bmap+0x82>
        a[bn] = addr;
    800025c0:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800025c4:	8552                	mv	a0,s4
    800025c6:	543000ef          	jal	80003308 <log_write>
    800025ca:	bfc9                	j	8000259c <bmap+0x82>
    800025cc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800025ce:	00005517          	auipc	a0,0x5
    800025d2:	eaa50513          	addi	a0,a0,-342 # 80007478 <etext+0x478>
    800025d6:	128030ef          	jal	800056fe <panic>

00000000800025da <iget>:
{
    800025da:	7179                	addi	sp,sp,-48
    800025dc:	f406                	sd	ra,40(sp)
    800025de:	f022                	sd	s0,32(sp)
    800025e0:	ec26                	sd	s1,24(sp)
    800025e2:	e84a                	sd	s2,16(sp)
    800025e4:	e44e                	sd	s3,8(sp)
    800025e6:	e052                	sd	s4,0(sp)
    800025e8:	1800                	addi	s0,sp,48
    800025ea:	892a                	mv	s2,a0
    800025ec:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800025ee:	00016517          	auipc	a0,0x16
    800025f2:	30a50513          	addi	a0,a0,778 # 800188f8 <itable>
    800025f6:	446030ef          	jal	80005a3c <acquire>
  empty = 0;
    800025fa:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800025fc:	00016497          	auipc	s1,0x16
    80002600:	31448493          	addi	s1,s1,788 # 80018910 <itable+0x18>
    80002604:	00018697          	auipc	a3,0x18
    80002608:	d9c68693          	addi	a3,a3,-612 # 8001a3a0 <log>
    8000260c:	a809                	j	8000261e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000260e:	e781                	bnez	a5,80002616 <iget+0x3c>
    80002610:	00099363          	bnez	s3,80002616 <iget+0x3c>
      empty = ip;
    80002614:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002616:	08848493          	addi	s1,s1,136
    8000261a:	02d48563          	beq	s1,a3,80002644 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000261e:	449c                	lw	a5,8(s1)
    80002620:	fef057e3          	blez	a5,8000260e <iget+0x34>
    80002624:	4098                	lw	a4,0(s1)
    80002626:	ff2718e3          	bne	a4,s2,80002616 <iget+0x3c>
    8000262a:	40d8                	lw	a4,4(s1)
    8000262c:	ff4715e3          	bne	a4,s4,80002616 <iget+0x3c>
      ip->ref++;
    80002630:	2785                	addiw	a5,a5,1
    80002632:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002634:	00016517          	auipc	a0,0x16
    80002638:	2c450513          	addi	a0,a0,708 # 800188f8 <itable>
    8000263c:	494030ef          	jal	80005ad0 <release>
      return ip;
    80002640:	89a6                	mv	s3,s1
    80002642:	a015                	j	80002666 <iget+0x8c>
  if(empty == 0)
    80002644:	02098a63          	beqz	s3,80002678 <iget+0x9e>
  ip->dev = dev;
    80002648:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000264c:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002650:	4785                	li	a5,1
    80002652:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002656:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000265a:	00016517          	auipc	a0,0x16
    8000265e:	29e50513          	addi	a0,a0,670 # 800188f8 <itable>
    80002662:	46e030ef          	jal	80005ad0 <release>
}
    80002666:	854e                	mv	a0,s3
    80002668:	70a2                	ld	ra,40(sp)
    8000266a:	7402                	ld	s0,32(sp)
    8000266c:	64e2                	ld	s1,24(sp)
    8000266e:	6942                	ld	s2,16(sp)
    80002670:	69a2                	ld	s3,8(sp)
    80002672:	6a02                	ld	s4,0(sp)
    80002674:	6145                	addi	sp,sp,48
    80002676:	8082                	ret
    panic("iget: no inodes");
    80002678:	00005517          	auipc	a0,0x5
    8000267c:	e1850513          	addi	a0,a0,-488 # 80007490 <etext+0x490>
    80002680:	07e030ef          	jal	800056fe <panic>

0000000080002684 <fsinit>:
fsinit(int dev) {
    80002684:	1101                	addi	sp,sp,-32
    80002686:	ec06                	sd	ra,24(sp)
    80002688:	e822                	sd	s0,16(sp)
    8000268a:	e426                	sd	s1,8(sp)
    8000268c:	e04a                	sd	s2,0(sp)
    8000268e:	1000                	addi	s0,sp,32
    80002690:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002692:	4585                	li	a1,1
    80002694:	b21ff0ef          	jal	800021b4 <bread>
    80002698:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000269a:	02000613          	li	a2,32
    8000269e:	05850593          	addi	a1,a0,88
    800026a2:	00016517          	auipc	a0,0x16
    800026a6:	23650513          	addi	a0,a0,566 # 800188d8 <sb>
    800026aa:	b15fd0ef          	jal	800001be <memmove>
  brelse(bp);
    800026ae:	8526                	mv	a0,s1
    800026b0:	c0dff0ef          	jal	800022bc <brelse>
  if(sb.magic != FSMAGIC)
    800026b4:	00016717          	auipc	a4,0x16
    800026b8:	22472703          	lw	a4,548(a4) # 800188d8 <sb>
    800026bc:	102037b7          	lui	a5,0x10203
    800026c0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800026c4:	00f71f63          	bne	a4,a5,800026e2 <fsinit+0x5e>
  initlog(dev, &sb);
    800026c8:	00016597          	auipc	a1,0x16
    800026cc:	21058593          	addi	a1,a1,528 # 800188d8 <sb>
    800026d0:	854a                	mv	a0,s2
    800026d2:	219000ef          	jal	800030ea <initlog>
}
    800026d6:	60e2                	ld	ra,24(sp)
    800026d8:	6442                	ld	s0,16(sp)
    800026da:	64a2                	ld	s1,8(sp)
    800026dc:	6902                	ld	s2,0(sp)
    800026de:	6105                	addi	sp,sp,32
    800026e0:	8082                	ret
    panic("invalid file system");
    800026e2:	00005517          	auipc	a0,0x5
    800026e6:	dbe50513          	addi	a0,a0,-578 # 800074a0 <etext+0x4a0>
    800026ea:	014030ef          	jal	800056fe <panic>

00000000800026ee <iinit>:
{
    800026ee:	7179                	addi	sp,sp,-48
    800026f0:	f406                	sd	ra,40(sp)
    800026f2:	f022                	sd	s0,32(sp)
    800026f4:	ec26                	sd	s1,24(sp)
    800026f6:	e84a                	sd	s2,16(sp)
    800026f8:	e44e                	sd	s3,8(sp)
    800026fa:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800026fc:	00005597          	auipc	a1,0x5
    80002700:	dbc58593          	addi	a1,a1,-580 # 800074b8 <etext+0x4b8>
    80002704:	00016517          	auipc	a0,0x16
    80002708:	1f450513          	addi	a0,a0,500 # 800188f8 <itable>
    8000270c:	2a6030ef          	jal	800059b2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002710:	00016497          	auipc	s1,0x16
    80002714:	21048493          	addi	s1,s1,528 # 80018920 <itable+0x28>
    80002718:	00018997          	auipc	s3,0x18
    8000271c:	c9898993          	addi	s3,s3,-872 # 8001a3b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002720:	00005917          	auipc	s2,0x5
    80002724:	da090913          	addi	s2,s2,-608 # 800074c0 <etext+0x4c0>
    80002728:	85ca                	mv	a1,s2
    8000272a:	8526                	mv	a0,s1
    8000272c:	4af000ef          	jal	800033da <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002730:	08848493          	addi	s1,s1,136
    80002734:	ff349ae3          	bne	s1,s3,80002728 <iinit+0x3a>
}
    80002738:	70a2                	ld	ra,40(sp)
    8000273a:	7402                	ld	s0,32(sp)
    8000273c:	64e2                	ld	s1,24(sp)
    8000273e:	6942                	ld	s2,16(sp)
    80002740:	69a2                	ld	s3,8(sp)
    80002742:	6145                	addi	sp,sp,48
    80002744:	8082                	ret

0000000080002746 <ialloc>:
{
    80002746:	7139                	addi	sp,sp,-64
    80002748:	fc06                	sd	ra,56(sp)
    8000274a:	f822                	sd	s0,48(sp)
    8000274c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000274e:	00016717          	auipc	a4,0x16
    80002752:	19672703          	lw	a4,406(a4) # 800188e4 <sb+0xc>
    80002756:	4785                	li	a5,1
    80002758:	06e7f063          	bgeu	a5,a4,800027b8 <ialloc+0x72>
    8000275c:	f426                	sd	s1,40(sp)
    8000275e:	f04a                	sd	s2,32(sp)
    80002760:	ec4e                	sd	s3,24(sp)
    80002762:	e852                	sd	s4,16(sp)
    80002764:	e456                	sd	s5,8(sp)
    80002766:	e05a                	sd	s6,0(sp)
    80002768:	8aaa                	mv	s5,a0
    8000276a:	8b2e                	mv	s6,a1
    8000276c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000276e:	00016a17          	auipc	s4,0x16
    80002772:	16aa0a13          	addi	s4,s4,362 # 800188d8 <sb>
    80002776:	00495593          	srli	a1,s2,0x4
    8000277a:	018a2783          	lw	a5,24(s4)
    8000277e:	9dbd                	addw	a1,a1,a5
    80002780:	8556                	mv	a0,s5
    80002782:	a33ff0ef          	jal	800021b4 <bread>
    80002786:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002788:	05850993          	addi	s3,a0,88
    8000278c:	00f97793          	andi	a5,s2,15
    80002790:	079a                	slli	a5,a5,0x6
    80002792:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002794:	00099783          	lh	a5,0(s3)
    80002798:	cb9d                	beqz	a5,800027ce <ialloc+0x88>
    brelse(bp);
    8000279a:	b23ff0ef          	jal	800022bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000279e:	0905                	addi	s2,s2,1
    800027a0:	00ca2703          	lw	a4,12(s4)
    800027a4:	0009079b          	sext.w	a5,s2
    800027a8:	fce7e7e3          	bltu	a5,a4,80002776 <ialloc+0x30>
    800027ac:	74a2                	ld	s1,40(sp)
    800027ae:	7902                	ld	s2,32(sp)
    800027b0:	69e2                	ld	s3,24(sp)
    800027b2:	6a42                	ld	s4,16(sp)
    800027b4:	6aa2                	ld	s5,8(sp)
    800027b6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800027b8:	00005517          	auipc	a0,0x5
    800027bc:	d1050513          	addi	a0,a0,-752 # 800074c8 <etext+0x4c8>
    800027c0:	42f020ef          	jal	800053ee <printf>
  return 0;
    800027c4:	4501                	li	a0,0
}
    800027c6:	70e2                	ld	ra,56(sp)
    800027c8:	7442                	ld	s0,48(sp)
    800027ca:	6121                	addi	sp,sp,64
    800027cc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800027ce:	04000613          	li	a2,64
    800027d2:	4581                	li	a1,0
    800027d4:	854e                	mv	a0,s3
    800027d6:	989fd0ef          	jal	8000015e <memset>
      dip->type = type;
    800027da:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800027de:	8526                	mv	a0,s1
    800027e0:	329000ef          	jal	80003308 <log_write>
      brelse(bp);
    800027e4:	8526                	mv	a0,s1
    800027e6:	ad7ff0ef          	jal	800022bc <brelse>
      return iget(dev, inum);
    800027ea:	0009059b          	sext.w	a1,s2
    800027ee:	8556                	mv	a0,s5
    800027f0:	debff0ef          	jal	800025da <iget>
    800027f4:	74a2                	ld	s1,40(sp)
    800027f6:	7902                	ld	s2,32(sp)
    800027f8:	69e2                	ld	s3,24(sp)
    800027fa:	6a42                	ld	s4,16(sp)
    800027fc:	6aa2                	ld	s5,8(sp)
    800027fe:	6b02                	ld	s6,0(sp)
    80002800:	b7d9                	j	800027c6 <ialloc+0x80>

0000000080002802 <iupdate>:
{
    80002802:	1101                	addi	sp,sp,-32
    80002804:	ec06                	sd	ra,24(sp)
    80002806:	e822                	sd	s0,16(sp)
    80002808:	e426                	sd	s1,8(sp)
    8000280a:	e04a                	sd	s2,0(sp)
    8000280c:	1000                	addi	s0,sp,32
    8000280e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002810:	415c                	lw	a5,4(a0)
    80002812:	0047d79b          	srliw	a5,a5,0x4
    80002816:	00016597          	auipc	a1,0x16
    8000281a:	0da5a583          	lw	a1,218(a1) # 800188f0 <sb+0x18>
    8000281e:	9dbd                	addw	a1,a1,a5
    80002820:	4108                	lw	a0,0(a0)
    80002822:	993ff0ef          	jal	800021b4 <bread>
    80002826:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002828:	05850793          	addi	a5,a0,88
    8000282c:	40d8                	lw	a4,4(s1)
    8000282e:	8b3d                	andi	a4,a4,15
    80002830:	071a                	slli	a4,a4,0x6
    80002832:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002834:	04449703          	lh	a4,68(s1)
    80002838:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000283c:	04649703          	lh	a4,70(s1)
    80002840:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002844:	04849703          	lh	a4,72(s1)
    80002848:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000284c:	04a49703          	lh	a4,74(s1)
    80002850:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002854:	44f8                	lw	a4,76(s1)
    80002856:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002858:	03400613          	li	a2,52
    8000285c:	05048593          	addi	a1,s1,80
    80002860:	00c78513          	addi	a0,a5,12
    80002864:	95bfd0ef          	jal	800001be <memmove>
  log_write(bp);
    80002868:	854a                	mv	a0,s2
    8000286a:	29f000ef          	jal	80003308 <log_write>
  brelse(bp);
    8000286e:	854a                	mv	a0,s2
    80002870:	a4dff0ef          	jal	800022bc <brelse>
}
    80002874:	60e2                	ld	ra,24(sp)
    80002876:	6442                	ld	s0,16(sp)
    80002878:	64a2                	ld	s1,8(sp)
    8000287a:	6902                	ld	s2,0(sp)
    8000287c:	6105                	addi	sp,sp,32
    8000287e:	8082                	ret

0000000080002880 <idup>:
{
    80002880:	1101                	addi	sp,sp,-32
    80002882:	ec06                	sd	ra,24(sp)
    80002884:	e822                	sd	s0,16(sp)
    80002886:	e426                	sd	s1,8(sp)
    80002888:	1000                	addi	s0,sp,32
    8000288a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000288c:	00016517          	auipc	a0,0x16
    80002890:	06c50513          	addi	a0,a0,108 # 800188f8 <itable>
    80002894:	1a8030ef          	jal	80005a3c <acquire>
  ip->ref++;
    80002898:	449c                	lw	a5,8(s1)
    8000289a:	2785                	addiw	a5,a5,1
    8000289c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000289e:	00016517          	auipc	a0,0x16
    800028a2:	05a50513          	addi	a0,a0,90 # 800188f8 <itable>
    800028a6:	22a030ef          	jal	80005ad0 <release>
}
    800028aa:	8526                	mv	a0,s1
    800028ac:	60e2                	ld	ra,24(sp)
    800028ae:	6442                	ld	s0,16(sp)
    800028b0:	64a2                	ld	s1,8(sp)
    800028b2:	6105                	addi	sp,sp,32
    800028b4:	8082                	ret

00000000800028b6 <ilock>:
{
    800028b6:	1101                	addi	sp,sp,-32
    800028b8:	ec06                	sd	ra,24(sp)
    800028ba:	e822                	sd	s0,16(sp)
    800028bc:	e426                	sd	s1,8(sp)
    800028be:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800028c0:	cd19                	beqz	a0,800028de <ilock+0x28>
    800028c2:	84aa                	mv	s1,a0
    800028c4:	451c                	lw	a5,8(a0)
    800028c6:	00f05c63          	blez	a5,800028de <ilock+0x28>
  acquiresleep(&ip->lock);
    800028ca:	0541                	addi	a0,a0,16
    800028cc:	345000ef          	jal	80003410 <acquiresleep>
  if(ip->valid == 0){
    800028d0:	40bc                	lw	a5,64(s1)
    800028d2:	cf89                	beqz	a5,800028ec <ilock+0x36>
}
    800028d4:	60e2                	ld	ra,24(sp)
    800028d6:	6442                	ld	s0,16(sp)
    800028d8:	64a2                	ld	s1,8(sp)
    800028da:	6105                	addi	sp,sp,32
    800028dc:	8082                	ret
    800028de:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800028e0:	00005517          	auipc	a0,0x5
    800028e4:	c0050513          	addi	a0,a0,-1024 # 800074e0 <etext+0x4e0>
    800028e8:	617020ef          	jal	800056fe <panic>
    800028ec:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800028ee:	40dc                	lw	a5,4(s1)
    800028f0:	0047d79b          	srliw	a5,a5,0x4
    800028f4:	00016597          	auipc	a1,0x16
    800028f8:	ffc5a583          	lw	a1,-4(a1) # 800188f0 <sb+0x18>
    800028fc:	9dbd                	addw	a1,a1,a5
    800028fe:	4088                	lw	a0,0(s1)
    80002900:	8b5ff0ef          	jal	800021b4 <bread>
    80002904:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002906:	05850593          	addi	a1,a0,88
    8000290a:	40dc                	lw	a5,4(s1)
    8000290c:	8bbd                	andi	a5,a5,15
    8000290e:	079a                	slli	a5,a5,0x6
    80002910:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002912:	00059783          	lh	a5,0(a1)
    80002916:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000291a:	00259783          	lh	a5,2(a1)
    8000291e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002922:	00459783          	lh	a5,4(a1)
    80002926:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000292a:	00659783          	lh	a5,6(a1)
    8000292e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002932:	459c                	lw	a5,8(a1)
    80002934:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002936:	03400613          	li	a2,52
    8000293a:	05b1                	addi	a1,a1,12
    8000293c:	05048513          	addi	a0,s1,80
    80002940:	87ffd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002944:	854a                	mv	a0,s2
    80002946:	977ff0ef          	jal	800022bc <brelse>
    ip->valid = 1;
    8000294a:	4785                	li	a5,1
    8000294c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000294e:	04449783          	lh	a5,68(s1)
    80002952:	c399                	beqz	a5,80002958 <ilock+0xa2>
    80002954:	6902                	ld	s2,0(sp)
    80002956:	bfbd                	j	800028d4 <ilock+0x1e>
      panic("ilock: no type");
    80002958:	00005517          	auipc	a0,0x5
    8000295c:	b9050513          	addi	a0,a0,-1136 # 800074e8 <etext+0x4e8>
    80002960:	59f020ef          	jal	800056fe <panic>

0000000080002964 <iunlock>:
{
    80002964:	1101                	addi	sp,sp,-32
    80002966:	ec06                	sd	ra,24(sp)
    80002968:	e822                	sd	s0,16(sp)
    8000296a:	e426                	sd	s1,8(sp)
    8000296c:	e04a                	sd	s2,0(sp)
    8000296e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002970:	c505                	beqz	a0,80002998 <iunlock+0x34>
    80002972:	84aa                	mv	s1,a0
    80002974:	01050913          	addi	s2,a0,16
    80002978:	854a                	mv	a0,s2
    8000297a:	315000ef          	jal	8000348e <holdingsleep>
    8000297e:	cd09                	beqz	a0,80002998 <iunlock+0x34>
    80002980:	449c                	lw	a5,8(s1)
    80002982:	00f05b63          	blez	a5,80002998 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002986:	854a                	mv	a0,s2
    80002988:	2cf000ef          	jal	80003456 <releasesleep>
}
    8000298c:	60e2                	ld	ra,24(sp)
    8000298e:	6442                	ld	s0,16(sp)
    80002990:	64a2                	ld	s1,8(sp)
    80002992:	6902                	ld	s2,0(sp)
    80002994:	6105                	addi	sp,sp,32
    80002996:	8082                	ret
    panic("iunlock");
    80002998:	00005517          	auipc	a0,0x5
    8000299c:	b6050513          	addi	a0,a0,-1184 # 800074f8 <etext+0x4f8>
    800029a0:	55f020ef          	jal	800056fe <panic>

00000000800029a4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800029a4:	7179                	addi	sp,sp,-48
    800029a6:	f406                	sd	ra,40(sp)
    800029a8:	f022                	sd	s0,32(sp)
    800029aa:	ec26                	sd	s1,24(sp)
    800029ac:	e84a                	sd	s2,16(sp)
    800029ae:	e44e                	sd	s3,8(sp)
    800029b0:	1800                	addi	s0,sp,48
    800029b2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800029b4:	05050493          	addi	s1,a0,80
    800029b8:	08050913          	addi	s2,a0,128
    800029bc:	a021                	j	800029c4 <itrunc+0x20>
    800029be:	0491                	addi	s1,s1,4
    800029c0:	01248b63          	beq	s1,s2,800029d6 <itrunc+0x32>
    if(ip->addrs[i]){
    800029c4:	408c                	lw	a1,0(s1)
    800029c6:	dde5                	beqz	a1,800029be <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800029c8:	0009a503          	lw	a0,0(s3)
    800029cc:	9ddff0ef          	jal	800023a8 <bfree>
      ip->addrs[i] = 0;
    800029d0:	0004a023          	sw	zero,0(s1)
    800029d4:	b7ed                	j	800029be <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800029d6:	0809a583          	lw	a1,128(s3)
    800029da:	ed89                	bnez	a1,800029f4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800029dc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800029e0:	854e                	mv	a0,s3
    800029e2:	e21ff0ef          	jal	80002802 <iupdate>
}
    800029e6:	70a2                	ld	ra,40(sp)
    800029e8:	7402                	ld	s0,32(sp)
    800029ea:	64e2                	ld	s1,24(sp)
    800029ec:	6942                	ld	s2,16(sp)
    800029ee:	69a2                	ld	s3,8(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
    800029f4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800029f6:	0009a503          	lw	a0,0(s3)
    800029fa:	fbaff0ef          	jal	800021b4 <bread>
    800029fe:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002a00:	05850493          	addi	s1,a0,88
    80002a04:	45850913          	addi	s2,a0,1112
    80002a08:	a021                	j	80002a10 <itrunc+0x6c>
    80002a0a:	0491                	addi	s1,s1,4
    80002a0c:	01248963          	beq	s1,s2,80002a1e <itrunc+0x7a>
      if(a[j])
    80002a10:	408c                	lw	a1,0(s1)
    80002a12:	dde5                	beqz	a1,80002a0a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002a14:	0009a503          	lw	a0,0(s3)
    80002a18:	991ff0ef          	jal	800023a8 <bfree>
    80002a1c:	b7fd                	j	80002a0a <itrunc+0x66>
    brelse(bp);
    80002a1e:	8552                	mv	a0,s4
    80002a20:	89dff0ef          	jal	800022bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002a24:	0809a583          	lw	a1,128(s3)
    80002a28:	0009a503          	lw	a0,0(s3)
    80002a2c:	97dff0ef          	jal	800023a8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002a30:	0809a023          	sw	zero,128(s3)
    80002a34:	6a02                	ld	s4,0(sp)
    80002a36:	b75d                	j	800029dc <itrunc+0x38>

0000000080002a38 <iput>:
{
    80002a38:	1101                	addi	sp,sp,-32
    80002a3a:	ec06                	sd	ra,24(sp)
    80002a3c:	e822                	sd	s0,16(sp)
    80002a3e:	e426                	sd	s1,8(sp)
    80002a40:	1000                	addi	s0,sp,32
    80002a42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a44:	00016517          	auipc	a0,0x16
    80002a48:	eb450513          	addi	a0,a0,-332 # 800188f8 <itable>
    80002a4c:	7f1020ef          	jal	80005a3c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002a50:	4498                	lw	a4,8(s1)
    80002a52:	4785                	li	a5,1
    80002a54:	02f70063          	beq	a4,a5,80002a74 <iput+0x3c>
  ip->ref--;
    80002a58:	449c                	lw	a5,8(s1)
    80002a5a:	37fd                	addiw	a5,a5,-1
    80002a5c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a5e:	00016517          	auipc	a0,0x16
    80002a62:	e9a50513          	addi	a0,a0,-358 # 800188f8 <itable>
    80002a66:	06a030ef          	jal	80005ad0 <release>
}
    80002a6a:	60e2                	ld	ra,24(sp)
    80002a6c:	6442                	ld	s0,16(sp)
    80002a6e:	64a2                	ld	s1,8(sp)
    80002a70:	6105                	addi	sp,sp,32
    80002a72:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002a74:	40bc                	lw	a5,64(s1)
    80002a76:	d3ed                	beqz	a5,80002a58 <iput+0x20>
    80002a78:	04a49783          	lh	a5,74(s1)
    80002a7c:	fff1                	bnez	a5,80002a58 <iput+0x20>
    80002a7e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002a80:	01048793          	addi	a5,s1,16
    80002a84:	893e                	mv	s2,a5
    80002a86:	853e                	mv	a0,a5
    80002a88:	189000ef          	jal	80003410 <acquiresleep>
    release(&itable.lock);
    80002a8c:	00016517          	auipc	a0,0x16
    80002a90:	e6c50513          	addi	a0,a0,-404 # 800188f8 <itable>
    80002a94:	03c030ef          	jal	80005ad0 <release>
    itrunc(ip);
    80002a98:	8526                	mv	a0,s1
    80002a9a:	f0bff0ef          	jal	800029a4 <itrunc>
    ip->type = 0;
    80002a9e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	d5fff0ef          	jal	80002802 <iupdate>
    ip->valid = 0;
    80002aa8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002aac:	854a                	mv	a0,s2
    80002aae:	1a9000ef          	jal	80003456 <releasesleep>
    acquire(&itable.lock);
    80002ab2:	00016517          	auipc	a0,0x16
    80002ab6:	e4650513          	addi	a0,a0,-442 # 800188f8 <itable>
    80002aba:	783020ef          	jal	80005a3c <acquire>
    80002abe:	6902                	ld	s2,0(sp)
    80002ac0:	bf61                	j	80002a58 <iput+0x20>

0000000080002ac2 <iunlockput>:
{
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	e426                	sd	s1,8(sp)
    80002aca:	1000                	addi	s0,sp,32
    80002acc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ace:	e97ff0ef          	jal	80002964 <iunlock>
  iput(ip);
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	f65ff0ef          	jal	80002a38 <iput>
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret

0000000080002ae2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ae2:	1141                	addi	sp,sp,-16
    80002ae4:	e406                	sd	ra,8(sp)
    80002ae6:	e022                	sd	s0,0(sp)
    80002ae8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002aea:	411c                	lw	a5,0(a0)
    80002aec:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002aee:	415c                	lw	a5,4(a0)
    80002af0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002af2:	04451783          	lh	a5,68(a0)
    80002af6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002afa:	04a51783          	lh	a5,74(a0)
    80002afe:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002b02:	04c56783          	lwu	a5,76(a0)
    80002b06:	e99c                	sd	a5,16(a1)
}
    80002b08:	60a2                	ld	ra,8(sp)
    80002b0a:	6402                	ld	s0,0(sp)
    80002b0c:	0141                	addi	sp,sp,16
    80002b0e:	8082                	ret

0000000080002b10 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b10:	457c                	lw	a5,76(a0)
    80002b12:	0ed7e663          	bltu	a5,a3,80002bfe <readi+0xee>
{
    80002b16:	7159                	addi	sp,sp,-112
    80002b18:	f486                	sd	ra,104(sp)
    80002b1a:	f0a2                	sd	s0,96(sp)
    80002b1c:	eca6                	sd	s1,88(sp)
    80002b1e:	e0d2                	sd	s4,64(sp)
    80002b20:	fc56                	sd	s5,56(sp)
    80002b22:	f85a                	sd	s6,48(sp)
    80002b24:	f45e                	sd	s7,40(sp)
    80002b26:	1880                	addi	s0,sp,112
    80002b28:	8b2a                	mv	s6,a0
    80002b2a:	8bae                	mv	s7,a1
    80002b2c:	8a32                	mv	s4,a2
    80002b2e:	84b6                	mv	s1,a3
    80002b30:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b32:	9f35                	addw	a4,a4,a3
    return 0;
    80002b34:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b36:	0ad76b63          	bltu	a4,a3,80002bec <readi+0xdc>
    80002b3a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b3c:	00e7f463          	bgeu	a5,a4,80002b44 <readi+0x34>
    n = ip->size - off;
    80002b40:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b44:	080a8b63          	beqz	s5,80002bda <readi+0xca>
    80002b48:	e8ca                	sd	s2,80(sp)
    80002b4a:	f062                	sd	s8,32(sp)
    80002b4c:	ec66                	sd	s9,24(sp)
    80002b4e:	e86a                	sd	s10,16(sp)
    80002b50:	e46e                	sd	s11,8(sp)
    80002b52:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b54:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b58:	5c7d                	li	s8,-1
    80002b5a:	a80d                	j	80002b8c <readi+0x7c>
    80002b5c:	020d1d93          	slli	s11,s10,0x20
    80002b60:	020ddd93          	srli	s11,s11,0x20
    80002b64:	05890613          	addi	a2,s2,88
    80002b68:	86ee                	mv	a3,s11
    80002b6a:	963e                	add	a2,a2,a5
    80002b6c:	85d2                	mv	a1,s4
    80002b6e:	855e                	mv	a0,s7
    80002b70:	b4ffe0ef          	jal	800016be <either_copyout>
    80002b74:	05850363          	beq	a0,s8,80002bba <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b78:	854a                	mv	a0,s2
    80002b7a:	f42ff0ef          	jal	800022bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b7e:	013d09bb          	addw	s3,s10,s3
    80002b82:	009d04bb          	addw	s1,s10,s1
    80002b86:	9a6e                	add	s4,s4,s11
    80002b88:	0559f363          	bgeu	s3,s5,80002bce <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b8c:	00a4d59b          	srliw	a1,s1,0xa
    80002b90:	855a                	mv	a0,s6
    80002b92:	989ff0ef          	jal	8000251a <bmap>
    80002b96:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b98:	c139                	beqz	a0,80002bde <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b9a:	000b2503          	lw	a0,0(s6)
    80002b9e:	e16ff0ef          	jal	800021b4 <bread>
    80002ba2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ba4:	3ff4f793          	andi	a5,s1,1023
    80002ba8:	40fc873b          	subw	a4,s9,a5
    80002bac:	413a86bb          	subw	a3,s5,s3
    80002bb0:	8d3a                	mv	s10,a4
    80002bb2:	fae6f5e3          	bgeu	a3,a4,80002b5c <readi+0x4c>
    80002bb6:	8d36                	mv	s10,a3
    80002bb8:	b755                	j	80002b5c <readi+0x4c>
      brelse(bp);
    80002bba:	854a                	mv	a0,s2
    80002bbc:	f00ff0ef          	jal	800022bc <brelse>
      tot = -1;
    80002bc0:	59fd                	li	s3,-1
      break;
    80002bc2:	6946                	ld	s2,80(sp)
    80002bc4:	7c02                	ld	s8,32(sp)
    80002bc6:	6ce2                	ld	s9,24(sp)
    80002bc8:	6d42                	ld	s10,16(sp)
    80002bca:	6da2                	ld	s11,8(sp)
    80002bcc:	a831                	j	80002be8 <readi+0xd8>
    80002bce:	6946                	ld	s2,80(sp)
    80002bd0:	7c02                	ld	s8,32(sp)
    80002bd2:	6ce2                	ld	s9,24(sp)
    80002bd4:	6d42                	ld	s10,16(sp)
    80002bd6:	6da2                	ld	s11,8(sp)
    80002bd8:	a801                	j	80002be8 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bda:	89d6                	mv	s3,s5
    80002bdc:	a031                	j	80002be8 <readi+0xd8>
    80002bde:	6946                	ld	s2,80(sp)
    80002be0:	7c02                	ld	s8,32(sp)
    80002be2:	6ce2                	ld	s9,24(sp)
    80002be4:	6d42                	ld	s10,16(sp)
    80002be6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002be8:	854e                	mv	a0,s3
    80002bea:	69a6                	ld	s3,72(sp)
}
    80002bec:	70a6                	ld	ra,104(sp)
    80002bee:	7406                	ld	s0,96(sp)
    80002bf0:	64e6                	ld	s1,88(sp)
    80002bf2:	6a06                	ld	s4,64(sp)
    80002bf4:	7ae2                	ld	s5,56(sp)
    80002bf6:	7b42                	ld	s6,48(sp)
    80002bf8:	7ba2                	ld	s7,40(sp)
    80002bfa:	6165                	addi	sp,sp,112
    80002bfc:	8082                	ret
    return 0;
    80002bfe:	4501                	li	a0,0
}
    80002c00:	8082                	ret

0000000080002c02 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c02:	457c                	lw	a5,76(a0)
    80002c04:	0ed7eb63          	bltu	a5,a3,80002cfa <writei+0xf8>
{
    80002c08:	7159                	addi	sp,sp,-112
    80002c0a:	f486                	sd	ra,104(sp)
    80002c0c:	f0a2                	sd	s0,96(sp)
    80002c0e:	e8ca                	sd	s2,80(sp)
    80002c10:	e0d2                	sd	s4,64(sp)
    80002c12:	fc56                	sd	s5,56(sp)
    80002c14:	f85a                	sd	s6,48(sp)
    80002c16:	f45e                	sd	s7,40(sp)
    80002c18:	1880                	addi	s0,sp,112
    80002c1a:	8aaa                	mv	s5,a0
    80002c1c:	8bae                	mv	s7,a1
    80002c1e:	8a32                	mv	s4,a2
    80002c20:	8936                	mv	s2,a3
    80002c22:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c24:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c28:	00043737          	lui	a4,0x43
    80002c2c:	0cf76963          	bltu	a4,a5,80002cfe <writei+0xfc>
    80002c30:	0cd7e763          	bltu	a5,a3,80002cfe <writei+0xfc>
    80002c34:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c36:	0a0b0a63          	beqz	s6,80002cea <writei+0xe8>
    80002c3a:	eca6                	sd	s1,88(sp)
    80002c3c:	f062                	sd	s8,32(sp)
    80002c3e:	ec66                	sd	s9,24(sp)
    80002c40:	e86a                	sd	s10,16(sp)
    80002c42:	e46e                	sd	s11,8(sp)
    80002c44:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c46:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c4a:	5c7d                	li	s8,-1
    80002c4c:	a825                	j	80002c84 <writei+0x82>
    80002c4e:	020d1d93          	slli	s11,s10,0x20
    80002c52:	020ddd93          	srli	s11,s11,0x20
    80002c56:	05848513          	addi	a0,s1,88
    80002c5a:	86ee                	mv	a3,s11
    80002c5c:	8652                	mv	a2,s4
    80002c5e:	85de                	mv	a1,s7
    80002c60:	953e                	add	a0,a0,a5
    80002c62:	aa7fe0ef          	jal	80001708 <either_copyin>
    80002c66:	05850663          	beq	a0,s8,80002cb2 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c6a:	8526                	mv	a0,s1
    80002c6c:	69c000ef          	jal	80003308 <log_write>
    brelse(bp);
    80002c70:	8526                	mv	a0,s1
    80002c72:	e4aff0ef          	jal	800022bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c76:	013d09bb          	addw	s3,s10,s3
    80002c7a:	012d093b          	addw	s2,s10,s2
    80002c7e:	9a6e                	add	s4,s4,s11
    80002c80:	0369fc63          	bgeu	s3,s6,80002cb8 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c84:	00a9559b          	srliw	a1,s2,0xa
    80002c88:	8556                	mv	a0,s5
    80002c8a:	891ff0ef          	jal	8000251a <bmap>
    80002c8e:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c90:	c505                	beqz	a0,80002cb8 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c92:	000aa503          	lw	a0,0(s5)
    80002c96:	d1eff0ef          	jal	800021b4 <bread>
    80002c9a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c9c:	3ff97793          	andi	a5,s2,1023
    80002ca0:	40fc873b          	subw	a4,s9,a5
    80002ca4:	413b06bb          	subw	a3,s6,s3
    80002ca8:	8d3a                	mv	s10,a4
    80002caa:	fae6f2e3          	bgeu	a3,a4,80002c4e <writei+0x4c>
    80002cae:	8d36                	mv	s10,a3
    80002cb0:	bf79                	j	80002c4e <writei+0x4c>
      brelse(bp);
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	e08ff0ef          	jal	800022bc <brelse>
  }

  if(off > ip->size)
    80002cb8:	04caa783          	lw	a5,76(s5)
    80002cbc:	0327f963          	bgeu	a5,s2,80002cee <writei+0xec>
    ip->size = off;
    80002cc0:	052aa623          	sw	s2,76(s5)
    80002cc4:	64e6                	ld	s1,88(sp)
    80002cc6:	7c02                	ld	s8,32(sp)
    80002cc8:	6ce2                	ld	s9,24(sp)
    80002cca:	6d42                	ld	s10,16(sp)
    80002ccc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002cce:	8556                	mv	a0,s5
    80002cd0:	b33ff0ef          	jal	80002802 <iupdate>

  return tot;
    80002cd4:	854e                	mv	a0,s3
    80002cd6:	69a6                	ld	s3,72(sp)
}
    80002cd8:	70a6                	ld	ra,104(sp)
    80002cda:	7406                	ld	s0,96(sp)
    80002cdc:	6946                	ld	s2,80(sp)
    80002cde:	6a06                	ld	s4,64(sp)
    80002ce0:	7ae2                	ld	s5,56(sp)
    80002ce2:	7b42                	ld	s6,48(sp)
    80002ce4:	7ba2                	ld	s7,40(sp)
    80002ce6:	6165                	addi	sp,sp,112
    80002ce8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002cea:	89da                	mv	s3,s6
    80002cec:	b7cd                	j	80002cce <writei+0xcc>
    80002cee:	64e6                	ld	s1,88(sp)
    80002cf0:	7c02                	ld	s8,32(sp)
    80002cf2:	6ce2                	ld	s9,24(sp)
    80002cf4:	6d42                	ld	s10,16(sp)
    80002cf6:	6da2                	ld	s11,8(sp)
    80002cf8:	bfd9                	j	80002cce <writei+0xcc>
    return -1;
    80002cfa:	557d                	li	a0,-1
}
    80002cfc:	8082                	ret
    return -1;
    80002cfe:	557d                	li	a0,-1
    80002d00:	bfe1                	j	80002cd8 <writei+0xd6>

0000000080002d02 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002d02:	1141                	addi	sp,sp,-16
    80002d04:	e406                	sd	ra,8(sp)
    80002d06:	e022                	sd	s0,0(sp)
    80002d08:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002d0a:	4639                	li	a2,14
    80002d0c:	d26fd0ef          	jal	80000232 <strncmp>
}
    80002d10:	60a2                	ld	ra,8(sp)
    80002d12:	6402                	ld	s0,0(sp)
    80002d14:	0141                	addi	sp,sp,16
    80002d16:	8082                	ret

0000000080002d18 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d18:	711d                	addi	sp,sp,-96
    80002d1a:	ec86                	sd	ra,88(sp)
    80002d1c:	e8a2                	sd	s0,80(sp)
    80002d1e:	e4a6                	sd	s1,72(sp)
    80002d20:	e0ca                	sd	s2,64(sp)
    80002d22:	fc4e                	sd	s3,56(sp)
    80002d24:	f852                	sd	s4,48(sp)
    80002d26:	f456                	sd	s5,40(sp)
    80002d28:	f05a                	sd	s6,32(sp)
    80002d2a:	ec5e                	sd	s7,24(sp)
    80002d2c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d2e:	04451703          	lh	a4,68(a0)
    80002d32:	4785                	li	a5,1
    80002d34:	00f71f63          	bne	a4,a5,80002d52 <dirlookup+0x3a>
    80002d38:	892a                	mv	s2,a0
    80002d3a:	8aae                	mv	s5,a1
    80002d3c:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d3e:	457c                	lw	a5,76(a0)
    80002d40:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d42:	fa040a13          	addi	s4,s0,-96
    80002d46:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d48:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d4c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d4e:	e39d                	bnez	a5,80002d74 <dirlookup+0x5c>
    80002d50:	a8b9                	j	80002dae <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d52:	00004517          	auipc	a0,0x4
    80002d56:	7ae50513          	addi	a0,a0,1966 # 80007500 <etext+0x500>
    80002d5a:	1a5020ef          	jal	800056fe <panic>
      panic("dirlookup read");
    80002d5e:	00004517          	auipc	a0,0x4
    80002d62:	7ba50513          	addi	a0,a0,1978 # 80007518 <etext+0x518>
    80002d66:	199020ef          	jal	800056fe <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d6a:	24c1                	addiw	s1,s1,16
    80002d6c:	04c92783          	lw	a5,76(s2)
    80002d70:	02f4fe63          	bgeu	s1,a5,80002dac <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d74:	874e                	mv	a4,s3
    80002d76:	86a6                	mv	a3,s1
    80002d78:	8652                	mv	a2,s4
    80002d7a:	4581                	li	a1,0
    80002d7c:	854a                	mv	a0,s2
    80002d7e:	d93ff0ef          	jal	80002b10 <readi>
    80002d82:	fd351ee3          	bne	a0,s3,80002d5e <dirlookup+0x46>
    if(de.inum == 0)
    80002d86:	fa045783          	lhu	a5,-96(s0)
    80002d8a:	d3e5                	beqz	a5,80002d6a <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d8c:	85da                	mv	a1,s6
    80002d8e:	8556                	mv	a0,s5
    80002d90:	f73ff0ef          	jal	80002d02 <namecmp>
    80002d94:	f979                	bnez	a0,80002d6a <dirlookup+0x52>
      if(poff)
    80002d96:	000b8463          	beqz	s7,80002d9e <dirlookup+0x86>
        *poff = off;
    80002d9a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d9e:	fa045583          	lhu	a1,-96(s0)
    80002da2:	00092503          	lw	a0,0(s2)
    80002da6:	835ff0ef          	jal	800025da <iget>
    80002daa:	a011                	j	80002dae <dirlookup+0x96>
  return 0;
    80002dac:	4501                	li	a0,0
}
    80002dae:	60e6                	ld	ra,88(sp)
    80002db0:	6446                	ld	s0,80(sp)
    80002db2:	64a6                	ld	s1,72(sp)
    80002db4:	6906                	ld	s2,64(sp)
    80002db6:	79e2                	ld	s3,56(sp)
    80002db8:	7a42                	ld	s4,48(sp)
    80002dba:	7aa2                	ld	s5,40(sp)
    80002dbc:	7b02                	ld	s6,32(sp)
    80002dbe:	6be2                	ld	s7,24(sp)
    80002dc0:	6125                	addi	sp,sp,96
    80002dc2:	8082                	ret

0000000080002dc4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002dc4:	711d                	addi	sp,sp,-96
    80002dc6:	ec86                	sd	ra,88(sp)
    80002dc8:	e8a2                	sd	s0,80(sp)
    80002dca:	e4a6                	sd	s1,72(sp)
    80002dcc:	e0ca                	sd	s2,64(sp)
    80002dce:	fc4e                	sd	s3,56(sp)
    80002dd0:	f852                	sd	s4,48(sp)
    80002dd2:	f456                	sd	s5,40(sp)
    80002dd4:	f05a                	sd	s6,32(sp)
    80002dd6:	ec5e                	sd	s7,24(sp)
    80002dd8:	e862                	sd	s8,16(sp)
    80002dda:	e466                	sd	s9,8(sp)
    80002ddc:	e06a                	sd	s10,0(sp)
    80002dde:	1080                	addi	s0,sp,96
    80002de0:	84aa                	mv	s1,a0
    80002de2:	8b2e                	mv	s6,a1
    80002de4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002de6:	00054703          	lbu	a4,0(a0)
    80002dea:	02f00793          	li	a5,47
    80002dee:	00f70f63          	beq	a4,a5,80002e0c <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002df2:	f95fd0ef          	jal	80000d86 <myproc>
    80002df6:	15053503          	ld	a0,336(a0)
    80002dfa:	a87ff0ef          	jal	80002880 <idup>
    80002dfe:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002e00:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002e04:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002e06:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002e08:	4b85                	li	s7,1
    80002e0a:	a879                	j	80002ea8 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002e0c:	4585                	li	a1,1
    80002e0e:	852e                	mv	a0,a1
    80002e10:	fcaff0ef          	jal	800025da <iget>
    80002e14:	8a2a                	mv	s4,a0
    80002e16:	b7ed                	j	80002e00 <namex+0x3c>
      iunlockput(ip);
    80002e18:	8552                	mv	a0,s4
    80002e1a:	ca9ff0ef          	jal	80002ac2 <iunlockput>
      return 0;
    80002e1e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e20:	8552                	mv	a0,s4
    80002e22:	60e6                	ld	ra,88(sp)
    80002e24:	6446                	ld	s0,80(sp)
    80002e26:	64a6                	ld	s1,72(sp)
    80002e28:	6906                	ld	s2,64(sp)
    80002e2a:	79e2                	ld	s3,56(sp)
    80002e2c:	7a42                	ld	s4,48(sp)
    80002e2e:	7aa2                	ld	s5,40(sp)
    80002e30:	7b02                	ld	s6,32(sp)
    80002e32:	6be2                	ld	s7,24(sp)
    80002e34:	6c42                	ld	s8,16(sp)
    80002e36:	6ca2                	ld	s9,8(sp)
    80002e38:	6d02                	ld	s10,0(sp)
    80002e3a:	6125                	addi	sp,sp,96
    80002e3c:	8082                	ret
      iunlock(ip);
    80002e3e:	8552                	mv	a0,s4
    80002e40:	b25ff0ef          	jal	80002964 <iunlock>
      return ip;
    80002e44:	bff1                	j	80002e20 <namex+0x5c>
      iunlockput(ip);
    80002e46:	8552                	mv	a0,s4
    80002e48:	c7bff0ef          	jal	80002ac2 <iunlockput>
      return 0;
    80002e4c:	8a4a                	mv	s4,s2
    80002e4e:	bfc9                	j	80002e20 <namex+0x5c>
  len = path - s;
    80002e50:	40990633          	sub	a2,s2,s1
    80002e54:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e58:	09ac5463          	bge	s8,s10,80002ee0 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e5c:	8666                	mv	a2,s9
    80002e5e:	85a6                	mv	a1,s1
    80002e60:	8556                	mv	a0,s5
    80002e62:	b5cfd0ef          	jal	800001be <memmove>
    80002e66:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e68:	0004c783          	lbu	a5,0(s1)
    80002e6c:	01379763          	bne	a5,s3,80002e7a <namex+0xb6>
    path++;
    80002e70:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e72:	0004c783          	lbu	a5,0(s1)
    80002e76:	ff378de3          	beq	a5,s3,80002e70 <namex+0xac>
    ilock(ip);
    80002e7a:	8552                	mv	a0,s4
    80002e7c:	a3bff0ef          	jal	800028b6 <ilock>
    if(ip->type != T_DIR){
    80002e80:	044a1783          	lh	a5,68(s4)
    80002e84:	f9779ae3          	bne	a5,s7,80002e18 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e88:	000b0563          	beqz	s6,80002e92 <namex+0xce>
    80002e8c:	0004c783          	lbu	a5,0(s1)
    80002e90:	d7dd                	beqz	a5,80002e3e <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e92:	4601                	li	a2,0
    80002e94:	85d6                	mv	a1,s5
    80002e96:	8552                	mv	a0,s4
    80002e98:	e81ff0ef          	jal	80002d18 <dirlookup>
    80002e9c:	892a                	mv	s2,a0
    80002e9e:	d545                	beqz	a0,80002e46 <namex+0x82>
    iunlockput(ip);
    80002ea0:	8552                	mv	a0,s4
    80002ea2:	c21ff0ef          	jal	80002ac2 <iunlockput>
    ip = next;
    80002ea6:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002ea8:	0004c783          	lbu	a5,0(s1)
    80002eac:	01379763          	bne	a5,s3,80002eba <namex+0xf6>
    path++;
    80002eb0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002eb2:	0004c783          	lbu	a5,0(s1)
    80002eb6:	ff378de3          	beq	a5,s3,80002eb0 <namex+0xec>
  if(*path == 0)
    80002eba:	cf8d                	beqz	a5,80002ef4 <namex+0x130>
  while(*path != '/' && *path != 0)
    80002ebc:	0004c783          	lbu	a5,0(s1)
    80002ec0:	fd178713          	addi	a4,a5,-47
    80002ec4:	cb19                	beqz	a4,80002eda <namex+0x116>
    80002ec6:	cb91                	beqz	a5,80002eda <namex+0x116>
    80002ec8:	8926                	mv	s2,s1
    path++;
    80002eca:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002ecc:	00094783          	lbu	a5,0(s2)
    80002ed0:	fd178713          	addi	a4,a5,-47
    80002ed4:	df35                	beqz	a4,80002e50 <namex+0x8c>
    80002ed6:	fbf5                	bnez	a5,80002eca <namex+0x106>
    80002ed8:	bfa5                	j	80002e50 <namex+0x8c>
    80002eda:	8926                	mv	s2,s1
  len = path - s;
    80002edc:	4d01                	li	s10,0
    80002ede:	4601                	li	a2,0
    memmove(name, s, len);
    80002ee0:	2601                	sext.w	a2,a2
    80002ee2:	85a6                	mv	a1,s1
    80002ee4:	8556                	mv	a0,s5
    80002ee6:	ad8fd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002eea:	9d56                	add	s10,s10,s5
    80002eec:	000d0023          	sb	zero,0(s10)
    80002ef0:	84ca                	mv	s1,s2
    80002ef2:	bf9d                	j	80002e68 <namex+0xa4>
  if(nameiparent){
    80002ef4:	f20b06e3          	beqz	s6,80002e20 <namex+0x5c>
    iput(ip);
    80002ef8:	8552                	mv	a0,s4
    80002efa:	b3fff0ef          	jal	80002a38 <iput>
    return 0;
    80002efe:	4a01                	li	s4,0
    80002f00:	b705                	j	80002e20 <namex+0x5c>

0000000080002f02 <dirlink>:
{
    80002f02:	715d                	addi	sp,sp,-80
    80002f04:	e486                	sd	ra,72(sp)
    80002f06:	e0a2                	sd	s0,64(sp)
    80002f08:	f84a                	sd	s2,48(sp)
    80002f0a:	ec56                	sd	s5,24(sp)
    80002f0c:	e85a                	sd	s6,16(sp)
    80002f0e:	0880                	addi	s0,sp,80
    80002f10:	892a                	mv	s2,a0
    80002f12:	8aae                	mv	s5,a1
    80002f14:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f16:	4601                	li	a2,0
    80002f18:	e01ff0ef          	jal	80002d18 <dirlookup>
    80002f1c:	ed1d                	bnez	a0,80002f5a <dirlink+0x58>
    80002f1e:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f20:	04c92483          	lw	s1,76(s2)
    80002f24:	c4b9                	beqz	s1,80002f72 <dirlink+0x70>
    80002f26:	f44e                	sd	s3,40(sp)
    80002f28:	f052                	sd	s4,32(sp)
    80002f2a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f2c:	fb040a13          	addi	s4,s0,-80
    80002f30:	49c1                	li	s3,16
    80002f32:	874e                	mv	a4,s3
    80002f34:	86a6                	mv	a3,s1
    80002f36:	8652                	mv	a2,s4
    80002f38:	4581                	li	a1,0
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	bd5ff0ef          	jal	80002b10 <readi>
    80002f40:	03351163          	bne	a0,s3,80002f62 <dirlink+0x60>
    if(de.inum == 0)
    80002f44:	fb045783          	lhu	a5,-80(s0)
    80002f48:	c39d                	beqz	a5,80002f6e <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f4a:	24c1                	addiw	s1,s1,16
    80002f4c:	04c92783          	lw	a5,76(s2)
    80002f50:	fef4e1e3          	bltu	s1,a5,80002f32 <dirlink+0x30>
    80002f54:	79a2                	ld	s3,40(sp)
    80002f56:	7a02                	ld	s4,32(sp)
    80002f58:	a829                	j	80002f72 <dirlink+0x70>
    iput(ip);
    80002f5a:	adfff0ef          	jal	80002a38 <iput>
    return -1;
    80002f5e:	557d                	li	a0,-1
    80002f60:	a83d                	j	80002f9e <dirlink+0x9c>
      panic("dirlink read");
    80002f62:	00004517          	auipc	a0,0x4
    80002f66:	5c650513          	addi	a0,a0,1478 # 80007528 <etext+0x528>
    80002f6a:	794020ef          	jal	800056fe <panic>
    80002f6e:	79a2                	ld	s3,40(sp)
    80002f70:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f72:	4639                	li	a2,14
    80002f74:	85d6                	mv	a1,s5
    80002f76:	fb240513          	addi	a0,s0,-78
    80002f7a:	af2fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002f7e:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f82:	4741                	li	a4,16
    80002f84:	86a6                	mv	a3,s1
    80002f86:	fb040613          	addi	a2,s0,-80
    80002f8a:	4581                	li	a1,0
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	c75ff0ef          	jal	80002c02 <writei>
    80002f92:	1541                	addi	a0,a0,-16
    80002f94:	00a03533          	snez	a0,a0
    80002f98:	40a0053b          	negw	a0,a0
    80002f9c:	74e2                	ld	s1,56(sp)
}
    80002f9e:	60a6                	ld	ra,72(sp)
    80002fa0:	6406                	ld	s0,64(sp)
    80002fa2:	7942                	ld	s2,48(sp)
    80002fa4:	6ae2                	ld	s5,24(sp)
    80002fa6:	6b42                	ld	s6,16(sp)
    80002fa8:	6161                	addi	sp,sp,80
    80002faa:	8082                	ret

0000000080002fac <namei>:

struct inode*
namei(char *path)
{
    80002fac:	1101                	addi	sp,sp,-32
    80002fae:	ec06                	sd	ra,24(sp)
    80002fb0:	e822                	sd	s0,16(sp)
    80002fb2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002fb4:	fe040613          	addi	a2,s0,-32
    80002fb8:	4581                	li	a1,0
    80002fba:	e0bff0ef          	jal	80002dc4 <namex>
}
    80002fbe:	60e2                	ld	ra,24(sp)
    80002fc0:	6442                	ld	s0,16(sp)
    80002fc2:	6105                	addi	sp,sp,32
    80002fc4:	8082                	ret

0000000080002fc6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fc6:	1141                	addi	sp,sp,-16
    80002fc8:	e406                	sd	ra,8(sp)
    80002fca:	e022                	sd	s0,0(sp)
    80002fcc:	0800                	addi	s0,sp,16
    80002fce:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002fd0:	4585                	li	a1,1
    80002fd2:	df3ff0ef          	jal	80002dc4 <namex>
}
    80002fd6:	60a2                	ld	ra,8(sp)
    80002fd8:	6402                	ld	s0,0(sp)
    80002fda:	0141                	addi	sp,sp,16
    80002fdc:	8082                	ret

0000000080002fde <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002fde:	1101                	addi	sp,sp,-32
    80002fe0:	ec06                	sd	ra,24(sp)
    80002fe2:	e822                	sd	s0,16(sp)
    80002fe4:	e426                	sd	s1,8(sp)
    80002fe6:	e04a                	sd	s2,0(sp)
    80002fe8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002fea:	00017917          	auipc	s2,0x17
    80002fee:	3b690913          	addi	s2,s2,950 # 8001a3a0 <log>
    80002ff2:	01892583          	lw	a1,24(s2)
    80002ff6:	02892503          	lw	a0,40(s2)
    80002ffa:	9baff0ef          	jal	800021b4 <bread>
    80002ffe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003000:	02c92603          	lw	a2,44(s2)
    80003004:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003006:	00c05f63          	blez	a2,80003024 <write_head+0x46>
    8000300a:	00017717          	auipc	a4,0x17
    8000300e:	3c670713          	addi	a4,a4,966 # 8001a3d0 <log+0x30>
    80003012:	87aa                	mv	a5,a0
    80003014:	060a                	slli	a2,a2,0x2
    80003016:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003018:	4314                	lw	a3,0(a4)
    8000301a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000301c:	0711                	addi	a4,a4,4
    8000301e:	0791                	addi	a5,a5,4
    80003020:	fec79ce3          	bne	a5,a2,80003018 <write_head+0x3a>
  }
  bwrite(buf);
    80003024:	8526                	mv	a0,s1
    80003026:	a64ff0ef          	jal	8000228a <bwrite>
  brelse(buf);
    8000302a:	8526                	mv	a0,s1
    8000302c:	a90ff0ef          	jal	800022bc <brelse>
}
    80003030:	60e2                	ld	ra,24(sp)
    80003032:	6442                	ld	s0,16(sp)
    80003034:	64a2                	ld	s1,8(sp)
    80003036:	6902                	ld	s2,0(sp)
    80003038:	6105                	addi	sp,sp,32
    8000303a:	8082                	ret

000000008000303c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000303c:	00017797          	auipc	a5,0x17
    80003040:	3907a783          	lw	a5,912(a5) # 8001a3cc <log+0x2c>
    80003044:	0af05263          	blez	a5,800030e8 <install_trans+0xac>
{
    80003048:	715d                	addi	sp,sp,-80
    8000304a:	e486                	sd	ra,72(sp)
    8000304c:	e0a2                	sd	s0,64(sp)
    8000304e:	fc26                	sd	s1,56(sp)
    80003050:	f84a                	sd	s2,48(sp)
    80003052:	f44e                	sd	s3,40(sp)
    80003054:	f052                	sd	s4,32(sp)
    80003056:	ec56                	sd	s5,24(sp)
    80003058:	e85a                	sd	s6,16(sp)
    8000305a:	e45e                	sd	s7,8(sp)
    8000305c:	0880                	addi	s0,sp,80
    8000305e:	8b2a                	mv	s6,a0
    80003060:	00017a97          	auipc	s5,0x17
    80003064:	370a8a93          	addi	s5,s5,880 # 8001a3d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003068:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000306a:	00017997          	auipc	s3,0x17
    8000306e:	33698993          	addi	s3,s3,822 # 8001a3a0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003072:	40000b93          	li	s7,1024
    80003076:	a829                	j	80003090 <install_trans+0x54>
    brelse(lbuf);
    80003078:	854a                	mv	a0,s2
    8000307a:	a42ff0ef          	jal	800022bc <brelse>
    brelse(dbuf);
    8000307e:	8526                	mv	a0,s1
    80003080:	a3cff0ef          	jal	800022bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003084:	2a05                	addiw	s4,s4,1
    80003086:	0a91                	addi	s5,s5,4
    80003088:	02c9a783          	lw	a5,44(s3)
    8000308c:	04fa5363          	bge	s4,a5,800030d2 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003090:	0189a583          	lw	a1,24(s3)
    80003094:	014585bb          	addw	a1,a1,s4
    80003098:	2585                	addiw	a1,a1,1
    8000309a:	0289a503          	lw	a0,40(s3)
    8000309e:	916ff0ef          	jal	800021b4 <bread>
    800030a2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030a4:	000aa583          	lw	a1,0(s5)
    800030a8:	0289a503          	lw	a0,40(s3)
    800030ac:	908ff0ef          	jal	800021b4 <bread>
    800030b0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030b2:	865e                	mv	a2,s7
    800030b4:	05890593          	addi	a1,s2,88
    800030b8:	05850513          	addi	a0,a0,88
    800030bc:	902fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800030c0:	8526                	mv	a0,s1
    800030c2:	9c8ff0ef          	jal	8000228a <bwrite>
    if(recovering == 0)
    800030c6:	fa0b19e3          	bnez	s6,80003078 <install_trans+0x3c>
      bunpin(dbuf);
    800030ca:	8526                	mv	a0,s1
    800030cc:	aa8ff0ef          	jal	80002374 <bunpin>
    800030d0:	b765                	j	80003078 <install_trans+0x3c>
}
    800030d2:	60a6                	ld	ra,72(sp)
    800030d4:	6406                	ld	s0,64(sp)
    800030d6:	74e2                	ld	s1,56(sp)
    800030d8:	7942                	ld	s2,48(sp)
    800030da:	79a2                	ld	s3,40(sp)
    800030dc:	7a02                	ld	s4,32(sp)
    800030de:	6ae2                	ld	s5,24(sp)
    800030e0:	6b42                	ld	s6,16(sp)
    800030e2:	6ba2                	ld	s7,8(sp)
    800030e4:	6161                	addi	sp,sp,80
    800030e6:	8082                	ret
    800030e8:	8082                	ret

00000000800030ea <initlog>:
{
    800030ea:	7179                	addi	sp,sp,-48
    800030ec:	f406                	sd	ra,40(sp)
    800030ee:	f022                	sd	s0,32(sp)
    800030f0:	ec26                	sd	s1,24(sp)
    800030f2:	e84a                	sd	s2,16(sp)
    800030f4:	e44e                	sd	s3,8(sp)
    800030f6:	1800                	addi	s0,sp,48
    800030f8:	892a                	mv	s2,a0
    800030fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800030fc:	00017497          	auipc	s1,0x17
    80003100:	2a448493          	addi	s1,s1,676 # 8001a3a0 <log>
    80003104:	00004597          	auipc	a1,0x4
    80003108:	43458593          	addi	a1,a1,1076 # 80007538 <etext+0x538>
    8000310c:	8526                	mv	a0,s1
    8000310e:	0a5020ef          	jal	800059b2 <initlock>
  log.start = sb->logstart;
    80003112:	0149a583          	lw	a1,20(s3)
    80003116:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003118:	0109a783          	lw	a5,16(s3)
    8000311c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000311e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003122:	854a                	mv	a0,s2
    80003124:	890ff0ef          	jal	800021b4 <bread>
  log.lh.n = lh->n;
    80003128:	4d30                	lw	a2,88(a0)
    8000312a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000312c:	00c05f63          	blez	a2,8000314a <initlog+0x60>
    80003130:	87aa                	mv	a5,a0
    80003132:	00017717          	auipc	a4,0x17
    80003136:	29e70713          	addi	a4,a4,670 # 8001a3d0 <log+0x30>
    8000313a:	060a                	slli	a2,a2,0x2
    8000313c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000313e:	4ff4                	lw	a3,92(a5)
    80003140:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003142:	0791                	addi	a5,a5,4
    80003144:	0711                	addi	a4,a4,4
    80003146:	fec79ce3          	bne	a5,a2,8000313e <initlog+0x54>
  brelse(buf);
    8000314a:	972ff0ef          	jal	800022bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000314e:	4505                	li	a0,1
    80003150:	eedff0ef          	jal	8000303c <install_trans>
  log.lh.n = 0;
    80003154:	00017797          	auipc	a5,0x17
    80003158:	2607ac23          	sw	zero,632(a5) # 8001a3cc <log+0x2c>
  write_head(); // clear the log
    8000315c:	e83ff0ef          	jal	80002fde <write_head>
}
    80003160:	70a2                	ld	ra,40(sp)
    80003162:	7402                	ld	s0,32(sp)
    80003164:	64e2                	ld	s1,24(sp)
    80003166:	6942                	ld	s2,16(sp)
    80003168:	69a2                	ld	s3,8(sp)
    8000316a:	6145                	addi	sp,sp,48
    8000316c:	8082                	ret

000000008000316e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	e426                	sd	s1,8(sp)
    80003176:	e04a                	sd	s2,0(sp)
    80003178:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000317a:	00017517          	auipc	a0,0x17
    8000317e:	22650513          	addi	a0,a0,550 # 8001a3a0 <log>
    80003182:	0bb020ef          	jal	80005a3c <acquire>
  while(1){
    if(log.committing){
    80003186:	00017497          	auipc	s1,0x17
    8000318a:	21a48493          	addi	s1,s1,538 # 8001a3a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000318e:	4979                	li	s2,30
    80003190:	a029                	j	8000319a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003192:	85a6                	mv	a1,s1
    80003194:	8526                	mv	a0,s1
    80003196:	9cefe0ef          	jal	80001364 <sleep>
    if(log.committing){
    8000319a:	50dc                	lw	a5,36(s1)
    8000319c:	fbfd                	bnez	a5,80003192 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000319e:	5098                	lw	a4,32(s1)
    800031a0:	2705                	addiw	a4,a4,1
    800031a2:	0027179b          	slliw	a5,a4,0x2
    800031a6:	9fb9                	addw	a5,a5,a4
    800031a8:	0017979b          	slliw	a5,a5,0x1
    800031ac:	54d4                	lw	a3,44(s1)
    800031ae:	9fb5                	addw	a5,a5,a3
    800031b0:	00f95763          	bge	s2,a5,800031be <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031b4:	85a6                	mv	a1,s1
    800031b6:	8526                	mv	a0,s1
    800031b8:	9acfe0ef          	jal	80001364 <sleep>
    800031bc:	bff9                	j	8000319a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031be:	00017797          	auipc	a5,0x17
    800031c2:	20e7a123          	sw	a4,514(a5) # 8001a3c0 <log+0x20>
      release(&log.lock);
    800031c6:	00017517          	auipc	a0,0x17
    800031ca:	1da50513          	addi	a0,a0,474 # 8001a3a0 <log>
    800031ce:	103020ef          	jal	80005ad0 <release>
      break;
    }
  }
}
    800031d2:	60e2                	ld	ra,24(sp)
    800031d4:	6442                	ld	s0,16(sp)
    800031d6:	64a2                	ld	s1,8(sp)
    800031d8:	6902                	ld	s2,0(sp)
    800031da:	6105                	addi	sp,sp,32
    800031dc:	8082                	ret

00000000800031de <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800031de:	7139                	addi	sp,sp,-64
    800031e0:	fc06                	sd	ra,56(sp)
    800031e2:	f822                	sd	s0,48(sp)
    800031e4:	f426                	sd	s1,40(sp)
    800031e6:	f04a                	sd	s2,32(sp)
    800031e8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800031ea:	00017497          	auipc	s1,0x17
    800031ee:	1b648493          	addi	s1,s1,438 # 8001a3a0 <log>
    800031f2:	8526                	mv	a0,s1
    800031f4:	049020ef          	jal	80005a3c <acquire>
  log.outstanding -= 1;
    800031f8:	509c                	lw	a5,32(s1)
    800031fa:	37fd                	addiw	a5,a5,-1
    800031fc:	893e                	mv	s2,a5
    800031fe:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003200:	50dc                	lw	a5,36(s1)
    80003202:	e7b1                	bnez	a5,8000324e <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003204:	04091e63          	bnez	s2,80003260 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003208:	00017497          	auipc	s1,0x17
    8000320c:	19848493          	addi	s1,s1,408 # 8001a3a0 <log>
    80003210:	4785                	li	a5,1
    80003212:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003214:	8526                	mv	a0,s1
    80003216:	0bb020ef          	jal	80005ad0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000321a:	54dc                	lw	a5,44(s1)
    8000321c:	06f04463          	bgtz	a5,80003284 <end_op+0xa6>
    acquire(&log.lock);
    80003220:	00017517          	auipc	a0,0x17
    80003224:	18050513          	addi	a0,a0,384 # 8001a3a0 <log>
    80003228:	015020ef          	jal	80005a3c <acquire>
    log.committing = 0;
    8000322c:	00017797          	auipc	a5,0x17
    80003230:	1807ac23          	sw	zero,408(a5) # 8001a3c4 <log+0x24>
    wakeup(&log);
    80003234:	00017517          	auipc	a0,0x17
    80003238:	16c50513          	addi	a0,a0,364 # 8001a3a0 <log>
    8000323c:	974fe0ef          	jal	800013b0 <wakeup>
    release(&log.lock);
    80003240:	00017517          	auipc	a0,0x17
    80003244:	16050513          	addi	a0,a0,352 # 8001a3a0 <log>
    80003248:	089020ef          	jal	80005ad0 <release>
}
    8000324c:	a035                	j	80003278 <end_op+0x9a>
    8000324e:	ec4e                	sd	s3,24(sp)
    80003250:	e852                	sd	s4,16(sp)
    80003252:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003254:	00004517          	auipc	a0,0x4
    80003258:	2ec50513          	addi	a0,a0,748 # 80007540 <etext+0x540>
    8000325c:	4a2020ef          	jal	800056fe <panic>
    wakeup(&log);
    80003260:	00017517          	auipc	a0,0x17
    80003264:	14050513          	addi	a0,a0,320 # 8001a3a0 <log>
    80003268:	948fe0ef          	jal	800013b0 <wakeup>
  release(&log.lock);
    8000326c:	00017517          	auipc	a0,0x17
    80003270:	13450513          	addi	a0,a0,308 # 8001a3a0 <log>
    80003274:	05d020ef          	jal	80005ad0 <release>
}
    80003278:	70e2                	ld	ra,56(sp)
    8000327a:	7442                	ld	s0,48(sp)
    8000327c:	74a2                	ld	s1,40(sp)
    8000327e:	7902                	ld	s2,32(sp)
    80003280:	6121                	addi	sp,sp,64
    80003282:	8082                	ret
    80003284:	ec4e                	sd	s3,24(sp)
    80003286:	e852                	sd	s4,16(sp)
    80003288:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000328a:	00017a97          	auipc	s5,0x17
    8000328e:	146a8a93          	addi	s5,s5,326 # 8001a3d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003292:	00017a17          	auipc	s4,0x17
    80003296:	10ea0a13          	addi	s4,s4,270 # 8001a3a0 <log>
    8000329a:	018a2583          	lw	a1,24(s4)
    8000329e:	012585bb          	addw	a1,a1,s2
    800032a2:	2585                	addiw	a1,a1,1
    800032a4:	028a2503          	lw	a0,40(s4)
    800032a8:	f0dfe0ef          	jal	800021b4 <bread>
    800032ac:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032ae:	000aa583          	lw	a1,0(s5)
    800032b2:	028a2503          	lw	a0,40(s4)
    800032b6:	efffe0ef          	jal	800021b4 <bread>
    800032ba:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032bc:	40000613          	li	a2,1024
    800032c0:	05850593          	addi	a1,a0,88
    800032c4:	05848513          	addi	a0,s1,88
    800032c8:	ef7fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800032cc:	8526                	mv	a0,s1
    800032ce:	fbdfe0ef          	jal	8000228a <bwrite>
    brelse(from);
    800032d2:	854e                	mv	a0,s3
    800032d4:	fe9fe0ef          	jal	800022bc <brelse>
    brelse(to);
    800032d8:	8526                	mv	a0,s1
    800032da:	fe3fe0ef          	jal	800022bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032de:	2905                	addiw	s2,s2,1
    800032e0:	0a91                	addi	s5,s5,4
    800032e2:	02ca2783          	lw	a5,44(s4)
    800032e6:	faf94ae3          	blt	s2,a5,8000329a <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800032ea:	cf5ff0ef          	jal	80002fde <write_head>
    install_trans(0); // Now install writes to home locations
    800032ee:	4501                	li	a0,0
    800032f0:	d4dff0ef          	jal	8000303c <install_trans>
    log.lh.n = 0;
    800032f4:	00017797          	auipc	a5,0x17
    800032f8:	0c07ac23          	sw	zero,216(a5) # 8001a3cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800032fc:	ce3ff0ef          	jal	80002fde <write_head>
    80003300:	69e2                	ld	s3,24(sp)
    80003302:	6a42                	ld	s4,16(sp)
    80003304:	6aa2                	ld	s5,8(sp)
    80003306:	bf29                	j	80003220 <end_op+0x42>

0000000080003308 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	e426                	sd	s1,8(sp)
    80003310:	1000                	addi	s0,sp,32
    80003312:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003314:	00017517          	auipc	a0,0x17
    80003318:	08c50513          	addi	a0,a0,140 # 8001a3a0 <log>
    8000331c:	720020ef          	jal	80005a3c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003320:	00017617          	auipc	a2,0x17
    80003324:	0ac62603          	lw	a2,172(a2) # 8001a3cc <log+0x2c>
    80003328:	47f5                	li	a5,29
    8000332a:	06c7c463          	blt	a5,a2,80003392 <log_write+0x8a>
    8000332e:	00017797          	auipc	a5,0x17
    80003332:	08e7a783          	lw	a5,142(a5) # 8001a3bc <log+0x1c>
    80003336:	37fd                	addiw	a5,a5,-1
    80003338:	04f65d63          	bge	a2,a5,80003392 <log_write+0x8a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000333c:	00017797          	auipc	a5,0x17
    80003340:	0847a783          	lw	a5,132(a5) # 8001a3c0 <log+0x20>
    80003344:	04f05d63          	blez	a5,8000339e <log_write+0x96>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003348:	4781                	li	a5,0
    8000334a:	06c05063          	blez	a2,800033aa <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000334e:	44cc                	lw	a1,12(s1)
    80003350:	00017717          	auipc	a4,0x17
    80003354:	08070713          	addi	a4,a4,128 # 8001a3d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003358:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000335a:	4314                	lw	a3,0(a4)
    8000335c:	04b68763          	beq	a3,a1,800033aa <log_write+0xa2>
  for (i = 0; i < log.lh.n; i++) {
    80003360:	2785                	addiw	a5,a5,1
    80003362:	0711                	addi	a4,a4,4
    80003364:	fef61be3          	bne	a2,a5,8000335a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003368:	060a                	slli	a2,a2,0x2
    8000336a:	02060613          	addi	a2,a2,32
    8000336e:	00017797          	auipc	a5,0x17
    80003372:	03278793          	addi	a5,a5,50 # 8001a3a0 <log>
    80003376:	97b2                	add	a5,a5,a2
    80003378:	44d8                	lw	a4,12(s1)
    8000337a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000337c:	8526                	mv	a0,s1
    8000337e:	fc3fe0ef          	jal	80002340 <bpin>
    log.lh.n++;
    80003382:	00017717          	auipc	a4,0x17
    80003386:	01e70713          	addi	a4,a4,30 # 8001a3a0 <log>
    8000338a:	575c                	lw	a5,44(a4)
    8000338c:	2785                	addiw	a5,a5,1
    8000338e:	d75c                	sw	a5,44(a4)
    80003390:	a815                	j	800033c4 <log_write+0xbc>
    panic("too big a transaction");
    80003392:	00004517          	auipc	a0,0x4
    80003396:	1be50513          	addi	a0,a0,446 # 80007550 <etext+0x550>
    8000339a:	364020ef          	jal	800056fe <panic>
    panic("log_write outside of trans");
    8000339e:	00004517          	auipc	a0,0x4
    800033a2:	1ca50513          	addi	a0,a0,458 # 80007568 <etext+0x568>
    800033a6:	358020ef          	jal	800056fe <panic>
  log.lh.block[i] = b->blockno;
    800033aa:	00279693          	slli	a3,a5,0x2
    800033ae:	02068693          	addi	a3,a3,32
    800033b2:	00017717          	auipc	a4,0x17
    800033b6:	fee70713          	addi	a4,a4,-18 # 8001a3a0 <log>
    800033ba:	9736                	add	a4,a4,a3
    800033bc:	44d4                	lw	a3,12(s1)
    800033be:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033c0:	faf60ee3          	beq	a2,a5,8000337c <log_write+0x74>
  }
  release(&log.lock);
    800033c4:	00017517          	auipc	a0,0x17
    800033c8:	fdc50513          	addi	a0,a0,-36 # 8001a3a0 <log>
    800033cc:	704020ef          	jal	80005ad0 <release>
}
    800033d0:	60e2                	ld	ra,24(sp)
    800033d2:	6442                	ld	s0,16(sp)
    800033d4:	64a2                	ld	s1,8(sp)
    800033d6:	6105                	addi	sp,sp,32
    800033d8:	8082                	ret

00000000800033da <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800033da:	1101                	addi	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	e04a                	sd	s2,0(sp)
    800033e4:	1000                	addi	s0,sp,32
    800033e6:	84aa                	mv	s1,a0
    800033e8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800033ea:	00004597          	auipc	a1,0x4
    800033ee:	19e58593          	addi	a1,a1,414 # 80007588 <etext+0x588>
    800033f2:	0521                	addi	a0,a0,8
    800033f4:	5be020ef          	jal	800059b2 <initlock>
  lk->name = name;
    800033f8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800033fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003400:	0204a423          	sw	zero,40(s1)
}
    80003404:	60e2                	ld	ra,24(sp)
    80003406:	6442                	ld	s0,16(sp)
    80003408:	64a2                	ld	s1,8(sp)
    8000340a:	6902                	ld	s2,0(sp)
    8000340c:	6105                	addi	sp,sp,32
    8000340e:	8082                	ret

0000000080003410 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003410:	1101                	addi	sp,sp,-32
    80003412:	ec06                	sd	ra,24(sp)
    80003414:	e822                	sd	s0,16(sp)
    80003416:	e426                	sd	s1,8(sp)
    80003418:	e04a                	sd	s2,0(sp)
    8000341a:	1000                	addi	s0,sp,32
    8000341c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000341e:	00850913          	addi	s2,a0,8
    80003422:	854a                	mv	a0,s2
    80003424:	618020ef          	jal	80005a3c <acquire>
  while (lk->locked) {
    80003428:	409c                	lw	a5,0(s1)
    8000342a:	c799                	beqz	a5,80003438 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000342c:	85ca                	mv	a1,s2
    8000342e:	8526                	mv	a0,s1
    80003430:	f35fd0ef          	jal	80001364 <sleep>
  while (lk->locked) {
    80003434:	409c                	lw	a5,0(s1)
    80003436:	fbfd                	bnez	a5,8000342c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003438:	4785                	li	a5,1
    8000343a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000343c:	94bfd0ef          	jal	80000d86 <myproc>
    80003440:	591c                	lw	a5,48(a0)
    80003442:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003444:	854a                	mv	a0,s2
    80003446:	68a020ef          	jal	80005ad0 <release>
}
    8000344a:	60e2                	ld	ra,24(sp)
    8000344c:	6442                	ld	s0,16(sp)
    8000344e:	64a2                	ld	s1,8(sp)
    80003450:	6902                	ld	s2,0(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret

0000000080003456 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	e426                	sd	s1,8(sp)
    8000345e:	e04a                	sd	s2,0(sp)
    80003460:	1000                	addi	s0,sp,32
    80003462:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003464:	00850913          	addi	s2,a0,8
    80003468:	854a                	mv	a0,s2
    8000346a:	5d2020ef          	jal	80005a3c <acquire>
  lk->locked = 0;
    8000346e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003472:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003476:	8526                	mv	a0,s1
    80003478:	f39fd0ef          	jal	800013b0 <wakeup>
  release(&lk->lk);
    8000347c:	854a                	mv	a0,s2
    8000347e:	652020ef          	jal	80005ad0 <release>
}
    80003482:	60e2                	ld	ra,24(sp)
    80003484:	6442                	ld	s0,16(sp)
    80003486:	64a2                	ld	s1,8(sp)
    80003488:	6902                	ld	s2,0(sp)
    8000348a:	6105                	addi	sp,sp,32
    8000348c:	8082                	ret

000000008000348e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000348e:	7179                	addi	sp,sp,-48
    80003490:	f406                	sd	ra,40(sp)
    80003492:	f022                	sd	s0,32(sp)
    80003494:	ec26                	sd	s1,24(sp)
    80003496:	e84a                	sd	s2,16(sp)
    80003498:	1800                	addi	s0,sp,48
    8000349a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000349c:	00850913          	addi	s2,a0,8
    800034a0:	854a                	mv	a0,s2
    800034a2:	59a020ef          	jal	80005a3c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800034a6:	409c                	lw	a5,0(s1)
    800034a8:	ef81                	bnez	a5,800034c0 <holdingsleep+0x32>
    800034aa:	4481                	li	s1,0
  release(&lk->lk);
    800034ac:	854a                	mv	a0,s2
    800034ae:	622020ef          	jal	80005ad0 <release>
  return r;
}
    800034b2:	8526                	mv	a0,s1
    800034b4:	70a2                	ld	ra,40(sp)
    800034b6:	7402                	ld	s0,32(sp)
    800034b8:	64e2                	ld	s1,24(sp)
    800034ba:	6942                	ld	s2,16(sp)
    800034bc:	6145                	addi	sp,sp,48
    800034be:	8082                	ret
    800034c0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034c2:	0284a983          	lw	s3,40(s1)
    800034c6:	8c1fd0ef          	jal	80000d86 <myproc>
    800034ca:	5904                	lw	s1,48(a0)
    800034cc:	413484b3          	sub	s1,s1,s3
    800034d0:	0014b493          	seqz	s1,s1
    800034d4:	69a2                	ld	s3,8(sp)
    800034d6:	bfd9                	j	800034ac <holdingsleep+0x1e>

00000000800034d8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800034d8:	1141                	addi	sp,sp,-16
    800034da:	e406                	sd	ra,8(sp)
    800034dc:	e022                	sd	s0,0(sp)
    800034de:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800034e0:	00004597          	auipc	a1,0x4
    800034e4:	0b858593          	addi	a1,a1,184 # 80007598 <etext+0x598>
    800034e8:	00017517          	auipc	a0,0x17
    800034ec:	00050513          	mv	a0,a0
    800034f0:	4c2020ef          	jal	800059b2 <initlock>
}
    800034f4:	60a2                	ld	ra,8(sp)
    800034f6:	6402                	ld	s0,0(sp)
    800034f8:	0141                	addi	sp,sp,16
    800034fa:	8082                	ret

00000000800034fc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	e426                	sd	s1,8(sp)
    80003504:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003506:	00017517          	auipc	a0,0x17
    8000350a:	fe250513          	addi	a0,a0,-30 # 8001a4e8 <ftable>
    8000350e:	52e020ef          	jal	80005a3c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003512:	00017497          	auipc	s1,0x17
    80003516:	fee48493          	addi	s1,s1,-18 # 8001a500 <ftable+0x18>
    8000351a:	00018717          	auipc	a4,0x18
    8000351e:	f8670713          	addi	a4,a4,-122 # 8001b4a0 <disk>
    if(f->ref == 0){
    80003522:	40dc                	lw	a5,4(s1)
    80003524:	cf89                	beqz	a5,8000353e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003526:	02848493          	addi	s1,s1,40
    8000352a:	fee49ce3          	bne	s1,a4,80003522 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000352e:	00017517          	auipc	a0,0x17
    80003532:	fba50513          	addi	a0,a0,-70 # 8001a4e8 <ftable>
    80003536:	59a020ef          	jal	80005ad0 <release>
  return 0;
    8000353a:	4481                	li	s1,0
    8000353c:	a809                	j	8000354e <filealloc+0x52>
      f->ref = 1;
    8000353e:	4785                	li	a5,1
    80003540:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003542:	00017517          	auipc	a0,0x17
    80003546:	fa650513          	addi	a0,a0,-90 # 8001a4e8 <ftable>
    8000354a:	586020ef          	jal	80005ad0 <release>
}
    8000354e:	8526                	mv	a0,s1
    80003550:	60e2                	ld	ra,24(sp)
    80003552:	6442                	ld	s0,16(sp)
    80003554:	64a2                	ld	s1,8(sp)
    80003556:	6105                	addi	sp,sp,32
    80003558:	8082                	ret

000000008000355a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000355a:	1101                	addi	sp,sp,-32
    8000355c:	ec06                	sd	ra,24(sp)
    8000355e:	e822                	sd	s0,16(sp)
    80003560:	e426                	sd	s1,8(sp)
    80003562:	1000                	addi	s0,sp,32
    80003564:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003566:	00017517          	auipc	a0,0x17
    8000356a:	f8250513          	addi	a0,a0,-126 # 8001a4e8 <ftable>
    8000356e:	4ce020ef          	jal	80005a3c <acquire>
  if(f->ref < 1)
    80003572:	40dc                	lw	a5,4(s1)
    80003574:	02f05063          	blez	a5,80003594 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003578:	2785                	addiw	a5,a5,1
    8000357a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000357c:	00017517          	auipc	a0,0x17
    80003580:	f6c50513          	addi	a0,a0,-148 # 8001a4e8 <ftable>
    80003584:	54c020ef          	jal	80005ad0 <release>
  return f;
}
    80003588:	8526                	mv	a0,s1
    8000358a:	60e2                	ld	ra,24(sp)
    8000358c:	6442                	ld	s0,16(sp)
    8000358e:	64a2                	ld	s1,8(sp)
    80003590:	6105                	addi	sp,sp,32
    80003592:	8082                	ret
    panic("filedup");
    80003594:	00004517          	auipc	a0,0x4
    80003598:	00c50513          	addi	a0,a0,12 # 800075a0 <etext+0x5a0>
    8000359c:	162020ef          	jal	800056fe <panic>

00000000800035a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800035a0:	7139                	addi	sp,sp,-64
    800035a2:	fc06                	sd	ra,56(sp)
    800035a4:	f822                	sd	s0,48(sp)
    800035a6:	f426                	sd	s1,40(sp)
    800035a8:	0080                	addi	s0,sp,64
    800035aa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035ac:	00017517          	auipc	a0,0x17
    800035b0:	f3c50513          	addi	a0,a0,-196 # 8001a4e8 <ftable>
    800035b4:	488020ef          	jal	80005a3c <acquire>
  if(f->ref < 1)
    800035b8:	40dc                	lw	a5,4(s1)
    800035ba:	04f05a63          	blez	a5,8000360e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035be:	37fd                	addiw	a5,a5,-1
    800035c0:	c0dc                	sw	a5,4(s1)
    800035c2:	06f04063          	bgtz	a5,80003622 <fileclose+0x82>
    800035c6:	f04a                	sd	s2,32(sp)
    800035c8:	ec4e                	sd	s3,24(sp)
    800035ca:	e852                	sd	s4,16(sp)
    800035cc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035ce:	0004a903          	lw	s2,0(s1)
    800035d2:	0094c783          	lbu	a5,9(s1)
    800035d6:	89be                	mv	s3,a5
    800035d8:	689c                	ld	a5,16(s1)
    800035da:	8a3e                	mv	s4,a5
    800035dc:	6c9c                	ld	a5,24(s1)
    800035de:	8abe                	mv	s5,a5
  f->ref = 0;
    800035e0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800035e4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800035e8:	00017517          	auipc	a0,0x17
    800035ec:	f0050513          	addi	a0,a0,-256 # 8001a4e8 <ftable>
    800035f0:	4e0020ef          	jal	80005ad0 <release>

  if(ff.type == FD_PIPE){
    800035f4:	4785                	li	a5,1
    800035f6:	04f90163          	beq	s2,a5,80003638 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800035fa:	ffe9079b          	addiw	a5,s2,-2
    800035fe:	4705                	li	a4,1
    80003600:	04f77563          	bgeu	a4,a5,8000364a <fileclose+0xaa>
    80003604:	7902                	ld	s2,32(sp)
    80003606:	69e2                	ld	s3,24(sp)
    80003608:	6a42                	ld	s4,16(sp)
    8000360a:	6aa2                	ld	s5,8(sp)
    8000360c:	a00d                	j	8000362e <fileclose+0x8e>
    8000360e:	f04a                	sd	s2,32(sp)
    80003610:	ec4e                	sd	s3,24(sp)
    80003612:	e852                	sd	s4,16(sp)
    80003614:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003616:	00004517          	auipc	a0,0x4
    8000361a:	f9250513          	addi	a0,a0,-110 # 800075a8 <etext+0x5a8>
    8000361e:	0e0020ef          	jal	800056fe <panic>
    release(&ftable.lock);
    80003622:	00017517          	auipc	a0,0x17
    80003626:	ec650513          	addi	a0,a0,-314 # 8001a4e8 <ftable>
    8000362a:	4a6020ef          	jal	80005ad0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000362e:	70e2                	ld	ra,56(sp)
    80003630:	7442                	ld	s0,48(sp)
    80003632:	74a2                	ld	s1,40(sp)
    80003634:	6121                	addi	sp,sp,64
    80003636:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003638:	85ce                	mv	a1,s3
    8000363a:	8552                	mv	a0,s4
    8000363c:	348000ef          	jal	80003984 <pipeclose>
    80003640:	7902                	ld	s2,32(sp)
    80003642:	69e2                	ld	s3,24(sp)
    80003644:	6a42                	ld	s4,16(sp)
    80003646:	6aa2                	ld	s5,8(sp)
    80003648:	b7dd                	j	8000362e <fileclose+0x8e>
    begin_op();
    8000364a:	b25ff0ef          	jal	8000316e <begin_op>
    iput(ff.ip);
    8000364e:	8556                	mv	a0,s5
    80003650:	be8ff0ef          	jal	80002a38 <iput>
    end_op();
    80003654:	b8bff0ef          	jal	800031de <end_op>
    80003658:	7902                	ld	s2,32(sp)
    8000365a:	69e2                	ld	s3,24(sp)
    8000365c:	6a42                	ld	s4,16(sp)
    8000365e:	6aa2                	ld	s5,8(sp)
    80003660:	b7f9                	j	8000362e <fileclose+0x8e>

0000000080003662 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003662:	715d                	addi	sp,sp,-80
    80003664:	e486                	sd	ra,72(sp)
    80003666:	e0a2                	sd	s0,64(sp)
    80003668:	fc26                	sd	s1,56(sp)
    8000366a:	f052                	sd	s4,32(sp)
    8000366c:	0880                	addi	s0,sp,80
    8000366e:	84aa                	mv	s1,a0
    80003670:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003672:	f14fd0ef          	jal	80000d86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003676:	409c                	lw	a5,0(s1)
    80003678:	37f9                	addiw	a5,a5,-2
    8000367a:	4705                	li	a4,1
    8000367c:	04f76263          	bltu	a4,a5,800036c0 <filestat+0x5e>
    80003680:	f84a                	sd	s2,48(sp)
    80003682:	f44e                	sd	s3,40(sp)
    80003684:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003686:	6c88                	ld	a0,24(s1)
    80003688:	a2eff0ef          	jal	800028b6 <ilock>
    stati(f->ip, &st);
    8000368c:	fb840913          	addi	s2,s0,-72
    80003690:	85ca                	mv	a1,s2
    80003692:	6c88                	ld	a0,24(s1)
    80003694:	c4eff0ef          	jal	80002ae2 <stati>
    iunlock(f->ip);
    80003698:	6c88                	ld	a0,24(s1)
    8000369a:	acaff0ef          	jal	80002964 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000369e:	46e1                	li	a3,24
    800036a0:	864a                	mv	a2,s2
    800036a2:	85d2                	mv	a1,s4
    800036a4:	0509b503          	ld	a0,80(s3)
    800036a8:	b5afd0ef          	jal	80000a02 <copyout>
    800036ac:	41f5551b          	sraiw	a0,a0,0x1f
    800036b0:	7942                	ld	s2,48(sp)
    800036b2:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036b4:	60a6                	ld	ra,72(sp)
    800036b6:	6406                	ld	s0,64(sp)
    800036b8:	74e2                	ld	s1,56(sp)
    800036ba:	7a02                	ld	s4,32(sp)
    800036bc:	6161                	addi	sp,sp,80
    800036be:	8082                	ret
  return -1;
    800036c0:	557d                	li	a0,-1
    800036c2:	bfcd                	j	800036b4 <filestat+0x52>

00000000800036c4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036c4:	7179                	addi	sp,sp,-48
    800036c6:	f406                	sd	ra,40(sp)
    800036c8:	f022                	sd	s0,32(sp)
    800036ca:	e84a                	sd	s2,16(sp)
    800036cc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036ce:	00854783          	lbu	a5,8(a0)
    800036d2:	cfd1                	beqz	a5,8000376e <fileread+0xaa>
    800036d4:	ec26                	sd	s1,24(sp)
    800036d6:	e44e                	sd	s3,8(sp)
    800036d8:	84aa                	mv	s1,a0
    800036da:	892e                	mv	s2,a1
    800036dc:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800036de:	411c                	lw	a5,0(a0)
    800036e0:	4705                	li	a4,1
    800036e2:	04e78363          	beq	a5,a4,80003728 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036e6:	470d                	li	a4,3
    800036e8:	04e78763          	beq	a5,a4,80003736 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800036ec:	4709                	li	a4,2
    800036ee:	06e79a63          	bne	a5,a4,80003762 <fileread+0x9e>
    ilock(f->ip);
    800036f2:	6d08                	ld	a0,24(a0)
    800036f4:	9c2ff0ef          	jal	800028b6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800036f8:	874e                	mv	a4,s3
    800036fa:	5094                	lw	a3,32(s1)
    800036fc:	864a                	mv	a2,s2
    800036fe:	4585                	li	a1,1
    80003700:	6c88                	ld	a0,24(s1)
    80003702:	c0eff0ef          	jal	80002b10 <readi>
    80003706:	892a                	mv	s2,a0
    80003708:	00a05563          	blez	a0,80003712 <fileread+0x4e>
      f->off += r;
    8000370c:	509c                	lw	a5,32(s1)
    8000370e:	9fa9                	addw	a5,a5,a0
    80003710:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003712:	6c88                	ld	a0,24(s1)
    80003714:	a50ff0ef          	jal	80002964 <iunlock>
    80003718:	64e2                	ld	s1,24(sp)
    8000371a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000371c:	854a                	mv	a0,s2
    8000371e:	70a2                	ld	ra,40(sp)
    80003720:	7402                	ld	s0,32(sp)
    80003722:	6942                	ld	s2,16(sp)
    80003724:	6145                	addi	sp,sp,48
    80003726:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003728:	6908                	ld	a0,16(a0)
    8000372a:	3b0000ef          	jal	80003ada <piperead>
    8000372e:	892a                	mv	s2,a0
    80003730:	64e2                	ld	s1,24(sp)
    80003732:	69a2                	ld	s3,8(sp)
    80003734:	b7e5                	j	8000371c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003736:	02451783          	lh	a5,36(a0)
    8000373a:	03079693          	slli	a3,a5,0x30
    8000373e:	92c1                	srli	a3,a3,0x30
    80003740:	4725                	li	a4,9
    80003742:	02d76963          	bltu	a4,a3,80003774 <fileread+0xb0>
    80003746:	0792                	slli	a5,a5,0x4
    80003748:	00017717          	auipc	a4,0x17
    8000374c:	d0070713          	addi	a4,a4,-768 # 8001a448 <devsw>
    80003750:	97ba                	add	a5,a5,a4
    80003752:	639c                	ld	a5,0(a5)
    80003754:	c78d                	beqz	a5,8000377e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003756:	4505                	li	a0,1
    80003758:	9782                	jalr	a5
    8000375a:	892a                	mv	s2,a0
    8000375c:	64e2                	ld	s1,24(sp)
    8000375e:	69a2                	ld	s3,8(sp)
    80003760:	bf75                	j	8000371c <fileread+0x58>
    panic("fileread");
    80003762:	00004517          	auipc	a0,0x4
    80003766:	e5650513          	addi	a0,a0,-426 # 800075b8 <etext+0x5b8>
    8000376a:	795010ef          	jal	800056fe <panic>
    return -1;
    8000376e:	57fd                	li	a5,-1
    80003770:	893e                	mv	s2,a5
    80003772:	b76d                	j	8000371c <fileread+0x58>
      return -1;
    80003774:	57fd                	li	a5,-1
    80003776:	893e                	mv	s2,a5
    80003778:	64e2                	ld	s1,24(sp)
    8000377a:	69a2                	ld	s3,8(sp)
    8000377c:	b745                	j	8000371c <fileread+0x58>
    8000377e:	57fd                	li	a5,-1
    80003780:	893e                	mv	s2,a5
    80003782:	64e2                	ld	s1,24(sp)
    80003784:	69a2                	ld	s3,8(sp)
    80003786:	bf59                	j	8000371c <fileread+0x58>

0000000080003788 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003788:	00954783          	lbu	a5,9(a0)
    8000378c:	10078f63          	beqz	a5,800038aa <filewrite+0x122>
{
    80003790:	711d                	addi	sp,sp,-96
    80003792:	ec86                	sd	ra,88(sp)
    80003794:	e8a2                	sd	s0,80(sp)
    80003796:	e0ca                	sd	s2,64(sp)
    80003798:	f456                	sd	s5,40(sp)
    8000379a:	f05a                	sd	s6,32(sp)
    8000379c:	1080                	addi	s0,sp,96
    8000379e:	892a                	mv	s2,a0
    800037a0:	8b2e                	mv	s6,a1
    800037a2:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800037a4:	411c                	lw	a5,0(a0)
    800037a6:	4705                	li	a4,1
    800037a8:	02e78a63          	beq	a5,a4,800037dc <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037ac:	470d                	li	a4,3
    800037ae:	02e78b63          	beq	a5,a4,800037e4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037b2:	4709                	li	a4,2
    800037b4:	0ce79f63          	bne	a5,a4,80003892 <filewrite+0x10a>
    800037b8:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037ba:	0ac05a63          	blez	a2,8000386e <filewrite+0xe6>
    800037be:	e4a6                	sd	s1,72(sp)
    800037c0:	fc4e                	sd	s3,56(sp)
    800037c2:	ec5e                	sd	s7,24(sp)
    800037c4:	e862                	sd	s8,16(sp)
    800037c6:	e466                	sd	s9,8(sp)
    int i = 0;
    800037c8:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037ca:	6b85                	lui	s7,0x1
    800037cc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037d0:	6785                	lui	a5,0x1
    800037d2:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800037d6:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037d8:	4c05                	li	s8,1
    800037da:	a8ad                	j	80003854 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800037dc:	6908                	ld	a0,16(a0)
    800037de:	204000ef          	jal	800039e2 <pipewrite>
    800037e2:	a04d                	j	80003884 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800037e4:	02451783          	lh	a5,36(a0)
    800037e8:	03079693          	slli	a3,a5,0x30
    800037ec:	92c1                	srli	a3,a3,0x30
    800037ee:	4725                	li	a4,9
    800037f0:	0ad76f63          	bltu	a4,a3,800038ae <filewrite+0x126>
    800037f4:	0792                	slli	a5,a5,0x4
    800037f6:	00017717          	auipc	a4,0x17
    800037fa:	c5270713          	addi	a4,a4,-942 # 8001a448 <devsw>
    800037fe:	97ba                	add	a5,a5,a4
    80003800:	679c                	ld	a5,8(a5)
    80003802:	cbc5                	beqz	a5,800038b2 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003804:	4505                	li	a0,1
    80003806:	9782                	jalr	a5
    80003808:	a8b5                	j	80003884 <filewrite+0xfc>
      if(n1 > max)
    8000380a:	2981                	sext.w	s3,s3
      begin_op();
    8000380c:	963ff0ef          	jal	8000316e <begin_op>
      ilock(f->ip);
    80003810:	01893503          	ld	a0,24(s2)
    80003814:	8a2ff0ef          	jal	800028b6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003818:	874e                	mv	a4,s3
    8000381a:	02092683          	lw	a3,32(s2)
    8000381e:	016a0633          	add	a2,s4,s6
    80003822:	85e2                	mv	a1,s8
    80003824:	01893503          	ld	a0,24(s2)
    80003828:	bdaff0ef          	jal	80002c02 <writei>
    8000382c:	84aa                	mv	s1,a0
    8000382e:	00a05763          	blez	a0,8000383c <filewrite+0xb4>
        f->off += r;
    80003832:	02092783          	lw	a5,32(s2)
    80003836:	9fa9                	addw	a5,a5,a0
    80003838:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000383c:	01893503          	ld	a0,24(s2)
    80003840:	924ff0ef          	jal	80002964 <iunlock>
      end_op();
    80003844:	99bff0ef          	jal	800031de <end_op>

      if(r != n1){
    80003848:	02999563          	bne	s3,s1,80003872 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000384c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003850:	015a5963          	bge	s4,s5,80003862 <filewrite+0xda>
      int n1 = n - i;
    80003854:	414a87bb          	subw	a5,s5,s4
    80003858:	89be                	mv	s3,a5
      if(n1 > max)
    8000385a:	fafbd8e3          	bge	s7,a5,8000380a <filewrite+0x82>
    8000385e:	89e6                	mv	s3,s9
    80003860:	b76d                	j	8000380a <filewrite+0x82>
    80003862:	64a6                	ld	s1,72(sp)
    80003864:	79e2                	ld	s3,56(sp)
    80003866:	6be2                	ld	s7,24(sp)
    80003868:	6c42                	ld	s8,16(sp)
    8000386a:	6ca2                	ld	s9,8(sp)
    8000386c:	a801                	j	8000387c <filewrite+0xf4>
    int i = 0;
    8000386e:	4a01                	li	s4,0
    80003870:	a031                	j	8000387c <filewrite+0xf4>
    80003872:	64a6                	ld	s1,72(sp)
    80003874:	79e2                	ld	s3,56(sp)
    80003876:	6be2                	ld	s7,24(sp)
    80003878:	6c42                	ld	s8,16(sp)
    8000387a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000387c:	034a9d63          	bne	s5,s4,800038b6 <filewrite+0x12e>
    80003880:	8556                	mv	a0,s5
    80003882:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003884:	60e6                	ld	ra,88(sp)
    80003886:	6446                	ld	s0,80(sp)
    80003888:	6906                	ld	s2,64(sp)
    8000388a:	7aa2                	ld	s5,40(sp)
    8000388c:	7b02                	ld	s6,32(sp)
    8000388e:	6125                	addi	sp,sp,96
    80003890:	8082                	ret
    80003892:	e4a6                	sd	s1,72(sp)
    80003894:	fc4e                	sd	s3,56(sp)
    80003896:	f852                	sd	s4,48(sp)
    80003898:	ec5e                	sd	s7,24(sp)
    8000389a:	e862                	sd	s8,16(sp)
    8000389c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000389e:	00004517          	auipc	a0,0x4
    800038a2:	d2a50513          	addi	a0,a0,-726 # 800075c8 <etext+0x5c8>
    800038a6:	659010ef          	jal	800056fe <panic>
    return -1;
    800038aa:	557d                	li	a0,-1
}
    800038ac:	8082                	ret
      return -1;
    800038ae:	557d                	li	a0,-1
    800038b0:	bfd1                	j	80003884 <filewrite+0xfc>
    800038b2:	557d                	li	a0,-1
    800038b4:	bfc1                	j	80003884 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800038b6:	557d                	li	a0,-1
    800038b8:	7a42                	ld	s4,48(sp)
    800038ba:	b7e9                	j	80003884 <filewrite+0xfc>

00000000800038bc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038bc:	7179                	addi	sp,sp,-48
    800038be:	f406                	sd	ra,40(sp)
    800038c0:	f022                	sd	s0,32(sp)
    800038c2:	ec26                	sd	s1,24(sp)
    800038c4:	e052                	sd	s4,0(sp)
    800038c6:	1800                	addi	s0,sp,48
    800038c8:	84aa                	mv	s1,a0
    800038ca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038cc:	0005b023          	sd	zero,0(a1)
    800038d0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800038d4:	c29ff0ef          	jal	800034fc <filealloc>
    800038d8:	e088                	sd	a0,0(s1)
    800038da:	c549                	beqz	a0,80003964 <pipealloc+0xa8>
    800038dc:	c21ff0ef          	jal	800034fc <filealloc>
    800038e0:	00aa3023          	sd	a0,0(s4)
    800038e4:	cd25                	beqz	a0,8000395c <pipealloc+0xa0>
    800038e6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800038e8:	81dfc0ef          	jal	80000104 <kalloc>
    800038ec:	892a                	mv	s2,a0
    800038ee:	c12d                	beqz	a0,80003950 <pipealloc+0x94>
    800038f0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800038f2:	4985                	li	s3,1
    800038f4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800038f8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800038fc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003900:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003904:	00004597          	auipc	a1,0x4
    80003908:	cd458593          	addi	a1,a1,-812 # 800075d8 <etext+0x5d8>
    8000390c:	0a6020ef          	jal	800059b2 <initlock>
  (*f0)->type = FD_PIPE;
    80003910:	609c                	ld	a5,0(s1)
    80003912:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003916:	609c                	ld	a5,0(s1)
    80003918:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000391c:	609c                	ld	a5,0(s1)
    8000391e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003922:	609c                	ld	a5,0(s1)
    80003924:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003928:	000a3783          	ld	a5,0(s4)
    8000392c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003930:	000a3783          	ld	a5,0(s4)
    80003934:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003938:	000a3783          	ld	a5,0(s4)
    8000393c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003940:	000a3783          	ld	a5,0(s4)
    80003944:	0127b823          	sd	s2,16(a5)
  return 0;
    80003948:	4501                	li	a0,0
    8000394a:	6942                	ld	s2,16(sp)
    8000394c:	69a2                	ld	s3,8(sp)
    8000394e:	a01d                	j	80003974 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003950:	6088                	ld	a0,0(s1)
    80003952:	c119                	beqz	a0,80003958 <pipealloc+0x9c>
    80003954:	6942                	ld	s2,16(sp)
    80003956:	a029                	j	80003960 <pipealloc+0xa4>
    80003958:	6942                	ld	s2,16(sp)
    8000395a:	a029                	j	80003964 <pipealloc+0xa8>
    8000395c:	6088                	ld	a0,0(s1)
    8000395e:	c10d                	beqz	a0,80003980 <pipealloc+0xc4>
    fileclose(*f0);
    80003960:	c41ff0ef          	jal	800035a0 <fileclose>
  if(*f1)
    80003964:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003968:	557d                	li	a0,-1
  if(*f1)
    8000396a:	c789                	beqz	a5,80003974 <pipealloc+0xb8>
    fileclose(*f1);
    8000396c:	853e                	mv	a0,a5
    8000396e:	c33ff0ef          	jal	800035a0 <fileclose>
  return -1;
    80003972:	557d                	li	a0,-1
}
    80003974:	70a2                	ld	ra,40(sp)
    80003976:	7402                	ld	s0,32(sp)
    80003978:	64e2                	ld	s1,24(sp)
    8000397a:	6a02                	ld	s4,0(sp)
    8000397c:	6145                	addi	sp,sp,48
    8000397e:	8082                	ret
  return -1;
    80003980:	557d                	li	a0,-1
    80003982:	bfcd                	j	80003974 <pipealloc+0xb8>

0000000080003984 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
    80003992:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003994:	0a8020ef          	jal	80005a3c <acquire>
  if(writable){
    80003998:	02090763          	beqz	s2,800039c6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000399c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800039a0:	21848513          	addi	a0,s1,536
    800039a4:	a0dfd0ef          	jal	800013b0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039a8:	2204a783          	lw	a5,544(s1)
    800039ac:	e781                	bnez	a5,800039b4 <pipeclose+0x30>
    800039ae:	2244a783          	lw	a5,548(s1)
    800039b2:	c38d                	beqz	a5,800039d4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800039b4:	8526                	mv	a0,s1
    800039b6:	11a020ef          	jal	80005ad0 <release>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret
    pi->readopen = 0;
    800039c6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039ca:	21c48513          	addi	a0,s1,540
    800039ce:	9e3fd0ef          	jal	800013b0 <wakeup>
    800039d2:	bfd9                	j	800039a8 <pipeclose+0x24>
    release(&pi->lock);
    800039d4:	8526                	mv	a0,s1
    800039d6:	0fa020ef          	jal	80005ad0 <release>
    kfree((char*)pi);
    800039da:	8526                	mv	a0,s1
    800039dc:	e40fc0ef          	jal	8000001c <kfree>
    800039e0:	bfe9                	j	800039ba <pipeclose+0x36>

00000000800039e2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800039e2:	7159                	addi	sp,sp,-112
    800039e4:	f486                	sd	ra,104(sp)
    800039e6:	f0a2                	sd	s0,96(sp)
    800039e8:	eca6                	sd	s1,88(sp)
    800039ea:	e8ca                	sd	s2,80(sp)
    800039ec:	e4ce                	sd	s3,72(sp)
    800039ee:	e0d2                	sd	s4,64(sp)
    800039f0:	fc56                	sd	s5,56(sp)
    800039f2:	1880                	addi	s0,sp,112
    800039f4:	84aa                	mv	s1,a0
    800039f6:	8aae                	mv	s5,a1
    800039f8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800039fa:	b8cfd0ef          	jal	80000d86 <myproc>
    800039fe:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a00:	8526                	mv	a0,s1
    80003a02:	03a020ef          	jal	80005a3c <acquire>
  while(i < n){
    80003a06:	0d405263          	blez	s4,80003aca <pipewrite+0xe8>
    80003a0a:	f85a                	sd	s6,48(sp)
    80003a0c:	f45e                	sd	s7,40(sp)
    80003a0e:	f062                	sd	s8,32(sp)
    80003a10:	ec66                	sd	s9,24(sp)
    80003a12:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a14:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a16:	f9f40c13          	addi	s8,s0,-97
    80003a1a:	4b85                	li	s7,1
    80003a1c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a1e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a22:	21c48c93          	addi	s9,s1,540
    80003a26:	a82d                	j	80003a60 <pipewrite+0x7e>
      release(&pi->lock);
    80003a28:	8526                	mv	a0,s1
    80003a2a:	0a6020ef          	jal	80005ad0 <release>
      return -1;
    80003a2e:	597d                	li	s2,-1
    80003a30:	7b42                	ld	s6,48(sp)
    80003a32:	7ba2                	ld	s7,40(sp)
    80003a34:	7c02                	ld	s8,32(sp)
    80003a36:	6ce2                	ld	s9,24(sp)
    80003a38:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a3a:	854a                	mv	a0,s2
    80003a3c:	70a6                	ld	ra,104(sp)
    80003a3e:	7406                	ld	s0,96(sp)
    80003a40:	64e6                	ld	s1,88(sp)
    80003a42:	6946                	ld	s2,80(sp)
    80003a44:	69a6                	ld	s3,72(sp)
    80003a46:	6a06                	ld	s4,64(sp)
    80003a48:	7ae2                	ld	s5,56(sp)
    80003a4a:	6165                	addi	sp,sp,112
    80003a4c:	8082                	ret
      wakeup(&pi->nread);
    80003a4e:	856a                	mv	a0,s10
    80003a50:	961fd0ef          	jal	800013b0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a54:	85a6                	mv	a1,s1
    80003a56:	8566                	mv	a0,s9
    80003a58:	90dfd0ef          	jal	80001364 <sleep>
  while(i < n){
    80003a5c:	05495a63          	bge	s2,s4,80003ab0 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a60:	2204a783          	lw	a5,544(s1)
    80003a64:	d3f1                	beqz	a5,80003a28 <pipewrite+0x46>
    80003a66:	854e                	mv	a0,s3
    80003a68:	b39fd0ef          	jal	800015a0 <killed>
    80003a6c:	fd55                	bnez	a0,80003a28 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a6e:	2184a783          	lw	a5,536(s1)
    80003a72:	21c4a703          	lw	a4,540(s1)
    80003a76:	2007879b          	addiw	a5,a5,512
    80003a7a:	fcf70ae3          	beq	a4,a5,80003a4e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a7e:	86de                	mv	a3,s7
    80003a80:	01590633          	add	a2,s2,s5
    80003a84:	85e2                	mv	a1,s8
    80003a86:	0509b503          	ld	a0,80(s3)
    80003a8a:	828fd0ef          	jal	80000ab2 <copyin>
    80003a8e:	05650063          	beq	a0,s6,80003ace <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a92:	21c4a783          	lw	a5,540(s1)
    80003a96:	0017871b          	addiw	a4,a5,1
    80003a9a:	20e4ae23          	sw	a4,540(s1)
    80003a9e:	1ff7f793          	andi	a5,a5,511
    80003aa2:	97a6                	add	a5,a5,s1
    80003aa4:	f9f44703          	lbu	a4,-97(s0)
    80003aa8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003aac:	2905                	addiw	s2,s2,1
    80003aae:	b77d                	j	80003a5c <pipewrite+0x7a>
    80003ab0:	7b42                	ld	s6,48(sp)
    80003ab2:	7ba2                	ld	s7,40(sp)
    80003ab4:	7c02                	ld	s8,32(sp)
    80003ab6:	6ce2                	ld	s9,24(sp)
    80003ab8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003aba:	21848513          	addi	a0,s1,536
    80003abe:	8f3fd0ef          	jal	800013b0 <wakeup>
  release(&pi->lock);
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	00c020ef          	jal	80005ad0 <release>
  return i;
    80003ac8:	bf8d                	j	80003a3a <pipewrite+0x58>
  int i = 0;
    80003aca:	4901                	li	s2,0
    80003acc:	b7fd                	j	80003aba <pipewrite+0xd8>
    80003ace:	7b42                	ld	s6,48(sp)
    80003ad0:	7ba2                	ld	s7,40(sp)
    80003ad2:	7c02                	ld	s8,32(sp)
    80003ad4:	6ce2                	ld	s9,24(sp)
    80003ad6:	6d42                	ld	s10,16(sp)
    80003ad8:	b7cd                	j	80003aba <pipewrite+0xd8>

0000000080003ada <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ada:	711d                	addi	sp,sp,-96
    80003adc:	ec86                	sd	ra,88(sp)
    80003ade:	e8a2                	sd	s0,80(sp)
    80003ae0:	e4a6                	sd	s1,72(sp)
    80003ae2:	e0ca                	sd	s2,64(sp)
    80003ae4:	fc4e                	sd	s3,56(sp)
    80003ae6:	f852                	sd	s4,48(sp)
    80003ae8:	f456                	sd	s5,40(sp)
    80003aea:	1080                	addi	s0,sp,96
    80003aec:	84aa                	mv	s1,a0
    80003aee:	892e                	mv	s2,a1
    80003af0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003af2:	a94fd0ef          	jal	80000d86 <myproc>
    80003af6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003af8:	8526                	mv	a0,s1
    80003afa:	743010ef          	jal	80005a3c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003afe:	2184a703          	lw	a4,536(s1)
    80003b02:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b06:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b0a:	02f71763          	bne	a4,a5,80003b38 <piperead+0x5e>
    80003b0e:	2244a783          	lw	a5,548(s1)
    80003b12:	cf85                	beqz	a5,80003b4a <piperead+0x70>
    if(killed(pr)){
    80003b14:	8552                	mv	a0,s4
    80003b16:	a8bfd0ef          	jal	800015a0 <killed>
    80003b1a:	e11d                	bnez	a0,80003b40 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b1c:	85a6                	mv	a1,s1
    80003b1e:	854e                	mv	a0,s3
    80003b20:	845fd0ef          	jal	80001364 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b24:	2184a703          	lw	a4,536(s1)
    80003b28:	21c4a783          	lw	a5,540(s1)
    80003b2c:	fef701e3          	beq	a4,a5,80003b0e <piperead+0x34>
    80003b30:	f05a                	sd	s6,32(sp)
    80003b32:	ec5e                	sd	s7,24(sp)
    80003b34:	e862                	sd	s8,16(sp)
    80003b36:	a829                	j	80003b50 <piperead+0x76>
    80003b38:	f05a                	sd	s6,32(sp)
    80003b3a:	ec5e                	sd	s7,24(sp)
    80003b3c:	e862                	sd	s8,16(sp)
    80003b3e:	a809                	j	80003b50 <piperead+0x76>
      release(&pi->lock);
    80003b40:	8526                	mv	a0,s1
    80003b42:	78f010ef          	jal	80005ad0 <release>
      return -1;
    80003b46:	59fd                	li	s3,-1
    80003b48:	a09d                	j	80003bae <piperead+0xd4>
    80003b4a:	f05a                	sd	s6,32(sp)
    80003b4c:	ec5e                	sd	s7,24(sp)
    80003b4e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b50:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b52:	faf40c13          	addi	s8,s0,-81
    80003b56:	4b85                	li	s7,1
    80003b58:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b5a:	05505063          	blez	s5,80003b9a <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b5e:	2184a783          	lw	a5,536(s1)
    80003b62:	21c4a703          	lw	a4,540(s1)
    80003b66:	02f70a63          	beq	a4,a5,80003b9a <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b6a:	0017871b          	addiw	a4,a5,1
    80003b6e:	20e4ac23          	sw	a4,536(s1)
    80003b72:	1ff7f793          	andi	a5,a5,511
    80003b76:	97a6                	add	a5,a5,s1
    80003b78:	0187c783          	lbu	a5,24(a5)
    80003b7c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b80:	86de                	mv	a3,s7
    80003b82:	8662                	mv	a2,s8
    80003b84:	85ca                	mv	a1,s2
    80003b86:	050a3503          	ld	a0,80(s4)
    80003b8a:	e79fc0ef          	jal	80000a02 <copyout>
    80003b8e:	01650663          	beq	a0,s6,80003b9a <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b92:	2985                	addiw	s3,s3,1
    80003b94:	0905                	addi	s2,s2,1
    80003b96:	fd3a94e3          	bne	s5,s3,80003b5e <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003b9a:	21c48513          	addi	a0,s1,540
    80003b9e:	813fd0ef          	jal	800013b0 <wakeup>
  release(&pi->lock);
    80003ba2:	8526                	mv	a0,s1
    80003ba4:	72d010ef          	jal	80005ad0 <release>
    80003ba8:	7b02                	ld	s6,32(sp)
    80003baa:	6be2                	ld	s7,24(sp)
    80003bac:	6c42                	ld	s8,16(sp)
  return i;
}
    80003bae:	854e                	mv	a0,s3
    80003bb0:	60e6                	ld	ra,88(sp)
    80003bb2:	6446                	ld	s0,80(sp)
    80003bb4:	64a6                	ld	s1,72(sp)
    80003bb6:	6906                	ld	s2,64(sp)
    80003bb8:	79e2                	ld	s3,56(sp)
    80003bba:	7a42                	ld	s4,48(sp)
    80003bbc:	7aa2                	ld	s5,40(sp)
    80003bbe:	6125                	addi	sp,sp,96
    80003bc0:	8082                	ret

0000000080003bc2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003bc2:	1141                	addi	sp,sp,-16
    80003bc4:	e406                	sd	ra,8(sp)
    80003bc6:	e022                	sd	s0,0(sp)
    80003bc8:	0800                	addi	s0,sp,16
    80003bca:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bcc:	0035151b          	slliw	a0,a0,0x3
    80003bd0:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003bd2:	8b89                	andi	a5,a5,2
    80003bd4:	c399                	beqz	a5,80003bda <flags2perm+0x18>
      perm |= PTE_W;
    80003bd6:	00456513          	ori	a0,a0,4
    return perm;
}
    80003bda:	60a2                	ld	ra,8(sp)
    80003bdc:	6402                	ld	s0,0(sp)
    80003bde:	0141                	addi	sp,sp,16
    80003be0:	8082                	ret

0000000080003be2 <exec>:

int
exec(char *path, char **argv)
{
    80003be2:	de010113          	addi	sp,sp,-544
    80003be6:	20113c23          	sd	ra,536(sp)
    80003bea:	20813823          	sd	s0,528(sp)
    80003bee:	20913423          	sd	s1,520(sp)
    80003bf2:	21213023          	sd	s2,512(sp)
    80003bf6:	1400                	addi	s0,sp,544
    80003bf8:	892a                	mv	s2,a0
    80003bfa:	dea43823          	sd	a0,-528(s0)
    80003bfe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c02:	984fd0ef          	jal	80000d86 <myproc>
    80003c06:	84aa                	mv	s1,a0

  begin_op();
    80003c08:	d66ff0ef          	jal	8000316e <begin_op>

  if((ip = namei(path)) == 0){
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	b9eff0ef          	jal	80002fac <namei>
    80003c12:	cd21                	beqz	a0,80003c6a <exec+0x88>
    80003c14:	fbd2                	sd	s4,496(sp)
    80003c16:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c18:	c9ffe0ef          	jal	800028b6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c1c:	04000713          	li	a4,64
    80003c20:	4681                	li	a3,0
    80003c22:	e5040613          	addi	a2,s0,-432
    80003c26:	4581                	li	a1,0
    80003c28:	8552                	mv	a0,s4
    80003c2a:	ee7fe0ef          	jal	80002b10 <readi>
    80003c2e:	04000793          	li	a5,64
    80003c32:	00f51a63          	bne	a0,a5,80003c46 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003c36:	e5042703          	lw	a4,-432(s0)
    80003c3a:	464c47b7          	lui	a5,0x464c4
    80003c3e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c42:	02f70863          	beq	a4,a5,80003c72 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c46:	8552                	mv	a0,s4
    80003c48:	e7bfe0ef          	jal	80002ac2 <iunlockput>
    end_op();
    80003c4c:	d92ff0ef          	jal	800031de <end_op>
  }
  return -1;
    80003c50:	557d                	li	a0,-1
    80003c52:	7a5e                	ld	s4,496(sp)
}
    80003c54:	21813083          	ld	ra,536(sp)
    80003c58:	21013403          	ld	s0,528(sp)
    80003c5c:	20813483          	ld	s1,520(sp)
    80003c60:	20013903          	ld	s2,512(sp)
    80003c64:	22010113          	addi	sp,sp,544
    80003c68:	8082                	ret
    end_op();
    80003c6a:	d74ff0ef          	jal	800031de <end_op>
    return -1;
    80003c6e:	557d                	li	a0,-1
    80003c70:	b7d5                	j	80003c54 <exec+0x72>
    80003c72:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c74:	8526                	mv	a0,s1
    80003c76:	9bafd0ef          	jal	80000e30 <proc_pagetable>
    80003c7a:	8b2a                	mv	s6,a0
    80003c7c:	26050d63          	beqz	a0,80003ef6 <exec+0x314>
    80003c80:	ffce                	sd	s3,504(sp)
    80003c82:	f7d6                	sd	s5,488(sp)
    80003c84:	efde                	sd	s7,472(sp)
    80003c86:	ebe2                	sd	s8,464(sp)
    80003c88:	e7e6                	sd	s9,456(sp)
    80003c8a:	e3ea                	sd	s10,448(sp)
    80003c8c:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c8e:	e8845783          	lhu	a5,-376(s0)
    80003c92:	0e078963          	beqz	a5,80003d84 <exec+0x1a2>
    80003c96:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c9a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c9c:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c9e:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003ca2:	6c85                	lui	s9,0x1
    80003ca4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ca8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cac:	6a85                	lui	s5,0x1
    80003cae:	a085                	j	80003d0e <exec+0x12c>
      panic("loadseg: address should exist");
    80003cb0:	00004517          	auipc	a0,0x4
    80003cb4:	93050513          	addi	a0,a0,-1744 # 800075e0 <etext+0x5e0>
    80003cb8:	247010ef          	jal	800056fe <panic>
    if(sz - i < PGSIZE)
    80003cbc:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003cbe:	874a                	mv	a4,s2
    80003cc0:	009b86bb          	addw	a3,s7,s1
    80003cc4:	4581                	li	a1,0
    80003cc6:	8552                	mv	a0,s4
    80003cc8:	e49fe0ef          	jal	80002b10 <readi>
    80003ccc:	22a91963          	bne	s2,a0,80003efe <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003cd0:	009a84bb          	addw	s1,s5,s1
    80003cd4:	0334f263          	bgeu	s1,s3,80003cf8 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003cd8:	02049593          	slli	a1,s1,0x20
    80003cdc:	9181                	srli	a1,a1,0x20
    80003cde:	95e2                	add	a1,a1,s8
    80003ce0:	855a                	mv	a0,s6
    80003ce2:	faafc0ef          	jal	8000048c <walkaddr>
    80003ce6:	862a                	mv	a2,a0
    if(pa == 0)
    80003ce8:	d561                	beqz	a0,80003cb0 <exec+0xce>
    if(sz - i < PGSIZE)
    80003cea:	409987bb          	subw	a5,s3,s1
    80003cee:	893e                	mv	s2,a5
    80003cf0:	fcfcf6e3          	bgeu	s9,a5,80003cbc <exec+0xda>
    80003cf4:	8956                	mv	s2,s5
    80003cf6:	b7d9                	j	80003cbc <exec+0xda>
    sz = sz1;
    80003cf8:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cfc:	2d05                	addiw	s10,s10,1
    80003cfe:	e0843783          	ld	a5,-504(s0)
    80003d02:	0387869b          	addiw	a3,a5,56
    80003d06:	e8845783          	lhu	a5,-376(s0)
    80003d0a:	06fd5e63          	bge	s10,a5,80003d86 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d0e:	e0d43423          	sd	a3,-504(s0)
    80003d12:	876e                	mv	a4,s11
    80003d14:	e1840613          	addi	a2,s0,-488
    80003d18:	4581                	li	a1,0
    80003d1a:	8552                	mv	a0,s4
    80003d1c:	df5fe0ef          	jal	80002b10 <readi>
    80003d20:	1db51d63          	bne	a0,s11,80003efa <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003d24:	e1842783          	lw	a5,-488(s0)
    80003d28:	4705                	li	a4,1
    80003d2a:	fce799e3          	bne	a5,a4,80003cfc <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d2e:	e4043483          	ld	s1,-448(s0)
    80003d32:	e3843783          	ld	a5,-456(s0)
    80003d36:	1ef4e263          	bltu	s1,a5,80003f1a <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d3a:	e2843783          	ld	a5,-472(s0)
    80003d3e:	94be                	add	s1,s1,a5
    80003d40:	1ef4e063          	bltu	s1,a5,80003f20 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003d44:	de843703          	ld	a4,-536(s0)
    80003d48:	8ff9                	and	a5,a5,a4
    80003d4a:	1c079e63          	bnez	a5,80003f26 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d4e:	e1c42503          	lw	a0,-484(s0)
    80003d52:	e71ff0ef          	jal	80003bc2 <flags2perm>
    80003d56:	86aa                	mv	a3,a0
    80003d58:	8626                	mv	a2,s1
    80003d5a:	85ca                	mv	a1,s2
    80003d5c:	855a                	mv	a0,s6
    80003d5e:	a95fc0ef          	jal	800007f2 <uvmalloc>
    80003d62:	dea43c23          	sd	a0,-520(s0)
    80003d66:	1c050363          	beqz	a0,80003f2c <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d6a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d6e:	00098863          	beqz	s3,80003d7e <exec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d72:	e2843c03          	ld	s8,-472(s0)
    80003d76:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d7a:	4481                	li	s1,0
    80003d7c:	bfb1                	j	80003cd8 <exec+0xf6>
    sz = sz1;
    80003d7e:	df843903          	ld	s2,-520(s0)
    80003d82:	bfad                	j	80003cfc <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d84:	4901                	li	s2,0
  iunlockput(ip);
    80003d86:	8552                	mv	a0,s4
    80003d88:	d3bfe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    80003d8c:	c52ff0ef          	jal	800031de <end_op>
  p = myproc();
    80003d90:	ff7fc0ef          	jal	80000d86 <myproc>
    80003d94:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003d96:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d9a:	6985                	lui	s3,0x1
    80003d9c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d9e:	99ca                	add	s3,s3,s2
    80003da0:	77fd                	lui	a5,0xfffff
    80003da2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003da6:	4691                	li	a3,4
    80003da8:	660d                	lui	a2,0x3
    80003daa:	964e                	add	a2,a2,s3
    80003dac:	85ce                	mv	a1,s3
    80003dae:	855a                	mv	a0,s6
    80003db0:	a43fc0ef          	jal	800007f2 <uvmalloc>
    80003db4:	8a2a                	mv	s4,a0
    80003db6:	e105                	bnez	a0,80003dd6 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003db8:	85ce                	mv	a1,s3
    80003dba:	855a                	mv	a0,s6
    80003dbc:	8f8fd0ef          	jal	80000eb4 <proc_freepagetable>
  return -1;
    80003dc0:	557d                	li	a0,-1
    80003dc2:	79fe                	ld	s3,504(sp)
    80003dc4:	7a5e                	ld	s4,496(sp)
    80003dc6:	7abe                	ld	s5,488(sp)
    80003dc8:	7b1e                	ld	s6,480(sp)
    80003dca:	6bfe                	ld	s7,472(sp)
    80003dcc:	6c5e                	ld	s8,464(sp)
    80003dce:	6cbe                	ld	s9,456(sp)
    80003dd0:	6d1e                	ld	s10,448(sp)
    80003dd2:	7dfa                	ld	s11,440(sp)
    80003dd4:	b541                	j	80003c54 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003dd6:	75f5                	lui	a1,0xffffd
    80003dd8:	95aa                	add	a1,a1,a0
    80003dda:	855a                	mv	a0,s6
    80003ddc:	bfdfc0ef          	jal	800009d8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003de0:	7bf9                	lui	s7,0xffffe
    80003de2:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003de4:	e0043783          	ld	a5,-512(s0)
    80003de8:	6388                	ld	a0,0(a5)
  sp = sz;
    80003dea:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003dec:	4481                	li	s1,0
    ustack[argc] = sp;
    80003dee:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003df2:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003df6:	cd21                	beqz	a0,80003e4e <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003df8:	cf0fc0ef          	jal	800002e8 <strlen>
    80003dfc:	0015079b          	addiw	a5,a0,1
    80003e00:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e04:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e08:	13796563          	bltu	s2,s7,80003f32 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e0c:	e0043d83          	ld	s11,-512(s0)
    80003e10:	000db983          	ld	s3,0(s11)
    80003e14:	854e                	mv	a0,s3
    80003e16:	cd2fc0ef          	jal	800002e8 <strlen>
    80003e1a:	0015069b          	addiw	a3,a0,1
    80003e1e:	864e                	mv	a2,s3
    80003e20:	85ca                	mv	a1,s2
    80003e22:	855a                	mv	a0,s6
    80003e24:	bdffc0ef          	jal	80000a02 <copyout>
    80003e28:	10054763          	bltz	a0,80003f36 <exec+0x354>
    ustack[argc] = sp;
    80003e2c:	00349793          	slli	a5,s1,0x3
    80003e30:	97e6                	add	a5,a5,s9
    80003e32:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb920>
  for(argc = 0; argv[argc]; argc++) {
    80003e36:	0485                	addi	s1,s1,1
    80003e38:	008d8793          	addi	a5,s11,8
    80003e3c:	e0f43023          	sd	a5,-512(s0)
    80003e40:	008db503          	ld	a0,8(s11)
    80003e44:	c509                	beqz	a0,80003e4e <exec+0x26c>
    if(argc >= MAXARG)
    80003e46:	fb8499e3          	bne	s1,s8,80003df8 <exec+0x216>
  sz = sz1;
    80003e4a:	89d2                	mv	s3,s4
    80003e4c:	b7b5                	j	80003db8 <exec+0x1d6>
  ustack[argc] = 0;
    80003e4e:	00349793          	slli	a5,s1,0x3
    80003e52:	f9078793          	addi	a5,a5,-112
    80003e56:	97a2                	add	a5,a5,s0
    80003e58:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e5c:	00349693          	slli	a3,s1,0x3
    80003e60:	06a1                	addi	a3,a3,8
    80003e62:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e66:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e6a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e6c:	f57966e3          	bltu	s2,s7,80003db8 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e70:	e9040613          	addi	a2,s0,-368
    80003e74:	85ca                	mv	a1,s2
    80003e76:	855a                	mv	a0,s6
    80003e78:	b8bfc0ef          	jal	80000a02 <copyout>
    80003e7c:	f2054ee3          	bltz	a0,80003db8 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003e80:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e84:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e88:	df043783          	ld	a5,-528(s0)
    80003e8c:	0007c703          	lbu	a4,0(a5)
    80003e90:	cf11                	beqz	a4,80003eac <exec+0x2ca>
    80003e92:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e94:	02f00693          	li	a3,47
    80003e98:	a029                	j	80003ea2 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003e9a:	0785                	addi	a5,a5,1
    80003e9c:	fff7c703          	lbu	a4,-1(a5)
    80003ea0:	c711                	beqz	a4,80003eac <exec+0x2ca>
    if(*s == '/')
    80003ea2:	fed71ce3          	bne	a4,a3,80003e9a <exec+0x2b8>
      last = s+1;
    80003ea6:	def43823          	sd	a5,-528(s0)
    80003eaa:	bfc5                	j	80003e9a <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003eac:	4641                	li	a2,16
    80003eae:	df043583          	ld	a1,-528(s0)
    80003eb2:	158a8513          	addi	a0,s5,344
    80003eb6:	bfcfc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003eba:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ebe:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ec2:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003ec6:	058ab783          	ld	a5,88(s5)
    80003eca:	e6843703          	ld	a4,-408(s0)
    80003ece:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ed0:	058ab783          	ld	a5,88(s5)
    80003ed4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ed8:	85ea                	mv	a1,s10
    80003eda:	fdbfc0ef          	jal	80000eb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003ede:	0004851b          	sext.w	a0,s1
    80003ee2:	79fe                	ld	s3,504(sp)
    80003ee4:	7a5e                	ld	s4,496(sp)
    80003ee6:	7abe                	ld	s5,488(sp)
    80003ee8:	7b1e                	ld	s6,480(sp)
    80003eea:	6bfe                	ld	s7,472(sp)
    80003eec:	6c5e                	ld	s8,464(sp)
    80003eee:	6cbe                	ld	s9,456(sp)
    80003ef0:	6d1e                	ld	s10,448(sp)
    80003ef2:	7dfa                	ld	s11,440(sp)
    80003ef4:	b385                	j	80003c54 <exec+0x72>
    80003ef6:	7b1e                	ld	s6,480(sp)
    80003ef8:	b3b9                	j	80003c46 <exec+0x64>
    80003efa:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003efe:	df843583          	ld	a1,-520(s0)
    80003f02:	855a                	mv	a0,s6
    80003f04:	fb1fc0ef          	jal	80000eb4 <proc_freepagetable>
  if(ip){
    80003f08:	79fe                	ld	s3,504(sp)
    80003f0a:	7abe                	ld	s5,488(sp)
    80003f0c:	7b1e                	ld	s6,480(sp)
    80003f0e:	6bfe                	ld	s7,472(sp)
    80003f10:	6c5e                	ld	s8,464(sp)
    80003f12:	6cbe                	ld	s9,456(sp)
    80003f14:	6d1e                	ld	s10,448(sp)
    80003f16:	7dfa                	ld	s11,440(sp)
    80003f18:	b33d                	j	80003c46 <exec+0x64>
    80003f1a:	df243c23          	sd	s2,-520(s0)
    80003f1e:	b7c5                	j	80003efe <exec+0x31c>
    80003f20:	df243c23          	sd	s2,-520(s0)
    80003f24:	bfe9                	j	80003efe <exec+0x31c>
    80003f26:	df243c23          	sd	s2,-520(s0)
    80003f2a:	bfd1                	j	80003efe <exec+0x31c>
    80003f2c:	df243c23          	sd	s2,-520(s0)
    80003f30:	b7f9                	j	80003efe <exec+0x31c>
  sz = sz1;
    80003f32:	89d2                	mv	s3,s4
    80003f34:	b551                	j	80003db8 <exec+0x1d6>
    80003f36:	89d2                	mv	s3,s4
    80003f38:	b541                	j	80003db8 <exec+0x1d6>

0000000080003f3a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f3a:	7179                	addi	sp,sp,-48
    80003f3c:	f406                	sd	ra,40(sp)
    80003f3e:	f022                	sd	s0,32(sp)
    80003f40:	ec26                	sd	s1,24(sp)
    80003f42:	e84a                	sd	s2,16(sp)
    80003f44:	1800                	addi	s0,sp,48
    80003f46:	892e                	mv	s2,a1
    80003f48:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f4a:	fdc40593          	addi	a1,s0,-36
    80003f4e:	d05fd0ef          	jal	80001c52 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f52:	fdc42703          	lw	a4,-36(s0)
    80003f56:	47bd                	li	a5,15
    80003f58:	02e7ea63          	bltu	a5,a4,80003f8c <argfd+0x52>
    80003f5c:	e2bfc0ef          	jal	80000d86 <myproc>
    80003f60:	fdc42703          	lw	a4,-36(s0)
    80003f64:	00371793          	slli	a5,a4,0x3
    80003f68:	0d078793          	addi	a5,a5,208
    80003f6c:	953e                	add	a0,a0,a5
    80003f6e:	611c                	ld	a5,0(a0)
    80003f70:	c385                	beqz	a5,80003f90 <argfd+0x56>
    return -1;
  if(pfd)
    80003f72:	00090463          	beqz	s2,80003f7a <argfd+0x40>
    *pfd = fd;
    80003f76:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f7a:	4501                	li	a0,0
  if(pf)
    80003f7c:	c091                	beqz	s1,80003f80 <argfd+0x46>
    *pf = f;
    80003f7e:	e09c                	sd	a5,0(s1)
}
    80003f80:	70a2                	ld	ra,40(sp)
    80003f82:	7402                	ld	s0,32(sp)
    80003f84:	64e2                	ld	s1,24(sp)
    80003f86:	6942                	ld	s2,16(sp)
    80003f88:	6145                	addi	sp,sp,48
    80003f8a:	8082                	ret
    return -1;
    80003f8c:	557d                	li	a0,-1
    80003f8e:	bfcd                	j	80003f80 <argfd+0x46>
    80003f90:	557d                	li	a0,-1
    80003f92:	b7fd                	j	80003f80 <argfd+0x46>

0000000080003f94 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003f94:	1101                	addi	sp,sp,-32
    80003f96:	ec06                	sd	ra,24(sp)
    80003f98:	e822                	sd	s0,16(sp)
    80003f9a:	e426                	sd	s1,8(sp)
    80003f9c:	1000                	addi	s0,sp,32
    80003f9e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fa0:	de7fc0ef          	jal	80000d86 <myproc>
    80003fa4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fa6:	0d050793          	addi	a5,a0,208
    80003faa:	4501                	li	a0,0
    80003fac:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fae:	6398                	ld	a4,0(a5)
    80003fb0:	cb19                	beqz	a4,80003fc6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fb2:	2505                	addiw	a0,a0,1
    80003fb4:	07a1                	addi	a5,a5,8
    80003fb6:	fed51ce3          	bne	a0,a3,80003fae <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fba:	557d                	li	a0,-1
}
    80003fbc:	60e2                	ld	ra,24(sp)
    80003fbe:	6442                	ld	s0,16(sp)
    80003fc0:	64a2                	ld	s1,8(sp)
    80003fc2:	6105                	addi	sp,sp,32
    80003fc4:	8082                	ret
      p->ofile[fd] = f;
    80003fc6:	00351793          	slli	a5,a0,0x3
    80003fca:	0d078793          	addi	a5,a5,208
    80003fce:	963e                	add	a2,a2,a5
    80003fd0:	e204                	sd	s1,0(a2)
      return fd;
    80003fd2:	b7ed                	j	80003fbc <fdalloc+0x28>

0000000080003fd4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fd4:	715d                	addi	sp,sp,-80
    80003fd6:	e486                	sd	ra,72(sp)
    80003fd8:	e0a2                	sd	s0,64(sp)
    80003fda:	fc26                	sd	s1,56(sp)
    80003fdc:	f84a                	sd	s2,48(sp)
    80003fde:	f44e                	sd	s3,40(sp)
    80003fe0:	f052                	sd	s4,32(sp)
    80003fe2:	ec56                	sd	s5,24(sp)
    80003fe4:	e85a                	sd	s6,16(sp)
    80003fe6:	0880                	addi	s0,sp,80
    80003fe8:	892e                	mv	s2,a1
    80003fea:	8a2e                	mv	s4,a1
    80003fec:	8ab2                	mv	s5,a2
    80003fee:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003ff0:	fb040593          	addi	a1,s0,-80
    80003ff4:	fd3fe0ef          	jal	80002fc6 <nameiparent>
    80003ff8:	84aa                	mv	s1,a0
    80003ffa:	10050763          	beqz	a0,80004108 <create+0x134>
    return 0;

  ilock(dp);
    80003ffe:	8b9fe0ef          	jal	800028b6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004002:	4601                	li	a2,0
    80004004:	fb040593          	addi	a1,s0,-80
    80004008:	8526                	mv	a0,s1
    8000400a:	d0ffe0ef          	jal	80002d18 <dirlookup>
    8000400e:	89aa                	mv	s3,a0
    80004010:	c131                	beqz	a0,80004054 <create+0x80>
    iunlockput(dp);
    80004012:	8526                	mv	a0,s1
    80004014:	aaffe0ef          	jal	80002ac2 <iunlockput>
    ilock(ip);
    80004018:	854e                	mv	a0,s3
    8000401a:	89dfe0ef          	jal	800028b6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000401e:	4789                	li	a5,2
    80004020:	02f91563          	bne	s2,a5,8000404a <create+0x76>
    80004024:	0449d783          	lhu	a5,68(s3)
    80004028:	37f9                	addiw	a5,a5,-2
    8000402a:	17c2                	slli	a5,a5,0x30
    8000402c:	93c1                	srli	a5,a5,0x30
    8000402e:	4705                	li	a4,1
    80004030:	00f76d63          	bltu	a4,a5,8000404a <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004034:	854e                	mv	a0,s3
    80004036:	60a6                	ld	ra,72(sp)
    80004038:	6406                	ld	s0,64(sp)
    8000403a:	74e2                	ld	s1,56(sp)
    8000403c:	7942                	ld	s2,48(sp)
    8000403e:	79a2                	ld	s3,40(sp)
    80004040:	7a02                	ld	s4,32(sp)
    80004042:	6ae2                	ld	s5,24(sp)
    80004044:	6b42                	ld	s6,16(sp)
    80004046:	6161                	addi	sp,sp,80
    80004048:	8082                	ret
    iunlockput(ip);
    8000404a:	854e                	mv	a0,s3
    8000404c:	a77fe0ef          	jal	80002ac2 <iunlockput>
    return 0;
    80004050:	4981                	li	s3,0
    80004052:	b7cd                	j	80004034 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004054:	85ca                	mv	a1,s2
    80004056:	4088                	lw	a0,0(s1)
    80004058:	eeefe0ef          	jal	80002746 <ialloc>
    8000405c:	892a                	mv	s2,a0
    8000405e:	cd15                	beqz	a0,8000409a <create+0xc6>
  ilock(ip);
    80004060:	857fe0ef          	jal	800028b6 <ilock>
  ip->major = major;
    80004064:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004068:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    8000406c:	4785                	li	a5,1
    8000406e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004072:	854a                	mv	a0,s2
    80004074:	f8efe0ef          	jal	80002802 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004078:	4705                	li	a4,1
    8000407a:	02ea0463          	beq	s4,a4,800040a2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000407e:	00492603          	lw	a2,4(s2)
    80004082:	fb040593          	addi	a1,s0,-80
    80004086:	8526                	mv	a0,s1
    80004088:	e7bfe0ef          	jal	80002f02 <dirlink>
    8000408c:	06054263          	bltz	a0,800040f0 <create+0x11c>
  iunlockput(dp);
    80004090:	8526                	mv	a0,s1
    80004092:	a31fe0ef          	jal	80002ac2 <iunlockput>
  return ip;
    80004096:	89ca                	mv	s3,s2
    80004098:	bf71                	j	80004034 <create+0x60>
    iunlockput(dp);
    8000409a:	8526                	mv	a0,s1
    8000409c:	a27fe0ef          	jal	80002ac2 <iunlockput>
    return 0;
    800040a0:	bf51                	j	80004034 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040a2:	00492603          	lw	a2,4(s2)
    800040a6:	00003597          	auipc	a1,0x3
    800040aa:	55a58593          	addi	a1,a1,1370 # 80007600 <etext+0x600>
    800040ae:	854a                	mv	a0,s2
    800040b0:	e53fe0ef          	jal	80002f02 <dirlink>
    800040b4:	02054e63          	bltz	a0,800040f0 <create+0x11c>
    800040b8:	40d0                	lw	a2,4(s1)
    800040ba:	00003597          	auipc	a1,0x3
    800040be:	54e58593          	addi	a1,a1,1358 # 80007608 <etext+0x608>
    800040c2:	854a                	mv	a0,s2
    800040c4:	e3ffe0ef          	jal	80002f02 <dirlink>
    800040c8:	02054463          	bltz	a0,800040f0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040cc:	00492603          	lw	a2,4(s2)
    800040d0:	fb040593          	addi	a1,s0,-80
    800040d4:	8526                	mv	a0,s1
    800040d6:	e2dfe0ef          	jal	80002f02 <dirlink>
    800040da:	00054b63          	bltz	a0,800040f0 <create+0x11c>
    dp->nlink++;  // for ".."
    800040de:	04a4d783          	lhu	a5,74(s1)
    800040e2:	2785                	addiw	a5,a5,1
    800040e4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040e8:	8526                	mv	a0,s1
    800040ea:	f18fe0ef          	jal	80002802 <iupdate>
    800040ee:	b74d                	j	80004090 <create+0xbc>
  ip->nlink = 0;
    800040f0:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800040f4:	854a                	mv	a0,s2
    800040f6:	f0cfe0ef          	jal	80002802 <iupdate>
  iunlockput(ip);
    800040fa:	854a                	mv	a0,s2
    800040fc:	9c7fe0ef          	jal	80002ac2 <iunlockput>
  iunlockput(dp);
    80004100:	8526                	mv	a0,s1
    80004102:	9c1fe0ef          	jal	80002ac2 <iunlockput>
  return 0;
    80004106:	b73d                	j	80004034 <create+0x60>
    return 0;
    80004108:	89aa                	mv	s3,a0
    8000410a:	b72d                	j	80004034 <create+0x60>

000000008000410c <sys_dup>:
{
    8000410c:	7179                	addi	sp,sp,-48
    8000410e:	f406                	sd	ra,40(sp)
    80004110:	f022                	sd	s0,32(sp)
    80004112:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004114:	fd840613          	addi	a2,s0,-40
    80004118:	4581                	li	a1,0
    8000411a:	4501                	li	a0,0
    8000411c:	e1fff0ef          	jal	80003f3a <argfd>
    return -1;
    80004120:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004122:	02054363          	bltz	a0,80004148 <sys_dup+0x3c>
    80004126:	ec26                	sd	s1,24(sp)
    80004128:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000412a:	fd843483          	ld	s1,-40(s0)
    8000412e:	8526                	mv	a0,s1
    80004130:	e65ff0ef          	jal	80003f94 <fdalloc>
    80004134:	892a                	mv	s2,a0
    return -1;
    80004136:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004138:	00054d63          	bltz	a0,80004152 <sys_dup+0x46>
  filedup(f);
    8000413c:	8526                	mv	a0,s1
    8000413e:	c1cff0ef          	jal	8000355a <filedup>
  return fd;
    80004142:	87ca                	mv	a5,s2
    80004144:	64e2                	ld	s1,24(sp)
    80004146:	6942                	ld	s2,16(sp)
}
    80004148:	853e                	mv	a0,a5
    8000414a:	70a2                	ld	ra,40(sp)
    8000414c:	7402                	ld	s0,32(sp)
    8000414e:	6145                	addi	sp,sp,48
    80004150:	8082                	ret
    80004152:	64e2                	ld	s1,24(sp)
    80004154:	6942                	ld	s2,16(sp)
    80004156:	bfcd                	j	80004148 <sys_dup+0x3c>

0000000080004158 <sys_read>:
{
    80004158:	7179                	addi	sp,sp,-48
    8000415a:	f406                	sd	ra,40(sp)
    8000415c:	f022                	sd	s0,32(sp)
    8000415e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004160:	fd840593          	addi	a1,s0,-40
    80004164:	4505                	li	a0,1
    80004166:	b09fd0ef          	jal	80001c6e <argaddr>
  argint(2, &n);
    8000416a:	fe440593          	addi	a1,s0,-28
    8000416e:	4509                	li	a0,2
    80004170:	ae3fd0ef          	jal	80001c52 <argint>
  if(argfd(0, 0, &f) < 0)
    80004174:	fe840613          	addi	a2,s0,-24
    80004178:	4581                	li	a1,0
    8000417a:	4501                	li	a0,0
    8000417c:	dbfff0ef          	jal	80003f3a <argfd>
    80004180:	87aa                	mv	a5,a0
    return -1;
    80004182:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004184:	0007ca63          	bltz	a5,80004198 <sys_read+0x40>
  return fileread(f, p, n);
    80004188:	fe442603          	lw	a2,-28(s0)
    8000418c:	fd843583          	ld	a1,-40(s0)
    80004190:	fe843503          	ld	a0,-24(s0)
    80004194:	d30ff0ef          	jal	800036c4 <fileread>
}
    80004198:	70a2                	ld	ra,40(sp)
    8000419a:	7402                	ld	s0,32(sp)
    8000419c:	6145                	addi	sp,sp,48
    8000419e:	8082                	ret

00000000800041a0 <sys_write>:
{
    800041a0:	7179                	addi	sp,sp,-48
    800041a2:	f406                	sd	ra,40(sp)
    800041a4:	f022                	sd	s0,32(sp)
    800041a6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041a8:	fd840593          	addi	a1,s0,-40
    800041ac:	4505                	li	a0,1
    800041ae:	ac1fd0ef          	jal	80001c6e <argaddr>
  argint(2, &n);
    800041b2:	fe440593          	addi	a1,s0,-28
    800041b6:	4509                	li	a0,2
    800041b8:	a9bfd0ef          	jal	80001c52 <argint>
  if(argfd(0, 0, &f) < 0)
    800041bc:	fe840613          	addi	a2,s0,-24
    800041c0:	4581                	li	a1,0
    800041c2:	4501                	li	a0,0
    800041c4:	d77ff0ef          	jal	80003f3a <argfd>
    800041c8:	87aa                	mv	a5,a0
    return -1;
    800041ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041cc:	0007ca63          	bltz	a5,800041e0 <sys_write+0x40>
  return filewrite(f, p, n);
    800041d0:	fe442603          	lw	a2,-28(s0)
    800041d4:	fd843583          	ld	a1,-40(s0)
    800041d8:	fe843503          	ld	a0,-24(s0)
    800041dc:	dacff0ef          	jal	80003788 <filewrite>
}
    800041e0:	70a2                	ld	ra,40(sp)
    800041e2:	7402                	ld	s0,32(sp)
    800041e4:	6145                	addi	sp,sp,48
    800041e6:	8082                	ret

00000000800041e8 <sys_close>:
{
    800041e8:	1101                	addi	sp,sp,-32
    800041ea:	ec06                	sd	ra,24(sp)
    800041ec:	e822                	sd	s0,16(sp)
    800041ee:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800041f0:	fe040613          	addi	a2,s0,-32
    800041f4:	fec40593          	addi	a1,s0,-20
    800041f8:	4501                	li	a0,0
    800041fa:	d41ff0ef          	jal	80003f3a <argfd>
    return -1;
    800041fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004200:	02054163          	bltz	a0,80004222 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004204:	b83fc0ef          	jal	80000d86 <myproc>
    80004208:	fec42783          	lw	a5,-20(s0)
    8000420c:	078e                	slli	a5,a5,0x3
    8000420e:	0d078793          	addi	a5,a5,208
    80004212:	953e                	add	a0,a0,a5
    80004214:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004218:	fe043503          	ld	a0,-32(s0)
    8000421c:	b84ff0ef          	jal	800035a0 <fileclose>
  return 0;
    80004220:	4781                	li	a5,0
}
    80004222:	853e                	mv	a0,a5
    80004224:	60e2                	ld	ra,24(sp)
    80004226:	6442                	ld	s0,16(sp)
    80004228:	6105                	addi	sp,sp,32
    8000422a:	8082                	ret

000000008000422c <sys_fstat>:
{
    8000422c:	1101                	addi	sp,sp,-32
    8000422e:	ec06                	sd	ra,24(sp)
    80004230:	e822                	sd	s0,16(sp)
    80004232:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004234:	fe040593          	addi	a1,s0,-32
    80004238:	4505                	li	a0,1
    8000423a:	a35fd0ef          	jal	80001c6e <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000423e:	fe840613          	addi	a2,s0,-24
    80004242:	4581                	li	a1,0
    80004244:	4501                	li	a0,0
    80004246:	cf5ff0ef          	jal	80003f3a <argfd>
    8000424a:	87aa                	mv	a5,a0
    return -1;
    8000424c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000424e:	0007c863          	bltz	a5,8000425e <sys_fstat+0x32>
  return filestat(f, st);
    80004252:	fe043583          	ld	a1,-32(s0)
    80004256:	fe843503          	ld	a0,-24(s0)
    8000425a:	c08ff0ef          	jal	80003662 <filestat>
}
    8000425e:	60e2                	ld	ra,24(sp)
    80004260:	6442                	ld	s0,16(sp)
    80004262:	6105                	addi	sp,sp,32
    80004264:	8082                	ret

0000000080004266 <sys_link>:
{
    80004266:	7169                	addi	sp,sp,-304
    80004268:	f606                	sd	ra,296(sp)
    8000426a:	f222                	sd	s0,288(sp)
    8000426c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000426e:	08000613          	li	a2,128
    80004272:	ed040593          	addi	a1,s0,-304
    80004276:	4501                	li	a0,0
    80004278:	a13fd0ef          	jal	80001c8a <argstr>
    return -1;
    8000427c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000427e:	0c054e63          	bltz	a0,8000435a <sys_link+0xf4>
    80004282:	08000613          	li	a2,128
    80004286:	f5040593          	addi	a1,s0,-176
    8000428a:	4505                	li	a0,1
    8000428c:	9fffd0ef          	jal	80001c8a <argstr>
    return -1;
    80004290:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004292:	0c054463          	bltz	a0,8000435a <sys_link+0xf4>
    80004296:	ee26                	sd	s1,280(sp)
  begin_op();
    80004298:	ed7fe0ef          	jal	8000316e <begin_op>
  if((ip = namei(old)) == 0){
    8000429c:	ed040513          	addi	a0,s0,-304
    800042a0:	d0dfe0ef          	jal	80002fac <namei>
    800042a4:	84aa                	mv	s1,a0
    800042a6:	c53d                	beqz	a0,80004314 <sys_link+0xae>
  ilock(ip);
    800042a8:	e0efe0ef          	jal	800028b6 <ilock>
  if(ip->type == T_DIR){
    800042ac:	04449703          	lh	a4,68(s1)
    800042b0:	4785                	li	a5,1
    800042b2:	06f70663          	beq	a4,a5,8000431e <sys_link+0xb8>
    800042b6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042b8:	04a4d783          	lhu	a5,74(s1)
    800042bc:	2785                	addiw	a5,a5,1
    800042be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042c2:	8526                	mv	a0,s1
    800042c4:	d3efe0ef          	jal	80002802 <iupdate>
  iunlock(ip);
    800042c8:	8526                	mv	a0,s1
    800042ca:	e9afe0ef          	jal	80002964 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042ce:	fd040593          	addi	a1,s0,-48
    800042d2:	f5040513          	addi	a0,s0,-176
    800042d6:	cf1fe0ef          	jal	80002fc6 <nameiparent>
    800042da:	892a                	mv	s2,a0
    800042dc:	cd21                	beqz	a0,80004334 <sys_link+0xce>
  ilock(dp);
    800042de:	dd8fe0ef          	jal	800028b6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042e2:	854a                	mv	a0,s2
    800042e4:	00092703          	lw	a4,0(s2)
    800042e8:	409c                	lw	a5,0(s1)
    800042ea:	04f71263          	bne	a4,a5,8000432e <sys_link+0xc8>
    800042ee:	40d0                	lw	a2,4(s1)
    800042f0:	fd040593          	addi	a1,s0,-48
    800042f4:	c0ffe0ef          	jal	80002f02 <dirlink>
    800042f8:	02054b63          	bltz	a0,8000432e <sys_link+0xc8>
  iunlockput(dp);
    800042fc:	854a                	mv	a0,s2
    800042fe:	fc4fe0ef          	jal	80002ac2 <iunlockput>
  iput(ip);
    80004302:	8526                	mv	a0,s1
    80004304:	f34fe0ef          	jal	80002a38 <iput>
  end_op();
    80004308:	ed7fe0ef          	jal	800031de <end_op>
  return 0;
    8000430c:	4781                	li	a5,0
    8000430e:	64f2                	ld	s1,280(sp)
    80004310:	6952                	ld	s2,272(sp)
    80004312:	a0a1                	j	8000435a <sys_link+0xf4>
    end_op();
    80004314:	ecbfe0ef          	jal	800031de <end_op>
    return -1;
    80004318:	57fd                	li	a5,-1
    8000431a:	64f2                	ld	s1,280(sp)
    8000431c:	a83d                	j	8000435a <sys_link+0xf4>
    iunlockput(ip);
    8000431e:	8526                	mv	a0,s1
    80004320:	fa2fe0ef          	jal	80002ac2 <iunlockput>
    end_op();
    80004324:	ebbfe0ef          	jal	800031de <end_op>
    return -1;
    80004328:	57fd                	li	a5,-1
    8000432a:	64f2                	ld	s1,280(sp)
    8000432c:	a03d                	j	8000435a <sys_link+0xf4>
    iunlockput(dp);
    8000432e:	854a                	mv	a0,s2
    80004330:	f92fe0ef          	jal	80002ac2 <iunlockput>
  ilock(ip);
    80004334:	8526                	mv	a0,s1
    80004336:	d80fe0ef          	jal	800028b6 <ilock>
  ip->nlink--;
    8000433a:	04a4d783          	lhu	a5,74(s1)
    8000433e:	37fd                	addiw	a5,a5,-1
    80004340:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004344:	8526                	mv	a0,s1
    80004346:	cbcfe0ef          	jal	80002802 <iupdate>
  iunlockput(ip);
    8000434a:	8526                	mv	a0,s1
    8000434c:	f76fe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    80004350:	e8ffe0ef          	jal	800031de <end_op>
  return -1;
    80004354:	57fd                	li	a5,-1
    80004356:	64f2                	ld	s1,280(sp)
    80004358:	6952                	ld	s2,272(sp)
}
    8000435a:	853e                	mv	a0,a5
    8000435c:	70b2                	ld	ra,296(sp)
    8000435e:	7412                	ld	s0,288(sp)
    80004360:	6155                	addi	sp,sp,304
    80004362:	8082                	ret

0000000080004364 <sys_unlink>:
{
    80004364:	7151                	addi	sp,sp,-240
    80004366:	f586                	sd	ra,232(sp)
    80004368:	f1a2                	sd	s0,224(sp)
    8000436a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000436c:	08000613          	li	a2,128
    80004370:	f3040593          	addi	a1,s0,-208
    80004374:	4501                	li	a0,0
    80004376:	915fd0ef          	jal	80001c8a <argstr>
    8000437a:	14054d63          	bltz	a0,800044d4 <sys_unlink+0x170>
    8000437e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004380:	deffe0ef          	jal	8000316e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004384:	fb040593          	addi	a1,s0,-80
    80004388:	f3040513          	addi	a0,s0,-208
    8000438c:	c3bfe0ef          	jal	80002fc6 <nameiparent>
    80004390:	84aa                	mv	s1,a0
    80004392:	c955                	beqz	a0,80004446 <sys_unlink+0xe2>
  ilock(dp);
    80004394:	d22fe0ef          	jal	800028b6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004398:	00003597          	auipc	a1,0x3
    8000439c:	26858593          	addi	a1,a1,616 # 80007600 <etext+0x600>
    800043a0:	fb040513          	addi	a0,s0,-80
    800043a4:	95ffe0ef          	jal	80002d02 <namecmp>
    800043a8:	10050b63          	beqz	a0,800044be <sys_unlink+0x15a>
    800043ac:	00003597          	auipc	a1,0x3
    800043b0:	25c58593          	addi	a1,a1,604 # 80007608 <etext+0x608>
    800043b4:	fb040513          	addi	a0,s0,-80
    800043b8:	94bfe0ef          	jal	80002d02 <namecmp>
    800043bc:	10050163          	beqz	a0,800044be <sys_unlink+0x15a>
    800043c0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043c2:	f2c40613          	addi	a2,s0,-212
    800043c6:	fb040593          	addi	a1,s0,-80
    800043ca:	8526                	mv	a0,s1
    800043cc:	94dfe0ef          	jal	80002d18 <dirlookup>
    800043d0:	892a                	mv	s2,a0
    800043d2:	0e050563          	beqz	a0,800044bc <sys_unlink+0x158>
    800043d6:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800043d8:	cdefe0ef          	jal	800028b6 <ilock>
  if(ip->nlink < 1)
    800043dc:	04a91783          	lh	a5,74(s2)
    800043e0:	06f05863          	blez	a5,80004450 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043e4:	04491703          	lh	a4,68(s2)
    800043e8:	4785                	li	a5,1
    800043ea:	06f70963          	beq	a4,a5,8000445c <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800043ee:	fc040993          	addi	s3,s0,-64
    800043f2:	4641                	li	a2,16
    800043f4:	4581                	li	a1,0
    800043f6:	854e                	mv	a0,s3
    800043f8:	d67fb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043fc:	4741                	li	a4,16
    800043fe:	f2c42683          	lw	a3,-212(s0)
    80004402:	864e                	mv	a2,s3
    80004404:	4581                	li	a1,0
    80004406:	8526                	mv	a0,s1
    80004408:	ffafe0ef          	jal	80002c02 <writei>
    8000440c:	47c1                	li	a5,16
    8000440e:	08f51863          	bne	a0,a5,8000449e <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004412:	04491703          	lh	a4,68(s2)
    80004416:	4785                	li	a5,1
    80004418:	08f70963          	beq	a4,a5,800044aa <sys_unlink+0x146>
  iunlockput(dp);
    8000441c:	8526                	mv	a0,s1
    8000441e:	ea4fe0ef          	jal	80002ac2 <iunlockput>
  ip->nlink--;
    80004422:	04a95783          	lhu	a5,74(s2)
    80004426:	37fd                	addiw	a5,a5,-1
    80004428:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000442c:	854a                	mv	a0,s2
    8000442e:	bd4fe0ef          	jal	80002802 <iupdate>
  iunlockput(ip);
    80004432:	854a                	mv	a0,s2
    80004434:	e8efe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    80004438:	da7fe0ef          	jal	800031de <end_op>
  return 0;
    8000443c:	4501                	li	a0,0
    8000443e:	64ee                	ld	s1,216(sp)
    80004440:	694e                	ld	s2,208(sp)
    80004442:	69ae                	ld	s3,200(sp)
    80004444:	a061                	j	800044cc <sys_unlink+0x168>
    end_op();
    80004446:	d99fe0ef          	jal	800031de <end_op>
    return -1;
    8000444a:	557d                	li	a0,-1
    8000444c:	64ee                	ld	s1,216(sp)
    8000444e:	a8bd                	j	800044cc <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004450:	00003517          	auipc	a0,0x3
    80004454:	1c050513          	addi	a0,a0,448 # 80007610 <etext+0x610>
    80004458:	2a6010ef          	jal	800056fe <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000445c:	04c92703          	lw	a4,76(s2)
    80004460:	02000793          	li	a5,32
    80004464:	f8e7f5e3          	bgeu	a5,a4,800043ee <sys_unlink+0x8a>
    80004468:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000446a:	4741                	li	a4,16
    8000446c:	86ce                	mv	a3,s3
    8000446e:	f1840613          	addi	a2,s0,-232
    80004472:	4581                	li	a1,0
    80004474:	854a                	mv	a0,s2
    80004476:	e9afe0ef          	jal	80002b10 <readi>
    8000447a:	47c1                	li	a5,16
    8000447c:	00f51b63          	bne	a0,a5,80004492 <sys_unlink+0x12e>
    if(de.inum != 0)
    80004480:	f1845783          	lhu	a5,-232(s0)
    80004484:	ebb1                	bnez	a5,800044d8 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004486:	29c1                	addiw	s3,s3,16
    80004488:	04c92783          	lw	a5,76(s2)
    8000448c:	fcf9efe3          	bltu	s3,a5,8000446a <sys_unlink+0x106>
    80004490:	bfb9                	j	800043ee <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004492:	00003517          	auipc	a0,0x3
    80004496:	19650513          	addi	a0,a0,406 # 80007628 <etext+0x628>
    8000449a:	264010ef          	jal	800056fe <panic>
    panic("unlink: writei");
    8000449e:	00003517          	auipc	a0,0x3
    800044a2:	1a250513          	addi	a0,a0,418 # 80007640 <etext+0x640>
    800044a6:	258010ef          	jal	800056fe <panic>
    dp->nlink--;
    800044aa:	04a4d783          	lhu	a5,74(s1)
    800044ae:	37fd                	addiw	a5,a5,-1
    800044b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044b4:	8526                	mv	a0,s1
    800044b6:	b4cfe0ef          	jal	80002802 <iupdate>
    800044ba:	b78d                	j	8000441c <sys_unlink+0xb8>
    800044bc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044be:	8526                	mv	a0,s1
    800044c0:	e02fe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    800044c4:	d1bfe0ef          	jal	800031de <end_op>
  return -1;
    800044c8:	557d                	li	a0,-1
    800044ca:	64ee                	ld	s1,216(sp)
}
    800044cc:	70ae                	ld	ra,232(sp)
    800044ce:	740e                	ld	s0,224(sp)
    800044d0:	616d                	addi	sp,sp,240
    800044d2:	8082                	ret
    return -1;
    800044d4:	557d                	li	a0,-1
    800044d6:	bfdd                	j	800044cc <sys_unlink+0x168>
    iunlockput(ip);
    800044d8:	854a                	mv	a0,s2
    800044da:	de8fe0ef          	jal	80002ac2 <iunlockput>
    goto bad;
    800044de:	694e                	ld	s2,208(sp)
    800044e0:	69ae                	ld	s3,200(sp)
    800044e2:	bff1                	j	800044be <sys_unlink+0x15a>

00000000800044e4 <sys_open>:

uint64
sys_open(void)
{
    800044e4:	7131                	addi	sp,sp,-192
    800044e6:	fd06                	sd	ra,184(sp)
    800044e8:	f922                	sd	s0,176(sp)
    800044ea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800044ec:	f4c40593          	addi	a1,s0,-180
    800044f0:	4505                	li	a0,1
    800044f2:	f60fd0ef          	jal	80001c52 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800044f6:	08000613          	li	a2,128
    800044fa:	f5040593          	addi	a1,s0,-176
    800044fe:	4501                	li	a0,0
    80004500:	f8afd0ef          	jal	80001c8a <argstr>
    80004504:	87aa                	mv	a5,a0
    return -1;
    80004506:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004508:	0a07c363          	bltz	a5,800045ae <sys_open+0xca>
    8000450c:	f526                	sd	s1,168(sp)

  begin_op();
    8000450e:	c61fe0ef          	jal	8000316e <begin_op>

  if(omode & O_CREATE){
    80004512:	f4c42783          	lw	a5,-180(s0)
    80004516:	2007f793          	andi	a5,a5,512
    8000451a:	c3dd                	beqz	a5,800045c0 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000451c:	4681                	li	a3,0
    8000451e:	4601                	li	a2,0
    80004520:	4589                	li	a1,2
    80004522:	f5040513          	addi	a0,s0,-176
    80004526:	aafff0ef          	jal	80003fd4 <create>
    8000452a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000452c:	c549                	beqz	a0,800045b6 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000452e:	04449703          	lh	a4,68(s1)
    80004532:	478d                	li	a5,3
    80004534:	00f71763          	bne	a4,a5,80004542 <sys_open+0x5e>
    80004538:	0464d703          	lhu	a4,70(s1)
    8000453c:	47a5                	li	a5,9
    8000453e:	0ae7ee63          	bltu	a5,a4,800045fa <sys_open+0x116>
    80004542:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004544:	fb9fe0ef          	jal	800034fc <filealloc>
    80004548:	892a                	mv	s2,a0
    8000454a:	c561                	beqz	a0,80004612 <sys_open+0x12e>
    8000454c:	ed4e                	sd	s3,152(sp)
    8000454e:	a47ff0ef          	jal	80003f94 <fdalloc>
    80004552:	89aa                	mv	s3,a0
    80004554:	0a054b63          	bltz	a0,8000460a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004558:	04449703          	lh	a4,68(s1)
    8000455c:	478d                	li	a5,3
    8000455e:	0cf70363          	beq	a4,a5,80004624 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004562:	4789                	li	a5,2
    80004564:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004568:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000456c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004570:	f4c42783          	lw	a5,-180(s0)
    80004574:	0017f713          	andi	a4,a5,1
    80004578:	00174713          	xori	a4,a4,1
    8000457c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004580:	0037f713          	andi	a4,a5,3
    80004584:	00e03733          	snez	a4,a4
    80004588:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000458c:	4007f793          	andi	a5,a5,1024
    80004590:	c791                	beqz	a5,8000459c <sys_open+0xb8>
    80004592:	04449703          	lh	a4,68(s1)
    80004596:	4789                	li	a5,2
    80004598:	08f70d63          	beq	a4,a5,80004632 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000459c:	8526                	mv	a0,s1
    8000459e:	bc6fe0ef          	jal	80002964 <iunlock>
  end_op();
    800045a2:	c3dfe0ef          	jal	800031de <end_op>

  return fd;
    800045a6:	854e                	mv	a0,s3
    800045a8:	74aa                	ld	s1,168(sp)
    800045aa:	790a                	ld	s2,160(sp)
    800045ac:	69ea                	ld	s3,152(sp)
}
    800045ae:	70ea                	ld	ra,184(sp)
    800045b0:	744a                	ld	s0,176(sp)
    800045b2:	6129                	addi	sp,sp,192
    800045b4:	8082                	ret
      end_op();
    800045b6:	c29fe0ef          	jal	800031de <end_op>
      return -1;
    800045ba:	557d                	li	a0,-1
    800045bc:	74aa                	ld	s1,168(sp)
    800045be:	bfc5                	j	800045ae <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045c0:	f5040513          	addi	a0,s0,-176
    800045c4:	9e9fe0ef          	jal	80002fac <namei>
    800045c8:	84aa                	mv	s1,a0
    800045ca:	c11d                	beqz	a0,800045f0 <sys_open+0x10c>
    ilock(ip);
    800045cc:	aeafe0ef          	jal	800028b6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045d0:	04449703          	lh	a4,68(s1)
    800045d4:	4785                	li	a5,1
    800045d6:	f4f71ce3          	bne	a4,a5,8000452e <sys_open+0x4a>
    800045da:	f4c42783          	lw	a5,-180(s0)
    800045de:	d3b5                	beqz	a5,80004542 <sys_open+0x5e>
      iunlockput(ip);
    800045e0:	8526                	mv	a0,s1
    800045e2:	ce0fe0ef          	jal	80002ac2 <iunlockput>
      end_op();
    800045e6:	bf9fe0ef          	jal	800031de <end_op>
      return -1;
    800045ea:	557d                	li	a0,-1
    800045ec:	74aa                	ld	s1,168(sp)
    800045ee:	b7c1                	j	800045ae <sys_open+0xca>
      end_op();
    800045f0:	beffe0ef          	jal	800031de <end_op>
      return -1;
    800045f4:	557d                	li	a0,-1
    800045f6:	74aa                	ld	s1,168(sp)
    800045f8:	bf5d                	j	800045ae <sys_open+0xca>
    iunlockput(ip);
    800045fa:	8526                	mv	a0,s1
    800045fc:	cc6fe0ef          	jal	80002ac2 <iunlockput>
    end_op();
    80004600:	bdffe0ef          	jal	800031de <end_op>
    return -1;
    80004604:	557d                	li	a0,-1
    80004606:	74aa                	ld	s1,168(sp)
    80004608:	b75d                	j	800045ae <sys_open+0xca>
      fileclose(f);
    8000460a:	854a                	mv	a0,s2
    8000460c:	f95fe0ef          	jal	800035a0 <fileclose>
    80004610:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004612:	8526                	mv	a0,s1
    80004614:	caefe0ef          	jal	80002ac2 <iunlockput>
    end_op();
    80004618:	bc7fe0ef          	jal	800031de <end_op>
    return -1;
    8000461c:	557d                	li	a0,-1
    8000461e:	74aa                	ld	s1,168(sp)
    80004620:	790a                	ld	s2,160(sp)
    80004622:	b771                	j	800045ae <sys_open+0xca>
    f->type = FD_DEVICE;
    80004624:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004628:	04649783          	lh	a5,70(s1)
    8000462c:	02f91223          	sh	a5,36(s2)
    80004630:	bf35                	j	8000456c <sys_open+0x88>
    itrunc(ip);
    80004632:	8526                	mv	a0,s1
    80004634:	b70fe0ef          	jal	800029a4 <itrunc>
    80004638:	b795                	j	8000459c <sys_open+0xb8>

000000008000463a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000463a:	7175                	addi	sp,sp,-144
    8000463c:	e506                	sd	ra,136(sp)
    8000463e:	e122                	sd	s0,128(sp)
    80004640:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004642:	b2dfe0ef          	jal	8000316e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004646:	08000613          	li	a2,128
    8000464a:	f7040593          	addi	a1,s0,-144
    8000464e:	4501                	li	a0,0
    80004650:	e3afd0ef          	jal	80001c8a <argstr>
    80004654:	02054363          	bltz	a0,8000467a <sys_mkdir+0x40>
    80004658:	4681                	li	a3,0
    8000465a:	4601                	li	a2,0
    8000465c:	4585                	li	a1,1
    8000465e:	f7040513          	addi	a0,s0,-144
    80004662:	973ff0ef          	jal	80003fd4 <create>
    80004666:	c911                	beqz	a0,8000467a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004668:	c5afe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    8000466c:	b73fe0ef          	jal	800031de <end_op>
  return 0;
    80004670:	4501                	li	a0,0
}
    80004672:	60aa                	ld	ra,136(sp)
    80004674:	640a                	ld	s0,128(sp)
    80004676:	6149                	addi	sp,sp,144
    80004678:	8082                	ret
    end_op();
    8000467a:	b65fe0ef          	jal	800031de <end_op>
    return -1;
    8000467e:	557d                	li	a0,-1
    80004680:	bfcd                	j	80004672 <sys_mkdir+0x38>

0000000080004682 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004682:	7135                	addi	sp,sp,-160
    80004684:	ed06                	sd	ra,152(sp)
    80004686:	e922                	sd	s0,144(sp)
    80004688:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000468a:	ae5fe0ef          	jal	8000316e <begin_op>
  argint(1, &major);
    8000468e:	f6c40593          	addi	a1,s0,-148
    80004692:	4505                	li	a0,1
    80004694:	dbefd0ef          	jal	80001c52 <argint>
  argint(2, &minor);
    80004698:	f6840593          	addi	a1,s0,-152
    8000469c:	4509                	li	a0,2
    8000469e:	db4fd0ef          	jal	80001c52 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046a2:	08000613          	li	a2,128
    800046a6:	f7040593          	addi	a1,s0,-144
    800046aa:	4501                	li	a0,0
    800046ac:	ddefd0ef          	jal	80001c8a <argstr>
    800046b0:	02054563          	bltz	a0,800046da <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046b4:	f6841683          	lh	a3,-152(s0)
    800046b8:	f6c41603          	lh	a2,-148(s0)
    800046bc:	458d                	li	a1,3
    800046be:	f7040513          	addi	a0,s0,-144
    800046c2:	913ff0ef          	jal	80003fd4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046c6:	c911                	beqz	a0,800046da <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046c8:	bfafe0ef          	jal	80002ac2 <iunlockput>
  end_op();
    800046cc:	b13fe0ef          	jal	800031de <end_op>
  return 0;
    800046d0:	4501                	li	a0,0
}
    800046d2:	60ea                	ld	ra,152(sp)
    800046d4:	644a                	ld	s0,144(sp)
    800046d6:	610d                	addi	sp,sp,160
    800046d8:	8082                	ret
    end_op();
    800046da:	b05fe0ef          	jal	800031de <end_op>
    return -1;
    800046de:	557d                	li	a0,-1
    800046e0:	bfcd                	j	800046d2 <sys_mknod+0x50>

00000000800046e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800046e2:	7135                	addi	sp,sp,-160
    800046e4:	ed06                	sd	ra,152(sp)
    800046e6:	e922                	sd	s0,144(sp)
    800046e8:	e14a                	sd	s2,128(sp)
    800046ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800046ec:	e9afc0ef          	jal	80000d86 <myproc>
    800046f0:	892a                	mv	s2,a0
  
  begin_op();
    800046f2:	a7dfe0ef          	jal	8000316e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800046f6:	08000613          	li	a2,128
    800046fa:	f6040593          	addi	a1,s0,-160
    800046fe:	4501                	li	a0,0
    80004700:	d8afd0ef          	jal	80001c8a <argstr>
    80004704:	04054363          	bltz	a0,8000474a <sys_chdir+0x68>
    80004708:	e526                	sd	s1,136(sp)
    8000470a:	f6040513          	addi	a0,s0,-160
    8000470e:	89ffe0ef          	jal	80002fac <namei>
    80004712:	84aa                	mv	s1,a0
    80004714:	c915                	beqz	a0,80004748 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004716:	9a0fe0ef          	jal	800028b6 <ilock>
  if(ip->type != T_DIR){
    8000471a:	04449703          	lh	a4,68(s1)
    8000471e:	4785                	li	a5,1
    80004720:	02f71963          	bne	a4,a5,80004752 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004724:	8526                	mv	a0,s1
    80004726:	a3efe0ef          	jal	80002964 <iunlock>
  iput(p->cwd);
    8000472a:	15093503          	ld	a0,336(s2)
    8000472e:	b0afe0ef          	jal	80002a38 <iput>
  end_op();
    80004732:	aadfe0ef          	jal	800031de <end_op>
  p->cwd = ip;
    80004736:	14993823          	sd	s1,336(s2)
  return 0;
    8000473a:	4501                	li	a0,0
    8000473c:	64aa                	ld	s1,136(sp)
}
    8000473e:	60ea                	ld	ra,152(sp)
    80004740:	644a                	ld	s0,144(sp)
    80004742:	690a                	ld	s2,128(sp)
    80004744:	610d                	addi	sp,sp,160
    80004746:	8082                	ret
    80004748:	64aa                	ld	s1,136(sp)
    end_op();
    8000474a:	a95fe0ef          	jal	800031de <end_op>
    return -1;
    8000474e:	557d                	li	a0,-1
    80004750:	b7fd                	j	8000473e <sys_chdir+0x5c>
    iunlockput(ip);
    80004752:	8526                	mv	a0,s1
    80004754:	b6efe0ef          	jal	80002ac2 <iunlockput>
    end_op();
    80004758:	a87fe0ef          	jal	800031de <end_op>
    return -1;
    8000475c:	557d                	li	a0,-1
    8000475e:	64aa                	ld	s1,136(sp)
    80004760:	bff9                	j	8000473e <sys_chdir+0x5c>

0000000080004762 <sys_exec>:

uint64
sys_exec(void)
{
    80004762:	7105                	addi	sp,sp,-480
    80004764:	ef86                	sd	ra,472(sp)
    80004766:	eba2                	sd	s0,464(sp)
    80004768:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000476a:	e2840593          	addi	a1,s0,-472
    8000476e:	4505                	li	a0,1
    80004770:	cfefd0ef          	jal	80001c6e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004774:	08000613          	li	a2,128
    80004778:	f3040593          	addi	a1,s0,-208
    8000477c:	4501                	li	a0,0
    8000477e:	d0cfd0ef          	jal	80001c8a <argstr>
    80004782:	87aa                	mv	a5,a0
    return -1;
    80004784:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004786:	0e07c063          	bltz	a5,80004866 <sys_exec+0x104>
    8000478a:	e7a6                	sd	s1,456(sp)
    8000478c:	e3ca                	sd	s2,448(sp)
    8000478e:	ff4e                	sd	s3,440(sp)
    80004790:	fb52                	sd	s4,432(sp)
    80004792:	f756                	sd	s5,424(sp)
    80004794:	f35a                	sd	s6,416(sp)
    80004796:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004798:	e3040a13          	addi	s4,s0,-464
    8000479c:	10000613          	li	a2,256
    800047a0:	4581                	li	a1,0
    800047a2:	8552                	mv	a0,s4
    800047a4:	9bbfb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047a8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800047aa:	89d2                	mv	s3,s4
    800047ac:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047ae:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047b2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047b4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047b8:	00391513          	slli	a0,s2,0x3
    800047bc:	85d6                	mv	a1,s5
    800047be:	e2843783          	ld	a5,-472(s0)
    800047c2:	953e                	add	a0,a0,a5
    800047c4:	c04fd0ef          	jal	80001bc8 <fetchaddr>
    800047c8:	02054663          	bltz	a0,800047f4 <sys_exec+0x92>
    if(uarg == 0){
    800047cc:	e2043783          	ld	a5,-480(s0)
    800047d0:	c7a1                	beqz	a5,80004818 <sys_exec+0xb6>
    argv[i] = kalloc();
    800047d2:	933fb0ef          	jal	80000104 <kalloc>
    800047d6:	85aa                	mv	a1,a0
    800047d8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047dc:	cd01                	beqz	a0,800047f4 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047de:	865a                	mv	a2,s6
    800047e0:	e2043503          	ld	a0,-480(s0)
    800047e4:	c2efd0ef          	jal	80001c12 <fetchstr>
    800047e8:	00054663          	bltz	a0,800047f4 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800047ec:	0905                	addi	s2,s2,1
    800047ee:	09a1                	addi	s3,s3,8
    800047f0:	fd7914e3          	bne	s2,s7,800047b8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047f4:	100a0a13          	addi	s4,s4,256
    800047f8:	6088                	ld	a0,0(s1)
    800047fa:	cd31                	beqz	a0,80004856 <sys_exec+0xf4>
    kfree(argv[i]);
    800047fc:	821fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004800:	04a1                	addi	s1,s1,8
    80004802:	ff449be3          	bne	s1,s4,800047f8 <sys_exec+0x96>
  return -1;
    80004806:	557d                	li	a0,-1
    80004808:	64be                	ld	s1,456(sp)
    8000480a:	691e                	ld	s2,448(sp)
    8000480c:	79fa                	ld	s3,440(sp)
    8000480e:	7a5a                	ld	s4,432(sp)
    80004810:	7aba                	ld	s5,424(sp)
    80004812:	7b1a                	ld	s6,416(sp)
    80004814:	6bfa                	ld	s7,408(sp)
    80004816:	a881                	j	80004866 <sys_exec+0x104>
      argv[i] = 0;
    80004818:	0009079b          	sext.w	a5,s2
    8000481c:	e3040593          	addi	a1,s0,-464
    80004820:	078e                	slli	a5,a5,0x3
    80004822:	97ae                	add	a5,a5,a1
    80004824:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004828:	f3040513          	addi	a0,s0,-208
    8000482c:	bb6ff0ef          	jal	80003be2 <exec>
    80004830:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004832:	100a0a13          	addi	s4,s4,256
    80004836:	6088                	ld	a0,0(s1)
    80004838:	c511                	beqz	a0,80004844 <sys_exec+0xe2>
    kfree(argv[i]);
    8000483a:	fe2fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000483e:	04a1                	addi	s1,s1,8
    80004840:	ff449be3          	bne	s1,s4,80004836 <sys_exec+0xd4>
  return ret;
    80004844:	854a                	mv	a0,s2
    80004846:	64be                	ld	s1,456(sp)
    80004848:	691e                	ld	s2,448(sp)
    8000484a:	79fa                	ld	s3,440(sp)
    8000484c:	7a5a                	ld	s4,432(sp)
    8000484e:	7aba                	ld	s5,424(sp)
    80004850:	7b1a                	ld	s6,416(sp)
    80004852:	6bfa                	ld	s7,408(sp)
    80004854:	a809                	j	80004866 <sys_exec+0x104>
  return -1;
    80004856:	557d                	li	a0,-1
    80004858:	64be                	ld	s1,456(sp)
    8000485a:	691e                	ld	s2,448(sp)
    8000485c:	79fa                	ld	s3,440(sp)
    8000485e:	7a5a                	ld	s4,432(sp)
    80004860:	7aba                	ld	s5,424(sp)
    80004862:	7b1a                	ld	s6,416(sp)
    80004864:	6bfa                	ld	s7,408(sp)
}
    80004866:	60fe                	ld	ra,472(sp)
    80004868:	645e                	ld	s0,464(sp)
    8000486a:	613d                	addi	sp,sp,480
    8000486c:	8082                	ret

000000008000486e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000486e:	7139                	addi	sp,sp,-64
    80004870:	fc06                	sd	ra,56(sp)
    80004872:	f822                	sd	s0,48(sp)
    80004874:	f426                	sd	s1,40(sp)
    80004876:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004878:	d0efc0ef          	jal	80000d86 <myproc>
    8000487c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000487e:	fd840593          	addi	a1,s0,-40
    80004882:	4501                	li	a0,0
    80004884:	beafd0ef          	jal	80001c6e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004888:	fc840593          	addi	a1,s0,-56
    8000488c:	fd040513          	addi	a0,s0,-48
    80004890:	82cff0ef          	jal	800038bc <pipealloc>
    return -1;
    80004894:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004896:	0a054763          	bltz	a0,80004944 <sys_pipe+0xd6>
  fd0 = -1;
    8000489a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000489e:	fd043503          	ld	a0,-48(s0)
    800048a2:	ef2ff0ef          	jal	80003f94 <fdalloc>
    800048a6:	fca42223          	sw	a0,-60(s0)
    800048aa:	08054463          	bltz	a0,80004932 <sys_pipe+0xc4>
    800048ae:	fc843503          	ld	a0,-56(s0)
    800048b2:	ee2ff0ef          	jal	80003f94 <fdalloc>
    800048b6:	fca42023          	sw	a0,-64(s0)
    800048ba:	06054263          	bltz	a0,8000491e <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048be:	4691                	li	a3,4
    800048c0:	fc440613          	addi	a2,s0,-60
    800048c4:	fd843583          	ld	a1,-40(s0)
    800048c8:	68a8                	ld	a0,80(s1)
    800048ca:	938fc0ef          	jal	80000a02 <copyout>
    800048ce:	00054e63          	bltz	a0,800048ea <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048d2:	4691                	li	a3,4
    800048d4:	fc040613          	addi	a2,s0,-64
    800048d8:	fd843583          	ld	a1,-40(s0)
    800048dc:	95b6                	add	a1,a1,a3
    800048de:	68a8                	ld	a0,80(s1)
    800048e0:	922fc0ef          	jal	80000a02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800048e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048e6:	04055f63          	bgez	a0,80004944 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800048ea:	fc442783          	lw	a5,-60(s0)
    800048ee:	078e                	slli	a5,a5,0x3
    800048f0:	0d078793          	addi	a5,a5,208
    800048f4:	97a6                	add	a5,a5,s1
    800048f6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800048fa:	fc042783          	lw	a5,-64(s0)
    800048fe:	078e                	slli	a5,a5,0x3
    80004900:	0d078793          	addi	a5,a5,208
    80004904:	97a6                	add	a5,a5,s1
    80004906:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000490a:	fd043503          	ld	a0,-48(s0)
    8000490e:	c93fe0ef          	jal	800035a0 <fileclose>
    fileclose(wf);
    80004912:	fc843503          	ld	a0,-56(s0)
    80004916:	c8bfe0ef          	jal	800035a0 <fileclose>
    return -1;
    8000491a:	57fd                	li	a5,-1
    8000491c:	a025                	j	80004944 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000491e:	fc442783          	lw	a5,-60(s0)
    80004922:	0007c863          	bltz	a5,80004932 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004926:	078e                	slli	a5,a5,0x3
    80004928:	0d078793          	addi	a5,a5,208
    8000492c:	97a6                	add	a5,a5,s1
    8000492e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004932:	fd043503          	ld	a0,-48(s0)
    80004936:	c6bfe0ef          	jal	800035a0 <fileclose>
    fileclose(wf);
    8000493a:	fc843503          	ld	a0,-56(s0)
    8000493e:	c63fe0ef          	jal	800035a0 <fileclose>
    return -1;
    80004942:	57fd                	li	a5,-1
}
    80004944:	853e                	mv	a0,a5
    80004946:	70e2                	ld	ra,56(sp)
    80004948:	7442                	ld	s0,48(sp)
    8000494a:	74a2                	ld	s1,40(sp)
    8000494c:	6121                	addi	sp,sp,64
    8000494e:	8082                	ret

0000000080004950 <kernelvec>:
    80004950:	7111                	addi	sp,sp,-256
    80004952:	e006                	sd	ra,0(sp)
    80004954:	e40a                	sd	sp,8(sp)
    80004956:	e80e                	sd	gp,16(sp)
    80004958:	ec12                	sd	tp,24(sp)
    8000495a:	f016                	sd	t0,32(sp)
    8000495c:	f41a                	sd	t1,40(sp)
    8000495e:	f81e                	sd	t2,48(sp)
    80004960:	e4aa                	sd	a0,72(sp)
    80004962:	e8ae                	sd	a1,80(sp)
    80004964:	ecb2                	sd	a2,88(sp)
    80004966:	f0b6                	sd	a3,96(sp)
    80004968:	f4ba                	sd	a4,104(sp)
    8000496a:	f8be                	sd	a5,112(sp)
    8000496c:	fcc2                	sd	a6,120(sp)
    8000496e:	e146                	sd	a7,128(sp)
    80004970:	edf2                	sd	t3,216(sp)
    80004972:	f1f6                	sd	t4,224(sp)
    80004974:	f5fa                	sd	t5,232(sp)
    80004976:	f9fe                	sd	t6,240(sp)
    80004978:	95efd0ef          	jal	80001ad6 <kerneltrap>
    8000497c:	6082                	ld	ra,0(sp)
    8000497e:	6122                	ld	sp,8(sp)
    80004980:	61c2                	ld	gp,16(sp)
    80004982:	7282                	ld	t0,32(sp)
    80004984:	7322                	ld	t1,40(sp)
    80004986:	73c2                	ld	t2,48(sp)
    80004988:	6526                	ld	a0,72(sp)
    8000498a:	65c6                	ld	a1,80(sp)
    8000498c:	6666                	ld	a2,88(sp)
    8000498e:	7686                	ld	a3,96(sp)
    80004990:	7726                	ld	a4,104(sp)
    80004992:	77c6                	ld	a5,112(sp)
    80004994:	7866                	ld	a6,120(sp)
    80004996:	688a                	ld	a7,128(sp)
    80004998:	6e6e                	ld	t3,216(sp)
    8000499a:	7e8e                	ld	t4,224(sp)
    8000499c:	7f2e                	ld	t5,232(sp)
    8000499e:	7fce                	ld	t6,240(sp)
    800049a0:	6111                	addi	sp,sp,256
    800049a2:	10200073          	sret
    800049a6:	00000013          	nop
    800049aa:	00000013          	nop

00000000800049ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049ae:	1141                	addi	sp,sp,-16
    800049b0:	e406                	sd	ra,8(sp)
    800049b2:	e022                	sd	s0,0(sp)
    800049b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049b6:	0c000737          	lui	a4,0xc000
    800049ba:	4785                	li	a5,1
    800049bc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049be:	c35c                	sw	a5,4(a4)
}
    800049c0:	60a2                	ld	ra,8(sp)
    800049c2:	6402                	ld	s0,0(sp)
    800049c4:	0141                	addi	sp,sp,16
    800049c6:	8082                	ret

00000000800049c8 <plicinithart>:

void
plicinithart(void)
{
    800049c8:	1141                	addi	sp,sp,-16
    800049ca:	e406                	sd	ra,8(sp)
    800049cc:	e022                	sd	s0,0(sp)
    800049ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049d0:	b82fc0ef          	jal	80000d52 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049d4:	0085171b          	slliw	a4,a0,0x8
    800049d8:	0c0027b7          	lui	a5,0xc002
    800049dc:	97ba                	add	a5,a5,a4
    800049de:	40200713          	li	a4,1026
    800049e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049e6:	00d5151b          	slliw	a0,a0,0xd
    800049ea:	0c2017b7          	lui	a5,0xc201
    800049ee:	97aa                	add	a5,a5,a0
    800049f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049f4:	60a2                	ld	ra,8(sp)
    800049f6:	6402                	ld	s0,0(sp)
    800049f8:	0141                	addi	sp,sp,16
    800049fa:	8082                	ret

00000000800049fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049fc:	1141                	addi	sp,sp,-16
    800049fe:	e406                	sd	ra,8(sp)
    80004a00:	e022                	sd	s0,0(sp)
    80004a02:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a04:	b4efc0ef          	jal	80000d52 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a08:	00d5151b          	slliw	a0,a0,0xd
    80004a0c:	0c2017b7          	lui	a5,0xc201
    80004a10:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a12:	43c8                	lw	a0,4(a5)
    80004a14:	60a2                	ld	ra,8(sp)
    80004a16:	6402                	ld	s0,0(sp)
    80004a18:	0141                	addi	sp,sp,16
    80004a1a:	8082                	ret

0000000080004a1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a1c:	1101                	addi	sp,sp,-32
    80004a1e:	ec06                	sd	ra,24(sp)
    80004a20:	e822                	sd	s0,16(sp)
    80004a22:	e426                	sd	s1,8(sp)
    80004a24:	1000                	addi	s0,sp,32
    80004a26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a28:	b2afc0ef          	jal	80000d52 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a2c:	00d5179b          	slliw	a5,a0,0xd
    80004a30:	0c201737          	lui	a4,0xc201
    80004a34:	97ba                	add	a5,a5,a4
    80004a36:	c3c4                	sw	s1,4(a5)
}
    80004a38:	60e2                	ld	ra,24(sp)
    80004a3a:	6442                	ld	s0,16(sp)
    80004a3c:	64a2                	ld	s1,8(sp)
    80004a3e:	6105                	addi	sp,sp,32
    80004a40:	8082                	ret

0000000080004a42 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a42:	1141                	addi	sp,sp,-16
    80004a44:	e406                	sd	ra,8(sp)
    80004a46:	e022                	sd	s0,0(sp)
    80004a48:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a4a:	479d                	li	a5,7
    80004a4c:	04a7ca63          	blt	a5,a0,80004aa0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a50:	00017797          	auipc	a5,0x17
    80004a54:	a5078793          	addi	a5,a5,-1456 # 8001b4a0 <disk>
    80004a58:	97aa                	add	a5,a5,a0
    80004a5a:	0187c783          	lbu	a5,24(a5)
    80004a5e:	e7b9                	bnez	a5,80004aac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a60:	00451693          	slli	a3,a0,0x4
    80004a64:	00017797          	auipc	a5,0x17
    80004a68:	a3c78793          	addi	a5,a5,-1476 # 8001b4a0 <disk>
    80004a6c:	6398                	ld	a4,0(a5)
    80004a6e:	9736                	add	a4,a4,a3
    80004a70:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a74:	6398                	ld	a4,0(a5)
    80004a76:	9736                	add	a4,a4,a3
    80004a78:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a7c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a80:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a84:	97aa                	add	a5,a5,a0
    80004a86:	4705                	li	a4,1
    80004a88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a8c:	00017517          	auipc	a0,0x17
    80004a90:	a2c50513          	addi	a0,a0,-1492 # 8001b4b8 <disk+0x18>
    80004a94:	91dfc0ef          	jal	800013b0 <wakeup>
}
    80004a98:	60a2                	ld	ra,8(sp)
    80004a9a:	6402                	ld	s0,0(sp)
    80004a9c:	0141                	addi	sp,sp,16
    80004a9e:	8082                	ret
    panic("free_desc 1");
    80004aa0:	00003517          	auipc	a0,0x3
    80004aa4:	bb050513          	addi	a0,a0,-1104 # 80007650 <etext+0x650>
    80004aa8:	457000ef          	jal	800056fe <panic>
    panic("free_desc 2");
    80004aac:	00003517          	auipc	a0,0x3
    80004ab0:	bb450513          	addi	a0,a0,-1100 # 80007660 <etext+0x660>
    80004ab4:	44b000ef          	jal	800056fe <panic>

0000000080004ab8 <virtio_disk_init>:
{
    80004ab8:	1101                	addi	sp,sp,-32
    80004aba:	ec06                	sd	ra,24(sp)
    80004abc:	e822                	sd	s0,16(sp)
    80004abe:	e426                	sd	s1,8(sp)
    80004ac0:	e04a                	sd	s2,0(sp)
    80004ac2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ac4:	00003597          	auipc	a1,0x3
    80004ac8:	bac58593          	addi	a1,a1,-1108 # 80007670 <etext+0x670>
    80004acc:	00017517          	auipc	a0,0x17
    80004ad0:	afc50513          	addi	a0,a0,-1284 # 8001b5c8 <disk+0x128>
    80004ad4:	6df000ef          	jal	800059b2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ad8:	100017b7          	lui	a5,0x10001
    80004adc:	4398                	lw	a4,0(a5)
    80004ade:	2701                	sext.w	a4,a4
    80004ae0:	747277b7          	lui	a5,0x74727
    80004ae4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004ae8:	14f71863          	bne	a4,a5,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004aec:	100017b7          	lui	a5,0x10001
    80004af0:	43dc                	lw	a5,4(a5)
    80004af2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004af4:	4709                	li	a4,2
    80004af6:	14e79163          	bne	a5,a4,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004afa:	100017b7          	lui	a5,0x10001
    80004afe:	479c                	lw	a5,8(a5)
    80004b00:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b02:	12e79b63          	bne	a5,a4,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b06:	100017b7          	lui	a5,0x10001
    80004b0a:	47d8                	lw	a4,12(a5)
    80004b0c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b0e:	554d47b7          	lui	a5,0x554d4
    80004b12:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b16:	12f71163          	bne	a4,a5,80004c38 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b1a:	100017b7          	lui	a5,0x10001
    80004b1e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b22:	4705                	li	a4,1
    80004b24:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b26:	470d                	li	a4,3
    80004b28:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b2a:	10001737          	lui	a4,0x10001
    80004b2e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b30:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b34:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb07f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b38:	8f75                	and	a4,a4,a3
    80004b3a:	100016b7          	lui	a3,0x10001
    80004b3e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b40:	472d                	li	a4,11
    80004b42:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b44:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b48:	439c                	lw	a5,0(a5)
    80004b4a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b4e:	8ba1                	andi	a5,a5,8
    80004b50:	0e078a63          	beqz	a5,80004c44 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b54:	100017b7          	lui	a5,0x10001
    80004b58:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b5c:	43fc                	lw	a5,68(a5)
    80004b5e:	2781                	sext.w	a5,a5
    80004b60:	0e079863          	bnez	a5,80004c50 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b64:	100017b7          	lui	a5,0x10001
    80004b68:	5bdc                	lw	a5,52(a5)
    80004b6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b6c:	0e078863          	beqz	a5,80004c5c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b70:	471d                	li	a4,7
    80004b72:	0ef77b63          	bgeu	a4,a5,80004c68 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b76:	d8efb0ef          	jal	80000104 <kalloc>
    80004b7a:	00017497          	auipc	s1,0x17
    80004b7e:	92648493          	addi	s1,s1,-1754 # 8001b4a0 <disk>
    80004b82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b84:	d80fb0ef          	jal	80000104 <kalloc>
    80004b88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b8a:	d7afb0ef          	jal	80000104 <kalloc>
    80004b8e:	87aa                	mv	a5,a0
    80004b90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b92:	6088                	ld	a0,0(s1)
    80004b94:	0e050063          	beqz	a0,80004c74 <virtio_disk_init+0x1bc>
    80004b98:	00017717          	auipc	a4,0x17
    80004b9c:	91073703          	ld	a4,-1776(a4) # 8001b4a8 <disk+0x8>
    80004ba0:	cb71                	beqz	a4,80004c74 <virtio_disk_init+0x1bc>
    80004ba2:	cbe9                	beqz	a5,80004c74 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004ba4:	6605                	lui	a2,0x1
    80004ba6:	4581                	li	a1,0
    80004ba8:	db6fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bac:	00017497          	auipc	s1,0x17
    80004bb0:	8f448493          	addi	s1,s1,-1804 # 8001b4a0 <disk>
    80004bb4:	6605                	lui	a2,0x1
    80004bb6:	4581                	li	a1,0
    80004bb8:	6488                	ld	a0,8(s1)
    80004bba:	da4fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bbe:	6605                	lui	a2,0x1
    80004bc0:	4581                	li	a1,0
    80004bc2:	6888                	ld	a0,16(s1)
    80004bc4:	d9afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004bc8:	100017b7          	lui	a5,0x10001
    80004bcc:	4721                	li	a4,8
    80004bce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004bd0:	4098                	lw	a4,0(s1)
    80004bd2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bd6:	40d8                	lw	a4,4(s1)
    80004bd8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bdc:	649c                	ld	a5,8(s1)
    80004bde:	0007869b          	sext.w	a3,a5
    80004be2:	10001737          	lui	a4,0x10001
    80004be6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004bea:	9781                	srai	a5,a5,0x20
    80004bec:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004bf0:	689c                	ld	a5,16(s1)
    80004bf2:	0007869b          	sext.w	a3,a5
    80004bf6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bfa:	9781                	srai	a5,a5,0x20
    80004bfc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c00:	4785                	li	a5,1
    80004c02:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c04:	00f48c23          	sb	a5,24(s1)
    80004c08:	00f48ca3          	sb	a5,25(s1)
    80004c0c:	00f48d23          	sb	a5,26(s1)
    80004c10:	00f48da3          	sb	a5,27(s1)
    80004c14:	00f48e23          	sb	a5,28(s1)
    80004c18:	00f48ea3          	sb	a5,29(s1)
    80004c1c:	00f48f23          	sb	a5,30(s1)
    80004c20:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c24:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c28:	07272823          	sw	s2,112(a4)
}
    80004c2c:	60e2                	ld	ra,24(sp)
    80004c2e:	6442                	ld	s0,16(sp)
    80004c30:	64a2                	ld	s1,8(sp)
    80004c32:	6902                	ld	s2,0(sp)
    80004c34:	6105                	addi	sp,sp,32
    80004c36:	8082                	ret
    panic("could not find virtio disk");
    80004c38:	00003517          	auipc	a0,0x3
    80004c3c:	a4850513          	addi	a0,a0,-1464 # 80007680 <etext+0x680>
    80004c40:	2bf000ef          	jal	800056fe <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c44:	00003517          	auipc	a0,0x3
    80004c48:	a5c50513          	addi	a0,a0,-1444 # 800076a0 <etext+0x6a0>
    80004c4c:	2b3000ef          	jal	800056fe <panic>
    panic("virtio disk should not be ready");
    80004c50:	00003517          	auipc	a0,0x3
    80004c54:	a7050513          	addi	a0,a0,-1424 # 800076c0 <etext+0x6c0>
    80004c58:	2a7000ef          	jal	800056fe <panic>
    panic("virtio disk has no queue 0");
    80004c5c:	00003517          	auipc	a0,0x3
    80004c60:	a8450513          	addi	a0,a0,-1404 # 800076e0 <etext+0x6e0>
    80004c64:	29b000ef          	jal	800056fe <panic>
    panic("virtio disk max queue too short");
    80004c68:	00003517          	auipc	a0,0x3
    80004c6c:	a9850513          	addi	a0,a0,-1384 # 80007700 <etext+0x700>
    80004c70:	28f000ef          	jal	800056fe <panic>
    panic("virtio disk kalloc");
    80004c74:	00003517          	auipc	a0,0x3
    80004c78:	aac50513          	addi	a0,a0,-1364 # 80007720 <etext+0x720>
    80004c7c:	283000ef          	jal	800056fe <panic>

0000000080004c80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c80:	711d                	addi	sp,sp,-96
    80004c82:	ec86                	sd	ra,88(sp)
    80004c84:	e8a2                	sd	s0,80(sp)
    80004c86:	e4a6                	sd	s1,72(sp)
    80004c88:	e0ca                	sd	s2,64(sp)
    80004c8a:	fc4e                	sd	s3,56(sp)
    80004c8c:	f852                	sd	s4,48(sp)
    80004c8e:	f456                	sd	s5,40(sp)
    80004c90:	f05a                	sd	s6,32(sp)
    80004c92:	ec5e                	sd	s7,24(sp)
    80004c94:	e862                	sd	s8,16(sp)
    80004c96:	1080                	addi	s0,sp,96
    80004c98:	89aa                	mv	s3,a0
    80004c9a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c9c:	00c52b83          	lw	s7,12(a0)
    80004ca0:	001b9b9b          	slliw	s7,s7,0x1
    80004ca4:	1b82                	slli	s7,s7,0x20
    80004ca6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004caa:	00017517          	auipc	a0,0x17
    80004cae:	91e50513          	addi	a0,a0,-1762 # 8001b5c8 <disk+0x128>
    80004cb2:	58b000ef          	jal	80005a3c <acquire>
  for(int i = 0; i < NUM; i++){
    80004cb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004cb8:	00016a97          	auipc	s5,0x16
    80004cbc:	7e8a8a93          	addi	s5,s5,2024 # 8001b4a0 <disk>
  for(int i = 0; i < 3; i++){
    80004cc0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004cc2:	5c7d                	li	s8,-1
    80004cc4:	a095                	j	80004d28 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004cc6:	00fa8733          	add	a4,s5,a5
    80004cca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004cce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cd0:	0207c563          	bltz	a5,80004cfa <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004cd4:	2905                	addiw	s2,s2,1
    80004cd6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cd8:	05490c63          	beq	s2,s4,80004d30 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004cdc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cde:	00016717          	auipc	a4,0x16
    80004ce2:	7c270713          	addi	a4,a4,1986 # 8001b4a0 <disk>
    80004ce6:	4781                	li	a5,0
    if(disk.free[i]){
    80004ce8:	01874683          	lbu	a3,24(a4)
    80004cec:	fee9                	bnez	a3,80004cc6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004cee:	2785                	addiw	a5,a5,1
    80004cf0:	0705                	addi	a4,a4,1
    80004cf2:	fe979be3          	bne	a5,s1,80004ce8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004cf6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004cfa:	01205d63          	blez	s2,80004d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cfe:	fa042503          	lw	a0,-96(s0)
    80004d02:	d41ff0ef          	jal	80004a42 <free_desc>
      for(int j = 0; j < i; j++)
    80004d06:	4785                	li	a5,1
    80004d08:	0127d663          	bge	a5,s2,80004d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004d0c:	fa442503          	lw	a0,-92(s0)
    80004d10:	d33ff0ef          	jal	80004a42 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d14:	00017597          	auipc	a1,0x17
    80004d18:	8b458593          	addi	a1,a1,-1868 # 8001b5c8 <disk+0x128>
    80004d1c:	00016517          	auipc	a0,0x16
    80004d20:	79c50513          	addi	a0,a0,1948 # 8001b4b8 <disk+0x18>
    80004d24:	e40fc0ef          	jal	80001364 <sleep>
  for(int i = 0; i < 3; i++){
    80004d28:	fa040613          	addi	a2,s0,-96
    80004d2c:	4901                	li	s2,0
    80004d2e:	b77d                	j	80004cdc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d30:	fa042503          	lw	a0,-96(s0)
    80004d34:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d38:	00016797          	auipc	a5,0x16
    80004d3c:	76878793          	addi	a5,a5,1896 # 8001b4a0 <disk>
    80004d40:	00451713          	slli	a4,a0,0x4
    80004d44:	0a070713          	addi	a4,a4,160
    80004d48:	973e                	add	a4,a4,a5
    80004d4a:	01603633          	snez	a2,s6
    80004d4e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d50:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d54:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d58:	6398                	ld	a4,0(a5)
    80004d5a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d5c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d60:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d62:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d64:	6390                	ld	a2,0(a5)
    80004d66:	00d60833          	add	a6,a2,a3
    80004d6a:	4741                	li	a4,16
    80004d6c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d70:	4585                	li	a1,1
    80004d72:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d76:	fa442703          	lw	a4,-92(s0)
    80004d7a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d7e:	0712                	slli	a4,a4,0x4
    80004d80:	963a                	add	a2,a2,a4
    80004d82:	05898813          	addi	a6,s3,88
    80004d86:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d8a:	0007b883          	ld	a7,0(a5)
    80004d8e:	9746                	add	a4,a4,a7
    80004d90:	40000613          	li	a2,1024
    80004d94:	c710                	sw	a2,8(a4)
  if(write)
    80004d96:	001b3613          	seqz	a2,s6
    80004d9a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d9e:	8e4d                	or	a2,a2,a1
    80004da0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004da4:	fa842603          	lw	a2,-88(s0)
    80004da8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004dac:	00451813          	slli	a6,a0,0x4
    80004db0:	02080813          	addi	a6,a6,32
    80004db4:	983e                	add	a6,a6,a5
    80004db6:	577d                	li	a4,-1
    80004db8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004dbc:	0612                	slli	a2,a2,0x4
    80004dbe:	98b2                	add	a7,a7,a2
    80004dc0:	03068713          	addi	a4,a3,48
    80004dc4:	973e                	add	a4,a4,a5
    80004dc6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004dca:	6398                	ld	a4,0(a5)
    80004dcc:	9732                	add	a4,a4,a2
    80004dce:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004dd0:	4689                	li	a3,2
    80004dd2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004dd6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dda:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004dde:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004de2:	6794                	ld	a3,8(a5)
    80004de4:	0026d703          	lhu	a4,2(a3)
    80004de8:	8b1d                	andi	a4,a4,7
    80004dea:	0706                	slli	a4,a4,0x1
    80004dec:	96ba                	add	a3,a3,a4
    80004dee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004df2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004df6:	6798                	ld	a4,8(a5)
    80004df8:	00275783          	lhu	a5,2(a4)
    80004dfc:	2785                	addiw	a5,a5,1
    80004dfe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e02:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e06:	100017b7          	lui	a5,0x10001
    80004e0a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e0e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004e12:	00016917          	auipc	s2,0x16
    80004e16:	7b690913          	addi	s2,s2,1974 # 8001b5c8 <disk+0x128>
  while(b->disk == 1) {
    80004e1a:	84ae                	mv	s1,a1
    80004e1c:	00b79a63          	bne	a5,a1,80004e30 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e20:	85ca                	mv	a1,s2
    80004e22:	854e                	mv	a0,s3
    80004e24:	d40fc0ef          	jal	80001364 <sleep>
  while(b->disk == 1) {
    80004e28:	0049a783          	lw	a5,4(s3)
    80004e2c:	fe978ae3          	beq	a5,s1,80004e20 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e30:	fa042903          	lw	s2,-96(s0)
    80004e34:	00491713          	slli	a4,s2,0x4
    80004e38:	02070713          	addi	a4,a4,32
    80004e3c:	00016797          	auipc	a5,0x16
    80004e40:	66478793          	addi	a5,a5,1636 # 8001b4a0 <disk>
    80004e44:	97ba                	add	a5,a5,a4
    80004e46:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e4a:	00016997          	auipc	s3,0x16
    80004e4e:	65698993          	addi	s3,s3,1622 # 8001b4a0 <disk>
    80004e52:	00491713          	slli	a4,s2,0x4
    80004e56:	0009b783          	ld	a5,0(s3)
    80004e5a:	97ba                	add	a5,a5,a4
    80004e5c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e60:	854a                	mv	a0,s2
    80004e62:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e66:	bddff0ef          	jal	80004a42 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e6a:	8885                	andi	s1,s1,1
    80004e6c:	f0fd                	bnez	s1,80004e52 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e6e:	00016517          	auipc	a0,0x16
    80004e72:	75a50513          	addi	a0,a0,1882 # 8001b5c8 <disk+0x128>
    80004e76:	45b000ef          	jal	80005ad0 <release>
}
    80004e7a:	60e6                	ld	ra,88(sp)
    80004e7c:	6446                	ld	s0,80(sp)
    80004e7e:	64a6                	ld	s1,72(sp)
    80004e80:	6906                	ld	s2,64(sp)
    80004e82:	79e2                	ld	s3,56(sp)
    80004e84:	7a42                	ld	s4,48(sp)
    80004e86:	7aa2                	ld	s5,40(sp)
    80004e88:	7b02                	ld	s6,32(sp)
    80004e8a:	6be2                	ld	s7,24(sp)
    80004e8c:	6c42                	ld	s8,16(sp)
    80004e8e:	6125                	addi	sp,sp,96
    80004e90:	8082                	ret

0000000080004e92 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e92:	1101                	addi	sp,sp,-32
    80004e94:	ec06                	sd	ra,24(sp)
    80004e96:	e822                	sd	s0,16(sp)
    80004e98:	e426                	sd	s1,8(sp)
    80004e9a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e9c:	00016497          	auipc	s1,0x16
    80004ea0:	60448493          	addi	s1,s1,1540 # 8001b4a0 <disk>
    80004ea4:	00016517          	auipc	a0,0x16
    80004ea8:	72450513          	addi	a0,a0,1828 # 8001b5c8 <disk+0x128>
    80004eac:	391000ef          	jal	80005a3c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004eb0:	100017b7          	lui	a5,0x10001
    80004eb4:	53bc                	lw	a5,96(a5)
    80004eb6:	8b8d                	andi	a5,a5,3
    80004eb8:	10001737          	lui	a4,0x10001
    80004ebc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004ebe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ec2:	689c                	ld	a5,16(s1)
    80004ec4:	0204d703          	lhu	a4,32(s1)
    80004ec8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004ecc:	04f70863          	beq	a4,a5,80004f1c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004ed0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ed4:	6898                	ld	a4,16(s1)
    80004ed6:	0204d783          	lhu	a5,32(s1)
    80004eda:	8b9d                	andi	a5,a5,7
    80004edc:	078e                	slli	a5,a5,0x3
    80004ede:	97ba                	add	a5,a5,a4
    80004ee0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ee2:	00479713          	slli	a4,a5,0x4
    80004ee6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004eea:	9726                	add	a4,a4,s1
    80004eec:	01074703          	lbu	a4,16(a4)
    80004ef0:	e329                	bnez	a4,80004f32 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ef2:	0792                	slli	a5,a5,0x4
    80004ef4:	02078793          	addi	a5,a5,32
    80004ef8:	97a6                	add	a5,a5,s1
    80004efa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004efc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f00:	cb0fc0ef          	jal	800013b0 <wakeup>

    disk.used_idx += 1;
    80004f04:	0204d783          	lhu	a5,32(s1)
    80004f08:	2785                	addiw	a5,a5,1
    80004f0a:	17c2                	slli	a5,a5,0x30
    80004f0c:	93c1                	srli	a5,a5,0x30
    80004f0e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f12:	6898                	ld	a4,16(s1)
    80004f14:	00275703          	lhu	a4,2(a4)
    80004f18:	faf71ce3          	bne	a4,a5,80004ed0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f1c:	00016517          	auipc	a0,0x16
    80004f20:	6ac50513          	addi	a0,a0,1708 # 8001b5c8 <disk+0x128>
    80004f24:	3ad000ef          	jal	80005ad0 <release>
}
    80004f28:	60e2                	ld	ra,24(sp)
    80004f2a:	6442                	ld	s0,16(sp)
    80004f2c:	64a2                	ld	s1,8(sp)
    80004f2e:	6105                	addi	sp,sp,32
    80004f30:	8082                	ret
      panic("virtio_disk_intr status");
    80004f32:	00003517          	auipc	a0,0x3
    80004f36:	80650513          	addi	a0,a0,-2042 # 80007738 <etext+0x738>
    80004f3a:	7c4000ef          	jal	800056fe <panic>

0000000080004f3e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f3e:	1141                	addi	sp,sp,-16
    80004f40:	e406                	sd	ra,8(sp)
    80004f42:	e022                	sd	s0,0(sp)
    80004f44:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f46:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f4a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f4e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f52:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f56:	577d                	li	a4,-1
    80004f58:	177e                	slli	a4,a4,0x3f
    80004f5a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f5c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f60:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f68:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f6c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f70:	000f4737          	lui	a4,0xf4
    80004f74:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f78:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f7a:	14d79073          	csrw	stimecmp,a5
}
    80004f7e:	60a2                	ld	ra,8(sp)
    80004f80:	6402                	ld	s0,0(sp)
    80004f82:	0141                	addi	sp,sp,16
    80004f84:	8082                	ret

0000000080004f86 <start>:
{
    80004f86:	1141                	addi	sp,sp,-16
    80004f88:	e406                	sd	ra,8(sp)
    80004f8a:	e022                	sd	s0,0(sp)
    80004f8c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004f8e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f92:	7779                	lui	a4,0xffffe
    80004f94:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb11f>
    80004f98:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f9a:	6705                	lui	a4,0x1
    80004f9c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004fa0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004fa2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004fa6:	ffffb797          	auipc	a5,0xffffb
    80004faa:	36e78793          	addi	a5,a5,878 # 80000314 <main>
    80004fae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004fb2:	4781                	li	a5,0
    80004fb4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004fb8:	67c1                	lui	a5,0x10
    80004fba:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fbc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fc0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004fc4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004fc8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fcc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004fd0:	57fd                	li	a5,-1
    80004fd2:	83a9                	srli	a5,a5,0xa
    80004fd4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004fd8:	47bd                	li	a5,15
    80004fda:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004fde:	f61ff0ef          	jal	80004f3e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004fe2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004fe6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004fe8:	823e                	mv	tp,a5
  asm volatile("mret");
    80004fea:	30200073          	mret
}
    80004fee:	60a2                	ld	ra,8(sp)
    80004ff0:	6402                	ld	s0,0(sp)
    80004ff2:	0141                	addi	sp,sp,16
    80004ff4:	8082                	ret

0000000080004ff6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ff6:	711d                	addi	sp,sp,-96
    80004ff8:	ec86                	sd	ra,88(sp)
    80004ffa:	e8a2                	sd	s0,80(sp)
    80004ffc:	e0ca                	sd	s2,64(sp)
    80004ffe:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005000:	04c05763          	blez	a2,8000504e <consolewrite+0x58>
    80005004:	e4a6                	sd	s1,72(sp)
    80005006:	fc4e                	sd	s3,56(sp)
    80005008:	f852                	sd	s4,48(sp)
    8000500a:	f456                	sd	s5,40(sp)
    8000500c:	f05a                	sd	s6,32(sp)
    8000500e:	ec5e                	sd	s7,24(sp)
    80005010:	8a2a                	mv	s4,a0
    80005012:	84ae                	mv	s1,a1
    80005014:	89b2                	mv	s3,a2
    80005016:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005018:	faf40b93          	addi	s7,s0,-81
    8000501c:	4b05                	li	s6,1
    8000501e:	5afd                	li	s5,-1
    80005020:	86da                	mv	a3,s6
    80005022:	8626                	mv	a2,s1
    80005024:	85d2                	mv	a1,s4
    80005026:	855e                	mv	a0,s7
    80005028:	ee0fc0ef          	jal	80001708 <either_copyin>
    8000502c:	03550363          	beq	a0,s5,80005052 <consolewrite+0x5c>
      break;
    uartputc(c);
    80005030:	faf44503          	lbu	a0,-81(s0)
    80005034:	06b000ef          	jal	8000589e <uartputc>
  for(i = 0; i < n; i++){
    80005038:	2905                	addiw	s2,s2,1
    8000503a:	0485                	addi	s1,s1,1
    8000503c:	ff2992e3          	bne	s3,s2,80005020 <consolewrite+0x2a>
    80005040:	64a6                	ld	s1,72(sp)
    80005042:	79e2                	ld	s3,56(sp)
    80005044:	7a42                	ld	s4,48(sp)
    80005046:	7aa2                	ld	s5,40(sp)
    80005048:	7b02                	ld	s6,32(sp)
    8000504a:	6be2                	ld	s7,24(sp)
    8000504c:	a809                	j	8000505e <consolewrite+0x68>
    8000504e:	4901                	li	s2,0
    80005050:	a039                	j	8000505e <consolewrite+0x68>
    80005052:	64a6                	ld	s1,72(sp)
    80005054:	79e2                	ld	s3,56(sp)
    80005056:	7a42                	ld	s4,48(sp)
    80005058:	7aa2                	ld	s5,40(sp)
    8000505a:	7b02                	ld	s6,32(sp)
    8000505c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000505e:	854a                	mv	a0,s2
    80005060:	60e6                	ld	ra,88(sp)
    80005062:	6446                	ld	s0,80(sp)
    80005064:	6906                	ld	s2,64(sp)
    80005066:	6125                	addi	sp,sp,96
    80005068:	8082                	ret

000000008000506a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000506a:	711d                	addi	sp,sp,-96
    8000506c:	ec86                	sd	ra,88(sp)
    8000506e:	e8a2                	sd	s0,80(sp)
    80005070:	e4a6                	sd	s1,72(sp)
    80005072:	e0ca                	sd	s2,64(sp)
    80005074:	fc4e                	sd	s3,56(sp)
    80005076:	f852                	sd	s4,48(sp)
    80005078:	f05a                	sd	s6,32(sp)
    8000507a:	ec5e                	sd	s7,24(sp)
    8000507c:	1080                	addi	s0,sp,96
    8000507e:	8b2a                	mv	s6,a0
    80005080:	8a2e                	mv	s4,a1
    80005082:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005084:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005086:	0001e517          	auipc	a0,0x1e
    8000508a:	55a50513          	addi	a0,a0,1370 # 800235e0 <cons>
    8000508e:	1af000ef          	jal	80005a3c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005092:	0001e497          	auipc	s1,0x1e
    80005096:	54e48493          	addi	s1,s1,1358 # 800235e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000509a:	0001e917          	auipc	s2,0x1e
    8000509e:	5de90913          	addi	s2,s2,1502 # 80023678 <cons+0x98>
  while(n > 0){
    800050a2:	0b305b63          	blez	s3,80005158 <consoleread+0xee>
    while(cons.r == cons.w){
    800050a6:	0984a783          	lw	a5,152(s1)
    800050aa:	09c4a703          	lw	a4,156(s1)
    800050ae:	0af71063          	bne	a4,a5,8000514e <consoleread+0xe4>
      if(killed(myproc())){
    800050b2:	cd5fb0ef          	jal	80000d86 <myproc>
    800050b6:	ceafc0ef          	jal	800015a0 <killed>
    800050ba:	e12d                	bnez	a0,8000511c <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800050bc:	85a6                	mv	a1,s1
    800050be:	854a                	mv	a0,s2
    800050c0:	aa4fc0ef          	jal	80001364 <sleep>
    while(cons.r == cons.w){
    800050c4:	0984a783          	lw	a5,152(s1)
    800050c8:	09c4a703          	lw	a4,156(s1)
    800050cc:	fef703e3          	beq	a4,a5,800050b2 <consoleread+0x48>
    800050d0:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800050d2:	0001e717          	auipc	a4,0x1e
    800050d6:	50e70713          	addi	a4,a4,1294 # 800235e0 <cons>
    800050da:	0017869b          	addiw	a3,a5,1
    800050de:	08d72c23          	sw	a3,152(a4)
    800050e2:	07f7f693          	andi	a3,a5,127
    800050e6:	9736                	add	a4,a4,a3
    800050e8:	01874703          	lbu	a4,24(a4)
    800050ec:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800050f0:	4691                	li	a3,4
    800050f2:	04da8663          	beq	s5,a3,8000513e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800050f6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800050fa:	4685                	li	a3,1
    800050fc:	faf40613          	addi	a2,s0,-81
    80005100:	85d2                	mv	a1,s4
    80005102:	855a                	mv	a0,s6
    80005104:	dbafc0ef          	jal	800016be <either_copyout>
    80005108:	57fd                	li	a5,-1
    8000510a:	04f50663          	beq	a0,a5,80005156 <consoleread+0xec>
      break;

    dst++;
    8000510e:	0a05                	addi	s4,s4,1
    --n;
    80005110:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005112:	47a9                	li	a5,10
    80005114:	04fa8b63          	beq	s5,a5,8000516a <consoleread+0x100>
    80005118:	7aa2                	ld	s5,40(sp)
    8000511a:	b761                	j	800050a2 <consoleread+0x38>
        release(&cons.lock);
    8000511c:	0001e517          	auipc	a0,0x1e
    80005120:	4c450513          	addi	a0,a0,1220 # 800235e0 <cons>
    80005124:	1ad000ef          	jal	80005ad0 <release>
        return -1;
    80005128:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000512a:	60e6                	ld	ra,88(sp)
    8000512c:	6446                	ld	s0,80(sp)
    8000512e:	64a6                	ld	s1,72(sp)
    80005130:	6906                	ld	s2,64(sp)
    80005132:	79e2                	ld	s3,56(sp)
    80005134:	7a42                	ld	s4,48(sp)
    80005136:	7b02                	ld	s6,32(sp)
    80005138:	6be2                	ld	s7,24(sp)
    8000513a:	6125                	addi	sp,sp,96
    8000513c:	8082                	ret
      if(n < target){
    8000513e:	0179fa63          	bgeu	s3,s7,80005152 <consoleread+0xe8>
        cons.r--;
    80005142:	0001e717          	auipc	a4,0x1e
    80005146:	52f72b23          	sw	a5,1334(a4) # 80023678 <cons+0x98>
    8000514a:	7aa2                	ld	s5,40(sp)
    8000514c:	a031                	j	80005158 <consoleread+0xee>
    8000514e:	f456                	sd	s5,40(sp)
    80005150:	b749                	j	800050d2 <consoleread+0x68>
    80005152:	7aa2                	ld	s5,40(sp)
    80005154:	a011                	j	80005158 <consoleread+0xee>
    80005156:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005158:	0001e517          	auipc	a0,0x1e
    8000515c:	48850513          	addi	a0,a0,1160 # 800235e0 <cons>
    80005160:	171000ef          	jal	80005ad0 <release>
  return target - n;
    80005164:	413b853b          	subw	a0,s7,s3
    80005168:	b7c9                	j	8000512a <consoleread+0xc0>
    8000516a:	7aa2                	ld	s5,40(sp)
    8000516c:	b7f5                	j	80005158 <consoleread+0xee>

000000008000516e <consputc>:
{
    8000516e:	1141                	addi	sp,sp,-16
    80005170:	e406                	sd	ra,8(sp)
    80005172:	e022                	sd	s0,0(sp)
    80005174:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005176:	10000793          	li	a5,256
    8000517a:	00f50863          	beq	a0,a5,8000518a <consputc+0x1c>
    uartputc_sync(c);
    8000517e:	63e000ef          	jal	800057bc <uartputc_sync>
}
    80005182:	60a2                	ld	ra,8(sp)
    80005184:	6402                	ld	s0,0(sp)
    80005186:	0141                	addi	sp,sp,16
    80005188:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000518a:	4521                	li	a0,8
    8000518c:	630000ef          	jal	800057bc <uartputc_sync>
    80005190:	02000513          	li	a0,32
    80005194:	628000ef          	jal	800057bc <uartputc_sync>
    80005198:	4521                	li	a0,8
    8000519a:	622000ef          	jal	800057bc <uartputc_sync>
    8000519e:	b7d5                	j	80005182 <consputc+0x14>

00000000800051a0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051a0:	1101                	addi	sp,sp,-32
    800051a2:	ec06                	sd	ra,24(sp)
    800051a4:	e822                	sd	s0,16(sp)
    800051a6:	e426                	sd	s1,8(sp)
    800051a8:	1000                	addi	s0,sp,32
    800051aa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051ac:	0001e517          	auipc	a0,0x1e
    800051b0:	43450513          	addi	a0,a0,1076 # 800235e0 <cons>
    800051b4:	089000ef          	jal	80005a3c <acquire>

  switch(c){
    800051b8:	47d5                	li	a5,21
    800051ba:	08f48d63          	beq	s1,a5,80005254 <consoleintr+0xb4>
    800051be:	0297c563          	blt	a5,s1,800051e8 <consoleintr+0x48>
    800051c2:	47a1                	li	a5,8
    800051c4:	0ef48263          	beq	s1,a5,800052a8 <consoleintr+0x108>
    800051c8:	47c1                	li	a5,16
    800051ca:	10f49363          	bne	s1,a5,800052d0 <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800051ce:	d84fc0ef          	jal	80001752 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051d2:	0001e517          	auipc	a0,0x1e
    800051d6:	40e50513          	addi	a0,a0,1038 # 800235e0 <cons>
    800051da:	0f7000ef          	jal	80005ad0 <release>
}
    800051de:	60e2                	ld	ra,24(sp)
    800051e0:	6442                	ld	s0,16(sp)
    800051e2:	64a2                	ld	s1,8(sp)
    800051e4:	6105                	addi	sp,sp,32
    800051e6:	8082                	ret
  switch(c){
    800051e8:	07f00793          	li	a5,127
    800051ec:	0af48e63          	beq	s1,a5,800052a8 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051f0:	0001e717          	auipc	a4,0x1e
    800051f4:	3f070713          	addi	a4,a4,1008 # 800235e0 <cons>
    800051f8:	0a072783          	lw	a5,160(a4)
    800051fc:	09872703          	lw	a4,152(a4)
    80005200:	9f99                	subw	a5,a5,a4
    80005202:	07f00713          	li	a4,127
    80005206:	fcf766e3          	bltu	a4,a5,800051d2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000520a:	47b5                	li	a5,13
    8000520c:	0cf48563          	beq	s1,a5,800052d6 <consoleintr+0x136>
      consputc(c);
    80005210:	8526                	mv	a0,s1
    80005212:	f5dff0ef          	jal	8000516e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005216:	0001e717          	auipc	a4,0x1e
    8000521a:	3ca70713          	addi	a4,a4,970 # 800235e0 <cons>
    8000521e:	0a072683          	lw	a3,160(a4)
    80005222:	0016879b          	addiw	a5,a3,1
    80005226:	863e                	mv	a2,a5
    80005228:	0af72023          	sw	a5,160(a4)
    8000522c:	07f6f693          	andi	a3,a3,127
    80005230:	9736                	add	a4,a4,a3
    80005232:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005236:	ff648713          	addi	a4,s1,-10
    8000523a:	c371                	beqz	a4,800052fe <consoleintr+0x15e>
    8000523c:	14f1                	addi	s1,s1,-4
    8000523e:	c0e1                	beqz	s1,800052fe <consoleintr+0x15e>
    80005240:	0001e717          	auipc	a4,0x1e
    80005244:	43872703          	lw	a4,1080(a4) # 80023678 <cons+0x98>
    80005248:	9f99                	subw	a5,a5,a4
    8000524a:	08000713          	li	a4,128
    8000524e:	f8e792e3          	bne	a5,a4,800051d2 <consoleintr+0x32>
    80005252:	a075                	j	800052fe <consoleintr+0x15e>
    80005254:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005256:	0001e717          	auipc	a4,0x1e
    8000525a:	38a70713          	addi	a4,a4,906 # 800235e0 <cons>
    8000525e:	0a072783          	lw	a5,160(a4)
    80005262:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005266:	0001e497          	auipc	s1,0x1e
    8000526a:	37a48493          	addi	s1,s1,890 # 800235e0 <cons>
    while(cons.e != cons.w &&
    8000526e:	4929                	li	s2,10
    80005270:	02f70863          	beq	a4,a5,800052a0 <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005274:	37fd                	addiw	a5,a5,-1
    80005276:	07f7f713          	andi	a4,a5,127
    8000527a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000527c:	01874703          	lbu	a4,24(a4)
    80005280:	03270263          	beq	a4,s2,800052a4 <consoleintr+0x104>
      cons.e--;
    80005284:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005288:	10000513          	li	a0,256
    8000528c:	ee3ff0ef          	jal	8000516e <consputc>
    while(cons.e != cons.w &&
    80005290:	0a04a783          	lw	a5,160(s1)
    80005294:	09c4a703          	lw	a4,156(s1)
    80005298:	fcf71ee3          	bne	a4,a5,80005274 <consoleintr+0xd4>
    8000529c:	6902                	ld	s2,0(sp)
    8000529e:	bf15                	j	800051d2 <consoleintr+0x32>
    800052a0:	6902                	ld	s2,0(sp)
    800052a2:	bf05                	j	800051d2 <consoleintr+0x32>
    800052a4:	6902                	ld	s2,0(sp)
    800052a6:	b735                	j	800051d2 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052a8:	0001e717          	auipc	a4,0x1e
    800052ac:	33870713          	addi	a4,a4,824 # 800235e0 <cons>
    800052b0:	0a072783          	lw	a5,160(a4)
    800052b4:	09c72703          	lw	a4,156(a4)
    800052b8:	f0f70de3          	beq	a4,a5,800051d2 <consoleintr+0x32>
      cons.e--;
    800052bc:	37fd                	addiw	a5,a5,-1
    800052be:	0001e717          	auipc	a4,0x1e
    800052c2:	3cf72123          	sw	a5,962(a4) # 80023680 <cons+0xa0>
      consputc(BACKSPACE);
    800052c6:	10000513          	li	a0,256
    800052ca:	ea5ff0ef          	jal	8000516e <consputc>
    800052ce:	b711                	j	800051d2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052d0:	f00481e3          	beqz	s1,800051d2 <consoleintr+0x32>
    800052d4:	bf31                	j	800051f0 <consoleintr+0x50>
      consputc(c);
    800052d6:	4529                	li	a0,10
    800052d8:	e97ff0ef          	jal	8000516e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800052dc:	0001e797          	auipc	a5,0x1e
    800052e0:	30478793          	addi	a5,a5,772 # 800235e0 <cons>
    800052e4:	0a07a703          	lw	a4,160(a5)
    800052e8:	0017069b          	addiw	a3,a4,1
    800052ec:	8636                	mv	a2,a3
    800052ee:	0ad7a023          	sw	a3,160(a5)
    800052f2:	07f77713          	andi	a4,a4,127
    800052f6:	97ba                	add	a5,a5,a4
    800052f8:	4729                	li	a4,10
    800052fa:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800052fe:	0001e797          	auipc	a5,0x1e
    80005302:	36c7af23          	sw	a2,894(a5) # 8002367c <cons+0x9c>
        wakeup(&cons.r);
    80005306:	0001e517          	auipc	a0,0x1e
    8000530a:	37250513          	addi	a0,a0,882 # 80023678 <cons+0x98>
    8000530e:	8a2fc0ef          	jal	800013b0 <wakeup>
    80005312:	b5c1                	j	800051d2 <consoleintr+0x32>

0000000080005314 <consoleinit>:

void
consoleinit(void)
{
    80005314:	1141                	addi	sp,sp,-16
    80005316:	e406                	sd	ra,8(sp)
    80005318:	e022                	sd	s0,0(sp)
    8000531a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000531c:	00002597          	auipc	a1,0x2
    80005320:	43458593          	addi	a1,a1,1076 # 80007750 <etext+0x750>
    80005324:	0001e517          	auipc	a0,0x1e
    80005328:	2bc50513          	addi	a0,a0,700 # 800235e0 <cons>
    8000532c:	686000ef          	jal	800059b2 <initlock>

  uartinit();
    80005330:	436000ef          	jal	80005766 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005334:	00015797          	auipc	a5,0x15
    80005338:	11478793          	addi	a5,a5,276 # 8001a448 <devsw>
    8000533c:	00000717          	auipc	a4,0x0
    80005340:	d2e70713          	addi	a4,a4,-722 # 8000506a <consoleread>
    80005344:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005346:	00000717          	auipc	a4,0x0
    8000534a:	cb070713          	addi	a4,a4,-848 # 80004ff6 <consolewrite>
    8000534e:	ef98                	sd	a4,24(a5)
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret

0000000080005358 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005358:	7179                	addi	sp,sp,-48
    8000535a:	f406                	sd	ra,40(sp)
    8000535c:	f022                	sd	s0,32(sp)
    8000535e:	e84a                	sd	s2,16(sp)
    80005360:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005362:	c219                	beqz	a2,80005368 <printint+0x10>
    80005364:	08054163          	bltz	a0,800053e6 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005368:	4301                	li	t1,0

  i = 0;
    8000536a:	fd040913          	addi	s2,s0,-48
    x = xx;
    8000536e:	86ca                	mv	a3,s2
  i = 0;
    80005370:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005372:	00002817          	auipc	a6,0x2
    80005376:	55680813          	addi	a6,a6,1366 # 800078c8 <digits>
    8000537a:	88ba                	mv	a7,a4
    8000537c:	0017061b          	addiw	a2,a4,1
    80005380:	8732                	mv	a4,a2
    80005382:	02b577b3          	remu	a5,a0,a1
    80005386:	97c2                	add	a5,a5,a6
    80005388:	0007c783          	lbu	a5,0(a5)
    8000538c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005390:	87aa                	mv	a5,a0
    80005392:	02b55533          	divu	a0,a0,a1
    80005396:	0685                	addi	a3,a3,1
    80005398:	feb7f1e3          	bgeu	a5,a1,8000537a <printint+0x22>

  if(sign)
    8000539c:	00030c63          	beqz	t1,800053b4 <printint+0x5c>
    buf[i++] = '-';
    800053a0:	fe060793          	addi	a5,a2,-32
    800053a4:	00878633          	add	a2,a5,s0
    800053a8:	02d00793          	li	a5,45
    800053ac:	fef60823          	sb	a5,-16(a2)
    800053b0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800053b4:	02e05463          	blez	a4,800053dc <printint+0x84>
    800053b8:	ec26                	sd	s1,24(sp)
    800053ba:	377d                	addiw	a4,a4,-1
    800053bc:	00e904b3          	add	s1,s2,a4
    800053c0:	197d                	addi	s2,s2,-1
    800053c2:	993a                	add	s2,s2,a4
    800053c4:	1702                	slli	a4,a4,0x20
    800053c6:	9301                	srli	a4,a4,0x20
    800053c8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800053cc:	0004c503          	lbu	a0,0(s1)
    800053d0:	d9fff0ef          	jal	8000516e <consputc>
  while(--i >= 0)
    800053d4:	14fd                	addi	s1,s1,-1
    800053d6:	ff249be3          	bne	s1,s2,800053cc <printint+0x74>
    800053da:	64e2                	ld	s1,24(sp)
}
    800053dc:	70a2                	ld	ra,40(sp)
    800053de:	7402                	ld	s0,32(sp)
    800053e0:	6942                	ld	s2,16(sp)
    800053e2:	6145                	addi	sp,sp,48
    800053e4:	8082                	ret
    x = -xx;
    800053e6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800053ea:	4305                	li	t1,1
    x = -xx;
    800053ec:	bfbd                	j	8000536a <printint+0x12>

00000000800053ee <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800053ee:	7131                	addi	sp,sp,-192
    800053f0:	fc86                	sd	ra,120(sp)
    800053f2:	f8a2                	sd	s0,112(sp)
    800053f4:	f0ca                	sd	s2,96(sp)
    800053f6:	ec6e                	sd	s11,24(sp)
    800053f8:	0100                	addi	s0,sp,128
    800053fa:	892a                	mv	s2,a0
    800053fc:	e40c                	sd	a1,8(s0)
    800053fe:	e810                	sd	a2,16(s0)
    80005400:	ec14                	sd	a3,24(s0)
    80005402:	f018                	sd	a4,32(s0)
    80005404:	f41c                	sd	a5,40(s0)
    80005406:	03043823          	sd	a6,48(s0)
    8000540a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000540e:	0001ed97          	auipc	s11,0x1e
    80005412:	292dad83          	lw	s11,658(s11) # 800236a0 <pr+0x18>
  if(locking)
    80005416:	020d9d63          	bnez	s11,80005450 <printf+0x62>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000541a:	00840793          	addi	a5,s0,8
    8000541e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005422:	00054503          	lbu	a0,0(a0)
    80005426:	20050f63          	beqz	a0,80005644 <printf+0x256>
    8000542a:	f4a6                	sd	s1,104(sp)
    8000542c:	ecce                	sd	s3,88(sp)
    8000542e:	e8d2                	sd	s4,80(sp)
    80005430:	e4d6                	sd	s5,72(sp)
    80005432:	e0da                	sd	s6,64(sp)
    80005434:	fc5e                	sd	s7,56(sp)
    80005436:	f862                	sd	s8,48(sp)
    80005438:	f06a                	sd	s10,32(sp)
    8000543a:	4a81                	li	s5,0
    if(cx != '%'){
    8000543c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005440:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005444:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 10, 0);
    80005448:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000544a:	06400b93          	li	s7,100
    8000544e:	a80d                	j	80005480 <printf+0x92>
    acquire(&pr.lock);
    80005450:	0001e517          	auipc	a0,0x1e
    80005454:	23850513          	addi	a0,a0,568 # 80023688 <pr>
    80005458:	5e4000ef          	jal	80005a3c <acquire>
  va_start(ap, fmt);
    8000545c:	00840793          	addi	a5,s0,8
    80005460:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005464:	00094503          	lbu	a0,0(s2)
    80005468:	f169                	bnez	a0,8000542a <printf+0x3c>
    8000546a:	aae5                	j	80005662 <printf+0x274>
      consputc(cx);
    8000546c:	d03ff0ef          	jal	8000516e <consputc>
      continue;
    80005470:	84d6                	mv	s1,s5
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005472:	2485                	addiw	s1,s1,1
    80005474:	8aa6                	mv	s5,s1
    80005476:	94ca                	add	s1,s1,s2
    80005478:	0004c503          	lbu	a0,0(s1)
    8000547c:	1a050a63          	beqz	a0,80005630 <printf+0x242>
    if(cx != '%'){
    80005480:	ff3516e3          	bne	a0,s3,8000546c <printf+0x7e>
    i++;
    80005484:	001a879b          	addiw	a5,s5,1
    80005488:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000548a:	00f90733          	add	a4,s2,a5
    8000548e:	00074a03          	lbu	s4,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005492:	1e0a0863          	beqz	s4,80005682 <printf+0x294>
    80005496:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000549a:	1c068b63          	beqz	a3,80005670 <printf+0x282>
    if(c0 == 'd'){
    8000549e:	037a0863          	beq	s4,s7,800054ce <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800054a2:	f94a0713          	addi	a4,s4,-108
    800054a6:	00173713          	seqz	a4,a4
    800054aa:	f9c68613          	addi	a2,a3,-100
    800054ae:	ee05                	bnez	a2,800054e6 <printf+0xf8>
    800054b0:	cb1d                	beqz	a4,800054e6 <printf+0xf8>
      printint(va_arg(ap, uint64), 10, 1);
    800054b2:	f8843783          	ld	a5,-120(s0)
    800054b6:	00878713          	addi	a4,a5,8
    800054ba:	f8e43423          	sd	a4,-120(s0)
    800054be:	4605                	li	a2,1
    800054c0:	85da                	mv	a1,s6
    800054c2:	6388                	ld	a0,0(a5)
    800054c4:	e95ff0ef          	jal	80005358 <printint>
      i += 1;
    800054c8:	002a849b          	addiw	s1,s5,2
    800054cc:	b75d                	j	80005472 <printf+0x84>
      printint(va_arg(ap, int), 10, 1);
    800054ce:	f8843783          	ld	a5,-120(s0)
    800054d2:	00878713          	addi	a4,a5,8
    800054d6:	f8e43423          	sd	a4,-120(s0)
    800054da:	4605                	li	a2,1
    800054dc:	85da                	mv	a1,s6
    800054de:	4388                	lw	a0,0(a5)
    800054e0:	e79ff0ef          	jal	80005358 <printint>
    800054e4:	b779                	j	80005472 <printf+0x84>
    if(c1) c2 = fmt[i+2] & 0xff;
    800054e6:	97ca                	add	a5,a5,s2
    800054e8:	8636                	mv	a2,a3
    800054ea:	0027c683          	lbu	a3,2(a5)
    800054ee:	a245                	j	8000568e <printf+0x2a0>
      printint(va_arg(ap, uint64), 10, 1);
    800054f0:	f8843783          	ld	a5,-120(s0)
    800054f4:	00878713          	addi	a4,a5,8
    800054f8:	f8e43423          	sd	a4,-120(s0)
    800054fc:	4605                	li	a2,1
    800054fe:	45a9                	li	a1,10
    80005500:	6388                	ld	a0,0(a5)
    80005502:	e57ff0ef          	jal	80005358 <printint>
      i += 2;
    80005506:	003a849b          	addiw	s1,s5,3
    8000550a:	b7a5                	j	80005472 <printf+0x84>
      printint(va_arg(ap, int), 10, 0);
    8000550c:	f8843783          	ld	a5,-120(s0)
    80005510:	00878713          	addi	a4,a5,8
    80005514:	f8e43423          	sd	a4,-120(s0)
    80005518:	4601                	li	a2,0
    8000551a:	85da                	mv	a1,s6
    8000551c:	4388                	lw	a0,0(a5)
    8000551e:	e3bff0ef          	jal	80005358 <printint>
    80005522:	bf81                	j	80005472 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005524:	f8843783          	ld	a5,-120(s0)
    80005528:	00878713          	addi	a4,a5,8
    8000552c:	f8e43423          	sd	a4,-120(s0)
    80005530:	4601                	li	a2,0
    80005532:	85da                	mv	a1,s6
    80005534:	6388                	ld	a0,0(a5)
    80005536:	e23ff0ef          	jal	80005358 <printint>
      i += 1;
    8000553a:	002a849b          	addiw	s1,s5,2
    8000553e:	bf15                	j	80005472 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005540:	f8843783          	ld	a5,-120(s0)
    80005544:	00878713          	addi	a4,a5,8
    80005548:	f8e43423          	sd	a4,-120(s0)
    8000554c:	4601                	li	a2,0
    8000554e:	45a9                	li	a1,10
    80005550:	6388                	ld	a0,0(a5)
    80005552:	e07ff0ef          	jal	80005358 <printint>
      i += 2;
    80005556:	003a849b          	addiw	s1,s5,3
    8000555a:	bf21                	j	80005472 <printf+0x84>
      printint(va_arg(ap, int), 16, 0);
    8000555c:	f8843783          	ld	a5,-120(s0)
    80005560:	00878713          	addi	a4,a5,8
    80005564:	f8e43423          	sd	a4,-120(s0)
    80005568:	4601                	li	a2,0
    8000556a:	45c1                	li	a1,16
    8000556c:	4388                	lw	a0,0(a5)
    8000556e:	debff0ef          	jal	80005358 <printint>
    80005572:	b701                	j	80005472 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
    80005574:	f8843783          	ld	a5,-120(s0)
    80005578:	00878713          	addi	a4,a5,8
    8000557c:	f8e43423          	sd	a4,-120(s0)
    80005580:	45c1                	li	a1,16
    80005582:	6388                	ld	a0,0(a5)
    80005584:	dd5ff0ef          	jal	80005358 <printint>
      i += 1;
    80005588:	002a849b          	addiw	s1,s5,2
    8000558c:	b5dd                	j	80005472 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
    8000558e:	f8843783          	ld	a5,-120(s0)
    80005592:	00878713          	addi	a4,a5,8
    80005596:	f8e43423          	sd	a4,-120(s0)
    8000559a:	4601                	li	a2,0
    8000559c:	45c1                	li	a1,16
    8000559e:	6388                	ld	a0,0(a5)
    800055a0:	db9ff0ef          	jal	80005358 <printint>
      i += 2;
    800055a4:	003a849b          	addiw	s1,s5,3
    800055a8:	b5e9                	j	80005472 <printf+0x84>
    800055aa:	f466                	sd	s9,40(sp)
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    800055ac:	f8843783          	ld	a5,-120(s0)
    800055b0:	00878713          	addi	a4,a5,8
    800055b4:	f8e43423          	sd	a4,-120(s0)
    800055b8:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800055bc:	03000513          	li	a0,48
    800055c0:	bafff0ef          	jal	8000516e <consputc>
  consputc('x');
    800055c4:	07800513          	li	a0,120
    800055c8:	ba7ff0ef          	jal	8000516e <consputc>
    800055cc:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800055ce:	00002c97          	auipc	s9,0x2
    800055d2:	2fac8c93          	addi	s9,s9,762 # 800078c8 <digits>
    800055d6:	03cad793          	srli	a5,s5,0x3c
    800055da:	97e6                	add	a5,a5,s9
    800055dc:	0007c503          	lbu	a0,0(a5)
    800055e0:	b8fff0ef          	jal	8000516e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800055e4:	0a92                	slli	s5,s5,0x4
    800055e6:	3a7d                	addiw	s4,s4,-1
    800055e8:	fe0a17e3          	bnez	s4,800055d6 <printf+0x1e8>
    800055ec:	7ca2                	ld	s9,40(sp)
    800055ee:	b551                	j	80005472 <printf+0x84>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    800055f0:	f8843783          	ld	a5,-120(s0)
    800055f4:	00878713          	addi	a4,a5,8
    800055f8:	f8e43423          	sd	a4,-120(s0)
    800055fc:	0007ba03          	ld	s4,0(a5)
    80005600:	000a0d63          	beqz	s4,8000561a <printf+0x22c>
        s = "(null)";
      for(; *s; s++)
    80005604:	000a4503          	lbu	a0,0(s4)
    80005608:	e60505e3          	beqz	a0,80005472 <printf+0x84>
        consputc(*s);
    8000560c:	b63ff0ef          	jal	8000516e <consputc>
      for(; *s; s++)
    80005610:	0a05                	addi	s4,s4,1
    80005612:	000a4503          	lbu	a0,0(s4)
    80005616:	f97d                	bnez	a0,8000560c <printf+0x21e>
    80005618:	bda9                	j	80005472 <printf+0x84>
        s = "(null)";
    8000561a:	00002a17          	auipc	s4,0x2
    8000561e:	13ea0a13          	addi	s4,s4,318 # 80007758 <etext+0x758>
      for(; *s; s++)
    80005622:	02800513          	li	a0,40
    80005626:	b7dd                	j	8000560c <printf+0x21e>
    } else if(c0 == '%'){
      consputc('%');
    80005628:	8552                	mv	a0,s4
    8000562a:	b45ff0ef          	jal	8000516e <consputc>
    8000562e:	b591                	j	80005472 <printf+0x84>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005630:	020d9163          	bnez	s11,80005652 <printf+0x264>
    80005634:	74a6                	ld	s1,104(sp)
    80005636:	69e6                	ld	s3,88(sp)
    80005638:	6a46                	ld	s4,80(sp)
    8000563a:	6aa6                	ld	s5,72(sp)
    8000563c:	6b06                	ld	s6,64(sp)
    8000563e:	7be2                	ld	s7,56(sp)
    80005640:	7c42                	ld	s8,48(sp)
    80005642:	7d02                	ld	s10,32(sp)
    release(&pr.lock);

  return 0;
}
    80005644:	4501                	li	a0,0
    80005646:	70e6                	ld	ra,120(sp)
    80005648:	7446                	ld	s0,112(sp)
    8000564a:	7906                	ld	s2,96(sp)
    8000564c:	6de2                	ld	s11,24(sp)
    8000564e:	6129                	addi	sp,sp,192
    80005650:	8082                	ret
    80005652:	74a6                	ld	s1,104(sp)
    80005654:	69e6                	ld	s3,88(sp)
    80005656:	6a46                	ld	s4,80(sp)
    80005658:	6aa6                	ld	s5,72(sp)
    8000565a:	6b06                	ld	s6,64(sp)
    8000565c:	7be2                	ld	s7,56(sp)
    8000565e:	7c42                	ld	s8,48(sp)
    80005660:	7d02                	ld	s10,32(sp)
    release(&pr.lock);
    80005662:	0001e517          	auipc	a0,0x1e
    80005666:	02650513          	addi	a0,a0,38 # 80023688 <pr>
    8000566a:	466000ef          	jal	80005ad0 <release>
    8000566e:	bfd9                	j	80005644 <printf+0x256>
    if(c0 == 'd'){
    80005670:	e57a0fe3          	beq	s4,s7,800054ce <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    80005674:	f94a0713          	addi	a4,s4,-108
    80005678:	00173713          	seqz	a4,a4
    8000567c:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000567e:	4781                	li	a5,0
    80005680:	a00d                	j	800056a2 <printf+0x2b4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005682:	f94a0713          	addi	a4,s4,-108
    80005686:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    8000568a:	8652                	mv	a2,s4
    8000568c:	86d2                	mv	a3,s4
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000568e:	f9460793          	addi	a5,a2,-108
    80005692:	0017b793          	seqz	a5,a5
    80005696:	8ff9                	and	a5,a5,a4
    80005698:	f9c68593          	addi	a1,a3,-100
    8000569c:	e199                	bnez	a1,800056a2 <printf+0x2b4>
    8000569e:	e40799e3          	bnez	a5,800054f0 <printf+0x102>
    } else if(c0 == 'u'){
    800056a2:	e78a05e3          	beq	s4,s8,8000550c <printf+0x11e>
    } else if(c0 == 'l' && c1 == 'u'){
    800056a6:	f8b60593          	addi	a1,a2,-117
    800056aa:	e199                	bnez	a1,800056b0 <printf+0x2c2>
    800056ac:	e6071ce3          	bnez	a4,80005524 <printf+0x136>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056b0:	f8b68593          	addi	a1,a3,-117
    800056b4:	e199                	bnez	a1,800056ba <printf+0x2cc>
    800056b6:	e80795e3          	bnez	a5,80005540 <printf+0x152>
    } else if(c0 == 'x'){
    800056ba:	ebaa01e3          	beq	s4,s10,8000555c <printf+0x16e>
    } else if(c0 == 'l' && c1 == 'x'){
    800056be:	f8860613          	addi	a2,a2,-120
    800056c2:	e219                	bnez	a2,800056c8 <printf+0x2da>
    800056c4:	ea0718e3          	bnez	a4,80005574 <printf+0x186>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800056c8:	f8868693          	addi	a3,a3,-120
    800056cc:	e299                	bnez	a3,800056d2 <printf+0x2e4>
    800056ce:	ec0790e3          	bnez	a5,8000558e <printf+0x1a0>
    } else if(c0 == 'p'){
    800056d2:	07000793          	li	a5,112
    800056d6:	ecfa0ae3          	beq	s4,a5,800055aa <printf+0x1bc>
    } else if(c0 == 's'){
    800056da:	07300793          	li	a5,115
    800056de:	f0fa09e3          	beq	s4,a5,800055f0 <printf+0x202>
    } else if(c0 == '%'){
    800056e2:	02500793          	li	a5,37
    800056e6:	f4fa01e3          	beq	s4,a5,80005628 <printf+0x23a>
    } else if(c0 == 0){
    800056ea:	f40a03e3          	beqz	s4,80005630 <printf+0x242>
      consputc('%');
    800056ee:	02500513          	li	a0,37
    800056f2:	a7dff0ef          	jal	8000516e <consputc>
      consputc(c0);
    800056f6:	8552                	mv	a0,s4
    800056f8:	a77ff0ef          	jal	8000516e <consputc>
    800056fc:	bb9d                	j	80005472 <printf+0x84>

00000000800056fe <panic>:

void
panic(char *s)
{
    800056fe:	1101                	addi	sp,sp,-32
    80005700:	ec06                	sd	ra,24(sp)
    80005702:	e822                	sd	s0,16(sp)
    80005704:	e426                	sd	s1,8(sp)
    80005706:	1000                	addi	s0,sp,32
    80005708:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000570a:	0001e797          	auipc	a5,0x1e
    8000570e:	f807ab23          	sw	zero,-106(a5) # 800236a0 <pr+0x18>
  printf("panic: ");
    80005712:	00002517          	auipc	a0,0x2
    80005716:	04e50513          	addi	a0,a0,78 # 80007760 <etext+0x760>
    8000571a:	cd5ff0ef          	jal	800053ee <printf>
  printf("%s\n", s);
    8000571e:	85a6                	mv	a1,s1
    80005720:	00002517          	auipc	a0,0x2
    80005724:	04850513          	addi	a0,a0,72 # 80007768 <etext+0x768>
    80005728:	cc7ff0ef          	jal	800053ee <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000572c:	4785                	li	a5,1
    8000572e:	00005717          	auipc	a4,0x5
    80005732:	c6f72723          	sw	a5,-914(a4) # 8000a39c <panicked>
  for(;;)
    80005736:	a001                	j	80005736 <panic+0x38>

0000000080005738 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005738:	1141                	addi	sp,sp,-16
    8000573a:	e406                	sd	ra,8(sp)
    8000573c:	e022                	sd	s0,0(sp)
    8000573e:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005740:	00002597          	auipc	a1,0x2
    80005744:	03058593          	addi	a1,a1,48 # 80007770 <etext+0x770>
    80005748:	0001e517          	auipc	a0,0x1e
    8000574c:	f4050513          	addi	a0,a0,-192 # 80023688 <pr>
    80005750:	262000ef          	jal	800059b2 <initlock>
  pr.locking = 1;
    80005754:	4785                	li	a5,1
    80005756:	0001e717          	auipc	a4,0x1e
    8000575a:	f4f72523          	sw	a5,-182(a4) # 800236a0 <pr+0x18>
}
    8000575e:	60a2                	ld	ra,8(sp)
    80005760:	6402                	ld	s0,0(sp)
    80005762:	0141                	addi	sp,sp,16
    80005764:	8082                	ret

0000000080005766 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e406                	sd	ra,8(sp)
    8000576a:	e022                	sd	s0,0(sp)
    8000576c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000576e:	100007b7          	lui	a5,0x10000
    80005772:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005776:	10000737          	lui	a4,0x10000
    8000577a:	f8000693          	li	a3,-128
    8000577e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005782:	468d                	li	a3,3
    80005784:	10000637          	lui	a2,0x10000
    80005788:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000578c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005790:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005794:	8732                	mv	a4,a2
    80005796:	461d                	li	a2,7
    80005798:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000579c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800057a0:	00002597          	auipc	a1,0x2
    800057a4:	fd858593          	addi	a1,a1,-40 # 80007778 <etext+0x778>
    800057a8:	0001e517          	auipc	a0,0x1e
    800057ac:	f0050513          	addi	a0,a0,-256 # 800236a8 <uart_tx_lock>
    800057b0:	202000ef          	jal	800059b2 <initlock>
}
    800057b4:	60a2                	ld	ra,8(sp)
    800057b6:	6402                	ld	s0,0(sp)
    800057b8:	0141                	addi	sp,sp,16
    800057ba:	8082                	ret

00000000800057bc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800057bc:	1101                	addi	sp,sp,-32
    800057be:	ec06                	sd	ra,24(sp)
    800057c0:	e822                	sd	s0,16(sp)
    800057c2:	e426                	sd	s1,8(sp)
    800057c4:	1000                	addi	s0,sp,32
    800057c6:	84aa                	mv	s1,a0
  push_off();
    800057c8:	230000ef          	jal	800059f8 <push_off>

  if(panicked){
    800057cc:	00005797          	auipc	a5,0x5
    800057d0:	bd07a783          	lw	a5,-1072(a5) # 8000a39c <panicked>
    800057d4:	e795                	bnez	a5,80005800 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800057d6:	10000737          	lui	a4,0x10000
    800057da:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800057dc:	00074783          	lbu	a5,0(a4)
    800057e0:	0207f793          	andi	a5,a5,32
    800057e4:	dfe5                	beqz	a5,800057dc <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800057e6:	0ff4f513          	zext.b	a0,s1
    800057ea:	100007b7          	lui	a5,0x10000
    800057ee:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800057f2:	28e000ef          	jal	80005a80 <pop_off>
}
    800057f6:	60e2                	ld	ra,24(sp)
    800057f8:	6442                	ld	s0,16(sp)
    800057fa:	64a2                	ld	s1,8(sp)
    800057fc:	6105                	addi	sp,sp,32
    800057fe:	8082                	ret
    for(;;)
    80005800:	a001                	j	80005800 <uartputc_sync+0x44>

0000000080005802 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005802:	00005797          	auipc	a5,0x5
    80005806:	b9e7b783          	ld	a5,-1122(a5) # 8000a3a0 <uart_tx_r>
    8000580a:	00005717          	auipc	a4,0x5
    8000580e:	b9e73703          	ld	a4,-1122(a4) # 8000a3a8 <uart_tx_w>
    80005812:	08f70163          	beq	a4,a5,80005894 <uartstart+0x92>
{
    80005816:	7139                	addi	sp,sp,-64
    80005818:	fc06                	sd	ra,56(sp)
    8000581a:	f822                	sd	s0,48(sp)
    8000581c:	f426                	sd	s1,40(sp)
    8000581e:	f04a                	sd	s2,32(sp)
    80005820:	ec4e                	sd	s3,24(sp)
    80005822:	e852                	sd	s4,16(sp)
    80005824:	e456                	sd	s5,8(sp)
    80005826:	e05a                	sd	s6,0(sp)
    80005828:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000582a:	10000937          	lui	s2,0x10000
    8000582e:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005830:	0001ea97          	auipc	s5,0x1e
    80005834:	e78a8a93          	addi	s5,s5,-392 # 800236a8 <uart_tx_lock>
    uart_tx_r += 1;
    80005838:	00005497          	auipc	s1,0x5
    8000583c:	b6848493          	addi	s1,s1,-1176 # 8000a3a0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005840:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005844:	00005997          	auipc	s3,0x5
    80005848:	b6498993          	addi	s3,s3,-1180 # 8000a3a8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000584c:	00094703          	lbu	a4,0(s2)
    80005850:	02077713          	andi	a4,a4,32
    80005854:	c715                	beqz	a4,80005880 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005856:	01f7f713          	andi	a4,a5,31
    8000585a:	9756                	add	a4,a4,s5
    8000585c:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005860:	0785                	addi	a5,a5,1
    80005862:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005864:	8526                	mv	a0,s1
    80005866:	b4bfb0ef          	jal	800013b0 <wakeup>
    WriteReg(THR, c);
    8000586a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000586e:	609c                	ld	a5,0(s1)
    80005870:	0009b703          	ld	a4,0(s3)
    80005874:	fcf71ce3          	bne	a4,a5,8000584c <uartstart+0x4a>
      ReadReg(ISR);
    80005878:	100007b7          	lui	a5,0x10000
    8000587c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005880:	70e2                	ld	ra,56(sp)
    80005882:	7442                	ld	s0,48(sp)
    80005884:	74a2                	ld	s1,40(sp)
    80005886:	7902                	ld	s2,32(sp)
    80005888:	69e2                	ld	s3,24(sp)
    8000588a:	6a42                	ld	s4,16(sp)
    8000588c:	6aa2                	ld	s5,8(sp)
    8000588e:	6b02                	ld	s6,0(sp)
    80005890:	6121                	addi	sp,sp,64
    80005892:	8082                	ret
      ReadReg(ISR);
    80005894:	100007b7          	lui	a5,0x10000
    80005898:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000589c:	8082                	ret

000000008000589e <uartputc>:
{
    8000589e:	7179                	addi	sp,sp,-48
    800058a0:	f406                	sd	ra,40(sp)
    800058a2:	f022                	sd	s0,32(sp)
    800058a4:	ec26                	sd	s1,24(sp)
    800058a6:	e84a                	sd	s2,16(sp)
    800058a8:	e44e                	sd	s3,8(sp)
    800058aa:	e052                	sd	s4,0(sp)
    800058ac:	1800                	addi	s0,sp,48
    800058ae:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800058b0:	0001e517          	auipc	a0,0x1e
    800058b4:	df850513          	addi	a0,a0,-520 # 800236a8 <uart_tx_lock>
    800058b8:	184000ef          	jal	80005a3c <acquire>
  if(panicked){
    800058bc:	00005797          	auipc	a5,0x5
    800058c0:	ae07a783          	lw	a5,-1312(a5) # 8000a39c <panicked>
    800058c4:	e3d1                	bnez	a5,80005948 <uartputc+0xaa>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058c6:	00005717          	auipc	a4,0x5
    800058ca:	ae273703          	ld	a4,-1310(a4) # 8000a3a8 <uart_tx_w>
    800058ce:	00005797          	auipc	a5,0x5
    800058d2:	ad27b783          	ld	a5,-1326(a5) # 8000a3a0 <uart_tx_r>
    800058d6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800058da:	0001e997          	auipc	s3,0x1e
    800058de:	dce98993          	addi	s3,s3,-562 # 800236a8 <uart_tx_lock>
    800058e2:	00005497          	auipc	s1,0x5
    800058e6:	abe48493          	addi	s1,s1,-1346 # 8000a3a0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058ea:	00005917          	auipc	s2,0x5
    800058ee:	abe90913          	addi	s2,s2,-1346 # 8000a3a8 <uart_tx_w>
    800058f2:	00e79d63          	bne	a5,a4,8000590c <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800058f6:	85ce                	mv	a1,s3
    800058f8:	8526                	mv	a0,s1
    800058fa:	a6bfb0ef          	jal	80001364 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058fe:	00093703          	ld	a4,0(s2)
    80005902:	609c                	ld	a5,0(s1)
    80005904:	02078793          	addi	a5,a5,32
    80005908:	fee787e3          	beq	a5,a4,800058f6 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000590c:	01f77693          	andi	a3,a4,31
    80005910:	0001e797          	auipc	a5,0x1e
    80005914:	d9878793          	addi	a5,a5,-616 # 800236a8 <uart_tx_lock>
    80005918:	97b6                	add	a5,a5,a3
    8000591a:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000591e:	0705                	addi	a4,a4,1
    80005920:	00005797          	auipc	a5,0x5
    80005924:	a8e7b423          	sd	a4,-1400(a5) # 8000a3a8 <uart_tx_w>
  uartstart();
    80005928:	edbff0ef          	jal	80005802 <uartstart>
  release(&uart_tx_lock);
    8000592c:	0001e517          	auipc	a0,0x1e
    80005930:	d7c50513          	addi	a0,a0,-644 # 800236a8 <uart_tx_lock>
    80005934:	19c000ef          	jal	80005ad0 <release>
}
    80005938:	70a2                	ld	ra,40(sp)
    8000593a:	7402                	ld	s0,32(sp)
    8000593c:	64e2                	ld	s1,24(sp)
    8000593e:	6942                	ld	s2,16(sp)
    80005940:	69a2                	ld	s3,8(sp)
    80005942:	6a02                	ld	s4,0(sp)
    80005944:	6145                	addi	sp,sp,48
    80005946:	8082                	ret
    for(;;)
    80005948:	a001                	j	80005948 <uartputc+0xaa>

000000008000594a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000594a:	1141                	addi	sp,sp,-16
    8000594c:	e406                	sd	ra,8(sp)
    8000594e:	e022                	sd	s0,0(sp)
    80005950:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005952:	100007b7          	lui	a5,0x10000
    80005956:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000595a:	8b85                	andi	a5,a5,1
    8000595c:	cb89                	beqz	a5,8000596e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000595e:	100007b7          	lui	a5,0x10000
    80005962:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005966:	60a2                	ld	ra,8(sp)
    80005968:	6402                	ld	s0,0(sp)
    8000596a:	0141                	addi	sp,sp,16
    8000596c:	8082                	ret
    return -1;
    8000596e:	557d                	li	a0,-1
    80005970:	bfdd                	j	80005966 <uartgetc+0x1c>

0000000080005972 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005972:	1101                	addi	sp,sp,-32
    80005974:	ec06                	sd	ra,24(sp)
    80005976:	e822                	sd	s0,16(sp)
    80005978:	e426                	sd	s1,8(sp)
    8000597a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000597c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000597e:	fcdff0ef          	jal	8000594a <uartgetc>
    if(c == -1)
    80005982:	00950563          	beq	a0,s1,8000598c <uartintr+0x1a>
      break;
    consoleintr(c);
    80005986:	81bff0ef          	jal	800051a0 <consoleintr>
  while(1){
    8000598a:	bfd5                	j	8000597e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000598c:	0001e517          	auipc	a0,0x1e
    80005990:	d1c50513          	addi	a0,a0,-740 # 800236a8 <uart_tx_lock>
    80005994:	0a8000ef          	jal	80005a3c <acquire>
  uartstart();
    80005998:	e6bff0ef          	jal	80005802 <uartstart>
  release(&uart_tx_lock);
    8000599c:	0001e517          	auipc	a0,0x1e
    800059a0:	d0c50513          	addi	a0,a0,-756 # 800236a8 <uart_tx_lock>
    800059a4:	12c000ef          	jal	80005ad0 <release>
}
    800059a8:	60e2                	ld	ra,24(sp)
    800059aa:	6442                	ld	s0,16(sp)
    800059ac:	64a2                	ld	s1,8(sp)
    800059ae:	6105                	addi	sp,sp,32
    800059b0:	8082                	ret

00000000800059b2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800059b2:	1141                	addi	sp,sp,-16
    800059b4:	e406                	sd	ra,8(sp)
    800059b6:	e022                	sd	s0,0(sp)
    800059b8:	0800                	addi	s0,sp,16
  lk->name = name;
    800059ba:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800059bc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800059c0:	00053823          	sd	zero,16(a0)
}
    800059c4:	60a2                	ld	ra,8(sp)
    800059c6:	6402                	ld	s0,0(sp)
    800059c8:	0141                	addi	sp,sp,16
    800059ca:	8082                	ret

00000000800059cc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800059cc:	411c                	lw	a5,0(a0)
    800059ce:	e399                	bnez	a5,800059d4 <holding+0x8>
    800059d0:	4501                	li	a0,0
  return r;
}
    800059d2:	8082                	ret
{
    800059d4:	1101                	addi	sp,sp,-32
    800059d6:	ec06                	sd	ra,24(sp)
    800059d8:	e822                	sd	s0,16(sp)
    800059da:	e426                	sd	s1,8(sp)
    800059dc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059de:	691c                	ld	a5,16(a0)
    800059e0:	84be                	mv	s1,a5
    800059e2:	b84fb0ef          	jal	80000d66 <mycpu>
    800059e6:	40a48533          	sub	a0,s1,a0
    800059ea:	00153513          	seqz	a0,a0
}
    800059ee:	60e2                	ld	ra,24(sp)
    800059f0:	6442                	ld	s0,16(sp)
    800059f2:	64a2                	ld	s1,8(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret

00000000800059f8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800059f8:	1101                	addi	sp,sp,-32
    800059fa:	ec06                	sd	ra,24(sp)
    800059fc:	e822                	sd	s0,16(sp)
    800059fe:	e426                	sd	s1,8(sp)
    80005a00:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a02:	100027f3          	csrr	a5,sstatus
    80005a06:	84be                	mv	s1,a5
    80005a08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005a0c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a0e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005a12:	b54fb0ef          	jal	80000d66 <mycpu>
    80005a16:	5d3c                	lw	a5,120(a0)
    80005a18:	cb99                	beqz	a5,80005a2e <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005a1a:	b4cfb0ef          	jal	80000d66 <mycpu>
    80005a1e:	5d3c                	lw	a5,120(a0)
    80005a20:	2785                	addiw	a5,a5,1
    80005a22:	dd3c                	sw	a5,120(a0)
}
    80005a24:	60e2                	ld	ra,24(sp)
    80005a26:	6442                	ld	s0,16(sp)
    80005a28:	64a2                	ld	s1,8(sp)
    80005a2a:	6105                	addi	sp,sp,32
    80005a2c:	8082                	ret
    mycpu()->intena = old;
    80005a2e:	b38fb0ef          	jal	80000d66 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005a32:	0014d793          	srli	a5,s1,0x1
    80005a36:	8b85                	andi	a5,a5,1
    80005a38:	dd7c                	sw	a5,124(a0)
    80005a3a:	b7c5                	j	80005a1a <push_off+0x22>

0000000080005a3c <acquire>:
{
    80005a3c:	1101                	addi	sp,sp,-32
    80005a3e:	ec06                	sd	ra,24(sp)
    80005a40:	e822                	sd	s0,16(sp)
    80005a42:	e426                	sd	s1,8(sp)
    80005a44:	1000                	addi	s0,sp,32
    80005a46:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a48:	fb1ff0ef          	jal	800059f8 <push_off>
  if(holding(lk))
    80005a4c:	8526                	mv	a0,s1
    80005a4e:	f7fff0ef          	jal	800059cc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a52:	4705                	li	a4,1
  if(holding(lk))
    80005a54:	e105                	bnez	a0,80005a74 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a56:	87ba                	mv	a5,a4
    80005a58:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a5c:	2781                	sext.w	a5,a5
    80005a5e:	ffe5                	bnez	a5,80005a56 <acquire+0x1a>
  __sync_synchronize();
    80005a60:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a64:	b02fb0ef          	jal	80000d66 <mycpu>
    80005a68:	e888                	sd	a0,16(s1)
}
    80005a6a:	60e2                	ld	ra,24(sp)
    80005a6c:	6442                	ld	s0,16(sp)
    80005a6e:	64a2                	ld	s1,8(sp)
    80005a70:	6105                	addi	sp,sp,32
    80005a72:	8082                	ret
    panic("acquire");
    80005a74:	00002517          	auipc	a0,0x2
    80005a78:	d0c50513          	addi	a0,a0,-756 # 80007780 <etext+0x780>
    80005a7c:	c83ff0ef          	jal	800056fe <panic>

0000000080005a80 <pop_off>:

void
pop_off(void)
{
    80005a80:	1141                	addi	sp,sp,-16
    80005a82:	e406                	sd	ra,8(sp)
    80005a84:	e022                	sd	s0,0(sp)
    80005a86:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a88:	adefb0ef          	jal	80000d66 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a8c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a90:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a92:	e39d                	bnez	a5,80005ab8 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a94:	5d3c                	lw	a5,120(a0)
    80005a96:	02f05763          	blez	a5,80005ac4 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005a9a:	37fd                	addiw	a5,a5,-1
    80005a9c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a9e:	eb89                	bnez	a5,80005ab0 <pop_off+0x30>
    80005aa0:	5d7c                	lw	a5,124(a0)
    80005aa2:	c799                	beqz	a5,80005ab0 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005aa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005aa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005aac:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ab0:	60a2                	ld	ra,8(sp)
    80005ab2:	6402                	ld	s0,0(sp)
    80005ab4:	0141                	addi	sp,sp,16
    80005ab6:	8082                	ret
    panic("pop_off - interruptible");
    80005ab8:	00002517          	auipc	a0,0x2
    80005abc:	cd050513          	addi	a0,a0,-816 # 80007788 <etext+0x788>
    80005ac0:	c3fff0ef          	jal	800056fe <panic>
    panic("pop_off");
    80005ac4:	00002517          	auipc	a0,0x2
    80005ac8:	cdc50513          	addi	a0,a0,-804 # 800077a0 <etext+0x7a0>
    80005acc:	c33ff0ef          	jal	800056fe <panic>

0000000080005ad0 <release>:
{
    80005ad0:	1101                	addi	sp,sp,-32
    80005ad2:	ec06                	sd	ra,24(sp)
    80005ad4:	e822                	sd	s0,16(sp)
    80005ad6:	e426                	sd	s1,8(sp)
    80005ad8:	1000                	addi	s0,sp,32
    80005ada:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005adc:	ef1ff0ef          	jal	800059cc <holding>
    80005ae0:	c105                	beqz	a0,80005b00 <release+0x30>
  lk->cpu = 0;
    80005ae2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005ae6:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005aea:	0310000f          	fence	rw,w
    80005aee:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005af2:	f8fff0ef          	jal	80005a80 <pop_off>
}
    80005af6:	60e2                	ld	ra,24(sp)
    80005af8:	6442                	ld	s0,16(sp)
    80005afa:	64a2                	ld	s1,8(sp)
    80005afc:	6105                	addi	sp,sp,32
    80005afe:	8082                	ret
    panic("release");
    80005b00:	00002517          	auipc	a0,0x2
    80005b04:	ca850513          	addi	a0,a0,-856 # 800077a8 <etext+0x7a8>
    80005b08:	bf7ff0ef          	jal	800056fe <panic>
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
