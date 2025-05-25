
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	22e58593          	addi	a1,a1,558 # 1240 <malloc+0xfe>
      1a:	8532                	mv	a0,a2
      1c:	497000ef          	jal	cb2 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	21f000ef          	jal	a44 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	265000ef          	jal	a92 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	1fc58593          	addi	a1,a1,508 # 1250 <malloc+0x10e>
      5c:	4509                	li	a0,2
      5e:	002010ef          	jal	1060 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	3df000ef          	jal	c42 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	3cb000ef          	jal	c3a <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	1d650513          	addi	a0,a0,470 # 1258 <malloc+0x116>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2ae70713          	addi	a4,a4,686 # 1358 <malloc+0x216>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	385000ef          	jal	c42 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	19e50513          	addi	a0,a0,414 # 1260 <malloc+0x11e>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	395000ef          	jal	c6a <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	18c58593          	addi	a1,a1,396 # 1268 <malloc+0x126>
      e4:	4509                	li	a0,2
      e6:	77b000ef          	jal	1060 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	357000ef          	jal	c42 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	351000ef          	jal	c42 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	3e3000ef          	jal	cda <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3ab000ef          	jal	caa <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	16858593          	addi	a1,a1,360 # 1278 <malloc+0x136>
     118:	4509                	li	a0,2
     11a:	747000ef          	jal	1060 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	323000ef          	jal	c42 <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	319000ef          	jal	c4a <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	313000ef          	jal	c52 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	38b000ef          	jal	cda <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	32b000ef          	jal	c82 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	37b000ef          	jal	cda <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	373000ef          	jal	cda <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	11650513          	addi	a0,a0,278 # 1288 <malloc+0x146>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	357000ef          	jal	cda <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	2f7000ef          	jal	c82 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	347000ef          	jal	cda <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	33f000ef          	jal	cda <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	331000ef          	jal	cda <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	329000ef          	jal	cda <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	293000ef          	jal	c4a <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	28d000ef          	jal	c4a <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	763000ef          	jal	1142 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	059000ef          	jal	a44 <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	892a                	mv	s2,a0
     216:	89ae                	mv	s3,a1
     218:	8a32                	mv	s4,a2
     21a:	8ab6                	mv	s5,a3
     21c:	8b3a                	mv	s6,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	721000ef          	jal	1142 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	017000ef          	jal	a44 <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0124b423          	sd	s2,8(s1)
  cmd->file = file;
     23a:	0134b823          	sd	s3,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0354a023          	sw	s5,32(s1)
  cmd->fd = fd;
     246:	0364a223          	sw	s6,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	892a                	mv	s2,a0
     270:	89ae                	mv	s3,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	6cf000ef          	jal	1142 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7c6000ef          	jal	a44 <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     28a:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	892a                	mv	s2,a0
     2ae:	89ae                	mv	s3,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	691000ef          	jal	1142 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	788000ef          	jal	a44 <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     2c8:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	657000ef          	jal	1142 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	74e000ef          	jal	a44 <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	72a000ef          	jal	a6a <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76563          	bltu	a4,a5,3ec <gettoken+0xdc>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6c8000ef          	jal	a6a <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	00e79b63          	bne	a5,a4,3e4 <gettoken+0xd4>
    if(*s == '>'){
     3d2:	0014c703          	lbu	a4,1(s1)
     3d6:	03e00793          	li	a5,62
     3da:	04f70863          	beq	a4,a5,42a <gettoken+0x11a>
    s++;
     3de:	0485                	addi	s1,s1,1
  ret = *s;
     3e0:	8abe                	mv	s5,a5
     3e2:	b75d                	j	388 <gettoken+0x78>
  switch(*s){
     3e4:	07c00713          	li	a4,124
     3e8:	f8e78fe3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3ec:	00002997          	auipc	s3,0x2
     3f0:	c1c98993          	addi	s3,s3,-996 # 2008 <whitespace>
     3f4:	00002a97          	auipc	s5,0x2
     3f8:	c0ca8a93          	addi	s5,s5,-1012 # 2000 <symbols>
     3fc:	0524f163          	bgeu	s1,s2,43e <gettoken+0x12e>
     400:	0004c583          	lbu	a1,0(s1)
     404:	854e                	mv	a0,s3
     406:	664000ef          	jal	a6a <strchr>
     40a:	e51d                	bnez	a0,438 <gettoken+0x128>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	8556                	mv	a0,s5
     412:	658000ef          	jal	a6a <strchr>
     416:	ed11                	bnez	a0,432 <gettoken+0x122>
      s++;
     418:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     41a:	fe9913e3          	bne	s2,s1,400 <gettoken+0xf0>
  if(eq)
     41e:	84ca                	mv	s1,s2
    ret = 'a';
     420:	06100a93          	li	s5,97
  if(eq)
     424:	f60b14e3          	bnez	s6,38c <gettoken+0x7c>
     428:	b761                	j	3b0 <gettoken+0xa0>
      s++;
     42a:	0489                	addi	s1,s1,2
      ret = '+';
     42c:	02b00a93          	li	s5,43
     430:	bfa1                	j	388 <gettoken+0x78>
    ret = 'a';
     432:	06100a93          	li	s5,97
     436:	bf89                	j	388 <gettoken+0x78>
     438:	06100a93          	li	s5,97
     43c:	b7b1                	j	388 <gettoken+0x78>
     43e:	06100a93          	li	s5,97
  if(eq)
     442:	f40b15e3          	bnez	s6,38c <gettoken+0x7c>
     446:	b7ad                	j	3b0 <gettoken+0xa0>

0000000000000448 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     448:	7139                	addi	sp,sp,-64
     44a:	fc06                	sd	ra,56(sp)
     44c:	f822                	sd	s0,48(sp)
     44e:	f426                	sd	s1,40(sp)
     450:	f04a                	sd	s2,32(sp)
     452:	ec4e                	sd	s3,24(sp)
     454:	e852                	sd	s4,16(sp)
     456:	e456                	sd	s5,8(sp)
     458:	0080                	addi	s0,sp,64
     45a:	8a2a                	mv	s4,a0
     45c:	892e                	mv	s2,a1
     45e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     460:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	addi	s3,s3,-1114 # 2008 <whitespace>
     46a:	00b4fc63          	bgeu	s1,a1,482 <peek+0x3a>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	5f6000ef          	jal	a6a <strchr>
     478:	c509                	beqz	a0,482 <peek+0x3a>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9919e3          	bne	s2,s1,46e <peek+0x26>
     480:	84ca                	mv	s1,s2
  *ps = s;
     482:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     486:	0004c583          	lbu	a1,0(s1)
     48a:	4501                	li	a0,0
     48c:	e991                	bnez	a1,4a0 <peek+0x58>
}
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  return *s && strchr(toks, *s);
     4a0:	8556                	mv	a0,s5
     4a2:	5c8000ef          	jal	a6a <strchr>
     4a6:	00a03533          	snez	a0,a0
     4aa:	b7d5                	j	48e <peek+0x46>

00000000000004ac <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4ac:	7159                	addi	sp,sp,-112
     4ae:	f486                	sd	ra,104(sp)
     4b0:	f0a2                	sd	s0,96(sp)
     4b2:	eca6                	sd	s1,88(sp)
     4b4:	e8ca                	sd	s2,80(sp)
     4b6:	e4ce                	sd	s3,72(sp)
     4b8:	e0d2                	sd	s4,64(sp)
     4ba:	fc56                	sd	s5,56(sp)
     4bc:	f85a                	sd	s6,48(sp)
     4be:	f45e                	sd	s7,40(sp)
     4c0:	f062                	sd	s8,32(sp)
     4c2:	ec66                	sd	s9,24(sp)
     4c4:	1880                	addi	s0,sp,112
     4c6:	8a2a                	mv	s4,a0
     4c8:	89ae                	mv	s3,a1
     4ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4cc:	00001b17          	auipc	s6,0x1
     4d0:	de4b0b13          	addi	s6,s6,-540 # 12b0 <malloc+0x16e>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d4:	f9040c93          	addi	s9,s0,-112
     4d8:	f9840c13          	addi	s8,s0,-104
     4dc:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e0:	a00d                	j	502 <parseredirs+0x56>
      panic("missing file for redirection");
     4e2:	00001517          	auipc	a0,0x1
     4e6:	dae50513          	addi	a0,a0,-594 # 1290 <malloc+0x14e>
     4ea:	b61ff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ee:	4701                	li	a4,0
     4f0:	4681                	li	a3,0
     4f2:	f9043603          	ld	a2,-112(s0)
     4f6:	f9843583          	ld	a1,-104(s0)
     4fa:	8552                	mv	a0,s4
     4fc:	d05ff0ef          	jal	200 <redircmd>
     500:	8a2a                	mv	s4,a0
    switch(tok){
     502:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     506:	865a                	mv	a2,s6
     508:	85ca                	mv	a1,s2
     50a:	854e                	mv	a0,s3
     50c:	f3dff0ef          	jal	448 <peek>
     510:	c135                	beqz	a0,574 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     512:	4681                	li	a3,0
     514:	4601                	li	a2,0
     516:	85ca                	mv	a1,s2
     518:	854e                	mv	a0,s3
     51a:	df7ff0ef          	jal	310 <gettoken>
     51e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     520:	86e6                	mv	a3,s9
     522:	8662                	mv	a2,s8
     524:	85ca                	mv	a1,s2
     526:	854e                	mv	a0,s3
     528:	de9ff0ef          	jal	310 <gettoken>
     52c:	fb751be3          	bne	a0,s7,4e2 <parseredirs+0x36>
    switch(tok){
     530:	fb548fe3          	beq	s1,s5,4ee <parseredirs+0x42>
     534:	03e00793          	li	a5,62
     538:	02f48263          	beq	s1,a5,55c <parseredirs+0xb0>
     53c:	02b00793          	li	a5,43
     540:	fcf493e3          	bne	s1,a5,506 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     544:	4705                	li	a4,1
     546:	20100693          	li	a3,513
     54a:	f9043603          	ld	a2,-112(s0)
     54e:	f9843583          	ld	a1,-104(s0)
     552:	8552                	mv	a0,s4
     554:	cadff0ef          	jal	200 <redircmd>
     558:	8a2a                	mv	s4,a0
      break;
     55a:	b765                	j	502 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55c:	4705                	li	a4,1
     55e:	60100693          	li	a3,1537
     562:	f9043603          	ld	a2,-112(s0)
     566:	f9843583          	ld	a1,-104(s0)
     56a:	8552                	mv	a0,s4
     56c:	c95ff0ef          	jal	200 <redircmd>
     570:	8a2a                	mv	s4,a0
      break;
     572:	bf41                	j	502 <parseredirs+0x56>
    }
  }
  return cmd;
}
     574:	8552                	mv	a0,s4
     576:	70a6                	ld	ra,104(sp)
     578:	7406                	ld	s0,96(sp)
     57a:	64e6                	ld	s1,88(sp)
     57c:	6946                	ld	s2,80(sp)
     57e:	69a6                	ld	s3,72(sp)
     580:	6a06                	ld	s4,64(sp)
     582:	7ae2                	ld	s5,56(sp)
     584:	7b42                	ld	s6,48(sp)
     586:	7ba2                	ld	s7,40(sp)
     588:	7c02                	ld	s8,32(sp)
     58a:	6ce2                	ld	s9,24(sp)
     58c:	6165                	addi	sp,sp,112
     58e:	8082                	ret

0000000000000590 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     590:	7119                	addi	sp,sp,-128
     592:	fc86                	sd	ra,120(sp)
     594:	f8a2                	sd	s0,112(sp)
     596:	f4a6                	sd	s1,104(sp)
     598:	e8d2                	sd	s4,80(sp)
     59a:	e4d6                	sd	s5,72(sp)
     59c:	0100                	addi	s0,sp,128
     59e:	8a2a                	mv	s4,a0
     5a0:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a2:	00001617          	auipc	a2,0x1
     5a6:	d1660613          	addi	a2,a2,-746 # 12b8 <malloc+0x176>
     5aa:	e9fff0ef          	jal	448 <peek>
     5ae:	e121                	bnez	a0,5ee <parseexec+0x5e>
     5b0:	f0ca                	sd	s2,96(sp)
     5b2:	ecce                	sd	s3,88(sp)
     5b4:	e0da                	sd	s6,64(sp)
     5b6:	fc5e                	sd	s7,56(sp)
     5b8:	f862                	sd	s8,48(sp)
     5ba:	f466                	sd	s9,40(sp)
     5bc:	f06a                	sd	s10,32(sp)
     5be:	ec6e                	sd	s11,24(sp)
     5c0:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c2:	c11ff0ef          	jal	1d2 <execcmd>
     5c6:	89aa                	mv	s3,a0
     5c8:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5ca:	8656                	mv	a2,s5
     5cc:	85d2                	mv	a1,s4
     5ce:	edfff0ef          	jal	4ac <parseredirs>
     5d2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d4:	09a1                	addi	s3,s3,8
     5d6:	00001b17          	auipc	s6,0x1
     5da:	d02b0b13          	addi	s6,s6,-766 # 12d8 <malloc+0x196>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5de:	f8040c13          	addi	s8,s0,-128
     5e2:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5e6:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ea:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5ec:	a81d                	j	622 <parseexec+0x92>
    return parseblock(ps, es);
     5ee:	85d6                	mv	a1,s5
     5f0:	8552                	mv	a0,s4
     5f2:	178000ef          	jal	76a <parseblock>
     5f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5f8:	8526                	mv	a0,s1
     5fa:	70e6                	ld	ra,120(sp)
     5fc:	7446                	ld	s0,112(sp)
     5fe:	74a6                	ld	s1,104(sp)
     600:	6a46                	ld	s4,80(sp)
     602:	6aa6                	ld	s5,72(sp)
     604:	6109                	addi	sp,sp,128
     606:	8082                	ret
      panic("syntax");
     608:	00001517          	auipc	a0,0x1
     60c:	cb850513          	addi	a0,a0,-840 # 12c0 <malloc+0x17e>
     610:	a3bff0ef          	jal	4a <panic>
    if(argc >= MAXARGS)
     614:	09a1                	addi	s3,s3,8
    ret = parseredirs(ret, ps, es);
     616:	8656                	mv	a2,s5
     618:	85d2                	mv	a1,s4
     61a:	8526                	mv	a0,s1
     61c:	e91ff0ef          	jal	4ac <parseredirs>
     620:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     622:	865a                	mv	a2,s6
     624:	85d6                	mv	a1,s5
     626:	8552                	mv	a0,s4
     628:	e21ff0ef          	jal	448 <peek>
     62c:	e91d                	bnez	a0,662 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     62e:	86e2                	mv	a3,s8
     630:	865e                	mv	a2,s7
     632:	85d6                	mv	a1,s5
     634:	8552                	mv	a0,s4
     636:	cdbff0ef          	jal	310 <gettoken>
     63a:	c505                	beqz	a0,662 <parseexec+0xd2>
    if(tok != 'a')
     63c:	fda516e3          	bne	a0,s10,608 <parseexec+0x78>
    cmd->argv[argc] = q;
     640:	f8843783          	ld	a5,-120(s0)
     644:	00f9b023          	sd	a5,0(s3)
    cmd->eargv[argc] = eq;
     648:	f8043783          	ld	a5,-128(s0)
     64c:	04f9b823          	sd	a5,80(s3)
    argc++;
     650:	2905                	addiw	s2,s2,1
    if(argc >= MAXARGS)
     652:	fd9911e3          	bne	s2,s9,614 <parseexec+0x84>
      panic("too many args");
     656:	00001517          	auipc	a0,0x1
     65a:	c7250513          	addi	a0,a0,-910 # 12c8 <malloc+0x186>
     65e:	9edff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     662:	090e                	slli	s2,s2,0x3
     664:	012d87b3          	add	a5,s11,s2
     668:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     66c:	0407bc23          	sd	zero,88(a5)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6b06                	ld	s6,64(sp)
     676:	7be2                	ld	s7,56(sp)
     678:	7c42                	ld	s8,48(sp)
     67a:	7ca2                	ld	s9,40(sp)
     67c:	7d02                	ld	s10,32(sp)
     67e:	6de2                	ld	s11,24(sp)
  return ret;
     680:	bfa5                	j	5f8 <parseexec+0x68>

0000000000000682 <parsepipe>:
{
     682:	7179                	addi	sp,sp,-48
     684:	f406                	sd	ra,40(sp)
     686:	f022                	sd	s0,32(sp)
     688:	ec26                	sd	s1,24(sp)
     68a:	e84a                	sd	s2,16(sp)
     68c:	e44e                	sd	s3,8(sp)
     68e:	e052                	sd	s4,0(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	8a2a                	mv	s4,a0
     696:	84ae                	mv	s1,a1
  cmd = parseexec(ps, es);
     698:	ef9ff0ef          	jal	590 <parseexec>
     69c:	89aa                	mv	s3,a0
  if(peek(ps, es, "|")){
     69e:	00001617          	auipc	a2,0x1
     6a2:	c4260613          	addi	a2,a2,-958 # 12e0 <malloc+0x19e>
     6a6:	85a6                	mv	a1,s1
     6a8:	854a                	mv	a0,s2
     6aa:	d9fff0ef          	jal	448 <peek>
     6ae:	e911                	bnez	a0,6c2 <parsepipe+0x40>
}
     6b0:	854e                	mv	a0,s3
     6b2:	70a2                	ld	ra,40(sp)
     6b4:	7402                	ld	s0,32(sp)
     6b6:	64e2                	ld	s1,24(sp)
     6b8:	6942                	ld	s2,16(sp)
     6ba:	69a2                	ld	s3,8(sp)
     6bc:	6a02                	ld	s4,0(sp)
     6be:	6145                	addi	sp,sp,48
     6c0:	8082                	ret
    gettoken(ps, es, 0, 0);
     6c2:	4681                	li	a3,0
     6c4:	4601                	li	a2,0
     6c6:	85a6                	mv	a1,s1
     6c8:	8552                	mv	a0,s4
     6ca:	c47ff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ce:	85a6                	mv	a1,s1
     6d0:	8552                	mv	a0,s4
     6d2:	fb1ff0ef          	jal	682 <parsepipe>
     6d6:	85aa                	mv	a1,a0
     6d8:	854e                	mv	a0,s3
     6da:	b87ff0ef          	jal	260 <pipecmd>
     6de:	89aa                	mv	s3,a0
  return cmd;
     6e0:	bfc1                	j	6b0 <parsepipe+0x2e>

00000000000006e2 <parseline>:
{
     6e2:	7179                	addi	sp,sp,-48
     6e4:	f406                	sd	ra,40(sp)
     6e6:	f022                	sd	s0,32(sp)
     6e8:	ec26                	sd	s1,24(sp)
     6ea:	e84a                	sd	s2,16(sp)
     6ec:	e44e                	sd	s3,8(sp)
     6ee:	e052                	sd	s4,0(sp)
     6f0:	1800                	addi	s0,sp,48
     6f2:	892a                	mv	s2,a0
     6f4:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f6:	f8dff0ef          	jal	682 <parsepipe>
     6fa:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6fc:	00001a17          	auipc	s4,0x1
     700:	beca0a13          	addi	s4,s4,-1044 # 12e8 <malloc+0x1a6>
     704:	a819                	j	71a <parseline+0x38>
    gettoken(ps, es, 0, 0);
     706:	4681                	li	a3,0
     708:	4601                	li	a2,0
     70a:	85ce                	mv	a1,s3
     70c:	854a                	mv	a0,s2
     70e:	c03ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     712:	8526                	mv	a0,s1
     714:	bc9ff0ef          	jal	2dc <backcmd>
     718:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     71a:	8652                	mv	a2,s4
     71c:	85ce                	mv	a1,s3
     71e:	854a                	mv	a0,s2
     720:	d29ff0ef          	jal	448 <peek>
     724:	f16d                	bnez	a0,706 <parseline+0x24>
  if(peek(ps, es, ";")){
     726:	00001617          	auipc	a2,0x1
     72a:	bca60613          	addi	a2,a2,-1078 # 12f0 <malloc+0x1ae>
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	d17ff0ef          	jal	448 <peek>
     736:	e911                	bnez	a0,74a <parseline+0x68>
}
     738:	8526                	mv	a0,s1
     73a:	70a2                	ld	ra,40(sp)
     73c:	7402                	ld	s0,32(sp)
     73e:	64e2                	ld	s1,24(sp)
     740:	6942                	ld	s2,16(sp)
     742:	69a2                	ld	s3,8(sp)
     744:	6a02                	ld	s4,0(sp)
     746:	6145                	addi	sp,sp,48
     748:	8082                	ret
    gettoken(ps, es, 0, 0);
     74a:	4681                	li	a3,0
     74c:	4601                	li	a2,0
     74e:	85ce                	mv	a1,s3
     750:	854a                	mv	a0,s2
     752:	bbfff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     756:	85ce                	mv	a1,s3
     758:	854a                	mv	a0,s2
     75a:	f89ff0ef          	jal	6e2 <parseline>
     75e:	85aa                	mv	a1,a0
     760:	8526                	mv	a0,s1
     762:	b3dff0ef          	jal	29e <listcmd>
     766:	84aa                	mv	s1,a0
  return cmd;
     768:	bfc1                	j	738 <parseline+0x56>

000000000000076a <parseblock>:
{
     76a:	7179                	addi	sp,sp,-48
     76c:	f406                	sd	ra,40(sp)
     76e:	f022                	sd	s0,32(sp)
     770:	ec26                	sd	s1,24(sp)
     772:	e84a                	sd	s2,16(sp)
     774:	e44e                	sd	s3,8(sp)
     776:	1800                	addi	s0,sp,48
     778:	84aa                	mv	s1,a0
     77a:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     77c:	00001617          	auipc	a2,0x1
     780:	b3c60613          	addi	a2,a2,-1220 # 12b8 <malloc+0x176>
     784:	cc5ff0ef          	jal	448 <peek>
     788:	c539                	beqz	a0,7d6 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7fff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     796:	85ca                	mv	a1,s2
     798:	8526                	mv	a0,s1
     79a:	f49ff0ef          	jal	6e2 <parseline>
     79e:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     7a0:	00001617          	auipc	a2,0x1
     7a4:	b6860613          	addi	a2,a2,-1176 # 1308 <malloc+0x1c6>
     7a8:	85ca                	mv	a1,s2
     7aa:	8526                	mv	a0,s1
     7ac:	c9dff0ef          	jal	448 <peek>
     7b0:	c90d                	beqz	a0,7e2 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7b2:	4681                	li	a3,0
     7b4:	4601                	li	a2,0
     7b6:	85ca                	mv	a1,s2
     7b8:	8526                	mv	a0,s1
     7ba:	b57ff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7be:	864a                	mv	a2,s2
     7c0:	85a6                	mv	a1,s1
     7c2:	854e                	mv	a0,s3
     7c4:	ce9ff0ef          	jal	4ac <parseredirs>
}
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
    panic("parseblock");
     7d6:	00001517          	auipc	a0,0x1
     7da:	b2250513          	addi	a0,a0,-1246 # 12f8 <malloc+0x1b6>
     7de:	86dff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7e2:	00001517          	auipc	a0,0x1
     7e6:	b2e50513          	addi	a0,a0,-1234 # 1310 <malloc+0x1ce>
     7ea:	861ff0ef          	jal	4a <panic>

00000000000007ee <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ee:	1101                	addi	sp,sp,-32
     7f0:	ec06                	sd	ra,24(sp)
     7f2:	e822                	sd	s0,16(sp)
     7f4:	e426                	sd	s1,8(sp)
     7f6:	1000                	addi	s0,sp,32
     7f8:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7fa:	c131                	beqz	a0,83e <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7fc:	4118                	lw	a4,0(a0)
     7fe:	4795                	li	a5,5
     800:	02e7ef63          	bltu	a5,a4,83e <nulterminate+0x50>
     804:	00056783          	lwu	a5,0(a0)
     808:	078a                	slli	a5,a5,0x2
     80a:	00001717          	auipc	a4,0x1
     80e:	b6670713          	addi	a4,a4,-1178 # 1370 <malloc+0x22e>
     812:	97ba                	add	a5,a5,a4
     814:	439c                	lw	a5,0(a5)
     816:	97ba                	add	a5,a5,a4
     818:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     81a:	651c                	ld	a5,8(a0)
     81c:	c38d                	beqz	a5,83e <nulterminate+0x50>
     81e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     822:	67b8                	ld	a4,72(a5)
     824:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     828:	07a1                	addi	a5,a5,8
     82a:	ff87b703          	ld	a4,-8(a5)
     82e:	fb75                	bnez	a4,822 <nulterminate+0x34>
     830:	a039                	j	83e <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     832:	6508                	ld	a0,8(a0)
     834:	fbbff0ef          	jal	7ee <nulterminate>
    *rcmd->efile = 0;
     838:	6c9c                	ld	a5,24(s1)
     83a:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83e:	8526                	mv	a0,s1
     840:	60e2                	ld	ra,24(sp)
     842:	6442                	ld	s0,16(sp)
     844:	64a2                	ld	s1,8(sp)
     846:	6105                	addi	sp,sp,32
     848:	8082                	ret
    nulterminate(pcmd->left);
     84a:	6508                	ld	a0,8(a0)
     84c:	fa3ff0ef          	jal	7ee <nulterminate>
    nulterminate(pcmd->right);
     850:	6888                	ld	a0,16(s1)
     852:	f9dff0ef          	jal	7ee <nulterminate>
    break;
     856:	b7e5                	j	83e <nulterminate+0x50>
    nulterminate(lcmd->left);
     858:	6508                	ld	a0,8(a0)
     85a:	f95ff0ef          	jal	7ee <nulterminate>
    nulterminate(lcmd->right);
     85e:	6888                	ld	a0,16(s1)
     860:	f8fff0ef          	jal	7ee <nulterminate>
    break;
     864:	bfe9                	j	83e <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     866:	6508                	ld	a0,8(a0)
     868:	f87ff0ef          	jal	7ee <nulterminate>
    break;
     86c:	bfc9                	j	83e <nulterminate+0x50>

000000000000086e <parsecmd>:
{
     86e:	7139                	addi	sp,sp,-64
     870:	fc06                	sd	ra,56(sp)
     872:	f822                	sd	s0,48(sp)
     874:	f426                	sd	s1,40(sp)
     876:	f04a                	sd	s2,32(sp)
     878:	ec4e                	sd	s3,24(sp)
     87a:	0080                	addi	s0,sp,64
     87c:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     880:	84aa                	mv	s1,a0
     882:	196000ef          	jal	a18 <strlen>
     886:	1502                	slli	a0,a0,0x20
     888:	9101                	srli	a0,a0,0x20
     88a:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     88c:	fc840913          	addi	s2,s0,-56
     890:	85a6                	mv	a1,s1
     892:	854a                	mv	a0,s2
     894:	e4fff0ef          	jal	6e2 <parseline>
     898:	89aa                	mv	s3,a0
  peek(&s, es, "");
     89a:	00001617          	auipc	a2,0x1
     89e:	9ae60613          	addi	a2,a2,-1618 # 1248 <malloc+0x106>
     8a2:	85a6                	mv	a1,s1
     8a4:	854a                	mv	a0,s2
     8a6:	ba3ff0ef          	jal	448 <peek>
  if(s != es){
     8aa:	fc843603          	ld	a2,-56(s0)
     8ae:	00961d63          	bne	a2,s1,8c8 <parsecmd+0x5a>
  nulterminate(cmd);
     8b2:	854e                	mv	a0,s3
     8b4:	f3bff0ef          	jal	7ee <nulterminate>
}
     8b8:	854e                	mv	a0,s3
     8ba:	70e2                	ld	ra,56(sp)
     8bc:	7442                	ld	s0,48(sp)
     8be:	74a2                	ld	s1,40(sp)
     8c0:	7902                	ld	s2,32(sp)
     8c2:	69e2                	ld	s3,24(sp)
     8c4:	6121                	addi	sp,sp,64
     8c6:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c8:	00001597          	auipc	a1,0x1
     8cc:	a6058593          	addi	a1,a1,-1440 # 1328 <malloc+0x1e6>
     8d0:	4509                	li	a0,2
     8d2:	78e000ef          	jal	1060 <fprintf>
    panic("syntax");
     8d6:	00001517          	auipc	a0,0x1
     8da:	9ea50513          	addi	a0,a0,-1558 # 12c0 <malloc+0x17e>
     8de:	f6cff0ef          	jal	4a <panic>

00000000000008e2 <main>:
{
     8e2:	7179                	addi	sp,sp,-48
     8e4:	f406                	sd	ra,40(sp)
     8e6:	f022                	sd	s0,32(sp)
     8e8:	ec26                	sd	s1,24(sp)
     8ea:	e84a                	sd	s2,16(sp)
     8ec:	e44e                	sd	s3,8(sp)
     8ee:	e052                	sd	s4,0(sp)
     8f0:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     8f2:	4489                	li	s1,2
     8f4:	00001917          	auipc	s2,0x1
     8f8:	a4490913          	addi	s2,s2,-1468 # 1338 <malloc+0x1f6>
     8fc:	85a6                	mv	a1,s1
     8fe:	854a                	mv	a0,s2
     900:	3aa000ef          	jal	caa <open>
     904:	00054663          	bltz	a0,910 <main+0x2e>
    if(fd >= 3){
     908:	fea4dae3          	bge	s1,a0,8fc <main+0x1a>
      close(fd);
     90c:	3ce000ef          	jal	cda <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     910:	06400913          	li	s2,100
     914:	00001497          	auipc	s1,0x1
     918:	70c48493          	addi	s1,s1,1804 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     91c:	06300993          	li	s3,99
     920:	02000a13          	li	s4,32
     924:	a039                	j	932 <main+0x50>
    if(fork1() == 0)
     926:	f42ff0ef          	jal	68 <fork1>
     92a:	c93d                	beqz	a0,9a0 <main+0xbe>
    wait(0);
     92c:	4501                	li	a0,0
     92e:	31c000ef          	jal	c4a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     932:	85ca                	mv	a1,s2
     934:	8526                	mv	a0,s1
     936:	ecaff0ef          	jal	0 <getcmd>
     93a:	06054b63          	bltz	a0,9b0 <main+0xce>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     93e:	0004c783          	lbu	a5,0(s1)
     942:	ff3792e3          	bne	a5,s3,926 <main+0x44>
     946:	0014c783          	lbu	a5,1(s1)
     94a:	fd279ee3          	bne	a5,s2,926 <main+0x44>
     94e:	0024c783          	lbu	a5,2(s1)
     952:	fd479ae3          	bne	a5,s4,926 <main+0x44>
      buf[strlen(buf)-1] = 0;  // chop \n
     956:	00001517          	auipc	a0,0x1
     95a:	6ca50513          	addi	a0,a0,1738 # 2020 <buf.0>
     95e:	0ba000ef          	jal	a18 <strlen>
     962:	fff5079b          	addiw	a5,a0,-1
     966:	1782                	slli	a5,a5,0x20
     968:	9381                	srli	a5,a5,0x20
     96a:	00001717          	auipc	a4,0x1
     96e:	6b670713          	addi	a4,a4,1718 # 2020 <buf.0>
     972:	97ba                	add	a5,a5,a4
     974:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     978:	00001517          	auipc	a0,0x1
     97c:	6ab50513          	addi	a0,a0,1707 # 2023 <buf.0+0x3>
     980:	2fa000ef          	jal	c7a <chdir>
     984:	fa0557e3          	bgez	a0,932 <main+0x50>
        fprintf(2, "cannot cd %s\n", buf+3);
     988:	00001617          	auipc	a2,0x1
     98c:	69b60613          	addi	a2,a2,1691 # 2023 <buf.0+0x3>
     990:	00001597          	auipc	a1,0x1
     994:	9b058593          	addi	a1,a1,-1616 # 1340 <malloc+0x1fe>
     998:	4509                	li	a0,2
     99a:	6c6000ef          	jal	1060 <fprintf>
     99e:	bf51                	j	932 <main+0x50>
      runcmd(parsecmd(buf));
     9a0:	00001517          	auipc	a0,0x1
     9a4:	68050513          	addi	a0,a0,1664 # 2020 <buf.0>
     9a8:	ec7ff0ef          	jal	86e <parsecmd>
     9ac:	ee2ff0ef          	jal	8e <runcmd>
  exit(0);
     9b0:	4501                	li	a0,0
     9b2:	290000ef          	jal	c42 <exit>

00000000000009b6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9b6:	1141                	addi	sp,sp,-16
     9b8:	e406                	sd	ra,8(sp)
     9ba:	e022                	sd	s0,0(sp)
     9bc:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9be:	f25ff0ef          	jal	8e2 <main>
  exit(0);
     9c2:	4501                	li	a0,0
     9c4:	27e000ef          	jal	c42 <exit>

00000000000009c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9c8:	1141                	addi	sp,sp,-16
     9ca:	e406                	sd	ra,8(sp)
     9cc:	e022                	sd	s0,0(sp)
     9ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9d0:	87aa                	mv	a5,a0
     9d2:	0585                	addi	a1,a1,1
     9d4:	0785                	addi	a5,a5,1
     9d6:	fff5c703          	lbu	a4,-1(a1)
     9da:	fee78fa3          	sb	a4,-1(a5)
     9de:	fb75                	bnez	a4,9d2 <strcpy+0xa>
    ;
  return os;
}
     9e0:	60a2                	ld	ra,8(sp)
     9e2:	6402                	ld	s0,0(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9f0:	00054783          	lbu	a5,0(a0)
     9f4:	cb91                	beqz	a5,a08 <strcmp+0x20>
     9f6:	0005c703          	lbu	a4,0(a1)
     9fa:	00f71763          	bne	a4,a5,a08 <strcmp+0x20>
    p++, q++;
     9fe:	0505                	addi	a0,a0,1
     a00:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a02:	00054783          	lbu	a5,0(a0)
     a06:	fbe5                	bnez	a5,9f6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a08:	0005c503          	lbu	a0,0(a1)
}
     a0c:	40a7853b          	subw	a0,a5,a0
     a10:	60a2                	ld	ra,8(sp)
     a12:	6402                	ld	s0,0(sp)
     a14:	0141                	addi	sp,sp,16
     a16:	8082                	ret

0000000000000a18 <strlen>:

uint
strlen(const char *s)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e406                	sd	ra,8(sp)
     a1c:	e022                	sd	s0,0(sp)
     a1e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a20:	00054783          	lbu	a5,0(a0)
     a24:	cf91                	beqz	a5,a40 <strlen+0x28>
     a26:	00150793          	addi	a5,a0,1
     a2a:	86be                	mv	a3,a5
     a2c:	0785                	addi	a5,a5,1
     a2e:	fff7c703          	lbu	a4,-1(a5)
     a32:	ff65                	bnez	a4,a2a <strlen+0x12>
     a34:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a38:	60a2                	ld	ra,8(sp)
     a3a:	6402                	ld	s0,0(sp)
     a3c:	0141                	addi	sp,sp,16
     a3e:	8082                	ret
  for(n = 0; s[n]; n++)
     a40:	4501                	li	a0,0
     a42:	bfdd                	j	a38 <strlen+0x20>

0000000000000a44 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a44:	1141                	addi	sp,sp,-16
     a46:	e406                	sd	ra,8(sp)
     a48:	e022                	sd	s0,0(sp)
     a4a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a4c:	ca19                	beqz	a2,a62 <memset+0x1e>
     a4e:	87aa                	mv	a5,a0
     a50:	1602                	slli	a2,a2,0x20
     a52:	9201                	srli	a2,a2,0x20
     a54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a5c:	0785                	addi	a5,a5,1
     a5e:	fee79de3          	bne	a5,a4,a58 <memset+0x14>
  }
  return dst;
}
     a62:	60a2                	ld	ra,8(sp)
     a64:	6402                	ld	s0,0(sp)
     a66:	0141                	addi	sp,sp,16
     a68:	8082                	ret

0000000000000a6a <strchr>:

char*
strchr(const char *s, char c)
{
     a6a:	1141                	addi	sp,sp,-16
     a6c:	e406                	sd	ra,8(sp)
     a6e:	e022                	sd	s0,0(sp)
     a70:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a72:	00054783          	lbu	a5,0(a0)
     a76:	cf81                	beqz	a5,a8e <strchr+0x24>
    if(*s == c)
     a78:	00f58763          	beq	a1,a5,a86 <strchr+0x1c>
  for(; *s; s++)
     a7c:	0505                	addi	a0,a0,1
     a7e:	00054783          	lbu	a5,0(a0)
     a82:	fbfd                	bnez	a5,a78 <strchr+0xe>
      return (char*)s;
  return 0;
     a84:	4501                	li	a0,0
}
     a86:	60a2                	ld	ra,8(sp)
     a88:	6402                	ld	s0,0(sp)
     a8a:	0141                	addi	sp,sp,16
     a8c:	8082                	ret
  return 0;
     a8e:	4501                	li	a0,0
     a90:	bfdd                	j	a86 <strchr+0x1c>

0000000000000a92 <gets>:

char*
gets(char *buf, int max)
{
     a92:	711d                	addi	sp,sp,-96
     a94:	ec86                	sd	ra,88(sp)
     a96:	e8a2                	sd	s0,80(sp)
     a98:	e4a6                	sd	s1,72(sp)
     a9a:	e0ca                	sd	s2,64(sp)
     a9c:	fc4e                	sd	s3,56(sp)
     a9e:	f852                	sd	s4,48(sp)
     aa0:	f456                	sd	s5,40(sp)
     aa2:	f05a                	sd	s6,32(sp)
     aa4:	ec5e                	sd	s7,24(sp)
     aa6:	e862                	sd	s8,16(sp)
     aa8:	1080                	addi	s0,sp,96
     aaa:	8baa                	mv	s7,a0
     aac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aae:	892a                	mv	s2,a0
     ab0:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ab2:	faf40b13          	addi	s6,s0,-81
     ab6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     ab8:	8c26                	mv	s8,s1
     aba:	0014899b          	addiw	s3,s1,1
     abe:	84ce                	mv	s1,s3
     ac0:	0349d463          	bge	s3,s4,ae8 <gets+0x56>
    cc = read(0, &c, 1);
     ac4:	8656                	mv	a2,s5
     ac6:	85da                	mv	a1,s6
     ac8:	4501                	li	a0,0
     aca:	190000ef          	jal	c5a <read>
    if(cc < 1)
     ace:	00a05d63          	blez	a0,ae8 <gets+0x56>
      break;
    buf[i++] = c;
     ad2:	faf44783          	lbu	a5,-81(s0)
     ad6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ada:	0905                	addi	s2,s2,1
     adc:	ff678713          	addi	a4,a5,-10
     ae0:	c319                	beqz	a4,ae6 <gets+0x54>
     ae2:	17cd                	addi	a5,a5,-13
     ae4:	fbf1                	bnez	a5,ab8 <gets+0x26>
    buf[i++] = c;
     ae6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     ae8:	9c5e                	add	s8,s8,s7
     aea:	000c0023          	sb	zero,0(s8)
  return buf;
}
     aee:	855e                	mv	a0,s7
     af0:	60e6                	ld	ra,88(sp)
     af2:	6446                	ld	s0,80(sp)
     af4:	64a6                	ld	s1,72(sp)
     af6:	6906                	ld	s2,64(sp)
     af8:	79e2                	ld	s3,56(sp)
     afa:	7a42                	ld	s4,48(sp)
     afc:	7aa2                	ld	s5,40(sp)
     afe:	7b02                	ld	s6,32(sp)
     b00:	6be2                	ld	s7,24(sp)
     b02:	6c42                	ld	s8,16(sp)
     b04:	6125                	addi	sp,sp,96
     b06:	8082                	ret

0000000000000b08 <stat>:

int
stat(const char *n, struct stat *st)
{
     b08:	1101                	addi	sp,sp,-32
     b0a:	ec06                	sd	ra,24(sp)
     b0c:	e822                	sd	s0,16(sp)
     b0e:	e04a                	sd	s2,0(sp)
     b10:	1000                	addi	s0,sp,32
     b12:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b14:	4581                	li	a1,0
     b16:	194000ef          	jal	caa <open>
  if(fd < 0)
     b1a:	02054263          	bltz	a0,b3e <stat+0x36>
     b1e:	e426                	sd	s1,8(sp)
     b20:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b22:	85ca                	mv	a1,s2
     b24:	14e000ef          	jal	c72 <fstat>
     b28:	892a                	mv	s2,a0
  close(fd);
     b2a:	8526                	mv	a0,s1
     b2c:	1ae000ef          	jal	cda <close>
  return r;
     b30:	64a2                	ld	s1,8(sp)
}
     b32:	854a                	mv	a0,s2
     b34:	60e2                	ld	ra,24(sp)
     b36:	6442                	ld	s0,16(sp)
     b38:	6902                	ld	s2,0(sp)
     b3a:	6105                	addi	sp,sp,32
     b3c:	8082                	ret
    return -1;
     b3e:	57fd                	li	a5,-1
     b40:	893e                	mv	s2,a5
     b42:	bfc5                	j	b32 <stat+0x2a>

0000000000000b44 <atoi>:

int
atoi(const char *s)
{
     b44:	1141                	addi	sp,sp,-16
     b46:	e406                	sd	ra,8(sp)
     b48:	e022                	sd	s0,0(sp)
     b4a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b4c:	00054683          	lbu	a3,0(a0)
     b50:	fd06879b          	addiw	a5,a3,-48
     b54:	0ff7f793          	zext.b	a5,a5
     b58:	4625                	li	a2,9
     b5a:	02f66963          	bltu	a2,a5,b8c <atoi+0x48>
     b5e:	872a                	mv	a4,a0
  n = 0;
     b60:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b62:	0705                	addi	a4,a4,1
     b64:	0025179b          	slliw	a5,a0,0x2
     b68:	9fa9                	addw	a5,a5,a0
     b6a:	0017979b          	slliw	a5,a5,0x1
     b6e:	9fb5                	addw	a5,a5,a3
     b70:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b74:	00074683          	lbu	a3,0(a4)
     b78:	fd06879b          	addiw	a5,a3,-48
     b7c:	0ff7f793          	zext.b	a5,a5
     b80:	fef671e3          	bgeu	a2,a5,b62 <atoi+0x1e>
  return n;
}
     b84:	60a2                	ld	ra,8(sp)
     b86:	6402                	ld	s0,0(sp)
     b88:	0141                	addi	sp,sp,16
     b8a:	8082                	ret
  n = 0;
     b8c:	4501                	li	a0,0
     b8e:	bfdd                	j	b84 <atoi+0x40>

0000000000000b90 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b90:	1141                	addi	sp,sp,-16
     b92:	e406                	sd	ra,8(sp)
     b94:	e022                	sd	s0,0(sp)
     b96:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b98:	02b57563          	bgeu	a0,a1,bc2 <memmove+0x32>
    while(n-- > 0)
     b9c:	00c05f63          	blez	a2,bba <memmove+0x2a>
     ba0:	1602                	slli	a2,a2,0x20
     ba2:	9201                	srli	a2,a2,0x20
     ba4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ba8:	872a                	mv	a4,a0
      *dst++ = *src++;
     baa:	0585                	addi	a1,a1,1
     bac:	0705                	addi	a4,a4,1
     bae:	fff5c683          	lbu	a3,-1(a1)
     bb2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bb6:	fee79ae3          	bne	a5,a4,baa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bba:	60a2                	ld	ra,8(sp)
     bbc:	6402                	ld	s0,0(sp)
     bbe:	0141                	addi	sp,sp,16
     bc0:	8082                	ret
    while(n-- > 0)
     bc2:	fec05ce3          	blez	a2,bba <memmove+0x2a>
    dst += n;
     bc6:	00c50733          	add	a4,a0,a2
    src += n;
     bca:	95b2                	add	a1,a1,a2
     bcc:	fff6079b          	addiw	a5,a2,-1
     bd0:	1782                	slli	a5,a5,0x20
     bd2:	9381                	srli	a5,a5,0x20
     bd4:	fff7c793          	not	a5,a5
     bd8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bda:	15fd                	addi	a1,a1,-1
     bdc:	177d                	addi	a4,a4,-1
     bde:	0005c683          	lbu	a3,0(a1)
     be2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     be6:	fef71ae3          	bne	a4,a5,bda <memmove+0x4a>
     bea:	bfc1                	j	bba <memmove+0x2a>

0000000000000bec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bec:	1141                	addi	sp,sp,-16
     bee:	e406                	sd	ra,8(sp)
     bf0:	e022                	sd	s0,0(sp)
     bf2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bf4:	c61d                	beqz	a2,c22 <memcmp+0x36>
     bf6:	1602                	slli	a2,a2,0x20
     bf8:	9201                	srli	a2,a2,0x20
     bfa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     bfe:	00054783          	lbu	a5,0(a0)
     c02:	0005c703          	lbu	a4,0(a1)
     c06:	00e79863          	bne	a5,a4,c16 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     c0a:	0505                	addi	a0,a0,1
    p2++;
     c0c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c0e:	fed518e3          	bne	a0,a3,bfe <memcmp+0x12>
  }
  return 0;
     c12:	4501                	li	a0,0
     c14:	a019                	j	c1a <memcmp+0x2e>
      return *p1 - *p2;
     c16:	40e7853b          	subw	a0,a5,a4
}
     c1a:	60a2                	ld	ra,8(sp)
     c1c:	6402                	ld	s0,0(sp)
     c1e:	0141                	addi	sp,sp,16
     c20:	8082                	ret
  return 0;
     c22:	4501                	li	a0,0
     c24:	bfdd                	j	c1a <memcmp+0x2e>

0000000000000c26 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c26:	1141                	addi	sp,sp,-16
     c28:	e406                	sd	ra,8(sp)
     c2a:	e022                	sd	s0,0(sp)
     c2c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c2e:	f63ff0ef          	jal	b90 <memmove>
}
     c32:	60a2                	ld	ra,8(sp)
     c34:	6402                	ld	s0,0(sp)
     c36:	0141                	addi	sp,sp,16
     c38:	8082                	ret

0000000000000c3a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c3a:	4885                	li	a7,1
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c42:	4889                	li	a7,2
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c4a:	488d                	li	a7,3
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c52:	4891                	li	a7,4
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <read>:
.global read
read:
 li a7, SYS_read
     c5a:	4895                	li	a7,5
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c62:	4899                	li	a7,6
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c6a:	489d                	li	a7,7
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c72:	48a1                	li	a7,8
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c7a:	48a5                	li	a7,9
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c82:	48a9                	li	a7,10
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c8a:	48ad                	li	a7,11
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c92:	48b1                	li	a7,12
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c9a:	48b5                	li	a7,13
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ca2:	48b9                	li	a7,14
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <open>:
.global open
open:
 li a7, SYS_open
     caa:	48bd                	li	a7,15
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <write>:
.global write
write:
 li a7, SYS_write
     cb2:	48c1                	li	a7,16
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cba:	48c5                	li	a7,17
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cc2:	48c9                	li	a7,18
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <link>:
.global link
link:
 li a7, SYS_link
     cca:	48cd                	li	a7,19
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cd2:	48d1                	li	a7,20
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <close>:
.global close
close:
 li a7, SYS_close
     cda:	48d5                	li	a7,21
 ecall
     cdc:	00000073          	ecall
 ret
     ce0:	8082                	ret

0000000000000ce2 <freeze>:
.global freeze
freeze:
 li a7, SYS_freeze
     ce2:	48d9                	li	a7,22
 ecall
     ce4:	00000073          	ecall
 ret
     ce8:	8082                	ret

0000000000000cea <unfreeze>:
.global unfreeze
unfreeze:
 li a7, SYS_unfreeze
     cea:	48dd                	li	a7,23
 ecall
     cec:	00000073          	ecall
 ret
     cf0:	8082                	ret

0000000000000cf2 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
     cf2:	48e1                	li	a7,24
 ecall
     cf4:	00000073          	ecall
 ret
     cf8:	8082                	ret

0000000000000cfa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cfa:	1101                	addi	sp,sp,-32
     cfc:	ec06                	sd	ra,24(sp)
     cfe:	e822                	sd	s0,16(sp)
     d00:	1000                	addi	s0,sp,32
     d02:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d06:	4605                	li	a2,1
     d08:	fef40593          	addi	a1,s0,-17
     d0c:	fa7ff0ef          	jal	cb2 <write>
}
     d10:	60e2                	ld	ra,24(sp)
     d12:	6442                	ld	s0,16(sp)
     d14:	6105                	addi	sp,sp,32
     d16:	8082                	ret

0000000000000d18 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d18:	7139                	addi	sp,sp,-64
     d1a:	fc06                	sd	ra,56(sp)
     d1c:	f822                	sd	s0,48(sp)
     d1e:	f04a                	sd	s2,32(sp)
     d20:	ec4e                	sd	s3,24(sp)
     d22:	0080                	addi	s0,sp,64
     d24:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d26:	cac9                	beqz	a3,db8 <printint+0xa0>
     d28:	01f5d79b          	srliw	a5,a1,0x1f
     d2c:	c7d1                	beqz	a5,db8 <printint+0xa0>
    neg = 1;
    x = -xx;
     d2e:	40b005bb          	negw	a1,a1
    neg = 1;
     d32:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d34:	fc040993          	addi	s3,s0,-64
  neg = 0;
     d38:	86ce                	mv	a3,s3
  i = 0;
     d3a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d3c:	00000817          	auipc	a6,0x0
     d40:	64c80813          	addi	a6,a6,1612 # 1388 <digits>
     d44:	88ba                	mv	a7,a4
     d46:	0017051b          	addiw	a0,a4,1
     d4a:	872a                	mv	a4,a0
     d4c:	02c5f7bb          	remuw	a5,a1,a2
     d50:	1782                	slli	a5,a5,0x20
     d52:	9381                	srli	a5,a5,0x20
     d54:	97c2                	add	a5,a5,a6
     d56:	0007c783          	lbu	a5,0(a5)
     d5a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d5e:	87ae                	mv	a5,a1
     d60:	02c5d5bb          	divuw	a1,a1,a2
     d64:	0685                	addi	a3,a3,1
     d66:	fcc7ffe3          	bgeu	a5,a2,d44 <printint+0x2c>
  if(neg)
     d6a:	00030c63          	beqz	t1,d82 <printint+0x6a>
    buf[i++] = '-';
     d6e:	fd050793          	addi	a5,a0,-48
     d72:	00878533          	add	a0,a5,s0
     d76:	02d00793          	li	a5,45
     d7a:	fef50823          	sb	a5,-16(a0)
     d7e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d82:	02e05563          	blez	a4,dac <printint+0x94>
     d86:	f426                	sd	s1,40(sp)
     d88:	377d                	addiw	a4,a4,-1
     d8a:	00e984b3          	add	s1,s3,a4
     d8e:	19fd                	addi	s3,s3,-1
     d90:	99ba                	add	s3,s3,a4
     d92:	1702                	slli	a4,a4,0x20
     d94:	9301                	srli	a4,a4,0x20
     d96:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d9a:	0004c583          	lbu	a1,0(s1)
     d9e:	854a                	mv	a0,s2
     da0:	f5bff0ef          	jal	cfa <putc>
  while(--i >= 0)
     da4:	14fd                	addi	s1,s1,-1
     da6:	ff349ae3          	bne	s1,s3,d9a <printint+0x82>
     daa:	74a2                	ld	s1,40(sp)
}
     dac:	70e2                	ld	ra,56(sp)
     dae:	7442                	ld	s0,48(sp)
     db0:	7902                	ld	s2,32(sp)
     db2:	69e2                	ld	s3,24(sp)
     db4:	6121                	addi	sp,sp,64
     db6:	8082                	ret
  neg = 0;
     db8:	4301                	li	t1,0
     dba:	bfad                	j	d34 <printint+0x1c>

0000000000000dbc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dbc:	711d                	addi	sp,sp,-96
     dbe:	ec86                	sd	ra,88(sp)
     dc0:	e8a2                	sd	s0,80(sp)
     dc2:	e4a6                	sd	s1,72(sp)
     dc4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dc6:	0005c483          	lbu	s1,0(a1)
     dca:	20048963          	beqz	s1,fdc <vprintf+0x220>
     dce:	e0ca                	sd	s2,64(sp)
     dd0:	fc4e                	sd	s3,56(sp)
     dd2:	f852                	sd	s4,48(sp)
     dd4:	f456                	sd	s5,40(sp)
     dd6:	f05a                	sd	s6,32(sp)
     dd8:	ec5e                	sd	s7,24(sp)
     dda:	e862                	sd	s8,16(sp)
     ddc:	8b2a                	mv	s6,a0
     dde:	8a2e                	mv	s4,a1
     de0:	8bb2                	mv	s7,a2
  state = 0;
     de2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     de4:	4901                	li	s2,0
     de6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     de8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dec:	06400c13          	li	s8,100
     df0:	a00d                	j	e12 <vprintf+0x56>
        putc(fd, c0);
     df2:	85a6                	mv	a1,s1
     df4:	855a                	mv	a0,s6
     df6:	f05ff0ef          	jal	cfa <putc>
     dfa:	a019                	j	e00 <vprintf+0x44>
    } else if(state == '%'){
     dfc:	03598363          	beq	s3,s5,e22 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     e00:	0019079b          	addiw	a5,s2,1
     e04:	893e                	mv	s2,a5
     e06:	873e                	mv	a4,a5
     e08:	97d2                	add	a5,a5,s4
     e0a:	0007c483          	lbu	s1,0(a5)
     e0e:	1c048063          	beqz	s1,fce <vprintf+0x212>
    c0 = fmt[i] & 0xff;
     e12:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e16:	fe0993e3          	bnez	s3,dfc <vprintf+0x40>
      if(c0 == '%'){
     e1a:	fd579ce3          	bne	a5,s5,df2 <vprintf+0x36>
        state = '%';
     e1e:	89be                	mv	s3,a5
     e20:	b7c5                	j	e00 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     e22:	00ea06b3          	add	a3,s4,a4
     e26:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e2a:	1a060e63          	beqz	a2,fe6 <vprintf+0x22a>
      if(c0 == 'd'){
     e2e:	03878763          	beq	a5,s8,e5c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e32:	f9478693          	addi	a3,a5,-108
     e36:	0016b693          	seqz	a3,a3
     e3a:	f9c60593          	addi	a1,a2,-100
     e3e:	e99d                	bnez	a1,e74 <vprintf+0xb8>
     e40:	ca95                	beqz	a3,e74 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e42:	008b8493          	addi	s1,s7,8
     e46:	4685                	li	a3,1
     e48:	4629                	li	a2,10
     e4a:	000ba583          	lw	a1,0(s7)
     e4e:	855a                	mv	a0,s6
     e50:	ec9ff0ef          	jal	d18 <printint>
        i += 1;
     e54:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e56:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e58:	4981                	li	s3,0
     e5a:	b75d                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e5c:	008b8493          	addi	s1,s7,8
     e60:	4685                	li	a3,1
     e62:	4629                	li	a2,10
     e64:	000ba583          	lw	a1,0(s7)
     e68:	855a                	mv	a0,s6
     e6a:	eafff0ef          	jal	d18 <printint>
     e6e:	8ba6                	mv	s7,s1
      state = 0;
     e70:	4981                	li	s3,0
     e72:	b779                	j	e00 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e74:	9752                	add	a4,a4,s4
     e76:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e7a:	f9460713          	addi	a4,a2,-108
     e7e:	00173713          	seqz	a4,a4
     e82:	8f75                	and	a4,a4,a3
     e84:	f9c58513          	addi	a0,a1,-100
     e88:	16051963          	bnez	a0,ffa <vprintf+0x23e>
     e8c:	16070763          	beqz	a4,ffa <vprintf+0x23e>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e90:	008b8493          	addi	s1,s7,8
     e94:	4685                	li	a3,1
     e96:	4629                	li	a2,10
     e98:	000ba583          	lw	a1,0(s7)
     e9c:	855a                	mv	a0,s6
     e9e:	e7bff0ef          	jal	d18 <printint>
        i += 2;
     ea2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea4:	8ba6                	mv	s7,s1
      state = 0;
     ea6:	4981                	li	s3,0
        i += 2;
     ea8:	bfa1                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 0);
     eaa:	008b8493          	addi	s1,s7,8
     eae:	4681                	li	a3,0
     eb0:	4629                	li	a2,10
     eb2:	000ba583          	lw	a1,0(s7)
     eb6:	855a                	mv	a0,s6
     eb8:	e61ff0ef          	jal	d18 <printint>
     ebc:	8ba6                	mv	s7,s1
      state = 0;
     ebe:	4981                	li	s3,0
     ec0:	b781                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ec2:	008b8493          	addi	s1,s7,8
     ec6:	4681                	li	a3,0
     ec8:	4629                	li	a2,10
     eca:	000ba583          	lw	a1,0(s7)
     ece:	855a                	mv	a0,s6
     ed0:	e49ff0ef          	jal	d18 <printint>
        i += 1;
     ed4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed6:	8ba6                	mv	s7,s1
      state = 0;
     ed8:	4981                	li	s3,0
     eda:	b71d                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     edc:	008b8493          	addi	s1,s7,8
     ee0:	4681                	li	a3,0
     ee2:	4629                	li	a2,10
     ee4:	000ba583          	lw	a1,0(s7)
     ee8:	855a                	mv	a0,s6
     eea:	e2fff0ef          	jal	d18 <printint>
        i += 2;
     eee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef0:	8ba6                	mv	s7,s1
      state = 0;
     ef2:	4981                	li	s3,0
        i += 2;
     ef4:	b731                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
     ef6:	008b8493          	addi	s1,s7,8
     efa:	4681                	li	a3,0
     efc:	4641                	li	a2,16
     efe:	000ba583          	lw	a1,0(s7)
     f02:	855a                	mv	a0,s6
     f04:	e15ff0ef          	jal	d18 <printint>
     f08:	8ba6                	mv	s7,s1
      state = 0;
     f0a:	4981                	li	s3,0
     f0c:	bdd5                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f0e:	008b8493          	addi	s1,s7,8
     f12:	4681                	li	a3,0
     f14:	4641                	li	a2,16
     f16:	000ba583          	lw	a1,0(s7)
     f1a:	855a                	mv	a0,s6
     f1c:	dfdff0ef          	jal	d18 <printint>
        i += 1;
     f20:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f22:	8ba6                	mv	s7,s1
      state = 0;
     f24:	4981                	li	s3,0
     f26:	bde9                	j	e00 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f28:	008b8493          	addi	s1,s7,8
     f2c:	4681                	li	a3,0
     f2e:	4641                	li	a2,16
     f30:	000ba583          	lw	a1,0(s7)
     f34:	855a                	mv	a0,s6
     f36:	de3ff0ef          	jal	d18 <printint>
        i += 2;
     f3a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f3c:	8ba6                	mv	s7,s1
      state = 0;
     f3e:	4981                	li	s3,0
        i += 2;
     f40:	b5c1                	j	e00 <vprintf+0x44>
     f42:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f44:	008b8793          	addi	a5,s7,8
     f48:	8cbe                	mv	s9,a5
     f4a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f4e:	03000593          	li	a1,48
     f52:	855a                	mv	a0,s6
     f54:	da7ff0ef          	jal	cfa <putc>
  putc(fd, 'x');
     f58:	07800593          	li	a1,120
     f5c:	855a                	mv	a0,s6
     f5e:	d9dff0ef          	jal	cfa <putc>
     f62:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f64:	00000b97          	auipc	s7,0x0
     f68:	424b8b93          	addi	s7,s7,1060 # 1388 <digits>
     f6c:	03c9d793          	srli	a5,s3,0x3c
     f70:	97de                	add	a5,a5,s7
     f72:	0007c583          	lbu	a1,0(a5)
     f76:	855a                	mv	a0,s6
     f78:	d83ff0ef          	jal	cfa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f7c:	0992                	slli	s3,s3,0x4
     f7e:	34fd                	addiw	s1,s1,-1
     f80:	f4f5                	bnez	s1,f6c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f82:	8be6                	mv	s7,s9
      state = 0;
     f84:	4981                	li	s3,0
     f86:	6ca2                	ld	s9,8(sp)
     f88:	bda5                	j	e00 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f8a:	008b8993          	addi	s3,s7,8
     f8e:	000bb483          	ld	s1,0(s7)
     f92:	cc91                	beqz	s1,fae <vprintf+0x1f2>
        for(; *s; s++)
     f94:	0004c583          	lbu	a1,0(s1)
     f98:	c985                	beqz	a1,fc8 <vprintf+0x20c>
          putc(fd, *s);
     f9a:	855a                	mv	a0,s6
     f9c:	d5fff0ef          	jal	cfa <putc>
        for(; *s; s++)
     fa0:	0485                	addi	s1,s1,1
     fa2:	0004c583          	lbu	a1,0(s1)
     fa6:	f9f5                	bnez	a1,f9a <vprintf+0x1de>
        if((s = va_arg(ap, char*)) == 0)
     fa8:	8bce                	mv	s7,s3
      state = 0;
     faa:	4981                	li	s3,0
     fac:	bd91                	j	e00 <vprintf+0x44>
          s = "(null)";
     fae:	00000497          	auipc	s1,0x0
     fb2:	3a248493          	addi	s1,s1,930 # 1350 <malloc+0x20e>
        for(; *s; s++)
     fb6:	02800593          	li	a1,40
     fba:	b7c5                	j	f9a <vprintf+0x1de>
        putc(fd, '%');
     fbc:	85be                	mv	a1,a5
     fbe:	855a                	mv	a0,s6
     fc0:	d3bff0ef          	jal	cfa <putc>
      state = 0;
     fc4:	4981                	li	s3,0
     fc6:	bd2d                	j	e00 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fc8:	8bce                	mv	s7,s3
      state = 0;
     fca:	4981                	li	s3,0
     fcc:	bd15                	j	e00 <vprintf+0x44>
     fce:	6906                	ld	s2,64(sp)
     fd0:	79e2                	ld	s3,56(sp)
     fd2:	7a42                	ld	s4,48(sp)
     fd4:	7aa2                	ld	s5,40(sp)
     fd6:	7b02                	ld	s6,32(sp)
     fd8:	6be2                	ld	s7,24(sp)
     fda:	6c42                	ld	s8,16(sp)
    }
  }
}
     fdc:	60e6                	ld	ra,88(sp)
     fde:	6446                	ld	s0,80(sp)
     fe0:	64a6                	ld	s1,72(sp)
     fe2:	6125                	addi	sp,sp,96
     fe4:	8082                	ret
      if(c0 == 'd'){
     fe6:	06400713          	li	a4,100
     fea:	e6e789e3          	beq	a5,a4,e5c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     fee:	f9478693          	addi	a3,a5,-108
     ff2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     ff6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ff8:	4701                	li	a4,0
      } else if(c0 == 'u'){
     ffa:	07500513          	li	a0,117
     ffe:	eaa786e3          	beq	a5,a0,eaa <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    1002:	f8b60513          	addi	a0,a2,-117
    1006:	e119                	bnez	a0,100c <vprintf+0x250>
    1008:	ea069de3          	bnez	a3,ec2 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    100c:	f8b58513          	addi	a0,a1,-117
    1010:	e119                	bnez	a0,1016 <vprintf+0x25a>
    1012:	ec0715e3          	bnez	a4,edc <vprintf+0x120>
      } else if(c0 == 'x'){
    1016:	07800513          	li	a0,120
    101a:	eca78ee3          	beq	a5,a0,ef6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    101e:	f8860613          	addi	a2,a2,-120
    1022:	e219                	bnez	a2,1028 <vprintf+0x26c>
    1024:	ee0695e3          	bnez	a3,f0e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1028:	f8858593          	addi	a1,a1,-120
    102c:	e199                	bnez	a1,1032 <vprintf+0x276>
    102e:	ee071de3          	bnez	a4,f28 <vprintf+0x16c>
      } else if(c0 == 'p'){
    1032:	07000713          	li	a4,112
    1036:	f0e786e3          	beq	a5,a4,f42 <vprintf+0x186>
      } else if(c0 == 's'){
    103a:	07300713          	li	a4,115
    103e:	f4e786e3          	beq	a5,a4,f8a <vprintf+0x1ce>
      } else if(c0 == '%'){
    1042:	02500713          	li	a4,37
    1046:	f6e78be3          	beq	a5,a4,fbc <vprintf+0x200>
        putc(fd, '%');
    104a:	02500593          	li	a1,37
    104e:	855a                	mv	a0,s6
    1050:	cabff0ef          	jal	cfa <putc>
        putc(fd, c0);
    1054:	85a6                	mv	a1,s1
    1056:	855a                	mv	a0,s6
    1058:	ca3ff0ef          	jal	cfa <putc>
      state = 0;
    105c:	4981                	li	s3,0
    105e:	b34d                	j	e00 <vprintf+0x44>

0000000000001060 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1060:	715d                	addi	sp,sp,-80
    1062:	ec06                	sd	ra,24(sp)
    1064:	e822                	sd	s0,16(sp)
    1066:	1000                	addi	s0,sp,32
    1068:	e010                	sd	a2,0(s0)
    106a:	e414                	sd	a3,8(s0)
    106c:	e818                	sd	a4,16(s0)
    106e:	ec1c                	sd	a5,24(s0)
    1070:	03043023          	sd	a6,32(s0)
    1074:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1078:	8622                	mv	a2,s0
    107a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    107e:	d3fff0ef          	jal	dbc <vprintf>
}
    1082:	60e2                	ld	ra,24(sp)
    1084:	6442                	ld	s0,16(sp)
    1086:	6161                	addi	sp,sp,80
    1088:	8082                	ret

000000000000108a <printf>:

void
printf(const char *fmt, ...)
{
    108a:	711d                	addi	sp,sp,-96
    108c:	ec06                	sd	ra,24(sp)
    108e:	e822                	sd	s0,16(sp)
    1090:	1000                	addi	s0,sp,32
    1092:	e40c                	sd	a1,8(s0)
    1094:	e810                	sd	a2,16(s0)
    1096:	ec14                	sd	a3,24(s0)
    1098:	f018                	sd	a4,32(s0)
    109a:	f41c                	sd	a5,40(s0)
    109c:	03043823          	sd	a6,48(s0)
    10a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10a4:	00840613          	addi	a2,s0,8
    10a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ac:	85aa                	mv	a1,a0
    10ae:	4505                	li	a0,1
    10b0:	d0dff0ef          	jal	dbc <vprintf>
}
    10b4:	60e2                	ld	ra,24(sp)
    10b6:	6442                	ld	s0,16(sp)
    10b8:	6125                	addi	sp,sp,96
    10ba:	8082                	ret

00000000000010bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10bc:	1141                	addi	sp,sp,-16
    10be:	e406                	sd	ra,8(sp)
    10c0:	e022                	sd	s0,0(sp)
    10c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c8:	00001797          	auipc	a5,0x1
    10cc:	f487b783          	ld	a5,-184(a5) # 2010 <freep>
    10d0:	a039                	j	10de <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10d2:	6398                	ld	a4,0(a5)
    10d4:	00e7e463          	bltu	a5,a4,10dc <free+0x20>
    10d8:	00e6ea63          	bltu	a3,a4,10ec <free+0x30>
{
    10dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10de:	fed7fae3          	bgeu	a5,a3,10d2 <free+0x16>
    10e2:	6398                	ld	a4,0(a5)
    10e4:	00e6e463          	bltu	a3,a4,10ec <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e8:	fee7eae3          	bltu	a5,a4,10dc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10ec:	ff852583          	lw	a1,-8(a0)
    10f0:	6390                	ld	a2,0(a5)
    10f2:	02059813          	slli	a6,a1,0x20
    10f6:	01c85713          	srli	a4,a6,0x1c
    10fa:	9736                	add	a4,a4,a3
    10fc:	02e60563          	beq	a2,a4,1126 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1100:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1104:	4790                	lw	a2,8(a5)
    1106:	02061593          	slli	a1,a2,0x20
    110a:	01c5d713          	srli	a4,a1,0x1c
    110e:	973e                	add	a4,a4,a5
    1110:	02e68263          	beq	a3,a4,1134 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1114:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1116:	00001717          	auipc	a4,0x1
    111a:	eef73d23          	sd	a5,-262(a4) # 2010 <freep>
}
    111e:	60a2                	ld	ra,8(sp)
    1120:	6402                	ld	s0,0(sp)
    1122:	0141                	addi	sp,sp,16
    1124:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1126:	4618                	lw	a4,8(a2)
    1128:	9f2d                	addw	a4,a4,a1
    112a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    112e:	6398                	ld	a4,0(a5)
    1130:	6310                	ld	a2,0(a4)
    1132:	b7f9                	j	1100 <free+0x44>
    p->s.size += bp->s.size;
    1134:	ff852703          	lw	a4,-8(a0)
    1138:	9f31                	addw	a4,a4,a2
    113a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    113c:	ff053683          	ld	a3,-16(a0)
    1140:	bfd1                	j	1114 <free+0x58>

0000000000001142 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    114e:	02051993          	slli	s3,a0,0x20
    1152:	0209d993          	srli	s3,s3,0x20
    1156:	09bd                	addi	s3,s3,15
    1158:	0049d993          	srli	s3,s3,0x4
    115c:	2985                	addiw	s3,s3,1
    115e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1160:	00001517          	auipc	a0,0x1
    1164:	eb053503          	ld	a0,-336(a0) # 2010 <freep>
    1168:	c905                	beqz	a0,1198 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    116a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    116c:	4798                	lw	a4,8(a5)
    116e:	09377663          	bgeu	a4,s3,11fa <malloc+0xb8>
    1172:	f426                	sd	s1,40(sp)
    1174:	e852                	sd	s4,16(sp)
    1176:	e456                	sd	s5,8(sp)
    1178:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    117a:	8a4e                	mv	s4,s3
    117c:	6705                	lui	a4,0x1
    117e:	00e9f363          	bgeu	s3,a4,1184 <malloc+0x42>
    1182:	6a05                	lui	s4,0x1
    1184:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1188:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    118c:	00001497          	auipc	s1,0x1
    1190:	e8448493          	addi	s1,s1,-380 # 2010 <freep>
  if(p == (char*)-1)
    1194:	5afd                	li	s5,-1
    1196:	a83d                	j	11d4 <malloc+0x92>
    1198:	f426                	sd	s1,40(sp)
    119a:	e852                	sd	s4,16(sp)
    119c:	e456                	sd	s5,8(sp)
    119e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11a0:	00001797          	auipc	a5,0x1
    11a4:	ee878793          	addi	a5,a5,-280 # 2088 <base>
    11a8:	00001717          	auipc	a4,0x1
    11ac:	e6f73423          	sd	a5,-408(a4) # 2010 <freep>
    11b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11b6:	b7d1                	j	117a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11b8:	6398                	ld	a4,0(a5)
    11ba:	e118                	sd	a4,0(a0)
    11bc:	a899                	j	1212 <malloc+0xd0>
  hp->s.size = nu;
    11be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11c2:	0541                	addi	a0,a0,16
    11c4:	ef9ff0ef          	jal	10bc <free>
  return freep;
    11c8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11ca:	c125                	beqz	a0,122a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11ce:	4798                	lw	a4,8(a5)
    11d0:	03277163          	bgeu	a4,s2,11f2 <malloc+0xb0>
    if(p == freep)
    11d4:	6098                	ld	a4,0(s1)
    11d6:	853e                	mv	a0,a5
    11d8:	fef71ae3          	bne	a4,a5,11cc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11dc:	8552                	mv	a0,s4
    11de:	ab5ff0ef          	jal	c92 <sbrk>
  if(p == (char*)-1)
    11e2:	fd551ee3          	bne	a0,s5,11be <malloc+0x7c>
        return 0;
    11e6:	4501                	li	a0,0
    11e8:	74a2                	ld	s1,40(sp)
    11ea:	6a42                	ld	s4,16(sp)
    11ec:	6aa2                	ld	s5,8(sp)
    11ee:	6b02                	ld	s6,0(sp)
    11f0:	a03d                	j	121e <malloc+0xdc>
    11f2:	74a2                	ld	s1,40(sp)
    11f4:	6a42                	ld	s4,16(sp)
    11f6:	6aa2                	ld	s5,8(sp)
    11f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11fa:	fae90fe3          	beq	s2,a4,11b8 <malloc+0x76>
        p->s.size -= nunits;
    11fe:	4137073b          	subw	a4,a4,s3
    1202:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1204:	02071693          	slli	a3,a4,0x20
    1208:	01c6d713          	srli	a4,a3,0x1c
    120c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    120e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1212:	00001717          	auipc	a4,0x1
    1216:	dea73f23          	sd	a0,-514(a4) # 2010 <freep>
      return (void*)(p + 1);
    121a:	01078513          	addi	a0,a5,16
  }
}
    121e:	70e2                	ld	ra,56(sp)
    1220:	7442                	ld	s0,48(sp)
    1222:	7902                	ld	s2,32(sp)
    1224:	69e2                	ld	s3,24(sp)
    1226:	6121                	addi	sp,sp,64
    1228:	8082                	ret
    122a:	74a2                	ld	s1,40(sp)
    122c:	6a42                	ld	s4,16(sp)
    122e:	6aa2                	ld	s5,8(sp)
    1230:	6b02                	ld	s6,0(sp)
    1232:	b7f5                	j	121e <malloc+0xdc>
