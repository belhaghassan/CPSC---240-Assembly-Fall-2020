;****************************************************************************************************************************
;Program name: "Geometric Mean".  This program demonstrates how to compute the geometric mean of a set of floating point    *
;numbers stored in an array of quadwords.  Copyright (C) 2018  Floyd Holliday                                               *                                                                             *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;****************************************************************************************************************************



;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Geometric Mean
;  Programming languages: C++. X86, C.
;  Date program began: 2019-Feb-20
;  Date of last update: 2019-Feb-28
;  Comments reorganized: 2019-Mar-10
;  Files in the program: geometric-main.c, geometric-controller.asm, fill-array.cpp, display.c, run.sh
;
;Purpose
;  Compute the Geometric Mean as a mathematical quantity used in statistics.
;  For learning purposes: Demonstrate use of SSE registers (xmm's), Demonstrate how to use the cpu clock to measure runtime.
;
;This file
;  File name: geometric-controller.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 136 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 136 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l control.lis -o control.o geometric-controller.asm
;  Comments begin column 61
;  References: Seyfarth, Chapter 10
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

;
;===== Begin code area ====================================================================================================================================================

;%include "savedata.inc"                                     ;Not used in this program.  External macros that assist in data backup.

;%include "debug.inc"                                        ;Not now in use.  The debug tool was used during the development stages of this program.

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

extern get_data                                             ;The external function will file a passed array with qword data.

extern put_data

extern pow

global geometric_mean                                        ;This makes array_tools callable by functions outside of this file.

segment .data                                               ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.

initialmessage db "The X86 controller subprogram is now executing.", 10, 0

arrayaddressmessage db "The first element of the array is located at 0x%016lx in the heap space", 10, 0

message_about_array db "These are the values now stored in the array.",10,0

longfloatform db "The sum of numbers in the array is %14.10lf", 10, 0

product_message db "The product of the numbers in the array is %-3.15lf", 10, 0

geometric_message db "The geometric mean of all the numbers in the array is %5.16lf",10,0

elapsed_time_message db "The CPU used %ld tics or 0x%016lx for computing the geometric mean.",10,0

goodbye db "The geometric mean written in X86 will now return execution to the main function.",10,10,0

stringformat db "%s", 0                                     ;general string format

segment .bss                                                ;Declare pointers to un-initialized static space in this segment.

academic resq 28                                            ;Declare a static array for demonstration purposes.

;==========================================================================================================================================================================
;===== Begin the application here: show how to input and output floating point numbers ====================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

geometric_mean:                                             ;Entry point.  Execution begins here.

;The pushes that follow are here to backup the data in GPRs placed there by the calling module.  It is probable that the caller
;already backed up his own data before making the call -- however, we never know for sure.
push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;We do this in order to be 100% compatible with C and C++.
push       rbx                                              ;Back up rbx
push       rcx                                              ;Back up rcx
push       rdx                                              ;Back up rdx
push       rsi                                              ;Back up rsi
push       rdi                                              ;Back up rdi
push       r8                                               ;Back up r8
push       r9                                               ;Back up r9
push       r10                                              ;Back up r10
push       r11                                              ;Back up r11
push       r12                                              ;Back up r12
push       r13                                              ;Back up r13
push       r14                                              ;Back up r14
push       r15                                              ;Back up r15
pushf                                                       ;Back up rflags

;=========== Show the initial message =================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, initialmessage                              ;"The X86 controller subprogram is now executing."
call       printf                                           ;Call a library function to make the output

;========== Manage the array declared in this module ==================================================================================

mov        r14, academic                                    ;r14 points to the start of the array.  r14 is constant in this module.

;Find the address where the array academic is really stored.  Remember that academic is static.
mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, arrayaddressmessage                         ;"The first element of the array is located at 0x%016lx in the heap space"
mov        rsi, r14                                         ;rsi has the address of the start of the array
call       printf

;=========== Call a function that will input some numbers into the array ==============================================================

mov qword  rax, 0                                           ;0 is the number of xmm registers involved in the coming call.
mov        rdi, r14                                         ;rdi points to the first cell of the array
mov        rsi, 28                                          ;28 = number of qwords in the array academic
call       get_data
mov        r13, rax                                         ;r13 holds the number of numbers now in the array academic

;========== Identify the data that will be displayed ==================================================================================

mov qword rax, 0
mov        rdi, message_about_array                         ;These are the values now stored in the array.
call       printf

;=========== Show the contents recently placed into the array r14 =====================================================================

mov qword  rax, 0                                           ;0 is the number of xmm registers involved in the coming call.
mov        rdi, r14                                         ;rdi is a pointer to the start of the array
mov        rsi, r13                                         ;r13 is the true number of doubles in the array
call       put_data

;========== Compute the arithmetic sum of numbers in the array ========================================================================

mov        r12, 0                                           ;r12 is the index into the array.  r12 is initialized to zero
push qword 0                                                ;64 zero bits are now on top of the stack
movsd      xmm8, [rsp]                                      ;Zero out xmm8
pop        rax                                              ;Reverse the push of a few instructions earlier

topofloop:
cmp        r12, r13                                         ;Is r12 >= r13?  If 'yes' then loop is finished
jge        outofloop
mov        rax,[r14+8*r12]                                  ;Copy the current array element into rax
push       rax                                              ;Push the array element onto the stack
movsd      xmm9, [rsp]                                      ;Place a copy of the array element into xmm9
addsd      xmm8, xmm9                                       ;Add the array element to the accummulator
inc        r12                                              ;The index into the array is incremented
pop        rax                                              ;pop the push of a few instuctions earlier
jmp        topofloop
outofloop:  

;========== Show the computed sum =====================================================================================================

movsd       xmm0, xmm8
mov         rax, 1
mov         rdi, longfloatform                              ;The sum of numbers in the array is %14.10lf", 10, 0
call        printf

;========== Read the time on the cpu clock and save that time =========================================================================

mov qword  rax, 0                                           ;Make sure rax is zeroed out.  This may be un-necessary.
mov qword  rdx, 0
cpuid
rdtsc                                                       ;Write the number of tics in edx:eax
shl        rdx, 32                                          ;Shift the lower half of rdx to the upper half of rdx
or         rdx, rax                                         ;Join the two half into a single register, namely: rdx
mov        r15, rdx                                         ;Save the clock in a safe register: in this case r15.

;========== Compute the geometric mean of numbers in the array ========================================================================

mov         rax, 0x3FF0000000000000                         ;1.0 is now in rax
push        rax
movsd       xmm9, [rsp]                                     ;1.0 is now in xmm9
pop         rax
movsd       xmm15, xmm9                                     ;Place a backup copy of 1.0 in xmm15 for later use.
mov qword   r12, 0                                          ;r12 = index variable into the array

beginloop:
cmp         r12, r13                                        ;Is r12 >= r13?  If 'yes' then loop is finished
jge         loopisdone
movsd       xmm10, [r14+8*r12]                              ;Copy array item numberr r12 to a floating point register
mulsd       xmm9, xmm10                                     ;Multiply
inc         r12
jmp         beginloop                                       ;Iterate this loop one more time.
loopisdone:

;========== Read the time on the cpu clock again =====================================================================================

mov qword  rax, 0                                           ;Make sure rax is zeroed out.  This may be un-necessary.
mov qword  rdx, 0
cpuid
rdtsc                                                       ;Write the number of tics in edx:eax
shl        rdx, 32                                          ;Shift the lower half of rdx to the upper half of rdx
or         rdx, rax                                         ;Join the two half into a single register, namely: rdx

;========== Compute the elapsed time that was required to compute the geometric mean ==================================================

sub        rdx, r15                                         ;The elapsed time measured in tics is in rdx.
mov        r15, rdx                                         ;Copy elapsed time to r15 for safe keeping, which is safer than rdx

;========== Show the computed product =================================================================================================

mov         rax, 1                                          ;One xmm register will be used
mov         rdi, product_message                            ;"The product of the numbers in the array is %-3.15"
movsd       xmm0, xmm9                                      ;Copy the product to xmm0
call        printf

;========== Compute the geometric mean ================================================================================================

cvtsi2sd    xmm11, r13                                      ;The number of numbers in the array is now in xmm11
divsd       xmm15, xmm11                                    ;The reciprocal of the number of numbers in the array is in xmm15

;Set up parameters to pass to the pow function
movsd       xmm0, xmm9                                      ;xmm0 holds the product of all the numbers in the array
movsd       xmm1, xmm15                                     ;xmm1 holds the reciprocal of the number of numbers in the array
mov         rax, 2                                          ;The pow function expects to recieve data from two xmm registers
call        pow                                             ;Call a function in the C++ library

movsd       xmm15, xmm0                                     ;Save a backup copy of the geometric mean

;========== Show the computed geometric mean ==========================================================================================

mov         rax, 1                                          ;printf will receive exactly one floating point number
mov         rdi, geometric_message                          ;"The geometric mean of all the numbers in the array is %5.16lf",10,0
call        printf

;========== Show how much time the cpu used to compute the geometric mean =============================================================

mov         rax, 0
mov         rdi, elapsed_time_message                       ;"The CPU used %ld tics or 0x%016lx for computing the geometric mean."
mov         rsi, r15
mov         rdx, r15
call        printf

;===== Conclusion message =============================================================================================================
;It is not necessary to be on a boundary to output a string.

mov qword  rax, 0                                          ;No data from SSE will be printed
mov        rdi, stringformat                               ;"%s"
mov        rsi, goodbye                                    ;"The geometric mean written in X86 will now return control to the main function."
call       printf                                          ;Call a library function to do the hard work.

;========== Send a float number back to the caller ====================================================================================

movsd      xmm0, xmm15

;===== Restore GPRs with the values held when this module "geometric_mean" was called =================================================

popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Return rbp to point to the base of the activation record of the caller.
;Now the system stack is in the same state it was when this function began execution.

ret                                                         ;Pop a qword from the stack into rip, and continue executing.
;========== End of program "geometric_mean" located in the file geometric_controller ==================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
