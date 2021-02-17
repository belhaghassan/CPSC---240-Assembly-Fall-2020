;****************************************************************************************************************************
;Program name: "Validate Integer Input".  This program demonstrates how to validate input received from scanf as valid      *
;integer data.  Copyright (C) 2020 Floyd Holliday                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
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
;  Program name: Validate Integer Input
;  Programming languages: Two modules in C++ and one module in X86
;  Date program began: 2020-Sep-02
;  Date of last update: 2020-Sep-02
;  Date of reorganization of comments: 2020-Sep-03
;  Files in this program: validate-driver.cpp, test-validation.asm, test-scanf.cpp
;  Status: In testing phase
;
;This file
;   File name: test-validation.asm
;   Language: X86, 64-bit target machine
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l test-validation.lis -o valid.o test-validation.asm


;===== Begin code area ==============================================================================================================


;Assembler directives
extern printf
extern atol
extern stol
extern scanf
extern isinteger
max_tries equ 3
global testmodule

segment .data

welcome db "The asm function 'testmodule' has begun executing.", 10, 10, 0
prompt db "Please enter an integer.  The input may be preceeded by a plus or minus sign: ",0
stringformat db "%s",0
newmessage db "The new long integer created from a string is %ld",10,0
error_message db "The input is invalid. Please try again",10,0
timeout_message db "Exceeded number of allowed attempts.  Bye",10,0


segment .bss  ; Reserved for uninitialized arrays
   ;Empty
   
segment .text
testmodule:

;Prolog  Back up the GPRs
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

;Display a welcome message to the viewer.
mov rax, 0             ;A zero in rax means printf uses no data from xmm registers
mov rdi, welcome       ;"The asm function 'testmodule' has begun executing."
call printf

;Create 256 bytes of space for potentially long input string
sub rsp, 256

;Initialize the counter for number of attempt to enter valid data.
mov r15,0

begin_loop:

cmp r15, max_tries
jge timed_out

;Display a prompt requesting an integer for input
mov rax, 0
mov rdi, prompt        ;"Please enter an integer.  The input may be preceeded by a plus or minus sign: "
call printf



;===== Begin validation of input =====================================================================================;|
;===== Strategy for validating integer input begins here =============================================================;|
;Step 1: Read the input as a string terminated by null                                                                ;|
;Step 2: Call the isinteger function which returns 1 if all char in the string are decimal digits; returns 0 otherwise;|
;Step 3a: Call the atol function to convert the validated string to a quadword signed integer.  Done                  ;|
;Step 3b: Give the user additional chances to input a valid string.  After 3 tries terminate execution.               ;|
                                                                                                                      ;|
;Block to input an integer                                                                                            ;|
mov rax, 0;                                                                                                           ;|
mov rdi, stringformat  ;"%s"                                                                                          ;|
mov rsi, rsp           ;rsi points to the start of free space                                                         ;|
call scanf                                                                                                            ;|
                                                                                                                      ;|
;Block to validate the recent input                                                                                   ;|
mov rdi, rsp                                                                                                          ;|
call isinteger                                                                                                        ;|
mov r13, rax           ;Save a copy of the return from isinteger in r13                                               ;|
                                                                                                                      ;|
cmp r13,0                                                                                                             ;|
je error_in_input                                                                                                     ;|
                                                                                                                      ;|
;Block: call atol to convert string starting at rsp into a numeric integer in a register.                             ;|
;Caveat: numerically wrong results will be produced if the string is long and causes the integer to overflow.         ;|
mov rax, 0                                                                                                            ;|
mov rdi,rsp                                                                                                           ;|
call atol                                                                                                             ;|
mov r14,rax            ;Save a copy of the newly created integer in r14                                               ;|
                                                                                                                      ;|
;====================== End of validation block ======================================================================;|

;View the newly created integer currently residing in r14
mov rax,0
mov rdi,newmessage
mov rsi,r14
call printf

jmp conclusion

error_in_input:
mov rax,0
mov rdi,error_message
call printf

inc r15

jmp begin_loop

timed_out:
mov rax,0
mov rdi,timeout_message
call printf
mov r14,r15

conclusion:
mov rax, r14            ;long int return number
add rsp, 256
;Epilogue: restore data to the values held before this function was called.
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
pop rbp               ;Restore the base pointer of the stack frame of the caller.
ret

;========================================================================================
