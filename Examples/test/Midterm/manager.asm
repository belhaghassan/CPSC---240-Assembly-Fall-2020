;********************************************************************************************
; Program name:          Reverse Array                                                      *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns array in reverse.                                          *
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

extern printf
extern scanf
extern input_array
extern display_array
extern reverse

array_size equ 100                  ; Capacity limit for number of elements allowed in array.

global manager                     ; Makes function callable from other linked files.

section .data
    intructions db "This program will reverse an array of integers", 10, 
                db "Please enter integers separated by ws. Press enter followed by Control+D"
                db " to finish", 10, 0
    numsreceived db "The values in the array are: ", 0
    reversed db "The array has been reversed", 10, 0
    negative db "Negative 1 will be returned to the driver.", 10, 0
    stringFormat db "%s", 0 

section .bss
    intArray: resq 100                  ; Uninitialized array with 100 reserved qwords.

section .text

manager:

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

;-----------------------------INITIALIZE PARAMETERS-----------------------------------------
mov qword r14, 0                        ; Reserve register for number of elements in array.
mov qword r13, 0                        ; Reserve register for Sum of integers in array

;-------------------------------INSTRUCTION PROMPT------------------------------------------

mov qword rdi, stringFormat                     
mov qword rsi, intructions              
mov qword rax, 0
call printf                             ; Prints out intructionS prompt.

;---------------------------CALL FUNCTION INPUT_ARRAY---------------------------------------

mov qword rdi, intArray                 ; Passes array into rdi register.
mov qword rsi, array_size               ; Passes the max array size into rsi register.
mov qword rax, 0
call input_array                        ; Calls funtion input_array.
mov r14, rax                            ; Saves copy of input_array output into r14.

;-------------------------CONFIRMS OUTPUT OF INPUTTED VALUES--------------------------------

mov qword rdi, stringFormat
mov qword rsi, numsreceived
mov qword rax, 0
call printf                             ; Prints out received confirmation

;----------------------------DISPLAY ELEMENTS OF ARRAY--------------------------------------
; Calls display_array that prints out each integer in the array seperated by 1 space.

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call display_array                      ; Calls display_array function.

;------------------------------------REVERSE-----------------------------------------------
mov rax, 0
mov rdi, intArray
mov rsi, r14
call reverse

mov rax, 0
mov rdi, stringFormat
mov rsi, reversed
call printf

mov qword rdi, stringFormat
mov qword rsi, numsreceived
mov qword rax, 0
call printf    

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call display_array                      ; Calls display_array function.

mov rax, 0
mov rdi, stringFormat
mov rsi, negative
call printf

;---------------------------------END OF FILE-----------------------------------------------

; Restores all registers to their original state.
pop rax                                 ; Remove extra push of -1 from stack.
mov qword rax, -1                      ; Copies Sum (r13) to rax.
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
