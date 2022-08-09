
kernel.elf:     file format elf32-littlearm


Disassembly of section .text:
;------------------------------------------------------------
;ip has the value 0x0 for the entire programm
;r5 has the value 0x10000 for the entire programm 
;r3 has the address for the timer variable for the entire programm after line 802c (until line 8040 will always be executed, bc there are no branches before)
;r0 has the address for the morse variable for the entire programm
;lr has the address for the dot_length for the entire programm
;------------------------------------------------------------

00008000 <main>: ;pc = program counter; for this line pc = 00008000
;ldr = load from address
;ldr	r2, [pc, #616] loads from the current program counter(0x8000) + an Offset (616_dec) = 0x8270 the value into r2
;r2 is a general purpose register
    8000:	e59f2268 	ldr	r2, [pc, #616]	; 8270 <main+0x270>; r2 = 0x20200000; 0x20200000 is address for GPIO_START
;mov ip, #0; moves into the ip register the value 0 
;ip is synonym for r12; 
   8004:	e3a0c000 	mov	ip, #0 ;ip = 0x0
    8008:	e1a04002 	mov	r4, r2 ; r4 = r2 = 0x20200000(GPIO_START)
    800c:	e59f3260 	ldr	r3, [pc, #608]	; 8274 <main+0x274> ;r3 = 0x00030d40 	(dont know purpose yet)
    8010:	e59fe260 	ldr	lr, [pc, #608]	; 8278 <main+0x278> ;lr = 0x000182e4 	(address in symbol table for dot_length, program uses morse code, morse code consists of dash and dots)
    8014:	e59f1260 	ldr	r1, [pc, #608]	; 827c <main+0x27c> ;r1 = 0x000182e8    (---------||--------- for gpio)
	
	;str: value found in register r3 ist stored to the address found in lr; lr = 0x000182e4 (dot_length); r3 = 0x00030d40 
    8018:	e58e3000 	str	r3, [lr] ;dot_length = r3 = 0x00030d40; sets the time for dot_length (e.g. dot_length is 1 second now)
    801c:	e5812000 	str	r2, [r1] ;r2 = gpio = 0x20200000
    8020:	e5921004 	ldr	r1, [r2, #4] ;r1 = *(0x20200000+0x4) ;GPIO Function Select 1 register (Pins 10 - 19), Pin 16 is onboard LED
    8024:	e59f0254 	ldr	r0, [pc, #596]	; 8280 <main+0x280>; r0 = 0x000182ec; morser variable
	;orr = logical orr: r1 = r1 OR 0x4000
    8028:	e3811701 	orr	r1, r1, #262144	; 0x40000 = bin 01|00 0|000 |000|0 00|00 0|000; defines Pin 16 as OUTPUT 													
    802c:	e59f3250 	ldr	r3, [pc, #592]	; 8284 <main+0x284>  r3 = value of timer variable(from symbol table, is not initialized)
    8030:	e5821004 	str	r1, [r2, #4] ;write r1 back to the register for GPIO[1] (Function Select 1); the register for GPIO[1] is not directly written to
    8034:	e580c000 	str	ip, [r0] ;morser = 0; r0 holds the address for morser variable
    8038:	e5902000 	ldr	r2, [r0] ;r2 = morser (value); r0 is the address for the morser variable
    803c:	e3520002 	cmp	r2, #2 ;r2 == 2(sets flags); 1st iteration: 0 == 2; sets flag for less than
    8040:	93a05801 	movls	r5, #65536	; 0x10000 ; conditional move if the comparison was equal or less than; if true r5 = 65536_dec = 0x10000 = bin 0001 0000 0000 0000 0000 (1 is 16-th place counting from 0)
	;until here there are no branches
		
;if defined as output, CLEAR turns off the LED									
    8044:	8a00001d 	bhi	80c0 <main+0xc0> ;branch if morser > 2; (((for loop with 2 iterations(?))))
;-----	
    8048:	e5845028 	str	r5, [r4, #40]	; 0x28; if r2 <= 2 we continue here; 40_dec = 0x28; r4 is GPIO_START; r4 + 0x28 points to GPIO Pin Output Clear 0 register; clears GPIO Pin 16
    804c:	e59e1000 	ldr	r1, [lr]; r1 = dot_length (value)
    8050:	e583c000 	str	ip, [r3]; r3 points to timer variable; timer = 0;
    8054:	e5932000 	ldr	r2, [r3]; r2 = timer (value, not addr);
    8058:	e1510002 	cmp	r1, r2; r1 == r2 
    805c:	9a000005 	bls	8078 <main+0x78> ; branch if r1 <= r2; (dot_length <= timer); prolly timer increases over time  
	
    8060:	e5932000 	ldr	r2, [r3]; r2 = timer (value, not addr);															| loop start
    8064:	e2822001 	add	r2, r2, #1; r2 = r2 + 1; (timer  = timer + 1)													|
    8068:	e5832000 	str	r2, [r3]; timer = r2																			|
    806c:	e5932000 	ldr	r2, [r3]; r2 = timer (value, not addr);															|		
    8070:	e1510002 	cmp	r1, r2; r1 == r2 																				|
    8074:	8afffff9 	bhi	8060 <main+0x60>; branch if r1 > r2; (dot_length > timer)										| loop end	
	;repeats until dot_length <= timer
	
    8078:	e584501c 	str	r5, [r4, #28]; 28_dec = 0x001C; r4 + 0x001C points to GPIO Pin Output Set 0 register
    807c:	e59e1000 	ldr	r1, [lr]; lr points to dot_length; r1 = dot_length (value)
    8080:	e583c000 	str	ip, [r3]; r3 points to timer; timer = 0; (reset timer(?))
    8084:	e5932000 	ldr	r2, [r3]; r2 = timer (value) = 0;
    8088:	e1510002 	cmp	r1, r2; r1 == r2
    808c:	9a000005 	bls	80a8 <main+0xa8>; brach if r1 <= r2
	
    8090:	e5932000 	ldr	r2, [r3]; r3 points to timer; r2 = timer (value)
    8094:	e2822001 	add	r2, r2, #1; r2 = r2 + 1 (timer++)
    8098:	e5832000 	str	r2, [r3]; write value back to timer variable
    809c:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    80a0:	e1510002 	cmp	r1, r2; r1 == r2
    80a4:	8afffff9 	bhi	8090 <main+0x90>; branch if r1 > r2 (prolly dot_length > timer)
	
    80a8:	e5902000 	ldr	r2, [r0]; r0 points to morser var
    80ac:	e2822001 	add	r2, r2, #1; r2 = r2 + 1;
    80b0:	e5802000 	str	r2, [r0]; write value back to morser var
    80b4:	e5902000 	ldr	r2, [r0]; r2 = morser (value)
    80b8:	e3520002 	cmp	r2, #2; r2 == 2
    80bc:	9affffe1 	bls	8048 <main+0x48>; branch if morser <= 2;
	
	;"function" for dash_length (wait between two symbols)
    80c0:	e59e1000 	ldr	r1, [lr]; lr points to dot_length; r1 = dot_length (value)
    80c4:	e583c000 	str	ip, [r3]; r3 points to timer; timer = 0
    80c8:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    80cc:	e0811081 	add	r1, r1, r1, lsl #1; r1 = r1 + lsl(r1,1) = r1 + 2*r1 = 3*r1; lsl = logical shift left; r1 contains value for dot_length; 3 times dot_length is the time for a dash length
    80d0:	e1510002 	cmp	r1, r2; 3*dot_length  == timer (look if timer has reached dash_length)
    80d4:	9a000005 	bls	80f0 <main+0xf0> ; branch if dash_length <= timer; (dash_length = 3*dot_length)
		
    80d8:	e5932000 	ldr	r2, [r3]; r3 points to timer; r2 = timer (value)			| loop start
    80dc:	e2822001 	add	r2, r2, #1; r2 = r2 + 1 (timer++)                           |
    80e0:	e5832000 	str	r2, [r3]; write back r2 to timer variable                   |
    80e4:	e5932000 	ldr	r2, [r3]; r2 = timer (value)                                |		
    80e8:	e1510002 	cmp	r1, r2; r1 == r2; (dot_length or dash_length) == timer      |
    80ec:	8afffff9 	bhi	80d8 <main+0xd8>; branch if r1 > r2                         | loop end	
	
    80f0:	e580c000 	str	ip, [r0]; r0 points to morser var; morser = 0;
    80f4:	e5902000 	ldr	r2, [r0]; r2 = morser (value) = 0
    80f8:	e3520002 	cmp	r2, #2; r2 == 0
    80fc:	93a05801 	movls	r5, #65536	; 0x10000; move 0x10000 into register r5 if r2 < 2 (is always true?? bc. r2 gest set to 0 before)
    8100:	8a00001e 	bhi	8180 <main+0x180>; branch if r2 > 2 (never happens??)
	
    8104:	e5845028 	str	r5, [r4, #40]; assuming r5 = 0x10000; 40 dec = 0x28; r4 + 0x28 points to GPIO Pin Output Clear 0 register; clears GPIO Pin 16
    8108:	e59e1000 	ldr	r1, [lr]; lr points to dot_length; r1 = dot_length (value)
    810c:	e583c000 	str	ip, [r3]; r3 points to timer; timer = 0
    8110:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    8114:	e0811081 	add	r1, r1, r1, lsl #1; r1 = 3*r1 = 3*dot_length = dash_length
    8118:	e1510002 	cmp	r1, r2; r1 == r2
    811c:	9a000005 	bls	8138 <main+0x138>; branch if dash_length <= timer
	
    8120:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    8124:	e2822001 	add	r2, r2, #1; r2 = r2 + 1;
    8128:	e5832000 	str	r2, [r3]; timer = r2
    812c:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    8130:	e1510002 	cmp	r1, r2; r1 == r2
    8134:	8afffff9 	bhi	8120 <main+0x120>; branch if (dot_length or dash_length) > timer
	
    8138:	e584501c 	str	r5, [r4, #28]; 28_dec = 0x001C; r4 + 0x001C points to GPIO Pin Output Set 0 register; r5 = 0x10000, CLEARS Pin 16
    813c:	e59e1000 	ldr	r1, [lr]; lr points to dot_length; r1 = dot_length (value)
    8140:	e583c000 	str	ip, [r3]; r3 points to timer variable; timer = 0;
    8144:	e5932000 	ldr	r2, [r3]; r2 = timer (value)
    8148:	e1510002 	cmp	r1, r2; r1 == r2
    814c:	9a000005 	bls	8168 <main+0x168>; branch if dot_length <= timer
	
	;increases timer by 1 until timer == (dot_length OR dash_length)
    8150:	e5932000 	ldr	r2, [r3]                                ;| loop start
    8154:	e2822001 	add	r2, r2, #1                              ;|
    8158:	e5832000 	str	r2, [r3]                                ;|
    815c:	e5932000 	ldr	r2, [r3]                                ;|		
    8160:	e1510002 	cmp	r1, r2                                  ;|
    8164:	8afffff9 	bhi	8150 <main+0x150>                       ;| loop end	
	
	;loads value from morse variable, increases it by 1, writes it back and compares it to 2
    8168:	e5902000 	ldr	r2, [r0]
    816c:	e2822001 	add	r2, r2, #1
    8170:	e5802000 	str	r2, [r0]
    8174:	e5902000 	ldr	r2, [r0]
    8178:	e3520002 	cmp	r2, #2
    817c:	9affffe0 	bls	8104 <main+0x104>
	
	;sets timer to 0, computs the dash_length, compares it to timer variable
	8180:	e59e1000 	ldr	r1, [lr]
    8184:	e583c000 	str	ip, [r3]
    8188:	e5932000 	ldr	r2, [r3]
    818c:	e0811081 	add	r1, r1, r1, lsl #1
    8190:	e1510002 	cmp	r1, r2
    8194:	9a000005 	bls	81b0 <main+0x1b0>
	
	

	;loads timer, increases it by one, compares if (dot_length or dash_length) >= timer; repeat until timer > (dot_length or dash_length)
    8198:	e5932000 	ldr	r2, [r3]
    819c:	e2822001 	add	r2, r2, #1
    81a0:	e5832000 	str	r2, [r3]
    81a4:	e5932000 	ldr	r2, [r3]
    81a8:	e1510002 	cmp	r1, r2; r1 = (dot_length or dash_length)
    81ac:	8afffff9 	bhi	8198 <main+0x198>
	
    81b0:	e580c000 	str	ip, [r0]
    81b4:	e5902000 	ldr	r2, [r0]
    81b8:	e3520002 	cmp	r2, #2
    81bc:	93a05801 	movls	r5, #65536	; 0x10000
    81c0:	8a00001d 	bhi	823c <main+0x23c>
	
    81c4:	e5845028 	str	r5, [r4, #40]	; 0x28 
    81c8:	e59e1000 	ldr	r1, [lr]
    81cc:	e583c000 	str	ip, [r3]
    81d0:	e5932000 	ldr	r2, [r3]
    81d4:	e1510002 	cmp	r1, r2
    81d8:	9a000005 	bls	81f4 <main+0x1f4>
	
    81dc:	e5932000 	ldr	r2, [r3]
    81e0:	e2822001 	add	r2, r2, #1
    81e4:	e5832000 	str	r2, [r3]
    81e8:	e5932000 	ldr	r2, [r3]
    81ec:	e1510002 	cmp	r1, r2
    81f0:	8afffff9 	bhi	81dc <main+0x1dc>
	
    81f4:	e584501c 	str	r5, [r4, #28]
    81f8:	e59e1000 	ldr	r1, [lr]
    81fc:	e583c000 	str	ip, [r3]
    8200:	e5932000 	ldr	r2, [r3]
    8204:	e1510002 	cmp	r1, r2
    8208:	9a000005 	bls	8224 <main+0x224>
	
    820c:	e5932000 	ldr	r2, [r3]
    8210:	e2822001 	add	r2, r2, #1
    8214:	e5832000 	str	r2, [r3]
    8218:	e5932000 	ldr	r2, [r3]
    821c:	e1510002 	cmp	r1, r2
    8220:	8afffff9 	bhi	820c <main+0x20c>
	
    8224:	e5902000 	ldr	r2, [r0]
    8228:	e2822001 	add	r2, r2, #1
    822c:	e5802000 	str	r2, [r0]
    8230:	e5902000 	ldr	r2, [r0]
    8234:	e3520002 	cmp	r2, #2
    8238:	9affffe1 	bls	81c4 <main+0x1c4>
	
    823c:	e59e1000 	ldr	r1, [lr]
    8240:	e583c000 	str	ip, [r3]
    8244:	e5932000 	ldr	r2, [r3]
    8248:	e0611181 	rsb	r1, r1, r1, lsl #3 ;r1 = lsl(r1,3) - r1 = 7*r1 = 7*dot_length(defined time in morse code after one word)
    824c:	e1510002 	cmp	r1, r2
    8250:	9affff77 	bls	8034 <main+0x34>
	
    8254:	e5932000 	ldr	r2, [r3]
    8258:	e2822001 	add	r2, r2, #1
    825c:	e5832000 	str	r2, [r3]
    8260:	e5932000 	ldr	r2, [r3]
    8264:	e1510002 	cmp	r1, r2
    8268:	8afffff9 	bhi	8254 <main+0x254>
	
    826c:	eaffff70 	b	8034 <main+0x34> ;while(1) to repeat the morse code until eternity
    8270:	20200000 	.word	0x20200000 ;32 Bit long word (same size as register length)
    8274:	00030d40 	.word	0x00030d40
    8278:	000182e4 	.word	0x000182e4
    827c:	000182e8 	.word	0x000182e8
    8280:	000182ec 	.word	0x000182ec ;morser
    8284:	000182e0 	.word	0x000182e0



























;function never get called, nice bait ;)
00008288 <foo>: ;(for loop) used for the timer
    8288:	e3a03000 	mov	r3, #0 ;register r3 = 0
    828c:	e59f2028 	ldr	r2, [pc, #40]	; 82bc <foo+0x34> 
    8290:	e5823000 	str	r3, [r2] ; r2 contains a address to the symbol table; the value of r3 is written to the addr given in r2
    8294:	e5923000 	ldr	r3, [r2]
    8298:	e1530000 	cmp	r3, r0
    829c:	212fff1e 	bxcs	lr
    82a0:	e5923000 	ldr	r3, [r2]
    82a4:	e2833001 	add	r3, r3, #1
    82a8:	e5823000 	str	r3, [r2]
    82ac:	e5923000 	ldr	r3, [r2]
    82b0:	e1530000 	cmp	r3, r0
    82b4:	3afffff9 	bcc	82a0 <foo+0x18>
    82b8:	e12fff1e 	bx	lr
    82bc:	000182e0 	.word	0x000182e0

000082c0 <bar>: ;function to switch the LED
    82c0:	e3a02801 	mov	r2, #65536	; 0x10000
    82c4:	e59f3010 	ldr	r3, [pc, #16]	; 82dc <bar+0x1c>
    82c8:	e3500001 	cmp	r0, #1
    82cc:	e5933000 	ldr	r3, [r3]
    82d0:	05832028 	streq	r2, [r3, #40]	; 0x28
    82d4:	1583201c 	strne	r2, [r3, #28]
    82d8:	e12fff1e 	bx	lr
    82dc:	000182e8 	.word	0x000182e8
