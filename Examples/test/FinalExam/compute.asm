
; Bilal El-haghassan - 887210292 - December 14, 2020

;********************************************************************************************
; Author Information:                                                                       *
; Name:         Bilal El-haghassan                CWID = 887210292                          *
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

;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf
extern ispositivefloat
extern atof

global compute                     ; Makes function callable from other linked files.

section .data
    hours db  "Please enter hours worked: ", 0 
    payRate db 10, "Please enter pay rate: ", 0

    error db 10,"Error try again: ", 0
    shutdown db 10, "Shut down. You may run this program again.", 10,0

    total db 10, "The total pay is $ %.2lf", 10, 0
    driver db 10, "The driver received this number %.4lf and will keep it.",10, 10 ,0
    stringFormat db "%s", 0
    intFormat db 10, "%ld", 10, 10, 0
    floatFormat db "%lf",0

section .bss
section .text

compute:

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
mov rax, 0x3FE0000000000000     ; Copy 0.5 float into rax to mov into xmm14 iterator.
movq xmm15, rax                 ; Move 0.5 into xmm15.

mov rax, 0x4044000000000000     ; Copy 40.0 float into rax
movq xmm14, rax                 ; Copy 40.0 into xmm14

mov r12, 0
mov r13, 1                      ; Max errors.

mov rax, 0
mov rdi, stringFormat
mov rsi, hours
call printf

hourinput:

push qword -1
mov rdi, stringFormat      ; Pass stringformat to take a users input as a string.
mov rsi, rsp               ; Points rsi to top of stack to place input value of scanf.
mov rax, 0                 ; Set rax to 1 to let scanf know its an incoming float.
call scanf

;----------------------------------FLOAT VALIDATION-----------------------------------------

mov rdi, rsp               ; Copy address of stack pointer to rdi to pass input value.
mov rax, 0                 ; Set rax 0 to allow function to return to it.
call ispositivefloat       ; Call ispositivefloat cpp function to validate input.

cmp rax, 0                 ; Checks to see if ispositivefloat function returned false.
je error1

mov rax, 1                 ; Set rax to 1 to allow function to return float to xmm0 reg.
call atof                  ; Call atof c++ library function.

movq xmm13, xmm0           ; Save hours into xmm13.
pop rax

jmp payrateinput

error1:
pop rax

cmp r12, r13
je too_many_errors

mov rax, 0
mov rdi, stringFormat
mov rsi, error
call printf

inc r12
jmp hourinput

payrateinput:
mov rax, 0
mov rdi, stringFormat
mov rsi, payRate
call printf

pay_rate:

push qword -1
mov rdi, stringFormat             ; Pass stringformat to take a users input as a string.
mov rsi, rsp               ; Points rsi to top of stack to place input value of scanf.
mov rax, 1                 ; Set rax to 1 to let scanf know its an incoming float.
call scanf
;----------------------------------FLOAT VALIDATION-----------------------------------------

mov rdi, rsp               ; Copy address of stack pointer to rdi to pass input value.
mov rax, 0                 ; Set rax 0 to allow function to return to it.
call ispositivefloat       ; Call ispositivefloat cpp function to validate input.

cmp rax, 0                 ; Checks to see if ispositivefloat function returned false.                ; Checks to see if ispositivefloat function returned false.
je error2

mov rax, 1                 ; Set rax to 1 to allow function to return float to xmm0 reg.
call atof                  ; Call atof c++ library function.

movq xmm12, xmm0           ; Save hours into xmm13.
pop rax

jmp calculate 

error2:
pop rax

cmp r12, r13
je too_many_errors

mov rax, 0
mov rdi, stringFormat
mov rsi, error
call printf

inc r12
jmp pay_rate

too_many_errors:
mov rax, 0
mov rdi, stringFormat
mov rsi, shutdown
call printf

mov rax, 0x0000000000000000
movq xmm15, rax

jmp endprogram
;-----------------------------------Calculate Hours----------------------------------------;
calculate:

ucomisd xmm13, xmm14 
ja overtime

mulsd xmm12, xmm13

jmp totalpay

overtime:

movsd xmm11, xmm13          ; copy hours to xmm11

subsd xmm11, xmm14          ; sub 40 from hours

mulsd xmm11, xmm12          ; multiply by pay rate
mulsd xmm11, xmm15          ; multiply overtime hours by 0.5 

mulsd xmm12, xmm13          ; multiply hours by pay rate

addsd xmm12, xmm11          ; add overtime pay to gross pay

totalpay:

movsd xmm15, xmm12

push qword -1
mov rax, 1
mov rdi, total
movsd xmm0, xmm15
call printf
pop rax

endprogram:
push qword -1
mov rax, 1
mov rdi, driver
movsd xmm0, xmm15
call printf
pop rax

movq xmm0, xmm15
;================================END OF FILE================================================


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
