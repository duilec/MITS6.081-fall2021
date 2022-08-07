
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00028117          	auipc	sp,0x28
    80000004:	14010113          	addi	sp,sp,320 # 80028140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	463050ef          	jal	ra,80005c78 <start>

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
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00030797          	auipc	a5,0x30
    80000034:	21078793          	addi	a5,a5,528 # 80030240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	618080e7          	jalr	1560(ra) # 80006672 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	6b8080e7          	jalr	1720(ra) # 80006726 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	09e080e7          	jalr	158(ra) # 80006128 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	4ee080e7          	jalr	1262(ra) # 800065e2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00030517          	auipc	a0,0x30
    80000104:	14050513          	addi	a0,a0,320 # 80030240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	546080e7          	jalr	1350(ra) # 80006672 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	5e2080e7          	jalr	1506(ra) # 80006726 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	5b8080e7          	jalr	1464(ra) # 80006726 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	e16080e7          	jalr	-490(ra) # 80006172 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	86c080e7          	jalr	-1940(ra) # 80001bd8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	28c080e7          	jalr	652(ra) # 80005600 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	046080e7          	jalr	70(ra) # 800013c2 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	cb6080e7          	jalr	-842(ra) # 8000603a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	fcc080e7          	jalr	-52(ra) # 80006358 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	dd6080e7          	jalr	-554(ra) # 80006172 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	dc6080e7          	jalr	-570(ra) # 80006172 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	db6080e7          	jalr	-586(ra) # 80006172 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	7cc080e7          	jalr	1996(ra) # 80001bb0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	7ec080e7          	jalr	2028(ra) # 80001bd8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	1f6080e7          	jalr	502(ra) # 800055ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	204080e7          	jalr	516(ra) # 80005600 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	080080e7          	jalr	128(ra) # 80002484 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	710080e7          	jalr	1808(ra) # 80002b1c <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6ba080e7          	jalr	1722(ra) # 80003ace <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	306080e7          	jalr	774(ra) # 80005722 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	c9a080e7          	jalr	-870(ra) # 80006128 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	ba2080e7          	jalr	-1118(ra) # 80006128 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	b92080e7          	jalr	-1134(ra) # 80006128 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00006097          	auipc	ra,0x6
    80000614:	b18080e7          	jalr	-1256(ra) # 80006128 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	9cc080e7          	jalr	-1588(ra) # 80006128 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	9bc080e7          	jalr	-1604(ra) # 80006128 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	9ac080e7          	jalr	-1620(ra) # 80006128 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00006097          	auipc	ra,0x6
    80000790:	99c080e7          	jalr	-1636(ra) # 80006128 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00006097          	auipc	ra,0x6
    8000086e:	8be080e7          	jalr	-1858(ra) # 80006128 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	77c080e7          	jalr	1916(ra) # 80006128 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{ 
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	6a0080e7          	jalr	1696(ra) # 80006128 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	690080e7          	jalr	1680(ra) # 80006128 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	626080e7          	jalr	1574(ra) # 80006128 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00018a17          	auipc	s4,0x18
    80000d0a:	17aa0a13          	addi	s4,s4,378 # 80018e80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	3e848493          	addi	s1,s1,1000
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	3c4080e7          	jalr	964(ra) # 80006128 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00006097          	auipc	ra,0x6
    80000d94:	852080e7          	jalr	-1966(ra) # 800065e2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00006097          	auipc	ra,0x6
    80000dac:	83a080e7          	jalr	-1990(ra) # 800065e2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00018997          	auipc	s3,0x18
    80000dd6:	0ae98993          	addi	s3,s3,174 # 80018e80 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00006097          	auipc	ra,0x6
    80000de2:	804080e7          	jalr	-2044(ra) # 800065e2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	3e848493          	addi	s1,s1,1000
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	7d4080e7          	jalr	2004(ra) # 80006626 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00006097          	auipc	ra,0x6
    80000e70:	85a080e7          	jalr	-1958(ra) # 800066c6 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00006097          	auipc	ra,0x6
    80000e94:	896080e7          	jalr	-1898(ra) # 80006726 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9887a783          	lw	a5,-1656(a5) # 80008820 <first.1714>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	e8a080e7          	jalr	-374(ra) # 80001d2c <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607a723          	sw	zero,-1682(a5) # 80008820 <first.1714>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	be0080e7          	jalr	-1056(ra) # 80002a9c <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	796080e7          	jalr	1942(ra) # 80006672 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	94078793          	addi	a5,a5,-1728 # 80008824 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00006097          	auipc	ra,0x6
    80000efa:	830080e7          	jalr	-2000(ra) # 80006726 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00018917          	auipc	s2,0x18
    8000106a:	e1a90913          	addi	s2,s2,-486 # 80018e80 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	602080e7          	jalr	1538(ra) # 80006672 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	6a8080e7          	jalr	1704(ra) # 80006726 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	3e848493          	addi	s1,s1,1000
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a889                	j	800010e2 <allocproc+0x90>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c131                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	c531                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
}
    800010e2:	8526                	mv	a0,s1
    800010e4:	60e2                	ld	ra,24(sp)
    800010e6:	6442                	ld	s0,16(sp)
    800010e8:	64a2                	ld	s1,8(sp)
    800010ea:	6902                	ld	s2,0(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	62a080e7          	jalr	1578(ra) # 80006726 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	bff1                	j	800010e2 <allocproc+0x90>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	612080e7          	jalr	1554(ra) # 80006726 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	b7d1                	j	800010e2 <allocproc+0x90>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	6f058593          	addi	a1,a1,1776 # 80008830 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	34c080e7          	jalr	844(ra) # 800034ca <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	596080e7          	jalr	1430(ra) # 80006726 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c20080e7          	jalr	-992(ra) # 80000e48 <myproc>
    80001230:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e20080e7          	jalr	-480(ra) # 80001052 <allocproc>
    8000123a:	18050263          	beqz	a0,800013be <fork+0x1a8>
    8000123e:	8a2a                	mv	s4,a0
    80001240:	17098793          	addi	a5,s3,368
    80001244:	3f098613          	addi	a2,s3,1008
  int length = 0;
    80001248:	4701                	li	a4,0
      length += p->vmas[i].length;
    8000124a:	4394                	lw	a3,0(a5)
    8000124c:	9f35                	addw	a4,a4,a3
  for(int i = 0; i < 16; i++){
    8000124e:	02878793          	addi	a5,a5,40 # 1028 <_entry-0x7fffefd8>
    80001252:	fec79ce3          	bne	a5,a2,8000124a <fork+0x34>
  if(uvmcopy(p->pagetable, np->pagetable, p->sz-length) < 0){
    80001256:	0489b603          	ld	a2,72(s3)
    8000125a:	8e19                	sub	a2,a2,a4
    8000125c:	050a3583          	ld	a1,80(s4)
    80001260:	0509b503          	ld	a0,80(s3)
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	7a2080e7          	jalr	1954(ra) # 80000a06 <uvmcopy>
    8000126c:	00054963          	bltz	a0,8000127e <fork+0x68>
    80001270:	16898493          	addi	s1,s3,360
    80001274:	168a0913          	addi	s2,s4,360
    80001278:	3e898a93          	addi	s5,s3,1000
    8000127c:	a8a1                	j	800012d4 <fork+0xbe>
    freeproc(np);
    8000127e:	8552                	mv	a0,s4
    80001280:	00000097          	auipc	ra,0x0
    80001284:	d7a080e7          	jalr	-646(ra) # 80000ffa <freeproc>
    release(&np->lock);
    80001288:	8552                	mv	a0,s4
    8000128a:	00005097          	auipc	ra,0x5
    8000128e:	49c080e7          	jalr	1180(ra) # 80006726 <release>
    return -1;
    80001292:	597d                	li	s2,-1
    80001294:	aa19                	j	800013aa <fork+0x194>
      np->vmas[i].f = p->vmas[i].f;
    80001296:	609c                	ld	a5,0(s1)
    80001298:	00f93023          	sd	a5,0(s2)
      np->vmas[i].length = p->vmas[i].length;
    8000129c:	449c                	lw	a5,8(s1)
    8000129e:	00f92423          	sw	a5,8(s2)
      np->vmas[i].prot = p->vmas[i].prot;
    800012a2:	44dc                	lw	a5,12(s1)
    800012a4:	00f92623          	sw	a5,12(s2)
      np->vmas[i].flags = p->vmas[i].flags;
    800012a8:	489c                	lw	a5,16(s1)
    800012aa:	00f92823          	sw	a5,16(s2)
      np->vmas[i].offset = 0; // ret offset, becasue we maybe read before fork()
    800012ae:	00092a23          	sw	zero,20(s2)
      np->vmas[i].addr = p->vmas[i].addr;
    800012b2:	709c                	ld	a5,32(s1)
    800012b4:	02f93023          	sd	a5,32(s2)
      np->vmas[i].oldsz = p->vmas[i].oldsz;
    800012b8:	4c9c                	lw	a5,24(s1)
    800012ba:	00f92c23          	sw	a5,24(s2)
      filedup(p->vmas[i].f);
    800012be:	6088                	ld	a0,0(s1)
    800012c0:	00003097          	auipc	ra,0x3
    800012c4:	8a0080e7          	jalr	-1888(ra) # 80003b60 <filedup>
  for(int i = 0; i < 16; i++){
    800012c8:	02848493          	addi	s1,s1,40
    800012cc:	02890913          	addi	s2,s2,40
    800012d0:	01548563          	beq	s1,s5,800012da <fork+0xc4>
    if(p->vmas[i].addr){
    800012d4:	709c                	ld	a5,32(s1)
    800012d6:	dbed                	beqz	a5,800012c8 <fork+0xb2>
    800012d8:	bf7d                	j	80001296 <fork+0x80>
  np->sz = p->sz;
    800012da:	0489b783          	ld	a5,72(s3)
    800012de:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012e2:	0589b683          	ld	a3,88(s3)
    800012e6:	87b6                	mv	a5,a3
    800012e8:	058a3703          	ld	a4,88(s4)
    800012ec:	12068693          	addi	a3,a3,288
    800012f0:	0007b803          	ld	a6,0(a5)
    800012f4:	6788                	ld	a0,8(a5)
    800012f6:	6b8c                	ld	a1,16(a5)
    800012f8:	6f90                	ld	a2,24(a5)
    800012fa:	01073023          	sd	a6,0(a4)
    800012fe:	e708                	sd	a0,8(a4)
    80001300:	eb0c                	sd	a1,16(a4)
    80001302:	ef10                	sd	a2,24(a4)
    80001304:	02078793          	addi	a5,a5,32
    80001308:	02070713          	addi	a4,a4,32
    8000130c:	fed792e3          	bne	a5,a3,800012f0 <fork+0xda>
  np->trapframe->a0 = 0;
    80001310:	058a3783          	ld	a5,88(s4)
    80001314:	0607b823          	sd	zero,112(a5)
    80001318:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000131c:	15000913          	li	s2,336
    80001320:	a819                	j	80001336 <fork+0x120>
      np->ofile[i] = filedup(p->ofile[i]);
    80001322:	00003097          	auipc	ra,0x3
    80001326:	83e080e7          	jalr	-1986(ra) # 80003b60 <filedup>
    8000132a:	009a07b3          	add	a5,s4,s1
    8000132e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001330:	04a1                	addi	s1,s1,8
    80001332:	01248763          	beq	s1,s2,80001340 <fork+0x12a>
    if(p->ofile[i])
    80001336:	009987b3          	add	a5,s3,s1
    8000133a:	6388                	ld	a0,0(a5)
    8000133c:	f17d                	bnez	a0,80001322 <fork+0x10c>
    8000133e:	bfcd                	j	80001330 <fork+0x11a>
  np->cwd = idup(p->cwd);
    80001340:	1509b503          	ld	a0,336(s3)
    80001344:	00002097          	auipc	ra,0x2
    80001348:	992080e7          	jalr	-1646(ra) # 80002cd6 <idup>
    8000134c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001350:	4641                	li	a2,16
    80001352:	15898593          	addi	a1,s3,344
    80001356:	158a0513          	addi	a0,s4,344
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	f70080e7          	jalr	-144(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001362:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	3be080e7          	jalr	958(ra) # 80006726 <release>
  acquire(&wait_lock);
    80001370:	00008497          	auipc	s1,0x8
    80001374:	cf848493          	addi	s1,s1,-776 # 80009068 <wait_lock>
    80001378:	8526                	mv	a0,s1
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	2f8080e7          	jalr	760(ra) # 80006672 <acquire>
  np->parent = p;
    80001382:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    80001386:	8526                	mv	a0,s1
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	39e080e7          	jalr	926(ra) # 80006726 <release>
  acquire(&np->lock);
    80001390:	8552                	mv	a0,s4
    80001392:	00005097          	auipc	ra,0x5
    80001396:	2e0080e7          	jalr	736(ra) # 80006672 <acquire>
  np->state = RUNNABLE;
    8000139a:	478d                	li	a5,3
    8000139c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	384080e7          	jalr	900(ra) # 80006726 <release>
}
    800013aa:	854a                	mv	a0,s2
    800013ac:	70e2                	ld	ra,56(sp)
    800013ae:	7442                	ld	s0,48(sp)
    800013b0:	74a2                	ld	s1,40(sp)
    800013b2:	7902                	ld	s2,32(sp)
    800013b4:	69e2                	ld	s3,24(sp)
    800013b6:	6a42                	ld	s4,16(sp)
    800013b8:	6aa2                	ld	s5,8(sp)
    800013ba:	6121                	addi	sp,sp,64
    800013bc:	8082                	ret
    return -1;
    800013be:	597d                	li	s2,-1
    800013c0:	b7ed                	j	800013aa <fork+0x194>

00000000800013c2 <scheduler>:
{
    800013c2:	7139                	addi	sp,sp,-64
    800013c4:	fc06                	sd	ra,56(sp)
    800013c6:	f822                	sd	s0,48(sp)
    800013c8:	f426                	sd	s1,40(sp)
    800013ca:	f04a                	sd	s2,32(sp)
    800013cc:	ec4e                	sd	s3,24(sp)
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	e456                	sd	s5,8(sp)
    800013d2:	e05a                	sd	s6,0(sp)
    800013d4:	0080                	addi	s0,sp,64
    800013d6:	8792                	mv	a5,tp
  int id = r_tp();
    800013d8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013da:	00779a93          	slli	s5,a5,0x7
    800013de:	00008717          	auipc	a4,0x8
    800013e2:	c7270713          	addi	a4,a4,-910 # 80009050 <pid_lock>
    800013e6:	9756                	add	a4,a4,s5
    800013e8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ec:	00008717          	auipc	a4,0x8
    800013f0:	c9c70713          	addi	a4,a4,-868 # 80009088 <cpus+0x8>
    800013f4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013f6:	498d                	li	s3,3
        p->state = RUNNING;
    800013f8:	4b11                	li	s6,4
        c->proc = p;
    800013fa:	079e                	slli	a5,a5,0x7
    800013fc:	00008a17          	auipc	s4,0x8
    80001400:	c54a0a13          	addi	s4,s4,-940 # 80009050 <pid_lock>
    80001404:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001406:	00018917          	auipc	s2,0x18
    8000140a:	a7a90913          	addi	s2,s2,-1414 # 80018e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000140e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001412:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001416:	10079073          	csrw	sstatus,a5
    8000141a:	00008497          	auipc	s1,0x8
    8000141e:	06648493          	addi	s1,s1,102 # 80009480 <proc>
    80001422:	a03d                	j	80001450 <scheduler+0x8e>
        p->state = RUNNING;
    80001424:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001428:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142c:	06048593          	addi	a1,s1,96
    80001430:	8556                	mv	a0,s5
    80001432:	00000097          	auipc	ra,0x0
    80001436:	714080e7          	jalr	1812(ra) # 80001b46 <swtch>
        c->proc = 0;
    8000143a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000143e:	8526                	mv	a0,s1
    80001440:	00005097          	auipc	ra,0x5
    80001444:	2e6080e7          	jalr	742(ra) # 80006726 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001448:	3e848493          	addi	s1,s1,1000
    8000144c:	fd2481e3          	beq	s1,s2,8000140e <scheduler+0x4c>
      acquire(&p->lock);
    80001450:	8526                	mv	a0,s1
    80001452:	00005097          	auipc	ra,0x5
    80001456:	220080e7          	jalr	544(ra) # 80006672 <acquire>
      if(p->state == RUNNABLE) {
    8000145a:	4c9c                	lw	a5,24(s1)
    8000145c:	ff3791e3          	bne	a5,s3,8000143e <scheduler+0x7c>
    80001460:	b7d1                	j	80001424 <scheduler+0x62>

0000000080001462 <sched>:
{
    80001462:	7179                	addi	sp,sp,-48
    80001464:	f406                	sd	ra,40(sp)
    80001466:	f022                	sd	s0,32(sp)
    80001468:	ec26                	sd	s1,24(sp)
    8000146a:	e84a                	sd	s2,16(sp)
    8000146c:	e44e                	sd	s3,8(sp)
    8000146e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001470:	00000097          	auipc	ra,0x0
    80001474:	9d8080e7          	jalr	-1576(ra) # 80000e48 <myproc>
    80001478:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	17e080e7          	jalr	382(ra) # 800065f8 <holding>
    80001482:	c93d                	beqz	a0,800014f8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001484:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	00008717          	auipc	a4,0x8
    8000148e:	bc670713          	addi	a4,a4,-1082 # 80009050 <pid_lock>
    80001492:	97ba                	add	a5,a5,a4
    80001494:	0a87a703          	lw	a4,168(a5)
    80001498:	4785                	li	a5,1
    8000149a:	06f71763          	bne	a4,a5,80001508 <sched+0xa6>
  if(p->state == RUNNING)
    8000149e:	4c98                	lw	a4,24(s1)
    800014a0:	4791                	li	a5,4
    800014a2:	06f70b63          	beq	a4,a5,80001518 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014aa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014ac:	efb5                	bnez	a5,80001528 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ae:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014b0:	00008917          	auipc	s2,0x8
    800014b4:	ba090913          	addi	s2,s2,-1120 # 80009050 <pid_lock>
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	97ca                	add	a5,a5,s2
    800014be:	0ac7a983          	lw	s3,172(a5)
    800014c2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	slli	a5,a5,0x7
    800014c8:	00008597          	auipc	a1,0x8
    800014cc:	bc058593          	addi	a1,a1,-1088 # 80009088 <cpus+0x8>
    800014d0:	95be                	add	a1,a1,a5
    800014d2:	06048513          	addi	a0,s1,96
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	670080e7          	jalr	1648(ra) # 80001b46 <swtch>
    800014de:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	97ca                	add	a5,a5,s2
    800014e6:	0b37a623          	sw	s3,172(a5)
}
    800014ea:	70a2                	ld	ra,40(sp)
    800014ec:	7402                	ld	s0,32(sp)
    800014ee:	64e2                	ld	s1,24(sp)
    800014f0:	6942                	ld	s2,16(sp)
    800014f2:	69a2                	ld	s3,8(sp)
    800014f4:	6145                	addi	sp,sp,48
    800014f6:	8082                	ret
    panic("sched p->lock");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	ca050513          	addi	a0,a0,-864 # 80008198 <etext+0x198>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	c28080e7          	jalr	-984(ra) # 80006128 <panic>
    panic("sched locks");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	ca050513          	addi	a0,a0,-864 # 800081a8 <etext+0x1a8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	c18080e7          	jalr	-1000(ra) # 80006128 <panic>
    panic("sched running");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	ca050513          	addi	a0,a0,-864 # 800081b8 <etext+0x1b8>
    80001520:	00005097          	auipc	ra,0x5
    80001524:	c08080e7          	jalr	-1016(ra) # 80006128 <panic>
    panic("sched interruptible");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	ca050513          	addi	a0,a0,-864 # 800081c8 <etext+0x1c8>
    80001530:	00005097          	auipc	ra,0x5
    80001534:	bf8080e7          	jalr	-1032(ra) # 80006128 <panic>

0000000080001538 <yield>:
{
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	906080e7          	jalr	-1786(ra) # 80000e48 <myproc>
    8000154a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	126080e7          	jalr	294(ra) # 80006672 <acquire>
  p->state = RUNNABLE;
    80001554:	478d                	li	a5,3
    80001556:	cc9c                	sw	a5,24(s1)
  sched();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	f0a080e7          	jalr	-246(ra) # 80001462 <sched>
  release(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	1c4080e7          	jalr	452(ra) # 80006726 <release>
}
    8000156a:	60e2                	ld	ra,24(sp)
    8000156c:	6442                	ld	s0,16(sp)
    8000156e:	64a2                	ld	s1,8(sp)
    80001570:	6105                	addi	sp,sp,32
    80001572:	8082                	ret

0000000080001574 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001574:	7179                	addi	sp,sp,-48
    80001576:	f406                	sd	ra,40(sp)
    80001578:	f022                	sd	s0,32(sp)
    8000157a:	ec26                	sd	s1,24(sp)
    8000157c:	e84a                	sd	s2,16(sp)
    8000157e:	e44e                	sd	s3,8(sp)
    80001580:	1800                	addi	s0,sp,48
    80001582:	89aa                	mv	s3,a0
    80001584:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	8c2080e7          	jalr	-1854(ra) # 80000e48 <myproc>
    8000158e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	0e2080e7          	jalr	226(ra) # 80006672 <acquire>
  release(lk);
    80001598:	854a                	mv	a0,s2
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	18c080e7          	jalr	396(ra) # 80006726 <release>

  // Go to sleep.
  p->chan = chan;
    800015a2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015a6:	4789                	li	a5,2
    800015a8:	cc9c                	sw	a5,24(s1)

  sched();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	eb8080e7          	jalr	-328(ra) # 80001462 <sched>

  // Tidy up.
  p->chan = 0;
    800015b2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	16e080e7          	jalr	366(ra) # 80006726 <release>
  acquire(lk);
    800015c0:	854a                	mv	a0,s2
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	0b0080e7          	jalr	176(ra) # 80006672 <acquire>
}
    800015ca:	70a2                	ld	ra,40(sp)
    800015cc:	7402                	ld	s0,32(sp)
    800015ce:	64e2                	ld	s1,24(sp)
    800015d0:	6942                	ld	s2,16(sp)
    800015d2:	69a2                	ld	s3,8(sp)
    800015d4:	6145                	addi	sp,sp,48
    800015d6:	8082                	ret

00000000800015d8 <wait>:
{
    800015d8:	715d                	addi	sp,sp,-80
    800015da:	e486                	sd	ra,72(sp)
    800015dc:	e0a2                	sd	s0,64(sp)
    800015de:	fc26                	sd	s1,56(sp)
    800015e0:	f84a                	sd	s2,48(sp)
    800015e2:	f44e                	sd	s3,40(sp)
    800015e4:	f052                	sd	s4,32(sp)
    800015e6:	ec56                	sd	s5,24(sp)
    800015e8:	e85a                	sd	s6,16(sp)
    800015ea:	e45e                	sd	s7,8(sp)
    800015ec:	e062                	sd	s8,0(sp)
    800015ee:	0880                	addi	s0,sp,80
    800015f0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015f2:	00000097          	auipc	ra,0x0
    800015f6:	856080e7          	jalr	-1962(ra) # 80000e48 <myproc>
    800015fa:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015fc:	00008517          	auipc	a0,0x8
    80001600:	a6c50513          	addi	a0,a0,-1428 # 80009068 <wait_lock>
    80001604:	00005097          	auipc	ra,0x5
    80001608:	06e080e7          	jalr	110(ra) # 80006672 <acquire>
    havekids = 0;
    8000160c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000160e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001610:	00018997          	auipc	s3,0x18
    80001614:	87098993          	addi	s3,s3,-1936 # 80018e80 <tickslock>
        havekids = 1;
    80001618:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000161a:	00008c17          	auipc	s8,0x8
    8000161e:	a4ec0c13          	addi	s8,s8,-1458 # 80009068 <wait_lock>
    havekids = 0;
    80001622:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001624:	00008497          	auipc	s1,0x8
    80001628:	e5c48493          	addi	s1,s1,-420 # 80009480 <proc>
    8000162c:	a0bd                	j	8000169a <wait+0xc2>
          pid = np->pid;
    8000162e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001632:	000b0e63          	beqz	s6,8000164e <wait+0x76>
    80001636:	4691                	li	a3,4
    80001638:	02c48613          	addi	a2,s1,44
    8000163c:	85da                	mv	a1,s6
    8000163e:	05093503          	ld	a0,80(s2)
    80001642:	fffff097          	auipc	ra,0xfffff
    80001646:	4c8080e7          	jalr	1224(ra) # 80000b0a <copyout>
    8000164a:	02054563          	bltz	a0,80001674 <wait+0x9c>
          freeproc(np);
    8000164e:	8526                	mv	a0,s1
    80001650:	00000097          	auipc	ra,0x0
    80001654:	9aa080e7          	jalr	-1622(ra) # 80000ffa <freeproc>
          release(&np->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	0cc080e7          	jalr	204(ra) # 80006726 <release>
          release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	0bc080e7          	jalr	188(ra) # 80006726 <release>
          return pid;
    80001672:	a09d                	j	800016d8 <wait+0x100>
            release(&np->lock);
    80001674:	8526                	mv	a0,s1
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	0b0080e7          	jalr	176(ra) # 80006726 <release>
            release(&wait_lock);
    8000167e:	00008517          	auipc	a0,0x8
    80001682:	9ea50513          	addi	a0,a0,-1558 # 80009068 <wait_lock>
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	0a0080e7          	jalr	160(ra) # 80006726 <release>
            return -1;
    8000168e:	59fd                	li	s3,-1
    80001690:	a0a1                	j	800016d8 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001692:	3e848493          	addi	s1,s1,1000
    80001696:	03348463          	beq	s1,s3,800016be <wait+0xe6>
      if(np->parent == p){
    8000169a:	7c9c                	ld	a5,56(s1)
    8000169c:	ff279be3          	bne	a5,s2,80001692 <wait+0xba>
        acquire(&np->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	fd0080e7          	jalr	-48(ra) # 80006672 <acquire>
        if(np->state == ZOMBIE){
    800016aa:	4c9c                	lw	a5,24(s1)
    800016ac:	f94781e3          	beq	a5,s4,8000162e <wait+0x56>
        release(&np->lock);
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	074080e7          	jalr	116(ra) # 80006726 <release>
        havekids = 1;
    800016ba:	8756                	mv	a4,s5
    800016bc:	bfd9                	j	80001692 <wait+0xba>
    if(!havekids || p->killed){
    800016be:	c701                	beqz	a4,800016c6 <wait+0xee>
    800016c0:	02892783          	lw	a5,40(s2)
    800016c4:	c79d                	beqz	a5,800016f2 <wait+0x11a>
      release(&wait_lock);
    800016c6:	00008517          	auipc	a0,0x8
    800016ca:	9a250513          	addi	a0,a0,-1630 # 80009068 <wait_lock>
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	058080e7          	jalr	88(ra) # 80006726 <release>
      return -1;
    800016d6:	59fd                	li	s3,-1
}
    800016d8:	854e                	mv	a0,s3
    800016da:	60a6                	ld	ra,72(sp)
    800016dc:	6406                	ld	s0,64(sp)
    800016de:	74e2                	ld	s1,56(sp)
    800016e0:	7942                	ld	s2,48(sp)
    800016e2:	79a2                	ld	s3,40(sp)
    800016e4:	7a02                	ld	s4,32(sp)
    800016e6:	6ae2                	ld	s5,24(sp)
    800016e8:	6b42                	ld	s6,16(sp)
    800016ea:	6ba2                	ld	s7,8(sp)
    800016ec:	6c02                	ld	s8,0(sp)
    800016ee:	6161                	addi	sp,sp,80
    800016f0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f2:	85e2                	mv	a1,s8
    800016f4:	854a                	mv	a0,s2
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	e7e080e7          	jalr	-386(ra) # 80001574 <sleep>
    havekids = 0;
    800016fe:	b715                	j	80001622 <wait+0x4a>

0000000080001700 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001700:	7139                	addi	sp,sp,-64
    80001702:	fc06                	sd	ra,56(sp)
    80001704:	f822                	sd	s0,48(sp)
    80001706:	f426                	sd	s1,40(sp)
    80001708:	f04a                	sd	s2,32(sp)
    8000170a:	ec4e                	sd	s3,24(sp)
    8000170c:	e852                	sd	s4,16(sp)
    8000170e:	e456                	sd	s5,8(sp)
    80001710:	0080                	addi	s0,sp,64
    80001712:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001714:	00008497          	auipc	s1,0x8
    80001718:	d6c48493          	addi	s1,s1,-660 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000171c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000171e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001720:	00017917          	auipc	s2,0x17
    80001724:	76090913          	addi	s2,s2,1888 # 80018e80 <tickslock>
    80001728:	a821                	j	80001740 <wakeup+0x40>
        p->state = RUNNABLE;
    8000172a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	ff6080e7          	jalr	-10(ra) # 80006726 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001738:	3e848493          	addi	s1,s1,1000
    8000173c:	03248463          	beq	s1,s2,80001764 <wakeup+0x64>
    if(p != myproc()){
    80001740:	fffff097          	auipc	ra,0xfffff
    80001744:	708080e7          	jalr	1800(ra) # 80000e48 <myproc>
    80001748:	fea488e3          	beq	s1,a0,80001738 <wakeup+0x38>
      acquire(&p->lock);
    8000174c:	8526                	mv	a0,s1
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	f24080e7          	jalr	-220(ra) # 80006672 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001756:	4c9c                	lw	a5,24(s1)
    80001758:	fd379be3          	bne	a5,s3,8000172e <wakeup+0x2e>
    8000175c:	709c                	ld	a5,32(s1)
    8000175e:	fd4798e3          	bne	a5,s4,8000172e <wakeup+0x2e>
    80001762:	b7e1                	j	8000172a <wakeup+0x2a>
    }
  }
}
    80001764:	70e2                	ld	ra,56(sp)
    80001766:	7442                	ld	s0,48(sp)
    80001768:	74a2                	ld	s1,40(sp)
    8000176a:	7902                	ld	s2,32(sp)
    8000176c:	69e2                	ld	s3,24(sp)
    8000176e:	6a42                	ld	s4,16(sp)
    80001770:	6aa2                	ld	s5,8(sp)
    80001772:	6121                	addi	sp,sp,64
    80001774:	8082                	ret

0000000080001776 <reparent>:
{
    80001776:	7179                	addi	sp,sp,-48
    80001778:	f406                	sd	ra,40(sp)
    8000177a:	f022                	sd	s0,32(sp)
    8000177c:	ec26                	sd	s1,24(sp)
    8000177e:	e84a                	sd	s2,16(sp)
    80001780:	e44e                	sd	s3,8(sp)
    80001782:	e052                	sd	s4,0(sp)
    80001784:	1800                	addi	s0,sp,48
    80001786:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001788:	00008497          	auipc	s1,0x8
    8000178c:	cf848493          	addi	s1,s1,-776 # 80009480 <proc>
      pp->parent = initproc;
    80001790:	00008a17          	auipc	s4,0x8
    80001794:	880a0a13          	addi	s4,s4,-1920 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001798:	00017997          	auipc	s3,0x17
    8000179c:	6e898993          	addi	s3,s3,1768 # 80018e80 <tickslock>
    800017a0:	a029                	j	800017aa <reparent+0x34>
    800017a2:	3e848493          	addi	s1,s1,1000
    800017a6:	01348d63          	beq	s1,s3,800017c0 <reparent+0x4a>
    if(pp->parent == p){
    800017aa:	7c9c                	ld	a5,56(s1)
    800017ac:	ff279be3          	bne	a5,s2,800017a2 <reparent+0x2c>
      pp->parent = initproc;
    800017b0:	000a3503          	ld	a0,0(s4)
    800017b4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017b6:	00000097          	auipc	ra,0x0
    800017ba:	f4a080e7          	jalr	-182(ra) # 80001700 <wakeup>
    800017be:	b7d5                	j	800017a2 <reparent+0x2c>
}
    800017c0:	70a2                	ld	ra,40(sp)
    800017c2:	7402                	ld	s0,32(sp)
    800017c4:	64e2                	ld	s1,24(sp)
    800017c6:	6942                	ld	s2,16(sp)
    800017c8:	69a2                	ld	s3,8(sp)
    800017ca:	6a02                	ld	s4,0(sp)
    800017cc:	6145                	addi	sp,sp,48
    800017ce:	8082                	ret

00000000800017d0 <exit>:
{
    800017d0:	7139                	addi	sp,sp,-64
    800017d2:	fc06                	sd	ra,56(sp)
    800017d4:	f822                	sd	s0,48(sp)
    800017d6:	f426                	sd	s1,40(sp)
    800017d8:	f04a                	sd	s2,32(sp)
    800017da:	ec4e                	sd	s3,24(sp)
    800017dc:	e852                	sd	s4,16(sp)
    800017de:	e456                	sd	s5,8(sp)
    800017e0:	e05a                	sd	s6,0(sp)
    800017e2:	0080                	addi	s0,sp,64
    800017e4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017e6:	fffff097          	auipc	ra,0xfffff
    800017ea:	662080e7          	jalr	1634(ra) # 80000e48 <myproc>
    800017ee:	89aa                	mv	s3,a0
  if(p == initproc)
    800017f0:	00008797          	auipc	a5,0x8
    800017f4:	8207b783          	ld	a5,-2016(a5) # 80009010 <initproc>
    800017f8:	0d050493          	addi	s1,a0,208
    800017fc:	15050913          	addi	s2,a0,336
    80001800:	02a79363          	bne	a5,a0,80001826 <exit+0x56>
    panic("init exiting");
    80001804:	00007517          	auipc	a0,0x7
    80001808:	9dc50513          	addi	a0,a0,-1572 # 800081e0 <etext+0x1e0>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	91c080e7          	jalr	-1764(ra) # 80006128 <panic>
      fileclose(f);
    80001814:	00002097          	auipc	ra,0x2
    80001818:	39e080e7          	jalr	926(ra) # 80003bb2 <fileclose>
      p->ofile[fd] = 0;
    8000181c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001820:	04a1                	addi	s1,s1,8
    80001822:	01248563          	beq	s1,s2,8000182c <exit+0x5c>
    if(p->ofile[fd]){
    80001826:	6088                	ld	a0,0(s1)
    80001828:	f575                	bnez	a0,80001814 <exit+0x44>
    8000182a:	bfdd                	j	80001820 <exit+0x50>
    8000182c:	16898493          	addi	s1,s3,360
    80001830:	3e898a93          	addi	s5,s3,1000
    80001834:	a889                	j	80001886 <exit+0xb6>
          begin_op();
    80001836:	00002097          	auipc	ra,0x2
    8000183a:	eb0080e7          	jalr	-336(ra) # 800036e6 <begin_op>
          ilock(p->vmas[i].f->ip);
    8000183e:	00093783          	ld	a5,0(s2)
    80001842:	6f88                	ld	a0,24(a5)
    80001844:	00001097          	auipc	ra,0x1
    80001848:	4d0080e7          	jalr	1232(ra) # 80002d14 <ilock>
          writei(p->vmas[i].f->ip, 1, p->vmas[i].addr, offset, p->vmas[i].length);
    8000184c:	00093783          	ld	a5,0(s2)
    80001850:	00892703          	lw	a4,8(s2)
    80001854:	86da                	mv	a3,s6
    80001856:	02093603          	ld	a2,32(s2)
    8000185a:	4585                	li	a1,1
    8000185c:	6f88                	ld	a0,24(a5)
    8000185e:	00002097          	auipc	ra,0x2
    80001862:	862080e7          	jalr	-1950(ra) # 800030c0 <writei>
          iunlock(p->vmas[i].f->ip);
    80001866:	00093783          	ld	a5,0(s2)
    8000186a:	6f88                	ld	a0,24(a5)
    8000186c:	00001097          	auipc	ra,0x1
    80001870:	56a080e7          	jalr	1386(ra) # 80002dd6 <iunlock>
          end_op();
    80001874:	00002097          	auipc	ra,0x2
    80001878:	ef2080e7          	jalr	-270(ra) # 80003766 <end_op>
    8000187c:	a02d                	j	800018a6 <exit+0xd6>
  for(int i = 0; i < 16; i++){
    8000187e:	02848493          	addi	s1,s1,40
    80001882:	07548d63          	beq	s1,s5,800018fc <exit+0x12c>
    if(p->vmas[i].addr){
    80001886:	8926                	mv	s2,s1
    80001888:	709c                	ld	a5,32(s1)
    8000188a:	dbf5                	beqz	a5,8000187e <exit+0xae>
      int offset = p->vmas[i].f->off; // addr is beginning of vma, so use file->off
    8000188c:	6098                	ld	a4,0(s1)
    8000188e:	5314                	lw	a3,32(a4)
      if(p->vmas[i].oldsz != p->vmas[i].addr) // addr is't beginning of vma, so use p->vmas[i].offset
    80001890:	4c98                	lw	a4,24(s1)
      int offset = p->vmas[i].f->off; // addr is beginning of vma, so use file->off
    80001892:	00068b1b          	sext.w	s6,a3
      if(p->vmas[i].oldsz != p->vmas[i].addr) // addr is't beginning of vma, so use p->vmas[i].offset
    80001896:	00e78463          	beq	a5,a4,8000189e <exit+0xce>
        offset = p->vmas[i].offset;  
    8000189a:	0144ab03          	lw	s6,20(s1)
      if(p->vmas[i].flags & MAP_SHARED){
    8000189e:	01092783          	lw	a5,16(s2)
    800018a2:	8b85                	andi	a5,a5,1
    800018a4:	fbc9                	bnez	a5,80001836 <exit+0x66>
      p->sz -= p->vmas[i].length;  
    800018a6:	00892703          	lw	a4,8(s2)
    800018aa:	0489b783          	ld	a5,72(s3)
    800018ae:	8f99                	sub	a5,a5,a4
    800018b0:	04f9b423          	sd	a5,72(s3)
      p->vmas[i].f->ref--;
    800018b4:	00093703          	ld	a4,0(s2)
    800018b8:	435c                	lw	a5,4(a4)
    800018ba:	37fd                	addiw	a5,a5,-1
    800018bc:	c35c                	sw	a5,4(a4)
      pte_t *pte = walk(p->pagetable, p->vmas[i].addr, 0);
    800018be:	4601                	li	a2,0
    800018c0:	02093583          	ld	a1,32(s2)
    800018c4:	0509b503          	ld	a0,80(s3)
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	b98080e7          	jalr	-1128(ra) # 80000460 <walk>
      if((*pte & PTE_V) == 0) // don't write and uvmunmap(), only change data of vma
    800018d0:	611c                	ld	a5,0(a0)
    800018d2:	8b85                	andi	a5,a5,1
    800018d4:	d7cd                	beqz	a5,8000187e <exit+0xae>
      uvmunmap(p->pagetable, p->vmas[i].addr, p->vmas[i].length/PGSIZE, 1);
    800018d6:	00892783          	lw	a5,8(s2)
    800018da:	41f7d61b          	sraiw	a2,a5,0x1f
    800018de:	0146561b          	srliw	a2,a2,0x14
    800018e2:	9e3d                	addw	a2,a2,a5
    800018e4:	4685                	li	a3,1
    800018e6:	40c6561b          	sraiw	a2,a2,0xc
    800018ea:	02093583          	ld	a1,32(s2)
    800018ee:	0509b503          	ld	a0,80(s3)
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	e1c080e7          	jalr	-484(ra) # 8000070e <uvmunmap>
    800018fa:	b751                	j	8000187e <exit+0xae>
  begin_op();
    800018fc:	00002097          	auipc	ra,0x2
    80001900:	dea080e7          	jalr	-534(ra) # 800036e6 <begin_op>
  iput(p->cwd);
    80001904:	1509b503          	ld	a0,336(s3)
    80001908:	00001097          	auipc	ra,0x1
    8000190c:	5c6080e7          	jalr	1478(ra) # 80002ece <iput>
  end_op();
    80001910:	00002097          	auipc	ra,0x2
    80001914:	e56080e7          	jalr	-426(ra) # 80003766 <end_op>
  p->cwd = 0;
    80001918:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000191c:	00007497          	auipc	s1,0x7
    80001920:	74c48493          	addi	s1,s1,1868 # 80009068 <wait_lock>
    80001924:	8526                	mv	a0,s1
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	d4c080e7          	jalr	-692(ra) # 80006672 <acquire>
  reparent(p);
    8000192e:	854e                	mv	a0,s3
    80001930:	00000097          	auipc	ra,0x0
    80001934:	e46080e7          	jalr	-442(ra) # 80001776 <reparent>
  wakeup(p->parent);
    80001938:	0389b503          	ld	a0,56(s3)
    8000193c:	00000097          	auipc	ra,0x0
    80001940:	dc4080e7          	jalr	-572(ra) # 80001700 <wakeup>
  acquire(&p->lock);
    80001944:	854e                	mv	a0,s3
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	d2c080e7          	jalr	-724(ra) # 80006672 <acquire>
  p->xstate = status;
    8000194e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001952:	4795                	li	a5,5
    80001954:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001958:	8526                	mv	a0,s1
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	dcc080e7          	jalr	-564(ra) # 80006726 <release>
  sched();
    80001962:	00000097          	auipc	ra,0x0
    80001966:	b00080e7          	jalr	-1280(ra) # 80001462 <sched>
  panic("zombie exit");
    8000196a:	00007517          	auipc	a0,0x7
    8000196e:	88650513          	addi	a0,a0,-1914 # 800081f0 <etext+0x1f0>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	7b6080e7          	jalr	1974(ra) # 80006128 <panic>

000000008000197a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000197a:	7179                	addi	sp,sp,-48
    8000197c:	f406                	sd	ra,40(sp)
    8000197e:	f022                	sd	s0,32(sp)
    80001980:	ec26                	sd	s1,24(sp)
    80001982:	e84a                	sd	s2,16(sp)
    80001984:	e44e                	sd	s3,8(sp)
    80001986:	1800                	addi	s0,sp,48
    80001988:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000198a:	00008497          	auipc	s1,0x8
    8000198e:	af648493          	addi	s1,s1,-1290 # 80009480 <proc>
    80001992:	00017997          	auipc	s3,0x17
    80001996:	4ee98993          	addi	s3,s3,1262 # 80018e80 <tickslock>
    acquire(&p->lock);
    8000199a:	8526                	mv	a0,s1
    8000199c:	00005097          	auipc	ra,0x5
    800019a0:	cd6080e7          	jalr	-810(ra) # 80006672 <acquire>
    if(p->pid == pid){
    800019a4:	589c                	lw	a5,48(s1)
    800019a6:	01278d63          	beq	a5,s2,800019c0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019aa:	8526                	mv	a0,s1
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	d7a080e7          	jalr	-646(ra) # 80006726 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b4:	3e848493          	addi	s1,s1,1000
    800019b8:	ff3491e3          	bne	s1,s3,8000199a <kill+0x20>
  }
  return -1;
    800019bc:	557d                	li	a0,-1
    800019be:	a829                	j	800019d8 <kill+0x5e>
      p->killed = 1;
    800019c0:	4785                	li	a5,1
    800019c2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019c4:	4c98                	lw	a4,24(s1)
    800019c6:	4789                	li	a5,2
    800019c8:	00f70f63          	beq	a4,a5,800019e6 <kill+0x6c>
      release(&p->lock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	d58080e7          	jalr	-680(ra) # 80006726 <release>
      return 0;
    800019d6:	4501                	li	a0,0
}
    800019d8:	70a2                	ld	ra,40(sp)
    800019da:	7402                	ld	s0,32(sp)
    800019dc:	64e2                	ld	s1,24(sp)
    800019de:	6942                	ld	s2,16(sp)
    800019e0:	69a2                	ld	s3,8(sp)
    800019e2:	6145                	addi	sp,sp,48
    800019e4:	8082                	ret
        p->state = RUNNABLE;
    800019e6:	478d                	li	a5,3
    800019e8:	cc9c                	sw	a5,24(s1)
    800019ea:	b7cd                	j	800019cc <kill+0x52>

00000000800019ec <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019ec:	7179                	addi	sp,sp,-48
    800019ee:	f406                	sd	ra,40(sp)
    800019f0:	f022                	sd	s0,32(sp)
    800019f2:	ec26                	sd	s1,24(sp)
    800019f4:	e84a                	sd	s2,16(sp)
    800019f6:	e44e                	sd	s3,8(sp)
    800019f8:	e052                	sd	s4,0(sp)
    800019fa:	1800                	addi	s0,sp,48
    800019fc:	84aa                	mv	s1,a0
    800019fe:	892e                	mv	s2,a1
    80001a00:	89b2                	mv	s3,a2
    80001a02:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	444080e7          	jalr	1092(ra) # 80000e48 <myproc>
  if(user_dst){
    80001a0c:	c08d                	beqz	s1,80001a2e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a0e:	86d2                	mv	a3,s4
    80001a10:	864e                	mv	a2,s3
    80001a12:	85ca                	mv	a1,s2
    80001a14:	6928                	ld	a0,80(a0)
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	0f4080e7          	jalr	244(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a1e:	70a2                	ld	ra,40(sp)
    80001a20:	7402                	ld	s0,32(sp)
    80001a22:	64e2                	ld	s1,24(sp)
    80001a24:	6942                	ld	s2,16(sp)
    80001a26:	69a2                	ld	s3,8(sp)
    80001a28:	6a02                	ld	s4,0(sp)
    80001a2a:	6145                	addi	sp,sp,48
    80001a2c:	8082                	ret
    memmove((char *)dst, src, len);
    80001a2e:	000a061b          	sext.w	a2,s4
    80001a32:	85ce                	mv	a1,s3
    80001a34:	854a                	mv	a0,s2
    80001a36:	ffffe097          	auipc	ra,0xffffe
    80001a3a:	7a2080e7          	jalr	1954(ra) # 800001d8 <memmove>
    return 0;
    80001a3e:	8526                	mv	a0,s1
    80001a40:	bff9                	j	80001a1e <either_copyout+0x32>

0000000080001a42 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a42:	7179                	addi	sp,sp,-48
    80001a44:	f406                	sd	ra,40(sp)
    80001a46:	f022                	sd	s0,32(sp)
    80001a48:	ec26                	sd	s1,24(sp)
    80001a4a:	e84a                	sd	s2,16(sp)
    80001a4c:	e44e                	sd	s3,8(sp)
    80001a4e:	e052                	sd	s4,0(sp)
    80001a50:	1800                	addi	s0,sp,48
    80001a52:	892a                	mv	s2,a0
    80001a54:	84ae                	mv	s1,a1
    80001a56:	89b2                	mv	s3,a2
    80001a58:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	3ee080e7          	jalr	1006(ra) # 80000e48 <myproc>
  if(user_src){
    80001a62:	c08d                	beqz	s1,80001a84 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a64:	86d2                	mv	a3,s4
    80001a66:	864e                	mv	a2,s3
    80001a68:	85ca                	mv	a1,s2
    80001a6a:	6928                	ld	a0,80(a0)
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	12a080e7          	jalr	298(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a74:	70a2                	ld	ra,40(sp)
    80001a76:	7402                	ld	s0,32(sp)
    80001a78:	64e2                	ld	s1,24(sp)
    80001a7a:	6942                	ld	s2,16(sp)
    80001a7c:	69a2                	ld	s3,8(sp)
    80001a7e:	6a02                	ld	s4,0(sp)
    80001a80:	6145                	addi	sp,sp,48
    80001a82:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a84:	000a061b          	sext.w	a2,s4
    80001a88:	85ce                	mv	a1,s3
    80001a8a:	854a                	mv	a0,s2
    80001a8c:	ffffe097          	auipc	ra,0xffffe
    80001a90:	74c080e7          	jalr	1868(ra) # 800001d8 <memmove>
    return 0;
    80001a94:	8526                	mv	a0,s1
    80001a96:	bff9                	j	80001a74 <either_copyin+0x32>

0000000080001a98 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a98:	715d                	addi	sp,sp,-80
    80001a9a:	e486                	sd	ra,72(sp)
    80001a9c:	e0a2                	sd	s0,64(sp)
    80001a9e:	fc26                	sd	s1,56(sp)
    80001aa0:	f84a                	sd	s2,48(sp)
    80001aa2:	f44e                	sd	s3,40(sp)
    80001aa4:	f052                	sd	s4,32(sp)
    80001aa6:	ec56                	sd	s5,24(sp)
    80001aa8:	e85a                	sd	s6,16(sp)
    80001aaa:	e45e                	sd	s7,8(sp)
    80001aac:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aae:	00006517          	auipc	a0,0x6
    80001ab2:	59a50513          	addi	a0,a0,1434 # 80008048 <etext+0x48>
    80001ab6:	00004097          	auipc	ra,0x4
    80001aba:	6bc080e7          	jalr	1724(ra) # 80006172 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001abe:	00008497          	auipc	s1,0x8
    80001ac2:	b1a48493          	addi	s1,s1,-1254 # 800095d8 <proc+0x158>
    80001ac6:	00017917          	auipc	s2,0x17
    80001aca:	51290913          	addi	s2,s2,1298 # 80018fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ace:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ad0:	00006997          	auipc	s3,0x6
    80001ad4:	73098993          	addi	s3,s3,1840 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ad8:	00006a97          	auipc	s5,0x6
    80001adc:	730a8a93          	addi	s5,s5,1840 # 80008208 <etext+0x208>
    printf("\n");
    80001ae0:	00006a17          	auipc	s4,0x6
    80001ae4:	568a0a13          	addi	s4,s4,1384 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae8:	00006b97          	auipc	s7,0x6
    80001aec:	758b8b93          	addi	s7,s7,1880 # 80008240 <states.1751>
    80001af0:	a00d                	j	80001b12 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001af2:	ed86a583          	lw	a1,-296(a3)
    80001af6:	8556                	mv	a0,s5
    80001af8:	00004097          	auipc	ra,0x4
    80001afc:	67a080e7          	jalr	1658(ra) # 80006172 <printf>
    printf("\n");
    80001b00:	8552                	mv	a0,s4
    80001b02:	00004097          	auipc	ra,0x4
    80001b06:	670080e7          	jalr	1648(ra) # 80006172 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b0a:	3e848493          	addi	s1,s1,1000
    80001b0e:	03248163          	beq	s1,s2,80001b30 <procdump+0x98>
    if(p->state == UNUSED)
    80001b12:	86a6                	mv	a3,s1
    80001b14:	ec04a783          	lw	a5,-320(s1)
    80001b18:	dbed                	beqz	a5,80001b0a <procdump+0x72>
      state = "???";
    80001b1a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b1c:	fcfb6be3          	bltu	s6,a5,80001af2 <procdump+0x5a>
    80001b20:	1782                	slli	a5,a5,0x20
    80001b22:	9381                	srli	a5,a5,0x20
    80001b24:	078e                	slli	a5,a5,0x3
    80001b26:	97de                	add	a5,a5,s7
    80001b28:	6390                	ld	a2,0(a5)
    80001b2a:	f661                	bnez	a2,80001af2 <procdump+0x5a>
      state = "???";
    80001b2c:	864e                	mv	a2,s3
    80001b2e:	b7d1                	j	80001af2 <procdump+0x5a>
  }
}
    80001b30:	60a6                	ld	ra,72(sp)
    80001b32:	6406                	ld	s0,64(sp)
    80001b34:	74e2                	ld	s1,56(sp)
    80001b36:	7942                	ld	s2,48(sp)
    80001b38:	79a2                	ld	s3,40(sp)
    80001b3a:	7a02                	ld	s4,32(sp)
    80001b3c:	6ae2                	ld	s5,24(sp)
    80001b3e:	6b42                	ld	s6,16(sp)
    80001b40:	6ba2                	ld	s7,8(sp)
    80001b42:	6161                	addi	sp,sp,80
    80001b44:	8082                	ret

0000000080001b46 <swtch>:
    80001b46:	00153023          	sd	ra,0(a0)
    80001b4a:	00253423          	sd	sp,8(a0)
    80001b4e:	e900                	sd	s0,16(a0)
    80001b50:	ed04                	sd	s1,24(a0)
    80001b52:	03253023          	sd	s2,32(a0)
    80001b56:	03353423          	sd	s3,40(a0)
    80001b5a:	03453823          	sd	s4,48(a0)
    80001b5e:	03553c23          	sd	s5,56(a0)
    80001b62:	05653023          	sd	s6,64(a0)
    80001b66:	05753423          	sd	s7,72(a0)
    80001b6a:	05853823          	sd	s8,80(a0)
    80001b6e:	05953c23          	sd	s9,88(a0)
    80001b72:	07a53023          	sd	s10,96(a0)
    80001b76:	07b53423          	sd	s11,104(a0)
    80001b7a:	0005b083          	ld	ra,0(a1)
    80001b7e:	0085b103          	ld	sp,8(a1)
    80001b82:	6980                	ld	s0,16(a1)
    80001b84:	6d84                	ld	s1,24(a1)
    80001b86:	0205b903          	ld	s2,32(a1)
    80001b8a:	0285b983          	ld	s3,40(a1)
    80001b8e:	0305ba03          	ld	s4,48(a1)
    80001b92:	0385ba83          	ld	s5,56(a1)
    80001b96:	0405bb03          	ld	s6,64(a1)
    80001b9a:	0485bb83          	ld	s7,72(a1)
    80001b9e:	0505bc03          	ld	s8,80(a1)
    80001ba2:	0585bc83          	ld	s9,88(a1)
    80001ba6:	0605bd03          	ld	s10,96(a1)
    80001baa:	0685bd83          	ld	s11,104(a1)
    80001bae:	8082                	ret

0000000080001bb0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bb0:	1141                	addi	sp,sp,-16
    80001bb2:	e406                	sd	ra,8(sp)
    80001bb4:	e022                	sd	s0,0(sp)
    80001bb6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bb8:	00006597          	auipc	a1,0x6
    80001bbc:	6b858593          	addi	a1,a1,1720 # 80008270 <states.1751+0x30>
    80001bc0:	00017517          	auipc	a0,0x17
    80001bc4:	2c050513          	addi	a0,a0,704 # 80018e80 <tickslock>
    80001bc8:	00005097          	auipc	ra,0x5
    80001bcc:	a1a080e7          	jalr	-1510(ra) # 800065e2 <initlock>
}
    80001bd0:	60a2                	ld	ra,8(sp)
    80001bd2:	6402                	ld	s0,0(sp)
    80001bd4:	0141                	addi	sp,sp,16
    80001bd6:	8082                	ret

0000000080001bd8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bd8:	1141                	addi	sp,sp,-16
    80001bda:	e422                	sd	s0,8(sp)
    80001bdc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bde:	00004797          	auipc	a5,0x4
    80001be2:	95278793          	addi	a5,a5,-1710 # 80005530 <kernelvec>
    80001be6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bea:	6422                	ld	s0,8(sp)
    80001bec:	0141                	addi	sp,sp,16
    80001bee:	8082                	ret

0000000080001bf0 <mmap_lazyalloc>:

int
mmap_lazyalloc(pagetable_t pagetable, uint64 va)
{ 
    80001bf0:	715d                	addi	sp,sp,-80
    80001bf2:	e486                	sd	ra,72(sp)
    80001bf4:	e0a2                	sd	s0,64(sp)
    80001bf6:	fc26                	sd	s1,56(sp)
    80001bf8:	f84a                	sd	s2,48(sp)
    80001bfa:	f44e                	sd	s3,40(sp)
    80001bfc:	f052                	sd	s4,32(sp)
    80001bfe:	ec56                	sd	s5,24(sp)
    80001c00:	e85a                	sd	s6,16(sp)
    80001c02:	e45e                	sd	s7,8(sp)
    80001c04:	0880                	addi	s0,sp,80
    80001c06:	8a2a                	mv	s4,a0
    80001c08:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	23e080e7          	jalr	574(ra) # 80000e48 <myproc>
    80001c12:	89aa                	mv	s3,a0
  int perm = 0;
  char *mem;
  
  // find va between vma.addr and vma.addr+vma.lenght
  int i;
  for(i = 0; i < 16; i++){
    80001c14:	17050793          	addi	a5,a0,368
    80001c18:	4481                	li	s1,0
    80001c1a:	4641                	li	a2,16
    80001c1c:	a031                	j	80001c28 <mmap_lazyalloc+0x38>
    80001c1e:	2485                	addiw	s1,s1,1
    80001c20:	02878793          	addi	a5,a5,40
    80001c24:	0ec48263          	beq	s1,a2,80001d08 <mmap_lazyalloc+0x118>
    if(p->vmas[i].addr <= va && va < (p->vmas[i].addr + p->vmas[i].length)){
    80001c28:	6f98                	ld	a4,24(a5)
    80001c2a:	fee96ae3          	bltu	s2,a4,80001c1e <mmap_lazyalloc+0x2e>
    80001c2e:	4394                	lw	a3,0(a5)
    80001c30:	9736                	add	a4,a4,a3
    80001c32:	fee976e3          	bgeu	s2,a4,80001c1e <mmap_lazyalloc+0x2e>
      has_a_vam = 1;
      f = p->vmas[i].f;
    80001c36:	00249793          	slli	a5,s1,0x2
    80001c3a:	97a6                	add	a5,a5,s1
    80001c3c:	078e                	slli	a5,a5,0x3
    80001c3e:	97ce                	add	a5,a5,s3
    80001c40:	1687ba83          	ld	s5,360(a5)
      prot = p->vmas[i].prot;
    80001c44:	1747a783          	lw	a5,372(a5)
    
  // PTE_U controls whether instructions in user mode are allowed to access the page; 
  // if PTE_U is notset, the PTE can be used only in supervisor mode.
  perm |= PTE_U;
  // MAYBE sets PTE_R, PTE_W, PTE_X
  if(prot & PROT_READ){
    80001c48:	0017f713          	andi	a4,a5,1
    perm |= PTE_R;
    80001c4c:	4bc9                	li	s7,18
  if(prot & PROT_READ){
    80001c4e:	e311                	bnez	a4,80001c52 <mmap_lazyalloc+0x62>
  perm |= PTE_U;
    80001c50:	4bc1                	li	s7,16
  }
  if(prot & PROT_WRITE){
    80001c52:	0027f713          	andi	a4,a5,2
    80001c56:	c319                	beqz	a4,80001c5c <mmap_lazyalloc+0x6c>
    perm |= PTE_W;
    80001c58:	004beb93          	ori	s7,s7,4
  }  
  if(prot & PROT_EXEC){
    80001c5c:	8b91                	andi	a5,a5,4
    80001c5e:	c399                	beqz	a5,80001c64 <mmap_lazyalloc+0x74>
    perm |= PTE_X;
    80001c60:	008beb93          	ori	s7,s7,8
  }

  // big bug: not alloc mem(4096) to all virtual addresses
  if((mem = kalloc()) == 0){
    80001c64:	ffffe097          	auipc	ra,0xffffe
    80001c68:	4b4080e7          	jalr	1204(ra) # 80000118 <kalloc>
    80001c6c:	8b2a                	mv	s6,a0
    80001c6e:	cd4d                	beqz	a0,80001d28 <mmap_lazyalloc+0x138>
  }
  // In mmaptest/makefile()
  // create a file to be mapped, containing
  // 1.5 pages of 'A' and half a page of zeros.
  // so we must set 0 of length after getting mem
  memset(mem, 0, PGSIZE);
    80001c70:	6605                	lui	a2,0x1
    80001c72:	4581                	li	a1,0
    80001c74:	ffffe097          	auipc	ra,0xffffe
    80001c78:	504080e7          	jalr	1284(ra) # 80000178 <memset>

  // note: mem is new address of phycial memory
  if(mappages(pagetable, va, PGSIZE, (uint64)mem, perm) == -1){
    80001c7c:	875e                	mv	a4,s7
    80001c7e:	86da                	mv	a3,s6
    80001c80:	6605                	lui	a2,0x1
    80001c82:	85ca                	mv	a1,s2
    80001c84:	8552                	mv	a0,s4
    80001c86:	fffff097          	auipc	ra,0xfffff
    80001c8a:	8c2080e7          	jalr	-1854(ra) # 80000548 <mappages>
    80001c8e:	8a2a                	mv	s4,a0
    80001c90:	57fd                	li	a5,-1
    80001c92:	06f50d63          	beq	a0,a5,80001d0c <mmap_lazyalloc+0x11c>

  // we not set PTE_D, becasue we always directly wirite back to file in munmap()

  // length is the number of bytes to map; it might not be the same as the file's length.
  // read data from file, then put data to va
  ilock(f->ip);
    80001c96:	018ab503          	ld	a0,24(s5)
    80001c9a:	00001097          	auipc	ra,0x1
    80001c9e:	07a080e7          	jalr	122(ra) # 80002d14 <ilock>
  if(readi(f->ip, 1, va, va - p->vmas[i].addr, PGSIZE) < 0){ // readi offset by 'va - p->vmas[i].addr'  
    80001ca2:	00249793          	slli	a5,s1,0x2
    80001ca6:	97a6                	add	a5,a5,s1
    80001ca8:	078e                	slli	a5,a5,0x3
    80001caa:	97ce                	add	a5,a5,s3
    80001cac:	1887b683          	ld	a3,392(a5)
    80001cb0:	6705                	lui	a4,0x1
    80001cb2:	40d906bb          	subw	a3,s2,a3
    80001cb6:	864a                	mv	a2,s2
    80001cb8:	4585                	li	a1,1
    80001cba:	018ab503          	ld	a0,24(s5)
    80001cbe:	00001097          	auipc	ra,0x1
    80001cc2:	30a080e7          	jalr	778(ra) # 80002fc8 <readi>
    80001cc6:	04054963          	bltz	a0,80001d18 <mmap_lazyalloc+0x128>
    iunlock(f->ip);
    return -1;
  }
  iunlock(f->ip);
    80001cca:	018ab503          	ld	a0,24(s5)
    80001cce:	00001097          	auipc	ra,0x1
    80001cd2:	108080e7          	jalr	264(ra) # 80002dd6 <iunlock>
  p->vmas[i].offset += PGSIZE;
    80001cd6:	00249793          	slli	a5,s1,0x2
    80001cda:	00978733          	add	a4,a5,s1
    80001cde:	070e                	slli	a4,a4,0x3
    80001ce0:	974e                	add	a4,a4,s3
    80001ce2:	17c72783          	lw	a5,380(a4) # 117c <_entry-0x7fffee84>
    80001ce6:	6685                	lui	a3,0x1
    80001ce8:	9fb5                	addw	a5,a5,a3
    80001cea:	16f72e23          	sw	a5,380(a4)

  // success, ret 0
  return 0;
    80001cee:	4a01                	li	s4,0
}
    80001cf0:	8552                	mv	a0,s4
    80001cf2:	60a6                	ld	ra,72(sp)
    80001cf4:	6406                	ld	s0,64(sp)
    80001cf6:	74e2                	ld	s1,56(sp)
    80001cf8:	7942                	ld	s2,48(sp)
    80001cfa:	79a2                	ld	s3,40(sp)
    80001cfc:	7a02                	ld	s4,32(sp)
    80001cfe:	6ae2                	ld	s5,24(sp)
    80001d00:	6b42                	ld	s6,16(sp)
    80001d02:	6ba2                	ld	s7,8(sp)
    80001d04:	6161                	addi	sp,sp,80
    80001d06:	8082                	ret
    return -1;
    80001d08:	5a7d                	li	s4,-1
    80001d0a:	b7dd                	j	80001cf0 <mmap_lazyalloc+0x100>
    kfree(mem);
    80001d0c:	855a                	mv	a0,s6
    80001d0e:	ffffe097          	auipc	ra,0xffffe
    80001d12:	30e080e7          	jalr	782(ra) # 8000001c <kfree>
    return -1;
    80001d16:	bfe9                	j	80001cf0 <mmap_lazyalloc+0x100>
    iunlock(f->ip);
    80001d18:	018ab503          	ld	a0,24(s5)
    80001d1c:	00001097          	auipc	ra,0x1
    80001d20:	0ba080e7          	jalr	186(ra) # 80002dd6 <iunlock>
    return -1;
    80001d24:	5a7d                	li	s4,-1
    80001d26:	b7e9                	j	80001cf0 <mmap_lazyalloc+0x100>
    return -1;
    80001d28:	5a7d                	li	s4,-1
    80001d2a:	b7d9                	j	80001cf0 <mmap_lazyalloc+0x100>

0000000080001d2c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d2c:	1141                	addi	sp,sp,-16
    80001d2e:	e406                	sd	ra,8(sp)
    80001d30:	e022                	sd	s0,0(sp)
    80001d32:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	114080e7          	jalr	276(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d46:	00005617          	auipc	a2,0x5
    80001d4a:	2ba60613          	addi	a2,a2,698 # 80007000 <_trampoline>
    80001d4e:	00005697          	auipc	a3,0x5
    80001d52:	2b268693          	addi	a3,a3,690 # 80007000 <_trampoline>
    80001d56:	8e91                	sub	a3,a3,a2
    80001d58:	040007b7          	lui	a5,0x4000
    80001d5c:	17fd                	addi	a5,a5,-1
    80001d5e:	07b2                	slli	a5,a5,0xc
    80001d60:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d62:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d66:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d68:	180026f3          	csrr	a3,satp
    80001d6c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d6e:	6d38                	ld	a4,88(a0)
    80001d70:	6134                	ld	a3,64(a0)
    80001d72:	6585                	lui	a1,0x1
    80001d74:	96ae                	add	a3,a3,a1
    80001d76:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d78:	6d38                	ld	a4,88(a0)
    80001d7a:	00000697          	auipc	a3,0x0
    80001d7e:	13868693          	addi	a3,a3,312 # 80001eb2 <usertrap>
    80001d82:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d84:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d86:	8692                	mv	a3,tp
    80001d88:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d8e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d92:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d96:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d9a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d9c:	6f18                	ld	a4,24(a4)
    80001d9e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001da2:	692c                	ld	a1,80(a0)
    80001da4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001da6:	00005717          	auipc	a4,0x5
    80001daa:	2ea70713          	addi	a4,a4,746 # 80007090 <userret>
    80001dae:	8f11                	sub	a4,a4,a2
    80001db0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001db2:	577d                	li	a4,-1
    80001db4:	177e                	slli	a4,a4,0x3f
    80001db6:	8dd9                	or	a1,a1,a4
    80001db8:	02000537          	lui	a0,0x2000
    80001dbc:	157d                	addi	a0,a0,-1
    80001dbe:	0536                	slli	a0,a0,0xd
    80001dc0:	9782                	jalr	a5
}
    80001dc2:	60a2                	ld	ra,8(sp)
    80001dc4:	6402                	ld	s0,0(sp)
    80001dc6:	0141                	addi	sp,sp,16
    80001dc8:	8082                	ret

0000000080001dca <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dd4:	00017497          	auipc	s1,0x17
    80001dd8:	0ac48493          	addi	s1,s1,172 # 80018e80 <tickslock>
    80001ddc:	8526                	mv	a0,s1
    80001dde:	00005097          	auipc	ra,0x5
    80001de2:	894080e7          	jalr	-1900(ra) # 80006672 <acquire>
  ticks++;
    80001de6:	00007517          	auipc	a0,0x7
    80001dea:	23250513          	addi	a0,a0,562 # 80009018 <ticks>
    80001dee:	411c                	lw	a5,0(a0)
    80001df0:	2785                	addiw	a5,a5,1
    80001df2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	90c080e7          	jalr	-1780(ra) # 80001700 <wakeup>
  release(&tickslock);
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	00005097          	auipc	ra,0x5
    80001e02:	928080e7          	jalr	-1752(ra) # 80006726 <release>
}
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e10:	1101                	addi	sp,sp,-32
    80001e12:	ec06                	sd	ra,24(sp)
    80001e14:	e822                	sd	s0,16(sp)
    80001e16:	e426                	sd	s1,8(sp)
    80001e18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e1a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e1e:	00074d63          	bltz	a4,80001e38 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e22:	57fd                	li	a5,-1
    80001e24:	17fe                	slli	a5,a5,0x3f
    80001e26:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e28:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e2a:	06f70363          	beq	a4,a5,80001e90 <devintr+0x80>
  }
}
    80001e2e:	60e2                	ld	ra,24(sp)
    80001e30:	6442                	ld	s0,16(sp)
    80001e32:	64a2                	ld	s1,8(sp)
    80001e34:	6105                	addi	sp,sp,32
    80001e36:	8082                	ret
     (scause & 0xff) == 9){
    80001e38:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e3c:	46a5                	li	a3,9
    80001e3e:	fed792e3          	bne	a5,a3,80001e22 <devintr+0x12>
    int irq = plic_claim();
    80001e42:	00003097          	auipc	ra,0x3
    80001e46:	7f6080e7          	jalr	2038(ra) # 80005638 <plic_claim>
    80001e4a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e4c:	47a9                	li	a5,10
    80001e4e:	02f50763          	beq	a0,a5,80001e7c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e52:	4785                	li	a5,1
    80001e54:	02f50963          	beq	a0,a5,80001e86 <devintr+0x76>
    return 1;
    80001e58:	4505                	li	a0,1
    } else if(irq){
    80001e5a:	d8f1                	beqz	s1,80001e2e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e5c:	85a6                	mv	a1,s1
    80001e5e:	00006517          	auipc	a0,0x6
    80001e62:	41a50513          	addi	a0,a0,1050 # 80008278 <states.1751+0x38>
    80001e66:	00004097          	auipc	ra,0x4
    80001e6a:	30c080e7          	jalr	780(ra) # 80006172 <printf>
      plic_complete(irq);
    80001e6e:	8526                	mv	a0,s1
    80001e70:	00003097          	auipc	ra,0x3
    80001e74:	7ec080e7          	jalr	2028(ra) # 8000565c <plic_complete>
    return 1;
    80001e78:	4505                	li	a0,1
    80001e7a:	bf55                	j	80001e2e <devintr+0x1e>
      uartintr();
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	716080e7          	jalr	1814(ra) # 80006592 <uartintr>
    80001e84:	b7ed                	j	80001e6e <devintr+0x5e>
      virtio_disk_intr();
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	cb6080e7          	jalr	-842(ra) # 80005b3c <virtio_disk_intr>
    80001e8e:	b7c5                	j	80001e6e <devintr+0x5e>
    if(cpuid() == 0){
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	f8c080e7          	jalr	-116(ra) # 80000e1c <cpuid>
    80001e98:	c901                	beqz	a0,80001ea8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e9a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ea0:	14479073          	csrw	sip,a5
    return 2;
    80001ea4:	4509                	li	a0,2
    80001ea6:	b761                	j	80001e2e <devintr+0x1e>
      clockintr();
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	f22080e7          	jalr	-222(ra) # 80001dca <clockintr>
    80001eb0:	b7ed                	j	80001e9a <devintr+0x8a>

0000000080001eb2 <usertrap>:
{
    80001eb2:	1101                	addi	sp,sp,-32
    80001eb4:	ec06                	sd	ra,24(sp)
    80001eb6:	e822                	sd	s0,16(sp)
    80001eb8:	e426                	sd	s1,8(sp)
    80001eba:	e04a                	sd	s2,0(sp)
    80001ebc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ebe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ec2:	1007f793          	andi	a5,a5,256
    80001ec6:	e3b9                	bnez	a5,80001f0c <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ec8:	00003797          	auipc	a5,0x3
    80001ecc:	66878793          	addi	a5,a5,1640 # 80005530 <kernelvec>
    80001ed0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	f74080e7          	jalr	-140(ra) # 80000e48 <myproc>
    80001edc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ede:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee0:	14102773          	csrr	a4,sepc
    80001ee4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001eea:	47a1                	li	a5,8
    80001eec:	02f70863          	beq	a4,a5,80001f1c <usertrap+0x6a>
    80001ef0:	14202773          	csrr	a4,scause
  } else if(r_scause() == 13){
    80001ef4:	47b5                	li	a5,13
    80001ef6:	04f70d63          	beq	a4,a5,80001f50 <usertrap+0x9e>
  } else if((which_dev = devintr()) != 0){
    80001efa:	00000097          	auipc	ra,0x0
    80001efe:	f16080e7          	jalr	-234(ra) # 80001e10 <devintr>
    80001f02:	892a                	mv	s2,a0
    80001f04:	c949                	beqz	a0,80001f96 <usertrap+0xe4>
  if(p->killed)
    80001f06:	549c                	lw	a5,40(s1)
    80001f08:	cbb5                	beqz	a5,80001f7c <usertrap+0xca>
    80001f0a:	a0a5                	j	80001f72 <usertrap+0xc0>
    panic("usertrap: not from user mode");
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	38c50513          	addi	a0,a0,908 # 80008298 <states.1751+0x58>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	214080e7          	jalr	532(ra) # 80006128 <panic>
    if(p->killed)
    80001f1c:	551c                	lw	a5,40(a0)
    80001f1e:	e39d                	bnez	a5,80001f44 <usertrap+0x92>
    p->trapframe->epc += 4;
    80001f20:	6cb8                	ld	a4,88(s1)
    80001f22:	6f1c                	ld	a5,24(a4)
    80001f24:	0791                	addi	a5,a5,4
    80001f26:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f2c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f30:	10079073          	csrw	sstatus,a5
    syscall();
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	2e2080e7          	jalr	738(ra) # 80002216 <syscall>
  if(p->killed)
    80001f3c:	549c                	lw	a5,40(s1)
    80001f3e:	c3b1                	beqz	a5,80001f82 <usertrap+0xd0>
    80001f40:	4901                	li	s2,0
    80001f42:	a805                	j	80001f72 <usertrap+0xc0>
      exit(-1);
    80001f44:	557d                	li	a0,-1
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	88a080e7          	jalr	-1910(ra) # 800017d0 <exit>
    80001f4e:	bfc9                	j	80001f20 <usertrap+0x6e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f50:	14302973          	csrr	s2,stval
    int is_alloc = mmap_lazyalloc(p->pagetable, fault_va);
    80001f54:	85ca                	mv	a1,s2
    80001f56:	6928                	ld	a0,80(a0)
    80001f58:	00000097          	auipc	ra,0x0
    80001f5c:	c98080e7          	jalr	-872(ra) # 80001bf0 <mmap_lazyalloc>
    if(fault_va > p->sz || is_alloc == -1){
    80001f60:	64bc                	ld	a5,72(s1)
    80001f62:	0127e563          	bltu	a5,s2,80001f6c <usertrap+0xba>
    80001f66:	57fd                	li	a5,-1
    80001f68:	fcf51ae3          	bne	a0,a5,80001f3c <usertrap+0x8a>
      p->killed = 1;
    80001f6c:	4785                	li	a5,1
    80001f6e:	d49c                	sw	a5,40(s1)
{
    80001f70:	4901                	li	s2,0
    exit(-1);
    80001f72:	557d                	li	a0,-1
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	85c080e7          	jalr	-1956(ra) # 800017d0 <exit>
  if(which_dev == 2)
    80001f7c:	4789                	li	a5,2
    80001f7e:	04f90663          	beq	s2,a5,80001fca <usertrap+0x118>
  usertrapret();
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	daa080e7          	jalr	-598(ra) # 80001d2c <usertrapret>
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6902                	ld	s2,0(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f96:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f9a:	5890                	lw	a2,48(s1)
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	31c50513          	addi	a0,a0,796 # 800082b8 <states.1751+0x78>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	1ce080e7          	jalr	462(ra) # 80006172 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	33450513          	addi	a0,a0,820 # 800082e8 <states.1751+0xa8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	1b6080e7          	jalr	438(ra) # 80006172 <printf>
    p->killed = 1;
    80001fc4:	4785                	li	a5,1
    80001fc6:	d49c                	sw	a5,40(s1)
    80001fc8:	b765                	j	80001f70 <usertrap+0xbe>
    yield();
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	56e080e7          	jalr	1390(ra) # 80001538 <yield>
    80001fd2:	bf45                	j	80001f82 <usertrap+0xd0>

0000000080001fd4 <kerneltrap>:
{
    80001fd4:	7179                	addi	sp,sp,-48
    80001fd6:	f406                	sd	ra,40(sp)
    80001fd8:	f022                	sd	s0,32(sp)
    80001fda:	ec26                	sd	s1,24(sp)
    80001fdc:	e84a                	sd	s2,16(sp)
    80001fde:	e44e                	sd	s3,8(sp)
    80001fe0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fe2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fee:	1004f793          	andi	a5,s1,256
    80001ff2:	cb85                	beqz	a5,80002022 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ff8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ffa:	ef85                	bnez	a5,80002032 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	e14080e7          	jalr	-492(ra) # 80001e10 <devintr>
    80002004:	cd1d                	beqz	a0,80002042 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002006:	4789                	li	a5,2
    80002008:	06f50a63          	beq	a0,a5,8000207c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000200c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002010:	10049073          	csrw	sstatus,s1
}
    80002014:	70a2                	ld	ra,40(sp)
    80002016:	7402                	ld	s0,32(sp)
    80002018:	64e2                	ld	s1,24(sp)
    8000201a:	6942                	ld	s2,16(sp)
    8000201c:	69a2                	ld	s3,8(sp)
    8000201e:	6145                	addi	sp,sp,48
    80002020:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	2e650513          	addi	a0,a0,742 # 80008308 <states.1751+0xc8>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	0fe080e7          	jalr	254(ra) # 80006128 <panic>
    panic("kerneltrap: interrupts enabled");
    80002032:	00006517          	auipc	a0,0x6
    80002036:	2fe50513          	addi	a0,a0,766 # 80008330 <states.1751+0xf0>
    8000203a:	00004097          	auipc	ra,0x4
    8000203e:	0ee080e7          	jalr	238(ra) # 80006128 <panic>
    printf("scause %p\n", scause);
    80002042:	85ce                	mv	a1,s3
    80002044:	00006517          	auipc	a0,0x6
    80002048:	30c50513          	addi	a0,a0,780 # 80008350 <states.1751+0x110>
    8000204c:	00004097          	auipc	ra,0x4
    80002050:	126080e7          	jalr	294(ra) # 80006172 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002054:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002058:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	30450513          	addi	a0,a0,772 # 80008360 <states.1751+0x120>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	10e080e7          	jalr	270(ra) # 80006172 <printf>
    panic("kerneltrap");
    8000206c:	00006517          	auipc	a0,0x6
    80002070:	30c50513          	addi	a0,a0,780 # 80008378 <states.1751+0x138>
    80002074:	00004097          	auipc	ra,0x4
    80002078:	0b4080e7          	jalr	180(ra) # 80006128 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	dcc080e7          	jalr	-564(ra) # 80000e48 <myproc>
    80002084:	d541                	beqz	a0,8000200c <kerneltrap+0x38>
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	dc2080e7          	jalr	-574(ra) # 80000e48 <myproc>
    8000208e:	4d18                	lw	a4,24(a0)
    80002090:	4791                	li	a5,4
    80002092:	f6f71de3          	bne	a4,a5,8000200c <kerneltrap+0x38>
    yield();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	4a2080e7          	jalr	1186(ra) # 80001538 <yield>
    8000209e:	b7bd                	j	8000200c <kerneltrap+0x38>

00000000800020a0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	e426                	sd	s1,8(sp)
    800020a8:	1000                	addi	s0,sp,32
    800020aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	d9c080e7          	jalr	-612(ra) # 80000e48 <myproc>
  switch (n) {
    800020b4:	4795                	li	a5,5
    800020b6:	0497e163          	bltu	a5,s1,800020f8 <argraw+0x58>
    800020ba:	048a                	slli	s1,s1,0x2
    800020bc:	00006717          	auipc	a4,0x6
    800020c0:	2f470713          	addi	a4,a4,756 # 800083b0 <states.1751+0x170>
    800020c4:	94ba                	add	s1,s1,a4
    800020c6:	409c                	lw	a5,0(s1)
    800020c8:	97ba                	add	a5,a5,a4
    800020ca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020cc:	6d3c                	ld	a5,88(a0)
    800020ce:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	64a2                	ld	s1,8(sp)
    800020d6:	6105                	addi	sp,sp,32
    800020d8:	8082                	ret
    return p->trapframe->a1;
    800020da:	6d3c                	ld	a5,88(a0)
    800020dc:	7fa8                	ld	a0,120(a5)
    800020de:	bfcd                	j	800020d0 <argraw+0x30>
    return p->trapframe->a2;
    800020e0:	6d3c                	ld	a5,88(a0)
    800020e2:	63c8                	ld	a0,128(a5)
    800020e4:	b7f5                	j	800020d0 <argraw+0x30>
    return p->trapframe->a3;
    800020e6:	6d3c                	ld	a5,88(a0)
    800020e8:	67c8                	ld	a0,136(a5)
    800020ea:	b7dd                	j	800020d0 <argraw+0x30>
    return p->trapframe->a4;
    800020ec:	6d3c                	ld	a5,88(a0)
    800020ee:	6bc8                	ld	a0,144(a5)
    800020f0:	b7c5                	j	800020d0 <argraw+0x30>
    return p->trapframe->a5;
    800020f2:	6d3c                	ld	a5,88(a0)
    800020f4:	6fc8                	ld	a0,152(a5)
    800020f6:	bfe9                	j	800020d0 <argraw+0x30>
  panic("argraw");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	29050513          	addi	a0,a0,656 # 80008388 <states.1751+0x148>
    80002100:	00004097          	auipc	ra,0x4
    80002104:	028080e7          	jalr	40(ra) # 80006128 <panic>

0000000080002108 <fetchaddr>:
{
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	e04a                	sd	s2,0(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	84aa                	mv	s1,a0
    80002116:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	d30080e7          	jalr	-720(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002120:	653c                	ld	a5,72(a0)
    80002122:	02f4f863          	bgeu	s1,a5,80002152 <fetchaddr+0x4a>
    80002126:	00848713          	addi	a4,s1,8
    8000212a:	02e7e663          	bltu	a5,a4,80002156 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000212e:	46a1                	li	a3,8
    80002130:	8626                	mv	a2,s1
    80002132:	85ca                	mv	a1,s2
    80002134:	6928                	ld	a0,80(a0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	a60080e7          	jalr	-1440(ra) # 80000b96 <copyin>
    8000213e:	00a03533          	snez	a0,a0
    80002142:	40a00533          	neg	a0,a0
}
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	64a2                	ld	s1,8(sp)
    8000214c:	6902                	ld	s2,0(sp)
    8000214e:	6105                	addi	sp,sp,32
    80002150:	8082                	ret
    return -1;
    80002152:	557d                	li	a0,-1
    80002154:	bfcd                	j	80002146 <fetchaddr+0x3e>
    80002156:	557d                	li	a0,-1
    80002158:	b7fd                	j	80002146 <fetchaddr+0x3e>

000000008000215a <fetchstr>:
{
    8000215a:	7179                	addi	sp,sp,-48
    8000215c:	f406                	sd	ra,40(sp)
    8000215e:	f022                	sd	s0,32(sp)
    80002160:	ec26                	sd	s1,24(sp)
    80002162:	e84a                	sd	s2,16(sp)
    80002164:	e44e                	sd	s3,8(sp)
    80002166:	1800                	addi	s0,sp,48
    80002168:	892a                	mv	s2,a0
    8000216a:	84ae                	mv	s1,a1
    8000216c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	cda080e7          	jalr	-806(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002176:	86ce                	mv	a3,s3
    80002178:	864a                	mv	a2,s2
    8000217a:	85a6                	mv	a1,s1
    8000217c:	6928                	ld	a0,80(a0)
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	aa4080e7          	jalr	-1372(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002186:	00054763          	bltz	a0,80002194 <fetchstr+0x3a>
  return strlen(buf);
    8000218a:	8526                	mv	a0,s1
    8000218c:	ffffe097          	auipc	ra,0xffffe
    80002190:	170080e7          	jalr	368(ra) # 800002fc <strlen>
}
    80002194:	70a2                	ld	ra,40(sp)
    80002196:	7402                	ld	s0,32(sp)
    80002198:	64e2                	ld	s1,24(sp)
    8000219a:	6942                	ld	s2,16(sp)
    8000219c:	69a2                	ld	s3,8(sp)
    8000219e:	6145                	addi	sp,sp,48
    800021a0:	8082                	ret

00000000800021a2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	e426                	sd	s1,8(sp)
    800021aa:	1000                	addi	s0,sp,32
    800021ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	ef2080e7          	jalr	-270(ra) # 800020a0 <argraw>
    800021b6:	c088                	sw	a0,0(s1)
  return 0;
}
    800021b8:	4501                	li	a0,0
    800021ba:	60e2                	ld	ra,24(sp)
    800021bc:	6442                	ld	s0,16(sp)
    800021be:	64a2                	ld	s1,8(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021c4:	1101                	addi	sp,sp,-32
    800021c6:	ec06                	sd	ra,24(sp)
    800021c8:	e822                	sd	s0,16(sp)
    800021ca:	e426                	sd	s1,8(sp)
    800021cc:	1000                	addi	s0,sp,32
    800021ce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021d0:	00000097          	auipc	ra,0x0
    800021d4:	ed0080e7          	jalr	-304(ra) # 800020a0 <argraw>
    800021d8:	e088                	sd	a0,0(s1)
  return 0;
}
    800021da:	4501                	li	a0,0
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	e426                	sd	s1,8(sp)
    800021ee:	e04a                	sd	s2,0(sp)
    800021f0:	1000                	addi	s0,sp,32
    800021f2:	84ae                	mv	s1,a1
    800021f4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	eaa080e7          	jalr	-342(ra) # 800020a0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021fe:	864a                	mv	a2,s2
    80002200:	85a6                	mv	a1,s1
    80002202:	00000097          	auipc	ra,0x0
    80002206:	f58080e7          	jalr	-168(ra) # 8000215a <fetchstr>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	64a2                	ld	s1,8(sp)
    80002210:	6902                	ld	s2,0(sp)
    80002212:	6105                	addi	sp,sp,32
    80002214:	8082                	ret

0000000080002216 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	e426                	sd	s1,8(sp)
    8000221e:	e04a                	sd	s2,0(sp)
    80002220:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	c26080e7          	jalr	-986(ra) # 80000e48 <myproc>
    8000222a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000222c:	05853903          	ld	s2,88(a0)
    80002230:	0a893783          	ld	a5,168(s2)
    80002234:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002238:	37fd                	addiw	a5,a5,-1
    8000223a:	4759                	li	a4,22
    8000223c:	00f76f63          	bltu	a4,a5,8000225a <syscall+0x44>
    80002240:	00369713          	slli	a4,a3,0x3
    80002244:	00006797          	auipc	a5,0x6
    80002248:	18478793          	addi	a5,a5,388 # 800083c8 <syscalls>
    8000224c:	97ba                	add	a5,a5,a4
    8000224e:	639c                	ld	a5,0(a5)
    80002250:	c789                	beqz	a5,8000225a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002252:	9782                	jalr	a5
    80002254:	06a93823          	sd	a0,112(s2)
    80002258:	a839                	j	80002276 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000225a:	15848613          	addi	a2,s1,344
    8000225e:	588c                	lw	a1,48(s1)
    80002260:	00006517          	auipc	a0,0x6
    80002264:	13050513          	addi	a0,a0,304 # 80008390 <states.1751+0x150>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	f0a080e7          	jalr	-246(ra) # 80006172 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002270:	6cbc                	ld	a5,88(s1)
    80002272:	577d                	li	a4,-1
    80002274:	fbb8                	sd	a4,112(a5)
  }
}
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	64a2                	ld	s1,8(sp)
    8000227c:	6902                	ld	s2,0(sp)
    8000227e:	6105                	addi	sp,sp,32
    80002280:	8082                	ret

0000000080002282 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002282:	1101                	addi	sp,sp,-32
    80002284:	ec06                	sd	ra,24(sp)
    80002286:	e822                	sd	s0,16(sp)
    80002288:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000228a:	fec40593          	addi	a1,s0,-20
    8000228e:	4501                	li	a0,0
    80002290:	00000097          	auipc	ra,0x0
    80002294:	f12080e7          	jalr	-238(ra) # 800021a2 <argint>
    return -1;
    80002298:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000229a:	00054963          	bltz	a0,800022ac <sys_exit+0x2a>
  exit(n);
    8000229e:	fec42503          	lw	a0,-20(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	52e080e7          	jalr	1326(ra) # 800017d0 <exit>
  return 0;  // not reached
    800022aa:	4781                	li	a5,0
}
    800022ac:	853e                	mv	a0,a5
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	6105                	addi	sp,sp,32
    800022b4:	8082                	ret

00000000800022b6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022b6:	1141                	addi	sp,sp,-16
    800022b8:	e406                	sd	ra,8(sp)
    800022ba:	e022                	sd	s0,0(sp)
    800022bc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	b8a080e7          	jalr	-1142(ra) # 80000e48 <myproc>
}
    800022c6:	5908                	lw	a0,48(a0)
    800022c8:	60a2                	ld	ra,8(sp)
    800022ca:	6402                	ld	s0,0(sp)
    800022cc:	0141                	addi	sp,sp,16
    800022ce:	8082                	ret

00000000800022d0 <sys_fork>:

uint64
sys_fork(void)
{
    800022d0:	1141                	addi	sp,sp,-16
    800022d2:	e406                	sd	ra,8(sp)
    800022d4:	e022                	sd	s0,0(sp)
    800022d6:	0800                	addi	s0,sp,16
  return fork();
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	f3e080e7          	jalr	-194(ra) # 80001216 <fork>
}
    800022e0:	60a2                	ld	ra,8(sp)
    800022e2:	6402                	ld	s0,0(sp)
    800022e4:	0141                	addi	sp,sp,16
    800022e6:	8082                	ret

00000000800022e8 <sys_wait>:

uint64
sys_wait(void)
{
    800022e8:	1101                	addi	sp,sp,-32
    800022ea:	ec06                	sd	ra,24(sp)
    800022ec:	e822                	sd	s0,16(sp)
    800022ee:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022f0:	fe840593          	addi	a1,s0,-24
    800022f4:	4501                	li	a0,0
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	ece080e7          	jalr	-306(ra) # 800021c4 <argaddr>
    800022fe:	87aa                	mv	a5,a0
    return -1;
    80002300:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002302:	0007c863          	bltz	a5,80002312 <sys_wait+0x2a>
  return wait(p);
    80002306:	fe843503          	ld	a0,-24(s0)
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	2ce080e7          	jalr	718(ra) # 800015d8 <wait>
}
    80002312:	60e2                	ld	ra,24(sp)
    80002314:	6442                	ld	s0,16(sp)
    80002316:	6105                	addi	sp,sp,32
    80002318:	8082                	ret

000000008000231a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000231a:	7179                	addi	sp,sp,-48
    8000231c:	f406                	sd	ra,40(sp)
    8000231e:	f022                	sd	s0,32(sp)
    80002320:	ec26                	sd	s1,24(sp)
    80002322:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002324:	fdc40593          	addi	a1,s0,-36
    80002328:	4501                	li	a0,0
    8000232a:	00000097          	auipc	ra,0x0
    8000232e:	e78080e7          	jalr	-392(ra) # 800021a2 <argint>
    80002332:	87aa                	mv	a5,a0
    return -1;
    80002334:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002336:	0207c063          	bltz	a5,80002356 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	b0e080e7          	jalr	-1266(ra) # 80000e48 <myproc>
    80002342:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002344:	fdc42503          	lw	a0,-36(s0)
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	e5a080e7          	jalr	-422(ra) # 800011a2 <growproc>
    80002350:	00054863          	bltz	a0,80002360 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002354:	8526                	mv	a0,s1
}
    80002356:	70a2                	ld	ra,40(sp)
    80002358:	7402                	ld	s0,32(sp)
    8000235a:	64e2                	ld	s1,24(sp)
    8000235c:	6145                	addi	sp,sp,48
    8000235e:	8082                	ret
    return -1;
    80002360:	557d                	li	a0,-1
    80002362:	bfd5                	j	80002356 <sys_sbrk+0x3c>

0000000080002364 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002364:	7139                	addi	sp,sp,-64
    80002366:	fc06                	sd	ra,56(sp)
    80002368:	f822                	sd	s0,48(sp)
    8000236a:	f426                	sd	s1,40(sp)
    8000236c:	f04a                	sd	s2,32(sp)
    8000236e:	ec4e                	sd	s3,24(sp)
    80002370:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002372:	fcc40593          	addi	a1,s0,-52
    80002376:	4501                	li	a0,0
    80002378:	00000097          	auipc	ra,0x0
    8000237c:	e2a080e7          	jalr	-470(ra) # 800021a2 <argint>
    return -1;
    80002380:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002382:	06054563          	bltz	a0,800023ec <sys_sleep+0x88>
  acquire(&tickslock);
    80002386:	00017517          	auipc	a0,0x17
    8000238a:	afa50513          	addi	a0,a0,-1286 # 80018e80 <tickslock>
    8000238e:	00004097          	auipc	ra,0x4
    80002392:	2e4080e7          	jalr	740(ra) # 80006672 <acquire>
  ticks0 = ticks;
    80002396:	00007917          	auipc	s2,0x7
    8000239a:	c8292903          	lw	s2,-894(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000239e:	fcc42783          	lw	a5,-52(s0)
    800023a2:	cf85                	beqz	a5,800023da <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023a4:	00017997          	auipc	s3,0x17
    800023a8:	adc98993          	addi	s3,s3,-1316 # 80018e80 <tickslock>
    800023ac:	00007497          	auipc	s1,0x7
    800023b0:	c6c48493          	addi	s1,s1,-916 # 80009018 <ticks>
    if(myproc()->killed){
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	a94080e7          	jalr	-1388(ra) # 80000e48 <myproc>
    800023bc:	551c                	lw	a5,40(a0)
    800023be:	ef9d                	bnez	a5,800023fc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023c0:	85ce                	mv	a1,s3
    800023c2:	8526                	mv	a0,s1
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	1b0080e7          	jalr	432(ra) # 80001574 <sleep>
  while(ticks - ticks0 < n){
    800023cc:	409c                	lw	a5,0(s1)
    800023ce:	412787bb          	subw	a5,a5,s2
    800023d2:	fcc42703          	lw	a4,-52(s0)
    800023d6:	fce7efe3          	bltu	a5,a4,800023b4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800023da:	00017517          	auipc	a0,0x17
    800023de:	aa650513          	addi	a0,a0,-1370 # 80018e80 <tickslock>
    800023e2:	00004097          	auipc	ra,0x4
    800023e6:	344080e7          	jalr	836(ra) # 80006726 <release>
  return 0;
    800023ea:	4781                	li	a5,0
}
    800023ec:	853e                	mv	a0,a5
    800023ee:	70e2                	ld	ra,56(sp)
    800023f0:	7442                	ld	s0,48(sp)
    800023f2:	74a2                	ld	s1,40(sp)
    800023f4:	7902                	ld	s2,32(sp)
    800023f6:	69e2                	ld	s3,24(sp)
    800023f8:	6121                	addi	sp,sp,64
    800023fa:	8082                	ret
      release(&tickslock);
    800023fc:	00017517          	auipc	a0,0x17
    80002400:	a8450513          	addi	a0,a0,-1404 # 80018e80 <tickslock>
    80002404:	00004097          	auipc	ra,0x4
    80002408:	322080e7          	jalr	802(ra) # 80006726 <release>
      return -1;
    8000240c:	57fd                	li	a5,-1
    8000240e:	bff9                	j	800023ec <sys_sleep+0x88>

0000000080002410 <sys_kill>:

uint64
sys_kill(void)
{
    80002410:	1101                	addi	sp,sp,-32
    80002412:	ec06                	sd	ra,24(sp)
    80002414:	e822                	sd	s0,16(sp)
    80002416:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002418:	fec40593          	addi	a1,s0,-20
    8000241c:	4501                	li	a0,0
    8000241e:	00000097          	auipc	ra,0x0
    80002422:	d84080e7          	jalr	-636(ra) # 800021a2 <argint>
    80002426:	87aa                	mv	a5,a0
    return -1;
    80002428:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000242a:	0007c863          	bltz	a5,8000243a <sys_kill+0x2a>
  return kill(pid);
    8000242e:	fec42503          	lw	a0,-20(s0)
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	548080e7          	jalr	1352(ra) # 8000197a <kill>
}
    8000243a:	60e2                	ld	ra,24(sp)
    8000243c:	6442                	ld	s0,16(sp)
    8000243e:	6105                	addi	sp,sp,32
    80002440:	8082                	ret

0000000080002442 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002442:	1101                	addi	sp,sp,-32
    80002444:	ec06                	sd	ra,24(sp)
    80002446:	e822                	sd	s0,16(sp)
    80002448:	e426                	sd	s1,8(sp)
    8000244a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000244c:	00017517          	auipc	a0,0x17
    80002450:	a3450513          	addi	a0,a0,-1484 # 80018e80 <tickslock>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	21e080e7          	jalr	542(ra) # 80006672 <acquire>
  xticks = ticks;
    8000245c:	00007497          	auipc	s1,0x7
    80002460:	bbc4a483          	lw	s1,-1092(s1) # 80009018 <ticks>
  release(&tickslock);
    80002464:	00017517          	auipc	a0,0x17
    80002468:	a1c50513          	addi	a0,a0,-1508 # 80018e80 <tickslock>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	2ba080e7          	jalr	698(ra) # 80006726 <release>
  return xticks;
}
    80002474:	02049513          	slli	a0,s1,0x20
    80002478:	9101                	srli	a0,a0,0x20
    8000247a:	60e2                	ld	ra,24(sp)
    8000247c:	6442                	ld	s0,16(sp)
    8000247e:	64a2                	ld	s1,8(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret

0000000080002484 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002484:	7179                	addi	sp,sp,-48
    80002486:	f406                	sd	ra,40(sp)
    80002488:	f022                	sd	s0,32(sp)
    8000248a:	ec26                	sd	s1,24(sp)
    8000248c:	e84a                	sd	s2,16(sp)
    8000248e:	e44e                	sd	s3,8(sp)
    80002490:	e052                	sd	s4,0(sp)
    80002492:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002494:	00006597          	auipc	a1,0x6
    80002498:	ff458593          	addi	a1,a1,-12 # 80008488 <syscalls+0xc0>
    8000249c:	00017517          	auipc	a0,0x17
    800024a0:	9fc50513          	addi	a0,a0,-1540 # 80018e98 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	13e080e7          	jalr	318(ra) # 800065e2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024ac:	0001f797          	auipc	a5,0x1f
    800024b0:	9ec78793          	addi	a5,a5,-1556 # 80020e98 <bcache+0x8000>
    800024b4:	0001f717          	auipc	a4,0x1f
    800024b8:	c4c70713          	addi	a4,a4,-948 # 80021100 <bcache+0x8268>
    800024bc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024c0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024c4:	00017497          	auipc	s1,0x17
    800024c8:	9ec48493          	addi	s1,s1,-1556 # 80018eb0 <bcache+0x18>
    b->next = bcache.head.next;
    800024cc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024ce:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024d0:	00006a17          	auipc	s4,0x6
    800024d4:	fc0a0a13          	addi	s4,s4,-64 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    800024d8:	2b893783          	ld	a5,696(s2)
    800024dc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024de:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024e2:	85d2                	mv	a1,s4
    800024e4:	01048513          	addi	a0,s1,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	4bc080e7          	jalr	1212(ra) # 800039a4 <initsleeplock>
    bcache.head.next->prev = b;
    800024f0:	2b893783          	ld	a5,696(s2)
    800024f4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024fa:	45848493          	addi	s1,s1,1112
    800024fe:	fd349de3          	bne	s1,s3,800024d8 <binit+0x54>
  }
}
    80002502:	70a2                	ld	ra,40(sp)
    80002504:	7402                	ld	s0,32(sp)
    80002506:	64e2                	ld	s1,24(sp)
    80002508:	6942                	ld	s2,16(sp)
    8000250a:	69a2                	ld	s3,8(sp)
    8000250c:	6a02                	ld	s4,0(sp)
    8000250e:	6145                	addi	sp,sp,48
    80002510:	8082                	ret

0000000080002512 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002512:	7179                	addi	sp,sp,-48
    80002514:	f406                	sd	ra,40(sp)
    80002516:	f022                	sd	s0,32(sp)
    80002518:	ec26                	sd	s1,24(sp)
    8000251a:	e84a                	sd	s2,16(sp)
    8000251c:	e44e                	sd	s3,8(sp)
    8000251e:	1800                	addi	s0,sp,48
    80002520:	89aa                	mv	s3,a0
    80002522:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002524:	00017517          	auipc	a0,0x17
    80002528:	97450513          	addi	a0,a0,-1676 # 80018e98 <bcache>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	146080e7          	jalr	326(ra) # 80006672 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002534:	0001f497          	auipc	s1,0x1f
    80002538:	c1c4b483          	ld	s1,-996(s1) # 80021150 <bcache+0x82b8>
    8000253c:	0001f797          	auipc	a5,0x1f
    80002540:	bc478793          	addi	a5,a5,-1084 # 80021100 <bcache+0x8268>
    80002544:	02f48f63          	beq	s1,a5,80002582 <bread+0x70>
    80002548:	873e                	mv	a4,a5
    8000254a:	a021                	j	80002552 <bread+0x40>
    8000254c:	68a4                	ld	s1,80(s1)
    8000254e:	02e48a63          	beq	s1,a4,80002582 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002552:	449c                	lw	a5,8(s1)
    80002554:	ff379ce3          	bne	a5,s3,8000254c <bread+0x3a>
    80002558:	44dc                	lw	a5,12(s1)
    8000255a:	ff2799e3          	bne	a5,s2,8000254c <bread+0x3a>
      b->refcnt++;
    8000255e:	40bc                	lw	a5,64(s1)
    80002560:	2785                	addiw	a5,a5,1
    80002562:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002564:	00017517          	auipc	a0,0x17
    80002568:	93450513          	addi	a0,a0,-1740 # 80018e98 <bcache>
    8000256c:	00004097          	auipc	ra,0x4
    80002570:	1ba080e7          	jalr	442(ra) # 80006726 <release>
      acquiresleep(&b->lock);
    80002574:	01048513          	addi	a0,s1,16
    80002578:	00001097          	auipc	ra,0x1
    8000257c:	466080e7          	jalr	1126(ra) # 800039de <acquiresleep>
      return b;
    80002580:	a8b9                	j	800025de <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002582:	0001f497          	auipc	s1,0x1f
    80002586:	bc64b483          	ld	s1,-1082(s1) # 80021148 <bcache+0x82b0>
    8000258a:	0001f797          	auipc	a5,0x1f
    8000258e:	b7678793          	addi	a5,a5,-1162 # 80021100 <bcache+0x8268>
    80002592:	00f48863          	beq	s1,a5,800025a2 <bread+0x90>
    80002596:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002598:	40bc                	lw	a5,64(s1)
    8000259a:	cf81                	beqz	a5,800025b2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259c:	64a4                	ld	s1,72(s1)
    8000259e:	fee49de3          	bne	s1,a4,80002598 <bread+0x86>
  panic("bget: no buffers");
    800025a2:	00006517          	auipc	a0,0x6
    800025a6:	ef650513          	addi	a0,a0,-266 # 80008498 <syscalls+0xd0>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	b7e080e7          	jalr	-1154(ra) # 80006128 <panic>
      b->dev = dev;
    800025b2:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025b6:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025ba:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025be:	4785                	li	a5,1
    800025c0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c2:	00017517          	auipc	a0,0x17
    800025c6:	8d650513          	addi	a0,a0,-1834 # 80018e98 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	15c080e7          	jalr	348(ra) # 80006726 <release>
      acquiresleep(&b->lock);
    800025d2:	01048513          	addi	a0,s1,16
    800025d6:	00001097          	auipc	ra,0x1
    800025da:	408080e7          	jalr	1032(ra) # 800039de <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025de:	409c                	lw	a5,0(s1)
    800025e0:	cb89                	beqz	a5,800025f2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025e2:	8526                	mv	a0,s1
    800025e4:	70a2                	ld	ra,40(sp)
    800025e6:	7402                	ld	s0,32(sp)
    800025e8:	64e2                	ld	s1,24(sp)
    800025ea:	6942                	ld	s2,16(sp)
    800025ec:	69a2                	ld	s3,8(sp)
    800025ee:	6145                	addi	sp,sp,48
    800025f0:	8082                	ret
    virtio_disk_rw(b, 0);
    800025f2:	4581                	li	a1,0
    800025f4:	8526                	mv	a0,s1
    800025f6:	00003097          	auipc	ra,0x3
    800025fa:	270080e7          	jalr	624(ra) # 80005866 <virtio_disk_rw>
    b->valid = 1;
    800025fe:	4785                	li	a5,1
    80002600:	c09c                	sw	a5,0(s1)
  return b;
    80002602:	b7c5                	j	800025e2 <bread+0xd0>

0000000080002604 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002604:	1101                	addi	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002610:	0541                	addi	a0,a0,16
    80002612:	00001097          	auipc	ra,0x1
    80002616:	466080e7          	jalr	1126(ra) # 80003a78 <holdingsleep>
    8000261a:	cd01                	beqz	a0,80002632 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000261c:	4585                	li	a1,1
    8000261e:	8526                	mv	a0,s1
    80002620:	00003097          	auipc	ra,0x3
    80002624:	246080e7          	jalr	582(ra) # 80005866 <virtio_disk_rw>
}
    80002628:	60e2                	ld	ra,24(sp)
    8000262a:	6442                	ld	s0,16(sp)
    8000262c:	64a2                	ld	s1,8(sp)
    8000262e:	6105                	addi	sp,sp,32
    80002630:	8082                	ret
    panic("bwrite");
    80002632:	00006517          	auipc	a0,0x6
    80002636:	e7e50513          	addi	a0,a0,-386 # 800084b0 <syscalls+0xe8>
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	aee080e7          	jalr	-1298(ra) # 80006128 <panic>

0000000080002642 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002642:	1101                	addi	sp,sp,-32
    80002644:	ec06                	sd	ra,24(sp)
    80002646:	e822                	sd	s0,16(sp)
    80002648:	e426                	sd	s1,8(sp)
    8000264a:	e04a                	sd	s2,0(sp)
    8000264c:	1000                	addi	s0,sp,32
    8000264e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002650:	01050913          	addi	s2,a0,16
    80002654:	854a                	mv	a0,s2
    80002656:	00001097          	auipc	ra,0x1
    8000265a:	422080e7          	jalr	1058(ra) # 80003a78 <holdingsleep>
    8000265e:	c92d                	beqz	a0,800026d0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002660:	854a                	mv	a0,s2
    80002662:	00001097          	auipc	ra,0x1
    80002666:	3d2080e7          	jalr	978(ra) # 80003a34 <releasesleep>

  acquire(&bcache.lock);
    8000266a:	00017517          	auipc	a0,0x17
    8000266e:	82e50513          	addi	a0,a0,-2002 # 80018e98 <bcache>
    80002672:	00004097          	auipc	ra,0x4
    80002676:	000080e7          	jalr	ra # 80006672 <acquire>
  b->refcnt--;
    8000267a:	40bc                	lw	a5,64(s1)
    8000267c:	37fd                	addiw	a5,a5,-1
    8000267e:	0007871b          	sext.w	a4,a5
    80002682:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002684:	eb05                	bnez	a4,800026b4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002686:	68bc                	ld	a5,80(s1)
    80002688:	64b8                	ld	a4,72(s1)
    8000268a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000268c:	64bc                	ld	a5,72(s1)
    8000268e:	68b8                	ld	a4,80(s1)
    80002690:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002692:	0001f797          	auipc	a5,0x1f
    80002696:	80678793          	addi	a5,a5,-2042 # 80020e98 <bcache+0x8000>
    8000269a:	2b87b703          	ld	a4,696(a5)
    8000269e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026a0:	0001f717          	auipc	a4,0x1f
    800026a4:	a6070713          	addi	a4,a4,-1440 # 80021100 <bcache+0x8268>
    800026a8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026aa:	2b87b703          	ld	a4,696(a5)
    800026ae:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026b0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026b4:	00016517          	auipc	a0,0x16
    800026b8:	7e450513          	addi	a0,a0,2020 # 80018e98 <bcache>
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	06a080e7          	jalr	106(ra) # 80006726 <release>
}
    800026c4:	60e2                	ld	ra,24(sp)
    800026c6:	6442                	ld	s0,16(sp)
    800026c8:	64a2                	ld	s1,8(sp)
    800026ca:	6902                	ld	s2,0(sp)
    800026cc:	6105                	addi	sp,sp,32
    800026ce:	8082                	ret
    panic("brelse");
    800026d0:	00006517          	auipc	a0,0x6
    800026d4:	de850513          	addi	a0,a0,-536 # 800084b8 <syscalls+0xf0>
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	a50080e7          	jalr	-1456(ra) # 80006128 <panic>

00000000800026e0 <bpin>:

void
bpin(struct buf *b) {
    800026e0:	1101                	addi	sp,sp,-32
    800026e2:	ec06                	sd	ra,24(sp)
    800026e4:	e822                	sd	s0,16(sp)
    800026e6:	e426                	sd	s1,8(sp)
    800026e8:	1000                	addi	s0,sp,32
    800026ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ec:	00016517          	auipc	a0,0x16
    800026f0:	7ac50513          	addi	a0,a0,1964 # 80018e98 <bcache>
    800026f4:	00004097          	auipc	ra,0x4
    800026f8:	f7e080e7          	jalr	-130(ra) # 80006672 <acquire>
  b->refcnt++;
    800026fc:	40bc                	lw	a5,64(s1)
    800026fe:	2785                	addiw	a5,a5,1
    80002700:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002702:	00016517          	auipc	a0,0x16
    80002706:	79650513          	addi	a0,a0,1942 # 80018e98 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	01c080e7          	jalr	28(ra) # 80006726 <release>
}
    80002712:	60e2                	ld	ra,24(sp)
    80002714:	6442                	ld	s0,16(sp)
    80002716:	64a2                	ld	s1,8(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret

000000008000271c <bunpin>:

void
bunpin(struct buf *b) {
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
    80002726:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002728:	00016517          	auipc	a0,0x16
    8000272c:	77050513          	addi	a0,a0,1904 # 80018e98 <bcache>
    80002730:	00004097          	auipc	ra,0x4
    80002734:	f42080e7          	jalr	-190(ra) # 80006672 <acquire>
  b->refcnt--;
    80002738:	40bc                	lw	a5,64(s1)
    8000273a:	37fd                	addiw	a5,a5,-1
    8000273c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000273e:	00016517          	auipc	a0,0x16
    80002742:	75a50513          	addi	a0,a0,1882 # 80018e98 <bcache>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	fe0080e7          	jalr	-32(ra) # 80006726 <release>
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret

0000000080002758 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002758:	1101                	addi	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	e04a                	sd	s2,0(sp)
    80002762:	1000                	addi	s0,sp,32
    80002764:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002766:	00d5d59b          	srliw	a1,a1,0xd
    8000276a:	0001f797          	auipc	a5,0x1f
    8000276e:	e0a7a783          	lw	a5,-502(a5) # 80021574 <sb+0x1c>
    80002772:	9dbd                	addw	a1,a1,a5
    80002774:	00000097          	auipc	ra,0x0
    80002778:	d9e080e7          	jalr	-610(ra) # 80002512 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000277c:	0074f713          	andi	a4,s1,7
    80002780:	4785                	li	a5,1
    80002782:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002786:	14ce                	slli	s1,s1,0x33
    80002788:	90d9                	srli	s1,s1,0x36
    8000278a:	00950733          	add	a4,a0,s1
    8000278e:	05874703          	lbu	a4,88(a4)
    80002792:	00e7f6b3          	and	a3,a5,a4
    80002796:	c69d                	beqz	a3,800027c4 <bfree+0x6c>
    80002798:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000279a:	94aa                	add	s1,s1,a0
    8000279c:	fff7c793          	not	a5,a5
    800027a0:	8ff9                	and	a5,a5,a4
    800027a2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027a6:	00001097          	auipc	ra,0x1
    800027aa:	118080e7          	jalr	280(ra) # 800038be <log_write>
  brelse(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	e92080e7          	jalr	-366(ra) # 80002642 <brelse>
}
    800027b8:	60e2                	ld	ra,24(sp)
    800027ba:	6442                	ld	s0,16(sp)
    800027bc:	64a2                	ld	s1,8(sp)
    800027be:	6902                	ld	s2,0(sp)
    800027c0:	6105                	addi	sp,sp,32
    800027c2:	8082                	ret
    panic("freeing free block");
    800027c4:	00006517          	auipc	a0,0x6
    800027c8:	cfc50513          	addi	a0,a0,-772 # 800084c0 <syscalls+0xf8>
    800027cc:	00004097          	auipc	ra,0x4
    800027d0:	95c080e7          	jalr	-1700(ra) # 80006128 <panic>

00000000800027d4 <balloc>:
{
    800027d4:	711d                	addi	sp,sp,-96
    800027d6:	ec86                	sd	ra,88(sp)
    800027d8:	e8a2                	sd	s0,80(sp)
    800027da:	e4a6                	sd	s1,72(sp)
    800027dc:	e0ca                	sd	s2,64(sp)
    800027de:	fc4e                	sd	s3,56(sp)
    800027e0:	f852                	sd	s4,48(sp)
    800027e2:	f456                	sd	s5,40(sp)
    800027e4:	f05a                	sd	s6,32(sp)
    800027e6:	ec5e                	sd	s7,24(sp)
    800027e8:	e862                	sd	s8,16(sp)
    800027ea:	e466                	sd	s9,8(sp)
    800027ec:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ee:	0001f797          	auipc	a5,0x1f
    800027f2:	d6e7a783          	lw	a5,-658(a5) # 8002155c <sb+0x4>
    800027f6:	cbd1                	beqz	a5,8000288a <balloc+0xb6>
    800027f8:	8baa                	mv	s7,a0
    800027fa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027fc:	0001fb17          	auipc	s6,0x1f
    80002800:	d5cb0b13          	addi	s6,s6,-676 # 80021558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002804:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002806:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000280a:	6c89                	lui	s9,0x2
    8000280c:	a831                	j	80002828 <balloc+0x54>
    brelse(bp);
    8000280e:	854a                	mv	a0,s2
    80002810:	00000097          	auipc	ra,0x0
    80002814:	e32080e7          	jalr	-462(ra) # 80002642 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002818:	015c87bb          	addw	a5,s9,s5
    8000281c:	00078a9b          	sext.w	s5,a5
    80002820:	004b2703          	lw	a4,4(s6)
    80002824:	06eaf363          	bgeu	s5,a4,8000288a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002828:	41fad79b          	sraiw	a5,s5,0x1f
    8000282c:	0137d79b          	srliw	a5,a5,0x13
    80002830:	015787bb          	addw	a5,a5,s5
    80002834:	40d7d79b          	sraiw	a5,a5,0xd
    80002838:	01cb2583          	lw	a1,28(s6)
    8000283c:	9dbd                	addw	a1,a1,a5
    8000283e:	855e                	mv	a0,s7
    80002840:	00000097          	auipc	ra,0x0
    80002844:	cd2080e7          	jalr	-814(ra) # 80002512 <bread>
    80002848:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	004b2503          	lw	a0,4(s6)
    8000284e:	000a849b          	sext.w	s1,s5
    80002852:	8662                	mv	a2,s8
    80002854:	faa4fde3          	bgeu	s1,a0,8000280e <balloc+0x3a>
      m = 1 << (bi % 8);
    80002858:	41f6579b          	sraiw	a5,a2,0x1f
    8000285c:	01d7d69b          	srliw	a3,a5,0x1d
    80002860:	00c6873b          	addw	a4,a3,a2
    80002864:	00777793          	andi	a5,a4,7
    80002868:	9f95                	subw	a5,a5,a3
    8000286a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000286e:	4037571b          	sraiw	a4,a4,0x3
    80002872:	00e906b3          	add	a3,s2,a4
    80002876:	0586c683          	lbu	a3,88(a3)
    8000287a:	00d7f5b3          	and	a1,a5,a3
    8000287e:	cd91                	beqz	a1,8000289a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002880:	2605                	addiw	a2,a2,1
    80002882:	2485                	addiw	s1,s1,1
    80002884:	fd4618e3          	bne	a2,s4,80002854 <balloc+0x80>
    80002888:	b759                	j	8000280e <balloc+0x3a>
  panic("balloc: out of blocks");
    8000288a:	00006517          	auipc	a0,0x6
    8000288e:	c4e50513          	addi	a0,a0,-946 # 800084d8 <syscalls+0x110>
    80002892:	00004097          	auipc	ra,0x4
    80002896:	896080e7          	jalr	-1898(ra) # 80006128 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000289a:	974a                	add	a4,a4,s2
    8000289c:	8fd5                	or	a5,a5,a3
    8000289e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028a2:	854a                	mv	a0,s2
    800028a4:	00001097          	auipc	ra,0x1
    800028a8:	01a080e7          	jalr	26(ra) # 800038be <log_write>
        brelse(bp);
    800028ac:	854a                	mv	a0,s2
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	d94080e7          	jalr	-620(ra) # 80002642 <brelse>
  bp = bread(dev, bno);
    800028b6:	85a6                	mv	a1,s1
    800028b8:	855e                	mv	a0,s7
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	c58080e7          	jalr	-936(ra) # 80002512 <bread>
    800028c2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028c4:	40000613          	li	a2,1024
    800028c8:	4581                	li	a1,0
    800028ca:	05850513          	addi	a0,a0,88
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	8aa080e7          	jalr	-1878(ra) # 80000178 <memset>
  log_write(bp);
    800028d6:	854a                	mv	a0,s2
    800028d8:	00001097          	auipc	ra,0x1
    800028dc:	fe6080e7          	jalr	-26(ra) # 800038be <log_write>
  brelse(bp);
    800028e0:	854a                	mv	a0,s2
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	d60080e7          	jalr	-672(ra) # 80002642 <brelse>
}
    800028ea:	8526                	mv	a0,s1
    800028ec:	60e6                	ld	ra,88(sp)
    800028ee:	6446                	ld	s0,80(sp)
    800028f0:	64a6                	ld	s1,72(sp)
    800028f2:	6906                	ld	s2,64(sp)
    800028f4:	79e2                	ld	s3,56(sp)
    800028f6:	7a42                	ld	s4,48(sp)
    800028f8:	7aa2                	ld	s5,40(sp)
    800028fa:	7b02                	ld	s6,32(sp)
    800028fc:	6be2                	ld	s7,24(sp)
    800028fe:	6c42                	ld	s8,16(sp)
    80002900:	6ca2                	ld	s9,8(sp)
    80002902:	6125                	addi	sp,sp,96
    80002904:	8082                	ret

0000000080002906 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002906:	7179                	addi	sp,sp,-48
    80002908:	f406                	sd	ra,40(sp)
    8000290a:	f022                	sd	s0,32(sp)
    8000290c:	ec26                	sd	s1,24(sp)
    8000290e:	e84a                	sd	s2,16(sp)
    80002910:	e44e                	sd	s3,8(sp)
    80002912:	e052                	sd	s4,0(sp)
    80002914:	1800                	addi	s0,sp,48
    80002916:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002918:	47ad                	li	a5,11
    8000291a:	04b7fe63          	bgeu	a5,a1,80002976 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000291e:	ff45849b          	addiw	s1,a1,-12
    80002922:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002926:	0ff00793          	li	a5,255
    8000292a:	0ae7e363          	bltu	a5,a4,800029d0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000292e:	08052583          	lw	a1,128(a0)
    80002932:	c5ad                	beqz	a1,8000299c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002934:	00092503          	lw	a0,0(s2)
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	bda080e7          	jalr	-1062(ra) # 80002512 <bread>
    80002940:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002942:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002946:	02049593          	slli	a1,s1,0x20
    8000294a:	9181                	srli	a1,a1,0x20
    8000294c:	058a                	slli	a1,a1,0x2
    8000294e:	00b784b3          	add	s1,a5,a1
    80002952:	0004a983          	lw	s3,0(s1)
    80002956:	04098d63          	beqz	s3,800029b0 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000295a:	8552                	mv	a0,s4
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	ce6080e7          	jalr	-794(ra) # 80002642 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002964:	854e                	mv	a0,s3
    80002966:	70a2                	ld	ra,40(sp)
    80002968:	7402                	ld	s0,32(sp)
    8000296a:	64e2                	ld	s1,24(sp)
    8000296c:	6942                	ld	s2,16(sp)
    8000296e:	69a2                	ld	s3,8(sp)
    80002970:	6a02                	ld	s4,0(sp)
    80002972:	6145                	addi	sp,sp,48
    80002974:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002976:	02059493          	slli	s1,a1,0x20
    8000297a:	9081                	srli	s1,s1,0x20
    8000297c:	048a                	slli	s1,s1,0x2
    8000297e:	94aa                	add	s1,s1,a0
    80002980:	0504a983          	lw	s3,80(s1)
    80002984:	fe0990e3          	bnez	s3,80002964 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002988:	4108                	lw	a0,0(a0)
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	e4a080e7          	jalr	-438(ra) # 800027d4 <balloc>
    80002992:	0005099b          	sext.w	s3,a0
    80002996:	0534a823          	sw	s3,80(s1)
    8000299a:	b7e9                	j	80002964 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000299c:	4108                	lw	a0,0(a0)
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	e36080e7          	jalr	-458(ra) # 800027d4 <balloc>
    800029a6:	0005059b          	sext.w	a1,a0
    800029aa:	08b92023          	sw	a1,128(s2)
    800029ae:	b759                	j	80002934 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029b0:	00092503          	lw	a0,0(s2)
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e20080e7          	jalr	-480(ra) # 800027d4 <balloc>
    800029bc:	0005099b          	sext.w	s3,a0
    800029c0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029c4:	8552                	mv	a0,s4
    800029c6:	00001097          	auipc	ra,0x1
    800029ca:	ef8080e7          	jalr	-264(ra) # 800038be <log_write>
    800029ce:	b771                	j	8000295a <bmap+0x54>
  panic("bmap: out of range");
    800029d0:	00006517          	auipc	a0,0x6
    800029d4:	b2050513          	addi	a0,a0,-1248 # 800084f0 <syscalls+0x128>
    800029d8:	00003097          	auipc	ra,0x3
    800029dc:	750080e7          	jalr	1872(ra) # 80006128 <panic>

00000000800029e0 <iget>:
{
    800029e0:	7179                	addi	sp,sp,-48
    800029e2:	f406                	sd	ra,40(sp)
    800029e4:	f022                	sd	s0,32(sp)
    800029e6:	ec26                	sd	s1,24(sp)
    800029e8:	e84a                	sd	s2,16(sp)
    800029ea:	e44e                	sd	s3,8(sp)
    800029ec:	e052                	sd	s4,0(sp)
    800029ee:	1800                	addi	s0,sp,48
    800029f0:	89aa                	mv	s3,a0
    800029f2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029f4:	0001f517          	auipc	a0,0x1f
    800029f8:	b8450513          	addi	a0,a0,-1148 # 80021578 <itable>
    800029fc:	00004097          	auipc	ra,0x4
    80002a00:	c76080e7          	jalr	-906(ra) # 80006672 <acquire>
  empty = 0;
    80002a04:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a06:	0001f497          	auipc	s1,0x1f
    80002a0a:	b8a48493          	addi	s1,s1,-1142 # 80021590 <itable+0x18>
    80002a0e:	00020697          	auipc	a3,0x20
    80002a12:	61268693          	addi	a3,a3,1554 # 80023020 <log>
    80002a16:	a039                	j	80002a24 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a18:	02090b63          	beqz	s2,80002a4e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1c:	08848493          	addi	s1,s1,136
    80002a20:	02d48a63          	beq	s1,a3,80002a54 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a24:	449c                	lw	a5,8(s1)
    80002a26:	fef059e3          	blez	a5,80002a18 <iget+0x38>
    80002a2a:	4098                	lw	a4,0(s1)
    80002a2c:	ff3716e3          	bne	a4,s3,80002a18 <iget+0x38>
    80002a30:	40d8                	lw	a4,4(s1)
    80002a32:	ff4713e3          	bne	a4,s4,80002a18 <iget+0x38>
      ip->ref++;
    80002a36:	2785                	addiw	a5,a5,1
    80002a38:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a3a:	0001f517          	auipc	a0,0x1f
    80002a3e:	b3e50513          	addi	a0,a0,-1218 # 80021578 <itable>
    80002a42:	00004097          	auipc	ra,0x4
    80002a46:	ce4080e7          	jalr	-796(ra) # 80006726 <release>
      return ip;
    80002a4a:	8926                	mv	s2,s1
    80002a4c:	a03d                	j	80002a7a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a4e:	f7f9                	bnez	a5,80002a1c <iget+0x3c>
    80002a50:	8926                	mv	s2,s1
    80002a52:	b7e9                	j	80002a1c <iget+0x3c>
  if(empty == 0)
    80002a54:	02090c63          	beqz	s2,80002a8c <iget+0xac>
  ip->dev = dev;
    80002a58:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a5c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a60:	4785                	li	a5,1
    80002a62:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a66:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a6a:	0001f517          	auipc	a0,0x1f
    80002a6e:	b0e50513          	addi	a0,a0,-1266 # 80021578 <itable>
    80002a72:	00004097          	auipc	ra,0x4
    80002a76:	cb4080e7          	jalr	-844(ra) # 80006726 <release>
}
    80002a7a:	854a                	mv	a0,s2
    80002a7c:	70a2                	ld	ra,40(sp)
    80002a7e:	7402                	ld	s0,32(sp)
    80002a80:	64e2                	ld	s1,24(sp)
    80002a82:	6942                	ld	s2,16(sp)
    80002a84:	69a2                	ld	s3,8(sp)
    80002a86:	6a02                	ld	s4,0(sp)
    80002a88:	6145                	addi	sp,sp,48
    80002a8a:	8082                	ret
    panic("iget: no inodes");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	a7c50513          	addi	a0,a0,-1412 # 80008508 <syscalls+0x140>
    80002a94:	00003097          	auipc	ra,0x3
    80002a98:	694080e7          	jalr	1684(ra) # 80006128 <panic>

0000000080002a9c <fsinit>:
fsinit(int dev) {
    80002a9c:	7179                	addi	sp,sp,-48
    80002a9e:	f406                	sd	ra,40(sp)
    80002aa0:	f022                	sd	s0,32(sp)
    80002aa2:	ec26                	sd	s1,24(sp)
    80002aa4:	e84a                	sd	s2,16(sp)
    80002aa6:	e44e                	sd	s3,8(sp)
    80002aa8:	1800                	addi	s0,sp,48
    80002aaa:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aac:	4585                	li	a1,1
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	a64080e7          	jalr	-1436(ra) # 80002512 <bread>
    80002ab6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ab8:	0001f997          	auipc	s3,0x1f
    80002abc:	aa098993          	addi	s3,s3,-1376 # 80021558 <sb>
    80002ac0:	02000613          	li	a2,32
    80002ac4:	05850593          	addi	a1,a0,88
    80002ac8:	854e                	mv	a0,s3
    80002aca:	ffffd097          	auipc	ra,0xffffd
    80002ace:	70e080e7          	jalr	1806(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	b6e080e7          	jalr	-1170(ra) # 80002642 <brelse>
  if(sb.magic != FSMAGIC)
    80002adc:	0009a703          	lw	a4,0(s3)
    80002ae0:	102037b7          	lui	a5,0x10203
    80002ae4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ae8:	02f71263          	bne	a4,a5,80002b0c <fsinit+0x70>
  initlog(dev, &sb);
    80002aec:	0001f597          	auipc	a1,0x1f
    80002af0:	a6c58593          	addi	a1,a1,-1428 # 80021558 <sb>
    80002af4:	854a                	mv	a0,s2
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	b4c080e7          	jalr	-1204(ra) # 80003642 <initlog>
}
    80002afe:	70a2                	ld	ra,40(sp)
    80002b00:	7402                	ld	s0,32(sp)
    80002b02:	64e2                	ld	s1,24(sp)
    80002b04:	6942                	ld	s2,16(sp)
    80002b06:	69a2                	ld	s3,8(sp)
    80002b08:	6145                	addi	sp,sp,48
    80002b0a:	8082                	ret
    panic("invalid file system");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	a0c50513          	addi	a0,a0,-1524 # 80008518 <syscalls+0x150>
    80002b14:	00003097          	auipc	ra,0x3
    80002b18:	614080e7          	jalr	1556(ra) # 80006128 <panic>

0000000080002b1c <iinit>:
{
    80002b1c:	7179                	addi	sp,sp,-48
    80002b1e:	f406                	sd	ra,40(sp)
    80002b20:	f022                	sd	s0,32(sp)
    80002b22:	ec26                	sd	s1,24(sp)
    80002b24:	e84a                	sd	s2,16(sp)
    80002b26:	e44e                	sd	s3,8(sp)
    80002b28:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b2a:	00006597          	auipc	a1,0x6
    80002b2e:	a0658593          	addi	a1,a1,-1530 # 80008530 <syscalls+0x168>
    80002b32:	0001f517          	auipc	a0,0x1f
    80002b36:	a4650513          	addi	a0,a0,-1466 # 80021578 <itable>
    80002b3a:	00004097          	auipc	ra,0x4
    80002b3e:	aa8080e7          	jalr	-1368(ra) # 800065e2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b42:	0001f497          	auipc	s1,0x1f
    80002b46:	a5e48493          	addi	s1,s1,-1442 # 800215a0 <itable+0x28>
    80002b4a:	00020997          	auipc	s3,0x20
    80002b4e:	4e698993          	addi	s3,s3,1254 # 80023030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b52:	00006917          	auipc	s2,0x6
    80002b56:	9e690913          	addi	s2,s2,-1562 # 80008538 <syscalls+0x170>
    80002b5a:	85ca                	mv	a1,s2
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	00001097          	auipc	ra,0x1
    80002b62:	e46080e7          	jalr	-442(ra) # 800039a4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b66:	08848493          	addi	s1,s1,136
    80002b6a:	ff3498e3          	bne	s1,s3,80002b5a <iinit+0x3e>
}
    80002b6e:	70a2                	ld	ra,40(sp)
    80002b70:	7402                	ld	s0,32(sp)
    80002b72:	64e2                	ld	s1,24(sp)
    80002b74:	6942                	ld	s2,16(sp)
    80002b76:	69a2                	ld	s3,8(sp)
    80002b78:	6145                	addi	sp,sp,48
    80002b7a:	8082                	ret

0000000080002b7c <ialloc>:
{
    80002b7c:	715d                	addi	sp,sp,-80
    80002b7e:	e486                	sd	ra,72(sp)
    80002b80:	e0a2                	sd	s0,64(sp)
    80002b82:	fc26                	sd	s1,56(sp)
    80002b84:	f84a                	sd	s2,48(sp)
    80002b86:	f44e                	sd	s3,40(sp)
    80002b88:	f052                	sd	s4,32(sp)
    80002b8a:	ec56                	sd	s5,24(sp)
    80002b8c:	e85a                	sd	s6,16(sp)
    80002b8e:	e45e                	sd	s7,8(sp)
    80002b90:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b92:	0001f717          	auipc	a4,0x1f
    80002b96:	9d272703          	lw	a4,-1582(a4) # 80021564 <sb+0xc>
    80002b9a:	4785                	li	a5,1
    80002b9c:	04e7fa63          	bgeu	a5,a4,80002bf0 <ialloc+0x74>
    80002ba0:	8aaa                	mv	s5,a0
    80002ba2:	8bae                	mv	s7,a1
    80002ba4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ba6:	0001fa17          	auipc	s4,0x1f
    80002baa:	9b2a0a13          	addi	s4,s4,-1614 # 80021558 <sb>
    80002bae:	00048b1b          	sext.w	s6,s1
    80002bb2:	0044d593          	srli	a1,s1,0x4
    80002bb6:	018a2783          	lw	a5,24(s4)
    80002bba:	9dbd                	addw	a1,a1,a5
    80002bbc:	8556                	mv	a0,s5
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	954080e7          	jalr	-1708(ra) # 80002512 <bread>
    80002bc6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bc8:	05850993          	addi	s3,a0,88
    80002bcc:	00f4f793          	andi	a5,s1,15
    80002bd0:	079a                	slli	a5,a5,0x6
    80002bd2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bd4:	00099783          	lh	a5,0(s3)
    80002bd8:	c785                	beqz	a5,80002c00 <ialloc+0x84>
    brelse(bp);
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	a68080e7          	jalr	-1432(ra) # 80002642 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be2:	0485                	addi	s1,s1,1
    80002be4:	00ca2703          	lw	a4,12(s4)
    80002be8:	0004879b          	sext.w	a5,s1
    80002bec:	fce7e1e3          	bltu	a5,a4,80002bae <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	95050513          	addi	a0,a0,-1712 # 80008540 <syscalls+0x178>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	530080e7          	jalr	1328(ra) # 80006128 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c00:	04000613          	li	a2,64
    80002c04:	4581                	li	a1,0
    80002c06:	854e                	mv	a0,s3
    80002c08:	ffffd097          	auipc	ra,0xffffd
    80002c0c:	570080e7          	jalr	1392(ra) # 80000178 <memset>
      dip->type = type;
    80002c10:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c14:	854a                	mv	a0,s2
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	ca8080e7          	jalr	-856(ra) # 800038be <log_write>
      brelse(bp);
    80002c1e:	854a                	mv	a0,s2
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	a22080e7          	jalr	-1502(ra) # 80002642 <brelse>
      return iget(dev, inum);
    80002c28:	85da                	mv	a1,s6
    80002c2a:	8556                	mv	a0,s5
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	db4080e7          	jalr	-588(ra) # 800029e0 <iget>
}
    80002c34:	60a6                	ld	ra,72(sp)
    80002c36:	6406                	ld	s0,64(sp)
    80002c38:	74e2                	ld	s1,56(sp)
    80002c3a:	7942                	ld	s2,48(sp)
    80002c3c:	79a2                	ld	s3,40(sp)
    80002c3e:	7a02                	ld	s4,32(sp)
    80002c40:	6ae2                	ld	s5,24(sp)
    80002c42:	6b42                	ld	s6,16(sp)
    80002c44:	6ba2                	ld	s7,8(sp)
    80002c46:	6161                	addi	sp,sp,80
    80002c48:	8082                	ret

0000000080002c4a <iupdate>:
{
    80002c4a:	1101                	addi	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	e426                	sd	s1,8(sp)
    80002c52:	e04a                	sd	s2,0(sp)
    80002c54:	1000                	addi	s0,sp,32
    80002c56:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c58:	415c                	lw	a5,4(a0)
    80002c5a:	0047d79b          	srliw	a5,a5,0x4
    80002c5e:	0001f597          	auipc	a1,0x1f
    80002c62:	9125a583          	lw	a1,-1774(a1) # 80021570 <sb+0x18>
    80002c66:	9dbd                	addw	a1,a1,a5
    80002c68:	4108                	lw	a0,0(a0)
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	8a8080e7          	jalr	-1880(ra) # 80002512 <bread>
    80002c72:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c74:	05850793          	addi	a5,a0,88
    80002c78:	40c8                	lw	a0,4(s1)
    80002c7a:	893d                	andi	a0,a0,15
    80002c7c:	051a                	slli	a0,a0,0x6
    80002c7e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c80:	04449703          	lh	a4,68(s1)
    80002c84:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c88:	04649703          	lh	a4,70(s1)
    80002c8c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c90:	04849703          	lh	a4,72(s1)
    80002c94:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c98:	04a49703          	lh	a4,74(s1)
    80002c9c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ca0:	44f8                	lw	a4,76(s1)
    80002ca2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ca4:	03400613          	li	a2,52
    80002ca8:	05048593          	addi	a1,s1,80
    80002cac:	0531                	addi	a0,a0,12
    80002cae:	ffffd097          	auipc	ra,0xffffd
    80002cb2:	52a080e7          	jalr	1322(ra) # 800001d8 <memmove>
  log_write(bp);
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	c06080e7          	jalr	-1018(ra) # 800038be <log_write>
  brelse(bp);
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	980080e7          	jalr	-1664(ra) # 80002642 <brelse>
}
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6902                	ld	s2,0(sp)
    80002cd2:	6105                	addi	sp,sp,32
    80002cd4:	8082                	ret

0000000080002cd6 <idup>:
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ce2:	0001f517          	auipc	a0,0x1f
    80002ce6:	89650513          	addi	a0,a0,-1898 # 80021578 <itable>
    80002cea:	00004097          	auipc	ra,0x4
    80002cee:	988080e7          	jalr	-1656(ra) # 80006672 <acquire>
  ip->ref++;
    80002cf2:	449c                	lw	a5,8(s1)
    80002cf4:	2785                	addiw	a5,a5,1
    80002cf6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cf8:	0001f517          	auipc	a0,0x1f
    80002cfc:	88050513          	addi	a0,a0,-1920 # 80021578 <itable>
    80002d00:	00004097          	auipc	ra,0x4
    80002d04:	a26080e7          	jalr	-1498(ra) # 80006726 <release>
}
    80002d08:	8526                	mv	a0,s1
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	64a2                	ld	s1,8(sp)
    80002d10:	6105                	addi	sp,sp,32
    80002d12:	8082                	ret

0000000080002d14 <ilock>:
{
    80002d14:	1101                	addi	sp,sp,-32
    80002d16:	ec06                	sd	ra,24(sp)
    80002d18:	e822                	sd	s0,16(sp)
    80002d1a:	e426                	sd	s1,8(sp)
    80002d1c:	e04a                	sd	s2,0(sp)
    80002d1e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d20:	c115                	beqz	a0,80002d44 <ilock+0x30>
    80002d22:	84aa                	mv	s1,a0
    80002d24:	451c                	lw	a5,8(a0)
    80002d26:	00f05f63          	blez	a5,80002d44 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d2a:	0541                	addi	a0,a0,16
    80002d2c:	00001097          	auipc	ra,0x1
    80002d30:	cb2080e7          	jalr	-846(ra) # 800039de <acquiresleep>
  if(ip->valid == 0){
    80002d34:	40bc                	lw	a5,64(s1)
    80002d36:	cf99                	beqz	a5,80002d54 <ilock+0x40>
}
    80002d38:	60e2                	ld	ra,24(sp)
    80002d3a:	6442                	ld	s0,16(sp)
    80002d3c:	64a2                	ld	s1,8(sp)
    80002d3e:	6902                	ld	s2,0(sp)
    80002d40:	6105                	addi	sp,sp,32
    80002d42:	8082                	ret
    panic("ilock");
    80002d44:	00006517          	auipc	a0,0x6
    80002d48:	81450513          	addi	a0,a0,-2028 # 80008558 <syscalls+0x190>
    80002d4c:	00003097          	auipc	ra,0x3
    80002d50:	3dc080e7          	jalr	988(ra) # 80006128 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d54:	40dc                	lw	a5,4(s1)
    80002d56:	0047d79b          	srliw	a5,a5,0x4
    80002d5a:	0001f597          	auipc	a1,0x1f
    80002d5e:	8165a583          	lw	a1,-2026(a1) # 80021570 <sb+0x18>
    80002d62:	9dbd                	addw	a1,a1,a5
    80002d64:	4088                	lw	a0,0(s1)
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	7ac080e7          	jalr	1964(ra) # 80002512 <bread>
    80002d6e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d70:	05850593          	addi	a1,a0,88
    80002d74:	40dc                	lw	a5,4(s1)
    80002d76:	8bbd                	andi	a5,a5,15
    80002d78:	079a                	slli	a5,a5,0x6
    80002d7a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d7c:	00059783          	lh	a5,0(a1)
    80002d80:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d84:	00259783          	lh	a5,2(a1)
    80002d88:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d8c:	00459783          	lh	a5,4(a1)
    80002d90:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d94:	00659783          	lh	a5,6(a1)
    80002d98:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d9c:	459c                	lw	a5,8(a1)
    80002d9e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002da0:	03400613          	li	a2,52
    80002da4:	05b1                	addi	a1,a1,12
    80002da6:	05048513          	addi	a0,s1,80
    80002daa:	ffffd097          	auipc	ra,0xffffd
    80002dae:	42e080e7          	jalr	1070(ra) # 800001d8 <memmove>
    brelse(bp);
    80002db2:	854a                	mv	a0,s2
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	88e080e7          	jalr	-1906(ra) # 80002642 <brelse>
    ip->valid = 1;
    80002dbc:	4785                	li	a5,1
    80002dbe:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dc0:	04449783          	lh	a5,68(s1)
    80002dc4:	fbb5                	bnez	a5,80002d38 <ilock+0x24>
      panic("ilock: no type");
    80002dc6:	00005517          	auipc	a0,0x5
    80002dca:	79a50513          	addi	a0,a0,1946 # 80008560 <syscalls+0x198>
    80002dce:	00003097          	auipc	ra,0x3
    80002dd2:	35a080e7          	jalr	858(ra) # 80006128 <panic>

0000000080002dd6 <iunlock>:
{
    80002dd6:	1101                	addi	sp,sp,-32
    80002dd8:	ec06                	sd	ra,24(sp)
    80002dda:	e822                	sd	s0,16(sp)
    80002ddc:	e426                	sd	s1,8(sp)
    80002dde:	e04a                	sd	s2,0(sp)
    80002de0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002de2:	c905                	beqz	a0,80002e12 <iunlock+0x3c>
    80002de4:	84aa                	mv	s1,a0
    80002de6:	01050913          	addi	s2,a0,16
    80002dea:	854a                	mv	a0,s2
    80002dec:	00001097          	auipc	ra,0x1
    80002df0:	c8c080e7          	jalr	-884(ra) # 80003a78 <holdingsleep>
    80002df4:	cd19                	beqz	a0,80002e12 <iunlock+0x3c>
    80002df6:	449c                	lw	a5,8(s1)
    80002df8:	00f05d63          	blez	a5,80002e12 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dfc:	854a                	mv	a0,s2
    80002dfe:	00001097          	auipc	ra,0x1
    80002e02:	c36080e7          	jalr	-970(ra) # 80003a34 <releasesleep>
}
    80002e06:	60e2                	ld	ra,24(sp)
    80002e08:	6442                	ld	s0,16(sp)
    80002e0a:	64a2                	ld	s1,8(sp)
    80002e0c:	6902                	ld	s2,0(sp)
    80002e0e:	6105                	addi	sp,sp,32
    80002e10:	8082                	ret
    panic("iunlock");
    80002e12:	00005517          	auipc	a0,0x5
    80002e16:	75e50513          	addi	a0,a0,1886 # 80008570 <syscalls+0x1a8>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	30e080e7          	jalr	782(ra) # 80006128 <panic>

0000000080002e22 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e22:	7179                	addi	sp,sp,-48
    80002e24:	f406                	sd	ra,40(sp)
    80002e26:	f022                	sd	s0,32(sp)
    80002e28:	ec26                	sd	s1,24(sp)
    80002e2a:	e84a                	sd	s2,16(sp)
    80002e2c:	e44e                	sd	s3,8(sp)
    80002e2e:	e052                	sd	s4,0(sp)
    80002e30:	1800                	addi	s0,sp,48
    80002e32:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e34:	05050493          	addi	s1,a0,80
    80002e38:	08050913          	addi	s2,a0,128
    80002e3c:	a021                	j	80002e44 <itrunc+0x22>
    80002e3e:	0491                	addi	s1,s1,4
    80002e40:	01248d63          	beq	s1,s2,80002e5a <itrunc+0x38>
    if(ip->addrs[i]){
    80002e44:	408c                	lw	a1,0(s1)
    80002e46:	dde5                	beqz	a1,80002e3e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e48:	0009a503          	lw	a0,0(s3)
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	90c080e7          	jalr	-1780(ra) # 80002758 <bfree>
      ip->addrs[i] = 0;
    80002e54:	0004a023          	sw	zero,0(s1)
    80002e58:	b7dd                	j	80002e3e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e5a:	0809a583          	lw	a1,128(s3)
    80002e5e:	e185                	bnez	a1,80002e7e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e60:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e64:	854e                	mv	a0,s3
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	de4080e7          	jalr	-540(ra) # 80002c4a <iupdate>
}
    80002e6e:	70a2                	ld	ra,40(sp)
    80002e70:	7402                	ld	s0,32(sp)
    80002e72:	64e2                	ld	s1,24(sp)
    80002e74:	6942                	ld	s2,16(sp)
    80002e76:	69a2                	ld	s3,8(sp)
    80002e78:	6a02                	ld	s4,0(sp)
    80002e7a:	6145                	addi	sp,sp,48
    80002e7c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e7e:	0009a503          	lw	a0,0(s3)
    80002e82:	fffff097          	auipc	ra,0xfffff
    80002e86:	690080e7          	jalr	1680(ra) # 80002512 <bread>
    80002e8a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e8c:	05850493          	addi	s1,a0,88
    80002e90:	45850913          	addi	s2,a0,1112
    80002e94:	a811                	j	80002ea8 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	8be080e7          	jalr	-1858(ra) # 80002758 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ea2:	0491                	addi	s1,s1,4
    80002ea4:	01248563          	beq	s1,s2,80002eae <itrunc+0x8c>
      if(a[j])
    80002ea8:	408c                	lw	a1,0(s1)
    80002eaa:	dde5                	beqz	a1,80002ea2 <itrunc+0x80>
    80002eac:	b7ed                	j	80002e96 <itrunc+0x74>
    brelse(bp);
    80002eae:	8552                	mv	a0,s4
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	792080e7          	jalr	1938(ra) # 80002642 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eb8:	0809a583          	lw	a1,128(s3)
    80002ebc:	0009a503          	lw	a0,0(s3)
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	898080e7          	jalr	-1896(ra) # 80002758 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ec8:	0809a023          	sw	zero,128(s3)
    80002ecc:	bf51                	j	80002e60 <itrunc+0x3e>

0000000080002ece <iput>:
{
    80002ece:	1101                	addi	sp,sp,-32
    80002ed0:	ec06                	sd	ra,24(sp)
    80002ed2:	e822                	sd	s0,16(sp)
    80002ed4:	e426                	sd	s1,8(sp)
    80002ed6:	e04a                	sd	s2,0(sp)
    80002ed8:	1000                	addi	s0,sp,32
    80002eda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002edc:	0001e517          	auipc	a0,0x1e
    80002ee0:	69c50513          	addi	a0,a0,1692 # 80021578 <itable>
    80002ee4:	00003097          	auipc	ra,0x3
    80002ee8:	78e080e7          	jalr	1934(ra) # 80006672 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eec:	4498                	lw	a4,8(s1)
    80002eee:	4785                	li	a5,1
    80002ef0:	02f70363          	beq	a4,a5,80002f16 <iput+0x48>
  ip->ref--;
    80002ef4:	449c                	lw	a5,8(s1)
    80002ef6:	37fd                	addiw	a5,a5,-1
    80002ef8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002efa:	0001e517          	auipc	a0,0x1e
    80002efe:	67e50513          	addi	a0,a0,1662 # 80021578 <itable>
    80002f02:	00004097          	auipc	ra,0x4
    80002f06:	824080e7          	jalr	-2012(ra) # 80006726 <release>
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6902                	ld	s2,0(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f16:	40bc                	lw	a5,64(s1)
    80002f18:	dff1                	beqz	a5,80002ef4 <iput+0x26>
    80002f1a:	04a49783          	lh	a5,74(s1)
    80002f1e:	fbf9                	bnez	a5,80002ef4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f20:	01048913          	addi	s2,s1,16
    80002f24:	854a                	mv	a0,s2
    80002f26:	00001097          	auipc	ra,0x1
    80002f2a:	ab8080e7          	jalr	-1352(ra) # 800039de <acquiresleep>
    release(&itable.lock);
    80002f2e:	0001e517          	auipc	a0,0x1e
    80002f32:	64a50513          	addi	a0,a0,1610 # 80021578 <itable>
    80002f36:	00003097          	auipc	ra,0x3
    80002f3a:	7f0080e7          	jalr	2032(ra) # 80006726 <release>
    itrunc(ip);
    80002f3e:	8526                	mv	a0,s1
    80002f40:	00000097          	auipc	ra,0x0
    80002f44:	ee2080e7          	jalr	-286(ra) # 80002e22 <itrunc>
    ip->type = 0;
    80002f48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	00000097          	auipc	ra,0x0
    80002f52:	cfc080e7          	jalr	-772(ra) # 80002c4a <iupdate>
    ip->valid = 0;
    80002f56:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	00001097          	auipc	ra,0x1
    80002f60:	ad8080e7          	jalr	-1320(ra) # 80003a34 <releasesleep>
    acquire(&itable.lock);
    80002f64:	0001e517          	auipc	a0,0x1e
    80002f68:	61450513          	addi	a0,a0,1556 # 80021578 <itable>
    80002f6c:	00003097          	auipc	ra,0x3
    80002f70:	706080e7          	jalr	1798(ra) # 80006672 <acquire>
    80002f74:	b741                	j	80002ef4 <iput+0x26>

0000000080002f76 <iunlockput>:
{
    80002f76:	1101                	addi	sp,sp,-32
    80002f78:	ec06                	sd	ra,24(sp)
    80002f7a:	e822                	sd	s0,16(sp)
    80002f7c:	e426                	sd	s1,8(sp)
    80002f7e:	1000                	addi	s0,sp,32
    80002f80:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	e54080e7          	jalr	-428(ra) # 80002dd6 <iunlock>
  iput(ip);
    80002f8a:	8526                	mv	a0,s1
    80002f8c:	00000097          	auipc	ra,0x0
    80002f90:	f42080e7          	jalr	-190(ra) # 80002ece <iput>
}
    80002f94:	60e2                	ld	ra,24(sp)
    80002f96:	6442                	ld	s0,16(sp)
    80002f98:	64a2                	ld	s1,8(sp)
    80002f9a:	6105                	addi	sp,sp,32
    80002f9c:	8082                	ret

0000000080002f9e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f9e:	1141                	addi	sp,sp,-16
    80002fa0:	e422                	sd	s0,8(sp)
    80002fa2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fa4:	411c                	lw	a5,0(a0)
    80002fa6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fa8:	415c                	lw	a5,4(a0)
    80002faa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fac:	04451783          	lh	a5,68(a0)
    80002fb0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fb4:	04a51783          	lh	a5,74(a0)
    80002fb8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fbc:	04c56783          	lwu	a5,76(a0)
    80002fc0:	e99c                	sd	a5,16(a1)
}
    80002fc2:	6422                	ld	s0,8(sp)
    80002fc4:	0141                	addi	sp,sp,16
    80002fc6:	8082                	ret

0000000080002fc8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc8:	457c                	lw	a5,76(a0)
    80002fca:	0ed7e963          	bltu	a5,a3,800030bc <readi+0xf4>
{
    80002fce:	7159                	addi	sp,sp,-112
    80002fd0:	f486                	sd	ra,104(sp)
    80002fd2:	f0a2                	sd	s0,96(sp)
    80002fd4:	eca6                	sd	s1,88(sp)
    80002fd6:	e8ca                	sd	s2,80(sp)
    80002fd8:	e4ce                	sd	s3,72(sp)
    80002fda:	e0d2                	sd	s4,64(sp)
    80002fdc:	fc56                	sd	s5,56(sp)
    80002fde:	f85a                	sd	s6,48(sp)
    80002fe0:	f45e                	sd	s7,40(sp)
    80002fe2:	f062                	sd	s8,32(sp)
    80002fe4:	ec66                	sd	s9,24(sp)
    80002fe6:	e86a                	sd	s10,16(sp)
    80002fe8:	e46e                	sd	s11,8(sp)
    80002fea:	1880                	addi	s0,sp,112
    80002fec:	8baa                	mv	s7,a0
    80002fee:	8c2e                	mv	s8,a1
    80002ff0:	8ab2                	mv	s5,a2
    80002ff2:	84b6                	mv	s1,a3
    80002ff4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ff6:	9f35                	addw	a4,a4,a3
    return 0;
    80002ff8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ffa:	0ad76063          	bltu	a4,a3,8000309a <readi+0xd2>
  if(off + n > ip->size)
    80002ffe:	00e7f463          	bgeu	a5,a4,80003006 <readi+0x3e>
    n = ip->size - off;
    80003002:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003006:	0a0b0963          	beqz	s6,800030b8 <readi+0xf0>
    8000300a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000300c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003010:	5cfd                	li	s9,-1
    80003012:	a82d                	j	8000304c <readi+0x84>
    80003014:	020a1d93          	slli	s11,s4,0x20
    80003018:	020ddd93          	srli	s11,s11,0x20
    8000301c:	05890613          	addi	a2,s2,88
    80003020:	86ee                	mv	a3,s11
    80003022:	963a                	add	a2,a2,a4
    80003024:	85d6                	mv	a1,s5
    80003026:	8562                	mv	a0,s8
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	9c4080e7          	jalr	-1596(ra) # 800019ec <either_copyout>
    80003030:	05950d63          	beq	a0,s9,8000308a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003034:	854a                	mv	a0,s2
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	60c080e7          	jalr	1548(ra) # 80002642 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000303e:	013a09bb          	addw	s3,s4,s3
    80003042:	009a04bb          	addw	s1,s4,s1
    80003046:	9aee                	add	s5,s5,s11
    80003048:	0569f763          	bgeu	s3,s6,80003096 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000304c:	000ba903          	lw	s2,0(s7)
    80003050:	00a4d59b          	srliw	a1,s1,0xa
    80003054:	855e                	mv	a0,s7
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	8b0080e7          	jalr	-1872(ra) # 80002906 <bmap>
    8000305e:	0005059b          	sext.w	a1,a0
    80003062:	854a                	mv	a0,s2
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	4ae080e7          	jalr	1198(ra) # 80002512 <bread>
    8000306c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306e:	3ff4f713          	andi	a4,s1,1023
    80003072:	40ed07bb          	subw	a5,s10,a4
    80003076:	413b06bb          	subw	a3,s6,s3
    8000307a:	8a3e                	mv	s4,a5
    8000307c:	2781                	sext.w	a5,a5
    8000307e:	0006861b          	sext.w	a2,a3
    80003082:	f8f679e3          	bgeu	a2,a5,80003014 <readi+0x4c>
    80003086:	8a36                	mv	s4,a3
    80003088:	b771                	j	80003014 <readi+0x4c>
      brelse(bp);
    8000308a:	854a                	mv	a0,s2
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	5b6080e7          	jalr	1462(ra) # 80002642 <brelse>
      tot = -1;
    80003094:	59fd                	li	s3,-1
  }
  return tot;
    80003096:	0009851b          	sext.w	a0,s3
}
    8000309a:	70a6                	ld	ra,104(sp)
    8000309c:	7406                	ld	s0,96(sp)
    8000309e:	64e6                	ld	s1,88(sp)
    800030a0:	6946                	ld	s2,80(sp)
    800030a2:	69a6                	ld	s3,72(sp)
    800030a4:	6a06                	ld	s4,64(sp)
    800030a6:	7ae2                	ld	s5,56(sp)
    800030a8:	7b42                	ld	s6,48(sp)
    800030aa:	7ba2                	ld	s7,40(sp)
    800030ac:	7c02                	ld	s8,32(sp)
    800030ae:	6ce2                	ld	s9,24(sp)
    800030b0:	6d42                	ld	s10,16(sp)
    800030b2:	6da2                	ld	s11,8(sp)
    800030b4:	6165                	addi	sp,sp,112
    800030b6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b8:	89da                	mv	s3,s6
    800030ba:	bff1                	j	80003096 <readi+0xce>
    return 0;
    800030bc:	4501                	li	a0,0
}
    800030be:	8082                	ret

00000000800030c0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030c0:	457c                	lw	a5,76(a0)
    800030c2:	10d7e863          	bltu	a5,a3,800031d2 <writei+0x112>
{
    800030c6:	7159                	addi	sp,sp,-112
    800030c8:	f486                	sd	ra,104(sp)
    800030ca:	f0a2                	sd	s0,96(sp)
    800030cc:	eca6                	sd	s1,88(sp)
    800030ce:	e8ca                	sd	s2,80(sp)
    800030d0:	e4ce                	sd	s3,72(sp)
    800030d2:	e0d2                	sd	s4,64(sp)
    800030d4:	fc56                	sd	s5,56(sp)
    800030d6:	f85a                	sd	s6,48(sp)
    800030d8:	f45e                	sd	s7,40(sp)
    800030da:	f062                	sd	s8,32(sp)
    800030dc:	ec66                	sd	s9,24(sp)
    800030de:	e86a                	sd	s10,16(sp)
    800030e0:	e46e                	sd	s11,8(sp)
    800030e2:	1880                	addi	s0,sp,112
    800030e4:	8b2a                	mv	s6,a0
    800030e6:	8c2e                	mv	s8,a1
    800030e8:	8ab2                	mv	s5,a2
    800030ea:	8936                	mv	s2,a3
    800030ec:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030ee:	00e687bb          	addw	a5,a3,a4
    800030f2:	0ed7e263          	bltu	a5,a3,800031d6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030f6:	00043737          	lui	a4,0x43
    800030fa:	0ef76063          	bltu	a4,a5,800031da <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030fe:	0c0b8863          	beqz	s7,800031ce <writei+0x10e>
    80003102:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003104:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003108:	5cfd                	li	s9,-1
    8000310a:	a091                	j	8000314e <writei+0x8e>
    8000310c:	02099d93          	slli	s11,s3,0x20
    80003110:	020ddd93          	srli	s11,s11,0x20
    80003114:	05848513          	addi	a0,s1,88
    80003118:	86ee                	mv	a3,s11
    8000311a:	8656                	mv	a2,s5
    8000311c:	85e2                	mv	a1,s8
    8000311e:	953a                	add	a0,a0,a4
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	922080e7          	jalr	-1758(ra) # 80001a42 <either_copyin>
    80003128:	07950263          	beq	a0,s9,8000318c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000312c:	8526                	mv	a0,s1
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	790080e7          	jalr	1936(ra) # 800038be <log_write>
    brelse(bp);
    80003136:	8526                	mv	a0,s1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	50a080e7          	jalr	1290(ra) # 80002642 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003140:	01498a3b          	addw	s4,s3,s4
    80003144:	0129893b          	addw	s2,s3,s2
    80003148:	9aee                	add	s5,s5,s11
    8000314a:	057a7663          	bgeu	s4,s7,80003196 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000314e:	000b2483          	lw	s1,0(s6)
    80003152:	00a9559b          	srliw	a1,s2,0xa
    80003156:	855a                	mv	a0,s6
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	7ae080e7          	jalr	1966(ra) # 80002906 <bmap>
    80003160:	0005059b          	sext.w	a1,a0
    80003164:	8526                	mv	a0,s1
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	3ac080e7          	jalr	940(ra) # 80002512 <bread>
    8000316e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003170:	3ff97713          	andi	a4,s2,1023
    80003174:	40ed07bb          	subw	a5,s10,a4
    80003178:	414b86bb          	subw	a3,s7,s4
    8000317c:	89be                	mv	s3,a5
    8000317e:	2781                	sext.w	a5,a5
    80003180:	0006861b          	sext.w	a2,a3
    80003184:	f8f674e3          	bgeu	a2,a5,8000310c <writei+0x4c>
    80003188:	89b6                	mv	s3,a3
    8000318a:	b749                	j	8000310c <writei+0x4c>
      brelse(bp);
    8000318c:	8526                	mv	a0,s1
    8000318e:	fffff097          	auipc	ra,0xfffff
    80003192:	4b4080e7          	jalr	1204(ra) # 80002642 <brelse>
  }

  if(off > ip->size)
    80003196:	04cb2783          	lw	a5,76(s6)
    8000319a:	0127f463          	bgeu	a5,s2,800031a2 <writei+0xe2>
    ip->size = off;
    8000319e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031a2:	855a                	mv	a0,s6
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	aa6080e7          	jalr	-1370(ra) # 80002c4a <iupdate>

  return tot;
    800031ac:	000a051b          	sext.w	a0,s4
}
    800031b0:	70a6                	ld	ra,104(sp)
    800031b2:	7406                	ld	s0,96(sp)
    800031b4:	64e6                	ld	s1,88(sp)
    800031b6:	6946                	ld	s2,80(sp)
    800031b8:	69a6                	ld	s3,72(sp)
    800031ba:	6a06                	ld	s4,64(sp)
    800031bc:	7ae2                	ld	s5,56(sp)
    800031be:	7b42                	ld	s6,48(sp)
    800031c0:	7ba2                	ld	s7,40(sp)
    800031c2:	7c02                	ld	s8,32(sp)
    800031c4:	6ce2                	ld	s9,24(sp)
    800031c6:	6d42                	ld	s10,16(sp)
    800031c8:	6da2                	ld	s11,8(sp)
    800031ca:	6165                	addi	sp,sp,112
    800031cc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ce:	8a5e                	mv	s4,s7
    800031d0:	bfc9                	j	800031a2 <writei+0xe2>
    return -1;
    800031d2:	557d                	li	a0,-1
}
    800031d4:	8082                	ret
    return -1;
    800031d6:	557d                	li	a0,-1
    800031d8:	bfe1                	j	800031b0 <writei+0xf0>
    return -1;
    800031da:	557d                	li	a0,-1
    800031dc:	bfd1                	j	800031b0 <writei+0xf0>

00000000800031de <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031de:	1141                	addi	sp,sp,-16
    800031e0:	e406                	sd	ra,8(sp)
    800031e2:	e022                	sd	s0,0(sp)
    800031e4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031e6:	4639                	li	a2,14
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	068080e7          	jalr	104(ra) # 80000250 <strncmp>
}
    800031f0:	60a2                	ld	ra,8(sp)
    800031f2:	6402                	ld	s0,0(sp)
    800031f4:	0141                	addi	sp,sp,16
    800031f6:	8082                	ret

00000000800031f8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f8:	7139                	addi	sp,sp,-64
    800031fa:	fc06                	sd	ra,56(sp)
    800031fc:	f822                	sd	s0,48(sp)
    800031fe:	f426                	sd	s1,40(sp)
    80003200:	f04a                	sd	s2,32(sp)
    80003202:	ec4e                	sd	s3,24(sp)
    80003204:	e852                	sd	s4,16(sp)
    80003206:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003208:	04451703          	lh	a4,68(a0)
    8000320c:	4785                	li	a5,1
    8000320e:	00f71a63          	bne	a4,a5,80003222 <dirlookup+0x2a>
    80003212:	892a                	mv	s2,a0
    80003214:	89ae                	mv	s3,a1
    80003216:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003218:	457c                	lw	a5,76(a0)
    8000321a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000321c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321e:	e79d                	bnez	a5,8000324c <dirlookup+0x54>
    80003220:	a8a5                	j	80003298 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003222:	00005517          	auipc	a0,0x5
    80003226:	35650513          	addi	a0,a0,854 # 80008578 <syscalls+0x1b0>
    8000322a:	00003097          	auipc	ra,0x3
    8000322e:	efe080e7          	jalr	-258(ra) # 80006128 <panic>
      panic("dirlookup read");
    80003232:	00005517          	auipc	a0,0x5
    80003236:	35e50513          	addi	a0,a0,862 # 80008590 <syscalls+0x1c8>
    8000323a:	00003097          	auipc	ra,0x3
    8000323e:	eee080e7          	jalr	-274(ra) # 80006128 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003242:	24c1                	addiw	s1,s1,16
    80003244:	04c92783          	lw	a5,76(s2)
    80003248:	04f4f763          	bgeu	s1,a5,80003296 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324c:	4741                	li	a4,16
    8000324e:	86a6                	mv	a3,s1
    80003250:	fc040613          	addi	a2,s0,-64
    80003254:	4581                	li	a1,0
    80003256:	854a                	mv	a0,s2
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	d70080e7          	jalr	-656(ra) # 80002fc8 <readi>
    80003260:	47c1                	li	a5,16
    80003262:	fcf518e3          	bne	a0,a5,80003232 <dirlookup+0x3a>
    if(de.inum == 0)
    80003266:	fc045783          	lhu	a5,-64(s0)
    8000326a:	dfe1                	beqz	a5,80003242 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000326c:	fc240593          	addi	a1,s0,-62
    80003270:	854e                	mv	a0,s3
    80003272:	00000097          	auipc	ra,0x0
    80003276:	f6c080e7          	jalr	-148(ra) # 800031de <namecmp>
    8000327a:	f561                	bnez	a0,80003242 <dirlookup+0x4a>
      if(poff)
    8000327c:	000a0463          	beqz	s4,80003284 <dirlookup+0x8c>
        *poff = off;
    80003280:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003284:	fc045583          	lhu	a1,-64(s0)
    80003288:	00092503          	lw	a0,0(s2)
    8000328c:	fffff097          	auipc	ra,0xfffff
    80003290:	754080e7          	jalr	1876(ra) # 800029e0 <iget>
    80003294:	a011                	j	80003298 <dirlookup+0xa0>
  return 0;
    80003296:	4501                	li	a0,0
}
    80003298:	70e2                	ld	ra,56(sp)
    8000329a:	7442                	ld	s0,48(sp)
    8000329c:	74a2                	ld	s1,40(sp)
    8000329e:	7902                	ld	s2,32(sp)
    800032a0:	69e2                	ld	s3,24(sp)
    800032a2:	6a42                	ld	s4,16(sp)
    800032a4:	6121                	addi	sp,sp,64
    800032a6:	8082                	ret

00000000800032a8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a8:	711d                	addi	sp,sp,-96
    800032aa:	ec86                	sd	ra,88(sp)
    800032ac:	e8a2                	sd	s0,80(sp)
    800032ae:	e4a6                	sd	s1,72(sp)
    800032b0:	e0ca                	sd	s2,64(sp)
    800032b2:	fc4e                	sd	s3,56(sp)
    800032b4:	f852                	sd	s4,48(sp)
    800032b6:	f456                	sd	s5,40(sp)
    800032b8:	f05a                	sd	s6,32(sp)
    800032ba:	ec5e                	sd	s7,24(sp)
    800032bc:	e862                	sd	s8,16(sp)
    800032be:	e466                	sd	s9,8(sp)
    800032c0:	1080                	addi	s0,sp,96
    800032c2:	84aa                	mv	s1,a0
    800032c4:	8b2e                	mv	s6,a1
    800032c6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c8:	00054703          	lbu	a4,0(a0)
    800032cc:	02f00793          	li	a5,47
    800032d0:	02f70363          	beq	a4,a5,800032f6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032d4:	ffffe097          	auipc	ra,0xffffe
    800032d8:	b74080e7          	jalr	-1164(ra) # 80000e48 <myproc>
    800032dc:	15053503          	ld	a0,336(a0)
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	9f6080e7          	jalr	-1546(ra) # 80002cd6 <idup>
    800032e8:	89aa                	mv	s3,a0
  while(*path == '/')
    800032ea:	02f00913          	li	s2,47
  len = path - s;
    800032ee:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032f0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032f2:	4c05                	li	s8,1
    800032f4:	a865                	j	800033ac <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032f6:	4585                	li	a1,1
    800032f8:	4505                	li	a0,1
    800032fa:	fffff097          	auipc	ra,0xfffff
    800032fe:	6e6080e7          	jalr	1766(ra) # 800029e0 <iget>
    80003302:	89aa                	mv	s3,a0
    80003304:	b7dd                	j	800032ea <namex+0x42>
      iunlockput(ip);
    80003306:	854e                	mv	a0,s3
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	c6e080e7          	jalr	-914(ra) # 80002f76 <iunlockput>
      return 0;
    80003310:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003312:	854e                	mv	a0,s3
    80003314:	60e6                	ld	ra,88(sp)
    80003316:	6446                	ld	s0,80(sp)
    80003318:	64a6                	ld	s1,72(sp)
    8000331a:	6906                	ld	s2,64(sp)
    8000331c:	79e2                	ld	s3,56(sp)
    8000331e:	7a42                	ld	s4,48(sp)
    80003320:	7aa2                	ld	s5,40(sp)
    80003322:	7b02                	ld	s6,32(sp)
    80003324:	6be2                	ld	s7,24(sp)
    80003326:	6c42                	ld	s8,16(sp)
    80003328:	6ca2                	ld	s9,8(sp)
    8000332a:	6125                	addi	sp,sp,96
    8000332c:	8082                	ret
      iunlock(ip);
    8000332e:	854e                	mv	a0,s3
    80003330:	00000097          	auipc	ra,0x0
    80003334:	aa6080e7          	jalr	-1370(ra) # 80002dd6 <iunlock>
      return ip;
    80003338:	bfe9                	j	80003312 <namex+0x6a>
      iunlockput(ip);
    8000333a:	854e                	mv	a0,s3
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	c3a080e7          	jalr	-966(ra) # 80002f76 <iunlockput>
      return 0;
    80003344:	89d2                	mv	s3,s4
    80003346:	b7f1                	j	80003312 <namex+0x6a>
  len = path - s;
    80003348:	40b48633          	sub	a2,s1,a1
    8000334c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003350:	094cd463          	bge	s9,s4,800033d8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003354:	4639                	li	a2,14
    80003356:	8556                	mv	a0,s5
    80003358:	ffffd097          	auipc	ra,0xffffd
    8000335c:	e80080e7          	jalr	-384(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003360:	0004c783          	lbu	a5,0(s1)
    80003364:	01279763          	bne	a5,s2,80003372 <namex+0xca>
    path++;
    80003368:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	ff278de3          	beq	a5,s2,80003368 <namex+0xc0>
    ilock(ip);
    80003372:	854e                	mv	a0,s3
    80003374:	00000097          	auipc	ra,0x0
    80003378:	9a0080e7          	jalr	-1632(ra) # 80002d14 <ilock>
    if(ip->type != T_DIR){
    8000337c:	04499783          	lh	a5,68(s3)
    80003380:	f98793e3          	bne	a5,s8,80003306 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003384:	000b0563          	beqz	s6,8000338e <namex+0xe6>
    80003388:	0004c783          	lbu	a5,0(s1)
    8000338c:	d3cd                	beqz	a5,8000332e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000338e:	865e                	mv	a2,s7
    80003390:	85d6                	mv	a1,s5
    80003392:	854e                	mv	a0,s3
    80003394:	00000097          	auipc	ra,0x0
    80003398:	e64080e7          	jalr	-412(ra) # 800031f8 <dirlookup>
    8000339c:	8a2a                	mv	s4,a0
    8000339e:	dd51                	beqz	a0,8000333a <namex+0x92>
    iunlockput(ip);
    800033a0:	854e                	mv	a0,s3
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	bd4080e7          	jalr	-1068(ra) # 80002f76 <iunlockput>
    ip = next;
    800033aa:	89d2                	mv	s3,s4
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	05279763          	bne	a5,s2,800033fe <namex+0x156>
    path++;
    800033b4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	ff278de3          	beq	a5,s2,800033b4 <namex+0x10c>
  if(*path == 0)
    800033be:	c79d                	beqz	a5,800033ec <namex+0x144>
    path++;
    800033c0:	85a6                	mv	a1,s1
  len = path - s;
    800033c2:	8a5e                	mv	s4,s7
    800033c4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033c6:	01278963          	beq	a5,s2,800033d8 <namex+0x130>
    800033ca:	dfbd                	beqz	a5,80003348 <namex+0xa0>
    path++;
    800033cc:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033ce:	0004c783          	lbu	a5,0(s1)
    800033d2:	ff279ce3          	bne	a5,s2,800033ca <namex+0x122>
    800033d6:	bf8d                	j	80003348 <namex+0xa0>
    memmove(name, s, len);
    800033d8:	2601                	sext.w	a2,a2
    800033da:	8556                	mv	a0,s5
    800033dc:	ffffd097          	auipc	ra,0xffffd
    800033e0:	dfc080e7          	jalr	-516(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033e4:	9a56                	add	s4,s4,s5
    800033e6:	000a0023          	sb	zero,0(s4)
    800033ea:	bf9d                	j	80003360 <namex+0xb8>
  if(nameiparent){
    800033ec:	f20b03e3          	beqz	s6,80003312 <namex+0x6a>
    iput(ip);
    800033f0:	854e                	mv	a0,s3
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	adc080e7          	jalr	-1316(ra) # 80002ece <iput>
    return 0;
    800033fa:	4981                	li	s3,0
    800033fc:	bf19                	j	80003312 <namex+0x6a>
  if(*path == 0)
    800033fe:	d7fd                	beqz	a5,800033ec <namex+0x144>
  while(*path != '/' && *path != 0)
    80003400:	0004c783          	lbu	a5,0(s1)
    80003404:	85a6                	mv	a1,s1
    80003406:	b7d1                	j	800033ca <namex+0x122>

0000000080003408 <dirlink>:
{
    80003408:	7139                	addi	sp,sp,-64
    8000340a:	fc06                	sd	ra,56(sp)
    8000340c:	f822                	sd	s0,48(sp)
    8000340e:	f426                	sd	s1,40(sp)
    80003410:	f04a                	sd	s2,32(sp)
    80003412:	ec4e                	sd	s3,24(sp)
    80003414:	e852                	sd	s4,16(sp)
    80003416:	0080                	addi	s0,sp,64
    80003418:	892a                	mv	s2,a0
    8000341a:	8a2e                	mv	s4,a1
    8000341c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000341e:	4601                	li	a2,0
    80003420:	00000097          	auipc	ra,0x0
    80003424:	dd8080e7          	jalr	-552(ra) # 800031f8 <dirlookup>
    80003428:	e93d                	bnez	a0,8000349e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000342a:	04c92483          	lw	s1,76(s2)
    8000342e:	c49d                	beqz	s1,8000345c <dirlink+0x54>
    80003430:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003432:	4741                	li	a4,16
    80003434:	86a6                	mv	a3,s1
    80003436:	fc040613          	addi	a2,s0,-64
    8000343a:	4581                	li	a1,0
    8000343c:	854a                	mv	a0,s2
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	b8a080e7          	jalr	-1142(ra) # 80002fc8 <readi>
    80003446:	47c1                	li	a5,16
    80003448:	06f51163          	bne	a0,a5,800034aa <dirlink+0xa2>
    if(de.inum == 0)
    8000344c:	fc045783          	lhu	a5,-64(s0)
    80003450:	c791                	beqz	a5,8000345c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003452:	24c1                	addiw	s1,s1,16
    80003454:	04c92783          	lw	a5,76(s2)
    80003458:	fcf4ede3          	bltu	s1,a5,80003432 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000345c:	4639                	li	a2,14
    8000345e:	85d2                	mv	a1,s4
    80003460:	fc240513          	addi	a0,s0,-62
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	e28080e7          	jalr	-472(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000346c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003470:	4741                	li	a4,16
    80003472:	86a6                	mv	a3,s1
    80003474:	fc040613          	addi	a2,s0,-64
    80003478:	4581                	li	a1,0
    8000347a:	854a                	mv	a0,s2
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	c44080e7          	jalr	-956(ra) # 800030c0 <writei>
    80003484:	872a                	mv	a4,a0
    80003486:	47c1                	li	a5,16
  return 0;
    80003488:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348a:	02f71863          	bne	a4,a5,800034ba <dirlink+0xb2>
}
    8000348e:	70e2                	ld	ra,56(sp)
    80003490:	7442                	ld	s0,48(sp)
    80003492:	74a2                	ld	s1,40(sp)
    80003494:	7902                	ld	s2,32(sp)
    80003496:	69e2                	ld	s3,24(sp)
    80003498:	6a42                	ld	s4,16(sp)
    8000349a:	6121                	addi	sp,sp,64
    8000349c:	8082                	ret
    iput(ip);
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	a30080e7          	jalr	-1488(ra) # 80002ece <iput>
    return -1;
    800034a6:	557d                	li	a0,-1
    800034a8:	b7dd                	j	8000348e <dirlink+0x86>
      panic("dirlink read");
    800034aa:	00005517          	auipc	a0,0x5
    800034ae:	0f650513          	addi	a0,a0,246 # 800085a0 <syscalls+0x1d8>
    800034b2:	00003097          	auipc	ra,0x3
    800034b6:	c76080e7          	jalr	-906(ra) # 80006128 <panic>
    panic("dirlink");
    800034ba:	00005517          	auipc	a0,0x5
    800034be:	1f650513          	addi	a0,a0,502 # 800086b0 <syscalls+0x2e8>
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	c66080e7          	jalr	-922(ra) # 80006128 <panic>

00000000800034ca <namei>:

struct inode*
namei(char *path)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034d2:	fe040613          	addi	a2,s0,-32
    800034d6:	4581                	li	a1,0
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	dd0080e7          	jalr	-560(ra) # 800032a8 <namex>
}
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret

00000000800034e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e8:	1141                	addi	sp,sp,-16
    800034ea:	e406                	sd	ra,8(sp)
    800034ec:	e022                	sd	s0,0(sp)
    800034ee:	0800                	addi	s0,sp,16
    800034f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034f2:	4585                	li	a1,1
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	db4080e7          	jalr	-588(ra) # 800032a8 <namex>
}
    800034fc:	60a2                	ld	ra,8(sp)
    800034fe:	6402                	ld	s0,0(sp)
    80003500:	0141                	addi	sp,sp,16
    80003502:	8082                	ret

0000000080003504 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003504:	1101                	addi	sp,sp,-32
    80003506:	ec06                	sd	ra,24(sp)
    80003508:	e822                	sd	s0,16(sp)
    8000350a:	e426                	sd	s1,8(sp)
    8000350c:	e04a                	sd	s2,0(sp)
    8000350e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003510:	00020917          	auipc	s2,0x20
    80003514:	b1090913          	addi	s2,s2,-1264 # 80023020 <log>
    80003518:	01892583          	lw	a1,24(s2)
    8000351c:	02892503          	lw	a0,40(s2)
    80003520:	fffff097          	auipc	ra,0xfffff
    80003524:	ff2080e7          	jalr	-14(ra) # 80002512 <bread>
    80003528:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000352a:	02c92683          	lw	a3,44(s2)
    8000352e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	02d05763          	blez	a3,8000355e <write_head+0x5a>
    80003534:	00020797          	auipc	a5,0x20
    80003538:	b1c78793          	addi	a5,a5,-1252 # 80023050 <log+0x30>
    8000353c:	05c50713          	addi	a4,a0,92
    80003540:	36fd                	addiw	a3,a3,-1
    80003542:	1682                	slli	a3,a3,0x20
    80003544:	9281                	srli	a3,a3,0x20
    80003546:	068a                	slli	a3,a3,0x2
    80003548:	00020617          	auipc	a2,0x20
    8000354c:	b0c60613          	addi	a2,a2,-1268 # 80023054 <log+0x34>
    80003550:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003552:	4390                	lw	a2,0(a5)
    80003554:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003556:	0791                	addi	a5,a5,4
    80003558:	0711                	addi	a4,a4,4
    8000355a:	fed79ce3          	bne	a5,a3,80003552 <write_head+0x4e>
  }
  bwrite(buf);
    8000355e:	8526                	mv	a0,s1
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	0a4080e7          	jalr	164(ra) # 80002604 <bwrite>
  brelse(buf);
    80003568:	8526                	mv	a0,s1
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	0d8080e7          	jalr	216(ra) # 80002642 <brelse>
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6902                	ld	s2,0(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357e:	00020797          	auipc	a5,0x20
    80003582:	ace7a783          	lw	a5,-1330(a5) # 8002304c <log+0x2c>
    80003586:	0af05d63          	blez	a5,80003640 <install_trans+0xc2>
{
    8000358a:	7139                	addi	sp,sp,-64
    8000358c:	fc06                	sd	ra,56(sp)
    8000358e:	f822                	sd	s0,48(sp)
    80003590:	f426                	sd	s1,40(sp)
    80003592:	f04a                	sd	s2,32(sp)
    80003594:	ec4e                	sd	s3,24(sp)
    80003596:	e852                	sd	s4,16(sp)
    80003598:	e456                	sd	s5,8(sp)
    8000359a:	e05a                	sd	s6,0(sp)
    8000359c:	0080                	addi	s0,sp,64
    8000359e:	8b2a                	mv	s6,a0
    800035a0:	00020a97          	auipc	s5,0x20
    800035a4:	ab0a8a93          	addi	s5,s5,-1360 # 80023050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035aa:	00020997          	auipc	s3,0x20
    800035ae:	a7698993          	addi	s3,s3,-1418 # 80023020 <log>
    800035b2:	a035                	j	800035de <install_trans+0x60>
      bunpin(dbuf);
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	166080e7          	jalr	358(ra) # 8000271c <bunpin>
    brelse(lbuf);
    800035be:	854a                	mv	a0,s2
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	082080e7          	jalr	130(ra) # 80002642 <brelse>
    brelse(dbuf);
    800035c8:	8526                	mv	a0,s1
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	078080e7          	jalr	120(ra) # 80002642 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d2:	2a05                	addiw	s4,s4,1
    800035d4:	0a91                	addi	s5,s5,4
    800035d6:	02c9a783          	lw	a5,44(s3)
    800035da:	04fa5963          	bge	s4,a5,8000362c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035de:	0189a583          	lw	a1,24(s3)
    800035e2:	014585bb          	addw	a1,a1,s4
    800035e6:	2585                	addiw	a1,a1,1
    800035e8:	0289a503          	lw	a0,40(s3)
    800035ec:	fffff097          	auipc	ra,0xfffff
    800035f0:	f26080e7          	jalr	-218(ra) # 80002512 <bread>
    800035f4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035f6:	000aa583          	lw	a1,0(s5)
    800035fa:	0289a503          	lw	a0,40(s3)
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	f14080e7          	jalr	-236(ra) # 80002512 <bread>
    80003606:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003608:	40000613          	li	a2,1024
    8000360c:	05890593          	addi	a1,s2,88
    80003610:	05850513          	addi	a0,a0,88
    80003614:	ffffd097          	auipc	ra,0xffffd
    80003618:	bc4080e7          	jalr	-1084(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000361c:	8526                	mv	a0,s1
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	fe6080e7          	jalr	-26(ra) # 80002604 <bwrite>
    if(recovering == 0)
    80003626:	f80b1ce3          	bnez	s6,800035be <install_trans+0x40>
    8000362a:	b769                	j	800035b4 <install_trans+0x36>
}
    8000362c:	70e2                	ld	ra,56(sp)
    8000362e:	7442                	ld	s0,48(sp)
    80003630:	74a2                	ld	s1,40(sp)
    80003632:	7902                	ld	s2,32(sp)
    80003634:	69e2                	ld	s3,24(sp)
    80003636:	6a42                	ld	s4,16(sp)
    80003638:	6aa2                	ld	s5,8(sp)
    8000363a:	6b02                	ld	s6,0(sp)
    8000363c:	6121                	addi	sp,sp,64
    8000363e:	8082                	ret
    80003640:	8082                	ret

0000000080003642 <initlog>:
{
    80003642:	7179                	addi	sp,sp,-48
    80003644:	f406                	sd	ra,40(sp)
    80003646:	f022                	sd	s0,32(sp)
    80003648:	ec26                	sd	s1,24(sp)
    8000364a:	e84a                	sd	s2,16(sp)
    8000364c:	e44e                	sd	s3,8(sp)
    8000364e:	1800                	addi	s0,sp,48
    80003650:	892a                	mv	s2,a0
    80003652:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003654:	00020497          	auipc	s1,0x20
    80003658:	9cc48493          	addi	s1,s1,-1588 # 80023020 <log>
    8000365c:	00005597          	auipc	a1,0x5
    80003660:	f5458593          	addi	a1,a1,-172 # 800085b0 <syscalls+0x1e8>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	f7c080e7          	jalr	-132(ra) # 800065e2 <initlock>
  log.start = sb->logstart;
    8000366e:	0149a583          	lw	a1,20(s3)
    80003672:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003674:	0109a783          	lw	a5,16(s3)
    80003678:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000367a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367e:	854a                	mv	a0,s2
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	e92080e7          	jalr	-366(ra) # 80002512 <bread>
  log.lh.n = lh->n;
    80003688:	4d3c                	lw	a5,88(a0)
    8000368a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000368c:	02f05563          	blez	a5,800036b6 <initlog+0x74>
    80003690:	05c50713          	addi	a4,a0,92
    80003694:	00020697          	auipc	a3,0x20
    80003698:	9bc68693          	addi	a3,a3,-1604 # 80023050 <log+0x30>
    8000369c:	37fd                	addiw	a5,a5,-1
    8000369e:	1782                	slli	a5,a5,0x20
    800036a0:	9381                	srli	a5,a5,0x20
    800036a2:	078a                	slli	a5,a5,0x2
    800036a4:	06050613          	addi	a2,a0,96
    800036a8:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036aa:	4310                	lw	a2,0(a4)
    800036ac:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036ae:	0711                	addi	a4,a4,4
    800036b0:	0691                	addi	a3,a3,4
    800036b2:	fef71ce3          	bne	a4,a5,800036aa <initlog+0x68>
  brelse(buf);
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	f8c080e7          	jalr	-116(ra) # 80002642 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036be:	4505                	li	a0,1
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	ebe080e7          	jalr	-322(ra) # 8000357e <install_trans>
  log.lh.n = 0;
    800036c8:	00020797          	auipc	a5,0x20
    800036cc:	9807a223          	sw	zero,-1660(a5) # 8002304c <log+0x2c>
  write_head(); // clear the log
    800036d0:	00000097          	auipc	ra,0x0
    800036d4:	e34080e7          	jalr	-460(ra) # 80003504 <write_head>
}
    800036d8:	70a2                	ld	ra,40(sp)
    800036da:	7402                	ld	s0,32(sp)
    800036dc:	64e2                	ld	s1,24(sp)
    800036de:	6942                	ld	s2,16(sp)
    800036e0:	69a2                	ld	s3,8(sp)
    800036e2:	6145                	addi	sp,sp,48
    800036e4:	8082                	ret

00000000800036e6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036e6:	1101                	addi	sp,sp,-32
    800036e8:	ec06                	sd	ra,24(sp)
    800036ea:	e822                	sd	s0,16(sp)
    800036ec:	e426                	sd	s1,8(sp)
    800036ee:	e04a                	sd	s2,0(sp)
    800036f0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036f2:	00020517          	auipc	a0,0x20
    800036f6:	92e50513          	addi	a0,a0,-1746 # 80023020 <log>
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	f78080e7          	jalr	-136(ra) # 80006672 <acquire>
  while(1){
    if(log.committing){
    80003702:	00020497          	auipc	s1,0x20
    80003706:	91e48493          	addi	s1,s1,-1762 # 80023020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000370a:	4979                	li	s2,30
    8000370c:	a039                	j	8000371a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000370e:	85a6                	mv	a1,s1
    80003710:	8526                	mv	a0,s1
    80003712:	ffffe097          	auipc	ra,0xffffe
    80003716:	e62080e7          	jalr	-414(ra) # 80001574 <sleep>
    if(log.committing){
    8000371a:	50dc                	lw	a5,36(s1)
    8000371c:	fbed                	bnez	a5,8000370e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000371e:	509c                	lw	a5,32(s1)
    80003720:	0017871b          	addiw	a4,a5,1
    80003724:	0007069b          	sext.w	a3,a4
    80003728:	0027179b          	slliw	a5,a4,0x2
    8000372c:	9fb9                	addw	a5,a5,a4
    8000372e:	0017979b          	slliw	a5,a5,0x1
    80003732:	54d8                	lw	a4,44(s1)
    80003734:	9fb9                	addw	a5,a5,a4
    80003736:	00f95963          	bge	s2,a5,80003748 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000373a:	85a6                	mv	a1,s1
    8000373c:	8526                	mv	a0,s1
    8000373e:	ffffe097          	auipc	ra,0xffffe
    80003742:	e36080e7          	jalr	-458(ra) # 80001574 <sleep>
    80003746:	bfd1                	j	8000371a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003748:	00020517          	auipc	a0,0x20
    8000374c:	8d850513          	addi	a0,a0,-1832 # 80023020 <log>
    80003750:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003752:	00003097          	auipc	ra,0x3
    80003756:	fd4080e7          	jalr	-44(ra) # 80006726 <release>
      break;
    }
  }
}
    8000375a:	60e2                	ld	ra,24(sp)
    8000375c:	6442                	ld	s0,16(sp)
    8000375e:	64a2                	ld	s1,8(sp)
    80003760:	6902                	ld	s2,0(sp)
    80003762:	6105                	addi	sp,sp,32
    80003764:	8082                	ret

0000000080003766 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003766:	7139                	addi	sp,sp,-64
    80003768:	fc06                	sd	ra,56(sp)
    8000376a:	f822                	sd	s0,48(sp)
    8000376c:	f426                	sd	s1,40(sp)
    8000376e:	f04a                	sd	s2,32(sp)
    80003770:	ec4e                	sd	s3,24(sp)
    80003772:	e852                	sd	s4,16(sp)
    80003774:	e456                	sd	s5,8(sp)
    80003776:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003778:	00020497          	auipc	s1,0x20
    8000377c:	8a848493          	addi	s1,s1,-1880 # 80023020 <log>
    80003780:	8526                	mv	a0,s1
    80003782:	00003097          	auipc	ra,0x3
    80003786:	ef0080e7          	jalr	-272(ra) # 80006672 <acquire>
  log.outstanding -= 1;
    8000378a:	509c                	lw	a5,32(s1)
    8000378c:	37fd                	addiw	a5,a5,-1
    8000378e:	0007891b          	sext.w	s2,a5
    80003792:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003794:	50dc                	lw	a5,36(s1)
    80003796:	efb9                	bnez	a5,800037f4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003798:	06091663          	bnez	s2,80003804 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000379c:	00020497          	auipc	s1,0x20
    800037a0:	88448493          	addi	s1,s1,-1916 # 80023020 <log>
    800037a4:	4785                	li	a5,1
    800037a6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	f7c080e7          	jalr	-132(ra) # 80006726 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037b2:	54dc                	lw	a5,44(s1)
    800037b4:	06f04763          	bgtz	a5,80003822 <end_op+0xbc>
    acquire(&log.lock);
    800037b8:	00020497          	auipc	s1,0x20
    800037bc:	86848493          	addi	s1,s1,-1944 # 80023020 <log>
    800037c0:	8526                	mv	a0,s1
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	eb0080e7          	jalr	-336(ra) # 80006672 <acquire>
    log.committing = 0;
    800037ca:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ce:	8526                	mv	a0,s1
    800037d0:	ffffe097          	auipc	ra,0xffffe
    800037d4:	f30080e7          	jalr	-208(ra) # 80001700 <wakeup>
    release(&log.lock);
    800037d8:	8526                	mv	a0,s1
    800037da:	00003097          	auipc	ra,0x3
    800037de:	f4c080e7          	jalr	-180(ra) # 80006726 <release>
}
    800037e2:	70e2                	ld	ra,56(sp)
    800037e4:	7442                	ld	s0,48(sp)
    800037e6:	74a2                	ld	s1,40(sp)
    800037e8:	7902                	ld	s2,32(sp)
    800037ea:	69e2                	ld	s3,24(sp)
    800037ec:	6a42                	ld	s4,16(sp)
    800037ee:	6aa2                	ld	s5,8(sp)
    800037f0:	6121                	addi	sp,sp,64
    800037f2:	8082                	ret
    panic("log.committing");
    800037f4:	00005517          	auipc	a0,0x5
    800037f8:	dc450513          	addi	a0,a0,-572 # 800085b8 <syscalls+0x1f0>
    800037fc:	00003097          	auipc	ra,0x3
    80003800:	92c080e7          	jalr	-1748(ra) # 80006128 <panic>
    wakeup(&log);
    80003804:	00020497          	auipc	s1,0x20
    80003808:	81c48493          	addi	s1,s1,-2020 # 80023020 <log>
    8000380c:	8526                	mv	a0,s1
    8000380e:	ffffe097          	auipc	ra,0xffffe
    80003812:	ef2080e7          	jalr	-270(ra) # 80001700 <wakeup>
  release(&log.lock);
    80003816:	8526                	mv	a0,s1
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	f0e080e7          	jalr	-242(ra) # 80006726 <release>
  if(do_commit){
    80003820:	b7c9                	j	800037e2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003822:	00020a97          	auipc	s5,0x20
    80003826:	82ea8a93          	addi	s5,s5,-2002 # 80023050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000382a:	0001fa17          	auipc	s4,0x1f
    8000382e:	7f6a0a13          	addi	s4,s4,2038 # 80023020 <log>
    80003832:	018a2583          	lw	a1,24(s4)
    80003836:	012585bb          	addw	a1,a1,s2
    8000383a:	2585                	addiw	a1,a1,1
    8000383c:	028a2503          	lw	a0,40(s4)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	cd2080e7          	jalr	-814(ra) # 80002512 <bread>
    80003848:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000384a:	000aa583          	lw	a1,0(s5)
    8000384e:	028a2503          	lw	a0,40(s4)
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	cc0080e7          	jalr	-832(ra) # 80002512 <bread>
    8000385a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000385c:	40000613          	li	a2,1024
    80003860:	05850593          	addi	a1,a0,88
    80003864:	05848513          	addi	a0,s1,88
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	970080e7          	jalr	-1680(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	d92080e7          	jalr	-622(ra) # 80002604 <bwrite>
    brelse(from);
    8000387a:	854e                	mv	a0,s3
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	dc6080e7          	jalr	-570(ra) # 80002642 <brelse>
    brelse(to);
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	dbc080e7          	jalr	-580(ra) # 80002642 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388e:	2905                	addiw	s2,s2,1
    80003890:	0a91                	addi	s5,s5,4
    80003892:	02ca2783          	lw	a5,44(s4)
    80003896:	f8f94ee3          	blt	s2,a5,80003832 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	c6a080e7          	jalr	-918(ra) # 80003504 <write_head>
    install_trans(0); // Now install writes to home locations
    800038a2:	4501                	li	a0,0
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	cda080e7          	jalr	-806(ra) # 8000357e <install_trans>
    log.lh.n = 0;
    800038ac:	0001f797          	auipc	a5,0x1f
    800038b0:	7a07a023          	sw	zero,1952(a5) # 8002304c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	c50080e7          	jalr	-944(ra) # 80003504 <write_head>
    800038bc:	bdf5                	j	800037b8 <end_op+0x52>

00000000800038be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	e04a                	sd	s2,0(sp)
    800038c8:	1000                	addi	s0,sp,32
    800038ca:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038cc:	0001f917          	auipc	s2,0x1f
    800038d0:	75490913          	addi	s2,s2,1876 # 80023020 <log>
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	d9c080e7          	jalr	-612(ra) # 80006672 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038de:	02c92603          	lw	a2,44(s2)
    800038e2:	47f5                	li	a5,29
    800038e4:	06c7c563          	blt	a5,a2,8000394e <log_write+0x90>
    800038e8:	0001f797          	auipc	a5,0x1f
    800038ec:	7547a783          	lw	a5,1876(a5) # 8002303c <log+0x1c>
    800038f0:	37fd                	addiw	a5,a5,-1
    800038f2:	04f65e63          	bge	a2,a5,8000394e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038f6:	0001f797          	auipc	a5,0x1f
    800038fa:	74a7a783          	lw	a5,1866(a5) # 80023040 <log+0x20>
    800038fe:	06f05063          	blez	a5,8000395e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003902:	4781                	li	a5,0
    80003904:	06c05563          	blez	a2,8000396e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003908:	44cc                	lw	a1,12(s1)
    8000390a:	0001f717          	auipc	a4,0x1f
    8000390e:	74670713          	addi	a4,a4,1862 # 80023050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003912:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003914:	4314                	lw	a3,0(a4)
    80003916:	04b68c63          	beq	a3,a1,8000396e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000391a:	2785                	addiw	a5,a5,1
    8000391c:	0711                	addi	a4,a4,4
    8000391e:	fef61be3          	bne	a2,a5,80003914 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003922:	0621                	addi	a2,a2,8
    80003924:	060a                	slli	a2,a2,0x2
    80003926:	0001f797          	auipc	a5,0x1f
    8000392a:	6fa78793          	addi	a5,a5,1786 # 80023020 <log>
    8000392e:	963e                	add	a2,a2,a5
    80003930:	44dc                	lw	a5,12(s1)
    80003932:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003934:	8526                	mv	a0,s1
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	daa080e7          	jalr	-598(ra) # 800026e0 <bpin>
    log.lh.n++;
    8000393e:	0001f717          	auipc	a4,0x1f
    80003942:	6e270713          	addi	a4,a4,1762 # 80023020 <log>
    80003946:	575c                	lw	a5,44(a4)
    80003948:	2785                	addiw	a5,a5,1
    8000394a:	d75c                	sw	a5,44(a4)
    8000394c:	a835                	j	80003988 <log_write+0xca>
    panic("too big a transaction");
    8000394e:	00005517          	auipc	a0,0x5
    80003952:	c7a50513          	addi	a0,a0,-902 # 800085c8 <syscalls+0x200>
    80003956:	00002097          	auipc	ra,0x2
    8000395a:	7d2080e7          	jalr	2002(ra) # 80006128 <panic>
    panic("log_write outside of trans");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	c8250513          	addi	a0,a0,-894 # 800085e0 <syscalls+0x218>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	7c2080e7          	jalr	1986(ra) # 80006128 <panic>
  log.lh.block[i] = b->blockno;
    8000396e:	00878713          	addi	a4,a5,8
    80003972:	00271693          	slli	a3,a4,0x2
    80003976:	0001f717          	auipc	a4,0x1f
    8000397a:	6aa70713          	addi	a4,a4,1706 # 80023020 <log>
    8000397e:	9736                	add	a4,a4,a3
    80003980:	44d4                	lw	a3,12(s1)
    80003982:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003984:	faf608e3          	beq	a2,a5,80003934 <log_write+0x76>
  }
  release(&log.lock);
    80003988:	0001f517          	auipc	a0,0x1f
    8000398c:	69850513          	addi	a0,a0,1688 # 80023020 <log>
    80003990:	00003097          	auipc	ra,0x3
    80003994:	d96080e7          	jalr	-618(ra) # 80006726 <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	e04a                	sd	s2,0(sp)
    800039ae:	1000                	addi	s0,sp,32
    800039b0:	84aa                	mv	s1,a0
    800039b2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039b4:	00005597          	auipc	a1,0x5
    800039b8:	c4c58593          	addi	a1,a1,-948 # 80008600 <syscalls+0x238>
    800039bc:	0521                	addi	a0,a0,8
    800039be:	00003097          	auipc	ra,0x3
    800039c2:	c24080e7          	jalr	-988(ra) # 800065e2 <initlock>
  lk->name = name;
    800039c6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ce:	0204a423          	sw	zero,40(s1)
}
    800039d2:	60e2                	ld	ra,24(sp)
    800039d4:	6442                	ld	s0,16(sp)
    800039d6:	64a2                	ld	s1,8(sp)
    800039d8:	6902                	ld	s2,0(sp)
    800039da:	6105                	addi	sp,sp,32
    800039dc:	8082                	ret

00000000800039de <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	e04a                	sd	s2,0(sp)
    800039e8:	1000                	addi	s0,sp,32
    800039ea:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ec:	00850913          	addi	s2,a0,8
    800039f0:	854a                	mv	a0,s2
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	c80080e7          	jalr	-896(ra) # 80006672 <acquire>
  while (lk->locked) {
    800039fa:	409c                	lw	a5,0(s1)
    800039fc:	cb89                	beqz	a5,80003a0e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039fe:	85ca                	mv	a1,s2
    80003a00:	8526                	mv	a0,s1
    80003a02:	ffffe097          	auipc	ra,0xffffe
    80003a06:	b72080e7          	jalr	-1166(ra) # 80001574 <sleep>
  while (lk->locked) {
    80003a0a:	409c                	lw	a5,0(s1)
    80003a0c:	fbed                	bnez	a5,800039fe <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a0e:	4785                	li	a5,1
    80003a10:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	436080e7          	jalr	1078(ra) # 80000e48 <myproc>
    80003a1a:	591c                	lw	a5,48(a0)
    80003a1c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a1e:	854a                	mv	a0,s2
    80003a20:	00003097          	auipc	ra,0x3
    80003a24:	d06080e7          	jalr	-762(ra) # 80006726 <release>
}
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6902                	ld	s2,0(sp)
    80003a30:	6105                	addi	sp,sp,32
    80003a32:	8082                	ret

0000000080003a34 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a34:	1101                	addi	sp,sp,-32
    80003a36:	ec06                	sd	ra,24(sp)
    80003a38:	e822                	sd	s0,16(sp)
    80003a3a:	e426                	sd	s1,8(sp)
    80003a3c:	e04a                	sd	s2,0(sp)
    80003a3e:	1000                	addi	s0,sp,32
    80003a40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a42:	00850913          	addi	s2,a0,8
    80003a46:	854a                	mv	a0,s2
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	c2a080e7          	jalr	-982(ra) # 80006672 <acquire>
  lk->locked = 0;
    80003a50:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a54:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a58:	8526                	mv	a0,s1
    80003a5a:	ffffe097          	auipc	ra,0xffffe
    80003a5e:	ca6080e7          	jalr	-858(ra) # 80001700 <wakeup>
  release(&lk->lk);
    80003a62:	854a                	mv	a0,s2
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	cc2080e7          	jalr	-830(ra) # 80006726 <release>
}
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6902                	ld	s2,0(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret

0000000080003a78 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a78:	7179                	addi	sp,sp,-48
    80003a7a:	f406                	sd	ra,40(sp)
    80003a7c:	f022                	sd	s0,32(sp)
    80003a7e:	ec26                	sd	s1,24(sp)
    80003a80:	e84a                	sd	s2,16(sp)
    80003a82:	e44e                	sd	s3,8(sp)
    80003a84:	1800                	addi	s0,sp,48
    80003a86:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a88:	00850913          	addi	s2,a0,8
    80003a8c:	854a                	mv	a0,s2
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	be4080e7          	jalr	-1052(ra) # 80006672 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a96:	409c                	lw	a5,0(s1)
    80003a98:	ef99                	bnez	a5,80003ab6 <holdingsleep+0x3e>
    80003a9a:	4481                	li	s1,0
  release(&lk->lk);
    80003a9c:	854a                	mv	a0,s2
    80003a9e:	00003097          	auipc	ra,0x3
    80003aa2:	c88080e7          	jalr	-888(ra) # 80006726 <release>
  return r;
}
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	70a2                	ld	ra,40(sp)
    80003aaa:	7402                	ld	s0,32(sp)
    80003aac:	64e2                	ld	s1,24(sp)
    80003aae:	6942                	ld	s2,16(sp)
    80003ab0:	69a2                	ld	s3,8(sp)
    80003ab2:	6145                	addi	sp,sp,48
    80003ab4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab6:	0284a983          	lw	s3,40(s1)
    80003aba:	ffffd097          	auipc	ra,0xffffd
    80003abe:	38e080e7          	jalr	910(ra) # 80000e48 <myproc>
    80003ac2:	5904                	lw	s1,48(a0)
    80003ac4:	413484b3          	sub	s1,s1,s3
    80003ac8:	0014b493          	seqz	s1,s1
    80003acc:	bfc1                	j	80003a9c <holdingsleep+0x24>

0000000080003ace <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ace:	1141                	addi	sp,sp,-16
    80003ad0:	e406                	sd	ra,8(sp)
    80003ad2:	e022                	sd	s0,0(sp)
    80003ad4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ad6:	00005597          	auipc	a1,0x5
    80003ada:	b3a58593          	addi	a1,a1,-1222 # 80008610 <syscalls+0x248>
    80003ade:	0001f517          	auipc	a0,0x1f
    80003ae2:	68a50513          	addi	a0,a0,1674 # 80023168 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	afc080e7          	jalr	-1284(ra) # 800065e2 <initlock>
}
    80003aee:	60a2                	ld	ra,8(sp)
    80003af0:	6402                	ld	s0,0(sp)
    80003af2:	0141                	addi	sp,sp,16
    80003af4:	8082                	ret

0000000080003af6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003af6:	1101                	addi	sp,sp,-32
    80003af8:	ec06                	sd	ra,24(sp)
    80003afa:	e822                	sd	s0,16(sp)
    80003afc:	e426                	sd	s1,8(sp)
    80003afe:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b00:	0001f517          	auipc	a0,0x1f
    80003b04:	66850513          	addi	a0,a0,1640 # 80023168 <ftable>
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	b6a080e7          	jalr	-1174(ra) # 80006672 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b10:	0001f497          	auipc	s1,0x1f
    80003b14:	67048493          	addi	s1,s1,1648 # 80023180 <ftable+0x18>
    80003b18:	00020717          	auipc	a4,0x20
    80003b1c:	60870713          	addi	a4,a4,1544 # 80024120 <ftable+0xfb8>
    if(f->ref == 0){
    80003b20:	40dc                	lw	a5,4(s1)
    80003b22:	cf99                	beqz	a5,80003b40 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b24:	02848493          	addi	s1,s1,40
    80003b28:	fee49ce3          	bne	s1,a4,80003b20 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b2c:	0001f517          	auipc	a0,0x1f
    80003b30:	63c50513          	addi	a0,a0,1596 # 80023168 <ftable>
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	bf2080e7          	jalr	-1038(ra) # 80006726 <release>
  return 0;
    80003b3c:	4481                	li	s1,0
    80003b3e:	a819                	j	80003b54 <filealloc+0x5e>
      f->ref = 1;
    80003b40:	4785                	li	a5,1
    80003b42:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b44:	0001f517          	auipc	a0,0x1f
    80003b48:	62450513          	addi	a0,a0,1572 # 80023168 <ftable>
    80003b4c:	00003097          	auipc	ra,0x3
    80003b50:	bda080e7          	jalr	-1062(ra) # 80006726 <release>
}
    80003b54:	8526                	mv	a0,s1
    80003b56:	60e2                	ld	ra,24(sp)
    80003b58:	6442                	ld	s0,16(sp)
    80003b5a:	64a2                	ld	s1,8(sp)
    80003b5c:	6105                	addi	sp,sp,32
    80003b5e:	8082                	ret

0000000080003b60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b60:	1101                	addi	sp,sp,-32
    80003b62:	ec06                	sd	ra,24(sp)
    80003b64:	e822                	sd	s0,16(sp)
    80003b66:	e426                	sd	s1,8(sp)
    80003b68:	1000                	addi	s0,sp,32
    80003b6a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b6c:	0001f517          	auipc	a0,0x1f
    80003b70:	5fc50513          	addi	a0,a0,1532 # 80023168 <ftable>
    80003b74:	00003097          	auipc	ra,0x3
    80003b78:	afe080e7          	jalr	-1282(ra) # 80006672 <acquire>
  if(f->ref < 1)
    80003b7c:	40dc                	lw	a5,4(s1)
    80003b7e:	02f05263          	blez	a5,80003ba2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b82:	2785                	addiw	a5,a5,1
    80003b84:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b86:	0001f517          	auipc	a0,0x1f
    80003b8a:	5e250513          	addi	a0,a0,1506 # 80023168 <ftable>
    80003b8e:	00003097          	auipc	ra,0x3
    80003b92:	b98080e7          	jalr	-1128(ra) # 80006726 <release>
  return f;
}
    80003b96:	8526                	mv	a0,s1
    80003b98:	60e2                	ld	ra,24(sp)
    80003b9a:	6442                	ld	s0,16(sp)
    80003b9c:	64a2                	ld	s1,8(sp)
    80003b9e:	6105                	addi	sp,sp,32
    80003ba0:	8082                	ret
    panic("filedup");
    80003ba2:	00005517          	auipc	a0,0x5
    80003ba6:	a7650513          	addi	a0,a0,-1418 # 80008618 <syscalls+0x250>
    80003baa:	00002097          	auipc	ra,0x2
    80003bae:	57e080e7          	jalr	1406(ra) # 80006128 <panic>

0000000080003bb2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bb2:	7139                	addi	sp,sp,-64
    80003bb4:	fc06                	sd	ra,56(sp)
    80003bb6:	f822                	sd	s0,48(sp)
    80003bb8:	f426                	sd	s1,40(sp)
    80003bba:	f04a                	sd	s2,32(sp)
    80003bbc:	ec4e                	sd	s3,24(sp)
    80003bbe:	e852                	sd	s4,16(sp)
    80003bc0:	e456                	sd	s5,8(sp)
    80003bc2:	0080                	addi	s0,sp,64
    80003bc4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bc6:	0001f517          	auipc	a0,0x1f
    80003bca:	5a250513          	addi	a0,a0,1442 # 80023168 <ftable>
    80003bce:	00003097          	auipc	ra,0x3
    80003bd2:	aa4080e7          	jalr	-1372(ra) # 80006672 <acquire>
  if(f->ref < 1)
    80003bd6:	40dc                	lw	a5,4(s1)
    80003bd8:	06f05163          	blez	a5,80003c3a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bdc:	37fd                	addiw	a5,a5,-1
    80003bde:	0007871b          	sext.w	a4,a5
    80003be2:	c0dc                	sw	a5,4(s1)
    80003be4:	06e04363          	bgtz	a4,80003c4a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be8:	0004a903          	lw	s2,0(s1)
    80003bec:	0094ca83          	lbu	s5,9(s1)
    80003bf0:	0104ba03          	ld	s4,16(s1)
    80003bf4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bfc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c00:	0001f517          	auipc	a0,0x1f
    80003c04:	56850513          	addi	a0,a0,1384 # 80023168 <ftable>
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	b1e080e7          	jalr	-1250(ra) # 80006726 <release>

  if(ff.type == FD_PIPE){
    80003c10:	4785                	li	a5,1
    80003c12:	04f90d63          	beq	s2,a5,80003c6c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c16:	3979                	addiw	s2,s2,-2
    80003c18:	4785                	li	a5,1
    80003c1a:	0527e063          	bltu	a5,s2,80003c5a <fileclose+0xa8>
    begin_op();
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	ac8080e7          	jalr	-1336(ra) # 800036e6 <begin_op>
    iput(ff.ip);
    80003c26:	854e                	mv	a0,s3
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	2a6080e7          	jalr	678(ra) # 80002ece <iput>
    end_op();
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	b36080e7          	jalr	-1226(ra) # 80003766 <end_op>
    80003c38:	a00d                	j	80003c5a <fileclose+0xa8>
    panic("fileclose");
    80003c3a:	00005517          	auipc	a0,0x5
    80003c3e:	9e650513          	addi	a0,a0,-1562 # 80008620 <syscalls+0x258>
    80003c42:	00002097          	auipc	ra,0x2
    80003c46:	4e6080e7          	jalr	1254(ra) # 80006128 <panic>
    release(&ftable.lock);
    80003c4a:	0001f517          	auipc	a0,0x1f
    80003c4e:	51e50513          	addi	a0,a0,1310 # 80023168 <ftable>
    80003c52:	00003097          	auipc	ra,0x3
    80003c56:	ad4080e7          	jalr	-1324(ra) # 80006726 <release>
  }
}
    80003c5a:	70e2                	ld	ra,56(sp)
    80003c5c:	7442                	ld	s0,48(sp)
    80003c5e:	74a2                	ld	s1,40(sp)
    80003c60:	7902                	ld	s2,32(sp)
    80003c62:	69e2                	ld	s3,24(sp)
    80003c64:	6a42                	ld	s4,16(sp)
    80003c66:	6aa2                	ld	s5,8(sp)
    80003c68:	6121                	addi	sp,sp,64
    80003c6a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c6c:	85d6                	mv	a1,s5
    80003c6e:	8552                	mv	a0,s4
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	34c080e7          	jalr	844(ra) # 80003fbc <pipeclose>
    80003c78:	b7cd                	j	80003c5a <fileclose+0xa8>

0000000080003c7a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c7a:	715d                	addi	sp,sp,-80
    80003c7c:	e486                	sd	ra,72(sp)
    80003c7e:	e0a2                	sd	s0,64(sp)
    80003c80:	fc26                	sd	s1,56(sp)
    80003c82:	f84a                	sd	s2,48(sp)
    80003c84:	f44e                	sd	s3,40(sp)
    80003c86:	0880                	addi	s0,sp,80
    80003c88:	84aa                	mv	s1,a0
    80003c8a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c8c:	ffffd097          	auipc	ra,0xffffd
    80003c90:	1bc080e7          	jalr	444(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c94:	409c                	lw	a5,0(s1)
    80003c96:	37f9                	addiw	a5,a5,-2
    80003c98:	4705                	li	a4,1
    80003c9a:	04f76763          	bltu	a4,a5,80003ce8 <filestat+0x6e>
    80003c9e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ca0:	6c88                	ld	a0,24(s1)
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	072080e7          	jalr	114(ra) # 80002d14 <ilock>
    stati(f->ip, &st);
    80003caa:	fb840593          	addi	a1,s0,-72
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	2ee080e7          	jalr	750(ra) # 80002f9e <stati>
    iunlock(f->ip);
    80003cb8:	6c88                	ld	a0,24(s1)
    80003cba:	fffff097          	auipc	ra,0xfffff
    80003cbe:	11c080e7          	jalr	284(ra) # 80002dd6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cc2:	46e1                	li	a3,24
    80003cc4:	fb840613          	addi	a2,s0,-72
    80003cc8:	85ce                	mv	a1,s3
    80003cca:	05093503          	ld	a0,80(s2)
    80003cce:	ffffd097          	auipc	ra,0xffffd
    80003cd2:	e3c080e7          	jalr	-452(ra) # 80000b0a <copyout>
    80003cd6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cda:	60a6                	ld	ra,72(sp)
    80003cdc:	6406                	ld	s0,64(sp)
    80003cde:	74e2                	ld	s1,56(sp)
    80003ce0:	7942                	ld	s2,48(sp)
    80003ce2:	79a2                	ld	s3,40(sp)
    80003ce4:	6161                	addi	sp,sp,80
    80003ce6:	8082                	ret
  return -1;
    80003ce8:	557d                	li	a0,-1
    80003cea:	bfc5                	j	80003cda <filestat+0x60>

0000000080003cec <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cec:	7179                	addi	sp,sp,-48
    80003cee:	f406                	sd	ra,40(sp)
    80003cf0:	f022                	sd	s0,32(sp)
    80003cf2:	ec26                	sd	s1,24(sp)
    80003cf4:	e84a                	sd	s2,16(sp)
    80003cf6:	e44e                	sd	s3,8(sp)
    80003cf8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cfa:	00854783          	lbu	a5,8(a0)
    80003cfe:	c3d5                	beqz	a5,80003da2 <fileread+0xb6>
    80003d00:	84aa                	mv	s1,a0
    80003d02:	89ae                	mv	s3,a1
    80003d04:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d06:	411c                	lw	a5,0(a0)
    80003d08:	4705                	li	a4,1
    80003d0a:	04e78963          	beq	a5,a4,80003d5c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0e:	470d                	li	a4,3
    80003d10:	04e78d63          	beq	a5,a4,80003d6a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d14:	4709                	li	a4,2
    80003d16:	06e79e63          	bne	a5,a4,80003d92 <fileread+0xa6>
    ilock(f->ip);
    80003d1a:	6d08                	ld	a0,24(a0)
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	ff8080e7          	jalr	-8(ra) # 80002d14 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d24:	874a                	mv	a4,s2
    80003d26:	5094                	lw	a3,32(s1)
    80003d28:	864e                	mv	a2,s3
    80003d2a:	4585                	li	a1,1
    80003d2c:	6c88                	ld	a0,24(s1)
    80003d2e:	fffff097          	auipc	ra,0xfffff
    80003d32:	29a080e7          	jalr	666(ra) # 80002fc8 <readi>
    80003d36:	892a                	mv	s2,a0
    80003d38:	00a05563          	blez	a0,80003d42 <fileread+0x56>
      f->off += r;
    80003d3c:	509c                	lw	a5,32(s1)
    80003d3e:	9fa9                	addw	a5,a5,a0
    80003d40:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d42:	6c88                	ld	a0,24(s1)
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	092080e7          	jalr	146(ra) # 80002dd6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d4c:	854a                	mv	a0,s2
    80003d4e:	70a2                	ld	ra,40(sp)
    80003d50:	7402                	ld	s0,32(sp)
    80003d52:	64e2                	ld	s1,24(sp)
    80003d54:	6942                	ld	s2,16(sp)
    80003d56:	69a2                	ld	s3,8(sp)
    80003d58:	6145                	addi	sp,sp,48
    80003d5a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d5c:	6908                	ld	a0,16(a0)
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	3c8080e7          	jalr	968(ra) # 80004126 <piperead>
    80003d66:	892a                	mv	s2,a0
    80003d68:	b7d5                	j	80003d4c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d6a:	02451783          	lh	a5,36(a0)
    80003d6e:	03079693          	slli	a3,a5,0x30
    80003d72:	92c1                	srli	a3,a3,0x30
    80003d74:	4725                	li	a4,9
    80003d76:	02d76863          	bltu	a4,a3,80003da6 <fileread+0xba>
    80003d7a:	0792                	slli	a5,a5,0x4
    80003d7c:	0001f717          	auipc	a4,0x1f
    80003d80:	34c70713          	addi	a4,a4,844 # 800230c8 <devsw>
    80003d84:	97ba                	add	a5,a5,a4
    80003d86:	639c                	ld	a5,0(a5)
    80003d88:	c38d                	beqz	a5,80003daa <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d8a:	4505                	li	a0,1
    80003d8c:	9782                	jalr	a5
    80003d8e:	892a                	mv	s2,a0
    80003d90:	bf75                	j	80003d4c <fileread+0x60>
    panic("fileread");
    80003d92:	00005517          	auipc	a0,0x5
    80003d96:	89e50513          	addi	a0,a0,-1890 # 80008630 <syscalls+0x268>
    80003d9a:	00002097          	auipc	ra,0x2
    80003d9e:	38e080e7          	jalr	910(ra) # 80006128 <panic>
    return -1;
    80003da2:	597d                	li	s2,-1
    80003da4:	b765                	j	80003d4c <fileread+0x60>
      return -1;
    80003da6:	597d                	li	s2,-1
    80003da8:	b755                	j	80003d4c <fileread+0x60>
    80003daa:	597d                	li	s2,-1
    80003dac:	b745                	j	80003d4c <fileread+0x60>

0000000080003dae <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dae:	715d                	addi	sp,sp,-80
    80003db0:	e486                	sd	ra,72(sp)
    80003db2:	e0a2                	sd	s0,64(sp)
    80003db4:	fc26                	sd	s1,56(sp)
    80003db6:	f84a                	sd	s2,48(sp)
    80003db8:	f44e                	sd	s3,40(sp)
    80003dba:	f052                	sd	s4,32(sp)
    80003dbc:	ec56                	sd	s5,24(sp)
    80003dbe:	e85a                	sd	s6,16(sp)
    80003dc0:	e45e                	sd	s7,8(sp)
    80003dc2:	e062                	sd	s8,0(sp)
    80003dc4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dc6:	00954783          	lbu	a5,9(a0)
    80003dca:	10078663          	beqz	a5,80003ed6 <filewrite+0x128>
    80003dce:	892a                	mv	s2,a0
    80003dd0:	8aae                	mv	s5,a1
    80003dd2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd4:	411c                	lw	a5,0(a0)
    80003dd6:	4705                	li	a4,1
    80003dd8:	02e78263          	beq	a5,a4,80003dfc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ddc:	470d                	li	a4,3
    80003dde:	02e78663          	beq	a5,a4,80003e0a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de2:	4709                	li	a4,2
    80003de4:	0ee79163          	bne	a5,a4,80003ec6 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de8:	0ac05d63          	blez	a2,80003ea2 <filewrite+0xf4>
    int i = 0;
    80003dec:	4981                	li	s3,0
    80003dee:	6b05                	lui	s6,0x1
    80003df0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003df4:	6b85                	lui	s7,0x1
    80003df6:	c00b8b9b          	addiw	s7,s7,-1024
    80003dfa:	a861                	j	80003e92 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dfc:	6908                	ld	a0,16(a0)
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	22e080e7          	jalr	558(ra) # 8000402c <pipewrite>
    80003e06:	8a2a                	mv	s4,a0
    80003e08:	a045                	j	80003ea8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e0a:	02451783          	lh	a5,36(a0)
    80003e0e:	03079693          	slli	a3,a5,0x30
    80003e12:	92c1                	srli	a3,a3,0x30
    80003e14:	4725                	li	a4,9
    80003e16:	0cd76263          	bltu	a4,a3,80003eda <filewrite+0x12c>
    80003e1a:	0792                	slli	a5,a5,0x4
    80003e1c:	0001f717          	auipc	a4,0x1f
    80003e20:	2ac70713          	addi	a4,a4,684 # 800230c8 <devsw>
    80003e24:	97ba                	add	a5,a5,a4
    80003e26:	679c                	ld	a5,8(a5)
    80003e28:	cbdd                	beqz	a5,80003ede <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e2a:	4505                	li	a0,1
    80003e2c:	9782                	jalr	a5
    80003e2e:	8a2a                	mv	s4,a0
    80003e30:	a8a5                	j	80003ea8 <filewrite+0xfa>
    80003e32:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	8b0080e7          	jalr	-1872(ra) # 800036e6 <begin_op>
      ilock(f->ip);
    80003e3e:	01893503          	ld	a0,24(s2)
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	ed2080e7          	jalr	-302(ra) # 80002d14 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e4a:	8762                	mv	a4,s8
    80003e4c:	02092683          	lw	a3,32(s2)
    80003e50:	01598633          	add	a2,s3,s5
    80003e54:	4585                	li	a1,1
    80003e56:	01893503          	ld	a0,24(s2)
    80003e5a:	fffff097          	auipc	ra,0xfffff
    80003e5e:	266080e7          	jalr	614(ra) # 800030c0 <writei>
    80003e62:	84aa                	mv	s1,a0
    80003e64:	00a05763          	blez	a0,80003e72 <filewrite+0xc4>
        f->off += r;
    80003e68:	02092783          	lw	a5,32(s2)
    80003e6c:	9fa9                	addw	a5,a5,a0
    80003e6e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e72:	01893503          	ld	a0,24(s2)
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	f60080e7          	jalr	-160(ra) # 80002dd6 <iunlock>
      end_op();
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	8e8080e7          	jalr	-1816(ra) # 80003766 <end_op>

      if(r != n1){
    80003e86:	009c1f63          	bne	s8,s1,80003ea4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e8a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e8e:	0149db63          	bge	s3,s4,80003ea4 <filewrite+0xf6>
      int n1 = n - i;
    80003e92:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e96:	84be                	mv	s1,a5
    80003e98:	2781                	sext.w	a5,a5
    80003e9a:	f8fb5ce3          	bge	s6,a5,80003e32 <filewrite+0x84>
    80003e9e:	84de                	mv	s1,s7
    80003ea0:	bf49                	j	80003e32 <filewrite+0x84>
    int i = 0;
    80003ea2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ea4:	013a1f63          	bne	s4,s3,80003ec2 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea8:	8552                	mv	a0,s4
    80003eaa:	60a6                	ld	ra,72(sp)
    80003eac:	6406                	ld	s0,64(sp)
    80003eae:	74e2                	ld	s1,56(sp)
    80003eb0:	7942                	ld	s2,48(sp)
    80003eb2:	79a2                	ld	s3,40(sp)
    80003eb4:	7a02                	ld	s4,32(sp)
    80003eb6:	6ae2                	ld	s5,24(sp)
    80003eb8:	6b42                	ld	s6,16(sp)
    80003eba:	6ba2                	ld	s7,8(sp)
    80003ebc:	6c02                	ld	s8,0(sp)
    80003ebe:	6161                	addi	sp,sp,80
    80003ec0:	8082                	ret
    ret = (i == n ? n : -1);
    80003ec2:	5a7d                	li	s4,-1
    80003ec4:	b7d5                	j	80003ea8 <filewrite+0xfa>
    panic("filewrite");
    80003ec6:	00004517          	auipc	a0,0x4
    80003eca:	77a50513          	addi	a0,a0,1914 # 80008640 <syscalls+0x278>
    80003ece:	00002097          	auipc	ra,0x2
    80003ed2:	25a080e7          	jalr	602(ra) # 80006128 <panic>
    return -1;
    80003ed6:	5a7d                	li	s4,-1
    80003ed8:	bfc1                	j	80003ea8 <filewrite+0xfa>
      return -1;
    80003eda:	5a7d                	li	s4,-1
    80003edc:	b7f1                	j	80003ea8 <filewrite+0xfa>
    80003ede:	5a7d                	li	s4,-1
    80003ee0:	b7e1                	j	80003ea8 <filewrite+0xfa>

0000000080003ee2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ee2:	7179                	addi	sp,sp,-48
    80003ee4:	f406                	sd	ra,40(sp)
    80003ee6:	f022                	sd	s0,32(sp)
    80003ee8:	ec26                	sd	s1,24(sp)
    80003eea:	e84a                	sd	s2,16(sp)
    80003eec:	e44e                	sd	s3,8(sp)
    80003eee:	e052                	sd	s4,0(sp)
    80003ef0:	1800                	addi	s0,sp,48
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef6:	0005b023          	sd	zero,0(a1)
    80003efa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	bf8080e7          	jalr	-1032(ra) # 80003af6 <filealloc>
    80003f06:	e088                	sd	a0,0(s1)
    80003f08:	c551                	beqz	a0,80003f94 <pipealloc+0xb2>
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	bec080e7          	jalr	-1044(ra) # 80003af6 <filealloc>
    80003f12:	00aa3023          	sd	a0,0(s4)
    80003f16:	c92d                	beqz	a0,80003f88 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f18:	ffffc097          	auipc	ra,0xffffc
    80003f1c:	200080e7          	jalr	512(ra) # 80000118 <kalloc>
    80003f20:	892a                	mv	s2,a0
    80003f22:	c125                	beqz	a0,80003f82 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f24:	4985                	li	s3,1
    80003f26:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f2a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f2e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f32:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f36:	00004597          	auipc	a1,0x4
    80003f3a:	71a58593          	addi	a1,a1,1818 # 80008650 <syscalls+0x288>
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	6a4080e7          	jalr	1700(ra) # 800065e2 <initlock>
  (*f0)->type = FD_PIPE;
    80003f46:	609c                	ld	a5,0(s1)
    80003f48:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f4c:	609c                	ld	a5,0(s1)
    80003f4e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f52:	609c                	ld	a5,0(s1)
    80003f54:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f58:	609c                	ld	a5,0(s1)
    80003f5a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f5e:	000a3783          	ld	a5,0(s4)
    80003f62:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f66:	000a3783          	ld	a5,0(s4)
    80003f6a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f6e:	000a3783          	ld	a5,0(s4)
    80003f72:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f76:	000a3783          	ld	a5,0(s4)
    80003f7a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f7e:	4501                	li	a0,0
    80003f80:	a025                	j	80003fa8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f82:	6088                	ld	a0,0(s1)
    80003f84:	e501                	bnez	a0,80003f8c <pipealloc+0xaa>
    80003f86:	a039                	j	80003f94 <pipealloc+0xb2>
    80003f88:	6088                	ld	a0,0(s1)
    80003f8a:	c51d                	beqz	a0,80003fb8 <pipealloc+0xd6>
    fileclose(*f0);
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	c26080e7          	jalr	-986(ra) # 80003bb2 <fileclose>
  if(*f1)
    80003f94:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f98:	557d                	li	a0,-1
  if(*f1)
    80003f9a:	c799                	beqz	a5,80003fa8 <pipealloc+0xc6>
    fileclose(*f1);
    80003f9c:	853e                	mv	a0,a5
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	c14080e7          	jalr	-1004(ra) # 80003bb2 <fileclose>
  return -1;
    80003fa6:	557d                	li	a0,-1
}
    80003fa8:	70a2                	ld	ra,40(sp)
    80003faa:	7402                	ld	s0,32(sp)
    80003fac:	64e2                	ld	s1,24(sp)
    80003fae:	6942                	ld	s2,16(sp)
    80003fb0:	69a2                	ld	s3,8(sp)
    80003fb2:	6a02                	ld	s4,0(sp)
    80003fb4:	6145                	addi	sp,sp,48
    80003fb6:	8082                	ret
  return -1;
    80003fb8:	557d                	li	a0,-1
    80003fba:	b7fd                	j	80003fa8 <pipealloc+0xc6>

0000000080003fbc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fbc:	1101                	addi	sp,sp,-32
    80003fbe:	ec06                	sd	ra,24(sp)
    80003fc0:	e822                	sd	s0,16(sp)
    80003fc2:	e426                	sd	s1,8(sp)
    80003fc4:	e04a                	sd	s2,0(sp)
    80003fc6:	1000                	addi	s0,sp,32
    80003fc8:	84aa                	mv	s1,a0
    80003fca:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fcc:	00002097          	auipc	ra,0x2
    80003fd0:	6a6080e7          	jalr	1702(ra) # 80006672 <acquire>
  if(writable){
    80003fd4:	02090d63          	beqz	s2,8000400e <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fdc:	21848513          	addi	a0,s1,536
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	720080e7          	jalr	1824(ra) # 80001700 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe8:	2204b783          	ld	a5,544(s1)
    80003fec:	eb95                	bnez	a5,80004020 <pipeclose+0x64>
    release(&pi->lock);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	736080e7          	jalr	1846(ra) # 80006726 <release>
    kfree((char*)pi);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	ffffc097          	auipc	ra,0xffffc
    80003ffe:	022080e7          	jalr	34(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004002:	60e2                	ld	ra,24(sp)
    80004004:	6442                	ld	s0,16(sp)
    80004006:	64a2                	ld	s1,8(sp)
    80004008:	6902                	ld	s2,0(sp)
    8000400a:	6105                	addi	sp,sp,32
    8000400c:	8082                	ret
    pi->readopen = 0;
    8000400e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004012:	21c48513          	addi	a0,s1,540
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	6ea080e7          	jalr	1770(ra) # 80001700 <wakeup>
    8000401e:	b7e9                	j	80003fe8 <pipeclose+0x2c>
    release(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	704080e7          	jalr	1796(ra) # 80006726 <release>
}
    8000402a:	bfe1                	j	80004002 <pipeclose+0x46>

000000008000402c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000402c:	7159                	addi	sp,sp,-112
    8000402e:	f486                	sd	ra,104(sp)
    80004030:	f0a2                	sd	s0,96(sp)
    80004032:	eca6                	sd	s1,88(sp)
    80004034:	e8ca                	sd	s2,80(sp)
    80004036:	e4ce                	sd	s3,72(sp)
    80004038:	e0d2                	sd	s4,64(sp)
    8000403a:	fc56                	sd	s5,56(sp)
    8000403c:	f85a                	sd	s6,48(sp)
    8000403e:	f45e                	sd	s7,40(sp)
    80004040:	f062                	sd	s8,32(sp)
    80004042:	ec66                	sd	s9,24(sp)
    80004044:	1880                	addi	s0,sp,112
    80004046:	84aa                	mv	s1,a0
    80004048:	8aae                	mv	s5,a1
    8000404a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	dfc080e7          	jalr	-516(ra) # 80000e48 <myproc>
    80004054:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004056:	8526                	mv	a0,s1
    80004058:	00002097          	auipc	ra,0x2
    8000405c:	61a080e7          	jalr	1562(ra) # 80006672 <acquire>
  while(i < n){
    80004060:	0d405163          	blez	s4,80004122 <pipewrite+0xf6>
    80004064:	8ba6                	mv	s7,s1
  int i = 0;
    80004066:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004068:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000406a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000406e:	21c48c13          	addi	s8,s1,540
    80004072:	a08d                	j	800040d4 <pipewrite+0xa8>
      release(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	6b0080e7          	jalr	1712(ra) # 80006726 <release>
      return -1;
    8000407e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004080:	854a                	mv	a0,s2
    80004082:	70a6                	ld	ra,104(sp)
    80004084:	7406                	ld	s0,96(sp)
    80004086:	64e6                	ld	s1,88(sp)
    80004088:	6946                	ld	s2,80(sp)
    8000408a:	69a6                	ld	s3,72(sp)
    8000408c:	6a06                	ld	s4,64(sp)
    8000408e:	7ae2                	ld	s5,56(sp)
    80004090:	7b42                	ld	s6,48(sp)
    80004092:	7ba2                	ld	s7,40(sp)
    80004094:	7c02                	ld	s8,32(sp)
    80004096:	6ce2                	ld	s9,24(sp)
    80004098:	6165                	addi	sp,sp,112
    8000409a:	8082                	ret
      wakeup(&pi->nread);
    8000409c:	8566                	mv	a0,s9
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	662080e7          	jalr	1634(ra) # 80001700 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040a6:	85de                	mv	a1,s7
    800040a8:	8562                	mv	a0,s8
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	4ca080e7          	jalr	1226(ra) # 80001574 <sleep>
    800040b2:	a839                	j	800040d0 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040b4:	21c4a783          	lw	a5,540(s1)
    800040b8:	0017871b          	addiw	a4,a5,1
    800040bc:	20e4ae23          	sw	a4,540(s1)
    800040c0:	1ff7f793          	andi	a5,a5,511
    800040c4:	97a6                	add	a5,a5,s1
    800040c6:	f9f44703          	lbu	a4,-97(s0)
    800040ca:	00e78c23          	sb	a4,24(a5)
      i++;
    800040ce:	2905                	addiw	s2,s2,1
  while(i < n){
    800040d0:	03495d63          	bge	s2,s4,8000410a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040d4:	2204a783          	lw	a5,544(s1)
    800040d8:	dfd1                	beqz	a5,80004074 <pipewrite+0x48>
    800040da:	0289a783          	lw	a5,40(s3)
    800040de:	fbd9                	bnez	a5,80004074 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040e0:	2184a783          	lw	a5,536(s1)
    800040e4:	21c4a703          	lw	a4,540(s1)
    800040e8:	2007879b          	addiw	a5,a5,512
    800040ec:	faf708e3          	beq	a4,a5,8000409c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040f0:	4685                	li	a3,1
    800040f2:	01590633          	add	a2,s2,s5
    800040f6:	f9f40593          	addi	a1,s0,-97
    800040fa:	0509b503          	ld	a0,80(s3)
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	a98080e7          	jalr	-1384(ra) # 80000b96 <copyin>
    80004106:	fb6517e3          	bne	a0,s6,800040b4 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000410a:	21848513          	addi	a0,s1,536
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	5f2080e7          	jalr	1522(ra) # 80001700 <wakeup>
  release(&pi->lock);
    80004116:	8526                	mv	a0,s1
    80004118:	00002097          	auipc	ra,0x2
    8000411c:	60e080e7          	jalr	1550(ra) # 80006726 <release>
  return i;
    80004120:	b785                	j	80004080 <pipewrite+0x54>
  int i = 0;
    80004122:	4901                	li	s2,0
    80004124:	b7dd                	j	8000410a <pipewrite+0xde>

0000000080004126 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004126:	715d                	addi	sp,sp,-80
    80004128:	e486                	sd	ra,72(sp)
    8000412a:	e0a2                	sd	s0,64(sp)
    8000412c:	fc26                	sd	s1,56(sp)
    8000412e:	f84a                	sd	s2,48(sp)
    80004130:	f44e                	sd	s3,40(sp)
    80004132:	f052                	sd	s4,32(sp)
    80004134:	ec56                	sd	s5,24(sp)
    80004136:	e85a                	sd	s6,16(sp)
    80004138:	0880                	addi	s0,sp,80
    8000413a:	84aa                	mv	s1,a0
    8000413c:	892e                	mv	s2,a1
    8000413e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	d08080e7          	jalr	-760(ra) # 80000e48 <myproc>
    80004148:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000414a:	8b26                	mv	s6,s1
    8000414c:	8526                	mv	a0,s1
    8000414e:	00002097          	auipc	ra,0x2
    80004152:	524080e7          	jalr	1316(ra) # 80006672 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004156:	2184a703          	lw	a4,536(s1)
    8000415a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000415e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004162:	02f71463          	bne	a4,a5,8000418a <piperead+0x64>
    80004166:	2244a783          	lw	a5,548(s1)
    8000416a:	c385                	beqz	a5,8000418a <piperead+0x64>
    if(pr->killed){
    8000416c:	028a2783          	lw	a5,40(s4)
    80004170:	ebc1                	bnez	a5,80004200 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004172:	85da                	mv	a1,s6
    80004174:	854e                	mv	a0,s3
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	3fe080e7          	jalr	1022(ra) # 80001574 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000417e:	2184a703          	lw	a4,536(s1)
    80004182:	21c4a783          	lw	a5,540(s1)
    80004186:	fef700e3          	beq	a4,a5,80004166 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000418a:	09505263          	blez	s5,8000420e <piperead+0xe8>
    8000418e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004190:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004192:	2184a783          	lw	a5,536(s1)
    80004196:	21c4a703          	lw	a4,540(s1)
    8000419a:	02f70d63          	beq	a4,a5,800041d4 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000419e:	0017871b          	addiw	a4,a5,1
    800041a2:	20e4ac23          	sw	a4,536(s1)
    800041a6:	1ff7f793          	andi	a5,a5,511
    800041aa:	97a6                	add	a5,a5,s1
    800041ac:	0187c783          	lbu	a5,24(a5)
    800041b0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041b4:	4685                	li	a3,1
    800041b6:	fbf40613          	addi	a2,s0,-65
    800041ba:	85ca                	mv	a1,s2
    800041bc:	050a3503          	ld	a0,80(s4)
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	94a080e7          	jalr	-1718(ra) # 80000b0a <copyout>
    800041c8:	01650663          	beq	a0,s6,800041d4 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041cc:	2985                	addiw	s3,s3,1
    800041ce:	0905                	addi	s2,s2,1
    800041d0:	fd3a91e3          	bne	s5,s3,80004192 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041d4:	21c48513          	addi	a0,s1,540
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	528080e7          	jalr	1320(ra) # 80001700 <wakeup>
  release(&pi->lock);
    800041e0:	8526                	mv	a0,s1
    800041e2:	00002097          	auipc	ra,0x2
    800041e6:	544080e7          	jalr	1348(ra) # 80006726 <release>
  return i;
}
    800041ea:	854e                	mv	a0,s3
    800041ec:	60a6                	ld	ra,72(sp)
    800041ee:	6406                	ld	s0,64(sp)
    800041f0:	74e2                	ld	s1,56(sp)
    800041f2:	7942                	ld	s2,48(sp)
    800041f4:	79a2                	ld	s3,40(sp)
    800041f6:	7a02                	ld	s4,32(sp)
    800041f8:	6ae2                	ld	s5,24(sp)
    800041fa:	6b42                	ld	s6,16(sp)
    800041fc:	6161                	addi	sp,sp,80
    800041fe:	8082                	ret
      release(&pi->lock);
    80004200:	8526                	mv	a0,s1
    80004202:	00002097          	auipc	ra,0x2
    80004206:	524080e7          	jalr	1316(ra) # 80006726 <release>
      return -1;
    8000420a:	59fd                	li	s3,-1
    8000420c:	bff9                	j	800041ea <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420e:	4981                	li	s3,0
    80004210:	b7d1                	j	800041d4 <piperead+0xae>

0000000080004212 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004212:	df010113          	addi	sp,sp,-528
    80004216:	20113423          	sd	ra,520(sp)
    8000421a:	20813023          	sd	s0,512(sp)
    8000421e:	ffa6                	sd	s1,504(sp)
    80004220:	fbca                	sd	s2,496(sp)
    80004222:	f7ce                	sd	s3,488(sp)
    80004224:	f3d2                	sd	s4,480(sp)
    80004226:	efd6                	sd	s5,472(sp)
    80004228:	ebda                	sd	s6,464(sp)
    8000422a:	e7de                	sd	s7,456(sp)
    8000422c:	e3e2                	sd	s8,448(sp)
    8000422e:	ff66                	sd	s9,440(sp)
    80004230:	fb6a                	sd	s10,432(sp)
    80004232:	f76e                	sd	s11,424(sp)
    80004234:	0c00                	addi	s0,sp,528
    80004236:	84aa                	mv	s1,a0
    80004238:	dea43c23          	sd	a0,-520(s0)
    8000423c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	c08080e7          	jalr	-1016(ra) # 80000e48 <myproc>
    80004248:	892a                	mv	s2,a0

  begin_op();
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	49c080e7          	jalr	1180(ra) # 800036e6 <begin_op>

  if((ip = namei(path)) == 0){
    80004252:	8526                	mv	a0,s1
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	276080e7          	jalr	630(ra) # 800034ca <namei>
    8000425c:	c92d                	beqz	a0,800042ce <exec+0xbc>
    8000425e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	ab4080e7          	jalr	-1356(ra) # 80002d14 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004268:	04000713          	li	a4,64
    8000426c:	4681                	li	a3,0
    8000426e:	e5040613          	addi	a2,s0,-432
    80004272:	4581                	li	a1,0
    80004274:	8526                	mv	a0,s1
    80004276:	fffff097          	auipc	ra,0xfffff
    8000427a:	d52080e7          	jalr	-686(ra) # 80002fc8 <readi>
    8000427e:	04000793          	li	a5,64
    80004282:	00f51a63          	bne	a0,a5,80004296 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004286:	e5042703          	lw	a4,-432(s0)
    8000428a:	464c47b7          	lui	a5,0x464c4
    8000428e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004292:	04f70463          	beq	a4,a5,800042da <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004296:	8526                	mv	a0,s1
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	cde080e7          	jalr	-802(ra) # 80002f76 <iunlockput>
    end_op();
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	4c6080e7          	jalr	1222(ra) # 80003766 <end_op>
  }
  return -1;
    800042a8:	557d                	li	a0,-1
}
    800042aa:	20813083          	ld	ra,520(sp)
    800042ae:	20013403          	ld	s0,512(sp)
    800042b2:	74fe                	ld	s1,504(sp)
    800042b4:	795e                	ld	s2,496(sp)
    800042b6:	79be                	ld	s3,488(sp)
    800042b8:	7a1e                	ld	s4,480(sp)
    800042ba:	6afe                	ld	s5,472(sp)
    800042bc:	6b5e                	ld	s6,464(sp)
    800042be:	6bbe                	ld	s7,456(sp)
    800042c0:	6c1e                	ld	s8,448(sp)
    800042c2:	7cfa                	ld	s9,440(sp)
    800042c4:	7d5a                	ld	s10,432(sp)
    800042c6:	7dba                	ld	s11,424(sp)
    800042c8:	21010113          	addi	sp,sp,528
    800042cc:	8082                	ret
    end_op();
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	498080e7          	jalr	1176(ra) # 80003766 <end_op>
    return -1;
    800042d6:	557d                	li	a0,-1
    800042d8:	bfc9                	j	800042aa <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042da:	854a                	mv	a0,s2
    800042dc:	ffffd097          	auipc	ra,0xffffd
    800042e0:	c30080e7          	jalr	-976(ra) # 80000f0c <proc_pagetable>
    800042e4:	8baa                	mv	s7,a0
    800042e6:	d945                	beqz	a0,80004296 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e8:	e7042983          	lw	s3,-400(s0)
    800042ec:	e8845783          	lhu	a5,-376(s0)
    800042f0:	c7ad                	beqz	a5,8000435a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042f2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042f4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042f6:	6c85                	lui	s9,0x1
    800042f8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042fc:	def43823          	sd	a5,-528(s0)
    80004300:	a42d                	j	8000452a <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004302:	00004517          	auipc	a0,0x4
    80004306:	35650513          	addi	a0,a0,854 # 80008658 <syscalls+0x290>
    8000430a:	00002097          	auipc	ra,0x2
    8000430e:	e1e080e7          	jalr	-482(ra) # 80006128 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004312:	8756                	mv	a4,s5
    80004314:	012d86bb          	addw	a3,s11,s2
    80004318:	4581                	li	a1,0
    8000431a:	8526                	mv	a0,s1
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	cac080e7          	jalr	-852(ra) # 80002fc8 <readi>
    80004324:	2501                	sext.w	a0,a0
    80004326:	1aaa9963          	bne	s5,a0,800044d8 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000432a:	6785                	lui	a5,0x1
    8000432c:	0127893b          	addw	s2,a5,s2
    80004330:	77fd                	lui	a5,0xfffff
    80004332:	01478a3b          	addw	s4,a5,s4
    80004336:	1f897163          	bgeu	s2,s8,80004518 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000433a:	02091593          	slli	a1,s2,0x20
    8000433e:	9181                	srli	a1,a1,0x20
    80004340:	95ea                	add	a1,a1,s10
    80004342:	855e                	mv	a0,s7
    80004344:	ffffc097          	auipc	ra,0xffffc
    80004348:	1c2080e7          	jalr	450(ra) # 80000506 <walkaddr>
    8000434c:	862a                	mv	a2,a0
    if(pa == 0)
    8000434e:	d955                	beqz	a0,80004302 <exec+0xf0>
      n = PGSIZE;
    80004350:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004352:	fd9a70e3          	bgeu	s4,s9,80004312 <exec+0x100>
      n = sz - i;
    80004356:	8ad2                	mv	s5,s4
    80004358:	bf6d                	j	80004312 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000435a:	4901                	li	s2,0
  iunlockput(ip);
    8000435c:	8526                	mv	a0,s1
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	c18080e7          	jalr	-1000(ra) # 80002f76 <iunlockput>
  end_op();
    80004366:	fffff097          	auipc	ra,0xfffff
    8000436a:	400080e7          	jalr	1024(ra) # 80003766 <end_op>
  p = myproc();
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	ada080e7          	jalr	-1318(ra) # 80000e48 <myproc>
    80004376:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004378:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000437c:	6785                	lui	a5,0x1
    8000437e:	17fd                	addi	a5,a5,-1
    80004380:	993e                	add	s2,s2,a5
    80004382:	757d                	lui	a0,0xfffff
    80004384:	00a977b3          	and	a5,s2,a0
    80004388:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000438c:	6609                	lui	a2,0x2
    8000438e:	963e                	add	a2,a2,a5
    80004390:	85be                	mv	a1,a5
    80004392:	855e                	mv	a0,s7
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	526080e7          	jalr	1318(ra) # 800008ba <uvmalloc>
    8000439c:	8b2a                	mv	s6,a0
  ip = 0;
    8000439e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043a0:	12050c63          	beqz	a0,800044d8 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043a4:	75f9                	lui	a1,0xffffe
    800043a6:	95aa                	add	a1,a1,a0
    800043a8:	855e                	mv	a0,s7
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	72e080e7          	jalr	1838(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800043b2:	7c7d                	lui	s8,0xfffff
    800043b4:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b6:	e0043783          	ld	a5,-512(s0)
    800043ba:	6388                	ld	a0,0(a5)
    800043bc:	c535                	beqz	a0,80004428 <exec+0x216>
    800043be:	e9040993          	addi	s3,s0,-368
    800043c2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043c6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	f34080e7          	jalr	-204(ra) # 800002fc <strlen>
    800043d0:	2505                	addiw	a0,a0,1
    800043d2:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d6:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043da:	13896363          	bltu	s2,s8,80004500 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043de:	e0043d83          	ld	s11,-512(s0)
    800043e2:	000dba03          	ld	s4,0(s11)
    800043e6:	8552                	mv	a0,s4
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	f14080e7          	jalr	-236(ra) # 800002fc <strlen>
    800043f0:	0015069b          	addiw	a3,a0,1
    800043f4:	8652                	mv	a2,s4
    800043f6:	85ca                	mv	a1,s2
    800043f8:	855e                	mv	a0,s7
    800043fa:	ffffc097          	auipc	ra,0xffffc
    800043fe:	710080e7          	jalr	1808(ra) # 80000b0a <copyout>
    80004402:	10054363          	bltz	a0,80004508 <exec+0x2f6>
    ustack[argc] = sp;
    80004406:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000440a:	0485                	addi	s1,s1,1
    8000440c:	008d8793          	addi	a5,s11,8
    80004410:	e0f43023          	sd	a5,-512(s0)
    80004414:	008db503          	ld	a0,8(s11)
    80004418:	c911                	beqz	a0,8000442c <exec+0x21a>
    if(argc >= MAXARG)
    8000441a:	09a1                	addi	s3,s3,8
    8000441c:	fb3c96e3          	bne	s9,s3,800043c8 <exec+0x1b6>
  sz = sz1;
    80004420:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004424:	4481                	li	s1,0
    80004426:	a84d                	j	800044d8 <exec+0x2c6>
  sp = sz;
    80004428:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000442a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000442c:	00349793          	slli	a5,s1,0x3
    80004430:	f9040713          	addi	a4,s0,-112
    80004434:	97ba                	add	a5,a5,a4
    80004436:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000443a:	00148693          	addi	a3,s1,1
    8000443e:	068e                	slli	a3,a3,0x3
    80004440:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004444:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004448:	01897663          	bgeu	s2,s8,80004454 <exec+0x242>
  sz = sz1;
    8000444c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004450:	4481                	li	s1,0
    80004452:	a059                	j	800044d8 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004454:	e9040613          	addi	a2,s0,-368
    80004458:	85ca                	mv	a1,s2
    8000445a:	855e                	mv	a0,s7
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	6ae080e7          	jalr	1710(ra) # 80000b0a <copyout>
    80004464:	0a054663          	bltz	a0,80004510 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004468:	058ab783          	ld	a5,88(s5)
    8000446c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004470:	df843783          	ld	a5,-520(s0)
    80004474:	0007c703          	lbu	a4,0(a5)
    80004478:	cf11                	beqz	a4,80004494 <exec+0x282>
    8000447a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000447c:	02f00693          	li	a3,47
    80004480:	a039                	j	8000448e <exec+0x27c>
      last = s+1;
    80004482:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004486:	0785                	addi	a5,a5,1
    80004488:	fff7c703          	lbu	a4,-1(a5)
    8000448c:	c701                	beqz	a4,80004494 <exec+0x282>
    if(*s == '/')
    8000448e:	fed71ce3          	bne	a4,a3,80004486 <exec+0x274>
    80004492:	bfc5                	j	80004482 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004494:	4641                	li	a2,16
    80004496:	df843583          	ld	a1,-520(s0)
    8000449a:	158a8513          	addi	a0,s5,344
    8000449e:	ffffc097          	auipc	ra,0xffffc
    800044a2:	e2c080e7          	jalr	-468(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800044a6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044aa:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044ae:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044b2:	058ab783          	ld	a5,88(s5)
    800044b6:	e6843703          	ld	a4,-408(s0)
    800044ba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044bc:	058ab783          	ld	a5,88(s5)
    800044c0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c4:	85ea                	mv	a1,s10
    800044c6:	ffffd097          	auipc	ra,0xffffd
    800044ca:	ae2080e7          	jalr	-1310(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ce:	0004851b          	sext.w	a0,s1
    800044d2:	bbe1                	j	800042aa <exec+0x98>
    800044d4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044d8:	e0843583          	ld	a1,-504(s0)
    800044dc:	855e                	mv	a0,s7
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	aca080e7          	jalr	-1334(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800044e6:	da0498e3          	bnez	s1,80004296 <exec+0x84>
  return -1;
    800044ea:	557d                	li	a0,-1
    800044ec:	bb7d                	j	800042aa <exec+0x98>
    800044ee:	e1243423          	sd	s2,-504(s0)
    800044f2:	b7dd                	j	800044d8 <exec+0x2c6>
    800044f4:	e1243423          	sd	s2,-504(s0)
    800044f8:	b7c5                	j	800044d8 <exec+0x2c6>
    800044fa:	e1243423          	sd	s2,-504(s0)
    800044fe:	bfe9                	j	800044d8 <exec+0x2c6>
  sz = sz1;
    80004500:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004504:	4481                	li	s1,0
    80004506:	bfc9                	j	800044d8 <exec+0x2c6>
  sz = sz1;
    80004508:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000450c:	4481                	li	s1,0
    8000450e:	b7e9                	j	800044d8 <exec+0x2c6>
  sz = sz1;
    80004510:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004514:	4481                	li	s1,0
    80004516:	b7c9                	j	800044d8 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004518:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451c:	2b05                	addiw	s6,s6,1
    8000451e:	0389899b          	addiw	s3,s3,56
    80004522:	e8845783          	lhu	a5,-376(s0)
    80004526:	e2fb5be3          	bge	s6,a5,8000435c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000452a:	2981                	sext.w	s3,s3
    8000452c:	03800713          	li	a4,56
    80004530:	86ce                	mv	a3,s3
    80004532:	e1840613          	addi	a2,s0,-488
    80004536:	4581                	li	a1,0
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	a8e080e7          	jalr	-1394(ra) # 80002fc8 <readi>
    80004542:	03800793          	li	a5,56
    80004546:	f8f517e3          	bne	a0,a5,800044d4 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000454a:	e1842783          	lw	a5,-488(s0)
    8000454e:	4705                	li	a4,1
    80004550:	fce796e3          	bne	a5,a4,8000451c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004554:	e4043603          	ld	a2,-448(s0)
    80004558:	e3843783          	ld	a5,-456(s0)
    8000455c:	f8f669e3          	bltu	a2,a5,800044ee <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004560:	e2843783          	ld	a5,-472(s0)
    80004564:	963e                	add	a2,a2,a5
    80004566:	f8f667e3          	bltu	a2,a5,800044f4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000456a:	85ca                	mv	a1,s2
    8000456c:	855e                	mv	a0,s7
    8000456e:	ffffc097          	auipc	ra,0xffffc
    80004572:	34c080e7          	jalr	844(ra) # 800008ba <uvmalloc>
    80004576:	e0a43423          	sd	a0,-504(s0)
    8000457a:	d141                	beqz	a0,800044fa <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000457c:	e2843d03          	ld	s10,-472(s0)
    80004580:	df043783          	ld	a5,-528(s0)
    80004584:	00fd77b3          	and	a5,s10,a5
    80004588:	fba1                	bnez	a5,800044d8 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000458a:	e2042d83          	lw	s11,-480(s0)
    8000458e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004592:	f80c03e3          	beqz	s8,80004518 <exec+0x306>
    80004596:	8a62                	mv	s4,s8
    80004598:	4901                	li	s2,0
    8000459a:	b345                	j	8000433a <exec+0x128>

000000008000459c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000459c:	7179                	addi	sp,sp,-48
    8000459e:	f406                	sd	ra,40(sp)
    800045a0:	f022                	sd	s0,32(sp)
    800045a2:	ec26                	sd	s1,24(sp)
    800045a4:	e84a                	sd	s2,16(sp)
    800045a6:	1800                	addi	s0,sp,48
    800045a8:	892e                	mv	s2,a1
    800045aa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045ac:	fdc40593          	addi	a1,s0,-36
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	bf2080e7          	jalr	-1038(ra) # 800021a2 <argint>
    800045b8:	04054063          	bltz	a0,800045f8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045bc:	fdc42703          	lw	a4,-36(s0)
    800045c0:	47bd                	li	a5,15
    800045c2:	02e7ed63          	bltu	a5,a4,800045fc <argfd+0x60>
    800045c6:	ffffd097          	auipc	ra,0xffffd
    800045ca:	882080e7          	jalr	-1918(ra) # 80000e48 <myproc>
    800045ce:	fdc42703          	lw	a4,-36(s0)
    800045d2:	01a70793          	addi	a5,a4,26
    800045d6:	078e                	slli	a5,a5,0x3
    800045d8:	953e                	add	a0,a0,a5
    800045da:	611c                	ld	a5,0(a0)
    800045dc:	c395                	beqz	a5,80004600 <argfd+0x64>
    return -1;
  if(pfd)
    800045de:	00090463          	beqz	s2,800045e6 <argfd+0x4a>
    *pfd = fd;
    800045e2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e6:	4501                	li	a0,0
  if(pf)
    800045e8:	c091                	beqz	s1,800045ec <argfd+0x50>
    *pf = f;
    800045ea:	e09c                	sd	a5,0(s1)
}
    800045ec:	70a2                	ld	ra,40(sp)
    800045ee:	7402                	ld	s0,32(sp)
    800045f0:	64e2                	ld	s1,24(sp)
    800045f2:	6942                	ld	s2,16(sp)
    800045f4:	6145                	addi	sp,sp,48
    800045f6:	8082                	ret
    return -1;
    800045f8:	557d                	li	a0,-1
    800045fa:	bfcd                	j	800045ec <argfd+0x50>
    return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	b7fd                	j	800045ec <argfd+0x50>
    80004600:	557d                	li	a0,-1
    80004602:	b7ed                	j	800045ec <argfd+0x50>

0000000080004604 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004604:	1101                	addi	sp,sp,-32
    80004606:	ec06                	sd	ra,24(sp)
    80004608:	e822                	sd	s0,16(sp)
    8000460a:	e426                	sd	s1,8(sp)
    8000460c:	1000                	addi	s0,sp,32
    8000460e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004610:	ffffd097          	auipc	ra,0xffffd
    80004614:	838080e7          	jalr	-1992(ra) # 80000e48 <myproc>
    80004618:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000461a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcee90>
    8000461e:	4501                	li	a0,0
    80004620:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004622:	6398                	ld	a4,0(a5)
    80004624:	cb19                	beqz	a4,8000463a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004626:	2505                	addiw	a0,a0,1
    80004628:	07a1                	addi	a5,a5,8
    8000462a:	fed51ce3          	bne	a0,a3,80004622 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000462e:	557d                	li	a0,-1
}
    80004630:	60e2                	ld	ra,24(sp)
    80004632:	6442                	ld	s0,16(sp)
    80004634:	64a2                	ld	s1,8(sp)
    80004636:	6105                	addi	sp,sp,32
    80004638:	8082                	ret
      p->ofile[fd] = f;
    8000463a:	01a50793          	addi	a5,a0,26
    8000463e:	078e                	slli	a5,a5,0x3
    80004640:	963e                	add	a2,a2,a5
    80004642:	e204                	sd	s1,0(a2)
      return fd;
    80004644:	b7f5                	j	80004630 <fdalloc+0x2c>

0000000080004646 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004646:	715d                	addi	sp,sp,-80
    80004648:	e486                	sd	ra,72(sp)
    8000464a:	e0a2                	sd	s0,64(sp)
    8000464c:	fc26                	sd	s1,56(sp)
    8000464e:	f84a                	sd	s2,48(sp)
    80004650:	f44e                	sd	s3,40(sp)
    80004652:	f052                	sd	s4,32(sp)
    80004654:	ec56                	sd	s5,24(sp)
    80004656:	0880                	addi	s0,sp,80
    80004658:	89ae                	mv	s3,a1
    8000465a:	8ab2                	mv	s5,a2
    8000465c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000465e:	fb040593          	addi	a1,s0,-80
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	e86080e7          	jalr	-378(ra) # 800034e8 <nameiparent>
    8000466a:	892a                	mv	s2,a0
    8000466c:	12050f63          	beqz	a0,800047aa <create+0x164>
    return 0;

  ilock(dp);
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	6a4080e7          	jalr	1700(ra) # 80002d14 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004678:	4601                	li	a2,0
    8000467a:	fb040593          	addi	a1,s0,-80
    8000467e:	854a                	mv	a0,s2
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	b78080e7          	jalr	-1160(ra) # 800031f8 <dirlookup>
    80004688:	84aa                	mv	s1,a0
    8000468a:	c921                	beqz	a0,800046da <create+0x94>
    iunlockput(dp);
    8000468c:	854a                	mv	a0,s2
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	8e8080e7          	jalr	-1816(ra) # 80002f76 <iunlockput>
    ilock(ip);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	67c080e7          	jalr	1660(ra) # 80002d14 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046a0:	2981                	sext.w	s3,s3
    800046a2:	4789                	li	a5,2
    800046a4:	02f99463          	bne	s3,a5,800046cc <create+0x86>
    800046a8:	0444d783          	lhu	a5,68(s1)
    800046ac:	37f9                	addiw	a5,a5,-2
    800046ae:	17c2                	slli	a5,a5,0x30
    800046b0:	93c1                	srli	a5,a5,0x30
    800046b2:	4705                	li	a4,1
    800046b4:	00f76c63          	bltu	a4,a5,800046cc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b8:	8526                	mv	a0,s1
    800046ba:	60a6                	ld	ra,72(sp)
    800046bc:	6406                	ld	s0,64(sp)
    800046be:	74e2                	ld	s1,56(sp)
    800046c0:	7942                	ld	s2,48(sp)
    800046c2:	79a2                	ld	s3,40(sp)
    800046c4:	7a02                	ld	s4,32(sp)
    800046c6:	6ae2                	ld	s5,24(sp)
    800046c8:	6161                	addi	sp,sp,80
    800046ca:	8082                	ret
    iunlockput(ip);
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	8a8080e7          	jalr	-1880(ra) # 80002f76 <iunlockput>
    return 0;
    800046d6:	4481                	li	s1,0
    800046d8:	b7c5                	j	800046b8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046da:	85ce                	mv	a1,s3
    800046dc:	00092503          	lw	a0,0(s2)
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	49c080e7          	jalr	1180(ra) # 80002b7c <ialloc>
    800046e8:	84aa                	mv	s1,a0
    800046ea:	c529                	beqz	a0,80004734 <create+0xee>
  ilock(ip);
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	628080e7          	jalr	1576(ra) # 80002d14 <ilock>
  ip->major = major;
    800046f4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046f8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046fc:	4785                	li	a5,1
    800046fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004702:	8526                	mv	a0,s1
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	546080e7          	jalr	1350(ra) # 80002c4a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000470c:	2981                	sext.w	s3,s3
    8000470e:	4785                	li	a5,1
    80004710:	02f98a63          	beq	s3,a5,80004744 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004714:	40d0                	lw	a2,4(s1)
    80004716:	fb040593          	addi	a1,s0,-80
    8000471a:	854a                	mv	a0,s2
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	cec080e7          	jalr	-788(ra) # 80003408 <dirlink>
    80004724:	06054b63          	bltz	a0,8000479a <create+0x154>
  iunlockput(dp);
    80004728:	854a                	mv	a0,s2
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	84c080e7          	jalr	-1972(ra) # 80002f76 <iunlockput>
  return ip;
    80004732:	b759                	j	800046b8 <create+0x72>
    panic("create: ialloc");
    80004734:	00004517          	auipc	a0,0x4
    80004738:	f4450513          	addi	a0,a0,-188 # 80008678 <syscalls+0x2b0>
    8000473c:	00002097          	auipc	ra,0x2
    80004740:	9ec080e7          	jalr	-1556(ra) # 80006128 <panic>
    dp->nlink++;  // for ".."
    80004744:	04a95783          	lhu	a5,74(s2)
    80004748:	2785                	addiw	a5,a5,1
    8000474a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000474e:	854a                	mv	a0,s2
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	4fa080e7          	jalr	1274(ra) # 80002c4a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004758:	40d0                	lw	a2,4(s1)
    8000475a:	00004597          	auipc	a1,0x4
    8000475e:	f2e58593          	addi	a1,a1,-210 # 80008688 <syscalls+0x2c0>
    80004762:	8526                	mv	a0,s1
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	ca4080e7          	jalr	-860(ra) # 80003408 <dirlink>
    8000476c:	00054f63          	bltz	a0,8000478a <create+0x144>
    80004770:	00492603          	lw	a2,4(s2)
    80004774:	00004597          	auipc	a1,0x4
    80004778:	f1c58593          	addi	a1,a1,-228 # 80008690 <syscalls+0x2c8>
    8000477c:	8526                	mv	a0,s1
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	c8a080e7          	jalr	-886(ra) # 80003408 <dirlink>
    80004786:	f80557e3          	bgez	a0,80004714 <create+0xce>
      panic("create dots");
    8000478a:	00004517          	auipc	a0,0x4
    8000478e:	f0e50513          	addi	a0,a0,-242 # 80008698 <syscalls+0x2d0>
    80004792:	00002097          	auipc	ra,0x2
    80004796:	996080e7          	jalr	-1642(ra) # 80006128 <panic>
    panic("create: dirlink");
    8000479a:	00004517          	auipc	a0,0x4
    8000479e:	f0e50513          	addi	a0,a0,-242 # 800086a8 <syscalls+0x2e0>
    800047a2:	00002097          	auipc	ra,0x2
    800047a6:	986080e7          	jalr	-1658(ra) # 80006128 <panic>
    return 0;
    800047aa:	84aa                	mv	s1,a0
    800047ac:	b731                	j	800046b8 <create+0x72>

00000000800047ae <sys_dup>:
{
    800047ae:	7179                	addi	sp,sp,-48
    800047b0:	f406                	sd	ra,40(sp)
    800047b2:	f022                	sd	s0,32(sp)
    800047b4:	ec26                	sd	s1,24(sp)
    800047b6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b8:	fd840613          	addi	a2,s0,-40
    800047bc:	4581                	li	a1,0
    800047be:	4501                	li	a0,0
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	ddc080e7          	jalr	-548(ra) # 8000459c <argfd>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ca:	02054363          	bltz	a0,800047f0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047ce:	fd843503          	ld	a0,-40(s0)
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	e32080e7          	jalr	-462(ra) # 80004604 <fdalloc>
    800047da:	84aa                	mv	s1,a0
    return -1;
    800047dc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047de:	00054963          	bltz	a0,800047f0 <sys_dup+0x42>
  filedup(f);
    800047e2:	fd843503          	ld	a0,-40(s0)
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	37a080e7          	jalr	890(ra) # 80003b60 <filedup>
  return fd;
    800047ee:	87a6                	mv	a5,s1
}
    800047f0:	853e                	mv	a0,a5
    800047f2:	70a2                	ld	ra,40(sp)
    800047f4:	7402                	ld	s0,32(sp)
    800047f6:	64e2                	ld	s1,24(sp)
    800047f8:	6145                	addi	sp,sp,48
    800047fa:	8082                	ret

00000000800047fc <sys_read>:
{
    800047fc:	7179                	addi	sp,sp,-48
    800047fe:	f406                	sd	ra,40(sp)
    80004800:	f022                	sd	s0,32(sp)
    80004802:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004804:	fe840613          	addi	a2,s0,-24
    80004808:	4581                	li	a1,0
    8000480a:	4501                	li	a0,0
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	d90080e7          	jalr	-624(ra) # 8000459c <argfd>
    return -1;
    80004814:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	04054163          	bltz	a0,80004858 <sys_read+0x5c>
    8000481a:	fe440593          	addi	a1,s0,-28
    8000481e:	4509                	li	a0,2
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	982080e7          	jalr	-1662(ra) # 800021a2 <argint>
    return -1;
    80004828:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482a:	02054763          	bltz	a0,80004858 <sys_read+0x5c>
    8000482e:	fd840593          	addi	a1,s0,-40
    80004832:	4505                	li	a0,1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	990080e7          	jalr	-1648(ra) # 800021c4 <argaddr>
    return -1;
    8000483c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483e:	00054d63          	bltz	a0,80004858 <sys_read+0x5c>
  return fileread(f, p, n);
    80004842:	fe442603          	lw	a2,-28(s0)
    80004846:	fd843583          	ld	a1,-40(s0)
    8000484a:	fe843503          	ld	a0,-24(s0)
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	49e080e7          	jalr	1182(ra) # 80003cec <fileread>
    80004856:	87aa                	mv	a5,a0
}
    80004858:	853e                	mv	a0,a5
    8000485a:	70a2                	ld	ra,40(sp)
    8000485c:	7402                	ld	s0,32(sp)
    8000485e:	6145                	addi	sp,sp,48
    80004860:	8082                	ret

0000000080004862 <sys_write>:
{
    80004862:	7179                	addi	sp,sp,-48
    80004864:	f406                	sd	ra,40(sp)
    80004866:	f022                	sd	s0,32(sp)
    80004868:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	fe840613          	addi	a2,s0,-24
    8000486e:	4581                	li	a1,0
    80004870:	4501                	li	a0,0
    80004872:	00000097          	auipc	ra,0x0
    80004876:	d2a080e7          	jalr	-726(ra) # 8000459c <argfd>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	04054163          	bltz	a0,800048be <sys_write+0x5c>
    80004880:	fe440593          	addi	a1,s0,-28
    80004884:	4509                	li	a0,2
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	91c080e7          	jalr	-1764(ra) # 800021a2 <argint>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004890:	02054763          	bltz	a0,800048be <sys_write+0x5c>
    80004894:	fd840593          	addi	a1,s0,-40
    80004898:	4505                	li	a0,1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	92a080e7          	jalr	-1750(ra) # 800021c4 <argaddr>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a4:	00054d63          	bltz	a0,800048be <sys_write+0x5c>
  return filewrite(f, p, n);
    800048a8:	fe442603          	lw	a2,-28(s0)
    800048ac:	fd843583          	ld	a1,-40(s0)
    800048b0:	fe843503          	ld	a0,-24(s0)
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	4fa080e7          	jalr	1274(ra) # 80003dae <filewrite>
    800048bc:	87aa                	mv	a5,a0
}
    800048be:	853e                	mv	a0,a5
    800048c0:	70a2                	ld	ra,40(sp)
    800048c2:	7402                	ld	s0,32(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret

00000000800048c8 <sys_close>:
{
    800048c8:	1101                	addi	sp,sp,-32
    800048ca:	ec06                	sd	ra,24(sp)
    800048cc:	e822                	sd	s0,16(sp)
    800048ce:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048d0:	fe040613          	addi	a2,s0,-32
    800048d4:	fec40593          	addi	a1,s0,-20
    800048d8:	4501                	li	a0,0
    800048da:	00000097          	auipc	ra,0x0
    800048de:	cc2080e7          	jalr	-830(ra) # 8000459c <argfd>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e4:	02054463          	bltz	a0,8000490c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048e8:	ffffc097          	auipc	ra,0xffffc
    800048ec:	560080e7          	jalr	1376(ra) # 80000e48 <myproc>
    800048f0:	fec42783          	lw	a5,-20(s0)
    800048f4:	07e9                	addi	a5,a5,26
    800048f6:	078e                	slli	a5,a5,0x3
    800048f8:	97aa                	add	a5,a5,a0
    800048fa:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048fe:	fe043503          	ld	a0,-32(s0)
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	2b0080e7          	jalr	688(ra) # 80003bb2 <fileclose>
  return 0;
    8000490a:	4781                	li	a5,0
}
    8000490c:	853e                	mv	a0,a5
    8000490e:	60e2                	ld	ra,24(sp)
    80004910:	6442                	ld	s0,16(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret

0000000080004916 <sys_fstat>:
{
    80004916:	1101                	addi	sp,sp,-32
    80004918:	ec06                	sd	ra,24(sp)
    8000491a:	e822                	sd	s0,16(sp)
    8000491c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491e:	fe840613          	addi	a2,s0,-24
    80004922:	4581                	li	a1,0
    80004924:	4501                	li	a0,0
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	c76080e7          	jalr	-906(ra) # 8000459c <argfd>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004930:	02054563          	bltz	a0,8000495a <sys_fstat+0x44>
    80004934:	fe040593          	addi	a1,s0,-32
    80004938:	4505                	li	a0,1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	88a080e7          	jalr	-1910(ra) # 800021c4 <argaddr>
    return -1;
    80004942:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004944:	00054b63          	bltz	a0,8000495a <sys_fstat+0x44>
  return filestat(f, st);
    80004948:	fe043583          	ld	a1,-32(s0)
    8000494c:	fe843503          	ld	a0,-24(s0)
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	32a080e7          	jalr	810(ra) # 80003c7a <filestat>
    80004958:	87aa                	mv	a5,a0
}
    8000495a:	853e                	mv	a0,a5
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	6105                	addi	sp,sp,32
    80004962:	8082                	ret

0000000080004964 <sys_link>:
{
    80004964:	7169                	addi	sp,sp,-304
    80004966:	f606                	sd	ra,296(sp)
    80004968:	f222                	sd	s0,288(sp)
    8000496a:	ee26                	sd	s1,280(sp)
    8000496c:	ea4a                	sd	s2,272(sp)
    8000496e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004970:	08000613          	li	a2,128
    80004974:	ed040593          	addi	a1,s0,-304
    80004978:	4501                	li	a0,0
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	86c080e7          	jalr	-1940(ra) # 800021e6 <argstr>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004984:	10054e63          	bltz	a0,80004aa0 <sys_link+0x13c>
    80004988:	08000613          	li	a2,128
    8000498c:	f5040593          	addi	a1,s0,-176
    80004990:	4505                	li	a0,1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	854080e7          	jalr	-1964(ra) # 800021e6 <argstr>
    return -1;
    8000499a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499c:	10054263          	bltz	a0,80004aa0 <sys_link+0x13c>
  begin_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	d46080e7          	jalr	-698(ra) # 800036e6 <begin_op>
  if((ip = namei(old)) == 0){
    800049a8:	ed040513          	addi	a0,s0,-304
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	b1e080e7          	jalr	-1250(ra) # 800034ca <namei>
    800049b4:	84aa                	mv	s1,a0
    800049b6:	c551                	beqz	a0,80004a42 <sys_link+0xde>
  ilock(ip);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	35c080e7          	jalr	860(ra) # 80002d14 <ilock>
  if(ip->type == T_DIR){
    800049c0:	04449703          	lh	a4,68(s1)
    800049c4:	4785                	li	a5,1
    800049c6:	08f70463          	beq	a4,a5,80004a4e <sys_link+0xea>
  ip->nlink++;
    800049ca:	04a4d783          	lhu	a5,74(s1)
    800049ce:	2785                	addiw	a5,a5,1
    800049d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	274080e7          	jalr	628(ra) # 80002c4a <iupdate>
  iunlock(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	3f6080e7          	jalr	1014(ra) # 80002dd6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e8:	fd040593          	addi	a1,s0,-48
    800049ec:	f5040513          	addi	a0,s0,-176
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	af8080e7          	jalr	-1288(ra) # 800034e8 <nameiparent>
    800049f8:	892a                	mv	s2,a0
    800049fa:	c935                	beqz	a0,80004a6e <sys_link+0x10a>
  ilock(dp);
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	318080e7          	jalr	792(ra) # 80002d14 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a04:	00092703          	lw	a4,0(s2)
    80004a08:	409c                	lw	a5,0(s1)
    80004a0a:	04f71d63          	bne	a4,a5,80004a64 <sys_link+0x100>
    80004a0e:	40d0                	lw	a2,4(s1)
    80004a10:	fd040593          	addi	a1,s0,-48
    80004a14:	854a                	mv	a0,s2
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	9f2080e7          	jalr	-1550(ra) # 80003408 <dirlink>
    80004a1e:	04054363          	bltz	a0,80004a64 <sys_link+0x100>
  iunlockput(dp);
    80004a22:	854a                	mv	a0,s2
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	552080e7          	jalr	1362(ra) # 80002f76 <iunlockput>
  iput(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	4a0080e7          	jalr	1184(ra) # 80002ece <iput>
  end_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	d30080e7          	jalr	-720(ra) # 80003766 <end_op>
  return 0;
    80004a3e:	4781                	li	a5,0
    80004a40:	a085                	j	80004aa0 <sys_link+0x13c>
    end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	d24080e7          	jalr	-732(ra) # 80003766 <end_op>
    return -1;
    80004a4a:	57fd                	li	a5,-1
    80004a4c:	a891                	j	80004aa0 <sys_link+0x13c>
    iunlockput(ip);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	526080e7          	jalr	1318(ra) # 80002f76 <iunlockput>
    end_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	d0e080e7          	jalr	-754(ra) # 80003766 <end_op>
    return -1;
    80004a60:	57fd                	li	a5,-1
    80004a62:	a83d                	j	80004aa0 <sys_link+0x13c>
    iunlockput(dp);
    80004a64:	854a                	mv	a0,s2
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	510080e7          	jalr	1296(ra) # 80002f76 <iunlockput>
  ilock(ip);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	2a4080e7          	jalr	676(ra) # 80002d14 <ilock>
  ip->nlink--;
    80004a78:	04a4d783          	lhu	a5,74(s1)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	1c6080e7          	jalr	454(ra) # 80002c4a <iupdate>
  iunlockput(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	4e8080e7          	jalr	1256(ra) # 80002f76 <iunlockput>
  end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	cd0080e7          	jalr	-816(ra) # 80003766 <end_op>
  return -1;
    80004a9e:	57fd                	li	a5,-1
}
    80004aa0:	853e                	mv	a0,a5
    80004aa2:	70b2                	ld	ra,296(sp)
    80004aa4:	7412                	ld	s0,288(sp)
    80004aa6:	64f2                	ld	s1,280(sp)
    80004aa8:	6952                	ld	s2,272(sp)
    80004aaa:	6155                	addi	sp,sp,304
    80004aac:	8082                	ret

0000000080004aae <sys_unlink>:
{
    80004aae:	7151                	addi	sp,sp,-240
    80004ab0:	f586                	sd	ra,232(sp)
    80004ab2:	f1a2                	sd	s0,224(sp)
    80004ab4:	eda6                	sd	s1,216(sp)
    80004ab6:	e9ca                	sd	s2,208(sp)
    80004ab8:	e5ce                	sd	s3,200(sp)
    80004aba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004abc:	08000613          	li	a2,128
    80004ac0:	f3040593          	addi	a1,s0,-208
    80004ac4:	4501                	li	a0,0
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	720080e7          	jalr	1824(ra) # 800021e6 <argstr>
    80004ace:	18054163          	bltz	a0,80004c50 <sys_unlink+0x1a2>
  begin_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	c14080e7          	jalr	-1004(ra) # 800036e6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ada:	fb040593          	addi	a1,s0,-80
    80004ade:	f3040513          	addi	a0,s0,-208
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	a06080e7          	jalr	-1530(ra) # 800034e8 <nameiparent>
    80004aea:	84aa                	mv	s1,a0
    80004aec:	c979                	beqz	a0,80004bc2 <sys_unlink+0x114>
  ilock(dp);
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	226080e7          	jalr	550(ra) # 80002d14 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af6:	00004597          	auipc	a1,0x4
    80004afa:	b9258593          	addi	a1,a1,-1134 # 80008688 <syscalls+0x2c0>
    80004afe:	fb040513          	addi	a0,s0,-80
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	6dc080e7          	jalr	1756(ra) # 800031de <namecmp>
    80004b0a:	14050a63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
    80004b0e:	00004597          	auipc	a1,0x4
    80004b12:	b8258593          	addi	a1,a1,-1150 # 80008690 <syscalls+0x2c8>
    80004b16:	fb040513          	addi	a0,s0,-80
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	6c4080e7          	jalr	1732(ra) # 800031de <namecmp>
    80004b22:	12050e63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b26:	f2c40613          	addi	a2,s0,-212
    80004b2a:	fb040593          	addi	a1,s0,-80
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	6c8080e7          	jalr	1736(ra) # 800031f8 <dirlookup>
    80004b38:	892a                	mv	s2,a0
    80004b3a:	12050263          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  ilock(ip);
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	1d6080e7          	jalr	470(ra) # 80002d14 <ilock>
  if(ip->nlink < 1)
    80004b46:	04a91783          	lh	a5,74(s2)
    80004b4a:	08f05263          	blez	a5,80004bce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	4785                	li	a5,1
    80004b54:	08f70563          	beq	a4,a5,80004bde <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b58:	4641                	li	a2,16
    80004b5a:	4581                	li	a1,0
    80004b5c:	fc040513          	addi	a0,s0,-64
    80004b60:	ffffb097          	auipc	ra,0xffffb
    80004b64:	618080e7          	jalr	1560(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b68:	4741                	li	a4,16
    80004b6a:	f2c42683          	lw	a3,-212(s0)
    80004b6e:	fc040613          	addi	a2,s0,-64
    80004b72:	4581                	li	a1,0
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	54a080e7          	jalr	1354(ra) # 800030c0 <writei>
    80004b7e:	47c1                	li	a5,16
    80004b80:	0af51563          	bne	a0,a5,80004c2a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b84:	04491703          	lh	a4,68(s2)
    80004b88:	4785                	li	a5,1
    80004b8a:	0af70863          	beq	a4,a5,80004c3a <sys_unlink+0x18c>
  iunlockput(dp);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	3e6080e7          	jalr	998(ra) # 80002f76 <iunlockput>
  ip->nlink--;
    80004b98:	04a95783          	lhu	a5,74(s2)
    80004b9c:	37fd                	addiw	a5,a5,-1
    80004b9e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	0a6080e7          	jalr	166(ra) # 80002c4a <iupdate>
  iunlockput(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	3c8080e7          	jalr	968(ra) # 80002f76 <iunlockput>
  end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	bb0080e7          	jalr	-1104(ra) # 80003766 <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
    80004bc0:	a84d                	j	80004c72 <sys_unlink+0x1c4>
    end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	ba4080e7          	jalr	-1116(ra) # 80003766 <end_op>
    return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	a05d                	j	80004c72 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	aea50513          	addi	a0,a0,-1302 # 800086b8 <syscalls+0x2f0>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	552080e7          	jalr	1362(ra) # 80006128 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bde:	04c92703          	lw	a4,76(s2)
    80004be2:	02000793          	li	a5,32
    80004be6:	f6e7f9e3          	bgeu	a5,a4,80004b58 <sys_unlink+0xaa>
    80004bea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bee:	4741                	li	a4,16
    80004bf0:	86ce                	mv	a3,s3
    80004bf2:	f1840613          	addi	a2,s0,-232
    80004bf6:	4581                	li	a1,0
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	3ce080e7          	jalr	974(ra) # 80002fc8 <readi>
    80004c02:	47c1                	li	a5,16
    80004c04:	00f51b63          	bne	a0,a5,80004c1a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c08:	f1845783          	lhu	a5,-232(s0)
    80004c0c:	e7a1                	bnez	a5,80004c54 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0e:	29c1                	addiw	s3,s3,16
    80004c10:	04c92783          	lw	a5,76(s2)
    80004c14:	fcf9ede3          	bltu	s3,a5,80004bee <sys_unlink+0x140>
    80004c18:	b781                	j	80004b58 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c1a:	00004517          	auipc	a0,0x4
    80004c1e:	ab650513          	addi	a0,a0,-1354 # 800086d0 <syscalls+0x308>
    80004c22:	00001097          	auipc	ra,0x1
    80004c26:	506080e7          	jalr	1286(ra) # 80006128 <panic>
    panic("unlink: writei");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	abe50513          	addi	a0,a0,-1346 # 800086e8 <syscalls+0x320>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	4f6080e7          	jalr	1270(ra) # 80006128 <panic>
    dp->nlink--;
    80004c3a:	04a4d783          	lhu	a5,74(s1)
    80004c3e:	37fd                	addiw	a5,a5,-1
    80004c40:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	004080e7          	jalr	4(ra) # 80002c4a <iupdate>
    80004c4e:	b781                	j	80004b8e <sys_unlink+0xe0>
    return -1;
    80004c50:	557d                	li	a0,-1
    80004c52:	a005                	j	80004c72 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	320080e7          	jalr	800(ra) # 80002f76 <iunlockput>
  iunlockput(dp);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	316080e7          	jalr	790(ra) # 80002f76 <iunlockput>
  end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	afe080e7          	jalr	-1282(ra) # 80003766 <end_op>
  return -1;
    80004c70:	557d                	li	a0,-1
}
    80004c72:	70ae                	ld	ra,232(sp)
    80004c74:	740e                	ld	s0,224(sp)
    80004c76:	64ee                	ld	s1,216(sp)
    80004c78:	694e                	ld	s2,208(sp)
    80004c7a:	69ae                	ld	s3,200(sp)
    80004c7c:	616d                	addi	sp,sp,240
    80004c7e:	8082                	ret

0000000080004c80 <sys_open>:

uint64
sys_open(void)
{
    80004c80:	7131                	addi	sp,sp,-192
    80004c82:	fd06                	sd	ra,184(sp)
    80004c84:	f922                	sd	s0,176(sp)
    80004c86:	f526                	sd	s1,168(sp)
    80004c88:	f14a                	sd	s2,160(sp)
    80004c8a:	ed4e                	sd	s3,152(sp)
    80004c8c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c8e:	08000613          	li	a2,128
    80004c92:	f5040593          	addi	a1,s0,-176
    80004c96:	4501                	li	a0,0
    80004c98:	ffffd097          	auipc	ra,0xffffd
    80004c9c:	54e080e7          	jalr	1358(ra) # 800021e6 <argstr>
    return -1;
    80004ca0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca2:	0c054163          	bltz	a0,80004d64 <sys_open+0xe4>
    80004ca6:	f4c40593          	addi	a1,s0,-180
    80004caa:	4505                	li	a0,1
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	4f6080e7          	jalr	1270(ra) # 800021a2 <argint>
    80004cb4:	0a054863          	bltz	a0,80004d64 <sys_open+0xe4>

  begin_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	a2e080e7          	jalr	-1490(ra) # 800036e6 <begin_op>

  if(omode & O_CREATE){
    80004cc0:	f4c42783          	lw	a5,-180(s0)
    80004cc4:	2007f793          	andi	a5,a5,512
    80004cc8:	cbdd                	beqz	a5,80004d7e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cca:	4681                	li	a3,0
    80004ccc:	4601                	li	a2,0
    80004cce:	4589                	li	a1,2
    80004cd0:	f5040513          	addi	a0,s0,-176
    80004cd4:	00000097          	auipc	ra,0x0
    80004cd8:	972080e7          	jalr	-1678(ra) # 80004646 <create>
    80004cdc:	892a                	mv	s2,a0
    if(ip == 0){
    80004cde:	c959                	beqz	a0,80004d74 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ce0:	04491703          	lh	a4,68(s2)
    80004ce4:	478d                	li	a5,3
    80004ce6:	00f71763          	bne	a4,a5,80004cf4 <sys_open+0x74>
    80004cea:	04695703          	lhu	a4,70(s2)
    80004cee:	47a5                	li	a5,9
    80004cf0:	0ce7ec63          	bltu	a5,a4,80004dc8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	e02080e7          	jalr	-510(ra) # 80003af6 <filealloc>
    80004cfc:	89aa                	mv	s3,a0
    80004cfe:	10050263          	beqz	a0,80004e02 <sys_open+0x182>
    80004d02:	00000097          	auipc	ra,0x0
    80004d06:	902080e7          	jalr	-1790(ra) # 80004604 <fdalloc>
    80004d0a:	84aa                	mv	s1,a0
    80004d0c:	0e054663          	bltz	a0,80004df8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d10:	04491703          	lh	a4,68(s2)
    80004d14:	478d                	li	a5,3
    80004d16:	0cf70463          	beq	a4,a5,80004dde <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d1a:	4789                	li	a5,2
    80004d1c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d20:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d24:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d28:	f4c42783          	lw	a5,-180(s0)
    80004d2c:	0017c713          	xori	a4,a5,1
    80004d30:	8b05                	andi	a4,a4,1
    80004d32:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d36:	0037f713          	andi	a4,a5,3
    80004d3a:	00e03733          	snez	a4,a4
    80004d3e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d42:	4007f793          	andi	a5,a5,1024
    80004d46:	c791                	beqz	a5,80004d52 <sys_open+0xd2>
    80004d48:	04491703          	lh	a4,68(s2)
    80004d4c:	4789                	li	a5,2
    80004d4e:	08f70f63          	beq	a4,a5,80004dec <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d52:	854a                	mv	a0,s2
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	082080e7          	jalr	130(ra) # 80002dd6 <iunlock>
  end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	a0a080e7          	jalr	-1526(ra) # 80003766 <end_op>

  return fd;
}
    80004d64:	8526                	mv	a0,s1
    80004d66:	70ea                	ld	ra,184(sp)
    80004d68:	744a                	ld	s0,176(sp)
    80004d6a:	74aa                	ld	s1,168(sp)
    80004d6c:	790a                	ld	s2,160(sp)
    80004d6e:	69ea                	ld	s3,152(sp)
    80004d70:	6129                	addi	sp,sp,192
    80004d72:	8082                	ret
      end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	9f2080e7          	jalr	-1550(ra) # 80003766 <end_op>
      return -1;
    80004d7c:	b7e5                	j	80004d64 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d7e:	f5040513          	addi	a0,s0,-176
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	748080e7          	jalr	1864(ra) # 800034ca <namei>
    80004d8a:	892a                	mv	s2,a0
    80004d8c:	c905                	beqz	a0,80004dbc <sys_open+0x13c>
    ilock(ip);
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	f86080e7          	jalr	-122(ra) # 80002d14 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d96:	04491703          	lh	a4,68(s2)
    80004d9a:	4785                	li	a5,1
    80004d9c:	f4f712e3          	bne	a4,a5,80004ce0 <sys_open+0x60>
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	dba1                	beqz	a5,80004cf4 <sys_open+0x74>
      iunlockput(ip);
    80004da6:	854a                	mv	a0,s2
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	1ce080e7          	jalr	462(ra) # 80002f76 <iunlockput>
      end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	9b6080e7          	jalr	-1610(ra) # 80003766 <end_op>
      return -1;
    80004db8:	54fd                	li	s1,-1
    80004dba:	b76d                	j	80004d64 <sys_open+0xe4>
      end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	9aa080e7          	jalr	-1622(ra) # 80003766 <end_op>
      return -1;
    80004dc4:	54fd                	li	s1,-1
    80004dc6:	bf79                	j	80004d64 <sys_open+0xe4>
    iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	1ac080e7          	jalr	428(ra) # 80002f76 <iunlockput>
    end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	994080e7          	jalr	-1644(ra) # 80003766 <end_op>
    return -1;
    80004dda:	54fd                	li	s1,-1
    80004ddc:	b761                	j	80004d64 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dde:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004de2:	04691783          	lh	a5,70(s2)
    80004de6:	02f99223          	sh	a5,36(s3)
    80004dea:	bf2d                	j	80004d24 <sys_open+0xa4>
    itrunc(ip);
    80004dec:	854a                	mv	a0,s2
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	034080e7          	jalr	52(ra) # 80002e22 <itrunc>
    80004df6:	bfb1                	j	80004d52 <sys_open+0xd2>
      fileclose(f);
    80004df8:	854e                	mv	a0,s3
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	db8080e7          	jalr	-584(ra) # 80003bb2 <fileclose>
    iunlockput(ip);
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	172080e7          	jalr	370(ra) # 80002f76 <iunlockput>
    end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	95a080e7          	jalr	-1702(ra) # 80003766 <end_op>
    return -1;
    80004e14:	54fd                	li	s1,-1
    80004e16:	b7b9                	j	80004d64 <sys_open+0xe4>

0000000080004e18 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e18:	7175                	addi	sp,sp,-144
    80004e1a:	e506                	sd	ra,136(sp)
    80004e1c:	e122                	sd	s0,128(sp)
    80004e1e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	8c6080e7          	jalr	-1850(ra) # 800036e6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e28:	08000613          	li	a2,128
    80004e2c:	f7040593          	addi	a1,s0,-144
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	3b4080e7          	jalr	948(ra) # 800021e6 <argstr>
    80004e3a:	02054963          	bltz	a0,80004e6c <sys_mkdir+0x54>
    80004e3e:	4681                	li	a3,0
    80004e40:	4601                	li	a2,0
    80004e42:	4585                	li	a1,1
    80004e44:	f7040513          	addi	a0,s0,-144
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	7fe080e7          	jalr	2046(ra) # 80004646 <create>
    80004e50:	cd11                	beqz	a0,80004e6c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	124080e7          	jalr	292(ra) # 80002f76 <iunlockput>
  end_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	90c080e7          	jalr	-1780(ra) # 80003766 <end_op>
  return 0;
    80004e62:	4501                	li	a0,0
}
    80004e64:	60aa                	ld	ra,136(sp)
    80004e66:	640a                	ld	s0,128(sp)
    80004e68:	6149                	addi	sp,sp,144
    80004e6a:	8082                	ret
    end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8fa080e7          	jalr	-1798(ra) # 80003766 <end_op>
    return -1;
    80004e74:	557d                	li	a0,-1
    80004e76:	b7fd                	j	80004e64 <sys_mkdir+0x4c>

0000000080004e78 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e78:	7135                	addi	sp,sp,-160
    80004e7a:	ed06                	sd	ra,152(sp)
    80004e7c:	e922                	sd	s0,144(sp)
    80004e7e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	866080e7          	jalr	-1946(ra) # 800036e6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e88:	08000613          	li	a2,128
    80004e8c:	f7040593          	addi	a1,s0,-144
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	354080e7          	jalr	852(ra) # 800021e6 <argstr>
    80004e9a:	04054a63          	bltz	a0,80004eee <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e9e:	f6c40593          	addi	a1,s0,-148
    80004ea2:	4505                	li	a0,1
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	2fe080e7          	jalr	766(ra) # 800021a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eac:	04054163          	bltz	a0,80004eee <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eb0:	f6840593          	addi	a1,s0,-152
    80004eb4:	4509                	li	a0,2
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	2ec080e7          	jalr	748(ra) # 800021a2 <argint>
     argint(1, &major) < 0 ||
    80004ebe:	02054863          	bltz	a0,80004eee <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ec2:	f6841683          	lh	a3,-152(s0)
    80004ec6:	f6c41603          	lh	a2,-148(s0)
    80004eca:	458d                	li	a1,3
    80004ecc:	f7040513          	addi	a0,s0,-144
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	776080e7          	jalr	1910(ra) # 80004646 <create>
     argint(2, &minor) < 0 ||
    80004ed8:	c919                	beqz	a0,80004eee <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	09c080e7          	jalr	156(ra) # 80002f76 <iunlockput>
  end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	884080e7          	jalr	-1916(ra) # 80003766 <end_op>
  return 0;
    80004eea:	4501                	li	a0,0
    80004eec:	a031                	j	80004ef8 <sys_mknod+0x80>
    end_op();
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	878080e7          	jalr	-1928(ra) # 80003766 <end_op>
    return -1;
    80004ef6:	557d                	li	a0,-1
}
    80004ef8:	60ea                	ld	ra,152(sp)
    80004efa:	644a                	ld	s0,144(sp)
    80004efc:	610d                	addi	sp,sp,160
    80004efe:	8082                	ret

0000000080004f00 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f00:	7135                	addi	sp,sp,-160
    80004f02:	ed06                	sd	ra,152(sp)
    80004f04:	e922                	sd	s0,144(sp)
    80004f06:	e526                	sd	s1,136(sp)
    80004f08:	e14a                	sd	s2,128(sp)
    80004f0a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	f3c080e7          	jalr	-196(ra) # 80000e48 <myproc>
    80004f14:	892a                	mv	s2,a0
  
  begin_op();
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	7d0080e7          	jalr	2000(ra) # 800036e6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f1e:	08000613          	li	a2,128
    80004f22:	f6040593          	addi	a1,s0,-160
    80004f26:	4501                	li	a0,0
    80004f28:	ffffd097          	auipc	ra,0xffffd
    80004f2c:	2be080e7          	jalr	702(ra) # 800021e6 <argstr>
    80004f30:	04054b63          	bltz	a0,80004f86 <sys_chdir+0x86>
    80004f34:	f6040513          	addi	a0,s0,-160
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	592080e7          	jalr	1426(ra) # 800034ca <namei>
    80004f40:	84aa                	mv	s1,a0
    80004f42:	c131                	beqz	a0,80004f86 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	dd0080e7          	jalr	-560(ra) # 80002d14 <ilock>
  if(ip->type != T_DIR){
    80004f4c:	04449703          	lh	a4,68(s1)
    80004f50:	4785                	li	a5,1
    80004f52:	04f71063          	bne	a4,a5,80004f92 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f56:	8526                	mv	a0,s1
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	e7e080e7          	jalr	-386(ra) # 80002dd6 <iunlock>
  iput(p->cwd);
    80004f60:	15093503          	ld	a0,336(s2)
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	f6a080e7          	jalr	-150(ra) # 80002ece <iput>
  end_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	7fa080e7          	jalr	2042(ra) # 80003766 <end_op>
  p->cwd = ip;
    80004f74:	14993823          	sd	s1,336(s2)
  return 0;
    80004f78:	4501                	li	a0,0
}
    80004f7a:	60ea                	ld	ra,152(sp)
    80004f7c:	644a                	ld	s0,144(sp)
    80004f7e:	64aa                	ld	s1,136(sp)
    80004f80:	690a                	ld	s2,128(sp)
    80004f82:	610d                	addi	sp,sp,160
    80004f84:	8082                	ret
    end_op();
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	7e0080e7          	jalr	2016(ra) # 80003766 <end_op>
    return -1;
    80004f8e:	557d                	li	a0,-1
    80004f90:	b7ed                	j	80004f7a <sys_chdir+0x7a>
    iunlockput(ip);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	fe2080e7          	jalr	-30(ra) # 80002f76 <iunlockput>
    end_op();
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	7ca080e7          	jalr	1994(ra) # 80003766 <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	bfd1                	j	80004f7a <sys_chdir+0x7a>

0000000080004fa8 <sys_exec>:

uint64
sys_exec(void)
{
    80004fa8:	7145                	addi	sp,sp,-464
    80004faa:	e786                	sd	ra,456(sp)
    80004fac:	e3a2                	sd	s0,448(sp)
    80004fae:	ff26                	sd	s1,440(sp)
    80004fb0:	fb4a                	sd	s2,432(sp)
    80004fb2:	f74e                	sd	s3,424(sp)
    80004fb4:	f352                	sd	s4,416(sp)
    80004fb6:	ef56                	sd	s5,408(sp)
    80004fb8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fba:	08000613          	li	a2,128
    80004fbe:	f4040593          	addi	a1,s0,-192
    80004fc2:	4501                	li	a0,0
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	222080e7          	jalr	546(ra) # 800021e6 <argstr>
    return -1;
    80004fcc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fce:	0c054a63          	bltz	a0,800050a2 <sys_exec+0xfa>
    80004fd2:	e3840593          	addi	a1,s0,-456
    80004fd6:	4505                	li	a0,1
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	1ec080e7          	jalr	492(ra) # 800021c4 <argaddr>
    80004fe0:	0c054163          	bltz	a0,800050a2 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fe4:	10000613          	li	a2,256
    80004fe8:	4581                	li	a1,0
    80004fea:	e4040513          	addi	a0,s0,-448
    80004fee:	ffffb097          	auipc	ra,0xffffb
    80004ff2:	18a080e7          	jalr	394(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ff6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ffa:	89a6                	mv	s3,s1
    80004ffc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ffe:	02000a13          	li	s4,32
    80005002:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005006:	00391513          	slli	a0,s2,0x3
    8000500a:	e3040593          	addi	a1,s0,-464
    8000500e:	e3843783          	ld	a5,-456(s0)
    80005012:	953e                	add	a0,a0,a5
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	0f4080e7          	jalr	244(ra) # 80002108 <fetchaddr>
    8000501c:	02054a63          	bltz	a0,80005050 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005020:	e3043783          	ld	a5,-464(s0)
    80005024:	c3b9                	beqz	a5,8000506a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005026:	ffffb097          	auipc	ra,0xffffb
    8000502a:	0f2080e7          	jalr	242(ra) # 80000118 <kalloc>
    8000502e:	85aa                	mv	a1,a0
    80005030:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005034:	cd11                	beqz	a0,80005050 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005036:	6605                	lui	a2,0x1
    80005038:	e3043503          	ld	a0,-464(s0)
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	11e080e7          	jalr	286(ra) # 8000215a <fetchstr>
    80005044:	00054663          	bltz	a0,80005050 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005048:	0905                	addi	s2,s2,1
    8000504a:	09a1                	addi	s3,s3,8
    8000504c:	fb491be3          	bne	s2,s4,80005002 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005050:	10048913          	addi	s2,s1,256
    80005054:	6088                	ld	a0,0(s1)
    80005056:	c529                	beqz	a0,800050a0 <sys_exec+0xf8>
    kfree(argv[i]);
    80005058:	ffffb097          	auipc	ra,0xffffb
    8000505c:	fc4080e7          	jalr	-60(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005060:	04a1                	addi	s1,s1,8
    80005062:	ff2499e3          	bne	s1,s2,80005054 <sys_exec+0xac>
  return -1;
    80005066:	597d                	li	s2,-1
    80005068:	a82d                	j	800050a2 <sys_exec+0xfa>
      argv[i] = 0;
    8000506a:	0a8e                	slli	s5,s5,0x3
    8000506c:	fc040793          	addi	a5,s0,-64
    80005070:	9abe                	add	s5,s5,a5
    80005072:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005076:	e4040593          	addi	a1,s0,-448
    8000507a:	f4040513          	addi	a0,s0,-192
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	194080e7          	jalr	404(ra) # 80004212 <exec>
    80005086:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005088:	10048993          	addi	s3,s1,256
    8000508c:	6088                	ld	a0,0(s1)
    8000508e:	c911                	beqz	a0,800050a2 <sys_exec+0xfa>
    kfree(argv[i]);
    80005090:	ffffb097          	auipc	ra,0xffffb
    80005094:	f8c080e7          	jalr	-116(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005098:	04a1                	addi	s1,s1,8
    8000509a:	ff3499e3          	bne	s1,s3,8000508c <sys_exec+0xe4>
    8000509e:	a011                	j	800050a2 <sys_exec+0xfa>
  return -1;
    800050a0:	597d                	li	s2,-1
}
    800050a2:	854a                	mv	a0,s2
    800050a4:	60be                	ld	ra,456(sp)
    800050a6:	641e                	ld	s0,448(sp)
    800050a8:	74fa                	ld	s1,440(sp)
    800050aa:	795a                	ld	s2,432(sp)
    800050ac:	79ba                	ld	s3,424(sp)
    800050ae:	7a1a                	ld	s4,416(sp)
    800050b0:	6afa                	ld	s5,408(sp)
    800050b2:	6179                	addi	sp,sp,464
    800050b4:	8082                	ret

00000000800050b6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050b6:	7139                	addi	sp,sp,-64
    800050b8:	fc06                	sd	ra,56(sp)
    800050ba:	f822                	sd	s0,48(sp)
    800050bc:	f426                	sd	s1,40(sp)
    800050be:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d88080e7          	jalr	-632(ra) # 80000e48 <myproc>
    800050c8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050ca:	fd840593          	addi	a1,s0,-40
    800050ce:	4501                	li	a0,0
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	0f4080e7          	jalr	244(ra) # 800021c4 <argaddr>
    return -1;
    800050d8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050da:	0e054063          	bltz	a0,800051ba <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050de:	fc840593          	addi	a1,s0,-56
    800050e2:	fd040513          	addi	a0,s0,-48
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	dfc080e7          	jalr	-516(ra) # 80003ee2 <pipealloc>
    return -1;
    800050ee:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050f0:	0c054563          	bltz	a0,800051ba <sys_pipe+0x104>
  fd0 = -1;
    800050f4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f8:	fd043503          	ld	a0,-48(s0)
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	508080e7          	jalr	1288(ra) # 80004604 <fdalloc>
    80005104:	fca42223          	sw	a0,-60(s0)
    80005108:	08054c63          	bltz	a0,800051a0 <sys_pipe+0xea>
    8000510c:	fc843503          	ld	a0,-56(s0)
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	4f4080e7          	jalr	1268(ra) # 80004604 <fdalloc>
    80005118:	fca42023          	sw	a0,-64(s0)
    8000511c:	06054863          	bltz	a0,8000518c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005120:	4691                	li	a3,4
    80005122:	fc440613          	addi	a2,s0,-60
    80005126:	fd843583          	ld	a1,-40(s0)
    8000512a:	68a8                	ld	a0,80(s1)
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	9de080e7          	jalr	-1570(ra) # 80000b0a <copyout>
    80005134:	02054063          	bltz	a0,80005154 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005138:	4691                	li	a3,4
    8000513a:	fc040613          	addi	a2,s0,-64
    8000513e:	fd843583          	ld	a1,-40(s0)
    80005142:	0591                	addi	a1,a1,4
    80005144:	68a8                	ld	a0,80(s1)
    80005146:	ffffc097          	auipc	ra,0xffffc
    8000514a:	9c4080e7          	jalr	-1596(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000514e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005150:	06055563          	bgez	a0,800051ba <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005154:	fc442783          	lw	a5,-60(s0)
    80005158:	07e9                	addi	a5,a5,26
    8000515a:	078e                	slli	a5,a5,0x3
    8000515c:	97a6                	add	a5,a5,s1
    8000515e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005162:	fc042503          	lw	a0,-64(s0)
    80005166:	0569                	addi	a0,a0,26
    80005168:	050e                	slli	a0,a0,0x3
    8000516a:	9526                	add	a0,a0,s1
    8000516c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005170:	fd043503          	ld	a0,-48(s0)
    80005174:	fffff097          	auipc	ra,0xfffff
    80005178:	a3e080e7          	jalr	-1474(ra) # 80003bb2 <fileclose>
    fileclose(wf);
    8000517c:	fc843503          	ld	a0,-56(s0)
    80005180:	fffff097          	auipc	ra,0xfffff
    80005184:	a32080e7          	jalr	-1486(ra) # 80003bb2 <fileclose>
    return -1;
    80005188:	57fd                	li	a5,-1
    8000518a:	a805                	j	800051ba <sys_pipe+0x104>
    if(fd0 >= 0)
    8000518c:	fc442783          	lw	a5,-60(s0)
    80005190:	0007c863          	bltz	a5,800051a0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005194:	01a78513          	addi	a0,a5,26
    80005198:	050e                	slli	a0,a0,0x3
    8000519a:	9526                	add	a0,a0,s1
    8000519c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051a0:	fd043503          	ld	a0,-48(s0)
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	a0e080e7          	jalr	-1522(ra) # 80003bb2 <fileclose>
    fileclose(wf);
    800051ac:	fc843503          	ld	a0,-56(s0)
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	a02080e7          	jalr	-1534(ra) # 80003bb2 <fileclose>
    return -1;
    800051b8:	57fd                	li	a5,-1
}
    800051ba:	853e                	mv	a0,a5
    800051bc:	70e2                	ld	ra,56(sp)
    800051be:	7442                	ld	s0,48(sp)
    800051c0:	74a2                	ld	s1,40(sp)
    800051c2:	6121                	addi	sp,sp,64
    800051c4:	8082                	ret

00000000800051c6 <sys_mmap>:

uint64
sys_mmap(void)
{
    800051c6:	7179                	addi	sp,sp,-48
    800051c8:	f406                	sd	ra,40(sp)
    800051ca:	f022                	sd	s0,32(sp)
    800051cc:	1800                	addi	s0,sp,48
  struct file *f; 
  int length , prot, flags, offset; 
  uint64 addr; 

  // get args, 0:addr, 1:length, 2:prot, 3:flags, 5:offset, 4:fd=>*f
  if(argaddr(0, &addr) < 0
    800051ce:	fd040593          	addi	a1,s0,-48
    800051d2:	4501                	li	a0,0
    800051d4:	ffffd097          	auipc	ra,0xffffd
    800051d8:	ff0080e7          	jalr	-16(ra) # 800021c4 <argaddr>
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    || argfd(4, 0, &f) < 0 )
    return -1;
    800051dc:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0
    800051de:	0a054863          	bltz	a0,8000528e <sys_mmap+0xc8>
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    800051e2:	fe440593          	addi	a1,s0,-28
    800051e6:	4505                	li	a0,1
    800051e8:	ffffd097          	auipc	ra,0xffffd
    800051ec:	fba080e7          	jalr	-70(ra) # 800021a2 <argint>
    return -1;
    800051f0:	57fd                	li	a5,-1
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    800051f2:	08054e63          	bltz	a0,8000528e <sys_mmap+0xc8>
    800051f6:	fe040593          	addi	a1,s0,-32
    800051fa:	4509                	li	a0,2
    800051fc:	ffffd097          	auipc	ra,0xffffd
    80005200:	fa6080e7          	jalr	-90(ra) # 800021a2 <argint>
    return -1;
    80005204:	57fd                	li	a5,-1
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    80005206:	08054463          	bltz	a0,8000528e <sys_mmap+0xc8>
    8000520a:	fdc40593          	addi	a1,s0,-36
    8000520e:	450d                	li	a0,3
    80005210:	ffffd097          	auipc	ra,0xffffd
    80005214:	f92080e7          	jalr	-110(ra) # 800021a2 <argint>
    return -1;
    80005218:	57fd                	li	a5,-1
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    8000521a:	06054a63          	bltz	a0,8000528e <sys_mmap+0xc8>
    8000521e:	fd840593          	addi	a1,s0,-40
    80005222:	4515                	li	a0,5
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	f7e080e7          	jalr	-130(ra) # 800021a2 <argint>
    return -1;
    8000522c:	57fd                	li	a5,-1
    || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(5, &offset) < 0 
    8000522e:	06054063          	bltz	a0,8000528e <sys_mmap+0xc8>
    || argfd(4, 0, &f) < 0 )
    80005232:	fe840613          	addi	a2,s0,-24
    80005236:	4581                	li	a1,0
    80005238:	4511                	li	a0,4
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	362080e7          	jalr	866(ra) # 8000459c <argfd>
    80005242:	10054163          	bltz	a0,80005344 <sys_mmap+0x17e>

  // mmap doesn't allow read/write mapping of a file opened read-only with MAP_SHARED
  // "or", "/" also meaning "and" in english when use "doesn't", "not" and so on
  if(f->readable && !f->writable && (prot & PROT_READ) && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80005246:	fe843783          	ld	a5,-24(s0)
    8000524a:	0087c703          	lbu	a4,8(a5)
    8000524e:	cb11                	beqz	a4,80005262 <sys_mmap+0x9c>
    80005250:	0097c783          	lbu	a5,9(a5)
    80005254:	e799                	bnez	a5,80005262 <sys_mmap+0x9c>
    80005256:	fe042783          	lw	a5,-32(s0)
    8000525a:	8b8d                	andi	a5,a5,3
    8000525c:	470d                	li	a4,3
    8000525e:	02e78d63          	beq	a5,a4,80005298 <sys_mmap+0xd2>
    return -1;
  
  struct proc *p = myproc();
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	be6080e7          	jalr	-1050(ra) # 80000e48 <myproc>
    8000526a:	882a                	mv	a6,a0
  int oldsz = p->sz;
    8000526c:	04853303          	ld	t1,72(a0)
  
  // get va without anything by p->sz
  if(addr == 0){
    80005270:	fd043783          	ld	a5,-48(s0)
    80005274:	cb85                	beqz	a5,800052a4 <sys_mmap+0xde>
      return -1;
    va += PGSIZE;
    }
  }

  for(int i = 0; i < 16; i++){
    80005276:	18880713          	addi	a4,a6,392
    8000527a:	4781                	li	a5,0
    8000527c:	4641                	li	a2,16
    // case: maybe remove and rebuild a vmas[i] when slots full
    // not case in test
    // build a vams[i]
    if(p->vmas[i].addr == 0){
    8000527e:	6314                	ld	a3,0(a4)
    80005280:	cabd                	beqz	a3,800052f6 <sys_mmap+0x130>
  for(int i = 0; i < 16; i++){
    80005282:	2785                	addiw	a5,a5,1
    80005284:	02870713          	addi	a4,a4,40
    80005288:	fec79be3          	bne	a5,a2,8000527e <sys_mmap+0xb8>
      return addr;
    }
  }

  // failed, ret -1
  return -1;
    8000528c:	57fd                	li	a5,-1
}
    8000528e:	853e                	mv	a0,a5
    80005290:	70a2                	ld	ra,40(sp)
    80005292:	7402                	ld	s0,32(sp)
    80005294:	6145                	addi	sp,sp,48
    80005296:	8082                	ret
  if(f->readable && !f->writable && (prot & PROT_READ) && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80005298:	fdc42703          	lw	a4,-36(s0)
    8000529c:	8b05                	andi	a4,a4,1
    return -1;
    8000529e:	57fd                	li	a5,-1
  if(f->readable && !f->writable && (prot & PROT_READ) && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    800052a0:	d369                	beqz	a4,80005262 <sys_mmap+0x9c>
    800052a2:	b7f5                	j	8000528e <sys_mmap+0xc8>
    uint64 va = p->sz;
    800052a4:	861a                	mv	a2,t1
    800052a6:	3f050593          	addi	a1,a0,1008
    800052aa:	4e81                	li	t4,0
          is_same = 1;
    800052ac:	4885                	li	a7,1
    if(va >= MAXVA)
    800052ae:	5e7d                	li	t3,-1
    800052b0:	01ae5e13          	srli	t3,t3,0x1a
    va += PGSIZE;
    800052b4:	6f05                	lui	t5,0x1
      for(i = 0; i < 16; i++){
    800052b6:	17080793          	addi	a5,a6,368
    uint64 va = p->sz;
    800052ba:	8576                	mv	a0,t4
    800052bc:	a029                	j	800052c6 <sys_mmap+0x100>
      for(i = 0; i < 16; i++){
    800052be:	02878793          	addi	a5,a5,40
    800052c2:	00b78b63          	beq	a5,a1,800052d8 <sys_mmap+0x112>
        if(p->vmas[i].addr <= va && va < (p->vmas[i].addr + p->vmas[i].length))
    800052c6:	6f98                	ld	a4,24(a5)
    800052c8:	fee66be3          	bltu	a2,a4,800052be <sys_mmap+0xf8>
    800052cc:	4394                	lw	a3,0(a5)
    800052ce:	9736                	add	a4,a4,a3
    800052d0:	fee677e3          	bgeu	a2,a4,800052be <sys_mmap+0xf8>
          is_same = 1;
    800052d4:	8546                	mv	a0,a7
    800052d6:	b7e5                	j	800052be <sys_mmap+0xf8>
      if(!is_same){
    800052d8:	c509                	beqz	a0,800052e2 <sys_mmap+0x11c>
    if(va >= MAXVA)
    800052da:	00ce7c63          	bgeu	t3,a2,800052f2 <sys_mmap+0x12c>
      return -1;
    800052de:	57fd                	li	a5,-1
    800052e0:	b77d                	j	8000528e <sys_mmap+0xc8>
        addr = va;
    800052e2:	fcc43823          	sd	a2,-48(s0)
        p->sz = va + length;
    800052e6:	fe442783          	lw	a5,-28(s0)
    800052ea:	963e                	add	a2,a2,a5
    800052ec:	04c83423          	sd	a2,72(a6)
        break;
    800052f0:	b759                	j	80005276 <sys_mmap+0xb0>
    va += PGSIZE;
    800052f2:	967a                	add	a2,a2,t5
    while(1){
    800052f4:	b7c9                	j	800052b6 <sys_mmap+0xf0>
      p->vmas[i].f = f;
    800052f6:	fe843503          	ld	a0,-24(s0)
    800052fa:	00279693          	slli	a3,a5,0x2
    800052fe:	00f68733          	add	a4,a3,a5
    80005302:	070e                	slli	a4,a4,0x3
    80005304:	9742                	add	a4,a4,a6
    80005306:	16a73423          	sd	a0,360(a4)
      p->vmas[i].length = length;
    8000530a:	fe442603          	lw	a2,-28(s0)
    8000530e:	16c72823          	sw	a2,368(a4)
      p->vmas[i].prot = prot;
    80005312:	fe042603          	lw	a2,-32(s0)
    80005316:	16c72a23          	sw	a2,372(a4)
      p->vmas[i].flags = flags;
    8000531a:	fdc42603          	lw	a2,-36(s0)
    8000531e:	16c72c23          	sw	a2,376(a4)
      p->vmas[i].offset = offset;
    80005322:	fd842603          	lw	a2,-40(s0)
    80005326:	16c72e23          	sw	a2,380(a4)
      p->vmas[i].addr = addr;
    8000532a:	fd043603          	ld	a2,-48(s0)
    8000532e:	18c73423          	sd	a2,392(a4)
  int oldsz = p->sz;
    80005332:	18672023          	sw	t1,384(a4)
      filedup(f);
    80005336:	fffff097          	auipc	ra,0xfffff
    8000533a:	82a080e7          	jalr	-2006(ra) # 80003b60 <filedup>
      return addr;
    8000533e:	fd043783          	ld	a5,-48(s0)
    80005342:	b7b1                	j	8000528e <sys_mmap+0xc8>
    return -1;
    80005344:	57fd                	li	a5,-1
    80005346:	b7a1                	j	8000528e <sys_mmap+0xc8>

0000000080005348 <sys_munmap>:


uint64
sys_munmap(void)
{
    80005348:	715d                	addi	sp,sp,-80
    8000534a:	e486                	sd	ra,72(sp)
    8000534c:	e0a2                	sd	s0,64(sp)
    8000534e:	fc26                	sd	s1,56(sp)
    80005350:	f84a                	sd	s2,48(sp)
    80005352:	f44e                	sd	s3,40(sp)
    80005354:	f052                	sd	s4,32(sp)
    80005356:	ec56                	sd	s5,24(sp)
    80005358:	0880                	addi	s0,sp,80
  uint64 addr; 
  int length;

  // get args, 0:addr, 1:length
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    8000535a:	fb840593          	addi	a1,s0,-72
    8000535e:	4501                	li	a0,0
    80005360:	ffffd097          	auipc	ra,0xffffd
    80005364:	e64080e7          	jalr	-412(ra) # 800021c4 <argaddr>
    return -1;
    80005368:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    8000536a:	10054763          	bltz	a0,80005478 <sys_munmap+0x130>
    8000536e:	fb440593          	addi	a1,s0,-76
    80005372:	4505                	li	a0,1
    80005374:	ffffd097          	auipc	ra,0xffffd
    80005378:	e2e080e7          	jalr	-466(ra) # 800021a2 <argint>
    return -1;
    8000537c:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    8000537e:	0e054d63          	bltz	a0,80005478 <sys_munmap+0x130>
  
  struct proc *p = myproc();
    80005382:	ffffc097          	auipc	ra,0xffffc
    80005386:	ac6080e7          	jalr	-1338(ra) # 80000e48 <myproc>
    8000538a:	892a                	mv	s2,a0
  int has_a_vma = 0;

  int i;
  for(i = 0 ; i < 16; i++){
    if(p->vmas[i].addr <= addr && addr < (p->vmas[i].addr + p->vmas[i].length)){
    8000538c:	fb843583          	ld	a1,-72(s0)
    80005390:	17050793          	addi	a5,a0,368
  for(i = 0 ; i < 16; i++){
    80005394:	4481                	li	s1,0
    80005396:	4641                	li	a2,16
    80005398:	a031                	j	800053a4 <sys_munmap+0x5c>
    8000539a:	2485                	addiw	s1,s1,1
    8000539c:	02878793          	addi	a5,a5,40
    800053a0:	0cc48b63          	beq	s1,a2,80005476 <sys_munmap+0x12e>
    if(p->vmas[i].addr <= addr && addr < (p->vmas[i].addr + p->vmas[i].length)){
    800053a4:	6f98                	ld	a4,24(a5)
    800053a6:	fee5eae3          	bltu	a1,a4,8000539a <sys_munmap+0x52>
    800053aa:	4394                	lw	a3,0(a5)
    800053ac:	9736                	add	a4,a4,a3
    800053ae:	fee5f6e3          	bgeu	a1,a4,8000539a <sys_munmap+0x52>
  // not find a vma, so ret -1
  if(has_a_vma == 0){
    return -1;
  }

  pte_t *pte = walk(p->pagetable, addr, 0);
    800053b2:	4601                	li	a2,0
    800053b4:	05093503          	ld	a0,80(s2)
    800053b8:	ffffb097          	auipc	ra,0xffffb
    800053bc:	0a8080e7          	jalr	168(ra) # 80000460 <walk>
    800053c0:	89aa                	mv	s3,a0
  int offset = p->vmas[i].f->off; // addr is beginning of vma, so use file->off
    800053c2:	00249793          	slli	a5,s1,0x2
    800053c6:	97a6                	add	a5,a5,s1
    800053c8:	078e                	slli	a5,a5,0x3
    800053ca:	97ca                	add	a5,a5,s2
    800053cc:	1687b703          	ld	a4,360(a5)
    800053d0:	02072a03          	lw	s4,32(a4)
  if(p->vmas[i].oldsz != addr) // addr is't beginning of vma, so use p->vmas[i].offset
    800053d4:	1807a703          	lw	a4,384(a5)
    800053d8:	fb843783          	ld	a5,-72(s0)
  int offset = p->vmas[i].f->off; // addr is beginning of vma, so use file->off
    800053dc:	2a01                	sext.w	s4,s4
  if(p->vmas[i].oldsz != addr) // addr is't beginning of vma, so use p->vmas[i].offset
    800053de:	00f70963          	beq	a4,a5,800053f0 <sys_munmap+0xa8>
    offset = p->vmas[i].offset;
    800053e2:	00249793          	slli	a5,s1,0x2
    800053e6:	97a6                	add	a5,a5,s1
    800053e8:	078e                	slli	a5,a5,0x3
    800053ea:	97ca                	add	a5,a5,s2
    800053ec:	17c7aa03          	lw	s4,380(a5)

  // If an unmapped page has been modified and the file is mapped MAP_SHARED,
  // write the page back to the file.
  if((*pte & PTE_V) && p->vmas[i].flags & MAP_SHARED){
    800053f0:	0009b783          	ld	a5,0(s3)
    800053f4:	8b85                	andi	a5,a5,1
    800053f6:	cb91                	beqz	a5,8000540a <sys_munmap+0xc2>
    800053f8:	00249793          	slli	a5,s1,0x2
    800053fc:	97a6                	add	a5,a5,s1
    800053fe:	078e                	slli	a5,a5,0x3
    80005400:	97ca                	add	a5,a5,s2
    80005402:	1787a783          	lw	a5,376(a5)
    80005406:	8b85                	andi	a5,a5,1
    80005408:	e3d1                	bnez	a5,8000548c <sys_munmap+0x144>
  // [                     p->sz                        ]
  // ==>
  //                                  ' p->vmas[i].addr
  // [process data][  length munmap  ][p->vmas[i].length]
  // [             p->sz           ]   
  if(length < p->vmas[i].length){
    8000540a:	00249793          	slli	a5,s1,0x2
    8000540e:	97a6                	add	a5,a5,s1
    80005410:	078e                	slli	a5,a5,0x3
    80005412:	97ca                	add	a5,a5,s2
    80005414:	1707a703          	lw	a4,368(a5)
    80005418:	fb442603          	lw	a2,-76(s0)
    8000541c:	0ce65163          	bge	a2,a4,800054de <sys_munmap+0x196>
    p->sz -= length;
    80005420:	04893783          	ld	a5,72(s2)
    80005424:	8f91                	sub	a5,a5,a2
    80005426:	04f93423          	sd	a5,72(s2)
    p->vmas[i].addr += length;
    8000542a:	00249793          	slli	a5,s1,0x2
    8000542e:	00978733          	add	a4,a5,s1
    80005432:	070e                	slli	a4,a4,0x3
    80005434:	974a                	add	a4,a4,s2
    80005436:	18873683          	ld	a3,392(a4)
    8000543a:	96b2                	add	a3,a3,a2
    8000543c:	18d73423          	sd	a3,392(a4)
    p->vmas[i].length -= length;
    80005440:	17072783          	lw	a5,368(a4)
    80005444:	9f91                	subw	a5,a5,a2
    80005446:	16f72823          	sw	a5,368(a4)
    p->vmas[i].oldsz = 0;
  }
  else
    return -1;

  if((*pte & PTE_V) == 0) // don't write and uvmunmap(), only change data of vma
    8000544a:	0009b783          	ld	a5,0(s3)
    8000544e:	8b85                	andi	a5,a5,1
    80005450:	c785                	beqz	a5,80005478 <sys_munmap+0x130>
    return 0;

  // uvmunmap() after writing
  // find the VMA for the address range and unmap the specified pages
  // note: free physical memory => 'do_free = 1'
  uvmunmap(p->pagetable, addr, length/PGSIZE, 1);
    80005452:	41f6579b          	sraiw	a5,a2,0x1f
    80005456:	0147d79b          	srliw	a5,a5,0x14
    8000545a:	9e3d                	addw	a2,a2,a5
    8000545c:	4685                	li	a3,1
    8000545e:	40c6561b          	sraiw	a2,a2,0xc
    80005462:	fb843583          	ld	a1,-72(s0)
    80005466:	05093503          	ld	a0,80(s2)
    8000546a:	ffffb097          	auipc	ra,0xffffb
    8000546e:	2a4080e7          	jalr	676(ra) # 8000070e <uvmunmap>

  // success, ret 0
  return 0;
    80005472:	4781                	li	a5,0
    80005474:	a011                	j	80005478 <sys_munmap+0x130>
    return -1;
    80005476:	57fd                	li	a5,-1
}
    80005478:	853e                	mv	a0,a5
    8000547a:	60a6                	ld	ra,72(sp)
    8000547c:	6406                	ld	s0,64(sp)
    8000547e:	74e2                	ld	s1,56(sp)
    80005480:	7942                	ld	s2,48(sp)
    80005482:	79a2                	ld	s3,40(sp)
    80005484:	7a02                	ld	s4,32(sp)
    80005486:	6ae2                	ld	s5,24(sp)
    80005488:	6161                	addi	sp,sp,80
    8000548a:	8082                	ret
    begin_op();
    8000548c:	ffffe097          	auipc	ra,0xffffe
    80005490:	25a080e7          	jalr	602(ra) # 800036e6 <begin_op>
    ilock(p->vmas[i].f->ip);
    80005494:	00249a93          	slli	s5,s1,0x2
    80005498:	9aa6                	add	s5,s5,s1
    8000549a:	0a8e                	slli	s5,s5,0x3
    8000549c:	9aca                	add	s5,s5,s2
    8000549e:	168ab783          	ld	a5,360(s5)
    800054a2:	6f88                	ld	a0,24(a5)
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	870080e7          	jalr	-1936(ra) # 80002d14 <ilock>
    writei(p->vmas[i].f->ip, 1, addr, offset, length); 
    800054ac:	168ab783          	ld	a5,360(s5)
    800054b0:	fb442703          	lw	a4,-76(s0)
    800054b4:	86d2                	mv	a3,s4
    800054b6:	fb843603          	ld	a2,-72(s0)
    800054ba:	4585                	li	a1,1
    800054bc:	6f88                	ld	a0,24(a5)
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	c02080e7          	jalr	-1022(ra) # 800030c0 <writei>
    iunlock(p->vmas[i].f->ip);
    800054c6:	168ab783          	ld	a5,360(s5)
    800054ca:	6f88                	ld	a0,24(a5)
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	90a080e7          	jalr	-1782(ra) # 80002dd6 <iunlock>
    end_op();
    800054d4:	ffffe097          	auipc	ra,0xffffe
    800054d8:	292080e7          	jalr	658(ra) # 80003766 <end_op>
    800054dc:	b73d                	j	8000540a <sys_munmap+0xc2>
    return -1;
    800054de:	57fd                	li	a5,-1
  else if(length == p->vmas[i].length){
    800054e0:	f8c71ce3          	bne	a4,a2,80005478 <sys_munmap+0x130>
    p->sz -= length;  
    800054e4:	04893783          	ld	a5,72(s2)
    800054e8:	8f91                	sub	a5,a5,a2
    800054ea:	04f93423          	sd	a5,72(s2)
    p->vmas[i].f->ref--;
    800054ee:	00249713          	slli	a4,s1,0x2
    800054f2:	009707b3          	add	a5,a4,s1
    800054f6:	078e                	slli	a5,a5,0x3
    800054f8:	97ca                	add	a5,a5,s2
    800054fa:	1687b583          	ld	a1,360(a5)
    800054fe:	41d4                	lw	a3,4(a1)
    80005500:	36fd                	addiw	a3,a3,-1
    80005502:	c1d4                	sw	a3,4(a1)
    p->vmas[i].f = 0;
    80005504:	1607b423          	sd	zero,360(a5)
    p->vmas[i].addr = 0;
    80005508:	1807b423          	sd	zero,392(a5)
    p->vmas[i].prot = 0;
    8000550c:	1607aa23          	sw	zero,372(a5)
    p->vmas[i].flags = 0;
    80005510:	1607ac23          	sw	zero,376(a5)
    p->vmas[i].length = 0;
    80005514:	1607a823          	sw	zero,368(a5)
    p->vmas[i].oldsz = 0;
    80005518:	009707b3          	add	a5,a4,s1
    8000551c:	078e                	slli	a5,a5,0x3
    8000551e:	97ca                	add	a5,a5,s2
    80005520:	1807a023          	sw	zero,384(a5)
    80005524:	b71d                	j	8000544a <sys_munmap+0x102>
	...

0000000080005530 <kernelvec>:
    80005530:	7111                	addi	sp,sp,-256
    80005532:	e006                	sd	ra,0(sp)
    80005534:	e40a                	sd	sp,8(sp)
    80005536:	e80e                	sd	gp,16(sp)
    80005538:	ec12                	sd	tp,24(sp)
    8000553a:	f016                	sd	t0,32(sp)
    8000553c:	f41a                	sd	t1,40(sp)
    8000553e:	f81e                	sd	t2,48(sp)
    80005540:	fc22                	sd	s0,56(sp)
    80005542:	e0a6                	sd	s1,64(sp)
    80005544:	e4aa                	sd	a0,72(sp)
    80005546:	e8ae                	sd	a1,80(sp)
    80005548:	ecb2                	sd	a2,88(sp)
    8000554a:	f0b6                	sd	a3,96(sp)
    8000554c:	f4ba                	sd	a4,104(sp)
    8000554e:	f8be                	sd	a5,112(sp)
    80005550:	fcc2                	sd	a6,120(sp)
    80005552:	e146                	sd	a7,128(sp)
    80005554:	e54a                	sd	s2,136(sp)
    80005556:	e94e                	sd	s3,144(sp)
    80005558:	ed52                	sd	s4,152(sp)
    8000555a:	f156                	sd	s5,160(sp)
    8000555c:	f55a                	sd	s6,168(sp)
    8000555e:	f95e                	sd	s7,176(sp)
    80005560:	fd62                	sd	s8,184(sp)
    80005562:	e1e6                	sd	s9,192(sp)
    80005564:	e5ea                	sd	s10,200(sp)
    80005566:	e9ee                	sd	s11,208(sp)
    80005568:	edf2                	sd	t3,216(sp)
    8000556a:	f1f6                	sd	t4,224(sp)
    8000556c:	f5fa                	sd	t5,232(sp)
    8000556e:	f9fe                	sd	t6,240(sp)
    80005570:	a65fc0ef          	jal	ra,80001fd4 <kerneltrap>
    80005574:	6082                	ld	ra,0(sp)
    80005576:	6122                	ld	sp,8(sp)
    80005578:	61c2                	ld	gp,16(sp)
    8000557a:	7282                	ld	t0,32(sp)
    8000557c:	7322                	ld	t1,40(sp)
    8000557e:	73c2                	ld	t2,48(sp)
    80005580:	7462                	ld	s0,56(sp)
    80005582:	6486                	ld	s1,64(sp)
    80005584:	6526                	ld	a0,72(sp)
    80005586:	65c6                	ld	a1,80(sp)
    80005588:	6666                	ld	a2,88(sp)
    8000558a:	7686                	ld	a3,96(sp)
    8000558c:	7726                	ld	a4,104(sp)
    8000558e:	77c6                	ld	a5,112(sp)
    80005590:	7866                	ld	a6,120(sp)
    80005592:	688a                	ld	a7,128(sp)
    80005594:	692a                	ld	s2,136(sp)
    80005596:	69ca                	ld	s3,144(sp)
    80005598:	6a6a                	ld	s4,152(sp)
    8000559a:	7a8a                	ld	s5,160(sp)
    8000559c:	7b2a                	ld	s6,168(sp)
    8000559e:	7bca                	ld	s7,176(sp)
    800055a0:	7c6a                	ld	s8,184(sp)
    800055a2:	6c8e                	ld	s9,192(sp)
    800055a4:	6d2e                	ld	s10,200(sp)
    800055a6:	6dce                	ld	s11,208(sp)
    800055a8:	6e6e                	ld	t3,216(sp)
    800055aa:	7e8e                	ld	t4,224(sp)
    800055ac:	7f2e                	ld	t5,232(sp)
    800055ae:	7fce                	ld	t6,240(sp)
    800055b0:	6111                	addi	sp,sp,256
    800055b2:	10200073          	sret
    800055b6:	00000013          	nop
    800055ba:	00000013          	nop
    800055be:	0001                	nop

00000000800055c0 <timervec>:
    800055c0:	34051573          	csrrw	a0,mscratch,a0
    800055c4:	e10c                	sd	a1,0(a0)
    800055c6:	e510                	sd	a2,8(a0)
    800055c8:	e914                	sd	a3,16(a0)
    800055ca:	6d0c                	ld	a1,24(a0)
    800055cc:	7110                	ld	a2,32(a0)
    800055ce:	6194                	ld	a3,0(a1)
    800055d0:	96b2                	add	a3,a3,a2
    800055d2:	e194                	sd	a3,0(a1)
    800055d4:	4589                	li	a1,2
    800055d6:	14459073          	csrw	sip,a1
    800055da:	6914                	ld	a3,16(a0)
    800055dc:	6510                	ld	a2,8(a0)
    800055de:	610c                	ld	a1,0(a0)
    800055e0:	34051573          	csrrw	a0,mscratch,a0
    800055e4:	30200073          	mret
	...

00000000800055ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055ea:	1141                	addi	sp,sp,-16
    800055ec:	e422                	sd	s0,8(sp)
    800055ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055f0:	0c0007b7          	lui	a5,0xc000
    800055f4:	4705                	li	a4,1
    800055f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055f8:	c3d8                	sw	a4,4(a5)
}
    800055fa:	6422                	ld	s0,8(sp)
    800055fc:	0141                	addi	sp,sp,16
    800055fe:	8082                	ret

0000000080005600 <plicinithart>:

void
plicinithart(void)
{
    80005600:	1141                	addi	sp,sp,-16
    80005602:	e406                	sd	ra,8(sp)
    80005604:	e022                	sd	s0,0(sp)
    80005606:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005608:	ffffc097          	auipc	ra,0xffffc
    8000560c:	814080e7          	jalr	-2028(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005610:	0085171b          	slliw	a4,a0,0x8
    80005614:	0c0027b7          	lui	a5,0xc002
    80005618:	97ba                	add	a5,a5,a4
    8000561a:	40200713          	li	a4,1026
    8000561e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005622:	00d5151b          	slliw	a0,a0,0xd
    80005626:	0c2017b7          	lui	a5,0xc201
    8000562a:	953e                	add	a0,a0,a5
    8000562c:	00052023          	sw	zero,0(a0)
}
    80005630:	60a2                	ld	ra,8(sp)
    80005632:	6402                	ld	s0,0(sp)
    80005634:	0141                	addi	sp,sp,16
    80005636:	8082                	ret

0000000080005638 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005638:	1141                	addi	sp,sp,-16
    8000563a:	e406                	sd	ra,8(sp)
    8000563c:	e022                	sd	s0,0(sp)
    8000563e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005640:	ffffb097          	auipc	ra,0xffffb
    80005644:	7dc080e7          	jalr	2012(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005648:	00d5179b          	slliw	a5,a0,0xd
    8000564c:	0c201537          	lui	a0,0xc201
    80005650:	953e                	add	a0,a0,a5
  return irq;
}
    80005652:	4148                	lw	a0,4(a0)
    80005654:	60a2                	ld	ra,8(sp)
    80005656:	6402                	ld	s0,0(sp)
    80005658:	0141                	addi	sp,sp,16
    8000565a:	8082                	ret

000000008000565c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000565c:	1101                	addi	sp,sp,-32
    8000565e:	ec06                	sd	ra,24(sp)
    80005660:	e822                	sd	s0,16(sp)
    80005662:	e426                	sd	s1,8(sp)
    80005664:	1000                	addi	s0,sp,32
    80005666:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005668:	ffffb097          	auipc	ra,0xffffb
    8000566c:	7b4080e7          	jalr	1972(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005670:	00d5151b          	slliw	a0,a0,0xd
    80005674:	0c2017b7          	lui	a5,0xc201
    80005678:	97aa                	add	a5,a5,a0
    8000567a:	c3c4                	sw	s1,4(a5)
}
    8000567c:	60e2                	ld	ra,24(sp)
    8000567e:	6442                	ld	s0,16(sp)
    80005680:	64a2                	ld	s1,8(sp)
    80005682:	6105                	addi	sp,sp,32
    80005684:	8082                	ret

0000000080005686 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005686:	1141                	addi	sp,sp,-16
    80005688:	e406                	sd	ra,8(sp)
    8000568a:	e022                	sd	s0,0(sp)
    8000568c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000568e:	479d                	li	a5,7
    80005690:	06a7c963          	blt	a5,a0,80005702 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005694:	00020797          	auipc	a5,0x20
    80005698:	96c78793          	addi	a5,a5,-1684 # 80025000 <disk>
    8000569c:	00a78733          	add	a4,a5,a0
    800056a0:	6789                	lui	a5,0x2
    800056a2:	97ba                	add	a5,a5,a4
    800056a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800056a8:	e7ad                	bnez	a5,80005712 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800056aa:	00451793          	slli	a5,a0,0x4
    800056ae:	00022717          	auipc	a4,0x22
    800056b2:	95270713          	addi	a4,a4,-1710 # 80027000 <disk+0x2000>
    800056b6:	6314                	ld	a3,0(a4)
    800056b8:	96be                	add	a3,a3,a5
    800056ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800056be:	6314                	ld	a3,0(a4)
    800056c0:	96be                	add	a3,a3,a5
    800056c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800056c6:	6314                	ld	a3,0(a4)
    800056c8:	96be                	add	a3,a3,a5
    800056ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800056ce:	6318                	ld	a4,0(a4)
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800056d6:	00020797          	auipc	a5,0x20
    800056da:	92a78793          	addi	a5,a5,-1750 # 80025000 <disk>
    800056de:	97aa                	add	a5,a5,a0
    800056e0:	6509                	lui	a0,0x2
    800056e2:	953e                	add	a0,a0,a5
    800056e4:	4785                	li	a5,1
    800056e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800056ea:	00022517          	auipc	a0,0x22
    800056ee:	92e50513          	addi	a0,a0,-1746 # 80027018 <disk+0x2018>
    800056f2:	ffffc097          	auipc	ra,0xffffc
    800056f6:	00e080e7          	jalr	14(ra) # 80001700 <wakeup>
}
    800056fa:	60a2                	ld	ra,8(sp)
    800056fc:	6402                	ld	s0,0(sp)
    800056fe:	0141                	addi	sp,sp,16
    80005700:	8082                	ret
    panic("free_desc 1");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	ff650513          	addi	a0,a0,-10 # 800086f8 <syscalls+0x330>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	a1e080e7          	jalr	-1506(ra) # 80006128 <panic>
    panic("free_desc 2");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	ff650513          	addi	a0,a0,-10 # 80008708 <syscalls+0x340>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	a0e080e7          	jalr	-1522(ra) # 80006128 <panic>

0000000080005722 <virtio_disk_init>:
{
    80005722:	1101                	addi	sp,sp,-32
    80005724:	ec06                	sd	ra,24(sp)
    80005726:	e822                	sd	s0,16(sp)
    80005728:	e426                	sd	s1,8(sp)
    8000572a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000572c:	00003597          	auipc	a1,0x3
    80005730:	fec58593          	addi	a1,a1,-20 # 80008718 <syscalls+0x350>
    80005734:	00022517          	auipc	a0,0x22
    80005738:	9f450513          	addi	a0,a0,-1548 # 80027128 <disk+0x2128>
    8000573c:	00001097          	auipc	ra,0x1
    80005740:	ea6080e7          	jalr	-346(ra) # 800065e2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005744:	100017b7          	lui	a5,0x10001
    80005748:	4398                	lw	a4,0(a5)
    8000574a:	2701                	sext.w	a4,a4
    8000574c:	747277b7          	lui	a5,0x74727
    80005750:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005754:	0ef71163          	bne	a4,a5,80005836 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005758:	100017b7          	lui	a5,0x10001
    8000575c:	43dc                	lw	a5,4(a5)
    8000575e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005760:	4705                	li	a4,1
    80005762:	0ce79a63          	bne	a5,a4,80005836 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005766:	100017b7          	lui	a5,0x10001
    8000576a:	479c                	lw	a5,8(a5)
    8000576c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000576e:	4709                	li	a4,2
    80005770:	0ce79363          	bne	a5,a4,80005836 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005774:	100017b7          	lui	a5,0x10001
    80005778:	47d8                	lw	a4,12(a5)
    8000577a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000577c:	554d47b7          	lui	a5,0x554d4
    80005780:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005784:	0af71963          	bne	a4,a5,80005836 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005788:	100017b7          	lui	a5,0x10001
    8000578c:	4705                	li	a4,1
    8000578e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005790:	470d                	li	a4,3
    80005792:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005794:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005796:	c7ffe737          	lui	a4,0xc7ffe
    8000579a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fce51f>
    8000579e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057a0:	2701                	sext.w	a4,a4
    800057a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057a4:	472d                	li	a4,11
    800057a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057a8:	473d                	li	a4,15
    800057aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800057ac:	6705                	lui	a4,0x1
    800057ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800057b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057b4:	5bdc                	lw	a5,52(a5)
    800057b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800057b8:	c7d9                	beqz	a5,80005846 <virtio_disk_init+0x124>
  if(max < NUM)
    800057ba:	471d                	li	a4,7
    800057bc:	08f77d63          	bgeu	a4,a5,80005856 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057c0:	100014b7          	lui	s1,0x10001
    800057c4:	47a1                	li	a5,8
    800057c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800057c8:	6609                	lui	a2,0x2
    800057ca:	4581                	li	a1,0
    800057cc:	00020517          	auipc	a0,0x20
    800057d0:	83450513          	addi	a0,a0,-1996 # 80025000 <disk>
    800057d4:	ffffb097          	auipc	ra,0xffffb
    800057d8:	9a4080e7          	jalr	-1628(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800057dc:	00020717          	auipc	a4,0x20
    800057e0:	82470713          	addi	a4,a4,-2012 # 80025000 <disk>
    800057e4:	00c75793          	srli	a5,a4,0xc
    800057e8:	2781                	sext.w	a5,a5
    800057ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800057ec:	00022797          	auipc	a5,0x22
    800057f0:	81478793          	addi	a5,a5,-2028 # 80027000 <disk+0x2000>
    800057f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800057f6:	00020717          	auipc	a4,0x20
    800057fa:	88a70713          	addi	a4,a4,-1910 # 80025080 <disk+0x80>
    800057fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005800:	00021717          	auipc	a4,0x21
    80005804:	80070713          	addi	a4,a4,-2048 # 80026000 <disk+0x1000>
    80005808:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000580a:	4705                	li	a4,1
    8000580c:	00e78c23          	sb	a4,24(a5)
    80005810:	00e78ca3          	sb	a4,25(a5)
    80005814:	00e78d23          	sb	a4,26(a5)
    80005818:	00e78da3          	sb	a4,27(a5)
    8000581c:	00e78e23          	sb	a4,28(a5)
    80005820:	00e78ea3          	sb	a4,29(a5)
    80005824:	00e78f23          	sb	a4,30(a5)
    80005828:	00e78fa3          	sb	a4,31(a5)
}
    8000582c:	60e2                	ld	ra,24(sp)
    8000582e:	6442                	ld	s0,16(sp)
    80005830:	64a2                	ld	s1,8(sp)
    80005832:	6105                	addi	sp,sp,32
    80005834:	8082                	ret
    panic("could not find virtio disk");
    80005836:	00003517          	auipc	a0,0x3
    8000583a:	ef250513          	addi	a0,a0,-270 # 80008728 <syscalls+0x360>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	8ea080e7          	jalr	-1814(ra) # 80006128 <panic>
    panic("virtio disk has no queue 0");
    80005846:	00003517          	auipc	a0,0x3
    8000584a:	f0250513          	addi	a0,a0,-254 # 80008748 <syscalls+0x380>
    8000584e:	00001097          	auipc	ra,0x1
    80005852:	8da080e7          	jalr	-1830(ra) # 80006128 <panic>
    panic("virtio disk max queue too short");
    80005856:	00003517          	auipc	a0,0x3
    8000585a:	f1250513          	addi	a0,a0,-238 # 80008768 <syscalls+0x3a0>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	8ca080e7          	jalr	-1846(ra) # 80006128 <panic>

0000000080005866 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005866:	7159                	addi	sp,sp,-112
    80005868:	f486                	sd	ra,104(sp)
    8000586a:	f0a2                	sd	s0,96(sp)
    8000586c:	eca6                	sd	s1,88(sp)
    8000586e:	e8ca                	sd	s2,80(sp)
    80005870:	e4ce                	sd	s3,72(sp)
    80005872:	e0d2                	sd	s4,64(sp)
    80005874:	fc56                	sd	s5,56(sp)
    80005876:	f85a                	sd	s6,48(sp)
    80005878:	f45e                	sd	s7,40(sp)
    8000587a:	f062                	sd	s8,32(sp)
    8000587c:	ec66                	sd	s9,24(sp)
    8000587e:	e86a                	sd	s10,16(sp)
    80005880:	1880                	addi	s0,sp,112
    80005882:	892a                	mv	s2,a0
    80005884:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005886:	00c52c83          	lw	s9,12(a0)
    8000588a:	001c9c9b          	slliw	s9,s9,0x1
    8000588e:	1c82                	slli	s9,s9,0x20
    80005890:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005894:	00022517          	auipc	a0,0x22
    80005898:	89450513          	addi	a0,a0,-1900 # 80027128 <disk+0x2128>
    8000589c:	00001097          	auipc	ra,0x1
    800058a0:	dd6080e7          	jalr	-554(ra) # 80006672 <acquire>
  for(int i = 0; i < 3; i++){
    800058a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800058a6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800058a8:	0001fb97          	auipc	s7,0x1f
    800058ac:	758b8b93          	addi	s7,s7,1880 # 80025000 <disk>
    800058b0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800058b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800058b4:	8a4e                	mv	s4,s3
    800058b6:	a051                	j	8000593a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800058b8:	00fb86b3          	add	a3,s7,a5
    800058bc:	96da                	add	a3,a3,s6
    800058be:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800058c2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800058c4:	0207c563          	bltz	a5,800058ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800058c8:	2485                	addiw	s1,s1,1
    800058ca:	0711                	addi	a4,a4,4
    800058cc:	25548063          	beq	s1,s5,80005b0c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800058d0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800058d2:	00021697          	auipc	a3,0x21
    800058d6:	74668693          	addi	a3,a3,1862 # 80027018 <disk+0x2018>
    800058da:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800058dc:	0006c583          	lbu	a1,0(a3)
    800058e0:	fde1                	bnez	a1,800058b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800058e2:	2785                	addiw	a5,a5,1
    800058e4:	0685                	addi	a3,a3,1
    800058e6:	ff879be3          	bne	a5,s8,800058dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800058ea:	57fd                	li	a5,-1
    800058ec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800058ee:	02905a63          	blez	s1,80005922 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800058f2:	f9042503          	lw	a0,-112(s0)
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	d90080e7          	jalr	-624(ra) # 80005686 <free_desc>
      for(int j = 0; j < i; j++)
    800058fe:	4785                	li	a5,1
    80005900:	0297d163          	bge	a5,s1,80005922 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005904:	f9442503          	lw	a0,-108(s0)
    80005908:	00000097          	auipc	ra,0x0
    8000590c:	d7e080e7          	jalr	-642(ra) # 80005686 <free_desc>
      for(int j = 0; j < i; j++)
    80005910:	4789                	li	a5,2
    80005912:	0097d863          	bge	a5,s1,80005922 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005916:	f9842503          	lw	a0,-104(s0)
    8000591a:	00000097          	auipc	ra,0x0
    8000591e:	d6c080e7          	jalr	-660(ra) # 80005686 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005922:	00022597          	auipc	a1,0x22
    80005926:	80658593          	addi	a1,a1,-2042 # 80027128 <disk+0x2128>
    8000592a:	00021517          	auipc	a0,0x21
    8000592e:	6ee50513          	addi	a0,a0,1774 # 80027018 <disk+0x2018>
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	c42080e7          	jalr	-958(ra) # 80001574 <sleep>
  for(int i = 0; i < 3; i++){
    8000593a:	f9040713          	addi	a4,s0,-112
    8000593e:	84ce                	mv	s1,s3
    80005940:	bf41                	j	800058d0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005942:	20058713          	addi	a4,a1,512
    80005946:	00471693          	slli	a3,a4,0x4
    8000594a:	0001f717          	auipc	a4,0x1f
    8000594e:	6b670713          	addi	a4,a4,1718 # 80025000 <disk>
    80005952:	9736                	add	a4,a4,a3
    80005954:	4685                	li	a3,1
    80005956:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000595a:	20058713          	addi	a4,a1,512
    8000595e:	00471693          	slli	a3,a4,0x4
    80005962:	0001f717          	auipc	a4,0x1f
    80005966:	69e70713          	addi	a4,a4,1694 # 80025000 <disk>
    8000596a:	9736                	add	a4,a4,a3
    8000596c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005970:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005974:	7679                	lui	a2,0xffffe
    80005976:	963e                	add	a2,a2,a5
    80005978:	00021697          	auipc	a3,0x21
    8000597c:	68868693          	addi	a3,a3,1672 # 80027000 <disk+0x2000>
    80005980:	6298                	ld	a4,0(a3)
    80005982:	9732                	add	a4,a4,a2
    80005984:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005986:	6298                	ld	a4,0(a3)
    80005988:	9732                	add	a4,a4,a2
    8000598a:	4541                	li	a0,16
    8000598c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000598e:	6298                	ld	a4,0(a3)
    80005990:	9732                	add	a4,a4,a2
    80005992:	4505                	li	a0,1
    80005994:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005998:	f9442703          	lw	a4,-108(s0)
    8000599c:	6288                	ld	a0,0(a3)
    8000599e:	962a                	add	a2,a2,a0
    800059a0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcddce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800059a4:	0712                	slli	a4,a4,0x4
    800059a6:	6290                	ld	a2,0(a3)
    800059a8:	963a                	add	a2,a2,a4
    800059aa:	05890513          	addi	a0,s2,88
    800059ae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800059b0:	6294                	ld	a3,0(a3)
    800059b2:	96ba                	add	a3,a3,a4
    800059b4:	40000613          	li	a2,1024
    800059b8:	c690                	sw	a2,8(a3)
  if(write)
    800059ba:	140d0063          	beqz	s10,80005afa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800059be:	00021697          	auipc	a3,0x21
    800059c2:	6426b683          	ld	a3,1602(a3) # 80027000 <disk+0x2000>
    800059c6:	96ba                	add	a3,a3,a4
    800059c8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059cc:	0001f817          	auipc	a6,0x1f
    800059d0:	63480813          	addi	a6,a6,1588 # 80025000 <disk>
    800059d4:	00021517          	auipc	a0,0x21
    800059d8:	62c50513          	addi	a0,a0,1580 # 80027000 <disk+0x2000>
    800059dc:	6114                	ld	a3,0(a0)
    800059de:	96ba                	add	a3,a3,a4
    800059e0:	00c6d603          	lhu	a2,12(a3)
    800059e4:	00166613          	ori	a2,a2,1
    800059e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800059ec:	f9842683          	lw	a3,-104(s0)
    800059f0:	6110                	ld	a2,0(a0)
    800059f2:	9732                	add	a4,a4,a2
    800059f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059f8:	20058613          	addi	a2,a1,512
    800059fc:	0612                	slli	a2,a2,0x4
    800059fe:	9642                	add	a2,a2,a6
    80005a00:	577d                	li	a4,-1
    80005a02:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a06:	00469713          	slli	a4,a3,0x4
    80005a0a:	6114                	ld	a3,0(a0)
    80005a0c:	96ba                	add	a3,a3,a4
    80005a0e:	03078793          	addi	a5,a5,48
    80005a12:	97c2                	add	a5,a5,a6
    80005a14:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005a16:	611c                	ld	a5,0(a0)
    80005a18:	97ba                	add	a5,a5,a4
    80005a1a:	4685                	li	a3,1
    80005a1c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a1e:	611c                	ld	a5,0(a0)
    80005a20:	97ba                	add	a5,a5,a4
    80005a22:	4809                	li	a6,2
    80005a24:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005a28:	611c                	ld	a5,0(a0)
    80005a2a:	973e                	add	a4,a4,a5
    80005a2c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a30:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005a34:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a38:	6518                	ld	a4,8(a0)
    80005a3a:	00275783          	lhu	a5,2(a4)
    80005a3e:	8b9d                	andi	a5,a5,7
    80005a40:	0786                	slli	a5,a5,0x1
    80005a42:	97ba                	add	a5,a5,a4
    80005a44:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005a48:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a4c:	6518                	ld	a4,8(a0)
    80005a4e:	00275783          	lhu	a5,2(a4)
    80005a52:	2785                	addiw	a5,a5,1
    80005a54:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a58:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a5c:	100017b7          	lui	a5,0x10001
    80005a60:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a64:	00492703          	lw	a4,4(s2)
    80005a68:	4785                	li	a5,1
    80005a6a:	02f71163          	bne	a4,a5,80005a8c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005a6e:	00021997          	auipc	s3,0x21
    80005a72:	6ba98993          	addi	s3,s3,1722 # 80027128 <disk+0x2128>
  while(b->disk == 1) {
    80005a76:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005a78:	85ce                	mv	a1,s3
    80005a7a:	854a                	mv	a0,s2
    80005a7c:	ffffc097          	auipc	ra,0xffffc
    80005a80:	af8080e7          	jalr	-1288(ra) # 80001574 <sleep>
  while(b->disk == 1) {
    80005a84:	00492783          	lw	a5,4(s2)
    80005a88:	fe9788e3          	beq	a5,s1,80005a78 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005a8c:	f9042903          	lw	s2,-112(s0)
    80005a90:	20090793          	addi	a5,s2,512
    80005a94:	00479713          	slli	a4,a5,0x4
    80005a98:	0001f797          	auipc	a5,0x1f
    80005a9c:	56878793          	addi	a5,a5,1384 # 80025000 <disk>
    80005aa0:	97ba                	add	a5,a5,a4
    80005aa2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005aa6:	00021997          	auipc	s3,0x21
    80005aaa:	55a98993          	addi	s3,s3,1370 # 80027000 <disk+0x2000>
    80005aae:	00491713          	slli	a4,s2,0x4
    80005ab2:	0009b783          	ld	a5,0(s3)
    80005ab6:	97ba                	add	a5,a5,a4
    80005ab8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005abc:	854a                	mv	a0,s2
    80005abe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	bc4080e7          	jalr	-1084(ra) # 80005686 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005aca:	8885                	andi	s1,s1,1
    80005acc:	f0ed                	bnez	s1,80005aae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005ace:	00021517          	auipc	a0,0x21
    80005ad2:	65a50513          	addi	a0,a0,1626 # 80027128 <disk+0x2128>
    80005ad6:	00001097          	auipc	ra,0x1
    80005ada:	c50080e7          	jalr	-944(ra) # 80006726 <release>
}
    80005ade:	70a6                	ld	ra,104(sp)
    80005ae0:	7406                	ld	s0,96(sp)
    80005ae2:	64e6                	ld	s1,88(sp)
    80005ae4:	6946                	ld	s2,80(sp)
    80005ae6:	69a6                	ld	s3,72(sp)
    80005ae8:	6a06                	ld	s4,64(sp)
    80005aea:	7ae2                	ld	s5,56(sp)
    80005aec:	7b42                	ld	s6,48(sp)
    80005aee:	7ba2                	ld	s7,40(sp)
    80005af0:	7c02                	ld	s8,32(sp)
    80005af2:	6ce2                	ld	s9,24(sp)
    80005af4:	6d42                	ld	s10,16(sp)
    80005af6:	6165                	addi	sp,sp,112
    80005af8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005afa:	00021697          	auipc	a3,0x21
    80005afe:	5066b683          	ld	a3,1286(a3) # 80027000 <disk+0x2000>
    80005b02:	96ba                	add	a3,a3,a4
    80005b04:	4609                	li	a2,2
    80005b06:	00c69623          	sh	a2,12(a3)
    80005b0a:	b5c9                	j	800059cc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b0c:	f9042583          	lw	a1,-112(s0)
    80005b10:	20058793          	addi	a5,a1,512
    80005b14:	0792                	slli	a5,a5,0x4
    80005b16:	0001f517          	auipc	a0,0x1f
    80005b1a:	59250513          	addi	a0,a0,1426 # 800250a8 <disk+0xa8>
    80005b1e:	953e                	add	a0,a0,a5
  if(write)
    80005b20:	e20d11e3          	bnez	s10,80005942 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005b24:	20058713          	addi	a4,a1,512
    80005b28:	00471693          	slli	a3,a4,0x4
    80005b2c:	0001f717          	auipc	a4,0x1f
    80005b30:	4d470713          	addi	a4,a4,1236 # 80025000 <disk>
    80005b34:	9736                	add	a4,a4,a3
    80005b36:	0a072423          	sw	zero,168(a4)
    80005b3a:	b505                	j	8000595a <virtio_disk_rw+0xf4>

0000000080005b3c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b3c:	1101                	addi	sp,sp,-32
    80005b3e:	ec06                	sd	ra,24(sp)
    80005b40:	e822                	sd	s0,16(sp)
    80005b42:	e426                	sd	s1,8(sp)
    80005b44:	e04a                	sd	s2,0(sp)
    80005b46:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b48:	00021517          	auipc	a0,0x21
    80005b4c:	5e050513          	addi	a0,a0,1504 # 80027128 <disk+0x2128>
    80005b50:	00001097          	auipc	ra,0x1
    80005b54:	b22080e7          	jalr	-1246(ra) # 80006672 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b58:	10001737          	lui	a4,0x10001
    80005b5c:	533c                	lw	a5,96(a4)
    80005b5e:	8b8d                	andi	a5,a5,3
    80005b60:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b62:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b66:	00021797          	auipc	a5,0x21
    80005b6a:	49a78793          	addi	a5,a5,1178 # 80027000 <disk+0x2000>
    80005b6e:	6b94                	ld	a3,16(a5)
    80005b70:	0207d703          	lhu	a4,32(a5)
    80005b74:	0026d783          	lhu	a5,2(a3)
    80005b78:	06f70163          	beq	a4,a5,80005bda <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b7c:	0001f917          	auipc	s2,0x1f
    80005b80:	48490913          	addi	s2,s2,1156 # 80025000 <disk>
    80005b84:	00021497          	auipc	s1,0x21
    80005b88:	47c48493          	addi	s1,s1,1148 # 80027000 <disk+0x2000>
    __sync_synchronize();
    80005b8c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b90:	6898                	ld	a4,16(s1)
    80005b92:	0204d783          	lhu	a5,32(s1)
    80005b96:	8b9d                	andi	a5,a5,7
    80005b98:	078e                	slli	a5,a5,0x3
    80005b9a:	97ba                	add	a5,a5,a4
    80005b9c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b9e:	20078713          	addi	a4,a5,512
    80005ba2:	0712                	slli	a4,a4,0x4
    80005ba4:	974a                	add	a4,a4,s2
    80005ba6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005baa:	e731                	bnez	a4,80005bf6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005bac:	20078793          	addi	a5,a5,512
    80005bb0:	0792                	slli	a5,a5,0x4
    80005bb2:	97ca                	add	a5,a5,s2
    80005bb4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005bb6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005bba:	ffffc097          	auipc	ra,0xffffc
    80005bbe:	b46080e7          	jalr	-1210(ra) # 80001700 <wakeup>

    disk.used_idx += 1;
    80005bc2:	0204d783          	lhu	a5,32(s1)
    80005bc6:	2785                	addiw	a5,a5,1
    80005bc8:	17c2                	slli	a5,a5,0x30
    80005bca:	93c1                	srli	a5,a5,0x30
    80005bcc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bd0:	6898                	ld	a4,16(s1)
    80005bd2:	00275703          	lhu	a4,2(a4)
    80005bd6:	faf71be3          	bne	a4,a5,80005b8c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005bda:	00021517          	auipc	a0,0x21
    80005bde:	54e50513          	addi	a0,a0,1358 # 80027128 <disk+0x2128>
    80005be2:	00001097          	auipc	ra,0x1
    80005be6:	b44080e7          	jalr	-1212(ra) # 80006726 <release>
}
    80005bea:	60e2                	ld	ra,24(sp)
    80005bec:	6442                	ld	s0,16(sp)
    80005bee:	64a2                	ld	s1,8(sp)
    80005bf0:	6902                	ld	s2,0(sp)
    80005bf2:	6105                	addi	sp,sp,32
    80005bf4:	8082                	ret
      panic("virtio_disk_intr status");
    80005bf6:	00003517          	auipc	a0,0x3
    80005bfa:	b9250513          	addi	a0,a0,-1134 # 80008788 <syscalls+0x3c0>
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	52a080e7          	jalr	1322(ra) # 80006128 <panic>

0000000080005c06 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c06:	1141                	addi	sp,sp,-16
    80005c08:	e422                	sd	s0,8(sp)
    80005c0a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c0c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c10:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c14:	0037979b          	slliw	a5,a5,0x3
    80005c18:	02004737          	lui	a4,0x2004
    80005c1c:	97ba                	add	a5,a5,a4
    80005c1e:	0200c737          	lui	a4,0x200c
    80005c22:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c26:	000f4637          	lui	a2,0xf4
    80005c2a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c2e:	95b2                	add	a1,a1,a2
    80005c30:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c32:	00269713          	slli	a4,a3,0x2
    80005c36:	9736                	add	a4,a4,a3
    80005c38:	00371693          	slli	a3,a4,0x3
    80005c3c:	00022717          	auipc	a4,0x22
    80005c40:	3c470713          	addi	a4,a4,964 # 80028000 <timer_scratch>
    80005c44:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c46:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c48:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c4a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c4e:	00000797          	auipc	a5,0x0
    80005c52:	97278793          	addi	a5,a5,-1678 # 800055c0 <timervec>
    80005c56:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c5a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c5e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c62:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c66:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c6a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c6e:	30479073          	csrw	mie,a5
}
    80005c72:	6422                	ld	s0,8(sp)
    80005c74:	0141                	addi	sp,sp,16
    80005c76:	8082                	ret

0000000080005c78 <start>:
{
    80005c78:	1141                	addi	sp,sp,-16
    80005c7a:	e406                	sd	ra,8(sp)
    80005c7c:	e022                	sd	s0,0(sp)
    80005c7e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c80:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c84:	7779                	lui	a4,0xffffe
    80005c86:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffce5bf>
    80005c8a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c8c:	6705                	lui	a4,0x1
    80005c8e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c92:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c94:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c98:	ffffa797          	auipc	a5,0xffffa
    80005c9c:	68e78793          	addi	a5,a5,1678 # 80000326 <main>
    80005ca0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005ca4:	4781                	li	a5,0
    80005ca6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005caa:	67c1                	lui	a5,0x10
    80005cac:	17fd                	addi	a5,a5,-1
    80005cae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005cb2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cb6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cbe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cc2:	57fd                	li	a5,-1
    80005cc4:	83a9                	srli	a5,a5,0xa
    80005cc6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cca:	47bd                	li	a5,15
    80005ccc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	f36080e7          	jalr	-202(ra) # 80005c06 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cd8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005cdc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005cde:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ce0:	30200073          	mret
}
    80005ce4:	60a2                	ld	ra,8(sp)
    80005ce6:	6402                	ld	s0,0(sp)
    80005ce8:	0141                	addi	sp,sp,16
    80005cea:	8082                	ret

0000000080005cec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cec:	715d                	addi	sp,sp,-80
    80005cee:	e486                	sd	ra,72(sp)
    80005cf0:	e0a2                	sd	s0,64(sp)
    80005cf2:	fc26                	sd	s1,56(sp)
    80005cf4:	f84a                	sd	s2,48(sp)
    80005cf6:	f44e                	sd	s3,40(sp)
    80005cf8:	f052                	sd	s4,32(sp)
    80005cfa:	ec56                	sd	s5,24(sp)
    80005cfc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cfe:	04c05663          	blez	a2,80005d4a <consolewrite+0x5e>
    80005d02:	8a2a                	mv	s4,a0
    80005d04:	84ae                	mv	s1,a1
    80005d06:	89b2                	mv	s3,a2
    80005d08:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d0a:	5afd                	li	s5,-1
    80005d0c:	4685                	li	a3,1
    80005d0e:	8626                	mv	a2,s1
    80005d10:	85d2                	mv	a1,s4
    80005d12:	fbf40513          	addi	a0,s0,-65
    80005d16:	ffffc097          	auipc	ra,0xffffc
    80005d1a:	d2c080e7          	jalr	-724(ra) # 80001a42 <either_copyin>
    80005d1e:	01550c63          	beq	a0,s5,80005d36 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005d22:	fbf44503          	lbu	a0,-65(s0)
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	78e080e7          	jalr	1934(ra) # 800064b4 <uartputc>
  for(i = 0; i < n; i++){
    80005d2e:	2905                	addiw	s2,s2,1
    80005d30:	0485                	addi	s1,s1,1
    80005d32:	fd299de3          	bne	s3,s2,80005d0c <consolewrite+0x20>
  }

  return i;
}
    80005d36:	854a                	mv	a0,s2
    80005d38:	60a6                	ld	ra,72(sp)
    80005d3a:	6406                	ld	s0,64(sp)
    80005d3c:	74e2                	ld	s1,56(sp)
    80005d3e:	7942                	ld	s2,48(sp)
    80005d40:	79a2                	ld	s3,40(sp)
    80005d42:	7a02                	ld	s4,32(sp)
    80005d44:	6ae2                	ld	s5,24(sp)
    80005d46:	6161                	addi	sp,sp,80
    80005d48:	8082                	ret
  for(i = 0; i < n; i++){
    80005d4a:	4901                	li	s2,0
    80005d4c:	b7ed                	j	80005d36 <consolewrite+0x4a>

0000000080005d4e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d4e:	7119                	addi	sp,sp,-128
    80005d50:	fc86                	sd	ra,120(sp)
    80005d52:	f8a2                	sd	s0,112(sp)
    80005d54:	f4a6                	sd	s1,104(sp)
    80005d56:	f0ca                	sd	s2,96(sp)
    80005d58:	ecce                	sd	s3,88(sp)
    80005d5a:	e8d2                	sd	s4,80(sp)
    80005d5c:	e4d6                	sd	s5,72(sp)
    80005d5e:	e0da                	sd	s6,64(sp)
    80005d60:	fc5e                	sd	s7,56(sp)
    80005d62:	f862                	sd	s8,48(sp)
    80005d64:	f466                	sd	s9,40(sp)
    80005d66:	f06a                	sd	s10,32(sp)
    80005d68:	ec6e                	sd	s11,24(sp)
    80005d6a:	0100                	addi	s0,sp,128
    80005d6c:	8b2a                	mv	s6,a0
    80005d6e:	8aae                	mv	s5,a1
    80005d70:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d72:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d76:	0002a517          	auipc	a0,0x2a
    80005d7a:	3ca50513          	addi	a0,a0,970 # 80030140 <cons>
    80005d7e:	00001097          	auipc	ra,0x1
    80005d82:	8f4080e7          	jalr	-1804(ra) # 80006672 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d86:	0002a497          	auipc	s1,0x2a
    80005d8a:	3ba48493          	addi	s1,s1,954 # 80030140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d8e:	89a6                	mv	s3,s1
    80005d90:	0002a917          	auipc	s2,0x2a
    80005d94:	44890913          	addi	s2,s2,1096 # 800301d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d98:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d9a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d9c:	4da9                	li	s11,10
  while(n > 0){
    80005d9e:	07405863          	blez	s4,80005e0e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005da2:	0984a783          	lw	a5,152(s1)
    80005da6:	09c4a703          	lw	a4,156(s1)
    80005daa:	02f71463          	bne	a4,a5,80005dd2 <consoleread+0x84>
      if(myproc()->killed){
    80005dae:	ffffb097          	auipc	ra,0xffffb
    80005db2:	09a080e7          	jalr	154(ra) # 80000e48 <myproc>
    80005db6:	551c                	lw	a5,40(a0)
    80005db8:	e7b5                	bnez	a5,80005e24 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005dba:	85ce                	mv	a1,s3
    80005dbc:	854a                	mv	a0,s2
    80005dbe:	ffffb097          	auipc	ra,0xffffb
    80005dc2:	7b6080e7          	jalr	1974(ra) # 80001574 <sleep>
    while(cons.r == cons.w){
    80005dc6:	0984a783          	lw	a5,152(s1)
    80005dca:	09c4a703          	lw	a4,156(s1)
    80005dce:	fef700e3          	beq	a4,a5,80005dae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005dd2:	0017871b          	addiw	a4,a5,1
    80005dd6:	08e4ac23          	sw	a4,152(s1)
    80005dda:	07f7f713          	andi	a4,a5,127
    80005dde:	9726                	add	a4,a4,s1
    80005de0:	01874703          	lbu	a4,24(a4)
    80005de4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005de8:	079c0663          	beq	s8,s9,80005e54 <consoleread+0x106>
    cbuf = c;
    80005dec:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005df0:	4685                	li	a3,1
    80005df2:	f8f40613          	addi	a2,s0,-113
    80005df6:	85d6                	mv	a1,s5
    80005df8:	855a                	mv	a0,s6
    80005dfa:	ffffc097          	auipc	ra,0xffffc
    80005dfe:	bf2080e7          	jalr	-1038(ra) # 800019ec <either_copyout>
    80005e02:	01a50663          	beq	a0,s10,80005e0e <consoleread+0xc0>
    dst++;
    80005e06:	0a85                	addi	s5,s5,1
    --n;
    80005e08:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005e0a:	f9bc1ae3          	bne	s8,s11,80005d9e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005e0e:	0002a517          	auipc	a0,0x2a
    80005e12:	33250513          	addi	a0,a0,818 # 80030140 <cons>
    80005e16:	00001097          	auipc	ra,0x1
    80005e1a:	910080e7          	jalr	-1776(ra) # 80006726 <release>

  return target - n;
    80005e1e:	414b853b          	subw	a0,s7,s4
    80005e22:	a811                	j	80005e36 <consoleread+0xe8>
        release(&cons.lock);
    80005e24:	0002a517          	auipc	a0,0x2a
    80005e28:	31c50513          	addi	a0,a0,796 # 80030140 <cons>
    80005e2c:	00001097          	auipc	ra,0x1
    80005e30:	8fa080e7          	jalr	-1798(ra) # 80006726 <release>
        return -1;
    80005e34:	557d                	li	a0,-1
}
    80005e36:	70e6                	ld	ra,120(sp)
    80005e38:	7446                	ld	s0,112(sp)
    80005e3a:	74a6                	ld	s1,104(sp)
    80005e3c:	7906                	ld	s2,96(sp)
    80005e3e:	69e6                	ld	s3,88(sp)
    80005e40:	6a46                	ld	s4,80(sp)
    80005e42:	6aa6                	ld	s5,72(sp)
    80005e44:	6b06                	ld	s6,64(sp)
    80005e46:	7be2                	ld	s7,56(sp)
    80005e48:	7c42                	ld	s8,48(sp)
    80005e4a:	7ca2                	ld	s9,40(sp)
    80005e4c:	7d02                	ld	s10,32(sp)
    80005e4e:	6de2                	ld	s11,24(sp)
    80005e50:	6109                	addi	sp,sp,128
    80005e52:	8082                	ret
      if(n < target){
    80005e54:	000a071b          	sext.w	a4,s4
    80005e58:	fb777be3          	bgeu	a4,s7,80005e0e <consoleread+0xc0>
        cons.r--;
    80005e5c:	0002a717          	auipc	a4,0x2a
    80005e60:	36f72e23          	sw	a5,892(a4) # 800301d8 <cons+0x98>
    80005e64:	b76d                	j	80005e0e <consoleread+0xc0>

0000000080005e66 <consputc>:
{
    80005e66:	1141                	addi	sp,sp,-16
    80005e68:	e406                	sd	ra,8(sp)
    80005e6a:	e022                	sd	s0,0(sp)
    80005e6c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e6e:	10000793          	li	a5,256
    80005e72:	00f50a63          	beq	a0,a5,80005e86 <consputc+0x20>
    uartputc_sync(c);
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	564080e7          	jalr	1380(ra) # 800063da <uartputc_sync>
}
    80005e7e:	60a2                	ld	ra,8(sp)
    80005e80:	6402                	ld	s0,0(sp)
    80005e82:	0141                	addi	sp,sp,16
    80005e84:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e86:	4521                	li	a0,8
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	552080e7          	jalr	1362(ra) # 800063da <uartputc_sync>
    80005e90:	02000513          	li	a0,32
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	546080e7          	jalr	1350(ra) # 800063da <uartputc_sync>
    80005e9c:	4521                	li	a0,8
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	53c080e7          	jalr	1340(ra) # 800063da <uartputc_sync>
    80005ea6:	bfe1                	j	80005e7e <consputc+0x18>

0000000080005ea8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ea8:	1101                	addi	sp,sp,-32
    80005eaa:	ec06                	sd	ra,24(sp)
    80005eac:	e822                	sd	s0,16(sp)
    80005eae:	e426                	sd	s1,8(sp)
    80005eb0:	e04a                	sd	s2,0(sp)
    80005eb2:	1000                	addi	s0,sp,32
    80005eb4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005eb6:	0002a517          	auipc	a0,0x2a
    80005eba:	28a50513          	addi	a0,a0,650 # 80030140 <cons>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	7b4080e7          	jalr	1972(ra) # 80006672 <acquire>

  switch(c){
    80005ec6:	47d5                	li	a5,21
    80005ec8:	0af48663          	beq	s1,a5,80005f74 <consoleintr+0xcc>
    80005ecc:	0297ca63          	blt	a5,s1,80005f00 <consoleintr+0x58>
    80005ed0:	47a1                	li	a5,8
    80005ed2:	0ef48763          	beq	s1,a5,80005fc0 <consoleintr+0x118>
    80005ed6:	47c1                	li	a5,16
    80005ed8:	10f49a63          	bne	s1,a5,80005fec <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005edc:	ffffc097          	auipc	ra,0xffffc
    80005ee0:	bbc080e7          	jalr	-1092(ra) # 80001a98 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ee4:	0002a517          	auipc	a0,0x2a
    80005ee8:	25c50513          	addi	a0,a0,604 # 80030140 <cons>
    80005eec:	00001097          	auipc	ra,0x1
    80005ef0:	83a080e7          	jalr	-1990(ra) # 80006726 <release>
}
    80005ef4:	60e2                	ld	ra,24(sp)
    80005ef6:	6442                	ld	s0,16(sp)
    80005ef8:	64a2                	ld	s1,8(sp)
    80005efa:	6902                	ld	s2,0(sp)
    80005efc:	6105                	addi	sp,sp,32
    80005efe:	8082                	ret
  switch(c){
    80005f00:	07f00793          	li	a5,127
    80005f04:	0af48e63          	beq	s1,a5,80005fc0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f08:	0002a717          	auipc	a4,0x2a
    80005f0c:	23870713          	addi	a4,a4,568 # 80030140 <cons>
    80005f10:	0a072783          	lw	a5,160(a4)
    80005f14:	09872703          	lw	a4,152(a4)
    80005f18:	9f99                	subw	a5,a5,a4
    80005f1a:	07f00713          	li	a4,127
    80005f1e:	fcf763e3          	bltu	a4,a5,80005ee4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f22:	47b5                	li	a5,13
    80005f24:	0cf48763          	beq	s1,a5,80005ff2 <consoleintr+0x14a>
      consputc(c);
    80005f28:	8526                	mv	a0,s1
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	f3c080e7          	jalr	-196(ra) # 80005e66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f32:	0002a797          	auipc	a5,0x2a
    80005f36:	20e78793          	addi	a5,a5,526 # 80030140 <cons>
    80005f3a:	0a07a703          	lw	a4,160(a5)
    80005f3e:	0017069b          	addiw	a3,a4,1
    80005f42:	0006861b          	sext.w	a2,a3
    80005f46:	0ad7a023          	sw	a3,160(a5)
    80005f4a:	07f77713          	andi	a4,a4,127
    80005f4e:	97ba                	add	a5,a5,a4
    80005f50:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f54:	47a9                	li	a5,10
    80005f56:	0cf48563          	beq	s1,a5,80006020 <consoleintr+0x178>
    80005f5a:	4791                	li	a5,4
    80005f5c:	0cf48263          	beq	s1,a5,80006020 <consoleintr+0x178>
    80005f60:	0002a797          	auipc	a5,0x2a
    80005f64:	2787a783          	lw	a5,632(a5) # 800301d8 <cons+0x98>
    80005f68:	0807879b          	addiw	a5,a5,128
    80005f6c:	f6f61ce3          	bne	a2,a5,80005ee4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f70:	863e                	mv	a2,a5
    80005f72:	a07d                	j	80006020 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f74:	0002a717          	auipc	a4,0x2a
    80005f78:	1cc70713          	addi	a4,a4,460 # 80030140 <cons>
    80005f7c:	0a072783          	lw	a5,160(a4)
    80005f80:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f84:	0002a497          	auipc	s1,0x2a
    80005f88:	1bc48493          	addi	s1,s1,444 # 80030140 <cons>
    while(cons.e != cons.w &&
    80005f8c:	4929                	li	s2,10
    80005f8e:	f4f70be3          	beq	a4,a5,80005ee4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f92:	37fd                	addiw	a5,a5,-1
    80005f94:	07f7f713          	andi	a4,a5,127
    80005f98:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f9a:	01874703          	lbu	a4,24(a4)
    80005f9e:	f52703e3          	beq	a4,s2,80005ee4 <consoleintr+0x3c>
      cons.e--;
    80005fa2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005fa6:	10000513          	li	a0,256
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	ebc080e7          	jalr	-324(ra) # 80005e66 <consputc>
    while(cons.e != cons.w &&
    80005fb2:	0a04a783          	lw	a5,160(s1)
    80005fb6:	09c4a703          	lw	a4,156(s1)
    80005fba:	fcf71ce3          	bne	a4,a5,80005f92 <consoleintr+0xea>
    80005fbe:	b71d                	j	80005ee4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005fc0:	0002a717          	auipc	a4,0x2a
    80005fc4:	18070713          	addi	a4,a4,384 # 80030140 <cons>
    80005fc8:	0a072783          	lw	a5,160(a4)
    80005fcc:	09c72703          	lw	a4,156(a4)
    80005fd0:	f0f70ae3          	beq	a4,a5,80005ee4 <consoleintr+0x3c>
      cons.e--;
    80005fd4:	37fd                	addiw	a5,a5,-1
    80005fd6:	0002a717          	auipc	a4,0x2a
    80005fda:	20f72523          	sw	a5,522(a4) # 800301e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005fde:	10000513          	li	a0,256
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	e84080e7          	jalr	-380(ra) # 80005e66 <consputc>
    80005fea:	bded                	j	80005ee4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fec:	ee048ce3          	beqz	s1,80005ee4 <consoleintr+0x3c>
    80005ff0:	bf21                	j	80005f08 <consoleintr+0x60>
      consputc(c);
    80005ff2:	4529                	li	a0,10
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	e72080e7          	jalr	-398(ra) # 80005e66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ffc:	0002a797          	auipc	a5,0x2a
    80006000:	14478793          	addi	a5,a5,324 # 80030140 <cons>
    80006004:	0a07a703          	lw	a4,160(a5)
    80006008:	0017069b          	addiw	a3,a4,1
    8000600c:	0006861b          	sext.w	a2,a3
    80006010:	0ad7a023          	sw	a3,160(a5)
    80006014:	07f77713          	andi	a4,a4,127
    80006018:	97ba                	add	a5,a5,a4
    8000601a:	4729                	li	a4,10
    8000601c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006020:	0002a797          	auipc	a5,0x2a
    80006024:	1ac7ae23          	sw	a2,444(a5) # 800301dc <cons+0x9c>
        wakeup(&cons.r);
    80006028:	0002a517          	auipc	a0,0x2a
    8000602c:	1b050513          	addi	a0,a0,432 # 800301d8 <cons+0x98>
    80006030:	ffffb097          	auipc	ra,0xffffb
    80006034:	6d0080e7          	jalr	1744(ra) # 80001700 <wakeup>
    80006038:	b575                	j	80005ee4 <consoleintr+0x3c>

000000008000603a <consoleinit>:

void
consoleinit(void)
{
    8000603a:	1141                	addi	sp,sp,-16
    8000603c:	e406                	sd	ra,8(sp)
    8000603e:	e022                	sd	s0,0(sp)
    80006040:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006042:	00002597          	auipc	a1,0x2
    80006046:	75e58593          	addi	a1,a1,1886 # 800087a0 <syscalls+0x3d8>
    8000604a:	0002a517          	auipc	a0,0x2a
    8000604e:	0f650513          	addi	a0,a0,246 # 80030140 <cons>
    80006052:	00000097          	auipc	ra,0x0
    80006056:	590080e7          	jalr	1424(ra) # 800065e2 <initlock>

  uartinit();
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	330080e7          	jalr	816(ra) # 8000638a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006062:	0001d797          	auipc	a5,0x1d
    80006066:	06678793          	addi	a5,a5,102 # 800230c8 <devsw>
    8000606a:	00000717          	auipc	a4,0x0
    8000606e:	ce470713          	addi	a4,a4,-796 # 80005d4e <consoleread>
    80006072:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006074:	00000717          	auipc	a4,0x0
    80006078:	c7870713          	addi	a4,a4,-904 # 80005cec <consolewrite>
    8000607c:	ef98                	sd	a4,24(a5)
}
    8000607e:	60a2                	ld	ra,8(sp)
    80006080:	6402                	ld	s0,0(sp)
    80006082:	0141                	addi	sp,sp,16
    80006084:	8082                	ret

0000000080006086 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006086:	7179                	addi	sp,sp,-48
    80006088:	f406                	sd	ra,40(sp)
    8000608a:	f022                	sd	s0,32(sp)
    8000608c:	ec26                	sd	s1,24(sp)
    8000608e:	e84a                	sd	s2,16(sp)
    80006090:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006092:	c219                	beqz	a2,80006098 <printint+0x12>
    80006094:	08054663          	bltz	a0,80006120 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006098:	2501                	sext.w	a0,a0
    8000609a:	4881                	li	a7,0
    8000609c:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060a0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060a2:	2581                	sext.w	a1,a1
    800060a4:	00002617          	auipc	a2,0x2
    800060a8:	72c60613          	addi	a2,a2,1836 # 800087d0 <digits>
    800060ac:	883a                	mv	a6,a4
    800060ae:	2705                	addiw	a4,a4,1
    800060b0:	02b577bb          	remuw	a5,a0,a1
    800060b4:	1782                	slli	a5,a5,0x20
    800060b6:	9381                	srli	a5,a5,0x20
    800060b8:	97b2                	add	a5,a5,a2
    800060ba:	0007c783          	lbu	a5,0(a5)
    800060be:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060c2:	0005079b          	sext.w	a5,a0
    800060c6:	02b5553b          	divuw	a0,a0,a1
    800060ca:	0685                	addi	a3,a3,1
    800060cc:	feb7f0e3          	bgeu	a5,a1,800060ac <printint+0x26>

  if(sign)
    800060d0:	00088b63          	beqz	a7,800060e6 <printint+0x60>
    buf[i++] = '-';
    800060d4:	fe040793          	addi	a5,s0,-32
    800060d8:	973e                	add	a4,a4,a5
    800060da:	02d00793          	li	a5,45
    800060de:	fef70823          	sb	a5,-16(a4)
    800060e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060e6:	02e05763          	blez	a4,80006114 <printint+0x8e>
    800060ea:	fd040793          	addi	a5,s0,-48
    800060ee:	00e784b3          	add	s1,a5,a4
    800060f2:	fff78913          	addi	s2,a5,-1
    800060f6:	993a                	add	s2,s2,a4
    800060f8:	377d                	addiw	a4,a4,-1
    800060fa:	1702                	slli	a4,a4,0x20
    800060fc:	9301                	srli	a4,a4,0x20
    800060fe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006102:	fff4c503          	lbu	a0,-1(s1)
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	d60080e7          	jalr	-672(ra) # 80005e66 <consputc>
  while(--i >= 0)
    8000610e:	14fd                	addi	s1,s1,-1
    80006110:	ff2499e3          	bne	s1,s2,80006102 <printint+0x7c>
}
    80006114:	70a2                	ld	ra,40(sp)
    80006116:	7402                	ld	s0,32(sp)
    80006118:	64e2                	ld	s1,24(sp)
    8000611a:	6942                	ld	s2,16(sp)
    8000611c:	6145                	addi	sp,sp,48
    8000611e:	8082                	ret
    x = -xx;
    80006120:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006124:	4885                	li	a7,1
    x = -xx;
    80006126:	bf9d                	j	8000609c <printint+0x16>

0000000080006128 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006128:	1101                	addi	sp,sp,-32
    8000612a:	ec06                	sd	ra,24(sp)
    8000612c:	e822                	sd	s0,16(sp)
    8000612e:	e426                	sd	s1,8(sp)
    80006130:	1000                	addi	s0,sp,32
    80006132:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006134:	0002a797          	auipc	a5,0x2a
    80006138:	0c07a623          	sw	zero,204(a5) # 80030200 <pr+0x18>
  printf("panic: ");
    8000613c:	00002517          	auipc	a0,0x2
    80006140:	66c50513          	addi	a0,a0,1644 # 800087a8 <syscalls+0x3e0>
    80006144:	00000097          	auipc	ra,0x0
    80006148:	02e080e7          	jalr	46(ra) # 80006172 <printf>
  printf(s);
    8000614c:	8526                	mv	a0,s1
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	024080e7          	jalr	36(ra) # 80006172 <printf>
  printf("\n");
    80006156:	00002517          	auipc	a0,0x2
    8000615a:	ef250513          	addi	a0,a0,-270 # 80008048 <etext+0x48>
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	014080e7          	jalr	20(ra) # 80006172 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006166:	4785                	li	a5,1
    80006168:	00003717          	auipc	a4,0x3
    8000616c:	eaf72a23          	sw	a5,-332(a4) # 8000901c <panicked>
  for(;;)
    80006170:	a001                	j	80006170 <panic+0x48>

0000000080006172 <printf>:
{
    80006172:	7131                	addi	sp,sp,-192
    80006174:	fc86                	sd	ra,120(sp)
    80006176:	f8a2                	sd	s0,112(sp)
    80006178:	f4a6                	sd	s1,104(sp)
    8000617a:	f0ca                	sd	s2,96(sp)
    8000617c:	ecce                	sd	s3,88(sp)
    8000617e:	e8d2                	sd	s4,80(sp)
    80006180:	e4d6                	sd	s5,72(sp)
    80006182:	e0da                	sd	s6,64(sp)
    80006184:	fc5e                	sd	s7,56(sp)
    80006186:	f862                	sd	s8,48(sp)
    80006188:	f466                	sd	s9,40(sp)
    8000618a:	f06a                	sd	s10,32(sp)
    8000618c:	ec6e                	sd	s11,24(sp)
    8000618e:	0100                	addi	s0,sp,128
    80006190:	8a2a                	mv	s4,a0
    80006192:	e40c                	sd	a1,8(s0)
    80006194:	e810                	sd	a2,16(s0)
    80006196:	ec14                	sd	a3,24(s0)
    80006198:	f018                	sd	a4,32(s0)
    8000619a:	f41c                	sd	a5,40(s0)
    8000619c:	03043823          	sd	a6,48(s0)
    800061a0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061a4:	0002ad97          	auipc	s11,0x2a
    800061a8:	05cdad83          	lw	s11,92(s11) # 80030200 <pr+0x18>
  if(locking)
    800061ac:	020d9b63          	bnez	s11,800061e2 <printf+0x70>
  if (fmt == 0)
    800061b0:	040a0263          	beqz	s4,800061f4 <printf+0x82>
  va_start(ap, fmt);
    800061b4:	00840793          	addi	a5,s0,8
    800061b8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061bc:	000a4503          	lbu	a0,0(s4)
    800061c0:	16050263          	beqz	a0,80006324 <printf+0x1b2>
    800061c4:	4481                	li	s1,0
    if(c != '%'){
    800061c6:	02500a93          	li	s5,37
    switch(c){
    800061ca:	07000b13          	li	s6,112
  consputc('x');
    800061ce:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061d0:	00002b97          	auipc	s7,0x2
    800061d4:	600b8b93          	addi	s7,s7,1536 # 800087d0 <digits>
    switch(c){
    800061d8:	07300c93          	li	s9,115
    800061dc:	06400c13          	li	s8,100
    800061e0:	a82d                	j	8000621a <printf+0xa8>
    acquire(&pr.lock);
    800061e2:	0002a517          	auipc	a0,0x2a
    800061e6:	00650513          	addi	a0,a0,6 # 800301e8 <pr>
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	488080e7          	jalr	1160(ra) # 80006672 <acquire>
    800061f2:	bf7d                	j	800061b0 <printf+0x3e>
    panic("null fmt");
    800061f4:	00002517          	auipc	a0,0x2
    800061f8:	5c450513          	addi	a0,a0,1476 # 800087b8 <syscalls+0x3f0>
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	f2c080e7          	jalr	-212(ra) # 80006128 <panic>
      consputc(c);
    80006204:	00000097          	auipc	ra,0x0
    80006208:	c62080e7          	jalr	-926(ra) # 80005e66 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000620c:	2485                	addiw	s1,s1,1
    8000620e:	009a07b3          	add	a5,s4,s1
    80006212:	0007c503          	lbu	a0,0(a5)
    80006216:	10050763          	beqz	a0,80006324 <printf+0x1b2>
    if(c != '%'){
    8000621a:	ff5515e3          	bne	a0,s5,80006204 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000621e:	2485                	addiw	s1,s1,1
    80006220:	009a07b3          	add	a5,s4,s1
    80006224:	0007c783          	lbu	a5,0(a5)
    80006228:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000622c:	cfe5                	beqz	a5,80006324 <printf+0x1b2>
    switch(c){
    8000622e:	05678a63          	beq	a5,s6,80006282 <printf+0x110>
    80006232:	02fb7663          	bgeu	s6,a5,8000625e <printf+0xec>
    80006236:	09978963          	beq	a5,s9,800062c8 <printf+0x156>
    8000623a:	07800713          	li	a4,120
    8000623e:	0ce79863          	bne	a5,a4,8000630e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006242:	f8843783          	ld	a5,-120(s0)
    80006246:	00878713          	addi	a4,a5,8
    8000624a:	f8e43423          	sd	a4,-120(s0)
    8000624e:	4605                	li	a2,1
    80006250:	85ea                	mv	a1,s10
    80006252:	4388                	lw	a0,0(a5)
    80006254:	00000097          	auipc	ra,0x0
    80006258:	e32080e7          	jalr	-462(ra) # 80006086 <printint>
      break;
    8000625c:	bf45                	j	8000620c <printf+0x9a>
    switch(c){
    8000625e:	0b578263          	beq	a5,s5,80006302 <printf+0x190>
    80006262:	0b879663          	bne	a5,s8,8000630e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006266:	f8843783          	ld	a5,-120(s0)
    8000626a:	00878713          	addi	a4,a5,8
    8000626e:	f8e43423          	sd	a4,-120(s0)
    80006272:	4605                	li	a2,1
    80006274:	45a9                	li	a1,10
    80006276:	4388                	lw	a0,0(a5)
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	e0e080e7          	jalr	-498(ra) # 80006086 <printint>
      break;
    80006280:	b771                	j	8000620c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006282:	f8843783          	ld	a5,-120(s0)
    80006286:	00878713          	addi	a4,a5,8
    8000628a:	f8e43423          	sd	a4,-120(s0)
    8000628e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006292:	03000513          	li	a0,48
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	bd0080e7          	jalr	-1072(ra) # 80005e66 <consputc>
  consputc('x');
    8000629e:	07800513          	li	a0,120
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	bc4080e7          	jalr	-1084(ra) # 80005e66 <consputc>
    800062aa:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062ac:	03c9d793          	srli	a5,s3,0x3c
    800062b0:	97de                	add	a5,a5,s7
    800062b2:	0007c503          	lbu	a0,0(a5)
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	bb0080e7          	jalr	-1104(ra) # 80005e66 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062be:	0992                	slli	s3,s3,0x4
    800062c0:	397d                	addiw	s2,s2,-1
    800062c2:	fe0915e3          	bnez	s2,800062ac <printf+0x13a>
    800062c6:	b799                	j	8000620c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062c8:	f8843783          	ld	a5,-120(s0)
    800062cc:	00878713          	addi	a4,a5,8
    800062d0:	f8e43423          	sd	a4,-120(s0)
    800062d4:	0007b903          	ld	s2,0(a5)
    800062d8:	00090e63          	beqz	s2,800062f4 <printf+0x182>
      for(; *s; s++)
    800062dc:	00094503          	lbu	a0,0(s2)
    800062e0:	d515                	beqz	a0,8000620c <printf+0x9a>
        consputc(*s);
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	b84080e7          	jalr	-1148(ra) # 80005e66 <consputc>
      for(; *s; s++)
    800062ea:	0905                	addi	s2,s2,1
    800062ec:	00094503          	lbu	a0,0(s2)
    800062f0:	f96d                	bnez	a0,800062e2 <printf+0x170>
    800062f2:	bf29                	j	8000620c <printf+0x9a>
        s = "(null)";
    800062f4:	00002917          	auipc	s2,0x2
    800062f8:	4bc90913          	addi	s2,s2,1212 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    800062fc:	02800513          	li	a0,40
    80006300:	b7cd                	j	800062e2 <printf+0x170>
      consputc('%');
    80006302:	8556                	mv	a0,s5
    80006304:	00000097          	auipc	ra,0x0
    80006308:	b62080e7          	jalr	-1182(ra) # 80005e66 <consputc>
      break;
    8000630c:	b701                	j	8000620c <printf+0x9a>
      consputc('%');
    8000630e:	8556                	mv	a0,s5
    80006310:	00000097          	auipc	ra,0x0
    80006314:	b56080e7          	jalr	-1194(ra) # 80005e66 <consputc>
      consputc(c);
    80006318:	854a                	mv	a0,s2
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	b4c080e7          	jalr	-1204(ra) # 80005e66 <consputc>
      break;
    80006322:	b5ed                	j	8000620c <printf+0x9a>
  if(locking)
    80006324:	020d9163          	bnez	s11,80006346 <printf+0x1d4>
}
    80006328:	70e6                	ld	ra,120(sp)
    8000632a:	7446                	ld	s0,112(sp)
    8000632c:	74a6                	ld	s1,104(sp)
    8000632e:	7906                	ld	s2,96(sp)
    80006330:	69e6                	ld	s3,88(sp)
    80006332:	6a46                	ld	s4,80(sp)
    80006334:	6aa6                	ld	s5,72(sp)
    80006336:	6b06                	ld	s6,64(sp)
    80006338:	7be2                	ld	s7,56(sp)
    8000633a:	7c42                	ld	s8,48(sp)
    8000633c:	7ca2                	ld	s9,40(sp)
    8000633e:	7d02                	ld	s10,32(sp)
    80006340:	6de2                	ld	s11,24(sp)
    80006342:	6129                	addi	sp,sp,192
    80006344:	8082                	ret
    release(&pr.lock);
    80006346:	0002a517          	auipc	a0,0x2a
    8000634a:	ea250513          	addi	a0,a0,-350 # 800301e8 <pr>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	3d8080e7          	jalr	984(ra) # 80006726 <release>
}
    80006356:	bfc9                	j	80006328 <printf+0x1b6>

0000000080006358 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006362:	0002a497          	auipc	s1,0x2a
    80006366:	e8648493          	addi	s1,s1,-378 # 800301e8 <pr>
    8000636a:	00002597          	auipc	a1,0x2
    8000636e:	45e58593          	addi	a1,a1,1118 # 800087c8 <syscalls+0x400>
    80006372:	8526                	mv	a0,s1
    80006374:	00000097          	auipc	ra,0x0
    80006378:	26e080e7          	jalr	622(ra) # 800065e2 <initlock>
  pr.locking = 1;
    8000637c:	4785                	li	a5,1
    8000637e:	cc9c                	sw	a5,24(s1)
}
    80006380:	60e2                	ld	ra,24(sp)
    80006382:	6442                	ld	s0,16(sp)
    80006384:	64a2                	ld	s1,8(sp)
    80006386:	6105                	addi	sp,sp,32
    80006388:	8082                	ret

000000008000638a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000638a:	1141                	addi	sp,sp,-16
    8000638c:	e406                	sd	ra,8(sp)
    8000638e:	e022                	sd	s0,0(sp)
    80006390:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006392:	100007b7          	lui	a5,0x10000
    80006396:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000639a:	f8000713          	li	a4,-128
    8000639e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800063a2:	470d                	li	a4,3
    800063a4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800063a8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800063ac:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063b0:	469d                	li	a3,7
    800063b2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063b6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063ba:	00002597          	auipc	a1,0x2
    800063be:	42e58593          	addi	a1,a1,1070 # 800087e8 <digits+0x18>
    800063c2:	0002a517          	auipc	a0,0x2a
    800063c6:	e4650513          	addi	a0,a0,-442 # 80030208 <uart_tx_lock>
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	218080e7          	jalr	536(ra) # 800065e2 <initlock>
}
    800063d2:	60a2                	ld	ra,8(sp)
    800063d4:	6402                	ld	s0,0(sp)
    800063d6:	0141                	addi	sp,sp,16
    800063d8:	8082                	ret

00000000800063da <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063da:	1101                	addi	sp,sp,-32
    800063dc:	ec06                	sd	ra,24(sp)
    800063de:	e822                	sd	s0,16(sp)
    800063e0:	e426                	sd	s1,8(sp)
    800063e2:	1000                	addi	s0,sp,32
    800063e4:	84aa                	mv	s1,a0
  push_off();
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	240080e7          	jalr	576(ra) # 80006626 <push_off>

  if(panicked){
    800063ee:	00003797          	auipc	a5,0x3
    800063f2:	c2e7a783          	lw	a5,-978(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063f6:	10000737          	lui	a4,0x10000
  if(panicked){
    800063fa:	c391                	beqz	a5,800063fe <uartputc_sync+0x24>
    for(;;)
    800063fc:	a001                	j	800063fc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063fe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006402:	0ff7f793          	andi	a5,a5,255
    80006406:	0207f793          	andi	a5,a5,32
    8000640a:	dbf5                	beqz	a5,800063fe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000640c:	0ff4f793          	andi	a5,s1,255
    80006410:	10000737          	lui	a4,0x10000
    80006414:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	2ae080e7          	jalr	686(ra) # 800066c6 <pop_off>
}
    80006420:	60e2                	ld	ra,24(sp)
    80006422:	6442                	ld	s0,16(sp)
    80006424:	64a2                	ld	s1,8(sp)
    80006426:	6105                	addi	sp,sp,32
    80006428:	8082                	ret

000000008000642a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000642a:	00003717          	auipc	a4,0x3
    8000642e:	bf673703          	ld	a4,-1034(a4) # 80009020 <uart_tx_r>
    80006432:	00003797          	auipc	a5,0x3
    80006436:	bf67b783          	ld	a5,-1034(a5) # 80009028 <uart_tx_w>
    8000643a:	06e78c63          	beq	a5,a4,800064b2 <uartstart+0x88>
{
    8000643e:	7139                	addi	sp,sp,-64
    80006440:	fc06                	sd	ra,56(sp)
    80006442:	f822                	sd	s0,48(sp)
    80006444:	f426                	sd	s1,40(sp)
    80006446:	f04a                	sd	s2,32(sp)
    80006448:	ec4e                	sd	s3,24(sp)
    8000644a:	e852                	sd	s4,16(sp)
    8000644c:	e456                	sd	s5,8(sp)
    8000644e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006450:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006454:	0002aa17          	auipc	s4,0x2a
    80006458:	db4a0a13          	addi	s4,s4,-588 # 80030208 <uart_tx_lock>
    uart_tx_r += 1;
    8000645c:	00003497          	auipc	s1,0x3
    80006460:	bc448493          	addi	s1,s1,-1084 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006464:	00003997          	auipc	s3,0x3
    80006468:	bc498993          	addi	s3,s3,-1084 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000646c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006470:	0ff7f793          	andi	a5,a5,255
    80006474:	0207f793          	andi	a5,a5,32
    80006478:	c785                	beqz	a5,800064a0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000647a:	01f77793          	andi	a5,a4,31
    8000647e:	97d2                	add	a5,a5,s4
    80006480:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006484:	0705                	addi	a4,a4,1
    80006486:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006488:	8526                	mv	a0,s1
    8000648a:	ffffb097          	auipc	ra,0xffffb
    8000648e:	276080e7          	jalr	630(ra) # 80001700 <wakeup>
    
    WriteReg(THR, c);
    80006492:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006496:	6098                	ld	a4,0(s1)
    80006498:	0009b783          	ld	a5,0(s3)
    8000649c:	fce798e3          	bne	a5,a4,8000646c <uartstart+0x42>
  }
}
    800064a0:	70e2                	ld	ra,56(sp)
    800064a2:	7442                	ld	s0,48(sp)
    800064a4:	74a2                	ld	s1,40(sp)
    800064a6:	7902                	ld	s2,32(sp)
    800064a8:	69e2                	ld	s3,24(sp)
    800064aa:	6a42                	ld	s4,16(sp)
    800064ac:	6aa2                	ld	s5,8(sp)
    800064ae:	6121                	addi	sp,sp,64
    800064b0:	8082                	ret
    800064b2:	8082                	ret

00000000800064b4 <uartputc>:
{
    800064b4:	7179                	addi	sp,sp,-48
    800064b6:	f406                	sd	ra,40(sp)
    800064b8:	f022                	sd	s0,32(sp)
    800064ba:	ec26                	sd	s1,24(sp)
    800064bc:	e84a                	sd	s2,16(sp)
    800064be:	e44e                	sd	s3,8(sp)
    800064c0:	e052                	sd	s4,0(sp)
    800064c2:	1800                	addi	s0,sp,48
    800064c4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800064c6:	0002a517          	auipc	a0,0x2a
    800064ca:	d4250513          	addi	a0,a0,-702 # 80030208 <uart_tx_lock>
    800064ce:	00000097          	auipc	ra,0x0
    800064d2:	1a4080e7          	jalr	420(ra) # 80006672 <acquire>
  if(panicked){
    800064d6:	00003797          	auipc	a5,0x3
    800064da:	b467a783          	lw	a5,-1210(a5) # 8000901c <panicked>
    800064de:	c391                	beqz	a5,800064e2 <uartputc+0x2e>
    for(;;)
    800064e0:	a001                	j	800064e0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064e2:	00003797          	auipc	a5,0x3
    800064e6:	b467b783          	ld	a5,-1210(a5) # 80009028 <uart_tx_w>
    800064ea:	00003717          	auipc	a4,0x3
    800064ee:	b3673703          	ld	a4,-1226(a4) # 80009020 <uart_tx_r>
    800064f2:	02070713          	addi	a4,a4,32
    800064f6:	02f71b63          	bne	a4,a5,8000652c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064fa:	0002aa17          	auipc	s4,0x2a
    800064fe:	d0ea0a13          	addi	s4,s4,-754 # 80030208 <uart_tx_lock>
    80006502:	00003497          	auipc	s1,0x3
    80006506:	b1e48493          	addi	s1,s1,-1250 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000650a:	00003917          	auipc	s2,0x3
    8000650e:	b1e90913          	addi	s2,s2,-1250 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006512:	85d2                	mv	a1,s4
    80006514:	8526                	mv	a0,s1
    80006516:	ffffb097          	auipc	ra,0xffffb
    8000651a:	05e080e7          	jalr	94(ra) # 80001574 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000651e:	00093783          	ld	a5,0(s2)
    80006522:	6098                	ld	a4,0(s1)
    80006524:	02070713          	addi	a4,a4,32
    80006528:	fef705e3          	beq	a4,a5,80006512 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000652c:	0002a497          	auipc	s1,0x2a
    80006530:	cdc48493          	addi	s1,s1,-804 # 80030208 <uart_tx_lock>
    80006534:	01f7f713          	andi	a4,a5,31
    80006538:	9726                	add	a4,a4,s1
    8000653a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000653e:	0785                	addi	a5,a5,1
    80006540:	00003717          	auipc	a4,0x3
    80006544:	aef73423          	sd	a5,-1304(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	ee2080e7          	jalr	-286(ra) # 8000642a <uartstart>
      release(&uart_tx_lock);
    80006550:	8526                	mv	a0,s1
    80006552:	00000097          	auipc	ra,0x0
    80006556:	1d4080e7          	jalr	468(ra) # 80006726 <release>
}
    8000655a:	70a2                	ld	ra,40(sp)
    8000655c:	7402                	ld	s0,32(sp)
    8000655e:	64e2                	ld	s1,24(sp)
    80006560:	6942                	ld	s2,16(sp)
    80006562:	69a2                	ld	s3,8(sp)
    80006564:	6a02                	ld	s4,0(sp)
    80006566:	6145                	addi	sp,sp,48
    80006568:	8082                	ret

000000008000656a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000656a:	1141                	addi	sp,sp,-16
    8000656c:	e422                	sd	s0,8(sp)
    8000656e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006570:	100007b7          	lui	a5,0x10000
    80006574:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006578:	8b85                	andi	a5,a5,1
    8000657a:	cb91                	beqz	a5,8000658e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000657c:	100007b7          	lui	a5,0x10000
    80006580:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006584:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006588:	6422                	ld	s0,8(sp)
    8000658a:	0141                	addi	sp,sp,16
    8000658c:	8082                	ret
    return -1;
    8000658e:	557d                	li	a0,-1
    80006590:	bfe5                	j	80006588 <uartgetc+0x1e>

0000000080006592 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006592:	1101                	addi	sp,sp,-32
    80006594:	ec06                	sd	ra,24(sp)
    80006596:	e822                	sd	s0,16(sp)
    80006598:	e426                	sd	s1,8(sp)
    8000659a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000659c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000659e:	00000097          	auipc	ra,0x0
    800065a2:	fcc080e7          	jalr	-52(ra) # 8000656a <uartgetc>
    if(c == -1)
    800065a6:	00950763          	beq	a0,s1,800065b4 <uartintr+0x22>
      break;
    consoleintr(c);
    800065aa:	00000097          	auipc	ra,0x0
    800065ae:	8fe080e7          	jalr	-1794(ra) # 80005ea8 <consoleintr>
  while(1){
    800065b2:	b7f5                	j	8000659e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065b4:	0002a497          	auipc	s1,0x2a
    800065b8:	c5448493          	addi	s1,s1,-940 # 80030208 <uart_tx_lock>
    800065bc:	8526                	mv	a0,s1
    800065be:	00000097          	auipc	ra,0x0
    800065c2:	0b4080e7          	jalr	180(ra) # 80006672 <acquire>
  uartstart();
    800065c6:	00000097          	auipc	ra,0x0
    800065ca:	e64080e7          	jalr	-412(ra) # 8000642a <uartstart>
  release(&uart_tx_lock);
    800065ce:	8526                	mv	a0,s1
    800065d0:	00000097          	auipc	ra,0x0
    800065d4:	156080e7          	jalr	342(ra) # 80006726 <release>
}
    800065d8:	60e2                	ld	ra,24(sp)
    800065da:	6442                	ld	s0,16(sp)
    800065dc:	64a2                	ld	s1,8(sp)
    800065de:	6105                	addi	sp,sp,32
    800065e0:	8082                	ret

00000000800065e2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800065e2:	1141                	addi	sp,sp,-16
    800065e4:	e422                	sd	s0,8(sp)
    800065e6:	0800                	addi	s0,sp,16
  lk->name = name;
    800065e8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800065ea:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800065ee:	00053823          	sd	zero,16(a0)
}
    800065f2:	6422                	ld	s0,8(sp)
    800065f4:	0141                	addi	sp,sp,16
    800065f6:	8082                	ret

00000000800065f8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065f8:	411c                	lw	a5,0(a0)
    800065fa:	e399                	bnez	a5,80006600 <holding+0x8>
    800065fc:	4501                	li	a0,0
  return r;
}
    800065fe:	8082                	ret
{
    80006600:	1101                	addi	sp,sp,-32
    80006602:	ec06                	sd	ra,24(sp)
    80006604:	e822                	sd	s0,16(sp)
    80006606:	e426                	sd	s1,8(sp)
    80006608:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000660a:	6904                	ld	s1,16(a0)
    8000660c:	ffffb097          	auipc	ra,0xffffb
    80006610:	820080e7          	jalr	-2016(ra) # 80000e2c <mycpu>
    80006614:	40a48533          	sub	a0,s1,a0
    80006618:	00153513          	seqz	a0,a0
}
    8000661c:	60e2                	ld	ra,24(sp)
    8000661e:	6442                	ld	s0,16(sp)
    80006620:	64a2                	ld	s1,8(sp)
    80006622:	6105                	addi	sp,sp,32
    80006624:	8082                	ret

0000000080006626 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006626:	1101                	addi	sp,sp,-32
    80006628:	ec06                	sd	ra,24(sp)
    8000662a:	e822                	sd	s0,16(sp)
    8000662c:	e426                	sd	s1,8(sp)
    8000662e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006630:	100024f3          	csrr	s1,sstatus
    80006634:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006638:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000663a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000663e:	ffffa097          	auipc	ra,0xffffa
    80006642:	7ee080e7          	jalr	2030(ra) # 80000e2c <mycpu>
    80006646:	5d3c                	lw	a5,120(a0)
    80006648:	cf89                	beqz	a5,80006662 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000664a:	ffffa097          	auipc	ra,0xffffa
    8000664e:	7e2080e7          	jalr	2018(ra) # 80000e2c <mycpu>
    80006652:	5d3c                	lw	a5,120(a0)
    80006654:	2785                	addiw	a5,a5,1
    80006656:	dd3c                	sw	a5,120(a0)
}
    80006658:	60e2                	ld	ra,24(sp)
    8000665a:	6442                	ld	s0,16(sp)
    8000665c:	64a2                	ld	s1,8(sp)
    8000665e:	6105                	addi	sp,sp,32
    80006660:	8082                	ret
    mycpu()->intena = old;
    80006662:	ffffa097          	auipc	ra,0xffffa
    80006666:	7ca080e7          	jalr	1994(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000666a:	8085                	srli	s1,s1,0x1
    8000666c:	8885                	andi	s1,s1,1
    8000666e:	dd64                	sw	s1,124(a0)
    80006670:	bfe9                	j	8000664a <push_off+0x24>

0000000080006672 <acquire>:
{
    80006672:	1101                	addi	sp,sp,-32
    80006674:	ec06                	sd	ra,24(sp)
    80006676:	e822                	sd	s0,16(sp)
    80006678:	e426                	sd	s1,8(sp)
    8000667a:	1000                	addi	s0,sp,32
    8000667c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000667e:	00000097          	auipc	ra,0x0
    80006682:	fa8080e7          	jalr	-88(ra) # 80006626 <push_off>
  if(holding(lk))
    80006686:	8526                	mv	a0,s1
    80006688:	00000097          	auipc	ra,0x0
    8000668c:	f70080e7          	jalr	-144(ra) # 800065f8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006690:	4705                	li	a4,1
  if(holding(lk))
    80006692:	e115                	bnez	a0,800066b6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006694:	87ba                	mv	a5,a4
    80006696:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000669a:	2781                	sext.w	a5,a5
    8000669c:	ffe5                	bnez	a5,80006694 <acquire+0x22>
  __sync_synchronize();
    8000669e:	0ff0000f          	fence
  lk->cpu = mycpu();
    800066a2:	ffffa097          	auipc	ra,0xffffa
    800066a6:	78a080e7          	jalr	1930(ra) # 80000e2c <mycpu>
    800066aa:	e888                	sd	a0,16(s1)
}
    800066ac:	60e2                	ld	ra,24(sp)
    800066ae:	6442                	ld	s0,16(sp)
    800066b0:	64a2                	ld	s1,8(sp)
    800066b2:	6105                	addi	sp,sp,32
    800066b4:	8082                	ret
    panic("acquire");
    800066b6:	00002517          	auipc	a0,0x2
    800066ba:	13a50513          	addi	a0,a0,314 # 800087f0 <digits+0x20>
    800066be:	00000097          	auipc	ra,0x0
    800066c2:	a6a080e7          	jalr	-1430(ra) # 80006128 <panic>

00000000800066c6 <pop_off>:

void
pop_off(void)
{
    800066c6:	1141                	addi	sp,sp,-16
    800066c8:	e406                	sd	ra,8(sp)
    800066ca:	e022                	sd	s0,0(sp)
    800066cc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066ce:	ffffa097          	auipc	ra,0xffffa
    800066d2:	75e080e7          	jalr	1886(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800066da:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066dc:	e78d                	bnez	a5,80006706 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066de:	5d3c                	lw	a5,120(a0)
    800066e0:	02f05b63          	blez	a5,80006716 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800066e4:	37fd                	addiw	a5,a5,-1
    800066e6:	0007871b          	sext.w	a4,a5
    800066ea:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066ec:	eb09                	bnez	a4,800066fe <pop_off+0x38>
    800066ee:	5d7c                	lw	a5,124(a0)
    800066f0:	c799                	beqz	a5,800066fe <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066fa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066fe:	60a2                	ld	ra,8(sp)
    80006700:	6402                	ld	s0,0(sp)
    80006702:	0141                	addi	sp,sp,16
    80006704:	8082                	ret
    panic("pop_off - interruptible");
    80006706:	00002517          	auipc	a0,0x2
    8000670a:	0f250513          	addi	a0,a0,242 # 800087f8 <digits+0x28>
    8000670e:	00000097          	auipc	ra,0x0
    80006712:	a1a080e7          	jalr	-1510(ra) # 80006128 <panic>
    panic("pop_off");
    80006716:	00002517          	auipc	a0,0x2
    8000671a:	0fa50513          	addi	a0,a0,250 # 80008810 <digits+0x40>
    8000671e:	00000097          	auipc	ra,0x0
    80006722:	a0a080e7          	jalr	-1526(ra) # 80006128 <panic>

0000000080006726 <release>:
{
    80006726:	1101                	addi	sp,sp,-32
    80006728:	ec06                	sd	ra,24(sp)
    8000672a:	e822                	sd	s0,16(sp)
    8000672c:	e426                	sd	s1,8(sp)
    8000672e:	1000                	addi	s0,sp,32
    80006730:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006732:	00000097          	auipc	ra,0x0
    80006736:	ec6080e7          	jalr	-314(ra) # 800065f8 <holding>
    8000673a:	c115                	beqz	a0,8000675e <release+0x38>
  lk->cpu = 0;
    8000673c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006740:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006744:	0f50000f          	fence	iorw,ow
    80006748:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000674c:	00000097          	auipc	ra,0x0
    80006750:	f7a080e7          	jalr	-134(ra) # 800066c6 <pop_off>
}
    80006754:	60e2                	ld	ra,24(sp)
    80006756:	6442                	ld	s0,16(sp)
    80006758:	64a2                	ld	s1,8(sp)
    8000675a:	6105                	addi	sp,sp,32
    8000675c:	8082                	ret
    panic("release");
    8000675e:	00002517          	auipc	a0,0x2
    80006762:	0ba50513          	addi	a0,a0,186 # 80008818 <digits+0x48>
    80006766:	00000097          	auipc	ra,0x0
    8000676a:	9c2080e7          	jalr	-1598(ra) # 80006128 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
