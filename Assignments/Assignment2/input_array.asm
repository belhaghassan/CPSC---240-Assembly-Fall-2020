;********************************************************************************************
; Program name:          Sum of Integers - Array                                            *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the sum of integers in the array.                          *
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
; Program information                                                                       *
;   Program name: Sum of Integers - Array                                                   *
;   Programming languages: One module in C, Four modules in X86, Two modules in c++         *
;   Files in this program: manager.asm, input_array.asm, sum.asm, atol.asm, main.c,         *   
;   					   validate_decimal_digits.cpp, display_array.cpp                   *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      input_array.asm                                                             *
;    Purpose:   To accept a users input of integers and save it into an array then send     *
;               the total number of elements inputed into the array back to manager.        *
;                                                                                           *
;********************************************************************************************

extern printf
extern scanf
extern atolong
extern isinteger

global input_array                  ; Makes function callable from other linked files.

section .data
    invalid db "The last input was invalid and not entered into the array.", 10, 0
    stringFormat db "%s", 0

section .bss

section .text

input_array:

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

push qword -1                           ; Extra push to create even number of pushes

;-----------------------------INITIALIZE PARAMETERS-----------------------------------------
mov qword r15, rdi                      ; Address of array saved to r15.
mov qword r14, rsi                      ; Max number of elements allowed in array.
mov qword r13, 0                        ; Set counter to 0 elements in Array.


;---------------------------------START OF LOOP---------------------------------------------
begin_loop:

; Scanf function called to take user input.
mov qword rdi, stringFormat
push qword 0
mov qword rsi, rsp                      ; Stack pointer points to where scanf outputs.
mov qword rax, 0
call scanf

; Tests if Control + D is entered to finish inputing into array.
cdqe
cmp rax, -1                          
je end_of_loop                          ; If control + D is entered, jump to end_of_loop.

;------------------------------INPUT VALIDATION---------------------------------------------
; Checks to see if each character in the input string of integers is from 0 to 9.

mov qword rax, 0
mov qword rdi, rsp
call isinteger
cmp rax, 0                              ; Checks to see if isinteger returned true/false.
je invalid_input                        ; If isinteger returns 0. jump to not_an_int label.

;---------------------------------ASCII TO LONG---------------------------------------------
; Converts string of characters (user input) into a long integer. 

mov qword rax, 0
mov qword rdi, rsp
call atolong                            
mov qword r12, rax                      ; Saves output long integer from atolong in r12.
pop r8                                  ; Pop off stack into any scratch register. 

;--------------------------------COPY INTO ARRAY--------------------------------------------
; Adds copy of long integer saved in r12 into array at index of counter (r13).

mov [r15 + 8 * r13], r12                ; Copies user input into array at index of r13.
inc r13                                 ; Increments counter r13 by 1.

;-----------------------------ARRAY CAPACITY TEST-------------------------------------------
; Tests to see if max array capacity has been reached.
cmp r13, r14                            ; Compares # of elements (r13) to capacity (r14).
je exit                                 ; If # of elements equals capacity, exit loop.

; Restarts loop.
jmp begin_loop

;--------------------------------INVALID INPUT----------------------------------------------
; Prints out invalid input statement and restarts loop and pops stack to offset initial push
; at the beginning of the loop.

invalid_input:
mov rdi, stringFormat
mov rsi, invalid 
mov rax, 0
call printf
pop r8                                 ; Pop off stack to any scratch register.  
jmp begin_loop                         ; Restarts loop.

;---------------------------------END OF LOOP-----------------------------------------------

; After control+D is entered the loop is skipped and so is the pop in the loop
; therefore this controlD block makes up for that missed pop.
end_of_loop:
pop r8                                  ; Pop off stack into any scratch register.                

;------------------------------------EXIT---------------------------------------------------
exit:

; Restore all backed up registers to their original state.
pop rax                                 ; Remove extra push of -1 from stack.
mov qword rax, r13                      ; Copies # of elements in r13 to rax.
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
