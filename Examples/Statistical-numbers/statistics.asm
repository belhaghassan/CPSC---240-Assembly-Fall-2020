;****************************************************************************************************************************
;Program name: "Statistical Numbers".  This program demonstrates how to clear the state of the input stream following an    *
;action that placed it into a failed state.  Clearing the failed state is necessary in order to continue receiving inputs   *
;from the standard input stream.  Copyright (C) 2019 Floyd Holliday.                                                        *
;This program is free software: you may redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;****************************************************************************************************************************

;Author: F. Holliday
;Author email: holliday@fullerton.edu

;Program name: Statistical Numbers
;Programming languages: C++ and X86
;Date of last modification: 2019-Sep-08
;Files in the program: stats.cpp, statistics.asm, run.sh
;Status: Testing has been successful
;Future: Separate some of the functionality in statistics.asm into one, or two, or more files containing functions.

;Declare the names of function defined outside of this file that will be called from within this file.
extern scanf 
extern printf
extern getchar
extern stdin
extern clearerr

global average               ;Allow this module (function) to be called from outside of this file.

segment .data
introduction db 10, "We will compute the mean for you using only integers.", 10, 0
prompt_message db "Enter a sequence of long integers.  After each integer enter white space.  After the last white space press enter followed by Cntl+D.",10, 
          db "If you have no data press Cntl+d now to exit.", 10, 0
computed_results db 10, 10, "The number of numbers entered was %ld and the mean is %ld.", 10, 0
meanMsg db "The integer mean was %ld.", 10, 10, 0
query_message db "Do you have sets of integers to process?",10,
              db "Entering cntl+d twice has the same outcome as entering n.  Please enter your response (y or n or cntl+d):", 0
goodbye_message1 db 10, 10, "Patrick Henry hopes you liked your means. Please come again.", 10, 0
goodbye_message2 db "This software will return the last mean to the driver program. Bye", 0

stringformat db "%s", 0
numberformat db "%ld", 0

segment .bss                  ;Location were uninitialized arrays are declared.
;Currently empty
myarray resq 8

segment .text
average:

;Back up all the GPR for the benefit of any function which may call this one.
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

mov r12,-1                              ;Default value to be returned when no data are inputted.

;=======================================Initial Message============================================
mov qword rax, 0
mov rdi, stringformat
mov rsi, introduction
call printf

;=======================================Query Message==============================================
mov rax, 0
mov rdi, query_message
call printf

;=======================================Get the answer from customer==============================
push qword 0
mov rax, 0
call getchar
mov r14,rax
pop rax

push qword 0
mov rax, 0
call getchar
pop rax

begin_outer_loop:;======================Begin outer loop==========================================
cmp r14,'y'
jne conclusion

;=======================================Begin inner loop==========================================
   ;Set counter and accumulator to zero
   mov r15, 0                             ;r15 is the counter
   mov r13, 0                             ;r13 ia the accumulator

   ;Display instructions for entering integers
   mov qword rax, 0
   mov rdi, stringformat
   mov rsi, prompt_message                ;"Enter a sequence of long integers.  After each integer enter white space."
   call printf

   input_numbers:

   ;Input one integer or one cntl+D
   mov rax, 0
   mov rdi, numberformat
   push qword 0
   mov rsi, rsp
   call scanf

   ;Check for possible cntl+D indicating end of inputs
   cdqe
   cmp rax, -1
   je exit_inner_loop
   pop rax
   add r13, rax
   inc r15

   jmp input_numbers

   exit_inner_loop: ;===================End inner loop=============================================



pop rax                                 ;Correction for unbalanced pushes and pops in preceding loop

;Compute mean
mov rax, qword r13
cqo
idiv qword r15                      ;r15 = counter
mov r12, rax                        ;The mean is now in r12

;Display the count and the mean
mov rax, 0
mov rdi, computed_results
mov rsi, r15
mov rdx, r12
call printf

;=======================================Query Message==============================================
mov rax, 0
mov rdi, query_message                  ;"Do you have sets of integers to process (y or n)?"
call printf

;=======================================Get the answer from customer==============================
;It is expected that the user will input either y <enter> or n <enter>.  In the following 
;instructions first the character is read and saved in r14, then the <enter> is removed from the
;input stream and is discarded.
mov rax, 0
call getchar
mov r14,rax
mov rax, 0
call getchar

jmp begin_outer_loop

;===== Output final messages ======================================================================
conclusion:
mov qword rax, 0
mov rdi, stringformat
mov rsi, goodbye_message1               ;"Patrick Henry hopes you liked your means.
call printf

mov qword rax, 0
mov rdi, stringformat
mov rsi, goodbye_message2               ;"This software will return the last mean to the driver program. Bye"
call printf

mov rax, r12                            ;The computed mean was saved in r12.  Now return that mean to the caller.

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

ret


