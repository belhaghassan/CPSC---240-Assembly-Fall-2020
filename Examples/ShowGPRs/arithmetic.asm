;*****************************************************************************************************************************
;Program name: "Volatility Test of GPRs across printf".  This program checks for changes in general registers before and     *
;after a call to printf.  The program will empirically aid in finding stable registers.  Copyright (C) 2020 Floyd Holliday   *
;                                                                                                                            *
;This file is part of the software program "Volatility Test of GPRs across printf".                                          *
;Volatility Test of GPRs across printf is free software: you can redistribute it and/or modify it under the terms of the GNU *
;General Public License version 3 as published by the Free Software Foundation.                                              *
;Volatility Test of GPRs across printf is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without  *
;even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for   *
;more details.  A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.             *
;*****************************************************************************************************************************

;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Volatility Test of GPRs across printf
;  Programming languages: One modules in C and two modules in X86, one module in C++
;  Date program began:     2020-Sep-18
;  Date program completed: 2020-Sep-18
;  Date comments upgraded: 2020-Sep-18
;  Files in this program: integerdriver.c, arithmetic.asm, atol.asm (lib), validate-decimal-digits.cpp (lib), showgprs.asm (lib)
;  Files labeled "lib" are library files containing source code.  They are borrowed without modification for use here.
;  Status: Complete.
;
;Program history
;  This program is a derivation of the open source program Input Integer Validation.  This program continues to
;  carry the same license at the parent program.  All rights conveyed in the parent program are also conveyed
;  in this derived program
;
;References for this program
;  Jorgensen, X86-64 Assembly Language Programming with Ubuntu, Version 1.1.40.
;  Robert Plantz, X86 Assembly Programming.  [No longer available as a free download.😣️]
;
;Purpose
;  Purpose: Emperically test the state of general purpose registers before a call to printf and immediately 
;  the call to printf has terminated.  Four tests have been included in this program and the results have
;  been tabulated.  Four test cases does not 'prove' anything, but four test cases do provide strong 
;  evidence about which registers are always modified by printf, sometimes modified by printf, or never 
;  modified by printf.
;
;This file
;  File name: arithmetic.asm
;  Language: X86-64 with Intel syntax
;  Max page width: 132 columns
;  Assemble: nasm -f elf64 -o arithmetic.o arithmetic.asm
;  Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper



;Declare the names of programs called from this X86 source file, but whose own source code is not in this file.
extern printf                                     ;Reference: Jorgensen book 1.1.40, page48
extern scanf
extern isinteger
extern atolong
extern showgprs                                   ;This is a library function only found at the 240 class website.

;Declare constants if needed
null equ 0                                        ;Reference: Jorgensen book 1.1.40, page 34.
newline equ 10
storage_size equ 32                               ;Number of byte available for incoming numeric char array

;Only entry point is allowed and it is delcared here.
global arithmetic                                 ;Make this program callable by other programs.

segment .data                                     ;Initialized data are placed in this segment

welcome db "Welcome to Input Integer Validation", newline, null
promptforinteger1 db "Enter the first signed integer: ", null
stringformat db "%s",0
outputformat1 db "You entered %ld",newline,null
promptforinteger2 db "Enter the second signed integer: ", 0
farewell db "I hope you enjoyed using my program as much as I enjoyed making it.  Bye.", 10, 0
product_expression db "The product of those two numbers is %ld",10,null
invalid_message db "Invalid inputs have been encountered.  You may run this program again.",10,0

segment .bss                                      ;Uninitialized data are declared in this segment

;Empty segment: there are no un-initialized arrays.

segment .text                                     ;Instructions are placed in this segment
arithmetic:                                       ;Entry point for execution of this program.

;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                          ;Backup rbp
mov  rbp,rsp                                      ;The base pointer now points to top of stack
push rdi                                          ;Backup rdi
push rsi                                          ;Backup rsi
push rdx                                          ;Backup rdx
push rcx                                          ;Backup rcx
push r8                                           ;Backup r8
push r9                                           ;Backup r9
push r10                                          ;Backup r10
push r11                                          ;Backup r11
push r12                                          ;Backup r12
push r13                                          ;Backup r13
push r14                                          ;Backup r14
push r15                                          ;Backup r15
push rbx                                          ;Backup rbx
pushf                                             ;Backup rflags

;Registers rax, rip, and rsp are usually not backed up.


;Output the welcome message                       ;This is a group of instructions jointly performing one task.
mov qword rdi, stringformat
mov qword rsi, welcome
mov qword rax, 0
call printf



;======== Begin first test of printf ===========================

;Prompt for the first integer
mov qword rdi, stringformat
mov qword rsi, promptforinteger1                  ;Place the address of the prompt into rdi
mov qword rax, 0
call showgprs
call printf
call showgprs

;======== End first test of printf ==============================



;Create space for the incoming numeric data
sub rsp, storage_size                             ;32 bytes of memory are available for the incoming data


;Input the first integer
mov qword rax, 0
mov qword rdi, stringformat
mov qword rsi, rsp                                ;Now rsi points to that dummy value on the stack
call scanf                                        ;Call the external function; the new value is placed into the location that rsi points to


;The inputted value is now in memory at starting address rsp
;The next block will scan that string for non-decimal chars
mov rax,0
mov rdi,rsp                                       ;Now rdi points to the start of the inputted data.
call isinteger
mov r13,rax                                       ;Save the response from isinteger in r13: 1 = valid, 0 = invalid

cmp r13,0
je error_message


;Convert the input from ascii string to quadword integer
mov rdi,rsp                                       ;rdi points to the start of the input string
call atolong
mov r13,rax                                       ;r13 holds the inputted data as a quadword integer



;=============== Begin second test of printf ===================================

;Output the value previously entered
mov rax, 0
mov qword rdi, outputformat1
mov rsi, r13
call showgprs
call printf
call showgprs

;============== End second test of printf ========================================



;Output a prompt for the second integer
mov qword rax, 0
mov qword rdi, promptforinteger2
call printf


mov qword rax, 0
mov qword rdi, stringformat
mov qword rsi, rsp                                ;Now rsi points to that dummy value on the stack
call scanf                                        ;Call the external function; the new value is placed into the location that rsi points to


;The inputted value is now in memory at starting address rsp
;The next block will scan that string for non-decimal chars
mov rax,0
mov rdi,rsp                                       ;Now rdi points to the start of the inputted data.
call isinteger
mov rbx,rax                                       ;Save the response from isinteger in r13: 1 = valid, 0 = invalid


cmp rbx,0
je error_message


;Convert the input from ascii string to quadword integer
mov rdi,rsp                                       ;rdi points to the start of the input string
call atolong
mov r14,rax                                       ;r14 holds the inputted data as a quadword integer



;========== Begin third test of printf ===========================

;Output the value previously entered
mov qword rax, 0
mov qword rdi, outputformat1
mov rsi, r14
;mov qword rdx, r14                               ;Both rsi and rdx hold the inputted value as well as r13
call showgprs
call printf
call showgprs

;========== End third test of printf ===============================



;Multiply the two inputted integers
mov rax, r13
imul r14
;The product is now in rdx:rax.  This programmer is going to ignore the rdx and hope that the product fits entirely in rax.
mov r15, rax                            ;The product is backedup in r15


;Show the product.
mov rax, 0
mov rdi, product_expression
mov rsi, r15
call printf



;============ Begin fourth test of printf ========================

;Output the farewell message
mov qword rdi, stringformat
mov qword rsi, farewell                 ;The starting address of the string is placed into the second parameter.
mov qword rax, 0
call showgprs
call printf
call showgprs
mov rax, 0                              ;A zero return value indicates a successful run.
jmp restore

;============ End fourth test of printf =============================



error_message:
mov rax,0
mov rdi,invalid_message
call showgprs
call printf
call showgprs

mov rax, 1                              ;Non-zero return value indicates a failed run.

restore:
add rsp,storage_size                    ;Reverse the earlier sub
popf                                    ;Restore rflags
pop rbx                                 ;Restore rbx
pop r15                                 ;Restore r15
pop r14                                 ;Restore r14
pop r13                                 ;Restore r13
pop r12                                 ;Restore r12
pop r11                                 ;Restore r11
pop r10                                 ;Restore r10
pop r9                                  ;Restore r9
pop r8                                  ;Restore r8
pop rcx                                 ;Restore rcx
pop rdx                                 ;Restore rdx
pop rsi                                 ;Restore rsi
pop rdi                                 ;Restore rdi
pop rbp                                 ;Restore rbp

ret                                     ;Pop the integer stack and jump to the address represented by the popped value.


;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;============== Epilogue ==========================================================================================================

;Run this program and notice that there are 4 pairs of GPR dumps.  For each pair visually detected which registers have changed 
;from the state before printf to state after printf.  The conclusion is as follows.
;The stable registers in all four cases are: rbx, rcx, r12, r13, r14, r15.
;The volatile registers in all four cases are: rdi, rsi, r9
;The unreliable registers are rdx, r8, r10, r11.
;"Unreliable" means these registers are sometimes modified by printf but not always.
;The registers rax, rbp, rsp, rip have been excluded because they are not normally used by programmers for storage of 
;application data.

;Conclusion: Four test cases are not enough to prove any universal rule, but 4 test cases give us strong evidence of 
;which registers the programmer can trust.  The evidence says you can store your data in rbx, rcx, r12, r13, r14, r15 
;when you are making a call to printf.

