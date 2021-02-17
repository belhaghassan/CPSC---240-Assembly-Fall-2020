;====================================================PROGRAM INFORMATION==============================================================
;Program Name: The Harmonic Sum
;Programming Language: x86 Assembly
;
;General Purpose: This program takes asks the user to enter in a number. The harmonic sum
;                 is calculated and displayed using n as the user input.
;
;File Description: read_clock.asm came from assignment 3. This reads in the CPU info 
;                  of the computer running this program. Takes in current CPU tics.
;
;Compile: g++ -c -g -Wall -m64 -no-pie -o main.o main.cpp -std=c++17
;         nasm -g -F dwarf -f elf64 -o manager.o manager.asm
;         nasm -g -F dwarf -f elf64 -o read_clock.o read_clock.asm
;Link: g++ -m64 -no-pie -o a.out -std=c++17 main.o manager.o read_clock.o  
;Execute: ./a.out
;=====================================================================================================================================
;
;
;=====================================================ABOUT THE AUTHOR================================================================
;Author: Justin Bui
;Email: Justin_Bui12@csu.fullerton.edu
;Institution: California State University, Fullerton
;Course: CPSC 240-05
;Start Date: 29 November, 2020
;=====================================================================================================================================
;
;
;
;======================================================COPYRIGHT/LICENSING============================================================
;Copyright (C) 2020 Justin Bui
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
;version 3 as published by the Free Software Foundation.
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
;Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.
;=====================================================================================================================================


;==========================================================START OF MODULE============================================================

extern printf
extern scanf
global get_tics


section .data
	;Nothing defined in section .data

section .bss
	;Nothing defined in section .bss

	
section .text
get_tics:
    ;==========================================================16 PUSHES============================================================

	push rbp                                                    ;Backup rbp
	mov  rbp,rsp                                                ;The base pointer now points to top of stack
	push rdi                                                    ;Backup rdi
	push rsi                                                    ;Backup rsi
	push rdx                                                    ;Backup rdx
	push rcx                                                    ;Backup rcx
	push r8                                                     ;Backup r8
	push r9                                                     ;Backup r9
	push r10                                                    ;Backup r10
	push r11                                                    ;Backup r11
	push r12                                                    ;Backup r12
	push r13                                                    ;Backup r13
	push r14                                                    ;Backup r14
	push r15                                                    ;Backup r15
	push rbx                                                    ;Backup rbx
	pushf                                                       ;Backup rflags
    push rax 

    ;==========================================================DETERMINE CPU TICS============================================================

	cpuid			;Identify your CPU	

	;********************************************************************;
	rdtsc			;Gets number of tics. This combines one half of 	 ;
	;				;rdx and one half of rax into 1 register.			 ;   
	;				;rdtsc = "Read Time Stamp Counter"					 ;
	;																	 ;
	;																	 ;
	;********************************************************************;

	shl rdx, 32		;Shifts the 32 bits of rdx to the the.
	add rax, rdx		
	
endClockReading:
    
    ;==========================================================16 POPS============================================================
    add rsp, 8                                                  ;Makes up for push rax
	popf                                                        ;Restore rflags
	pop rbx                                                     ;Restore rbx
	pop r15                                                     ;Restore r15
	pop r14                                                     ;Restore r14
	pop r13                                                     ;Restore r13
	pop r12                                                     ;Restore r12
	pop r11                                                     ;Restore r11
	pop r10                                                     ;Restore r10
	pop r9                                                      ;Restore r9
	pop r8                                                      ;Restore r8
	pop rcx                                                     ;Restore rcx
	pop rdx                                                     ;Restore rdx
	pop rsi                                                     ;Restore rsi
	pop rdi                                                     ;Restore rdi
	pop rbp                                                     ;Restore rbp


	ret                                               	    
    ;==============================================END OF MODULE=================================================
