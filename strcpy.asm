bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
       format   db "%s", 0
       new_line db 10, 0
	
section .bss
       input	resb 30
	
section .text
    main:
	sub	RSP, 8
	
	;scanf
	lea	RDI, [format]
	lea	RSI, [input]	
	mov	RAX, 0
	call	scanf wrt ..plt
	
	;printf
	lea	RDI, [format]
	lea	RDI, [input]
	mov	RAX, 0
	call	printf wrt ..plt
	
	;print a new line
        lea   RDI, [new_line]
        mov   RAX, 0
        call  printf wrt ..plt

	add	RSP, 8
	sub	RAX, RAX
	ret