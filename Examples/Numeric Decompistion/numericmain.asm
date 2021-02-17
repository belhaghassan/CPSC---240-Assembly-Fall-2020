;****************************************************************************************************************************
;Program name: "Numeric Decomposition".  This program accepts a base 10 floating point number from stdin and decomposes it  *
;into standard components: sign big, stored exponent, and significand.  Lastly, the number is displayed in IEEE 754 format. *
;Copyright (C) 2014  Floyd Holliday                                               *
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
;  Author location: Fullerton, CA
;Program information
;  Short title: Numeric Decomposition
;  Purpose: This program will demonstrate to the CPSC240 class how to "pass back" multiple values from an X86 subprogram to a C program that called the X86 subprogram.
;  Status: Testing phase. No errors discovered after a few dozen test cases. 
;  Program begun: 2014-Dec-5
;  Program completed and tested: 2014-Dec-08
;  Comments and bash instructions upgraded 2019-Dec-16
;  Project files: numericdecomposition.c, numericmain.asm
;Module information
;  File name: numericmain.asm
;  Language: X86
;  Syntax: Intel
;  Date completed: 2014-Dec-8
;  Comments and bash file updated : 2019-December-16
;  Purpose: This module will decompose a floating point number (64 bits) into its fundamental components according to the IEEE-754 standard.
;  Status: This module is simple X86 code, and has been tested extensively.
;  Future enhancements: Implement the capability of correctly processing subnormal inputs.
;Translator information (Tested in Bash shell)
;  Gnu compiler: gcc -c -m64 -Wall -std=c11 -o numeric_d_com.o -no-pie numericdecomposition.c
;  Gnu linker:   gcc -m64 -std=c11 -no-pie -o decomposition.out numeric.o numeric_d_com.o
;  Execute:      ./decomp.out
;References and credits
;  No references: this module is standard PC assembly language
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper



;===== Begin area for source code =========================================================================================================================================

extern printf                                               ;This subprogram will be linked later

extern scanf                                                ;This subprogram will be linked later

global numericdecomposition                                 ;Make this program callable by other programs.

segment .data                                               ;Initialized data are placed in this segment

align 16                                                    ;Start new data on a 16-byte boundary

;===== Declare some messages ==============================================================================================================================================

welcome db "This program will perform a simple operation on the AVX registers.", 10, 0

instruction db "Enter an 8-byte floating point number (normal or subnormal): ", 0

echo db "Thank you.  The number you entered was %lf.", 10, 0

farewell db "The X86 subprogram is now terminating. Further messages are produced by the caller.", 10, 0

xsavenotsupported.notsupportedmessage db "The xsave instruction is not supported in this microprocessor.", 10
                                      db "However, processing will continue without backing up state component data", 10, 0

;===== Declare formats for output =========================================================================================================================================

stringformat db "%s", 0

xsavenotsupported.stringformat db "%s", 0

basicfloatinputformat db "%lf", 0

segment .bss                                                ;Uninitialized data are declared in this segment

align 64                                                    ;Ask that the next data declaration start on a 64-byte boundary.
backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

binarray resb 53                                            ;Reserve space for 52 bits held as ascii values or 0 or 1, and one more byte for the null terminator.

segment .text                                               ;Instructions are placed in this segment

numericdecomposition:                                       ;Execution of this program will begin here.

;======== Backup Section ==================================================================================================================================================
;There are three concurrent objectives here.  First, when this X86 subprogram exits all registers (with minor exceptions: rax, rsp, rflags) must hold the same data they
;held when this subprogram was called.  The reason for this is to protect the data of the caller.  This subprogram will return to the caller the exact same data values
;that the caller had when this subprogram was called.

;The second objective relates to passing data from the caller to this called subprogram.  The data passing registers are rdi, rsi, rdx, rcx, r8, r9, and xmm0 through xmm7.
;It is important that these registers arrive at the application section with values unchanged.

;The third objective is to allow older machines without the xsave and xrstor instructions to continue processing the application even if backup of registers via xsave is
;not possible. 

; 1. =========== Back up all the GPRs whether used in this program or not =================================================================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;This will preserve the linked list of base pointers.
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

; 2. ========== Back up those xmm registers numbered 0 through 7 ==========================================================================================================

push qword 0                                                ;Subprograms in external C or C++ libraries are known
movsd      [rsp], xmm7                                      ;to destruct the data in the xmm registers numbered 0 thru 7.
push qword 0
movsd      [rsp], xmm6
push qword 0
movsd      [rsp], xmm5
push qword 0
movsd      [rsp], xmm4
push qword 0
movsd      [rsp], xmm3
push qword 0
movsd      [rsp], xmm2
push qword 0
movsd      [rsp], xmm1
push qword 0
movsd      [rsp], xmm0

; 3. ========== Determine if this computer supports the two instructions xsave and xrstor =================================================================================
;Use the cpuid instruction to discover if this computer support xsave and xrstor

;Precondition for using cpuid: rax holds 1.
mov        rax, 1

cpuid                                                       ;Execute the cpuid instruction.

;Postconditions: If rcx[26]==1 then xsave is supported.  If rcx[26]==0 then xsave is not supported.

;Extract bit #26 and test it

and        rcx, 0x0000000004000000                          ;The mask 0x0000000004000000 has a 1 in position #26.  Now rcx is either all zeros or
                                                            ;has a single 1 in position #26 and zeros everywhere else.
cmp        rcx, 0                                           ;Is (rcx == 0)?
je         xsavenotsupported                                ;Skip the section that backs up state component data.

; 4. ========== Call the function to obtain the bitmap of state components ================================================================================================

;Preconditions
mov        rax, 0x000000000000000d                          ;Place 13 in rax.  This number is provided in the Intel manual.
mov        rcx, 0                                           ;0 is parameter for subfunction 0

;Call the function
cpuid                                                       ;cpuid is an essential function that returns information about the cpu

;Postconditions (There are 2 of these):

;1.  edx:eax is a bit map of state components managed by xsave.  At the time this program was written (2014 June) there were exactly 3 state components.  Therefore, bits
;    numbered 2, 1, and 0 are important for current cpu technology.
;2.  ecx holds the number of bytes required to store all the data of enabled state components. [Post condition 2 is not used in this program.]
;This program assumes that under current technology (year 2014) there are at most three state components having a maximum combined data storage requirement of 832 bytes.
;Therefore, the value in ecx will be less than or equal to 832.

;Precaution: As an insurance against a future time when there will be more than 3 state components in a processor of the X86 family the state component bitmap is masked to
;allow only 3 state components maximum.

and        rax, 0x0000000000000007                          ;Bits 63-3 become zeros
xor        rdx, rdx                                         ;rdx is zeroed out.

; 5A ========== Perform the state component backup ========== Perform section 5A or 5B but not both =======================================================================

;The instruction xsave will save those state components with on bits in the bitmap.  At this point edx:eax continues to hold the state component bitmap.

;Precondition: edx:eax holds the state component bit map.  This condition has been met by the two pops preceding this statement.
xsave      [backuparea]                                     ;All the data of state components managed by xsave have been written to backuparea.

mov        r15, -1                                          ;Set a flag (-1 = true) to indicate that state component data were backed up.
jmp        backupconclusion

; 5B. ========== Show message xsave is not supported on this platform =====================================================================================================
xsavenotsupported:

mov        rax, 0
mov        rdi, .stringformat
mov        rsi, .notsupportedmessage                        ;"The xsave instruction is not supported in this microprocessor.
call       printf

mov        r15, 0                                           ;Set a flag (0 = false) to indicate that state component data were not backed up.

backupconclusion: ;Insure that the parameter passing registers have their original values.

;Restore values to the 8 registers that pass in float type values.
movsd      xmm0, [rsp]
pop        rax
movsd      xmm1, [rsp]
pop        rax
movsd      xmm2, [rsp]
pop        rax
movsd      xmm3, [rsp]
pop        rax
movsd      xmm4, [rsp]
pop        rax
movsd      xmm5, [rsp]
pop        rax
movsd      xmm6, [rsp]
pop        rax
movsd      xmm7, [rsp]
pop        rax

;Restore values to the 6 registers that pass in integer type values.  The values in other GPRs are of no concern to this application.
mov        rdi, [rsp+72]
mov        rsi, [rsp+80]
mov        rdx, [rsp+88]
mov        rcx, [rsp+96]
mov        r8,  [rsp+64]
mov        r9,  [rsp+56]

;Save on the stack the flag that indicates if xsave is implemented (-1) in the current processor or not implemented (0) in the current processor.
push       r15                                              ;Save the flag on the stack and thereby make r15 available for other uses.

;==========================================================================================================================================================================
;===== End of all register backup =========================================================================================================================================
;==========================================================================================================================================================================


;==========================================================================================================================================================================
;===== Begin the application here: decompose an 8-byte floating point number ==============================================================================================
;==========================================================================================================================================================================

;===== Very important: back up into a safe place the four parameters (values) passed here by the caller. =================================================================+
push       r8                                               ;fifth CCC parameter: the significand
push       rcx                                              ;fourth CCC parameter: the hidden bit
push       rdx                                              ;third CCC parameter: the true exponent
push       rsi                                              ;second CCC parameter: the sign of the quadword: either '+' or '-'.
push       rdi                                              ;first CCC parameter: the complete quadword received from the keyboard

;===== Show the prompt message ============================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE or AVX will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, instruction                                 ;"Enter an 8-byte normal number (not subnormal): "
call       printf                                           ;Call a library function to make the output

;===== Obtain a normal floating point number from the standard input device and store a copy in r15 =======================================================================

push qword 0                                                ;Push 8 bytes to get off the 16 byte boundary, and therefore the next push will land on the 16-byte boundary.
push qword 0                                                ;Reserve 8 bytes of storage for the incoming number
mov qword  rax, 0                                           ;SSE is not involved in this scanf operation
mov        rdi, basicfloatinputformat                       ;"%lf"
mov        rsi, rsp                                         ;Give scanf a pointer to the reserved storage
call       scanf                                            ;Call a library function to do the input work
pop        r15                                              ;A copy of the input quadword is in r15.  This copy will be keep intact through the remainder of the run.
pop        rax                                              ;Reverse the boundary push.

;===== Provide a copy of the input quadword for the caller program ========================================================================================================

pop        rax                                              ;rax holds the first parameter passed here from the caller.
mov        [rax], r15                                       ;Place a copy of the input number in heap space where the caller has a pointer to this number.
                                                            ;The caller already has access to this number at this point.  There is no need to wait for the ret instruction.

;===== Extract the sign of the quadword in r15 ============================================================================================================================

mov        r14, r15                                         ;Make a second copy of the quadword inputted by the user.

;The next two instructions are a replacement for "and r14, 0x8000000000000000", which would not assemble.
mov        r13, 0x8000000000000000                          ;Place mask into r13
and        r14, r13                                         ;Zero out all bits except the sign bit.


cmp        r14, qword 0                                     ;Find out if the sign is '+' or '-'
je         positive                                         ;If the sign is positive then go to the positive section.
mov        r13, 0x000000000000002D                          ;2D is ascii for '-'
jmp        signcontinue
positive:
mov        r13, 0x000000000000002B                          ;2B is ascii for '+'
signcontinue:
pop        rax                                              ;rax holds the second parameter passed from the caller.
mov        [rax], r13                                       ;The caller already has access the the sign of the inputted quadword number.

;===== Extract the exponent of the quadword in r15 ========================================================================================================================

mov        r14, r15                                         ;Place a copy of the quadword in r14.
shl        r14, 1                                           ;Remove the sign bit from the number in r14
shr        r14, 53                                          ;Remove the significand from the number in r14.  The stored exponent remains in r14
cmp        r14, 0                                           ;Is (stored exponent == zero)?
je         subnormalprocess
normalprocess:                                              ;The next two instruction execute if the inputted number is normal.
           sub r14, 0x00000000000003FF                      ;Subtract the bias number from the stored exponent.  Now r14 holds the true exponent.
           jmp storetrueexponent
subnormalprocess:                                           ;The next instruction executes if the inputted number is subnormal.
           mov r14, -1022                                   ;r14 holds the 64-bit base number, which is the true exponent for subnormal numbers.
storetrueexponent:
pop        rax                                              ;Get a copy of the third parameter passed here from the driver.
mov        [rax], r14                                       ;Copy the true exponent into heap space where the caller has a pointer to that space.
                                                            ;The caller already has (access to) the true exponent.

;===== Determine the hidden bit ===========================================================================================================================================

;r14 continues to hold the true exponent.  If the true exponent is -1022 then the hidden bit is 0 otherwise it is 1.
cmp        r14, -1022                                       ;Is (r14 == -1022)?
je         hiddenbitiszero
           mov r13, 1                                       ;The hidden bit in this case is 1.
           jmp storehiddenbit
hiddenbitiszero:
           mov r13, 0                                       ;The hidden bit in this case is 0.
storehiddenbit:
pop        rax
mov        [rax], r13                                       ;Copy the hidden bit into heap space where the caller has a pointer to that space.

;===== Extract the significand of the quadword in r15 =====================================================================================================================

mov        r14, r15                                         ;Make a second copy of the quadword inputted by the user.

;The next two instructions are a replacement for and "r14, 0x0000FFFFFFFFFFFF", which would not assemble.
mov        r13, 0x000FFFFFFFFFFFFF
and        r14, r13                                         ;Zero out every thing except the significand.

pop        rax                                              ;Get a copy of the fourth parameter passed here from the driver.
mov        [rax], r14                                       ;Copy the significand into heap space where the caller has a pointer to that space.
                                                            ;Now the caller already has (access to) the significand.

;===== Convert the significand to a byte array of zeros and ones ==========================================================================================================

;The significand is currently in r14[51-0].  Establish a mask with a 1 at bit 51 and zeros elsewhere.
mov        r13, 0x0008000000000000                          ;r13 is the mask.
mov        rcx, 0                                           ;The loop counter begins at 0.  Iterations continue while rcx is less than 52
beginloop:
           mov r12, r14                                     ;r12 receives a new copy of the significand with each iteration.
           and r12, r13                                     ;Isolate one bit in r12
           cmp r12, 0                                       ;Is r12 equal to zero?
           je  zerobit                                      ;If the special bit in r12 is zero then go to a place to set a zero in the array.
           mov [binarray+1*rcx], byte '1'                   ;Place '1' in the array
           jmp endif
           zerobit:
           mov [binarray+1*rcx], byte '0'                   ;Place '0' in the array
           endif:
           inc rcx                                          ;rcx is the loop control variable
           shr r13, 1                                       ;The single 1 bit in r13 move right one space with each iteration.
           cmp rcx, 52                                      ;52 is the number of bits in the significand and the number of iterations of this loop.
           jl  beginloop
endloop:
mov        [binarray+1*52], byte 0                          ;Append the null terminator at the end of the char array.
;The array binarray has been filled with ascii values representing the bits in the significand.  The starting address of this array will be returned to the caller when the
;return instruction is executed.


;===== Say good-bye =======================================================================================================================================================
;Finally, we arrive at the end of this program Numeric Decomposition.

mov qword rdi, stringformat                                 ;A little good-bye message will be outputted.
mov qword rsi, farewell                                     ;"The X86 subprogram is now terminating. Further messages are produced by the caller."
mov qword rax, 0                                            ;Zero says that no data values from SSE registers are used by printf
call printf

;===== Save a copy of the value that will be returned to the caller =======================================================================================================

;This section is empty.  The starting address of the array binarray will be copied to rax after the State Component Restore.

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.

;==========================================================================================================================================================================
;End of application area: Numeric Decomposition
;==========================================================================================================================================================================



;==========================================================================================================================================================================
;===== Begin State Component Restore ======================================================================================================================================
;==========================================================================================================================================================================

;===== Check the flag to determine if state components were really backed up ==============================================================================================

pop        rbx                                              ;Obtain a copy of the flag that indicates state component backup or not.

cmp        rbx, 0                                           ;If there was no backup of state components then jump past the restore section.
je         setreturnvalue                                   ;Go to set up the return value.

;Continue with restoration of state components;

;Precondition: edx:eax must hold the state component bitmap.  Therefore, go get a new copy of that bitmap.

;Preconditions for obtaining the bitmap from the cpuid instruction
mov        rax, 0x000000000000000d                          ;Place 13 in rax.  This number is provided in the Intel manual
mov        rcx, 0                                           ;0 is parameter for subfunction 0

;Call the function
cpuid                                                       ;cpuid is an essential function that returns information about the cpu

;Postcondition: The bitmap in now in edx:eax

;Future insurance: Make sure the bitmap is limited to a maximum of 3 state components.
and        rdx, 0x00000000000000007                         ;Zero out all bits except bits numbered 2, 1, and 0.
xor        rdx, rdx                                         ;Zero out all of rdx

xrstor     [backuparea]

;==========================================================================================================================================================================
;===== End State Component Restore ========================================================================================================================================
;==========================================================================================================================================================================


setreturnvalue: ;=========== Set the value to be returned to the caller ===================================================================================================

mov        rax, binarray                                    ;The caller will receive the starting address of the array.

;=========== Restore GPR values and return to the caller ==================================================================================================================

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
pop        rbp                                              ;Restore rbp

ret                                                         ;Pop the integer stack and resume execution at the address that was popped from the stack.
;===== End of program numericmain =========================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
