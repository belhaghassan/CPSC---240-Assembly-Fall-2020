global compute_resistance

section .data
    

section .bss

section .text
compute_resistance:

    ;============================================16 PUSHES======================================================
    push rbp
    mov rbp, rsp 
    push rdi 
    push rsi
    push rdx 
    push rcx
    push r8 
    push r9 
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf
    push rax


    ;=========================================DEFINE IMPORTANT VALUES======================================================
    mov r15, rdi                    ;Array
    mov r14, rsi                    ;Size
    
    mov r13, 0x0000000000000000     ;0.0
    movq xmm15, r13                 ;Sum

    mov r12, 0

    

    ;============================================COMPUTE RESISTANCE======================================================

        ;Formula: 1/R = 1/R1 + 1/R2 + 1/R3 + 1/R4

startLoop:

    cmp r12, r14
    je endLoop

    ;Updating denominator
    mov r13, 0x3ff0000000000000     ;1.0
    movq xmm13, r13                 ;Denominator for 1/RN (Where N is the number of resistors)

    divsd xmm13, [r15 + 8 * r12]    ;1.0/RN
    addsd xmm15, xmm13              ;1/R1 + 1/R2 + 1/R3 + 1/R4


    inc r12
    jmp startLoop

endLoop:

    ;We need 1.0 again in order to isolate the R from 1/R
    mov r13, 0x3ff0000000000000     
    movq xmm13, r13                 

    divsd xmm13, xmm15                  ;------------------------OPERATION OVERVIEW-----------------------------------------;
                                        ;1/R = 1/R1 + 1/R2 + 1/R3 + 1/R4        (Multiplying R to both sides)               ;
                                        ;1 = (1/R1 + 1/R2 + 1/R3 + 1/R4)R                                                   ;
                                        ;1/(1/R1 + 1/R2 + 1/R3 + 1/R4) = R      (Dividing sum to both sides to isolate R)   ;
                                        ;-----------------------------------------------------------------------------------;

    ;============================================16 POPS======================================================

    movsd xmm0, xmm13           ;Returning resistance to resistance.asm

    pop rax
    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp 
    

    ret
