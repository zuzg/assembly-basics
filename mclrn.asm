;Writing assembly code is an art of composing instructions one after another
;bulshit kurrr żadna art japierpapier aaaaaaaaaaaaaaa
bits 64
default rel
global main
extern printf
extern scanf

section .data
    fmt_intro   db 'Enter the numbers (k, x): ', 0
    fmt_i_k       db 'i = %i, k = %i',10,0
    fmt_scan    db '%i %lf', 0
    fmt_scan2   db 'Input: %i %lf',10, 0
    fmt_result  db 'e^x = %f', 10, 0
    series      dq 1.0
    numerator   dq 1.0
    denominator dq 1.0
    i           dd 1

section .bss
    k           resd 1
    x           resq 1

section .text
main:
    sub rsp, 8
    
INPUT_READER:
    lea rdi, [fmt_intro]
    mov al, 0
    call printf wrt ..plt
    lea rdx, [x]
    lea rsi, [k]
    lea rdi, [fmt_scan]
    mov al, 0
    call scanf wrt ..plt

    ;sprawdzanie czy się dobrze wczytało
    ;movlpd xmm0, [x]
    ;mov rsi,     [k]
    ;lea rdi,     [fmt_scan2]
    ;mov al, 1
    ;call printf wrt ..plt
    
MAIN_LOOP:
    mov eax, [k]
    cmp eax, [i]
    jl  END
    
    ;numerator *= x;
    movlpd xmm1, [numerator]
    mulsd  xmm1, [x]
    movlpd [numerator], xmm1
    
    movss    xmm2, [i]     ;https://www.felixcloutier.com/x86/movss
    CVTDQ2PD xmm2, xmm2 ;https://www.felixcloutier.com/x86/cvtdq2pd
    ;denominator *= i;
    movlpd xmm3, [denominator]
    mulsd  xmm3, xmm2
    movlpd [denominator], xmm3
    
    ;series += numerator / denominator;
    movlpd xmm4, [series]
    divsd  xmm1, xmm3
    addsd  xmm4, xmm1
    movlpd [series], xmm4
    
    ;print i, k
    ;mov    rdx,  [k]
    ;mov    rsi,  [i]
    ;lea    rdi,  [fmt_i_k]
    ;mov    al,   0
    ;call printf wrt ..plt
    
    ;printf("e^x = %f\n", series);
    movlpd xmm0, [series]
    lea    rdi,  [fmt_result]
    mov    al, 1
    call printf wrt ..plt
    
    ;i++
    mov rcx,[i]
    inc rcx
    mov [i], rcx
    jmp MAIN_LOOP
    
END:
    ;printf("e^x = %f\n", series);
    movlpd xmm0, [series]
    lea    rdi,  [fmt_result]
    mov    al, 1
    call printf wrt ..plt
    
    add   rsp, 8
    sub   rax, rax
    ret