;Author name: Floyd Holliday
;Author email: holliday@fullerton.edu

;Program name: Show GPRs Utility
;Programming languages: X86 for the utility itself.
;Date program began: December 7, 2017
;Date of last update: February 17, 2019
;Files in this program: showgprs.asm, discover.asm, test-gprs.cpp, r.sh
;Comment: This module is not a member of a specific application program.  This module is to be used as an aid to developers building 
;application programs.  This program showgps should be removed before or when the application is ready to ship to the customer.
;Prototype for use by application programmers wanting to call this utility function:  extern "C" void showgprs();
;Status: Done.  No more work will be done on this program apart from fixing any reported errors.

;Purpose: Show how a programmer developing software in C, C++, or X86 can call a program to display the current values of all GPRs.
;The displayed values for GPRs are the ones held at the time this function was called. 

;This file name: showgprs.asm
;This file language: X86
;This file syntax: Intex
;Calling name: showgprs
;Parameter passed in: one parameter, namely rdi, holding 64-bit label.
;Parameter passed out: one 64-bit zero indicating successful completion.
;Assemble: nasm -f elf64 -o gprs.o -l showgprs.lis showgprs.asm

;X86 rflags register:
;Bit# Mnemonic Name
;  0     CF    Carry flag
;  1           unused
;  2     PF    Parity flag
;  3           unused
;  4     AF    Auxiliary Carry flag
;  5           unused
;  6     ZF    Zero flag
;  7     SF    Sign flag
;  8     TF    Trap flag
;  9     IF    Interrupt flag
; 10     DF    Direction flag
; 11     OF    Overflow flag

;===== Expected format of the output ======================================================================================================================================
;Register Dump # 132
;rax = 0000000000000003 rbx = 0000000000000000 rcx = 0000000000000001 rdx = 00007f59b444aab0
;rsi = 0000000000000003 rdi = 0000000000602ad0 rbp = 00007fff7d9a6960 rsp = 00007fff7d9a6900
;r8  = 00007f59b496e01b r9  = 0000000000000001 r10 = 0000000000000000 r11 = 0000000000000246
;r12 = 0000000000000003 r13 = 00007fff7d9a6a40 r14 = 0000000000000019 r15 = 0000000000000000
;rip = 00000000004008bf
;rflags = 0000000000000246 of = 0 sf = 0 zf = 1 af = 0 pf = 1 cf = 0


;===== Define constants ===================================================================================================================================================
;Set constants via assembler directives
%define qwordsize 8                     ;8 bytes
%define cmask 00000001h                 ;Carry mask
%define pmask 00000004h                 ;Parity mask
%define amask 00000010h                 ;Auxiliary mask
%define zmask 00000040h                 ;Zero mask
%define smask 00000080h                 ;Sign mask
%define dmask 00000400h                 ;Not used
%define omask 00000800h                 ;Overflow mask

extern printf                                               ;printf will be available to the linker in a binary format

global showgprs                                             ;Make this subprogram callable from outside this file

segment .data                                               ;This segment declares initialized data

showgprs.oldregisterformat1 db "Register Dump # %ld", 10,
                                        db "rax = %016lx rbx = %016lx rcx = %016lx rdx = %016lx", 10,
                                        db "rsi = %016lx rdi = %016lx rbp = %016lx rsp = %016lx", 10, 0

showgprs.registerformat1 db "rax = %016lx rbx = %016lx rcx = %016lx rdx = %016lx", 10,
                                        db "rsi = %016lx rdi = %016lx rbp = %016lx rsp = %016lx", 10, 0


showgprs.registerformat2 db "r8  = %016lx r9  = %016lx r10 = %016lx r11 = %016lx", 10,
                                        db "r12 = %016lx r13 = %016lx r14 = %016lx r15 = %016lx", 10, 0

showgprs.registerformat3 db "rip = %016lx", 10, "rflags = %016lx ",
                                        db "of = %1x sf = %1x zf = %1x af = %1x pf = %1x cf = %1x", 10, 0

showgprs.stringformat db "%s", 0

showgprs.notsupportedmessage db "The xsave instruction is not supported in this microprocessor.", 10, 0

segment .bss                                                ;Declare uninitialized arrays in this segment

align 64                                                    ;The next data object must begin on a 64-byte boundary.
showgprs.backuparea resb 832                                ;Declare an array of sufficient size to hold all data from state components 0, 1, and 2.

segment .text                                               ;Executable instruction are in this segment

showgprs:                                                   ;Execution begins here

;=========== Back up all the GPRs whether used in this program or not =====================================================================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;We do this in order to be 100% compatible with C and C++.
push       rax                                              ;This is a special case: typically rax is not backed up.
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

;==========================================================================================================================================================================
;===== Begin State Component Backup =======================================================================================================================================
;----- To: students.  You are welcome to remove all of these statements related to "State Component Backup" and "State Component Restore".  That state component stuff is
;----- an old project where I was making back up copies of all registers (integer & floating point) without performing dozens of pushes and pops.  You will not effect the
;----- run of your own program by removing "State Component".
;==========================================================================================================================================================================

;=========== Before proceeding verify that this computer supports xsave and xrstor ========================================================================================
;Bit #26 of rcx, written rcx[26], must be 1; otherwise xsave and xrstor are not supported by this computer.
;Preconditions: rax holds 1.
mov        rax, 1

;Execute the cpuid instruction
cpuid

;Postconditions: If rcx[26]==1 then xsave is supported.  If rcx[26]==0 then xsave is not supported.

;=========== Extract bit #26 and test it ==================================================================================================================================

and        rcx, 0x0000000004000000                          ;The mask 0x0000000004000000 has a 1 in position #26.  Now rcx is either all zeros or
                                                            ;has a single 1 in position #26 and zeros everywhere else.
cmp        rcx, 0                                           ;Is (rcx == 0)?
je         .xsavenotsupported                               ;Skip the section that backs up state component data.

;========== Call the function to obtain the bitmap of state components ====================================================================================================

;Preconditions
mov        rax, 0x000000000000000d                          ;Place 13 in rax.  This number is provided in the Intel manual
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

mov        r15, 7                                           ;7 equals three 1 bits.
and        rax, r15                                         ;Bits 63-3 become zeros.
mov        r15, 0                                           ;0 equals 64 binary zeros.
and        rdx, r15                                         ;Zero out rdx.

;========== Save all the data of all three components except GPRs =========================================================================================================

;The instruction xsave will save those state components with on bits in the bitmap.  At this point edx:eax continues to hold the state component bitmap.

;Precondition: edx:eax holds the state component bit map.  This condition has been met by the two pops preceding this statement.
xsave      [.backuparea]                                    ;All the data of state components managed by xsave have been written to backuparea.

push qword -1                                               ;Set a flag (-1 = true) to indicate that state component data were backed up.
jmp        .startapplication                                ;Jump past the message stating "The xsav instruction is not supported"

;========== Show message xsave is not supported on this platform ==========================================================================================================
.xsavenotsupported:

mov        rax, 0                                           ;The zero value indicates that no floating values will be outputted by printf.
mov        rdi, .stringformat                               ;"%s"
mov        rsi, .notsupportedmessage                        ;"The xsave instruction is not supported in this microprocessor.
call       printf

push qword 0                                                ;Set a flag (0 = false) to indicate that state component data were not backed up.

;==========================================================================================================================================================================
;===== End of State Component Backup ======================================================================================================================================
;==========================================================================================================================================================================

;==========================================================================================================================================================================
.startapplication: ;===== Begin the application here: Show the General Purpose Registers ==================================================================================
;==========================================================================================================================================================================

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+18*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+18*8 = rsp+144
;              |---------------------------|
;     rsp+17*8 | return address            |
;              |---------------------------|
;     rsp+16*8 | rbp                       |
;              |---------------------------|
;     rsp+15*8 | rax                       |
;              |---------------------------|
;     rsp+14*8 | rbx                       |
;              |---------------------------|
;     rsp+13*8 | rcx                       |
;              |---------------------------|
;     rsp+12*8 | rdx                       |
;              |---------------------------|
;     rsp+11*8 | rsi                       |
;              |---------------------------|
;     rsp+10*8 | rdi                       |
;              |---------------------------|
;     rsp+9*8  | r8                        |
;              |---------------------------|
;     rsp+8*8  | r9                        |
;              |---------------------------|
;     rsp+7*8  | r10                       |
;              |---------------------------|
;     rsp+6*8  | r11                       |
;              |---------------------------|
;     rsp+5*8  | r12                       |
;              |---------------------------|
;     rsp+4*8  | r13                       |
;              |---------------------------|
;     rsp+3*8  | r14                       |
;              |---------------------------|
;     rsp+2*8  | r15                       |
;              |---------------------------|
;     rsp+1*8  | rflags                    |
;              |---------------------------|
;     rsp      | flag either -1 or 0       |
;              |---------------------------|
;
mov        rax, rsp                                         ;Copy top of stack to an available registers where it can be modified without damage to the true top of stack.
add        rax, 144                                         ;144=18*8.  rax holds address of top of stack at the instant before this program showregisters was called.
push       rax                                              ;The top of stack holds the top of the stack address when showregisters was called.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+18*8 = rsp+144
;              |---------------------------|
;     rsp+18*8 | return address            |
;              |---------------------------|
;     rsp+17*8 | rbp                       |
;              |---------------------------|
;     rsp+16*8 | rax                       |
;              |---------------------------|
;     rsp+15*8 | rbx                       |
;              |---------------------------|
;     rsp+14*8 | rcx                       |
;              |---------------------------|
;     rsp+13*8 | rdx                       |
;              |---------------------------|
;     rsp+12*8 | rsi                       |
;              |---------------------------|
;     rsp+11*8 | rdi                       |
;              |---------------------------|
;     rsp+10*8 | r8                        |
;              |---------------------------|
;     rsp+9*8  | r9                        |
;              |---------------------------|
;     rsp+8*8  | r10                       |
;              |---------------------------|
;     rsp+7*8  | r11                       |
;              |---------------------------|
;     rsp+6*8  | r12                       |
;              |---------------------------|
;     rsp+5*8  | r13                       |
;              |---------------------------|
;     rsp+4*8  | r14                       |
;              |---------------------------|
;     rsp+3*8  | r15                       |
;              |---------------------------|
;     rsp+2*8  | rflags                    |
;              |---------------------------|
;     rsp+1*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp      | original rsp              |                ;"original rsp" means the value in rsp when showregisters was called.
;              |---------------------------|

mov        rax, [rsp+17*8]                                  ;Copy the original rbp to an available register.
push       rax                                              ;Push the original rbp onto the stack.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+20*8 | unknown                   |
;              |---------------------------|
;     rsp+19*8 | return address            |
;              |---------------------------|
;     rsp+18*8 | rbp                       |
;              |---------------------------|
;     rsp+17*8 | rax                       |
;              |---------------------------|
;     rsp+16*8 | rbx                       |
;              |---------------------------|
;     rsp+15*8 | rcx                       |
;              |---------------------------|
;     rsp+14*8 | rdx                       |
;              |---------------------------|
;     rsp+13*8 | rsi                       |
;              |---------------------------|
;     rsp+12*8 | rdi                       |
;              |---------------------------|
;     rsp+11*8 | r8                        |
;              |---------------------------|
;     rsp+10*8 | r9                        |
;              |---------------------------|
;     rsp+9*8  | r10                       |
;              |---------------------------|
;     rsp+8*8  | r11                       |
;              |---------------------------|
;     rsp+7*8  | r12                       |
;              |---------------------------|
;     rsp+6*8  | r13                       |
;              |---------------------------|
;     rsp+5*8  | r14                       |
;              |---------------------------|
;     rsp+4*8  | r15                       |
;              |---------------------------|
;     rsp+3*8  | rflags                    |
;              |---------------------------|
;     rsp+2*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+1*8  | original rsp              |                ;"original rsp" means the value in rsp when showregisters was called.
;              |---------------------------|
;     rsp      | original rbp              |                ;"original rbp" means the value in rbp when showregisters was called.
;              |---------------------------|

mov        rax, [rsp+12*8]                                  ;Copy the original rdi to an available register.
push       rax                                              ;Push the original rdi onto the stack.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+21*8 | unknown                   |
;              |---------------------------|
;     rsp+20*8 | return address            |
;              |---------------------------|
;     rsp+19*8 | rbp                       |
;              |---------------------------|
;     rsp+18*8 | rax                       |
;              |---------------------------|
;     rsp+17*8 | rbx                       |
;              |---------------------------|
;     rsp+16*8 | rcx                       |
;              |---------------------------|
;     rsp+15*8 | rdx                       |
;              |---------------------------|
;     rsp+14*8 | rsi                       |
;              |---------------------------|
;     rsp+13*8 | rdi                       |
;              |---------------------------|
;     rsp+12*8 | r8                        |
;              |---------------------------|
;     rsp+11*8 | r9                        |
;              |---------------------------|
;     rsp+10*8 | r10                       |
;              |---------------------------|
;     rsp+9*8  | r11                       |
;              |---------------------------|
;     rsp+8*8  | r12                       |
;              |---------------------------|
;     rsp+7*8  | r13                       |
;              |---------------------------|
;     rsp+6*8  | r14                       |
;              |---------------------------|
;     rsp+5*8  | r15                       |
;              |---------------------------|
;     rsp+4*8  | rflags                    |
;              |---------------------------|
;     rsp+3*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+2*8  | original rsp              |                ;"original rsp" means the value in rsp when showregisters was called.
;              |---------------------------|
;     rsp+1*8  | original rbp              |                ;"original rbp" means the value in rbp when showregisters was called.
;              |---------------------------|
;     rsp      | original rdi              |                ;"original rdi" means the value in rdi when showregisters was called.
;              |---------------------------|



mov        r9, [rsp+14*8]                                   ;Copy the original rsi to r9, which is the 6th CCC parameter
mov        r8, [rsp+15*8]                                   ;Copy the original rdx to r8, which is the 5th CCC parameter
mov        rcx, [rsp+16*8]                                  ;Copy the original rcx to rcx, which is the 4th CCC parameter
mov        rdx, [rsp+17*8]                                  ;Copy the original rbx to rdx, which is the 3rd CCC parameter
mov        rsi, [rsp+18*8]                                  ;Copy the original rax to rsi, which is the 2nd CCC parameter
mov        rdi, .registerformat1
mov        rax, 0                                           ;The value in rax signals to printf the number of floating point values to be outputted.


call       printf                                           ;Output the first line of numbers.


pop        rax                                              ;Remove and discard original rsi from the stack
pop        rax                                              ;Remove and discard original rdi from the stack
pop        rax                                              ;Remove and discard original rbp from the stack

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+18*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+18*8 = rsp+144
;              |---------------------------|
;     rsp+17*8 | return address            |
;              |---------------------------|
;     rsp+16*8 | rbp                       |
;              |---------------------------|
;     rsp+15*8 | rax                       |
;              |---------------------------|
;     rsp+14*8 | rbx                       |
;              |---------------------------|
;     rsp+13*8 | rcx                       |
;              |---------------------------|
;     rsp+12*8 | rdx                       |
;              |---------------------------|
;     rsp+11*8 | rsi                       |
;              |---------------------------|
;     rsp+10*8 | rdi                       |
;              |---------------------------|
;     rsp+9*8  | r8                        |
;              |---------------------------|
;     rsp+8*8  | r9                        |
;              |---------------------------|
;     rsp+7*8  | r10                       |
;              |---------------------------|
;     rsp+6*8  | r11                       |
;              |---------------------------|
;     rsp+5*8  | r12                       |
;              |---------------------------|
;     rsp+4*8  | r13                       |
;              |---------------------------|
;     rsp+3*8  | r14                       |
;              |---------------------------|
;     rsp+2*8  | r15                       |
;              |---------------------------|
;     rsp+1*8  | rflags                    |
;              |---------------------------|
;     rsp      | flag either -1 or 0       |
;              |---------------------------|

mov        rax, [rsp+2*8]                                   ;Copy the original value of r15 to an available register.
push       rax                                              ;Push the original value of r15 onto the stack.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+18*8 | return address            |
;              |---------------------------|
;     rsp+17*8 | rbp                       |
;              |---------------------------|
;     rsp+16*8 | rax                       |
;              |---------------------------|
;     rsp+15*8 | rbx                       |
;              |---------------------------|
;     rsp+14*8 | rcx                       |
;              |---------------------------|
;     rsp+13*8 | rdx                       |
;              |---------------------------|
;     rsp+12*8 | rsi                       |
;              |---------------------------|
;     rsp+11*8 | rdi                       |
;              |---------------------------|
;     rsp+10*8 | r8                        |
;              |---------------------------|
;     rsp+9*8  | r9                        |
;              |---------------------------|
;     rsp+8*8  | r10                       |
;              |---------------------------|
;     rsp+7*8  | r11                       |
;              |---------------------------|
;     rsp+6*8  | r12                       |
;              |---------------------------|
;     rsp+5*8  | r13                       |
;              |---------------------------|
;     rsp+4*8  | r14                       |
;              |---------------------------|
;     rsp+3*8  | r15                       |
;              |---------------------------|
;     rsp+2*8  | rflags                    |
;              |---------------------------|
;     rsp+1*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp      | original r15              |
;              |---------------------------|

mov        rax, [rsp+4*8]                                   ;Copy the original value of r14 to an available register.
push       rax                                              ;Push the original value of r14 onto the stack.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+20*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+20*8 = rsp+160
;              |---------------------------|
;     rsp+19*8 | return address            |
;              |---------------------------|
;     rsp+18*8 | rbp                       |
;              |---------------------------|
;     rsp+17*8 | rax                       |
;              |---------------------------|
;     rsp+16*8 | rbx                       |
;              |---------------------------|
;     rsp+15*8 | rcx                       |
;              |---------------------------|
;     rsp+14*8 | rdx                       |
;              |---------------------------|
;     rsp+13*8 | rsi                       |
;              |---------------------------|
;     rsp+12*8 | rdi                       |
;              |---------------------------|
;     rsp+11*8 | r8                        |
;              |---------------------------|
;     rsp+10*8 | r9                        |
;              |---------------------------|
;     rsp+9*8  | r10                       |
;              |---------------------------|
;     rsp+8*8  | r11                       |
;              |---------------------------|
;     rsp+7*8  | r12                       |
;              |---------------------------|
;     rsp+6*8  | r13                       |
;              |---------------------------|
;     rsp+5*8  | r14                       |
;              |---------------------------|
;     rsp+4*8  | r15                       |
;              |---------------------------|
;     rsp+3*8  | rflags                    |
;              |---------------------------|
;     rsp+2*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+1*8  | original r15              |
;              |---------------------------|
;     rsp      | original r14              |
;              |---------------------------|

mov        rax, [rsp+6*8]
push       rax

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+21*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+21*8 = rsp+168 using current value of rsp
;              |---------------------------|
;     rsp+20*8 | return address            |
;              |---------------------------|
;     rsp+19*8 | rbp                       |
;              |---------------------------|
;     rsp+18*8 | rax                       |
;              |---------------------------|
;     rsp+17*8 | rbx                       |
;              |---------------------------|
;     rsp+16*8 | rcx                       |
;              |---------------------------|
;     rsp+15*8 | rdx                       |
;              |---------------------------|
;     rsp+14*8 | rsi                       |
;              |---------------------------|
;     rsp+13*8 | rdi                       |
;              |---------------------------|
;     rsp+12*8 | r8                        |
;              |---------------------------|
;     rsp+11*8 | r9                        |
;              |---------------------------|
;     rsp+10*8 | r10                       |
;              |---------------------------|
;     rsp+9*8  | r11                       |
;              |---------------------------|
;     rsp+8*8  | r12                       |
;              |---------------------------|
;     rsp+7*8  | r13                       |
;              |---------------------------|
;     rsp+6*8  | r14                       |
;              |---------------------------|
;     rsp+5*8  | r15                       |
;              |---------------------------|
;     rsp+4*8  | rflags                    |
;              |---------------------------|
;     rsp+3*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+2*8  | original r15              |
;              |---------------------------|
;     rsp+1*8  | original r14              |
;              |---------------------------|
;     rsp      | original r13              |
;              |---------------------------|

mov        r9, [rsp+8*8]
mov        r8, [rsp+9*8]
mov        rcx, [rsp+10*8]
mov        rdx, [rsp+11*8]
mov        rsi, [rsp+12*8]
mov        rdi, .registerformat2
mov        rax, 0
call       printf

pop        rax                                              ;Remove and discard original r13 from the stack
pop        rax                                              ;Remove and discard original r14 from the stack
pop        rax                                              ;Remove and discard original r15 from the stack

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+18*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+18*8 = rsp+144 using current value of rsp
;              |---------------------------|
;     rsp+17*8 | return address            |
;              |---------------------------|
;     rsp+16*8 | rbp                       |
;              |---------------------------|
;     rsp+15*8 | rax                       |
;              |---------------------------|
;     rsp+14*8 | rbx                       |
;              |---------------------------|
;     rsp+13*8 | rcx                       |
;              |---------------------------|
;     rsp+12*8 | rdx                       |
;              |---------------------------|
;     rsp+11*8 | rsi                       |
;              |---------------------------|
;     rsp+10*8 | rdi                       |
;              |---------------------------|
;     rsp+9*8  | r8                        |
;              |---------------------------|
;     rsp+8*8  | r9                        |
;              |---------------------------|
;     rsp+7*8  | r10                       |
;              |---------------------------|
;     rsp+6*8  | r11                       |
;              |---------------------------|
;     rsp+5*8  | r12                       |
;              |---------------------------|
;     rsp+4*8  | r13                       |
;              |---------------------------|
;     rsp+3*8  | r14                       |
;              |---------------------------|
;     rsp+2*8  | r15                       |
;              |---------------------------|
;     rsp+1*8  | rflags                    |
;              |---------------------------|
;     rsp      | flag either -1 or 0       |
;              |---------------------------|

;===== Output the sixth and seventh lines of the register dump ============================================================================================================

;At this time the original value of rflags is at rsp+8, which is second quadword from the top.

;Go into the stack and get a copy of that original rflags
mov qword rbx, [rsp+8]                                      ;Now rbx contain a copy of rflags.

;First part of CCC-64 parameter-passing protocol setup: do the pushes for the right most parameters
;Begin process to extract the cf bit, which is bit #0 from the right.
mov rax, rbx                                                ;Place a copy of rflags into rax
and rax, cmask                                              ;rax has all zero bits except possibly position 0.
push qword rax                                              ;Count: push #1 of this section

;Begin process to extract the pf bit
mov rax, rbx                                                ;Place a new copy of rflags into rax
and rax, pmask                                              ;rax has all zero bits except possible position 2
shr rax, 2                                                  ;The pf bit is bit #2 from the right.
push qword rax                                              ;Count: push #2 of this section

;Begin process to extract the af bit
mov rax, rbx
and rax, amask
shr rax, 4                                                  ;The af bit is bit #4 from the right.
push qword rax                                              ;Count: push #3 of this section

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+21*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+21*8 = rsp+168 using current value of rsp
;              |---------------------------|
;     rsp+20*8 | return address            |
;              |---------------------------|
;     rsp+19*8 | rbp                       |
;              |---------------------------|
;     rsp+18*8 | rax                       |
;              |---------------------------|
;     rsp+17*8 | rbx                       |
;              |---------------------------|
;     rsp+16*8 | rcx                       |
;              |---------------------------|
;     rsp+15*8 | rdx                       |
;              |---------------------------|
;     rsp+14*8 | rsi                       |
;              |---------------------------|
;     rsp+13*8 | rdi                       |
;              |---------------------------|
;     rsp+12*8 | r8                        |
;              |---------------------------|
;     rsp+11*8 | r9                        |
;              |---------------------------|
;     rsp+10*8 | r10                       |
;              |---------------------------|
;     rsp+9*8  | r11                       |
;              |---------------------------|
;     rsp+8*8  | r12                       |
;              |---------------------------|
;     rsp+7*8  | r13                       |
;              |---------------------------|
;     rsp+6*8  | r14                       |
;              |---------------------------|
;     rsp+5*8  | r15                       |
;              |---------------------------|
;     rsp+4*8  | rflags                    |
;              |---------------------------|
;     rsp+3*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+2*8  | cf bit                    |
;              |---------------------------|
;     rsp+1*8  | pf bit                    |
;              |---------------------------|
;     rsp      | af bit                    |
;              |---------------------------|

;Second part of CCC-64 parameter-passing protocol setup: move data into the five fixed registers acting as parameters

;Begin process to extract the zf bit: the zero bit
mov rax, rbx
and rax, zmask
shr rax, 6
mov qword r9, rax                                           ;Parameter #6 of CCC

;Begin process to extract the sf bit: the sign bit
mov rax, rbx
and rax, smask
shr rax, 7
mov qword r8, rax                                           ;Parameter #5 of CCC

;Begin process to extract the of bit: the overflow bit
mov rax, rbx
and rax, omask
shr rax, 11
mov qword rcx, rax                                          ;Parameter #4 of CCC

;Copy the original rflags data to rdx
mov qword rdx, rbx                                          ;Parameter #3 of CCC
;
;rip is a highly protected register in the sense that it is the only one providing neither read nor write privileges.  Therefore, the programmer cannot assign a value to
;rip nor read the value in rip.  The one technique to obtain the value stored in rip is to call a subprogram such as this one, showregisterssubprogram.  The call will
;place a copy of rip on the integer stack.  That value can be retrieved later from the integer stack, and that is what is done here.  That value is the address of the
;next instruction to execute when the current subprogram returns.

;Copy the rip at the time this subprogram was called; the copy goes into rsi, which is parameter #2 of CCC
mov qword rsi, [rsp+20*qwordsize]                           ;We use the return address as the value of rip at the time instantly before showregisters is called.

mov qword rdi, .registerformat3                             ;Parameter #1 of CCC

;Third part of the CCC-64 protocol
mov qword rax, 0
call printf

;Reverse the three recent pushes.
pop rax                                                     ;Discard the qword containing the af bit
pop rax                                                     ;Discard the qword containing the pf bit
pop rax                                                     ;Discard the qword containing the cf bit

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+17*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+17*8 = rsp+136 using current value of rsp
;              |---------------------------|
;     rsp+16*8 | rbp                       |
;              |---------------------------|
;     rsp+15*8 | rax                       |
;              |---------------------------|
;     rsp+14*8 | rbx                       |
;              |---------------------------|
;     rsp+13*8 | rcx                       |
;              |---------------------------|
;     rsp+12*8 | rdx                       |
;              |---------------------------|
;     rsp+11*8 | rsi                       |
;              |---------------------------|
;     rsp+10*8 | rdi                       |
;              |---------------------------|
;     rsp+9*8  | r8                        |
;              |---------------------------|
;     rsp+8*8  | r9                        |
;              |---------------------------|
;     rsp+7*8  | r10                       |
;              |---------------------------|
;     rsp+6*8  | r11                       |
;              |---------------------------|
;     rsp+5*8  | r12                       |
;              |---------------------------|
;     rsp+4*8  | r13                       |
;              |---------------------------|
;     rsp+3*8  | r14                       |
;              |---------------------------|
;     rsp+2*8  | r15                       |
;              |---------------------------|
;     rsp+1*8  | rflags                    |
;              |---------------------------|
;     rsp      | flag either -1 or 0       |
;              |---------------------------|

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
mov        r15, 7
and        rax, r15
mov        r15, 0
and        rdx, r15

xrstor     [.backuparea]

;==========================================================================================================================================================================
;===== End State Component Restore ========================================================================================================================================
;==========================================================================================================================================================================


setreturnvalue: ;=========== Set the value to be returned to the caller ===================================================================================================

mov        rax, 0                                           ;Send 0 back to the caller indicating a successful termination

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
add        rsp, 8                                           ;Remove the old value of rax from the stack and discard that value.  This counts as one pop.
pop        rbp                                              ;Restore rbp

ret                                                         ;Pop the integer stack and resume execution at the address that was popped from the stack.

;===== End of program showregisters ========================================================================================================================================

