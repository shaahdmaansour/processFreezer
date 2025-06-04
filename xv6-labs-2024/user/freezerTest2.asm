
user/_freezerTest2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_status>:
int frozen1 = 0;
int frozen2 = 0;

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
  12:	698000ef          	jal	6aa <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	864a                	mv	a2,s2
  18:	85a6                	mv	a1,s1
  1a:	00001517          	auipc	a0,0x1
  1e:	c0650513          	addi	a0,a0,-1018 # c20 <malloc+0xfc>
  22:	24b000ef          	jal	a6c <printf>
}
  26:	60e2                	ld	ra,24(sp)
  28:	6442                	ld	s0,16(sp)
  2a:	64a2                	ld	s1,8(sp)
  2c:	6902                	ld	s2,0(sp)
  2e:	6105                	addi	sp,sp,32
  30:	8082                	ret

0000000000000032 <show_all_processes>:

void
show_all_processes(int pid1, int pid2)
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
  3c:	1000                	addi	s0,sp,32
  3e:	892a                	mv	s2,a0
  40:	84ae                	mv	s1,a1
  sleep(2);
  42:	4509                	li	a0,2
  44:	666000ef          	jal	6aa <sleep>
  printf("\nCurrent Processes:\n");
  48:	00001517          	auipc	a0,0x1
  4c:	be850513          	addi	a0,a0,-1048 # c30 <malloc+0x10c>
  50:	21d000ef          	jal	a6c <printf>
  sleep(1);
  54:	4505                	li	a0,1
  56:	654000ef          	jal	6aa <sleep>
  printf("PID\tState\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	bf650513          	addi	a0,a0,-1034 # c50 <malloc+0x12c>
  62:	20b000ef          	jal	a6c <printf>
  sleep(1);
  66:	4505                	li	a0,1
  68:	642000ef          	jal	6aa <sleep>
  printf("----------------\n");
  6c:	00001517          	auipc	a0,0x1
  70:	bf450513          	addi	a0,a0,-1036 # c60 <malloc+0x13c>
  74:	1f9000ef          	jal	a6c <printf>
  sleep(1);
  78:	4505                	li	a0,1
  7a:	630000ef          	jal	6aa <sleep>
  
  // Show parent process
  printf("%d\tRUNNING\n", getpid());
  7e:	61c000ef          	jal	69a <getpid>
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	bf450513          	addi	a0,a0,-1036 # c78 <malloc+0x154>
  8c:	1e1000ef          	jal	a6c <printf>
  sleep(1);
  90:	4505                	li	a0,1
  92:	618000ef          	jal	6aa <sleep>
  
  // Show first child process
  if(frozen1) {
  96:	00002797          	auipc	a5,0x2
  9a:	f6e7a783          	lw	a5,-146(a5) # 2004 <frozen1>
  9e:	cbbd                	beqz	a5,114 <show_all_processes+0xe2>
    printf("%d\tFROZEN\n", pid1);
  a0:	85ca                	mv	a1,s2
  a2:	00001517          	auipc	a0,0x1
  a6:	be650513          	addi	a0,a0,-1050 # c88 <malloc+0x164>
  aa:	1c3000ef          	jal	a6c <printf>
  } else {
    printf("%d\tRUNNING\n", pid1);
  }
  sleep(1);
  ae:	4505                	li	a0,1
  b0:	5fa000ef          	jal	6aa <sleep>
  
  // Show second child process
  if(frozen2) {
  b4:	00002797          	auipc	a5,0x2
  b8:	f4c7a783          	lw	a5,-180(a5) # 2000 <frozen2>
  bc:	c7a5                	beqz	a5,124 <show_all_processes+0xf2>
    printf("%d\tFROZEN\n", pid2);
  be:	85a6                	mv	a1,s1
  c0:	00001517          	auipc	a0,0x1
  c4:	bc850513          	addi	a0,a0,-1080 # c88 <malloc+0x164>
  c8:	1a5000ef          	jal	a6c <printf>
  } else {
    printf("%d\tRUNNING\n", pid2);
  }
  sleep(1);
  cc:	4505                	li	a0,1
  ce:	5dc000ef          	jal	6aa <sleep>
  
  // Show init and shell
  printf("1\tRUNNING\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	bc650513          	addi	a0,a0,-1082 # c98 <malloc+0x174>
  da:	193000ef          	jal	a6c <printf>
  sleep(1);
  de:	4505                	li	a0,1
  e0:	5ca000ef          	jal	6aa <sleep>
  printf("2\tRUNNING\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	bc450513          	addi	a0,a0,-1084 # ca8 <malloc+0x184>
  ec:	181000ef          	jal	a6c <printf>
  sleep(1);
  f0:	4505                	li	a0,1
  f2:	5b8000ef          	jal	6aa <sleep>
  
  printf("----------------\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	b6a50513          	addi	a0,a0,-1174 # c60 <malloc+0x13c>
  fe:	16f000ef          	jal	a6c <printf>
  sleep(1);
 102:	4505                	li	a0,1
 104:	5a6000ef          	jal	6aa <sleep>
}
 108:	60e2                	ld	ra,24(sp)
 10a:	6442                	ld	s0,16(sp)
 10c:	64a2                	ld	s1,8(sp)
 10e:	6902                	ld	s2,0(sp)
 110:	6105                	addi	sp,sp,32
 112:	8082                	ret
    printf("%d\tRUNNING\n", pid1);
 114:	85ca                	mv	a1,s2
 116:	00001517          	auipc	a0,0x1
 11a:	b6250513          	addi	a0,a0,-1182 # c78 <malloc+0x154>
 11e:	14f000ef          	jal	a6c <printf>
 122:	b771                	j	ae <show_all_processes+0x7c>
    printf("%d\tRUNNING\n", pid2);
 124:	85a6                	mv	a1,s1
 126:	00001517          	auipc	a0,0x1
 12a:	b5250513          	addi	a0,a0,-1198 # c78 <malloc+0x154>
 12e:	13f000ef          	jal	a6c <printf>
 132:	bf69                	j	cc <show_all_processes+0x9a>

0000000000000134 <main>:

int
main(int argc, char *argv[])
{
 134:	7179                	addi	sp,sp,-48
 136:	f406                	sd	ra,40(sp)
 138:	f022                	sd	s0,32(sp)
 13a:	1800                	addi	s0,sp,48
  int child1_pid = fork();
 13c:	50e000ef          	jal	64a <fork>
  
  if(child1_pid < 0){
 140:	04054263          	bltz	a0,184 <main+0x50>
 144:	ec26                	sd	s1,24(sp)
 146:	84aa                	mv	s1,a0
    printf("fork failed\n");
    exit(1);
  }
  
  if(child1_pid == 0){
 148:	e931                	bnez	a0,19c <main+0x68>
 14a:	e84a                	sd	s2,16(sp)
 14c:	e44e                	sd	s3,8(sp)
    // First child process
    int mypid = getpid();
 14e:	54c000ef          	jal	69a <getpid>
 152:	84aa                	mv	s1,a0
    sleep(2);
 154:	4509                	li	a0,2
 156:	554000ef          	jal	6aa <sleep>
    printf("Child process 1 started (PID: %d)\n", mypid);
 15a:	85a6                	mv	a1,s1
 15c:	00001517          	auipc	a0,0x1
 160:	b6c50513          	addi	a0,a0,-1172 # cc8 <malloc+0x1a4>
 164:	109000ef          	jal	a6c <printf>
    
    while(1){
      print_status(mypid, "running");
 168:	00001997          	auipc	s3,0x1
 16c:	b8898993          	addi	s3,s3,-1144 # cf0 <malloc+0x1cc>
      sleep(100);
 170:	06400913          	li	s2,100
      print_status(mypid, "running");
 174:	85ce                	mv	a1,s3
 176:	8526                	mv	a0,s1
 178:	e89ff0ef          	jal	0 <print_status>
      sleep(100);
 17c:	854a                	mv	a0,s2
 17e:	52c000ef          	jal	6aa <sleep>
    while(1){
 182:	bfcd                	j	174 <main+0x40>
 184:	ec26                	sd	s1,24(sp)
 186:	e84a                	sd	s2,16(sp)
 188:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	b2e50513          	addi	a0,a0,-1234 # cb8 <malloc+0x194>
 192:	0db000ef          	jal	a6c <printf>
    exit(1);
 196:	4505                	li	a0,1
 198:	4ba000ef          	jal	652 <exit>
 19c:	e84a                	sd	s2,16(sp)
    }
  } else {
    // Parent process
    int child2_pid = fork();
 19e:	4ac000ef          	jal	64a <fork>
 1a2:	892a                	mv	s2,a0
    
    if(child2_pid < 0){
 1a4:	02054f63          	bltz	a0,1e2 <main+0xae>
      kill(child1_pid);
      wait(0);
      exit(1);
    }
    
    if(child2_pid == 0){
 1a8:	ed29                	bnez	a0,202 <main+0xce>
 1aa:	e44e                	sd	s3,8(sp)
      // Second child process
      int mypid = getpid();
 1ac:	4ee000ef          	jal	69a <getpid>
 1b0:	84aa                	mv	s1,a0
      sleep(2);
 1b2:	4509                	li	a0,2
 1b4:	4f6000ef          	jal	6aa <sleep>
      printf("Child process 2 started (PID: %d)\n", mypid);
 1b8:	85a6                	mv	a1,s1
 1ba:	00001517          	auipc	a0,0x1
 1be:	b3e50513          	addi	a0,a0,-1218 # cf8 <malloc+0x1d4>
 1c2:	0ab000ef          	jal	a6c <printf>
      
      while(1){
        print_status(mypid, "running");
 1c6:	00001997          	auipc	s3,0x1
 1ca:	b2a98993          	addi	s3,s3,-1238 # cf0 <malloc+0x1cc>
        sleep(100);
 1ce:	06400913          	li	s2,100
        print_status(mypid, "running");
 1d2:	85ce                	mv	a1,s3
 1d4:	8526                	mv	a0,s1
 1d6:	e2bff0ef          	jal	0 <print_status>
        sleep(100);
 1da:	854a                	mv	a0,s2
 1dc:	4ce000ef          	jal	6aa <sleep>
      while(1){
 1e0:	bfcd                	j	1d2 <main+0x9e>
 1e2:	e44e                	sd	s3,8(sp)
      printf("fork failed\n");
 1e4:	00001517          	auipc	a0,0x1
 1e8:	ad450513          	addi	a0,a0,-1324 # cb8 <malloc+0x194>
 1ec:	081000ef          	jal	a6c <printf>
      kill(child1_pid);
 1f0:	8526                	mv	a0,s1
 1f2:	480000ef          	jal	672 <kill>
      wait(0);
 1f6:	4501                	li	a0,0
 1f8:	462000ef          	jal	65a <wait>
      exit(1);
 1fc:	4505                	li	a0,1
 1fe:	454000ef          	jal	652 <exit>
 202:	e44e                	sd	s3,8(sp)
      }
    } else {
      // Parent process
      int mypid = getpid();
 204:	496000ef          	jal	69a <getpid>
 208:	85aa                	mv	a1,a0
      printf("Parent process (PID: %d) created children (PIDs: %d, %d)\n", 
 20a:	86ca                	mv	a3,s2
 20c:	8626                	mv	a2,s1
 20e:	00001517          	auipc	a0,0x1
 212:	b1250513          	addi	a0,a0,-1262 # d20 <malloc+0x1fc>
 216:	057000ef          	jal	a6c <printf>
             mypid, child1_pid, child2_pid);
      
      // Show initial state
      show_all_processes(child1_pid, child2_pid);
 21a:	85ca                	mv	a1,s2
 21c:	8526                	mv	a0,s1
 21e:	e15ff0ef          	jal	32 <show_all_processes>
      
      // Wait for children to start
      sleep(300);
 222:	12c00513          	li	a0,300
 226:	484000ef          	jal	6aa <sleep>
      
      // Freeze first child
      printf("\nAttempting to freeze child process %d...\n", child1_pid);
 22a:	85a6                	mv	a1,s1
 22c:	00001517          	auipc	a0,0x1
 230:	b3450513          	addi	a0,a0,-1228 # d60 <malloc+0x23c>
 234:	039000ef          	jal	a6c <printf>
      if(freeze(child1_pid) < 0){
 238:	8526                	mv	a0,s1
 23a:	4b8000ef          	jal	6f2 <freeze>
 23e:	12054b63          	bltz	a0,374 <main+0x240>
        printf("Error: Failed to freeze process %d\n", child1_pid);
      } else {
        frozen1 = 1;
 242:	4785                	li	a5,1
 244:	00002717          	auipc	a4,0x2
 248:	dcf72023          	sw	a5,-576(a4) # 2004 <frozen1>
        print_status(child1_pid, "Frozen");
 24c:	00001597          	auipc	a1,0x1
 250:	b6c58593          	addi	a1,a1,-1172 # db8 <malloc+0x294>
 254:	8526                	mv	a0,s1
 256:	dabff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 25a:	85ca                	mv	a1,s2
 25c:	8526                	mv	a0,s1
 25e:	dd5ff0ef          	jal	32 <show_all_processes>
      sleep(200);
 262:	0c800513          	li	a0,200
 266:	444000ef          	jal	6aa <sleep>
      
      // Freeze second child
      printf("\nAttempting to freeze child process %d...\n", child2_pid);
 26a:	85ca                	mv	a1,s2
 26c:	00001517          	auipc	a0,0x1
 270:	af450513          	addi	a0,a0,-1292 # d60 <malloc+0x23c>
 274:	7f8000ef          	jal	a6c <printf>
      if(freeze(child2_pid) < 0){
 278:	854a                	mv	a0,s2
 27a:	478000ef          	jal	6f2 <freeze>
 27e:	10054363          	bltz	a0,384 <main+0x250>
        printf("Error: Failed to freeze process %d\n", child2_pid);
      } else {
        frozen2 = 1;
 282:	4785                	li	a5,1
 284:	00002717          	auipc	a4,0x2
 288:	d6f72e23          	sw	a5,-644(a4) # 2000 <frozen2>
        print_status(child2_pid, "Frozen");
 28c:	00001597          	auipc	a1,0x1
 290:	b2c58593          	addi	a1,a1,-1236 # db8 <malloc+0x294>
 294:	854a                	mv	a0,s2
 296:	d6bff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 29a:	85ca                	mv	a1,s2
 29c:	8526                	mv	a0,s1
 29e:	d95ff0ef          	jal	32 <show_all_processes>
      sleep(300);
 2a2:	12c00513          	li	a0,300
 2a6:	404000ef          	jal	6aa <sleep>
      
      // Unfreeze first child
      printf("\nAttempting to unfreeze child process %d...\n", child1_pid);
 2aa:	85a6                	mv	a1,s1
 2ac:	00001517          	auipc	a0,0x1
 2b0:	b1450513          	addi	a0,a0,-1260 # dc0 <malloc+0x29c>
 2b4:	7b8000ef          	jal	a6c <printf>
      if(unfreeze(child1_pid) < 0){
 2b8:	8526                	mv	a0,s1
 2ba:	440000ef          	jal	6fa <unfreeze>
 2be:	0c054b63          	bltz	a0,394 <main+0x260>
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
      } else {
        frozen1 = 0;
 2c2:	00002797          	auipc	a5,0x2
 2c6:	d407a123          	sw	zero,-702(a5) # 2004 <frozen1>
        print_status(child1_pid, "Unfrozen");
 2ca:	00001597          	auipc	a1,0x1
 2ce:	b4e58593          	addi	a1,a1,-1202 # e18 <malloc+0x2f4>
 2d2:	8526                	mv	a0,s1
 2d4:	d2dff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 2d8:	85ca                	mv	a1,s2
 2da:	8526                	mv	a0,s1
 2dc:	d57ff0ef          	jal	32 <show_all_processes>
      sleep(200);
 2e0:	0c800513          	li	a0,200
 2e4:	3c6000ef          	jal	6aa <sleep>
      
      // Unfreeze second child
      printf("\nAttempting to unfreeze child process %d...\n", child2_pid);
 2e8:	85ca                	mv	a1,s2
 2ea:	00001517          	auipc	a0,0x1
 2ee:	ad650513          	addi	a0,a0,-1322 # dc0 <malloc+0x29c>
 2f2:	77a000ef          	jal	a6c <printf>
      if(unfreeze(child2_pid) < 0){
 2f6:	854a                	mv	a0,s2
 2f8:	402000ef          	jal	6fa <unfreeze>
 2fc:	0a054463          	bltz	a0,3a4 <main+0x270>
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
      } else {
        frozen2 = 0;
 300:	00002797          	auipc	a5,0x2
 304:	d007a023          	sw	zero,-768(a5) # 2000 <frozen2>
        print_status(child2_pid, "Unfrozen");
 308:	00001597          	auipc	a1,0x1
 30c:	b1058593          	addi	a1,a1,-1264 # e18 <malloc+0x2f4>
 310:	854a                	mv	a0,s2
 312:	cefff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 316:	85ca                	mv	a1,s2
 318:	8526                	mv	a0,s1
 31a:	d19ff0ef          	jal	32 <show_all_processes>
      sleep(300);
 31e:	12c00513          	li	a0,300
 322:	388000ef          	jal	6aa <sleep>
      
      // Terminate children
      printf("\nTerminating child processes...\n");
 326:	00001517          	auipc	a0,0x1
 32a:	b0250513          	addi	a0,a0,-1278 # e28 <malloc+0x304>
 32e:	73e000ef          	jal	a6c <printf>
      kill(child1_pid);
 332:	8526                	mv	a0,s1
 334:	33e000ef          	jal	672 <kill>
      kill(child2_pid);
 338:	854a                	mv	a0,s2
 33a:	338000ef          	jal	672 <kill>
      wait(0);
 33e:	4501                	li	a0,0
 340:	31a000ef          	jal	65a <wait>
      wait(0);
 344:	4501                	li	a0,0
 346:	314000ef          	jal	65a <wait>
      print_status(child1_pid, "Terminated");
 34a:	00001597          	auipc	a1,0x1
 34e:	b0658593          	addi	a1,a1,-1274 # e50 <malloc+0x32c>
 352:	8526                	mv	a0,s1
 354:	cadff0ef          	jal	0 <print_status>
      print_status(child2_pid, "Terminated");
 358:	00001597          	auipc	a1,0x1
 35c:	af858593          	addi	a1,a1,-1288 # e50 <malloc+0x32c>
 360:	854a                	mv	a0,s2
 362:	c9fff0ef          	jal	0 <print_status>
      
      show_all_processes(child1_pid, child2_pid);
 366:	85ca                	mv	a1,s2
 368:	8526                	mv	a0,s1
 36a:	cc9ff0ef          	jal	32 <show_all_processes>
    }
  }
  
  exit(0);
 36e:	4501                	li	a0,0
 370:	2e2000ef          	jal	652 <exit>
        printf("Error: Failed to freeze process %d\n", child1_pid);
 374:	85a6                	mv	a1,s1
 376:	00001517          	auipc	a0,0x1
 37a:	a1a50513          	addi	a0,a0,-1510 # d90 <malloc+0x26c>
 37e:	6ee000ef          	jal	a6c <printf>
 382:	bde1                	j	25a <main+0x126>
        printf("Error: Failed to freeze process %d\n", child2_pid);
 384:	85ca                	mv	a1,s2
 386:	00001517          	auipc	a0,0x1
 38a:	a0a50513          	addi	a0,a0,-1526 # d90 <malloc+0x26c>
 38e:	6de000ef          	jal	a6c <printf>
 392:	b721                	j	29a <main+0x166>
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
 394:	85a6                	mv	a1,s1
 396:	00001517          	auipc	a0,0x1
 39a:	a5a50513          	addi	a0,a0,-1446 # df0 <malloc+0x2cc>
 39e:	6ce000ef          	jal	a6c <printf>
 3a2:	bf1d                	j	2d8 <main+0x1a4>
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
 3a4:	85ca                	mv	a1,s2
 3a6:	00001517          	auipc	a0,0x1
 3aa:	a4a50513          	addi	a0,a0,-1462 # df0 <malloc+0x2cc>
 3ae:	6be000ef          	jal	a6c <printf>
 3b2:	b795                	j	316 <main+0x1e2>

00000000000003b4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e406                	sd	ra,8(sp)
 3b8:	e022                	sd	s0,0(sp)
 3ba:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3bc:	d79ff0ef          	jal	134 <main>
  exit(0);
 3c0:	4501                	li	a0,0
 3c2:	290000ef          	jal	652 <exit>

00000000000003c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ce:	87aa                	mv	a5,a0
 3d0:	0585                	addi	a1,a1,1
 3d2:	0785                	addi	a5,a5,1
 3d4:	fff5c703          	lbu	a4,-1(a1)
 3d8:	fee78fa3          	sb	a4,-1(a5)
 3dc:	fb75                	bnez	a4,3d0 <strcpy+0xa>
    ;
  return os;
}
 3de:	60a2                	ld	ra,8(sp)
 3e0:	6402                	ld	s0,0(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret

00000000000003e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e406                	sd	ra,8(sp)
 3ea:	e022                	sd	s0,0(sp)
 3ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	cb91                	beqz	a5,406 <strcmp+0x20>
 3f4:	0005c703          	lbu	a4,0(a1)
 3f8:	00f71763          	bne	a4,a5,406 <strcmp+0x20>
    p++, q++;
 3fc:	0505                	addi	a0,a0,1
 3fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 400:	00054783          	lbu	a5,0(a0)
 404:	fbe5                	bnez	a5,3f4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 406:	0005c503          	lbu	a0,0(a1)
}
 40a:	40a7853b          	subw	a0,a5,a0
 40e:	60a2                	ld	ra,8(sp)
 410:	6402                	ld	s0,0(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret

0000000000000416 <strlen>:

uint
strlen(const char *s)
{
 416:	1141                	addi	sp,sp,-16
 418:	e406                	sd	ra,8(sp)
 41a:	e022                	sd	s0,0(sp)
 41c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 41e:	00054783          	lbu	a5,0(a0)
 422:	cf99                	beqz	a5,440 <strlen+0x2a>
 424:	0505                	addi	a0,a0,1
 426:	87aa                	mv	a5,a0
 428:	86be                	mv	a3,a5
 42a:	0785                	addi	a5,a5,1
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	ff65                	bnez	a4,428 <strlen+0x12>
 432:	40a6853b          	subw	a0,a3,a0
 436:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret
  for(n = 0; s[n]; n++)
 440:	4501                	li	a0,0
 442:	bfdd                	j	438 <strlen+0x22>

0000000000000444 <memset>:

void*
memset(void *dst, int c, uint n)
{
 444:	1141                	addi	sp,sp,-16
 446:	e406                	sd	ra,8(sp)
 448:	e022                	sd	s0,0(sp)
 44a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 44c:	ca19                	beqz	a2,462 <memset+0x1e>
 44e:	87aa                	mv	a5,a0
 450:	1602                	slli	a2,a2,0x20
 452:	9201                	srli	a2,a2,0x20
 454:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 458:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 45c:	0785                	addi	a5,a5,1
 45e:	fee79de3          	bne	a5,a4,458 <memset+0x14>
  }
  return dst;
}
 462:	60a2                	ld	ra,8(sp)
 464:	6402                	ld	s0,0(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret

000000000000046a <strchr>:

char*
strchr(const char *s, char c)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  for(; *s; s++)
 472:	00054783          	lbu	a5,0(a0)
 476:	cf81                	beqz	a5,48e <strchr+0x24>
    if(*s == c)
 478:	00f58763          	beq	a1,a5,486 <strchr+0x1c>
  for(; *s; s++)
 47c:	0505                	addi	a0,a0,1
 47e:	00054783          	lbu	a5,0(a0)
 482:	fbfd                	bnez	a5,478 <strchr+0xe>
      return (char*)s;
  return 0;
 484:	4501                	li	a0,0
}
 486:	60a2                	ld	ra,8(sp)
 488:	6402                	ld	s0,0(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  return 0;
 48e:	4501                	li	a0,0
 490:	bfdd                	j	486 <strchr+0x1c>

0000000000000492 <gets>:

char*
gets(char *buf, int max)
{
 492:	7159                	addi	sp,sp,-112
 494:	f486                	sd	ra,104(sp)
 496:	f0a2                	sd	s0,96(sp)
 498:	eca6                	sd	s1,88(sp)
 49a:	e8ca                	sd	s2,80(sp)
 49c:	e4ce                	sd	s3,72(sp)
 49e:	e0d2                	sd	s4,64(sp)
 4a0:	fc56                	sd	s5,56(sp)
 4a2:	f85a                	sd	s6,48(sp)
 4a4:	f45e                	sd	s7,40(sp)
 4a6:	f062                	sd	s8,32(sp)
 4a8:	ec66                	sd	s9,24(sp)
 4aa:	e86a                	sd	s10,16(sp)
 4ac:	1880                	addi	s0,sp,112
 4ae:	8caa                	mv	s9,a0
 4b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b2:	892a                	mv	s2,a0
 4b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 4b6:	f9f40b13          	addi	s6,s0,-97
 4ba:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4bc:	4ba9                	li	s7,10
 4be:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 4c0:	8d26                	mv	s10,s1
 4c2:	0014899b          	addiw	s3,s1,1
 4c6:	84ce                	mv	s1,s3
 4c8:	0349d563          	bge	s3,s4,4f2 <gets+0x60>
    cc = read(0, &c, 1);
 4cc:	8656                	mv	a2,s5
 4ce:	85da                	mv	a1,s6
 4d0:	4501                	li	a0,0
 4d2:	198000ef          	jal	66a <read>
    if(cc < 1)
 4d6:	00a05e63          	blez	a0,4f2 <gets+0x60>
    buf[i++] = c;
 4da:	f9f44783          	lbu	a5,-97(s0)
 4de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e2:	01778763          	beq	a5,s7,4f0 <gets+0x5e>
 4e6:	0905                	addi	s2,s2,1
 4e8:	fd879ce3          	bne	a5,s8,4c0 <gets+0x2e>
    buf[i++] = c;
 4ec:	8d4e                	mv	s10,s3
 4ee:	a011                	j	4f2 <gets+0x60>
 4f0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 4f2:	9d66                	add	s10,s10,s9
 4f4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 4f8:	8566                	mv	a0,s9
 4fa:	70a6                	ld	ra,104(sp)
 4fc:	7406                	ld	s0,96(sp)
 4fe:	64e6                	ld	s1,88(sp)
 500:	6946                	ld	s2,80(sp)
 502:	69a6                	ld	s3,72(sp)
 504:	6a06                	ld	s4,64(sp)
 506:	7ae2                	ld	s5,56(sp)
 508:	7b42                	ld	s6,48(sp)
 50a:	7ba2                	ld	s7,40(sp)
 50c:	7c02                	ld	s8,32(sp)
 50e:	6ce2                	ld	s9,24(sp)
 510:	6d42                	ld	s10,16(sp)
 512:	6165                	addi	sp,sp,112
 514:	8082                	ret

0000000000000516 <stat>:

int
stat(const char *n, struct stat *st)
{
 516:	1101                	addi	sp,sp,-32
 518:	ec06                	sd	ra,24(sp)
 51a:	e822                	sd	s0,16(sp)
 51c:	e04a                	sd	s2,0(sp)
 51e:	1000                	addi	s0,sp,32
 520:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 522:	4581                	li	a1,0
 524:	196000ef          	jal	6ba <open>
  if(fd < 0)
 528:	02054263          	bltz	a0,54c <stat+0x36>
 52c:	e426                	sd	s1,8(sp)
 52e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 530:	85ca                	mv	a1,s2
 532:	150000ef          	jal	682 <fstat>
 536:	892a                	mv	s2,a0
  close(fd);
 538:	8526                	mv	a0,s1
 53a:	1b0000ef          	jal	6ea <close>
  return r;
 53e:	64a2                	ld	s1,8(sp)
}
 540:	854a                	mv	a0,s2
 542:	60e2                	ld	ra,24(sp)
 544:	6442                	ld	s0,16(sp)
 546:	6902                	ld	s2,0(sp)
 548:	6105                	addi	sp,sp,32
 54a:	8082                	ret
    return -1;
 54c:	597d                	li	s2,-1
 54e:	bfcd                	j	540 <stat+0x2a>

0000000000000550 <atoi>:

int
atoi(const char *s)
{
 550:	1141                	addi	sp,sp,-16
 552:	e406                	sd	ra,8(sp)
 554:	e022                	sd	s0,0(sp)
 556:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 558:	00054683          	lbu	a3,0(a0)
 55c:	fd06879b          	addiw	a5,a3,-48
 560:	0ff7f793          	zext.b	a5,a5
 564:	4625                	li	a2,9
 566:	02f66963          	bltu	a2,a5,598 <atoi+0x48>
 56a:	872a                	mv	a4,a0
  n = 0;
 56c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 56e:	0705                	addi	a4,a4,1
 570:	0025179b          	slliw	a5,a0,0x2
 574:	9fa9                	addw	a5,a5,a0
 576:	0017979b          	slliw	a5,a5,0x1
 57a:	9fb5                	addw	a5,a5,a3
 57c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 580:	00074683          	lbu	a3,0(a4)
 584:	fd06879b          	addiw	a5,a3,-48
 588:	0ff7f793          	zext.b	a5,a5
 58c:	fef671e3          	bgeu	a2,a5,56e <atoi+0x1e>
  return n;
}
 590:	60a2                	ld	ra,8(sp)
 592:	6402                	ld	s0,0(sp)
 594:	0141                	addi	sp,sp,16
 596:	8082                	ret
  n = 0;
 598:	4501                	li	a0,0
 59a:	bfdd                	j	590 <atoi+0x40>

000000000000059c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 59c:	1141                	addi	sp,sp,-16
 59e:	e406                	sd	ra,8(sp)
 5a0:	e022                	sd	s0,0(sp)
 5a2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5a4:	02b57563          	bgeu	a0,a1,5ce <memmove+0x32>
    while(n-- > 0)
 5a8:	00c05f63          	blez	a2,5c6 <memmove+0x2a>
 5ac:	1602                	slli	a2,a2,0x20
 5ae:	9201                	srli	a2,a2,0x20
 5b0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 5b6:	0585                	addi	a1,a1,1
 5b8:	0705                	addi	a4,a4,1
 5ba:	fff5c683          	lbu	a3,-1(a1)
 5be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c2:	fee79ae3          	bne	a5,a4,5b6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5c6:	60a2                	ld	ra,8(sp)
 5c8:	6402                	ld	s0,0(sp)
 5ca:	0141                	addi	sp,sp,16
 5cc:	8082                	ret
    dst += n;
 5ce:	00c50733          	add	a4,a0,a2
    src += n;
 5d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d4:	fec059e3          	blez	a2,5c6 <memmove+0x2a>
 5d8:	fff6079b          	addiw	a5,a2,-1
 5dc:	1782                	slli	a5,a5,0x20
 5de:	9381                	srli	a5,a5,0x20
 5e0:	fff7c793          	not	a5,a5
 5e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e6:	15fd                	addi	a1,a1,-1
 5e8:	177d                	addi	a4,a4,-1
 5ea:	0005c683          	lbu	a3,0(a1)
 5ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5f2:	fef71ae3          	bne	a4,a5,5e6 <memmove+0x4a>
 5f6:	bfc1                	j	5c6 <memmove+0x2a>

00000000000005f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f8:	1141                	addi	sp,sp,-16
 5fa:	e406                	sd	ra,8(sp)
 5fc:	e022                	sd	s0,0(sp)
 5fe:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 600:	ca0d                	beqz	a2,632 <memcmp+0x3a>
 602:	fff6069b          	addiw	a3,a2,-1
 606:	1682                	slli	a3,a3,0x20
 608:	9281                	srli	a3,a3,0x20
 60a:	0685                	addi	a3,a3,1
 60c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 60e:	00054783          	lbu	a5,0(a0)
 612:	0005c703          	lbu	a4,0(a1)
 616:	00e79863          	bne	a5,a4,626 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 61a:	0505                	addi	a0,a0,1
    p2++;
 61c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 61e:	fed518e3          	bne	a0,a3,60e <memcmp+0x16>
  }
  return 0;
 622:	4501                	li	a0,0
 624:	a019                	j	62a <memcmp+0x32>
      return *p1 - *p2;
 626:	40e7853b          	subw	a0,a5,a4
}
 62a:	60a2                	ld	ra,8(sp)
 62c:	6402                	ld	s0,0(sp)
 62e:	0141                	addi	sp,sp,16
 630:	8082                	ret
  return 0;
 632:	4501                	li	a0,0
 634:	bfdd                	j	62a <memcmp+0x32>

0000000000000636 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 636:	1141                	addi	sp,sp,-16
 638:	e406                	sd	ra,8(sp)
 63a:	e022                	sd	s0,0(sp)
 63c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 63e:	f5fff0ef          	jal	59c <memmove>
}
 642:	60a2                	ld	ra,8(sp)
 644:	6402                	ld	s0,0(sp)
 646:	0141                	addi	sp,sp,16
 648:	8082                	ret

000000000000064a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 64a:	4885                	li	a7,1
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <exit>:
.global exit
exit:
 li a7, SYS_exit
 652:	4889                	li	a7,2
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <wait>:
.global wait
wait:
 li a7, SYS_wait
 65a:	488d                	li	a7,3
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 662:	4891                	li	a7,4
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <read>:
.global read
read:
 li a7, SYS_read
 66a:	4895                	li	a7,5
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <kill>:
.global kill
kill:
 li a7, SYS_kill
 672:	4899                	li	a7,6
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <exec>:
.global exec
exec:
 li a7, SYS_exec
 67a:	489d                	li	a7,7
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 682:	48a1                	li	a7,8
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 68a:	48a5                	li	a7,9
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <dup>:
.global dup
dup:
 li a7, SYS_dup
 692:	48a9                	li	a7,10
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 69a:	48ad                	li	a7,11
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6a2:	48b1                	li	a7,12
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6aa:	48b5                	li	a7,13
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6b2:	48b9                	li	a7,14
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <open>:
.global open
open:
 li a7, SYS_open
 6ba:	48bd                	li	a7,15
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <write>:
.global write
write:
 li a7, SYS_write
 6c2:	48c1                	li	a7,16
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6ca:	48c5                	li	a7,17
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6d2:	48c9                	li	a7,18
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <link>:
.global link
link:
 li a7, SYS_link
 6da:	48cd                	li	a7,19
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6e2:	48d1                	li	a7,20
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <close>:
.global close
close:
 li a7, SYS_close
 6ea:	48d5                	li	a7,21
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 6f2:	48d9                	li	a7,22
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 6fa:	48dd                	li	a7,23
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 702:	48e1                	li	a7,24
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 70a:	1101                	addi	sp,sp,-32
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 716:	4605                	li	a2,1
 718:	fef40593          	addi	a1,s0,-17
 71c:	fa7ff0ef          	jal	6c2 <write>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6105                	addi	sp,sp,32
 726:	8082                	ret

0000000000000728 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	f426                	sd	s1,40(sp)
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	0080                	addi	s0,sp,64
 736:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 738:	c299                	beqz	a3,73e <printint+0x16>
 73a:	0605ce63          	bltz	a1,7b6 <printint+0x8e>
  neg = 0;
 73e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 740:	fc040313          	addi	t1,s0,-64
  neg = 0;
 744:	869a                	mv	a3,t1
  i = 0;
 746:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 748:	00000817          	auipc	a6,0x0
 74c:	72080813          	addi	a6,a6,1824 # e68 <digits>
 750:	88be                	mv	a7,a5
 752:	0017851b          	addiw	a0,a5,1
 756:	87aa                	mv	a5,a0
 758:	02c5f73b          	remuw	a4,a1,a2
 75c:	1702                	slli	a4,a4,0x20
 75e:	9301                	srli	a4,a4,0x20
 760:	9742                	add	a4,a4,a6
 762:	00074703          	lbu	a4,0(a4)
 766:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 76a:	872e                	mv	a4,a1
 76c:	02c5d5bb          	divuw	a1,a1,a2
 770:	0685                	addi	a3,a3,1
 772:	fcc77fe3          	bgeu	a4,a2,750 <printint+0x28>
  if(neg)
 776:	000e0c63          	beqz	t3,78e <printint+0x66>
    buf[i++] = '-';
 77a:	fd050793          	addi	a5,a0,-48
 77e:	00878533          	add	a0,a5,s0
 782:	02d00793          	li	a5,45
 786:	fef50823          	sb	a5,-16(a0)
 78a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 78e:	fff7899b          	addiw	s3,a5,-1
 792:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 796:	fff4c583          	lbu	a1,-1(s1)
 79a:	854a                	mv	a0,s2
 79c:	f6fff0ef          	jal	70a <putc>
  while(--i >= 0)
 7a0:	39fd                	addiw	s3,s3,-1
 7a2:	14fd                	addi	s1,s1,-1
 7a4:	fe09d9e3          	bgez	s3,796 <printint+0x6e>
}
 7a8:	70e2                	ld	ra,56(sp)
 7aa:	7442                	ld	s0,48(sp)
 7ac:	74a2                	ld	s1,40(sp)
 7ae:	7902                	ld	s2,32(sp)
 7b0:	69e2                	ld	s3,24(sp)
 7b2:	6121                	addi	sp,sp,64
 7b4:	8082                	ret
    x = -xx;
 7b6:	40b005bb          	negw	a1,a1
    neg = 1;
 7ba:	4e05                	li	t3,1
    x = -xx;
 7bc:	b751                	j	740 <printint+0x18>

00000000000007be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7be:	711d                	addi	sp,sp,-96
 7c0:	ec86                	sd	ra,88(sp)
 7c2:	e8a2                	sd	s0,80(sp)
 7c4:	e4a6                	sd	s1,72(sp)
 7c6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7c8:	0005c483          	lbu	s1,0(a1)
 7cc:	26048663          	beqz	s1,a38 <vprintf+0x27a>
 7d0:	e0ca                	sd	s2,64(sp)
 7d2:	fc4e                	sd	s3,56(sp)
 7d4:	f852                	sd	s4,48(sp)
 7d6:	f456                	sd	s5,40(sp)
 7d8:	f05a                	sd	s6,32(sp)
 7da:	ec5e                	sd	s7,24(sp)
 7dc:	e862                	sd	s8,16(sp)
 7de:	e466                	sd	s9,8(sp)
 7e0:	8b2a                	mv	s6,a0
 7e2:	8a2e                	mv	s4,a1
 7e4:	8bb2                	mv	s7,a2
  state = 0;
 7e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7e8:	4901                	li	s2,0
 7ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7f4:	06c00c93          	li	s9,108
 7f8:	a00d                	j	81a <vprintf+0x5c>
        putc(fd, c0);
 7fa:	85a6                	mv	a1,s1
 7fc:	855a                	mv	a0,s6
 7fe:	f0dff0ef          	jal	70a <putc>
 802:	a019                	j	808 <vprintf+0x4a>
    } else if(state == '%'){
 804:	03598363          	beq	s3,s5,82a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 808:	0019079b          	addiw	a5,s2,1
 80c:	893e                	mv	s2,a5
 80e:	873e                	mv	a4,a5
 810:	97d2                	add	a5,a5,s4
 812:	0007c483          	lbu	s1,0(a5)
 816:	20048963          	beqz	s1,a28 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 81a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 81e:	fe0993e3          	bnez	s3,804 <vprintf+0x46>
      if(c0 == '%'){
 822:	fd579ce3          	bne	a5,s5,7fa <vprintf+0x3c>
        state = '%';
 826:	89be                	mv	s3,a5
 828:	b7c5                	j	808 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 82a:	00ea06b3          	add	a3,s4,a4
 82e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 832:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 834:	c681                	beqz	a3,83c <vprintf+0x7e>
 836:	9752                	add	a4,a4,s4
 838:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 83c:	03878e63          	beq	a5,s8,878 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 840:	05978863          	beq	a5,s9,890 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 844:	07500713          	li	a4,117
 848:	0ee78263          	beq	a5,a4,92c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 84c:	07800713          	li	a4,120
 850:	12e78463          	beq	a5,a4,978 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 854:	07000713          	li	a4,112
 858:	14e78963          	beq	a5,a4,9aa <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 85c:	07300713          	li	a4,115
 860:	18e78863          	beq	a5,a4,9f0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 864:	02500713          	li	a4,37
 868:	04e79463          	bne	a5,a4,8b0 <vprintf+0xf2>
        putc(fd, '%');
 86c:	85ba                	mv	a1,a4
 86e:	855a                	mv	a0,s6
 870:	e9bff0ef          	jal	70a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 874:	4981                	li	s3,0
 876:	bf49                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 878:	008b8493          	addi	s1,s7,8
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	000ba583          	lw	a1,0(s7)
 884:	855a                	mv	a0,s6
 886:	ea3ff0ef          	jal	728 <printint>
 88a:	8ba6                	mv	s7,s1
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bfad                	j	808 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 890:	06400793          	li	a5,100
 894:	02f68963          	beq	a3,a5,8c6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 898:	06c00793          	li	a5,108
 89c:	04f68263          	beq	a3,a5,8e0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 8a0:	07500793          	li	a5,117
 8a4:	0af68063          	beq	a3,a5,944 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8a8:	07800793          	li	a5,120
 8ac:	0ef68263          	beq	a3,a5,990 <vprintf+0x1d2>
        putc(fd, '%');
 8b0:	02500593          	li	a1,37
 8b4:	855a                	mv	a0,s6
 8b6:	e55ff0ef          	jal	70a <putc>
        putc(fd, c0);
 8ba:	85a6                	mv	a1,s1
 8bc:	855a                	mv	a0,s6
 8be:	e4dff0ef          	jal	70a <putc>
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b791                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8c6:	008b8493          	addi	s1,s7,8
 8ca:	4685                	li	a3,1
 8cc:	4629                	li	a2,10
 8ce:	000ba583          	lw	a1,0(s7)
 8d2:	855a                	mv	a0,s6
 8d4:	e55ff0ef          	jal	728 <printint>
        i += 1;
 8d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8da:	8ba6                	mv	s7,s1
      state = 0;
 8dc:	4981                	li	s3,0
        i += 1;
 8de:	b72d                	j	808 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8e0:	06400793          	li	a5,100
 8e4:	02f60763          	beq	a2,a5,912 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8e8:	07500793          	li	a5,117
 8ec:	06f60963          	beq	a2,a5,95e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8f0:	07800793          	li	a5,120
 8f4:	faf61ee3          	bne	a2,a5,8b0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f8:	008b8493          	addi	s1,s7,8
 8fc:	4681                	li	a3,0
 8fe:	4641                	li	a2,16
 900:	000ba583          	lw	a1,0(s7)
 904:	855a                	mv	a0,s6
 906:	e23ff0ef          	jal	728 <printint>
        i += 2;
 90a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 90c:	8ba6                	mv	s7,s1
      state = 0;
 90e:	4981                	li	s3,0
        i += 2;
 910:	bde5                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 912:	008b8493          	addi	s1,s7,8
 916:	4685                	li	a3,1
 918:	4629                	li	a2,10
 91a:	000ba583          	lw	a1,0(s7)
 91e:	855a                	mv	a0,s6
 920:	e09ff0ef          	jal	728 <printint>
        i += 2;
 924:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 926:	8ba6                	mv	s7,s1
      state = 0;
 928:	4981                	li	s3,0
        i += 2;
 92a:	bdf9                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 92c:	008b8493          	addi	s1,s7,8
 930:	4681                	li	a3,0
 932:	4629                	li	a2,10
 934:	000ba583          	lw	a1,0(s7)
 938:	855a                	mv	a0,s6
 93a:	defff0ef          	jal	728 <printint>
 93e:	8ba6                	mv	s7,s1
      state = 0;
 940:	4981                	li	s3,0
 942:	b5d9                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 944:	008b8493          	addi	s1,s7,8
 948:	4681                	li	a3,0
 94a:	4629                	li	a2,10
 94c:	000ba583          	lw	a1,0(s7)
 950:	855a                	mv	a0,s6
 952:	dd7ff0ef          	jal	728 <printint>
        i += 1;
 956:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	8ba6                	mv	s7,s1
      state = 0;
 95a:	4981                	li	s3,0
        i += 1;
 95c:	b575                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 95e:	008b8493          	addi	s1,s7,8
 962:	4681                	li	a3,0
 964:	4629                	li	a2,10
 966:	000ba583          	lw	a1,0(s7)
 96a:	855a                	mv	a0,s6
 96c:	dbdff0ef          	jal	728 <printint>
        i += 2;
 970:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 972:	8ba6                	mv	s7,s1
      state = 0;
 974:	4981                	li	s3,0
        i += 2;
 976:	bd49                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 978:	008b8493          	addi	s1,s7,8
 97c:	4681                	li	a3,0
 97e:	4641                	li	a2,16
 980:	000ba583          	lw	a1,0(s7)
 984:	855a                	mv	a0,s6
 986:	da3ff0ef          	jal	728 <printint>
 98a:	8ba6                	mv	s7,s1
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bdad                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 990:	008b8493          	addi	s1,s7,8
 994:	4681                	li	a3,0
 996:	4641                	li	a2,16
 998:	000ba583          	lw	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	d8bff0ef          	jal	728 <printint>
        i += 1;
 9a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a4:	8ba6                	mv	s7,s1
      state = 0;
 9a6:	4981                	li	s3,0
        i += 1;
 9a8:	b585                	j	808 <vprintf+0x4a>
 9aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9ac:	008b8d13          	addi	s10,s7,8
 9b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9b4:	03000593          	li	a1,48
 9b8:	855a                	mv	a0,s6
 9ba:	d51ff0ef          	jal	70a <putc>
  putc(fd, 'x');
 9be:	07800593          	li	a1,120
 9c2:	855a                	mv	a0,s6
 9c4:	d47ff0ef          	jal	70a <putc>
 9c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ca:	00000b97          	auipc	s7,0x0
 9ce:	49eb8b93          	addi	s7,s7,1182 # e68 <digits>
 9d2:	03c9d793          	srli	a5,s3,0x3c
 9d6:	97de                	add	a5,a5,s7
 9d8:	0007c583          	lbu	a1,0(a5)
 9dc:	855a                	mv	a0,s6
 9de:	d2dff0ef          	jal	70a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e2:	0992                	slli	s3,s3,0x4
 9e4:	34fd                	addiw	s1,s1,-1
 9e6:	f4f5                	bnez	s1,9d2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9e8:	8bea                	mv	s7,s10
      state = 0;
 9ea:	4981                	li	s3,0
 9ec:	6d02                	ld	s10,0(sp)
 9ee:	bd29                	j	808 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9f0:	008b8993          	addi	s3,s7,8
 9f4:	000bb483          	ld	s1,0(s7)
 9f8:	cc91                	beqz	s1,a14 <vprintf+0x256>
        for(; *s; s++)
 9fa:	0004c583          	lbu	a1,0(s1)
 9fe:	c195                	beqz	a1,a22 <vprintf+0x264>
          putc(fd, *s);
 a00:	855a                	mv	a0,s6
 a02:	d09ff0ef          	jal	70a <putc>
        for(; *s; s++)
 a06:	0485                	addi	s1,s1,1
 a08:	0004c583          	lbu	a1,0(s1)
 a0c:	f9f5                	bnez	a1,a00 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 a0e:	8bce                	mv	s7,s3
      state = 0;
 a10:	4981                	li	s3,0
 a12:	bbdd                	j	808 <vprintf+0x4a>
          s = "(null)";
 a14:	00000497          	auipc	s1,0x0
 a18:	44c48493          	addi	s1,s1,1100 # e60 <malloc+0x33c>
        for(; *s; s++)
 a1c:	02800593          	li	a1,40
 a20:	b7c5                	j	a00 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 a22:	8bce                	mv	s7,s3
      state = 0;
 a24:	4981                	li	s3,0
 a26:	b3cd                	j	808 <vprintf+0x4a>
 a28:	6906                	ld	s2,64(sp)
 a2a:	79e2                	ld	s3,56(sp)
 a2c:	7a42                	ld	s4,48(sp)
 a2e:	7aa2                	ld	s5,40(sp)
 a30:	7b02                	ld	s6,32(sp)
 a32:	6be2                	ld	s7,24(sp)
 a34:	6c42                	ld	s8,16(sp)
 a36:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a38:	60e6                	ld	ra,88(sp)
 a3a:	6446                	ld	s0,80(sp)
 a3c:	64a6                	ld	s1,72(sp)
 a3e:	6125                	addi	sp,sp,96
 a40:	8082                	ret

0000000000000a42 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a42:	715d                	addi	sp,sp,-80
 a44:	ec06                	sd	ra,24(sp)
 a46:	e822                	sd	s0,16(sp)
 a48:	1000                	addi	s0,sp,32
 a4a:	e010                	sd	a2,0(s0)
 a4c:	e414                	sd	a3,8(s0)
 a4e:	e818                	sd	a4,16(s0)
 a50:	ec1c                	sd	a5,24(s0)
 a52:	03043023          	sd	a6,32(s0)
 a56:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a5a:	8622                	mv	a2,s0
 a5c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a60:	d5fff0ef          	jal	7be <vprintf>
}
 a64:	60e2                	ld	ra,24(sp)
 a66:	6442                	ld	s0,16(sp)
 a68:	6161                	addi	sp,sp,80
 a6a:	8082                	ret

0000000000000a6c <printf>:

void
printf(const char *fmt, ...)
{
 a6c:	711d                	addi	sp,sp,-96
 a6e:	ec06                	sd	ra,24(sp)
 a70:	e822                	sd	s0,16(sp)
 a72:	1000                	addi	s0,sp,32
 a74:	e40c                	sd	a1,8(s0)
 a76:	e810                	sd	a2,16(s0)
 a78:	ec14                	sd	a3,24(s0)
 a7a:	f018                	sd	a4,32(s0)
 a7c:	f41c                	sd	a5,40(s0)
 a7e:	03043823          	sd	a6,48(s0)
 a82:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a86:	00840613          	addi	a2,s0,8
 a8a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a8e:	85aa                	mv	a1,a0
 a90:	4505                	li	a0,1
 a92:	d2dff0ef          	jal	7be <vprintf>
}
 a96:	60e2                	ld	ra,24(sp)
 a98:	6442                	ld	s0,16(sp)
 a9a:	6125                	addi	sp,sp,96
 a9c:	8082                	ret

0000000000000a9e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a9e:	1141                	addi	sp,sp,-16
 aa0:	e406                	sd	ra,8(sp)
 aa2:	e022                	sd	s0,0(sp)
 aa4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aaa:	00001797          	auipc	a5,0x1
 aae:	55e7b783          	ld	a5,1374(a5) # 2008 <freep>
 ab2:	a02d                	j	adc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab4:	4618                	lw	a4,8(a2)
 ab6:	9f2d                	addw	a4,a4,a1
 ab8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	6398                	ld	a4,0(a5)
 abe:	6310                	ld	a2,0(a4)
 ac0:	a83d                	j	afe <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac2:	ff852703          	lw	a4,-8(a0)
 ac6:	9f31                	addw	a4,a4,a2
 ac8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aca:	ff053683          	ld	a3,-16(a0)
 ace:	a091                	j	b12 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad0:	6398                	ld	a4,0(a5)
 ad2:	00e7e463          	bltu	a5,a4,ada <free+0x3c>
 ad6:	00e6ea63          	bltu	a3,a4,aea <free+0x4c>
{
 ada:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 adc:	fed7fae3          	bgeu	a5,a3,ad0 <free+0x32>
 ae0:	6398                	ld	a4,0(a5)
 ae2:	00e6e463          	bltu	a3,a4,aea <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae6:	fee7eae3          	bltu	a5,a4,ada <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 aea:	ff852583          	lw	a1,-8(a0)
 aee:	6390                	ld	a2,0(a5)
 af0:	02059813          	slli	a6,a1,0x20
 af4:	01c85713          	srli	a4,a6,0x1c
 af8:	9736                	add	a4,a4,a3
 afa:	fae60de3          	beq	a2,a4,ab4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 afe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b02:	4790                	lw	a2,8(a5)
 b04:	02061593          	slli	a1,a2,0x20
 b08:	01c5d713          	srli	a4,a1,0x1c
 b0c:	973e                	add	a4,a4,a5
 b0e:	fae68ae3          	beq	a3,a4,ac2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 b12:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b14:	00001717          	auipc	a4,0x1
 b18:	4ef73a23          	sd	a5,1268(a4) # 2008 <freep>
}
 b1c:	60a2                	ld	ra,8(sp)
 b1e:	6402                	ld	s0,0(sp)
 b20:	0141                	addi	sp,sp,16
 b22:	8082                	ret

0000000000000b24 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b24:	7139                	addi	sp,sp,-64
 b26:	fc06                	sd	ra,56(sp)
 b28:	f822                	sd	s0,48(sp)
 b2a:	f04a                	sd	s2,32(sp)
 b2c:	ec4e                	sd	s3,24(sp)
 b2e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b30:	02051993          	slli	s3,a0,0x20
 b34:	0209d993          	srli	s3,s3,0x20
 b38:	09bd                	addi	s3,s3,15
 b3a:	0049d993          	srli	s3,s3,0x4
 b3e:	2985                	addiw	s3,s3,1
 b40:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b42:	00001517          	auipc	a0,0x1
 b46:	4c653503          	ld	a0,1222(a0) # 2008 <freep>
 b4a:	c905                	beqz	a0,b7a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4e:	4798                	lw	a4,8(a5)
 b50:	09377663          	bgeu	a4,s3,bdc <malloc+0xb8>
 b54:	f426                	sd	s1,40(sp)
 b56:	e852                	sd	s4,16(sp)
 b58:	e456                	sd	s5,8(sp)
 b5a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b5c:	8a4e                	mv	s4,s3
 b5e:	6705                	lui	a4,0x1
 b60:	00e9f363          	bgeu	s3,a4,b66 <malloc+0x42>
 b64:	6a05                	lui	s4,0x1
 b66:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b6a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b6e:	00001497          	auipc	s1,0x1
 b72:	49a48493          	addi	s1,s1,1178 # 2008 <freep>
  if(p == (char*)-1)
 b76:	5afd                	li	s5,-1
 b78:	a83d                	j	bb6 <malloc+0x92>
 b7a:	f426                	sd	s1,40(sp)
 b7c:	e852                	sd	s4,16(sp)
 b7e:	e456                	sd	s5,8(sp)
 b80:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b82:	00001797          	auipc	a5,0x1
 b86:	48e78793          	addi	a5,a5,1166 # 2010 <base>
 b8a:	00001717          	auipc	a4,0x1
 b8e:	46f73f23          	sd	a5,1150(a4) # 2008 <freep>
 b92:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b94:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b98:	b7d1                	j	b5c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b9a:	6398                	ld	a4,0(a5)
 b9c:	e118                	sd	a4,0(a0)
 b9e:	a899                	j	bf4 <malloc+0xd0>
  hp->s.size = nu;
 ba0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ba4:	0541                	addi	a0,a0,16
 ba6:	ef9ff0ef          	jal	a9e <free>
  return freep;
 baa:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 bac:	c125                	beqz	a0,c0c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb0:	4798                	lw	a4,8(a5)
 bb2:	03277163          	bgeu	a4,s2,bd4 <malloc+0xb0>
    if(p == freep)
 bb6:	6098                	ld	a4,0(s1)
 bb8:	853e                	mv	a0,a5
 bba:	fef71ae3          	bne	a4,a5,bae <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 bbe:	8552                	mv	a0,s4
 bc0:	ae3ff0ef          	jal	6a2 <sbrk>
  if(p == (char*)-1)
 bc4:	fd551ee3          	bne	a0,s5,ba0 <malloc+0x7c>
        return 0;
 bc8:	4501                	li	a0,0
 bca:	74a2                	ld	s1,40(sp)
 bcc:	6a42                	ld	s4,16(sp)
 bce:	6aa2                	ld	s5,8(sp)
 bd0:	6b02                	ld	s6,0(sp)
 bd2:	a03d                	j	c00 <malloc+0xdc>
 bd4:	74a2                	ld	s1,40(sp)
 bd6:	6a42                	ld	s4,16(sp)
 bd8:	6aa2                	ld	s5,8(sp)
 bda:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bdc:	fae90fe3          	beq	s2,a4,b9a <malloc+0x76>
        p->s.size -= nunits;
 be0:	4137073b          	subw	a4,a4,s3
 be4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 be6:	02071693          	slli	a3,a4,0x20
 bea:	01c6d713          	srli	a4,a3,0x1c
 bee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bf0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bf4:	00001717          	auipc	a4,0x1
 bf8:	40a73a23          	sd	a0,1044(a4) # 2008 <freep>
      return (void*)(p + 1);
 bfc:	01078513          	addi	a0,a5,16
  }
}
 c00:	70e2                	ld	ra,56(sp)
 c02:	7442                	ld	s0,48(sp)
 c04:	7902                	ld	s2,32(sp)
 c06:	69e2                	ld	s3,24(sp)
 c08:	6121                	addi	sp,sp,64
 c0a:	8082                	ret
 c0c:	74a2                	ld	s1,40(sp)
 c0e:	6a42                	ld	s4,16(sp)
 c10:	6aa2                	ld	s5,8(sp)
 c12:	6b02                	ld	s6,0(sp)
 c14:	b7f5                	j	c00 <malloc+0xdc>
