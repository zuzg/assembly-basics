bits 64
default rel
global main
extern printf
extern scanf

section .data
    fmt      dd "%d ",10, 0
    fmt_in   dd "%d", 0
    message  db "The sorted array is: ", 10, 0
    new_line db 10, 0

section .bss
    array    resd 100
    size     resq 1 
    cnt      resq 1
    a        resd 1 ;one value

section .text

    main:
       sub    RSP, 8
       mov    RAX, 0
       mov    RCX, 0
       mov    RBX, 0

    INPUT_ARRAY:
       mov    [cnt], RCX 
       mov    [size], RCX
       
       lea    RDI, [fmt_in]
       lea    RSI, [a] 
       mov    AL, 0 
       call   scanf wrt ..plt ;scan number to a
       cmp    RAX, 1
       jnz    DONE
     
       mov    RAX, [a]
       mov    RCX, [cnt] ;add it to array
       lea    rsi, [array]
       mov    [rsi + rcx*8], rax
       add    RBX, [a]	
       inc    RCX	
       jmp    INPUT_ARRAY 

    DONE:
       mov    RAX, 0
       mov    RCX, 0
       mov    RBX, 0	

    OUTER_LOOP:
       cmp    RCX, [size]
       jge    END_LOOP
       mov    [cnt], RCX
       lea    rsi, [array]
       mov    rax, [rsi + rcx*8]

    INNER_LOOP:
	inc   RCX
	cmp   RCX, [size]
	jz    OK 
        lea   rsi, [array]
	cmp   RAX, [rsi+RCX*8]		
	jle   INNER_LOOP

        lea   rsi, [array]		
	xchg  RAX, [rsi+RCX*8]
	jmp   INNER_LOOP

    OK:
	mov   RCX, [cnt]
	lea   rsi, [array]
        mov   [rsi + rcx*8], rax
	inc   RCX
	jmp   OUTER_LOOP

    END_LOOP: 
	mov   RAX, 0
	mov   RBX, 0
	mov   RCX, 0
	lea   RDI, [message]
        mov   al, 0
	call  printf wrt ..plt

    PRINT_ARRAY:
	cmp   RCX, [size]
	jz    END
	lea   rsi, [array]
        mov   rax, [rsi + rcx*8]
	inc   RCX	
	mov   [cnt], RCX
	lea   RDI, [fmt]
        lea   RSI, [RAX]
        mov   al, 0
	call  printf wrt ..plt
	mov   RCX, [cnt]
	jmp   PRINT_ARRAY

    END:
       lea    RDI, [new_line]
       mov    al, 0
       call   printf wrt ..plt
       add    RSP, 8
       sub    RAX, RAX
    ret
