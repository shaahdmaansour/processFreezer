
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
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
  sleep(1);
  10:	4505                	li	a0,1
  12:	5e0000ef          	jal	5f2 <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	8626                	mv	a2,s1
  18:	85ca                	mv	a1,s2
  1a:	00001517          	auipc	a0,0x1
  1e:	b8650513          	addi	a0,a0,-1146 # ba0 <malloc+0xfe>
  22:	1c9000ef          	jal	9ea <printf>
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
  40:	5b2000ef          	jal	5f2 <sleep>
  printf("\nCurrent Processes:\n");
  44:	00001517          	auipc	a0,0x1
  48:	b6c50513          	addi	a0,a0,-1172 # bb0 <malloc+0x10e>
  4c:	19f000ef          	jal	9ea <printf>
  sleep(1);
  50:	4505                	li	a0,1
  52:	5a0000ef          	jal	5f2 <sleep>
  printf("PID\tState\t\tCPU Usage\n");
  56:	00001517          	auipc	a0,0x1
  5a:	b7250513          	addi	a0,a0,-1166 # bc8 <malloc+0x126>
  5e:	18d000ef          	jal	9ea <printf>
  sleep(1);
  62:	4505                	li	a0,1
  64:	58e000ef          	jal	5f2 <sleep>
  printf("--------------------------------\n");
  68:	00001517          	auipc	a0,0x1
  6c:	b7850513          	addi	a0,a0,-1160 # be0 <malloc+0x13e>
  70:	17b000ef          	jal	9ea <printf>
  sleep(1);
  74:	4505                	li	a0,1
  76:	57c000ef          	jal	5f2 <sleep>
  
  // Show parent process
  printf("%d\tRUNNING\t\tLow\n", getpid());
  7a:	568000ef          	jal	5e2 <getpid>
  7e:	85aa                	mv	a1,a0
  80:	00001517          	auipc	a0,0x1
  84:	b8850513          	addi	a0,a0,-1144 # c08 <malloc+0x166>
  88:	163000ef          	jal	9ea <printf>
  sleep(1);
  8c:	4505                	li	a0,1
  8e:	564000ef          	jal	5f2 <sleep>
  
  // Show child process
  if(frozen) {
  92:	00002797          	auipc	a5,0x2
  96:	f727a783          	lw	a5,-142(a5) # 2004 <frozen>
  9a:	cbb9                	beqz	a5,f0 <show_all_processes+0xbe>
    printf("%d\tFROZEN\t\tHigh\n", pid);
  9c:	85a6                	mv	a1,s1
  9e:	00001517          	auipc	a0,0x1
  a2:	b8250513          	addi	a0,a0,-1150 # c20 <malloc+0x17e>
  a6:	145000ef          	jal	9ea <printf>
  } else {
    printf("%d\tRUNNING\t\tHigh\n", pid);
  }
  sleep(1);
  aa:	4505                	li	a0,1
  ac:	546000ef          	jal	5f2 <sleep>
  
  // Show init and shell
  printf("1\tRUNNING\t\tLow\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	ba050513          	addi	a0,a0,-1120 # c50 <malloc+0x1ae>
  b8:	133000ef          	jal	9ea <printf>
  sleep(1);
  bc:	4505                	li	a0,1
  be:	534000ef          	jal	5f2 <sleep>
  printf("2\tRUNNING\t\tLow\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	b9e50513          	addi	a0,a0,-1122 # c60 <malloc+0x1be>
  ca:	121000ef          	jal	9ea <printf>
  sleep(1);
  ce:	4505                	li	a0,1
  d0:	522000ef          	jal	5f2 <sleep>
  
  printf("--------------------------------\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	b0c50513          	addi	a0,a0,-1268 # be0 <malloc+0x13e>
  dc:	10f000ef          	jal	9ea <printf>
  sleep(1);
  e0:	4505                	li	a0,1
  e2:	510000ef          	jal	5f2 <sleep>
}
  e6:	60e2                	ld	ra,24(sp)
  e8:	6442                	ld	s0,16(sp)
  ea:	64a2                	ld	s1,8(sp)
  ec:	6105                	addi	sp,sp,32
  ee:	8082                	ret
    printf("%d\tRUNNING\t\tHigh\n", pid);
  f0:	85a6                	mv	a1,s1
  f2:	00001517          	auipc	a0,0x1
  f6:	b4650513          	addi	a0,a0,-1210 # c38 <malloc+0x196>
  fa:	0f1000ef          	jal	9ea <printf>
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
 138:	4ba000ef          	jal	5f2 <sleep>
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
 198:	3fa000ef          	jal	592 <fork>
  
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
 1aa:	438000ef          	jal	5e2 <getpid>
 1ae:	84aa                	mv	s1,a0
    sleep(2);
 1b0:	4509                	li	a0,2
 1b2:	440000ef          	jal	5f2 <sleep>
    printf("Child process started (PID: %d)\n", mypid);
 1b6:	85a6                	mv	a1,s1
 1b8:	00001517          	auipc	a0,0x1
 1bc:	ac850513          	addi	a0,a0,-1336 # c80 <malloc+0x1de>
 1c0:	02b000ef          	jal	9ea <printf>
    printf("Child process is CPU intensive\n");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	ae450513          	addi	a0,a0,-1308 # ca8 <malloc+0x206>
 1cc:	01f000ef          	jal	9ea <printf>
    
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
 1e2:	aea98993          	addi	s3,s3,-1302 # cc8 <malloc+0x226>
      sleep(100);
 1e6:	06400913          	li	s2,100
      print_status(mypid, "running normally");
 1ea:	85ce                	mv	a1,s3
 1ec:	8526                	mv	a0,s1
 1ee:	e13ff0ef          	jal	0 <print_status>
      sleep(100);
 1f2:	854a                	mv	a0,s2
 1f4:	3fe000ef          	jal	5f2 <sleep>
    while(1){
 1f8:	bfcd                	j	1ea <main+0x5a>
 1fa:	ec26                	sd	s1,24(sp)
 1fc:	e84a                	sd	s2,16(sp)
 1fe:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 200:	00001517          	auipc	a0,0x1
 204:	a7050513          	addi	a0,a0,-1424 # c70 <malloc+0x1ce>
 208:	7e2000ef          	jal	9ea <printf>
    exit(1);
 20c:	4505                	li	a0,1
 20e:	38c000ef          	jal	59a <exit>
 212:	e84a                	sd	s2,16(sp)
 214:	e44e                	sd	s3,8(sp)
    }
  } else {
    // Parent process
    int mypid = getpid();
 216:	3cc000ef          	jal	5e2 <getpid>
 21a:	85aa                	mv	a1,a0
    printf("Parent process (PID: %d) created child (PID: %d)\n", mypid, child_pid);
 21c:	8626                	mv	a2,s1
 21e:	00001517          	auipc	a0,0x1
 222:	ac250513          	addi	a0,a0,-1342 # ce0 <malloc+0x23e>
 226:	7c4000ef          	jal	9ea <printf>
    
    // Show initial state
    show_all_processes(child_pid);
 22a:	8526                	mv	a0,s1
 22c:	e07ff0ef          	jal	32 <show_all_processes>
    
    // Wait for child to start CPU intensive work
    sleep(300);
 230:	12c00513          	li	a0,300
 234:	3be000ef          	jal	5f2 <sleep>
    
    // Freeze CPU intensive child
    printf("\nAttempting to freeze CPU intensive child process %d...\n", child_pid);
 238:	85a6                	mv	a1,s1
 23a:	00001517          	auipc	a0,0x1
 23e:	ade50513          	addi	a0,a0,-1314 # d18 <malloc+0x276>
 242:	7a8000ef          	jal	9ea <printf>
    if(freeze(child_pid) < 0){
 246:	8526                	mv	a0,s1
 248:	3f2000ef          	jal	63a <freeze>
 24c:	0a054163          	bltz	a0,2ee <main+0x15e>
      printf("Error: Failed to freeze process %d\n", child_pid);
    } else {
      frozen = 1;
 250:	4785                	li	a5,1
 252:	00002717          	auipc	a4,0x2
 256:	daf72923          	sw	a5,-590(a4) # 2004 <frozen>
      print_status(child_pid, "Frozen");
 25a:	00001597          	auipc	a1,0x1
 25e:	b2658593          	addi	a1,a1,-1242 # d80 <malloc+0x2de>
 262:	8526                	mv	a0,s1
 264:	d9dff0ef          	jal	0 <print_status>
    }
    
    show_all_processes(child_pid);
 268:	8526                	mv	a0,s1
 26a:	dc9ff0ef          	jal	32 <show_all_processes>
    sleep(300);
 26e:	12c00513          	li	a0,300
 272:	380000ef          	jal	5f2 <sleep>
    
    // Unfreeze child
    printf("\nAttempting to unfreeze child process %d...\n", child_pid);
 276:	85a6                	mv	a1,s1
 278:	00001517          	auipc	a0,0x1
 27c:	b1050513          	addi	a0,a0,-1264 # d88 <malloc+0x2e6>
 280:	76a000ef          	jal	9ea <printf>
    if(unfreeze(child_pid) < 0){
 284:	8526                	mv	a0,s1
 286:	3bc000ef          	jal	642 <unfreeze>
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
 2a2:	b4258593          	addi	a1,a1,-1214 # de0 <malloc+0x33e>
 2a6:	8526                	mv	a0,s1
 2a8:	d59ff0ef          	jal	0 <print_status>
    }
    
    show_all_processes(child_pid);
 2ac:	8526                	mv	a0,s1
 2ae:	d85ff0ef          	jal	32 <show_all_processes>
    sleep(300);
 2b2:	12c00513          	li	a0,300
 2b6:	33c000ef          	jal	5f2 <sleep>
    
    // Terminate child
    printf("\nTerminating child process %d...\n", child_pid);
 2ba:	85a6                	mv	a1,s1
 2bc:	00001517          	auipc	a0,0x1
 2c0:	b3450513          	addi	a0,a0,-1228 # df0 <malloc+0x34e>
 2c4:	726000ef          	jal	9ea <printf>
    kill(child_pid);
 2c8:	8526                	mv	a0,s1
 2ca:	2f0000ef          	jal	5ba <kill>
    wait(0);
 2ce:	4501                	li	a0,0
 2d0:	2d2000ef          	jal	5a2 <wait>
    print_status(child_pid, "Terminated");
 2d4:	00001597          	auipc	a1,0x1
 2d8:	b4458593          	addi	a1,a1,-1212 # e18 <malloc+0x376>
 2dc:	8526                	mv	a0,s1
 2de:	d23ff0ef          	jal	0 <print_status>
    
    show_all_processes(child_pid);
 2e2:	8526                	mv	a0,s1
 2e4:	d4fff0ef          	jal	32 <show_all_processes>
  }
  
  exit(0);
 2e8:	4501                	li	a0,0
 2ea:	2b0000ef          	jal	59a <exit>
      printf("Error: Failed to freeze process %d\n", child_pid);
 2ee:	85a6                	mv	a1,s1
 2f0:	00001517          	auipc	a0,0x1
 2f4:	a6850513          	addi	a0,a0,-1432 # d58 <malloc+0x2b6>
 2f8:	6f2000ef          	jal	9ea <printf>
 2fc:	b7b5                	j	268 <main+0xd8>
      printf("Error: Failed to unfreeze process %d\n", child_pid);
 2fe:	85a6                	mv	a1,s1
 300:	00001517          	auipc	a0,0x1
 304:	ab850513          	addi	a0,a0,-1352 # db8 <malloc+0x316>
 308:	6e2000ef          	jal	9ea <printf>
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
 31c:	27e000ef          	jal	59a <exit>

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
 37c:	cf91                	beqz	a5,398 <strlen+0x28>
 37e:	00150793          	addi	a5,a0,1
 382:	86be                	mv	a3,a5
 384:	0785                	addi	a5,a5,1
 386:	fff7c703          	lbu	a4,-1(a5)
 38a:	ff65                	bnez	a4,382 <strlen+0x12>
 38c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  for(n = 0; s[n]; n++)
 398:	4501                	li	a0,0
 39a:	bfdd                	j	390 <strlen+0x20>

000000000000039c <memset>:

void*
memset(void *dst, int c, uint n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3a4:	ca19                	beqz	a2,3ba <memset+0x1e>
 3a6:	87aa                	mv	a5,a0
 3a8:	1602                	slli	a2,a2,0x20
 3aa:	9201                	srli	a2,a2,0x20
 3ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b4:	0785                	addi	a5,a5,1
 3b6:	fee79de3          	bne	a5,a4,3b0 <memset+0x14>
  }
  return dst;
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <strchr>:

char*
strchr(const char *s, char c)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e406                	sd	ra,8(sp)
 3c6:	e022                	sd	s0,0(sp)
 3c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	cf81                	beqz	a5,3e6 <strchr+0x24>
    if(*s == c)
 3d0:	00f58763          	beq	a1,a5,3de <strchr+0x1c>
  for(; *s; s++)
 3d4:	0505                	addi	a0,a0,1
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	fbfd                	bnez	a5,3d0 <strchr+0xe>
      return (char*)s;
  return 0;
 3dc:	4501                	li	a0,0
}
 3de:	60a2                	ld	ra,8(sp)
 3e0:	6402                	ld	s0,0(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
  return 0;
 3e6:	4501                	li	a0,0
 3e8:	bfdd                	j	3de <strchr+0x1c>

00000000000003ea <gets>:

char*
gets(char *buf, int max)
{
 3ea:	711d                	addi	sp,sp,-96
 3ec:	ec86                	sd	ra,88(sp)
 3ee:	e8a2                	sd	s0,80(sp)
 3f0:	e4a6                	sd	s1,72(sp)
 3f2:	e0ca                	sd	s2,64(sp)
 3f4:	fc4e                	sd	s3,56(sp)
 3f6:	f852                	sd	s4,48(sp)
 3f8:	f456                	sd	s5,40(sp)
 3fa:	f05a                	sd	s6,32(sp)
 3fc:	ec5e                	sd	s7,24(sp)
 3fe:	e862                	sd	s8,16(sp)
 400:	1080                	addi	s0,sp,96
 402:	8baa                	mv	s7,a0
 404:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 406:	892a                	mv	s2,a0
 408:	4481                	li	s1,0
    cc = read(0, &c, 1);
 40a:	faf40b13          	addi	s6,s0,-81
 40e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 410:	8c26                	mv	s8,s1
 412:	0014899b          	addiw	s3,s1,1
 416:	84ce                	mv	s1,s3
 418:	0349d463          	bge	s3,s4,440 <gets+0x56>
    cc = read(0, &c, 1);
 41c:	8656                	mv	a2,s5
 41e:	85da                	mv	a1,s6
 420:	4501                	li	a0,0
 422:	190000ef          	jal	5b2 <read>
    if(cc < 1)
 426:	00a05d63          	blez	a0,440 <gets+0x56>
      break;
    buf[i++] = c;
 42a:	faf44783          	lbu	a5,-81(s0)
 42e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 432:	0905                	addi	s2,s2,1
 434:	ff678713          	addi	a4,a5,-10
 438:	c319                	beqz	a4,43e <gets+0x54>
 43a:	17cd                	addi	a5,a5,-13
 43c:	fbf1                	bnez	a5,410 <gets+0x26>
    buf[i++] = c;
 43e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 440:	9c5e                	add	s8,s8,s7
 442:	000c0023          	sb	zero,0(s8)
  return buf;
}
 446:	855e                	mv	a0,s7
 448:	60e6                	ld	ra,88(sp)
 44a:	6446                	ld	s0,80(sp)
 44c:	64a6                	ld	s1,72(sp)
 44e:	6906                	ld	s2,64(sp)
 450:	79e2                	ld	s3,56(sp)
 452:	7a42                	ld	s4,48(sp)
 454:	7aa2                	ld	s5,40(sp)
 456:	7b02                	ld	s6,32(sp)
 458:	6be2                	ld	s7,24(sp)
 45a:	6c42                	ld	s8,16(sp)
 45c:	6125                	addi	sp,sp,96
 45e:	8082                	ret

0000000000000460 <stat>:

int
stat(const char *n, struct stat *st)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	e04a                	sd	s2,0(sp)
 468:	1000                	addi	s0,sp,32
 46a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 46c:	4581                	li	a1,0
 46e:	194000ef          	jal	602 <open>
  if(fd < 0)
 472:	02054263          	bltz	a0,496 <stat+0x36>
 476:	e426                	sd	s1,8(sp)
 478:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 47a:	85ca                	mv	a1,s2
 47c:	14e000ef          	jal	5ca <fstat>
 480:	892a                	mv	s2,a0
  close(fd);
 482:	8526                	mv	a0,s1
 484:	1ae000ef          	jal	632 <close>
  return r;
 488:	64a2                	ld	s1,8(sp)
}
 48a:	854a                	mv	a0,s2
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6902                	ld	s2,0(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret
    return -1;
 496:	57fd                	li	a5,-1
 498:	893e                	mv	s2,a5
 49a:	bfc5                	j	48a <stat+0x2a>

000000000000049c <atoi>:

int
atoi(const char *s)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a4:	00054683          	lbu	a3,0(a0)
 4a8:	fd06879b          	addiw	a5,a3,-48
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	4625                	li	a2,9
 4b2:	02f66963          	bltu	a2,a5,4e4 <atoi+0x48>
 4b6:	872a                	mv	a4,a0
  n = 0;
 4b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ba:	0705                	addi	a4,a4,1
 4bc:	0025179b          	slliw	a5,a0,0x2
 4c0:	9fa9                	addw	a5,a5,a0
 4c2:	0017979b          	slliw	a5,a5,0x1
 4c6:	9fb5                	addw	a5,a5,a3
 4c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4cc:	00074683          	lbu	a3,0(a4)
 4d0:	fd06879b          	addiw	a5,a3,-48
 4d4:	0ff7f793          	zext.b	a5,a5
 4d8:	fef671e3          	bgeu	a2,a5,4ba <atoi+0x1e>
  return n;
}
 4dc:	60a2                	ld	ra,8(sp)
 4de:	6402                	ld	s0,0(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret
  n = 0;
 4e4:	4501                	li	a0,0
 4e6:	bfdd                	j	4dc <atoi+0x40>

00000000000004e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e406                	sd	ra,8(sp)
 4ec:	e022                	sd	s0,0(sp)
 4ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4f0:	02b57563          	bgeu	a0,a1,51a <memmove+0x32>
    while(n-- > 0)
 4f4:	00c05f63          	blez	a2,512 <memmove+0x2a>
 4f8:	1602                	slli	a2,a2,0x20
 4fa:	9201                	srli	a2,a2,0x20
 4fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 500:	872a                	mv	a4,a0
      *dst++ = *src++;
 502:	0585                	addi	a1,a1,1
 504:	0705                	addi	a4,a4,1
 506:	fff5c683          	lbu	a3,-1(a1)
 50a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 50e:	fee79ae3          	bne	a5,a4,502 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 512:	60a2                	ld	ra,8(sp)
 514:	6402                	ld	s0,0(sp)
 516:	0141                	addi	sp,sp,16
 518:	8082                	ret
    while(n-- > 0)
 51a:	fec05ce3          	blez	a2,512 <memmove+0x2a>
    dst += n;
 51e:	00c50733          	add	a4,a0,a2
    src += n;
 522:	95b2                	add	a1,a1,a2
 524:	fff6079b          	addiw	a5,a2,-1
 528:	1782                	slli	a5,a5,0x20
 52a:	9381                	srli	a5,a5,0x20
 52c:	fff7c793          	not	a5,a5
 530:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 532:	15fd                	addi	a1,a1,-1
 534:	177d                	addi	a4,a4,-1
 536:	0005c683          	lbu	a3,0(a1)
 53a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 53e:	fef71ae3          	bne	a4,a5,532 <memmove+0x4a>
 542:	bfc1                	j	512 <memmove+0x2a>

0000000000000544 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 544:	1141                	addi	sp,sp,-16
 546:	e406                	sd	ra,8(sp)
 548:	e022                	sd	s0,0(sp)
 54a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 54c:	c61d                	beqz	a2,57a <memcmp+0x36>
 54e:	1602                	slli	a2,a2,0x20
 550:	9201                	srli	a2,a2,0x20
 552:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 556:	00054783          	lbu	a5,0(a0)
 55a:	0005c703          	lbu	a4,0(a1)
 55e:	00e79863          	bne	a5,a4,56e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 562:	0505                	addi	a0,a0,1
    p2++;
 564:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 566:	fed518e3          	bne	a0,a3,556 <memcmp+0x12>
  }
  return 0;
 56a:	4501                	li	a0,0
 56c:	a019                	j	572 <memcmp+0x2e>
      return *p1 - *p2;
 56e:	40e7853b          	subw	a0,a5,a4
}
 572:	60a2                	ld	ra,8(sp)
 574:	6402                	ld	s0,0(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret
  return 0;
 57a:	4501                	li	a0,0
 57c:	bfdd                	j	572 <memcmp+0x2e>

000000000000057e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 57e:	1141                	addi	sp,sp,-16
 580:	e406                	sd	ra,8(sp)
 582:	e022                	sd	s0,0(sp)
 584:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 586:	f63ff0ef          	jal	4e8 <memmove>
}
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 592:	4885                	li	a7,1
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exit>:
.global exit
exit:
 li a7, SYS_exit
 59a:	4889                	li	a7,2
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a2:	488d                	li	a7,3
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5aa:	4891                	li	a7,4
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <read>:
.global read
read:
 li a7, SYS_read
 5b2:	4895                	li	a7,5
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ba:	4899                	li	a7,6
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c2:	489d                	li	a7,7
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ca:	48a1                	li	a7,8
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d2:	48a5                	li	a7,9
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <dup>:
.global dup
dup:
 li a7, SYS_dup
 5da:	48a9                	li	a7,10
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e2:	48ad                	li	a7,11
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ea:	48b1                	li	a7,12
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f2:	48b5                	li	a7,13
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fa:	48b9                	li	a7,14
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <open>:
.global open
open:
 li a7, SYS_open
 602:	48bd                	li	a7,15
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <write>:
.global write
write:
 li a7, SYS_write
 60a:	48c1                	li	a7,16
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 612:	48c5                	li	a7,17
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61a:	48c9                	li	a7,18
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <link>:
.global link
link:
 li a7, SYS_link
 622:	48cd                	li	a7,19
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 62a:	48d1                	li	a7,20
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <close>:
.global close
close:
 li a7, SYS_close
 632:	48d5                	li	a7,21
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 63a:	48d9                	li	a7,22
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 642:	48dd                	li	a7,23
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 64a:	48e1                	li	a7,24
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 652:	48e5                	li	a7,25
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65a:	1101                	addi	sp,sp,-32
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	addi	s0,sp,32
 662:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 666:	4605                	li	a2,1
 668:	fef40593          	addi	a1,s0,-17
 66c:	f9fff0ef          	jal	60a <write>
}
 670:	60e2                	ld	ra,24(sp)
 672:	6442                	ld	s0,16(sp)
 674:	6105                	addi	sp,sp,32
 676:	8082                	ret

0000000000000678 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 678:	7139                	addi	sp,sp,-64
 67a:	fc06                	sd	ra,56(sp)
 67c:	f822                	sd	s0,48(sp)
 67e:	f04a                	sd	s2,32(sp)
 680:	ec4e                	sd	s3,24(sp)
 682:	0080                	addi	s0,sp,64
 684:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 686:	cac9                	beqz	a3,718 <printint+0xa0>
 688:	01f5d79b          	srliw	a5,a1,0x1f
 68c:	c7d1                	beqz	a5,718 <printint+0xa0>
    neg = 1;
    x = -xx;
 68e:	40b005bb          	negw	a1,a1
    neg = 1;
 692:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 694:	fc040993          	addi	s3,s0,-64
  neg = 0;
 698:	86ce                	mv	a3,s3
  i = 0;
 69a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 69c:	00000817          	auipc	a6,0x0
 6a0:	79480813          	addi	a6,a6,1940 # e30 <digits>
 6a4:	88ba                	mv	a7,a4
 6a6:	0017051b          	addiw	a0,a4,1
 6aa:	872a                	mv	a4,a0
 6ac:	02c5f7bb          	remuw	a5,a1,a2
 6b0:	1782                	slli	a5,a5,0x20
 6b2:	9381                	srli	a5,a5,0x20
 6b4:	97c2                	add	a5,a5,a6
 6b6:	0007c783          	lbu	a5,0(a5)
 6ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6be:	87ae                	mv	a5,a1
 6c0:	02c5d5bb          	divuw	a1,a1,a2
 6c4:	0685                	addi	a3,a3,1
 6c6:	fcc7ffe3          	bgeu	a5,a2,6a4 <printint+0x2c>
  if(neg)
 6ca:	00030c63          	beqz	t1,6e2 <printint+0x6a>
    buf[i++] = '-';
 6ce:	fd050793          	addi	a5,a0,-48
 6d2:	00878533          	add	a0,a5,s0
 6d6:	02d00793          	li	a5,45
 6da:	fef50823          	sb	a5,-16(a0)
 6de:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 6e2:	02e05563          	blez	a4,70c <printint+0x94>
 6e6:	f426                	sd	s1,40(sp)
 6e8:	377d                	addiw	a4,a4,-1
 6ea:	00e984b3          	add	s1,s3,a4
 6ee:	19fd                	addi	s3,s3,-1
 6f0:	99ba                	add	s3,s3,a4
 6f2:	1702                	slli	a4,a4,0x20
 6f4:	9301                	srli	a4,a4,0x20
 6f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6fa:	0004c583          	lbu	a1,0(s1)
 6fe:	854a                	mv	a0,s2
 700:	f5bff0ef          	jal	65a <putc>
  while(--i >= 0)
 704:	14fd                	addi	s1,s1,-1
 706:	ff349ae3          	bne	s1,s3,6fa <printint+0x82>
 70a:	74a2                	ld	s1,40(sp)
}
 70c:	70e2                	ld	ra,56(sp)
 70e:	7442                	ld	s0,48(sp)
 710:	7902                	ld	s2,32(sp)
 712:	69e2                	ld	s3,24(sp)
 714:	6121                	addi	sp,sp,64
 716:	8082                	ret
  neg = 0;
 718:	4301                	li	t1,0
 71a:	bfad                	j	694 <printint+0x1c>

000000000000071c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71c:	711d                	addi	sp,sp,-96
 71e:	ec86                	sd	ra,88(sp)
 720:	e8a2                	sd	s0,80(sp)
 722:	e4a6                	sd	s1,72(sp)
 724:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 726:	0005c483          	lbu	s1,0(a1)
 72a:	20048963          	beqz	s1,93c <vprintf+0x220>
 72e:	e0ca                	sd	s2,64(sp)
 730:	fc4e                	sd	s3,56(sp)
 732:	f852                	sd	s4,48(sp)
 734:	f456                	sd	s5,40(sp)
 736:	f05a                	sd	s6,32(sp)
 738:	ec5e                	sd	s7,24(sp)
 73a:	e862                	sd	s8,16(sp)
 73c:	8b2a                	mv	s6,a0
 73e:	8a2e                	mv	s4,a1
 740:	8bb2                	mv	s7,a2
  state = 0;
 742:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 744:	4901                	li	s2,0
 746:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 748:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 74c:	06400c13          	li	s8,100
 750:	a00d                	j	772 <vprintf+0x56>
        putc(fd, c0);
 752:	85a6                	mv	a1,s1
 754:	855a                	mv	a0,s6
 756:	f05ff0ef          	jal	65a <putc>
 75a:	a019                	j	760 <vprintf+0x44>
    } else if(state == '%'){
 75c:	03598363          	beq	s3,s5,782 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 760:	0019079b          	addiw	a5,s2,1
 764:	893e                	mv	s2,a5
 766:	873e                	mv	a4,a5
 768:	97d2                	add	a5,a5,s4
 76a:	0007c483          	lbu	s1,0(a5)
 76e:	1c048063          	beqz	s1,92e <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 772:	0004879b          	sext.w	a5,s1
    if(state == 0){
 776:	fe0993e3          	bnez	s3,75c <vprintf+0x40>
      if(c0 == '%'){
 77a:	fd579ce3          	bne	a5,s5,752 <vprintf+0x36>
        state = '%';
 77e:	89be                	mv	s3,a5
 780:	b7c5                	j	760 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 782:	00ea06b3          	add	a3,s4,a4
 786:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 78a:	1a060e63          	beqz	a2,946 <vprintf+0x22a>
      if(c0 == 'd'){
 78e:	03878763          	beq	a5,s8,7bc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 792:	f9478693          	addi	a3,a5,-108
 796:	0016b693          	seqz	a3,a3
 79a:	f9c60593          	addi	a1,a2,-100
 79e:	e99d                	bnez	a1,7d4 <vprintf+0xb8>
 7a0:	ca95                	beqz	a3,7d4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a2:	008b8493          	addi	s1,s7,8
 7a6:	4685                	li	a3,1
 7a8:	4629                	li	a2,10
 7aa:	000ba583          	lw	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	ec9ff0ef          	jal	678 <printint>
        i += 1;
 7b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b75d                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 7bc:	008b8493          	addi	s1,s7,8
 7c0:	4685                	li	a3,1
 7c2:	4629                	li	a2,10
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	eafff0ef          	jal	678 <printint>
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b779                	j	760 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 7d4:	9752                	add	a4,a4,s4
 7d6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7da:	f9460713          	addi	a4,a2,-108
 7de:	00173713          	seqz	a4,a4
 7e2:	8f75                	and	a4,a4,a3
 7e4:	f9c58513          	addi	a0,a1,-100
 7e8:	16051963          	bnez	a0,95a <vprintf+0x23e>
 7ec:	16070763          	beqz	a4,95a <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f0:	008b8493          	addi	s1,s7,8
 7f4:	4685                	li	a3,1
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	e7bff0ef          	jal	678 <printint>
        i += 2;
 802:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 804:	8ba6                	mv	s7,s1
      state = 0;
 806:	4981                	li	s3,0
        i += 2;
 808:	bfa1                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 80a:	008b8493          	addi	s1,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	e61ff0ef          	jal	678 <printint>
 81c:	8ba6                	mv	s7,s1
      state = 0;
 81e:	4981                	li	s3,0
 820:	b781                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 822:	008b8493          	addi	s1,s7,8
 826:	4681                	li	a3,0
 828:	4629                	li	a2,10
 82a:	000ba583          	lw	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	e49ff0ef          	jal	678 <printint>
        i += 1;
 834:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	8ba6                	mv	s7,s1
      state = 0;
 838:	4981                	li	s3,0
 83a:	b71d                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83c:	008b8493          	addi	s1,s7,8
 840:	4681                	li	a3,0
 842:	4629                	li	a2,10
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	e2fff0ef          	jal	678 <printint>
        i += 2;
 84e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	8ba6                	mv	s7,s1
      state = 0;
 852:	4981                	li	s3,0
        i += 2;
 854:	b731                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 856:	008b8493          	addi	s1,s7,8
 85a:	4681                	li	a3,0
 85c:	4641                	li	a2,16
 85e:	000ba583          	lw	a1,0(s7)
 862:	855a                	mv	a0,s6
 864:	e15ff0ef          	jal	678 <printint>
 868:	8ba6                	mv	s7,s1
      state = 0;
 86a:	4981                	li	s3,0
 86c:	bdd5                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 86e:	008b8493          	addi	s1,s7,8
 872:	4681                	li	a3,0
 874:	4641                	li	a2,16
 876:	000ba583          	lw	a1,0(s7)
 87a:	855a                	mv	a0,s6
 87c:	dfdff0ef          	jal	678 <printint>
        i += 1;
 880:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 882:	8ba6                	mv	s7,s1
      state = 0;
 884:	4981                	li	s3,0
 886:	bde9                	j	760 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 888:	008b8493          	addi	s1,s7,8
 88c:	4681                	li	a3,0
 88e:	4641                	li	a2,16
 890:	000ba583          	lw	a1,0(s7)
 894:	855a                	mv	a0,s6
 896:	de3ff0ef          	jal	678 <printint>
        i += 2;
 89a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 89c:	8ba6                	mv	s7,s1
      state = 0;
 89e:	4981                	li	s3,0
        i += 2;
 8a0:	b5c1                	j	760 <vprintf+0x44>
 8a2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 8a4:	008b8793          	addi	a5,s7,8
 8a8:	8cbe                	mv	s9,a5
 8aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ae:	03000593          	li	a1,48
 8b2:	855a                	mv	a0,s6
 8b4:	da7ff0ef          	jal	65a <putc>
  putc(fd, 'x');
 8b8:	07800593          	li	a1,120
 8bc:	855a                	mv	a0,s6
 8be:	d9dff0ef          	jal	65a <putc>
 8c2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c4:	00000b97          	auipc	s7,0x0
 8c8:	56cb8b93          	addi	s7,s7,1388 # e30 <digits>
 8cc:	03c9d793          	srli	a5,s3,0x3c
 8d0:	97de                	add	a5,a5,s7
 8d2:	0007c583          	lbu	a1,0(a5)
 8d6:	855a                	mv	a0,s6
 8d8:	d83ff0ef          	jal	65a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8dc:	0992                	slli	s3,s3,0x4
 8de:	34fd                	addiw	s1,s1,-1
 8e0:	f4f5                	bnez	s1,8cc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 8e2:	8be6                	mv	s7,s9
      state = 0;
 8e4:	4981                	li	s3,0
 8e6:	6ca2                	ld	s9,8(sp)
 8e8:	bda5                	j	760 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8ea:	008b8993          	addi	s3,s7,8
 8ee:	000bb483          	ld	s1,0(s7)
 8f2:	cc91                	beqz	s1,90e <vprintf+0x1f2>
        for(; *s; s++)
 8f4:	0004c583          	lbu	a1,0(s1)
 8f8:	c985                	beqz	a1,928 <vprintf+0x20c>
          putc(fd, *s);
 8fa:	855a                	mv	a0,s6
 8fc:	d5fff0ef          	jal	65a <putc>
        for(; *s; s++)
 900:	0485                	addi	s1,s1,1
 902:	0004c583          	lbu	a1,0(s1)
 906:	f9f5                	bnez	a1,8fa <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 908:	8bce                	mv	s7,s3
      state = 0;
 90a:	4981                	li	s3,0
 90c:	bd91                	j	760 <vprintf+0x44>
          s = "(null)";
 90e:	00000497          	auipc	s1,0x0
 912:	51a48493          	addi	s1,s1,1306 # e28 <malloc+0x386>
        for(; *s; s++)
 916:	02800593          	li	a1,40
 91a:	b7c5                	j	8fa <vprintf+0x1de>
        putc(fd, '%');
 91c:	85be                	mv	a1,a5
 91e:	855a                	mv	a0,s6
 920:	d3bff0ef          	jal	65a <putc>
      state = 0;
 924:	4981                	li	s3,0
 926:	bd2d                	j	760 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 928:	8bce                	mv	s7,s3
      state = 0;
 92a:	4981                	li	s3,0
 92c:	bd15                	j	760 <vprintf+0x44>
 92e:	6906                	ld	s2,64(sp)
 930:	79e2                	ld	s3,56(sp)
 932:	7a42                	ld	s4,48(sp)
 934:	7aa2                	ld	s5,40(sp)
 936:	7b02                	ld	s6,32(sp)
 938:	6be2                	ld	s7,24(sp)
 93a:	6c42                	ld	s8,16(sp)
    }
  }
}
 93c:	60e6                	ld	ra,88(sp)
 93e:	6446                	ld	s0,80(sp)
 940:	64a6                	ld	s1,72(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret
      if(c0 == 'd'){
 946:	06400713          	li	a4,100
 94a:	e6e789e3          	beq	a5,a4,7bc <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 94e:	f9478693          	addi	a3,a5,-108
 952:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 956:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 958:	4701                	li	a4,0
      } else if(c0 == 'u'){
 95a:	07500513          	li	a0,117
 95e:	eaa786e3          	beq	a5,a0,80a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 962:	f8b60513          	addi	a0,a2,-117
 966:	e119                	bnez	a0,96c <vprintf+0x250>
 968:	ea069de3          	bnez	a3,822 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 96c:	f8b58513          	addi	a0,a1,-117
 970:	e119                	bnez	a0,976 <vprintf+0x25a>
 972:	ec0715e3          	bnez	a4,83c <vprintf+0x120>
      } else if(c0 == 'x'){
 976:	07800513          	li	a0,120
 97a:	eca78ee3          	beq	a5,a0,856 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 97e:	f8860613          	addi	a2,a2,-120
 982:	e219                	bnez	a2,988 <vprintf+0x26c>
 984:	ee0695e3          	bnez	a3,86e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 988:	f8858593          	addi	a1,a1,-120
 98c:	e199                	bnez	a1,992 <vprintf+0x276>
 98e:	ee071de3          	bnez	a4,888 <vprintf+0x16c>
      } else if(c0 == 'p'){
 992:	07000713          	li	a4,112
 996:	f0e786e3          	beq	a5,a4,8a2 <vprintf+0x186>
      } else if(c0 == 's'){
 99a:	07300713          	li	a4,115
 99e:	f4e786e3          	beq	a5,a4,8ea <vprintf+0x1ce>
      } else if(c0 == '%'){
 9a2:	02500713          	li	a4,37
 9a6:	f6e78be3          	beq	a5,a4,91c <vprintf+0x200>
        putc(fd, '%');
 9aa:	02500593          	li	a1,37
 9ae:	855a                	mv	a0,s6
 9b0:	cabff0ef          	jal	65a <putc>
        putc(fd, c0);
 9b4:	85a6                	mv	a1,s1
 9b6:	855a                	mv	a0,s6
 9b8:	ca3ff0ef          	jal	65a <putc>
      state = 0;
 9bc:	4981                	li	s3,0
 9be:	b34d                	j	760 <vprintf+0x44>

00000000000009c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c0:	715d                	addi	sp,sp,-80
 9c2:	ec06                	sd	ra,24(sp)
 9c4:	e822                	sd	s0,16(sp)
 9c6:	1000                	addi	s0,sp,32
 9c8:	e010                	sd	a2,0(s0)
 9ca:	e414                	sd	a3,8(s0)
 9cc:	e818                	sd	a4,16(s0)
 9ce:	ec1c                	sd	a5,24(s0)
 9d0:	03043023          	sd	a6,32(s0)
 9d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d8:	8622                	mv	a2,s0
 9da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9de:	d3fff0ef          	jal	71c <vprintf>
}
 9e2:	60e2                	ld	ra,24(sp)
 9e4:	6442                	ld	s0,16(sp)
 9e6:	6161                	addi	sp,sp,80
 9e8:	8082                	ret

00000000000009ea <printf>:

void
printf(const char *fmt, ...)
{
 9ea:	711d                	addi	sp,sp,-96
 9ec:	ec06                	sd	ra,24(sp)
 9ee:	e822                	sd	s0,16(sp)
 9f0:	1000                	addi	s0,sp,32
 9f2:	e40c                	sd	a1,8(s0)
 9f4:	e810                	sd	a2,16(s0)
 9f6:	ec14                	sd	a3,24(s0)
 9f8:	f018                	sd	a4,32(s0)
 9fa:	f41c                	sd	a5,40(s0)
 9fc:	03043823          	sd	a6,48(s0)
 a00:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a04:	00840613          	addi	a2,s0,8
 a08:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a0c:	85aa                	mv	a1,a0
 a0e:	4505                	li	a0,1
 a10:	d0dff0ef          	jal	71c <vprintf>
}
 a14:	60e2                	ld	ra,24(sp)
 a16:	6442                	ld	s0,16(sp)
 a18:	6125                	addi	sp,sp,96
 a1a:	8082                	ret

0000000000000a1c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a1c:	1141                	addi	sp,sp,-16
 a1e:	e406                	sd	ra,8(sp)
 a20:	e022                	sd	s0,0(sp)
 a22:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a24:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a28:	00001797          	auipc	a5,0x1
 a2c:	5e07b783          	ld	a5,1504(a5) # 2008 <freep>
 a30:	a039                	j	a3e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a32:	6398                	ld	a4,0(a5)
 a34:	00e7e463          	bltu	a5,a4,a3c <free+0x20>
 a38:	00e6ea63          	bltu	a3,a4,a4c <free+0x30>
{
 a3c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a3e:	fed7fae3          	bgeu	a5,a3,a32 <free+0x16>
 a42:	6398                	ld	a4,0(a5)
 a44:	00e6e463          	bltu	a3,a4,a4c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a48:	fee7eae3          	bltu	a5,a4,a3c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a4c:	ff852583          	lw	a1,-8(a0)
 a50:	6390                	ld	a2,0(a5)
 a52:	02059813          	slli	a6,a1,0x20
 a56:	01c85713          	srli	a4,a6,0x1c
 a5a:	9736                	add	a4,a4,a3
 a5c:	02e60563          	beq	a2,a4,a86 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a60:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a64:	4790                	lw	a2,8(a5)
 a66:	02061593          	slli	a1,a2,0x20
 a6a:	01c5d713          	srli	a4,a1,0x1c
 a6e:	973e                	add	a4,a4,a5
 a70:	02e68263          	beq	a3,a4,a94 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a74:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a76:	00001717          	auipc	a4,0x1
 a7a:	58f73923          	sd	a5,1426(a4) # 2008 <freep>
}
 a7e:	60a2                	ld	ra,8(sp)
 a80:	6402                	ld	s0,0(sp)
 a82:	0141                	addi	sp,sp,16
 a84:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a86:	4618                	lw	a4,8(a2)
 a88:	9f2d                	addw	a4,a4,a1
 a8a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a8e:	6398                	ld	a4,0(a5)
 a90:	6310                	ld	a2,0(a4)
 a92:	b7f9                	j	a60 <free+0x44>
    p->s.size += bp->s.size;
 a94:	ff852703          	lw	a4,-8(a0)
 a98:	9f31                	addw	a4,a4,a2
 a9a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a9c:	ff053683          	ld	a3,-16(a0)
 aa0:	bfd1                	j	a74 <free+0x58>

0000000000000aa2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa2:	7139                	addi	sp,sp,-64
 aa4:	fc06                	sd	ra,56(sp)
 aa6:	f822                	sd	s0,48(sp)
 aa8:	f04a                	sd	s2,32(sp)
 aaa:	ec4e                	sd	s3,24(sp)
 aac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aae:	02051993          	slli	s3,a0,0x20
 ab2:	0209d993          	srli	s3,s3,0x20
 ab6:	09bd                	addi	s3,s3,15
 ab8:	0049d993          	srli	s3,s3,0x4
 abc:	2985                	addiw	s3,s3,1
 abe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ac0:	00001517          	auipc	a0,0x1
 ac4:	54853503          	ld	a0,1352(a0) # 2008 <freep>
 ac8:	c905                	beqz	a0,af8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 acc:	4798                	lw	a4,8(a5)
 ace:	09377663          	bgeu	a4,s3,b5a <malloc+0xb8>
 ad2:	f426                	sd	s1,40(sp)
 ad4:	e852                	sd	s4,16(sp)
 ad6:	e456                	sd	s5,8(sp)
 ad8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ada:	8a4e                	mv	s4,s3
 adc:	6705                	lui	a4,0x1
 ade:	00e9f363          	bgeu	s3,a4,ae4 <malloc+0x42>
 ae2:	6a05                	lui	s4,0x1
 ae4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ae8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aec:	00001497          	auipc	s1,0x1
 af0:	51c48493          	addi	s1,s1,1308 # 2008 <freep>
  if(p == (char*)-1)
 af4:	5afd                	li	s5,-1
 af6:	a83d                	j	b34 <malloc+0x92>
 af8:	f426                	sd	s1,40(sp)
 afa:	e852                	sd	s4,16(sp)
 afc:	e456                	sd	s5,8(sp)
 afe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b00:	00001797          	auipc	a5,0x1
 b04:	51078793          	addi	a5,a5,1296 # 2010 <base>
 b08:	00001717          	auipc	a4,0x1
 b0c:	50f73023          	sd	a5,1280(a4) # 2008 <freep>
 b10:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b12:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b16:	b7d1                	j	ada <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b18:	6398                	ld	a4,0(a5)
 b1a:	e118                	sd	a4,0(a0)
 b1c:	a899                	j	b72 <malloc+0xd0>
  hp->s.size = nu;
 b1e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b22:	0541                	addi	a0,a0,16
 b24:	ef9ff0ef          	jal	a1c <free>
  return freep;
 b28:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b2a:	c125                	beqz	a0,b8a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2e:	4798                	lw	a4,8(a5)
 b30:	03277163          	bgeu	a4,s2,b52 <malloc+0xb0>
    if(p == freep)
 b34:	6098                	ld	a4,0(s1)
 b36:	853e                	mv	a0,a5
 b38:	fef71ae3          	bne	a4,a5,b2c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b3c:	8552                	mv	a0,s4
 b3e:	aadff0ef          	jal	5ea <sbrk>
  if(p == (char*)-1)
 b42:	fd551ee3          	bne	a0,s5,b1e <malloc+0x7c>
        return 0;
 b46:	4501                	li	a0,0
 b48:	74a2                	ld	s1,40(sp)
 b4a:	6a42                	ld	s4,16(sp)
 b4c:	6aa2                	ld	s5,8(sp)
 b4e:	6b02                	ld	s6,0(sp)
 b50:	a03d                	j	b7e <malloc+0xdc>
 b52:	74a2                	ld	s1,40(sp)
 b54:	6a42                	ld	s4,16(sp)
 b56:	6aa2                	ld	s5,8(sp)
 b58:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b5a:	fae90fe3          	beq	s2,a4,b18 <malloc+0x76>
        p->s.size -= nunits;
 b5e:	4137073b          	subw	a4,a4,s3
 b62:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b64:	02071693          	slli	a3,a4,0x20
 b68:	01c6d713          	srli	a4,a3,0x1c
 b6c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b6e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b72:	00001717          	auipc	a4,0x1
 b76:	48a73b23          	sd	a0,1174(a4) # 2008 <freep>
      return (void*)(p + 1);
 b7a:	01078513          	addi	a0,a5,16
  }
}
 b7e:	70e2                	ld	ra,56(sp)
 b80:	7442                	ld	s0,48(sp)
 b82:	7902                	ld	s2,32(sp)
 b84:	69e2                	ld	s3,24(sp)
 b86:	6121                	addi	sp,sp,64
 b88:	8082                	ret
 b8a:	74a2                	ld	s1,40(sp)
 b8c:	6a42                	ld	s4,16(sp)
 b8e:	6aa2                	ld	s5,8(sp)
 b90:	6b02                	ld	s6,0(sp)
 b92:	b7f5                	j	b7e <malloc+0xdc>
