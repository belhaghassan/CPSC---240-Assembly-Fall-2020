;********************************************************************************************
; Program name:          Circumference of a Circle	                                        *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 1, 2020													*
; Program Completed:	 November 2, 2020													*
; Last Modified:		 November 7, 2020													*
; Program Description:   This program asks a user to input a radius as a floating-point     *
;                        number and returns the circumference of a circle with that radius  *
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
; Program name:   Circumference of a Circle			                           				*
; Languages used: One module in C, One module in x86                         				*
; Files included: circle.asm, circumference.c                                               *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      circle.asm                                                           		*
;    Purpose:   To take a users input of a floating point number and returning the          *
;               calculated circumference to the driver (circumference.c)                    *
;	 Language:	x86-64																		*
;	 Assemble:	nasm -f elf64 -l circle.lis -o circle.o circle.asm			                *
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 circumference.o circle.o                 *
;																							*
;********************************************************************************************

;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf

global circle                       ; Make function callable by other linked files.

section .data

    intro db "This circle function is brought to you by Bilal El-haghassan.", 10
          db "Please enter the radius of a circle as a floating point number: ", 0
    receivedNum db "The number %.10lf was received.", 10, 0
    circum db "The circumference of a circle with this radius is %.15lf meters.", 10
           db "The circumference will be returned to the main program. Please enjoy your circles.", 10, 0
    stringFormat db "%s", 0 
    floatFormat db "%lf", 0 

section .bss

section .text

circle:
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

    push qword -1              ; Extra push to create even number of pushes

;-------------------------------CIRCLE FUNCTION BEGINS--------------------------------------
    mov rdi, stringFormat
    mov rsi, intro             
    mov rax, 0
    call printf                ; Prints out intro message.

;---------------------------------ASK USER FOR INPUT----------------------------------------
    push rax                   ; Add 8 bytes onto stack for incoming value of scanf.
    mov rdi, floatFormat
    mov rsi, rsp               ; Points rsi to top of stack to place input value of scanf.
    mov rax, 0                 
    call scanf
    
    movsd xmm10, [rsp]         ; Copy user input into preserved xmm10 register.
    
;--------------------------PRINT CONFIRMATION OF RADIUS INPUT-------------------------------
    movsd xmm0, xmm10          ; Copy user input to xmm0 reg to be used in printf function.
    mov rdi, receivedNum       
    mov rax, 1                 ; Set rax to 1 to let printf know its printing xmm0.
    call printf

;----------------------COPY 2.0 INTO XMM12 REGISTER FOR MULIPLICATION-----------------------
    mov rax, 0x4000000000000000     ; Copy hex value of 2.0 into rax.
    push rax                        ; Push 2.0 onto stack.
    movsd xmm12, [rsp]              ; Copy 2.0 from top of stack to preserved xmm12 reg.
    pop rax                         ; Return stack to 16 byte alignment.

;-------------------COPY VALUE OF PI INTO XMM12 REGISTER FOR MULIPLICATION------------------
    mov rax, 0x400921FB54442D18     ; Copy hex value of Pi into rax.
    push rax                        ; Push value of Pi onto stack.
    movsd xmm13, [rsp]              ; Copy Pi from top of stack into preserved xmm13 reg.
    pop rax                         ; Return stack to 16 byte alignment.

;-----------------------------MULTIPLY INPUT BY 2.0 AND PI----------------------------------
    mulsd xmm10, xmm12              ; Multiply radius in xmm10 by 2.0 value in xmm12.
    mulsd xmm10, xmm13              ; Multiply 2 x radius by the value Pi in xmm13.

;-------------------------------PRINT OUT CIRCUMFERENCE-------------------------------------
    movsd xmm0, xmm10               ; Copy value of calulated circumference into xmm0.
    mov rdi, circum                 ; Pass format of float to printf.
    mov rax, 1                      ; Set rax to 1 to let printf know its printing xmm0.
    call printf

;-------------------------------END OF CIRCLE FUNCTION--------------------------------------
    movsd xmm0, xmm10               ; Copy circumference from xmm10 to xmm0 to be returned.
   
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

