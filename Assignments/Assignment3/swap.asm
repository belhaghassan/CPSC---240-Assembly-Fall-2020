;********************************************************************************************
; Program name:          Sorting Array                                                      *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 October 12, 2020													*
; Program Completed:	 October 23, 2020													*
; Last Modified:		 October 31, 2020													*
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the same array but sorted in ascending order.              *
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
; Program name:   Sorting Array			                                       				*
; Languages used: One module in C, Five modules in x86, Three modules in C++ 				*
; Files included: manager.asm, input_array.asm, swap.asm, atol.asm, read_clock.asm 			*   
;   			  main.cpp, isinteger.cpp, display_array.cpp, bubble_sort.c      			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      swap.asm                                                            		*
;    Purpose:   Takes two addresses/pointers and swaps the values inside them.              *
;	 Language:	x86-64																		*
;	 Assemble:  nasm -f elf64 -l swap.lis -o swap.o swap.asm                      			*
;	 Link:		gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o 		*
;				swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o		*
;																							*
;********************************************************************************************

global swap                             ; Makes function callable from other linked files.

section .data     
section .bss

section .text

swap:

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

push qword -1                      ; Extra push onto stack to make even # of pushes.

;--------------------------------SWAP ALGORITHM---------------------------------------------

mov r12, [rdi]                     ; Copies the value in rdi and places it in r12.
mov r13, [rsi]                     ; Copies the value in rsi and places it in r13.

mov [rsi], r12                     ; Copies value originally in rdi into address of rsi.
mov [rdi], r13                     ; Copies value originally in rsi into address of rdi.

;---------------------------------END OF SWAP-----------------------------------------------

pop rax                            ; Remove extra push of -1 from stack.

; Restores all backed up registers to their original state.
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