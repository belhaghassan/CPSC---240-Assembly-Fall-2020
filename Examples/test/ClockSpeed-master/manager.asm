;Program Name        : Manager
;Programming Language: x86 Assembly
;Program Description : This file is responsible for printing the clock speed
;                      recieved from clock_speed.asm
;
;Author              : Aaron Lieberman
;Email               : AaronLieberman@csu.fullerton.edu
;Institution         : California State University, Fullerton
;
;Copyright (C) 2020 Aaron Lieberman
;This program is free software: you can redistribute
;it and/or modify it under the terms of the GNU General Public License
;version 3 as published by the Free Software Foundation. This program is
;distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
;without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A
;PARTICULAR PURPOSE. See the GNU General Public License for more details.
;A copy of the GNU General Public License v3 is available here:
;<https://www.gnu.org/licenses/>.

extern printf      ; c function
extern clock_speed ; user defined functino

section .data
	output db "Your clock speed is %f GHz", 10, 0

section .text
	global start 

start:
	; 17 pushs
	push rbp
	mov rbp, rsp
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	pushf

	xor rax, rax
	call clock_speed
	
	mov rax, 1
	mov rdi, output
	call printf

	; 17 pops
	popf
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rbp
	ret ; return result
