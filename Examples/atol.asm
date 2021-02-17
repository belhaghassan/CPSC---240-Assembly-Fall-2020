;****************************************************************************************************************************
;Program name: "atolong".  This is a single function distributed without accompanying software.  This function converts a   *
;null-terminated ascii string containing chars in the range '0' .. '9' to the corresponding numeric integer value.          *
;Copyright (C) 2020 Floyd Holliday                                                                                          *
;                                                                                                                           *
;This is a library function distributed without accompanying software.                                                      *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
;useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
;See the GNU General Public License for more details.  A copy of the GNU Lesser General Public License 3.0 should have been *
;distributed with this function.  If the LGPL does not accompany this software then it is available here:                    *
;<https:;www.gnu.org/licenses/>.                                                                                            *
;****************************************************************************************************************************
;
;To students in CPSC240:  This is my opinion.  I have studied the the available licenses for software especially the GPL,
;the LGPL, and the Affero GPL.  This is what I have learned about the LGPL that is used with this function "atolong".
;   The section above the blank line is called the "copyright notice".
;   The section below the blank line is called the "license notice".
;   LGPL is for use on software typically found in software libraries.
;   This LGPL license applies only to the specific function named in the license.
;   This library may be used within another application covered by other licenses (or EULAs).
;   This license requires that source code of this function be distributed with the application (even if other parts of the
;       application are not required to be distributed with source code).
;   This LGPL allows you to re-distribute the function (provided the original LGPL remains).
;   This LGPL allows you to modify the function (provided the original LGPL remains).
;   This LGPL allows you to distribute (or sell) your modified versions to anyone (provided the original LGPL remains). 
;   When you distribute this software to other people a copy of the LGPL is suppose to accompany the source code in a 
;       separate file.  If that separate file becomes lost (by human error) license still has legal standing.
;
;References: 
;   How to correctly place a software license in a source file: https://www.gnu.org/licenses/gpl-howto.html
;   Complete text of LGPl in html format: https://www.gnu.org/licenses/lgpl-3.0.html
;   Complete text of GPL in html format: https://www.gnu.org/licenses/gpl-3.0.html
;
;A example: Microsoft programmers are developing a new version of Skype.  One of the programmers on that project
;discovers a useful function stored online that can be used in the new version of Skype.  If that online function is 
;licensed by GPL and Microsoft uses it, then Microsoft must make all of Skype open source and licensed by GPL.  However, 
;if that online function is licensed by LGPL then Microsoft may legally incorporate the function into Skype, and 
;Skype remains proprietary and wholly secret.  Do you see a major difference between the two kinds of licenses?

;This opinion is included here for educational purposes in the course CPSC240.  You must remove this opinion statement 
;when you use this library function in other application programs such as homework.
;
;To students in 240:  You must remove this block of opinion statements when you use this function in your program.  If this
;block remains when I grade your program then automatically your program is not professional.
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;This function
;  Function name: atolong
;  Programming languages: X86
;  Syntax: Intel
;  Date program began: 2020-Sep-2
;  Date of last update: 2020-Sep-6
;  Comments reorganized: 2020-Sep-25
;  Assemble: nasm -f elf64 -o atol.o atol.asm
;  Classification: Library
;     Library functions are not specific to any one application program.  They are stored on a server and are available for re-use
;     in the development of future applications.
;
;Purpose
;  The purpose of this program is to convert a null-terminated array of ascii char containing only chars in the range 
;  '0' .. '9' to the corresponding numeric value. 
;
;Names
;   The function "atolong" was intended to be called atol, however there already is a function in the C++ standard library
;   with that name.  To avoid any possible conflict this function received the longer name, namely: atolong.  A simple web
;   search will produce lots of information about the original atol.
;
;References:
;  Jorgensen: X86-64 Assembly Language Programming with Ubuntu (free download)
;
;Prototype of this function in C++: 
;   extern "C" long atolong(char []);
;
;How to call atolong from C++:
;  == Place prototype of atolong at the beginning of the caller function: extern "C" long atolong(long *);
;  == An array of char must exist such as char num[256];
;  == Declare a long such as:  long mynumber;
;  == Call the function:  mynumber = atolong(num);
;
;How to call atolong from C:
;  == Place prototype of atolong at the beginning of the caller function: long atolong(long *);
;  == An array of char must exist such as char num[256];
;  == Declare a long such as:  long mynumber;
;  == Call the function:  mynumber = atolong(num);
;
;How to call atolong from X86:
;  == Declare atolong to be external:  extern atolong
;  == You need a register that holds a valid memory address.  One such example is rsp; another is an array declared in .bss
;  == Make the call setup block:
;     == mov rax,0
;     == mov rdi,rsp         or  mov rdi,<name of array in bss>
;     == call atolong
;     == mov r12,rax         ;Save the converted number in a safer register like r14
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;
;
;===== Begin code area ========================================================================================================

;Assembler directives
base_number equ 10                      ;10 base of the decimal number system
ascii_zero equ 48                       ;48 is the ascii value of '0'
null equ 0
minus equ '-'

extern printf                           ;External C++ function for writing to standard output device
extern scanf                            ;External C++ function for reading from the standard input device
global atolong                          ;This makes atolong callable by functions outside of this file.

segment .data                           ;Place initialized data here
   ;This segment is empty


segment .bss                            ;Declare pointers to un-initialized space in this segment.
   ;This segment is empty

;==============================================================================================================================
;===== Begin the executable code here.
;==============================================================================================================================
segment .text                           ;Place executable instructions in this segment.

atolong:                                ;Entry point.  Execution begins here.

;The next two instructions should be performed at the start of every assembly program.
push rbp                                ;This marks the start of a new stack frame belonging to this execution of this function.
mov  rbp, rsp                           ;rbp holds the address of the start of this new stack frame.
;The following pushes are performed for safety of the data that may already be in the remaining GPRs.
;This backup process is especially important when this module is called by another asm module.  It is less important when called
;called from a C or C++ function.
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

;Designate the purpose of selected registers: r8, r9, r10
mov r8, rdi                   ;Copy the pointer to char data to r8; r8 is the array of char
mov r9, 0                     ;r9 = array index
mov r10, 0                    ;r10 = long integer; final answer will be here.

;The first byte in the array may be '+' or '-', which are valid numeric characters.
;We need to check for the presence of a leading sign.
cmp byte [r8+1*0], '+'        ;Check for leading plus sign
jne next_comparison
mov r9, 1
jmp begin_loop

next_comparison:
cmp byte [r8+1*0], '-'        ;Check for leading minus sign
jne begin_loop
mov r9, 1

begin_loop:
cmp byte [r8+1*r9], null      ;Check the termination condition of the loop
je loop_finished
mov rax, base_number
mul r10
mov r10, rax

;This is the instruction we want to perform: "add r10, byte [r8+1*r9]".  But the problem is that the
;sizes of operands do not match.  You cannot add a 1-byte number to an 8-byte number.  However, the
;problem can be fixed by using the extension instructions documented on page 77 of the Jorgensen textbook.
mov al, byte [r8+1*r9]        ;The 1-byte number has been copied to al (1-byte register)
cbw                           ;The 1-byte number in al has been extended to 2-byte number in ax
cwde                          ;The 2-byte number in ax has been extended to 4-byte number in eax
cdqe                          ;The 4-byte number in eax has been extended to 8-byte number in rax

;Now addition is possible
add r10, rax                  ;To students in 240 class: wasn't that simply great fun?
sub r10, ascii_zero           ;A declared constant is compatible with various sizes of registers; explained in Jorgensen.
inc r9
jmp begin_loop
loop_finished:

;Set the computed value to negative if needed
cmp byte [r8+1*0], minus      ;Check for leading minus sign
jne positive
neg r10

positive:
mov rax, r10
;==================================================================================================================================
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
pop rbp                       ;Now the system stack is in the same state it was when this function began execution.
ret                           ;Pop a qword from the stack into rip, and continue executing..
;========== End of module atol.asm ================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
