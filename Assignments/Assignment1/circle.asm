;***************************************************
;Program name: "Circumference of a Circle".
;***************************************************
;
;Author information

;   Author name: Bilal El-haghassan
;   Author email: bilalelhaghassan@csu.fullerton.edu
;
;***************************************************

section .data

    author db "This circle function is brought to you by Bilal", 10, 0
    inputPrompt db "Please enter the radius of a circle in whole number of meters: ", 0
    receivedNum db "The number %ld was received.", 10, 0
    output1 db "The circumference of a circle with this radius is %ld ", 0
    output2 db "and %ld/7 meters.", 10, 0
    returnString db "The integer part of the area will be returned to the main program. Please enjoy your circles.", 10, 0

    stringFormat db "%s", 0 ; %s means any string
    numberFormat db "%ld", 0 ; %ld means any digit

section .bss
    pi_num equ 22
    pi_den equ 7

section .text
    extern printf
    extern scanf
    global start

start:
    push r12

    mov rdi, stringFormat
    mov rsi, author
    mov rax, 0
    call printf

    ;Request input for radius
    mov rdi, stringFormat
    mov rsi, inputPrompt          ;print out prompt for radius
    mov rax, 0
    call printf

    mov rdi, numberFormat
    mov rsi, rsp                  ; stack pointer points to rsi were scanf input will be placed
    mov rax, 0
    call scanf
    pop r12                       ; copy user input into r12

    ;Return received numberFormat
    mov rdi, receivedNum
    mov rsi, r12                  ; print out user input
    mov rax, 0
    call printf

    ;Calculate the Circumference
    ;Multiply radius by 2 and the numerator of egyptian pi
    mov rax, r12                  ; place user input into rax
    mov rcx, 2                    ; copy value 2 to rcx to multiply radius(user input)
    mul rcx
    mov rcx, pi_num               ; place egyptian pi numerator into rcx
    mul rcx                       ; multiply numerator by (2 * radius)
    mov r12, rax                  ; store quotient in r12

    ;Divide number stored in r12 after multiplication and divide it by
    ;egyptian quotient of pi
    mov rdx, 0
    mov rax, r12                  ; copy quotient into rax to be divided
    mov rcx, pi_den               ; copy egytian pi denominator into rcx
    div rcx                       ; divide quotient in rax by denominator in rcx
    mov r12, rax                  ; copy new quotient into r12
    mov r13, rdx                  ; copy remainder into r13

    ;Print quotient of circumference calculation
    mov rdi, output1
    mov rsi, r12
    mov rax, 0
    call printf

    ;Print remainder of circumference calculation
    mov rdi, output2
    mov rsi, r13
    mov rax, 0
    call printf

    ;Print return string
    mov rdi, stringFormat
    mov rsi, returnString
    mov rax, 0
    call printf

    mov rax, r12
    ret
