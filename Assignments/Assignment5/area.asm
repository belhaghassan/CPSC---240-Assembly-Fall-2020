;********************************************************************************************
; Program name:          Area of a Triangle			                                        *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 4, 2020													*
; Program Completed:	 November 6, 2020													*
; Last Modified:		 November 10, 2020													*
; Program Description:   This program asks a user to input three floating-point lengths     *
;                        of a triangle and returns the area using Herons Formula			*
;                        Herons Formula = Sqrt(s(s-a)(s-b)(s-c)), Where s = (a + b + c)/2   *
;                                                                                           *
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Bilal El-haghassan                                                          *
; Email:        bilalelhaghassan@csu.fullerton.edu                                          *
; Institution:  California State University - Fullerton                                     *
; Course:       CPSC 240-05 Assembly Language                                               *
;                                                                                           *
;********************************************************************************************
; Copyright (C) 2020 Bilal El-haghassan                                                     *
; This program is free software: you can redistribute it and/or modify it under the terms   *
; of the GNU General Public License version 3 as published by the Free Software Foundation. *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;                                                                                           *
;********************************************************************************************
; Program Information                                                                       *
; Program name:   Area of a Triangle 				                           				*
; Languages used: One module in C, One module in C++, One module in x86                   	*
; Files included: area.asm, ispositivefloat.cpp, triangle.c                                 *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      area.asm                                                         			*
;    Purpose:   Takes a users input of 3 floating point numbers corresponding to 3sides     * 
;               of a trangle and returns the area as a floating point number to driver      *
;	 Language:	x86																			*
;	 Assemble:	nasm -f elf64 -l area.lis -o area.o area.asm            					*
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 area.o triangle.o ispositivefloat.o      *
;																							*
;********************************************************************************************

;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf
extern ispositivefloat
extern atof

global area                       ; Make function callable by other linked files.

section .data

    intro db "This program will compute the area of your triangle.", 10, 10
          db "Enter the floating point lengths of the 3 sides of your triangle: ", 10, 10, 0

    input db "Side %d: ", 0
    stringFormat db "%s", 0 
    invalid db 10, "An invalid input was detected.  Please run the program again.", 10, 0
    validinputs db 10, "These values were received:  %.7lf   %.7lf   %.7lf", 10, 0
    trianglearea db 10, "The area of this triangle is %.7lf square meters", 10, 0
 

section .bss
    array: resq 3                 

section .text

area:
; Back up all registers and set stack pointer to base pointer
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

    push qword 0               ; Extra push to create even number of pushes

;=================================FUNCTION BEGINS===========================================
    mov r12, 0                 ; Counter
    mov r13, 3                 ; Max inputs 
    mov r14, 0                 ; flag for square root of negative   


;-------------------------------PRINTS INTRODUCTION-----------------------------------------
    mov rdi, stringFormat
    mov rsi, intro
    mov rax, 0
    call printf

;===============================INPUT LOOP BEGINS===========================================
    beginloop:

    cmp r12, r13               ; Compares Counter (r12) to input limit 3 in (r13).
    jge valid_inputs           

;--------------------------------PRINTS OUT SIDE #------------------------------------------

    inc r12                    ; Increments counter r12.
    mov rdi, input             ; Passes input format to print out "Side: %lf".
    mov rsi, r12               ; Passes Counter (r12) to be printed in input string.
    mov rax, 0                 
    call printf

;--------------------------------ASKS USER FOR INPUT----------------------------------------
    push qword 0
    mov rdi, stringFormat      ; Pass stringformat to take a users input as a string.
    mov rsi, rsp               ; Points rsi to top of stack to place input value of scanf.
    mov rax, 0                 ; Set rax to 1 to let scanf know its an incoming float.
    call scanf

;----------------------------------FLOAT VALIDATION-----------------------------------------

    mov rdi, rsp               ; Copy address of stack pointer to rdi to pass input value.
    mov rax, 0                 ; Set rax 0 to allow function to return to it.
    call ispositivefloat       ; Call ispositivefloat cpp function to validate input.

    cmp rax, 0                 ; Checks to see if ispositivefloat function returned false.
    je invalid_input

;-----------------------------------ASCII to Float------------------------------------------

    mov rax, 1                 ; Set rax to 1 to allow function to return float to xmm0 reg.
    call atof                  ; Call atof c++ library function.
    
;----------------------------MOVE VALID INPUT INTO ARRAY------------------------------------

    movq [array + 8 * (r12 - 1)], xmm0    ; Copy atof output into array.  
    addsd xmm15, [array + 8 * (r12 - 1)]  ; Add atof output to xmm15 registers.

    pop rax                               ; Pop to offset push before scanf function.

    jmp beginloop                         ; Restart loop.

;====================================END OF LOOP============================================

;---------------------------***INVALID INPUT DETECTED***------------------------------------
    invalid_input:
    mov rax, 0
    mov rdi, stringFormat      ; Pass string format as first parameter.
    mov rsi, invalid           ; Pass invalid message as second parameter.
    call printf                ; Calls printf function from c library.

    movq xmm15, r14            ; Sets the final value returned to driver to 0 (r14).

    jmp endfunction            ; Jump to end of file.

;--------------------------***VALID INPUT CALCULATION**-------------------------------------
    valid_inputs:
    push qword 0

;--------------------------Print out values recieved----------------------------------------

    movsd xmm0, [array]             ; Side A: First input passed as first parameter.
    movsd xmm1, [array + 8]         ; Side B: Second input passed as second parameter.
    movsd xmm2, [array + 16]        ; Side C: Third input passed as third parameter.
    mov rdi, validinputs            ; Pass validinputs prompt to output 3 floats.
    mov rax, 3                      ; Pass 3 to rax to allow printf to output 3 floats.
    call printf

;================================HERONS FORMULA=============================================
;                              s = (a + b + c)/2  
;                            Sqrt(s(s-a)(s-b)(s-c))       
;===========================================================================================
    mov rax, 0x4000000000000000     ; Copy hex value of 2.0 into rax.
    movq xmm8, rax                  ; Copy 2.0 from rax to xmm8 reg.

;-----------------------------CALCULATE S PERIMETER-----------------------------------------
    divsd xmm15, xmm8               ; Divide xmm15(a + b + c) by xmm8(2.0).

;--------------------------CALCULATE (s-a)*(s-b)*(s-c)--------------------------------------

    movsd xmm13, xmm15              ; Copy s perimeter to xmm13.
    subsd xmm13, [array]            ; Subtract first input from s:  (s - a) 

    movsd xmm10, xmm15              ; Copy s perimeter to xmm10.
    subsd xmm10, [array + 8]        ; Subtract second input from s:  (s - b)

    movsd xmm11, xmm15              ; Copy s perimeter
    subsd xmm11, [array + 16]       ; Subtract third input from s:  (s - c)

    mulsd xmm15, xmm13              ; Multiply s by (s-a)
    mulsd xmm15, xmm10              ; Multiply s by (s-b)
    mulsd xmm15, xmm11              ; Multiply s by (s-c)


    movq xmm1, r14                  ; Copy 0 from r14 to xmm1 register.
    ucomisd xmm15, xmm1             ; Compare value in xmm15 after calculations with 0.
    jb invalid_input                ; Jump to invalid input label if xmm15 is negative
    
    Sqrtsd xmm15, xmm15             ; Square Root of xmm15: s(s-a)(s-b)(s-c)

;===============================END HERONS FORMULA==========================================

;---------------------------PRINT OUT AREA OF TRIANGLE--------------------------------------
    movsd xmm0, xmm15               ; Copy calculated area of triangle to xmm0 reg.
    mov rdi, trianglearea           ; Pass trianglearea prompt as parameter for printf.
    mov rax, 1                      ; Set rax to 1 to let printf know its printing xmm0. 
    call printf

;===============================END OF AREA FUNCTION========================================
endfunction:

    movsd xmm0, xmm15               ; Copy area from xmm15 to xmm0 to be returned.
   
    pop rax                         ; Extra pop to align stack to 16 bytes.
    pop rax                         ; Remove extra push of -1 from stack.

    ; Restores all registers to their original state.
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

