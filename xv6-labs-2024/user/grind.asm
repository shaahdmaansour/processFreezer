
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	3ab000ef          	jal	c62 <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	15050513          	addi	a0,a0,336 # 1210 <malloc+0xf6>
      c8:	3db000ef          	jal	ca2 <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	14450513          	addi	a0,a0,324 # 1210 <malloc+0xf6>
      d4:	377000ef          	jal	c4a <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	12a50513          	addi	a0,a0,298 # 1218 <malloc+0xfe>
      f6:	76d000ef          	jal	1062 <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	317000ef          	jal	c12 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	12c50513          	addi	a0,a0,300 # 1240 <malloc+0x126>
     11c:	32f000ef          	jal	c4a <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	130c0c13          	addi	s8,s8,304 # 1250 <malloc+0x136>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	11ec0c13          	addi	s8,s8,286 # 1248 <malloc+0x12e>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     136:	106259b7          	lui	s3,0x10625
     13a:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x106229cb>
     13e:	09be                	slli	s3,s3,0xf
     140:	8d598993          	addi	s3,s3,-1835
     144:	09ca                	slli	s3,s3,0x12
     146:	80098993          	addi	s3,s3,-2048
     14a:	fcf98993          	addi	s3,s3,-49
     14e:	1f400b93          	li	s7,500
      write(1, which_child?"B":"A", 1);
     152:	4a05                	li	s4,1
    int what = rand() % 23;
     154:	b2164ab7          	lui	s5,0xb2164
     158:	2c9a8a93          	addi	s5,s5,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     15c:	4b59                	li	s6,22
     15e:	00001917          	auipc	s2,0x1
     162:	3c290913          	addi	s2,s2,962 # 1520 <malloc+0x406>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     166:	f6840d93          	addi	s11,s0,-152
     16a:	a819                	j	180 <go+0xd6>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	0e850513          	addi	a0,a0,232 # 1258 <malloc+0x13e>
     178:	303000ef          	jal	c7a <open>
     17c:	32f000ef          	jal	caa <close>
    iters++;
     180:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     182:	0024d793          	srli	a5,s1,0x2
     186:	0337b7b3          	mulhu	a5,a5,s3
     18a:	8391                	srli	a5,a5,0x4
     18c:	037787b3          	mul	a5,a5,s7
     190:	00f49763          	bne	s1,a5,19e <go+0xf4>
      write(1, which_child?"B":"A", 1);
     194:	8652                	mv	a2,s4
     196:	85e2                	mv	a1,s8
     198:	8552                	mv	a0,s4
     19a:	2e9000ef          	jal	c82 <write>
    int what = rand() % 23;
     19e:	ef1ff0ef          	jal	8e <rand>
     1a2:	035507b3          	mul	a5,a0,s5
     1a6:	9381                	srli	a5,a5,0x20
     1a8:	9fa9                	addw	a5,a5,a0
     1aa:	4047d79b          	sraiw	a5,a5,0x4
     1ae:	41f5571b          	sraiw	a4,a0,0x1f
     1b2:	9f99                	subw	a5,a5,a4
     1b4:	0017971b          	slliw	a4,a5,0x1
     1b8:	9f3d                	addw	a4,a4,a5
     1ba:	0037171b          	slliw	a4,a4,0x3
     1be:	40f707bb          	subw	a5,a4,a5
     1c2:	9d1d                	subw	a0,a0,a5
     1c4:	faab6ee3          	bltu	s6,a0,180 <go+0xd6>
     1c8:	02051793          	slli	a5,a0,0x20
     1cc:	01e7d513          	srli	a0,a5,0x1e
     1d0:	954a                	add	a0,a0,s2
     1d2:	411c                	lw	a5,0(a0)
     1d4:	97ca                	add	a5,a5,s2
     1d6:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d8:	20200593          	li	a1,514
     1dc:	00001517          	auipc	a0,0x1
     1e0:	08c50513          	addi	a0,a0,140 # 1268 <malloc+0x14e>
     1e4:	297000ef          	jal	c7a <open>
     1e8:	2c3000ef          	jal	caa <close>
     1ec:	bf51                	j	180 <go+0xd6>
      unlink("grindir/../a");
     1ee:	00001517          	auipc	a0,0x1
     1f2:	06a50513          	addi	a0,a0,106 # 1258 <malloc+0x13e>
     1f6:	29d000ef          	jal	c92 <unlink>
     1fa:	b759                	j	180 <go+0xd6>
      if(chdir("grindir") != 0){
     1fc:	00001517          	auipc	a0,0x1
     200:	01450513          	addi	a0,a0,20 # 1210 <malloc+0xf6>
     204:	247000ef          	jal	c4a <chdir>
     208:	ed11                	bnez	a0,224 <go+0x17a>
      unlink("../b");
     20a:	00001517          	auipc	a0,0x1
     20e:	07650513          	addi	a0,a0,118 # 1280 <malloc+0x166>
     212:	281000ef          	jal	c92 <unlink>
      chdir("/");
     216:	00001517          	auipc	a0,0x1
     21a:	02a50513          	addi	a0,a0,42 # 1240 <malloc+0x126>
     21e:	22d000ef          	jal	c4a <chdir>
     222:	bfb9                	j	180 <go+0xd6>
        printf("grind: chdir grindir failed\n");
     224:	00001517          	auipc	a0,0x1
     228:	ff450513          	addi	a0,a0,-12 # 1218 <malloc+0xfe>
     22c:	637000ef          	jal	1062 <printf>
        exit(1);
     230:	4505                	li	a0,1
     232:	1e1000ef          	jal	c12 <exit>
      close(fd);
     236:	8566                	mv	a0,s9
     238:	273000ef          	jal	caa <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     23c:	20200593          	li	a1,514
     240:	00001517          	auipc	a0,0x1
     244:	04850513          	addi	a0,a0,72 # 1288 <malloc+0x16e>
     248:	233000ef          	jal	c7a <open>
     24c:	8caa                	mv	s9,a0
     24e:	bf0d                	j	180 <go+0xd6>
      close(fd);
     250:	8566                	mv	a0,s9
     252:	259000ef          	jal	caa <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     256:	20200593          	li	a1,514
     25a:	00001517          	auipc	a0,0x1
     25e:	03e50513          	addi	a0,a0,62 # 1298 <malloc+0x17e>
     262:	219000ef          	jal	c7a <open>
     266:	8caa                	mv	s9,a0
     268:	bf21                	j	180 <go+0xd6>
      write(fd, buf, sizeof(buf));
     26a:	3e700613          	li	a2,999
     26e:	00002597          	auipc	a1,0x2
     272:	db258593          	addi	a1,a1,-590 # 2020 <buf.0>
     276:	8566                	mv	a0,s9
     278:	20b000ef          	jal	c82 <write>
     27c:	b711                	j	180 <go+0xd6>
      read(fd, buf, sizeof(buf));
     27e:	3e700613          	li	a2,999
     282:	00002597          	auipc	a1,0x2
     286:	d9e58593          	addi	a1,a1,-610 # 2020 <buf.0>
     28a:	8566                	mv	a0,s9
     28c:	19f000ef          	jal	c2a <read>
     290:	bdc5                	j	180 <go+0xd6>
      mkdir("grindir/../a");
     292:	00001517          	auipc	a0,0x1
     296:	fc650513          	addi	a0,a0,-58 # 1258 <malloc+0x13e>
     29a:	209000ef          	jal	ca2 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29e:	20200593          	li	a1,514
     2a2:	00001517          	auipc	a0,0x1
     2a6:	00e50513          	addi	a0,a0,14 # 12b0 <malloc+0x196>
     2aa:	1d1000ef          	jal	c7a <open>
     2ae:	1fd000ef          	jal	caa <close>
      unlink("a/a");
     2b2:	00001517          	auipc	a0,0x1
     2b6:	00e50513          	addi	a0,a0,14 # 12c0 <malloc+0x1a6>
     2ba:	1d9000ef          	jal	c92 <unlink>
     2be:	b5c9                	j	180 <go+0xd6>
      mkdir("/../b");
     2c0:	00001517          	auipc	a0,0x1
     2c4:	00850513          	addi	a0,a0,8 # 12c8 <malloc+0x1ae>
     2c8:	1db000ef          	jal	ca2 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2cc:	20200593          	li	a1,514
     2d0:	00001517          	auipc	a0,0x1
     2d4:	00050513          	mv	a0,a0
     2d8:	1a3000ef          	jal	c7a <open>
     2dc:	1cf000ef          	jal	caa <close>
      unlink("b/b");
     2e0:	00001517          	auipc	a0,0x1
     2e4:	00050513          	mv	a0,a0
     2e8:	1ab000ef          	jal	c92 <unlink>
     2ec:	bd51                	j	180 <go+0xd6>
      unlink("b");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	ffa50513          	addi	a0,a0,-6 # 12e8 <malloc+0x1ce>
     2f6:	19d000ef          	jal	c92 <unlink>
      link("../grindir/./../a", "../b");
     2fa:	00001597          	auipc	a1,0x1
     2fe:	f8658593          	addi	a1,a1,-122 # 1280 <malloc+0x166>
     302:	00001517          	auipc	a0,0x1
     306:	fee50513          	addi	a0,a0,-18 # 12f0 <malloc+0x1d6>
     30a:	191000ef          	jal	c9a <link>
     30e:	bd8d                	j	180 <go+0xd6>
      unlink("../grindir/../a");
     310:	00001517          	auipc	a0,0x1
     314:	ff850513          	addi	a0,a0,-8 # 1308 <malloc+0x1ee>
     318:	17b000ef          	jal	c92 <unlink>
      link(".././b", "/grindir/../a");
     31c:	00001597          	auipc	a1,0x1
     320:	f6c58593          	addi	a1,a1,-148 # 1288 <malloc+0x16e>
     324:	00001517          	auipc	a0,0x1
     328:	ff450513          	addi	a0,a0,-12 # 1318 <malloc+0x1fe>
     32c:	16f000ef          	jal	c9a <link>
     330:	bd81                	j	180 <go+0xd6>
      int pid = fork();
     332:	0d9000ef          	jal	c0a <fork>
      if(pid == 0){
     336:	c519                	beqz	a0,344 <go+0x29a>
      } else if(pid < 0){
     338:	00054863          	bltz	a0,348 <go+0x29e>
      wait(0);
     33c:	4501                	li	a0,0
     33e:	0dd000ef          	jal	c1a <wait>
     342:	bd3d                	j	180 <go+0xd6>
        exit(0);
     344:	0cf000ef          	jal	c12 <exit>
        printf("grind: fork failed\n");
     348:	00001517          	auipc	a0,0x1
     34c:	fd850513          	addi	a0,a0,-40 # 1320 <malloc+0x206>
     350:	513000ef          	jal	1062 <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	0bd000ef          	jal	c12 <exit>
      int pid = fork();
     35a:	0b1000ef          	jal	c0a <fork>
      if(pid == 0){
     35e:	c519                	beqz	a0,36c <go+0x2c2>
      } else if(pid < 0){
     360:	00054d63          	bltz	a0,37a <go+0x2d0>
      wait(0);
     364:	4501                	li	a0,0
     366:	0b5000ef          	jal	c1a <wait>
     36a:	bd19                	j	180 <go+0xd6>
        fork();
     36c:	09f000ef          	jal	c0a <fork>
        fork();
     370:	09b000ef          	jal	c0a <fork>
        exit(0);
     374:	4501                	li	a0,0
     376:	09d000ef          	jal	c12 <exit>
        printf("grind: fork failed\n");
     37a:	00001517          	auipc	a0,0x1
     37e:	fa650513          	addi	a0,a0,-90 # 1320 <malloc+0x206>
     382:	4e1000ef          	jal	1062 <printf>
        exit(1);
     386:	4505                	li	a0,1
     388:	08b000ef          	jal	c12 <exit>
      sbrk(6011);
     38c:	6505                	lui	a0,0x1
     38e:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x1fb>
     392:	0d1000ef          	jal	c62 <sbrk>
     396:	b3ed                	j	180 <go+0xd6>
      if(sbrk(0) > break0)
     398:	4501                	li	a0,0
     39a:	0c9000ef          	jal	c62 <sbrk>
     39e:	f5843783          	ld	a5,-168(s0)
     3a2:	dca7ffe3          	bgeu	a5,a0,180 <go+0xd6>
        sbrk(-(sbrk(0) - break0));
     3a6:	4501                	li	a0,0
     3a8:	0bb000ef          	jal	c62 <sbrk>
     3ac:	f5843783          	ld	a5,-168(s0)
     3b0:	40a7853b          	subw	a0,a5,a0
     3b4:	0af000ef          	jal	c62 <sbrk>
     3b8:	b3e1                	j	180 <go+0xd6>
      int pid = fork();
     3ba:	051000ef          	jal	c0a <fork>
     3be:	8d2a                	mv	s10,a0
      if(pid == 0){
     3c0:	c10d                	beqz	a0,3e2 <go+0x338>
      } else if(pid < 0){
     3c2:	02054d63          	bltz	a0,3fc <go+0x352>
      if(chdir("../grindir/..") != 0){
     3c6:	00001517          	auipc	a0,0x1
     3ca:	f7a50513          	addi	a0,a0,-134 # 1340 <malloc+0x226>
     3ce:	07d000ef          	jal	c4a <chdir>
     3d2:	ed15                	bnez	a0,40e <go+0x364>
      kill(pid);
     3d4:	856a                	mv	a0,s10
     3d6:	05d000ef          	jal	c32 <kill>
      wait(0);
     3da:	4501                	li	a0,0
     3dc:	03f000ef          	jal	c1a <wait>
     3e0:	b345                	j	180 <go+0xd6>
        close(open("a", O_CREATE|O_RDWR));
     3e2:	20200593          	li	a1,514
     3e6:	00001517          	auipc	a0,0x1
     3ea:	f5250513          	addi	a0,a0,-174 # 1338 <malloc+0x21e>
     3ee:	08d000ef          	jal	c7a <open>
     3f2:	0b9000ef          	jal	caa <close>
        exit(0);
     3f6:	4501                	li	a0,0
     3f8:	01b000ef          	jal	c12 <exit>
        printf("grind: fork failed\n");
     3fc:	00001517          	auipc	a0,0x1
     400:	f2450513          	addi	a0,a0,-220 # 1320 <malloc+0x206>
     404:	45f000ef          	jal	1062 <printf>
        exit(1);
     408:	4505                	li	a0,1
     40a:	009000ef          	jal	c12 <exit>
        printf("grind: chdir failed\n");
     40e:	00001517          	auipc	a0,0x1
     412:	f4250513          	addi	a0,a0,-190 # 1350 <malloc+0x236>
     416:	44d000ef          	jal	1062 <printf>
        exit(1);
     41a:	4505                	li	a0,1
     41c:	7f6000ef          	jal	c12 <exit>
      int pid = fork();
     420:	7ea000ef          	jal	c0a <fork>
      if(pid == 0){
     424:	c519                	beqz	a0,432 <go+0x388>
      } else if(pid < 0){
     426:	00054d63          	bltz	a0,440 <go+0x396>
      wait(0);
     42a:	4501                	li	a0,0
     42c:	7ee000ef          	jal	c1a <wait>
     430:	bb81                	j	180 <go+0xd6>
        kill(getpid());
     432:	029000ef          	jal	c5a <getpid>
     436:	7fc000ef          	jal	c32 <kill>
        exit(0);
     43a:	4501                	li	a0,0
     43c:	7d6000ef          	jal	c12 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	ee050513          	addi	a0,a0,-288 # 1320 <malloc+0x206>
     448:	41b000ef          	jal	1062 <printf>
        exit(1);
     44c:	4505                	li	a0,1
     44e:	7c4000ef          	jal	c12 <exit>
      if(pipe(fds) < 0){
     452:	f7840513          	addi	a0,s0,-136
     456:	7cc000ef          	jal	c22 <pipe>
     45a:	02054363          	bltz	a0,480 <go+0x3d6>
      int pid = fork();
     45e:	7ac000ef          	jal	c0a <fork>
      if(pid == 0){
     462:	c905                	beqz	a0,492 <go+0x3e8>
      } else if(pid < 0){
     464:	08054263          	bltz	a0,4e8 <go+0x43e>
      close(fds[0]);
     468:	f7842503          	lw	a0,-136(s0)
     46c:	03f000ef          	jal	caa <close>
      close(fds[1]);
     470:	f7c42503          	lw	a0,-132(s0)
     474:	037000ef          	jal	caa <close>
      wait(0);
     478:	4501                	li	a0,0
     47a:	7a0000ef          	jal	c1a <wait>
     47e:	b309                	j	180 <go+0xd6>
        printf("grind: pipe failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	ee850513          	addi	a0,a0,-280 # 1368 <malloc+0x24e>
     488:	3db000ef          	jal	1062 <printf>
        exit(1);
     48c:	4505                	li	a0,1
     48e:	784000ef          	jal	c12 <exit>
        fork();
     492:	778000ef          	jal	c0a <fork>
        fork();
     496:	774000ef          	jal	c0a <fork>
        if(write(fds[1], "x", 1) != 1)
     49a:	4605                	li	a2,1
     49c:	00001597          	auipc	a1,0x1
     4a0:	ee458593          	addi	a1,a1,-284 # 1380 <malloc+0x266>
     4a4:	f7c42503          	lw	a0,-132(s0)
     4a8:	7da000ef          	jal	c82 <write>
     4ac:	4785                	li	a5,1
     4ae:	00f51f63          	bne	a0,a5,4cc <go+0x422>
        if(read(fds[0], &c, 1) != 1)
     4b2:	4605                	li	a2,1
     4b4:	f7040593          	addi	a1,s0,-144
     4b8:	f7842503          	lw	a0,-136(s0)
     4bc:	76e000ef          	jal	c2a <read>
     4c0:	4785                	li	a5,1
     4c2:	00f51c63          	bne	a0,a5,4da <go+0x430>
        exit(0);
     4c6:	4501                	li	a0,0
     4c8:	74a000ef          	jal	c12 <exit>
          printf("grind: pipe write failed\n");
     4cc:	00001517          	auipc	a0,0x1
     4d0:	ebc50513          	addi	a0,a0,-324 # 1388 <malloc+0x26e>
     4d4:	38f000ef          	jal	1062 <printf>
     4d8:	bfe9                	j	4b2 <go+0x408>
          printf("grind: pipe read failed\n");
     4da:	00001517          	auipc	a0,0x1
     4de:	ece50513          	addi	a0,a0,-306 # 13a8 <malloc+0x28e>
     4e2:	381000ef          	jal	1062 <printf>
     4e6:	b7c5                	j	4c6 <go+0x41c>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	e3850513          	addi	a0,a0,-456 # 1320 <malloc+0x206>
     4f0:	373000ef          	jal	1062 <printf>
        exit(1);
     4f4:	4505                	li	a0,1
     4f6:	71c000ef          	jal	c12 <exit>
      int pid = fork();
     4fa:	710000ef          	jal	c0a <fork>
      if(pid == 0){
     4fe:	c519                	beqz	a0,50c <go+0x462>
      } else if(pid < 0){
     500:	04054f63          	bltz	a0,55e <go+0x4b4>
      wait(0);
     504:	4501                	li	a0,0
     506:	714000ef          	jal	c1a <wait>
     50a:	b99d                	j	180 <go+0xd6>
        unlink("a");
     50c:	00001517          	auipc	a0,0x1
     510:	e2c50513          	addi	a0,a0,-468 # 1338 <malloc+0x21e>
     514:	77e000ef          	jal	c92 <unlink>
        mkdir("a");
     518:	00001517          	auipc	a0,0x1
     51c:	e2050513          	addi	a0,a0,-480 # 1338 <malloc+0x21e>
     520:	782000ef          	jal	ca2 <mkdir>
        chdir("a");
     524:	00001517          	auipc	a0,0x1
     528:	e1450513          	addi	a0,a0,-492 # 1338 <malloc+0x21e>
     52c:	71e000ef          	jal	c4a <chdir>
        unlink("../a");
     530:	00001517          	auipc	a0,0x1
     534:	e9850513          	addi	a0,a0,-360 # 13c8 <malloc+0x2ae>
     538:	75a000ef          	jal	c92 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     53c:	20200593          	li	a1,514
     540:	00001517          	auipc	a0,0x1
     544:	e4050513          	addi	a0,a0,-448 # 1380 <malloc+0x266>
     548:	732000ef          	jal	c7a <open>
        unlink("x");
     54c:	00001517          	auipc	a0,0x1
     550:	e3450513          	addi	a0,a0,-460 # 1380 <malloc+0x266>
     554:	73e000ef          	jal	c92 <unlink>
        exit(0);
     558:	4501                	li	a0,0
     55a:	6b8000ef          	jal	c12 <exit>
        printf("grind: fork failed\n");
     55e:	00001517          	auipc	a0,0x1
     562:	dc250513          	addi	a0,a0,-574 # 1320 <malloc+0x206>
     566:	2fd000ef          	jal	1062 <printf>
        exit(1);
     56a:	4505                	li	a0,1
     56c:	6a6000ef          	jal	c12 <exit>
      unlink("c");
     570:	00001517          	auipc	a0,0x1
     574:	e6050513          	addi	a0,a0,-416 # 13d0 <malloc+0x2b6>
     578:	71a000ef          	jal	c92 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     57c:	20200593          	li	a1,514
     580:	00001517          	auipc	a0,0x1
     584:	e5050513          	addi	a0,a0,-432 # 13d0 <malloc+0x2b6>
     588:	6f2000ef          	jal	c7a <open>
     58c:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58e:	04054563          	bltz	a0,5d8 <go+0x52e>
      if(write(fd1, "x", 1) != 1){
     592:	8652                	mv	a2,s4
     594:	00001597          	auipc	a1,0x1
     598:	dec58593          	addi	a1,a1,-532 # 1380 <malloc+0x266>
     59c:	6e6000ef          	jal	c82 <write>
     5a0:	05451563          	bne	a0,s4,5ea <go+0x540>
      if(fstat(fd1, &st) != 0){
     5a4:	f7840593          	addi	a1,s0,-136
     5a8:	856a                	mv	a0,s10
     5aa:	698000ef          	jal	c42 <fstat>
     5ae:	e539                	bnez	a0,5fc <go+0x552>
      if(st.size != 1){
     5b0:	f8843583          	ld	a1,-120(s0)
     5b4:	05459d63          	bne	a1,s4,60e <go+0x564>
      if(st.ino > 200){
     5b8:	f7c42583          	lw	a1,-132(s0)
     5bc:	0c800793          	li	a5,200
     5c0:	06b7e163          	bltu	a5,a1,622 <go+0x578>
      close(fd1);
     5c4:	856a                	mv	a0,s10
     5c6:	6e4000ef          	jal	caa <close>
      unlink("c");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	e0650513          	addi	a0,a0,-506 # 13d0 <malloc+0x2b6>
     5d2:	6c0000ef          	jal	c92 <unlink>
     5d6:	b66d                	j	180 <go+0xd6>
        printf("grind: create c failed\n");
     5d8:	00001517          	auipc	a0,0x1
     5dc:	e0050513          	addi	a0,a0,-512 # 13d8 <malloc+0x2be>
     5e0:	283000ef          	jal	1062 <printf>
        exit(1);
     5e4:	4505                	li	a0,1
     5e6:	62c000ef          	jal	c12 <exit>
        printf("grind: write c failed\n");
     5ea:	00001517          	auipc	a0,0x1
     5ee:	e0650513          	addi	a0,a0,-506 # 13f0 <malloc+0x2d6>
     5f2:	271000ef          	jal	1062 <printf>
        exit(1);
     5f6:	4505                	li	a0,1
     5f8:	61a000ef          	jal	c12 <exit>
        printf("grind: fstat failed\n");
     5fc:	00001517          	auipc	a0,0x1
     600:	e0c50513          	addi	a0,a0,-500 # 1408 <malloc+0x2ee>
     604:	25f000ef          	jal	1062 <printf>
        exit(1);
     608:	4505                	li	a0,1
     60a:	608000ef          	jal	c12 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60e:	2581                	sext.w	a1,a1
     610:	00001517          	auipc	a0,0x1
     614:	e1050513          	addi	a0,a0,-496 # 1420 <malloc+0x306>
     618:	24b000ef          	jal	1062 <printf>
        exit(1);
     61c:	4505                	li	a0,1
     61e:	5f4000ef          	jal	c12 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     622:	00001517          	auipc	a0,0x1
     626:	e2650513          	addi	a0,a0,-474 # 1448 <malloc+0x32e>
     62a:	239000ef          	jal	1062 <printf>
        exit(1);
     62e:	4505                	li	a0,1
     630:	5e2000ef          	jal	c12 <exit>
      if(pipe(aa) < 0){
     634:	856e                	mv	a0,s11
     636:	5ec000ef          	jal	c22 <pipe>
     63a:	0a054863          	bltz	a0,6ea <go+0x640>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63e:	f7040513          	addi	a0,s0,-144
     642:	5e0000ef          	jal	c22 <pipe>
     646:	0a054c63          	bltz	a0,6fe <go+0x654>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     64a:	5c0000ef          	jal	c0a <fork>
      if(pid1 == 0){
     64e:	0c050263          	beqz	a0,712 <go+0x668>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     652:	14054463          	bltz	a0,79a <go+0x6f0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     656:	5b4000ef          	jal	c0a <fork>
      if(pid2 == 0){
     65a:	14050a63          	beqz	a0,7ae <go+0x704>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     65e:	1e054863          	bltz	a0,84e <go+0x7a4>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     662:	f6842503          	lw	a0,-152(s0)
     666:	644000ef          	jal	caa <close>
      close(aa[1]);
     66a:	f6c42503          	lw	a0,-148(s0)
     66e:	63c000ef          	jal	caa <close>
      close(bb[1]);
     672:	f7442503          	lw	a0,-140(s0)
     676:	634000ef          	jal	caa <close>
      char buf[4] = { 0, 0, 0, 0 };
     67a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67e:	8652                	mv	a2,s4
     680:	f6040593          	addi	a1,s0,-160
     684:	f7042503          	lw	a0,-144(s0)
     688:	5a2000ef          	jal	c2a <read>
      read(bb[0], buf+1, 1);
     68c:	8652                	mv	a2,s4
     68e:	f6140593          	addi	a1,s0,-159
     692:	f7042503          	lw	a0,-144(s0)
     696:	594000ef          	jal	c2a <read>
      read(bb[0], buf+2, 1);
     69a:	8652                	mv	a2,s4
     69c:	f6240593          	addi	a1,s0,-158
     6a0:	f7042503          	lw	a0,-144(s0)
     6a4:	586000ef          	jal	c2a <read>
      close(bb[0]);
     6a8:	f7042503          	lw	a0,-144(s0)
     6ac:	5fe000ef          	jal	caa <close>
      int st1, st2;
      wait(&st1);
     6b0:	f6440513          	addi	a0,s0,-156
     6b4:	566000ef          	jal	c1a <wait>
      wait(&st2);
     6b8:	f7840513          	addi	a0,s0,-136
     6bc:	55e000ef          	jal	c1a <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6c0:	f6442783          	lw	a5,-156(s0)
     6c4:	f7842703          	lw	a4,-136(s0)
     6c8:	f4e43823          	sd	a4,-176(s0)
     6cc:	00e7ed33          	or	s10,a5,a4
     6d0:	180d1963          	bnez	s10,862 <go+0x7b8>
     6d4:	00001597          	auipc	a1,0x1
     6d8:	e1458593          	addi	a1,a1,-492 # 14e8 <malloc+0x3ce>
     6dc:	f6040513          	addi	a0,s0,-160
     6e0:	2d8000ef          	jal	9b8 <strcmp>
     6e4:	a8050ee3          	beqz	a0,180 <go+0xd6>
     6e8:	aab5                	j	864 <go+0x7ba>
        fprintf(2, "grind: pipe failed\n");
     6ea:	00001597          	auipc	a1,0x1
     6ee:	c7e58593          	addi	a1,a1,-898 # 1368 <malloc+0x24e>
     6f2:	4509                	li	a0,2
     6f4:	145000ef          	jal	1038 <fprintf>
        exit(1);
     6f8:	4505                	li	a0,1
     6fa:	518000ef          	jal	c12 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	c6a58593          	addi	a1,a1,-918 # 1368 <malloc+0x24e>
     706:	4509                	li	a0,2
     708:	131000ef          	jal	1038 <fprintf>
        exit(1);
     70c:	4505                	li	a0,1
     70e:	504000ef          	jal	c12 <exit>
        close(bb[0]);
     712:	f7042503          	lw	a0,-144(s0)
     716:	594000ef          	jal	caa <close>
        close(bb[1]);
     71a:	f7442503          	lw	a0,-140(s0)
     71e:	58c000ef          	jal	caa <close>
        close(aa[0]);
     722:	f6842503          	lw	a0,-152(s0)
     726:	584000ef          	jal	caa <close>
        close(1);
     72a:	4505                	li	a0,1
     72c:	57e000ef          	jal	caa <close>
        if(dup(aa[1]) != 1){
     730:	f6c42503          	lw	a0,-148(s0)
     734:	51e000ef          	jal	c52 <dup>
     738:	4785                	li	a5,1
     73a:	00f50c63          	beq	a0,a5,752 <go+0x6a8>
          fprintf(2, "grind: dup failed\n");
     73e:	00001597          	auipc	a1,0x1
     742:	d3258593          	addi	a1,a1,-718 # 1470 <malloc+0x356>
     746:	4509                	li	a0,2
     748:	0f1000ef          	jal	1038 <fprintf>
          exit(1);
     74c:	4505                	li	a0,1
     74e:	4c4000ef          	jal	c12 <exit>
        close(aa[1]);
     752:	f6c42503          	lw	a0,-148(s0)
     756:	554000ef          	jal	caa <close>
        char *args[3] = { "echo", "hi", 0 };
     75a:	00001797          	auipc	a5,0x1
     75e:	d2e78793          	addi	a5,a5,-722 # 1488 <malloc+0x36e>
     762:	f6f43c23          	sd	a5,-136(s0)
     766:	00001797          	auipc	a5,0x1
     76a:	d2a78793          	addi	a5,a5,-726 # 1490 <malloc+0x376>
     76e:	f8f43023          	sd	a5,-128(s0)
     772:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     776:	f7840593          	addi	a1,s0,-136
     77a:	00001517          	auipc	a0,0x1
     77e:	d1e50513          	addi	a0,a0,-738 # 1498 <malloc+0x37e>
     782:	4b8000ef          	jal	c3a <exec>
        fprintf(2, "grind: echo: not found\n");
     786:	00001597          	auipc	a1,0x1
     78a:	d2258593          	addi	a1,a1,-734 # 14a8 <malloc+0x38e>
     78e:	4509                	li	a0,2
     790:	0a9000ef          	jal	1038 <fprintf>
        exit(2);
     794:	4509                	li	a0,2
     796:	47c000ef          	jal	c12 <exit>
        fprintf(2, "grind: fork failed\n");
     79a:	00001597          	auipc	a1,0x1
     79e:	b8658593          	addi	a1,a1,-1146 # 1320 <malloc+0x206>
     7a2:	4509                	li	a0,2
     7a4:	095000ef          	jal	1038 <fprintf>
        exit(3);
     7a8:	450d                	li	a0,3
     7aa:	468000ef          	jal	c12 <exit>
        close(aa[1]);
     7ae:	f6c42503          	lw	a0,-148(s0)
     7b2:	4f8000ef          	jal	caa <close>
        close(bb[0]);
     7b6:	f7042503          	lw	a0,-144(s0)
     7ba:	4f0000ef          	jal	caa <close>
        close(0);
     7be:	4501                	li	a0,0
     7c0:	4ea000ef          	jal	caa <close>
        if(dup(aa[0]) != 0){
     7c4:	f6842503          	lw	a0,-152(s0)
     7c8:	48a000ef          	jal	c52 <dup>
     7cc:	c919                	beqz	a0,7e2 <go+0x738>
          fprintf(2, "grind: dup failed\n");
     7ce:	00001597          	auipc	a1,0x1
     7d2:	ca258593          	addi	a1,a1,-862 # 1470 <malloc+0x356>
     7d6:	4509                	li	a0,2
     7d8:	061000ef          	jal	1038 <fprintf>
          exit(4);
     7dc:	4511                	li	a0,4
     7de:	434000ef          	jal	c12 <exit>
        close(aa[0]);
     7e2:	f6842503          	lw	a0,-152(s0)
     7e6:	4c4000ef          	jal	caa <close>
        close(1);
     7ea:	4505                	li	a0,1
     7ec:	4be000ef          	jal	caa <close>
        if(dup(bb[1]) != 1){
     7f0:	f7442503          	lw	a0,-140(s0)
     7f4:	45e000ef          	jal	c52 <dup>
     7f8:	4785                	li	a5,1
     7fa:	00f50c63          	beq	a0,a5,812 <go+0x768>
          fprintf(2, "grind: dup failed\n");
     7fe:	00001597          	auipc	a1,0x1
     802:	c7258593          	addi	a1,a1,-910 # 1470 <malloc+0x356>
     806:	4509                	li	a0,2
     808:	031000ef          	jal	1038 <fprintf>
          exit(5);
     80c:	4515                	li	a0,5
     80e:	404000ef          	jal	c12 <exit>
        close(bb[1]);
     812:	f7442503          	lw	a0,-140(s0)
     816:	494000ef          	jal	caa <close>
        char *args[2] = { "cat", 0 };
     81a:	00001797          	auipc	a5,0x1
     81e:	ca678793          	addi	a5,a5,-858 # 14c0 <malloc+0x3a6>
     822:	f6f43c23          	sd	a5,-136(s0)
     826:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     82a:	f7840593          	addi	a1,s0,-136
     82e:	00001517          	auipc	a0,0x1
     832:	c9a50513          	addi	a0,a0,-870 # 14c8 <malloc+0x3ae>
     836:	404000ef          	jal	c3a <exec>
        fprintf(2, "grind: cat: not found\n");
     83a:	00001597          	auipc	a1,0x1
     83e:	c9658593          	addi	a1,a1,-874 # 14d0 <malloc+0x3b6>
     842:	4509                	li	a0,2
     844:	7f4000ef          	jal	1038 <fprintf>
        exit(6);
     848:	4519                	li	a0,6
     84a:	3c8000ef          	jal	c12 <exit>
        fprintf(2, "grind: fork failed\n");
     84e:	00001597          	auipc	a1,0x1
     852:	ad258593          	addi	a1,a1,-1326 # 1320 <malloc+0x206>
     856:	4509                	li	a0,2
     858:	7e0000ef          	jal	1038 <fprintf>
        exit(7);
     85c:	451d                	li	a0,7
     85e:	3b4000ef          	jal	c12 <exit>
     862:	8d3e                	mv	s10,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     864:	f6040693          	addi	a3,s0,-160
     868:	f5043603          	ld	a2,-176(s0)
     86c:	85ea                	mv	a1,s10
     86e:	00001517          	auipc	a0,0x1
     872:	c8250513          	addi	a0,a0,-894 # 14f0 <malloc+0x3d6>
     876:	7ec000ef          	jal	1062 <printf>
        exit(1);
     87a:	4505                	li	a0,1
     87c:	396000ef          	jal	c12 <exit>

0000000000000880 <iter>:
  }
}

void
iter()
{
     880:	7179                	addi	sp,sp,-48
     882:	f406                	sd	ra,40(sp)
     884:	f022                	sd	s0,32(sp)
     886:	1800                	addi	s0,sp,48
  unlink("a");
     888:	00001517          	auipc	a0,0x1
     88c:	ab050513          	addi	a0,a0,-1360 # 1338 <malloc+0x21e>
     890:	402000ef          	jal	c92 <unlink>
  unlink("b");
     894:	00001517          	auipc	a0,0x1
     898:	a5450513          	addi	a0,a0,-1452 # 12e8 <malloc+0x1ce>
     89c:	3f6000ef          	jal	c92 <unlink>
  
  int pid1 = fork();
     8a0:	36a000ef          	jal	c0a <fork>
  if(pid1 < 0){
     8a4:	02054163          	bltz	a0,8c6 <iter+0x46>
     8a8:	ec26                	sd	s1,24(sp)
     8aa:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     8ac:	e905                	bnez	a0,8dc <iter+0x5c>
     8ae:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8b0:	00001717          	auipc	a4,0x1
     8b4:	75070713          	addi	a4,a4,1872 # 2000 <rand_next>
     8b8:	631c                	ld	a5,0(a4)
     8ba:	01f7c793          	xori	a5,a5,31
     8be:	e31c                	sd	a5,0(a4)
    go(0);
     8c0:	4501                	li	a0,0
     8c2:	fe8ff0ef          	jal	aa <go>
     8c6:	ec26                	sd	s1,24(sp)
     8c8:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8ca:	00001517          	auipc	a0,0x1
     8ce:	a5650513          	addi	a0,a0,-1450 # 1320 <malloc+0x206>
     8d2:	790000ef          	jal	1062 <printf>
    exit(1);
     8d6:	4505                	li	a0,1
     8d8:	33a000ef          	jal	c12 <exit>
     8dc:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8de:	32c000ef          	jal	c0a <fork>
     8e2:	892a                	mv	s2,a0
  if(pid2 < 0){
     8e4:	02054063          	bltz	a0,904 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     8e8:	e51d                	bnez	a0,916 <iter+0x96>
    rand_next ^= 7177;
     8ea:	00001697          	auipc	a3,0x1
     8ee:	71668693          	addi	a3,a3,1814 # 2000 <rand_next>
     8f2:	629c                	ld	a5,0(a3)
     8f4:	6709                	lui	a4,0x2
     8f6:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x689>
     8fa:	8fb9                	xor	a5,a5,a4
     8fc:	e29c                	sd	a5,0(a3)
    go(1);
     8fe:	4505                	li	a0,1
     900:	faaff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     904:	00001517          	auipc	a0,0x1
     908:	a1c50513          	addi	a0,a0,-1508 # 1320 <malloc+0x206>
     90c:	756000ef          	jal	1062 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	300000ef          	jal	c12 <exit>
    exit(0);
  }

  int st1 = -1;
     916:	57fd                	li	a5,-1
     918:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     91c:	fdc40513          	addi	a0,s0,-36
     920:	2fa000ef          	jal	c1a <wait>
  if(st1 != 0){
     924:	fdc42783          	lw	a5,-36(s0)
     928:	eb99                	bnez	a5,93e <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     92a:	57fd                	li	a5,-1
     92c:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     930:	fd840513          	addi	a0,s0,-40
     934:	2e6000ef          	jal	c1a <wait>

  exit(0);
     938:	4501                	li	a0,0
     93a:	2d8000ef          	jal	c12 <exit>
    kill(pid1);
     93e:	8526                	mv	a0,s1
     940:	2f2000ef          	jal	c32 <kill>
    kill(pid2);
     944:	854a                	mv	a0,s2
     946:	2ec000ef          	jal	c32 <kill>
     94a:	b7c5                	j	92a <iter+0xaa>

000000000000094c <main>:
}

int
main()
{
     94c:	1101                	addi	sp,sp,-32
     94e:	ec06                	sd	ra,24(sp)
     950:	e822                	sd	s0,16(sp)
     952:	e426                	sd	s1,8(sp)
     954:	e04a                	sd	s2,0(sp)
     956:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     958:	4951                	li	s2,20
    rand_next += 1;
     95a:	00001497          	auipc	s1,0x1
     95e:	6a648493          	addi	s1,s1,1702 # 2000 <rand_next>
     962:	a809                	j	974 <main+0x28>
      iter();
     964:	f1dff0ef          	jal	880 <iter>
    sleep(20);
     968:	854a                	mv	a0,s2
     96a:	300000ef          	jal	c6a <sleep>
    rand_next += 1;
     96e:	609c                	ld	a5,0(s1)
     970:	0785                	addi	a5,a5,1
     972:	e09c                	sd	a5,0(s1)
    int pid = fork();
     974:	296000ef          	jal	c0a <fork>
    if(pid == 0){
     978:	d575                	beqz	a0,964 <main+0x18>
    if(pid > 0){
     97a:	fea057e3          	blez	a0,968 <main+0x1c>
      wait(0);
     97e:	4501                	li	a0,0
     980:	29a000ef          	jal	c1a <wait>
     984:	b7d5                	j	968 <main+0x1c>

0000000000000986 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     986:	1141                	addi	sp,sp,-16
     988:	e406                	sd	ra,8(sp)
     98a:	e022                	sd	s0,0(sp)
     98c:	0800                	addi	s0,sp,16
  extern int main();
  main();
     98e:	fbfff0ef          	jal	94c <main>
  exit(0);
     992:	4501                	li	a0,0
     994:	27e000ef          	jal	c12 <exit>

0000000000000998 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     998:	1141                	addi	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9a0:	87aa                	mv	a5,a0
     9a2:	0585                	addi	a1,a1,1
     9a4:	0785                	addi	a5,a5,1
     9a6:	fff5c703          	lbu	a4,-1(a1)
     9aa:	fee78fa3          	sb	a4,-1(a5)
     9ae:	fb75                	bnez	a4,9a2 <strcpy+0xa>
    ;
  return os;
}
     9b0:	60a2                	ld	ra,8(sp)
     9b2:	6402                	ld	s0,0(sp)
     9b4:	0141                	addi	sp,sp,16
     9b6:	8082                	ret

00000000000009b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9b8:	1141                	addi	sp,sp,-16
     9ba:	e406                	sd	ra,8(sp)
     9bc:	e022                	sd	s0,0(sp)
     9be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9c0:	00054783          	lbu	a5,0(a0)
     9c4:	cb91                	beqz	a5,9d8 <strcmp+0x20>
     9c6:	0005c703          	lbu	a4,0(a1)
     9ca:	00f71763          	bne	a4,a5,9d8 <strcmp+0x20>
    p++, q++;
     9ce:	0505                	addi	a0,a0,1
     9d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9d2:	00054783          	lbu	a5,0(a0)
     9d6:	fbe5                	bnez	a5,9c6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9d8:	0005c503          	lbu	a0,0(a1)
}
     9dc:	40a7853b          	subw	a0,a5,a0
     9e0:	60a2                	ld	ra,8(sp)
     9e2:	6402                	ld	s0,0(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strlen>:

uint
strlen(const char *s)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9f0:	00054783          	lbu	a5,0(a0)
     9f4:	cf91                	beqz	a5,a10 <strlen+0x28>
     9f6:	00150793          	addi	a5,a0,1
     9fa:	86be                	mv	a3,a5
     9fc:	0785                	addi	a5,a5,1
     9fe:	fff7c703          	lbu	a4,-1(a5)
     a02:	ff65                	bnez	a4,9fa <strlen+0x12>
     a04:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a08:	60a2                	ld	ra,8(sp)
     a0a:	6402                	ld	s0,0(sp)
     a0c:	0141                	addi	sp,sp,16
     a0e:	8082                	ret
  for(n = 0; s[n]; n++)
     a10:	4501                	li	a0,0
     a12:	bfdd                	j	a08 <strlen+0x20>

0000000000000a14 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a14:	1141                	addi	sp,sp,-16
     a16:	e406                	sd	ra,8(sp)
     a18:	e022                	sd	s0,0(sp)
     a1a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a1c:	ca19                	beqz	a2,a32 <memset+0x1e>
     a1e:	87aa                	mv	a5,a0
     a20:	1602                	slli	a2,a2,0x20
     a22:	9201                	srli	a2,a2,0x20
     a24:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a28:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2c:	0785                	addi	a5,a5,1
     a2e:	fee79de3          	bne	a5,a4,a28 <memset+0x14>
  }
  return dst;
}
     a32:	60a2                	ld	ra,8(sp)
     a34:	6402                	ld	s0,0(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret

0000000000000a3a <strchr>:

char*
strchr(const char *s, char c)
{
     a3a:	1141                	addi	sp,sp,-16
     a3c:	e406                	sd	ra,8(sp)
     a3e:	e022                	sd	s0,0(sp)
     a40:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a42:	00054783          	lbu	a5,0(a0)
     a46:	cf81                	beqz	a5,a5e <strchr+0x24>
    if(*s == c)
     a48:	00f58763          	beq	a1,a5,a56 <strchr+0x1c>
  for(; *s; s++)
     a4c:	0505                	addi	a0,a0,1
     a4e:	00054783          	lbu	a5,0(a0)
     a52:	fbfd                	bnez	a5,a48 <strchr+0xe>
      return (char*)s;
  return 0;
     a54:	4501                	li	a0,0
}
     a56:	60a2                	ld	ra,8(sp)
     a58:	6402                	ld	s0,0(sp)
     a5a:	0141                	addi	sp,sp,16
     a5c:	8082                	ret
  return 0;
     a5e:	4501                	li	a0,0
     a60:	bfdd                	j	a56 <strchr+0x1c>

0000000000000a62 <gets>:

char*
gets(char *buf, int max)
{
     a62:	711d                	addi	sp,sp,-96
     a64:	ec86                	sd	ra,88(sp)
     a66:	e8a2                	sd	s0,80(sp)
     a68:	e4a6                	sd	s1,72(sp)
     a6a:	e0ca                	sd	s2,64(sp)
     a6c:	fc4e                	sd	s3,56(sp)
     a6e:	f852                	sd	s4,48(sp)
     a70:	f456                	sd	s5,40(sp)
     a72:	f05a                	sd	s6,32(sp)
     a74:	ec5e                	sd	s7,24(sp)
     a76:	e862                	sd	s8,16(sp)
     a78:	1080                	addi	s0,sp,96
     a7a:	8baa                	mv	s7,a0
     a7c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a7e:	892a                	mv	s2,a0
     a80:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a82:	faf40b13          	addi	s6,s0,-81
     a86:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     a88:	8c26                	mv	s8,s1
     a8a:	0014899b          	addiw	s3,s1,1
     a8e:	84ce                	mv	s1,s3
     a90:	0349d463          	bge	s3,s4,ab8 <gets+0x56>
    cc = read(0, &c, 1);
     a94:	8656                	mv	a2,s5
     a96:	85da                	mv	a1,s6
     a98:	4501                	li	a0,0
     a9a:	190000ef          	jal	c2a <read>
    if(cc < 1)
     a9e:	00a05d63          	blez	a0,ab8 <gets+0x56>
      break;
    buf[i++] = c;
     aa2:	faf44783          	lbu	a5,-81(s0)
     aa6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aaa:	0905                	addi	s2,s2,1
     aac:	ff678713          	addi	a4,a5,-10
     ab0:	c319                	beqz	a4,ab6 <gets+0x54>
     ab2:	17cd                	addi	a5,a5,-13
     ab4:	fbf1                	bnez	a5,a88 <gets+0x26>
    buf[i++] = c;
     ab6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     ab8:	9c5e                	add	s8,s8,s7
     aba:	000c0023          	sb	zero,0(s8)
  return buf;
}
     abe:	855e                	mv	a0,s7
     ac0:	60e6                	ld	ra,88(sp)
     ac2:	6446                	ld	s0,80(sp)
     ac4:	64a6                	ld	s1,72(sp)
     ac6:	6906                	ld	s2,64(sp)
     ac8:	79e2                	ld	s3,56(sp)
     aca:	7a42                	ld	s4,48(sp)
     acc:	7aa2                	ld	s5,40(sp)
     ace:	7b02                	ld	s6,32(sp)
     ad0:	6be2                	ld	s7,24(sp)
     ad2:	6c42                	ld	s8,16(sp)
     ad4:	6125                	addi	sp,sp,96
     ad6:	8082                	ret

0000000000000ad8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad8:	1101                	addi	sp,sp,-32
     ada:	ec06                	sd	ra,24(sp)
     adc:	e822                	sd	s0,16(sp)
     ade:	e04a                	sd	s2,0(sp)
     ae0:	1000                	addi	s0,sp,32
     ae2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae4:	4581                	li	a1,0
     ae6:	194000ef          	jal	c7a <open>
  if(fd < 0)
     aea:	02054263          	bltz	a0,b0e <stat+0x36>
     aee:	e426                	sd	s1,8(sp)
     af0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af2:	85ca                	mv	a1,s2
     af4:	14e000ef          	jal	c42 <fstat>
     af8:	892a                	mv	s2,a0
  close(fd);
     afa:	8526                	mv	a0,s1
     afc:	1ae000ef          	jal	caa <close>
  return r;
     b00:	64a2                	ld	s1,8(sp)
}
     b02:	854a                	mv	a0,s2
     b04:	60e2                	ld	ra,24(sp)
     b06:	6442                	ld	s0,16(sp)
     b08:	6902                	ld	s2,0(sp)
     b0a:	6105                	addi	sp,sp,32
     b0c:	8082                	ret
    return -1;
     b0e:	57fd                	li	a5,-1
     b10:	893e                	mv	s2,a5
     b12:	bfc5                	j	b02 <stat+0x2a>

0000000000000b14 <atoi>:

int
atoi(const char *s)
{
     b14:	1141                	addi	sp,sp,-16
     b16:	e406                	sd	ra,8(sp)
     b18:	e022                	sd	s0,0(sp)
     b1a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b1c:	00054683          	lbu	a3,0(a0)
     b20:	fd06879b          	addiw	a5,a3,-48
     b24:	0ff7f793          	zext.b	a5,a5
     b28:	4625                	li	a2,9
     b2a:	02f66963          	bltu	a2,a5,b5c <atoi+0x48>
     b2e:	872a                	mv	a4,a0
  n = 0;
     b30:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b32:	0705                	addi	a4,a4,1
     b34:	0025179b          	slliw	a5,a0,0x2
     b38:	9fa9                	addw	a5,a5,a0
     b3a:	0017979b          	slliw	a5,a5,0x1
     b3e:	9fb5                	addw	a5,a5,a3
     b40:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b44:	00074683          	lbu	a3,0(a4)
     b48:	fd06879b          	addiw	a5,a3,-48
     b4c:	0ff7f793          	zext.b	a5,a5
     b50:	fef671e3          	bgeu	a2,a5,b32 <atoi+0x1e>
  return n;
}
     b54:	60a2                	ld	ra,8(sp)
     b56:	6402                	ld	s0,0(sp)
     b58:	0141                	addi	sp,sp,16
     b5a:	8082                	ret
  n = 0;
     b5c:	4501                	li	a0,0
     b5e:	bfdd                	j	b54 <atoi+0x40>

0000000000000b60 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b60:	1141                	addi	sp,sp,-16
     b62:	e406                	sd	ra,8(sp)
     b64:	e022                	sd	s0,0(sp)
     b66:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b68:	02b57563          	bgeu	a0,a1,b92 <memmove+0x32>
    while(n-- > 0)
     b6c:	00c05f63          	blez	a2,b8a <memmove+0x2a>
     b70:	1602                	slli	a2,a2,0x20
     b72:	9201                	srli	a2,a2,0x20
     b74:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b78:	872a                	mv	a4,a0
      *dst++ = *src++;
     b7a:	0585                	addi	a1,a1,1
     b7c:	0705                	addi	a4,a4,1
     b7e:	fff5c683          	lbu	a3,-1(a1)
     b82:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b86:	fee79ae3          	bne	a5,a4,b7a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b8a:	60a2                	ld	ra,8(sp)
     b8c:	6402                	ld	s0,0(sp)
     b8e:	0141                	addi	sp,sp,16
     b90:	8082                	ret
    while(n-- > 0)
     b92:	fec05ce3          	blez	a2,b8a <memmove+0x2a>
    dst += n;
     b96:	00c50733          	add	a4,a0,a2
    src += n;
     b9a:	95b2                	add	a1,a1,a2
     b9c:	fff6079b          	addiw	a5,a2,-1
     ba0:	1782                	slli	a5,a5,0x20
     ba2:	9381                	srli	a5,a5,0x20
     ba4:	fff7c793          	not	a5,a5
     ba8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     baa:	15fd                	addi	a1,a1,-1
     bac:	177d                	addi	a4,a4,-1
     bae:	0005c683          	lbu	a3,0(a1)
     bb2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bb6:	fef71ae3          	bne	a4,a5,baa <memmove+0x4a>
     bba:	bfc1                	j	b8a <memmove+0x2a>

0000000000000bbc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bbc:	1141                	addi	sp,sp,-16
     bbe:	e406                	sd	ra,8(sp)
     bc0:	e022                	sd	s0,0(sp)
     bc2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bc4:	c61d                	beqz	a2,bf2 <memcmp+0x36>
     bc6:	1602                	slli	a2,a2,0x20
     bc8:	9201                	srli	a2,a2,0x20
     bca:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     bce:	00054783          	lbu	a5,0(a0)
     bd2:	0005c703          	lbu	a4,0(a1)
     bd6:	00e79863          	bne	a5,a4,be6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     bda:	0505                	addi	a0,a0,1
    p2++;
     bdc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bde:	fed518e3          	bne	a0,a3,bce <memcmp+0x12>
  }
  return 0;
     be2:	4501                	li	a0,0
     be4:	a019                	j	bea <memcmp+0x2e>
      return *p1 - *p2;
     be6:	40e7853b          	subw	a0,a5,a4
}
     bea:	60a2                	ld	ra,8(sp)
     bec:	6402                	ld	s0,0(sp)
     bee:	0141                	addi	sp,sp,16
     bf0:	8082                	ret
  return 0;
     bf2:	4501                	li	a0,0
     bf4:	bfdd                	j	bea <memcmp+0x2e>

0000000000000bf6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bf6:	1141                	addi	sp,sp,-16
     bf8:	e406                	sd	ra,8(sp)
     bfa:	e022                	sd	s0,0(sp)
     bfc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bfe:	f63ff0ef          	jal	b60 <memmove>
}
     c02:	60a2                	ld	ra,8(sp)
     c04:	6402                	ld	s0,0(sp)
     c06:	0141                	addi	sp,sp,16
     c08:	8082                	ret

0000000000000c0a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c0a:	4885                	li	a7,1
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c12:	4889                	li	a7,2
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c1a:	488d                	li	a7,3
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c22:	4891                	li	a7,4
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <read>:
.global read
read:
 li a7, SYS_read
     c2a:	4895                	li	a7,5
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c32:	4899                	li	a7,6
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c3a:	489d                	li	a7,7
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c42:	48a1                	li	a7,8
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c4a:	48a5                	li	a7,9
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c52:	48a9                	li	a7,10
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c5a:	48ad                	li	a7,11
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c62:	48b1                	li	a7,12
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c6a:	48b5                	li	a7,13
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c72:	48b9                	li	a7,14
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <open>:
.global open
open:
 li a7, SYS_open
     c7a:	48bd                	li	a7,15
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <write>:
.global write
write:
 li a7, SYS_write
     c82:	48c1                	li	a7,16
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c8a:	48c5                	li	a7,17
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c92:	48c9                	li	a7,18
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <link>:
.global link
link:
 li a7, SYS_link
     c9a:	48cd                	li	a7,19
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ca2:	48d1                	li	a7,20
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <close>:
.global close
close:
 li a7, SYS_close
     caa:	48d5                	li	a7,21
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
     cb2:	48d9                	li	a7,22
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
     cba:	48dd                	li	a7,23
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
     cc2:	48e1                	li	a7,24
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
     cca:	48e5                	li	a7,25
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cd2:	1101                	addi	sp,sp,-32
     cd4:	ec06                	sd	ra,24(sp)
     cd6:	e822                	sd	s0,16(sp)
     cd8:	1000                	addi	s0,sp,32
     cda:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cde:	4605                	li	a2,1
     ce0:	fef40593          	addi	a1,s0,-17
     ce4:	f9fff0ef          	jal	c82 <write>
}
     ce8:	60e2                	ld	ra,24(sp)
     cea:	6442                	ld	s0,16(sp)
     cec:	6105                	addi	sp,sp,32
     cee:	8082                	ret

0000000000000cf0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cf0:	7139                	addi	sp,sp,-64
     cf2:	fc06                	sd	ra,56(sp)
     cf4:	f822                	sd	s0,48(sp)
     cf6:	f04a                	sd	s2,32(sp)
     cf8:	ec4e                	sd	s3,24(sp)
     cfa:	0080                	addi	s0,sp,64
     cfc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cfe:	cac9                	beqz	a3,d90 <printint+0xa0>
     d00:	01f5d79b          	srliw	a5,a1,0x1f
     d04:	c7d1                	beqz	a5,d90 <printint+0xa0>
    neg = 1;
    x = -xx;
     d06:	40b005bb          	negw	a1,a1
    neg = 1;
     d0a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d0c:	fc040993          	addi	s3,s0,-64
  neg = 0;
     d10:	86ce                	mv	a3,s3
  i = 0;
     d12:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d14:	00001817          	auipc	a6,0x1
     d18:	86c80813          	addi	a6,a6,-1940 # 1580 <digits>
     d1c:	88ba                	mv	a7,a4
     d1e:	0017051b          	addiw	a0,a4,1
     d22:	872a                	mv	a4,a0
     d24:	02c5f7bb          	remuw	a5,a1,a2
     d28:	1782                	slli	a5,a5,0x20
     d2a:	9381                	srli	a5,a5,0x20
     d2c:	97c2                	add	a5,a5,a6
     d2e:	0007c783          	lbu	a5,0(a5)
     d32:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d36:	87ae                	mv	a5,a1
     d38:	02c5d5bb          	divuw	a1,a1,a2
     d3c:	0685                	addi	a3,a3,1
     d3e:	fcc7ffe3          	bgeu	a5,a2,d1c <printint+0x2c>
  if(neg)
     d42:	00030c63          	beqz	t1,d5a <printint+0x6a>
    buf[i++] = '-';
     d46:	fd050793          	addi	a5,a0,-48
     d4a:	00878533          	add	a0,a5,s0
     d4e:	02d00793          	li	a5,45
     d52:	fef50823          	sb	a5,-16(a0)
     d56:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d5a:	02e05563          	blez	a4,d84 <printint+0x94>
     d5e:	f426                	sd	s1,40(sp)
     d60:	377d                	addiw	a4,a4,-1
     d62:	00e984b3          	add	s1,s3,a4
     d66:	19fd                	addi	s3,s3,-1
     d68:	99ba                	add	s3,s3,a4
     d6a:	1702                	slli	a4,a4,0x20
     d6c:	9301                	srli	a4,a4,0x20
     d6e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d72:	0004c583          	lbu	a1,0(s1)
     d76:	854a                	mv	a0,s2
     d78:	f5bff0ef          	jal	cd2 <putc>
  while(--i >= 0)
     d7c:	14fd                	addi	s1,s1,-1
     d7e:	ff349ae3          	bne	s1,s3,d72 <printint+0x82>
     d82:	74a2                	ld	s1,40(sp)
}
     d84:	70e2                	ld	ra,56(sp)
     d86:	7442                	ld	s0,48(sp)
     d88:	7902                	ld	s2,32(sp)
     d8a:	69e2                	ld	s3,24(sp)
     d8c:	6121                	addi	sp,sp,64
     d8e:	8082                	ret
  neg = 0;
     d90:	4301                	li	t1,0
     d92:	bfad                	j	d0c <printint+0x1c>

0000000000000d94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d94:	711d                	addi	sp,sp,-96
     d96:	ec86                	sd	ra,88(sp)
     d98:	e8a2                	sd	s0,80(sp)
     d9a:	e4a6                	sd	s1,72(sp)
     d9c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d9e:	0005c483          	lbu	s1,0(a1)
     da2:	20048963          	beqz	s1,fb4 <vprintf+0x220>
     da6:	e0ca                	sd	s2,64(sp)
     da8:	fc4e                	sd	s3,56(sp)
     daa:	f852                	sd	s4,48(sp)
     dac:	f456                	sd	s5,40(sp)
     dae:	f05a                	sd	s6,32(sp)
     db0:	ec5e                	sd	s7,24(sp)
     db2:	e862                	sd	s8,16(sp)
     db4:	8b2a                	mv	s6,a0
     db6:	8a2e                	mv	s4,a1
     db8:	8bb2                	mv	s7,a2
  state = 0;
     dba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     dbc:	4901                	li	s2,0
     dbe:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dc0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dc4:	06400c13          	li	s8,100
     dc8:	a00d                	j	dea <vprintf+0x56>
        putc(fd, c0);
     dca:	85a6                	mv	a1,s1
     dcc:	855a                	mv	a0,s6
     dce:	f05ff0ef          	jal	cd2 <putc>
     dd2:	a019                	j	dd8 <vprintf+0x44>
    } else if(state == '%'){
     dd4:	03598363          	beq	s3,s5,dfa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     dd8:	0019079b          	addiw	a5,s2,1
     ddc:	893e                	mv	s2,a5
     dde:	873e                	mv	a4,a5
     de0:	97d2                	add	a5,a5,s4
     de2:	0007c483          	lbu	s1,0(a5)
     de6:	1c048063          	beqz	s1,fa6 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
     dea:	0004879b          	sext.w	a5,s1
    if(state == 0){
     dee:	fe0993e3          	bnez	s3,dd4 <vprintf+0x40>
      if(c0 == '%'){
     df2:	fd579ce3          	bne	a5,s5,dca <vprintf+0x36>
        state = '%';
     df6:	89be                	mv	s3,a5
     df8:	b7c5                	j	dd8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     dfa:	00ea06b3          	add	a3,s4,a4
     dfe:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e02:	1a060e63          	beqz	a2,fbe <vprintf+0x22a>
      if(c0 == 'd'){
     e06:	03878763          	beq	a5,s8,e34 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e0a:	f9478693          	addi	a3,a5,-108
     e0e:	0016b693          	seqz	a3,a3
     e12:	f9c60593          	addi	a1,a2,-100
     e16:	e99d                	bnez	a1,e4c <vprintf+0xb8>
     e18:	ca95                	beqz	a3,e4c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e1a:	008b8493          	addi	s1,s7,8
     e1e:	4685                	li	a3,1
     e20:	4629                	li	a2,10
     e22:	000ba583          	lw	a1,0(s7)
     e26:	855a                	mv	a0,s6
     e28:	ec9ff0ef          	jal	cf0 <printint>
        i += 1;
     e2c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e2e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e30:	4981                	li	s3,0
     e32:	b75d                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e34:	008b8493          	addi	s1,s7,8
     e38:	4685                	li	a3,1
     e3a:	4629                	li	a2,10
     e3c:	000ba583          	lw	a1,0(s7)
     e40:	855a                	mv	a0,s6
     e42:	eafff0ef          	jal	cf0 <printint>
     e46:	8ba6                	mv	s7,s1
      state = 0;
     e48:	4981                	li	s3,0
     e4a:	b779                	j	dd8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e4c:	9752                	add	a4,a4,s4
     e4e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e52:	f9460713          	addi	a4,a2,-108
     e56:	00173713          	seqz	a4,a4
     e5a:	8f75                	and	a4,a4,a3
     e5c:	f9c58513          	addi	a0,a1,-100
     e60:	16051963          	bnez	a0,fd2 <vprintf+0x23e>
     e64:	16070763          	beqz	a4,fd2 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e68:	008b8493          	addi	s1,s7,8
     e6c:	4685                	li	a3,1
     e6e:	4629                	li	a2,10
     e70:	000ba583          	lw	a1,0(s7)
     e74:	855a                	mv	a0,s6
     e76:	e7bff0ef          	jal	cf0 <printint>
        i += 2;
     e7a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e7c:	8ba6                	mv	s7,s1
      state = 0;
     e7e:	4981                	li	s3,0
        i += 2;
     e80:	bfa1                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
     e82:	008b8493          	addi	s1,s7,8
     e86:	4681                	li	a3,0
     e88:	4629                	li	a2,10
     e8a:	000ba583          	lw	a1,0(s7)
     e8e:	855a                	mv	a0,s6
     e90:	e61ff0ef          	jal	cf0 <printint>
     e94:	8ba6                	mv	s7,s1
      state = 0;
     e96:	4981                	li	s3,0
     e98:	b781                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e9a:	008b8493          	addi	s1,s7,8
     e9e:	4681                	li	a3,0
     ea0:	4629                	li	a2,10
     ea2:	000ba583          	lw	a1,0(s7)
     ea6:	855a                	mv	a0,s6
     ea8:	e49ff0ef          	jal	cf0 <printint>
        i += 1;
     eac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     eae:	8ba6                	mv	s7,s1
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	b71d                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eb4:	008b8493          	addi	s1,s7,8
     eb8:	4681                	li	a3,0
     eba:	4629                	li	a2,10
     ebc:	000ba583          	lw	a1,0(s7)
     ec0:	855a                	mv	a0,s6
     ec2:	e2fff0ef          	jal	cf0 <printint>
        i += 2;
     ec6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ec8:	8ba6                	mv	s7,s1
      state = 0;
     eca:	4981                	li	s3,0
        i += 2;
     ecc:	b731                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
     ece:	008b8493          	addi	s1,s7,8
     ed2:	4681                	li	a3,0
     ed4:	4641                	li	a2,16
     ed6:	000ba583          	lw	a1,0(s7)
     eda:	855a                	mv	a0,s6
     edc:	e15ff0ef          	jal	cf0 <printint>
     ee0:	8ba6                	mv	s7,s1
      state = 0;
     ee2:	4981                	li	s3,0
     ee4:	bdd5                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ee6:	008b8493          	addi	s1,s7,8
     eea:	4681                	li	a3,0
     eec:	4641                	li	a2,16
     eee:	000ba583          	lw	a1,0(s7)
     ef2:	855a                	mv	a0,s6
     ef4:	dfdff0ef          	jal	cf0 <printint>
        i += 1;
     ef8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     efa:	8ba6                	mv	s7,s1
      state = 0;
     efc:	4981                	li	s3,0
     efe:	bde9                	j	dd8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f00:	008b8493          	addi	s1,s7,8
     f04:	4681                	li	a3,0
     f06:	4641                	li	a2,16
     f08:	000ba583          	lw	a1,0(s7)
     f0c:	855a                	mv	a0,s6
     f0e:	de3ff0ef          	jal	cf0 <printint>
        i += 2;
     f12:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f14:	8ba6                	mv	s7,s1
      state = 0;
     f16:	4981                	li	s3,0
        i += 2;
     f18:	b5c1                	j	dd8 <vprintf+0x44>
     f1a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f1c:	008b8793          	addi	a5,s7,8
     f20:	8cbe                	mv	s9,a5
     f22:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f26:	03000593          	li	a1,48
     f2a:	855a                	mv	a0,s6
     f2c:	da7ff0ef          	jal	cd2 <putc>
  putc(fd, 'x');
     f30:	07800593          	li	a1,120
     f34:	855a                	mv	a0,s6
     f36:	d9dff0ef          	jal	cd2 <putc>
     f3a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f3c:	00000b97          	auipc	s7,0x0
     f40:	644b8b93          	addi	s7,s7,1604 # 1580 <digits>
     f44:	03c9d793          	srli	a5,s3,0x3c
     f48:	97de                	add	a5,a5,s7
     f4a:	0007c583          	lbu	a1,0(a5)
     f4e:	855a                	mv	a0,s6
     f50:	d83ff0ef          	jal	cd2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f54:	0992                	slli	s3,s3,0x4
     f56:	34fd                	addiw	s1,s1,-1
     f58:	f4f5                	bnez	s1,f44 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f5a:	8be6                	mv	s7,s9
      state = 0;
     f5c:	4981                	li	s3,0
     f5e:	6ca2                	ld	s9,8(sp)
     f60:	bda5                	j	dd8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f62:	008b8993          	addi	s3,s7,8
     f66:	000bb483          	ld	s1,0(s7)
     f6a:	cc91                	beqz	s1,f86 <vprintf+0x1f2>
        for(; *s; s++)
     f6c:	0004c583          	lbu	a1,0(s1)
     f70:	c985                	beqz	a1,fa0 <vprintf+0x20c>
          putc(fd, *s);
     f72:	855a                	mv	a0,s6
     f74:	d5fff0ef          	jal	cd2 <putc>
        for(; *s; s++)
     f78:	0485                	addi	s1,s1,1
     f7a:	0004c583          	lbu	a1,0(s1)
     f7e:	f9f5                	bnez	a1,f72 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
     f80:	8bce                	mv	s7,s3
      state = 0;
     f82:	4981                	li	s3,0
     f84:	bd91                	j	dd8 <vprintf+0x44>
          s = "(null)";
     f86:	00000497          	auipc	s1,0x0
     f8a:	59248493          	addi	s1,s1,1426 # 1518 <malloc+0x3fe>
        for(; *s; s++)
     f8e:	02800593          	li	a1,40
     f92:	b7c5                	j	f72 <vprintf+0x1de>
        putc(fd, '%');
     f94:	85be                	mv	a1,a5
     f96:	855a                	mv	a0,s6
     f98:	d3bff0ef          	jal	cd2 <putc>
      state = 0;
     f9c:	4981                	li	s3,0
     f9e:	bd2d                	j	dd8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fa0:	8bce                	mv	s7,s3
      state = 0;
     fa2:	4981                	li	s3,0
     fa4:	bd15                	j	dd8 <vprintf+0x44>
     fa6:	6906                	ld	s2,64(sp)
     fa8:	79e2                	ld	s3,56(sp)
     faa:	7a42                	ld	s4,48(sp)
     fac:	7aa2                	ld	s5,40(sp)
     fae:	7b02                	ld	s6,32(sp)
     fb0:	6be2                	ld	s7,24(sp)
     fb2:	6c42                	ld	s8,16(sp)
    }
  }
}
     fb4:	60e6                	ld	ra,88(sp)
     fb6:	6446                	ld	s0,80(sp)
     fb8:	64a6                	ld	s1,72(sp)
     fba:	6125                	addi	sp,sp,96
     fbc:	8082                	ret
      if(c0 == 'd'){
     fbe:	06400713          	li	a4,100
     fc2:	e6e789e3          	beq	a5,a4,e34 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     fc6:	f9478693          	addi	a3,a5,-108
     fca:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     fce:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fd0:	4701                	li	a4,0
      } else if(c0 == 'u'){
     fd2:	07500513          	li	a0,117
     fd6:	eaa786e3          	beq	a5,a0,e82 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     fda:	f8b60513          	addi	a0,a2,-117
     fde:	e119                	bnez	a0,fe4 <vprintf+0x250>
     fe0:	ea069de3          	bnez	a3,e9a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fe4:	f8b58513          	addi	a0,a1,-117
     fe8:	e119                	bnez	a0,fee <vprintf+0x25a>
     fea:	ec0715e3          	bnez	a4,eb4 <vprintf+0x120>
      } else if(c0 == 'x'){
     fee:	07800513          	li	a0,120
     ff2:	eca78ee3          	beq	a5,a0,ece <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     ff6:	f8860613          	addi	a2,a2,-120
     ffa:	e219                	bnez	a2,1000 <vprintf+0x26c>
     ffc:	ee0695e3          	bnez	a3,ee6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1000:	f8858593          	addi	a1,a1,-120
    1004:	e199                	bnez	a1,100a <vprintf+0x276>
    1006:	ee071de3          	bnez	a4,f00 <vprintf+0x16c>
      } else if(c0 == 'p'){
    100a:	07000713          	li	a4,112
    100e:	f0e786e3          	beq	a5,a4,f1a <vprintf+0x186>
      } else if(c0 == 's'){
    1012:	07300713          	li	a4,115
    1016:	f4e786e3          	beq	a5,a4,f62 <vprintf+0x1ce>
      } else if(c0 == '%'){
    101a:	02500713          	li	a4,37
    101e:	f6e78be3          	beq	a5,a4,f94 <vprintf+0x200>
        putc(fd, '%');
    1022:	02500593          	li	a1,37
    1026:	855a                	mv	a0,s6
    1028:	cabff0ef          	jal	cd2 <putc>
        putc(fd, c0);
    102c:	85a6                	mv	a1,s1
    102e:	855a                	mv	a0,s6
    1030:	ca3ff0ef          	jal	cd2 <putc>
      state = 0;
    1034:	4981                	li	s3,0
    1036:	b34d                	j	dd8 <vprintf+0x44>

0000000000001038 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1038:	715d                	addi	sp,sp,-80
    103a:	ec06                	sd	ra,24(sp)
    103c:	e822                	sd	s0,16(sp)
    103e:	1000                	addi	s0,sp,32
    1040:	e010                	sd	a2,0(s0)
    1042:	e414                	sd	a3,8(s0)
    1044:	e818                	sd	a4,16(s0)
    1046:	ec1c                	sd	a5,24(s0)
    1048:	03043023          	sd	a6,32(s0)
    104c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1050:	8622                	mv	a2,s0
    1052:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1056:	d3fff0ef          	jal	d94 <vprintf>
}
    105a:	60e2                	ld	ra,24(sp)
    105c:	6442                	ld	s0,16(sp)
    105e:	6161                	addi	sp,sp,80
    1060:	8082                	ret

0000000000001062 <printf>:

void
printf(const char *fmt, ...)
{
    1062:	711d                	addi	sp,sp,-96
    1064:	ec06                	sd	ra,24(sp)
    1066:	e822                	sd	s0,16(sp)
    1068:	1000                	addi	s0,sp,32
    106a:	e40c                	sd	a1,8(s0)
    106c:	e810                	sd	a2,16(s0)
    106e:	ec14                	sd	a3,24(s0)
    1070:	f018                	sd	a4,32(s0)
    1072:	f41c                	sd	a5,40(s0)
    1074:	03043823          	sd	a6,48(s0)
    1078:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    107c:	00840613          	addi	a2,s0,8
    1080:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1084:	85aa                	mv	a1,a0
    1086:	4505                	li	a0,1
    1088:	d0dff0ef          	jal	d94 <vprintf>
}
    108c:	60e2                	ld	ra,24(sp)
    108e:	6442                	ld	s0,16(sp)
    1090:	6125                	addi	sp,sp,96
    1092:	8082                	ret

0000000000001094 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1094:	1141                	addi	sp,sp,-16
    1096:	e406                	sd	ra,8(sp)
    1098:	e022                	sd	s0,0(sp)
    109a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    109c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a0:	00001797          	auipc	a5,0x1
    10a4:	f707b783          	ld	a5,-144(a5) # 2010 <freep>
    10a8:	a039                	j	10b6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10aa:	6398                	ld	a4,0(a5)
    10ac:	00e7e463          	bltu	a5,a4,10b4 <free+0x20>
    10b0:	00e6ea63          	bltu	a3,a4,10c4 <free+0x30>
{
    10b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b6:	fed7fae3          	bgeu	a5,a3,10aa <free+0x16>
    10ba:	6398                	ld	a4,0(a5)
    10bc:	00e6e463          	bltu	a3,a4,10c4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c0:	fee7eae3          	bltu	a5,a4,10b4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10c4:	ff852583          	lw	a1,-8(a0)
    10c8:	6390                	ld	a2,0(a5)
    10ca:	02059813          	slli	a6,a1,0x20
    10ce:	01c85713          	srli	a4,a6,0x1c
    10d2:	9736                	add	a4,a4,a3
    10d4:	02e60563          	beq	a2,a4,10fe <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    10d8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    10dc:	4790                	lw	a2,8(a5)
    10de:	02061593          	slli	a1,a2,0x20
    10e2:	01c5d713          	srli	a4,a1,0x1c
    10e6:	973e                	add	a4,a4,a5
    10e8:	02e68263          	beq	a3,a4,110c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    10ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10ee:	00001717          	auipc	a4,0x1
    10f2:	f2f73123          	sd	a5,-222(a4) # 2010 <freep>
}
    10f6:	60a2                	ld	ra,8(sp)
    10f8:	6402                	ld	s0,0(sp)
    10fa:	0141                	addi	sp,sp,16
    10fc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    10fe:	4618                	lw	a4,8(a2)
    1100:	9f2d                	addw	a4,a4,a1
    1102:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1106:	6398                	ld	a4,0(a5)
    1108:	6310                	ld	a2,0(a4)
    110a:	b7f9                	j	10d8 <free+0x44>
    p->s.size += bp->s.size;
    110c:	ff852703          	lw	a4,-8(a0)
    1110:	9f31                	addw	a4,a4,a2
    1112:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1114:	ff053683          	ld	a3,-16(a0)
    1118:	bfd1                	j	10ec <free+0x58>

000000000000111a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    111a:	7139                	addi	sp,sp,-64
    111c:	fc06                	sd	ra,56(sp)
    111e:	f822                	sd	s0,48(sp)
    1120:	f04a                	sd	s2,32(sp)
    1122:	ec4e                	sd	s3,24(sp)
    1124:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1126:	02051993          	slli	s3,a0,0x20
    112a:	0209d993          	srli	s3,s3,0x20
    112e:	09bd                	addi	s3,s3,15
    1130:	0049d993          	srli	s3,s3,0x4
    1134:	2985                	addiw	s3,s3,1
    1136:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1138:	00001517          	auipc	a0,0x1
    113c:	ed853503          	ld	a0,-296(a0) # 2010 <freep>
    1140:	c905                	beqz	a0,1170 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1142:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1144:	4798                	lw	a4,8(a5)
    1146:	09377663          	bgeu	a4,s3,11d2 <malloc+0xb8>
    114a:	f426                	sd	s1,40(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1152:	8a4e                	mv	s4,s3
    1154:	6705                	lui	a4,0x1
    1156:	00e9f363          	bgeu	s3,a4,115c <malloc+0x42>
    115a:	6a05                	lui	s4,0x1
    115c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1160:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1164:	00001497          	auipc	s1,0x1
    1168:	eac48493          	addi	s1,s1,-340 # 2010 <freep>
  if(p == (char*)-1)
    116c:	5afd                	li	s5,-1
    116e:	a83d                	j	11ac <malloc+0x92>
    1170:	f426                	sd	s1,40(sp)
    1172:	e852                	sd	s4,16(sp)
    1174:	e456                	sd	s5,8(sp)
    1176:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1178:	00001797          	auipc	a5,0x1
    117c:	29078793          	addi	a5,a5,656 # 2408 <base>
    1180:	00001717          	auipc	a4,0x1
    1184:	e8f73823          	sd	a5,-368(a4) # 2010 <freep>
    1188:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    118a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    118e:	b7d1                	j	1152 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1190:	6398                	ld	a4,0(a5)
    1192:	e118                	sd	a4,0(a0)
    1194:	a899                	j	11ea <malloc+0xd0>
  hp->s.size = nu;
    1196:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    119a:	0541                	addi	a0,a0,16
    119c:	ef9ff0ef          	jal	1094 <free>
  return freep;
    11a0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11a2:	c125                	beqz	a0,1202 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11a6:	4798                	lw	a4,8(a5)
    11a8:	03277163          	bgeu	a4,s2,11ca <malloc+0xb0>
    if(p == freep)
    11ac:	6098                	ld	a4,0(s1)
    11ae:	853e                	mv	a0,a5
    11b0:	fef71ae3          	bne	a4,a5,11a4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11b4:	8552                	mv	a0,s4
    11b6:	aadff0ef          	jal	c62 <sbrk>
  if(p == (char*)-1)
    11ba:	fd551ee3          	bne	a0,s5,1196 <malloc+0x7c>
        return 0;
    11be:	4501                	li	a0,0
    11c0:	74a2                	ld	s1,40(sp)
    11c2:	6a42                	ld	s4,16(sp)
    11c4:	6aa2                	ld	s5,8(sp)
    11c6:	6b02                	ld	s6,0(sp)
    11c8:	a03d                	j	11f6 <malloc+0xdc>
    11ca:	74a2                	ld	s1,40(sp)
    11cc:	6a42                	ld	s4,16(sp)
    11ce:	6aa2                	ld	s5,8(sp)
    11d0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11d2:	fae90fe3          	beq	s2,a4,1190 <malloc+0x76>
        p->s.size -= nunits;
    11d6:	4137073b          	subw	a4,a4,s3
    11da:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11dc:	02071693          	slli	a3,a4,0x20
    11e0:	01c6d713          	srli	a4,a3,0x1c
    11e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11ea:	00001717          	auipc	a4,0x1
    11ee:	e2a73323          	sd	a0,-474(a4) # 2010 <freep>
      return (void*)(p + 1);
    11f2:	01078513          	addi	a0,a5,16
  }
}
    11f6:	70e2                	ld	ra,56(sp)
    11f8:	7442                	ld	s0,48(sp)
    11fa:	7902                	ld	s2,32(sp)
    11fc:	69e2                	ld	s3,24(sp)
    11fe:	6121                	addi	sp,sp,64
    1200:	8082                	ret
    1202:	74a2                	ld	s1,40(sp)
    1204:	6a42                	ld	s4,16(sp)
    1206:	6aa2                	ld	s5,8(sp)
    1208:	6b02                	ld	s6,0(sp)
    120a:	b7f5                	j	11f6 <malloc+0xdc>
