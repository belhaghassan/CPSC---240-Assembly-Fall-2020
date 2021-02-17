;****************************************************************************************************************************
;Program name: "Floating IO".  This program demonstrates the input of multiple float numbers from the standard input device *
;using a single instruction and the output of multiple float numbers to the standard output device also using a single      *
;instruction.  Copyright (C) 2019 Floyd Holliday.                                                                           *
;                                                                                                                           *
;This file is part of the software program "Floating IO".                                                                   *
;Floating IO is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;Floating IO is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Floating IO
;  Programming languages: One modules in C and one module in X86
;  Date program began: 2019-Oct-25
;  Date of last update: 2019-Oct-26
;  Date of reorganization of comments: 2019-Oct-29
;  Files in this program: manage-floats.c, float-input-output.asm
;  Status: Finished.  The program was tested extensively with no errors in Xubuntu19.04.
;
;This file
;   File name: float-input-output.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l float-input-output.lis -o float-input-output.o float-input-output.asm


;===== Begin code area ================================================================================================
extern printf
extern scanf
global floatio

segment .data
welcome db "The Assembly function floatio has begun execution",10,0
input1prompt db "Please input 1 floating point number and press enter with no ws.  Do not press cntl+d: ",0
input2prompt db "Please input 2 floating point numbers separated by ws and press enter.  Do not press cntl+d: ",0
input3prompt db "Please input 3tax floating point numbers separated by ws and press enter.  Do not press cntl+d: ",0
good_bye db "The floating module will return the large number to the caller.  Have a nice afternoon",10,0
one_float_format db "%lf",0
two_float_format db "%lf %lf",0
three_float_format db "%lf%lf%lf",0
output_one_float db "The one number is %5.3lf",10,0
output_two_float db "The two numbers are %5.3lf and %5.3lf.",10,0
output_three_float db "The three numbers in ascending order are %7.5lf, %7.5lf, and %7.5lf",10,0

segment .bss  ;Reserved for uninitialized data

segment .text ;Reserved for executing instructions.

floatio:

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
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

;Registers rax, rip, and rsp are usually not backed up.
push qword 0


;Display a welcome message to the viewer.
mov rax, 0                     ;A zero in rax means printf uses no data from xmm registers.
mov rdi, welcome               ;"The Assembly function floatio has begun execution"
call printf

;============= Begin section to input exactly one float number ========================================================
push qword 0
;Display a prompt message asking for inputs
mov rax, 0
mov rdi, input1prompt          ;"Please input 1 floating point numbers using the keyboard: "
call printf
pop rax

;Begin the scanf block
push qword 0
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm10, [rsp]

;Display one float number
mov rax, 1                     ;printf will need access to thhis many 
mov rdi, output_one_float      ;"The one number is %5.3lf"
movsd xmm0, xmm10
call printf

pop rax                        ;Reverse the push in the scanf block
;============= End of section to input one float number ===============================================================


;============= Begin section to input two float numbers using one call to scanf =======================================
;Display a prompt message asking for inputs
push qword 99
mov rax, 0
mov rdi, input2prompt          ;"Please input 2 floating point numbers using the keyboard: "
call printf
pop rax


push qword 99 ;Get on boundary
;Create space for 2 float numbers
push qword -1
push qword -2
mov rax, 0
mov rdi, two_float_format      ;"%lf%lf"
mov rsi, rsp                   ;rsi points to first quadword on the stack
mov rdx, rsp
add rdx, 8                     ;rdx points to second quadword on the stack
call scanf

movsd xmm12, [rsp]
movsd xmm13, [rsp+8]
pop rax                        ;Reverse the previous "push qword -2"
pop rax                        ;Reverse the previous "push qword -1"
pop rax                        ;Reverse the previous "push qword 99"

;Display 2 float numbers
push qword 99                  ;Get on the boundary
mov rax, 2
mov rdi, output_two_float
movsd xmm0, xmm12
movsd xmm1, xmm13
call printf
pop rax                        ;Reverse previous "push qword 99"

;============= End of section to input two float numbers ==============================================================


;============= Begin section to input three float numbers using only one call to scanf ================================

;Display a prompt message asking for inputs (The next block of instructions)
push qword 99
mov rax, 0
mov rdi, input3prompt          ;"Please input 3 floating point numbers separated by ws and press enter.  Do not press cntl+d: "
call printf
pop rax

;Input 3 float numbers (The next block of instructions)
push qword -1
push qword -2
push qword -3
mov rax, 0
mov rdi, three_float_format  ;"%lf%lf%lf"
mov rsi, rsp                   ;rsi points to first quadword on the stack
mov rdx, rsp
add rdx, 8                     ;rdx points to second quadword on the stack
mov rcx, rsp
add rcx, 16                    ;rcx points to third quadword on the stack
call scanf
movsd xmm5, [rsp]
movsd xmm6, [rsp+8]
movsd xmm7, [rsp+16]
pop rax                        ;Reverse the previous "push qword -3"
pop rax                        ;Reverse the previous "push qword -2"
pop rax                        ;Reverse the previous "push qword -1"

;============= End of the section that inputs three number using one call to scanf ====================================


;============= Begin section that organizes the three recently inputted numbers =======================================

;Sort out the mess of 3 numbers
ucomisd xmm5, xmm6             ;Compare two floating point numbers
jbe next1
   movsd xmm1, xmm5
   movsd xmm5, xmm6
   movsd xmm6, xmm1
next1:
ucomisd xmm5, xmm7             ;Compare two floating point numbers
jbe next2
   movsd xmm1, xmm5
   movsd xmm5, xmm7
   movsd xmm7, xmm1
next2:
ucomisd xmm6, xmm7             ;Compare two floating point numbers
jbe next3
   movsd xmm1, xmm6
   movsd xmm6, xmm7
   movsd xmm7, xmm1
next3:

;Display the three numbers (the next block of instructions)
push qword 99                  ;Get on the boundary
mov rax, 3                     ;printf will need to access this many SSE registers.
mov rdi, output_three_float    ;"The three numbers in ascending order are %7.5lf, %7.5lf, and %7.5lf"
movsd xmm0, xmm5
movsd xmm1, xmm6
movsd xmm2, xmm7
movsd xmm15, xmm7              ;Make a backup copy
call printf
pop rax                        ;Reverse previous "push qword 99"

;============= End of organizing the three numbers ====================================================================


;============= Prepare to exit from this program ======================================================================

;Display good-bye message (the next block of instructions)
mov rax, 0
mov rdi, good_bye              ;"The floating module will return the large number to the caller.  ....."
call printf

pop rax                        ;Reverse the push near the beginning of this asm function.

movsd xmm0, xmm15              ;Select the largest value for return to caller.

;===== Restore original values to integer registers ===================================================================
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

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
