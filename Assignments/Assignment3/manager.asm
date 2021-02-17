;********************************************************************************************
; Program name:          Sorting Array                                                      *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 October 12, 2020													*
; Program Completed:	 October 23, 2020													*
; Last Modified:		 October 31, 2020													*
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the same array but sorted in ascending order.              *
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
; Program Information                                                                       *
; Program name:   Sorting Array			                                       				*
; Languages used: One module in C, Five modules in x86, Three modules in C++ 				*
; Files included: manager.asm, input_array.asm, swap.asm, atol.asm, read_clock.asm 			*   
;   			  main.cpp, isinteger.cpp, display_array.cpp, bubble_sort.c      			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      manager.asm                                                           		*
;    Purpose:   To manage all the files in the program and call functions input_array,      *
;               bubblesort and display_array and returns largest value in array to main.    *
;	 Language:	x86-64																		*
;	 Assemble:	nasm -f elf64 -l manager.lis -o manager.o manager.asm			            *
;	 Link:		gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o 		*
;				swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o		*
;																							*
;********************************************************************************************

;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf
extern input_array
extern display_array
extern bubbleSort

array_size equ 100                 ; Capacity limit for number of elements allowed in array.

global manager                     ; Makes function callable from other linked files.

section .data
    intructions db "This program will sort your array of integers", 10, 
                db "Enter a sequence of long integers separated by white space.", 10, 
                db "After the last input press enter followed by Control+D:", 10, 0
    numsreceived db 10, "These numbers were received and placed into the array:", 10, 0
    sort_confirm db 10, "The array has been sorted by the bubble sort algorithm", 10,
                 db 10, "This is th order of the values in the array now:", 10, 0
    largestnumber db 10, "The largest number in the array will now be returned to ",
                  db "the main function.", 10, 0
    stringFormat db "%s", 0 
    numberFormat db "%ld", 0

section .bss
    intArray: resq 100             ; Uninitialized array with 100 reserved qwords.

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
mov qword r13, 0                        ; Reserve register for largest value in array.

;-------------------------------INSTRUCTION PROMPT------------------------------------------

mov qword rdi, stringFormat                     
mov qword rsi, intructions              
mov qword rax, 0
call printf                             ; Prints out intructions prompt.

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
; Calls display_array which prints out each integer in the array seperated by 1 space.

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call display_array                      ; Calls display_array function.

;--------------------------------CALL BUBBLE SORT------------------------------------------- 

mov qword rdi, intArray                 ; Passes the array
mov qword rsi, r14                      ; Passes number of elements in array.       
mov qword rax, 0
call bubbleSort                         ; Calls bubble sort function to sort array.

;----------------------------BUBBLE SORT CONFIRMATION---------------------------------------

mov qword rdi, stringFormat
mov qword rsi, sort_confirm             ; Prints out sorting confirmation.
mov qword rax, 0
call printf

;-------------------------------DISPLAY SORTED ARRAY----------------------------------------
; Calls display_array which prints out each integer in the array seperated by 1 space.

mov qword rdi, intArray                 ; Passes the array as first parameter.
mov qword rsi, r14                      ; Passes # of elements in the array stored in r14.
mov qword rax, 0
call display_array                      ; Calls display_array function.

;-----------------------------LARGEST NUMBER IN ARRAY---------------------------------------

mov qword rdi, stringFormat             
mov qword rsi, largestnumber            ; Confirms largest number will be returned to main.
mov qword rax, 0
call printf                             ; Prints confirmation of largest number in array.

;--------------------------FIND LARGEST NUMBER IN ARRAY-------------------------------------

mov r13, [intArray + (r14 - 1) * 8]      ; Copy largest (last) element in array into r13.

;---------------------------------END OF FILE-----------------------------------------------


mov qword rax, r13                       ; Copies Largest number in array (r13) to rax.
pop r8                                   ; Remove extra push of -1 from stack.

; Restores all registers to their original state.
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
