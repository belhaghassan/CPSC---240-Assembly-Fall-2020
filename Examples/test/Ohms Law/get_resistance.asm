extern scanf
extern printf
extern atof
extern isfloat

global get_resistance

section .data  
    stringFormat db "%s", 0
    finishStatement db "You pressed Control D.", 10, 0
    badInput db "This is not a valid input. Please try again", 10, 0
    negative db "Input must be greater than 0", 10, 10, 0

section .bss

section .text
get_resistance:

    ;=================================================16 PUSHES=============================================================
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
    
    mov r15, rdi                        ;Array 
    mov r14, 0                          ;Size of array currently @ 0

    ;=================================================TAKING INPUT=============================================================

startInputting:

    ;Inputting resistors
    push qword 99                       ;Making space onto stack
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, rsp 
    call scanf

    ;Checking for Ctrl+D
    cdqe 
    cmp rax, -1
    je ctrlDPressed

    ;=================================================VALIDATE INPUT=============================================================

inputValidations:

    ;Checking if user input is a proper float
    mov rax, 1
    mov rdi, rsp
    call isfloat
    mov r13, rax

    ;Checking boolean value
    cmp r13, 0
    je improperInput

    ;If it is a proper input, convert it into a float
    xor rax, rax
    mov rdi, rsp
    call atof
    movsd xmm15, xmm0                   ;User input into a float stored in xmm15

    ;User input <= 0?
    mov r11, 0x0000000000000000         ;0.0
    movq xmm14, r11
    ucomisd xmm15, xmm14
    jbe negativeInput

    ;If user input passes all tests
    movsd [r15 + r14 * 8], xmm15        ;Passing input into array 
    pop rax                             ;Popping space off stack to make it alligned again
    inc r14                             ;Increasing size of array to 1

    jmp startInputting

ctrlDPressed:

    ;Telling user control D is pressed
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, finishStatement
    call printf
    pop rax                             ;Making up for the pop after the scanf

    jmp endInputting

    ;=================================================INPUTS NOT ACCEPTED=============================================================

improperInput:

    ;Telling user that this is not proper
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, badInput
    call printf
    pop rax                             ;Making up for the pop after the scanf

    jmp startInputting

negativeInput:

    ;Telling user that input must be > 0
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, negative
    call printf
    pop rax                             ;Making up for the pop after the scanf

    jmp startInputting    

endInputting:

    mov rax, r14                        ;Program returns number of elements in array 

    ;=================================================16 POPS=============================================================
    add rsp, 8                          ;Equivalent to a pop since we wanna use rax
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