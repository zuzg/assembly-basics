bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
       format   db "%s", 0
       new_line db 10, 0
	
section .bss
       input	resb 1024
       output   resb 1024
	
section .text
    main:
	sub	RSP, 8
	
	;scanf
	lea	RDI, [format]
	lea	RSI, [input]	
	mov	RAX, 0
	call	scanf wrt ..plt

        ;copy
        lea     RDI, [output]           
        lea     RSI, [input]            
        mov     RCX, 1024               
        cld           ; clear direction flag (string operations inc the index registers)            
        rep     movsb ; repeat: copy byte from the DS:[(E)SI] to the ES:[(E)DI] register
	
	;printf
	lea	RDI, [format]
	lea	RSI, [output]
	mov	RAX, 0
	call	printf wrt ..plt
	
	;print a new line
        lea     RDI, [new_line]
        mov     RAX, 0
        call    printf wrt ..plt

	add	RSP, 8
	sub	RAX, RAX
	ret
