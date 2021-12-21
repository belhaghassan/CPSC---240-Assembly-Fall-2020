;Program Name        : Clock Speed
;Programming Language: x86 Assembly
;Program Description : This file contains the function clock_speed, which 
;                      parses information from cpuid to obtain the base clock speed
;                      of the users processor and returns it as a float in xmm0
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

extern printf
extern atof

section .text
	global clock_speed

clock_speed:
	; 15 pushes
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

	mov r14, 0x80000003 ; this value is passed to cpuid to get information about the processor
	xor r15, r15  ; set loop control variable for section_loop equal to 0
	xor r11, r11  ; set the counter/flag for character collection equal to 0

section_loop:
	xor r13, r13  ; zero the loop control variable for register loop

	mov rax, r14  ; get processor brand and information
	cpuid         ; cpu identification
	inc r14       ; increment the value passed to get the next section of the string

	push rdx      ; 4th set of chars
	push rcx      ; 3rd set of chars
	push rbx      ; 2nd set of chars
	push rax      ; 1st set of chars


register_loop:
	xor r12, r12  ; zero the loop control variable for char loop
	pop rbx       ; get new string of 4 chars

char_loop:
	mov rdx, rbx  ; move string of 4 chars to rdx
	and rdx, 0xFF ; gets the first char in string 
	shr rbx, 0x8  ; shifts string to get next char in next iteration

	cmp rdx, 64   ; 64 is the char value for the @ sign
	jne counter   ; leaves r11, does not set flag
	mov r11, 1    ; flag and counter to start storing chars in r10

counter:
	cmp r11, 1    ; checks if flag is true
	jl body       ; skips incrementing if flag is false
	inc r11       ; increments counter if flag is true

body:
	cmp r11, 4    ; counter is greater than 4
	jl loop_conditions
	cmp r11, 7    ; counter is less than 7
	jg loop_conditions

	shr r10, 0x8  ; r10 acts as a queue for characters
	shl rdx, 0x18 ; moves new character from rdx into free space for r10
	or r10, rdx   ; combine the registers

loop_conditions:
	inc r12
	cmp r12, 4 ; char loop
	jne char_loop

	inc r13
	cmp r13, 4 ; register loop
	jne register_loop

	inc r15
	cmp r15, 2 ; string loop
	jne section_loop

exit:
	push r10
	xor rax, rax
	mov rdi, rsp 
	call atof  ; converts the string representing the clock speed to a float
	pop r10    ; the value to be returned is already in xmm0, and will be returned

	; 15 pops
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
	ret  ; return xmm0

