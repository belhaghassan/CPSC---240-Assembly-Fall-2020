;********************************************************************************************
; Program name:          Harmonic Sum                                                       *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 28, 2020													*
; Program Completed:	 December 3, 2020													*
; Last Modified:		 December 8, 2020													*
; Program Description:   This program asks a user to input a value and will return the      *
;                        harmonic sum of that value.                                        *
;                                                                                           *
;                             __n__                                                         *
;                             \      1                                                      *
;            Harmonic Sum =   /     ---                                                     *
;                            /____   i                                                      *
;                            i = 1                                                          *
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
; Program name:   Harmonic Sum			                                       				*
; Languages used: Three modules in x86, One modules in C++ 				                    *
; Files included: manager.asm, read_clock.asm, getfrequency.asm, main.cpp          			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      manager.asm                                                           		*
;    Purpose:   To manage all the files in the program and call functions getfreq and       *
;               gettime and to calculate the Harmonic sum and return it to main.            *
;	 Language:	x86-64																		*
;	 Assemble:	nasm -f elf64 -l manager.lis -o manager.o manager.asm			            *
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 main.o manager.o read_clock.o freq.o		                                                        *
;																							*
;********************************************************************************************

;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf
extern gettime
extern clock_speed

global manager                     ; Makes function callable from other linked files.

section .data
    instructions db "Please enter the number of terms to be included in the sum: ", 0 
    intialClock db 10, "The clock is now %ld tics and the computation will begin", 10, 10, 0
    finalClock db 10, "The clock is now %ld tics.", 10, 0

    termcompleted db "Terms Completed		 Harmonic sum", 10, 0
    terms db "%10ld               %.13lf",10, 0

    elapsedTics db "The elapsed time was %ld tics, which equals %lf seconds.", 10, 10, 0

    harmonicSum db "The harmonic sum will be returned to the driver.", 10, 10, 0

    stringFormat db "%s", 0
    floatFormat db "%lf",0

section .bss
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

push qword -1                   ; Extra push to create even number of pushes

;-----------------------------INITIALIZE PARAMETERS-----------------------------------------
mov r15, 0x0000000000000000                        
movq xmm15, r15                 ; Resereved xmm15 register for Harmonic sum.

mov rax, 0x3ff0000000000000     ; Copy 1.0 float into rax to mov into xmm14 iterator.
movq xmm14, rax                 ; Reserved xmm14 register to iterate loop start at 1.

movq xmm12, r15                 ; Reserve xmm12 for input value set to 0.0

;-------------------------------INSTRUCTION PROMPT------------------------------------------
mov rax, 0
mov rdi, stringFormat       
mov rsi, instructions           ;"...enter the number of terms to be included in the sum:"
call printf                 

push qword -1
mov rax, 1
mov rdi, floatFormat            ; "%lf"
mov rsi, rsp
call scanf                      ; Take users input for Harmonic Sum as a float calculation

movsd xmm12, [rsp]              ; Input value saved as float

;-------------------------------Calculate term increments-----------------------------------
mov r8, 0x4024000000000000      ; Number 10.0 in hex IEEE754
movq xmm1, r8                   ; Copy 10.0 to xmm1 register to divide input value.
movq xmm11, xmm12               ; Copy user input value to xmm11 to be divided by 10.0.        
divsd xmm11, xmm1               ; Divide input value by 10.0 to use for incremented printing
roundsd xmm11, xmm11, 2         ; Save input value Divided by 10 and rounded up into xmm11.

;----------------------------PRINT INITIAL CLOCK--------------------------------------------
mov rax, 0
call gettime                    ; Call gettime function to get current cpu tics.
mov r14, rax                    ; Save initial clock time in r14 (tics).

mov rax, 0
mov rdi, intialClock            ;"The clock is now %ld tics and the computation will begin"
mov rsi, r14                    ; Initial clock tics retrieved from gettime function.   
call printf                     

;---------------------------HARMONIC SUM CALCULATION PREP-----------------------------------
mov rax, 0
mov rdi, stringFormat           ; "%s"
mov rsi, termcompleted          ;"Terms Completed		Harmonic sum"
call printf                     

mov rax, 0x3ff0000000000000     ; 1.0 in hex for Harmonic sum division.
movq xmm10, rax

cvtsd2si r13, xmm11             ; Convert Rounded value to integer for Print intervals.
mov r15, r13                    ; Copy rounded value to be added to itself in loop.

mov r12, 0                      ; Iterator to compare and indicate when to print, set = 0. 
movsd xmm13, xmm12              ; Copy input value to xmm13 for end of loop comparison.
addsd xmm13, xmm10              ; Increment xmm13 to 1.0 more then input value

;==============================BEGIN LOOP===================================================

begin_loop:

ucomisd xmm14, xmm13            ; Compare iterator to 1.0 more than input value
je end_loop                     ; Exit loop if iterations > input value.

cmp r12, r13                    ; Compare iterations to rounded value.
je print                        ; If iteration is multiple of rounded value print sum & term
inc r12                         ; Increment iterator.

movsd xmm9, xmm10               ; Copy value 1.0 into xmm9
divsd xmm9, xmm14               ; Divide 1.0 by current iteration (xmm14)
addsd xmm15, xmm9               ; Add to harmonic sum

addsd xmm14, xmm10              ; Add 1.0 to iterator

jmp begin_loop                  ; Restart loop

;------------------------PRINT CURRENT TERM AND SUM---------------------------------------
print:

mov rax, 1                      ; Pass 1 to rax for floating point.
mov rdi, terms                  ; "%10ld               %.13lf"
movsd xmm0, xmm15               ; Pass Harmonic sum (float) at current term 
mov rsi, r12                    ; Pass current integer term (iterator)
call printf                     

add r13, r15                    ; Increment term (r13) by rounded value in r15.

jmp begin_loop                  ; Restart loop

end_loop:
;================================End loop===================================================

;-------------------------PRINT FINAL TERM & SUM--------------------------------------------
mov rax, 1
mov rdi, terms                  ; "%10ld               %.13lf"
movsd xmm0, xmm15               ; Pass Final Harmonic sum to be printed.
mov rsi, r12                    ; Pass Input value to print term correlating to final Sum
call printf


;****************************INPUT 1 TRILLION*********************************************
;*******************************************************************************************

; HARMONIC SUM = 28.2082377. 
; ELAPSED TIME = 4698.788730 seconds.

;*******************************************************************************************
;*******************************************************************************************


;----------------------------PRINT FINAL CLOCK----------------------------------------------
mov rax, 0
call gettime                    ; Retrieve final cpu clock time (tics).
mov r15, rax                    ; Save final clock time in r15 (tics).

mov rax, 0
mov rdi, finalClock             ; "The clock is now %ld tics."
mov rsi, r15                    ; Clock time retrieved from gettime function.
call printf                     ; Print Final clock after Calculating Harmonic Sum. 

;----------------------------PRINT ELAPSED TIME---------------------------------------------

cvtsi2sd xmm10, r15             ; Convert final clock to float
cvtsi2sd xmm7, r14              ; Convert Initial clock to float
subsd xmm10, xmm7               ; Subtract Final clock from intial clock.

cvtsd2si r15, xmm10             ; Convert Elapsed time to long integer for print.

; mov rax, 1
; call clock_speed                ; Get frequency of Cpu.
mov r9, 0x400E5810624DD2F2
movq xmm11, r9
; movsd xmm11, xmm0               ; Save Cpu freq to xmm11 (i.e  2.70000Ghz)

mov rax, 0x41cdcd6500000000     ; 1 Billion in IEEE-754 to divide tics into secs
movq xmm12, rax                 ; Copy 1 billion as float to xmm12. 

mulsd xmm11, xmm12              ; Multiply cpu frequency by 1 billion.

divsd xmm10, xmm11              ; Divide tics elapsed by cpu speed (cpu GHz x 1 billion)

mov rax, 1
mov rdi, elapsedTics            ; "The elapsed time was %ld tics, which equals %lf seconds."
mov rsi, r15                    ; Pass Final clock time minus Initial clock time.
movsd xmm0, xmm10               ; Pass total seconds elapsed to calculate Harmonic Sum.
call printf

;-------------------------------RETURN TO DRIVER--------------------------------------------
mov rax, 0
mov rdi, stringFormat           ; "%s"
mov rsi, harmonicSum            ; "The harmonic sum will be returned to the driver."
call printf

movq xmm0, xmm15                ; Pass final Harmonic sum of input value to driver.

;================================END OF FILE================================================

pop rax                         ; Extra pop to align stack to 16 bytes.
pop rax                         ; Remove extra push of -1 from stack.    

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
