;*****************************************************************************************************************************
;Program name: "Integer Arithmetic".  This program demonstrates how to input and output long integer data and how to per-   *
;form a few simple operations on integers.  Copyright (C) 2019 Floyd Holliday                                               *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;*****************************************************************************************************************************

;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Integer Arithmetic
;  Programming languages: One modules in C and one module in X86
;  Date program began:     2012-Nov-01
;  Date program completed: 2012-Nov-04
;  Date comments upgraded: 2019-July-01 and 2020-Jan-22
;  Files in this program: integerdriver.c, arithmetic.asm, r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;References for this program
;  Jorgensen, X86-64 Assembly Language Programming with Ubuntu, Version 1.1.40.
;  Robert Plantz, X86 Assembly Programming.  [No longer available as a free download]
;
;Purpose
;  Show how to perform arithmetic operations on two operands both of type long integer.
;  Show how to handle overflow of multiplication.
;
;This file
;   File name: arithmetic.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l arithmetic.lis -o arithmetic.o arithmetic.asm
;   Link: gcc -m64 -no-pie -o current.out driver.o arithmetic.o        ;Ref Jorgensen, page 226, "-no-pie"
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper






;%include "debug.inc"                             ;Not used in this program: this line may be safely deleted.

;Declare the names of programs called from this X86 source file, but whose own source code is not in this file.
extern printf                                     ;Reference: Jorgensen book 1.1.40, page48
extern scanf

;Declare constants if needed
null equ 0                                        ;Reference: Jorgensen book 1.1.40, page 34.
newline equ 10

global arithmetic                                 ;Make this program callable by other programs.

segment .data                                     ;Initialized data are placed in this segment

welcome db "Welcome to Integer Arithmetic", newline, null
promptforinteger1 db "Enter the first signed integer: ", null
outputformat1 db "You entered %ld = 0x%lx", 10, 0
stringoutputformat db "%s", 0
signedintegerinputformat db "%ld", null
promptforinteger2 db "Enter the second signed integer: ", 0
outputformat2long db "The product is %ld = 0x%lx", 10, 0
outputformat2short db "The product is 0x%lx", 10, 0
outputformat3 db "The quotient is %ld = 0x%lx, and the remainder is %ld = 0x%lx", 10 , 0
productformatlong db "The product requires more than 64 bits.  It's value is 0x%016lx%016lx", 10, 0
productformatshort db "The product is %ld = 0x%016lx", 10, 0
quotientformat db "The quotient is %ld = 0x%016lx", 10, 0
remainderformat db "The remainder is %ld = 0x%016lx", 10, 0
farewell db "I hope you enjoyed using my program as much as I enjoyed making it.  Bye.", 10, 0

segment .bss                                      ;Uninitialized data are declared in this segment

;Empty segment: there are no un-initialized arrays.

segment .text                                     ;Instructions are placed in this segment
arithmetic:                                       ;Entry point for execution of this program.

;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
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
push qword -1                                                       ;Backup rflags

;There are 15 pushes above.  Make one more push of any value so that the number of pushes is an even number
push qword -1                                               ;Now the number of pushes is even
;Registers rax, rip, and rsp are usually not backed up.

;Output the welcome message                       ;This is a group of instructions jointly performing one task.
mov qword rdi, stringoutputformat
mov qword rsi, welcome
mov qword rax, 0
call printf

;Prompt for the first integer
mov qword rdi, stringoutputformat
mov qword rsi, promptforinteger1                  ;Place the address of the prompt into rdi
mov qword rax, 0
call printf

;Input the first integer
mov qword rdi, signedintegerinputformat
push qword -1                                     ;Place an arbitrary value on the stack; -1 is ok, any quad value will work
mov qword rsi, rsp                                ;Now rsi points to that dummy value on the stack
mov qword rax, 0                                  ;No vector registers
call scanf                                        ;Call the external function; the new value is placed into the location that rsi points to
pop qword r14                                     ;First inputted integer is saved in r14

;Output the value previously entered
mov qword rdi, outputformat1
mov rsi, r14                    ;Integar is in r14
mov qword rdx, r14                                ;Both rsi and rdx hold the inputted value as well as r14
mov qword rax, 0
call printf

;Output a prompt for the second integer
mov qword rdi, stringoutputformat
mov qword rsi, promptforinteger2
mov qword rax, 0
call printf

;Input the second integer
mov qword rdi, signedintegerinputformat
push qword 999                                    ;Place an arbitrary value on the stack
mov qword rsi, rsp                                ;Now rsi points to the top of the stack
mov qword rax, 0
call scanf                                        ;The new value is placed on top of the stack
pop r15                                           ;The second inputted value is in r15 for safekeeping

;Output the value previously entered
mov qword rdi, outputformat1                                   
mov qword rsi, r15
mov qword rdx, r15                                ;All 3 registers hold a copy of the inputted value: rsi, rdx, r15
mov qword rax, 0
call printf

;Perform the signed multiplication of two integers: rdx:rax <-- rax * r15 where rax holds a copy of the first input
;Multiplication is explained in the Jorgensen book, version 1.1.40, starting page 87 if the two operands are unsigned
;integers, and starting on page 91 if both operands are signed integers.
;Summary: this is what the Jorgensen book say to do to multiply two 64-bit integers using the single operand form of 
;multiplication: 
;1.  Copy the first operand into rax.
;2.  Make sure rdx is available (does not now hold valuable data)
;3.  Copy the second operand into another available register, say r15
;4.  Use the instruction "imul r15" without quotes assuming that either operand may be a signed integer.
;5.  The product will be in rax -- unless the product is so large it will not fit into the 64 bits provided by rax.  In this
;    later case the product will span two registers rdx:rax.  We use this 'single operand' technique below.

mov qword rax, r14                                ;Copy the first factor (operand) to rax
mov qword rdx, 0                                  ;rdx contains no data we wish to save.
imul r15                                          ;Use the signed multiplication instruction 'imul' followed by the second factor

;Now the product r14*r15 is in the pair rdx:rax. If the product will fit entirely in 64 bits then it will be store completely 
;in rax and rdx is not needed.  Nevertheless, we save both registers in the following 2 instructions.
mov qword r12, rdx                                ;High order bits are saved in r12
mov qword r13, rax                                ;Low order bits are saved in r13

;Several references were consulted.  All stated that in the case of imul the flags cf and of change in unison.  Specifically,
;when the product overflows beyond 64 bits both cf and of are set to 1, otherwise they are unset to 0.  We use the of flag here.
;The 'jo' in the next instruction means continue processing if the of variable called flag is equal to 1.
jo multiplicationoverflow                         ;if(of==true) then continue execution at the multiplicationoverflow marker.

;Output the computed product where 64 or less bits are needed for storage.
mov qword rdi, productformatshort
mov qword rsi, r13                                ;The low order bits are placed in the second parameter
mov qword rdx, r13                                ;The exact same bits are placed in the third parameter
mov qword rax, 0                                  ;Zero in rax
call printf
jmp divisionsection                               ;Continue execution at the divisionsection marker

multiplicationoverflow:
;Output the computed product where more than 64 bits are needed for storage of the product.
mov qword rdi, productformatlong
mov qword rsi, r12                                ;The high order bits are placed in the second parameter
mov qword rdx, r13                                ;The low order bits are placed in the third parameter
mov qword rax, 0                                  ;Zero in rax indicates no vector parameters
call printf

divisionsection:
;Divide the first integer by the second integer
;Division of integers is explained in the Jorgensen book, version 1.1.40, starting on page 90.  If operands, dividend
;and divisor, are unsigned use the instruction div, otherwise use the instruction idiv.  We have signed integers here
;and therefore we use the assembly instruction idiv.  First it is necessary to set up the dividend pair rdx:rax.  The
;Jorgensen book shows this setup on page 100.  We do the same thing directly below.
mov qword rax, r14                                ;The first integer is in rax
cqo                                               ;Sign extend the first integer to rdx:rax. Ref Jorgensen, page 777
idiv r15                                          ;Divide rdx:rax by r15
mov r13, rdx                                      ;Save the remainder in r13 for later use

;Show the quotient
mov qword rdi, quotientformat
mov qword rsi, rax                                ;Copy the quotient to rsi
mov qword rdx, rax                                ;Copy the quotient to rdx
mov qword rax, 0
call printf

;Show the remainder
mov qword rdi, remainderformat
mov qword rsi, r13                                ;Copy the remainder to rsi
mov qword rdx, r13                                ;Copy the remainder to rdx
mov qword rax, 0
call printf

;Output the farewell message
mov qword rdi, stringoutputformat
mov qword rsi, farewell                           ;The starting address of the string is placed into the second parameter.
mov qword rax, 0
call printf

;Restore the original values to the general registers before returning to the caller.
pop rax                                                     ;Remove the extra -1 from the stack
pop rax                                                        ;Restore rflags
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

mov qword rax, 0                                  ;Return value 0 indicates successful conclusion.
ret                                               ;Pop the integer stack and jump to the address represented by the popped value.
