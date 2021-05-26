bits 64
default rel
global main
extern printf
extern scanf

section .data
    fmt_lf       db '%lf', 0
    fmt_info     db 'sqrt(%lf) = %lf',10,0
    increase     dq 0.125
    new_line     db 10, 0
    d            dq 0.0

section .bss
    end          resq 1
    root         resq 1 

section .text
    main:
        sub     rsp, 8
        
    INPUT_READER:
        lea     rsi, [end]
        lea     rdi, [fmt_lf]
        mov     al, 0
        call    scanf wrt ..plt
        
    MAIN_LOOP:
        movlpd  xmm0, [end]
        movlpd  xmm1, [d]
        comisd  xmm0, xmm1
        jbe     END
        
        ;sqrt(d)
        movlpd  xmm1, [d]
        sqrtsd  xmm0, xmm1
        movlpd  [root], xmm0
    
        ;print (sqrt(%lf) = %lf\n)
        movlpd  xmm1, [root]
        movlpd  xmm0, [d]
        lea     rdi,  [fmt_info]
        mov     al, 2
        call    printf wrt ..plt
        ;d+=0.125
        movlpd  xmm1, [d]
        addsd   xmm1, [increase]
        movlpd  [d], xmm1
        jmp     MAIN_LOOP
    
    END:
        add     rsp, 8
        sub     rax, rax
        ret