
user/_freezerTest3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_status>:
int frozen = 0;
int cpu_intensive = 0;

void
print_status(int pid, const char *status)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  sleep(1);
  10:	4505                	li	a0,1
  12:	5f2000ef          	jal	604 <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	864a                	mv	a2,s2
  18:	85a6                	mv	a1,s1
  1a:	00001517          	auipc	a0,0x1
  1e:	b5650513          	addi	a0,a0,-1194 # b70 <malloc+0xf2>
  22:	1a5000ef          	jal	9c6 <printf>
}
  26:	60e2                	ld	ra,24(sp)
  28:	6442                	ld	s0,16(sp)
  2a:	64a2                	ld	s1,8(sp)
  2c:	6902                	ld	s2,0(sp)
  2e:	6105                	addi	sp,sp,32
  30:	8082                	ret

0000000000000032 <show_all_processes>:

void
show_all_processes(int pid)
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	1000                	addi	s0,sp,32
  3c:	84aa                	mv	s1,a0
  sleep(2);
  3e:	4509                	li	a0,2
  40:	5c4000ef          	jal	604 <sleep>
  printf("\nCurrent Processes:\n");
  44:	00001517          	auipc	a0,0x1
  48:	b3c50513          	addi	a0,a0,-1220 # b80 <malloc+0x102>
  4c:	17b000ef          	jal	9c6 <printf>
  sleep(1);
  50:	4505                	li	a0,1
  52:	5b2000ef          	jal	604 <sleep>
  printf("PID\tState\t\tCPU Usage\n");
  56:	00001517          	auipc	a0,0x1
  5a:	b4250513          	addi	a0,a0,-1214 # b98 <malloc+0x11a>
  5e:	169000ef          	jal	9c6 <printf>
  sleep(1);
  62:	4505                	li	a0,1
  64:	5a0000ef          	jal	604 <sleep>
  printf("--------------------------------\n");
  68:	00001517          	auipc	a0,0x1
  6c:	b4850513          	addi	a0,a0,-1208 # bb0 <malloc+0x132>
  70:	157000ef          	jal	9c6 <printf>
  sleep(1);
  74:	4505                	li	a0,1
  76:	58e000ef          	jal	604 <sleep>
  
  // Show parent process
  printf("%d\tRUNNING\t\tLow\n", getpid());
  7a:	57a000ef          	jal	5f4 <getpid>
  7e:	85aa                	mv	a1,a0
  80:	00001517          	auipc	a0,0x1
  84:	b5850513          	addi	a0,a0,-1192 # bd8 <malloc+0x15a>
  88:	13f000ef          	jal	9c6 <printf>
  sleep(1);
  8c:	4505                	li	a0,1
  8e:	576000ef          	jal	604 <sleep>
  
  // Show child process
  if(frozen) {
  92:	00002797          	auipc	a5,0x2
  96:	f727a783          	lw	a5,-142(a5) # 2004 <frozen>
  9a:	cbb9                	beqz	a5,f0 <show_all_processes+0xbe>
    printf("%d\tFROZEN\t\tHigh\n", pid);
  9c:	85a6                	mv	a1,s1
  9e:	00001517          	auipc	a0,0x1
  a2:	b5250513          	addi	a0,a0,-1198 # bf0 <malloc+0x172>
  a6:	121000ef          	jal	9c6 <printf>
  } else {
    printf("%d\tRUNNING\t\tHigh\n", pid);
  }
  sleep(1);
  aa:	4505                	li	a0,1
  ac:	558000ef          	jal	604 <sleep>
  
  // Show init and shell
  printf("1\tRUNNING\t\tLow\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	b7050513          	addi	a0,a0,-1168 # c20 <malloc+0x1a2>
  b8:	10f000ef          	jal	9c6 <printf>
  sleep(1);
  bc:	4505                	li	a0,1
  be:	546000ef          	jal	604 <sleep>
  printf("2\tRUNNING\t\tLow\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	b6e50513          	addi	a0,a0,-1170 # c30 <malloc+0x1b2>
  ca:	0fd000ef          	jal	9c6 <printf>
  sleep(1);
  ce:	4505                	li	a0,1
  d0:	534000ef          	jal	604 <sleep>
  
  printf("--------------------------------\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	adc50513          	addi	a0,a0,-1316 # bb0 <malloc+0x132>
  dc:	0eb000ef          	jal	9c6 <printf>
  sleep(1);
  e0:	4505                	li	a0,1
  e2:	522000ef          	jal	604 <sleep>
}
  e6:	60e2                	ld	ra,24(sp)
  e8:	6442                	ld	s0,16(sp)
  ea:	64a2                	ld	s1,8(sp)
  ec:	6105                	addi	sp,sp,32
  ee:	8082                	ret
    printf("%d\tRUNNING\t\tHigh\n", pid);
  f0:	85a6                	mv	a1,s1
  f2:	00001517          	auipc	a0,0x1
  f6:	b1650513          	addi	a0,a0,-1258 # c08 <malloc+0x18a>
  fa:	0cd000ef          	jal	9c6 <printf>
  fe:	b775                	j	aa <show_all_processes+0x78>

0000000000000100 <cpu_intensive_task>:

// CPU intensive task
void
cpu_intensive_task(void)
{
 100:	711d                	addi	sp,sp,-96
 102:	ec86                	sd	ra,88(sp)
 104:	e8a2                	sd	s0,80(sp)
 106:	e4a6                	sd	s1,72(sp)
 108:	e0ca                	sd	s2,64(sp)
 10a:	fc4e                	sd	s3,56(sp)
 10c:	f852                	sd	s4,48(sp)
 10e:	f456                	sd	s5,40(sp)
 110:	f05a                	sd	s6,32(sp)
 112:	ec5e                	sd	s7,24(sp)
 114:	e862                	sd	s8,16(sp)
 116:	e466                	sd	s9,8(sp)
 118:	1080                	addi	s0,sp,96
 11a:	3e800c13          	li	s8,1000
  while(1) {
    // Simulate CPU intensive work
    for(i = 0; i < 1000; i++) {
      for(j = 0; j < 1000; j++) {
        // Do some work
        if(i * j % 100 == 0) {
 11e:	51eb8a37          	lui	s4,0x51eb8
 122:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51eb650f>
 126:	06400a93          	li	s5,100
          sleep(1);  // Small sleep to prevent complete CPU hogging
 12a:	4b05                	li	s6,1
        }
      }
    }
    if(!cpu_intensive) break;  // Exit if not CPU intensive anymore
 12c:	00002c97          	auipc	s9,0x2
 130:	ed4c8c93          	addi	s9,s9,-300 # 2000 <cpu_intensive>
 134:	a83d                	j	172 <cpu_intensive_task+0x72>
          sleep(1);  // Small sleep to prevent complete CPU hogging
 136:	855a                	mv	a0,s6
 138:	4cc000ef          	jal	604 <sleep>
      for(j = 0; j < 1000; j++) {
 13c:	397d                	addiw	s2,s2,-1
 13e:	013484bb          	addw	s1,s1,s3
 142:	00090e63          	beqz	s2,15e <cpu_intensive_task+0x5e>
        if(i * j % 100 == 0) {
 146:	034487b3          	mul	a5,s1,s4
 14a:	9795                	srai	a5,a5,0x25
 14c:	41f4d71b          	sraiw	a4,s1,0x1f
 150:	9f99                	subw	a5,a5,a4
 152:	02fa87bb          	mulw	a5,s5,a5
 156:	40f487bb          	subw	a5,s1,a5
 15a:	f3ed                	bnez	a5,13c <cpu_intensive_task+0x3c>
 15c:	bfe9                	j	136 <cpu_intensive_task+0x36>
    for(i = 0; i < 1000; i++) {
 15e:	2b85                	addiw	s7,s7,1
 160:	018b8663          	beq	s7,s8,16c <cpu_intensive_task+0x6c>
      for(j = 0; j < 1000; j++) {
 164:	89de                	mv	s3,s7
{
 166:	4481                	li	s1,0
 168:	8962                	mv	s2,s8
 16a:	bff1                	j	146 <cpu_intensive_task+0x46>
    if(!cpu_intensive) break;  // Exit if not CPU intensive anymore
 16c:	000ca783          	lw	a5,0(s9)
 170:	c399                	beqz	a5,176 <cpu_intensive_task+0x76>
    for(i = 0; i < 1000; i++) {
 172:	4b81                	li	s7,0
 174:	bfc5                	j	164 <cpu_intensive_task+0x64>
  }
}
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6c42                	ld	s8,16(sp)
 18a:	6ca2                	ld	s9,8(sp)
 18c:	6125                	addi	sp,sp,96
 18e:	8082                	ret

0000000000000190 <main>:

int
main(int argc, char *argv[])
{
 190:	7179                	addi	sp,sp,-48
 192:	f406                	sd	ra,40(sp)
 194:	f022                	sd	s0,32(sp)
 196:	1800                	addi	s0,sp,48
  int child_pid = fork();
 198:	40c000ef          	jal	5a4 <fork>
  
  if(child_pid < 0){
 19c:	04054f63          	bltz	a0,1fa <main+0x6a>
 1a0:	ec26                	sd	s1,24(sp)
 1a2:	84aa                	mv	s1,a0
    printf("fork failed\n");
    exit(1);
  }
  
  if(child_pid == 0){
 1a4:	e53d                	bnez	a0,212 <main+0x82>
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
    // Child process
    int mypid = getpid();
 1aa:	44a000ef          	jal	5f4 <getpid>
 1ae:	84aa                	mv	s1,a0
    sleep(2);
 1b0:	4509                	li	a0,2
 1b2:	452000ef          	jal	604 <sleep>
    printf("Child process started (PID: %d)\n", mypid);
 1b6:	85a6                	mv	a1,s1
 1b8:	00001517          	auipc	a0,0x1
 1bc:	a9850513          	addi	a0,a0,-1384 # c50 <malloc+0x1d2>
 1c0:	007000ef          	jal	9c6 <printf>
    printf("Child process is CPU intensive\n");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	ab450513          	addi	a0,a0,-1356 # c78 <malloc+0x1fa>
 1cc:	7fa000ef          	jal	9c6 <printf>
    
    cpu_intensive = 1;
 1d0:	4785                	li	a5,1
 1d2:	00002717          	auipc	a4,0x2
 1d6:	e2f72723          	sw	a5,-466(a4) # 2000 <cpu_intensive>
    cpu_intensive_task();
 1da:	f27ff0ef          	jal	100 <cpu_intensive_task>
    
    // After being unfrozen, run normally
    while(1){
      print_status(mypid, "running normally");
 1de:	00001997          	auipc	s3,0x1
 1e2:	aba98993          	addi	s3,s3,-1350 # c98 <malloc+0x21a>
      sleep(100);
 1e6:	06400913          	li	s2,100
      print_status(mypid, "running normally");
 1ea:	85ce                	mv	a1,s3
 1ec:	8526                	mv	a0,s1
 1ee:	e13ff0ef          	jal	0 <print_status>
      sleep(100);
 1f2:	854a                	mv	a0,s2
 1f4:	410000ef          	jal	604 <sleep>
    while(1){
 1f8:	bfcd                	j	1ea <main+0x5a>
 1fa:	ec26                	sd	s1,24(sp)
 1fc:	e84a                	sd	s2,16(sp)
 1fe:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 200:	00001517          	auipc	a0,0x1
 204:	a4050513          	addi	a0,a0,-1472 # c40 <malloc+0x1c2>
 208:	7be000ef          	jal	9c6 <printf>
    exit(1);
 20c:	4505                	li	a0,1
 20e:	39e000ef          	jal	5ac <exit>
 212:	e84a                	sd	s2,16(sp)
 214:	e44e                	sd	s3,8(sp)
    }
  } else {
    // Parent process
    int mypid = getpid();
 216:	3de000ef          	jal	5f4 <getpid>
 21a:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
 21c:	8626                	mv	a2,s1
 21e:	00001517          	auipc	a0,0x1
 222:	a9250513          	addi	a0,a0,-1390 # cb0 <malloc+0x232>
 226:	7a0000ef          	jal	9c6 <printf>
    
    // Show initial state
    show_all_processes(child_pid);
 22a:	8526                	mv	a0,s1
 22c:	e07ff0ef          	jal	32 <show_all_processes>
    
    // Wait for child to start CPU intensive work
    sleep(300);
 230:	12c00513          	li	a0,300
 234:	3d0000ef          	jal	604 <sleep>
    
    // Freeze CPU intensive child
    printf("\nAttempting to freeze CPU intensive child process %d...\n", child_pid);
 238:	85a6                	mv	a1,s1
 23a:	00001517          	auipc	a0,0x1
 23e:	aae50513          	addi	a0,a0,-1362 # ce8 <malloc+0x26a>
 242:	784000ef          	jal	9c6 <printf>
    if(freeze(child_pid) < 0){
 246:	8526                	mv	a0,s1
 248:	404000ef          	jal	64c <freeze>
 24c:	0a054163          	bltz	a0,2ee <main+0x15e>
      printf("Error: Failed to freeze process %d\n", child_pid);
    } else {
      frozen = 1;
 250:	4785                	li	a5,1
 252:	00002717          	auipc	a4,0x2
 256:	daf72923          	sw	a5,-590(a4) # 2004 <frozen>
      print_status(child_pid, "Frozen");
 25a:	00001597          	auipc	a1,0x1
 25e:	af658593          	addi	a1,a1,-1290 # d50 <malloc+0x2d2>
 262:	8526                	mv	a0,s1
 264:	d9dff0ef          	jal	0 <print_status>
    }
    
    show_all_processes(child_pid);
 268:	8526                	mv	a0,s1
 26a:	dc9ff0ef          	jal	32 <show_all_processes>
    sleep(300);
 26e:	12c00513          	li	a0,300
 272:	392000ef          	jal	604 <sleep>
    
    // Unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
 276:	85a6                	mv	a1,s1
 278:	00001517          	auipc	a0,0x1
 27c:	ae050513          	addi	a0,a0,-1312 # d58 <malloc+0x2da>
 280:	746000ef          	jal	9c6 <printf>
    if(unfreeze(child_pid) < 0){
 284:	8526                	mv	a0,s1
 286:	3ce000ef          	jal	654 <unfreeze>
 28a:	06054a63          	bltz	a0,2fe <main+0x16e>
      printf("Error: Failed to unfreeze process %d\n", child_pid);
    } else {
      frozen = 0;
 28e:	00002797          	auipc	a5,0x2
 292:	d607ab23          	sw	zero,-650(a5) # 2004 <frozen>
      cpu_intensive = 0;  // Stop CPU intensive work
 296:	00002797          	auipc	a5,0x2
 29a:	d607a523          	sw	zero,-662(a5) # 2000 <cpu_intensive>
      print_status(child_pid, "Unfrozen");
 29e:	00001597          	auipc	a1,0x1
 2a2:	b1258593          	addi	a1,a1,-1262 # db0 <malloc+0x332>
 2a6:	8526                	mv	a0,s1
 2a8:	d59ff0ef          	jal	0 <print_status>
    }
    
    show_all_processes(child_pid);
 2ac:	8526                	mv	a0,s1
 2ae:	d85ff0ef          	jal	32 <show_all_processes>
    sleep(300);
 2b2:	12c00513          	li	a0,300
 2b6:	34e000ef          	jal	604 <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 2ba:	85a6                	mv	a1,s1
 2bc:	00001517          	auipc	a0,0x1
 2c0:	b0450513          	addi	a0,a0,-1276 # dc0 <malloc+0x342>
 2c4:	702000ef          	jal	9c6 <printf>
    kill(child_pid);
 2c8:	8526                	mv	a0,s1
 2ca:	302000ef          	jal	5cc <kill>
    wait(0);
 2ce:	4501                	li	a0,0
 2d0:	2e4000ef          	jal	5b4 <wait>
    print_status(child_pid, "Terminated");
 2d4:	00001597          	auipc	a1,0x1
 2d8:	b1458593          	addi	a1,a1,-1260 # de8 <malloc+0x36a>
 2dc:	8526                	mv	a0,s1
 2de:	d23ff0ef          	jal	0 <print_status>
    
    show_all_processes(child_pid);
 2e2:	8526                	mv	a0,s1
 2e4:	d4fff0ef          	jal	32 <show_all_processes>
  }
  
  exit(0);
 2e8:	4501                	li	a0,0
 2ea:	2c2000ef          	jal	5ac <exit>
      printf("Error: Failed to freeze process %d\n", child_pid);
 2ee:	85a6                	mv	a1,s1
 2f0:	00001517          	auipc	a0,0x1
 2f4:	a3850513          	addi	a0,a0,-1480 # d28 <malloc+0x2aa>
 2f8:	6ce000ef          	jal	9c6 <printf>
 2fc:	b7b5                	j	268 <main+0xd8>
      printf("Error: Failed to unfreeze process %d\n", child_pid);
 2fe:	85a6                	mv	a1,s1
 300:	00001517          	auipc	a0,0x1
 304:	a8850513          	addi	a0,a0,-1400 # d88 <malloc+0x30a>
 308:	6be000ef          	jal	9c6 <printf>
 30c:	b745                	j	2ac <main+0x11c>

000000000000030e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  extern int main();
  main();
 316:	e7bff0ef          	jal	190 <main>
  exit(0);
 31a:	4501                	li	a0,0
 31c:	290000ef          	jal	5ac <exit>

0000000000000320 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 328:	87aa                	mv	a5,a0
 32a:	0585                	addi	a1,a1,1
 32c:	0785                	addi	a5,a5,1
 32e:	fff5c703          	lbu	a4,-1(a1)
 332:	fee78fa3          	sb	a4,-1(a5)
 336:	fb75                	bnez	a4,32a <strcpy+0xa>
    ;
  return os;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cb91                	beqz	a5,360 <strcmp+0x20>
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00f71763          	bne	a4,a5,360 <strcmp+0x20>
    p++, q++;
 356:	0505                	addi	a0,a0,1
 358:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	fbe5                	bnez	a5,34e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 360:	0005c503          	lbu	a0,0(a1)
}
 364:	40a7853b          	subw	a0,a5,a0
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <strlen>:

uint
strlen(const char *s)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 378:	00054783          	lbu	a5,0(a0)
 37c:	cf99                	beqz	a5,39a <strlen+0x2a>
 37e:	0505                	addi	a0,a0,1
 380:	87aa                	mv	a5,a0
 382:	86be                	mv	a3,a5
 384:	0785                	addi	a5,a5,1
 386:	fff7c703          	lbu	a4,-1(a5)
 38a:	ff65                	bnez	a4,382 <strlen+0x12>
 38c:	40a6853b          	subw	a0,a3,a0
 390:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret
  for(n = 0; s[n]; n++)
 39a:	4501                	li	a0,0
 39c:	bfdd                	j	392 <strlen+0x22>

000000000000039e <memset>:

void*
memset(void *dst, int c, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3a6:	ca19                	beqz	a2,3bc <memset+0x1e>
 3a8:	87aa                	mv	a5,a0
 3aa:	1602                	slli	a2,a2,0x20
 3ac:	9201                	srli	a2,a2,0x20
 3ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b6:	0785                	addi	a5,a5,1
 3b8:	fee79de3          	bne	a5,a4,3b2 <memset+0x14>
  }
  return dst;
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <strchr>:

char*
strchr(const char *s, char c)
{
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e406                	sd	ra,8(sp)
 3c8:	e022                	sd	s0,0(sp)
 3ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3cc:	00054783          	lbu	a5,0(a0)
 3d0:	cf81                	beqz	a5,3e8 <strchr+0x24>
    if(*s == c)
 3d2:	00f58763          	beq	a1,a5,3e0 <strchr+0x1c>
  for(; *s; s++)
 3d6:	0505                	addi	a0,a0,1
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	fbfd                	bnez	a5,3d2 <strchr+0xe>
      return (char*)s;
  return 0;
 3de:	4501                	li	a0,0
}
 3e0:	60a2                	ld	ra,8(sp)
 3e2:	6402                	ld	s0,0(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfdd                	j	3e0 <strchr+0x1c>

00000000000003ec <gets>:

char*
gets(char *buf, int max)
{
 3ec:	7159                	addi	sp,sp,-112
 3ee:	f486                	sd	ra,104(sp)
 3f0:	f0a2                	sd	s0,96(sp)
 3f2:	eca6                	sd	s1,88(sp)
 3f4:	e8ca                	sd	s2,80(sp)
 3f6:	e4ce                	sd	s3,72(sp)
 3f8:	e0d2                	sd	s4,64(sp)
 3fa:	fc56                	sd	s5,56(sp)
 3fc:	f85a                	sd	s6,48(sp)
 3fe:	f45e                	sd	s7,40(sp)
 400:	f062                	sd	s8,32(sp)
 402:	ec66                	sd	s9,24(sp)
 404:	e86a                	sd	s10,16(sp)
 406:	1880                	addi	s0,sp,112
 408:	8caa                	mv	s9,a0
 40a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 40c:	892a                	mv	s2,a0
 40e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 410:	f9f40b13          	addi	s6,s0,-97
 414:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 416:	4ba9                	li	s7,10
 418:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 41a:	8d26                	mv	s10,s1
 41c:	0014899b          	addiw	s3,s1,1
 420:	84ce                	mv	s1,s3
 422:	0349d563          	bge	s3,s4,44c <gets+0x60>
    cc = read(0, &c, 1);
 426:	8656                	mv	a2,s5
 428:	85da                	mv	a1,s6
 42a:	4501                	li	a0,0
 42c:	198000ef          	jal	5c4 <read>
    if(cc < 1)
 430:	00a05e63          	blez	a0,44c <gets+0x60>
    buf[i++] = c;
 434:	f9f44783          	lbu	a5,-97(s0)
 438:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43c:	01778763          	beq	a5,s7,44a <gets+0x5e>
 440:	0905                	addi	s2,s2,1
 442:	fd879ce3          	bne	a5,s8,41a <gets+0x2e>
    buf[i++] = c;
 446:	8d4e                	mv	s10,s3
 448:	a011                	j	44c <gets+0x60>
 44a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 44c:	9d66                	add	s10,s10,s9
 44e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 452:	8566                	mv	a0,s9
 454:	70a6                	ld	ra,104(sp)
 456:	7406                	ld	s0,96(sp)
 458:	64e6                	ld	s1,88(sp)
 45a:	6946                	ld	s2,80(sp)
 45c:	69a6                	ld	s3,72(sp)
 45e:	6a06                	ld	s4,64(sp)
 460:	7ae2                	ld	s5,56(sp)
 462:	7b42                	ld	s6,48(sp)
 464:	7ba2                	ld	s7,40(sp)
 466:	7c02                	ld	s8,32(sp)
 468:	6ce2                	ld	s9,24(sp)
 46a:	6d42                	ld	s10,16(sp)
 46c:	6165                	addi	sp,sp,112
 46e:	8082                	ret

0000000000000470 <stat>:

int
stat(const char *n, struct stat *st)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	e04a                	sd	s2,0(sp)
 478:	1000                	addi	s0,sp,32
 47a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47c:	4581                	li	a1,0
 47e:	196000ef          	jal	614 <open>
  if(fd < 0)
 482:	02054263          	bltz	a0,4a6 <stat+0x36>
 486:	e426                	sd	s1,8(sp)
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	150000ef          	jal	5dc <fstat>
 490:	892a                	mv	s2,a0
  close(fd);
 492:	8526                	mv	a0,s1
 494:	1b0000ef          	jal	644 <close>
  return r;
 498:	64a2                	ld	s1,8(sp)
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6902                	ld	s2,0(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret
    return -1;
 4a6:	597d                	li	s2,-1
 4a8:	bfcd                	j	49a <stat+0x2a>

00000000000004aa <atoi>:

int
atoi(const char *s)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e406                	sd	ra,8(sp)
 4ae:	e022                	sd	s0,0(sp)
 4b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b2:	00054683          	lbu	a3,0(a0)
 4b6:	fd06879b          	addiw	a5,a3,-48
 4ba:	0ff7f793          	zext.b	a5,a5
 4be:	4625                	li	a2,9
 4c0:	02f66963          	bltu	a2,a5,4f2 <atoi+0x48>
 4c4:	872a                	mv	a4,a0
  n = 0;
 4c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4c8:	0705                	addi	a4,a4,1
 4ca:	0025179b          	slliw	a5,a0,0x2
 4ce:	9fa9                	addw	a5,a5,a0
 4d0:	0017979b          	slliw	a5,a5,0x1
 4d4:	9fb5                	addw	a5,a5,a3
 4d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4da:	00074683          	lbu	a3,0(a4)
 4de:	fd06879b          	addiw	a5,a3,-48
 4e2:	0ff7f793          	zext.b	a5,a5
 4e6:	fef671e3          	bgeu	a2,a5,4c8 <atoi+0x1e>
  return n;
}
 4ea:	60a2                	ld	ra,8(sp)
 4ec:	6402                	ld	s0,0(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
  n = 0;
 4f2:	4501                	li	a0,0
 4f4:	bfdd                	j	4ea <atoi+0x40>

00000000000004f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e406                	sd	ra,8(sp)
 4fa:	e022                	sd	s0,0(sp)
 4fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4fe:	02b57563          	bgeu	a0,a1,528 <memmove+0x32>
    while(n-- > 0)
 502:	00c05f63          	blez	a2,520 <memmove+0x2a>
 506:	1602                	slli	a2,a2,0x20
 508:	9201                	srli	a2,a2,0x20
 50a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 50e:	872a                	mv	a4,a0
      *dst++ = *src++;
 510:	0585                	addi	a1,a1,1
 512:	0705                	addi	a4,a4,1
 514:	fff5c683          	lbu	a3,-1(a1)
 518:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 51c:	fee79ae3          	bne	a5,a4,510 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 52e:	fec059e3          	blez	a2,520 <memmove+0x2a>
 532:	fff6079b          	addiw	a5,a2,-1
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 540:	15fd                	addi	a1,a1,-1
 542:	177d                	addi	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 54c:	fef71ae3          	bne	a4,a5,540 <memmove+0x4a>
 550:	bfc1                	j	520 <memmove+0x2a>

0000000000000552 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e406                	sd	ra,8(sp)
 556:	e022                	sd	s0,0(sp)
 558:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 55a:	ca0d                	beqz	a2,58c <memcmp+0x3a>
 55c:	fff6069b          	addiw	a3,a2,-1
 560:	1682                	slli	a3,a3,0x20
 562:	9281                	srli	a3,a3,0x20
 564:	0685                	addi	a3,a3,1
 566:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 568:	00054783          	lbu	a5,0(a0)
 56c:	0005c703          	lbu	a4,0(a1)
 570:	00e79863          	bne	a5,a4,580 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 574:	0505                	addi	a0,a0,1
    p2++;
 576:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 578:	fed518e3          	bne	a0,a3,568 <memcmp+0x16>
  }
  return 0;
 57c:	4501                	li	a0,0
 57e:	a019                	j	584 <memcmp+0x32>
      return *p1 - *p2;
 580:	40e7853b          	subw	a0,a5,a4
}
 584:	60a2                	ld	ra,8(sp)
 586:	6402                	ld	s0,0(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
  return 0;
 58c:	4501                	li	a0,0
 58e:	bfdd                	j	584 <memcmp+0x32>

0000000000000590 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 590:	1141                	addi	sp,sp,-16
 592:	e406                	sd	ra,8(sp)
 594:	e022                	sd	s0,0(sp)
 596:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 598:	f5fff0ef          	jal	4f6 <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a4:	4885                	li	a7,1
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ac:	4889                	li	a7,2
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b4:	488d                	li	a7,3
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5bc:	4891                	li	a7,4
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <read>:
.global read
read:
 li a7, SYS_read
 5c4:	4895                	li	a7,5
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5cc:	4899                	li	a7,6
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d4:	489d                	li	a7,7
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5dc:	48a1                	li	a7,8
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e4:	48a5                	li	a7,9
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ec:	48a9                	li	a7,10
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f4:	48ad                	li	a7,11
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fc:	48b1                	li	a7,12
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 604:	48b5                	li	a7,13
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60c:	48b9                	li	a7,14
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <open>:
.global open
open:
 li a7, SYS_open
 614:	48bd                	li	a7,15
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <write>:
.global write
write:
 li a7, SYS_write
 61c:	48c1                	li	a7,16
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 624:	48c5                	li	a7,17
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 62c:	48c9                	li	a7,18
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <link>:
.global link
link:
 li a7, SYS_link
 634:	48cd                	li	a7,19
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 63c:	48d1                	li	a7,20
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <close>:
.global close
close:
 li a7, SYS_close
 644:	48d5                	li	a7,21
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 64c:	48d9                	li	a7,22
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 654:	48dd                	li	a7,23
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 65c:	48e1                	li	a7,24
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 664:	1101                	addi	sp,sp,-32
 666:	ec06                	sd	ra,24(sp)
 668:	e822                	sd	s0,16(sp)
 66a:	1000                	addi	s0,sp,32
 66c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 670:	4605                	li	a2,1
 672:	fef40593          	addi	a1,s0,-17
 676:	fa7ff0ef          	jal	61c <write>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6105                	addi	sp,sp,32
 680:	8082                	ret

0000000000000682 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 682:	7139                	addi	sp,sp,-64
 684:	fc06                	sd	ra,56(sp)
 686:	f822                	sd	s0,48(sp)
 688:	f426                	sd	s1,40(sp)
 68a:	f04a                	sd	s2,32(sp)
 68c:	ec4e                	sd	s3,24(sp)
 68e:	0080                	addi	s0,sp,64
 690:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 692:	c299                	beqz	a3,698 <printint+0x16>
 694:	0605ce63          	bltz	a1,710 <printint+0x8e>
  neg = 0;
 698:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 69a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 69e:	869a                	mv	a3,t1
  i = 0;
 6a0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6a2:	00000817          	auipc	a6,0x0
 6a6:	75e80813          	addi	a6,a6,1886 # e00 <digits>
 6aa:	88be                	mv	a7,a5
 6ac:	0017851b          	addiw	a0,a5,1
 6b0:	87aa                	mv	a5,a0
 6b2:	02c5f73b          	remuw	a4,a1,a2
 6b6:	1702                	slli	a4,a4,0x20
 6b8:	9301                	srli	a4,a4,0x20
 6ba:	9742                	add	a4,a4,a6
 6bc:	00074703          	lbu	a4,0(a4)
 6c0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6c4:	872e                	mv	a4,a1
 6c6:	02c5d5bb          	divuw	a1,a1,a2
 6ca:	0685                	addi	a3,a3,1
 6cc:	fcc77fe3          	bgeu	a4,a2,6aa <printint+0x28>
  if(neg)
 6d0:	000e0c63          	beqz	t3,6e8 <printint+0x66>
    buf[i++] = '-';
 6d4:	fd050793          	addi	a5,a0,-48
 6d8:	00878533          	add	a0,a5,s0
 6dc:	02d00793          	li	a5,45
 6e0:	fef50823          	sb	a5,-16(a0)
 6e4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6e8:	fff7899b          	addiw	s3,a5,-1
 6ec:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6f0:	fff4c583          	lbu	a1,-1(s1)
 6f4:	854a                	mv	a0,s2
 6f6:	f6fff0ef          	jal	664 <putc>
  while(--i >= 0)
 6fa:	39fd                	addiw	s3,s3,-1
 6fc:	14fd                	addi	s1,s1,-1
 6fe:	fe09d9e3          	bgez	s3,6f0 <printint+0x6e>
}
 702:	70e2                	ld	ra,56(sp)
 704:	7442                	ld	s0,48(sp)
 706:	74a2                	ld	s1,40(sp)
 708:	7902                	ld	s2,32(sp)
 70a:	69e2                	ld	s3,24(sp)
 70c:	6121                	addi	sp,sp,64
 70e:	8082                	ret
    x = -xx;
 710:	40b005bb          	negw	a1,a1
    neg = 1;
 714:	4e05                	li	t3,1
    x = -xx;
 716:	b751                	j	69a <printint+0x18>

0000000000000718 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 718:	711d                	addi	sp,sp,-96
 71a:	ec86                	sd	ra,88(sp)
 71c:	e8a2                	sd	s0,80(sp)
 71e:	e4a6                	sd	s1,72(sp)
 720:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 722:	0005c483          	lbu	s1,0(a1)
 726:	26048663          	beqz	s1,992 <vprintf+0x27a>
 72a:	e0ca                	sd	s2,64(sp)
 72c:	fc4e                	sd	s3,56(sp)
 72e:	f852                	sd	s4,48(sp)
 730:	f456                	sd	s5,40(sp)
 732:	f05a                	sd	s6,32(sp)
 734:	ec5e                	sd	s7,24(sp)
 736:	e862                	sd	s8,16(sp)
 738:	e466                	sd	s9,8(sp)
 73a:	8b2a                	mv	s6,a0
 73c:	8a2e                	mv	s4,a1
 73e:	8bb2                	mv	s7,a2
  state = 0;
 740:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 742:	4901                	li	s2,0
 744:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 746:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 74a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 74e:	06c00c93          	li	s9,108
 752:	a00d                	j	774 <vprintf+0x5c>
        putc(fd, c0);
 754:	85a6                	mv	a1,s1
 756:	855a                	mv	a0,s6
 758:	f0dff0ef          	jal	664 <putc>
 75c:	a019                	j	762 <vprintf+0x4a>
    } else if(state == '%'){
 75e:	03598363          	beq	s3,s5,784 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 762:	0019079b          	addiw	a5,s2,1
 766:	893e                	mv	s2,a5
 768:	873e                	mv	a4,a5
 76a:	97d2                	add	a5,a5,s4
 76c:	0007c483          	lbu	s1,0(a5)
 770:	20048963          	beqz	s1,982 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 774:	0004879b          	sext.w	a5,s1
    if(state == 0){
 778:	fe0993e3          	bnez	s3,75e <vprintf+0x46>
      if(c0 == '%'){
 77c:	fd579ce3          	bne	a5,s5,754 <vprintf+0x3c>
        state = '%';
 780:	89be                	mv	s3,a5
 782:	b7c5                	j	762 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 784:	00ea06b3          	add	a3,s4,a4
 788:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 78c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 78e:	c681                	beqz	a3,796 <vprintf+0x7e>
 790:	9752                	add	a4,a4,s4
 792:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 796:	03878e63          	beq	a5,s8,7d2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 79a:	05978863          	beq	a5,s9,7ea <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 79e:	07500713          	li	a4,117
 7a2:	0ee78263          	beq	a5,a4,886 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7a6:	07800713          	li	a4,120
 7aa:	12e78463          	beq	a5,a4,8d2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7ae:	07000713          	li	a4,112
 7b2:	14e78963          	beq	a5,a4,904 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7b6:	07300713          	li	a4,115
 7ba:	18e78863          	beq	a5,a4,94a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7be:	02500713          	li	a4,37
 7c2:	04e79463          	bne	a5,a4,80a <vprintf+0xf2>
        putc(fd, '%');
 7c6:	85ba                	mv	a1,a4
 7c8:	855a                	mv	a0,s6
 7ca:	e9bff0ef          	jal	664 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bf49                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7d2:	008b8493          	addi	s1,s7,8
 7d6:	4685                	li	a3,1
 7d8:	4629                	li	a2,10
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	ea3ff0ef          	jal	682 <printint>
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bfad                	j	762 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7ea:	06400793          	li	a5,100
 7ee:	02f68963          	beq	a3,a5,820 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f2:	06c00793          	li	a5,108
 7f6:	04f68263          	beq	a3,a5,83a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 7fa:	07500793          	li	a5,117
 7fe:	0af68063          	beq	a3,a5,89e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 802:	07800793          	li	a5,120
 806:	0ef68263          	beq	a3,a5,8ea <vprintf+0x1d2>
        putc(fd, '%');
 80a:	02500593          	li	a1,37
 80e:	855a                	mv	a0,s6
 810:	e55ff0ef          	jal	664 <putc>
        putc(fd, c0);
 814:	85a6                	mv	a1,s1
 816:	855a                	mv	a0,s6
 818:	e4dff0ef          	jal	664 <putc>
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b791                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 820:	008b8493          	addi	s1,s7,8
 824:	4685                	li	a3,1
 826:	4629                	li	a2,10
 828:	000ba583          	lw	a1,0(s7)
 82c:	855a                	mv	a0,s6
 82e:	e55ff0ef          	jal	682 <printint>
        i += 1;
 832:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 834:	8ba6                	mv	s7,s1
      state = 0;
 836:	4981                	li	s3,0
        i += 1;
 838:	b72d                	j	762 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 83a:	06400793          	li	a5,100
 83e:	02f60763          	beq	a2,a5,86c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 842:	07500793          	li	a5,117
 846:	06f60963          	beq	a2,a5,8b8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 84a:	07800793          	li	a5,120
 84e:	faf61ee3          	bne	a2,a5,80a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 852:	008b8493          	addi	s1,s7,8
 856:	4681                	li	a3,0
 858:	4641                	li	a2,16
 85a:	000ba583          	lw	a1,0(s7)
 85e:	855a                	mv	a0,s6
 860:	e23ff0ef          	jal	682 <printint>
        i += 2;
 864:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 866:	8ba6                	mv	s7,s1
      state = 0;
 868:	4981                	li	s3,0
        i += 2;
 86a:	bde5                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 86c:	008b8493          	addi	s1,s7,8
 870:	4685                	li	a3,1
 872:	4629                	li	a2,10
 874:	000ba583          	lw	a1,0(s7)
 878:	855a                	mv	a0,s6
 87a:	e09ff0ef          	jal	682 <printint>
        i += 2;
 87e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 880:	8ba6                	mv	s7,s1
      state = 0;
 882:	4981                	li	s3,0
        i += 2;
 884:	bdf9                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 886:	008b8493          	addi	s1,s7,8
 88a:	4681                	li	a3,0
 88c:	4629                	li	a2,10
 88e:	000ba583          	lw	a1,0(s7)
 892:	855a                	mv	a0,s6
 894:	defff0ef          	jal	682 <printint>
 898:	8ba6                	mv	s7,s1
      state = 0;
 89a:	4981                	li	s3,0
 89c:	b5d9                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89e:	008b8493          	addi	s1,s7,8
 8a2:	4681                	li	a3,0
 8a4:	4629                	li	a2,10
 8a6:	000ba583          	lw	a1,0(s7)
 8aa:	855a                	mv	a0,s6
 8ac:	dd7ff0ef          	jal	682 <printint>
        i += 1;
 8b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b2:	8ba6                	mv	s7,s1
      state = 0;
 8b4:	4981                	li	s3,0
        i += 1;
 8b6:	b575                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b8:	008b8493          	addi	s1,s7,8
 8bc:	4681                	li	a3,0
 8be:	4629                	li	a2,10
 8c0:	000ba583          	lw	a1,0(s7)
 8c4:	855a                	mv	a0,s6
 8c6:	dbdff0ef          	jal	682 <printint>
        i += 2;
 8ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8cc:	8ba6                	mv	s7,s1
      state = 0;
 8ce:	4981                	li	s3,0
        i += 2;
 8d0:	bd49                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 8d2:	008b8493          	addi	s1,s7,8
 8d6:	4681                	li	a3,0
 8d8:	4641                	li	a2,16
 8da:	000ba583          	lw	a1,0(s7)
 8de:	855a                	mv	a0,s6
 8e0:	da3ff0ef          	jal	682 <printint>
 8e4:	8ba6                	mv	s7,s1
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bdad                	j	762 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ea:	008b8493          	addi	s1,s7,8
 8ee:	4681                	li	a3,0
 8f0:	4641                	li	a2,16
 8f2:	000ba583          	lw	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	d8bff0ef          	jal	682 <printint>
        i += 1;
 8fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8fe:	8ba6                	mv	s7,s1
      state = 0;
 900:	4981                	li	s3,0
        i += 1;
 902:	b585                	j	762 <vprintf+0x4a>
 904:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 906:	008b8d13          	addi	s10,s7,8
 90a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 90e:	03000593          	li	a1,48
 912:	855a                	mv	a0,s6
 914:	d51ff0ef          	jal	664 <putc>
  putc(fd, 'x');
 918:	07800593          	li	a1,120
 91c:	855a                	mv	a0,s6
 91e:	d47ff0ef          	jal	664 <putc>
 922:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 924:	00000b97          	auipc	s7,0x0
 928:	4dcb8b93          	addi	s7,s7,1244 # e00 <digits>
 92c:	03c9d793          	srli	a5,s3,0x3c
 930:	97de                	add	a5,a5,s7
 932:	0007c583          	lbu	a1,0(a5)
 936:	855a                	mv	a0,s6
 938:	d2dff0ef          	jal	664 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 93c:	0992                	slli	s3,s3,0x4
 93e:	34fd                	addiw	s1,s1,-1
 940:	f4f5                	bnez	s1,92c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 942:	8bea                	mv	s7,s10
      state = 0;
 944:	4981                	li	s3,0
 946:	6d02                	ld	s10,0(sp)
 948:	bd29                	j	762 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 94a:	008b8993          	addi	s3,s7,8
 94e:	000bb483          	ld	s1,0(s7)
 952:	cc91                	beqz	s1,96e <vprintf+0x256>
        for(; *s; s++)
 954:	0004c583          	lbu	a1,0(s1)
 958:	c195                	beqz	a1,97c <vprintf+0x264>
          putc(fd, *s);
 95a:	855a                	mv	a0,s6
 95c:	d09ff0ef          	jal	664 <putc>
        for(; *s; s++)
 960:	0485                	addi	s1,s1,1
 962:	0004c583          	lbu	a1,0(s1)
 966:	f9f5                	bnez	a1,95a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 968:	8bce                	mv	s7,s3
      state = 0;
 96a:	4981                	li	s3,0
 96c:	bbdd                	j	762 <vprintf+0x4a>
          s = "(null)";
 96e:	00000497          	auipc	s1,0x0
 972:	48a48493          	addi	s1,s1,1162 # df8 <malloc+0x37a>
        for(; *s; s++)
 976:	02800593          	li	a1,40
 97a:	b7c5                	j	95a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 97c:	8bce                	mv	s7,s3
      state = 0;
 97e:	4981                	li	s3,0
 980:	b3cd                	j	762 <vprintf+0x4a>
 982:	6906                	ld	s2,64(sp)
 984:	79e2                	ld	s3,56(sp)
 986:	7a42                	ld	s4,48(sp)
 988:	7aa2                	ld	s5,40(sp)
 98a:	7b02                	ld	s6,32(sp)
 98c:	6be2                	ld	s7,24(sp)
 98e:	6c42                	ld	s8,16(sp)
 990:	6ca2                	ld	s9,8(sp)
    }
  }
}
 992:	60e6                	ld	ra,88(sp)
 994:	6446                	ld	s0,80(sp)
 996:	64a6                	ld	s1,72(sp)
 998:	6125                	addi	sp,sp,96
 99a:	8082                	ret

000000000000099c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 99c:	715d                	addi	sp,sp,-80
 99e:	ec06                	sd	ra,24(sp)
 9a0:	e822                	sd	s0,16(sp)
 9a2:	1000                	addi	s0,sp,32
 9a4:	e010                	sd	a2,0(s0)
 9a6:	e414                	sd	a3,8(s0)
 9a8:	e818                	sd	a4,16(s0)
 9aa:	ec1c                	sd	a5,24(s0)
 9ac:	03043023          	sd	a6,32(s0)
 9b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	8622                	mv	a2,s0
 9b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ba:	d5fff0ef          	jal	718 <vprintf>
}
 9be:	60e2                	ld	ra,24(sp)
 9c0:	6442                	ld	s0,16(sp)
 9c2:	6161                	addi	sp,sp,80
 9c4:	8082                	ret

00000000000009c6 <printf>:

void
printf(const char *fmt, ...)
{
 9c6:	711d                	addi	sp,sp,-96
 9c8:	ec06                	sd	ra,24(sp)
 9ca:	e822                	sd	s0,16(sp)
 9cc:	1000                	addi	s0,sp,32
 9ce:	e40c                	sd	a1,8(s0)
 9d0:	e810                	sd	a2,16(s0)
 9d2:	ec14                	sd	a3,24(s0)
 9d4:	f018                	sd	a4,32(s0)
 9d6:	f41c                	sd	a5,40(s0)
 9d8:	03043823          	sd	a6,48(s0)
 9dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9e0:	00840613          	addi	a2,s0,8
 9e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e8:	85aa                	mv	a1,a0
 9ea:	4505                	li	a0,1
 9ec:	d2dff0ef          	jal	718 <vprintf>
}
 9f0:	60e2                	ld	ra,24(sp)
 9f2:	6442                	ld	s0,16(sp)
 9f4:	6125                	addi	sp,sp,96
 9f6:	8082                	ret

00000000000009f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f8:	1141                	addi	sp,sp,-16
 9fa:	e406                	sd	ra,8(sp)
 9fc:	e022                	sd	s0,0(sp)
 9fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a00:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a04:	00001797          	auipc	a5,0x1
 a08:	6047b783          	ld	a5,1540(a5) # 2008 <freep>
 a0c:	a02d                	j	a36 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a0e:	4618                	lw	a4,8(a2)
 a10:	9f2d                	addw	a4,a4,a1
 a12:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a16:	6398                	ld	a4,0(a5)
 a18:	6310                	ld	a2,0(a4)
 a1a:	a83d                	j	a58 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a1c:	ff852703          	lw	a4,-8(a0)
 a20:	9f31                	addw	a4,a4,a2
 a22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a24:	ff053683          	ld	a3,-16(a0)
 a28:	a091                	j	a6c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	6398                	ld	a4,0(a5)
 a2c:	00e7e463          	bltu	a5,a4,a34 <free+0x3c>
 a30:	00e6ea63          	bltu	a3,a4,a44 <free+0x4c>
{
 a34:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a36:	fed7fae3          	bgeu	a5,a3,a2a <free+0x32>
 a3a:	6398                	ld	a4,0(a5)
 a3c:	00e6e463          	bltu	a3,a4,a44 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	fee7eae3          	bltu	a5,a4,a34 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a44:	ff852583          	lw	a1,-8(a0)
 a48:	6390                	ld	a2,0(a5)
 a4a:	02059813          	slli	a6,a1,0x20
 a4e:	01c85713          	srli	a4,a6,0x1c
 a52:	9736                	add	a4,a4,a3
 a54:	fae60de3          	beq	a2,a4,a0e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a58:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a5c:	4790                	lw	a2,8(a5)
 a5e:	02061593          	slli	a1,a2,0x20
 a62:	01c5d713          	srli	a4,a1,0x1c
 a66:	973e                	add	a4,a4,a5
 a68:	fae68ae3          	beq	a3,a4,a1c <free+0x24>
    p->s.ptr = bp->s.ptr;
 a6c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a6e:	00001717          	auipc	a4,0x1
 a72:	58f73d23          	sd	a5,1434(a4) # 2008 <freep>
}
 a76:	60a2                	ld	ra,8(sp)
 a78:	6402                	ld	s0,0(sp)
 a7a:	0141                	addi	sp,sp,16
 a7c:	8082                	ret

0000000000000a7e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a7e:	7139                	addi	sp,sp,-64
 a80:	fc06                	sd	ra,56(sp)
 a82:	f822                	sd	s0,48(sp)
 a84:	f04a                	sd	s2,32(sp)
 a86:	ec4e                	sd	s3,24(sp)
 a88:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a8a:	02051993          	slli	s3,a0,0x20
 a8e:	0209d993          	srli	s3,s3,0x20
 a92:	09bd                	addi	s3,s3,15
 a94:	0049d993          	srli	s3,s3,0x4
 a98:	2985                	addiw	s3,s3,1
 a9a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a9c:	00001517          	auipc	a0,0x1
 aa0:	56c53503          	ld	a0,1388(a0) # 2008 <freep>
 aa4:	c905                	beqz	a0,ad4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa8:	4798                	lw	a4,8(a5)
 aaa:	09377663          	bgeu	a4,s3,b36 <malloc+0xb8>
 aae:	f426                	sd	s1,40(sp)
 ab0:	e852                	sd	s4,16(sp)
 ab2:	e456                	sd	s5,8(sp)
 ab4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ab6:	8a4e                	mv	s4,s3
 ab8:	6705                	lui	a4,0x1
 aba:	00e9f363          	bgeu	s3,a4,ac0 <malloc+0x42>
 abe:	6a05                	lui	s4,0x1
 ac0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac8:	00001497          	auipc	s1,0x1
 acc:	54048493          	addi	s1,s1,1344 # 2008 <freep>
  if(p == (char*)-1)
 ad0:	5afd                	li	s5,-1
 ad2:	a83d                	j	b10 <malloc+0x92>
 ad4:	f426                	sd	s1,40(sp)
 ad6:	e852                	sd	s4,16(sp)
 ad8:	e456                	sd	s5,8(sp)
 ada:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 adc:	00001797          	auipc	a5,0x1
 ae0:	53478793          	addi	a5,a5,1332 # 2010 <base>
 ae4:	00001717          	auipc	a4,0x1
 ae8:	52f73223          	sd	a5,1316(a4) # 2008 <freep>
 aec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 af2:	b7d1                	j	ab6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 af4:	6398                	ld	a4,0(a5)
 af6:	e118                	sd	a4,0(a0)
 af8:	a899                	j	b4e <malloc+0xd0>
  hp->s.size = nu;
 afa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 afe:	0541                	addi	a0,a0,16
 b00:	ef9ff0ef          	jal	9f8 <free>
  return freep;
 b04:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b06:	c125                	beqz	a0,b66 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b0a:	4798                	lw	a4,8(a5)
 b0c:	03277163          	bgeu	a4,s2,b2e <malloc+0xb0>
    if(p == freep)
 b10:	6098                	ld	a4,0(s1)
 b12:	853e                	mv	a0,a5
 b14:	fef71ae3          	bne	a4,a5,b08 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b18:	8552                	mv	a0,s4
 b1a:	ae3ff0ef          	jal	5fc <sbrk>
  if(p == (char*)-1)
 b1e:	fd551ee3          	bne	a0,s5,afa <malloc+0x7c>
        return 0;
 b22:	4501                	li	a0,0
 b24:	74a2                	ld	s1,40(sp)
 b26:	6a42                	ld	s4,16(sp)
 b28:	6aa2                	ld	s5,8(sp)
 b2a:	6b02                	ld	s6,0(sp)
 b2c:	a03d                	j	b5a <malloc+0xdc>
 b2e:	74a2                	ld	s1,40(sp)
 b30:	6a42                	ld	s4,16(sp)
 b32:	6aa2                	ld	s5,8(sp)
 b34:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b36:	fae90fe3          	beq	s2,a4,af4 <malloc+0x76>
        p->s.size -= nunits;
 b3a:	4137073b          	subw	a4,a4,s3
 b3e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b40:	02071693          	slli	a3,a4,0x20
 b44:	01c6d713          	srli	a4,a3,0x1c
 b48:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b4a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b4e:	00001717          	auipc	a4,0x1
 b52:	4aa73d23          	sd	a0,1210(a4) # 2008 <freep>
      return (void*)(p + 1);
 b56:	01078513          	addi	a0,a5,16
  }
}
 b5a:	70e2                	ld	ra,56(sp)
 b5c:	7442                	ld	s0,48(sp)
 b5e:	7902                	ld	s2,32(sp)
 b60:	69e2                	ld	s3,24(sp)
 b62:	6121                	addi	sp,sp,64
 b64:	8082                	ret
 b66:	74a2                	ld	s1,40(sp)
 b68:	6a42                	ld	s4,16(sp)
 b6a:	6aa2                	ld	s5,8(sp)
 b6c:	6b02                	ld	s6,0(sp)
 b6e:	b7f5                	j	b5a <malloc+0xdc>
