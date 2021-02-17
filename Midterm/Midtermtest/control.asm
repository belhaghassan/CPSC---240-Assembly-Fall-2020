;********************************************************************************************
; Program name:          Sum of Integers - Array                                            *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the sum of integers in the array.                          *
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
; Program information                                                                       *
;   Program name: Sum of Integers - Array                                                   *
;   Programming languages: One module in C, Four modules in X86, Two modules in c++         *
;   Files in this program: manager.asm, input_array.asm, sum.asm, atol.asm, main.c,         *   
;   					   validate_decimal_digits.cpp, display_array.cpp                   *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      manager.asm                                                                 *
;    Purpose:   To manage all the files in the program and call to functions input_array,   *
;               sum and display_array as needed.                                            *
;                                                                                           *
;********************************************************************************************

extern printf
extern scanf
extern input_array
extern output_array
extern shift_left

array_size equ 100                  ; Capacity limit for number of elements allowed in array.

global control                     ; Makes function callable from other linked files.

section .data

section .bss
    intArray: resq 100                  ; Uninitialized array with 100 reserved qwords.
    
section .text
    the_array db 10, "This is the Array: ", 0
    after_shift db 10, 10, "After shift left: ", 0
    stringFormat db "%s", 0

control:

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
mov qword r13, 0                        ; Reserve register for largest number in array.

;---------------------------CALL FUNCTION INPUT_ARRAY---------------------------------------

push qword 0
mov qword rdi, intArray                 ; Passes array into rdi register.
mov qword rax, 0
call input_array                        ; Calls funtion input_array.
mov r14, rax                            ; Saves copy of input_array output into r14.
pop r8

mov rax, 0
mov rdi, stringFormat
mov rsi, the_array
call printf

;----------------------------OUTPUT ARRAY--------------------------------------

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call output_array                       ; Calls output_array function.

;---------------------------CALL SHIFT-LEFT-------------------------------------------- 

mov qword rdi, intArray                 ; Passes the array
mov qword rsi, r14                      ; Passes number of elements in array.       
mov qword rax, 0
call shift_left                         ; Calls shift function to shift array left.


mov rax, 0
mov rdi, stringFormat
mov rsi, after_shift
call printf

;----------------------------OUTPUT ARRAY--------------------------------------

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call output_array                       ; Calls output_array function.

;---------------------------CALL SHIFT-LEFT-------------------------------------------- 

mov qword rdi, intArray                 ; Passes the array
mov qword rsi, r14                      ; Passes number of elements in array.       
mov qword rax, 0
call shift_left                         ; Calls shift function to shift array left.

mov rax, 0
mov rdi, stringFormat
mov rsi, after_shift
call printf

;----------------------------OUTPUT ARRAY--------------------------------------

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call output_array                       ; Calls output_array function.

;---------------------------CALL SHIFT-LEFT-------------------------------------------- 

mov qword rdi, intArray                 ; Passes the array
mov qword rsi, r14                      ; Passes number of elements in array.       
mov qword rax, 0
call shift_left                         ; Calls shift function to shift array left.

mov rax, 0
mov rdi, stringFormat
mov rsi, after_shift
call printf

;----------------------------OUTPUT ARRAY--------------------------------------

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call output_array                       ; Calls output_array function.

;-----------------------------END OF FILE-----------------------------------------------

; Restores all registers to their original state.
pop rax                                  ; Remove extra push of -1 from stack.
mov qword rax, [intArray]                     ; Copies Largest number in array (r13) to rax.
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
