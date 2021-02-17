;Functions to be used in program
extern printf
extern get_resistance
extern get_tics
extern getfreq
extern compute_resistance
extern show_resistance


global resistance

section .data
    stringFormat db "%s", 0
    enterResistance db "Please enter the resistance for each of the 4 circuits.", 10, 0
    inputInstructions db "Enter each number followed by an enter. When you are done, press Ctrl+D: ", 10, 0
    result db "The total resistance of the system is %lf ohms, which required %.0lf ns to compute", 10, 0
    resistanceReturned db "The resistance of the system will be returned to the driver.", 10, 10, 0
    contents db "Here are the contents of your array: ", 0

    floatIs db "Content of float: %lf", 10, 0

section .bss
    resistanceArr: resq 4              ;Array of resistance

section .text
resistance:

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

    ;==============================================INTRODUCTION===========================================================
    ;Telling user to enter resistance
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, enterResistance
    call printf

    ;Instructing how to input
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, inputInstructions
    call printf

    ;==============================================TAKING INPUT===========================================================

    ;Calling function to take input
    push qword 100
    xor rax, rax
    mov rdi, resistanceArr
    call get_resistance
    mov r15, rax                            ;r15 now holds the size of the array 
    pop rax

    ;--------------------------DELETE LATER--------------------------
    ; push qword 0
    ; mov rax, 1
    ; mov rdi, floatIs
    ; movsd xmm0, [resistanceArr]
    ; call printf
    ; pop rax

    ; push qword 0
    ; mov rax, 1
    ; mov rdi, floatIs
    ; movsd xmm0, [resistanceArr + 8]
    ; call printf
    ; pop rax

    ; push qword 0
    ; mov rax, 1
    ; mov rdi, floatIs
    ; movsd xmm0, [resistanceArr + 16]
    ; call printf
    ; pop rax

    ;--------------------------DELETE LATER--------------------------


    ;Introducing contents of my array
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, contents
    call printf

    ;Calling function to print array
    push qword 0
    xor rax, rax
    mov rdi, resistanceArr
    mov rsi, r15
    call show_resistance
    pop rax

    ;=================================================FIND RESISTANCE=============================================================

    ;Initial tics
    xor rax, rax
    call get_tics
    mov r14, rax                    ;Initial tics stored in r14

    ;Calling function to calculate resistance
    xor rax, rax
    mov rdi, resistanceArr
    mov rsi, r15
    call compute_resistance
    movsd xmm15, xmm0               ;Resistance stored in xmm15

    ;Tics after
    xor rax, rax
    call get_tics   
    mov r13, rax                    ;Tics after stored in r13

    ;=================================================CALCULATE TIME=============================================================

    ;Getting computer frequence in tics/seconds (GHz)
    mov rax, 1
    call getfreq
    movsd xmm12, xmm0        

    push qword 0
    mov rax, 1
    mov rdi, floatIs
    movsd xmm0, xmm12
    call printf
    pop rax       
    
    ;Converting tics to floats
    cvtsi2sd xmm13, r13             ;Converting tics after to xmm reg.
    cvtsi2sd xmm14, r14             ;Converting tics before to xmm reg.

    ;Calculate time in nanoseconds
    subsd xmm13, xmm14              ;Getting elapsed time

    divsd xmm13, xmm12              ;Dividing elapsed time / GHz * 1 billion
                                    ;xmm15 holds number of nanoseconds

    ;=================================================PRINT RESULTS=============================================================

    ;Printing resistance in ohms and time it took to calculate
    push qword 10
    mov rax, 1
    mov rdi, result
    movsd xmm0, xmm15               ;Resistance
    movsd xmm1, xmm13               ;Nanoseconds
    call printf
    pop rax

    ;Closing statement
    xor rax, rax
    mov rdi, stringFormat
    mov rsi, resistanceReturned
    call printf

end:

    ;=================================================16 POPS=============================================================

    movsd xmm0, xmm15               ;Returning resistance to driver

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
