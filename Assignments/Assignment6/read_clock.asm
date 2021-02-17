;********************************************************************************************
; Program name:          Harmonic Sum                                                       *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 28, 2020													*
; Program Completed:	 December 3, 2020													*
; Last Modified:		 December 3, 2020													*
; Program Description:   This program asks a user to input a value and will return the      *
;                        harmonic sum of that value.                                        *
;                                                                                           *
;                             __n__                                                         *
;                             \      1                                                      *
;            Harmonic Sum =   /     ---                                                     *
;                            /____   i                                                      *
;                            i = 1                                                          *
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
; Program name:   Harmonic Sum			                                       				*
; Languages used: Three modules in x86, One modules in C++ 				                    *
; Files included: manager.asm, read_clock.asm, getfrequency.asm, main.cpp          			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      read_clock.asm                                                           	*
;    Purpose:   Returns the number of cycles/tics that have occured on the cpu since reset. *
;	 Language:	x86-64																		*
;	 Assemble:	nasm -f elf64 -l read_clock.lis -o read_clock.o read_clock.asm			    *
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 main.o manager.o read_clock.o freq.o	    *	                                                        *
;																							*
;********************************************************************************************

global gettime                     ; Makes function callable from other linked files.

section .data
section .bss
section .text

gettime:

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

;----------------------------------READ CLOCK-----------------------------------------------

mov rax, 0  
mov rdx, 0

cpuid                              ; Identifies the type of cpu being used on pc.
rdtsc                              ; Counts the number of cycles/tics occured since pc reset.

shl rdx, 32
add rax, rdx

;---------------------------------END OF FILE-----------------------------------------------

pop r8                             ; Remove extra push of -1 from stack.

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
