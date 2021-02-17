;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;   TTTTTTTTTTTTTTT               A               PPPPPP         Titan Assembly Project, CSUF
;          T                     A A              P    PP        Titan Assembly Project, CSUF
;          T                    A   A             P     PP       Titan Assembly Project, CSUF
;          T                   A     A            P      PP      Titan Assembly Project, CSUF
;          T                  A       A           P     PP       Titan Assembly Project, CSUF
;          T                 A         A          P    PP        Titan Assembly Project, CSUF
;          T                AAAAAAAAAAAAA         PPPPPP         Titan Assembly Project, CSUF
;          T               A             A        P              Titan Assembly Project, CSUF
;          T              A               A       P              Titan Assembly Project, CSUF
;          T             A                 A      P              Titan Assembly Project, CSUF
;          T            A                   A     P              Titan Assembly Project, CSUF
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;Course information
;  Course number: CPSC240
;  Assignment number: 00
;  Due date: 9999-Dec-31
;  Date of last modification: 2014-Jul-09
;Project information
;  Project title: X86 Assembly Debugger
;  Purpose: Show contents of registers, stack, and arrays.  This is a tool used by assembly programmers during the development phase.
;  Status: In continuous maintenance
;  Project files: debug.inc, debug.asm
;  Modules (subprograms): showregisters, dumpstack, showfpusubprogram, showxmmregisters, showymmregisters
;  Those five subprograms are contained within this debug.asm file.
;Translator information
;  Linux: nasm -f elf64 -l debug.lis -o debug.o debug.asm
;References and credits
;  Dr. Paul Carter: www.drpaulcarter.com
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape orientation, 7 points, monospace, 8½x11 paper
;Restrictions
;  This software is for use by persons enrolled in CPSC240.  All other use is unauthorized.
;Information for users  
;  Make this Debug tool available for your own software.  First assemble this file.  Place the include statement |%include "debug.inc"| excluding the vertical bars in your
;  source code at the beginning.  Typically this include directive is the first statement other than comments in a program.
;Future enhancements pending
;  Add the save and restore feature to modules showregistersubprogram, showfpusubprogram, showxmmsubprogram
;  Localize all identifiers to their own subprogram in order that no identifier conflict with another identifier in this file.

;==========================================================================================================================================================================
;===== General facts used in Debug ========================================================================================================================================
;==========================================================================================================================================================================
;CCC-64 sequence of parameters (left to right):
;  1st  rdi
;  2nd  rsi
;  3nd  rdx
;  4rd  rcx
;  5th  r8
;  6th  r9
;  remainder on stack right to left

;Regarding which format specifier to use: the following appear to hold:
; "%x" designates 32-bit hex output with leading zeros suppressed.
; "%lx" designates 64-bit hex output
; "%llx" designates 128-bit hex output
; "%lllx" designates 256-bit hex output
; "%llld" designates 256-bit decimal output
; "%8x" designates 32-bit hex output in 8 columns
; "%016lx" designates 64-bit hex output in 16 columns with leading zeros displayed.
; "%lu" designates 64-bit unsigned integer.

;==========================================================================================================================================================================
;===== Begin subprogram showregisters =====================================================================================================================================
;===== Begin subprogram showregisters =====================================================================================================================================
;===== Begin subprogram showregisters =====================================================================================================================================
;==========================================================================================================================================================================
;Module information
;  This module's call name: showregisterssubprogram
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-July-14
;  Purpose: This module will show the contents of all integer registers including the flags register.
;  Status: The present source code is in production.
;  Future enhancements: Backup the SSE registers.  Find how to detect the presence of AVE and backup AVE only when present.

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

global showregisterssubprogram                              ;Make this subprogram callable from outside this file

segment .data                                               ;This segment declares initialized data

showregisterssubprogram.registerformat1 db "Register Dump # %ld", 10,
                                        db "rax = %016lx rbx = %016lx rcx = %016lx rdx = %016lx", 10,
                                        db "rsi = %016lx rdi = %016lx rbp = %016lx rsp = %016lx", 10, 0

showregisterssubprogram.registerformat2 db "r8  = %016lx r9  = %016lx r10 = %016lx r11 = %016lx", 10,
                                        db "r12 = %016lx r13 = %016lx r14 = %016lx r15 = %016lx", 10, 0

showregisterssubprogram.registerformat3 db "rip = %016lx", 10, "rflags = %016lx ",
                                        db "of = %1x sf = %1x zf = %1x af = %1x pf = %1x cf = %1x", 10, 0

showregisterssubprogram.stringformat db "%s", 0

showregisterssubprogram.notsupportedmessage db "The xsave instruction is not supported in this microprocessor.", 10, 0

segment .bss                                                ;Declare uninitialized arrays in this segment

align 64                                                    ;The next data object must begin on a 64-byte boundary.
showregisterssubprogram.backuparea resb 832                 ;Declare an array of sufficient size to hold all data from state components 0, 1, and 2.

segment .text                                               ;Executable instruction are in this segment

showregisterssubprogram:                                    ;Execution begins here

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
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+18*8 | arbitrary number from user|
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
add        rax, 152                                         ;152=19*8.  rax holds address of top of stack at the instant before this program showregisters was called.
push       rax                                              ;The top of stack holds the top of the stack address when showregisters was called.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+20*8 | unknown                   |
;              |---------------------------|
;     rsp+19*8 | arbitrary number from user|
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
;     rsp+21*8 | unknown                   |
;              |---------------------------|
;     rsp+20*8 | arbitrary number from user|
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
;     rsp+22*8 | unknown                   |
;              |---------------------------|
;     rsp+21*8 | arbitrary number from user|
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

mov        rax, [rsp+14*8]                                  ;Copy the original rsi to an available register.
push       rax                                              ;Push the original rsi onto the stack.

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+23*8 | unknown                   |
;              |---------------------------|
;     rsp+22*8 | arbitrary number from user|
;              |---------------------------|
;     rsp+21*8 | return address            |
;              |---------------------------|
;     rsp+20*8 | rbp                       |
;              |---------------------------|
;     rsp+19*8 | rax                       |
;              |---------------------------|
;     rsp+18*8 | rbx                       |
;              |---------------------------|
;     rsp+17*8 | rcx                       |
;              |---------------------------|
;     rsp+16*8 | rdx                       |
;              |---------------------------|
;     rsp+15*8 | rsi                       |
;              |---------------------------|
;     rsp+14*8 | rdi                       |
;              |---------------------------|
;     rsp+13*8 | r8                        |
;              |---------------------------|
;     rsp+12*8 | r9                        |
;              |---------------------------|
;     rsp+11*8 | r10                       |
;              |---------------------------|
;     rsp+10*8 | r11                       |
;              |---------------------------|
;     rsp+9*8  | r12                       |
;              |---------------------------|
;     rsp+8*8  | r13                       |
;              |---------------------------|
;     rsp+7*8  | r14                       |
;              |---------------------------|
;     rsp+6*8  | r15                       |
;              |---------------------------|
;     rsp+5*8  | rflags                    |
;              |---------------------------|
;     rsp+4*8  | flag either -1 or 0       |
;              |---------------------------|
;     rsp+3*8  | original rsp              |                ;"original rsp" means the value in rsp when showregisters was called.
;              |---------------------------|
;     rsp+2*8  | original rbp              |                ;"original rbp" means the value in rbp when showregisters was called.
;              |---------------------------|
;     rsp+1*8  | original rdi              |                ;"original rdi" means the value in rdi when showregisters was called.
;              |---------------------------|
;     rsp      | original rsi              |                ;"original rsi" means the value in rsi when showregisters was called.
;              |---------------------------|

mov        r9, [rsp+16*8]                                   ;Copy the original rdx to r9, which is the 6th CCC parameter
mov        r8, [rsp+17*8]                                   ;Copy the original rcx to r8, which is the 5th CCC parameter
mov        rcx, [rsp+18*8]                                  ;Copy the original rbx to rcx, which is the 4th CCC parameter
mov        rdx, [rsp+19*8]
mov        rsi, [rsp+22*8]
mov        rdi, .registerformat1
mov        rax, 0                                           ;The value in rax signals to printf the number of floating point values to be outputted.
call       printf

pop        rax                                              ;Remove and discard original rsi from the stack
pop        rax                                              ;Remove and discard original rdi from the stack
pop        rax                                              ;Remove and discard original rbp from the stack
pop        rax                                              ;Remove and discard original rsp from the stack

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+18*8 | arbitrary number from user|
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
;     rsp+20*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+19*8 | arbitrary number from user|
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
;     rsp+21*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+20*8 | arbitrary number from user|
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
;     rsp+22*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+21*8 | arbitrary number from user|
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
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+18*8 | arbitrary number from user|
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
;     rsp+22*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+21*8 | arbitrary number from user|
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
;     rsp+19*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+18*8 | arbitrary number from user|
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
add        rsp, 8                                           ;Remove the old value of rax from the stack and discard that value.
pop        rbp                                              ;Restore rbp

;The instruction "ret n" where n is a positive integer means "pop the stack once to obtain an address X where execution will resume, then add n to rsp effectively popping
;n number of bytes, then resume execution at the address X".

ret 8                                                       ;Pop the integer stack and resume execution at the address that was popped from the stack.

;===== End of program showregisters ========================================================================================================================================




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**



;==========================================================================================================================================================================
;===== Begin subprogram dumpstack =====================================================================================================================================
;===== Begin subprogram dumpstack=====================================================================================================================================
;===== Begin subprogram dumpstack =====================================================================================================================================
;==========================================================================================================================================================================
;Module information
;  This module's call name: dumpstacksubprogram
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-July-8
;  Purpose: This module will show the contents of all integer registers including the flags register.
;  Status: The present source code is in production.
;
;==========================================================================================================================================
;                             Show Stack Subprogram
;==========================================================================================================================================
;
;Program: showstacksubprogram
;Purpose: Show the current state of the X86-64 stack.
;This program is called by the macro code inside the file debug.inc.
;A program should bring in the debug.inc into an application program via a statement such as
;%include "debug.inc"
;
;File name: debug.asm
;Language: X86-64 Intel syntax
;Usage: CPSC240
;Author: F. Holliday
;Last update: 20130329

;Deficiency:  This program, showstacksubprogram, does not backup SSE2 registers.  This is a known issue and will be fixed as soon as time allows.

;Assemble: nasm -f elf64 -l debug.lis -o debug.o debug.asm
;
;Concerning the two pointers rbp and rsp.  The system stack, sometimes called the integer stack, is a built-in stack of 
;quadwords.  (Don't confuse this stack with the floating point stack.)  The pointer rsp always points to the top of the
;stack.  Use of the pointer rbp is optional.  That means that a programmer may use it or disregard it completely.  The
;most common use of the rbp is to point to the start of a new activation record.  An activation record is created when
;a subprogram is called, and it is destroyed when the subprogram returns.
;
;Important:  This program is built on rbp.  That means this program treats rbp as the top of the stack.  When calling
;this program it requires three parameters: an arbitrary integer, the number of qwords outside of the stack to be
;displayed, and the number of qwords inside the stack to be displayed.  Separator commas are placed after the first
;and second parameters.  Example call:  dumpstack 59, 4, 10

;===== Sample of expected output from this subprogram =====================================================================================

;To view the integer stack using rbp as the top use a statement like the following:
;  dumpstack 20, 2, 6
;The results will be as in the following:

;Stack Dump # 20:  rbp = 00007fff3ab0bba0 rsp = 00007fff3ab0bb50
;Offset    Address           Value
;  +48  00007fff3ab0bbd0  0000000000000000
;  +40  00007fff3ab0bbc8  00000000004006d0
;  +32  00007fff3ab0bbc0  0000000100000000
;  +24  00007fff3ab0bbb8  00007fff3ab0bc88
;  +16  00007fff3ab0bbb0  0000000000000000
;   +8  00007fff3ab0bba8  00007f318baf376d
;   +0  00007fff3ab0bba0  0000000000000000
;   -8  00007fff3ab0bb98  ffffffffffffff9d
;  -16  00007fff3ab0bb90  00007fff3ab0bc80

;To view the integer stack using rsp as the top use a pair of statements like the following:
;  mov rbp, rsp
;  dumpstack 21, 2, 6
;The results will be as in the following example

;Stack Dump # 21:  rbp = 00007fffe8e939b0 rsp = 00007fffe8e939b0
;Offset    Address           Value
;  +48  00007fffe8e939e0  00007fffe8e93a00
;  +40  00007fffe8e939d8  00007fffe8e93a00
;  +32  00007fffe8e939d0  00000000ffffffff
;  +24  00007fffe8e939c8  00007f804ae98000
;  +16  00007fffe8e939c0  0000000000000000
;   +8  00007fffe8e939b8  00000000004004a0
;   +0  00007fffe8e939b0  00000000ffffffff
;   -8  00007fffe8e939a8  00007fffe8e939b0
;  -16  00007fffe8e939a0  00007fffe8e939b0

;To view the contents of an array use a pair of statements like the following:
;  mov rbp, myarray
;  dumpstack 32, 0, 6
;The contents of the array will be displayed in 8-bytes segments as in this example:

;Stack Dump # 32:  rbp = 0000000000602a28 rsp = 00007fffe8e939b0
;Offset    Address           Value
;  +48  0000000000602a58  0000000000000000
;  +40  0000000000602a50  0000000000000000
;  +32  0000000000602a48  0000000000000000
;  +24  0000000000602a40  0000000000000000
;  +16  0000000000602a38  0000000000000000
;   +8  0000000000602a30  0000000000004000
;   +0  0000000000602a28  c90fdaa22168c235

;==========================================================================================================================================

;Set constants via assembler directives
%define qwordsize qword 8                                   ;8 bytes

extern printf
global showstacksubprogram                                  ;This declaration allows the subprogram to be called from outside this file.

segment .data                                               ;This segment declares initialized data

stackheadformat db "Stack Dump # %d:  ", 
                db "rbp = %016lx rsp = %016lx", 10, 
                db "Offset    Address           Value", 10, 0

stacklineformat db "%+5d  %016lx  %016lx", 10, 0

segment .bss                                                ;This segment declares uninitialized data
    ;This segment is empty

segment .text                                               ;Executable instructions appear in this segment

showstacksubprogram:                                        ;Where execution begins when this program is called.

;===== Backup all the registers that are used in this program =====================================================================
push rbp                                                    ;Backup the base pointer
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11: printf often changes r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags
;r15 is not used in this subprogram.  rax is intentionally not backed up.

;===== Prepare to output the dump stack header =====================================================================================
;At this time the integer stack has the following structure
;              |---------------------------|
;     rsp+19*8 | rsp                       |
;              |---------------------------|
;     rsp+18*8 | rbp                       |
;              |---------------------------|
;     rsp+17*8 | #qwords inside of stack   |
;              |---------------------------|
;     rsp+16*8 | #qwords outside of stack  |
;              |---------------------------|
;     rsp+15*8 | arbitrary number from user|
;              |---------------------------|
;     rsp+14*8 | return address            |
;              |---------------------------|
;     rsp+13*8 | rbp                       |
;              |---------------------------|
;     rsp+12*8 | rdi                       |
;              |---------------------------|
;     rsp+11*8 | rsi                       |
;              |---------------------------|
;     rsp+10*8 | rdx                       |
;              |---------------------------|
;     rsp+9*8  | rcx                       |
;              |---------------------------|
;     rsp+8*8  | r8                        |
;              |---------------------------|
;     rsp+7*8  | r9                        |
;              |---------------------------|
;     rsp+6*8  | r10                       |
;              |---------------------------|
;     rsp+5*8  | r11                       |
;              |---------------------------|
;     rsp+4*8  | r12                       |
;              |---------------------------|
;     rsp+3*8  | r13                       |
;              |---------------------------|
;     rsp+2*8  | r14                       |
;              |---------------------------|
;     rsp+1*8  | rbx                       |
;              |---------------------------|
;     rsp+0    | rflags                    |
;              |---------------------------|

;===== Output the header prior to displaying the contents of memory =======================================================================
;Assign values to be passed to printf for outputting the dump stack header
mov qword rdi, stackheadformat                              ;The format of the header
mov qword rsi, [rsp+15*8]                                   ;Arbitrary number passed in from caller
mov qword rdx, [rsp+18*8]                                   ;Retrieve the value of rbp
mov qword rcx, [rsp+19*8]                                   ;Retrieve the value of rsp
mov qword rax, 0                                            ;Zero in rax signals to printf that no vector registers (xmm) are used.
call printf

;===== Set up conditions before entering a loop ===========================================================================================
;Retrieve from the stack the number of qwords within the stack to be displayed
mov qword r13, [rsp+17*8]                                   ;r13 will serve as loop counter variable
;Retrieve from the stack the number of qwords outside the stack to be displayed
mov qword r14, [rsp+16*8]                                   ;r14 will help define the loop termination condition
neg r14                                                     ;Negate r14.  Now r14 contains a negative integer

;Setup rbx as offset number that will appear in the first column of output.
mov qword rax, [rsp+17*8]                                   ;Retrieve from the stack the number of qwords within the stack to be displayed.
mov qword r12, 8                                            ;Temporarily store 8 in r12
mul r12                                                     ;Multiply rax by 8 bytes per qword
mov qword rbx, rax                                          ;Save the product in rbx (column 1 of output)

;Retrieve from the stack the original value of rbp; r12 will be the address that appears in the 2nd column of output.
mov qword r12, [rsp+18*8]                                   ;Copy rbp to r12
add r12, rbx                                                ;Give r12 the first address to be display in column 2 of the output.

beginloop:

;===== Prepare to output one line of the body of the stack dump ===========================================================================
;Follow the CCC-64 protocol
mov       rdi, stacklineformat                              ;Format for offset, address, and quadword value
mov qword rsi, rbx                                          ;rbx stores the offset value
mov qword rdx, r12                                          ;r12 stores the address to be displayed
mov qword rcx, [rdx]                                        ;rcx receives the contents of memory at rbp+40
mov qword rax, 0                                            ;No vector registers contain data for printf
call printf

;===== Advance the variables 8 bytes in the direction of small addresses ==================================================================

sub rbx, 8                                                  ;rbx stores column 1, which is the offset value
sub r12, 8                                                  ;r12 stores column 2, which is the address value
dec r13                                                     ;r13 is loop counter; it decrements from high value to low (possibly negative) value

;===== Check for loop termination condition ===============================================================================================
cmp r13, r14                                                ;Compare loop variable r13 with terminating value r14
jge beginloop                                               ;If r13 >= r14 then continue to iterate


;OLD CODE BELOW -- This will eventually be removed

;===== Output the header prior to displaying the contents of memory =======================================================================
;Assign values to be passed to printf for outputting the dump stack header
;mov qword rdi, stackheadformat                              ;The format of the header
;mov qword rsi, [rsp+10*8]                                   ;Arbitrary number passed in from caller
;mov qword rdx, [rsp+13*8]                                   ;Retrieve the value of rbp
;mov qword rcx, [rsp+14*8]                                   ;Retrieve the value of rsp
;mov qword rax, 0                                            ;Zero in rax signals to printf that no vector registers (xmm) are used.
;call printf

;===== Set up conditions before entering a loop ===========================================================================================
;Retrieve from the stack the number of qwords within the stack to be displayed
;mov qword r13, [rsp+12*8]                                   ;r13 will serve as loop counter variable
;Retrieve from the stack the number of qwords outside the stack to be displayed
;mov qword r14, [rsp+11*8]                                   ;r14 will help define the loop termination condition
;neg r14                                                     ;Negate r14.  Now r14 contains a negative integer

;Setup rbx as offset number that will appear in the first column of output.
;mov qword rax, [rsp+12*8]                                   ;Retrieve from the stack the number of qwords within the stack to be displayed.
;mov qword r12, 8                                            ;Temporarily store 8 in r12
;mul r12                                                     ;Multiply rax by 8 bytes per qword
;mov qword rbx, rax                                          ;Save the product in rbx (column 1 of output)

;Retrieve from the stack the original value of rbp; r10 will be the address that appears in the 2nd column of output.
;mov qword r10, [rsp+13*8]                                   ;Copy rbp to r10
;add r10, rbx                                                ;Give r10 the first address to be display in column 2 of the output.

;beginloop:

;===== Prepare to output one line of the body of the stack dump ===========================================================================
;Follow the CCC-64 protocol
;mov       rdi, stacklineformat                              ;Format for offset, address, and quadword value
;mov qword rsi, rbx                                          ;rbx stores the offset value
;mov qword rdx, r10                                          ;r10 stores the address to be displayed
;mov qword rcx, [rdx]                                        ;rcx receives the contents of memory at rbp+40
;mov qword rax, 0                                            ;No vector registers contain data for printf
;call printf

;===== Advance the variables 8 bytes in the direction of small addresses ==================================================================

;sub rbx, 8                                                  ;rbx stores column 1, which is the offset value
;sub r10, 8                                                  ;r10 stores column 2, which is the address value
;dec r13                                                     ;r13 is loop counter; it decrements from high value to low (possibly negative) value

;===== Check for loop termination condition ===============================================================================================
;cmp r13, r14                                                ;Compare loop variable r13 with terminating value r14
;jge beginloop                                               ;If r13 >= r14 then continue to iterate


;END OLD CODE -- End of old stuff that will be removed.


;===== Restore original values to integer registers =======================================================================================

popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

;Now the number of 8-byte pushes equals the number of 8-byte pops.
;
;It is time to leave this program.
ret 40                                                      ;Return to address on top of stack and add 5*8 to rsp.
;End of showstacksubprogram

;==========================================================================================================================================
;                             Show FPU registers subprogram
;==========================================================================================================================================
;
;Program: showfpusubprogram
;Purpose: Show the current state of the FPU87 stack of registers.  Each member of the stack is an individual 10-bytes register in FPU87 
;extended format.
;This program is called by the macro code inside the file debug.inc.
;A program should bring in the debug.inc into an application program via a statement such as
;%include "debug.inc"
;
;File name: debug.asm
;Language: X86-64
;Usage: CPSC240
;Author: F. Holliday
;Last update: 2012-April-27

;Credit: The concepts for this program "showfpusubprogram" originated with a similar program written by Dr Paul Carter, and posted at the
;website www.drpaulcarter.com/pcasm .  His original program is somewhat more sophisticated than this one; for example, to allocate space on
;the integer stack he does not perform 14 individual pushes of one quadword per push.  He uses more advanced techniques to accomplish his 
;goals, and thereby needs fewer instructions.  Nevertheless, this program implements much of his original work using simpler and more 
;tedious programming techniques.

;Deficiency:  This program, showfpusubprogram, does not backup SSE2 registers.  This is a known issue and will be fixed as soon as time allows.

;Assemble: nasm -f elf64 -l debug.lis -o debug.o debug.asm

;Give a name to a famous number via assembler directive
%define qwordsize 8                                         ;8 bytes

;Set masks for Control Word via assembler directives
%define xcontrol 0000000000001000h                          ;bit #12
%define rcontrol 0000000000000c00h                          ;bits #10-11
%define pcontrol 0000000000000300h                          ;bits #8-9
%define pmask    0000000000000020h                          ;bit #5
%define umask    0000000000000010h                          ;bit #4
%define omask    0000000000000008h                          ;bit #3
%define zmask    0000000000000004h                          ;bit #2
%define dmask    0000000000000002h                          ;bit #1
%define imask    0000000000000001h                          ;bit #0 

;Set masks for Status Word via assembler directives
%define iemask 0000000000000001h                            ;bit #0
%define demask 0000000000000002h                            ;bit #1
%define zemask 0000000000000004h                            ;bit #2
%define oemask 0000000000000008h                            ;bit #3
%define uemask 0000000000000010h                            ;bit #4
%define pemask 0000000000000020h                            ;bit #5
%define sfmask 0000000000000040h                            ;bit #6
%define esmask 0000000000000080h                            ;bit #7
%define c0mask 0000000000000100h                            ;bit #8
%define c1mask 0000000000000200h                            ;bit #9
%define c2mask 0000000000000400h                            ;bit #10
%define tpmask 0000000000003800h                            ;bits #11-13
%define c3mask 0000000000004000h                            ;bit #14
%define bmask  0000000000008000h                            ;bit #15

;Set masks for the Tag Word via assembler directives
%define tag7mask 000000000000c000h                          ;bits #14-15
%define tag6mask 0000000000003000h                          ;bits #12-13
%define tag5mask 0000000000000c00h                          ;bits #10-11
%define tag4mask 0000000000000300h                          ;bits #8-9
%define tag3mask 00000000000000c0h                          ;bits #6-7
%define tag2mask 0000000000000030h                          ;bits #4-5
%define tag1mask 000000000000000ch                          ;bits #2-3
%define tag0mask 0000000000000003h                          ;bits #0-1

extern printf

segment .data                                               ;This segment declares initialized data

x87headformat db 10, "X87 FPU Display #%d", 10, "Control Word = %.4x Status Word = %.4x Tag Word = %.4x", 10, 0
stringformat db "%s", 0
columnheadings db "Register Extended hex number   Tag", 10, 0
st7format db "  st7    %04x%016lx  %s", 10, 0
st6format db "  st6    %04x%016lx  %s", 10, 0
st5format db "  st5    %04x%016lx  %s", 10, 0
st4format db "  st4    %04x%016lx  %s", 10, 0
st3format db "  st3    %04x%016lx  %s", 10, 0
st2format db "  st2    %04x%016lx  %s", 10, 0
st1format db "  st1    %04x%016lx  %s", 10, 0
st0format db "  st0    %04x%016lx  %s", 10, 0
;
emptyspace db "Empty or Free space", 0
validnumber db "Valid number", 0
floatingpointzero db "Zero number", 0
specialnumber db "Special: denormal, infinity, or nan", 0
newline db 10, 0 ;temporary
;
;Information about the FPU Control Word was obtained from http://www.c-jump.com/CIS77/reference/Intel/CIS77_24319002/index.html ==> Section 7.3.4
controlwordheading db "Control word by individual components:", 10, "Bit# Value Mnemonic Description", 10, 0
controlwordbit15_13 db "13-15  -     --     Unused", 10, 0
controlwordbit12 db " 12    %01x     X      Infinity control", 10, 0
controlwordbit11_10 db "10-11  %01x     RC     Rounding control", 10, 0
controlwordbit9_8 db " 8-9   %01x     PC     Precision control", 10, 0
controlwordbit7_6 db " 6-7   -     --     Unused", 10, 0
controlwordbit5 db "  5    %01x     PM     Precision mask", 10, 0
controlwordbit4 db "  4    %01x     UM     Underflow mask", 10, 0
controlwordbit3 db "  3    %01x     OM     Overflow mask", 10, 0
controlwordbit2 db "  2    %01x     ZM     Zero divide mask", 10, 0
controlwordbit1 db "  1    %01x     DM     Denormalized operand mask", 10, 0
controlwordbit0 db "  0    %01x     IM     Invalid operation mask", 10, 0            

;Reference regarding FPU Status Word: Plantz (2012), Table 14.4, page 355.
statuswordheading db "Status word by individual bits (Plantz, page 355):", 10, "Bit# Value Mnemonic Description", 10, 0
statuswordbit0 db "  0    %01x     IE     Invalid operation", 10, 0
statuswordbit1 db "  1    %01x     DE     Denormalized operation", 10, 0
statuswordbit2 db "  2    %01x     ZE     Zero divide", 10, 0
statuswordbit3 db "  3    %01x     OE     Overflow", 10, 0
statuswordbit4 db "  4    %01x     UE     Underflow", 10, 0
statuswordbit5 db "  5    %01x     PE     Precision", 10, 0
statuswordbit6 db "  6    %01x     SF     Stack fault", 10, 0
statuswordbit7 db "  7    %01x     ES     Error summary status", 10, 0
statuswordbit8 db "  8    %01x     C0     Condition code 0", 10, 0
statuswordbit9 db "  9    %01x     C1     Condition code 1", 10, 0
statuswordbit10 db " 10    %01x     C2     Condition code 2", 10, 0
statuswordbit11_13 db "11-13  %01x     TOP    Top of stack", 10, 0
statuswordbit14 db " 14    %01x     C3     Condition code 3", 10, 0
statuswordbit15 db " 15    %01x     B      FPU busy", 10, 0
;
;Information about the Tag Word was obtained from http://www.c-jump.com/CIS77/reference/Intel/CIS77_24319002/index.html ==> Section 7.3.6
tagwordheading db "Tag word by individual components each of size 2 bits:", 10,
               db "Tag values: 0=Valid number, 1=Floating point zero, 2=Special number (denormal, infinity, or nan), 3=Empty register (free space)", 10
               db "Bit# Value   Description", 10, 0
tag7bits15_14 db "14-15  %01x     Tag7", 10, 0
tag6bits13_12 db "12-13  %01x     Tag6", 10, 0
tag5bits11_10 db "10-11  %01x     Tag5", 10, 0
tag4bits9_8 db " 8-9   %01x     Tag4", 10, 0
tag3bits7_6 db " 6-7   %01x     Tag3", 10, 0
tag2bits5_4 db " 4-5   %01x     Tag2", 10, 0
tag1bits3_2 db " 2-3   %01x     Tag1", 10, 0
tag0bits1_0 db " 0-1   %01x     Tag0", 10, 0

farewell db "End of FPU87 stack dump", 10, 0

segment .bss                                                ;This segment declares uninitialized data
;
segment .text                                               ;This segment contains executable instructions
global showfpusubprogram                                    ;fpu refers to X87FPU also known as the st stack.

showfpusubprogram:                                          ;A place where execution begins when this program is called.

;Safe programming practice: save all the data that may possibly be modified within this subprogram.  Intentionally the registers rsp and 
;rax are not backed up.
push rbp                                                    ;Back up the very important base pointer register
push rdi                                                    ;Back up rdi
push rsi                                                    ;Back up rsi
push rdx                                                    ;Back up rdx
push rcx                                                    ;Back up rcx
push r8                                                     ;Back up r8
push r9                                                     ;Back up r9
push r10                                                    ;Back up r10
push r11                                                    ;Back up r11
push r12                                                    ;Back up r12
push r13                                                    ;Back up r13
push r14                                                    ;Back up r14
push r15                                                    ;Back up r15
push rbx                                                    ;Back up rbx
pushf                                                       ;Back up rflags

;= = = = = = Begin instructions to output X87 FPU = = = = = = = = =
;
;108 bytes of free storage is needed to store an image of the FPU.
;Here we create 112 bytes of storage (14 qwords).
mov qword rax, 0
push rax  ;push #1
push rax  ;push #2
push rax  ;push #3
push rax  ;push #4
push rax  ;push #5
push rax  ;push #6
push rax  ;push #7
push rax  ;push #8
push rax  ;push #9
push rax  ;push #10
push rax  ;push #11
push rax  ;push #12
push rax  ;push #13
push rax  ;push #14

;Place a copy of the entire FPU into the first 108 bytes of storage.
fsave [rsp]                                       ;There is an alternate command 'fnsave' that is less safe.  Here fsave is used.  After execution of
;                                                 ;fsave the entire fpu is reset; that is, all data are wiped clean identical to using the finit or
;                                                 ;the fninit instruction.

;Prepare for outputting the header line
mov rdi, x87headformat                            ;Copy the starting address of the format to the first standard parameter, namely: rdi
mov qword rsi, [rsp+30*qwordsize]                 ;Copy the identifier number provided by the caller to the second standard parameter, namely: rsi
mov word bx, [rsp]                                ;Retrieve the control word
and rbx, 000000000000ffffh                        ;Make sure the high order bits of rbx are zeros; only the low order word is preserved
mov rdx, rbx                                      ;Copy the control word to the third standard parameter, namely: rdx
mov word bx, [rsp+4]                              ;Get the status word
and rbx, 000000000000ffffh                        ;Make sure the high order bits of rbx are zeros; only the low order word is preserved
mov rcx, rbx                                      ;Copy the status word to the fourth standard parameter, namely: rcx
mov word bx, [rsp+8]                              ;Get the tag word
and rbx, 000000000000ffffh                        ;Make sure the high order bits of rbx are zeros; only the low order word is preserved
mov r8, rbx                                       ;Copy the tag word to the fifth standard parameter, namely: r8
mov qword rax, 0                                  ;Set rax to 0 as standard signal to printf that only integer parameters are in use.
call printf
;
;
;===== Begin section that outputs the contents of the Control Word ========================================================================
;
mov rdi, stringformat                             ;Set up for outputting headings over individual columns of the control word
mov rsi, controlwordheading                       ;Provide the text for each heading over each column
mov qword rax, 0                                  ;rax must be zero unless the output includes fp numbers
call printf

mov qword r15, 0
mov word r15w, [rsp]                              ;r15 is the backup copy of the control word; r15w is the lowest 16 bits of r15

mov rdi, stringformat                             ;Set up for string output only; no numeric outputs
mov rsi, controlwordbit15_13                      ;Assign the start of the text to rsi
mov qword rax, 0
call printf

mov rbx, r15                                      ;rbx is the working copy of the control word
and rbx, xcontrol                                 ;Zero out all bits of the control word except bit #12
shr rbx, 12                                       ;Shift bit number 12 to position #0
mov rdi, controlwordbit12
mov rsi, rbx
mov qword rax, 0                                  ;No fp numbers will be passed to parameters
call printf

mov rbx, r15                                      ;rbx is the working copy of the control word
and rbx, rcontrol                                 ;Zero out all bits of the control word except bits #10 and 11
shr rbx, 10                                       ;Shift bit number 10 to position #0
mov rdi, controlwordbit11_10
mov rsi, rbx
mov qword rax, 0                                  ;No fp numbers will be passed to parameters
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, pcontrol
shr rbx, 8                                        ;Shift bit number 8 to position #0
mov rdi, controlwordbit9_8
mov rsi, rbx
mov qword rax, 0                                  ;No fp numbers will be passed to parameters
call printf
;
mov rdi, stringformat                             ;Output a string message only; no numeric values will be displayed
mov rsi, controlwordbit7_6                        ;Bits 7 and 6 are not used
mov qword rax, 0                                  ;No fp numbers will be passed to parameters
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, pmask
shr rbx, 5                                        ;Shift bit number 5 to position #0
mov rdi, controlwordbit5
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word
and rbx, umask
shr rbx, 4                                        ;Shift bit number 4 to position #0
mov rdi, controlwordbit4
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, omask                                    ;Zero out all bits except bit #3
shr rbx, 3                                        ;Shift bit number 3 to position #0
mov rdi, controlwordbit3
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, zmask
shr rbx, 2
mov rdi, controlwordbit2
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, dmask
shr rbx, 1
mov rdi, controlwordbit1
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the control word; r15 is the permanent copy of the control word
and rbx, imask
;No shifting of bits is necessary
mov rdi, controlwordbit0
mov rsi, rbx
mov qword rax, 0
call printf
;
;===== Begin section that outputs the bits of the Status Word =============================================================================
;
mov rdi, stringformat                             ;Set up for outputting headings over individual columns of the status word
mov rsi, statuswordheading                        ;Provide the text for each heading over each column
mov qword rax, 0                                  ;rax must be zero unless the output includes fp numbers
call printf
;
mov qword r15, 0
mov word r15w, [rsp+4]                            ;r15 is the backup copy of the status word; r15w is the lowest 16 bits of r15
mov rbx, r15                                      ;rbx is the working copy of the status word
and rbx, bmask                                    ;Zero out all bits of status word except bit #15
shr rbx, 15                                       ;Shift bit number 15 to position #0
mov rdi, statuswordbit15
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, c3mask                                   ;Zero out all bits of status word except bit #14
shr rbx, 14                                       ;Shift bit number 14 to position #0
mov rdi, statuswordbit14
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, tpmask                                   ;Zero out all bits of status word except bits #13, 12, and 11
shr rbx, 11                                       ;Shift bits 13, 12 and 11 to positions 2, 1, and 0
mov rdi, statuswordbit11_13
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, c2mask                                   ;Zero out all bits of status word except bit #10
shr rbx, 10                                       ;Shift bit number 10 to position #0
mov rdi, statuswordbit10
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, c1mask                                   ;Zero out all bits of status word except bit #9
shr rbx, 9                                        ;Shift bit number 9 to position #0
mov rdi, statuswordbit9
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, c0mask                                   ;Zero out all bits of status word except bit #8
shr rbx, 8                                        ;Shift bit number 8 to position #0
mov rdi, statuswordbit8
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, esmask                                   ;Zero out all bits of status word except bit #7
shr rbx, 7                                        ;Shift bit number 7 to position #0
mov rdi, statuswordbit7
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, sfmask                                   ;Zero out all bits of status word except bit #6
shr rbx, 6                                        ;Shift bit number 6 to position #0
mov rdi, statuswordbit6
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, pemask                                   ;Zero out all bits of status word except bit #5
shr rbx, 5                                        ;Shift bit number 5 to position #0
mov rdi, statuswordbit5
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, uemask                                   ;Zero out all bits of status word except bit #4
shr rbx, 4                                        ;Shift bit number 4 to position #0
mov rdi, statuswordbit4
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, oemask                                   ;Zero out all bits of status word except bit #3
shr rbx, 3                                        ;Shift bit number 3 to position #0
mov rdi, statuswordbit3
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, zemask                                   ;Zero out all bits of the status word except bit #2
shr rbx, 2                                        ;Shift bit number 2 to position #0
mov rdi, statuswordbit2
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, demask                                   ;Zero out all bits of the status word except bit #1
shr rbx, 1                                        ;Shift bit number 1 to position #0
mov rdi, statuswordbit1
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;Get a new copy of the status word
and rbx, iemask                                   ;Zero out all bits of the status word except bit #0
;No shifting of bits is necessary
mov rdi, statuswordbit0
mov rsi, rbx
mov qword rax, 0
call printf
;
;===== Begin section that outputs the contents of the Tag Word ============================================================================
;
mov rdi, stringformat                             ;Set up for outputting headings over individual columns of the status word
mov rsi, tagwordheading                           ;Provide the text for each heading over each column
mov qword rax, 0                                  ;rax must be zero unless the output includes fp numbers
call printf
;
mov qword r15, 0
mov word r15w, [rsp+8]                            ;r15 is the backup copy of the tag word; r15w is the lowest 16 bits of r15
mov rbx, r15                                      ;rbx is the working copy of the tag word
and rbx, tag7mask                                 ;Zero out all bits except bits #15 and 14
shr rbx, 14                                       ;Shift bit number 14 to position #0
mov rdi, tag7bits15_14
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15                                      ;rbx is the working copy of the tag word
and rbx, tag6mask                                 ;Zero out all bits except bits #13 and 12
shr rbx, 12                                       ;Shift bit number 12 to position #0
mov rdi, tag6bits13_12                            ;Place address of format into first standard parameter
mov rsi, rbx                                      ;Place tag6 into the second standard parameter
mov qword rax, 0                                  ;Indicate that no fp numbers will be passed to the function printf
call printf                                       ;Make print do the work
;
mov rbx, r15
and rbx, tag5mask
shr rbx, 10
mov rdi, tag5bits11_10
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15
and rbx, tag4mask
shr rbx, 8
mov rdi, tag4bits9_8
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15
and rbx, tag3mask
shr rbx, 6
mov rdi, tag3bits7_6
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15
and rbx, tag2mask
shr rbx, 4
mov rdi, tag2bits5_4
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15
and rbx, tag1mask
shr rbx, 2
mov rdi, tag1bits3_2
mov rsi, rbx
mov qword rax, 0
call printf
;
mov rbx, r15
and rbx, tag0mask
;No shifting of bits is necessary
mov rdi, tag0bits1_0
mov rsi, rbx
mov qword rax, 0
call printf
;
;===== Begin setup of tag word for use in displaying type of contents of each fpu register ===============================================
;
;Initial configuration of tag word
;   -----------------------------------------
;   |tag7|tag6|tag5|tag4|tag3|tag2|tag1|tag0|
;   -----------------------------------------
;and each tag component is 2 bits.
;The contents of TOP (within the Status word) indicates which tag associates with st0.  For instance, suppose TOP contain 5, then tag5 
;identifies with register st0 as in the following diagram:
;   -----------------------------------------
;   |tag7|tag6|tag5|tag4|tag3|tag2|tag1|tag0|
;   -----------------------------------------
;     st2  st1  st0  st7  st6  st5  st4  st3
;
;The next step will be to rotate the Tag word to the right in order to align the tags with registers in the order st7 st6 st5 st4 st3 st2 
;st1 st0.  Then the diagram will be as follows:
;   -----------------------------------------
;   |tag7|tag6|tag5|tag4|tag3|tag2|tag1|tag0|
;   -----------------------------------------
;     st7  st6  st5  st4  st3  st2  st1  st0
;Then tag number k is associated with fpu register k.
;
;First obtain a copy of the top pointer.
mov qword r15, 0                                  ;Make sure r15 contains only zeros before placing the status word in r15.
mov word r15w, [rsp+4]                            ;Now the status word is in the lowest word of the 4-word register r15
and r15, tpmask                                   ;Zero out all bits of status word except bits #13, 12, and 11
shr r15, 11                                       ;Shift bits 13, 12 and 11 to positions 2, 1, and 0.  
;                                                 ;Now r15 contains only the top pointer.
;
;Obtain a copy of the Tag word.
mov qword r14, 0
mov word r14w, [rsp+8]                            ;The tag word is now in the lowest 2 bytes of r14.
and r14, 000000000000ffffh                        ;Make sure the upper 6 bytes are all zeros.
;
;Now rotate the Tag word by 2*Top many bits.  The syntax requires that we use a loop rotating by 2 bits with each iteration of the loop.
beginrotateloop:                                  ;Assembly version of a while loop; test stop condition before loop iterates.
     cmp qword r15, 0                             ;Compare: is r15 == 0?
     je  exitrotateloop                           ;If r15 is 0 then the loop has finished.
     ror r14w, 1                                  ;Rotate right 1 bit
     ror r14w, 1                                  ;Rotate right 1 more bit.  Do it twice because tag cells hold two bits.
     dec r15                                      ;r15 = r15 - 1
jmp beginrotateloop
exitrotateloop:
;
;
;
;===== Begin section that outputs the contents of each FPU register =======================================================================

;Display headings over each column.  Column 1 = identifier of register; Column 2 = contents of register; Column 3 = tag value
mov qword rdi, stringformat                       ;First parameter receives the standard string format 
mov qword rsi, columnheadings                     ;Second parameter receives the string to be printed
mov qword rax, 0                                  ;No fp values will be outputted
call printf

;Begin section to output st7
mov qword rdi, st7format                          ;Set the format for st7
mov qword rsi, [rsp+106]                          ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+98]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st7 is in bits 15 and 14 of the tag word r14.  We need that number to classify the data in st7.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag7mask                                 ;Make sure all bits other than bits 14 and 15 are zeros
shr rbx, 14                                       ;Shift the bit in position 14 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st7_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st7_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st7_endcase                               ;Exit from the entire case statement
st7_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st7_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st7_endcase                               ;Exit from the entire case statement
st7_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st7_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st7_endcase                               ;Exit from the entire case statement
st7_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st7_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st7
;
;
;Begin section to output st6
mov qword rdi, st6format                          ;Set the format for st6
mov qword rsi, [rsp+96]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+88]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st6 is in bits 13 and 12 of the tag word r14.  We need that number to classify the data in st6.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag6mask                                 ;Make sure all bits other than bits 13 and 12 are zeros
shr rbx, 12                                       ;Shift the bit in position 12 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st6_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st6_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st6_endcase                               ;Exit from the entire case statement
st6_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st6_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st6_endcase                               ;Exit from the entire case statement
st6_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st6_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st6_endcase                               ;Exit from the entire case statement
st6_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st6_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st6
;
;
;Begin section to output st5
mov qword rdi, st5format                          ;Set the format for st5
mov qword rsi, [rsp+86]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+78]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st5 is in bits 11 and 10 of the tag word r14.  We need that number to classify the data in st5.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag5mask                                 ;Make sure all bits other than bits 11 and 10 are zeros
shr rbx, 10                                       ;Shift the bit in position 10 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st5_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st5_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st5_endcase                               ;Exit from the entire case statement
st5_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st5_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st5_endcase                               ;Exit from the entire case statement
st5_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st5_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st5_endcase                               ;Exit from the entire case statement
st5_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st5_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st5
;
;
;Begin section to output st4
mov qword rdi, st4format                          ;Set the format for st4
mov qword rsi, [rsp+76]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+68]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st4 is in bits 9 and 8 of the tag word r14.  We need that number to classify the data in st4.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag4mask                                 ;Make sure all bits other than bits 9 and 8 are zeros
shr rbx, 8                                       ;Shift the bit in position 8 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st4_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st4_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st4_endcase                               ;Exit from the entire case statement
st4_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st4_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st4_endcase                               ;Exit from the entire case statement
st4_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st4_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st4_endcase                               ;Exit from the entire case statement
st4_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st4_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st4
;
;
;Begin section to output st3
mov qword rdi, st3format                          ;Set the format for st3
mov qword rsi, [rsp+66]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+58]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st3 is in bits 7 and 6 of the tag word r14.  We need that number to classify the data in st3.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag3mask                                 ;Make sure all bits other than bits 9 and 8 are zeros
shr rbx, 6                                       ;Shift the bit in position 6 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st3_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st3_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st3_endcase                               ;Exit from the entire case statement
st3_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st3_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st3_endcase                               ;Exit from the entire case statement
st3_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st3_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st3_endcase                               ;Exit from the entire case statement
st3_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st3_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st3
;
;
;Begin section to output st2
mov qword rdi, st2format                          ;Set the format for st2
mov qword rsi, [rsp+56]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+48]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st2 is in bits 5 and 4 of the tag word r14.  We need that number to classify the data in st2.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag2mask                                 ;Make sure all bits other than bits 5 and 4 are zeros
shr rbx, 4                                        ;Shift the bit in position 4 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st2_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st2_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st2_endcase                               ;Exit from the entire case statement
st2_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st2_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st2_endcase                               ;Exit from the entire case statement
st2_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st2_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st2_endcase                               ;Exit from the entire case statement
st2_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st2_endcase:                                      ;End of the case statement
;
mov qword rax, 0                              
call printf
;End of section to output st2
;
;
;Begin section to output st1
mov qword rdi, st1format                          ;Set the format for st1
mov qword rsi, [rsp+46]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+38]                           ;Copy the last 8 bytes of the number to the 3rd parameter
;The tag cell for st1 is in bits 3 and 2 of the tag word r14.  We need that number to classify the data in st1.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag1mask                                 ;Make sure all bits other than bits 3 and 2 are zeros
shr rbx, 2                                        ;Shift the bit in position 2 to position 0
;
;A case statement will be used to evaluate the contents of rbx.
st1_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st1_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st1_endcase                               ;Exit from the entire case statement
st1_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st1_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st1_endcase                               ;Exit from the entire case statement
st1_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st1_case3                                 ;Jump to case 3 if this is not case 2.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st1_endcase                               ;Exit from the entire case statement
st1_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st1_endcase:                                      ;End of the case statement
;
mov qword rax, 0                                  ;No fp values will be passed to parameters
call printf
;End of section to output st1
;
;
;Begin section to output st0
mov qword rdi, st0format                          ;Set the format for st0
mov qword rsi, [rsp+36]                           ;Copy the first 2 bytes of the number to the 2nd parameter
and rsi, 000000000000ffffh                        ;Make sure the 6 bytes of the high end are zeros
mov qword rdx, [rsp+28]                           ;Copy the last 8 bytes of the number to the 3rd parameter

;The tag cell for st0 is in bits 1 and 0 of the tag word r14.  We need that number to classify the data in st7.
mov rbx, r14                                      ;Place a copy of the tag word into rbx
and rbx, tag0mask                                 ;Make sure all bits other than bits 1 and 0 are zeros
;
;A case statement will be used to evaluate the contents of rbx.
st0_case0:
    cmp rbx, 0                                    ;Check for case 0
    jne st0_case1                                 ;Jump to case 1 if this is not case 0.
    mov rcx, validnumber                          ;Copy the address of the classifying label to the 4th parameter.
    jmp st0_endcase                               ;Exit from the entire case statement
st0_case1:
    cmp rbx, 1                                    ;Check for case 1
    jne st0_case2                                 ;Jump to case 2 if this is not case 1.
    mov rcx, floatingpointzero                    ;Copy the address of the classifying label to the 4th parameter.
    jmp st0_endcase                               ;Exit from the entire case statement
st0_case2:
    cmp rbx, 2                                    ;Check for case 2
    jne st0_case3                                 ;Jump to case 2 if this is not case 1.
    mov rcx, specialnumber                        ;Copy the address of the classifying label to the 4th parameter.
    jmp st0_endcase                               ;Exit from the entire case statement
st0_case3: ;default case -- if the numeric value in rbx is not (0 or 1 or 2) then it must be 3.
    mov rcx, emptyspace                           ;Copy the address of the classifying tag to the 4th parameter.
st0_endcase:                                      ;End of the case statement
;
mov qword rax, 0                                  ;No fp values will be passed to parameters.
call printf
;End of section to output st0

;===============================
;End of showing FPU registers  |
;===============================
;
;===== Final message ====================================================================================================================== 
;
mov qword rdi, stringformat                                 ;"%s"
mov qword rsi, farewell                                     ;"End of FPU87 stack dump"
mov qword rax, 0                                            ;Do not use any data from SSE
call printf                                                 ;Standard library function handles the output
;
;Dr Carter's program restores all the data in the FPU from memory.  Therefore, we do it here also. 
;Think of the frstor instruction as the reverse of the fsave instruction; it restores all the fpu registers from the system stack.  
;Scan the source code above belonging to the function showfpusubprogram and notice that between the fsave instruction and the frstor 
;instruction below the system stack is never modified.  Therefore, it should be safe to apply the frstor instruction.
;
frstor [rsp]   ;Hopefully rsp has not changed since the fsave instruction was executed earlier.
;
;===== Time to clean up and return to the caller ==========================================================================================
;This program is preparing to terminate.  It is time to reverse those earlier pushes.

;First do 14 pops and discard any data.  Undoubtedly Dr Carter has a more sophisticated way to accomplish the same result.
pop rax  ;pop #1
pop rax  ;pop #2
pop rax  ;pop #3
pop rax  ;pop #4
pop rax  ;pop #5
pop rax  ;pop #6
pop rax  ;pop #7
pop rax  ;pop #8
pop rax  ;pop #9
pop rax  ;pop #10
pop rax  ;pop #11
pop rax  ;pop #12
pop rax  ;pop #13
pop rax  ;pop #14
;
;Restore orginal values to the integer registers
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp
;
;
;===== Return an integer value 0 to the caller ====================================================================================================
;
mov qword rax, 0                                            ;Return value 0 indicates successful conclusion.
ret 8                                                       ;Return to the address on top of the stack and then discard one qword from the top of the stack.
;End of showfpusubprogram 
;========== End of showfpusubprogram ==============================================================================================================
;
;
;==================================================================================================================================================
;==================================================================================================================================================
;                             Show XMM Registers Subprogram
;==================================================================================================================================================
;==================================================================================================================================================

global showxmmsubprogram

segment .data

formatstring db "%s", 0
formatdumpnumber db "SSE2 Dump # %ld", 10, 0
formatsseheader db "xmm##        high64              low64", 10, 0
formatxmm15 db     "xmm15:  %016lx    %016lx", 10, 0
formatxmm14 db     "xmm14:  %016lx    %016lx", 10, 0
formatxmm13 db     "xmm13:  %016lx    %016lx", 10, 0
formatxmm12 db     "xmm12:  %016lx    %016lx", 10, 0
formatxmm11 db     "xmm11:  %016lx    %016lx", 10, 0
formatxmm10 db     "xmm10:  %016lx    %016lx", 10, 0
formatxmm9  db     "xmm9:   %016lx    %016lx", 10, 0
formatxmm8  db     "xmm8:   %016lx    %016lx", 10, 0
formatxmm7  db     "xmm7:   %016lx    %016lx", 10, 0
formatxmm6  db     "xmm6:   %016lx    %016lx", 10, 0
formatxmm5  db     "xmm5:   %016lx    %016lx", 10, 0
formatxmm4  db     "xmm4:   %016lx    %016lx", 10, 0
formatxmm3  db     "xmm3:   %016lx    %016lx", 10, 0
formatxmm2  db     "xmm2:   %016lx    %016lx", 10, 0
formatxmm1  db     "xmm1:   %016lx    %016lx", 10, 0
formatxmm0  db     "xmm0:   %016lx    %016lx", 10, 0

segment .text
showxmmsubprogram:

;========== Create backups for integer registers ========================================================================================
;Safe programming practice: save all the data that may possibly be modified within this subprogram.  Intentionally the registers rsp
;and rax are not backed up.
push rbp                                                    ;Back up the very important base pointer register
push rdi                                                    ;Back up rdi
push rsi                                                    ;Back up rsi
push rdx                                                    ;Back up rdx
push rcx                                                    ;Back up rcx
push r8                                                     ;Back up r8
push r9                                                     ;Back up r9
push r10                                                    ;Back up r10
push r11                                                    ;Back up r11
push r12                                                    ;Back up r12
push r13                                                    ;Back up r13
push r14                                                    ;Back up r14
push r15                                                    ;Back up r15
push rbx                                                    ;Back up rbx
pushf                                                       ;Back up rflags

;========== Copy all xmm values to the integer stack ====================================================================================
align 16
push qword 0
push qword 0
movupd     [rsp], xmm15
push qword 0
push qword 0
movupd     [rsp], xmm14
push qword 0
push qword 0
movupd     [rsp], xmm13
push qword 0
push qword 0
movupd     [rsp], xmm12
push qword 0
push qword 0
movupd     [rsp], xmm11
push qword 0
push qword 0
movupd     [rsp], xmm10
push qword 0
push qword 0
movupd     [rsp], xmm9
push qword 0
push qword 0
movupd     [rsp], xmm8
push qword 0
push qword 0
movupd     [rsp], xmm7
push qword 0
push qword 0
movupd     [rsp], xmm6
push qword 0
push qword 0
movupd     [rsp], xmm5
push qword 0
push qword 0
movupd     [rsp], xmm4
push qword 0
push qword 0
movupd     [rsp], xmm3
push qword 0
push qword 0
movupd     [rsp], xmm2
push qword 0
push qword 0
movupd     [rsp], xmm1
push qword 0
push qword 0
movupd     [rsp], xmm0
;========= End of copying xmm values to the integer stack =================================================================================

;========= Begin section that will display all the xmm values =============================================================================
align 16
mov qword  rax, 0
mov        rdi, formatdumpnumber
mov        rsi, [rsp+48*8]
call       printf
mov qword  rax, 0
mov        rdi, formatstring                                ;"%s", 0
mov        rsi, formatsseheader                             ;"xmm**    high64    low64"
call       printf
mov qword  rax, 0
mov        rdi, formatxmm15
mov        rsi, [rsp+31*8]
mov        rdx, [rsp+30*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm14
mov        rsi, [rsp+29*8]
mov        rdx, [rsp+28*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm13
mov        rsi, [rsp+27*8]
mov        rdx, [rsp+26*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm12
mov        rsi, [rsp+25*8]
mov        rdx, [rsp+24*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm11
mov        rsi, [rsp+23*8]
mov        rdx, [rsp+22*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm10
mov        rsi, [rsp+21*8]
mov        rdx, [rsp+20*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm9
mov        rsi, [rsp+19*8]
mov        rdx, [rsp+18*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm8
mov        rsi, [rsp+17*8]
mov        rdx, [rsp+16*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm7
mov        rsi, [rsp+15*8]
mov        rdx, [rsp+14*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm6
mov        rsi, [rsp+13*8]
mov        rdx, [rsp+12*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm5
mov        rsi, [rsp+11*8]
mov        rdx, [rsp+10*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm4
mov        rsi, [rsp+9*8]
mov        rdx, [rsp+8*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm3
mov        rsi, [rsp+7*8]
mov        rdx, [rsp+6*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm2
mov        rsi, [rsp+5*8]
mov        rdx, [rsp+4*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm1
mov        rsi, [rsp+3*8]
mov        rdx, [rsp+2*8]
call       printf
mov qword  rax, 0
mov        rdi, formatxmm0
mov        rsi, [rsp+1*8]
mov        rdx, [rsp+0*8]
call       printf

;========== Restore all the data to the SEE2 registers ===================================================================================

movupd     xmm15, [rsp+30*8]
movupd     xmm14, [rsp+28*8]
movupd     xmm13, [rsp+26*8]
movupd     xmm12, [rsp+24*8]
movupd     xmm11, [rsp+22*8]
movupd     xmm10, [rsp+20*8]
movupd     xmm9,  [rsp+18*8]
movupd     xmm8,  [rsp+16*8]
movupd     xmm7,  [rsp+14*8]
movupd     xmm6,  [rsp+12*8]
movupd     xmm5,  [rsp+10*8]
movupd     xmm4,  [rsp+8*8]
movupd     xmm3,  [rsp+6*8]
movupd     xmm2,  [rsp+4*8]
movupd     xmm1,  [rsp+2*8]
movupd     xmm0,  [rsp+0*8]

;========= Reverse the pushes that occurred in this subprogram ============================================================================
pop rax                                                     ;#32
pop rax                                                     ;#31
pop rax                                                     ;#30
pop rax                                                     ;#29
pop rax                                                     ;#28
pop rax                                                     ;#27
pop rax                                                     ;#26
pop rax                                                     ;#25
pop rax                                                     ;#24
pop rax                                                     ;#23
pop rax                                                     ;#22
pop rax                                                     ;#21
pop rax                                                     ;#20
pop rax                                                     ;#19
pop rax                                                     ;#18
pop rax                                                     ;#17
pop rax                                                     ;#16
pop rax                                                     ;#15
pop rax                                                     ;#14
pop rax                                                     ;#13
pop rax                                                     ;#12
pop rax                                                     ;#11
pop rax                                                     ;#10
pop rax                                                     ;#9
pop rax                                                     ;#8
pop rax                                                     ;#7
pop rax                                                     ;#6
pop rax                                                     ;#5
pop rax                                                     ;#4
pop rax                                                     ;#3
pop rax                                                     ;#2
pop rax                                                     ;#1

;=========== Restore the original values to the integer registers =========================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

;========== Gently exit from this subprogram ==============================================================================================================================

mov qword rax, 0                                            ;Return value 0 indicates successful conclusion.
ret 8                                                       ;Return to the address on top of the stack and then discard one qword from the 
;                                                           ;top of the stack.  The latter action is due to the '8' following the 'ret'.

;========== End of showxmmsubprogram ======================================================================================================================================





;===========================================================================================================================================================================
;===========================================================================================================================================================================
;                             Show YMM Registers Subprogram
;===========================================================================================================================================================================
;===========================================================================================================================================================================
;
;Author: Floyd Holliday
;Author email: holliday@fullerton.edu or activeprofessor@yahoo.com
;Subprogram name: showymmsubprogram
;Language: X86
;Syntax: Intel
;Date begun: 2013-Nov-15
;Dates modified: 2014-Jan-22, 2014-Mar-4, 2014-Jul-7
;Purpose: Show the contents of all 16 ymm registers in the AVX and SSE components.
;Strategy: First backup all of AVX and SSE using xsave
;          Second copy all ymm data to the stack
;          Third display on the standard output device the ymm data from the stack
;          Fourth restore the original data to AVX and SSE using xrstor
;Terminology: AVX is Advanced Vector Extensions (state component 2).  SSE is Streaming SIMD Extensions (state component 1).  SIMD is Single Instruction - Multiple Data.
;The registers ymm span both AVX and SSE: the upper half of each ymm register is in AVX and the lower half is in SSE.
;Format information:
;   Page width: 172 columns
;   Comments begin: column 61
;   Optimal printing: Landscape, 7 point font, monospace, 8½x11 paper

global showymmsubprogram

extern printf

segment .data

showymmsubprogram.aveheaderfirst db "AVX Dump # %ld", 10, 0
showymmsubprogram.aveheadersecond db "       |-----------------------------ymm registers---------------------------------|", 10, 0
showymmsubprogram.aveheaderthird  db "       |                                                                           |", 10, 0
showymmsubprogram.aveheaderfourth db "       |---------AVX Registers--------------|-----------SSE registers------------| |", 10, 0
showymmsubprogram.aveheaderfifth  db "       |                                    |                                    | |", 10, 0
showymmsubprogram.aveymm15        db "ymm15: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm14        db "ymm14: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm13        db "ymm13: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm12        db "ymm12: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm11        db "ymm11: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm10        db "ymm10: | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm9         db "ymm9:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm8         db "ymm8:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm7         db "ymm7:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm6         db "ymm6:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm5         db "ymm5:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm4         db "ymm4:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm3         db "ymm3:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm2         db "ymm2:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm1         db "ymm1:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.aveymm0         db "ymm0:  | %016lx  %016lx | %016lx  %016lx | |", 10, 0
showymmsubprogram.avefooter       db "       |-------------------------------------------------------------------------|-|", 10, 0

xsavenotsupported.stringformat db "%s", 0
xsavenotsupported.notsupportedmessage db "The xsave instruction is not suported in this microprocessor.", 10, 0

segment .bss

align 64                                                    ;The next data below must begin on a 64-byte boundary
showymmsubprogram.backuparea resb 832                       ;Create 832 bytes of storage for the data from state components 0 though 2.

segment .text

showymmsubprogram:

;=========== Back up all the GPRs whether used in this program or not ======================================================================================================

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


;===========================================================================================================================================================================
;===== Begin State Component Backup ========================================================================================================================================
;===========================================================================================================================================================================

;=========== Before proceeding verify that this computer supports xsave and xrstor =========================================================================================
;Bit #26 of rcx, written rcx[26], must be 1; otherwise xsave and xrstor are not supported by this computer.
;Preconditions: rax holds 1.
mov        rax, 1

;Execute the cpuid instruction
cpuid

;Postconditions: If rcx[26]==1 then xsave is supported.  If rcx[26]==0 then xsave is not supported.

;=========== Extract bit #26 and test it ===================================================================================================================================

and        rcx, 0x0000000004000000                          ;The mask 0x0000000004000000 has a 1 in position #26.  Now rcx is either all zeros or
                                                            ;has a single 1 in position #26 and zeros everywhere else.
cmp        rcx, 0                                           ;Is (rcx == 0)?
je         xsavenotsupported                                ;Skip the section that backs up state component data.

;========== Call the function to obtain the bitmap of state components =====================================================================================================

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

;========== Save all the data of all three components except GPRs ==========================================================================================================

;The instruction xsave will save those state components with on bits in the bitmap.  At this point edx:eax continues to hold the state component bitmap.

;Precondition: edx:eax holds the state component bit map.  This condition has been met by the two pops preceding this statement.
xsave      [.backuparea]                                    ;All the data of state components managed by xsave have been written to backuparea.

push qword -1                                               ;Set a flag (-1 = true) to indicate that state component data were backed up.
jmp        startapplication

;========== Show message xsave is not supported on this platform ===========================================================================================================
xsavenotsupported:

mov        rax, 0
mov        rdi, .stringformat
mov        rsi, .notsupportedmessage                        ;"The xsave instruction is not suported in this microprocessor.
call       printf

push qword 0                                                ;Set a flag (0 = false) to indicate that state component data were not backed up.

;===========================================================================================================================================================================
;===== End of State Component Backup =======================================================================================================================================
;===========================================================================================================================================================================

;===== State of the integer stack at this time ============================================================================================================================

;              |---------------------------|
;     rsp+18*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;              |---------------------------|
;     rsp+17*8 | arbitrary number from user|
;              |---------------------------|
;     rsp+16*8 | return address            |
;              |---------------------------|
;     rsp+15*8 | rbp                       |
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

;===========================================================================================================================================================================
startapplication: ;===== Begin the application here: Show contents of ymm registers ========================================================================================
;===========================================================================================================================================================================

;========== Copy all ymm data to the system stack ==========================================================================================================================

sub        rsp, 512                                         ;Create storage with the exact size needed to store the data of all ymm registers.

vmovupd    [rsp+15*32], ymm15                               ;16 tedious copy instructions
vmovupd    [rsp+14*32], ymm14                               ;ditto
vmovupd    [rsp+13*32], ymm13                               ;ditto
vmovupd    [rsp+12*32], ymm12                               ;ditto
vmovupd    [rsp+11*32], ymm11                               ;ditto
vmovupd    [rsp+10*32], ymm10                               ;ditto
vmovupd    [rsp+9*32], ymm9                                 ;ditto
vmovupd    [rsp+8*32], ymm8                                 ;ditto
vmovupd    [rsp+7*32], ymm7                                 ;ditto
vmovupd    [rsp+6*32], ymm6                                 ;ditto
vmovupd    [rsp+5*32], ymm5                                 ;ditto
vmovupd    [rsp+4*32], ymm4                                 ;ditto
vmovupd    [rsp+3*32], ymm3                                 ;ditto
vmovupd    [rsp+2*32], ymm2                                 ;ditto
vmovupd    [rsp+1*32], ymm1                                 ;ditto
vmovupd    [rsp+0*32], ymm0                                 ;ditto

;========== End of copying ymm values to the integer stack =================================================================================================================

;===== State of the integer stack at this time ============================================================================================================================

;               |---------------------------|
;  rsp+512+18*8 | unknown                   | <== top of stack at the instant before calling showregisters, which is rsp+19*8 = rsp+152
;               |---------------------------|
;  rsp+512+17*8 | arbitrary number from user|
;               |---------------------------|
;  rsp+512+16*8 | return address            |
;               |---------------------------|
;  rsp+512+15*8 | rbp                       |
;               |---------------------------|
;  rsp+512+14*8 | rbx                       |
;               |---------------------------|
;  rsp+512+13*8 | rcx                       |
;               |---------------------------|
;  rsp+512+12*8 | rdx                       |
;               |---------------------------|
;  rsp+512+11*8 | rsi                       |
;               |---------------------------|
;  rsp+512+10*8 | rdi                       |
;               |---------------------------|
;  rsp+512+9*8  | r8                        |
;               |---------------------------|
;  rsp+512+8*8  | r9                        |
;               |---------------------------|
;  rsp+512+7*8  | r10                       |
;               |---------------------------|
;  rsp+512+6*8  | r11                       |
;               |---------------------------|
;  rsp+512+5*8  | r12                       |
;               |---------------------------|
;  rsp+512+4*8  | r13                       |
;               |---------------------------|
;  rsp+512+3*8  | r14                       |
;               |---------------------------|
;  rsp+512+2*8  | r15                       |
;               |---------------------------|
;  rsp+512+1*8  | rflags                    |
;               |---------------------------|
;  rsp+512      | flag either -1 or 0       |
;               |---------------------------|
;               |                           |
;               |                           |
;               |                           |
;               |      512 bytes for        |
;               |      ymm registers        |
;               |                           |
;               |                           |
;               |                           |
;  rsp          |---------------------------|

;========== Begin section that will display all the ymm values =============================================================================================================
align 16
mov qword  rax, 0
mov        rdi, showymmsubprogram.aveheaderfirst
mov        rsi, [rsp+512+17*8]                            ;rsp+512+17*8 is the location of the ID integer used by the programmer when calling showymmregisters
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveheadersecond
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveheaderthird
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveheaderfourth
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveheaderfifth
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm15
mov        rsi, [rsp+63*8]
mov        rdx, [rsp+62*8]
mov        rcx, [rsp+61*8]
mov        r8,  [rsp+60*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm14
mov        rsi, [rsp+59*8]
mov        rdx, [rsp+58*8]
mov        rcx, [rsp+57*8]
mov        r8,  [rsp+56*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm13
mov        rsi, [rsp+55*8]
mov        rdx, [rsp+54*8]
mov        rcx, [rsp+53*8]
mov        r8,  [rsp+52*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm12
mov        rsi, [rsp+51*8]
mov        rdx, [rsp+50*8]
mov        rcx, [rsp+49*8]
mov        r8,  [rsp+48*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm11
mov        rsi, [rsp+47*8]
mov        rdx, [rsp+46*8]
mov        rcx, [rsp+45*8]
mov        r8,  [rsp+44*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm10
mov        rsi, [rsp+43*8]
mov        rdx, [rsp+42*8]
mov        rcx, [rsp+41*8]
mov        r8,  [rsp+40*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm9
mov        rsi, [rsp+39*8]
mov        rdx, [rsp+38*8]
mov        rcx, [rsp+37*8]
mov        r8,  [rsp+36*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm8
mov        rsi, [rsp+35*8]
mov        rdx, [rsp+34*8]
mov        rcx, [rsp+33*8]
mov        r8,  [rsp+32*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm7
mov        rsi, [rsp+31*8]
mov        rdx, [rsp+30*8]
mov        rcx, [rsp+29*8]
mov        r8,  [rsp+28*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm6
mov        rsi, [rsp+27*8]
mov        rdx, [rsp+26*8]
mov        rcx, [rsp+25*8]
mov        r8,  [rsp+24*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm5
mov        rsi, [rsp+23*8]
mov        rdx, [rsp+22*8]
mov        rcx, [rsp+21*8]
mov        r8,  [rsp+20*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm4
mov        rsi, [rsp+19*8]
mov        rdx, [rsp+18*8]
mov        rcx, [rsp+17*8]
mov        r8,  [rsp+16*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm3
mov        rsi, [rsp+15*8]
mov        rdx, [rsp+14*8]
mov        rcx, [rsp+13*8]
mov        r8,  [rsp+12*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm2
mov        rsi, [rsp+11*8]
mov        rdx, [rsp+10*8]
mov        rcx, [rsp+9*8]
mov        r8,  [rsp+8*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm1
mov        rsi, [rsp+7*8]
mov        rdx, [rsp+6*8]
mov        rcx, [rsp+5*8]
mov        r8,  [rsp+4*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.aveymm0
mov        rsi, [rsp+3*8]
mov        rdx, [rsp+2*8]
mov        rcx, [rsp+1*8]
mov        r8,  [rsp+0*8]
call       printf

mov qword  rax, 0
mov        rdi, showymmsubprogram.avefooter
call       printf

;========== End section that will display all the ymm values ===============================================================================================================

;========== Reverse the pushes that occurred in this subprogram ============================================================================================================

;Earlier in this program, showymmsubprogram, the instruction "sub rsp, 832" created 832 bytes of storage.  Now it is time to free that space

add rsp, 512                                                ;Free previously allocated space

;The stack in now in the same state it was in when execution of the application started.

;===========================================================================================================================================================================
;===== End of the application: Show contents of AVX registers ==============================================================================================================
;===========================================================================================================================================================================


;===========================================================================================================================================================================
;===== Begin State Component Restoration ==================================================================================================================================
;===========================================================================================================================================================================

;===== Check the flag to determine if state components were really backed up ===============================================================================================

pop        rbx                                              ;Obtain a copy of the flag that indicates state component backup or not.

cmp        rbx, 0                                           ;If there was no backup of state components then jump past the restore section.
je         leavestatecomponentrestoration                   ;There are not data to be restored

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

xrstor     [showymmsubprogram.backuparea]

;===========================================================================================================================================================================
;===== End State Component Restoration ====================================================================================================================================
;===========================================================================================================================================================================

leavestatecomponentrestoration:

;=========== Now restore original values to GPRs ===========================================================================================================================

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

;========== Exit gently from this subprogram ===============================================================================================================================

mov qword  rax, 0                                           ;Return zero to caller marking a successful conclusion.
ret        8                                                ;Go to the address on top of the stack, and then discard 8 from the stack.

;===========================================================================================================================================================================
;========== End of showymmsubprogram =======================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**












;===========================================================================================================================================================================
;========== Begin footnotes ================================================================================================================================================
;===========================================================================================================================================================================
;From Professional Assembly Language by Richard Blum, page 241.
;The tag register is used to identify the values with the eight 80-bit FPU data registers.  The tag register uses 16 bits (2 bits per register) to identify
;the contents of each FPU data registers.  See figure below.
;
;Bits:                   15&14 13&12 11&10 9&8 7&6 5&4 3&2 1&0
;Physical registers:      R7    R6    R5   R4  R3  R2  R1  R0
;
;Each tag value corresponds to a physical FPU register.  The 2-bit value for each register can contain on of four special codes indicating the content of the
;register.  At any given time, an FPU data register can contain any one of the following "tags":
    ;code 00:  a valid extended value
    ;code 01:  the value zero
    ;code 10:  one of the special fp value: denormal, infinity, or nan
    ;code 11:  empty [free space, probably a nan]
;This enables programmers to perform a quick check of the tag register to determine whether valid data may be in an FPU register, instead of having to read 
;and analyze the contents of the register, although in practice, because you are the one putting the values into the register stack, you should already know 
;what is there.
;===========================================================================================================================================================================

