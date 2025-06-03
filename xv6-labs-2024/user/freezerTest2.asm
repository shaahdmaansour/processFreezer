
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
  1e:	bf650513          	addi	a0,a0,-1034 # c10 <malloc+0xf4>
  22:	243000ef          	jal	a64 <printf>
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
  4c:	bd850513          	addi	a0,a0,-1064 # c20 <malloc+0x104>
  50:	215000ef          	jal	a64 <printf>
  sleep(1);
  54:	4505                	li	a0,1
  56:	654000ef          	jal	6aa <sleep>
  printf("PID\tState\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	be650513          	addi	a0,a0,-1050 # c40 <malloc+0x124>
  62:	203000ef          	jal	a64 <printf>
  sleep(1);
  66:	4505                	li	a0,1
  68:	642000ef          	jal	6aa <sleep>
  printf("----------------\n");
  6c:	00001517          	auipc	a0,0x1
  70:	be450513          	addi	a0,a0,-1052 # c50 <malloc+0x134>
  74:	1f1000ef          	jal	a64 <printf>
  sleep(1);
  78:	4505                	li	a0,1
  7a:	630000ef          	jal	6aa <sleep>
  
  // Show parent process
  printf("%d\tRUNNING\n", getpid());
  7e:	61c000ef          	jal	69a <getpid>
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	be450513          	addi	a0,a0,-1052 # c68 <malloc+0x14c>
  8c:	1d9000ef          	jal	a64 <printf>
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
  a6:	bd650513          	addi	a0,a0,-1066 # c78 <malloc+0x15c>
  aa:	1bb000ef          	jal	a64 <printf>
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
  c4:	bb850513          	addi	a0,a0,-1096 # c78 <malloc+0x15c>
  c8:	19d000ef          	jal	a64 <printf>
  } else {
    printf("%d\tRUNNING\n", pid2);
  }
  sleep(1);
  cc:	4505                	li	a0,1
  ce:	5dc000ef          	jal	6aa <sleep>
  
  // Show init and shell
  printf("1\tRUNNING\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	bb650513          	addi	a0,a0,-1098 # c88 <malloc+0x16c>
  da:	18b000ef          	jal	a64 <printf>
  sleep(1);
  de:	4505                	li	a0,1
  e0:	5ca000ef          	jal	6aa <sleep>
  printf("2\tRUNNING\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	bb450513          	addi	a0,a0,-1100 # c98 <malloc+0x17c>
  ec:	179000ef          	jal	a64 <printf>
  sleep(1);
  f0:	4505                	li	a0,1
  f2:	5b8000ef          	jal	6aa <sleep>
  
  printf("----------------\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	b5a50513          	addi	a0,a0,-1190 # c50 <malloc+0x134>
  fe:	167000ef          	jal	a64 <printf>
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
 11a:	b5250513          	addi	a0,a0,-1198 # c68 <malloc+0x14c>
 11e:	147000ef          	jal	a64 <printf>
 122:	b771                	j	ae <show_all_processes+0x7c>
    printf("%d\tRUNNING\n", pid2);
 124:	85a6                	mv	a1,s1
 126:	00001517          	auipc	a0,0x1
 12a:	b4250513          	addi	a0,a0,-1214 # c68 <malloc+0x14c>
 12e:	137000ef          	jal	a64 <printf>
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
 160:	b5c50513          	addi	a0,a0,-1188 # cb8 <malloc+0x19c>
 164:	101000ef          	jal	a64 <printf>
    
    while(1){
      print_status(mypid, "running");
 168:	00001997          	auipc	s3,0x1
 16c:	b7898993          	addi	s3,s3,-1160 # ce0 <malloc+0x1c4>
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
 18e:	b1e50513          	addi	a0,a0,-1250 # ca8 <malloc+0x18c>
 192:	0d3000ef          	jal	a64 <printf>
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
 1be:	b2e50513          	addi	a0,a0,-1234 # ce8 <malloc+0x1cc>
 1c2:	0a3000ef          	jal	a64 <printf>
      
      while(1){
        print_status(mypid, "running");
 1c6:	00001997          	auipc	s3,0x1
 1ca:	b1a98993          	addi	s3,s3,-1254 # ce0 <malloc+0x1c4>
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
 1e8:	ac450513          	addi	a0,a0,-1340 # ca8 <malloc+0x18c>
 1ec:	079000ef          	jal	a64 <printf>
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
 212:	b0250513          	addi	a0,a0,-1278 # d10 <malloc+0x1f4>
 216:	04f000ef          	jal	a64 <printf>
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
 230:	b2450513          	addi	a0,a0,-1244 # d50 <malloc+0x234>
 234:	031000ef          	jal	a64 <printf>
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
 250:	b5c58593          	addi	a1,a1,-1188 # da8 <malloc+0x28c>
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
 270:	ae450513          	addi	a0,a0,-1308 # d50 <malloc+0x234>
 274:	7f0000ef          	jal	a64 <printf>
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
 290:	b1c58593          	addi	a1,a1,-1252 # da8 <malloc+0x28c>
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
 2b0:	b0450513          	addi	a0,a0,-1276 # db0 <malloc+0x294>
 2b4:	7b0000ef          	jal	a64 <printf>
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
 2ce:	b3e58593          	addi	a1,a1,-1218 # e08 <malloc+0x2ec>
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
 2ee:	ac650513          	addi	a0,a0,-1338 # db0 <malloc+0x294>
 2f2:	772000ef          	jal	a64 <printf>
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
 30c:	b0058593          	addi	a1,a1,-1280 # e08 <malloc+0x2ec>
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
 32a:	af250513          	addi	a0,a0,-1294 # e18 <malloc+0x2fc>
 32e:	736000ef          	jal	a64 <printf>
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
 34e:	af658593          	addi	a1,a1,-1290 # e40 <malloc+0x324>
 352:	8526                	mv	a0,s1
 354:	cadff0ef          	jal	0 <print_status>
      print_status(child2_pid, "Terminated");
 358:	00001597          	auipc	a1,0x1
 35c:	ae858593          	addi	a1,a1,-1304 # e40 <malloc+0x324>
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
 37a:	a0a50513          	addi	a0,a0,-1526 # d80 <malloc+0x264>
 37e:	6e6000ef          	jal	a64 <printf>
 382:	bde1                	j	25a <main+0x126>
        printf("Error: Failed to freeze process %d\n", child2_pid);
 384:	85ca                	mv	a1,s2
 386:	00001517          	auipc	a0,0x1
 38a:	9fa50513          	addi	a0,a0,-1542 # d80 <malloc+0x264>
 38e:	6d6000ef          	jal	a64 <printf>
 392:	b721                	j	29a <main+0x166>
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
 394:	85a6                	mv	a1,s1
 396:	00001517          	auipc	a0,0x1
 39a:	a4a50513          	addi	a0,a0,-1462 # de0 <malloc+0x2c4>
 39e:	6c6000ef          	jal	a64 <printf>
 3a2:	bf1d                	j	2d8 <main+0x1a4>
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
 3a4:	85ca                	mv	a1,s2
 3a6:	00001517          	auipc	a0,0x1
 3aa:	a3a50513          	addi	a0,a0,-1478 # de0 <malloc+0x2c4>
 3ae:	6b6000ef          	jal	a64 <printf>
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

0000000000000702 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 702:	1101                	addi	sp,sp,-32
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 70e:	4605                	li	a2,1
 710:	fef40593          	addi	a1,s0,-17
 714:	fafff0ef          	jal	6c2 <write>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6105                	addi	sp,sp,32
 71e:	8082                	ret

0000000000000720 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 720:	7139                	addi	sp,sp,-64
 722:	fc06                	sd	ra,56(sp)
 724:	f822                	sd	s0,48(sp)
 726:	f426                	sd	s1,40(sp)
 728:	f04a                	sd	s2,32(sp)
 72a:	ec4e                	sd	s3,24(sp)
 72c:	0080                	addi	s0,sp,64
 72e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 730:	c299                	beqz	a3,736 <printint+0x16>
 732:	0605ce63          	bltz	a1,7ae <printint+0x8e>
  neg = 0;
 736:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 738:	fc040313          	addi	t1,s0,-64
  neg = 0;
 73c:	869a                	mv	a3,t1
  i = 0;
 73e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 740:	00000817          	auipc	a6,0x0
 744:	71880813          	addi	a6,a6,1816 # e58 <digits>
 748:	88be                	mv	a7,a5
 74a:	0017851b          	addiw	a0,a5,1
 74e:	87aa                	mv	a5,a0
 750:	02c5f73b          	remuw	a4,a1,a2
 754:	1702                	slli	a4,a4,0x20
 756:	9301                	srli	a4,a4,0x20
 758:	9742                	add	a4,a4,a6
 75a:	00074703          	lbu	a4,0(a4)
 75e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 762:	872e                	mv	a4,a1
 764:	02c5d5bb          	divuw	a1,a1,a2
 768:	0685                	addi	a3,a3,1
 76a:	fcc77fe3          	bgeu	a4,a2,748 <printint+0x28>
  if(neg)
 76e:	000e0c63          	beqz	t3,786 <printint+0x66>
    buf[i++] = '-';
 772:	fd050793          	addi	a5,a0,-48
 776:	00878533          	add	a0,a5,s0
 77a:	02d00793          	li	a5,45
 77e:	fef50823          	sb	a5,-16(a0)
 782:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 786:	fff7899b          	addiw	s3,a5,-1
 78a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 78e:	fff4c583          	lbu	a1,-1(s1)
 792:	854a                	mv	a0,s2
 794:	f6fff0ef          	jal	702 <putc>
  while(--i >= 0)
 798:	39fd                	addiw	s3,s3,-1
 79a:	14fd                	addi	s1,s1,-1
 79c:	fe09d9e3          	bgez	s3,78e <printint+0x6e>
}
 7a0:	70e2                	ld	ra,56(sp)
 7a2:	7442                	ld	s0,48(sp)
 7a4:	74a2                	ld	s1,40(sp)
 7a6:	7902                	ld	s2,32(sp)
 7a8:	69e2                	ld	s3,24(sp)
 7aa:	6121                	addi	sp,sp,64
 7ac:	8082                	ret
    x = -xx;
 7ae:	40b005bb          	negw	a1,a1
    neg = 1;
 7b2:	4e05                	li	t3,1
    x = -xx;
 7b4:	b751                	j	738 <printint+0x18>

00000000000007b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b6:	711d                	addi	sp,sp,-96
 7b8:	ec86                	sd	ra,88(sp)
 7ba:	e8a2                	sd	s0,80(sp)
 7bc:	e4a6                	sd	s1,72(sp)
 7be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7c0:	0005c483          	lbu	s1,0(a1)
 7c4:	26048663          	beqz	s1,a30 <vprintf+0x27a>
 7c8:	e0ca                	sd	s2,64(sp)
 7ca:	fc4e                	sd	s3,56(sp)
 7cc:	f852                	sd	s4,48(sp)
 7ce:	f456                	sd	s5,40(sp)
 7d0:	f05a                	sd	s6,32(sp)
 7d2:	ec5e                	sd	s7,24(sp)
 7d4:	e862                	sd	s8,16(sp)
 7d6:	e466                	sd	s9,8(sp)
 7d8:	8b2a                	mv	s6,a0
 7da:	8a2e                	mv	s4,a1
 7dc:	8bb2                	mv	s7,a2
  state = 0;
 7de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7e0:	4901                	li	s2,0
 7e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7ec:	06c00c93          	li	s9,108
 7f0:	a00d                	j	812 <vprintf+0x5c>
        putc(fd, c0);
 7f2:	85a6                	mv	a1,s1
 7f4:	855a                	mv	a0,s6
 7f6:	f0dff0ef          	jal	702 <putc>
 7fa:	a019                	j	800 <vprintf+0x4a>
    } else if(state == '%'){
 7fc:	03598363          	beq	s3,s5,822 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 800:	0019079b          	addiw	a5,s2,1
 804:	893e                	mv	s2,a5
 806:	873e                	mv	a4,a5
 808:	97d2                	add	a5,a5,s4
 80a:	0007c483          	lbu	s1,0(a5)
 80e:	20048963          	beqz	s1,a20 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 812:	0004879b          	sext.w	a5,s1
    if(state == 0){
 816:	fe0993e3          	bnez	s3,7fc <vprintf+0x46>
      if(c0 == '%'){
 81a:	fd579ce3          	bne	a5,s5,7f2 <vprintf+0x3c>
        state = '%';
 81e:	89be                	mv	s3,a5
 820:	b7c5                	j	800 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 822:	00ea06b3          	add	a3,s4,a4
 826:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 82a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 82c:	c681                	beqz	a3,834 <vprintf+0x7e>
 82e:	9752                	add	a4,a4,s4
 830:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 834:	03878e63          	beq	a5,s8,870 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 838:	05978863          	beq	a5,s9,888 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 83c:	07500713          	li	a4,117
 840:	0ee78263          	beq	a5,a4,924 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 844:	07800713          	li	a4,120
 848:	12e78463          	beq	a5,a4,970 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 84c:	07000713          	li	a4,112
 850:	14e78963          	beq	a5,a4,9a2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 854:	07300713          	li	a4,115
 858:	18e78863          	beq	a5,a4,9e8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 85c:	02500713          	li	a4,37
 860:	04e79463          	bne	a5,a4,8a8 <vprintf+0xf2>
        putc(fd, '%');
 864:	85ba                	mv	a1,a4
 866:	855a                	mv	a0,s6
 868:	e9bff0ef          	jal	702 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bf49                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 870:	008b8493          	addi	s1,s7,8
 874:	4685                	li	a3,1
 876:	4629                	li	a2,10
 878:	000ba583          	lw	a1,0(s7)
 87c:	855a                	mv	a0,s6
 87e:	ea3ff0ef          	jal	720 <printint>
 882:	8ba6                	mv	s7,s1
      state = 0;
 884:	4981                	li	s3,0
 886:	bfad                	j	800 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 888:	06400793          	li	a5,100
 88c:	02f68963          	beq	a3,a5,8be <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 890:	06c00793          	li	a5,108
 894:	04f68263          	beq	a3,a5,8d8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 898:	07500793          	li	a5,117
 89c:	0af68063          	beq	a3,a5,93c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8a0:	07800793          	li	a5,120
 8a4:	0ef68263          	beq	a3,a5,988 <vprintf+0x1d2>
        putc(fd, '%');
 8a8:	02500593          	li	a1,37
 8ac:	855a                	mv	a0,s6
 8ae:	e55ff0ef          	jal	702 <putc>
        putc(fd, c0);
 8b2:	85a6                	mv	a1,s1
 8b4:	855a                	mv	a0,s6
 8b6:	e4dff0ef          	jal	702 <putc>
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b791                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8be:	008b8493          	addi	s1,s7,8
 8c2:	4685                	li	a3,1
 8c4:	4629                	li	a2,10
 8c6:	000ba583          	lw	a1,0(s7)
 8ca:	855a                	mv	a0,s6
 8cc:	e55ff0ef          	jal	720 <printint>
        i += 1;
 8d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8d2:	8ba6                	mv	s7,s1
      state = 0;
 8d4:	4981                	li	s3,0
        i += 1;
 8d6:	b72d                	j	800 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8d8:	06400793          	li	a5,100
 8dc:	02f60763          	beq	a2,a5,90a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8e0:	07500793          	li	a5,117
 8e4:	06f60963          	beq	a2,a5,956 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8e8:	07800793          	li	a5,120
 8ec:	faf61ee3          	bne	a2,a5,8a8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f0:	008b8493          	addi	s1,s7,8
 8f4:	4681                	li	a3,0
 8f6:	4641                	li	a2,16
 8f8:	000ba583          	lw	a1,0(s7)
 8fc:	855a                	mv	a0,s6
 8fe:	e23ff0ef          	jal	720 <printint>
        i += 2;
 902:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 904:	8ba6                	mv	s7,s1
      state = 0;
 906:	4981                	li	s3,0
        i += 2;
 908:	bde5                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 90a:	008b8493          	addi	s1,s7,8
 90e:	4685                	li	a3,1
 910:	4629                	li	a2,10
 912:	000ba583          	lw	a1,0(s7)
 916:	855a                	mv	a0,s6
 918:	e09ff0ef          	jal	720 <printint>
        i += 2;
 91c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 91e:	8ba6                	mv	s7,s1
      state = 0;
 920:	4981                	li	s3,0
        i += 2;
 922:	bdf9                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 924:	008b8493          	addi	s1,s7,8
 928:	4681                	li	a3,0
 92a:	4629                	li	a2,10
 92c:	000ba583          	lw	a1,0(s7)
 930:	855a                	mv	a0,s6
 932:	defff0ef          	jal	720 <printint>
 936:	8ba6                	mv	s7,s1
      state = 0;
 938:	4981                	li	s3,0
 93a:	b5d9                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 93c:	008b8493          	addi	s1,s7,8
 940:	4681                	li	a3,0
 942:	4629                	li	a2,10
 944:	000ba583          	lw	a1,0(s7)
 948:	855a                	mv	a0,s6
 94a:	dd7ff0ef          	jal	720 <printint>
        i += 1;
 94e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 950:	8ba6                	mv	s7,s1
      state = 0;
 952:	4981                	li	s3,0
        i += 1;
 954:	b575                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 956:	008b8493          	addi	s1,s7,8
 95a:	4681                	li	a3,0
 95c:	4629                	li	a2,10
 95e:	000ba583          	lw	a1,0(s7)
 962:	855a                	mv	a0,s6
 964:	dbdff0ef          	jal	720 <printint>
        i += 2;
 968:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 96a:	8ba6                	mv	s7,s1
      state = 0;
 96c:	4981                	li	s3,0
        i += 2;
 96e:	bd49                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 970:	008b8493          	addi	s1,s7,8
 974:	4681                	li	a3,0
 976:	4641                	li	a2,16
 978:	000ba583          	lw	a1,0(s7)
 97c:	855a                	mv	a0,s6
 97e:	da3ff0ef          	jal	720 <printint>
 982:	8ba6                	mv	s7,s1
      state = 0;
 984:	4981                	li	s3,0
 986:	bdad                	j	800 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 988:	008b8493          	addi	s1,s7,8
 98c:	4681                	li	a3,0
 98e:	4641                	li	a2,16
 990:	000ba583          	lw	a1,0(s7)
 994:	855a                	mv	a0,s6
 996:	d8bff0ef          	jal	720 <printint>
        i += 1;
 99a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 99c:	8ba6                	mv	s7,s1
      state = 0;
 99e:	4981                	li	s3,0
        i += 1;
 9a0:	b585                	j	800 <vprintf+0x4a>
 9a2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9a4:	008b8d13          	addi	s10,s7,8
 9a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9ac:	03000593          	li	a1,48
 9b0:	855a                	mv	a0,s6
 9b2:	d51ff0ef          	jal	702 <putc>
  putc(fd, 'x');
 9b6:	07800593          	li	a1,120
 9ba:	855a                	mv	a0,s6
 9bc:	d47ff0ef          	jal	702 <putc>
 9c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c2:	00000b97          	auipc	s7,0x0
 9c6:	496b8b93          	addi	s7,s7,1174 # e58 <digits>
 9ca:	03c9d793          	srli	a5,s3,0x3c
 9ce:	97de                	add	a5,a5,s7
 9d0:	0007c583          	lbu	a1,0(a5)
 9d4:	855a                	mv	a0,s6
 9d6:	d2dff0ef          	jal	702 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9da:	0992                	slli	s3,s3,0x4
 9dc:	34fd                	addiw	s1,s1,-1
 9de:	f4f5                	bnez	s1,9ca <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9e0:	8bea                	mv	s7,s10
      state = 0;
 9e2:	4981                	li	s3,0
 9e4:	6d02                	ld	s10,0(sp)
 9e6:	bd29                	j	800 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9e8:	008b8993          	addi	s3,s7,8
 9ec:	000bb483          	ld	s1,0(s7)
 9f0:	cc91                	beqz	s1,a0c <vprintf+0x256>
        for(; *s; s++)
 9f2:	0004c583          	lbu	a1,0(s1)
 9f6:	c195                	beqz	a1,a1a <vprintf+0x264>
          putc(fd, *s);
 9f8:	855a                	mv	a0,s6
 9fa:	d09ff0ef          	jal	702 <putc>
        for(; *s; s++)
 9fe:	0485                	addi	s1,s1,1
 a00:	0004c583          	lbu	a1,0(s1)
 a04:	f9f5                	bnez	a1,9f8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 a06:	8bce                	mv	s7,s3
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	bbdd                	j	800 <vprintf+0x4a>
          s = "(null)";
 a0c:	00000497          	auipc	s1,0x0
 a10:	44448493          	addi	s1,s1,1092 # e50 <malloc+0x334>
        for(; *s; s++)
 a14:	02800593          	li	a1,40
 a18:	b7c5                	j	9f8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 a1a:	8bce                	mv	s7,s3
      state = 0;
 a1c:	4981                	li	s3,0
 a1e:	b3cd                	j	800 <vprintf+0x4a>
 a20:	6906                	ld	s2,64(sp)
 a22:	79e2                	ld	s3,56(sp)
 a24:	7a42                	ld	s4,48(sp)
 a26:	7aa2                	ld	s5,40(sp)
 a28:	7b02                	ld	s6,32(sp)
 a2a:	6be2                	ld	s7,24(sp)
 a2c:	6c42                	ld	s8,16(sp)
 a2e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a30:	60e6                	ld	ra,88(sp)
 a32:	6446                	ld	s0,80(sp)
 a34:	64a6                	ld	s1,72(sp)
 a36:	6125                	addi	sp,sp,96
 a38:	8082                	ret

0000000000000a3a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a3a:	715d                	addi	sp,sp,-80
 a3c:	ec06                	sd	ra,24(sp)
 a3e:	e822                	sd	s0,16(sp)
 a40:	1000                	addi	s0,sp,32
 a42:	e010                	sd	a2,0(s0)
 a44:	e414                	sd	a3,8(s0)
 a46:	e818                	sd	a4,16(s0)
 a48:	ec1c                	sd	a5,24(s0)
 a4a:	03043023          	sd	a6,32(s0)
 a4e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a52:	8622                	mv	a2,s0
 a54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a58:	d5fff0ef          	jal	7b6 <vprintf>
}
 a5c:	60e2                	ld	ra,24(sp)
 a5e:	6442                	ld	s0,16(sp)
 a60:	6161                	addi	sp,sp,80
 a62:	8082                	ret

0000000000000a64 <printf>:

void
printf(const char *fmt, ...)
{
 a64:	711d                	addi	sp,sp,-96
 a66:	ec06                	sd	ra,24(sp)
 a68:	e822                	sd	s0,16(sp)
 a6a:	1000                	addi	s0,sp,32
 a6c:	e40c                	sd	a1,8(s0)
 a6e:	e810                	sd	a2,16(s0)
 a70:	ec14                	sd	a3,24(s0)
 a72:	f018                	sd	a4,32(s0)
 a74:	f41c                	sd	a5,40(s0)
 a76:	03043823          	sd	a6,48(s0)
 a7a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a7e:	00840613          	addi	a2,s0,8
 a82:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a86:	85aa                	mv	a1,a0
 a88:	4505                	li	a0,1
 a8a:	d2dff0ef          	jal	7b6 <vprintf>
}
 a8e:	60e2                	ld	ra,24(sp)
 a90:	6442                	ld	s0,16(sp)
 a92:	6125                	addi	sp,sp,96
 a94:	8082                	ret

0000000000000a96 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a96:	1141                	addi	sp,sp,-16
 a98:	e406                	sd	ra,8(sp)
 a9a:	e022                	sd	s0,0(sp)
 a9c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a9e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa2:	00001797          	auipc	a5,0x1
 aa6:	5667b783          	ld	a5,1382(a5) # 2008 <freep>
 aaa:	a02d                	j	ad4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aac:	4618                	lw	a4,8(a2)
 aae:	9f2d                	addw	a4,a4,a1
 ab0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab4:	6398                	ld	a4,0(a5)
 ab6:	6310                	ld	a2,0(a4)
 ab8:	a83d                	j	af6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aba:	ff852703          	lw	a4,-8(a0)
 abe:	9f31                	addw	a4,a4,a2
 ac0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ac2:	ff053683          	ld	a3,-16(a0)
 ac6:	a091                	j	b0a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac8:	6398                	ld	a4,0(a5)
 aca:	00e7e463          	bltu	a5,a4,ad2 <free+0x3c>
 ace:	00e6ea63          	bltu	a3,a4,ae2 <free+0x4c>
{
 ad2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad4:	fed7fae3          	bgeu	a5,a3,ac8 <free+0x32>
 ad8:	6398                	ld	a4,0(a5)
 ada:	00e6e463          	bltu	a3,a4,ae2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ade:	fee7eae3          	bltu	a5,a4,ad2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 ae2:	ff852583          	lw	a1,-8(a0)
 ae6:	6390                	ld	a2,0(a5)
 ae8:	02059813          	slli	a6,a1,0x20
 aec:	01c85713          	srli	a4,a6,0x1c
 af0:	9736                	add	a4,a4,a3
 af2:	fae60de3          	beq	a2,a4,aac <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 af6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 afa:	4790                	lw	a2,8(a5)
 afc:	02061593          	slli	a1,a2,0x20
 b00:	01c5d713          	srli	a4,a1,0x1c
 b04:	973e                	add	a4,a4,a5
 b06:	fae68ae3          	beq	a3,a4,aba <free+0x24>
    p->s.ptr = bp->s.ptr;
 b0a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b0c:	00001717          	auipc	a4,0x1
 b10:	4ef73e23          	sd	a5,1276(a4) # 2008 <freep>
}
 b14:	60a2                	ld	ra,8(sp)
 b16:	6402                	ld	s0,0(sp)
 b18:	0141                	addi	sp,sp,16
 b1a:	8082                	ret

0000000000000b1c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b1c:	7139                	addi	sp,sp,-64
 b1e:	fc06                	sd	ra,56(sp)
 b20:	f822                	sd	s0,48(sp)
 b22:	f04a                	sd	s2,32(sp)
 b24:	ec4e                	sd	s3,24(sp)
 b26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b28:	02051993          	slli	s3,a0,0x20
 b2c:	0209d993          	srli	s3,s3,0x20
 b30:	09bd                	addi	s3,s3,15
 b32:	0049d993          	srli	s3,s3,0x4
 b36:	2985                	addiw	s3,s3,1
 b38:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b3a:	00001517          	auipc	a0,0x1
 b3e:	4ce53503          	ld	a0,1230(a0) # 2008 <freep>
 b42:	c905                	beqz	a0,b72 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b46:	4798                	lw	a4,8(a5)
 b48:	09377663          	bgeu	a4,s3,bd4 <malloc+0xb8>
 b4c:	f426                	sd	s1,40(sp)
 b4e:	e852                	sd	s4,16(sp)
 b50:	e456                	sd	s5,8(sp)
 b52:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b54:	8a4e                	mv	s4,s3
 b56:	6705                	lui	a4,0x1
 b58:	00e9f363          	bgeu	s3,a4,b5e <malloc+0x42>
 b5c:	6a05                	lui	s4,0x1
 b5e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b62:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b66:	00001497          	auipc	s1,0x1
 b6a:	4a248493          	addi	s1,s1,1186 # 2008 <freep>
  if(p == (char*)-1)
 b6e:	5afd                	li	s5,-1
 b70:	a83d                	j	bae <malloc+0x92>
 b72:	f426                	sd	s1,40(sp)
 b74:	e852                	sd	s4,16(sp)
 b76:	e456                	sd	s5,8(sp)
 b78:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b7a:	00001797          	auipc	a5,0x1
 b7e:	49678793          	addi	a5,a5,1174 # 2010 <base>
 b82:	00001717          	auipc	a4,0x1
 b86:	48f73323          	sd	a5,1158(a4) # 2008 <freep>
 b8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b90:	b7d1                	j	b54 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b92:	6398                	ld	a4,0(a5)
 b94:	e118                	sd	a4,0(a0)
 b96:	a899                	j	bec <malloc+0xd0>
  hp->s.size = nu;
 b98:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b9c:	0541                	addi	a0,a0,16
 b9e:	ef9ff0ef          	jal	a96 <free>
  return freep;
 ba2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ba4:	c125                	beqz	a0,c04 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ba8:	4798                	lw	a4,8(a5)
 baa:	03277163          	bgeu	a4,s2,bcc <malloc+0xb0>
    if(p == freep)
 bae:	6098                	ld	a4,0(s1)
 bb0:	853e                	mv	a0,a5
 bb2:	fef71ae3          	bne	a4,a5,ba6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 bb6:	8552                	mv	a0,s4
 bb8:	aebff0ef          	jal	6a2 <sbrk>
  if(p == (char*)-1)
 bbc:	fd551ee3          	bne	a0,s5,b98 <malloc+0x7c>
        return 0;
 bc0:	4501                	li	a0,0
 bc2:	74a2                	ld	s1,40(sp)
 bc4:	6a42                	ld	s4,16(sp)
 bc6:	6aa2                	ld	s5,8(sp)
 bc8:	6b02                	ld	s6,0(sp)
 bca:	a03d                	j	bf8 <malloc+0xdc>
 bcc:	74a2                	ld	s1,40(sp)
 bce:	6a42                	ld	s4,16(sp)
 bd0:	6aa2                	ld	s5,8(sp)
 bd2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bd4:	fae90fe3          	beq	s2,a4,b92 <malloc+0x76>
        p->s.size -= nunits;
 bd8:	4137073b          	subw	a4,a4,s3
 bdc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bde:	02071693          	slli	a3,a4,0x20
 be2:	01c6d713          	srli	a4,a3,0x1c
 be6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 be8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bec:	00001717          	auipc	a4,0x1
 bf0:	40a73e23          	sd	a0,1052(a4) # 2008 <freep>
      return (void*)(p + 1);
 bf4:	01078513          	addi	a0,a5,16
  }
}
 bf8:	70e2                	ld	ra,56(sp)
 bfa:	7442                	ld	s0,48(sp)
 bfc:	7902                	ld	s2,32(sp)
 bfe:	69e2                	ld	s3,24(sp)
 c00:	6121                	addi	sp,sp,64
 c02:	8082                	ret
 c04:	74a2                	ld	s1,40(sp)
 c06:	6a42                	ld	s4,16(sp)
 c08:	6aa2                	ld	s5,8(sp)
 c0a:	6b02                	ld	s6,0(sp)
 c0c:	b7f5                	j	bf8 <malloc+0xdc>
