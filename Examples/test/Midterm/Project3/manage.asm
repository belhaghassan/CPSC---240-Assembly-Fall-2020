;********************************************************************************************
; Program name:          Reverse Array                                            *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns array in reverse.                          *
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

extern printf
extern scanf
extern getdata
extern showarray
extern reverse

array_size equ 100                  ; Capacity limit for number of elements allowed in array.

global manage                     ; Makes function callable from other linked files.

section .data
welcome db 10, "Welcome to Array Mangement Tool.", 10
        db "Input your integer data with white space separating each number", 10
        db 10, "Please enter integer data to be stored in your array. Press enter ", 10
        db "and Cntl+D to terminate: ", 10, 0
reverseddata db 10,"The data have been reversed. This is the array:", 10, 0
inarray db "Thank you. The array contains the following data: ", 10, 0
length db 10, 10, "The length squared of this array is ", 0
correctness db "Is this correct (y or n)?", 0
stringFormat db "%s", 0
numberFormat db "%ld", 0

section .bss
    intArray: resq 100                  ; Uninitialized array with 100 reserved qwords.
    
section .text

manage:

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

push qword -1                           ; Extra push to create even number of pushes

;-----------------------------INITIALIZE PARAMETERS-----------------------------------------
mov qword r14, 0                        ; Reserve register for number of elements in array.
mov qword r13, 0                        ; Reserve register for lengthsquared of the array.

push qword 0
mov qword rax, 0
mov qword rdi, stringFormat
mov qword rsi, welcome
call printf

;---------------------------CALL FUNCTION INPUT_ARRAY---------------------------------------

;push qword 0
mov qword rdi, intArray                 ; Passes array into rdi register.
mov qword rax, 0
call getdata                        ; Calls funtion input_array.
mov r14, rax                            ; Saves copy of input_array output into r14.
pop r8

mov qword rax, 0
mov qword rdi, stringFormat
mov qword rsi, inarray
call printf

;----------------------------OUTPUT ARRAY--------------------------------------

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call showarray                       ; Calls output_array function.

mov qword rax, 0
mov qword rdi, stringFormat
mov qword rsi, correctness
call printf

mov r15, 121

push qword 0
mov rax, 0
mov rdi, stringFormat
mov rsi, rsp
call scanf
pop r11

mov qword rax, 0
mov qword rdi, stringFormat
mov qword rsi, correctness
call printf

cmp r11, r15
je errormsg

mov qword rax, 0
mov qword rdi, stringFormat
mov qword rsi, reverseddata
call printf
;---------------------------CALL REVERSED------------------------------------- 

mov qword rdi, intArray                 ; Passes the array      
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call reverse      
mov r13, rax                

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call showarray                       ; Calls output_array function.

errormsg:

;-----------------------------END OF FILE-----------------------------------------------

; Restores all registers to their original state.
pop rax                                  ; Remove extra push of -1 from stack.
mov qword rax, r14                       ; Copies length squared to rax.
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
