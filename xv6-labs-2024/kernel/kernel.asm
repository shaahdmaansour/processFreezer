
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	53010113          	addi	sp,sp,1328 # 8001b530 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6b1040ef          	jal	80004ec6 <start>

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
    8000002c:	60878793          	addi	a5,a5,1544 # 80023630 <end>
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
    80000056:	2ae90913          	addi	s2,s2,686 # 8000a300 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	121050ef          	jal	8000597c <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	1a5050ef          	jal	80005a10 <release>
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
    80000084:	5ba050ef          	jal	8000563e <panic>

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
    800000e4:	22050513          	addi	a0,a0,544 # 8000a300 <kmem>
    800000e8:	00b050ef          	jal	800058f2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00023517          	auipc	a0,0x23
    800000f4:	54050513          	addi	a0,a0,1344 # 80023630 <end>
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
    80000112:	1f250513          	addi	a0,a0,498 # 8000a300 <kmem>
    80000116:	067050ef          	jal	8000597c <acquire>
  r = kmem.freelist;
    8000011a:	0000a497          	auipc	s1,0xa
    8000011e:	1fe4b483          	ld	s1,510(s1) # 8000a318 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	0000a717          	auipc	a4,0xa
    8000012a:	1ef73923          	sd	a5,498(a4) # 8000a318 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	0000a517          	auipc	a0,0xa
    80000132:	1d250513          	addi	a0,a0,466 # 8000a300 <kmem>
    80000136:	0db050ef          	jal	80005a10 <release>

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
    80000154:	1b050513          	addi	a0,a0,432 # 8000a300 <kmem>
    80000158:	0b9050ef          	jal	80005a10 <release>
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
    80000324:	fb070713          	addi	a4,a4,-80 # 8000a2d0 <started>
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
    80000342:	7ed040ef          	jal	8000532e <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	53a010ef          	jal	80001884 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	5ba040ef          	jal	80004908 <plicinithart>
  }

  scheduler();        
    80000352:	66b000ef          	jal	800011bc <scheduler>
    consoleinit();
    80000356:	6ff040ef          	jal	80005254 <consoleinit>
    printfinit();
    8000035a:	31e050ef          	jal	80005678 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	7c9040ef          	jal	8000532e <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	7bd040ef          	jal	8000532e <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	7b1040ef          	jal	8000532e <printf>
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
    8000039a:	554040ef          	jal	800048ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	56a040ef          	jal	80004908 <plicinithart>
    binit();         // buffer cache
    800003a2:	413010ef          	jal	80001fb4 <binit>
    iinit();         // inode table
    800003a6:	1ce020ef          	jal	80002574 <iinit>
    fileinit();      // file table
    800003aa:	7bd020ef          	jal	80003366 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	64a040ef          	jal	800049f8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	43f000ef          	jal	80000ff0 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	0000a717          	auipc	a4,0xa
    800003c0:	f0f72a23          	sw	a5,-236(a4) # 8000a2d0 <started>
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
    800003d6:	f067b783          	ld	a5,-250(a5) # 8000a2d8 <kernel_pagetable>
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
    80000460:	1de050ef          	jal	8000563e <panic>
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
    80000538:	106050ef          	jal	8000563e <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	0fa050ef          	jal	8000563e <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	0ee050ef          	jal	8000563e <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	0e2050ef          	jal	8000563e <panic>
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
    800005a0:	09e050ef          	jal	8000563e <panic>

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
    80000662:	c6a7bd23          	sd	a0,-902(a5) # 8000a2d8 <kernel_pagetable>
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
    800006b6:	789040ef          	jal	8000563e <panic>
      panic("uvmunmap: walk");
    800006ba:	00007517          	auipc	a0,0x7
    800006be:	a1e50513          	addi	a0,a0,-1506 # 800070d8 <etext+0xd8>
    800006c2:	77d040ef          	jal	8000563e <panic>
      panic("uvmunmap: not mapped");
    800006c6:	00007517          	auipc	a0,0x7
    800006ca:	a2250513          	addi	a0,a0,-1502 # 800070e8 <etext+0xe8>
    800006ce:	771040ef          	jal	8000563e <panic>
      panic("uvmunmap: not a leaf");
    800006d2:	00007517          	auipc	a0,0x7
    800006d6:	a2e50513          	addi	a0,a0,-1490 # 80007100 <etext+0x100>
    800006da:	765040ef          	jal	8000563e <panic>
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
    800007aa:	695040ef          	jal	8000563e <panic>

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
    800008bc:	583040ef          	jal	8000563e <panic>
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
    80000998:	4a7040ef          	jal	8000563e <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	49b040ef          	jal	8000563e <panic>
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
    800009fe:	441040ef          	jal	8000563e <panic>

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
    80000c12:	b4248493          	addi	s1,s1,-1214 # 8000a750 <proc>
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
    80000c42:	512a8a93          	addi	s5,s5,1298 # 80010150 <tickslock>
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
    80000c94:	1ab040ef          	jal	8000563e <panic>

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
    80000cb8:	66c50513          	addi	a0,a0,1644 # 8000a320 <pid_lock>
    80000cbc:	437040ef          	jal	800058f2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	4e858593          	addi	a1,a1,1256 # 800071a8 <etext+0x1a8>
    80000cc8:	00009517          	auipc	a0,0x9
    80000ccc:	67050513          	addi	a0,a0,1648 # 8000a338 <wait_lock>
    80000cd0:	423040ef          	jal	800058f2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	a7c48493          	addi	s1,s1,-1412 # 8000a750 <proc>
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
    80000d0c:	448a0a13          	addi	s4,s4,1096 # 80010150 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	3df040ef          	jal	800058f2 <initlock>
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
    80000d78:	5dc50513          	addi	a0,a0,1500 # 8000a350 <cpus>
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
    80000d90:	3a9040ef          	jal	80005938 <push_off>
    80000d94:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d96:	2781                	sext.w	a5,a5
    80000d98:	079e                	slli	a5,a5,0x7
    80000d9a:	00009717          	auipc	a4,0x9
    80000d9e:	58670713          	addi	a4,a4,1414 # 8000a320 <pid_lock>
    80000da2:	97ba                	add	a5,a5,a4
    80000da4:	7b9c                	ld	a5,48(a5)
    80000da6:	84be                	mv	s1,a5
  pop_off();
    80000da8:	419040ef          	jal	800059c0 <pop_off>
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
    80000dc4:	44d040ef          	jal	80005a10 <release>

  if (first) {
    80000dc8:	00009797          	auipc	a5,0x9
    80000dcc:	4b87a783          	lw	a5,1208(a5) # 8000a280 <first.1>
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
    80000de0:	72a010ef          	jal	8000250a <fsinit>
    first = 0;
    80000de4:	00009797          	auipc	a5,0x9
    80000de8:	4807ae23          	sw	zero,1180(a5) # 8000a280 <first.1>
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
    80000e00:	52450513          	addi	a0,a0,1316 # 8000a320 <pid_lock>
    80000e04:	379040ef          	jal	8000597c <acquire>
  pid = nextpid;
    80000e08:	00009797          	auipc	a5,0x9
    80000e0c:	47c78793          	addi	a5,a5,1148 # 8000a284 <nextpid>
    80000e10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e12:	0014871b          	addiw	a4,s1,1
    80000e16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e18:	00009517          	auipc	a0,0x9
    80000e1c:	50850513          	addi	a0,a0,1288 # 8000a320 <pid_lock>
    80000e20:	3f1040ef          	jal	80005a10 <release>
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
    80000f56:	00009497          	auipc	s1,0x9
    80000f5a:	7fa48493          	addi	s1,s1,2042 # 8000a750 <proc>
    80000f5e:	0000f917          	auipc	s2,0xf
    80000f62:	1f290913          	addi	s2,s2,498 # 80010150 <tickslock>
    acquire(&p->lock);
    80000f66:	8526                	mv	a0,s1
    80000f68:	215040ef          	jal	8000597c <acquire>
    if(p->state == UNUSED) {
    80000f6c:	4c9c                	lw	a5,24(s1)
    80000f6e:	cb91                	beqz	a5,80000f82 <allocproc+0x38>
      release(&p->lock);
    80000f70:	8526                	mv	a0,s1
    80000f72:	29f040ef          	jal	80005a10 <release>
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
    80000fd8:	239040ef          	jal	80005a10 <release>
    return 0;
    80000fdc:	84ca                	mv	s1,s2
    80000fde:	b7d5                	j	80000fc2 <allocproc+0x78>
    freeproc(p);
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	f19ff0ef          	jal	80000efa <freeproc>
    release(&p->lock);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	229040ef          	jal	80005a10 <release>
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
    80001004:	2ea7b023          	sd	a0,736(a5) # 8000a2e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001008:	03400613          	li	a2,52
    8000100c:	00009597          	auipc	a1,0x9
    80001010:	28458593          	addi	a1,a1,644 # 8000a290 <initcode>
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
    80001042:	5f9010ef          	jal	80002e3a <namei>
    80001046:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000104a:	478d                	li	a5,3
    8000104c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000104e:	8526                	mv	a0,s1
    80001050:	1c1040ef          	jal	80005a10 <release>
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
    80001132:	0df040ef          	jal	80005a10 <release>
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
    80001148:	2a0020ef          	jal	800033e8 <filedup>
    8000114c:	00a93023          	sd	a0,0(s2)
    80001150:	b7f5                	j	8000113c <fork+0x8e>
  np->cwd = idup(p->cwd);
    80001152:	150ab503          	ld	a0,336(s5)
    80001156:	5b0010ef          	jal	80002706 <idup>
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
    80001172:	09f040ef          	jal	80005a10 <release>
  acquire(&wait_lock);
    80001176:	00009517          	auipc	a0,0x9
    8000117a:	1c250513          	addi	a0,a0,450 # 8000a338 <wait_lock>
    8000117e:	7fe040ef          	jal	8000597c <acquire>
  np->parent = p;
    80001182:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001186:	00009517          	auipc	a0,0x9
    8000118a:	1b250513          	addi	a0,a0,434 # 8000a338 <wait_lock>
    8000118e:	083040ef          	jal	80005a10 <release>
  acquire(&np->lock);
    80001192:	8552                	mv	a0,s4
    80001194:	7e8040ef          	jal	8000597c <acquire>
  np->state = RUNNABLE;
    80001198:	478d                	li	a5,3
    8000119a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000119e:	8552                	mv	a0,s4
    800011a0:	071040ef          	jal	80005a10 <release>
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
    800011e0:	14470713          	addi	a4,a4,324 # 8000a320 <pid_lock>
    800011e4:	975e                	add	a4,a4,s7
    800011e6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011ea:	00009717          	auipc	a4,0x9
    800011ee:	16e70713          	addi	a4,a4,366 # 8000a358 <cpus+0x8>
    800011f2:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE) {
    800011f4:	498d                	li	s3,3
        c->proc = p;
    800011f6:	079e                	slli	a5,a5,0x7
    800011f8:	00009a17          	auipc	s4,0x9
    800011fc:	128a0a13          	addi	s4,s4,296 # 8000a320 <pid_lock>
    80001200:	9a3e                	add	s4,s4,a5
        found = 1;
    80001202:	4c05                	li	s8,1
    80001204:	a899                	j	8000125a <scheduler+0x9e>
        release(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	009040ef          	jal	80005a10 <release>
        continue;
    8000120c:	a021                	j	80001214 <scheduler+0x58>
      release(&p->lock);
    8000120e:	8526                	mv	a0,s1
    80001210:	001040ef          	jal	80005a10 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001214:	16848493          	addi	s1,s1,360
    80001218:	03248763          	beq	s1,s2,80001246 <scheduler+0x8a>
      acquire(&p->lock);
    8000121c:	8526                	mv	a0,s1
    8000121e:	75e040ef          	jal	8000597c <acquire>
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
    8000126c:	4e848493          	addi	s1,s1,1256 # 8000a750 <proc>
        p->state = RUNNING;
    80001270:	4b11                	li	s6,4
    for(p = proc; p < &proc[NPROC]; p++) {
    80001272:	0000f917          	auipc	s2,0xf
    80001276:	ede90913          	addi	s2,s2,-290 # 80010150 <tickslock>
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
    80001290:	67c040ef          	jal	8000590c <holding>
    80001294:	c935                	beqz	a0,80001308 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001296:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	00009717          	auipc	a4,0x9
    800012a0:	08470713          	addi	a4,a4,132 # 8000a320 <pid_lock>
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
    800012c6:	05e90913          	addi	s2,s2,94 # 8000a320 <pid_lock>
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
    800012e0:	07458593          	addi	a1,a1,116 # 8000a350 <cpus>
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
    80001310:	32e040ef          	jal	8000563e <panic>
    panic("sched locks");
    80001314:	00006517          	auipc	a0,0x6
    80001318:	ed450513          	addi	a0,a0,-300 # 800071e8 <etext+0x1e8>
    8000131c:	322040ef          	jal	8000563e <panic>
    panic("sched running");
    80001320:	00006517          	auipc	a0,0x6
    80001324:	ed850513          	addi	a0,a0,-296 # 800071f8 <etext+0x1f8>
    80001328:	316040ef          	jal	8000563e <panic>
    panic("sched interruptible");
    8000132c:	00006517          	auipc	a0,0x6
    80001330:	edc50513          	addi	a0,a0,-292 # 80007208 <etext+0x208>
    80001334:	30a040ef          	jal	8000563e <panic>

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
    80001348:	634040ef          	jal	8000597c <acquire>
  p->state = RUNNABLE;
    8000134c:	478d                	li	a5,3
    8000134e:	cc9c                	sw	a5,24(s1)
  sched();
    80001350:	f2dff0ef          	jal	8000127c <sched>
  release(&p->lock);
    80001354:	8526                	mv	a0,s1
    80001356:	6ba040ef          	jal	80005a10 <release>
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
    8000137c:	600040ef          	jal	8000597c <acquire>
  release(lk);
    80001380:	854a                	mv	a0,s2
    80001382:	68e040ef          	jal	80005a10 <release>

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
    80001398:	678040ef          	jal	80005a10 <release>
  acquire(lk);
    8000139c:	854a                	mv	a0,s2
    8000139e:	5de040ef          	jal	8000597c <acquire>
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
    800013c8:	38c48493          	addi	s1,s1,908 # 8000a750 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013cc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013ce:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d0:	0000f917          	auipc	s2,0xf
    800013d4:	d8090913          	addi	s2,s2,-640 # 80010150 <tickslock>
    800013d8:	a801                	j	800013e8 <wakeup+0x38>
      }
      release(&p->lock);
    800013da:	8526                	mv	a0,s1
    800013dc:	634040ef          	jal	80005a10 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e0:	16848493          	addi	s1,s1,360
    800013e4:	03248263          	beq	s1,s2,80001408 <wakeup+0x58>
    if(p != myproc()){
    800013e8:	99fff0ef          	jal	80000d86 <myproc>
    800013ec:	fe950ae3          	beq	a0,s1,800013e0 <wakeup+0x30>
      acquire(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	58a040ef          	jal	8000597c <acquire>
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
    80001430:	32448493          	addi	s1,s1,804 # 8000a750 <proc>
      pp->parent = initproc;
    80001434:	00009a17          	auipc	s4,0x9
    80001438:	eaca0a13          	addi	s4,s4,-340 # 8000a2e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143c:	0000f997          	auipc	s3,0xf
    80001440:	d1498993          	addi	s3,s3,-748 # 80010150 <tickslock>
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
    8000148c:	e587b783          	ld	a5,-424(a5) # 8000a2e0 <initproc>
    80001490:	0d050493          	addi	s1,a0,208
    80001494:	15050913          	addi	s2,a0,336
    80001498:	00a79b63          	bne	a5,a0,800014ae <exit+0x3e>
    panic("init exiting");
    8000149c:	00006517          	auipc	a0,0x6
    800014a0:	d8450513          	addi	a0,a0,-636 # 80007220 <etext+0x220>
    800014a4:	19a040ef          	jal	8000563e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014a8:	04a1                	addi	s1,s1,8
    800014aa:	01248963          	beq	s1,s2,800014bc <exit+0x4c>
    if(p->ofile[fd]){
    800014ae:	6088                	ld	a0,0(s1)
    800014b0:	dd65                	beqz	a0,800014a8 <exit+0x38>
      fileclose(f);
    800014b2:	77d010ef          	jal	8000342e <fileclose>
      p->ofile[fd] = 0;
    800014b6:	0004b023          	sd	zero,0(s1)
    800014ba:	b7fd                	j	800014a8 <exit+0x38>
  begin_op();
    800014bc:	341010ef          	jal	80002ffc <begin_op>
  iput(p->cwd);
    800014c0:	1509b503          	ld	a0,336(s3)
    800014c4:	3fa010ef          	jal	800028be <iput>
  end_op();
    800014c8:	3a5010ef          	jal	8000306c <end_op>
  p->cwd = 0;
    800014cc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014d0:	00009517          	auipc	a0,0x9
    800014d4:	e6850513          	addi	a0,a0,-408 # 8000a338 <wait_lock>
    800014d8:	4a4040ef          	jal	8000597c <acquire>
  reparent(p);
    800014dc:	854e                	mv	a0,s3
    800014de:	f3dff0ef          	jal	8000141a <reparent>
  wakeup(p->parent);
    800014e2:	0389b503          	ld	a0,56(s3)
    800014e6:	ecbff0ef          	jal	800013b0 <wakeup>
  acquire(&p->lock);
    800014ea:	854e                	mv	a0,s3
    800014ec:	490040ef          	jal	8000597c <acquire>
  p->xstate = status;
    800014f0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014f4:	4795                	li	a5,5
    800014f6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014fa:	00009517          	auipc	a0,0x9
    800014fe:	e3e50513          	addi	a0,a0,-450 # 8000a338 <wait_lock>
    80001502:	50e040ef          	jal	80005a10 <release>
  sched();
    80001506:	d77ff0ef          	jal	8000127c <sched>
  panic("zombie exit");
    8000150a:	00006517          	auipc	a0,0x6
    8000150e:	d2650513          	addi	a0,a0,-730 # 80007230 <etext+0x230>
    80001512:	12c040ef          	jal	8000563e <panic>

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
    8000152a:	22a48493          	addi	s1,s1,554 # 8000a750 <proc>
    8000152e:	0000f997          	auipc	s3,0xf
    80001532:	c2298993          	addi	s3,s3,-990 # 80010150 <tickslock>
    acquire(&p->lock);
    80001536:	8526                	mv	a0,s1
    80001538:	444040ef          	jal	8000597c <acquire>
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
    80001544:	4cc040ef          	jal	80005a10 <release>
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
    80001562:	4ae040ef          	jal	80005a10 <release>
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
    80001588:	3f4040ef          	jal	8000597c <acquire>
  p->killed = 1;
    8000158c:	4785                	li	a5,1
    8000158e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001590:	8526                	mv	a0,s1
    80001592:	47e040ef          	jal	80005a10 <release>
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
    800015ae:	3ce040ef          	jal	8000597c <acquire>
  k = p->killed;
    800015b2:	549c                	lw	a5,40(s1)
    800015b4:	893e                	mv	s2,a5
  release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	458040ef          	jal	80005a10 <release>
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
    800015ec:	d5050513          	addi	a0,a0,-688 # 8000a338 <wait_lock>
    800015f0:	38c040ef          	jal	8000597c <acquire>
        if(pp->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
        havekids = 1;
    800015f6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f8:	0000f997          	auipc	s3,0xf
    800015fc:	b5898993          	addi	s3,s3,-1192 # 80010150 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	00009b17          	auipc	s6,0x9
    80001604:	d38b0b13          	addi	s6,s6,-712 # 8000a338 <wait_lock>
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
    8000162e:	3e2040ef          	jal	80005a10 <release>
          release(&wait_lock);
    80001632:	00009517          	auipc	a0,0x9
    80001636:	d0650513          	addi	a0,a0,-762 # 8000a338 <wait_lock>
    8000163a:	3d6040ef          	jal	80005a10 <release>
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
    80001658:	3b8040ef          	jal	80005a10 <release>
            release(&wait_lock);
    8000165c:	00009517          	auipc	a0,0x9
    80001660:	cdc50513          	addi	a0,a0,-804 # 8000a338 <wait_lock>
    80001664:	3ac040ef          	jal	80005a10 <release>
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
    8000167c:	300040ef          	jal	8000597c <acquire>
        if(pp->state == ZOMBIE){
    80001680:	4c9c                	lw	a5,24(s1)
    80001682:	f94784e3          	beq	a5,s4,8000160a <wait+0x40>
        release(&pp->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	388040ef          	jal	80005a10 <release>
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
    800016a8:	0ac48493          	addi	s1,s1,172 # 8000a750 <proc>
    800016ac:	b7e1                	j	80001674 <wait+0xaa>
      release(&wait_lock);
    800016ae:	00009517          	auipc	a0,0x9
    800016b2:	c8a50513          	addi	a0,a0,-886 # 8000a338 <wait_lock>
    800016b6:	35a040ef          	jal	80005a10 <release>
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
    80001770:	3bf030ef          	jal	8000532e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001774:	00009497          	auipc	s1,0x9
    80001778:	13448493          	addi	s1,s1,308 # 8000a8a8 <proc+0x158>
    8000177c:	0000f917          	auipc	s2,0xf
    80001780:	b2c90913          	addi	s2,s2,-1236 # 800102a8 <bcache+0x140>
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
    800017a2:	fd2b8b93          	addi	s7,s7,-46 # 80007770 <states.0>
    800017a6:	a829                	j	800017c0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017a8:	ed86a583          	lw	a1,-296(a3)
    800017ac:	8556                	mv	a0,s5
    800017ae:	381030ef          	jal	8000532e <printf>
    printf("\n");
    800017b2:	8552                	mv	a0,s4
    800017b4:	37b030ef          	jal	8000532e <printf>
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
    80001874:	8e050513          	addi	a0,a0,-1824 # 80010150 <tickslock>
    80001878:	07a040ef          	jal	800058f2 <initlock>
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
    80001890:	00478793          	addi	a5,a5,4 # 80004890 <kernelvec>
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
    8000195a:	0000e517          	auipc	a0,0xe
    8000195e:	7f650513          	addi	a0,a0,2038 # 80010150 <tickslock>
    80001962:	01a040ef          	jal	8000597c <acquire>
    ticks++;
    80001966:	00009717          	auipc	a4,0x9
    8000196a:	98270713          	addi	a4,a4,-1662 # 8000a2e8 <ticks>
    8000196e:	431c                	lw	a5,0(a4)
    80001970:	2785                	addiw	a5,a5,1
    80001972:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001974:	853a                	mv	a0,a4
    80001976:	a3bff0ef          	jal	800013b0 <wakeup>
    release(&tickslock);
    8000197a:	0000e517          	auipc	a0,0xe
    8000197e:	7d650513          	addi	a0,a0,2006 # 80010150 <tickslock>
    80001982:	08e040ef          	jal	80005a10 <release>
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
    800019b4:	789020ef          	jal	8000493c <plic_claim>
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
    800019d0:	6e3030ef          	jal	800058b2 <uartintr>
    if(irq)
    800019d4:	a819                	j	800019ea <devintr+0x62>
      virtio_disk_intr();
    800019d6:	3fc030ef          	jal	80004dd2 <virtio_disk_intr>
    if(irq)
    800019da:	a801                	j	800019ea <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800019dc:	85ba                	mv	a1,a4
    800019de:	00006517          	auipc	a0,0x6
    800019e2:	8b250513          	addi	a0,a0,-1870 # 80007290 <etext+0x290>
    800019e6:	149030ef          	jal	8000532e <printf>
      plic_complete(irq);
    800019ea:	8526                	mv	a0,s1
    800019ec:	771020ef          	jal	8000495c <plic_complete>
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
    80001a18:	e7c78793          	addi	a5,a5,-388 # 80004890 <kernelvec>
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
    80001a52:	3ed030ef          	jal	8000563e <panic>
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
    80001ab0:	07f030ef          	jal	8000532e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ab4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ab8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001abc:	00006517          	auipc	a0,0x6
    80001ac0:	84450513          	addi	a0,a0,-1980 # 80007300 <etext+0x300>
    80001ac4:	06b030ef          	jal	8000532e <printf>
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
    80001b2a:	315030ef          	jal	8000563e <panic>
    panic("kerneltrap: interrupts enabled");
    80001b2e:	00006517          	auipc	a0,0x6
    80001b32:	82250513          	addi	a0,a0,-2014 # 80007350 <etext+0x350>
    80001b36:	309030ef          	jal	8000563e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b3a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b3e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b42:	85ce                	mv	a1,s3
    80001b44:	00006517          	auipc	a0,0x6
    80001b48:	82c50513          	addi	a0,a0,-2004 # 80007370 <etext+0x370>
    80001b4c:	7e2030ef          	jal	8000532e <printf>
    panic("kerneltrap");
    80001b50:	00006517          	auipc	a0,0x6
    80001b54:	84850513          	addi	a0,a0,-1976 # 80007398 <etext+0x398>
    80001b58:	2e7030ef          	jal	8000563e <panic>
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
  switch (n)
    80001b78:	4795                	li	a5,5
    80001b7a:	0497e163          	bltu	a5,s1,80001bbc <argraw+0x54>
    80001b7e:	048a                	slli	s1,s1,0x2
    80001b80:	00006717          	auipc	a4,0x6
    80001b84:	c2070713          	addi	a4,a4,-992 # 800077a0 <states.0+0x30>
    80001b88:	94ba                	add	s1,s1,a4
    80001b8a:	409c                	lw	a5,0(s1)
    80001b8c:	97ba                	add	a5,a5,a4
    80001b8e:	8782                	jr	a5
  {
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
    80001bc4:	27b030ef          	jal	8000563e <panic>

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
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001bdc:	653c                	ld	a5,72(a0)
    80001bde:	02f4f663          	bgeu	s1,a5,80001c0a <fetchaddr+0x42>
    80001be2:	00848713          	addi	a4,s1,8
    80001be6:	02e7e463          	bltu	a5,a4,80001c0e <fetchaddr+0x46>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
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
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
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
void argint(int n, int *ip)
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
void argaddr(int n, uint64 *ip)
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
int argstr(int n, char *buf, int max)
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
    [SYS_unfreeze] sys_unfreeze,
    [SYS_chmod] sys_chmod,
};

void syscall(void)
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
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80001cd0:	37fd                	addiw	a5,a5,-1
    80001cd2:	475d                	li	a4,23
    80001cd4:	00f76f63          	bltu	a4,a5,80001cf2 <syscall+0x40>
    80001cd8:	00369713          	slli	a4,a3,0x3
    80001cdc:	00006797          	auipc	a5,0x6
    80001ce0:	adc78793          	addi	a5,a5,-1316 # 800077b8 <syscalls>
    80001ce4:	97ba                	add	a5,a5,a4
    80001ce6:	639c                	ld	a5,0(a5)
    80001ce8:	c789                	beqz	a5,80001cf2 <syscall+0x40>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cea:	9782                	jalr	a5
    80001cec:	06a93823          	sd	a0,112(s2)
    80001cf0:	a829                	j	80001d0a <syscall+0x58>
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80001cf2:	15848613          	addi	a2,s1,344
    80001cf6:	588c                	lw	a1,48(s1)
    80001cf8:	00005517          	auipc	a0,0x5
    80001cfc:	6b850513          	addi	a0,a0,1720 # 800073b0 <etext+0x3b0>
    80001d00:	62e030ef          	jal	8000532e <printf>
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

extern struct proc proc[NPROC];

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
    80001dde:	37650513          	addi	a0,a0,886 # 80010150 <tickslock>
    80001de2:	39b030ef          	jal	8000597c <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001de6:	fcc42783          	lw	a5,-52(s0)
    80001dea:	c3b9                	beqz	a5,80001e30 <sys_sleep+0x70>
    80001dec:	f426                	sd	s1,40(sp)
    80001dee:	f04a                	sd	s2,32(sp)
    80001df0:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001df2:	00008997          	auipc	s3,0x8
    80001df6:	4f69a983          	lw	s3,1270(s3) # 8000a2e8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dfa:	0000e917          	auipc	s2,0xe
    80001dfe:	35690913          	addi	s2,s2,854 # 80010150 <tickslock>
    80001e02:	00008497          	auipc	s1,0x8
    80001e06:	4e648493          	addi	s1,s1,1254 # 8000a2e8 <ticks>
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
    80001e34:	32050513          	addi	a0,a0,800 # 80010150 <tickslock>
    80001e38:	3d9030ef          	jal	80005a10 <release>
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
    80001e50:	30450513          	addi	a0,a0,772 # 80010150 <tickslock>
    80001e54:	3bd030ef          	jal	80005a10 <release>
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
    80001e92:	2c250513          	addi	a0,a0,706 # 80010150 <tickslock>
    80001e96:	2e7030ef          	jal	8000597c <acquire>
  xticks = ticks;
    80001e9a:	00008797          	auipc	a5,0x8
    80001e9e:	44e7a783          	lw	a5,1102(a5) # 8000a2e8 <ticks>
    80001ea2:	84be                	mv	s1,a5
  release(&tickslock);
    80001ea4:	0000e517          	auipc	a0,0xe
    80001ea8:	2ac50513          	addi	a0,a0,684 # 80010150 <tickslock>
    80001eac:	365030ef          	jal	80005a10 <release>
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
    80001eda:	87a48493          	addi	s1,s1,-1926 # 8000a750 <proc>
    80001ede:	0000e917          	auipc	s2,0xe
    80001ee2:	27290913          	addi	s2,s2,626 # 80010150 <tickslock>
    acquire(&p->lock);
    80001ee6:	8526                	mv	a0,s1
    80001ee8:	295030ef          	jal	8000597c <acquire>
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
    80001ef8:	319030ef          	jal	80005a10 <release>
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
    80001f18:	2f9030ef          	jal	80005a10 <release>
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
    80001f30:	2e1030ef          	jal	80005a10 <release>
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
    80001f52:	80248493          	addi	s1,s1,-2046 # 8000a750 <proc>
    80001f56:	0000e917          	auipc	s2,0xe
    80001f5a:	1fa90913          	addi	s2,s2,506 # 80010150 <tickslock>
    acquire(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	21d030ef          	jal	8000597c <acquire>
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
    80001f70:	2a1030ef          	jal	80005a10 <release>
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
    80001f92:	27f030ef          	jal	80005a10 <release>
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
    80001fac:	265030ef          	jal	80005a10 <release>
      return -1;
    80001fb0:	557d                	li	a0,-1
    80001fb2:	b7dd                	j	80001f98 <sys_unfreeze+0x60>

0000000080001fb4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	e44e                	sd	s3,8(sp)
    80001fc0:	e052                	sd	s4,0(sp)
    80001fc2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fc4:	00005597          	auipc	a1,0x5
    80001fc8:	40c58593          	addi	a1,a1,1036 # 800073d0 <etext+0x3d0>
    80001fcc:	0000e517          	auipc	a0,0xe
    80001fd0:	19c50513          	addi	a0,a0,412 # 80010168 <bcache>
    80001fd4:	11f030ef          	jal	800058f2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fd8:	00016797          	auipc	a5,0x16
    80001fdc:	19078793          	addi	a5,a5,400 # 80018168 <bcache+0x8000>
    80001fe0:	00016717          	auipc	a4,0x16
    80001fe4:	3f070713          	addi	a4,a4,1008 # 800183d0 <bcache+0x8268>
    80001fe8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ff0:	0000e497          	auipc	s1,0xe
    80001ff4:	19048493          	addi	s1,s1,400 # 80010180 <bcache+0x18>
    b->next = bcache.head.next;
    80001ff8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ffa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ffc:	00005a17          	auipc	s4,0x5
    80002000:	3dca0a13          	addi	s4,s4,988 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80002004:	2b893783          	ld	a5,696(s2)
    80002008:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000200a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000200e:	85d2                	mv	a1,s4
    80002010:	01048513          	addi	a0,s1,16
    80002014:	254010ef          	jal	80003268 <initsleeplock>
    bcache.head.next->prev = b;
    80002018:	2b893783          	ld	a5,696(s2)
    8000201c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000201e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002022:	45848493          	addi	s1,s1,1112
    80002026:	fd349fe3          	bne	s1,s3,80002004 <binit+0x50>
  }
}
    8000202a:	70a2                	ld	ra,40(sp)
    8000202c:	7402                	ld	s0,32(sp)
    8000202e:	64e2                	ld	s1,24(sp)
    80002030:	6942                	ld	s2,16(sp)
    80002032:	69a2                	ld	s3,8(sp)
    80002034:	6a02                	ld	s4,0(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret

000000008000203a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	892a                	mv	s2,a0
    8000204a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000204c:	0000e517          	auipc	a0,0xe
    80002050:	11c50513          	addi	a0,a0,284 # 80010168 <bcache>
    80002054:	129030ef          	jal	8000597c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002058:	00016497          	auipc	s1,0x16
    8000205c:	3c84b483          	ld	s1,968(s1) # 80018420 <bcache+0x82b8>
    80002060:	00016797          	auipc	a5,0x16
    80002064:	37078793          	addi	a5,a5,880 # 800183d0 <bcache+0x8268>
    80002068:	02f48b63          	beq	s1,a5,8000209e <bread+0x64>
    8000206c:	873e                	mv	a4,a5
    8000206e:	a021                	j	80002076 <bread+0x3c>
    80002070:	68a4                	ld	s1,80(s1)
    80002072:	02e48663          	beq	s1,a4,8000209e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002076:	449c                	lw	a5,8(s1)
    80002078:	ff279ce3          	bne	a5,s2,80002070 <bread+0x36>
    8000207c:	44dc                	lw	a5,12(s1)
    8000207e:	ff3799e3          	bne	a5,s3,80002070 <bread+0x36>
      b->refcnt++;
    80002082:	40bc                	lw	a5,64(s1)
    80002084:	2785                	addiw	a5,a5,1
    80002086:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002088:	0000e517          	auipc	a0,0xe
    8000208c:	0e050513          	addi	a0,a0,224 # 80010168 <bcache>
    80002090:	181030ef          	jal	80005a10 <release>
      acquiresleep(&b->lock);
    80002094:	01048513          	addi	a0,s1,16
    80002098:	206010ef          	jal	8000329e <acquiresleep>
      return b;
    8000209c:	a889                	j	800020ee <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209e:	00016497          	auipc	s1,0x16
    800020a2:	37a4b483          	ld	s1,890(s1) # 80018418 <bcache+0x82b0>
    800020a6:	00016797          	auipc	a5,0x16
    800020aa:	32a78793          	addi	a5,a5,810 # 800183d0 <bcache+0x8268>
    800020ae:	00f48863          	beq	s1,a5,800020be <bread+0x84>
    800020b2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020b4:	40bc                	lw	a5,64(s1)
    800020b6:	cb91                	beqz	a5,800020ca <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020b8:	64a4                	ld	s1,72(s1)
    800020ba:	fee49de3          	bne	s1,a4,800020b4 <bread+0x7a>
  panic("bget: no buffers");
    800020be:	00005517          	auipc	a0,0x5
    800020c2:	32250513          	addi	a0,a0,802 # 800073e0 <etext+0x3e0>
    800020c6:	578030ef          	jal	8000563e <panic>
      b->dev = dev;
    800020ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020d6:	4785                	li	a5,1
    800020d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020da:	0000e517          	auipc	a0,0xe
    800020de:	08e50513          	addi	a0,a0,142 # 80010168 <bcache>
    800020e2:	12f030ef          	jal	80005a10 <release>
      acquiresleep(&b->lock);
    800020e6:	01048513          	addi	a0,s1,16
    800020ea:	1b4010ef          	jal	8000329e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020ee:	409c                	lw	a5,0(s1)
    800020f0:	cb89                	beqz	a5,80002102 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020f2:	8526                	mv	a0,s1
    800020f4:	70a2                	ld	ra,40(sp)
    800020f6:	7402                	ld	s0,32(sp)
    800020f8:	64e2                	ld	s1,24(sp)
    800020fa:	6942                	ld	s2,16(sp)
    800020fc:	69a2                	ld	s3,8(sp)
    800020fe:	6145                	addi	sp,sp,48
    80002100:	8082                	ret
    virtio_disk_rw(b, 0);
    80002102:	4581                	li	a1,0
    80002104:	8526                	mv	a0,s1
    80002106:	2bb020ef          	jal	80004bc0 <virtio_disk_rw>
    b->valid = 1;
    8000210a:	4785                	li	a5,1
    8000210c:	c09c                	sw	a5,0(s1)
  return b;
    8000210e:	b7d5                	j	800020f2 <bread+0xb8>

0000000080002110 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000211c:	0541                	addi	a0,a0,16
    8000211e:	1fe010ef          	jal	8000331c <holdingsleep>
    80002122:	c911                	beqz	a0,80002136 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002124:	4585                	li	a1,1
    80002126:	8526                	mv	a0,s1
    80002128:	299020ef          	jal	80004bc0 <virtio_disk_rw>
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret
    panic("bwrite");
    80002136:	00005517          	auipc	a0,0x5
    8000213a:	2c250513          	addi	a0,a0,706 # 800073f8 <etext+0x3f8>
    8000213e:	500030ef          	jal	8000563e <panic>

0000000080002142 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	e04a                	sd	s2,0(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002150:	01050913          	addi	s2,a0,16
    80002154:	854a                	mv	a0,s2
    80002156:	1c6010ef          	jal	8000331c <holdingsleep>
    8000215a:	c125                	beqz	a0,800021ba <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000215c:	854a                	mv	a0,s2
    8000215e:	186010ef          	jal	800032e4 <releasesleep>

  acquire(&bcache.lock);
    80002162:	0000e517          	auipc	a0,0xe
    80002166:	00650513          	addi	a0,a0,6 # 80010168 <bcache>
    8000216a:	013030ef          	jal	8000597c <acquire>
  b->refcnt--;
    8000216e:	40bc                	lw	a5,64(s1)
    80002170:	37fd                	addiw	a5,a5,-1
    80002172:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002174:	e79d                	bnez	a5,800021a2 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002176:	68b8                	ld	a4,80(s1)
    80002178:	64bc                	ld	a5,72(s1)
    8000217a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000217c:	68b8                	ld	a4,80(s1)
    8000217e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002180:	00016797          	auipc	a5,0x16
    80002184:	fe878793          	addi	a5,a5,-24 # 80018168 <bcache+0x8000>
    80002188:	2b87b703          	ld	a4,696(a5)
    8000218c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000218e:	00016717          	auipc	a4,0x16
    80002192:	24270713          	addi	a4,a4,578 # 800183d0 <bcache+0x8268>
    80002196:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002198:	2b87b703          	ld	a4,696(a5)
    8000219c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000219e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021a2:	0000e517          	auipc	a0,0xe
    800021a6:	fc650513          	addi	a0,a0,-58 # 80010168 <bcache>
    800021aa:	067030ef          	jal	80005a10 <release>
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	64a2                	ld	s1,8(sp)
    800021b4:	6902                	ld	s2,0(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret
    panic("brelse");
    800021ba:	00005517          	auipc	a0,0x5
    800021be:	24650513          	addi	a0,a0,582 # 80007400 <etext+0x400>
    800021c2:	47c030ef          	jal	8000563e <panic>

00000000800021c6 <bpin>:

void
bpin(struct buf *b) {
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	e426                	sd	s1,8(sp)
    800021ce:	1000                	addi	s0,sp,32
    800021d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021d2:	0000e517          	auipc	a0,0xe
    800021d6:	f9650513          	addi	a0,a0,-106 # 80010168 <bcache>
    800021da:	7a2030ef          	jal	8000597c <acquire>
  b->refcnt++;
    800021de:	40bc                	lw	a5,64(s1)
    800021e0:	2785                	addiw	a5,a5,1
    800021e2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021e4:	0000e517          	auipc	a0,0xe
    800021e8:	f8450513          	addi	a0,a0,-124 # 80010168 <bcache>
    800021ec:	025030ef          	jal	80005a10 <release>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6105                	addi	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <bunpin>:

void
bunpin(struct buf *b) {
    800021fa:	1101                	addi	sp,sp,-32
    800021fc:	ec06                	sd	ra,24(sp)
    800021fe:	e822                	sd	s0,16(sp)
    80002200:	e426                	sd	s1,8(sp)
    80002202:	1000                	addi	s0,sp,32
    80002204:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002206:	0000e517          	auipc	a0,0xe
    8000220a:	f6250513          	addi	a0,a0,-158 # 80010168 <bcache>
    8000220e:	76e030ef          	jal	8000597c <acquire>
  b->refcnt--;
    80002212:	40bc                	lw	a5,64(s1)
    80002214:	37fd                	addiw	a5,a5,-1
    80002216:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002218:	0000e517          	auipc	a0,0xe
    8000221c:	f5050513          	addi	a0,a0,-176 # 80010168 <bcache>
    80002220:	7f0030ef          	jal	80005a10 <release>
}
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	64a2                	ld	s1,8(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000222e:	1101                	addi	sp,sp,-32
    80002230:	ec06                	sd	ra,24(sp)
    80002232:	e822                	sd	s0,16(sp)
    80002234:	e426                	sd	s1,8(sp)
    80002236:	e04a                	sd	s2,0(sp)
    80002238:	1000                	addi	s0,sp,32
    8000223a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000223c:	00d5d79b          	srliw	a5,a1,0xd
    80002240:	00016597          	auipc	a1,0x16
    80002244:	6045a583          	lw	a1,1540(a1) # 80018844 <sb+0x1c>
    80002248:	9dbd                	addw	a1,a1,a5
    8000224a:	df1ff0ef          	jal	8000203a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000224e:	0074f713          	andi	a4,s1,7
    80002252:	4785                	li	a5,1
    80002254:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002258:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    8000225a:	90d9                	srli	s1,s1,0x36
    8000225c:	00950733          	add	a4,a0,s1
    80002260:	05874703          	lbu	a4,88(a4)
    80002264:	00e7f6b3          	and	a3,a5,a4
    80002268:	c29d                	beqz	a3,8000228e <bfree+0x60>
    8000226a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    8000226c:	94aa                	add	s1,s1,a0
    8000226e:	fff7c793          	not	a5,a5
    80002272:	8f7d                	and	a4,a4,a5
    80002274:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002278:	71f000ef          	jal	80003196 <log_write>
  brelse(bp);
    8000227c:	854a                	mv	a0,s2
    8000227e:	ec5ff0ef          	jal	80002142 <brelse>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6902                	ld	s2,0(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret
    panic("freeing free block");
    8000228e:	00005517          	auipc	a0,0x5
    80002292:	17a50513          	addi	a0,a0,378 # 80007408 <etext+0x408>
    80002296:	3a8030ef          	jal	8000563e <panic>

000000008000229a <balloc>:
{
    8000229a:	715d                	addi	sp,sp,-80
    8000229c:	e486                	sd	ra,72(sp)
    8000229e:	e0a2                	sd	s0,64(sp)
    800022a0:	fc26                	sd	s1,56(sp)
    800022a2:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB)
    800022a4:	00016797          	auipc	a5,0x16
    800022a8:	5887a783          	lw	a5,1416(a5) # 8001882c <sb+0x4>
    800022ac:	0e078263          	beqz	a5,80002390 <balloc+0xf6>
    800022b0:	f84a                	sd	s2,48(sp)
    800022b2:	f44e                	sd	s3,40(sp)
    800022b4:	f052                	sd	s4,32(sp)
    800022b6:	ec56                	sd	s5,24(sp)
    800022b8:	e85a                	sd	s6,16(sp)
    800022ba:	e45e                	sd	s7,8(sp)
    800022bc:	e062                	sd	s8,0(sp)
    800022be:	8baa                	mv	s7,a0
    800022c0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022c2:	00016b17          	auipc	s6,0x16
    800022c6:	566b0b13          	addi	s6,s6,1382 # 80018828 <sb>
      m = 1 << (bi % 8);
    800022ca:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800022cc:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB)
    800022ce:	6c09                	lui	s8,0x2
    800022d0:	a09d                	j	80002336 <balloc+0x9c>
        bp->data[bi / 8] |= m; // Mark block in use.
    800022d2:	97ca                	add	a5,a5,s2
    800022d4:	8e55                	or	a2,a2,a3
    800022d6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022da:	854a                	mv	a0,s2
    800022dc:	6bb000ef          	jal	80003196 <log_write>
        brelse(bp);
    800022e0:	854a                	mv	a0,s2
    800022e2:	e61ff0ef          	jal	80002142 <brelse>
  bp = bread(dev, bno);
    800022e6:	85a6                	mv	a1,s1
    800022e8:	855e                	mv	a0,s7
    800022ea:	d51ff0ef          	jal	8000203a <bread>
    800022ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022f0:	40000613          	li	a2,1024
    800022f4:	4581                	li	a1,0
    800022f6:	05850513          	addi	a0,a0,88
    800022fa:	e65fd0ef          	jal	8000015e <memset>
  log_write(bp);
    800022fe:	854a                	mv	a0,s2
    80002300:	697000ef          	jal	80003196 <log_write>
  brelse(bp);
    80002304:	854a                	mv	a0,s2
    80002306:	e3dff0ef          	jal	80002142 <brelse>
}
    8000230a:	7942                	ld	s2,48(sp)
    8000230c:	79a2                	ld	s3,40(sp)
    8000230e:	7a02                	ld	s4,32(sp)
    80002310:	6ae2                	ld	s5,24(sp)
    80002312:	6b42                	ld	s6,16(sp)
    80002314:	6ba2                	ld	s7,8(sp)
    80002316:	6c02                	ld	s8,0(sp)
}
    80002318:	8526                	mv	a0,s1
    8000231a:	60a6                	ld	ra,72(sp)
    8000231c:	6406                	ld	s0,64(sp)
    8000231e:	74e2                	ld	s1,56(sp)
    80002320:	6161                	addi	sp,sp,80
    80002322:	8082                	ret
    brelse(bp);
    80002324:	854a                	mv	a0,s2
    80002326:	e1dff0ef          	jal	80002142 <brelse>
  for (b = 0; b < sb.size; b += BPB)
    8000232a:	015c0abb          	addw	s5,s8,s5
    8000232e:	004b2783          	lw	a5,4(s6)
    80002332:	04faf863          	bgeu	s5,a5,80002382 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002336:	40dad59b          	sraiw	a1,s5,0xd
    8000233a:	01cb2783          	lw	a5,28(s6)
    8000233e:	9dbd                	addw	a1,a1,a5
    80002340:	855e                	mv	a0,s7
    80002342:	cf9ff0ef          	jal	8000203a <bread>
    80002346:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002348:	004b2503          	lw	a0,4(s6)
    8000234c:	84d6                	mv	s1,s5
    8000234e:	4701                	li	a4,0
    80002350:	fca4fae3          	bgeu	s1,a0,80002324 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002354:	00777693          	andi	a3,a4,7
    80002358:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0)
    8000235c:	41f7579b          	sraiw	a5,a4,0x1f
    80002360:	01d7d79b          	srliw	a5,a5,0x1d
    80002364:	9fb9                	addw	a5,a5,a4
    80002366:	4037d79b          	sraiw	a5,a5,0x3
    8000236a:	00f90633          	add	a2,s2,a5
    8000236e:	05864603          	lbu	a2,88(a2)
    80002372:	00c6f5b3          	and	a1,a3,a2
    80002376:	ddb1                	beqz	a1,800022d2 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002378:	2705                	addiw	a4,a4,1
    8000237a:	2485                	addiw	s1,s1,1
    8000237c:	fd471ae3          	bne	a4,s4,80002350 <balloc+0xb6>
    80002380:	b755                	j	80002324 <balloc+0x8a>
    80002382:	7942                	ld	s2,48(sp)
    80002384:	79a2                	ld	s3,40(sp)
    80002386:	7a02                	ld	s4,32(sp)
    80002388:	6ae2                	ld	s5,24(sp)
    8000238a:	6b42                	ld	s6,16(sp)
    8000238c:	6ba2                	ld	s7,8(sp)
    8000238e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002390:	00005517          	auipc	a0,0x5
    80002394:	09050513          	addi	a0,a0,144 # 80007420 <etext+0x420>
    80002398:	797020ef          	jal	8000532e <printf>
  return 0;
    8000239c:	4481                	li	s1,0
    8000239e:	bfad                	j	80002318 <balloc+0x7e>

00000000800023a0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023a0:	7179                	addi	sp,sp,-48
    800023a2:	f406                	sd	ra,40(sp)
    800023a4:	f022                	sd	s0,32(sp)
    800023a6:	ec26                	sd	s1,24(sp)
    800023a8:	e84a                	sd	s2,16(sp)
    800023aa:	e44e                	sd	s3,8(sp)
    800023ac:	1800                	addi	s0,sp,48
    800023ae:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT)
    800023b0:	47ad                	li	a5,11
    800023b2:	02b7e363          	bltu	a5,a1,800023d8 <bmap+0x38>
  {
    if ((addr = ip->addrs[bn]) == 0)
    800023b6:	02059793          	slli	a5,a1,0x20
    800023ba:	01e7d593          	srli	a1,a5,0x1e
    800023be:	00b509b3          	add	s3,a0,a1
    800023c2:	0509a483          	lw	s1,80(s3)
    800023c6:	e0b5                	bnez	s1,8000242a <bmap+0x8a>
    {
      addr = balloc(ip->dev);
    800023c8:	4108                	lw	a0,0(a0)
    800023ca:	ed1ff0ef          	jal	8000229a <balloc>
    800023ce:	84aa                	mv	s1,a0
      if (addr == 0)
    800023d0:	cd29                	beqz	a0,8000242a <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800023d2:	04a9a823          	sw	a0,80(s3)
    800023d6:	a891                	j	8000242a <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023d8:	ff45879b          	addiw	a5,a1,-12
    800023dc:	873e                	mv	a4,a5
    800023de:	89be                	mv	s3,a5

  if (bn < NINDIRECT)
    800023e0:	0ff00793          	li	a5,255
    800023e4:	06e7e763          	bltu	a5,a4,80002452 <bmap+0xb2>
  {
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
    800023e8:	08052483          	lw	s1,128(a0)
    800023ec:	e891                	bnez	s1,80002400 <bmap+0x60>
    {
      addr = balloc(ip->dev);
    800023ee:	4108                	lw	a0,0(a0)
    800023f0:	eabff0ef          	jal	8000229a <balloc>
    800023f4:	84aa                	mv	s1,a0
      if (addr == 0)
    800023f6:	c915                	beqz	a0,8000242a <bmap+0x8a>
    800023f8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023fa:	08a92023          	sw	a0,128(s2)
    800023fe:	a011                	j	80002402 <bmap+0x62>
    80002400:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002402:	85a6                	mv	a1,s1
    80002404:	00092503          	lw	a0,0(s2)
    80002408:	c33ff0ef          	jal	8000203a <bread>
    8000240c:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000240e:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0)
    80002412:	02099713          	slli	a4,s3,0x20
    80002416:	01e75593          	srli	a1,a4,0x1e
    8000241a:	97ae                	add	a5,a5,a1
    8000241c:	89be                	mv	s3,a5
    8000241e:	4384                	lw	s1,0(a5)
    80002420:	cc89                	beqz	s1,8000243a <bmap+0x9a>
      {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002422:	8552                	mv	a0,s4
    80002424:	d1fff0ef          	jal	80002142 <brelse>
    return addr;
    80002428:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000242a:	8526                	mv	a0,s1
    8000242c:	70a2                	ld	ra,40(sp)
    8000242e:	7402                	ld	s0,32(sp)
    80002430:	64e2                	ld	s1,24(sp)
    80002432:	6942                	ld	s2,16(sp)
    80002434:	69a2                	ld	s3,8(sp)
    80002436:	6145                	addi	sp,sp,48
    80002438:	8082                	ret
      addr = balloc(ip->dev);
    8000243a:	00092503          	lw	a0,0(s2)
    8000243e:	e5dff0ef          	jal	8000229a <balloc>
    80002442:	84aa                	mv	s1,a0
      if (addr)
    80002444:	dd79                	beqz	a0,80002422 <bmap+0x82>
        a[bn] = addr;
    80002446:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000244a:	8552                	mv	a0,s4
    8000244c:	54b000ef          	jal	80003196 <log_write>
    80002450:	bfc9                	j	80002422 <bmap+0x82>
    80002452:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002454:	00005517          	auipc	a0,0x5
    80002458:	fe450513          	addi	a0,a0,-28 # 80007438 <etext+0x438>
    8000245c:	1e2030ef          	jal	8000563e <panic>

0000000080002460 <iget>:
{
    80002460:	7179                	addi	sp,sp,-48
    80002462:	f406                	sd	ra,40(sp)
    80002464:	f022                	sd	s0,32(sp)
    80002466:	ec26                	sd	s1,24(sp)
    80002468:	e84a                	sd	s2,16(sp)
    8000246a:	e44e                	sd	s3,8(sp)
    8000246c:	e052                	sd	s4,0(sp)
    8000246e:	1800                	addi	s0,sp,48
    80002470:	892a                	mv	s2,a0
    80002472:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002474:	00016517          	auipc	a0,0x16
    80002478:	3d450513          	addi	a0,a0,980 # 80018848 <itable>
    8000247c:	500030ef          	jal	8000597c <acquire>
  empty = 0;
    80002480:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002482:	00016497          	auipc	s1,0x16
    80002486:	3de48493          	addi	s1,s1,990 # 80018860 <itable+0x18>
    8000248a:	00018697          	auipc	a3,0x18
    8000248e:	e6668693          	addi	a3,a3,-410 # 8001a2f0 <log>
    80002492:	a809                	j	800024a4 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002494:	e781                	bnez	a5,8000249c <iget+0x3c>
    80002496:	00099363          	bnez	s3,8000249c <iget+0x3c>
      empty = ip;
    8000249a:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000249c:	08848493          	addi	s1,s1,136
    800024a0:	02d48563          	beq	s1,a3,800024ca <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    800024a4:	449c                	lw	a5,8(s1)
    800024a6:	fef057e3          	blez	a5,80002494 <iget+0x34>
    800024aa:	4098                	lw	a4,0(s1)
    800024ac:	ff2718e3          	bne	a4,s2,8000249c <iget+0x3c>
    800024b0:	40d8                	lw	a4,4(s1)
    800024b2:	ff4715e3          	bne	a4,s4,8000249c <iget+0x3c>
      ip->ref++;
    800024b6:	2785                	addiw	a5,a5,1
    800024b8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024ba:	00016517          	auipc	a0,0x16
    800024be:	38e50513          	addi	a0,a0,910 # 80018848 <itable>
    800024c2:	54e030ef          	jal	80005a10 <release>
      return ip;
    800024c6:	89a6                	mv	s3,s1
    800024c8:	a015                	j	800024ec <iget+0x8c>
  if (empty == 0)
    800024ca:	02098a63          	beqz	s3,800024fe <iget+0x9e>
  ip->dev = dev;
    800024ce:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800024d2:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800024d6:	4785                	li	a5,1
    800024d8:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800024dc:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800024e0:	00016517          	auipc	a0,0x16
    800024e4:	36850513          	addi	a0,a0,872 # 80018848 <itable>
    800024e8:	528030ef          	jal	80005a10 <release>
}
    800024ec:	854e                	mv	a0,s3
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6a02                	ld	s4,0(sp)
    800024fa:	6145                	addi	sp,sp,48
    800024fc:	8082                	ret
    panic("iget: no inodes");
    800024fe:	00005517          	auipc	a0,0x5
    80002502:	f5250513          	addi	a0,a0,-174 # 80007450 <etext+0x450>
    80002506:	138030ef          	jal	8000563e <panic>

000000008000250a <fsinit>:
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	addi	s0,sp,32
    80002516:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002518:	4585                	li	a1,1
    8000251a:	b21ff0ef          	jal	8000203a <bread>
    8000251e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002520:	02000613          	li	a2,32
    80002524:	05850593          	addi	a1,a0,88
    80002528:	00016517          	auipc	a0,0x16
    8000252c:	30050513          	addi	a0,a0,768 # 80018828 <sb>
    80002530:	c8ffd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002534:	8526                	mv	a0,s1
    80002536:	c0dff0ef          	jal	80002142 <brelse>
  if (sb.magic != FSMAGIC)
    8000253a:	00016717          	auipc	a4,0x16
    8000253e:	2ee72703          	lw	a4,750(a4) # 80018828 <sb>
    80002542:	102037b7          	lui	a5,0x10203
    80002546:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000254a:	00f71f63          	bne	a4,a5,80002568 <fsinit+0x5e>
  initlog(dev, &sb);
    8000254e:	00016597          	auipc	a1,0x16
    80002552:	2da58593          	addi	a1,a1,730 # 80018828 <sb>
    80002556:	854a                	mv	a0,s2
    80002558:	221000ef          	jal	80002f78 <initlog>
}
    8000255c:	60e2                	ld	ra,24(sp)
    8000255e:	6442                	ld	s0,16(sp)
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	6902                	ld	s2,0(sp)
    80002564:	6105                	addi	sp,sp,32
    80002566:	8082                	ret
    panic("invalid file system");
    80002568:	00005517          	auipc	a0,0x5
    8000256c:	ef850513          	addi	a0,a0,-264 # 80007460 <etext+0x460>
    80002570:	0ce030ef          	jal	8000563e <panic>

0000000080002574 <iinit>:
{
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002582:	00005597          	auipc	a1,0x5
    80002586:	ef658593          	addi	a1,a1,-266 # 80007478 <etext+0x478>
    8000258a:	00016517          	auipc	a0,0x16
    8000258e:	2be50513          	addi	a0,a0,702 # 80018848 <itable>
    80002592:	360030ef          	jal	800058f2 <initlock>
  for (i = 0; i < NINODE; i++)
    80002596:	00016497          	auipc	s1,0x16
    8000259a:	2da48493          	addi	s1,s1,730 # 80018870 <itable+0x28>
    8000259e:	00018997          	auipc	s3,0x18
    800025a2:	d6298993          	addi	s3,s3,-670 # 8001a300 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025a6:	00005917          	auipc	s2,0x5
    800025aa:	eda90913          	addi	s2,s2,-294 # 80007480 <etext+0x480>
    800025ae:	85ca                	mv	a1,s2
    800025b0:	8526                	mv	a0,s1
    800025b2:	4b7000ef          	jal	80003268 <initsleeplock>
  for (i = 0; i < NINODE; i++)
    800025b6:	08848493          	addi	s1,s1,136
    800025ba:	ff349ae3          	bne	s1,s3,800025ae <iinit+0x3a>
}
    800025be:	70a2                	ld	ra,40(sp)
    800025c0:	7402                	ld	s0,32(sp)
    800025c2:	64e2                	ld	s1,24(sp)
    800025c4:	6942                	ld	s2,16(sp)
    800025c6:	69a2                	ld	s3,8(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret

00000000800025cc <ialloc>:
{
    800025cc:	7139                	addi	sp,sp,-64
    800025ce:	fc06                	sd	ra,56(sp)
    800025d0:	f822                	sd	s0,48(sp)
    800025d2:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++)
    800025d4:	00016717          	auipc	a4,0x16
    800025d8:	26072703          	lw	a4,608(a4) # 80018834 <sb+0xc>
    800025dc:	4785                	li	a5,1
    800025de:	06e7f063          	bgeu	a5,a4,8000263e <ialloc+0x72>
    800025e2:	f426                	sd	s1,40(sp)
    800025e4:	f04a                	sd	s2,32(sp)
    800025e6:	ec4e                	sd	s3,24(sp)
    800025e8:	e852                	sd	s4,16(sp)
    800025ea:	e456                	sd	s5,8(sp)
    800025ec:	e05a                	sd	s6,0(sp)
    800025ee:	8aaa                	mv	s5,a0
    800025f0:	8b2e                	mv	s6,a1
    800025f2:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025f4:	00016a17          	auipc	s4,0x16
    800025f8:	234a0a13          	addi	s4,s4,564 # 80018828 <sb>
    800025fc:	00495593          	srli	a1,s2,0x4
    80002600:	018a2783          	lw	a5,24(s4)
    80002604:	9dbd                	addw	a1,a1,a5
    80002606:	8556                	mv	a0,s5
    80002608:	a33ff0ef          	jal	8000203a <bread>
    8000260c:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000260e:	05850993          	addi	s3,a0,88
    80002612:	00f97793          	andi	a5,s2,15
    80002616:	079a                	slli	a5,a5,0x6
    80002618:	99be                	add	s3,s3,a5
    if (dip->type == 0)
    8000261a:	00099783          	lh	a5,0(s3)
    8000261e:	cb9d                	beqz	a5,80002654 <ialloc+0x88>
    brelse(bp);
    80002620:	b23ff0ef          	jal	80002142 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
    80002624:	0905                	addi	s2,s2,1
    80002626:	00ca2703          	lw	a4,12(s4)
    8000262a:	0009079b          	sext.w	a5,s2
    8000262e:	fce7e7e3          	bltu	a5,a4,800025fc <ialloc+0x30>
    80002632:	74a2                	ld	s1,40(sp)
    80002634:	7902                	ld	s2,32(sp)
    80002636:	69e2                	ld	s3,24(sp)
    80002638:	6a42                	ld	s4,16(sp)
    8000263a:	6aa2                	ld	s5,8(sp)
    8000263c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000263e:	00005517          	auipc	a0,0x5
    80002642:	e4a50513          	addi	a0,a0,-438 # 80007488 <etext+0x488>
    80002646:	4e9020ef          	jal	8000532e <printf>
  return 0;
    8000264a:	4501                	li	a0,0
}
    8000264c:	70e2                	ld	ra,56(sp)
    8000264e:	7442                	ld	s0,48(sp)
    80002650:	6121                	addi	sp,sp,64
    80002652:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002654:	04000613          	li	a2,64
    80002658:	4581                	li	a1,0
    8000265a:	854e                	mv	a0,s3
    8000265c:	b03fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002660:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80002664:	8526                	mv	a0,s1
    80002666:	331000ef          	jal	80003196 <log_write>
      brelse(bp);
    8000266a:	8526                	mv	a0,s1
    8000266c:	ad7ff0ef          	jal	80002142 <brelse>
      return iget(dev, inum);
    80002670:	0009059b          	sext.w	a1,s2
    80002674:	8556                	mv	a0,s5
    80002676:	debff0ef          	jal	80002460 <iget>
    8000267a:	74a2                	ld	s1,40(sp)
    8000267c:	7902                	ld	s2,32(sp)
    8000267e:	69e2                	ld	s3,24(sp)
    80002680:	6a42                	ld	s4,16(sp)
    80002682:	6aa2                	ld	s5,8(sp)
    80002684:	6b02                	ld	s6,0(sp)
    80002686:	b7d9                	j	8000264c <ialloc+0x80>

0000000080002688 <iupdate>:
{
    80002688:	1101                	addi	sp,sp,-32
    8000268a:	ec06                	sd	ra,24(sp)
    8000268c:	e822                	sd	s0,16(sp)
    8000268e:	e426                	sd	s1,8(sp)
    80002690:	e04a                	sd	s2,0(sp)
    80002692:	1000                	addi	s0,sp,32
    80002694:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002696:	415c                	lw	a5,4(a0)
    80002698:	0047d79b          	srliw	a5,a5,0x4
    8000269c:	00016597          	auipc	a1,0x16
    800026a0:	1a45a583          	lw	a1,420(a1) # 80018840 <sb+0x18>
    800026a4:	9dbd                	addw	a1,a1,a5
    800026a6:	4108                	lw	a0,0(a0)
    800026a8:	993ff0ef          	jal	8000203a <bread>
    800026ac:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800026ae:	05850793          	addi	a5,a0,88
    800026b2:	40d8                	lw	a4,4(s1)
    800026b4:	8b3d                	andi	a4,a4,15
    800026b6:	071a                	slli	a4,a4,0x6
    800026b8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026ba:	04449703          	lh	a4,68(s1)
    800026be:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026c2:	04649703          	lh	a4,70(s1)
    800026c6:	00e79123          	sh	a4,2(a5)
  dip->nlink = ip->nlink;
    800026ca:	04a49703          	lh	a4,74(s1)
    800026ce:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026d2:	44f8                	lw	a4,76(s1)
    800026d4:	c798                	sw	a4,8(a5)
  dip->mode = ip->mode;
    800026d6:	04849703          	lh	a4,72(s1)
    800026da:	00e79223          	sh	a4,4(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026de:	03400613          	li	a2,52
    800026e2:	05048593          	addi	a1,s1,80
    800026e6:	00c78513          	addi	a0,a5,12
    800026ea:	ad5fd0ef          	jal	800001be <memmove>
  log_write(bp);
    800026ee:	854a                	mv	a0,s2
    800026f0:	2a7000ef          	jal	80003196 <log_write>
  brelse(bp);
    800026f4:	854a                	mv	a0,s2
    800026f6:	a4dff0ef          	jal	80002142 <brelse>
}
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6902                	ld	s2,0(sp)
    80002702:	6105                	addi	sp,sp,32
    80002704:	8082                	ret

0000000080002706 <idup>:
{
    80002706:	1101                	addi	sp,sp,-32
    80002708:	ec06                	sd	ra,24(sp)
    8000270a:	e822                	sd	s0,16(sp)
    8000270c:	e426                	sd	s1,8(sp)
    8000270e:	1000                	addi	s0,sp,32
    80002710:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002712:	00016517          	auipc	a0,0x16
    80002716:	13650513          	addi	a0,a0,310 # 80018848 <itable>
    8000271a:	262030ef          	jal	8000597c <acquire>
  ip->ref++;
    8000271e:	449c                	lw	a5,8(s1)
    80002720:	2785                	addiw	a5,a5,1
    80002722:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002724:	00016517          	auipc	a0,0x16
    80002728:	12450513          	addi	a0,a0,292 # 80018848 <itable>
    8000272c:	2e4030ef          	jal	80005a10 <release>
}
    80002730:	8526                	mv	a0,s1
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6105                	addi	sp,sp,32
    8000273a:	8082                	ret

000000008000273c <ilock>:
{
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80002746:	cd19                	beqz	a0,80002764 <ilock+0x28>
    80002748:	84aa                	mv	s1,a0
    8000274a:	451c                	lw	a5,8(a0)
    8000274c:	00f05c63          	blez	a5,80002764 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002750:	0541                	addi	a0,a0,16
    80002752:	34d000ef          	jal	8000329e <acquiresleep>
  if (ip->valid == 0)
    80002756:	40bc                	lw	a5,64(s1)
    80002758:	cf89                	beqz	a5,80002772 <ilock+0x36>
}
    8000275a:	60e2                	ld	ra,24(sp)
    8000275c:	6442                	ld	s0,16(sp)
    8000275e:	64a2                	ld	s1,8(sp)
    80002760:	6105                	addi	sp,sp,32
    80002762:	8082                	ret
    80002764:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002766:	00005517          	auipc	a0,0x5
    8000276a:	d3a50513          	addi	a0,a0,-710 # 800074a0 <etext+0x4a0>
    8000276e:	6d1020ef          	jal	8000563e <panic>
    80002772:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002774:	40dc                	lw	a5,4(s1)
    80002776:	0047d79b          	srliw	a5,a5,0x4
    8000277a:	00016597          	auipc	a1,0x16
    8000277e:	0c65a583          	lw	a1,198(a1) # 80018840 <sb+0x18>
    80002782:	9dbd                	addw	a1,a1,a5
    80002784:	4088                	lw	a0,0(s1)
    80002786:	8b5ff0ef          	jal	8000203a <bread>
    8000278a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000278c:	05850593          	addi	a1,a0,88
    80002790:	40dc                	lw	a5,4(s1)
    80002792:	8bbd                	andi	a5,a5,15
    80002794:	079a                	slli	a5,a5,0x6
    80002796:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002798:	00059783          	lh	a5,0(a1)
    8000279c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027a0:	00259783          	lh	a5,2(a1)
    800027a4:	04f49323          	sh	a5,70(s1)
    ip->nlink = dip->nlink;
    800027a8:	00659783          	lh	a5,6(a1)
    800027ac:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027b0:	459c                	lw	a5,8(a1)
    800027b2:	c4fc                	sw	a5,76(s1)
    ip->mode = dip->mode;
    800027b4:	00459783          	lh	a5,4(a1)
    800027b8:	04f49423          	sh	a5,72(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027bc:	03400613          	li	a2,52
    800027c0:	05b1                	addi	a1,a1,12
    800027c2:	05048513          	addi	a0,s1,80
    800027c6:	9f9fd0ef          	jal	800001be <memmove>
    brelse(bp);
    800027ca:	854a                	mv	a0,s2
    800027cc:	977ff0ef          	jal	80002142 <brelse>
    ip->valid = 1;
    800027d0:	4785                	li	a5,1
    800027d2:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800027d4:	04449783          	lh	a5,68(s1)
    800027d8:	c399                	beqz	a5,800027de <ilock+0xa2>
    800027da:	6902                	ld	s2,0(sp)
    800027dc:	bfbd                	j	8000275a <ilock+0x1e>
      panic("ilock: no type");
    800027de:	00005517          	auipc	a0,0x5
    800027e2:	cca50513          	addi	a0,a0,-822 # 800074a8 <etext+0x4a8>
    800027e6:	659020ef          	jal	8000563e <panic>

00000000800027ea <iunlock>:
{
    800027ea:	1101                	addi	sp,sp,-32
    800027ec:	ec06                	sd	ra,24(sp)
    800027ee:	e822                	sd	s0,16(sp)
    800027f0:	e426                	sd	s1,8(sp)
    800027f2:	e04a                	sd	s2,0(sp)
    800027f4:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027f6:	c505                	beqz	a0,8000281e <iunlock+0x34>
    800027f8:	84aa                	mv	s1,a0
    800027fa:	01050913          	addi	s2,a0,16
    800027fe:	854a                	mv	a0,s2
    80002800:	31d000ef          	jal	8000331c <holdingsleep>
    80002804:	cd09                	beqz	a0,8000281e <iunlock+0x34>
    80002806:	449c                	lw	a5,8(s1)
    80002808:	00f05b63          	blez	a5,8000281e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000280c:	854a                	mv	a0,s2
    8000280e:	2d7000ef          	jal	800032e4 <releasesleep>
}
    80002812:	60e2                	ld	ra,24(sp)
    80002814:	6442                	ld	s0,16(sp)
    80002816:	64a2                	ld	s1,8(sp)
    80002818:	6902                	ld	s2,0(sp)
    8000281a:	6105                	addi	sp,sp,32
    8000281c:	8082                	ret
    panic("iunlock");
    8000281e:	00005517          	auipc	a0,0x5
    80002822:	c9a50513          	addi	a0,a0,-870 # 800074b8 <etext+0x4b8>
    80002826:	619020ef          	jal	8000563e <panic>

000000008000282a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    8000282a:	7179                	addi	sp,sp,-48
    8000282c:	f406                	sd	ra,40(sp)
    8000282e:	f022                	sd	s0,32(sp)
    80002830:	ec26                	sd	s1,24(sp)
    80002832:	e84a                	sd	s2,16(sp)
    80002834:	e44e                	sd	s3,8(sp)
    80002836:	1800                	addi	s0,sp,48
    80002838:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++)
    8000283a:	05050493          	addi	s1,a0,80
    8000283e:	08050913          	addi	s2,a0,128
    80002842:	a021                	j	8000284a <itrunc+0x20>
    80002844:	0491                	addi	s1,s1,4
    80002846:	01248b63          	beq	s1,s2,8000285c <itrunc+0x32>
  {
    if (ip->addrs[i])
    8000284a:	408c                	lw	a1,0(s1)
    8000284c:	dde5                	beqz	a1,80002844 <itrunc+0x1a>
    {
      bfree(ip->dev, ip->addrs[i]);
    8000284e:	0009a503          	lw	a0,0(s3)
    80002852:	9ddff0ef          	jal	8000222e <bfree>
      ip->addrs[i] = 0;
    80002856:	0004a023          	sw	zero,0(s1)
    8000285a:	b7ed                	j	80002844 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT])
    8000285c:	0809a583          	lw	a1,128(s3)
    80002860:	ed89                	bnez	a1,8000287a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002862:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002866:	854e                	mv	a0,s3
    80002868:	e21ff0ef          	jal	80002688 <iupdate>
}
    8000286c:	70a2                	ld	ra,40(sp)
    8000286e:	7402                	ld	s0,32(sp)
    80002870:	64e2                	ld	s1,24(sp)
    80002872:	6942                	ld	s2,16(sp)
    80002874:	69a2                	ld	s3,8(sp)
    80002876:	6145                	addi	sp,sp,48
    80002878:	8082                	ret
    8000287a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000287c:	0009a503          	lw	a0,0(s3)
    80002880:	fbaff0ef          	jal	8000203a <bread>
    80002884:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++)
    80002886:	05850493          	addi	s1,a0,88
    8000288a:	45850913          	addi	s2,a0,1112
    8000288e:	a021                	j	80002896 <itrunc+0x6c>
    80002890:	0491                	addi	s1,s1,4
    80002892:	01248963          	beq	s1,s2,800028a4 <itrunc+0x7a>
      if (a[j])
    80002896:	408c                	lw	a1,0(s1)
    80002898:	dde5                	beqz	a1,80002890 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000289a:	0009a503          	lw	a0,0(s3)
    8000289e:	991ff0ef          	jal	8000222e <bfree>
    800028a2:	b7fd                	j	80002890 <itrunc+0x66>
    brelse(bp);
    800028a4:	8552                	mv	a0,s4
    800028a6:	89dff0ef          	jal	80002142 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028aa:	0809a583          	lw	a1,128(s3)
    800028ae:	0009a503          	lw	a0,0(s3)
    800028b2:	97dff0ef          	jal	8000222e <bfree>
    ip->addrs[NDIRECT] = 0;
    800028b6:	0809a023          	sw	zero,128(s3)
    800028ba:	6a02                	ld	s4,0(sp)
    800028bc:	b75d                	j	80002862 <itrunc+0x38>

00000000800028be <iput>:
{
    800028be:	1101                	addi	sp,sp,-32
    800028c0:	ec06                	sd	ra,24(sp)
    800028c2:	e822                	sd	s0,16(sp)
    800028c4:	e426                	sd	s1,8(sp)
    800028c6:	1000                	addi	s0,sp,32
    800028c8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028ca:	00016517          	auipc	a0,0x16
    800028ce:	f7e50513          	addi	a0,a0,-130 # 80018848 <itable>
    800028d2:	0aa030ef          	jal	8000597c <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    800028d6:	4498                	lw	a4,8(s1)
    800028d8:	4785                	li	a5,1
    800028da:	02f70063          	beq	a4,a5,800028fa <iput+0x3c>
  ip->ref--;
    800028de:	449c                	lw	a5,8(s1)
    800028e0:	37fd                	addiw	a5,a5,-1
    800028e2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028e4:	00016517          	auipc	a0,0x16
    800028e8:	f6450513          	addi	a0,a0,-156 # 80018848 <itable>
    800028ec:	124030ef          	jal	80005a10 <release>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6105                	addi	sp,sp,32
    800028f8:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    800028fa:	40bc                	lw	a5,64(s1)
    800028fc:	d3ed                	beqz	a5,800028de <iput+0x20>
    800028fe:	04a49783          	lh	a5,74(s1)
    80002902:	fff1                	bnez	a5,800028de <iput+0x20>
    80002904:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002906:	01048793          	addi	a5,s1,16
    8000290a:	893e                	mv	s2,a5
    8000290c:	853e                	mv	a0,a5
    8000290e:	191000ef          	jal	8000329e <acquiresleep>
    release(&itable.lock);
    80002912:	00016517          	auipc	a0,0x16
    80002916:	f3650513          	addi	a0,a0,-202 # 80018848 <itable>
    8000291a:	0f6030ef          	jal	80005a10 <release>
    itrunc(ip);
    8000291e:	8526                	mv	a0,s1
    80002920:	f0bff0ef          	jal	8000282a <itrunc>
    ip->type = 0;
    80002924:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002928:	8526                	mv	a0,s1
    8000292a:	d5fff0ef          	jal	80002688 <iupdate>
    ip->valid = 0;
    8000292e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002932:	854a                	mv	a0,s2
    80002934:	1b1000ef          	jal	800032e4 <releasesleep>
    acquire(&itable.lock);
    80002938:	00016517          	auipc	a0,0x16
    8000293c:	f1050513          	addi	a0,a0,-240 # 80018848 <itable>
    80002940:	03c030ef          	jal	8000597c <acquire>
    80002944:	6902                	ld	s2,0(sp)
    80002946:	bf61                	j	800028de <iput+0x20>

0000000080002948 <iunlockput>:
{
    80002948:	1101                	addi	sp,sp,-32
    8000294a:	ec06                	sd	ra,24(sp)
    8000294c:	e822                	sd	s0,16(sp)
    8000294e:	e426                	sd	s1,8(sp)
    80002950:	1000                	addi	s0,sp,32
    80002952:	84aa                	mv	s1,a0
  iunlock(ip);
    80002954:	e97ff0ef          	jal	800027ea <iunlock>
  iput(ip);
    80002958:	8526                	mv	a0,s1
    8000295a:	f65ff0ef          	jal	800028be <iput>
}
    8000295e:	60e2                	ld	ra,24(sp)
    80002960:	6442                	ld	s0,16(sp)
    80002962:	64a2                	ld	s1,8(sp)
    80002964:	6105                	addi	sp,sp,32
    80002966:	8082                	ret

0000000080002968 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002968:	1141                	addi	sp,sp,-16
    8000296a:	e406                	sd	ra,8(sp)
    8000296c:	e022                	sd	s0,0(sp)
    8000296e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002970:	411c                	lw	a5,0(a0)
    80002972:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002974:	415c                	lw	a5,4(a0)
    80002976:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002978:	04451783          	lh	a5,68(a0)
    8000297c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002980:	04a51783          	lh	a5,74(a0)
    80002984:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002988:	04c56783          	lwu	a5,76(a0)
    8000298c:	e99c                	sd	a5,16(a1)
  st->mode = ip->mode;
    8000298e:	04851783          	lh	a5,72(a0)
    80002992:	00f59c23          	sh	a5,24(a1)
}
    80002996:	60a2                	ld	ra,8(sp)
    80002998:	6402                	ld	s0,0(sp)
    8000299a:	0141                	addi	sp,sp,16
    8000299c:	8082                	ret

000000008000299e <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000299e:	457c                	lw	a5,76(a0)
    800029a0:	0ed7e663          	bltu	a5,a3,80002a8c <readi+0xee>
{
    800029a4:	7159                	addi	sp,sp,-112
    800029a6:	f486                	sd	ra,104(sp)
    800029a8:	f0a2                	sd	s0,96(sp)
    800029aa:	eca6                	sd	s1,88(sp)
    800029ac:	e0d2                	sd	s4,64(sp)
    800029ae:	fc56                	sd	s5,56(sp)
    800029b0:	f85a                	sd	s6,48(sp)
    800029b2:	f45e                	sd	s7,40(sp)
    800029b4:	1880                	addi	s0,sp,112
    800029b6:	8b2a                	mv	s6,a0
    800029b8:	8bae                	mv	s7,a1
    800029ba:	8a32                	mv	s4,a2
    800029bc:	84b6                	mv	s1,a3
    800029be:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    800029c0:	9f35                	addw	a4,a4,a3
    return 0;
    800029c2:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800029c4:	0ad76b63          	bltu	a4,a3,80002a7a <readi+0xdc>
    800029c8:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    800029ca:	00e7f463          	bgeu	a5,a4,800029d2 <readi+0x34>
    n = ip->size - off;
    800029ce:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    800029d2:	080a8b63          	beqz	s5,80002a68 <readi+0xca>
    800029d6:	e8ca                	sd	s2,80(sp)
    800029d8:	f062                	sd	s8,32(sp)
    800029da:	ec66                	sd	s9,24(sp)
    800029dc:	e86a                	sd	s10,16(sp)
    800029de:	e46e                	sd	s11,8(sp)
    800029e0:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800029e2:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    800029e6:	5c7d                	li	s8,-1
    800029e8:	a80d                	j	80002a1a <readi+0x7c>
    800029ea:	020d1d93          	slli	s11,s10,0x20
    800029ee:	020ddd93          	srli	s11,s11,0x20
    800029f2:	05890613          	addi	a2,s2,88
    800029f6:	86ee                	mv	a3,s11
    800029f8:	963e                	add	a2,a2,a5
    800029fa:	85d2                	mv	a1,s4
    800029fc:	855e                	mv	a0,s7
    800029fe:	cc1fe0ef          	jal	800016be <either_copyout>
    80002a02:	05850363          	beq	a0,s8,80002a48 <readi+0xaa>
    {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a06:	854a                	mv	a0,s2
    80002a08:	f3aff0ef          	jal	80002142 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002a0c:	013d09bb          	addw	s3,s10,s3
    80002a10:	009d04bb          	addw	s1,s10,s1
    80002a14:	9a6e                	add	s4,s4,s11
    80002a16:	0559f363          	bgeu	s3,s5,80002a5c <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80002a1a:	00a4d59b          	srliw	a1,s1,0xa
    80002a1e:	855a                	mv	a0,s6
    80002a20:	981ff0ef          	jal	800023a0 <bmap>
    80002a24:	85aa                	mv	a1,a0
    if (addr == 0)
    80002a26:	c139                	beqz	a0,80002a6c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002a28:	000b2503          	lw	a0,0(s6)
    80002a2c:	e0eff0ef          	jal	8000203a <bread>
    80002a30:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002a32:	3ff4f793          	andi	a5,s1,1023
    80002a36:	40fc873b          	subw	a4,s9,a5
    80002a3a:	413a86bb          	subw	a3,s5,s3
    80002a3e:	8d3a                	mv	s10,a4
    80002a40:	fae6f5e3          	bgeu	a3,a4,800029ea <readi+0x4c>
    80002a44:	8d36                	mv	s10,a3
    80002a46:	b755                	j	800029ea <readi+0x4c>
      brelse(bp);
    80002a48:	854a                	mv	a0,s2
    80002a4a:	ef8ff0ef          	jal	80002142 <brelse>
      tot = -1;
    80002a4e:	59fd                	li	s3,-1
      break;
    80002a50:	6946                	ld	s2,80(sp)
    80002a52:	7c02                	ld	s8,32(sp)
    80002a54:	6ce2                	ld	s9,24(sp)
    80002a56:	6d42                	ld	s10,16(sp)
    80002a58:	6da2                	ld	s11,8(sp)
    80002a5a:	a831                	j	80002a76 <readi+0xd8>
    80002a5c:	6946                	ld	s2,80(sp)
    80002a5e:	7c02                	ld	s8,32(sp)
    80002a60:	6ce2                	ld	s9,24(sp)
    80002a62:	6d42                	ld	s10,16(sp)
    80002a64:	6da2                	ld	s11,8(sp)
    80002a66:	a801                	j	80002a76 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002a68:	89d6                	mv	s3,s5
    80002a6a:	a031                	j	80002a76 <readi+0xd8>
    80002a6c:	6946                	ld	s2,80(sp)
    80002a6e:	7c02                	ld	s8,32(sp)
    80002a70:	6ce2                	ld	s9,24(sp)
    80002a72:	6d42                	ld	s10,16(sp)
    80002a74:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a76:	854e                	mv	a0,s3
    80002a78:	69a6                	ld	s3,72(sp)
}
    80002a7a:	70a6                	ld	ra,104(sp)
    80002a7c:	7406                	ld	s0,96(sp)
    80002a7e:	64e6                	ld	s1,88(sp)
    80002a80:	6a06                	ld	s4,64(sp)
    80002a82:	7ae2                	ld	s5,56(sp)
    80002a84:	7b42                	ld	s6,48(sp)
    80002a86:	7ba2                	ld	s7,40(sp)
    80002a88:	6165                	addi	sp,sp,112
    80002a8a:	8082                	ret
    return 0;
    80002a8c:	4501                	li	a0,0
}
    80002a8e:	8082                	ret

0000000080002a90 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002a90:	457c                	lw	a5,76(a0)
    80002a92:	0ed7eb63          	bltu	a5,a3,80002b88 <writei+0xf8>
{
    80002a96:	7159                	addi	sp,sp,-112
    80002a98:	f486                	sd	ra,104(sp)
    80002a9a:	f0a2                	sd	s0,96(sp)
    80002a9c:	e8ca                	sd	s2,80(sp)
    80002a9e:	e0d2                	sd	s4,64(sp)
    80002aa0:	fc56                	sd	s5,56(sp)
    80002aa2:	f85a                	sd	s6,48(sp)
    80002aa4:	f45e                	sd	s7,40(sp)
    80002aa6:	1880                	addi	s0,sp,112
    80002aa8:	8aaa                	mv	s5,a0
    80002aaa:	8bae                	mv	s7,a1
    80002aac:	8a32                	mv	s4,a2
    80002aae:	8936                	mv	s2,a3
    80002ab0:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80002ab2:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80002ab6:	00043737          	lui	a4,0x43
    80002aba:	0cf76963          	bltu	a4,a5,80002b8c <writei+0xfc>
    80002abe:	0cd7e763          	bltu	a5,a3,80002b8c <writei+0xfc>
    80002ac2:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002ac4:	0a0b0a63          	beqz	s6,80002b78 <writei+0xe8>
    80002ac8:	eca6                	sd	s1,88(sp)
    80002aca:	f062                	sd	s8,32(sp)
    80002acc:	ec66                	sd	s9,24(sp)
    80002ace:	e86a                	sd	s10,16(sp)
    80002ad0:	e46e                	sd	s11,8(sp)
    80002ad2:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002ad4:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80002ad8:	5c7d                	li	s8,-1
    80002ada:	a825                	j	80002b12 <writei+0x82>
    80002adc:	020d1d93          	slli	s11,s10,0x20
    80002ae0:	020ddd93          	srli	s11,s11,0x20
    80002ae4:	05848513          	addi	a0,s1,88
    80002ae8:	86ee                	mv	a3,s11
    80002aea:	8652                	mv	a2,s4
    80002aec:	85de                	mv	a1,s7
    80002aee:	953e                	add	a0,a0,a5
    80002af0:	c19fe0ef          	jal	80001708 <either_copyin>
    80002af4:	05850663          	beq	a0,s8,80002b40 <writei+0xb0>
    {
      brelse(bp);
      break;
    }
    log_write(bp);
    80002af8:	8526                	mv	a0,s1
    80002afa:	69c000ef          	jal	80003196 <log_write>
    brelse(bp);
    80002afe:	8526                	mv	a0,s1
    80002b00:	e42ff0ef          	jal	80002142 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002b04:	013d09bb          	addw	s3,s10,s3
    80002b08:	012d093b          	addw	s2,s10,s2
    80002b0c:	9a6e                	add	s4,s4,s11
    80002b0e:	0369fc63          	bgeu	s3,s6,80002b46 <writei+0xb6>
    uint addr = bmap(ip, off / BSIZE);
    80002b12:	00a9559b          	srliw	a1,s2,0xa
    80002b16:	8556                	mv	a0,s5
    80002b18:	889ff0ef          	jal	800023a0 <bmap>
    80002b1c:	85aa                	mv	a1,a0
    if (addr == 0)
    80002b1e:	c505                	beqz	a0,80002b46 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002b20:	000aa503          	lw	a0,0(s5)
    80002b24:	d16ff0ef          	jal	8000203a <bread>
    80002b28:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002b2a:	3ff97793          	andi	a5,s2,1023
    80002b2e:	40fc873b          	subw	a4,s9,a5
    80002b32:	413b06bb          	subw	a3,s6,s3
    80002b36:	8d3a                	mv	s10,a4
    80002b38:	fae6f2e3          	bgeu	a3,a4,80002adc <writei+0x4c>
    80002b3c:	8d36                	mv	s10,a3
    80002b3e:	bf79                	j	80002adc <writei+0x4c>
      brelse(bp);
    80002b40:	8526                	mv	a0,s1
    80002b42:	e00ff0ef          	jal	80002142 <brelse>
  }

  if (off > ip->size)
    80002b46:	04caa783          	lw	a5,76(s5)
    80002b4a:	0327f963          	bgeu	a5,s2,80002b7c <writei+0xec>
    ip->size = off;
    80002b4e:	052aa623          	sw	s2,76(s5)
    80002b52:	64e6                	ld	s1,88(sp)
    80002b54:	7c02                	ld	s8,32(sp)
    80002b56:	6ce2                	ld	s9,24(sp)
    80002b58:	6d42                	ld	s10,16(sp)
    80002b5a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b5c:	8556                	mv	a0,s5
    80002b5e:	b2bff0ef          	jal	80002688 <iupdate>

  return tot;
    80002b62:	854e                	mv	a0,s3
    80002b64:	69a6                	ld	s3,72(sp)
}
    80002b66:	70a6                	ld	ra,104(sp)
    80002b68:	7406                	ld	s0,96(sp)
    80002b6a:	6946                	ld	s2,80(sp)
    80002b6c:	6a06                	ld	s4,64(sp)
    80002b6e:	7ae2                	ld	s5,56(sp)
    80002b70:	7b42                	ld	s6,48(sp)
    80002b72:	7ba2                	ld	s7,40(sp)
    80002b74:	6165                	addi	sp,sp,112
    80002b76:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002b78:	89da                	mv	s3,s6
    80002b7a:	b7cd                	j	80002b5c <writei+0xcc>
    80002b7c:	64e6                	ld	s1,88(sp)
    80002b7e:	7c02                	ld	s8,32(sp)
    80002b80:	6ce2                	ld	s9,24(sp)
    80002b82:	6d42                	ld	s10,16(sp)
    80002b84:	6da2                	ld	s11,8(sp)
    80002b86:	bfd9                	j	80002b5c <writei+0xcc>
    return -1;
    80002b88:	557d                	li	a0,-1
}
    80002b8a:	8082                	ret
    return -1;
    80002b8c:	557d                	li	a0,-1
    80002b8e:	bfe1                	j	80002b66 <writei+0xd6>

0000000080002b90 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    80002b90:	1141                	addi	sp,sp,-16
    80002b92:	e406                	sd	ra,8(sp)
    80002b94:	e022                	sd	s0,0(sp)
    80002b96:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b98:	4639                	li	a2,14
    80002b9a:	e98fd0ef          	jal	80000232 <strncmp>
}
    80002b9e:	60a2                	ld	ra,8(sp)
    80002ba0:	6402                	ld	s0,0(sp)
    80002ba2:	0141                	addi	sp,sp,16
    80002ba4:	8082                	ret

0000000080002ba6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ba6:	711d                	addi	sp,sp,-96
    80002ba8:	ec86                	sd	ra,88(sp)
    80002baa:	e8a2                	sd	s0,80(sp)
    80002bac:	e4a6                	sd	s1,72(sp)
    80002bae:	e0ca                	sd	s2,64(sp)
    80002bb0:	fc4e                	sd	s3,56(sp)
    80002bb2:	f852                	sd	s4,48(sp)
    80002bb4:	f456                	sd	s5,40(sp)
    80002bb6:	f05a                	sd	s6,32(sp)
    80002bb8:	ec5e                	sd	s7,24(sp)
    80002bba:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80002bbc:	04451703          	lh	a4,68(a0)
    80002bc0:	4785                	li	a5,1
    80002bc2:	00f71f63          	bne	a4,a5,80002be0 <dirlookup+0x3a>
    80002bc6:	892a                	mv	s2,a0
    80002bc8:	8aae                	mv	s5,a1
    80002bca:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
    80002bcc:	457c                	lw	a5,76(a0)
    80002bce:	4481                	li	s1,0
  {
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bd0:	fa040a13          	addi	s4,s0,-96
    80002bd4:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0)
    80002bd6:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bda:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de))
    80002bdc:	e39d                	bnez	a5,80002c02 <dirlookup+0x5c>
    80002bde:	a8b9                	j	80002c3c <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002be0:	00005517          	auipc	a0,0x5
    80002be4:	8e050513          	addi	a0,a0,-1824 # 800074c0 <etext+0x4c0>
    80002be8:	257020ef          	jal	8000563e <panic>
      panic("dirlookup read");
    80002bec:	00005517          	auipc	a0,0x5
    80002bf0:	8ec50513          	addi	a0,a0,-1812 # 800074d8 <etext+0x4d8>
    80002bf4:	24b020ef          	jal	8000563e <panic>
  for (off = 0; off < dp->size; off += sizeof(de))
    80002bf8:	24c1                	addiw	s1,s1,16
    80002bfa:	04c92783          	lw	a5,76(s2)
    80002bfe:	02f4fe63          	bgeu	s1,a5,80002c3a <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c02:	874e                	mv	a4,s3
    80002c04:	86a6                	mv	a3,s1
    80002c06:	8652                	mv	a2,s4
    80002c08:	4581                	li	a1,0
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	d93ff0ef          	jal	8000299e <readi>
    80002c10:	fd351ee3          	bne	a0,s3,80002bec <dirlookup+0x46>
    if (de.inum == 0)
    80002c14:	fa045783          	lhu	a5,-96(s0)
    80002c18:	d3e5                	beqz	a5,80002bf8 <dirlookup+0x52>
    if (namecmp(name, de.name) == 0)
    80002c1a:	85da                	mv	a1,s6
    80002c1c:	8556                	mv	a0,s5
    80002c1e:	f73ff0ef          	jal	80002b90 <namecmp>
    80002c22:	f979                	bnez	a0,80002bf8 <dirlookup+0x52>
      if (poff)
    80002c24:	000b8463          	beqz	s7,80002c2c <dirlookup+0x86>
        *poff = off;
    80002c28:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002c2c:	fa045583          	lhu	a1,-96(s0)
    80002c30:	00092503          	lw	a0,0(s2)
    80002c34:	82dff0ef          	jal	80002460 <iget>
    80002c38:	a011                	j	80002c3c <dirlookup+0x96>
  return 0;
    80002c3a:	4501                	li	a0,0
}
    80002c3c:	60e6                	ld	ra,88(sp)
    80002c3e:	6446                	ld	s0,80(sp)
    80002c40:	64a6                	ld	s1,72(sp)
    80002c42:	6906                	ld	s2,64(sp)
    80002c44:	79e2                	ld	s3,56(sp)
    80002c46:	7a42                	ld	s4,48(sp)
    80002c48:	7aa2                	ld	s5,40(sp)
    80002c4a:	7b02                	ld	s6,32(sp)
    80002c4c:	6be2                	ld	s7,24(sp)
    80002c4e:	6125                	addi	sp,sp,96
    80002c50:	8082                	ret

0000000080002c52 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80002c52:	711d                	addi	sp,sp,-96
    80002c54:	ec86                	sd	ra,88(sp)
    80002c56:	e8a2                	sd	s0,80(sp)
    80002c58:	e4a6                	sd	s1,72(sp)
    80002c5a:	e0ca                	sd	s2,64(sp)
    80002c5c:	fc4e                	sd	s3,56(sp)
    80002c5e:	f852                	sd	s4,48(sp)
    80002c60:	f456                	sd	s5,40(sp)
    80002c62:	f05a                	sd	s6,32(sp)
    80002c64:	ec5e                	sd	s7,24(sp)
    80002c66:	e862                	sd	s8,16(sp)
    80002c68:	e466                	sd	s9,8(sp)
    80002c6a:	e06a                	sd	s10,0(sp)
    80002c6c:	1080                	addi	s0,sp,96
    80002c6e:	84aa                	mv	s1,a0
    80002c70:	8b2e                	mv	s6,a1
    80002c72:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80002c74:	00054703          	lbu	a4,0(a0)
    80002c78:	02f00793          	li	a5,47
    80002c7c:	00f70f63          	beq	a4,a5,80002c9a <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c80:	906fe0ef          	jal	80000d86 <myproc>
    80002c84:	15053503          	ld	a0,336(a0)
    80002c88:	a7fff0ef          	jal	80002706 <idup>
    80002c8c:	8a2a                	mv	s4,a0
  while (*path == '/')
    80002c8e:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80002c92:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002c94:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
    if (ip->type != T_DIR)
    80002c96:	4b85                	li	s7,1
    80002c98:	a879                	j	80002d36 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002c9a:	4585                	li	a1,1
    80002c9c:	852e                	mv	a0,a1
    80002c9e:	fc2ff0ef          	jal	80002460 <iget>
    80002ca2:	8a2a                	mv	s4,a0
    80002ca4:	b7ed                	j	80002c8e <namex+0x3c>
    {
      iunlockput(ip);
    80002ca6:	8552                	mv	a0,s4
    80002ca8:	ca1ff0ef          	jal	80002948 <iunlockput>
      return 0;
    80002cac:	4a01                	li	s4,0
  {
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cae:	8552                	mv	a0,s4
    80002cb0:	60e6                	ld	ra,88(sp)
    80002cb2:	6446                	ld	s0,80(sp)
    80002cb4:	64a6                	ld	s1,72(sp)
    80002cb6:	6906                	ld	s2,64(sp)
    80002cb8:	79e2                	ld	s3,56(sp)
    80002cba:	7a42                	ld	s4,48(sp)
    80002cbc:	7aa2                	ld	s5,40(sp)
    80002cbe:	7b02                	ld	s6,32(sp)
    80002cc0:	6be2                	ld	s7,24(sp)
    80002cc2:	6c42                	ld	s8,16(sp)
    80002cc4:	6ca2                	ld	s9,8(sp)
    80002cc6:	6d02                	ld	s10,0(sp)
    80002cc8:	6125                	addi	sp,sp,96
    80002cca:	8082                	ret
      iunlock(ip);
    80002ccc:	8552                	mv	a0,s4
    80002cce:	b1dff0ef          	jal	800027ea <iunlock>
      return ip;
    80002cd2:	bff1                	j	80002cae <namex+0x5c>
      iunlockput(ip);
    80002cd4:	8552                	mv	a0,s4
    80002cd6:	c73ff0ef          	jal	80002948 <iunlockput>
      return 0;
    80002cda:	8a4a                	mv	s4,s2
    80002cdc:	bfc9                	j	80002cae <namex+0x5c>
  len = path - s;
    80002cde:	40990633          	sub	a2,s2,s1
    80002ce2:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80002ce6:	09ac5463          	bge	s8,s10,80002d6e <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002cea:	8666                	mv	a2,s9
    80002cec:	85a6                	mv	a1,s1
    80002cee:	8556                	mv	a0,s5
    80002cf0:	ccefd0ef          	jal	800001be <memmove>
    80002cf4:	84ca                	mv	s1,s2
  while (*path == '/')
    80002cf6:	0004c783          	lbu	a5,0(s1)
    80002cfa:	01379763          	bne	a5,s3,80002d08 <namex+0xb6>
    path++;
    80002cfe:	0485                	addi	s1,s1,1
  while (*path == '/')
    80002d00:	0004c783          	lbu	a5,0(s1)
    80002d04:	ff378de3          	beq	a5,s3,80002cfe <namex+0xac>
    ilock(ip);
    80002d08:	8552                	mv	a0,s4
    80002d0a:	a33ff0ef          	jal	8000273c <ilock>
    if (ip->type != T_DIR)
    80002d0e:	044a1783          	lh	a5,68(s4)
    80002d12:	f9779ae3          	bne	a5,s7,80002ca6 <namex+0x54>
    if (nameiparent && *path == '\0')
    80002d16:	000b0563          	beqz	s6,80002d20 <namex+0xce>
    80002d1a:	0004c783          	lbu	a5,0(s1)
    80002d1e:	d7dd                	beqz	a5,80002ccc <namex+0x7a>
    if ((next = dirlookup(ip, name, 0)) == 0)
    80002d20:	4601                	li	a2,0
    80002d22:	85d6                	mv	a1,s5
    80002d24:	8552                	mv	a0,s4
    80002d26:	e81ff0ef          	jal	80002ba6 <dirlookup>
    80002d2a:	892a                	mv	s2,a0
    80002d2c:	d545                	beqz	a0,80002cd4 <namex+0x82>
    iunlockput(ip);
    80002d2e:	8552                	mv	a0,s4
    80002d30:	c19ff0ef          	jal	80002948 <iunlockput>
    ip = next;
    80002d34:	8a4a                	mv	s4,s2
  while (*path == '/')
    80002d36:	0004c783          	lbu	a5,0(s1)
    80002d3a:	01379763          	bne	a5,s3,80002d48 <namex+0xf6>
    path++;
    80002d3e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80002d40:	0004c783          	lbu	a5,0(s1)
    80002d44:	ff378de3          	beq	a5,s3,80002d3e <namex+0xec>
  if (*path == 0)
    80002d48:	cf8d                	beqz	a5,80002d82 <namex+0x130>
  while (*path != '/' && *path != 0)
    80002d4a:	0004c783          	lbu	a5,0(s1)
    80002d4e:	fd178713          	addi	a4,a5,-47
    80002d52:	cb19                	beqz	a4,80002d68 <namex+0x116>
    80002d54:	cb91                	beqz	a5,80002d68 <namex+0x116>
    80002d56:	8926                	mv	s2,s1
    path++;
    80002d58:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80002d5a:	00094783          	lbu	a5,0(s2)
    80002d5e:	fd178713          	addi	a4,a5,-47
    80002d62:	df35                	beqz	a4,80002cde <namex+0x8c>
    80002d64:	fbf5                	bnez	a5,80002d58 <namex+0x106>
    80002d66:	bfa5                	j	80002cde <namex+0x8c>
    80002d68:	8926                	mv	s2,s1
  len = path - s;
    80002d6a:	4d01                	li	s10,0
    80002d6c:	4601                	li	a2,0
    memmove(name, s, len);
    80002d6e:	2601                	sext.w	a2,a2
    80002d70:	85a6                	mv	a1,s1
    80002d72:	8556                	mv	a0,s5
    80002d74:	c4afd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002d78:	9d56                	add	s10,s10,s5
    80002d7a:	000d0023          	sb	zero,0(s10)
    80002d7e:	84ca                	mv	s1,s2
    80002d80:	bf9d                	j	80002cf6 <namex+0xa4>
  if (nameiparent)
    80002d82:	f20b06e3          	beqz	s6,80002cae <namex+0x5c>
    iput(ip);
    80002d86:	8552                	mv	a0,s4
    80002d88:	b37ff0ef          	jal	800028be <iput>
    return 0;
    80002d8c:	4a01                	li	s4,0
    80002d8e:	b705                	j	80002cae <namex+0x5c>

0000000080002d90 <dirlink>:
{
    80002d90:	715d                	addi	sp,sp,-80
    80002d92:	e486                	sd	ra,72(sp)
    80002d94:	e0a2                	sd	s0,64(sp)
    80002d96:	f84a                	sd	s2,48(sp)
    80002d98:	ec56                	sd	s5,24(sp)
    80002d9a:	e85a                	sd	s6,16(sp)
    80002d9c:	0880                	addi	s0,sp,80
    80002d9e:	892a                	mv	s2,a0
    80002da0:	8aae                	mv	s5,a1
    80002da2:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0)
    80002da4:	4601                	li	a2,0
    80002da6:	e01ff0ef          	jal	80002ba6 <dirlookup>
    80002daa:	ed1d                	bnez	a0,80002de8 <dirlink+0x58>
    80002dac:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de))
    80002dae:	04c92483          	lw	s1,76(s2)
    80002db2:	c4b9                	beqz	s1,80002e00 <dirlink+0x70>
    80002db4:	f44e                	sd	s3,40(sp)
    80002db6:	f052                	sd	s4,32(sp)
    80002db8:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dba:	fb040a13          	addi	s4,s0,-80
    80002dbe:	49c1                	li	s3,16
    80002dc0:	874e                	mv	a4,s3
    80002dc2:	86a6                	mv	a3,s1
    80002dc4:	8652                	mv	a2,s4
    80002dc6:	4581                	li	a1,0
    80002dc8:	854a                	mv	a0,s2
    80002dca:	bd5ff0ef          	jal	8000299e <readi>
    80002dce:	03351163          	bne	a0,s3,80002df0 <dirlink+0x60>
    if (de.inum == 0)
    80002dd2:	fb045783          	lhu	a5,-80(s0)
    80002dd6:	c39d                	beqz	a5,80002dfc <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de))
    80002dd8:	24c1                	addiw	s1,s1,16
    80002dda:	04c92783          	lw	a5,76(s2)
    80002dde:	fef4e1e3          	bltu	s1,a5,80002dc0 <dirlink+0x30>
    80002de2:	79a2                	ld	s3,40(sp)
    80002de4:	7a02                	ld	s4,32(sp)
    80002de6:	a829                	j	80002e00 <dirlink+0x70>
    iput(ip);
    80002de8:	ad7ff0ef          	jal	800028be <iput>
    return -1;
    80002dec:	557d                	li	a0,-1
    80002dee:	a83d                	j	80002e2c <dirlink+0x9c>
      panic("dirlink read");
    80002df0:	00004517          	auipc	a0,0x4
    80002df4:	6f850513          	addi	a0,a0,1784 # 800074e8 <etext+0x4e8>
    80002df8:	047020ef          	jal	8000563e <panic>
    80002dfc:	79a2                	ld	s3,40(sp)
    80002dfe:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002e00:	4639                	li	a2,14
    80002e02:	85d6                	mv	a1,s5
    80002e04:	fb240513          	addi	a0,s0,-78
    80002e08:	c64fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002e0c:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e10:	4741                	li	a4,16
    80002e12:	86a6                	mv	a3,s1
    80002e14:	fb040613          	addi	a2,s0,-80
    80002e18:	4581                	li	a1,0
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	c75ff0ef          	jal	80002a90 <writei>
    80002e20:	1541                	addi	a0,a0,-16
    80002e22:	00a03533          	snez	a0,a0
    80002e26:	40a0053b          	negw	a0,a0
    80002e2a:	74e2                	ld	s1,56(sp)
}
    80002e2c:	60a6                	ld	ra,72(sp)
    80002e2e:	6406                	ld	s0,64(sp)
    80002e30:	7942                	ld	s2,48(sp)
    80002e32:	6ae2                	ld	s5,24(sp)
    80002e34:	6b42                	ld	s6,16(sp)
    80002e36:	6161                	addi	sp,sp,80
    80002e38:	8082                	ret

0000000080002e3a <namei>:

struct inode *
namei(char *path)
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e42:	fe040613          	addi	a2,s0,-32
    80002e46:	4581                	li	a1,0
    80002e48:	e0bff0ef          	jal	80002c52 <namex>
}
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	6105                	addi	sp,sp,32
    80002e52:	8082                	ret

0000000080002e54 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80002e54:	1141                	addi	sp,sp,-16
    80002e56:	e406                	sd	ra,8(sp)
    80002e58:	e022                	sd	s0,0(sp)
    80002e5a:	0800                	addi	s0,sp,16
    80002e5c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e5e:	4585                	li	a1,1
    80002e60:	df3ff0ef          	jal	80002c52 <namex>
}
    80002e64:	60a2                	ld	ra,8(sp)
    80002e66:	6402                	ld	s0,0(sp)
    80002e68:	0141                	addi	sp,sp,16
    80002e6a:	8082                	ret

0000000080002e6c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	e04a                	sd	s2,0(sp)
    80002e76:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e78:	00017917          	auipc	s2,0x17
    80002e7c:	47890913          	addi	s2,s2,1144 # 8001a2f0 <log>
    80002e80:	01892583          	lw	a1,24(s2)
    80002e84:	02892503          	lw	a0,40(s2)
    80002e88:	9b2ff0ef          	jal	8000203a <bread>
    80002e8c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e8e:	02c92603          	lw	a2,44(s2)
    80002e92:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e94:	00c05f63          	blez	a2,80002eb2 <write_head+0x46>
    80002e98:	00017717          	auipc	a4,0x17
    80002e9c:	48870713          	addi	a4,a4,1160 # 8001a320 <log+0x30>
    80002ea0:	87aa                	mv	a5,a0
    80002ea2:	060a                	slli	a2,a2,0x2
    80002ea4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ea6:	4314                	lw	a3,0(a4)
    80002ea8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002eaa:	0711                	addi	a4,a4,4
    80002eac:	0791                	addi	a5,a5,4
    80002eae:	fec79ce3          	bne	a5,a2,80002ea6 <write_head+0x3a>
  }
  bwrite(buf);
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	a5cff0ef          	jal	80002110 <bwrite>
  brelse(buf);
    80002eb8:	8526                	mv	a0,s1
    80002eba:	a88ff0ef          	jal	80002142 <brelse>
}
    80002ebe:	60e2                	ld	ra,24(sp)
    80002ec0:	6442                	ld	s0,16(sp)
    80002ec2:	64a2                	ld	s1,8(sp)
    80002ec4:	6902                	ld	s2,0(sp)
    80002ec6:	6105                	addi	sp,sp,32
    80002ec8:	8082                	ret

0000000080002eca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002eca:	00017797          	auipc	a5,0x17
    80002ece:	4527a783          	lw	a5,1106(a5) # 8001a31c <log+0x2c>
    80002ed2:	0af05263          	blez	a5,80002f76 <install_trans+0xac>
{
    80002ed6:	715d                	addi	sp,sp,-80
    80002ed8:	e486                	sd	ra,72(sp)
    80002eda:	e0a2                	sd	s0,64(sp)
    80002edc:	fc26                	sd	s1,56(sp)
    80002ede:	f84a                	sd	s2,48(sp)
    80002ee0:	f44e                	sd	s3,40(sp)
    80002ee2:	f052                	sd	s4,32(sp)
    80002ee4:	ec56                	sd	s5,24(sp)
    80002ee6:	e85a                	sd	s6,16(sp)
    80002ee8:	e45e                	sd	s7,8(sp)
    80002eea:	0880                	addi	s0,sp,80
    80002eec:	8b2a                	mv	s6,a0
    80002eee:	00017a97          	auipc	s5,0x17
    80002ef2:	432a8a93          	addi	s5,s5,1074 # 8001a320 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ef8:	00017997          	auipc	s3,0x17
    80002efc:	3f898993          	addi	s3,s3,1016 # 8001a2f0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f00:	40000b93          	li	s7,1024
    80002f04:	a829                	j	80002f1e <install_trans+0x54>
    brelse(lbuf);
    80002f06:	854a                	mv	a0,s2
    80002f08:	a3aff0ef          	jal	80002142 <brelse>
    brelse(dbuf);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	a34ff0ef          	jal	80002142 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f12:	2a05                	addiw	s4,s4,1
    80002f14:	0a91                	addi	s5,s5,4
    80002f16:	02c9a783          	lw	a5,44(s3)
    80002f1a:	04fa5363          	bge	s4,a5,80002f60 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f1e:	0189a583          	lw	a1,24(s3)
    80002f22:	014585bb          	addw	a1,a1,s4
    80002f26:	2585                	addiw	a1,a1,1
    80002f28:	0289a503          	lw	a0,40(s3)
    80002f2c:	90eff0ef          	jal	8000203a <bread>
    80002f30:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f32:	000aa583          	lw	a1,0(s5)
    80002f36:	0289a503          	lw	a0,40(s3)
    80002f3a:	900ff0ef          	jal	8000203a <bread>
    80002f3e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f40:	865e                	mv	a2,s7
    80002f42:	05890593          	addi	a1,s2,88
    80002f46:	05850513          	addi	a0,a0,88
    80002f4a:	a74fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f4e:	8526                	mv	a0,s1
    80002f50:	9c0ff0ef          	jal	80002110 <bwrite>
    if(recovering == 0)
    80002f54:	fa0b19e3          	bnez	s6,80002f06 <install_trans+0x3c>
      bunpin(dbuf);
    80002f58:	8526                	mv	a0,s1
    80002f5a:	aa0ff0ef          	jal	800021fa <bunpin>
    80002f5e:	b765                	j	80002f06 <install_trans+0x3c>
}
    80002f60:	60a6                	ld	ra,72(sp)
    80002f62:	6406                	ld	s0,64(sp)
    80002f64:	74e2                	ld	s1,56(sp)
    80002f66:	7942                	ld	s2,48(sp)
    80002f68:	79a2                	ld	s3,40(sp)
    80002f6a:	7a02                	ld	s4,32(sp)
    80002f6c:	6ae2                	ld	s5,24(sp)
    80002f6e:	6b42                	ld	s6,16(sp)
    80002f70:	6ba2                	ld	s7,8(sp)
    80002f72:	6161                	addi	sp,sp,80
    80002f74:	8082                	ret
    80002f76:	8082                	ret

0000000080002f78 <initlog>:
{
    80002f78:	7179                	addi	sp,sp,-48
    80002f7a:	f406                	sd	ra,40(sp)
    80002f7c:	f022                	sd	s0,32(sp)
    80002f7e:	ec26                	sd	s1,24(sp)
    80002f80:	e84a                	sd	s2,16(sp)
    80002f82:	e44e                	sd	s3,8(sp)
    80002f84:	1800                	addi	s0,sp,48
    80002f86:	892a                	mv	s2,a0
    80002f88:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f8a:	00017497          	auipc	s1,0x17
    80002f8e:	36648493          	addi	s1,s1,870 # 8001a2f0 <log>
    80002f92:	00004597          	auipc	a1,0x4
    80002f96:	56658593          	addi	a1,a1,1382 # 800074f8 <etext+0x4f8>
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	157020ef          	jal	800058f2 <initlock>
  log.start = sb->logstart;
    80002fa0:	0149a583          	lw	a1,20(s3)
    80002fa4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fa6:	0109a783          	lw	a5,16(s3)
    80002faa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fac:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fb0:	854a                	mv	a0,s2
    80002fb2:	888ff0ef          	jal	8000203a <bread>
  log.lh.n = lh->n;
    80002fb6:	4d30                	lw	a2,88(a0)
    80002fb8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fba:	00c05f63          	blez	a2,80002fd8 <initlog+0x60>
    80002fbe:	87aa                	mv	a5,a0
    80002fc0:	00017717          	auipc	a4,0x17
    80002fc4:	36070713          	addi	a4,a4,864 # 8001a320 <log+0x30>
    80002fc8:	060a                	slli	a2,a2,0x2
    80002fca:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fcc:	4ff4                	lw	a3,92(a5)
    80002fce:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fd0:	0791                	addi	a5,a5,4
    80002fd2:	0711                	addi	a4,a4,4
    80002fd4:	fec79ce3          	bne	a5,a2,80002fcc <initlog+0x54>
  brelse(buf);
    80002fd8:	96aff0ef          	jal	80002142 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fdc:	4505                	li	a0,1
    80002fde:	eedff0ef          	jal	80002eca <install_trans>
  log.lh.n = 0;
    80002fe2:	00017797          	auipc	a5,0x17
    80002fe6:	3207ad23          	sw	zero,826(a5) # 8001a31c <log+0x2c>
  write_head(); // clear the log
    80002fea:	e83ff0ef          	jal	80002e6c <write_head>
}
    80002fee:	70a2                	ld	ra,40(sp)
    80002ff0:	7402                	ld	s0,32(sp)
    80002ff2:	64e2                	ld	s1,24(sp)
    80002ff4:	6942                	ld	s2,16(sp)
    80002ff6:	69a2                	ld	s3,8(sp)
    80002ff8:	6145                	addi	sp,sp,48
    80002ffa:	8082                	ret

0000000080002ffc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ffc:	1101                	addi	sp,sp,-32
    80002ffe:	ec06                	sd	ra,24(sp)
    80003000:	e822                	sd	s0,16(sp)
    80003002:	e426                	sd	s1,8(sp)
    80003004:	e04a                	sd	s2,0(sp)
    80003006:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003008:	00017517          	auipc	a0,0x17
    8000300c:	2e850513          	addi	a0,a0,744 # 8001a2f0 <log>
    80003010:	16d020ef          	jal	8000597c <acquire>
  while(1){
    if(log.committing){
    80003014:	00017497          	auipc	s1,0x17
    80003018:	2dc48493          	addi	s1,s1,732 # 8001a2f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000301c:	4979                	li	s2,30
    8000301e:	a029                	j	80003028 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003020:	85a6                	mv	a1,s1
    80003022:	8526                	mv	a0,s1
    80003024:	b40fe0ef          	jal	80001364 <sleep>
    if(log.committing){
    80003028:	50dc                	lw	a5,36(s1)
    8000302a:	fbfd                	bnez	a5,80003020 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000302c:	5098                	lw	a4,32(s1)
    8000302e:	2705                	addiw	a4,a4,1
    80003030:	0027179b          	slliw	a5,a4,0x2
    80003034:	9fb9                	addw	a5,a5,a4
    80003036:	0017979b          	slliw	a5,a5,0x1
    8000303a:	54d4                	lw	a3,44(s1)
    8000303c:	9fb5                	addw	a5,a5,a3
    8000303e:	00f95763          	bge	s2,a5,8000304c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003042:	85a6                	mv	a1,s1
    80003044:	8526                	mv	a0,s1
    80003046:	b1efe0ef          	jal	80001364 <sleep>
    8000304a:	bff9                	j	80003028 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000304c:	00017797          	auipc	a5,0x17
    80003050:	2ce7a223          	sw	a4,708(a5) # 8001a310 <log+0x20>
      release(&log.lock);
    80003054:	00017517          	auipc	a0,0x17
    80003058:	29c50513          	addi	a0,a0,668 # 8001a2f0 <log>
    8000305c:	1b5020ef          	jal	80005a10 <release>
      break;
    }
  }
}
    80003060:	60e2                	ld	ra,24(sp)
    80003062:	6442                	ld	s0,16(sp)
    80003064:	64a2                	ld	s1,8(sp)
    80003066:	6902                	ld	s2,0(sp)
    80003068:	6105                	addi	sp,sp,32
    8000306a:	8082                	ret

000000008000306c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000306c:	7139                	addi	sp,sp,-64
    8000306e:	fc06                	sd	ra,56(sp)
    80003070:	f822                	sd	s0,48(sp)
    80003072:	f426                	sd	s1,40(sp)
    80003074:	f04a                	sd	s2,32(sp)
    80003076:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003078:	00017497          	auipc	s1,0x17
    8000307c:	27848493          	addi	s1,s1,632 # 8001a2f0 <log>
    80003080:	8526                	mv	a0,s1
    80003082:	0fb020ef          	jal	8000597c <acquire>
  log.outstanding -= 1;
    80003086:	509c                	lw	a5,32(s1)
    80003088:	37fd                	addiw	a5,a5,-1
    8000308a:	893e                	mv	s2,a5
    8000308c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000308e:	50dc                	lw	a5,36(s1)
    80003090:	e7b1                	bnez	a5,800030dc <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003092:	04091e63          	bnez	s2,800030ee <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003096:	00017497          	auipc	s1,0x17
    8000309a:	25a48493          	addi	s1,s1,602 # 8001a2f0 <log>
    8000309e:	4785                	li	a5,1
    800030a0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030a2:	8526                	mv	a0,s1
    800030a4:	16d020ef          	jal	80005a10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030a8:	54dc                	lw	a5,44(s1)
    800030aa:	06f04463          	bgtz	a5,80003112 <end_op+0xa6>
    acquire(&log.lock);
    800030ae:	00017517          	auipc	a0,0x17
    800030b2:	24250513          	addi	a0,a0,578 # 8001a2f0 <log>
    800030b6:	0c7020ef          	jal	8000597c <acquire>
    log.committing = 0;
    800030ba:	00017797          	auipc	a5,0x17
    800030be:	2407ad23          	sw	zero,602(a5) # 8001a314 <log+0x24>
    wakeup(&log);
    800030c2:	00017517          	auipc	a0,0x17
    800030c6:	22e50513          	addi	a0,a0,558 # 8001a2f0 <log>
    800030ca:	ae6fe0ef          	jal	800013b0 <wakeup>
    release(&log.lock);
    800030ce:	00017517          	auipc	a0,0x17
    800030d2:	22250513          	addi	a0,a0,546 # 8001a2f0 <log>
    800030d6:	13b020ef          	jal	80005a10 <release>
}
    800030da:	a035                	j	80003106 <end_op+0x9a>
    800030dc:	ec4e                	sd	s3,24(sp)
    800030de:	e852                	sd	s4,16(sp)
    800030e0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030e2:	00004517          	auipc	a0,0x4
    800030e6:	41e50513          	addi	a0,a0,1054 # 80007500 <etext+0x500>
    800030ea:	554020ef          	jal	8000563e <panic>
    wakeup(&log);
    800030ee:	00017517          	auipc	a0,0x17
    800030f2:	20250513          	addi	a0,a0,514 # 8001a2f0 <log>
    800030f6:	abafe0ef          	jal	800013b0 <wakeup>
  release(&log.lock);
    800030fa:	00017517          	auipc	a0,0x17
    800030fe:	1f650513          	addi	a0,a0,502 # 8001a2f0 <log>
    80003102:	10f020ef          	jal	80005a10 <release>
}
    80003106:	70e2                	ld	ra,56(sp)
    80003108:	7442                	ld	s0,48(sp)
    8000310a:	74a2                	ld	s1,40(sp)
    8000310c:	7902                	ld	s2,32(sp)
    8000310e:	6121                	addi	sp,sp,64
    80003110:	8082                	ret
    80003112:	ec4e                	sd	s3,24(sp)
    80003114:	e852                	sd	s4,16(sp)
    80003116:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003118:	00017a97          	auipc	s5,0x17
    8000311c:	208a8a93          	addi	s5,s5,520 # 8001a320 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003120:	00017a17          	auipc	s4,0x17
    80003124:	1d0a0a13          	addi	s4,s4,464 # 8001a2f0 <log>
    80003128:	018a2583          	lw	a1,24(s4)
    8000312c:	012585bb          	addw	a1,a1,s2
    80003130:	2585                	addiw	a1,a1,1
    80003132:	028a2503          	lw	a0,40(s4)
    80003136:	f05fe0ef          	jal	8000203a <bread>
    8000313a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000313c:	000aa583          	lw	a1,0(s5)
    80003140:	028a2503          	lw	a0,40(s4)
    80003144:	ef7fe0ef          	jal	8000203a <bread>
    80003148:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000314a:	40000613          	li	a2,1024
    8000314e:	05850593          	addi	a1,a0,88
    80003152:	05848513          	addi	a0,s1,88
    80003156:	868fd0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    8000315a:	8526                	mv	a0,s1
    8000315c:	fb5fe0ef          	jal	80002110 <bwrite>
    brelse(from);
    80003160:	854e                	mv	a0,s3
    80003162:	fe1fe0ef          	jal	80002142 <brelse>
    brelse(to);
    80003166:	8526                	mv	a0,s1
    80003168:	fdbfe0ef          	jal	80002142 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000316c:	2905                	addiw	s2,s2,1
    8000316e:	0a91                	addi	s5,s5,4
    80003170:	02ca2783          	lw	a5,44(s4)
    80003174:	faf94ae3          	blt	s2,a5,80003128 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003178:	cf5ff0ef          	jal	80002e6c <write_head>
    install_trans(0); // Now install writes to home locations
    8000317c:	4501                	li	a0,0
    8000317e:	d4dff0ef          	jal	80002eca <install_trans>
    log.lh.n = 0;
    80003182:	00017797          	auipc	a5,0x17
    80003186:	1807ad23          	sw	zero,410(a5) # 8001a31c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000318a:	ce3ff0ef          	jal	80002e6c <write_head>
    8000318e:	69e2                	ld	s3,24(sp)
    80003190:	6a42                	ld	s4,16(sp)
    80003192:	6aa2                	ld	s5,8(sp)
    80003194:	bf29                	j	800030ae <end_op+0x42>

0000000080003196 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003196:	1101                	addi	sp,sp,-32
    80003198:	ec06                	sd	ra,24(sp)
    8000319a:	e822                	sd	s0,16(sp)
    8000319c:	e426                	sd	s1,8(sp)
    8000319e:	1000                	addi	s0,sp,32
    800031a0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031a2:	00017517          	auipc	a0,0x17
    800031a6:	14e50513          	addi	a0,a0,334 # 8001a2f0 <log>
    800031aa:	7d2020ef          	jal	8000597c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031ae:	00017617          	auipc	a2,0x17
    800031b2:	16e62603          	lw	a2,366(a2) # 8001a31c <log+0x2c>
    800031b6:	47f5                	li	a5,29
    800031b8:	06c7c463          	blt	a5,a2,80003220 <log_write+0x8a>
    800031bc:	00017797          	auipc	a5,0x17
    800031c0:	1507a783          	lw	a5,336(a5) # 8001a30c <log+0x1c>
    800031c4:	37fd                	addiw	a5,a5,-1
    800031c6:	04f65d63          	bge	a2,a5,80003220 <log_write+0x8a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031ca:	00017797          	auipc	a5,0x17
    800031ce:	1467a783          	lw	a5,326(a5) # 8001a310 <log+0x20>
    800031d2:	04f05d63          	blez	a5,8000322c <log_write+0x96>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031d6:	4781                	li	a5,0
    800031d8:	06c05063          	blez	a2,80003238 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031dc:	44cc                	lw	a1,12(s1)
    800031de:	00017717          	auipc	a4,0x17
    800031e2:	14270713          	addi	a4,a4,322 # 8001a320 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031e6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031e8:	4314                	lw	a3,0(a4)
    800031ea:	04b68763          	beq	a3,a1,80003238 <log_write+0xa2>
  for (i = 0; i < log.lh.n; i++) {
    800031ee:	2785                	addiw	a5,a5,1
    800031f0:	0711                	addi	a4,a4,4
    800031f2:	fef61be3          	bne	a2,a5,800031e8 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031f6:	060a                	slli	a2,a2,0x2
    800031f8:	02060613          	addi	a2,a2,32
    800031fc:	00017797          	auipc	a5,0x17
    80003200:	0f478793          	addi	a5,a5,244 # 8001a2f0 <log>
    80003204:	97b2                	add	a5,a5,a2
    80003206:	44d8                	lw	a4,12(s1)
    80003208:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000320a:	8526                	mv	a0,s1
    8000320c:	fbbfe0ef          	jal	800021c6 <bpin>
    log.lh.n++;
    80003210:	00017717          	auipc	a4,0x17
    80003214:	0e070713          	addi	a4,a4,224 # 8001a2f0 <log>
    80003218:	575c                	lw	a5,44(a4)
    8000321a:	2785                	addiw	a5,a5,1
    8000321c:	d75c                	sw	a5,44(a4)
    8000321e:	a815                	j	80003252 <log_write+0xbc>
    panic("too big a transaction");
    80003220:	00004517          	auipc	a0,0x4
    80003224:	2f050513          	addi	a0,a0,752 # 80007510 <etext+0x510>
    80003228:	416020ef          	jal	8000563e <panic>
    panic("log_write outside of trans");
    8000322c:	00004517          	auipc	a0,0x4
    80003230:	2fc50513          	addi	a0,a0,764 # 80007528 <etext+0x528>
    80003234:	40a020ef          	jal	8000563e <panic>
  log.lh.block[i] = b->blockno;
    80003238:	00279693          	slli	a3,a5,0x2
    8000323c:	02068693          	addi	a3,a3,32
    80003240:	00017717          	auipc	a4,0x17
    80003244:	0b070713          	addi	a4,a4,176 # 8001a2f0 <log>
    80003248:	9736                	add	a4,a4,a3
    8000324a:	44d4                	lw	a3,12(s1)
    8000324c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000324e:	faf60ee3          	beq	a2,a5,8000320a <log_write+0x74>
  }
  release(&log.lock);
    80003252:	00017517          	auipc	a0,0x17
    80003256:	09e50513          	addi	a0,a0,158 # 8001a2f0 <log>
    8000325a:	7b6020ef          	jal	80005a10 <release>
}
    8000325e:	60e2                	ld	ra,24(sp)
    80003260:	6442                	ld	s0,16(sp)
    80003262:	64a2                	ld	s1,8(sp)
    80003264:	6105                	addi	sp,sp,32
    80003266:	8082                	ret

0000000080003268 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003268:	1101                	addi	sp,sp,-32
    8000326a:	ec06                	sd	ra,24(sp)
    8000326c:	e822                	sd	s0,16(sp)
    8000326e:	e426                	sd	s1,8(sp)
    80003270:	e04a                	sd	s2,0(sp)
    80003272:	1000                	addi	s0,sp,32
    80003274:	84aa                	mv	s1,a0
    80003276:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003278:	00004597          	auipc	a1,0x4
    8000327c:	2d058593          	addi	a1,a1,720 # 80007548 <etext+0x548>
    80003280:	0521                	addi	a0,a0,8
    80003282:	670020ef          	jal	800058f2 <initlock>
  lk->name = name;
    80003286:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000328a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000328e:	0204a423          	sw	zero,40(s1)
}
    80003292:	60e2                	ld	ra,24(sp)
    80003294:	6442                	ld	s0,16(sp)
    80003296:	64a2                	ld	s1,8(sp)
    80003298:	6902                	ld	s2,0(sp)
    8000329a:	6105                	addi	sp,sp,32
    8000329c:	8082                	ret

000000008000329e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000329e:	1101                	addi	sp,sp,-32
    800032a0:	ec06                	sd	ra,24(sp)
    800032a2:	e822                	sd	s0,16(sp)
    800032a4:	e426                	sd	s1,8(sp)
    800032a6:	e04a                	sd	s2,0(sp)
    800032a8:	1000                	addi	s0,sp,32
    800032aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032ac:	00850913          	addi	s2,a0,8
    800032b0:	854a                	mv	a0,s2
    800032b2:	6ca020ef          	jal	8000597c <acquire>
  while (lk->locked) {
    800032b6:	409c                	lw	a5,0(s1)
    800032b8:	c799                	beqz	a5,800032c6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032ba:	85ca                	mv	a1,s2
    800032bc:	8526                	mv	a0,s1
    800032be:	8a6fe0ef          	jal	80001364 <sleep>
  while (lk->locked) {
    800032c2:	409c                	lw	a5,0(s1)
    800032c4:	fbfd                	bnez	a5,800032ba <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032c6:	4785                	li	a5,1
    800032c8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032ca:	abdfd0ef          	jal	80000d86 <myproc>
    800032ce:	591c                	lw	a5,48(a0)
    800032d0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032d2:	854a                	mv	a0,s2
    800032d4:	73c020ef          	jal	80005a10 <release>
}
    800032d8:	60e2                	ld	ra,24(sp)
    800032da:	6442                	ld	s0,16(sp)
    800032dc:	64a2                	ld	s1,8(sp)
    800032de:	6902                	ld	s2,0(sp)
    800032e0:	6105                	addi	sp,sp,32
    800032e2:	8082                	ret

00000000800032e4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032e4:	1101                	addi	sp,sp,-32
    800032e6:	ec06                	sd	ra,24(sp)
    800032e8:	e822                	sd	s0,16(sp)
    800032ea:	e426                	sd	s1,8(sp)
    800032ec:	e04a                	sd	s2,0(sp)
    800032ee:	1000                	addi	s0,sp,32
    800032f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032f2:	00850913          	addi	s2,a0,8
    800032f6:	854a                	mv	a0,s2
    800032f8:	684020ef          	jal	8000597c <acquire>
  lk->locked = 0;
    800032fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003300:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003304:	8526                	mv	a0,s1
    80003306:	8aafe0ef          	jal	800013b0 <wakeup>
  release(&lk->lk);
    8000330a:	854a                	mv	a0,s2
    8000330c:	704020ef          	jal	80005a10 <release>
}
    80003310:	60e2                	ld	ra,24(sp)
    80003312:	6442                	ld	s0,16(sp)
    80003314:	64a2                	ld	s1,8(sp)
    80003316:	6902                	ld	s2,0(sp)
    80003318:	6105                	addi	sp,sp,32
    8000331a:	8082                	ret

000000008000331c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000331c:	7179                	addi	sp,sp,-48
    8000331e:	f406                	sd	ra,40(sp)
    80003320:	f022                	sd	s0,32(sp)
    80003322:	ec26                	sd	s1,24(sp)
    80003324:	e84a                	sd	s2,16(sp)
    80003326:	1800                	addi	s0,sp,48
    80003328:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000332a:	00850913          	addi	s2,a0,8
    8000332e:	854a                	mv	a0,s2
    80003330:	64c020ef          	jal	8000597c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003334:	409c                	lw	a5,0(s1)
    80003336:	ef81                	bnez	a5,8000334e <holdingsleep+0x32>
    80003338:	4481                	li	s1,0
  release(&lk->lk);
    8000333a:	854a                	mv	a0,s2
    8000333c:	6d4020ef          	jal	80005a10 <release>
  return r;
}
    80003340:	8526                	mv	a0,s1
    80003342:	70a2                	ld	ra,40(sp)
    80003344:	7402                	ld	s0,32(sp)
    80003346:	64e2                	ld	s1,24(sp)
    80003348:	6942                	ld	s2,16(sp)
    8000334a:	6145                	addi	sp,sp,48
    8000334c:	8082                	ret
    8000334e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003350:	0284a983          	lw	s3,40(s1)
    80003354:	a33fd0ef          	jal	80000d86 <myproc>
    80003358:	5904                	lw	s1,48(a0)
    8000335a:	413484b3          	sub	s1,s1,s3
    8000335e:	0014b493          	seqz	s1,s1
    80003362:	69a2                	ld	s3,8(sp)
    80003364:	bfd9                	j	8000333a <holdingsleep+0x1e>

0000000080003366 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003366:	1141                	addi	sp,sp,-16
    80003368:	e406                	sd	ra,8(sp)
    8000336a:	e022                	sd	s0,0(sp)
    8000336c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000336e:	00004597          	auipc	a1,0x4
    80003372:	1ea58593          	addi	a1,a1,490 # 80007558 <etext+0x558>
    80003376:	00017517          	auipc	a0,0x17
    8000337a:	0c250513          	addi	a0,a0,194 # 8001a438 <ftable>
    8000337e:	574020ef          	jal	800058f2 <initlock>
}
    80003382:	60a2                	ld	ra,8(sp)
    80003384:	6402                	ld	s0,0(sp)
    80003386:	0141                	addi	sp,sp,16
    80003388:	8082                	ret

000000008000338a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	e426                	sd	s1,8(sp)
    80003392:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003394:	00017517          	auipc	a0,0x17
    80003398:	0a450513          	addi	a0,a0,164 # 8001a438 <ftable>
    8000339c:	5e0020ef          	jal	8000597c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033a0:	00017497          	auipc	s1,0x17
    800033a4:	0b048493          	addi	s1,s1,176 # 8001a450 <ftable+0x18>
    800033a8:	00018717          	auipc	a4,0x18
    800033ac:	04870713          	addi	a4,a4,72 # 8001b3f0 <disk>
    if(f->ref == 0){
    800033b0:	40dc                	lw	a5,4(s1)
    800033b2:	cf89                	beqz	a5,800033cc <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033b4:	02848493          	addi	s1,s1,40
    800033b8:	fee49ce3          	bne	s1,a4,800033b0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033bc:	00017517          	auipc	a0,0x17
    800033c0:	07c50513          	addi	a0,a0,124 # 8001a438 <ftable>
    800033c4:	64c020ef          	jal	80005a10 <release>
  return 0;
    800033c8:	4481                	li	s1,0
    800033ca:	a809                	j	800033dc <filealloc+0x52>
      f->ref = 1;
    800033cc:	4785                	li	a5,1
    800033ce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033d0:	00017517          	auipc	a0,0x17
    800033d4:	06850513          	addi	a0,a0,104 # 8001a438 <ftable>
    800033d8:	638020ef          	jal	80005a10 <release>
}
    800033dc:	8526                	mv	a0,s1
    800033de:	60e2                	ld	ra,24(sp)
    800033e0:	6442                	ld	s0,16(sp)
    800033e2:	64a2                	ld	s1,8(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	1000                	addi	s0,sp,32
    800033f2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033f4:	00017517          	auipc	a0,0x17
    800033f8:	04450513          	addi	a0,a0,68 # 8001a438 <ftable>
    800033fc:	580020ef          	jal	8000597c <acquire>
  if(f->ref < 1)
    80003400:	40dc                	lw	a5,4(s1)
    80003402:	02f05063          	blez	a5,80003422 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003406:	2785                	addiw	a5,a5,1
    80003408:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000340a:	00017517          	auipc	a0,0x17
    8000340e:	02e50513          	addi	a0,a0,46 # 8001a438 <ftable>
    80003412:	5fe020ef          	jal	80005a10 <release>
  return f;
}
    80003416:	8526                	mv	a0,s1
    80003418:	60e2                	ld	ra,24(sp)
    8000341a:	6442                	ld	s0,16(sp)
    8000341c:	64a2                	ld	s1,8(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret
    panic("filedup");
    80003422:	00004517          	auipc	a0,0x4
    80003426:	13e50513          	addi	a0,a0,318 # 80007560 <etext+0x560>
    8000342a:	214020ef          	jal	8000563e <panic>

000000008000342e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000342e:	7139                	addi	sp,sp,-64
    80003430:	fc06                	sd	ra,56(sp)
    80003432:	f822                	sd	s0,48(sp)
    80003434:	f426                	sd	s1,40(sp)
    80003436:	0080                	addi	s0,sp,64
    80003438:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000343a:	00017517          	auipc	a0,0x17
    8000343e:	ffe50513          	addi	a0,a0,-2 # 8001a438 <ftable>
    80003442:	53a020ef          	jal	8000597c <acquire>
  if(f->ref < 1)
    80003446:	40dc                	lw	a5,4(s1)
    80003448:	04f05a63          	blez	a5,8000349c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000344c:	37fd                	addiw	a5,a5,-1
    8000344e:	c0dc                	sw	a5,4(s1)
    80003450:	06f04063          	bgtz	a5,800034b0 <fileclose+0x82>
    80003454:	f04a                	sd	s2,32(sp)
    80003456:	ec4e                	sd	s3,24(sp)
    80003458:	e852                	sd	s4,16(sp)
    8000345a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000345c:	0004a903          	lw	s2,0(s1)
    80003460:	0094c783          	lbu	a5,9(s1)
    80003464:	89be                	mv	s3,a5
    80003466:	689c                	ld	a5,16(s1)
    80003468:	8a3e                	mv	s4,a5
    8000346a:	6c9c                	ld	a5,24(s1)
    8000346c:	8abe                	mv	s5,a5
  f->ref = 0;
    8000346e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003472:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003476:	00017517          	auipc	a0,0x17
    8000347a:	fc250513          	addi	a0,a0,-62 # 8001a438 <ftable>
    8000347e:	592020ef          	jal	80005a10 <release>

  if(ff.type == FD_PIPE){
    80003482:	4785                	li	a5,1
    80003484:	04f90163          	beq	s2,a5,800034c6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003488:	ffe9079b          	addiw	a5,s2,-2
    8000348c:	4705                	li	a4,1
    8000348e:	04f77563          	bgeu	a4,a5,800034d8 <fileclose+0xaa>
    80003492:	7902                	ld	s2,32(sp)
    80003494:	69e2                	ld	s3,24(sp)
    80003496:	6a42                	ld	s4,16(sp)
    80003498:	6aa2                	ld	s5,8(sp)
    8000349a:	a00d                	j	800034bc <fileclose+0x8e>
    8000349c:	f04a                	sd	s2,32(sp)
    8000349e:	ec4e                	sd	s3,24(sp)
    800034a0:	e852                	sd	s4,16(sp)
    800034a2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034a4:	00004517          	auipc	a0,0x4
    800034a8:	0c450513          	addi	a0,a0,196 # 80007568 <etext+0x568>
    800034ac:	192020ef          	jal	8000563e <panic>
    release(&ftable.lock);
    800034b0:	00017517          	auipc	a0,0x17
    800034b4:	f8850513          	addi	a0,a0,-120 # 8001a438 <ftable>
    800034b8:	558020ef          	jal	80005a10 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034bc:	70e2                	ld	ra,56(sp)
    800034be:	7442                	ld	s0,48(sp)
    800034c0:	74a2                	ld	s1,40(sp)
    800034c2:	6121                	addi	sp,sp,64
    800034c4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034c6:	85ce                	mv	a1,s3
    800034c8:	8552                	mv	a0,s4
    800034ca:	34a000ef          	jal	80003814 <pipeclose>
    800034ce:	7902                	ld	s2,32(sp)
    800034d0:	69e2                	ld	s3,24(sp)
    800034d2:	6a42                	ld	s4,16(sp)
    800034d4:	6aa2                	ld	s5,8(sp)
    800034d6:	b7dd                	j	800034bc <fileclose+0x8e>
    begin_op();
    800034d8:	b25ff0ef          	jal	80002ffc <begin_op>
    iput(ff.ip);
    800034dc:	8556                	mv	a0,s5
    800034de:	be0ff0ef          	jal	800028be <iput>
    end_op();
    800034e2:	b8bff0ef          	jal	8000306c <end_op>
    800034e6:	7902                	ld	s2,32(sp)
    800034e8:	69e2                	ld	s3,24(sp)
    800034ea:	6a42                	ld	s4,16(sp)
    800034ec:	6aa2                	ld	s5,8(sp)
    800034ee:	b7f9                	j	800034bc <fileclose+0x8e>

00000000800034f0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034f0:	715d                	addi	sp,sp,-80
    800034f2:	e486                	sd	ra,72(sp)
    800034f4:	e0a2                	sd	s0,64(sp)
    800034f6:	fc26                	sd	s1,56(sp)
    800034f8:	f052                	sd	s4,32(sp)
    800034fa:	0880                	addi	s0,sp,80
    800034fc:	84aa                	mv	s1,a0
    800034fe:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003500:	887fd0ef          	jal	80000d86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003504:	409c                	lw	a5,0(s1)
    80003506:	37f9                	addiw	a5,a5,-2
    80003508:	4705                	li	a4,1
    8000350a:	04f76363          	bltu	a4,a5,80003550 <filestat+0x60>
    8000350e:	f84a                	sd	s2,48(sp)
    80003510:	f44e                	sd	s3,40(sp)
    80003512:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003514:	6c88                	ld	a0,24(s1)
    80003516:	a26ff0ef          	jal	8000273c <ilock>
    stati(f->ip, &st);
    8000351a:	fb040913          	addi	s2,s0,-80
    8000351e:	85ca                	mv	a1,s2
    80003520:	6c88                	ld	a0,24(s1)
    80003522:	c46ff0ef          	jal	80002968 <stati>
    iunlock(f->ip);
    80003526:	6c88                	ld	a0,24(s1)
    80003528:	ac2ff0ef          	jal	800027ea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000352c:	02000693          	li	a3,32
    80003530:	864a                	mv	a2,s2
    80003532:	85d2                	mv	a1,s4
    80003534:	0509b503          	ld	a0,80(s3)
    80003538:	ccafd0ef          	jal	80000a02 <copyout>
    8000353c:	41f5551b          	sraiw	a0,a0,0x1f
    80003540:	7942                	ld	s2,48(sp)
    80003542:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003544:	60a6                	ld	ra,72(sp)
    80003546:	6406                	ld	s0,64(sp)
    80003548:	74e2                	ld	s1,56(sp)
    8000354a:	7a02                	ld	s4,32(sp)
    8000354c:	6161                	addi	sp,sp,80
    8000354e:	8082                	ret
  return -1;
    80003550:	557d                	li	a0,-1
    80003552:	bfcd                	j	80003544 <filestat+0x54>

0000000080003554 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003554:	7179                	addi	sp,sp,-48
    80003556:	f406                	sd	ra,40(sp)
    80003558:	f022                	sd	s0,32(sp)
    8000355a:	e84a                	sd	s2,16(sp)
    8000355c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000355e:	00854783          	lbu	a5,8(a0)
    80003562:	cfd1                	beqz	a5,800035fe <fileread+0xaa>
    80003564:	ec26                	sd	s1,24(sp)
    80003566:	e44e                	sd	s3,8(sp)
    80003568:	84aa                	mv	s1,a0
    8000356a:	892e                	mv	s2,a1
    8000356c:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    8000356e:	411c                	lw	a5,0(a0)
    80003570:	4705                	li	a4,1
    80003572:	04e78363          	beq	a5,a4,800035b8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003576:	470d                	li	a4,3
    80003578:	04e78763          	beq	a5,a4,800035c6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000357c:	4709                	li	a4,2
    8000357e:	06e79a63          	bne	a5,a4,800035f2 <fileread+0x9e>
    ilock(f->ip);
    80003582:	6d08                	ld	a0,24(a0)
    80003584:	9b8ff0ef          	jal	8000273c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003588:	874e                	mv	a4,s3
    8000358a:	5094                	lw	a3,32(s1)
    8000358c:	864a                	mv	a2,s2
    8000358e:	4585                	li	a1,1
    80003590:	6c88                	ld	a0,24(s1)
    80003592:	c0cff0ef          	jal	8000299e <readi>
    80003596:	892a                	mv	s2,a0
    80003598:	00a05563          	blez	a0,800035a2 <fileread+0x4e>
      f->off += r;
    8000359c:	509c                	lw	a5,32(s1)
    8000359e:	9fa9                	addw	a5,a5,a0
    800035a0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035a2:	6c88                	ld	a0,24(s1)
    800035a4:	a46ff0ef          	jal	800027ea <iunlock>
    800035a8:	64e2                	ld	s1,24(sp)
    800035aa:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035ac:	854a                	mv	a0,s2
    800035ae:	70a2                	ld	ra,40(sp)
    800035b0:	7402                	ld	s0,32(sp)
    800035b2:	6942                	ld	s2,16(sp)
    800035b4:	6145                	addi	sp,sp,48
    800035b6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035b8:	6908                	ld	a0,16(a0)
    800035ba:	3b0000ef          	jal	8000396a <piperead>
    800035be:	892a                	mv	s2,a0
    800035c0:	64e2                	ld	s1,24(sp)
    800035c2:	69a2                	ld	s3,8(sp)
    800035c4:	b7e5                	j	800035ac <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035c6:	02451783          	lh	a5,36(a0)
    800035ca:	03079693          	slli	a3,a5,0x30
    800035ce:	92c1                	srli	a3,a3,0x30
    800035d0:	4725                	li	a4,9
    800035d2:	02d76963          	bltu	a4,a3,80003604 <fileread+0xb0>
    800035d6:	0792                	slli	a5,a5,0x4
    800035d8:	00017717          	auipc	a4,0x17
    800035dc:	dc070713          	addi	a4,a4,-576 # 8001a398 <devsw>
    800035e0:	97ba                	add	a5,a5,a4
    800035e2:	639c                	ld	a5,0(a5)
    800035e4:	c78d                	beqz	a5,8000360e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800035e6:	4505                	li	a0,1
    800035e8:	9782                	jalr	a5
    800035ea:	892a                	mv	s2,a0
    800035ec:	64e2                	ld	s1,24(sp)
    800035ee:	69a2                	ld	s3,8(sp)
    800035f0:	bf75                	j	800035ac <fileread+0x58>
    panic("fileread");
    800035f2:	00004517          	auipc	a0,0x4
    800035f6:	f8650513          	addi	a0,a0,-122 # 80007578 <etext+0x578>
    800035fa:	044020ef          	jal	8000563e <panic>
    return -1;
    800035fe:	57fd                	li	a5,-1
    80003600:	893e                	mv	s2,a5
    80003602:	b76d                	j	800035ac <fileread+0x58>
      return -1;
    80003604:	57fd                	li	a5,-1
    80003606:	893e                	mv	s2,a5
    80003608:	64e2                	ld	s1,24(sp)
    8000360a:	69a2                	ld	s3,8(sp)
    8000360c:	b745                	j	800035ac <fileread+0x58>
    8000360e:	57fd                	li	a5,-1
    80003610:	893e                	mv	s2,a5
    80003612:	64e2                	ld	s1,24(sp)
    80003614:	69a2                	ld	s3,8(sp)
    80003616:	bf59                	j	800035ac <fileread+0x58>

0000000080003618 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003618:	00954783          	lbu	a5,9(a0)
    8000361c:	10078f63          	beqz	a5,8000373a <filewrite+0x122>
{
    80003620:	711d                	addi	sp,sp,-96
    80003622:	ec86                	sd	ra,88(sp)
    80003624:	e8a2                	sd	s0,80(sp)
    80003626:	e0ca                	sd	s2,64(sp)
    80003628:	f456                	sd	s5,40(sp)
    8000362a:	f05a                	sd	s6,32(sp)
    8000362c:	1080                	addi	s0,sp,96
    8000362e:	892a                	mv	s2,a0
    80003630:	8b2e                	mv	s6,a1
    80003632:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003634:	411c                	lw	a5,0(a0)
    80003636:	4705                	li	a4,1
    80003638:	02e78a63          	beq	a5,a4,8000366c <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000363c:	470d                	li	a4,3
    8000363e:	02e78b63          	beq	a5,a4,80003674 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003642:	4709                	li	a4,2
    80003644:	0ce79f63          	bne	a5,a4,80003722 <filewrite+0x10a>
    80003648:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000364a:	0ac05a63          	blez	a2,800036fe <filewrite+0xe6>
    8000364e:	e4a6                	sd	s1,72(sp)
    80003650:	fc4e                	sd	s3,56(sp)
    80003652:	ec5e                	sd	s7,24(sp)
    80003654:	e862                	sd	s8,16(sp)
    80003656:	e466                	sd	s9,8(sp)
    int i = 0;
    80003658:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000365a:	6b85                	lui	s7,0x1
    8000365c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003660:	6785                	lui	a5,0x1
    80003662:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003666:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003668:	4c05                	li	s8,1
    8000366a:	a8ad                	j	800036e4 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000366c:	6908                	ld	a0,16(a0)
    8000366e:	204000ef          	jal	80003872 <pipewrite>
    80003672:	a04d                	j	80003714 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003674:	02451783          	lh	a5,36(a0)
    80003678:	03079693          	slli	a3,a5,0x30
    8000367c:	92c1                	srli	a3,a3,0x30
    8000367e:	4725                	li	a4,9
    80003680:	0ad76f63          	bltu	a4,a3,8000373e <filewrite+0x126>
    80003684:	0792                	slli	a5,a5,0x4
    80003686:	00017717          	auipc	a4,0x17
    8000368a:	d1270713          	addi	a4,a4,-750 # 8001a398 <devsw>
    8000368e:	97ba                	add	a5,a5,a4
    80003690:	679c                	ld	a5,8(a5)
    80003692:	cbc5                	beqz	a5,80003742 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003694:	4505                	li	a0,1
    80003696:	9782                	jalr	a5
    80003698:	a8b5                	j	80003714 <filewrite+0xfc>
      if(n1 > max)
    8000369a:	2981                	sext.w	s3,s3
      begin_op();
    8000369c:	961ff0ef          	jal	80002ffc <begin_op>
      ilock(f->ip);
    800036a0:	01893503          	ld	a0,24(s2)
    800036a4:	898ff0ef          	jal	8000273c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036a8:	874e                	mv	a4,s3
    800036aa:	02092683          	lw	a3,32(s2)
    800036ae:	016a0633          	add	a2,s4,s6
    800036b2:	85e2                	mv	a1,s8
    800036b4:	01893503          	ld	a0,24(s2)
    800036b8:	bd8ff0ef          	jal	80002a90 <writei>
    800036bc:	84aa                	mv	s1,a0
    800036be:	00a05763          	blez	a0,800036cc <filewrite+0xb4>
        f->off += r;
    800036c2:	02092783          	lw	a5,32(s2)
    800036c6:	9fa9                	addw	a5,a5,a0
    800036c8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036cc:	01893503          	ld	a0,24(s2)
    800036d0:	91aff0ef          	jal	800027ea <iunlock>
      end_op();
    800036d4:	999ff0ef          	jal	8000306c <end_op>

      if(r != n1){
    800036d8:	02999563          	bne	s3,s1,80003702 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800036dc:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800036e0:	015a5963          	bge	s4,s5,800036f2 <filewrite+0xda>
      int n1 = n - i;
    800036e4:	414a87bb          	subw	a5,s5,s4
    800036e8:	89be                	mv	s3,a5
      if(n1 > max)
    800036ea:	fafbd8e3          	bge	s7,a5,8000369a <filewrite+0x82>
    800036ee:	89e6                	mv	s3,s9
    800036f0:	b76d                	j	8000369a <filewrite+0x82>
    800036f2:	64a6                	ld	s1,72(sp)
    800036f4:	79e2                	ld	s3,56(sp)
    800036f6:	6be2                	ld	s7,24(sp)
    800036f8:	6c42                	ld	s8,16(sp)
    800036fa:	6ca2                	ld	s9,8(sp)
    800036fc:	a801                	j	8000370c <filewrite+0xf4>
    int i = 0;
    800036fe:	4a01                	li	s4,0
    80003700:	a031                	j	8000370c <filewrite+0xf4>
    80003702:	64a6                	ld	s1,72(sp)
    80003704:	79e2                	ld	s3,56(sp)
    80003706:	6be2                	ld	s7,24(sp)
    80003708:	6c42                	ld	s8,16(sp)
    8000370a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000370c:	034a9d63          	bne	s5,s4,80003746 <filewrite+0x12e>
    80003710:	8556                	mv	a0,s5
    80003712:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003714:	60e6                	ld	ra,88(sp)
    80003716:	6446                	ld	s0,80(sp)
    80003718:	6906                	ld	s2,64(sp)
    8000371a:	7aa2                	ld	s5,40(sp)
    8000371c:	7b02                	ld	s6,32(sp)
    8000371e:	6125                	addi	sp,sp,96
    80003720:	8082                	ret
    80003722:	e4a6                	sd	s1,72(sp)
    80003724:	fc4e                	sd	s3,56(sp)
    80003726:	f852                	sd	s4,48(sp)
    80003728:	ec5e                	sd	s7,24(sp)
    8000372a:	e862                	sd	s8,16(sp)
    8000372c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000372e:	00004517          	auipc	a0,0x4
    80003732:	e5a50513          	addi	a0,a0,-422 # 80007588 <etext+0x588>
    80003736:	709010ef          	jal	8000563e <panic>
    return -1;
    8000373a:	557d                	li	a0,-1
}
    8000373c:	8082                	ret
      return -1;
    8000373e:	557d                	li	a0,-1
    80003740:	bfd1                	j	80003714 <filewrite+0xfc>
    80003742:	557d                	li	a0,-1
    80003744:	bfc1                	j	80003714 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003746:	557d                	li	a0,-1
    80003748:	7a42                	ld	s4,48(sp)
    8000374a:	b7e9                	j	80003714 <filewrite+0xfc>

000000008000374c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000374c:	7179                	addi	sp,sp,-48
    8000374e:	f406                	sd	ra,40(sp)
    80003750:	f022                	sd	s0,32(sp)
    80003752:	ec26                	sd	s1,24(sp)
    80003754:	e052                	sd	s4,0(sp)
    80003756:	1800                	addi	s0,sp,48
    80003758:	84aa                	mv	s1,a0
    8000375a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000375c:	0005b023          	sd	zero,0(a1)
    80003760:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003764:	c27ff0ef          	jal	8000338a <filealloc>
    80003768:	e088                	sd	a0,0(s1)
    8000376a:	c549                	beqz	a0,800037f4 <pipealloc+0xa8>
    8000376c:	c1fff0ef          	jal	8000338a <filealloc>
    80003770:	00aa3023          	sd	a0,0(s4)
    80003774:	cd25                	beqz	a0,800037ec <pipealloc+0xa0>
    80003776:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003778:	98dfc0ef          	jal	80000104 <kalloc>
    8000377c:	892a                	mv	s2,a0
    8000377e:	c12d                	beqz	a0,800037e0 <pipealloc+0x94>
    80003780:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003782:	4985                	li	s3,1
    80003784:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003788:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000378c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003790:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003794:	00004597          	auipc	a1,0x4
    80003798:	e0458593          	addi	a1,a1,-508 # 80007598 <etext+0x598>
    8000379c:	156020ef          	jal	800058f2 <initlock>
  (*f0)->type = FD_PIPE;
    800037a0:	609c                	ld	a5,0(s1)
    800037a2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037a6:	609c                	ld	a5,0(s1)
    800037a8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037ac:	609c                	ld	a5,0(s1)
    800037ae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037b2:	609c                	ld	a5,0(s1)
    800037b4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800037b8:	000a3783          	ld	a5,0(s4)
    800037bc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037c0:	000a3783          	ld	a5,0(s4)
    800037c4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037c8:	000a3783          	ld	a5,0(s4)
    800037cc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037d0:	000a3783          	ld	a5,0(s4)
    800037d4:	0127b823          	sd	s2,16(a5)
  return 0;
    800037d8:	4501                	li	a0,0
    800037da:	6942                	ld	s2,16(sp)
    800037dc:	69a2                	ld	s3,8(sp)
    800037de:	a01d                	j	80003804 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037e0:	6088                	ld	a0,0(s1)
    800037e2:	c119                	beqz	a0,800037e8 <pipealloc+0x9c>
    800037e4:	6942                	ld	s2,16(sp)
    800037e6:	a029                	j	800037f0 <pipealloc+0xa4>
    800037e8:	6942                	ld	s2,16(sp)
    800037ea:	a029                	j	800037f4 <pipealloc+0xa8>
    800037ec:	6088                	ld	a0,0(s1)
    800037ee:	c10d                	beqz	a0,80003810 <pipealloc+0xc4>
    fileclose(*f0);
    800037f0:	c3fff0ef          	jal	8000342e <fileclose>
  if(*f1)
    800037f4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037f8:	557d                	li	a0,-1
  if(*f1)
    800037fa:	c789                	beqz	a5,80003804 <pipealloc+0xb8>
    fileclose(*f1);
    800037fc:	853e                	mv	a0,a5
    800037fe:	c31ff0ef          	jal	8000342e <fileclose>
  return -1;
    80003802:	557d                	li	a0,-1
}
    80003804:	70a2                	ld	ra,40(sp)
    80003806:	7402                	ld	s0,32(sp)
    80003808:	64e2                	ld	s1,24(sp)
    8000380a:	6a02                	ld	s4,0(sp)
    8000380c:	6145                	addi	sp,sp,48
    8000380e:	8082                	ret
  return -1;
    80003810:	557d                	li	a0,-1
    80003812:	bfcd                	j	80003804 <pipealloc+0xb8>

0000000080003814 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003814:	1101                	addi	sp,sp,-32
    80003816:	ec06                	sd	ra,24(sp)
    80003818:	e822                	sd	s0,16(sp)
    8000381a:	e426                	sd	s1,8(sp)
    8000381c:	e04a                	sd	s2,0(sp)
    8000381e:	1000                	addi	s0,sp,32
    80003820:	84aa                	mv	s1,a0
    80003822:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003824:	158020ef          	jal	8000597c <acquire>
  if(writable){
    80003828:	02090763          	beqz	s2,80003856 <pipeclose+0x42>
    pi->writeopen = 0;
    8000382c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003830:	21848513          	addi	a0,s1,536
    80003834:	b7dfd0ef          	jal	800013b0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003838:	2204a783          	lw	a5,544(s1)
    8000383c:	e781                	bnez	a5,80003844 <pipeclose+0x30>
    8000383e:	2244a783          	lw	a5,548(s1)
    80003842:	c38d                	beqz	a5,80003864 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003844:	8526                	mv	a0,s1
    80003846:	1ca020ef          	jal	80005a10 <release>
}
    8000384a:	60e2                	ld	ra,24(sp)
    8000384c:	6442                	ld	s0,16(sp)
    8000384e:	64a2                	ld	s1,8(sp)
    80003850:	6902                	ld	s2,0(sp)
    80003852:	6105                	addi	sp,sp,32
    80003854:	8082                	ret
    pi->readopen = 0;
    80003856:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000385a:	21c48513          	addi	a0,s1,540
    8000385e:	b53fd0ef          	jal	800013b0 <wakeup>
    80003862:	bfd9                	j	80003838 <pipeclose+0x24>
    release(&pi->lock);
    80003864:	8526                	mv	a0,s1
    80003866:	1aa020ef          	jal	80005a10 <release>
    kfree((char*)pi);
    8000386a:	8526                	mv	a0,s1
    8000386c:	fb0fc0ef          	jal	8000001c <kfree>
    80003870:	bfe9                	j	8000384a <pipeclose+0x36>

0000000080003872 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003872:	7159                	addi	sp,sp,-112
    80003874:	f486                	sd	ra,104(sp)
    80003876:	f0a2                	sd	s0,96(sp)
    80003878:	eca6                	sd	s1,88(sp)
    8000387a:	e8ca                	sd	s2,80(sp)
    8000387c:	e4ce                	sd	s3,72(sp)
    8000387e:	e0d2                	sd	s4,64(sp)
    80003880:	fc56                	sd	s5,56(sp)
    80003882:	1880                	addi	s0,sp,112
    80003884:	84aa                	mv	s1,a0
    80003886:	8aae                	mv	s5,a1
    80003888:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000388a:	cfcfd0ef          	jal	80000d86 <myproc>
    8000388e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003890:	8526                	mv	a0,s1
    80003892:	0ea020ef          	jal	8000597c <acquire>
  while(i < n){
    80003896:	0d405263          	blez	s4,8000395a <pipewrite+0xe8>
    8000389a:	f85a                	sd	s6,48(sp)
    8000389c:	f45e                	sd	s7,40(sp)
    8000389e:	f062                	sd	s8,32(sp)
    800038a0:	ec66                	sd	s9,24(sp)
    800038a2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800038a4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038a6:	f9f40c13          	addi	s8,s0,-97
    800038aa:	4b85                	li	s7,1
    800038ac:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038ae:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038b2:	21c48c93          	addi	s9,s1,540
    800038b6:	a82d                	j	800038f0 <pipewrite+0x7e>
      release(&pi->lock);
    800038b8:	8526                	mv	a0,s1
    800038ba:	156020ef          	jal	80005a10 <release>
      return -1;
    800038be:	597d                	li	s2,-1
    800038c0:	7b42                	ld	s6,48(sp)
    800038c2:	7ba2                	ld	s7,40(sp)
    800038c4:	7c02                	ld	s8,32(sp)
    800038c6:	6ce2                	ld	s9,24(sp)
    800038c8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038ca:	854a                	mv	a0,s2
    800038cc:	70a6                	ld	ra,104(sp)
    800038ce:	7406                	ld	s0,96(sp)
    800038d0:	64e6                	ld	s1,88(sp)
    800038d2:	6946                	ld	s2,80(sp)
    800038d4:	69a6                	ld	s3,72(sp)
    800038d6:	6a06                	ld	s4,64(sp)
    800038d8:	7ae2                	ld	s5,56(sp)
    800038da:	6165                	addi	sp,sp,112
    800038dc:	8082                	ret
      wakeup(&pi->nread);
    800038de:	856a                	mv	a0,s10
    800038e0:	ad1fd0ef          	jal	800013b0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038e4:	85a6                	mv	a1,s1
    800038e6:	8566                	mv	a0,s9
    800038e8:	a7dfd0ef          	jal	80001364 <sleep>
  while(i < n){
    800038ec:	05495a63          	bge	s2,s4,80003940 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800038f0:	2204a783          	lw	a5,544(s1)
    800038f4:	d3f1                	beqz	a5,800038b8 <pipewrite+0x46>
    800038f6:	854e                	mv	a0,s3
    800038f8:	ca9fd0ef          	jal	800015a0 <killed>
    800038fc:	fd55                	bnez	a0,800038b8 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038fe:	2184a783          	lw	a5,536(s1)
    80003902:	21c4a703          	lw	a4,540(s1)
    80003906:	2007879b          	addiw	a5,a5,512
    8000390a:	fcf70ae3          	beq	a4,a5,800038de <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000390e:	86de                	mv	a3,s7
    80003910:	01590633          	add	a2,s2,s5
    80003914:	85e2                	mv	a1,s8
    80003916:	0509b503          	ld	a0,80(s3)
    8000391a:	998fd0ef          	jal	80000ab2 <copyin>
    8000391e:	05650063          	beq	a0,s6,8000395e <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003922:	21c4a783          	lw	a5,540(s1)
    80003926:	0017871b          	addiw	a4,a5,1
    8000392a:	20e4ae23          	sw	a4,540(s1)
    8000392e:	1ff7f793          	andi	a5,a5,511
    80003932:	97a6                	add	a5,a5,s1
    80003934:	f9f44703          	lbu	a4,-97(s0)
    80003938:	00e78c23          	sb	a4,24(a5)
      i++;
    8000393c:	2905                	addiw	s2,s2,1
    8000393e:	b77d                	j	800038ec <pipewrite+0x7a>
    80003940:	7b42                	ld	s6,48(sp)
    80003942:	7ba2                	ld	s7,40(sp)
    80003944:	7c02                	ld	s8,32(sp)
    80003946:	6ce2                	ld	s9,24(sp)
    80003948:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000394a:	21848513          	addi	a0,s1,536
    8000394e:	a63fd0ef          	jal	800013b0 <wakeup>
  release(&pi->lock);
    80003952:	8526                	mv	a0,s1
    80003954:	0bc020ef          	jal	80005a10 <release>
  return i;
    80003958:	bf8d                	j	800038ca <pipewrite+0x58>
  int i = 0;
    8000395a:	4901                	li	s2,0
    8000395c:	b7fd                	j	8000394a <pipewrite+0xd8>
    8000395e:	7b42                	ld	s6,48(sp)
    80003960:	7ba2                	ld	s7,40(sp)
    80003962:	7c02                	ld	s8,32(sp)
    80003964:	6ce2                	ld	s9,24(sp)
    80003966:	6d42                	ld	s10,16(sp)
    80003968:	b7cd                	j	8000394a <pipewrite+0xd8>

000000008000396a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000396a:	711d                	addi	sp,sp,-96
    8000396c:	ec86                	sd	ra,88(sp)
    8000396e:	e8a2                	sd	s0,80(sp)
    80003970:	e4a6                	sd	s1,72(sp)
    80003972:	e0ca                	sd	s2,64(sp)
    80003974:	fc4e                	sd	s3,56(sp)
    80003976:	f852                	sd	s4,48(sp)
    80003978:	f456                	sd	s5,40(sp)
    8000397a:	1080                	addi	s0,sp,96
    8000397c:	84aa                	mv	s1,a0
    8000397e:	892e                	mv	s2,a1
    80003980:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003982:	c04fd0ef          	jal	80000d86 <myproc>
    80003986:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003988:	8526                	mv	a0,s1
    8000398a:	7f3010ef          	jal	8000597c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000398e:	2184a703          	lw	a4,536(s1)
    80003992:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003996:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000399a:	02f71763          	bne	a4,a5,800039c8 <piperead+0x5e>
    8000399e:	2244a783          	lw	a5,548(s1)
    800039a2:	cf85                	beqz	a5,800039da <piperead+0x70>
    if(killed(pr)){
    800039a4:	8552                	mv	a0,s4
    800039a6:	bfbfd0ef          	jal	800015a0 <killed>
    800039aa:	e11d                	bnez	a0,800039d0 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039ac:	85a6                	mv	a1,s1
    800039ae:	854e                	mv	a0,s3
    800039b0:	9b5fd0ef          	jal	80001364 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039b4:	2184a703          	lw	a4,536(s1)
    800039b8:	21c4a783          	lw	a5,540(s1)
    800039bc:	fef701e3          	beq	a4,a5,8000399e <piperead+0x34>
    800039c0:	f05a                	sd	s6,32(sp)
    800039c2:	ec5e                	sd	s7,24(sp)
    800039c4:	e862                	sd	s8,16(sp)
    800039c6:	a829                	j	800039e0 <piperead+0x76>
    800039c8:	f05a                	sd	s6,32(sp)
    800039ca:	ec5e                	sd	s7,24(sp)
    800039cc:	e862                	sd	s8,16(sp)
    800039ce:	a809                	j	800039e0 <piperead+0x76>
      release(&pi->lock);
    800039d0:	8526                	mv	a0,s1
    800039d2:	03e020ef          	jal	80005a10 <release>
      return -1;
    800039d6:	59fd                	li	s3,-1
    800039d8:	a09d                	j	80003a3e <piperead+0xd4>
    800039da:	f05a                	sd	s6,32(sp)
    800039dc:	ec5e                	sd	s7,24(sp)
    800039de:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039e0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039e2:	faf40c13          	addi	s8,s0,-81
    800039e6:	4b85                	li	s7,1
    800039e8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039ea:	05505063          	blez	s5,80003a2a <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    800039ee:	2184a783          	lw	a5,536(s1)
    800039f2:	21c4a703          	lw	a4,540(s1)
    800039f6:	02f70a63          	beq	a4,a5,80003a2a <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039fa:	0017871b          	addiw	a4,a5,1
    800039fe:	20e4ac23          	sw	a4,536(s1)
    80003a02:	1ff7f793          	andi	a5,a5,511
    80003a06:	97a6                	add	a5,a5,s1
    80003a08:	0187c783          	lbu	a5,24(a5)
    80003a0c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a10:	86de                	mv	a3,s7
    80003a12:	8662                	mv	a2,s8
    80003a14:	85ca                	mv	a1,s2
    80003a16:	050a3503          	ld	a0,80(s4)
    80003a1a:	fe9fc0ef          	jal	80000a02 <copyout>
    80003a1e:	01650663          	beq	a0,s6,80003a2a <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a22:	2985                	addiw	s3,s3,1
    80003a24:	0905                	addi	s2,s2,1
    80003a26:	fd3a94e3          	bne	s5,s3,800039ee <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a2a:	21c48513          	addi	a0,s1,540
    80003a2e:	983fd0ef          	jal	800013b0 <wakeup>
  release(&pi->lock);
    80003a32:	8526                	mv	a0,s1
    80003a34:	7dd010ef          	jal	80005a10 <release>
    80003a38:	7b02                	ld	s6,32(sp)
    80003a3a:	6be2                	ld	s7,24(sp)
    80003a3c:	6c42                	ld	s8,16(sp)
  return i;
}
    80003a3e:	854e                	mv	a0,s3
    80003a40:	60e6                	ld	ra,88(sp)
    80003a42:	6446                	ld	s0,80(sp)
    80003a44:	64a6                	ld	s1,72(sp)
    80003a46:	6906                	ld	s2,64(sp)
    80003a48:	79e2                	ld	s3,56(sp)
    80003a4a:	7a42                	ld	s4,48(sp)
    80003a4c:	7aa2                	ld	s5,40(sp)
    80003a4e:	6125                	addi	sp,sp,96
    80003a50:	8082                	ret

0000000080003a52 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a52:	1141                	addi	sp,sp,-16
    80003a54:	e406                	sd	ra,8(sp)
    80003a56:	e022                	sd	s0,0(sp)
    80003a58:	0800                	addi	s0,sp,16
    80003a5a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a5c:	0035151b          	slliw	a0,a0,0x3
    80003a60:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003a62:	8b89                	andi	a5,a5,2
    80003a64:	c399                	beqz	a5,80003a6a <flags2perm+0x18>
      perm |= PTE_W;
    80003a66:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a6a:	60a2                	ld	ra,8(sp)
    80003a6c:	6402                	ld	s0,0(sp)
    80003a6e:	0141                	addi	sp,sp,16
    80003a70:	8082                	ret

0000000080003a72 <exec>:

int
exec(char *path, char **argv)
{
    80003a72:	de010113          	addi	sp,sp,-544
    80003a76:	20113c23          	sd	ra,536(sp)
    80003a7a:	20813823          	sd	s0,528(sp)
    80003a7e:	20913423          	sd	s1,520(sp)
    80003a82:	21213023          	sd	s2,512(sp)
    80003a86:	1400                	addi	s0,sp,544
    80003a88:	892a                	mv	s2,a0
    80003a8a:	dea43823          	sd	a0,-528(s0)
    80003a8e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a92:	af4fd0ef          	jal	80000d86 <myproc>
    80003a96:	84aa                	mv	s1,a0

  begin_op();
    80003a98:	d64ff0ef          	jal	80002ffc <begin_op>

  if((ip = namei(path)) == 0){
    80003a9c:	854a                	mv	a0,s2
    80003a9e:	b9cff0ef          	jal	80002e3a <namei>
    80003aa2:	cd21                	beqz	a0,80003afa <exec+0x88>
    80003aa4:	fbd2                	sd	s4,496(sp)
    80003aa6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003aa8:	c95fe0ef          	jal	8000273c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003aac:	04000713          	li	a4,64
    80003ab0:	4681                	li	a3,0
    80003ab2:	e5040613          	addi	a2,s0,-432
    80003ab6:	4581                	li	a1,0
    80003ab8:	8552                	mv	a0,s4
    80003aba:	ee5fe0ef          	jal	8000299e <readi>
    80003abe:	04000793          	li	a5,64
    80003ac2:	00f51a63          	bne	a0,a5,80003ad6 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003ac6:	e5042703          	lw	a4,-432(s0)
    80003aca:	464c47b7          	lui	a5,0x464c4
    80003ace:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ad2:	02f70863          	beq	a4,a5,80003b02 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ad6:	8552                	mv	a0,s4
    80003ad8:	e71fe0ef          	jal	80002948 <iunlockput>
    end_op();
    80003adc:	d90ff0ef          	jal	8000306c <end_op>
  }
  return -1;
    80003ae0:	557d                	li	a0,-1
    80003ae2:	7a5e                	ld	s4,496(sp)
}
    80003ae4:	21813083          	ld	ra,536(sp)
    80003ae8:	21013403          	ld	s0,528(sp)
    80003aec:	20813483          	ld	s1,520(sp)
    80003af0:	20013903          	ld	s2,512(sp)
    80003af4:	22010113          	addi	sp,sp,544
    80003af8:	8082                	ret
    end_op();
    80003afa:	d72ff0ef          	jal	8000306c <end_op>
    return -1;
    80003afe:	557d                	li	a0,-1
    80003b00:	b7d5                	j	80003ae4 <exec+0x72>
    80003b02:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b04:	8526                	mv	a0,s1
    80003b06:	b2afd0ef          	jal	80000e30 <proc_pagetable>
    80003b0a:	8b2a                	mv	s6,a0
    80003b0c:	26050d63          	beqz	a0,80003d86 <exec+0x314>
    80003b10:	ffce                	sd	s3,504(sp)
    80003b12:	f7d6                	sd	s5,488(sp)
    80003b14:	efde                	sd	s7,472(sp)
    80003b16:	ebe2                	sd	s8,464(sp)
    80003b18:	e7e6                	sd	s9,456(sp)
    80003b1a:	e3ea                	sd	s10,448(sp)
    80003b1c:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b1e:	e8845783          	lhu	a5,-376(s0)
    80003b22:	0e078963          	beqz	a5,80003c14 <exec+0x1a2>
    80003b26:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b2a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2c:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b2e:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003b32:	6c85                	lui	s9,0x1
    80003b34:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b38:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b3c:	6a85                	lui	s5,0x1
    80003b3e:	a085                	j	80003b9e <exec+0x12c>
      panic("loadseg: address should exist");
    80003b40:	00004517          	auipc	a0,0x4
    80003b44:	a6050513          	addi	a0,a0,-1440 # 800075a0 <etext+0x5a0>
    80003b48:	2f7010ef          	jal	8000563e <panic>
    if(sz - i < PGSIZE)
    80003b4c:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b4e:	874a                	mv	a4,s2
    80003b50:	009b86bb          	addw	a3,s7,s1
    80003b54:	4581                	li	a1,0
    80003b56:	8552                	mv	a0,s4
    80003b58:	e47fe0ef          	jal	8000299e <readi>
    80003b5c:	22a91963          	bne	s2,a0,80003d8e <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b60:	009a84bb          	addw	s1,s5,s1
    80003b64:	0334f263          	bgeu	s1,s3,80003b88 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003b68:	02049593          	slli	a1,s1,0x20
    80003b6c:	9181                	srli	a1,a1,0x20
    80003b6e:	95e2                	add	a1,a1,s8
    80003b70:	855a                	mv	a0,s6
    80003b72:	91bfc0ef          	jal	8000048c <walkaddr>
    80003b76:	862a                	mv	a2,a0
    if(pa == 0)
    80003b78:	d561                	beqz	a0,80003b40 <exec+0xce>
    if(sz - i < PGSIZE)
    80003b7a:	409987bb          	subw	a5,s3,s1
    80003b7e:	893e                	mv	s2,a5
    80003b80:	fcfcf6e3          	bgeu	s9,a5,80003b4c <exec+0xda>
    80003b84:	8956                	mv	s2,s5
    80003b86:	b7d9                	j	80003b4c <exec+0xda>
    sz = sz1;
    80003b88:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b8c:	2d05                	addiw	s10,s10,1
    80003b8e:	e0843783          	ld	a5,-504(s0)
    80003b92:	0387869b          	addiw	a3,a5,56
    80003b96:	e8845783          	lhu	a5,-376(s0)
    80003b9a:	06fd5e63          	bge	s10,a5,80003c16 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b9e:	e0d43423          	sd	a3,-504(s0)
    80003ba2:	876e                	mv	a4,s11
    80003ba4:	e1840613          	addi	a2,s0,-488
    80003ba8:	4581                	li	a1,0
    80003baa:	8552                	mv	a0,s4
    80003bac:	df3fe0ef          	jal	8000299e <readi>
    80003bb0:	1db51d63          	bne	a0,s11,80003d8a <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003bb4:	e1842783          	lw	a5,-488(s0)
    80003bb8:	4705                	li	a4,1
    80003bba:	fce799e3          	bne	a5,a4,80003b8c <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003bbe:	e4043483          	ld	s1,-448(s0)
    80003bc2:	e3843783          	ld	a5,-456(s0)
    80003bc6:	1ef4e263          	bltu	s1,a5,80003daa <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bca:	e2843783          	ld	a5,-472(s0)
    80003bce:	94be                	add	s1,s1,a5
    80003bd0:	1ef4e063          	bltu	s1,a5,80003db0 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003bd4:	de843703          	ld	a4,-536(s0)
    80003bd8:	8ff9                	and	a5,a5,a4
    80003bda:	1c079e63          	bnez	a5,80003db6 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bde:	e1c42503          	lw	a0,-484(s0)
    80003be2:	e71ff0ef          	jal	80003a52 <flags2perm>
    80003be6:	86aa                	mv	a3,a0
    80003be8:	8626                	mv	a2,s1
    80003bea:	85ca                	mv	a1,s2
    80003bec:	855a                	mv	a0,s6
    80003bee:	c05fc0ef          	jal	800007f2 <uvmalloc>
    80003bf2:	dea43c23          	sd	a0,-520(s0)
    80003bf6:	1c050363          	beqz	a0,80003dbc <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003bfa:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bfe:	00098863          	beqz	s3,80003c0e <exec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c02:	e2843c03          	ld	s8,-472(s0)
    80003c06:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c0a:	4481                	li	s1,0
    80003c0c:	bfb1                	j	80003b68 <exec+0xf6>
    sz = sz1;
    80003c0e:	df843903          	ld	s2,-520(s0)
    80003c12:	bfad                	j	80003b8c <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c14:	4901                	li	s2,0
  iunlockput(ip);
    80003c16:	8552                	mv	a0,s4
    80003c18:	d31fe0ef          	jal	80002948 <iunlockput>
  end_op();
    80003c1c:	c50ff0ef          	jal	8000306c <end_op>
  p = myproc();
    80003c20:	966fd0ef          	jal	80000d86 <myproc>
    80003c24:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c26:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003c2a:	6985                	lui	s3,0x1
    80003c2c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c2e:	99ca                	add	s3,s3,s2
    80003c30:	77fd                	lui	a5,0xfffff
    80003c32:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c36:	4691                	li	a3,4
    80003c38:	660d                	lui	a2,0x3
    80003c3a:	964e                	add	a2,a2,s3
    80003c3c:	85ce                	mv	a1,s3
    80003c3e:	855a                	mv	a0,s6
    80003c40:	bb3fc0ef          	jal	800007f2 <uvmalloc>
    80003c44:	8a2a                	mv	s4,a0
    80003c46:	e105                	bnez	a0,80003c66 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003c48:	85ce                	mv	a1,s3
    80003c4a:	855a                	mv	a0,s6
    80003c4c:	a68fd0ef          	jal	80000eb4 <proc_freepagetable>
  return -1;
    80003c50:	557d                	li	a0,-1
    80003c52:	79fe                	ld	s3,504(sp)
    80003c54:	7a5e                	ld	s4,496(sp)
    80003c56:	7abe                	ld	s5,488(sp)
    80003c58:	7b1e                	ld	s6,480(sp)
    80003c5a:	6bfe                	ld	s7,472(sp)
    80003c5c:	6c5e                	ld	s8,464(sp)
    80003c5e:	6cbe                	ld	s9,456(sp)
    80003c60:	6d1e                	ld	s10,448(sp)
    80003c62:	7dfa                	ld	s11,440(sp)
    80003c64:	b541                	j	80003ae4 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c66:	75f5                	lui	a1,0xffffd
    80003c68:	95aa                	add	a1,a1,a0
    80003c6a:	855a                	mv	a0,s6
    80003c6c:	d6dfc0ef          	jal	800009d8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c70:	7bf9                	lui	s7,0xffffe
    80003c72:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c74:	e0043783          	ld	a5,-512(s0)
    80003c78:	6388                	ld	a0,0(a5)
  sp = sz;
    80003c7a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c7c:	4481                	li	s1,0
    ustack[argc] = sp;
    80003c7e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003c82:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003c86:	cd21                	beqz	a0,80003cde <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003c88:	e60fc0ef          	jal	800002e8 <strlen>
    80003c8c:	0015079b          	addiw	a5,a0,1
    80003c90:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c94:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c98:	13796563          	bltu	s2,s7,80003dc2 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c9c:	e0043d83          	ld	s11,-512(s0)
    80003ca0:	000db983          	ld	s3,0(s11)
    80003ca4:	854e                	mv	a0,s3
    80003ca6:	e42fc0ef          	jal	800002e8 <strlen>
    80003caa:	0015069b          	addiw	a3,a0,1
    80003cae:	864e                	mv	a2,s3
    80003cb0:	85ca                	mv	a1,s2
    80003cb2:	855a                	mv	a0,s6
    80003cb4:	d4ffc0ef          	jal	80000a02 <copyout>
    80003cb8:	10054763          	bltz	a0,80003dc6 <exec+0x354>
    ustack[argc] = sp;
    80003cbc:	00349793          	slli	a5,s1,0x3
    80003cc0:	97e6                	add	a5,a5,s9
    80003cc2:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb9d0>
  for(argc = 0; argv[argc]; argc++) {
    80003cc6:	0485                	addi	s1,s1,1
    80003cc8:	008d8793          	addi	a5,s11,8
    80003ccc:	e0f43023          	sd	a5,-512(s0)
    80003cd0:	008db503          	ld	a0,8(s11)
    80003cd4:	c509                	beqz	a0,80003cde <exec+0x26c>
    if(argc >= MAXARG)
    80003cd6:	fb8499e3          	bne	s1,s8,80003c88 <exec+0x216>
  sz = sz1;
    80003cda:	89d2                	mv	s3,s4
    80003cdc:	b7b5                	j	80003c48 <exec+0x1d6>
  ustack[argc] = 0;
    80003cde:	00349793          	slli	a5,s1,0x3
    80003ce2:	f9078793          	addi	a5,a5,-112
    80003ce6:	97a2                	add	a5,a5,s0
    80003ce8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cec:	00349693          	slli	a3,s1,0x3
    80003cf0:	06a1                	addi	a3,a3,8
    80003cf2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cf6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cfa:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003cfc:	f57966e3          	bltu	s2,s7,80003c48 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d00:	e9040613          	addi	a2,s0,-368
    80003d04:	85ca                	mv	a1,s2
    80003d06:	855a                	mv	a0,s6
    80003d08:	cfbfc0ef          	jal	80000a02 <copyout>
    80003d0c:	f2054ee3          	bltz	a0,80003c48 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003d10:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d14:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d18:	df043783          	ld	a5,-528(s0)
    80003d1c:	0007c703          	lbu	a4,0(a5)
    80003d20:	cf11                	beqz	a4,80003d3c <exec+0x2ca>
    80003d22:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d24:	02f00693          	li	a3,47
    80003d28:	a029                	j	80003d32 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003d2a:	0785                	addi	a5,a5,1
    80003d2c:	fff7c703          	lbu	a4,-1(a5)
    80003d30:	c711                	beqz	a4,80003d3c <exec+0x2ca>
    if(*s == '/')
    80003d32:	fed71ce3          	bne	a4,a3,80003d2a <exec+0x2b8>
      last = s+1;
    80003d36:	def43823          	sd	a5,-528(s0)
    80003d3a:	bfc5                	j	80003d2a <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d3c:	4641                	li	a2,16
    80003d3e:	df043583          	ld	a1,-528(s0)
    80003d42:	158a8513          	addi	a0,s5,344
    80003d46:	d6cfc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d4a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d4e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d52:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d56:	058ab783          	ld	a5,88(s5)
    80003d5a:	e6843703          	ld	a4,-408(s0)
    80003d5e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d60:	058ab783          	ld	a5,88(s5)
    80003d64:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d68:	85ea                	mv	a1,s10
    80003d6a:	94afd0ef          	jal	80000eb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d6e:	0004851b          	sext.w	a0,s1
    80003d72:	79fe                	ld	s3,504(sp)
    80003d74:	7a5e                	ld	s4,496(sp)
    80003d76:	7abe                	ld	s5,488(sp)
    80003d78:	7b1e                	ld	s6,480(sp)
    80003d7a:	6bfe                	ld	s7,472(sp)
    80003d7c:	6c5e                	ld	s8,464(sp)
    80003d7e:	6cbe                	ld	s9,456(sp)
    80003d80:	6d1e                	ld	s10,448(sp)
    80003d82:	7dfa                	ld	s11,440(sp)
    80003d84:	b385                	j	80003ae4 <exec+0x72>
    80003d86:	7b1e                	ld	s6,480(sp)
    80003d88:	b3b9                	j	80003ad6 <exec+0x64>
    80003d8a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d8e:	df843583          	ld	a1,-520(s0)
    80003d92:	855a                	mv	a0,s6
    80003d94:	920fd0ef          	jal	80000eb4 <proc_freepagetable>
  if(ip){
    80003d98:	79fe                	ld	s3,504(sp)
    80003d9a:	7abe                	ld	s5,488(sp)
    80003d9c:	7b1e                	ld	s6,480(sp)
    80003d9e:	6bfe                	ld	s7,472(sp)
    80003da0:	6c5e                	ld	s8,464(sp)
    80003da2:	6cbe                	ld	s9,456(sp)
    80003da4:	6d1e                	ld	s10,448(sp)
    80003da6:	7dfa                	ld	s11,440(sp)
    80003da8:	b33d                	j	80003ad6 <exec+0x64>
    80003daa:	df243c23          	sd	s2,-520(s0)
    80003dae:	b7c5                	j	80003d8e <exec+0x31c>
    80003db0:	df243c23          	sd	s2,-520(s0)
    80003db4:	bfe9                	j	80003d8e <exec+0x31c>
    80003db6:	df243c23          	sd	s2,-520(s0)
    80003dba:	bfd1                	j	80003d8e <exec+0x31c>
    80003dbc:	df243c23          	sd	s2,-520(s0)
    80003dc0:	b7f9                	j	80003d8e <exec+0x31c>
  sz = sz1;
    80003dc2:	89d2                	mv	s3,s4
    80003dc4:	b551                	j	80003c48 <exec+0x1d6>
    80003dc6:	89d2                	mv	s3,s4
    80003dc8:	b541                	j	80003c48 <exec+0x1d6>

0000000080003dca <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dca:	7179                	addi	sp,sp,-48
    80003dcc:	f406                	sd	ra,40(sp)
    80003dce:	f022                	sd	s0,32(sp)
    80003dd0:	ec26                	sd	s1,24(sp)
    80003dd2:	e84a                	sd	s2,16(sp)
    80003dd4:	1800                	addi	s0,sp,48
    80003dd6:	892e                	mv	s2,a1
    80003dd8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003dda:	fdc40593          	addi	a1,s0,-36
    80003dde:	e75fd0ef          	jal	80001c52 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80003de2:	fdc42703          	lw	a4,-36(s0)
    80003de6:	47bd                	li	a5,15
    80003de8:	02e7ea63          	bltu	a5,a4,80003e1c <argfd+0x52>
    80003dec:	f9bfc0ef          	jal	80000d86 <myproc>
    80003df0:	fdc42703          	lw	a4,-36(s0)
    80003df4:	00371793          	slli	a5,a4,0x3
    80003df8:	0d078793          	addi	a5,a5,208
    80003dfc:	953e                	add	a0,a0,a5
    80003dfe:	611c                	ld	a5,0(a0)
    80003e00:	c385                	beqz	a5,80003e20 <argfd+0x56>
    return -1;
  if (pfd)
    80003e02:	00090463          	beqz	s2,80003e0a <argfd+0x40>
    *pfd = fd;
    80003e06:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80003e0a:	4501                	li	a0,0
  if (pf)
    80003e0c:	c091                	beqz	s1,80003e10 <argfd+0x46>
    *pf = f;
    80003e0e:	e09c                	sd	a5,0(s1)
}
    80003e10:	70a2                	ld	ra,40(sp)
    80003e12:	7402                	ld	s0,32(sp)
    80003e14:	64e2                	ld	s1,24(sp)
    80003e16:	6942                	ld	s2,16(sp)
    80003e18:	6145                	addi	sp,sp,48
    80003e1a:	8082                	ret
    return -1;
    80003e1c:	557d                	li	a0,-1
    80003e1e:	bfcd                	j	80003e10 <argfd+0x46>
    80003e20:	557d                	li	a0,-1
    80003e22:	b7fd                	j	80003e10 <argfd+0x46>

0000000080003e24 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e24:	1101                	addi	sp,sp,-32
    80003e26:	ec06                	sd	ra,24(sp)
    80003e28:	e822                	sd	s0,16(sp)
    80003e2a:	e426                	sd	s1,8(sp)
    80003e2c:	1000                	addi	s0,sp,32
    80003e2e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e30:	f57fc0ef          	jal	80000d86 <myproc>
    80003e34:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    80003e36:	0d050793          	addi	a5,a0,208
    80003e3a:	4501                	li	a0,0
    80003e3c:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80003e3e:	6398                	ld	a4,0(a5)
    80003e40:	cb19                	beqz	a4,80003e56 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++)
    80003e42:	2505                	addiw	a0,a0,1
    80003e44:	07a1                	addi	a5,a5,8
    80003e46:	fed51ce3          	bne	a0,a3,80003e3e <fdalloc+0x1a>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e4a:	557d                	li	a0,-1
}
    80003e4c:	60e2                	ld	ra,24(sp)
    80003e4e:	6442                	ld	s0,16(sp)
    80003e50:	64a2                	ld	s1,8(sp)
    80003e52:	6105                	addi	sp,sp,32
    80003e54:	8082                	ret
      p->ofile[fd] = f;
    80003e56:	00351793          	slli	a5,a0,0x3
    80003e5a:	0d078793          	addi	a5,a5,208
    80003e5e:	963e                	add	a2,a2,a5
    80003e60:	e204                	sd	s1,0(a2)
      return fd;
    80003e62:	b7ed                	j	80003e4c <fdalloc+0x28>

0000000080003e64 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80003e64:	715d                	addi	sp,sp,-80
    80003e66:	e486                	sd	ra,72(sp)
    80003e68:	e0a2                	sd	s0,64(sp)
    80003e6a:	fc26                	sd	s1,56(sp)
    80003e6c:	f84a                	sd	s2,48(sp)
    80003e6e:	f44e                	sd	s3,40(sp)
    80003e70:	f052                	sd	s4,32(sp)
    80003e72:	ec56                	sd	s5,24(sp)
    80003e74:	e85a                	sd	s6,16(sp)
    80003e76:	0880                	addi	s0,sp,80
    80003e78:	892e                	mv	s2,a1
    80003e7a:	8a2e                	mv	s4,a1
    80003e7c:	8ab2                	mv	s5,a2
    80003e7e:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80003e80:	fb040593          	addi	a1,s0,-80
    80003e84:	fd1fe0ef          	jal	80002e54 <nameiparent>
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	0c050e63          	beqz	a0,80003f66 <create+0x102>
    return 0;

  ilock(dp);
    80003e8e:	8affe0ef          	jal	8000273c <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80003e92:	4601                	li	a2,0
    80003e94:	fb040593          	addi	a1,s0,-80
    80003e98:	8526                	mv	a0,s1
    80003e9a:	d0dfe0ef          	jal	80002ba6 <dirlookup>
    80003e9e:	89aa                	mv	s3,a0
    80003ea0:	c131                	beqz	a0,80003ee4 <create+0x80>
  {
    iunlockput(dp);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	aa5fe0ef          	jal	80002948 <iunlockput>
    ilock(ip);
    80003ea8:	854e                	mv	a0,s3
    80003eaa:	893fe0ef          	jal	8000273c <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eae:	4789                	li	a5,2
    80003eb0:	02f91563          	bne	s2,a5,80003eda <create+0x76>
    80003eb4:	0449d783          	lhu	a5,68(s3)
    80003eb8:	37f9                	addiw	a5,a5,-2
    80003eba:	17c2                	slli	a5,a5,0x30
    80003ebc:	93c1                	srli	a5,a5,0x30
    80003ebe:	4705                	li	a4,1
    80003ec0:	00f76d63          	bltu	a4,a5,80003eda <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ec4:	854e                	mv	a0,s3
    80003ec6:	60a6                	ld	ra,72(sp)
    80003ec8:	6406                	ld	s0,64(sp)
    80003eca:	74e2                	ld	s1,56(sp)
    80003ecc:	7942                	ld	s2,48(sp)
    80003ece:	79a2                	ld	s3,40(sp)
    80003ed0:	7a02                	ld	s4,32(sp)
    80003ed2:	6ae2                	ld	s5,24(sp)
    80003ed4:	6b42                	ld	s6,16(sp)
    80003ed6:	6161                	addi	sp,sp,80
    80003ed8:	8082                	ret
    iunlockput(ip);
    80003eda:	854e                	mv	a0,s3
    80003edc:	a6dfe0ef          	jal	80002948 <iunlockput>
    return 0;
    80003ee0:	4981                	li	s3,0
    80003ee2:	b7cd                	j	80003ec4 <create+0x60>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80003ee4:	85ca                	mv	a1,s2
    80003ee6:	4088                	lw	a0,0(s1)
    80003ee8:	ee4fe0ef          	jal	800025cc <ialloc>
    80003eec:	892a                	mv	s2,a0
    80003eee:	c515                	beqz	a0,80003f1a <create+0xb6>
  ilock(ip);
    80003ef0:	84dfe0ef          	jal	8000273c <ilock>
  ip->major = major;
    80003ef4:	05591323          	sh	s5,70(s2)
  if (type == T_DEVICE)
    80003ef8:	478d                	li	a5,3
    80003efa:	02fa0463          	beq	s4,a5,80003f22 <create+0xbe>
    ip->mode = (type == T_DIR) ? 0755 : 0644;
    80003efe:	4785                	li	a5,1
    80003f00:	06fa0563          	beq	s4,a5,80003f6a <create+0x106>
    80003f04:	1a400793          	li	a5,420
    80003f08:	04f91423          	sh	a5,72(s2)
  ip->nlink = 1;
    80003f0c:	4785                	li	a5,1
    80003f0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80003f12:	854a                	mv	a0,s2
    80003f14:	f74fe0ef          	jal	80002688 <iupdate>
  if (type == T_DIR)
    80003f18:	a829                	j	80003f32 <create+0xce>
    iunlockput(dp);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	a2dfe0ef          	jal	80002948 <iunlockput>
    return 0;
    80003f20:	b755                	j	80003ec4 <create+0x60>
    ip->mode = minor; // Store minor device number in mode field for devices
    80003f22:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80003f26:	4785                	li	a5,1
    80003f28:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80003f2c:	854a                	mv	a0,s2
    80003f2e:	f5afe0ef          	jal	80002688 <iupdate>
  if (dirlink(dp, name, ip->inum) < 0)
    80003f32:	00492603          	lw	a2,4(s2)
    80003f36:	fb040593          	addi	a1,s0,-80
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	e55fe0ef          	jal	80002d90 <dirlink>
    80003f40:	00054763          	bltz	a0,80003f4e <create+0xea>
  iunlockput(dp);
    80003f44:	8526                	mv	a0,s1
    80003f46:	a03fe0ef          	jal	80002948 <iunlockput>
  return ip;
    80003f4a:	89ca                	mv	s3,s2
    80003f4c:	bfa5                	j	80003ec4 <create+0x60>
  ip->nlink = 0;
    80003f4e:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80003f52:	854a                	mv	a0,s2
    80003f54:	f34fe0ef          	jal	80002688 <iupdate>
  iunlockput(ip);
    80003f58:	854a                	mv	a0,s2
    80003f5a:	9effe0ef          	jal	80002948 <iunlockput>
  iunlockput(dp);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	9e9fe0ef          	jal	80002948 <iunlockput>
  return 0;
    80003f64:	b785                	j	80003ec4 <create+0x60>
    return 0;
    80003f66:	89aa                	mv	s3,a0
    80003f68:	bfb1                	j	80003ec4 <create+0x60>
    ip->mode = (type == T_DIR) ? 0755 : 0644;
    80003f6a:	1ed00793          	li	a5,493
    80003f6e:	04f91423          	sh	a5,72(s2)
  ip->nlink = 1;
    80003f72:	4785                	li	a5,1
    80003f74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80003f78:	854a                	mv	a0,s2
    80003f7a:	f0efe0ef          	jal	80002688 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f7e:	00492603          	lw	a2,4(s2)
    80003f82:	00003597          	auipc	a1,0x3
    80003f86:	64658593          	addi	a1,a1,1606 # 800075c8 <etext+0x5c8>
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	e05fe0ef          	jal	80002d90 <dirlink>
    80003f90:	fa054fe3          	bltz	a0,80003f4e <create+0xea>
    80003f94:	40d0                	lw	a2,4(s1)
    80003f96:	00003597          	auipc	a1,0x3
    80003f9a:	62a58593          	addi	a1,a1,1578 # 800075c0 <etext+0x5c0>
    80003f9e:	854a                	mv	a0,s2
    80003fa0:	df1fe0ef          	jal	80002d90 <dirlink>
    80003fa4:	fa0545e3          	bltz	a0,80003f4e <create+0xea>
  if (dirlink(dp, name, ip->inum) < 0)
    80003fa8:	00492603          	lw	a2,4(s2)
    80003fac:	fb040593          	addi	a1,s0,-80
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	ddffe0ef          	jal	80002d90 <dirlink>
    80003fb6:	f8054ce3          	bltz	a0,80003f4e <create+0xea>
    dp->nlink++; // for ".."
    80003fba:	04a4d783          	lhu	a5,74(s1)
    80003fbe:	2785                	addiw	a5,a5,1
    80003fc0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	ec2fe0ef          	jal	80002688 <iupdate>
    80003fca:	bfad                	j	80003f44 <create+0xe0>

0000000080003fcc <sys_dup>:
{
    80003fcc:	7179                	addi	sp,sp,-48
    80003fce:	f406                	sd	ra,40(sp)
    80003fd0:	f022                	sd	s0,32(sp)
    80003fd2:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80003fd4:	fd840613          	addi	a2,s0,-40
    80003fd8:	4581                	li	a1,0
    80003fda:	4501                	li	a0,0
    80003fdc:	defff0ef          	jal	80003dca <argfd>
    return -1;
    80003fe0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80003fe2:	02054363          	bltz	a0,80004008 <sys_dup+0x3c>
    80003fe6:	ec26                	sd	s1,24(sp)
    80003fe8:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80003fea:	fd843483          	ld	s1,-40(s0)
    80003fee:	8526                	mv	a0,s1
    80003ff0:	e35ff0ef          	jal	80003e24 <fdalloc>
    80003ff4:	892a                	mv	s2,a0
    return -1;
    80003ff6:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80003ff8:	00054d63          	bltz	a0,80004012 <sys_dup+0x46>
  filedup(f);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	beaff0ef          	jal	800033e8 <filedup>
  return fd;
    80004002:	87ca                	mv	a5,s2
    80004004:	64e2                	ld	s1,24(sp)
    80004006:	6942                	ld	s2,16(sp)
}
    80004008:	853e                	mv	a0,a5
    8000400a:	70a2                	ld	ra,40(sp)
    8000400c:	7402                	ld	s0,32(sp)
    8000400e:	6145                	addi	sp,sp,48
    80004010:	8082                	ret
    80004012:	64e2                	ld	s1,24(sp)
    80004014:	6942                	ld	s2,16(sp)
    80004016:	bfcd                	j	80004008 <sys_dup+0x3c>

0000000080004018 <sys_read>:
{
    80004018:	7179                	addi	sp,sp,-48
    8000401a:	f406                	sd	ra,40(sp)
    8000401c:	f022                	sd	s0,32(sp)
    8000401e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004020:	fd840593          	addi	a1,s0,-40
    80004024:	4505                	li	a0,1
    80004026:	c49fd0ef          	jal	80001c6e <argaddr>
  argint(2, &n);
    8000402a:	fe440593          	addi	a1,s0,-28
    8000402e:	4509                	li	a0,2
    80004030:	c23fd0ef          	jal	80001c52 <argint>
  if (argfd(0, 0, &f) < 0)
    80004034:	fe840613          	addi	a2,s0,-24
    80004038:	4581                	li	a1,0
    8000403a:	4501                	li	a0,0
    8000403c:	d8fff0ef          	jal	80003dca <argfd>
    80004040:	87aa                	mv	a5,a0
    return -1;
    80004042:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004044:	0007ca63          	bltz	a5,80004058 <sys_read+0x40>
  return fileread(f, p, n);
    80004048:	fe442603          	lw	a2,-28(s0)
    8000404c:	fd843583          	ld	a1,-40(s0)
    80004050:	fe843503          	ld	a0,-24(s0)
    80004054:	d00ff0ef          	jal	80003554 <fileread>
}
    80004058:	70a2                	ld	ra,40(sp)
    8000405a:	7402                	ld	s0,32(sp)
    8000405c:	6145                	addi	sp,sp,48
    8000405e:	8082                	ret

0000000080004060 <sys_write>:
{
    80004060:	7179                	addi	sp,sp,-48
    80004062:	f406                	sd	ra,40(sp)
    80004064:	f022                	sd	s0,32(sp)
    80004066:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004068:	fd840593          	addi	a1,s0,-40
    8000406c:	4505                	li	a0,1
    8000406e:	c01fd0ef          	jal	80001c6e <argaddr>
  argint(2, &n);
    80004072:	fe440593          	addi	a1,s0,-28
    80004076:	4509                	li	a0,2
    80004078:	bdbfd0ef          	jal	80001c52 <argint>
  if (argfd(0, 0, &f) < 0)
    8000407c:	fe840613          	addi	a2,s0,-24
    80004080:	4581                	li	a1,0
    80004082:	4501                	li	a0,0
    80004084:	d47ff0ef          	jal	80003dca <argfd>
    80004088:	87aa                	mv	a5,a0
    return -1;
    8000408a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000408c:	0007ca63          	bltz	a5,800040a0 <sys_write+0x40>
  return filewrite(f, p, n);
    80004090:	fe442603          	lw	a2,-28(s0)
    80004094:	fd843583          	ld	a1,-40(s0)
    80004098:	fe843503          	ld	a0,-24(s0)
    8000409c:	d7cff0ef          	jal	80003618 <filewrite>
}
    800040a0:	70a2                	ld	ra,40(sp)
    800040a2:	7402                	ld	s0,32(sp)
    800040a4:	6145                	addi	sp,sp,48
    800040a6:	8082                	ret

00000000800040a8 <sys_close>:
{
    800040a8:	1101                	addi	sp,sp,-32
    800040aa:	ec06                	sd	ra,24(sp)
    800040ac:	e822                	sd	s0,16(sp)
    800040ae:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800040b0:	fe040613          	addi	a2,s0,-32
    800040b4:	fec40593          	addi	a1,s0,-20
    800040b8:	4501                	li	a0,0
    800040ba:	d11ff0ef          	jal	80003dca <argfd>
    return -1;
    800040be:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800040c0:	02054163          	bltz	a0,800040e2 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800040c4:	cc3fc0ef          	jal	80000d86 <myproc>
    800040c8:	fec42783          	lw	a5,-20(s0)
    800040cc:	078e                	slli	a5,a5,0x3
    800040ce:	0d078793          	addi	a5,a5,208
    800040d2:	953e                	add	a0,a0,a5
    800040d4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040d8:	fe043503          	ld	a0,-32(s0)
    800040dc:	b52ff0ef          	jal	8000342e <fileclose>
  return 0;
    800040e0:	4781                	li	a5,0
}
    800040e2:	853e                	mv	a0,a5
    800040e4:	60e2                	ld	ra,24(sp)
    800040e6:	6442                	ld	s0,16(sp)
    800040e8:	6105                	addi	sp,sp,32
    800040ea:	8082                	ret

00000000800040ec <sys_fstat>:
{
    800040ec:	1101                	addi	sp,sp,-32
    800040ee:	ec06                	sd	ra,24(sp)
    800040f0:	e822                	sd	s0,16(sp)
    800040f2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040f4:	fe040593          	addi	a1,s0,-32
    800040f8:	4505                	li	a0,1
    800040fa:	b75fd0ef          	jal	80001c6e <argaddr>
  if (argfd(0, 0, &f) < 0)
    800040fe:	fe840613          	addi	a2,s0,-24
    80004102:	4581                	li	a1,0
    80004104:	4501                	li	a0,0
    80004106:	cc5ff0ef          	jal	80003dca <argfd>
    8000410a:	87aa                	mv	a5,a0
    return -1;
    8000410c:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000410e:	0007c863          	bltz	a5,8000411e <sys_fstat+0x32>
  return filestat(f, st);
    80004112:	fe043583          	ld	a1,-32(s0)
    80004116:	fe843503          	ld	a0,-24(s0)
    8000411a:	bd6ff0ef          	jal	800034f0 <filestat>
}
    8000411e:	60e2                	ld	ra,24(sp)
    80004120:	6442                	ld	s0,16(sp)
    80004122:	6105                	addi	sp,sp,32
    80004124:	8082                	ret

0000000080004126 <sys_link>:
{
    80004126:	7169                	addi	sp,sp,-304
    80004128:	f606                	sd	ra,296(sp)
    8000412a:	f222                	sd	s0,288(sp)
    8000412c:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000412e:	08000613          	li	a2,128
    80004132:	ed040593          	addi	a1,s0,-304
    80004136:	4501                	li	a0,0
    80004138:	b53fd0ef          	jal	80001c8a <argstr>
    return -1;
    8000413c:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000413e:	0c054e63          	bltz	a0,8000421a <sys_link+0xf4>
    80004142:	08000613          	li	a2,128
    80004146:	f5040593          	addi	a1,s0,-176
    8000414a:	4505                	li	a0,1
    8000414c:	b3ffd0ef          	jal	80001c8a <argstr>
    return -1;
    80004150:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004152:	0c054463          	bltz	a0,8000421a <sys_link+0xf4>
    80004156:	ee26                	sd	s1,280(sp)
  begin_op();
    80004158:	ea5fe0ef          	jal	80002ffc <begin_op>
  if ((ip = namei(old)) == 0)
    8000415c:	ed040513          	addi	a0,s0,-304
    80004160:	cdbfe0ef          	jal	80002e3a <namei>
    80004164:	84aa                	mv	s1,a0
    80004166:	c53d                	beqz	a0,800041d4 <sys_link+0xae>
  ilock(ip);
    80004168:	dd4fe0ef          	jal	8000273c <ilock>
  if (ip->type == T_DIR)
    8000416c:	04449703          	lh	a4,68(s1)
    80004170:	4785                	li	a5,1
    80004172:	06f70663          	beq	a4,a5,800041de <sys_link+0xb8>
    80004176:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004178:	04a4d783          	lhu	a5,74(s1)
    8000417c:	2785                	addiw	a5,a5,1
    8000417e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004182:	8526                	mv	a0,s1
    80004184:	d04fe0ef          	jal	80002688 <iupdate>
  iunlock(ip);
    80004188:	8526                	mv	a0,s1
    8000418a:	e60fe0ef          	jal	800027ea <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000418e:	fd040593          	addi	a1,s0,-48
    80004192:	f5040513          	addi	a0,s0,-176
    80004196:	cbffe0ef          	jal	80002e54 <nameiparent>
    8000419a:	892a                	mv	s2,a0
    8000419c:	cd21                	beqz	a0,800041f4 <sys_link+0xce>
  ilock(dp);
    8000419e:	d9efe0ef          	jal	8000273c <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800041a2:	854a                	mv	a0,s2
    800041a4:	00092703          	lw	a4,0(s2)
    800041a8:	409c                	lw	a5,0(s1)
    800041aa:	04f71263          	bne	a4,a5,800041ee <sys_link+0xc8>
    800041ae:	40d0                	lw	a2,4(s1)
    800041b0:	fd040593          	addi	a1,s0,-48
    800041b4:	bddfe0ef          	jal	80002d90 <dirlink>
    800041b8:	02054b63          	bltz	a0,800041ee <sys_link+0xc8>
  iunlockput(dp);
    800041bc:	854a                	mv	a0,s2
    800041be:	f8afe0ef          	jal	80002948 <iunlockput>
  iput(ip);
    800041c2:	8526                	mv	a0,s1
    800041c4:	efafe0ef          	jal	800028be <iput>
  end_op();
    800041c8:	ea5fe0ef          	jal	8000306c <end_op>
  return 0;
    800041cc:	4781                	li	a5,0
    800041ce:	64f2                	ld	s1,280(sp)
    800041d0:	6952                	ld	s2,272(sp)
    800041d2:	a0a1                	j	8000421a <sys_link+0xf4>
    end_op();
    800041d4:	e99fe0ef          	jal	8000306c <end_op>
    return -1;
    800041d8:	57fd                	li	a5,-1
    800041da:	64f2                	ld	s1,280(sp)
    800041dc:	a83d                	j	8000421a <sys_link+0xf4>
    iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	f68fe0ef          	jal	80002948 <iunlockput>
    end_op();
    800041e4:	e89fe0ef          	jal	8000306c <end_op>
    return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	a03d                	j	8000421a <sys_link+0xf4>
    iunlockput(dp);
    800041ee:	854a                	mv	a0,s2
    800041f0:	f58fe0ef          	jal	80002948 <iunlockput>
  ilock(ip);
    800041f4:	8526                	mv	a0,s1
    800041f6:	d46fe0ef          	jal	8000273c <ilock>
  ip->nlink--;
    800041fa:	04a4d783          	lhu	a5,74(s1)
    800041fe:	37fd                	addiw	a5,a5,-1
    80004200:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	c82fe0ef          	jal	80002688 <iupdate>
  iunlockput(ip);
    8000420a:	8526                	mv	a0,s1
    8000420c:	f3cfe0ef          	jal	80002948 <iunlockput>
  end_op();
    80004210:	e5dfe0ef          	jal	8000306c <end_op>
  return -1;
    80004214:	57fd                	li	a5,-1
    80004216:	64f2                	ld	s1,280(sp)
    80004218:	6952                	ld	s2,272(sp)
}
    8000421a:	853e                	mv	a0,a5
    8000421c:	70b2                	ld	ra,296(sp)
    8000421e:	7412                	ld	s0,288(sp)
    80004220:	6155                	addi	sp,sp,304
    80004222:	8082                	ret

0000000080004224 <sys_unlink>:
{
    80004224:	7151                	addi	sp,sp,-240
    80004226:	f586                	sd	ra,232(sp)
    80004228:	f1a2                	sd	s0,224(sp)
    8000422a:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    8000422c:	08000613          	li	a2,128
    80004230:	f3040593          	addi	a1,s0,-208
    80004234:	4501                	li	a0,0
    80004236:	a55fd0ef          	jal	80001c8a <argstr>
    8000423a:	14054d63          	bltz	a0,80004394 <sys_unlink+0x170>
    8000423e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004240:	dbdfe0ef          	jal	80002ffc <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004244:	fb040593          	addi	a1,s0,-80
    80004248:	f3040513          	addi	a0,s0,-208
    8000424c:	c09fe0ef          	jal	80002e54 <nameiparent>
    80004250:	84aa                	mv	s1,a0
    80004252:	c955                	beqz	a0,80004306 <sys_unlink+0xe2>
  ilock(dp);
    80004254:	ce8fe0ef          	jal	8000273c <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004258:	00003597          	auipc	a1,0x3
    8000425c:	37058593          	addi	a1,a1,880 # 800075c8 <etext+0x5c8>
    80004260:	fb040513          	addi	a0,s0,-80
    80004264:	92dfe0ef          	jal	80002b90 <namecmp>
    80004268:	10050b63          	beqz	a0,8000437e <sys_unlink+0x15a>
    8000426c:	00003597          	auipc	a1,0x3
    80004270:	35458593          	addi	a1,a1,852 # 800075c0 <etext+0x5c0>
    80004274:	fb040513          	addi	a0,s0,-80
    80004278:	919fe0ef          	jal	80002b90 <namecmp>
    8000427c:	10050163          	beqz	a0,8000437e <sys_unlink+0x15a>
    80004280:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004282:	f2c40613          	addi	a2,s0,-212
    80004286:	fb040593          	addi	a1,s0,-80
    8000428a:	8526                	mv	a0,s1
    8000428c:	91bfe0ef          	jal	80002ba6 <dirlookup>
    80004290:	892a                	mv	s2,a0
    80004292:	0e050563          	beqz	a0,8000437c <sys_unlink+0x158>
    80004296:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004298:	ca4fe0ef          	jal	8000273c <ilock>
  if (ip->nlink < 1)
    8000429c:	04a91783          	lh	a5,74(s2)
    800042a0:	06f05863          	blez	a5,80004310 <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip))
    800042a4:	04491703          	lh	a4,68(s2)
    800042a8:	4785                	li	a5,1
    800042aa:	06f70963          	beq	a4,a5,8000431c <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800042ae:	fc040993          	addi	s3,s0,-64
    800042b2:	4641                	li	a2,16
    800042b4:	4581                	li	a1,0
    800042b6:	854e                	mv	a0,s3
    800042b8:	ea7fb0ef          	jal	8000015e <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042bc:	4741                	li	a4,16
    800042be:	f2c42683          	lw	a3,-212(s0)
    800042c2:	864e                	mv	a2,s3
    800042c4:	4581                	li	a1,0
    800042c6:	8526                	mv	a0,s1
    800042c8:	fc8fe0ef          	jal	80002a90 <writei>
    800042cc:	47c1                	li	a5,16
    800042ce:	08f51863          	bne	a0,a5,8000435e <sys_unlink+0x13a>
  if (ip->type == T_DIR)
    800042d2:	04491703          	lh	a4,68(s2)
    800042d6:	4785                	li	a5,1
    800042d8:	08f70963          	beq	a4,a5,8000436a <sys_unlink+0x146>
  iunlockput(dp);
    800042dc:	8526                	mv	a0,s1
    800042de:	e6afe0ef          	jal	80002948 <iunlockput>
  ip->nlink--;
    800042e2:	04a95783          	lhu	a5,74(s2)
    800042e6:	37fd                	addiw	a5,a5,-1
    800042e8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042ec:	854a                	mv	a0,s2
    800042ee:	b9afe0ef          	jal	80002688 <iupdate>
  iunlockput(ip);
    800042f2:	854a                	mv	a0,s2
    800042f4:	e54fe0ef          	jal	80002948 <iunlockput>
  end_op();
    800042f8:	d75fe0ef          	jal	8000306c <end_op>
  return 0;
    800042fc:	4501                	li	a0,0
    800042fe:	64ee                	ld	s1,216(sp)
    80004300:	694e                	ld	s2,208(sp)
    80004302:	69ae                	ld	s3,200(sp)
    80004304:	a061                	j	8000438c <sys_unlink+0x168>
    end_op();
    80004306:	d67fe0ef          	jal	8000306c <end_op>
    return -1;
    8000430a:	557d                	li	a0,-1
    8000430c:	64ee                	ld	s1,216(sp)
    8000430e:	a8bd                	j	8000438c <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004310:	00003517          	auipc	a0,0x3
    80004314:	2c050513          	addi	a0,a0,704 # 800075d0 <etext+0x5d0>
    80004318:	326010ef          	jal	8000563e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    8000431c:	04c92703          	lw	a4,76(s2)
    80004320:	02000793          	li	a5,32
    80004324:	f8e7f5e3          	bgeu	a5,a4,800042ae <sys_unlink+0x8a>
    80004328:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000432a:	4741                	li	a4,16
    8000432c:	86ce                	mv	a3,s3
    8000432e:	f1840613          	addi	a2,s0,-232
    80004332:	4581                	li	a1,0
    80004334:	854a                	mv	a0,s2
    80004336:	e68fe0ef          	jal	8000299e <readi>
    8000433a:	47c1                	li	a5,16
    8000433c:	00f51b63          	bne	a0,a5,80004352 <sys_unlink+0x12e>
    if (de.inum != 0)
    80004340:	f1845783          	lhu	a5,-232(s0)
    80004344:	ebb1                	bnez	a5,80004398 <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004346:	29c1                	addiw	s3,s3,16
    80004348:	04c92783          	lw	a5,76(s2)
    8000434c:	fcf9efe3          	bltu	s3,a5,8000432a <sys_unlink+0x106>
    80004350:	bfb9                	j	800042ae <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004352:	00003517          	auipc	a0,0x3
    80004356:	29650513          	addi	a0,a0,662 # 800075e8 <etext+0x5e8>
    8000435a:	2e4010ef          	jal	8000563e <panic>
    panic("unlink: writei");
    8000435e:	00003517          	auipc	a0,0x3
    80004362:	2a250513          	addi	a0,a0,674 # 80007600 <etext+0x600>
    80004366:	2d8010ef          	jal	8000563e <panic>
    dp->nlink--;
    8000436a:	04a4d783          	lhu	a5,74(s1)
    8000436e:	37fd                	addiw	a5,a5,-1
    80004370:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004374:	8526                	mv	a0,s1
    80004376:	b12fe0ef          	jal	80002688 <iupdate>
    8000437a:	b78d                	j	800042dc <sys_unlink+0xb8>
    8000437c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000437e:	8526                	mv	a0,s1
    80004380:	dc8fe0ef          	jal	80002948 <iunlockput>
  end_op();
    80004384:	ce9fe0ef          	jal	8000306c <end_op>
  return -1;
    80004388:	557d                	li	a0,-1
    8000438a:	64ee                	ld	s1,216(sp)
}
    8000438c:	70ae                	ld	ra,232(sp)
    8000438e:	740e                	ld	s0,224(sp)
    80004390:	616d                	addi	sp,sp,240
    80004392:	8082                	ret
    return -1;
    80004394:	557d                	li	a0,-1
    80004396:	bfdd                	j	8000438c <sys_unlink+0x168>
    iunlockput(ip);
    80004398:	854a                	mv	a0,s2
    8000439a:	daefe0ef          	jal	80002948 <iunlockput>
    goto bad;
    8000439e:	694e                	ld	s2,208(sp)
    800043a0:	69ae                	ld	s3,200(sp)
    800043a2:	bff1                	j	8000437e <sys_unlink+0x15a>

00000000800043a4 <sys_open>:

uint64
sys_open(void)
{
    800043a4:	7131                	addi	sp,sp,-192
    800043a6:	fd06                	sd	ra,184(sp)
    800043a8:	f922                	sd	s0,176(sp)
    800043aa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043ac:	f4c40593          	addi	a1,s0,-180
    800043b0:	4505                	li	a0,1
    800043b2:	8a1fd0ef          	jal	80001c52 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800043b6:	08000613          	li	a2,128
    800043ba:	f5040593          	addi	a1,s0,-176
    800043be:	4501                	li	a0,0
    800043c0:	8cbfd0ef          	jal	80001c8a <argstr>
    800043c4:	87aa                	mv	a5,a0
    return -1;
    800043c6:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800043c8:	0a07c363          	bltz	a5,8000446e <sys_open+0xca>
    800043cc:	f526                	sd	s1,168(sp)

  begin_op();
    800043ce:	c2ffe0ef          	jal	80002ffc <begin_op>

  if (omode & O_CREATE)
    800043d2:	f4c42783          	lw	a5,-180(s0)
    800043d6:	2007f793          	andi	a5,a5,512
    800043da:	c3dd                	beqz	a5,80004480 <sys_open+0xdc>
  {
    ip = create(path, T_FILE, 0, 0);
    800043dc:	4681                	li	a3,0
    800043de:	4601                	li	a2,0
    800043e0:	4589                	li	a1,2
    800043e2:	f5040513          	addi	a0,s0,-176
    800043e6:	a7fff0ef          	jal	80003e64 <create>
    800043ea:	84aa                	mv	s1,a0
    if (ip == 0)
    800043ec:	c549                	beqz	a0,80004476 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    800043ee:	04449703          	lh	a4,68(s1)
    800043f2:	478d                	li	a5,3
    800043f4:	00f71763          	bne	a4,a5,80004402 <sys_open+0x5e>
    800043f8:	0464d703          	lhu	a4,70(s1)
    800043fc:	47a5                	li	a5,9
    800043fe:	0ae7ee63          	bltu	a5,a4,800044ba <sys_open+0x116>
    80004402:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004404:	f87fe0ef          	jal	8000338a <filealloc>
    80004408:	892a                	mv	s2,a0
    8000440a:	c561                	beqz	a0,800044d2 <sys_open+0x12e>
    8000440c:	ed4e                	sd	s3,152(sp)
    8000440e:	a17ff0ef          	jal	80003e24 <fdalloc>
    80004412:	89aa                	mv	s3,a0
    80004414:	0a054b63          	bltz	a0,800044ca <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004418:	04449703          	lh	a4,68(s1)
    8000441c:	478d                	li	a5,3
    8000441e:	0cf70363          	beq	a4,a5,800044e4 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004422:	4789                	li	a5,2
    80004424:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004428:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000442c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004430:	f4c42783          	lw	a5,-180(s0)
    80004434:	0017f713          	andi	a4,a5,1
    80004438:	00174713          	xori	a4,a4,1
    8000443c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004440:	0037f713          	andi	a4,a5,3
    80004444:	00e03733          	snez	a4,a4
    80004448:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    8000444c:	4007f793          	andi	a5,a5,1024
    80004450:	c791                	beqz	a5,8000445c <sys_open+0xb8>
    80004452:	04449703          	lh	a4,68(s1)
    80004456:	4789                	li	a5,2
    80004458:	08f70d63          	beq	a4,a5,800044f2 <sys_open+0x14e>
  {
    itrunc(ip);
  }

  iunlock(ip);
    8000445c:	8526                	mv	a0,s1
    8000445e:	b8cfe0ef          	jal	800027ea <iunlock>
  end_op();
    80004462:	c0bfe0ef          	jal	8000306c <end_op>

  return fd;
    80004466:	854e                	mv	a0,s3
    80004468:	74aa                	ld	s1,168(sp)
    8000446a:	790a                	ld	s2,160(sp)
    8000446c:	69ea                	ld	s3,152(sp)
}
    8000446e:	70ea                	ld	ra,184(sp)
    80004470:	744a                	ld	s0,176(sp)
    80004472:	6129                	addi	sp,sp,192
    80004474:	8082                	ret
      end_op();
    80004476:	bf7fe0ef          	jal	8000306c <end_op>
      return -1;
    8000447a:	557d                	li	a0,-1
    8000447c:	74aa                	ld	s1,168(sp)
    8000447e:	bfc5                	j	8000446e <sys_open+0xca>
    if ((ip = namei(path)) == 0)
    80004480:	f5040513          	addi	a0,s0,-176
    80004484:	9b7fe0ef          	jal	80002e3a <namei>
    80004488:	84aa                	mv	s1,a0
    8000448a:	c11d                	beqz	a0,800044b0 <sys_open+0x10c>
    ilock(ip);
    8000448c:	ab0fe0ef          	jal	8000273c <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004490:	04449703          	lh	a4,68(s1)
    80004494:	4785                	li	a5,1
    80004496:	f4f71ce3          	bne	a4,a5,800043ee <sys_open+0x4a>
    8000449a:	f4c42783          	lw	a5,-180(s0)
    8000449e:	d3b5                	beqz	a5,80004402 <sys_open+0x5e>
      iunlockput(ip);
    800044a0:	8526                	mv	a0,s1
    800044a2:	ca6fe0ef          	jal	80002948 <iunlockput>
      end_op();
    800044a6:	bc7fe0ef          	jal	8000306c <end_op>
      return -1;
    800044aa:	557d                	li	a0,-1
    800044ac:	74aa                	ld	s1,168(sp)
    800044ae:	b7c1                	j	8000446e <sys_open+0xca>
      end_op();
    800044b0:	bbdfe0ef          	jal	8000306c <end_op>
      return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	74aa                	ld	s1,168(sp)
    800044b8:	bf5d                	j	8000446e <sys_open+0xca>
    iunlockput(ip);
    800044ba:	8526                	mv	a0,s1
    800044bc:	c8cfe0ef          	jal	80002948 <iunlockput>
    end_op();
    800044c0:	badfe0ef          	jal	8000306c <end_op>
    return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	74aa                	ld	s1,168(sp)
    800044c8:	b75d                	j	8000446e <sys_open+0xca>
      fileclose(f);
    800044ca:	854a                	mv	a0,s2
    800044cc:	f63fe0ef          	jal	8000342e <fileclose>
    800044d0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044d2:	8526                	mv	a0,s1
    800044d4:	c74fe0ef          	jal	80002948 <iunlockput>
    end_op();
    800044d8:	b95fe0ef          	jal	8000306c <end_op>
    return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	74aa                	ld	s1,168(sp)
    800044e0:	790a                	ld	s2,160(sp)
    800044e2:	b771                	j	8000446e <sys_open+0xca>
    f->type = FD_DEVICE;
    800044e4:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800044e8:	04649783          	lh	a5,70(s1)
    800044ec:	02f91223          	sh	a5,36(s2)
    800044f0:	bf35                	j	8000442c <sys_open+0x88>
    itrunc(ip);
    800044f2:	8526                	mv	a0,s1
    800044f4:	b36fe0ef          	jal	8000282a <itrunc>
    800044f8:	b795                	j	8000445c <sys_open+0xb8>

00000000800044fa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044fa:	7175                	addi	sp,sp,-144
    800044fc:	e506                	sd	ra,136(sp)
    800044fe:	e122                	sd	s0,128(sp)
    80004500:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004502:	afbfe0ef          	jal	80002ffc <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004506:	08000613          	li	a2,128
    8000450a:	f7040593          	addi	a1,s0,-144
    8000450e:	4501                	li	a0,0
    80004510:	f7afd0ef          	jal	80001c8a <argstr>
    80004514:	02054363          	bltz	a0,8000453a <sys_mkdir+0x40>
    80004518:	4681                	li	a3,0
    8000451a:	4601                	li	a2,0
    8000451c:	4585                	li	a1,1
    8000451e:	f7040513          	addi	a0,s0,-144
    80004522:	943ff0ef          	jal	80003e64 <create>
    80004526:	c911                	beqz	a0,8000453a <sys_mkdir+0x40>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004528:	c20fe0ef          	jal	80002948 <iunlockput>
  end_op();
    8000452c:	b41fe0ef          	jal	8000306c <end_op>
  return 0;
    80004530:	4501                	li	a0,0
}
    80004532:	60aa                	ld	ra,136(sp)
    80004534:	640a                	ld	s0,128(sp)
    80004536:	6149                	addi	sp,sp,144
    80004538:	8082                	ret
    end_op();
    8000453a:	b33fe0ef          	jal	8000306c <end_op>
    return -1;
    8000453e:	557d                	li	a0,-1
    80004540:	bfcd                	j	80004532 <sys_mkdir+0x38>

0000000080004542 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004542:	7135                	addi	sp,sp,-160
    80004544:	ed06                	sd	ra,152(sp)
    80004546:	e922                	sd	s0,144(sp)
    80004548:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000454a:	ab3fe0ef          	jal	80002ffc <begin_op>
  argint(1, &major);
    8000454e:	f6c40593          	addi	a1,s0,-148
    80004552:	4505                	li	a0,1
    80004554:	efefd0ef          	jal	80001c52 <argint>
  argint(2, &minor);
    80004558:	f6840593          	addi	a1,s0,-152
    8000455c:	4509                	li	a0,2
    8000455e:	ef4fd0ef          	jal	80001c52 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004562:	08000613          	li	a2,128
    80004566:	f7040593          	addi	a1,s0,-144
    8000456a:	4501                	li	a0,0
    8000456c:	f1efd0ef          	jal	80001c8a <argstr>
    80004570:	02054563          	bltz	a0,8000459a <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004574:	f6841683          	lh	a3,-152(s0)
    80004578:	f6c41603          	lh	a2,-148(s0)
    8000457c:	458d                	li	a1,3
    8000457e:	f7040513          	addi	a0,s0,-144
    80004582:	8e3ff0ef          	jal	80003e64 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004586:	c911                	beqz	a0,8000459a <sys_mknod+0x58>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004588:	bc0fe0ef          	jal	80002948 <iunlockput>
  end_op();
    8000458c:	ae1fe0ef          	jal	8000306c <end_op>
  return 0;
    80004590:	4501                	li	a0,0
}
    80004592:	60ea                	ld	ra,152(sp)
    80004594:	644a                	ld	s0,144(sp)
    80004596:	610d                	addi	sp,sp,160
    80004598:	8082                	ret
    end_op();
    8000459a:	ad3fe0ef          	jal	8000306c <end_op>
    return -1;
    8000459e:	557d                	li	a0,-1
    800045a0:	bfcd                	j	80004592 <sys_mknod+0x50>

00000000800045a2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045a2:	7135                	addi	sp,sp,-160
    800045a4:	ed06                	sd	ra,152(sp)
    800045a6:	e922                	sd	s0,144(sp)
    800045a8:	e14a                	sd	s2,128(sp)
    800045aa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045ac:	fdafc0ef          	jal	80000d86 <myproc>
    800045b0:	892a                	mv	s2,a0

  begin_op();
    800045b2:	a4bfe0ef          	jal	80002ffc <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800045b6:	08000613          	li	a2,128
    800045ba:	f6040593          	addi	a1,s0,-160
    800045be:	4501                	li	a0,0
    800045c0:	ecafd0ef          	jal	80001c8a <argstr>
    800045c4:	04054363          	bltz	a0,8000460a <sys_chdir+0x68>
    800045c8:	e526                	sd	s1,136(sp)
    800045ca:	f6040513          	addi	a0,s0,-160
    800045ce:	86dfe0ef          	jal	80002e3a <namei>
    800045d2:	84aa                	mv	s1,a0
    800045d4:	c915                	beqz	a0,80004608 <sys_chdir+0x66>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800045d6:	966fe0ef          	jal	8000273c <ilock>
  if (ip->type != T_DIR)
    800045da:	04449703          	lh	a4,68(s1)
    800045de:	4785                	li	a5,1
    800045e0:	02f71963          	bne	a4,a5,80004612 <sys_chdir+0x70>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045e4:	8526                	mv	a0,s1
    800045e6:	a04fe0ef          	jal	800027ea <iunlock>
  iput(p->cwd);
    800045ea:	15093503          	ld	a0,336(s2)
    800045ee:	ad0fe0ef          	jal	800028be <iput>
  end_op();
    800045f2:	a7bfe0ef          	jal	8000306c <end_op>
  p->cwd = ip;
    800045f6:	14993823          	sd	s1,336(s2)
  return 0;
    800045fa:	4501                	li	a0,0
    800045fc:	64aa                	ld	s1,136(sp)
}
    800045fe:	60ea                	ld	ra,152(sp)
    80004600:	644a                	ld	s0,144(sp)
    80004602:	690a                	ld	s2,128(sp)
    80004604:	610d                	addi	sp,sp,160
    80004606:	8082                	ret
    80004608:	64aa                	ld	s1,136(sp)
    end_op();
    8000460a:	a63fe0ef          	jal	8000306c <end_op>
    return -1;
    8000460e:	557d                	li	a0,-1
    80004610:	b7fd                	j	800045fe <sys_chdir+0x5c>
    iunlockput(ip);
    80004612:	8526                	mv	a0,s1
    80004614:	b34fe0ef          	jal	80002948 <iunlockput>
    end_op();
    80004618:	a55fe0ef          	jal	8000306c <end_op>
    return -1;
    8000461c:	557d                	li	a0,-1
    8000461e:	64aa                	ld	s1,136(sp)
    80004620:	bff9                	j	800045fe <sys_chdir+0x5c>

0000000080004622 <sys_exec>:

uint64
sys_exec(void)
{
    80004622:	7105                	addi	sp,sp,-480
    80004624:	ef86                	sd	ra,472(sp)
    80004626:	eba2                	sd	s0,464(sp)
    80004628:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000462a:	e2840593          	addi	a1,s0,-472
    8000462e:	4505                	li	a0,1
    80004630:	e3efd0ef          	jal	80001c6e <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    80004634:	08000613          	li	a2,128
    80004638:	f3040593          	addi	a1,s0,-208
    8000463c:	4501                	li	a0,0
    8000463e:	e4cfd0ef          	jal	80001c8a <argstr>
    80004642:	87aa                	mv	a5,a0
  {
    return -1;
    80004644:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80004646:	0e07c063          	bltz	a5,80004726 <sys_exec+0x104>
    8000464a:	e7a6                	sd	s1,456(sp)
    8000464c:	e3ca                	sd	s2,448(sp)
    8000464e:	ff4e                	sd	s3,440(sp)
    80004650:	fb52                	sd	s4,432(sp)
    80004652:	f756                	sd	s5,424(sp)
    80004654:	f35a                	sd	s6,416(sp)
    80004656:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004658:	e3040a13          	addi	s4,s0,-464
    8000465c:	10000613          	li	a2,256
    80004660:	4581                	li	a1,0
    80004662:	8552                	mv	a0,s4
    80004664:	afbfb0ef          	jal	8000015e <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004668:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000466a:	89d2                	mv	s3,s4
    8000466c:	4901                	li	s2,0
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    8000466e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004672:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv))
    80004674:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004678:	00391513          	slli	a0,s2,0x3
    8000467c:	85d6                	mv	a1,s5
    8000467e:	e2843783          	ld	a5,-472(s0)
    80004682:	953e                	add	a0,a0,a5
    80004684:	d44fd0ef          	jal	80001bc8 <fetchaddr>
    80004688:	02054663          	bltz	a0,800046b4 <sys_exec+0x92>
    if (uarg == 0)
    8000468c:	e2043783          	ld	a5,-480(s0)
    80004690:	c7a1                	beqz	a5,800046d8 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004692:	a73fb0ef          	jal	80000104 <kalloc>
    80004696:	85aa                	mv	a1,a0
    80004698:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    8000469c:	cd01                	beqz	a0,800046b4 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000469e:	865a                	mv	a2,s6
    800046a0:	e2043503          	ld	a0,-480(s0)
    800046a4:	d6efd0ef          	jal	80001c12 <fetchstr>
    800046a8:	00054663          	bltz	a0,800046b4 <sys_exec+0x92>
    if (i >= NELEM(argv))
    800046ac:	0905                	addi	s2,s2,1
    800046ae:	09a1                	addi	s3,s3,8
    800046b0:	fd7914e3          	bne	s2,s7,80004678 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046b4:	100a0a13          	addi	s4,s4,256
    800046b8:	6088                	ld	a0,0(s1)
    800046ba:	cd31                	beqz	a0,80004716 <sys_exec+0xf4>
    kfree(argv[i]);
    800046bc:	961fb0ef          	jal	8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046c0:	04a1                	addi	s1,s1,8
    800046c2:	ff449be3          	bne	s1,s4,800046b8 <sys_exec+0x96>
  return -1;
    800046c6:	557d                	li	a0,-1
    800046c8:	64be                	ld	s1,456(sp)
    800046ca:	691e                	ld	s2,448(sp)
    800046cc:	79fa                	ld	s3,440(sp)
    800046ce:	7a5a                	ld	s4,432(sp)
    800046d0:	7aba                	ld	s5,424(sp)
    800046d2:	7b1a                	ld	s6,416(sp)
    800046d4:	6bfa                	ld	s7,408(sp)
    800046d6:	a881                	j	80004726 <sys_exec+0x104>
      argv[i] = 0;
    800046d8:	0009079b          	sext.w	a5,s2
    800046dc:	e3040593          	addi	a1,s0,-464
    800046e0:	078e                	slli	a5,a5,0x3
    800046e2:	97ae                	add	a5,a5,a1
    800046e4:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800046e8:	f3040513          	addi	a0,s0,-208
    800046ec:	b86ff0ef          	jal	80003a72 <exec>
    800046f0:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046f2:	100a0a13          	addi	s4,s4,256
    800046f6:	6088                	ld	a0,0(s1)
    800046f8:	c511                	beqz	a0,80004704 <sys_exec+0xe2>
    kfree(argv[i]);
    800046fa:	923fb0ef          	jal	8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046fe:	04a1                	addi	s1,s1,8
    80004700:	ff449be3          	bne	s1,s4,800046f6 <sys_exec+0xd4>
  return ret;
    80004704:	854a                	mv	a0,s2
    80004706:	64be                	ld	s1,456(sp)
    80004708:	691e                	ld	s2,448(sp)
    8000470a:	79fa                	ld	s3,440(sp)
    8000470c:	7a5a                	ld	s4,432(sp)
    8000470e:	7aba                	ld	s5,424(sp)
    80004710:	7b1a                	ld	s6,416(sp)
    80004712:	6bfa                	ld	s7,408(sp)
    80004714:	a809                	j	80004726 <sys_exec+0x104>
  return -1;
    80004716:	557d                	li	a0,-1
    80004718:	64be                	ld	s1,456(sp)
    8000471a:	691e                	ld	s2,448(sp)
    8000471c:	79fa                	ld	s3,440(sp)
    8000471e:	7a5a                	ld	s4,432(sp)
    80004720:	7aba                	ld	s5,424(sp)
    80004722:	7b1a                	ld	s6,416(sp)
    80004724:	6bfa                	ld	s7,408(sp)
}
    80004726:	60fe                	ld	ra,472(sp)
    80004728:	645e                	ld	s0,464(sp)
    8000472a:	613d                	addi	sp,sp,480
    8000472c:	8082                	ret

000000008000472e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000472e:	7139                	addi	sp,sp,-64
    80004730:	fc06                	sd	ra,56(sp)
    80004732:	f822                	sd	s0,48(sp)
    80004734:	f426                	sd	s1,40(sp)
    80004736:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004738:	e4efc0ef          	jal	80000d86 <myproc>
    8000473c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000473e:	fd840593          	addi	a1,s0,-40
    80004742:	4501                	li	a0,0
    80004744:	d2afd0ef          	jal	80001c6e <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80004748:	fc840593          	addi	a1,s0,-56
    8000474c:	fd040513          	addi	a0,s0,-48
    80004750:	ffdfe0ef          	jal	8000374c <pipealloc>
    return -1;
    80004754:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004756:	0a054763          	bltz	a0,80004804 <sys_pipe+0xd6>
  fd0 = -1;
    8000475a:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    8000475e:	fd043503          	ld	a0,-48(s0)
    80004762:	ec2ff0ef          	jal	80003e24 <fdalloc>
    80004766:	fca42223          	sw	a0,-60(s0)
    8000476a:	08054463          	bltz	a0,800047f2 <sys_pipe+0xc4>
    8000476e:	fc843503          	ld	a0,-56(s0)
    80004772:	eb2ff0ef          	jal	80003e24 <fdalloc>
    80004776:	fca42023          	sw	a0,-64(s0)
    8000477a:	06054263          	bltz	a0,800047de <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000477e:	4691                	li	a3,4
    80004780:	fc440613          	addi	a2,s0,-60
    80004784:	fd843583          	ld	a1,-40(s0)
    80004788:	68a8                	ld	a0,80(s1)
    8000478a:	a78fc0ef          	jal	80000a02 <copyout>
    8000478e:	00054e63          	bltz	a0,800047aa <sys_pipe+0x7c>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80004792:	4691                	li	a3,4
    80004794:	fc040613          	addi	a2,s0,-64
    80004798:	fd843583          	ld	a1,-40(s0)
    8000479c:	95b6                	add	a1,a1,a3
    8000479e:	68a8                	ld	a0,80(s1)
    800047a0:	a62fc0ef          	jal	80000a02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047a4:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800047a6:	04055f63          	bgez	a0,80004804 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800047aa:	fc442783          	lw	a5,-60(s0)
    800047ae:	078e                	slli	a5,a5,0x3
    800047b0:	0d078793          	addi	a5,a5,208
    800047b4:	97a6                	add	a5,a5,s1
    800047b6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047ba:	fc042783          	lw	a5,-64(s0)
    800047be:	078e                	slli	a5,a5,0x3
    800047c0:	0d078793          	addi	a5,a5,208
    800047c4:	97a6                	add	a5,a5,s1
    800047c6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047ca:	fd043503          	ld	a0,-48(s0)
    800047ce:	c61fe0ef          	jal	8000342e <fileclose>
    fileclose(wf);
    800047d2:	fc843503          	ld	a0,-56(s0)
    800047d6:	c59fe0ef          	jal	8000342e <fileclose>
    return -1;
    800047da:	57fd                	li	a5,-1
    800047dc:	a025                	j	80004804 <sys_pipe+0xd6>
    if (fd0 >= 0)
    800047de:	fc442783          	lw	a5,-60(s0)
    800047e2:	0007c863          	bltz	a5,800047f2 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800047e6:	078e                	slli	a5,a5,0x3
    800047e8:	0d078793          	addi	a5,a5,208
    800047ec:	97a6                	add	a5,a5,s1
    800047ee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047f2:	fd043503          	ld	a0,-48(s0)
    800047f6:	c39fe0ef          	jal	8000342e <fileclose>
    fileclose(wf);
    800047fa:	fc843503          	ld	a0,-56(s0)
    800047fe:	c31fe0ef          	jal	8000342e <fileclose>
    return -1;
    80004802:	57fd                	li	a5,-1
}
    80004804:	853e                	mv	a0,a5
    80004806:	70e2                	ld	ra,56(sp)
    80004808:	7442                	ld	s0,48(sp)
    8000480a:	74a2                	ld	s1,40(sp)
    8000480c:	6121                	addi	sp,sp,64
    8000480e:	8082                	ret

0000000080004810 <sys_chmod>:

uint64
sys_chmod(void)
{
    80004810:	7171                	addi	sp,sp,-176
    80004812:	f506                	sd	ra,168(sp)
    80004814:	f122                	sd	s0,160(sp)
    80004816:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  int mode;
  struct inode *ip;

  if (argstr(0, path, MAXPATH) < 0)
    80004818:	08000613          	li	a2,128
    8000481c:	f6040593          	addi	a1,s0,-160
    80004820:	4501                	li	a0,0
    80004822:	c68fd0ef          	jal	80001c8a <argstr>
    return -1;
    80004826:	57fd                	li	a5,-1
  if (argstr(0, path, MAXPATH) < 0)
    80004828:	04054363          	bltz	a0,8000486e <sys_chmod+0x5e>
    8000482c:	ed26                	sd	s1,152(sp)
  argint(1, &mode);
    8000482e:	f5c40593          	addi	a1,s0,-164
    80004832:	4505                	li	a0,1
    80004834:	c1efd0ef          	jal	80001c52 <argint>

  begin_op();
    80004838:	fc4fe0ef          	jal	80002ffc <begin_op>
  if ((ip = namei(path)) == 0)
    8000483c:	f6040513          	addi	a0,s0,-160
    80004840:	dfafe0ef          	jal	80002e3a <namei>
    80004844:	84aa                	mv	s1,a0
    80004846:	c90d                	beqz	a0,80004878 <sys_chmod+0x68>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004848:	ef5fd0ef          	jal	8000273c <ilock>
  ip->mode = mode;
    8000484c:	f5c42783          	lw	a5,-164(s0)
    80004850:	04f49423          	sh	a5,72(s1)
  iupdate(ip);
    80004854:	8526                	mv	a0,s1
    80004856:	e33fd0ef          	jal	80002688 <iupdate>
  iunlock(ip);
    8000485a:	8526                	mv	a0,s1
    8000485c:	f8ffd0ef          	jal	800027ea <iunlock>
  iput(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	85cfe0ef          	jal	800028be <iput>
  end_op();
    80004866:	807fe0ef          	jal	8000306c <end_op>
  return 0;
    8000486a:	4781                	li	a5,0
    8000486c:	64ea                	ld	s1,152(sp)
}
    8000486e:	853e                	mv	a0,a5
    80004870:	70aa                	ld	ra,168(sp)
    80004872:	740a                	ld	s0,160(sp)
    80004874:	614d                	addi	sp,sp,176
    80004876:	8082                	ret
    end_op();
    80004878:	ff4fe0ef          	jal	8000306c <end_op>
    return -1;
    8000487c:	57fd                	li	a5,-1
    8000487e:	64ea                	ld	s1,152(sp)
    80004880:	b7fd                	j	8000486e <sys_chmod+0x5e>
	...

0000000080004890 <kernelvec>:
    80004890:	7111                	addi	sp,sp,-256
    80004892:	e006                	sd	ra,0(sp)
    80004894:	e40a                	sd	sp,8(sp)
    80004896:	e80e                	sd	gp,16(sp)
    80004898:	ec12                	sd	tp,24(sp)
    8000489a:	f016                	sd	t0,32(sp)
    8000489c:	f41a                	sd	t1,40(sp)
    8000489e:	f81e                	sd	t2,48(sp)
    800048a0:	e4aa                	sd	a0,72(sp)
    800048a2:	e8ae                	sd	a1,80(sp)
    800048a4:	ecb2                	sd	a2,88(sp)
    800048a6:	f0b6                	sd	a3,96(sp)
    800048a8:	f4ba                	sd	a4,104(sp)
    800048aa:	f8be                	sd	a5,112(sp)
    800048ac:	fcc2                	sd	a6,120(sp)
    800048ae:	e146                	sd	a7,128(sp)
    800048b0:	edf2                	sd	t3,216(sp)
    800048b2:	f1f6                	sd	t4,224(sp)
    800048b4:	f5fa                	sd	t5,232(sp)
    800048b6:	f9fe                	sd	t6,240(sp)
    800048b8:	a1efd0ef          	jal	80001ad6 <kerneltrap>
    800048bc:	6082                	ld	ra,0(sp)
    800048be:	6122                	ld	sp,8(sp)
    800048c0:	61c2                	ld	gp,16(sp)
    800048c2:	7282                	ld	t0,32(sp)
    800048c4:	7322                	ld	t1,40(sp)
    800048c6:	73c2                	ld	t2,48(sp)
    800048c8:	6526                	ld	a0,72(sp)
    800048ca:	65c6                	ld	a1,80(sp)
    800048cc:	6666                	ld	a2,88(sp)
    800048ce:	7686                	ld	a3,96(sp)
    800048d0:	7726                	ld	a4,104(sp)
    800048d2:	77c6                	ld	a5,112(sp)
    800048d4:	7866                	ld	a6,120(sp)
    800048d6:	688a                	ld	a7,128(sp)
    800048d8:	6e6e                	ld	t3,216(sp)
    800048da:	7e8e                	ld	t4,224(sp)
    800048dc:	7f2e                	ld	t5,232(sp)
    800048de:	7fce                	ld	t6,240(sp)
    800048e0:	6111                	addi	sp,sp,256
    800048e2:	10200073          	sret
    800048e6:	00000013          	nop
    800048ea:	00000013          	nop

00000000800048ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800048ee:	1141                	addi	sp,sp,-16
    800048f0:	e406                	sd	ra,8(sp)
    800048f2:	e022                	sd	s0,0(sp)
    800048f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048f6:	0c000737          	lui	a4,0xc000
    800048fa:	4785                	li	a5,1
    800048fc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048fe:	c35c                	sw	a5,4(a4)
}
    80004900:	60a2                	ld	ra,8(sp)
    80004902:	6402                	ld	s0,0(sp)
    80004904:	0141                	addi	sp,sp,16
    80004906:	8082                	ret

0000000080004908 <plicinithart>:

void
plicinithart(void)
{
    80004908:	1141                	addi	sp,sp,-16
    8000490a:	e406                	sd	ra,8(sp)
    8000490c:	e022                	sd	s0,0(sp)
    8000490e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004910:	c42fc0ef          	jal	80000d52 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004914:	0085171b          	slliw	a4,a0,0x8
    80004918:	0c0027b7          	lui	a5,0xc002
    8000491c:	97ba                	add	a5,a5,a4
    8000491e:	40200713          	li	a4,1026
    80004922:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004926:	00d5151b          	slliw	a0,a0,0xd
    8000492a:	0c2017b7          	lui	a5,0xc201
    8000492e:	97aa                	add	a5,a5,a0
    80004930:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004934:	60a2                	ld	ra,8(sp)
    80004936:	6402                	ld	s0,0(sp)
    80004938:	0141                	addi	sp,sp,16
    8000493a:	8082                	ret

000000008000493c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000493c:	1141                	addi	sp,sp,-16
    8000493e:	e406                	sd	ra,8(sp)
    80004940:	e022                	sd	s0,0(sp)
    80004942:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004944:	c0efc0ef          	jal	80000d52 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004948:	00d5151b          	slliw	a0,a0,0xd
    8000494c:	0c2017b7          	lui	a5,0xc201
    80004950:	97aa                	add	a5,a5,a0
  return irq;
}
    80004952:	43c8                	lw	a0,4(a5)
    80004954:	60a2                	ld	ra,8(sp)
    80004956:	6402                	ld	s0,0(sp)
    80004958:	0141                	addi	sp,sp,16
    8000495a:	8082                	ret

000000008000495c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000495c:	1101                	addi	sp,sp,-32
    8000495e:	ec06                	sd	ra,24(sp)
    80004960:	e822                	sd	s0,16(sp)
    80004962:	e426                	sd	s1,8(sp)
    80004964:	1000                	addi	s0,sp,32
    80004966:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004968:	beafc0ef          	jal	80000d52 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000496c:	00d5179b          	slliw	a5,a0,0xd
    80004970:	0c201737          	lui	a4,0xc201
    80004974:	97ba                	add	a5,a5,a4
    80004976:	c3c4                	sw	s1,4(a5)
}
    80004978:	60e2                	ld	ra,24(sp)
    8000497a:	6442                	ld	s0,16(sp)
    8000497c:	64a2                	ld	s1,8(sp)
    8000497e:	6105                	addi	sp,sp,32
    80004980:	8082                	ret

0000000080004982 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004982:	1141                	addi	sp,sp,-16
    80004984:	e406                	sd	ra,8(sp)
    80004986:	e022                	sd	s0,0(sp)
    80004988:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000498a:	479d                	li	a5,7
    8000498c:	04a7ca63          	blt	a5,a0,800049e0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004990:	00017797          	auipc	a5,0x17
    80004994:	a6078793          	addi	a5,a5,-1440 # 8001b3f0 <disk>
    80004998:	97aa                	add	a5,a5,a0
    8000499a:	0187c783          	lbu	a5,24(a5)
    8000499e:	e7b9                	bnez	a5,800049ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800049a0:	00451693          	slli	a3,a0,0x4
    800049a4:	00017797          	auipc	a5,0x17
    800049a8:	a4c78793          	addi	a5,a5,-1460 # 8001b3f0 <disk>
    800049ac:	6398                	ld	a4,0(a5)
    800049ae:	9736                	add	a4,a4,a3
    800049b0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800049b4:	6398                	ld	a4,0(a5)
    800049b6:	9736                	add	a4,a4,a3
    800049b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800049bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800049c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800049c4:	97aa                	add	a5,a5,a0
    800049c6:	4705                	li	a4,1
    800049c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800049cc:	00017517          	auipc	a0,0x17
    800049d0:	a3c50513          	addi	a0,a0,-1476 # 8001b408 <disk+0x18>
    800049d4:	9ddfc0ef          	jal	800013b0 <wakeup>
}
    800049d8:	60a2                	ld	ra,8(sp)
    800049da:	6402                	ld	s0,0(sp)
    800049dc:	0141                	addi	sp,sp,16
    800049de:	8082                	ret
    panic("free_desc 1");
    800049e0:	00003517          	auipc	a0,0x3
    800049e4:	c3050513          	addi	a0,a0,-976 # 80007610 <etext+0x610>
    800049e8:	457000ef          	jal	8000563e <panic>
    panic("free_desc 2");
    800049ec:	00003517          	auipc	a0,0x3
    800049f0:	c3450513          	addi	a0,a0,-972 # 80007620 <etext+0x620>
    800049f4:	44b000ef          	jal	8000563e <panic>

00000000800049f8 <virtio_disk_init>:
{
    800049f8:	1101                	addi	sp,sp,-32
    800049fa:	ec06                	sd	ra,24(sp)
    800049fc:	e822                	sd	s0,16(sp)
    800049fe:	e426                	sd	s1,8(sp)
    80004a00:	e04a                	sd	s2,0(sp)
    80004a02:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a04:	00003597          	auipc	a1,0x3
    80004a08:	c2c58593          	addi	a1,a1,-980 # 80007630 <etext+0x630>
    80004a0c:	00017517          	auipc	a0,0x17
    80004a10:	b0c50513          	addi	a0,a0,-1268 # 8001b518 <disk+0x128>
    80004a14:	6df000ef          	jal	800058f2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a18:	100017b7          	lui	a5,0x10001
    80004a1c:	4398                	lw	a4,0(a5)
    80004a1e:	2701                	sext.w	a4,a4
    80004a20:	747277b7          	lui	a5,0x74727
    80004a24:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a28:	14f71863          	bne	a4,a5,80004b78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a2c:	100017b7          	lui	a5,0x10001
    80004a30:	43dc                	lw	a5,4(a5)
    80004a32:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a34:	4709                	li	a4,2
    80004a36:	14e79163          	bne	a5,a4,80004b78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a3a:	100017b7          	lui	a5,0x10001
    80004a3e:	479c                	lw	a5,8(a5)
    80004a40:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a42:	12e79b63          	bne	a5,a4,80004b78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a46:	100017b7          	lui	a5,0x10001
    80004a4a:	47d8                	lw	a4,12(a5)
    80004a4c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a4e:	554d47b7          	lui	a5,0x554d4
    80004a52:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a56:	12f71163          	bne	a4,a5,80004b78 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a5a:	100017b7          	lui	a5,0x10001
    80004a5e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a62:	4705                	li	a4,1
    80004a64:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a66:	470d                	li	a4,3
    80004a68:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a6a:	10001737          	lui	a4,0x10001
    80004a6e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a70:	c7ffe6b7          	lui	a3,0xc7ffe
    80004a74:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb12f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a78:	8f75                	and	a4,a4,a3
    80004a7a:	100016b7          	lui	a3,0x10001
    80004a7e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a80:	472d                	li	a4,11
    80004a82:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a84:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a88:	439c                	lw	a5,0(a5)
    80004a8a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a8e:	8ba1                	andi	a5,a5,8
    80004a90:	0e078a63          	beqz	a5,80004b84 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a94:	100017b7          	lui	a5,0x10001
    80004a98:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a9c:	43fc                	lw	a5,68(a5)
    80004a9e:	2781                	sext.w	a5,a5
    80004aa0:	0e079863          	bnez	a5,80004b90 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004aa4:	100017b7          	lui	a5,0x10001
    80004aa8:	5bdc                	lw	a5,52(a5)
    80004aaa:	2781                	sext.w	a5,a5
  if(max == 0)
    80004aac:	0e078863          	beqz	a5,80004b9c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004ab0:	471d                	li	a4,7
    80004ab2:	0ef77b63          	bgeu	a4,a5,80004ba8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004ab6:	e4efb0ef          	jal	80000104 <kalloc>
    80004aba:	00017497          	auipc	s1,0x17
    80004abe:	93648493          	addi	s1,s1,-1738 # 8001b3f0 <disk>
    80004ac2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ac4:	e40fb0ef          	jal	80000104 <kalloc>
    80004ac8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004aca:	e3afb0ef          	jal	80000104 <kalloc>
    80004ace:	87aa                	mv	a5,a0
    80004ad0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004ad2:	6088                	ld	a0,0(s1)
    80004ad4:	0e050063          	beqz	a0,80004bb4 <virtio_disk_init+0x1bc>
    80004ad8:	00017717          	auipc	a4,0x17
    80004adc:	92073703          	ld	a4,-1760(a4) # 8001b3f8 <disk+0x8>
    80004ae0:	cb71                	beqz	a4,80004bb4 <virtio_disk_init+0x1bc>
    80004ae2:	cbe9                	beqz	a5,80004bb4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004ae4:	6605                	lui	a2,0x1
    80004ae6:	4581                	li	a1,0
    80004ae8:	e76fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004aec:	00017497          	auipc	s1,0x17
    80004af0:	90448493          	addi	s1,s1,-1788 # 8001b3f0 <disk>
    80004af4:	6605                	lui	a2,0x1
    80004af6:	4581                	li	a1,0
    80004af8:	6488                	ld	a0,8(s1)
    80004afa:	e64fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004afe:	6605                	lui	a2,0x1
    80004b00:	4581                	li	a1,0
    80004b02:	6888                	ld	a0,16(s1)
    80004b04:	e5afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b08:	100017b7          	lui	a5,0x10001
    80004b0c:	4721                	li	a4,8
    80004b0e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b10:	4098                	lw	a4,0(s1)
    80004b12:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b16:	40d8                	lw	a4,4(s1)
    80004b18:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b1c:	649c                	ld	a5,8(s1)
    80004b1e:	0007869b          	sext.w	a3,a5
    80004b22:	10001737          	lui	a4,0x10001
    80004b26:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b2a:	9781                	srai	a5,a5,0x20
    80004b2c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b30:	689c                	ld	a5,16(s1)
    80004b32:	0007869b          	sext.w	a3,a5
    80004b36:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b3a:	9781                	srai	a5,a5,0x20
    80004b3c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b40:	4785                	li	a5,1
    80004b42:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b44:	00f48c23          	sb	a5,24(s1)
    80004b48:	00f48ca3          	sb	a5,25(s1)
    80004b4c:	00f48d23          	sb	a5,26(s1)
    80004b50:	00f48da3          	sb	a5,27(s1)
    80004b54:	00f48e23          	sb	a5,28(s1)
    80004b58:	00f48ea3          	sb	a5,29(s1)
    80004b5c:	00f48f23          	sb	a5,30(s1)
    80004b60:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b64:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b68:	07272823          	sw	s2,112(a4)
}
    80004b6c:	60e2                	ld	ra,24(sp)
    80004b6e:	6442                	ld	s0,16(sp)
    80004b70:	64a2                	ld	s1,8(sp)
    80004b72:	6902                	ld	s2,0(sp)
    80004b74:	6105                	addi	sp,sp,32
    80004b76:	8082                	ret
    panic("could not find virtio disk");
    80004b78:	00003517          	auipc	a0,0x3
    80004b7c:	ac850513          	addi	a0,a0,-1336 # 80007640 <etext+0x640>
    80004b80:	2bf000ef          	jal	8000563e <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b84:	00003517          	auipc	a0,0x3
    80004b88:	adc50513          	addi	a0,a0,-1316 # 80007660 <etext+0x660>
    80004b8c:	2b3000ef          	jal	8000563e <panic>
    panic("virtio disk should not be ready");
    80004b90:	00003517          	auipc	a0,0x3
    80004b94:	af050513          	addi	a0,a0,-1296 # 80007680 <etext+0x680>
    80004b98:	2a7000ef          	jal	8000563e <panic>
    panic("virtio disk has no queue 0");
    80004b9c:	00003517          	auipc	a0,0x3
    80004ba0:	b0450513          	addi	a0,a0,-1276 # 800076a0 <etext+0x6a0>
    80004ba4:	29b000ef          	jal	8000563e <panic>
    panic("virtio disk max queue too short");
    80004ba8:	00003517          	auipc	a0,0x3
    80004bac:	b1850513          	addi	a0,a0,-1256 # 800076c0 <etext+0x6c0>
    80004bb0:	28f000ef          	jal	8000563e <panic>
    panic("virtio disk kalloc");
    80004bb4:	00003517          	auipc	a0,0x3
    80004bb8:	b2c50513          	addi	a0,a0,-1236 # 800076e0 <etext+0x6e0>
    80004bbc:	283000ef          	jal	8000563e <panic>

0000000080004bc0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004bc0:	711d                	addi	sp,sp,-96
    80004bc2:	ec86                	sd	ra,88(sp)
    80004bc4:	e8a2                	sd	s0,80(sp)
    80004bc6:	e4a6                	sd	s1,72(sp)
    80004bc8:	e0ca                	sd	s2,64(sp)
    80004bca:	fc4e                	sd	s3,56(sp)
    80004bcc:	f852                	sd	s4,48(sp)
    80004bce:	f456                	sd	s5,40(sp)
    80004bd0:	f05a                	sd	s6,32(sp)
    80004bd2:	ec5e                	sd	s7,24(sp)
    80004bd4:	e862                	sd	s8,16(sp)
    80004bd6:	1080                	addi	s0,sp,96
    80004bd8:	89aa                	mv	s3,a0
    80004bda:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bdc:	00c52b83          	lw	s7,12(a0)
    80004be0:	001b9b9b          	slliw	s7,s7,0x1
    80004be4:	1b82                	slli	s7,s7,0x20
    80004be6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004bea:	00017517          	auipc	a0,0x17
    80004bee:	92e50513          	addi	a0,a0,-1746 # 8001b518 <disk+0x128>
    80004bf2:	58b000ef          	jal	8000597c <acquire>
  for(int i = 0; i < NUM; i++){
    80004bf6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bf8:	00016a97          	auipc	s5,0x16
    80004bfc:	7f8a8a93          	addi	s5,s5,2040 # 8001b3f0 <disk>
  for(int i = 0; i < 3; i++){
    80004c00:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c02:	5c7d                	li	s8,-1
    80004c04:	a095                	j	80004c68 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c06:	00fa8733          	add	a4,s5,a5
    80004c0a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c0e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c10:	0207c563          	bltz	a5,80004c3a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c14:	2905                	addiw	s2,s2,1
    80004c16:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c18:	05490c63          	beq	s2,s4,80004c70 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c1c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c1e:	00016717          	auipc	a4,0x16
    80004c22:	7d270713          	addi	a4,a4,2002 # 8001b3f0 <disk>
    80004c26:	4781                	li	a5,0
    if(disk.free[i]){
    80004c28:	01874683          	lbu	a3,24(a4)
    80004c2c:	fee9                	bnez	a3,80004c06 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c2e:	2785                	addiw	a5,a5,1
    80004c30:	0705                	addi	a4,a4,1
    80004c32:	fe979be3          	bne	a5,s1,80004c28 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c36:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c3a:	01205d63          	blez	s2,80004c54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c3e:	fa042503          	lw	a0,-96(s0)
    80004c42:	d41ff0ef          	jal	80004982 <free_desc>
      for(int j = 0; j < i; j++)
    80004c46:	4785                	li	a5,1
    80004c48:	0127d663          	bge	a5,s2,80004c54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c4c:	fa442503          	lw	a0,-92(s0)
    80004c50:	d33ff0ef          	jal	80004982 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c54:	00017597          	auipc	a1,0x17
    80004c58:	8c458593          	addi	a1,a1,-1852 # 8001b518 <disk+0x128>
    80004c5c:	00016517          	auipc	a0,0x16
    80004c60:	7ac50513          	addi	a0,a0,1964 # 8001b408 <disk+0x18>
    80004c64:	f00fc0ef          	jal	80001364 <sleep>
  for(int i = 0; i < 3; i++){
    80004c68:	fa040613          	addi	a2,s0,-96
    80004c6c:	4901                	li	s2,0
    80004c6e:	b77d                	j	80004c1c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c70:	fa042503          	lw	a0,-96(s0)
    80004c74:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c78:	00016797          	auipc	a5,0x16
    80004c7c:	77878793          	addi	a5,a5,1912 # 8001b3f0 <disk>
    80004c80:	00451713          	slli	a4,a0,0x4
    80004c84:	0a070713          	addi	a4,a4,160
    80004c88:	973e                	add	a4,a4,a5
    80004c8a:	01603633          	snez	a2,s6
    80004c8e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c90:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c94:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c98:	6398                	ld	a4,0(a5)
    80004c9a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c9c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004ca0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ca2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ca4:	6390                	ld	a2,0(a5)
    80004ca6:	00d60833          	add	a6,a2,a3
    80004caa:	4741                	li	a4,16
    80004cac:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004cb0:	4585                	li	a1,1
    80004cb2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004cb6:	fa442703          	lw	a4,-92(s0)
    80004cba:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cbe:	0712                	slli	a4,a4,0x4
    80004cc0:	963a                	add	a2,a2,a4
    80004cc2:	05898813          	addi	a6,s3,88
    80004cc6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004cca:	0007b883          	ld	a7,0(a5)
    80004cce:	9746                	add	a4,a4,a7
    80004cd0:	40000613          	li	a2,1024
    80004cd4:	c710                	sw	a2,8(a4)
  if(write)
    80004cd6:	001b3613          	seqz	a2,s6
    80004cda:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cde:	8e4d                	or	a2,a2,a1
    80004ce0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ce4:	fa842603          	lw	a2,-88(s0)
    80004ce8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004cec:	00451813          	slli	a6,a0,0x4
    80004cf0:	02080813          	addi	a6,a6,32
    80004cf4:	983e                	add	a6,a6,a5
    80004cf6:	577d                	li	a4,-1
    80004cf8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cfc:	0612                	slli	a2,a2,0x4
    80004cfe:	98b2                	add	a7,a7,a2
    80004d00:	03068713          	addi	a4,a3,48
    80004d04:	973e                	add	a4,a4,a5
    80004d06:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d0a:	6398                	ld	a4,0(a5)
    80004d0c:	9732                	add	a4,a4,a2
    80004d0e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d10:	4689                	li	a3,2
    80004d12:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d16:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d1a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004d1e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d22:	6794                	ld	a3,8(a5)
    80004d24:	0026d703          	lhu	a4,2(a3)
    80004d28:	8b1d                	andi	a4,a4,7
    80004d2a:	0706                	slli	a4,a4,0x1
    80004d2c:	96ba                	add	a3,a3,a4
    80004d2e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d32:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d36:	6798                	ld	a4,8(a5)
    80004d38:	00275783          	lhu	a5,2(a4)
    80004d3c:	2785                	addiw	a5,a5,1
    80004d3e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d42:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d46:	100017b7          	lui	a5,0x10001
    80004d4a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d4e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d52:	00016917          	auipc	s2,0x16
    80004d56:	7c690913          	addi	s2,s2,1990 # 8001b518 <disk+0x128>
  while(b->disk == 1) {
    80004d5a:	84ae                	mv	s1,a1
    80004d5c:	00b79a63          	bne	a5,a1,80004d70 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d60:	85ca                	mv	a1,s2
    80004d62:	854e                	mv	a0,s3
    80004d64:	e00fc0ef          	jal	80001364 <sleep>
  while(b->disk == 1) {
    80004d68:	0049a783          	lw	a5,4(s3)
    80004d6c:	fe978ae3          	beq	a5,s1,80004d60 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d70:	fa042903          	lw	s2,-96(s0)
    80004d74:	00491713          	slli	a4,s2,0x4
    80004d78:	02070713          	addi	a4,a4,32
    80004d7c:	00016797          	auipc	a5,0x16
    80004d80:	67478793          	addi	a5,a5,1652 # 8001b3f0 <disk>
    80004d84:	97ba                	add	a5,a5,a4
    80004d86:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d8a:	00016997          	auipc	s3,0x16
    80004d8e:	66698993          	addi	s3,s3,1638 # 8001b3f0 <disk>
    80004d92:	00491713          	slli	a4,s2,0x4
    80004d96:	0009b783          	ld	a5,0(s3)
    80004d9a:	97ba                	add	a5,a5,a4
    80004d9c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004da0:	854a                	mv	a0,s2
    80004da2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004da6:	bddff0ef          	jal	80004982 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004daa:	8885                	andi	s1,s1,1
    80004dac:	f0fd                	bnez	s1,80004d92 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004dae:	00016517          	auipc	a0,0x16
    80004db2:	76a50513          	addi	a0,a0,1898 # 8001b518 <disk+0x128>
    80004db6:	45b000ef          	jal	80005a10 <release>
}
    80004dba:	60e6                	ld	ra,88(sp)
    80004dbc:	6446                	ld	s0,80(sp)
    80004dbe:	64a6                	ld	s1,72(sp)
    80004dc0:	6906                	ld	s2,64(sp)
    80004dc2:	79e2                	ld	s3,56(sp)
    80004dc4:	7a42                	ld	s4,48(sp)
    80004dc6:	7aa2                	ld	s5,40(sp)
    80004dc8:	7b02                	ld	s6,32(sp)
    80004dca:	6be2                	ld	s7,24(sp)
    80004dcc:	6c42                	ld	s8,16(sp)
    80004dce:	6125                	addi	sp,sp,96
    80004dd0:	8082                	ret

0000000080004dd2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004dd2:	1101                	addi	sp,sp,-32
    80004dd4:	ec06                	sd	ra,24(sp)
    80004dd6:	e822                	sd	s0,16(sp)
    80004dd8:	e426                	sd	s1,8(sp)
    80004dda:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004ddc:	00016497          	auipc	s1,0x16
    80004de0:	61448493          	addi	s1,s1,1556 # 8001b3f0 <disk>
    80004de4:	00016517          	auipc	a0,0x16
    80004de8:	73450513          	addi	a0,a0,1844 # 8001b518 <disk+0x128>
    80004dec:	391000ef          	jal	8000597c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004df0:	100017b7          	lui	a5,0x10001
    80004df4:	53bc                	lw	a5,96(a5)
    80004df6:	8b8d                	andi	a5,a5,3
    80004df8:	10001737          	lui	a4,0x10001
    80004dfc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004dfe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e02:	689c                	ld	a5,16(s1)
    80004e04:	0204d703          	lhu	a4,32(s1)
    80004e08:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e0c:	04f70863          	beq	a4,a5,80004e5c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004e10:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e14:	6898                	ld	a4,16(s1)
    80004e16:	0204d783          	lhu	a5,32(s1)
    80004e1a:	8b9d                	andi	a5,a5,7
    80004e1c:	078e                	slli	a5,a5,0x3
    80004e1e:	97ba                	add	a5,a5,a4
    80004e20:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e22:	00479713          	slli	a4,a5,0x4
    80004e26:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004e2a:	9726                	add	a4,a4,s1
    80004e2c:	01074703          	lbu	a4,16(a4)
    80004e30:	e329                	bnez	a4,80004e72 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e32:	0792                	slli	a5,a5,0x4
    80004e34:	02078793          	addi	a5,a5,32
    80004e38:	97a6                	add	a5,a5,s1
    80004e3a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e3c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e40:	d70fc0ef          	jal	800013b0 <wakeup>

    disk.used_idx += 1;
    80004e44:	0204d783          	lhu	a5,32(s1)
    80004e48:	2785                	addiw	a5,a5,1
    80004e4a:	17c2                	slli	a5,a5,0x30
    80004e4c:	93c1                	srli	a5,a5,0x30
    80004e4e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e52:	6898                	ld	a4,16(s1)
    80004e54:	00275703          	lhu	a4,2(a4)
    80004e58:	faf71ce3          	bne	a4,a5,80004e10 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e5c:	00016517          	auipc	a0,0x16
    80004e60:	6bc50513          	addi	a0,a0,1724 # 8001b518 <disk+0x128>
    80004e64:	3ad000ef          	jal	80005a10 <release>
}
    80004e68:	60e2                	ld	ra,24(sp)
    80004e6a:	6442                	ld	s0,16(sp)
    80004e6c:	64a2                	ld	s1,8(sp)
    80004e6e:	6105                	addi	sp,sp,32
    80004e70:	8082                	ret
      panic("virtio_disk_intr status");
    80004e72:	00003517          	auipc	a0,0x3
    80004e76:	88650513          	addi	a0,a0,-1914 # 800076f8 <etext+0x6f8>
    80004e7a:	7c4000ef          	jal	8000563e <panic>

0000000080004e7e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e7e:	1141                	addi	sp,sp,-16
    80004e80:	e406                	sd	ra,8(sp)
    80004e82:	e022                	sd	s0,0(sp)
    80004e84:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e86:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e8a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e8e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e92:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e96:	577d                	li	a4,-1
    80004e98:	177e                	slli	a4,a4,0x3f
    80004e9a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e9c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004ea0:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004ea4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004ea8:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004eac:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004eb0:	000f4737          	lui	a4,0xf4
    80004eb4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004eb8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004eba:	14d79073          	csrw	stimecmp,a5
}
    80004ebe:	60a2                	ld	ra,8(sp)
    80004ec0:	6402                	ld	s0,0(sp)
    80004ec2:	0141                	addi	sp,sp,16
    80004ec4:	8082                	ret

0000000080004ec6 <start>:
{
    80004ec6:	1141                	addi	sp,sp,-16
    80004ec8:	e406                	sd	ra,8(sp)
    80004eca:	e022                	sd	s0,0(sp)
    80004ecc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ece:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004ed2:	7779                	lui	a4,0xffffe
    80004ed4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb1cf>
    80004ed8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004eda:	6705                	lui	a4,0x1
    80004edc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ee0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ee2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ee6:	ffffb797          	auipc	a5,0xffffb
    80004eea:	42e78793          	addi	a5,a5,1070 # 80000314 <main>
    80004eee:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004ef2:	4781                	li	a5,0
    80004ef4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ef8:	67c1                	lui	a5,0x10
    80004efa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004efc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004f00:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004f04:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004f08:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004f0c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004f10:	57fd                	li	a5,-1
    80004f12:	83a9                	srli	a5,a5,0xa
    80004f14:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004f18:	47bd                	li	a5,15
    80004f1a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f1e:	f61ff0ef          	jal	80004e7e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004f22:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f26:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f28:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f2a:	30200073          	mret
}
    80004f2e:	60a2                	ld	ra,8(sp)
    80004f30:	6402                	ld	s0,0(sp)
    80004f32:	0141                	addi	sp,sp,16
    80004f34:	8082                	ret

0000000080004f36 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f36:	711d                	addi	sp,sp,-96
    80004f38:	ec86                	sd	ra,88(sp)
    80004f3a:	e8a2                	sd	s0,80(sp)
    80004f3c:	e0ca                	sd	s2,64(sp)
    80004f3e:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004f40:	04c05763          	blez	a2,80004f8e <consolewrite+0x58>
    80004f44:	e4a6                	sd	s1,72(sp)
    80004f46:	fc4e                	sd	s3,56(sp)
    80004f48:	f852                	sd	s4,48(sp)
    80004f4a:	f456                	sd	s5,40(sp)
    80004f4c:	f05a                	sd	s6,32(sp)
    80004f4e:	ec5e                	sd	s7,24(sp)
    80004f50:	8a2a                	mv	s4,a0
    80004f52:	84ae                	mv	s1,a1
    80004f54:	89b2                	mv	s3,a2
    80004f56:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f58:	faf40b93          	addi	s7,s0,-81
    80004f5c:	4b05                	li	s6,1
    80004f5e:	5afd                	li	s5,-1
    80004f60:	86da                	mv	a3,s6
    80004f62:	8626                	mv	a2,s1
    80004f64:	85d2                	mv	a1,s4
    80004f66:	855e                	mv	a0,s7
    80004f68:	fa0fc0ef          	jal	80001708 <either_copyin>
    80004f6c:	03550363          	beq	a0,s5,80004f92 <consolewrite+0x5c>
      break;
    uartputc(c);
    80004f70:	faf44503          	lbu	a0,-81(s0)
    80004f74:	06b000ef          	jal	800057de <uartputc>
  for(i = 0; i < n; i++){
    80004f78:	2905                	addiw	s2,s2,1
    80004f7a:	0485                	addi	s1,s1,1
    80004f7c:	ff2992e3          	bne	s3,s2,80004f60 <consolewrite+0x2a>
    80004f80:	64a6                	ld	s1,72(sp)
    80004f82:	79e2                	ld	s3,56(sp)
    80004f84:	7a42                	ld	s4,48(sp)
    80004f86:	7aa2                	ld	s5,40(sp)
    80004f88:	7b02                	ld	s6,32(sp)
    80004f8a:	6be2                	ld	s7,24(sp)
    80004f8c:	a809                	j	80004f9e <consolewrite+0x68>
    80004f8e:	4901                	li	s2,0
    80004f90:	a039                	j	80004f9e <consolewrite+0x68>
    80004f92:	64a6                	ld	s1,72(sp)
    80004f94:	79e2                	ld	s3,56(sp)
    80004f96:	7a42                	ld	s4,48(sp)
    80004f98:	7aa2                	ld	s5,40(sp)
    80004f9a:	7b02                	ld	s6,32(sp)
    80004f9c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004f9e:	854a                	mv	a0,s2
    80004fa0:	60e6                	ld	ra,88(sp)
    80004fa2:	6446                	ld	s0,80(sp)
    80004fa4:	6906                	ld	s2,64(sp)
    80004fa6:	6125                	addi	sp,sp,96
    80004fa8:	8082                	ret

0000000080004faa <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004faa:	711d                	addi	sp,sp,-96
    80004fac:	ec86                	sd	ra,88(sp)
    80004fae:	e8a2                	sd	s0,80(sp)
    80004fb0:	e4a6                	sd	s1,72(sp)
    80004fb2:	e0ca                	sd	s2,64(sp)
    80004fb4:	fc4e                	sd	s3,56(sp)
    80004fb6:	f852                	sd	s4,48(sp)
    80004fb8:	f05a                	sd	s6,32(sp)
    80004fba:	ec5e                	sd	s7,24(sp)
    80004fbc:	1080                	addi	s0,sp,96
    80004fbe:	8b2a                	mv	s6,a0
    80004fc0:	8a2e                	mv	s4,a1
    80004fc2:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fc4:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80004fc6:	0001e517          	auipc	a0,0x1e
    80004fca:	56a50513          	addi	a0,a0,1386 # 80023530 <cons>
    80004fce:	1af000ef          	jal	8000597c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fd2:	0001e497          	auipc	s1,0x1e
    80004fd6:	55e48493          	addi	s1,s1,1374 # 80023530 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fda:	0001e917          	auipc	s2,0x1e
    80004fde:	5ee90913          	addi	s2,s2,1518 # 800235c8 <cons+0x98>
  while(n > 0){
    80004fe2:	0b305b63          	blez	s3,80005098 <consoleread+0xee>
    while(cons.r == cons.w){
    80004fe6:	0984a783          	lw	a5,152(s1)
    80004fea:	09c4a703          	lw	a4,156(s1)
    80004fee:	0af71063          	bne	a4,a5,8000508e <consoleread+0xe4>
      if(killed(myproc())){
    80004ff2:	d95fb0ef          	jal	80000d86 <myproc>
    80004ff6:	daafc0ef          	jal	800015a0 <killed>
    80004ffa:	e12d                	bnez	a0,8000505c <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004ffc:	85a6                	mv	a1,s1
    80004ffe:	854a                	mv	a0,s2
    80005000:	b64fc0ef          	jal	80001364 <sleep>
    while(cons.r == cons.w){
    80005004:	0984a783          	lw	a5,152(s1)
    80005008:	09c4a703          	lw	a4,156(s1)
    8000500c:	fef703e3          	beq	a4,a5,80004ff2 <consoleread+0x48>
    80005010:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005012:	0001e717          	auipc	a4,0x1e
    80005016:	51e70713          	addi	a4,a4,1310 # 80023530 <cons>
    8000501a:	0017869b          	addiw	a3,a5,1
    8000501e:	08d72c23          	sw	a3,152(a4)
    80005022:	07f7f693          	andi	a3,a5,127
    80005026:	9736                	add	a4,a4,a3
    80005028:	01874703          	lbu	a4,24(a4)
    8000502c:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    80005030:	4691                	li	a3,4
    80005032:	04da8663          	beq	s5,a3,8000507e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005036:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000503a:	4685                	li	a3,1
    8000503c:	faf40613          	addi	a2,s0,-81
    80005040:	85d2                	mv	a1,s4
    80005042:	855a                	mv	a0,s6
    80005044:	e7afc0ef          	jal	800016be <either_copyout>
    80005048:	57fd                	li	a5,-1
    8000504a:	04f50663          	beq	a0,a5,80005096 <consoleread+0xec>
      break;

    dst++;
    8000504e:	0a05                	addi	s4,s4,1
    --n;
    80005050:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005052:	47a9                	li	a5,10
    80005054:	04fa8b63          	beq	s5,a5,800050aa <consoleread+0x100>
    80005058:	7aa2                	ld	s5,40(sp)
    8000505a:	b761                	j	80004fe2 <consoleread+0x38>
        release(&cons.lock);
    8000505c:	0001e517          	auipc	a0,0x1e
    80005060:	4d450513          	addi	a0,a0,1236 # 80023530 <cons>
    80005064:	1ad000ef          	jal	80005a10 <release>
        return -1;
    80005068:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000506a:	60e6                	ld	ra,88(sp)
    8000506c:	6446                	ld	s0,80(sp)
    8000506e:	64a6                	ld	s1,72(sp)
    80005070:	6906                	ld	s2,64(sp)
    80005072:	79e2                	ld	s3,56(sp)
    80005074:	7a42                	ld	s4,48(sp)
    80005076:	7b02                	ld	s6,32(sp)
    80005078:	6be2                	ld	s7,24(sp)
    8000507a:	6125                	addi	sp,sp,96
    8000507c:	8082                	ret
      if(n < target){
    8000507e:	0179fa63          	bgeu	s3,s7,80005092 <consoleread+0xe8>
        cons.r--;
    80005082:	0001e717          	auipc	a4,0x1e
    80005086:	54f72323          	sw	a5,1350(a4) # 800235c8 <cons+0x98>
    8000508a:	7aa2                	ld	s5,40(sp)
    8000508c:	a031                	j	80005098 <consoleread+0xee>
    8000508e:	f456                	sd	s5,40(sp)
    80005090:	b749                	j	80005012 <consoleread+0x68>
    80005092:	7aa2                	ld	s5,40(sp)
    80005094:	a011                	j	80005098 <consoleread+0xee>
    80005096:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005098:	0001e517          	auipc	a0,0x1e
    8000509c:	49850513          	addi	a0,a0,1176 # 80023530 <cons>
    800050a0:	171000ef          	jal	80005a10 <release>
  return target - n;
    800050a4:	413b853b          	subw	a0,s7,s3
    800050a8:	b7c9                	j	8000506a <consoleread+0xc0>
    800050aa:	7aa2                	ld	s5,40(sp)
    800050ac:	b7f5                	j	80005098 <consoleread+0xee>

00000000800050ae <consputc>:
{
    800050ae:	1141                	addi	sp,sp,-16
    800050b0:	e406                	sd	ra,8(sp)
    800050b2:	e022                	sd	s0,0(sp)
    800050b4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800050b6:	10000793          	li	a5,256
    800050ba:	00f50863          	beq	a0,a5,800050ca <consputc+0x1c>
    uartputc_sync(c);
    800050be:	63e000ef          	jal	800056fc <uartputc_sync>
}
    800050c2:	60a2                	ld	ra,8(sp)
    800050c4:	6402                	ld	s0,0(sp)
    800050c6:	0141                	addi	sp,sp,16
    800050c8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050ca:	4521                	li	a0,8
    800050cc:	630000ef          	jal	800056fc <uartputc_sync>
    800050d0:	02000513          	li	a0,32
    800050d4:	628000ef          	jal	800056fc <uartputc_sync>
    800050d8:	4521                	li	a0,8
    800050da:	622000ef          	jal	800056fc <uartputc_sync>
    800050de:	b7d5                	j	800050c2 <consputc+0x14>

00000000800050e0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050e0:	1101                	addi	sp,sp,-32
    800050e2:	ec06                	sd	ra,24(sp)
    800050e4:	e822                	sd	s0,16(sp)
    800050e6:	e426                	sd	s1,8(sp)
    800050e8:	1000                	addi	s0,sp,32
    800050ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050ec:	0001e517          	auipc	a0,0x1e
    800050f0:	44450513          	addi	a0,a0,1092 # 80023530 <cons>
    800050f4:	089000ef          	jal	8000597c <acquire>

  switch(c){
    800050f8:	47d5                	li	a5,21
    800050fa:	08f48d63          	beq	s1,a5,80005194 <consoleintr+0xb4>
    800050fe:	0297c563          	blt	a5,s1,80005128 <consoleintr+0x48>
    80005102:	47a1                	li	a5,8
    80005104:	0ef48263          	beq	s1,a5,800051e8 <consoleintr+0x108>
    80005108:	47c1                	li	a5,16
    8000510a:	10f49363          	bne	s1,a5,80005210 <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000510e:	e44fc0ef          	jal	80001752 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005112:	0001e517          	auipc	a0,0x1e
    80005116:	41e50513          	addi	a0,a0,1054 # 80023530 <cons>
    8000511a:	0f7000ef          	jal	80005a10 <release>
}
    8000511e:	60e2                	ld	ra,24(sp)
    80005120:	6442                	ld	s0,16(sp)
    80005122:	64a2                	ld	s1,8(sp)
    80005124:	6105                	addi	sp,sp,32
    80005126:	8082                	ret
  switch(c){
    80005128:	07f00793          	li	a5,127
    8000512c:	0af48e63          	beq	s1,a5,800051e8 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005130:	0001e717          	auipc	a4,0x1e
    80005134:	40070713          	addi	a4,a4,1024 # 80023530 <cons>
    80005138:	0a072783          	lw	a5,160(a4)
    8000513c:	09872703          	lw	a4,152(a4)
    80005140:	9f99                	subw	a5,a5,a4
    80005142:	07f00713          	li	a4,127
    80005146:	fcf766e3          	bltu	a4,a5,80005112 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000514a:	47b5                	li	a5,13
    8000514c:	0cf48563          	beq	s1,a5,80005216 <consoleintr+0x136>
      consputc(c);
    80005150:	8526                	mv	a0,s1
    80005152:	f5dff0ef          	jal	800050ae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005156:	0001e717          	auipc	a4,0x1e
    8000515a:	3da70713          	addi	a4,a4,986 # 80023530 <cons>
    8000515e:	0a072683          	lw	a3,160(a4)
    80005162:	0016879b          	addiw	a5,a3,1
    80005166:	863e                	mv	a2,a5
    80005168:	0af72023          	sw	a5,160(a4)
    8000516c:	07f6f693          	andi	a3,a3,127
    80005170:	9736                	add	a4,a4,a3
    80005172:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005176:	ff648713          	addi	a4,s1,-10
    8000517a:	c371                	beqz	a4,8000523e <consoleintr+0x15e>
    8000517c:	14f1                	addi	s1,s1,-4
    8000517e:	c0e1                	beqz	s1,8000523e <consoleintr+0x15e>
    80005180:	0001e717          	auipc	a4,0x1e
    80005184:	44872703          	lw	a4,1096(a4) # 800235c8 <cons+0x98>
    80005188:	9f99                	subw	a5,a5,a4
    8000518a:	08000713          	li	a4,128
    8000518e:	f8e792e3          	bne	a5,a4,80005112 <consoleintr+0x32>
    80005192:	a075                	j	8000523e <consoleintr+0x15e>
    80005194:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005196:	0001e717          	auipc	a4,0x1e
    8000519a:	39a70713          	addi	a4,a4,922 # 80023530 <cons>
    8000519e:	0a072783          	lw	a5,160(a4)
    800051a2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051a6:	0001e497          	auipc	s1,0x1e
    800051aa:	38a48493          	addi	s1,s1,906 # 80023530 <cons>
    while(cons.e != cons.w &&
    800051ae:	4929                	li	s2,10
    800051b0:	02f70863          	beq	a4,a5,800051e0 <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051b4:	37fd                	addiw	a5,a5,-1
    800051b6:	07f7f713          	andi	a4,a5,127
    800051ba:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051bc:	01874703          	lbu	a4,24(a4)
    800051c0:	03270263          	beq	a4,s2,800051e4 <consoleintr+0x104>
      cons.e--;
    800051c4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051c8:	10000513          	li	a0,256
    800051cc:	ee3ff0ef          	jal	800050ae <consputc>
    while(cons.e != cons.w &&
    800051d0:	0a04a783          	lw	a5,160(s1)
    800051d4:	09c4a703          	lw	a4,156(s1)
    800051d8:	fcf71ee3          	bne	a4,a5,800051b4 <consoleintr+0xd4>
    800051dc:	6902                	ld	s2,0(sp)
    800051de:	bf15                	j	80005112 <consoleintr+0x32>
    800051e0:	6902                	ld	s2,0(sp)
    800051e2:	bf05                	j	80005112 <consoleintr+0x32>
    800051e4:	6902                	ld	s2,0(sp)
    800051e6:	b735                	j	80005112 <consoleintr+0x32>
    if(cons.e != cons.w){
    800051e8:	0001e717          	auipc	a4,0x1e
    800051ec:	34870713          	addi	a4,a4,840 # 80023530 <cons>
    800051f0:	0a072783          	lw	a5,160(a4)
    800051f4:	09c72703          	lw	a4,156(a4)
    800051f8:	f0f70de3          	beq	a4,a5,80005112 <consoleintr+0x32>
      cons.e--;
    800051fc:	37fd                	addiw	a5,a5,-1
    800051fe:	0001e717          	auipc	a4,0x1e
    80005202:	3cf72923          	sw	a5,978(a4) # 800235d0 <cons+0xa0>
      consputc(BACKSPACE);
    80005206:	10000513          	li	a0,256
    8000520a:	ea5ff0ef          	jal	800050ae <consputc>
    8000520e:	b711                	j	80005112 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005210:	f00481e3          	beqz	s1,80005112 <consoleintr+0x32>
    80005214:	bf31                	j	80005130 <consoleintr+0x50>
      consputc(c);
    80005216:	4529                	li	a0,10
    80005218:	e97ff0ef          	jal	800050ae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000521c:	0001e797          	auipc	a5,0x1e
    80005220:	31478793          	addi	a5,a5,788 # 80023530 <cons>
    80005224:	0a07a703          	lw	a4,160(a5)
    80005228:	0017069b          	addiw	a3,a4,1
    8000522c:	8636                	mv	a2,a3
    8000522e:	0ad7a023          	sw	a3,160(a5)
    80005232:	07f77713          	andi	a4,a4,127
    80005236:	97ba                	add	a5,a5,a4
    80005238:	4729                	li	a4,10
    8000523a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000523e:	0001e797          	auipc	a5,0x1e
    80005242:	38c7a723          	sw	a2,910(a5) # 800235cc <cons+0x9c>
        wakeup(&cons.r);
    80005246:	0001e517          	auipc	a0,0x1e
    8000524a:	38250513          	addi	a0,a0,898 # 800235c8 <cons+0x98>
    8000524e:	962fc0ef          	jal	800013b0 <wakeup>
    80005252:	b5c1                	j	80005112 <consoleintr+0x32>

0000000080005254 <consoleinit>:

void
consoleinit(void)
{
    80005254:	1141                	addi	sp,sp,-16
    80005256:	e406                	sd	ra,8(sp)
    80005258:	e022                	sd	s0,0(sp)
    8000525a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000525c:	00002597          	auipc	a1,0x2
    80005260:	4b458593          	addi	a1,a1,1204 # 80007710 <etext+0x710>
    80005264:	0001e517          	auipc	a0,0x1e
    80005268:	2cc50513          	addi	a0,a0,716 # 80023530 <cons>
    8000526c:	686000ef          	jal	800058f2 <initlock>

  uartinit();
    80005270:	436000ef          	jal	800056a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005274:	00015797          	auipc	a5,0x15
    80005278:	12478793          	addi	a5,a5,292 # 8001a398 <devsw>
    8000527c:	00000717          	auipc	a4,0x0
    80005280:	d2e70713          	addi	a4,a4,-722 # 80004faa <consoleread>
    80005284:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005286:	00000717          	auipc	a4,0x0
    8000528a:	cb070713          	addi	a4,a4,-848 # 80004f36 <consolewrite>
    8000528e:	ef98                	sd	a4,24(a5)
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005298:	7179                	addi	sp,sp,-48
    8000529a:	f406                	sd	ra,40(sp)
    8000529c:	f022                	sd	s0,32(sp)
    8000529e:	e84a                	sd	s2,16(sp)
    800052a0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800052a2:	c219                	beqz	a2,800052a8 <printint+0x10>
    800052a4:	08054163          	bltz	a0,80005326 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    800052a8:	4301                	li	t1,0

  i = 0;
    800052aa:	fd040913          	addi	s2,s0,-48
    x = xx;
    800052ae:	86ca                	mv	a3,s2
  i = 0;
    800052b0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800052b2:	00002817          	auipc	a6,0x2
    800052b6:	5ce80813          	addi	a6,a6,1486 # 80007880 <digits>
    800052ba:	88ba                	mv	a7,a4
    800052bc:	0017061b          	addiw	a2,a4,1
    800052c0:	8732                	mv	a4,a2
    800052c2:	02b577b3          	remu	a5,a0,a1
    800052c6:	97c2                	add	a5,a5,a6
    800052c8:	0007c783          	lbu	a5,0(a5)
    800052cc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800052d0:	87aa                	mv	a5,a0
    800052d2:	02b55533          	divu	a0,a0,a1
    800052d6:	0685                	addi	a3,a3,1
    800052d8:	feb7f1e3          	bgeu	a5,a1,800052ba <printint+0x22>

  if(sign)
    800052dc:	00030c63          	beqz	t1,800052f4 <printint+0x5c>
    buf[i++] = '-';
    800052e0:	fe060793          	addi	a5,a2,-32
    800052e4:	00878633          	add	a2,a5,s0
    800052e8:	02d00793          	li	a5,45
    800052ec:	fef60823          	sb	a5,-16(a2)
    800052f0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800052f4:	02e05463          	blez	a4,8000531c <printint+0x84>
    800052f8:	ec26                	sd	s1,24(sp)
    800052fa:	377d                	addiw	a4,a4,-1
    800052fc:	00e904b3          	add	s1,s2,a4
    80005300:	197d                	addi	s2,s2,-1
    80005302:	993a                	add	s2,s2,a4
    80005304:	1702                	slli	a4,a4,0x20
    80005306:	9301                	srli	a4,a4,0x20
    80005308:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000530c:	0004c503          	lbu	a0,0(s1)
    80005310:	d9fff0ef          	jal	800050ae <consputc>
  while(--i >= 0)
    80005314:	14fd                	addi	s1,s1,-1
    80005316:	ff249be3          	bne	s1,s2,8000530c <printint+0x74>
    8000531a:	64e2                	ld	s1,24(sp)
}
    8000531c:	70a2                	ld	ra,40(sp)
    8000531e:	7402                	ld	s0,32(sp)
    80005320:	6942                	ld	s2,16(sp)
    80005322:	6145                	addi	sp,sp,48
    80005324:	8082                	ret
    x = -xx;
    80005326:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000532a:	4305                	li	t1,1
    x = -xx;
    8000532c:	bfbd                	j	800052aa <printint+0x12>

000000008000532e <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000532e:	7131                	addi	sp,sp,-192
    80005330:	fc86                	sd	ra,120(sp)
    80005332:	f8a2                	sd	s0,112(sp)
    80005334:	f0ca                	sd	s2,96(sp)
    80005336:	ec6e                	sd	s11,24(sp)
    80005338:	0100                	addi	s0,sp,128
    8000533a:	892a                	mv	s2,a0
    8000533c:	e40c                	sd	a1,8(s0)
    8000533e:	e810                	sd	a2,16(s0)
    80005340:	ec14                	sd	a3,24(s0)
    80005342:	f018                	sd	a4,32(s0)
    80005344:	f41c                	sd	a5,40(s0)
    80005346:	03043823          	sd	a6,48(s0)
    8000534a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000534e:	0001ed97          	auipc	s11,0x1e
    80005352:	2a2dad83          	lw	s11,674(s11) # 800235f0 <pr+0x18>
  if(locking)
    80005356:	020d9d63          	bnez	s11,80005390 <printf+0x62>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000535a:	00840793          	addi	a5,s0,8
    8000535e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005362:	00054503          	lbu	a0,0(a0)
    80005366:	20050f63          	beqz	a0,80005584 <printf+0x256>
    8000536a:	f4a6                	sd	s1,104(sp)
    8000536c:	ecce                	sd	s3,88(sp)
    8000536e:	e8d2                	sd	s4,80(sp)
    80005370:	e4d6                	sd	s5,72(sp)
    80005372:	e0da                	sd	s6,64(sp)
    80005374:	fc5e                	sd	s7,56(sp)
    80005376:	f862                	sd	s8,48(sp)
    80005378:	f06a                	sd	s10,32(sp)
    8000537a:	4a81                	li	s5,0
    if(cx != '%'){
    8000537c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005380:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005384:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 10, 0);
    80005388:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000538a:	06400b93          	li	s7,100
    8000538e:	a80d                	j	800053c0 <printf+0x92>
    acquire(&pr.lock);
    80005390:	0001e517          	auipc	a0,0x1e
    80005394:	24850513          	addi	a0,a0,584 # 800235d8 <pr>
    80005398:	5e4000ef          	jal	8000597c <acquire>
  va_start(ap, fmt);
    8000539c:	00840793          	addi	a5,s0,8
    800053a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053a4:	00094503          	lbu	a0,0(s2)
    800053a8:	f169                	bnez	a0,8000536a <printf+0x3c>
    800053aa:	aae5                	j	800055a2 <printf+0x274>
      consputc(cx);
    800053ac:	d03ff0ef          	jal	800050ae <consputc>
      continue;
    800053b0:	84d6                	mv	s1,s5
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053b2:	2485                	addiw	s1,s1,1
    800053b4:	8aa6                	mv	s5,s1
    800053b6:	94ca                	add	s1,s1,s2
    800053b8:	0004c503          	lbu	a0,0(s1)
    800053bc:	1a050a63          	beqz	a0,80005570 <printf+0x242>
    if(cx != '%'){
    800053c0:	ff3516e3          	bne	a0,s3,800053ac <printf+0x7e>
    i++;
    800053c4:	001a879b          	addiw	a5,s5,1
    800053c8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800053ca:	00f90733          	add	a4,s2,a5
    800053ce:	00074a03          	lbu	s4,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053d2:	1e0a0863          	beqz	s4,800055c2 <printf+0x294>
    800053d6:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800053da:	1c068b63          	beqz	a3,800055b0 <printf+0x282>
    if(c0 == 'd'){
    800053de:	037a0863          	beq	s4,s7,8000540e <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800053e2:	f94a0713          	addi	a4,s4,-108
    800053e6:	00173713          	seqz	a4,a4
    800053ea:	f9c68613          	addi	a2,a3,-100
    800053ee:	ee05                	bnez	a2,80005426 <printf+0xf8>
    800053f0:	cb1d                	beqz	a4,80005426 <printf+0xf8>
      printint(va_arg(ap, uint64), 10, 1);
    800053f2:	f8843783          	ld	a5,-120(s0)
    800053f6:	00878713          	addi	a4,a5,8
    800053fa:	f8e43423          	sd	a4,-120(s0)
    800053fe:	4605                	li	a2,1
    80005400:	85da                	mv	a1,s6
    80005402:	6388                	ld	a0,0(a5)
    80005404:	e95ff0ef          	jal	80005298 <printint>
      i += 1;
    80005408:	002a849b          	addiw	s1,s5,2
    8000540c:	b75d                	j	800053b2 <printf+0x84>
      printint(va_arg(ap, int), 10, 1);
    8000540e:	f8843783          	ld	a5,-120(s0)
    80005412:	00878713          	addi	a4,a5,8
    80005416:	f8e43423          	sd	a4,-120(s0)
    8000541a:	4605                	li	a2,1
    8000541c:	85da                	mv	a1,s6
    8000541e:	4388                	lw	a0,0(a5)
    80005420:	e79ff0ef          	jal	80005298 <printint>
    80005424:	b779                	j	800053b2 <printf+0x84>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005426:	97ca                	add	a5,a5,s2
    80005428:	8636                	mv	a2,a3
    8000542a:	0027c683          	lbu	a3,2(a5)
    8000542e:	a245                	j	800055ce <printf+0x2a0>
      printint(va_arg(ap, uint64), 10, 1);
    80005430:	f8843783          	ld	a5,-120(s0)
    80005434:	00878713          	addi	a4,a5,8
    80005438:	f8e43423          	sd	a4,-120(s0)
    8000543c:	4605                	li	a2,1
    8000543e:	45a9                	li	a1,10
    80005440:	6388                	ld	a0,0(a5)
    80005442:	e57ff0ef          	jal	80005298 <printint>
      i += 2;
    80005446:	003a849b          	addiw	s1,s5,3
    8000544a:	b7a5                	j	800053b2 <printf+0x84>
      printint(va_arg(ap, int), 10, 0);
    8000544c:	f8843783          	ld	a5,-120(s0)
    80005450:	00878713          	addi	a4,a5,8
    80005454:	f8e43423          	sd	a4,-120(s0)
    80005458:	4601                	li	a2,0
    8000545a:	85da                	mv	a1,s6
    8000545c:	4388                	lw	a0,0(a5)
    8000545e:	e3bff0ef          	jal	80005298 <printint>
    80005462:	bf81                	j	800053b2 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005464:	f8843783          	ld	a5,-120(s0)
    80005468:	00878713          	addi	a4,a5,8
    8000546c:	f8e43423          	sd	a4,-120(s0)
    80005470:	4601                	li	a2,0
    80005472:	85da                	mv	a1,s6
    80005474:	6388                	ld	a0,0(a5)
    80005476:	e23ff0ef          	jal	80005298 <printint>
      i += 1;
    8000547a:	002a849b          	addiw	s1,s5,2
    8000547e:	bf15                	j	800053b2 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005480:	f8843783          	ld	a5,-120(s0)
    80005484:	00878713          	addi	a4,a5,8
    80005488:	f8e43423          	sd	a4,-120(s0)
    8000548c:	4601                	li	a2,0
    8000548e:	45a9                	li	a1,10
    80005490:	6388                	ld	a0,0(a5)
    80005492:	e07ff0ef          	jal	80005298 <printint>
      i += 2;
    80005496:	003a849b          	addiw	s1,s5,3
    8000549a:	bf21                	j	800053b2 <printf+0x84>
      printint(va_arg(ap, int), 16, 0);
    8000549c:	f8843783          	ld	a5,-120(s0)
    800054a0:	00878713          	addi	a4,a5,8
    800054a4:	f8e43423          	sd	a4,-120(s0)
    800054a8:	4601                	li	a2,0
    800054aa:	45c1                	li	a1,16
    800054ac:	4388                	lw	a0,0(a5)
    800054ae:	debff0ef          	jal	80005298 <printint>
    800054b2:	b701                	j	800053b2 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
    800054b4:	f8843783          	ld	a5,-120(s0)
    800054b8:	00878713          	addi	a4,a5,8
    800054bc:	f8e43423          	sd	a4,-120(s0)
    800054c0:	45c1                	li	a1,16
    800054c2:	6388                	ld	a0,0(a5)
    800054c4:	dd5ff0ef          	jal	80005298 <printint>
      i += 1;
    800054c8:	002a849b          	addiw	s1,s5,2
    800054cc:	b5dd                	j	800053b2 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
    800054ce:	f8843783          	ld	a5,-120(s0)
    800054d2:	00878713          	addi	a4,a5,8
    800054d6:	f8e43423          	sd	a4,-120(s0)
    800054da:	4601                	li	a2,0
    800054dc:	45c1                	li	a1,16
    800054de:	6388                	ld	a0,0(a5)
    800054e0:	db9ff0ef          	jal	80005298 <printint>
      i += 2;
    800054e4:	003a849b          	addiw	s1,s5,3
    800054e8:	b5e9                	j	800053b2 <printf+0x84>
    800054ea:	f466                	sd	s9,40(sp)
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    800054ec:	f8843783          	ld	a5,-120(s0)
    800054f0:	00878713          	addi	a4,a5,8
    800054f4:	f8e43423          	sd	a4,-120(s0)
    800054f8:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800054fc:	03000513          	li	a0,48
    80005500:	bafff0ef          	jal	800050ae <consputc>
  consputc('x');
    80005504:	07800513          	li	a0,120
    80005508:	ba7ff0ef          	jal	800050ae <consputc>
    8000550c:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000550e:	00002c97          	auipc	s9,0x2
    80005512:	372c8c93          	addi	s9,s9,882 # 80007880 <digits>
    80005516:	03cad793          	srli	a5,s5,0x3c
    8000551a:	97e6                	add	a5,a5,s9
    8000551c:	0007c503          	lbu	a0,0(a5)
    80005520:	b8fff0ef          	jal	800050ae <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005524:	0a92                	slli	s5,s5,0x4
    80005526:	3a7d                	addiw	s4,s4,-1
    80005528:	fe0a17e3          	bnez	s4,80005516 <printf+0x1e8>
    8000552c:	7ca2                	ld	s9,40(sp)
    8000552e:	b551                	j	800053b2 <printf+0x84>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80005530:	f8843783          	ld	a5,-120(s0)
    80005534:	00878713          	addi	a4,a5,8
    80005538:	f8e43423          	sd	a4,-120(s0)
    8000553c:	0007ba03          	ld	s4,0(a5)
    80005540:	000a0d63          	beqz	s4,8000555a <printf+0x22c>
        s = "(null)";
      for(; *s; s++)
    80005544:	000a4503          	lbu	a0,0(s4)
    80005548:	e60505e3          	beqz	a0,800053b2 <printf+0x84>
        consputc(*s);
    8000554c:	b63ff0ef          	jal	800050ae <consputc>
      for(; *s; s++)
    80005550:	0a05                	addi	s4,s4,1
    80005552:	000a4503          	lbu	a0,0(s4)
    80005556:	f97d                	bnez	a0,8000554c <printf+0x21e>
    80005558:	bda9                	j	800053b2 <printf+0x84>
        s = "(null)";
    8000555a:	00002a17          	auipc	s4,0x2
    8000555e:	1bea0a13          	addi	s4,s4,446 # 80007718 <etext+0x718>
      for(; *s; s++)
    80005562:	02800513          	li	a0,40
    80005566:	b7dd                	j	8000554c <printf+0x21e>
    } else if(c0 == '%'){
      consputc('%');
    80005568:	8552                	mv	a0,s4
    8000556a:	b45ff0ef          	jal	800050ae <consputc>
    8000556e:	b591                	j	800053b2 <printf+0x84>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005570:	020d9163          	bnez	s11,80005592 <printf+0x264>
    80005574:	74a6                	ld	s1,104(sp)
    80005576:	69e6                	ld	s3,88(sp)
    80005578:	6a46                	ld	s4,80(sp)
    8000557a:	6aa6                	ld	s5,72(sp)
    8000557c:	6b06                	ld	s6,64(sp)
    8000557e:	7be2                	ld	s7,56(sp)
    80005580:	7c42                	ld	s8,48(sp)
    80005582:	7d02                	ld	s10,32(sp)
    release(&pr.lock);

  return 0;
}
    80005584:	4501                	li	a0,0
    80005586:	70e6                	ld	ra,120(sp)
    80005588:	7446                	ld	s0,112(sp)
    8000558a:	7906                	ld	s2,96(sp)
    8000558c:	6de2                	ld	s11,24(sp)
    8000558e:	6129                	addi	sp,sp,192
    80005590:	8082                	ret
    80005592:	74a6                	ld	s1,104(sp)
    80005594:	69e6                	ld	s3,88(sp)
    80005596:	6a46                	ld	s4,80(sp)
    80005598:	6aa6                	ld	s5,72(sp)
    8000559a:	6b06                	ld	s6,64(sp)
    8000559c:	7be2                	ld	s7,56(sp)
    8000559e:	7c42                	ld	s8,48(sp)
    800055a0:	7d02                	ld	s10,32(sp)
    release(&pr.lock);
    800055a2:	0001e517          	auipc	a0,0x1e
    800055a6:	03650513          	addi	a0,a0,54 # 800235d8 <pr>
    800055aa:	466000ef          	jal	80005a10 <release>
    800055ae:	bfd9                	j	80005584 <printf+0x256>
    if(c0 == 'd'){
    800055b0:	e57a0fe3          	beq	s4,s7,8000540e <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800055b4:	f94a0713          	addi	a4,s4,-108
    800055b8:	00173713          	seqz	a4,a4
    800055bc:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800055be:	4781                	li	a5,0
    800055c0:	a00d                	j	800055e2 <printf+0x2b4>
    } else if(c0 == 'l' && c1 == 'd'){
    800055c2:	f94a0713          	addi	a4,s4,-108
    800055c6:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800055ca:	8652                	mv	a2,s4
    800055cc:	86d2                	mv	a3,s4
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800055ce:	f9460793          	addi	a5,a2,-108
    800055d2:	0017b793          	seqz	a5,a5
    800055d6:	8ff9                	and	a5,a5,a4
    800055d8:	f9c68593          	addi	a1,a3,-100
    800055dc:	e199                	bnez	a1,800055e2 <printf+0x2b4>
    800055de:	e40799e3          	bnez	a5,80005430 <printf+0x102>
    } else if(c0 == 'u'){
    800055e2:	e78a05e3          	beq	s4,s8,8000544c <printf+0x11e>
    } else if(c0 == 'l' && c1 == 'u'){
    800055e6:	f8b60593          	addi	a1,a2,-117
    800055ea:	e199                	bnez	a1,800055f0 <printf+0x2c2>
    800055ec:	e6071ce3          	bnez	a4,80005464 <printf+0x136>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800055f0:	f8b68593          	addi	a1,a3,-117
    800055f4:	e199                	bnez	a1,800055fa <printf+0x2cc>
    800055f6:	e80795e3          	bnez	a5,80005480 <printf+0x152>
    } else if(c0 == 'x'){
    800055fa:	ebaa01e3          	beq	s4,s10,8000549c <printf+0x16e>
    } else if(c0 == 'l' && c1 == 'x'){
    800055fe:	f8860613          	addi	a2,a2,-120
    80005602:	e219                	bnez	a2,80005608 <printf+0x2da>
    80005604:	ea0718e3          	bnez	a4,800054b4 <printf+0x186>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005608:	f8868693          	addi	a3,a3,-120
    8000560c:	e299                	bnez	a3,80005612 <printf+0x2e4>
    8000560e:	ec0790e3          	bnez	a5,800054ce <printf+0x1a0>
    } else if(c0 == 'p'){
    80005612:	07000793          	li	a5,112
    80005616:	ecfa0ae3          	beq	s4,a5,800054ea <printf+0x1bc>
    } else if(c0 == 's'){
    8000561a:	07300793          	li	a5,115
    8000561e:	f0fa09e3          	beq	s4,a5,80005530 <printf+0x202>
    } else if(c0 == '%'){
    80005622:	02500793          	li	a5,37
    80005626:	f4fa01e3          	beq	s4,a5,80005568 <printf+0x23a>
    } else if(c0 == 0){
    8000562a:	f40a03e3          	beqz	s4,80005570 <printf+0x242>
      consputc('%');
    8000562e:	02500513          	li	a0,37
    80005632:	a7dff0ef          	jal	800050ae <consputc>
      consputc(c0);
    80005636:	8552                	mv	a0,s4
    80005638:	a77ff0ef          	jal	800050ae <consputc>
    8000563c:	bb9d                	j	800053b2 <printf+0x84>

000000008000563e <panic>:

void
panic(char *s)
{
    8000563e:	1101                	addi	sp,sp,-32
    80005640:	ec06                	sd	ra,24(sp)
    80005642:	e822                	sd	s0,16(sp)
    80005644:	e426                	sd	s1,8(sp)
    80005646:	1000                	addi	s0,sp,32
    80005648:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000564a:	0001e797          	auipc	a5,0x1e
    8000564e:	fa07a323          	sw	zero,-90(a5) # 800235f0 <pr+0x18>
  printf("panic: ");
    80005652:	00002517          	auipc	a0,0x2
    80005656:	0ce50513          	addi	a0,a0,206 # 80007720 <etext+0x720>
    8000565a:	cd5ff0ef          	jal	8000532e <printf>
  printf("%s\n", s);
    8000565e:	85a6                	mv	a1,s1
    80005660:	00002517          	auipc	a0,0x2
    80005664:	0c850513          	addi	a0,a0,200 # 80007728 <etext+0x728>
    80005668:	cc7ff0ef          	jal	8000532e <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000566c:	4785                	li	a5,1
    8000566e:	00005717          	auipc	a4,0x5
    80005672:	c6f72f23          	sw	a5,-898(a4) # 8000a2ec <panicked>
  for(;;)
    80005676:	a001                	j	80005676 <panic+0x38>

0000000080005678 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005678:	1141                	addi	sp,sp,-16
    8000567a:	e406                	sd	ra,8(sp)
    8000567c:	e022                	sd	s0,0(sp)
    8000567e:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005680:	00002597          	auipc	a1,0x2
    80005684:	0b058593          	addi	a1,a1,176 # 80007730 <etext+0x730>
    80005688:	0001e517          	auipc	a0,0x1e
    8000568c:	f5050513          	addi	a0,a0,-176 # 800235d8 <pr>
    80005690:	262000ef          	jal	800058f2 <initlock>
  pr.locking = 1;
    80005694:	4785                	li	a5,1
    80005696:	0001e717          	auipc	a4,0x1e
    8000569a:	f4f72d23          	sw	a5,-166(a4) # 800235f0 <pr+0x18>
}
    8000569e:	60a2                	ld	ra,8(sp)
    800056a0:	6402                	ld	s0,0(sp)
    800056a2:	0141                	addi	sp,sp,16
    800056a4:	8082                	ret

00000000800056a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800056a6:	1141                	addi	sp,sp,-16
    800056a8:	e406                	sd	ra,8(sp)
    800056aa:	e022                	sd	s0,0(sp)
    800056ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800056ae:	100007b7          	lui	a5,0x10000
    800056b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800056b6:	10000737          	lui	a4,0x10000
    800056ba:	f8000693          	li	a3,-128
    800056be:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800056c2:	468d                	li	a3,3
    800056c4:	10000637          	lui	a2,0x10000
    800056c8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800056cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800056d0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800056d4:	8732                	mv	a4,a2
    800056d6:	461d                	li	a2,7
    800056d8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056dc:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800056e0:	00002597          	auipc	a1,0x2
    800056e4:	05858593          	addi	a1,a1,88 # 80007738 <etext+0x738>
    800056e8:	0001e517          	auipc	a0,0x1e
    800056ec:	f1050513          	addi	a0,a0,-240 # 800235f8 <uart_tx_lock>
    800056f0:	202000ef          	jal	800058f2 <initlock>
}
    800056f4:	60a2                	ld	ra,8(sp)
    800056f6:	6402                	ld	s0,0(sp)
    800056f8:	0141                	addi	sp,sp,16
    800056fa:	8082                	ret

00000000800056fc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056fc:	1101                	addi	sp,sp,-32
    800056fe:	ec06                	sd	ra,24(sp)
    80005700:	e822                	sd	s0,16(sp)
    80005702:	e426                	sd	s1,8(sp)
    80005704:	1000                	addi	s0,sp,32
    80005706:	84aa                	mv	s1,a0
  push_off();
    80005708:	230000ef          	jal	80005938 <push_off>

  if(panicked){
    8000570c:	00005797          	auipc	a5,0x5
    80005710:	be07a783          	lw	a5,-1056(a5) # 8000a2ec <panicked>
    80005714:	e795                	bnez	a5,80005740 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005716:	10000737          	lui	a4,0x10000
    8000571a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000571c:	00074783          	lbu	a5,0(a4)
    80005720:	0207f793          	andi	a5,a5,32
    80005724:	dfe5                	beqz	a5,8000571c <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80005726:	0ff4f513          	zext.b	a0,s1
    8000572a:	100007b7          	lui	a5,0x10000
    8000572e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005732:	28e000ef          	jal	800059c0 <pop_off>
}
    80005736:	60e2                	ld	ra,24(sp)
    80005738:	6442                	ld	s0,16(sp)
    8000573a:	64a2                	ld	s1,8(sp)
    8000573c:	6105                	addi	sp,sp,32
    8000573e:	8082                	ret
    for(;;)
    80005740:	a001                	j	80005740 <uartputc_sync+0x44>

0000000080005742 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005742:	00005797          	auipc	a5,0x5
    80005746:	bae7b783          	ld	a5,-1106(a5) # 8000a2f0 <uart_tx_r>
    8000574a:	00005717          	auipc	a4,0x5
    8000574e:	bae73703          	ld	a4,-1106(a4) # 8000a2f8 <uart_tx_w>
    80005752:	08f70163          	beq	a4,a5,800057d4 <uartstart+0x92>
{
    80005756:	7139                	addi	sp,sp,-64
    80005758:	fc06                	sd	ra,56(sp)
    8000575a:	f822                	sd	s0,48(sp)
    8000575c:	f426                	sd	s1,40(sp)
    8000575e:	f04a                	sd	s2,32(sp)
    80005760:	ec4e                	sd	s3,24(sp)
    80005762:	e852                	sd	s4,16(sp)
    80005764:	e456                	sd	s5,8(sp)
    80005766:	e05a                	sd	s6,0(sp)
    80005768:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000576a:	10000937          	lui	s2,0x10000
    8000576e:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005770:	0001ea97          	auipc	s5,0x1e
    80005774:	e88a8a93          	addi	s5,s5,-376 # 800235f8 <uart_tx_lock>
    uart_tx_r += 1;
    80005778:	00005497          	auipc	s1,0x5
    8000577c:	b7848493          	addi	s1,s1,-1160 # 8000a2f0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005780:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005784:	00005997          	auipc	s3,0x5
    80005788:	b7498993          	addi	s3,s3,-1164 # 8000a2f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000578c:	00094703          	lbu	a4,0(s2)
    80005790:	02077713          	andi	a4,a4,32
    80005794:	c715                	beqz	a4,800057c0 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005796:	01f7f713          	andi	a4,a5,31
    8000579a:	9756                	add	a4,a4,s5
    8000579c:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800057a0:	0785                	addi	a5,a5,1
    800057a2:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800057a4:	8526                	mv	a0,s1
    800057a6:	c0bfb0ef          	jal	800013b0 <wakeup>
    WriteReg(THR, c);
    800057aa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800057ae:	609c                	ld	a5,0(s1)
    800057b0:	0009b703          	ld	a4,0(s3)
    800057b4:	fcf71ce3          	bne	a4,a5,8000578c <uartstart+0x4a>
      ReadReg(ISR);
    800057b8:	100007b7          	lui	a5,0x10000
    800057bc:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800057c0:	70e2                	ld	ra,56(sp)
    800057c2:	7442                	ld	s0,48(sp)
    800057c4:	74a2                	ld	s1,40(sp)
    800057c6:	7902                	ld	s2,32(sp)
    800057c8:	69e2                	ld	s3,24(sp)
    800057ca:	6a42                	ld	s4,16(sp)
    800057cc:	6aa2                	ld	s5,8(sp)
    800057ce:	6b02                	ld	s6,0(sp)
    800057d0:	6121                	addi	sp,sp,64
    800057d2:	8082                	ret
      ReadReg(ISR);
    800057d4:	100007b7          	lui	a5,0x10000
    800057d8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800057dc:	8082                	ret

00000000800057de <uartputc>:
{
    800057de:	7179                	addi	sp,sp,-48
    800057e0:	f406                	sd	ra,40(sp)
    800057e2:	f022                	sd	s0,32(sp)
    800057e4:	ec26                	sd	s1,24(sp)
    800057e6:	e84a                	sd	s2,16(sp)
    800057e8:	e44e                	sd	s3,8(sp)
    800057ea:	e052                	sd	s4,0(sp)
    800057ec:	1800                	addi	s0,sp,48
    800057ee:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800057f0:	0001e517          	auipc	a0,0x1e
    800057f4:	e0850513          	addi	a0,a0,-504 # 800235f8 <uart_tx_lock>
    800057f8:	184000ef          	jal	8000597c <acquire>
  if(panicked){
    800057fc:	00005797          	auipc	a5,0x5
    80005800:	af07a783          	lw	a5,-1296(a5) # 8000a2ec <panicked>
    80005804:	e3d1                	bnez	a5,80005888 <uartputc+0xaa>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005806:	00005717          	auipc	a4,0x5
    8000580a:	af273703          	ld	a4,-1294(a4) # 8000a2f8 <uart_tx_w>
    8000580e:	00005797          	auipc	a5,0x5
    80005812:	ae27b783          	ld	a5,-1310(a5) # 8000a2f0 <uart_tx_r>
    80005816:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000581a:	0001e997          	auipc	s3,0x1e
    8000581e:	dde98993          	addi	s3,s3,-546 # 800235f8 <uart_tx_lock>
    80005822:	00005497          	auipc	s1,0x5
    80005826:	ace48493          	addi	s1,s1,-1330 # 8000a2f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000582a:	00005917          	auipc	s2,0x5
    8000582e:	ace90913          	addi	s2,s2,-1330 # 8000a2f8 <uart_tx_w>
    80005832:	00e79d63          	bne	a5,a4,8000584c <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005836:	85ce                	mv	a1,s3
    80005838:	8526                	mv	a0,s1
    8000583a:	b2bfb0ef          	jal	80001364 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000583e:	00093703          	ld	a4,0(s2)
    80005842:	609c                	ld	a5,0(s1)
    80005844:	02078793          	addi	a5,a5,32
    80005848:	fee787e3          	beq	a5,a4,80005836 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000584c:	01f77693          	andi	a3,a4,31
    80005850:	0001e797          	auipc	a5,0x1e
    80005854:	da878793          	addi	a5,a5,-600 # 800235f8 <uart_tx_lock>
    80005858:	97b6                	add	a5,a5,a3
    8000585a:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000585e:	0705                	addi	a4,a4,1
    80005860:	00005797          	auipc	a5,0x5
    80005864:	a8e7bc23          	sd	a4,-1384(a5) # 8000a2f8 <uart_tx_w>
  uartstart();
    80005868:	edbff0ef          	jal	80005742 <uartstart>
  release(&uart_tx_lock);
    8000586c:	0001e517          	auipc	a0,0x1e
    80005870:	d8c50513          	addi	a0,a0,-628 # 800235f8 <uart_tx_lock>
    80005874:	19c000ef          	jal	80005a10 <release>
}
    80005878:	70a2                	ld	ra,40(sp)
    8000587a:	7402                	ld	s0,32(sp)
    8000587c:	64e2                	ld	s1,24(sp)
    8000587e:	6942                	ld	s2,16(sp)
    80005880:	69a2                	ld	s3,8(sp)
    80005882:	6a02                	ld	s4,0(sp)
    80005884:	6145                	addi	sp,sp,48
    80005886:	8082                	ret
    for(;;)
    80005888:	a001                	j	80005888 <uartputc+0xaa>

000000008000588a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000588a:	1141                	addi	sp,sp,-16
    8000588c:	e406                	sd	ra,8(sp)
    8000588e:	e022                	sd	s0,0(sp)
    80005890:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005892:	100007b7          	lui	a5,0x10000
    80005896:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000589a:	8b85                	andi	a5,a5,1
    8000589c:	cb89                	beqz	a5,800058ae <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000589e:	100007b7          	lui	a5,0x10000
    800058a2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800058a6:	60a2                	ld	ra,8(sp)
    800058a8:	6402                	ld	s0,0(sp)
    800058aa:	0141                	addi	sp,sp,16
    800058ac:	8082                	ret
    return -1;
    800058ae:	557d                	li	a0,-1
    800058b0:	bfdd                	j	800058a6 <uartgetc+0x1c>

00000000800058b2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800058b2:	1101                	addi	sp,sp,-32
    800058b4:	ec06                	sd	ra,24(sp)
    800058b6:	e822                	sd	s0,16(sp)
    800058b8:	e426                	sd	s1,8(sp)
    800058ba:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800058bc:	54fd                	li	s1,-1
    int c = uartgetc();
    800058be:	fcdff0ef          	jal	8000588a <uartgetc>
    if(c == -1)
    800058c2:	00950563          	beq	a0,s1,800058cc <uartintr+0x1a>
      break;
    consoleintr(c);
    800058c6:	81bff0ef          	jal	800050e0 <consoleintr>
  while(1){
    800058ca:	bfd5                	j	800058be <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800058cc:	0001e517          	auipc	a0,0x1e
    800058d0:	d2c50513          	addi	a0,a0,-724 # 800235f8 <uart_tx_lock>
    800058d4:	0a8000ef          	jal	8000597c <acquire>
  uartstart();
    800058d8:	e6bff0ef          	jal	80005742 <uartstart>
  release(&uart_tx_lock);
    800058dc:	0001e517          	auipc	a0,0x1e
    800058e0:	d1c50513          	addi	a0,a0,-740 # 800235f8 <uart_tx_lock>
    800058e4:	12c000ef          	jal	80005a10 <release>
}
    800058e8:	60e2                	ld	ra,24(sp)
    800058ea:	6442                	ld	s0,16(sp)
    800058ec:	64a2                	ld	s1,8(sp)
    800058ee:	6105                	addi	sp,sp,32
    800058f0:	8082                	ret

00000000800058f2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800058f2:	1141                	addi	sp,sp,-16
    800058f4:	e406                	sd	ra,8(sp)
    800058f6:	e022                	sd	s0,0(sp)
    800058f8:	0800                	addi	s0,sp,16
  lk->name = name;
    800058fa:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800058fc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005900:	00053823          	sd	zero,16(a0)
}
    80005904:	60a2                	ld	ra,8(sp)
    80005906:	6402                	ld	s0,0(sp)
    80005908:	0141                	addi	sp,sp,16
    8000590a:	8082                	ret

000000008000590c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000590c:	411c                	lw	a5,0(a0)
    8000590e:	e399                	bnez	a5,80005914 <holding+0x8>
    80005910:	4501                	li	a0,0
  return r;
}
    80005912:	8082                	ret
{
    80005914:	1101                	addi	sp,sp,-32
    80005916:	ec06                	sd	ra,24(sp)
    80005918:	e822                	sd	s0,16(sp)
    8000591a:	e426                	sd	s1,8(sp)
    8000591c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000591e:	691c                	ld	a5,16(a0)
    80005920:	84be                	mv	s1,a5
    80005922:	c44fb0ef          	jal	80000d66 <mycpu>
    80005926:	40a48533          	sub	a0,s1,a0
    8000592a:	00153513          	seqz	a0,a0
}
    8000592e:	60e2                	ld	ra,24(sp)
    80005930:	6442                	ld	s0,16(sp)
    80005932:	64a2                	ld	s1,8(sp)
    80005934:	6105                	addi	sp,sp,32
    80005936:	8082                	ret

0000000080005938 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005938:	1101                	addi	sp,sp,-32
    8000593a:	ec06                	sd	ra,24(sp)
    8000593c:	e822                	sd	s0,16(sp)
    8000593e:	e426                	sd	s1,8(sp)
    80005940:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005942:	100027f3          	csrr	a5,sstatus
    80005946:	84be                	mv	s1,a5
    80005948:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000594c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000594e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005952:	c14fb0ef          	jal	80000d66 <mycpu>
    80005956:	5d3c                	lw	a5,120(a0)
    80005958:	cb99                	beqz	a5,8000596e <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000595a:	c0cfb0ef          	jal	80000d66 <mycpu>
    8000595e:	5d3c                	lw	a5,120(a0)
    80005960:	2785                	addiw	a5,a5,1
    80005962:	dd3c                	sw	a5,120(a0)
}
    80005964:	60e2                	ld	ra,24(sp)
    80005966:	6442                	ld	s0,16(sp)
    80005968:	64a2                	ld	s1,8(sp)
    8000596a:	6105                	addi	sp,sp,32
    8000596c:	8082                	ret
    mycpu()->intena = old;
    8000596e:	bf8fb0ef          	jal	80000d66 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005972:	0014d793          	srli	a5,s1,0x1
    80005976:	8b85                	andi	a5,a5,1
    80005978:	dd7c                	sw	a5,124(a0)
    8000597a:	b7c5                	j	8000595a <push_off+0x22>

000000008000597c <acquire>:
{
    8000597c:	1101                	addi	sp,sp,-32
    8000597e:	ec06                	sd	ra,24(sp)
    80005980:	e822                	sd	s0,16(sp)
    80005982:	e426                	sd	s1,8(sp)
    80005984:	1000                	addi	s0,sp,32
    80005986:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005988:	fb1ff0ef          	jal	80005938 <push_off>
  if(holding(lk))
    8000598c:	8526                	mv	a0,s1
    8000598e:	f7fff0ef          	jal	8000590c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005992:	4705                	li	a4,1
  if(holding(lk))
    80005994:	e105                	bnez	a0,800059b4 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005996:	87ba                	mv	a5,a4
    80005998:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000599c:	2781                	sext.w	a5,a5
    8000599e:	ffe5                	bnez	a5,80005996 <acquire+0x1a>
  __sync_synchronize();
    800059a0:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800059a4:	bc2fb0ef          	jal	80000d66 <mycpu>
    800059a8:	e888                	sd	a0,16(s1)
}
    800059aa:	60e2                	ld	ra,24(sp)
    800059ac:	6442                	ld	s0,16(sp)
    800059ae:	64a2                	ld	s1,8(sp)
    800059b0:	6105                	addi	sp,sp,32
    800059b2:	8082                	ret
    panic("acquire");
    800059b4:	00002517          	auipc	a0,0x2
    800059b8:	d8c50513          	addi	a0,a0,-628 # 80007740 <etext+0x740>
    800059bc:	c83ff0ef          	jal	8000563e <panic>

00000000800059c0 <pop_off>:

void
pop_off(void)
{
    800059c0:	1141                	addi	sp,sp,-16
    800059c2:	e406                	sd	ra,8(sp)
    800059c4:	e022                	sd	s0,0(sp)
    800059c6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800059c8:	b9efb0ef          	jal	80000d66 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800059d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800059d2:	e39d                	bnez	a5,800059f8 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800059d4:	5d3c                	lw	a5,120(a0)
    800059d6:	02f05763          	blez	a5,80005a04 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800059da:	37fd                	addiw	a5,a5,-1
    800059dc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800059de:	eb89                	bnez	a5,800059f0 <pop_off+0x30>
    800059e0:	5d7c                	lw	a5,124(a0)
    800059e2:	c799                	beqz	a5,800059f0 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800059e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059ec:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800059f0:	60a2                	ld	ra,8(sp)
    800059f2:	6402                	ld	s0,0(sp)
    800059f4:	0141                	addi	sp,sp,16
    800059f6:	8082                	ret
    panic("pop_off - interruptible");
    800059f8:	00002517          	auipc	a0,0x2
    800059fc:	d5050513          	addi	a0,a0,-688 # 80007748 <etext+0x748>
    80005a00:	c3fff0ef          	jal	8000563e <panic>
    panic("pop_off");
    80005a04:	00002517          	auipc	a0,0x2
    80005a08:	d5c50513          	addi	a0,a0,-676 # 80007760 <etext+0x760>
    80005a0c:	c33ff0ef          	jal	8000563e <panic>

0000000080005a10 <release>:
{
    80005a10:	1101                	addi	sp,sp,-32
    80005a12:	ec06                	sd	ra,24(sp)
    80005a14:	e822                	sd	s0,16(sp)
    80005a16:	e426                	sd	s1,8(sp)
    80005a18:	1000                	addi	s0,sp,32
    80005a1a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005a1c:	ef1ff0ef          	jal	8000590c <holding>
    80005a20:	c105                	beqz	a0,80005a40 <release+0x30>
  lk->cpu = 0;
    80005a22:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005a26:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005a2a:	0310000f          	fence	rw,w
    80005a2e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005a32:	f8fff0ef          	jal	800059c0 <pop_off>
}
    80005a36:	60e2                	ld	ra,24(sp)
    80005a38:	6442                	ld	s0,16(sp)
    80005a3a:	64a2                	ld	s1,8(sp)
    80005a3c:	6105                	addi	sp,sp,32
    80005a3e:	8082                	ret
    panic("release");
    80005a40:	00002517          	auipc	a0,0x2
    80005a44:	d2850513          	addi	a0,a0,-728 # 80007768 <etext+0x768>
    80005a48:	bf7ff0ef          	jal	8000563e <panic>
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
