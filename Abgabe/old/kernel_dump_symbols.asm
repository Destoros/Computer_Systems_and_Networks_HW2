
kernel.elf:     file format elf32-littlearm

SYMBOL TABLE:
00008000 l    d  .text	00000000 .text ;
000182e0 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .ARM.attributes	00000000 .ARM.attributes
00000000 l    df *ABS*	00000000 armc-morse.c ;name of c file
000182e0 g     O .bss	00000004 timer
000182f0 g       .bss	00000000 _bss_end__
000182e0 g       .bss	00000000 __bss_start__
000182f0 g       .bss	00000000 __bss_end__
000182e0 g       .bss	00000000 __bss_start
00008000 g     F .text	00000288 main
000182f0 g       .bss	00000000 __end__
000182e4 g     O .bss	00000004 dot_length ;its a morse code, dot_length describes the time for a dot symbol, the dash symbol is equal to 3(?) dot lengths
00008288 g     F .text	00000038 foo
000182e8 g     O .bss	00000004 gpio
000182e0 g       .text	00000000 _edata
000182f0 g       .bss	00000000 _end
000082c0 g     F .text	00000020 bar
00080000 g       .ARM.attributes	00000000 _stack
000182e0 g       .text	00000000 __data_start
000182ec g     O .bss	00000004 morser ;.bss means it is not intialized
						;length in hex

;.bss is for uninitalized variables

;g - global, L - local variable
;d - debugging symbol
;F - name of a function
;f - name for a file;
;O - object


;morser - Intervall länge
000182e0

000182ec