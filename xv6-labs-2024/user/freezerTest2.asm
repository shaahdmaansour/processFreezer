
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
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
  sleep(1);
  10:	4505                	li	a0,1
  12:	686000ef          	jal	698 <sleep>
  printf("Process %d: %s\n", pid, status);
  16:	8626                	mv	a2,s1
  18:	85ca                	mv	a1,s2
  1a:	00001517          	auipc	a0,0x1
  1e:	c2650513          	addi	a0,a0,-986 # c40 <malloc+0xf8>
  22:	26f000ef          	jal	a90 <printf>
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
  3e:	84aa                	mv	s1,a0
  40:	892e                	mv	s2,a1
  sleep(2);
  42:	4509                	li	a0,2
  44:	654000ef          	jal	698 <sleep>
  printf("\nCurrent Processes:\n");
  48:	00001517          	auipc	a0,0x1
  4c:	c0850513          	addi	a0,a0,-1016 # c50 <malloc+0x108>
  50:	241000ef          	jal	a90 <printf>
  sleep(1);
  54:	4505                	li	a0,1
  56:	642000ef          	jal	698 <sleep>
  printf("PID\tState\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	c1650513          	addi	a0,a0,-1002 # c70 <malloc+0x128>
  62:	22f000ef          	jal	a90 <printf>
  sleep(1);
  66:	4505                	li	a0,1
  68:	630000ef          	jal	698 <sleep>
  printf("----------------\n");
  6c:	00001517          	auipc	a0,0x1
  70:	c1450513          	addi	a0,a0,-1004 # c80 <malloc+0x138>
  74:	21d000ef          	jal	a90 <printf>
  sleep(1);
  78:	4505                	li	a0,1
  7a:	61e000ef          	jal	698 <sleep>
  
  // Show parent process
  printf("%d\tRUNNING\n", getpid());
  7e:	60a000ef          	jal	688 <getpid>
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	c1450513          	addi	a0,a0,-1004 # c98 <malloc+0x150>
  8c:	205000ef          	jal	a90 <printf>
  sleep(1);
  90:	4505                	li	a0,1
  92:	606000ef          	jal	698 <sleep>
  
  // Show first child process
  if(frozen1) {
  96:	00002797          	auipc	a5,0x2
  9a:	f6e7a783          	lw	a5,-146(a5) # 2004 <frozen1>
  9e:	cbbd                	beqz	a5,114 <show_all_processes+0xe2>
    printf("%d\tFROZEN\n", pid1);
  a0:	85a6                	mv	a1,s1
  a2:	00001517          	auipc	a0,0x1
  a6:	c0650513          	addi	a0,a0,-1018 # ca8 <malloc+0x160>
  aa:	1e7000ef          	jal	a90 <printf>
  } else {
    printf("%d\tRUNNING\n", pid1);
  }
  sleep(1);
  ae:	4505                	li	a0,1
  b0:	5e8000ef          	jal	698 <sleep>
  
  // Show second child process
  if(frozen2) {
  b4:	00002797          	auipc	a5,0x2
  b8:	f4c7a783          	lw	a5,-180(a5) # 2000 <frozen2>
  bc:	c7a5                	beqz	a5,124 <show_all_processes+0xf2>
    printf("%d\tFROZEN\n", pid2);
  be:	85ca                	mv	a1,s2
  c0:	00001517          	auipc	a0,0x1
  c4:	be850513          	addi	a0,a0,-1048 # ca8 <malloc+0x160>
  c8:	1c9000ef          	jal	a90 <printf>
  } else {
    printf("%d\tRUNNING\n", pid2);
  }
  sleep(1);
  cc:	4505                	li	a0,1
  ce:	5ca000ef          	jal	698 <sleep>
  
  // Show init and shell
  printf("1\tRUNNING\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	be650513          	addi	a0,a0,-1050 # cb8 <malloc+0x170>
  da:	1b7000ef          	jal	a90 <printf>
  sleep(1);
  de:	4505                	li	a0,1
  e0:	5b8000ef          	jal	698 <sleep>
  printf("2\tRUNNING\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	be450513          	addi	a0,a0,-1052 # cc8 <malloc+0x180>
  ec:	1a5000ef          	jal	a90 <printf>
  sleep(1);
  f0:	4505                	li	a0,1
  f2:	5a6000ef          	jal	698 <sleep>
  
  printf("----------------\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	b8a50513          	addi	a0,a0,-1142 # c80 <malloc+0x138>
  fe:	193000ef          	jal	a90 <printf>
  sleep(1);
 102:	4505                	li	a0,1
 104:	594000ef          	jal	698 <sleep>
}
 108:	60e2                	ld	ra,24(sp)
 10a:	6442                	ld	s0,16(sp)
 10c:	64a2                	ld	s1,8(sp)
 10e:	6902                	ld	s2,0(sp)
 110:	6105                	addi	sp,sp,32
 112:	8082                	ret
    printf("%d\tRUNNING\n", pid1);
 114:	85a6                	mv	a1,s1
 116:	00001517          	auipc	a0,0x1
 11a:	b8250513          	addi	a0,a0,-1150 # c98 <malloc+0x150>
 11e:	173000ef          	jal	a90 <printf>
 122:	b771                	j	ae <show_all_processes+0x7c>
    printf("%d\tRUNNING\n", pid2);
 124:	85ca                	mv	a1,s2
 126:	00001517          	auipc	a0,0x1
 12a:	b7250513          	addi	a0,a0,-1166 # c98 <malloc+0x150>
 12e:	163000ef          	jal	a90 <printf>
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
 13c:	4fc000ef          	jal	638 <fork>
  
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
 14e:	53a000ef          	jal	688 <getpid>
 152:	84aa                	mv	s1,a0
    sleep(2);
 154:	4509                	li	a0,2
 156:	542000ef          	jal	698 <sleep>
    printf("Child process 1 started (PID: %d)\n", mypid);
 15a:	85a6                	mv	a1,s1
 15c:	00001517          	auipc	a0,0x1
 160:	b8c50513          	addi	a0,a0,-1140 # ce8 <malloc+0x1a0>
 164:	12d000ef          	jal	a90 <printf>
    
    while(1){
      print_status(mypid, "running");
 168:	00001997          	auipc	s3,0x1
 16c:	ba898993          	addi	s3,s3,-1112 # d10 <malloc+0x1c8>
      sleep(100);
 170:	06400913          	li	s2,100
      print_status(mypid, "running");
 174:	85ce                	mv	a1,s3
 176:	8526                	mv	a0,s1
 178:	e89ff0ef          	jal	0 <print_status>
      sleep(100);
 17c:	854a                	mv	a0,s2
 17e:	51a000ef          	jal	698 <sleep>
    while(1){
 182:	bfcd                	j	174 <main+0x40>
 184:	ec26                	sd	s1,24(sp)
 186:	e84a                	sd	s2,16(sp)
 188:	e44e                	sd	s3,8(sp)
    printf("fork failed\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	b4e50513          	addi	a0,a0,-1202 # cd8 <malloc+0x190>
 192:	0ff000ef          	jal	a90 <printf>
    exit(1);
 196:	4505                	li	a0,1
 198:	4a8000ef          	jal	640 <exit>
 19c:	e84a                	sd	s2,16(sp)
    }
  } else {
    // Parent process
    int child2_pid = fork();
 19e:	49a000ef          	jal	638 <fork>
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
 1ac:	4dc000ef          	jal	688 <getpid>
 1b0:	84aa                	mv	s1,a0
      sleep(2);
 1b2:	4509                	li	a0,2
 1b4:	4e4000ef          	jal	698 <sleep>
      printf("Child process 2 started (PID: %d)\n", mypid);
 1b8:	85a6                	mv	a1,s1
 1ba:	00001517          	auipc	a0,0x1
 1be:	b5e50513          	addi	a0,a0,-1186 # d18 <malloc+0x1d0>
 1c2:	0cf000ef          	jal	a90 <printf>
      
      while(1){
        print_status(mypid, "running");
 1c6:	00001997          	auipc	s3,0x1
 1ca:	b4a98993          	addi	s3,s3,-1206 # d10 <malloc+0x1c8>
        sleep(100);
 1ce:	06400913          	li	s2,100
        print_status(mypid, "running");
 1d2:	85ce                	mv	a1,s3
 1d4:	8526                	mv	a0,s1
 1d6:	e2bff0ef          	jal	0 <print_status>
        sleep(100);
 1da:	854a                	mv	a0,s2
 1dc:	4bc000ef          	jal	698 <sleep>
      while(1){
 1e0:	bfcd                	j	1d2 <main+0x9e>
 1e2:	e44e                	sd	s3,8(sp)
      printf("fork failed\n");
 1e4:	00001517          	auipc	a0,0x1
 1e8:	af450513          	addi	a0,a0,-1292 # cd8 <malloc+0x190>
 1ec:	0a5000ef          	jal	a90 <printf>
      kill(child1_pid);
 1f0:	8526                	mv	a0,s1
 1f2:	46e000ef          	jal	660 <kill>
      wait(0);
 1f6:	4501                	li	a0,0
 1f8:	450000ef          	jal	648 <wait>
      exit(1);
 1fc:	4505                	li	a0,1
 1fe:	442000ef          	jal	640 <exit>
 202:	e44e                	sd	s3,8(sp)
      }
    } else {
      // Parent process
      int mypid = getpid();
 204:	484000ef          	jal	688 <getpid>
 208:	85aa                	mv	a1,a0
      printf("Parent process (PID: %d) created children (PIDs: %d, %d)\n", 
 20a:	86ca                	mv	a3,s2
 20c:	8626                	mv	a2,s1
 20e:	00001517          	auipc	a0,0x1
 212:	b3250513          	addi	a0,a0,-1230 # d40 <malloc+0x1f8>
 216:	07b000ef          	jal	a90 <printf>
             mypid, child1_pid, child2_pid);
      
      // Show initial state
      show_all_processes(child1_pid, child2_pid);
 21a:	85ca                	mv	a1,s2
 21c:	8526                	mv	a0,s1
 21e:	e15ff0ef          	jal	32 <show_all_processes>
      
      // Wait for children to start
      sleep(300);
 222:	12c00513          	li	a0,300
 226:	472000ef          	jal	698 <sleep>
      
      // Freeze first child
      printf("\nAttempting to freeze child process %d...\n", child1_pid);
 22a:	85a6                	mv	a1,s1
 22c:	00001517          	auipc	a0,0x1
 230:	b5450513          	addi	a0,a0,-1196 # d80 <malloc+0x238>
 234:	05d000ef          	jal	a90 <printf>
      if(freeze(child1_pid) < 0){
 238:	8526                	mv	a0,s1
 23a:	4a6000ef          	jal	6e0 <freeze>
 23e:	12054b63          	bltz	a0,374 <main+0x240>
        printf("Error: Failed to freeze process %d\n", child1_pid);
      } else {
        frozen1 = 1;
 242:	4785                	li	a5,1
 244:	00002717          	auipc	a4,0x2
 248:	dcf72023          	sw	a5,-576(a4) # 2004 <frozen1>
        print_status(child1_pid, "Frozen");
 24c:	00001597          	auipc	a1,0x1
 250:	b8c58593          	addi	a1,a1,-1140 # dd8 <malloc+0x290>
 254:	8526                	mv	a0,s1
 256:	dabff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 25a:	85ca                	mv	a1,s2
 25c:	8526                	mv	a0,s1
 25e:	dd5ff0ef          	jal	32 <show_all_processes>
      sleep(200);
 262:	0c800513          	li	a0,200
 266:	432000ef          	jal	698 <sleep>
      
      // Freeze second child
      printf("\nAttempting to freeze child process %d...\n", child2_pid);
 26a:	85ca                	mv	a1,s2
 26c:	00001517          	auipc	a0,0x1
 270:	b1450513          	addi	a0,a0,-1260 # d80 <malloc+0x238>
 274:	01d000ef          	jal	a90 <printf>
      if(freeze(child2_pid) < 0){
 278:	854a                	mv	a0,s2
 27a:	466000ef          	jal	6e0 <freeze>
 27e:	10054363          	bltz	a0,384 <main+0x250>
        printf("Error: Failed to freeze process %d\n", child2_pid);
      } else {
        frozen2 = 1;
 282:	4785                	li	a5,1
 284:	00002717          	auipc	a4,0x2
 288:	d6f72e23          	sw	a5,-644(a4) # 2000 <frozen2>
        print_status(child2_pid, "Frozen");
 28c:	00001597          	auipc	a1,0x1
 290:	b4c58593          	addi	a1,a1,-1204 # dd8 <malloc+0x290>
 294:	854a                	mv	a0,s2
 296:	d6bff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 29a:	85ca                	mv	a1,s2
 29c:	8526                	mv	a0,s1
 29e:	d95ff0ef          	jal	32 <show_all_processes>
      sleep(300);
 2a2:	12c00513          	li	a0,300
 2a6:	3f2000ef          	jal	698 <sleep>
      
      // Unfreeze first child
      printf("\nAttempting to unfreeze child process %d...\n", child1_pid);
 2aa:	85a6                	mv	a1,s1
 2ac:	00001517          	auipc	a0,0x1
 2b0:	b3450513          	addi	a0,a0,-1228 # de0 <malloc+0x298>
 2b4:	7dc000ef          	jal	a90 <printf>
      if(unfreeze(child1_pid) < 0){
 2b8:	8526                	mv	a0,s1
 2ba:	42e000ef          	jal	6e8 <unfreeze>
 2be:	0c054b63          	bltz	a0,394 <main+0x260>
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
      } else {
        frozen1 = 0;
 2c2:	00002797          	auipc	a5,0x2
 2c6:	d407a123          	sw	zero,-702(a5) # 2004 <frozen1>
        print_status(child1_pid, "Unfrozen");
 2ca:	00001597          	auipc	a1,0x1
 2ce:	b6e58593          	addi	a1,a1,-1170 # e38 <malloc+0x2f0>
 2d2:	8526                	mv	a0,s1
 2d4:	d2dff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 2d8:	85ca                	mv	a1,s2
 2da:	8526                	mv	a0,s1
 2dc:	d57ff0ef          	jal	32 <show_all_processes>
      sleep(200);
 2e0:	0c800513          	li	a0,200
 2e4:	3b4000ef          	jal	698 <sleep>
      
      // Unfreeze second child
      printf("\nAttempting to unfreeze child process %d...\n", child2_pid);
 2e8:	85ca                	mv	a1,s2
 2ea:	00001517          	auipc	a0,0x1
 2ee:	af650513          	addi	a0,a0,-1290 # de0 <malloc+0x298>
 2f2:	79e000ef          	jal	a90 <printf>
      if(unfreeze(child2_pid) < 0){
 2f6:	854a                	mv	a0,s2
 2f8:	3f0000ef          	jal	6e8 <unfreeze>
 2fc:	0a054463          	bltz	a0,3a4 <main+0x270>
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
      } else {
        frozen2 = 0;
 300:	00002797          	auipc	a5,0x2
 304:	d007a023          	sw	zero,-768(a5) # 2000 <frozen2>
        print_status(child2_pid, "Unfrozen");
 308:	00001597          	auipc	a1,0x1
 30c:	b3058593          	addi	a1,a1,-1232 # e38 <malloc+0x2f0>
 310:	854a                	mv	a0,s2
 312:	cefff0ef          	jal	0 <print_status>
      }
      
      show_all_processes(child1_pid, child2_pid);
 316:	85ca                	mv	a1,s2
 318:	8526                	mv	a0,s1
 31a:	d19ff0ef          	jal	32 <show_all_processes>
      sleep(300);
 31e:	12c00513          	li	a0,300
 322:	376000ef          	jal	698 <sleep>
      
      // Terminate children
      printf("\nTerminating child processes...\n");
 326:	00001517          	auipc	a0,0x1
 32a:	b2250513          	addi	a0,a0,-1246 # e48 <malloc+0x300>
 32e:	762000ef          	jal	a90 <printf>
      kill(child1_pid);
 332:	8526                	mv	a0,s1
 334:	32c000ef          	jal	660 <kill>
      kill(child2_pid);
 338:	854a                	mv	a0,s2
 33a:	326000ef          	jal	660 <kill>
      wait(0);
 33e:	4501                	li	a0,0
 340:	308000ef          	jal	648 <wait>
      wait(0);
 344:	4501                	li	a0,0
 346:	302000ef          	jal	648 <wait>
      print_status(child1_pid, "Terminated");
 34a:	00001597          	auipc	a1,0x1
 34e:	b2658593          	addi	a1,a1,-1242 # e70 <malloc+0x328>
 352:	8526                	mv	a0,s1
 354:	cadff0ef          	jal	0 <print_status>
      print_status(child2_pid, "Terminated");
 358:	00001597          	auipc	a1,0x1
 35c:	b1858593          	addi	a1,a1,-1256 # e70 <malloc+0x328>
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
 370:	2d0000ef          	jal	640 <exit>
        printf("Error: Failed to freeze process %d\n", child1_pid);
 374:	85a6                	mv	a1,s1
 376:	00001517          	auipc	a0,0x1
 37a:	a3a50513          	addi	a0,a0,-1478 # db0 <malloc+0x268>
 37e:	712000ef          	jal	a90 <printf>
 382:	bde1                	j	25a <main+0x126>
        printf("Error: Failed to freeze process %d\n", child2_pid);
 384:	85ca                	mv	a1,s2
 386:	00001517          	auipc	a0,0x1
 38a:	a2a50513          	addi	a0,a0,-1494 # db0 <malloc+0x268>
 38e:	702000ef          	jal	a90 <printf>
 392:	b721                	j	29a <main+0x166>
        printf("Error: Failed to unfreeze process %d\n", child1_pid);
 394:	85a6                	mv	a1,s1
 396:	00001517          	auipc	a0,0x1
 39a:	a7a50513          	addi	a0,a0,-1414 # e10 <malloc+0x2c8>
 39e:	6f2000ef          	jal	a90 <printf>
 3a2:	bf1d                	j	2d8 <main+0x1a4>
        printf("Error: Failed to unfreeze process %d\n", child2_pid);
 3a4:	85ca                	mv	a1,s2
 3a6:	00001517          	auipc	a0,0x1
 3aa:	a6a50513          	addi	a0,a0,-1430 # e10 <malloc+0x2c8>
 3ae:	6e2000ef          	jal	a90 <printf>
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
 3c2:	27e000ef          	jal	640 <exit>

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
 422:	cf91                	beqz	a5,43e <strlen+0x28>
 424:	00150793          	addi	a5,a0,1
 428:	86be                	mv	a3,a5
 42a:	0785                	addi	a5,a5,1
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	ff65                	bnez	a4,428 <strlen+0x12>
 432:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 436:	60a2                	ld	ra,8(sp)
 438:	6402                	ld	s0,0(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
  for(n = 0; s[n]; n++)
 43e:	4501                	li	a0,0
 440:	bfdd                	j	436 <strlen+0x20>

0000000000000442 <memset>:

void*
memset(void *dst, int c, uint n)
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 44a:	ca19                	beqz	a2,460 <memset+0x1e>
 44c:	87aa                	mv	a5,a0
 44e:	1602                	slli	a2,a2,0x20
 450:	9201                	srli	a2,a2,0x20
 452:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 456:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 45a:	0785                	addi	a5,a5,1
 45c:	fee79de3          	bne	a5,a4,456 <memset+0x14>
  }
  return dst;
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <strchr>:

char*
strchr(const char *s, char c)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e406                	sd	ra,8(sp)
 46c:	e022                	sd	s0,0(sp)
 46e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 470:	00054783          	lbu	a5,0(a0)
 474:	cf81                	beqz	a5,48c <strchr+0x24>
    if(*s == c)
 476:	00f58763          	beq	a1,a5,484 <strchr+0x1c>
  for(; *s; s++)
 47a:	0505                	addi	a0,a0,1
 47c:	00054783          	lbu	a5,0(a0)
 480:	fbfd                	bnez	a5,476 <strchr+0xe>
      return (char*)s;
  return 0;
 482:	4501                	li	a0,0
}
 484:	60a2                	ld	ra,8(sp)
 486:	6402                	ld	s0,0(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  return 0;
 48c:	4501                	li	a0,0
 48e:	bfdd                	j	484 <strchr+0x1c>

0000000000000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	711d                	addi	sp,sp,-96
 492:	ec86                	sd	ra,88(sp)
 494:	e8a2                	sd	s0,80(sp)
 496:	e4a6                	sd	s1,72(sp)
 498:	e0ca                	sd	s2,64(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	e862                	sd	s8,16(sp)
 4a6:	1080                	addi	s0,sp,96
 4a8:	8baa                	mv	s7,a0
 4aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ac:	892a                	mv	s2,a0
 4ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
 4b0:	faf40b13          	addi	s6,s0,-81
 4b4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 4b6:	8c26                	mv	s8,s1
 4b8:	0014899b          	addiw	s3,s1,1
 4bc:	84ce                	mv	s1,s3
 4be:	0349d463          	bge	s3,s4,4e6 <gets+0x56>
    cc = read(0, &c, 1);
 4c2:	8656                	mv	a2,s5
 4c4:	85da                	mv	a1,s6
 4c6:	4501                	li	a0,0
 4c8:	190000ef          	jal	658 <read>
    if(cc < 1)
 4cc:	00a05d63          	blez	a0,4e6 <gets+0x56>
      break;
    buf[i++] = c;
 4d0:	faf44783          	lbu	a5,-81(s0)
 4d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4d8:	0905                	addi	s2,s2,1
 4da:	ff678713          	addi	a4,a5,-10
 4de:	c319                	beqz	a4,4e4 <gets+0x54>
 4e0:	17cd                	addi	a5,a5,-13
 4e2:	fbf1                	bnez	a5,4b6 <gets+0x26>
    buf[i++] = c;
 4e4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 4e6:	9c5e                	add	s8,s8,s7
 4e8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 4ec:	855e                	mv	a0,s7
 4ee:	60e6                	ld	ra,88(sp)
 4f0:	6446                	ld	s0,80(sp)
 4f2:	64a6                	ld	s1,72(sp)
 4f4:	6906                	ld	s2,64(sp)
 4f6:	79e2                	ld	s3,56(sp)
 4f8:	7a42                	ld	s4,48(sp)
 4fa:	7aa2                	ld	s5,40(sp)
 4fc:	7b02                	ld	s6,32(sp)
 4fe:	6be2                	ld	s7,24(sp)
 500:	6c42                	ld	s8,16(sp)
 502:	6125                	addi	sp,sp,96
 504:	8082                	ret

0000000000000506 <stat>:

int
stat(const char *n, struct stat *st)
{
 506:	1101                	addi	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	e04a                	sd	s2,0(sp)
 50e:	1000                	addi	s0,sp,32
 510:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 512:	4581                	li	a1,0
 514:	194000ef          	jal	6a8 <open>
  if(fd < 0)
 518:	02054263          	bltz	a0,53c <stat+0x36>
 51c:	e426                	sd	s1,8(sp)
 51e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 520:	85ca                	mv	a1,s2
 522:	14e000ef          	jal	670 <fstat>
 526:	892a                	mv	s2,a0
  close(fd);
 528:	8526                	mv	a0,s1
 52a:	1ae000ef          	jal	6d8 <close>
  return r;
 52e:	64a2                	ld	s1,8(sp)
}
 530:	854a                	mv	a0,s2
 532:	60e2                	ld	ra,24(sp)
 534:	6442                	ld	s0,16(sp)
 536:	6902                	ld	s2,0(sp)
 538:	6105                	addi	sp,sp,32
 53a:	8082                	ret
    return -1;
 53c:	57fd                	li	a5,-1
 53e:	893e                	mv	s2,a5
 540:	bfc5                	j	530 <stat+0x2a>

0000000000000542 <atoi>:

int
atoi(const char *s)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54a:	00054683          	lbu	a3,0(a0)
 54e:	fd06879b          	addiw	a5,a3,-48
 552:	0ff7f793          	zext.b	a5,a5
 556:	4625                	li	a2,9
 558:	02f66963          	bltu	a2,a5,58a <atoi+0x48>
 55c:	872a                	mv	a4,a0
  n = 0;
 55e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 560:	0705                	addi	a4,a4,1
 562:	0025179b          	slliw	a5,a0,0x2
 566:	9fa9                	addw	a5,a5,a0
 568:	0017979b          	slliw	a5,a5,0x1
 56c:	9fb5                	addw	a5,a5,a3
 56e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 572:	00074683          	lbu	a3,0(a4)
 576:	fd06879b          	addiw	a5,a3,-48
 57a:	0ff7f793          	zext.b	a5,a5
 57e:	fef671e3          	bgeu	a2,a5,560 <atoi+0x1e>
  return n;
}
 582:	60a2                	ld	ra,8(sp)
 584:	6402                	ld	s0,0(sp)
 586:	0141                	addi	sp,sp,16
 588:	8082                	ret
  n = 0;
 58a:	4501                	li	a0,0
 58c:	bfdd                	j	582 <atoi+0x40>

000000000000058e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 58e:	1141                	addi	sp,sp,-16
 590:	e406                	sd	ra,8(sp)
 592:	e022                	sd	s0,0(sp)
 594:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 596:	02b57563          	bgeu	a0,a1,5c0 <memmove+0x32>
    while(n-- > 0)
 59a:	00c05f63          	blez	a2,5b8 <memmove+0x2a>
 59e:	1602                	slli	a2,a2,0x20
 5a0:	9201                	srli	a2,a2,0x20
 5a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 5a8:	0585                	addi	a1,a1,1
 5aa:	0705                	addi	a4,a4,1
 5ac:	fff5c683          	lbu	a3,-1(a1)
 5b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5b4:	fee79ae3          	bne	a5,a4,5a8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5b8:	60a2                	ld	ra,8(sp)
 5ba:	6402                	ld	s0,0(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret
    while(n-- > 0)
 5c0:	fec05ce3          	blez	a2,5b8 <memmove+0x2a>
    dst += n;
 5c4:	00c50733          	add	a4,a0,a2
    src += n;
 5c8:	95b2                	add	a1,a1,a2
 5ca:	fff6079b          	addiw	a5,a2,-1
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	fff7c793          	not	a5,a5
 5d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5d8:	15fd                	addi	a1,a1,-1
 5da:	177d                	addi	a4,a4,-1
 5dc:	0005c683          	lbu	a3,0(a1)
 5e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5e4:	fef71ae3          	bne	a4,a5,5d8 <memmove+0x4a>
 5e8:	bfc1                	j	5b8 <memmove+0x2a>

00000000000005ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5ea:	1141                	addi	sp,sp,-16
 5ec:	e406                	sd	ra,8(sp)
 5ee:	e022                	sd	s0,0(sp)
 5f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5f2:	c61d                	beqz	a2,620 <memcmp+0x36>
 5f4:	1602                	slli	a2,a2,0x20
 5f6:	9201                	srli	a2,a2,0x20
 5f8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 5fc:	00054783          	lbu	a5,0(a0)
 600:	0005c703          	lbu	a4,0(a1)
 604:	00e79863          	bne	a5,a4,614 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 608:	0505                	addi	a0,a0,1
    p2++;
 60a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 60c:	fed518e3          	bne	a0,a3,5fc <memcmp+0x12>
  }
  return 0;
 610:	4501                	li	a0,0
 612:	a019                	j	618 <memcmp+0x2e>
      return *p1 - *p2;
 614:	40e7853b          	subw	a0,a5,a4
}
 618:	60a2                	ld	ra,8(sp)
 61a:	6402                	ld	s0,0(sp)
 61c:	0141                	addi	sp,sp,16
 61e:	8082                	ret
  return 0;
 620:	4501                	li	a0,0
 622:	bfdd                	j	618 <memcmp+0x2e>

0000000000000624 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 624:	1141                	addi	sp,sp,-16
 626:	e406                	sd	ra,8(sp)
 628:	e022                	sd	s0,0(sp)
 62a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 62c:	f63ff0ef          	jal	58e <memmove>
}
 630:	60a2                	ld	ra,8(sp)
 632:	6402                	ld	s0,0(sp)
 634:	0141                	addi	sp,sp,16
 636:	8082                	ret

0000000000000638 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 638:	4885                	li	a7,1
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <exit>:
.global exit
exit:
 li a7, SYS_exit
 640:	4889                	li	a7,2
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <wait>:
.global wait
wait:
 li a7, SYS_wait
 648:	488d                	li	a7,3
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 650:	4891                	li	a7,4
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <read>:
.global read
read:
 li a7, SYS_read
 658:	4895                	li	a7,5
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <kill>:
.global kill
kill:
 li a7, SYS_kill
 660:	4899                	li	a7,6
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <exec>:
.global exec
exec:
 li a7, SYS_exec
 668:	489d                	li	a7,7
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 670:	48a1                	li	a7,8
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 678:	48a5                	li	a7,9
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <dup>:
.global dup
dup:
 li a7, SYS_dup
 680:	48a9                	li	a7,10
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 688:	48ad                	li	a7,11
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 690:	48b1                	li	a7,12
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 698:	48b5                	li	a7,13
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a0:	48b9                	li	a7,14
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <open>:
.global open
open:
 li a7, SYS_open
 6a8:	48bd                	li	a7,15
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <write>:
.global write
write:
 li a7, SYS_write
 6b0:	48c1                	li	a7,16
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6b8:	48c5                	li	a7,17
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6c0:	48c9                	li	a7,18
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <link>:
.global link
link:
 li a7, SYS_link
 6c8:	48cd                	li	a7,19
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6d0:	48d1                	li	a7,20
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <close>:
.global close
close:
 li a7, SYS_close
 6d8:	48d5                	li	a7,21
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
 6e0:	48d9                	li	a7,22
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
 6e8:	48dd                	li	a7,23
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <meminfo>:
.global meminfo
meminfo:
 li a7, SYS_meminfo
 6f0:	48e1                	li	a7,24
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 6f8:	48e5                	li	a7,25
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 700:	1101                	addi	sp,sp,-32
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 70c:	4605                	li	a2,1
 70e:	fef40593          	addi	a1,s0,-17
 712:	f9fff0ef          	jal	6b0 <write>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6105                	addi	sp,sp,32
 71c:	8082                	ret

000000000000071e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 71e:	7139                	addi	sp,sp,-64
 720:	fc06                	sd	ra,56(sp)
 722:	f822                	sd	s0,48(sp)
 724:	f04a                	sd	s2,32(sp)
 726:	ec4e                	sd	s3,24(sp)
 728:	0080                	addi	s0,sp,64
 72a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 72c:	cac9                	beqz	a3,7be <printint+0xa0>
 72e:	01f5d79b          	srliw	a5,a1,0x1f
 732:	c7d1                	beqz	a5,7be <printint+0xa0>
    neg = 1;
    x = -xx;
 734:	40b005bb          	negw	a1,a1
    neg = 1;
 738:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 73a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 73e:	86ce                	mv	a3,s3
  i = 0;
 740:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 742:	00000817          	auipc	a6,0x0
 746:	74680813          	addi	a6,a6,1862 # e88 <digits>
 74a:	88ba                	mv	a7,a4
 74c:	0017051b          	addiw	a0,a4,1
 750:	872a                	mv	a4,a0
 752:	02c5f7bb          	remuw	a5,a1,a2
 756:	1782                	slli	a5,a5,0x20
 758:	9381                	srli	a5,a5,0x20
 75a:	97c2                	add	a5,a5,a6
 75c:	0007c783          	lbu	a5,0(a5)
 760:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 764:	87ae                	mv	a5,a1
 766:	02c5d5bb          	divuw	a1,a1,a2
 76a:	0685                	addi	a3,a3,1
 76c:	fcc7ffe3          	bgeu	a5,a2,74a <printint+0x2c>
  if(neg)
 770:	00030c63          	beqz	t1,788 <printint+0x6a>
    buf[i++] = '-';
 774:	fd050793          	addi	a5,a0,-48
 778:	00878533          	add	a0,a5,s0
 77c:	02d00793          	li	a5,45
 780:	fef50823          	sb	a5,-16(a0)
 784:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 788:	02e05563          	blez	a4,7b2 <printint+0x94>
 78c:	f426                	sd	s1,40(sp)
 78e:	377d                	addiw	a4,a4,-1
 790:	00e984b3          	add	s1,s3,a4
 794:	19fd                	addi	s3,s3,-1
 796:	99ba                	add	s3,s3,a4
 798:	1702                	slli	a4,a4,0x20
 79a:	9301                	srli	a4,a4,0x20
 79c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7a0:	0004c583          	lbu	a1,0(s1)
 7a4:	854a                	mv	a0,s2
 7a6:	f5bff0ef          	jal	700 <putc>
  while(--i >= 0)
 7aa:	14fd                	addi	s1,s1,-1
 7ac:	ff349ae3          	bne	s1,s3,7a0 <printint+0x82>
 7b0:	74a2                	ld	s1,40(sp)
}
 7b2:	70e2                	ld	ra,56(sp)
 7b4:	7442                	ld	s0,48(sp)
 7b6:	7902                	ld	s2,32(sp)
 7b8:	69e2                	ld	s3,24(sp)
 7ba:	6121                	addi	sp,sp,64
 7bc:	8082                	ret
  neg = 0;
 7be:	4301                	li	t1,0
 7c0:	bfad                	j	73a <printint+0x1c>

00000000000007c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c2:	711d                	addi	sp,sp,-96
 7c4:	ec86                	sd	ra,88(sp)
 7c6:	e8a2                	sd	s0,80(sp)
 7c8:	e4a6                	sd	s1,72(sp)
 7ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7cc:	0005c483          	lbu	s1,0(a1)
 7d0:	20048963          	beqz	s1,9e2 <vprintf+0x220>
 7d4:	e0ca                	sd	s2,64(sp)
 7d6:	fc4e                	sd	s3,56(sp)
 7d8:	f852                	sd	s4,48(sp)
 7da:	f456                	sd	s5,40(sp)
 7dc:	f05a                	sd	s6,32(sp)
 7de:	ec5e                	sd	s7,24(sp)
 7e0:	e862                	sd	s8,16(sp)
 7e2:	8b2a                	mv	s6,a0
 7e4:	8a2e                	mv	s4,a1
 7e6:	8bb2                	mv	s7,a2
  state = 0;
 7e8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7ea:	4901                	li	s2,0
 7ec:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7ee:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7f2:	06400c13          	li	s8,100
 7f6:	a00d                	j	818 <vprintf+0x56>
        putc(fd, c0);
 7f8:	85a6                	mv	a1,s1
 7fa:	855a                	mv	a0,s6
 7fc:	f05ff0ef          	jal	700 <putc>
 800:	a019                	j	806 <vprintf+0x44>
    } else if(state == '%'){
 802:	03598363          	beq	s3,s5,828 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 806:	0019079b          	addiw	a5,s2,1
 80a:	893e                	mv	s2,a5
 80c:	873e                	mv	a4,a5
 80e:	97d2                	add	a5,a5,s4
 810:	0007c483          	lbu	s1,0(a5)
 814:	1c048063          	beqz	s1,9d4 <vprintf+0x212>
    c0 = fmt[i] & 0xff;
 818:	0004879b          	sext.w	a5,s1
    if(state == 0){
 81c:	fe0993e3          	bnez	s3,802 <vprintf+0x40>
      if(c0 == '%'){
 820:	fd579ce3          	bne	a5,s5,7f8 <vprintf+0x36>
        state = '%';
 824:	89be                	mv	s3,a5
 826:	b7c5                	j	806 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 828:	00ea06b3          	add	a3,s4,a4
 82c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 830:	1a060e63          	beqz	a2,9ec <vprintf+0x22a>
      if(c0 == 'd'){
 834:	03878763          	beq	a5,s8,862 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 838:	f9478693          	addi	a3,a5,-108
 83c:	0016b693          	seqz	a3,a3
 840:	f9c60593          	addi	a1,a2,-100
 844:	e99d                	bnez	a1,87a <vprintf+0xb8>
 846:	ca95                	beqz	a3,87a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 848:	008b8493          	addi	s1,s7,8
 84c:	4685                	li	a3,1
 84e:	4629                	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	ec9ff0ef          	jal	71e <printint>
        i += 1;
 85a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 85c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 85e:	4981                	li	s3,0
 860:	b75d                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 862:	008b8493          	addi	s1,s7,8
 866:	4685                	li	a3,1
 868:	4629                	li	a2,10
 86a:	000ba583          	lw	a1,0(s7)
 86e:	855a                	mv	a0,s6
 870:	eafff0ef          	jal	71e <printint>
 874:	8ba6                	mv	s7,s1
      state = 0;
 876:	4981                	li	s3,0
 878:	b779                	j	806 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 87a:	9752                	add	a4,a4,s4
 87c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 880:	f9460713          	addi	a4,a2,-108
 884:	00173713          	seqz	a4,a4
 888:	8f75                	and	a4,a4,a3
 88a:	f9c58513          	addi	a0,a1,-100
 88e:	16051963          	bnez	a0,a00 <vprintf+0x23e>
 892:	16070763          	beqz	a4,a00 <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 896:	008b8493          	addi	s1,s7,8
 89a:	4685                	li	a3,1
 89c:	4629                	li	a2,10
 89e:	000ba583          	lw	a1,0(s7)
 8a2:	855a                	mv	a0,s6
 8a4:	e7bff0ef          	jal	71e <printint>
        i += 2;
 8a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8aa:	8ba6                	mv	s7,s1
      state = 0;
 8ac:	4981                	li	s3,0
        i += 2;
 8ae:	bfa1                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
 8b0:	008b8493          	addi	s1,s7,8
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	000ba583          	lw	a1,0(s7)
 8bc:	855a                	mv	a0,s6
 8be:	e61ff0ef          	jal	71e <printint>
 8c2:	8ba6                	mv	s7,s1
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	b781                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	008b8493          	addi	s1,s7,8
 8cc:	4681                	li	a3,0
 8ce:	4629                	li	a2,10
 8d0:	000ba583          	lw	a1,0(s7)
 8d4:	855a                	mv	a0,s6
 8d6:	e49ff0ef          	jal	71e <printint>
        i += 1;
 8da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8dc:	8ba6                	mv	s7,s1
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	b71d                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e2:	008b8493          	addi	s1,s7,8
 8e6:	4681                	li	a3,0
 8e8:	4629                	li	a2,10
 8ea:	000ba583          	lw	a1,0(s7)
 8ee:	855a                	mv	a0,s6
 8f0:	e2fff0ef          	jal	71e <printint>
        i += 2;
 8f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f6:	8ba6                	mv	s7,s1
      state = 0;
 8f8:	4981                	li	s3,0
        i += 2;
 8fa:	b731                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 8fc:	008b8493          	addi	s1,s7,8
 900:	4681                	li	a3,0
 902:	4641                	li	a2,16
 904:	000ba583          	lw	a1,0(s7)
 908:	855a                	mv	a0,s6
 90a:	e15ff0ef          	jal	71e <printint>
 90e:	8ba6                	mv	s7,s1
      state = 0;
 910:	4981                	li	s3,0
 912:	bdd5                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 914:	008b8493          	addi	s1,s7,8
 918:	4681                	li	a3,0
 91a:	4641                	li	a2,16
 91c:	000ba583          	lw	a1,0(s7)
 920:	855a                	mv	a0,s6
 922:	dfdff0ef          	jal	71e <printint>
        i += 1;
 926:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 928:	8ba6                	mv	s7,s1
      state = 0;
 92a:	4981                	li	s3,0
 92c:	bde9                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 92e:	008b8493          	addi	s1,s7,8
 932:	4681                	li	a3,0
 934:	4641                	li	a2,16
 936:	000ba583          	lw	a1,0(s7)
 93a:	855a                	mv	a0,s6
 93c:	de3ff0ef          	jal	71e <printint>
        i += 2;
 940:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 942:	8ba6                	mv	s7,s1
      state = 0;
 944:	4981                	li	s3,0
        i += 2;
 946:	b5c1                	j	806 <vprintf+0x44>
 948:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 94a:	008b8793          	addi	a5,s7,8
 94e:	8cbe                	mv	s9,a5
 950:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 954:	03000593          	li	a1,48
 958:	855a                	mv	a0,s6
 95a:	da7ff0ef          	jal	700 <putc>
  putc(fd, 'x');
 95e:	07800593          	li	a1,120
 962:	855a                	mv	a0,s6
 964:	d9dff0ef          	jal	700 <putc>
 968:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 96a:	00000b97          	auipc	s7,0x0
 96e:	51eb8b93          	addi	s7,s7,1310 # e88 <digits>
 972:	03c9d793          	srli	a5,s3,0x3c
 976:	97de                	add	a5,a5,s7
 978:	0007c583          	lbu	a1,0(a5)
 97c:	855a                	mv	a0,s6
 97e:	d83ff0ef          	jal	700 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 982:	0992                	slli	s3,s3,0x4
 984:	34fd                	addiw	s1,s1,-1
 986:	f4f5                	bnez	s1,972 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 988:	8be6                	mv	s7,s9
      state = 0;
 98a:	4981                	li	s3,0
 98c:	6ca2                	ld	s9,8(sp)
 98e:	bda5                	j	806 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 990:	008b8993          	addi	s3,s7,8
 994:	000bb483          	ld	s1,0(s7)
 998:	cc91                	beqz	s1,9b4 <vprintf+0x1f2>
        for(; *s; s++)
 99a:	0004c583          	lbu	a1,0(s1)
 99e:	c985                	beqz	a1,9ce <vprintf+0x20c>
          putc(fd, *s);
 9a0:	855a                	mv	a0,s6
 9a2:	d5fff0ef          	jal	700 <putc>
        for(; *s; s++)
 9a6:	0485                	addi	s1,s1,1
 9a8:	0004c583          	lbu	a1,0(s1)
 9ac:	f9f5                	bnez	a1,9a0 <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
 9ae:	8bce                	mv	s7,s3
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	bd91                	j	806 <vprintf+0x44>
          s = "(null)";
 9b4:	00000497          	auipc	s1,0x0
 9b8:	4cc48493          	addi	s1,s1,1228 # e80 <malloc+0x338>
        for(; *s; s++)
 9bc:	02800593          	li	a1,40
 9c0:	b7c5                	j	9a0 <vprintf+0x1de>
        putc(fd, '%');
 9c2:	85be                	mv	a1,a5
 9c4:	855a                	mv	a0,s6
 9c6:	d3bff0ef          	jal	700 <putc>
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	bd2d                	j	806 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 9ce:	8bce                	mv	s7,s3
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	bd15                	j	806 <vprintf+0x44>
 9d4:	6906                	ld	s2,64(sp)
 9d6:	79e2                	ld	s3,56(sp)
 9d8:	7a42                	ld	s4,48(sp)
 9da:	7aa2                	ld	s5,40(sp)
 9dc:	7b02                	ld	s6,32(sp)
 9de:	6be2                	ld	s7,24(sp)
 9e0:	6c42                	ld	s8,16(sp)
    }
  }
}
 9e2:	60e6                	ld	ra,88(sp)
 9e4:	6446                	ld	s0,80(sp)
 9e6:	64a6                	ld	s1,72(sp)
 9e8:	6125                	addi	sp,sp,96
 9ea:	8082                	ret
      if(c0 == 'd'){
 9ec:	06400713          	li	a4,100
 9f0:	e6e789e3          	beq	a5,a4,862 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 9f4:	f9478693          	addi	a3,a5,-108
 9f8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 9fc:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9fe:	4701                	li	a4,0
      } else if(c0 == 'u'){
 a00:	07500513          	li	a0,117
 a04:	eaa786e3          	beq	a5,a0,8b0 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 a08:	f8b60513          	addi	a0,a2,-117
 a0c:	e119                	bnez	a0,a12 <vprintf+0x250>
 a0e:	ea069de3          	bnez	a3,8c8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a12:	f8b58513          	addi	a0,a1,-117
 a16:	e119                	bnez	a0,a1c <vprintf+0x25a>
 a18:	ec0715e3          	bnez	a4,8e2 <vprintf+0x120>
      } else if(c0 == 'x'){
 a1c:	07800513          	li	a0,120
 a20:	eca78ee3          	beq	a5,a0,8fc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 a24:	f8860613          	addi	a2,a2,-120
 a28:	e219                	bnez	a2,a2e <vprintf+0x26c>
 a2a:	ee0695e3          	bnez	a3,914 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a2e:	f8858593          	addi	a1,a1,-120
 a32:	e199                	bnez	a1,a38 <vprintf+0x276>
 a34:	ee071de3          	bnez	a4,92e <vprintf+0x16c>
      } else if(c0 == 'p'){
 a38:	07000713          	li	a4,112
 a3c:	f0e786e3          	beq	a5,a4,948 <vprintf+0x186>
      } else if(c0 == 's'){
 a40:	07300713          	li	a4,115
 a44:	f4e786e3          	beq	a5,a4,990 <vprintf+0x1ce>
      } else if(c0 == '%'){
 a48:	02500713          	li	a4,37
 a4c:	f6e78be3          	beq	a5,a4,9c2 <vprintf+0x200>
        putc(fd, '%');
 a50:	02500593          	li	a1,37
 a54:	855a                	mv	a0,s6
 a56:	cabff0ef          	jal	700 <putc>
        putc(fd, c0);
 a5a:	85a6                	mv	a1,s1
 a5c:	855a                	mv	a0,s6
 a5e:	ca3ff0ef          	jal	700 <putc>
      state = 0;
 a62:	4981                	li	s3,0
 a64:	b34d                	j	806 <vprintf+0x44>

0000000000000a66 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a66:	715d                	addi	sp,sp,-80
 a68:	ec06                	sd	ra,24(sp)
 a6a:	e822                	sd	s0,16(sp)
 a6c:	1000                	addi	s0,sp,32
 a6e:	e010                	sd	a2,0(s0)
 a70:	e414                	sd	a3,8(s0)
 a72:	e818                	sd	a4,16(s0)
 a74:	ec1c                	sd	a5,24(s0)
 a76:	03043023          	sd	a6,32(s0)
 a7a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a7e:	8622                	mv	a2,s0
 a80:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a84:	d3fff0ef          	jal	7c2 <vprintf>
}
 a88:	60e2                	ld	ra,24(sp)
 a8a:	6442                	ld	s0,16(sp)
 a8c:	6161                	addi	sp,sp,80
 a8e:	8082                	ret

0000000000000a90 <printf>:

void
printf(const char *fmt, ...)
{
 a90:	711d                	addi	sp,sp,-96
 a92:	ec06                	sd	ra,24(sp)
 a94:	e822                	sd	s0,16(sp)
 a96:	1000                	addi	s0,sp,32
 a98:	e40c                	sd	a1,8(s0)
 a9a:	e810                	sd	a2,16(s0)
 a9c:	ec14                	sd	a3,24(s0)
 a9e:	f018                	sd	a4,32(s0)
 aa0:	f41c                	sd	a5,40(s0)
 aa2:	03043823          	sd	a6,48(s0)
 aa6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aaa:	00840613          	addi	a2,s0,8
 aae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ab2:	85aa                	mv	a1,a0
 ab4:	4505                	li	a0,1
 ab6:	d0dff0ef          	jal	7c2 <vprintf>
}
 aba:	60e2                	ld	ra,24(sp)
 abc:	6442                	ld	s0,16(sp)
 abe:	6125                	addi	sp,sp,96
 ac0:	8082                	ret

0000000000000ac2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac2:	1141                	addi	sp,sp,-16
 ac4:	e406                	sd	ra,8(sp)
 ac6:	e022                	sd	s0,0(sp)
 ac8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	00001797          	auipc	a5,0x1
 ad2:	53a7b783          	ld	a5,1338(a5) # 2008 <freep>
 ad6:	a039                	j	ae4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad8:	6398                	ld	a4,0(a5)
 ada:	00e7e463          	bltu	a5,a4,ae2 <free+0x20>
 ade:	00e6ea63          	bltu	a3,a4,af2 <free+0x30>
{
 ae2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae4:	fed7fae3          	bgeu	a5,a3,ad8 <free+0x16>
 ae8:	6398                	ld	a4,0(a5)
 aea:	00e6e463          	bltu	a3,a4,af2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aee:	fee7eae3          	bltu	a5,a4,ae2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af2:	ff852583          	lw	a1,-8(a0)
 af6:	6390                	ld	a2,0(a5)
 af8:	02059813          	slli	a6,a1,0x20
 afc:	01c85713          	srli	a4,a6,0x1c
 b00:	9736                	add	a4,a4,a3
 b02:	02e60563          	beq	a2,a4,b2c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b06:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b0a:	4790                	lw	a2,8(a5)
 b0c:	02061593          	slli	a1,a2,0x20
 b10:	01c5d713          	srli	a4,a1,0x1c
 b14:	973e                	add	a4,a4,a5
 b16:	02e68263          	beq	a3,a4,b3a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b1a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b1c:	00001717          	auipc	a4,0x1
 b20:	4ef73623          	sd	a5,1260(a4) # 2008 <freep>
}
 b24:	60a2                	ld	ra,8(sp)
 b26:	6402                	ld	s0,0(sp)
 b28:	0141                	addi	sp,sp,16
 b2a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 b2c:	4618                	lw	a4,8(a2)
 b2e:	9f2d                	addw	a4,a4,a1
 b30:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b34:	6398                	ld	a4,0(a5)
 b36:	6310                	ld	a2,0(a4)
 b38:	b7f9                	j	b06 <free+0x44>
    p->s.size += bp->s.size;
 b3a:	ff852703          	lw	a4,-8(a0)
 b3e:	9f31                	addw	a4,a4,a2
 b40:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b42:	ff053683          	ld	a3,-16(a0)
 b46:	bfd1                	j	b1a <free+0x58>

0000000000000b48 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b48:	7139                	addi	sp,sp,-64
 b4a:	fc06                	sd	ra,56(sp)
 b4c:	f822                	sd	s0,48(sp)
 b4e:	f04a                	sd	s2,32(sp)
 b50:	ec4e                	sd	s3,24(sp)
 b52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b54:	02051993          	slli	s3,a0,0x20
 b58:	0209d993          	srli	s3,s3,0x20
 b5c:	09bd                	addi	s3,s3,15
 b5e:	0049d993          	srli	s3,s3,0x4
 b62:	2985                	addiw	s3,s3,1
 b64:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b66:	00001517          	auipc	a0,0x1
 b6a:	4a253503          	ld	a0,1186(a0) # 2008 <freep>
 b6e:	c905                	beqz	a0,b9e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b70:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b72:	4798                	lw	a4,8(a5)
 b74:	09377663          	bgeu	a4,s3,c00 <malloc+0xb8>
 b78:	f426                	sd	s1,40(sp)
 b7a:	e852                	sd	s4,16(sp)
 b7c:	e456                	sd	s5,8(sp)
 b7e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b80:	8a4e                	mv	s4,s3
 b82:	6705                	lui	a4,0x1
 b84:	00e9f363          	bgeu	s3,a4,b8a <malloc+0x42>
 b88:	6a05                	lui	s4,0x1
 b8a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b8e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b92:	00001497          	auipc	s1,0x1
 b96:	47648493          	addi	s1,s1,1142 # 2008 <freep>
  if(p == (char*)-1)
 b9a:	5afd                	li	s5,-1
 b9c:	a83d                	j	bda <malloc+0x92>
 b9e:	f426                	sd	s1,40(sp)
 ba0:	e852                	sd	s4,16(sp)
 ba2:	e456                	sd	s5,8(sp)
 ba4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ba6:	00001797          	auipc	a5,0x1
 baa:	46a78793          	addi	a5,a5,1130 # 2010 <base>
 bae:	00001717          	auipc	a4,0x1
 bb2:	44f73d23          	sd	a5,1114(a4) # 2008 <freep>
 bb6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bb8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bbc:	b7d1                	j	b80 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 bbe:	6398                	ld	a4,0(a5)
 bc0:	e118                	sd	a4,0(a0)
 bc2:	a899                	j	c18 <malloc+0xd0>
  hp->s.size = nu;
 bc4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc8:	0541                	addi	a0,a0,16
 bca:	ef9ff0ef          	jal	ac2 <free>
  return freep;
 bce:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 bd0:	c125                	beqz	a0,c30 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd4:	4798                	lw	a4,8(a5)
 bd6:	03277163          	bgeu	a4,s2,bf8 <malloc+0xb0>
    if(p == freep)
 bda:	6098                	ld	a4,0(s1)
 bdc:	853e                	mv	a0,a5
 bde:	fef71ae3          	bne	a4,a5,bd2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 be2:	8552                	mv	a0,s4
 be4:	aadff0ef          	jal	690 <sbrk>
  if(p == (char*)-1)
 be8:	fd551ee3          	bne	a0,s5,bc4 <malloc+0x7c>
        return 0;
 bec:	4501                	li	a0,0
 bee:	74a2                	ld	s1,40(sp)
 bf0:	6a42                	ld	s4,16(sp)
 bf2:	6aa2                	ld	s5,8(sp)
 bf4:	6b02                	ld	s6,0(sp)
 bf6:	a03d                	j	c24 <malloc+0xdc>
 bf8:	74a2                	ld	s1,40(sp)
 bfa:	6a42                	ld	s4,16(sp)
 bfc:	6aa2                	ld	s5,8(sp)
 bfe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c00:	fae90fe3          	beq	s2,a4,bbe <malloc+0x76>
        p->s.size -= nunits;
 c04:	4137073b          	subw	a4,a4,s3
 c08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c0a:	02071693          	slli	a3,a4,0x20
 c0e:	01c6d713          	srli	a4,a3,0x1c
 c12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c18:	00001717          	auipc	a4,0x1
 c1c:	3ea73823          	sd	a0,1008(a4) # 2008 <freep>
      return (void*)(p + 1);
 c20:	01078513          	addi	a0,a5,16
  }
}
 c24:	70e2                	ld	ra,56(sp)
 c26:	7442                	ld	s0,48(sp)
 c28:	7902                	ld	s2,32(sp)
 c2a:	69e2                	ld	s3,24(sp)
 c2c:	6121                	addi	sp,sp,64
 c2e:	8082                	ret
 c30:	74a2                	ld	s1,40(sp)
 c32:	6a42                	ld	s4,16(sp)
 c34:	6aa2                	ld	s5,8(sp)
 c36:	6b02                	ld	s6,0(sp)
 c38:	b7f5                	j	c24 <malloc+0xdc>
