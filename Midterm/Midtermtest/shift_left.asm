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
;    Name:      sum.asm                                                                     *
;    Purpose:   To add up all the integers in the array and return the sum back to manager. *
;                                                                                           *
;********************************************************************************************

global shift_left                             ; Makes function callable from other linked files.

section .data     
section .bss

section .text

shift_left:

; Back up all registers to stack and set stack pointer to base pointer
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

push qword -1                           ; Extra push onto stack to make even # of pushes.

mov r12, rdi            ; array
mov r13, rsi            ; size of array

mov r14, 0              ; counter for iteration.

mov r15, [rdi]            ; first value in array

beginloop:

cmp r14, r13
jge endloop

mov r11, [r12 + (r14 + 1) * 8]
mov [r12 + r14 * 8], r11

inc r14

jmp beginloop

endloop:
mov [r12 + (r13 - 1) * 8], r15

; Restores all backed up registers to their original state.
pop rax                                ; Remove extra push of -1 from stack.

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