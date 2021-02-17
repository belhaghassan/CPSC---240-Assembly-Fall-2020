;Author name: Floyd Holliday
;Author email: holliday@fullerton.edu

;Program name: Show System Memory
;Programming languages: C++ (driver), X86 (algorithm)
;Date program began: March 1, 2019
;Date of last update: March 3, 2019
;Files in this program: viewmemory-driver.c, viewmemory.asm, r.sh
;Status: Done.  No more work will be done on this program apart from fixing any reported errors.
;Purpose: Display a segment of memory centered at an address provided by the user of this program.  The output will included qwords 
;in hex both before and after the given address.

;This file name: viewmemory.asm
;This file language: X86
;This file syntax: Intel
;Assemble: nasm -f elf64 -o view.o -l viewmemory.lis viewmemory.asm

;Program Viewmemory: display a contiguous segment of memory:
;Parameters passed in:
;     rdi = identifying integer
;     rsi = number of qwords located at smaller addresses, non-negative integer
;     rdx = number of qwords located at higher addresses, non-negative integer
;     rcx = address (location) where the output is localized; this is zero-point.

;Create a new term for use in this program:
;    The zero-point is a location (or an address) where the human user of this software has focused attention.  This quantity is 
;    passed in by the calling program.

;Prototype of this function: 
;    long unsigned int * viewmemory(long int a, long unsigned int b, long unsigned int c, void * d);

;Identify incoming parameters:  
;    1st parameter a = an arbitrary integer sent by the caller for identification purposes only; may be negative.
;    2nd parameter b = number of qwords with addresses less than the zero point.
;    3rd parameter c = number of qwords with addresses greater than the zero point.
;    4th parameter d = the physical address of the zero point itself.

;Identify the single outgoing parameter:
;    The outgoing parameter is the address of the next instruction to be executed following the 'ret' instruction.

;Lessons to learn: What is an address? Your first answer is probably 64 bits holding a non-negative integer.  That is true, and we 
;call such things "unsigned longs".  However, an address is rather special kind of "unsigned long".  For example we never think of 
;multiplying together two unsigned long addresses.  Nor do we ever consider dividing one address by another address to obtain a 
;third address.  Therefore, we come to the question of what data type in C++ best describes 64-bit numbers with a limited set of 
;arithmetic operations allowed?  The only reasonable answer seems to be (long unsigned int)*, or as we say "pointer to 
;unsigned long data".

;Clarification of term: In the description of how this program works you will find strings such as "current position of rsp".  That 
;means the position of rsp at the time this subprogram, viewmemory, was called.  The reader of software like this one should be 
;aware of this subtle distinction.

extern printf

global viewmemory                                           ;This declaration allows the subprogram to be called from outside this file.

segment .data                                               ;This segment declares initialized data

stackheadformat db "Stack Dump # %d: ", 
                db "rbp = %016lx rsp = %016lx", 10, 
                db "Offset    Address           Value", 10, 0

stacklineformat db "%+5d  %016lx  %016lx", 10, 0

segment .bss                                                ;This segment declares uninitialized data
    ;This segment is empty

segment .text                                               ;Executable instructions appear in this segment

viewmemory:                                                 ;Where execution begins when this program is called.

;===== Backup all the registers that are used in this program =====================================================================
push rbp                                                    ;Backup the base pointer
mov  rbp,rsp                                                ;Advance the base pointer to start of the current stack frame
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
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags
;rax, rip, and rsp are intentionally not backed up.  r15 is not used explicitly in this program, but it is backed up nevertheless.

;===== Prepare to output the dump stack header =====================================================================================
;At this time the integer stack has the following structure
;              |---------------------------|
;     rsp+20*8 | variable in caller        | = 5th variable declared in caller
;              |---------------------------|
;     rsp+19*8 | variable in caller        | = 4th variable declared in caller
;              |---------------------------|
;     rsp+18*8 | variable in caller        | = 3rd variable declared in caller
;              |---------------------------|
;     rsp+17*8 | variable in caller        | = 2nd variable declared in caller
;              |---------------------------|
;     rsp+16*8 | variable in caller        | = 1st variable declared in caller
;              |---------------------------|
;     rsp+15*8 | return address            | = the stack pointer was here immediately before execution was handed off to the called program
;              |---------------------------|
;     rsp+14*8 | rbp                       | = base pointer of caller program pushed by this x86 module
;              |---------------------------|
;     rsp+13*8 | rdi                       | = arbitrary number passed in from caller module
;              |---------------------------|
;     rsp+12*8 | rsi                       | = number of quadwords outside of stack
;              |---------------------------|
;     rsp+11*8 | rdx                       | = number of quadwords inside of stack not counting the top qword
;              |---------------------------|
;     rsp+10*8 | rcx                       | = zero-point = location in memory where the display of memory will be centered
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
;     rsp+1*8  | rbx                       |
;              |---------------------------|
;     rsp+0    | rflags                    |
;              |---------------------------|

;Observation: the distance in bytes from the current position of rsp and the location of "return address" is 15*8 = 120 bytes.
;This number, 120, will be needed further down in this program.


;===== Output the header prior to displaying the contents of memory =======================================================================
;Assign values to be passed to printf for outputting the dump stack header

mov rdi, stackheadformat                              ;The format of the header
mov qword rsi, [rsp+13*8]                                   ;Arbitrary number passed in from caller
mov qword rdx, [rsp+14*8]                                   ;Base pointer of the stack frame of this x86 module
mov rcx,rsp                                                 ;Copy the current value of rsp into rcx
add rcx,120                                                 ;rcx hold the pointer to the top of stack at the time this x86 module was called
mov qword rax, 0                                            ;Zero in rax signals to printf that no vector registers (xmm) are used.
call printf


;===== Set up conditions before entering a loop ===========================================================================================
;Retrieve from the stack the number of qwords within the stack to be displayed
mov qword r13, [rsp+11*8]                                   ;r13 will serve as loop counter variable
;Retrieve from the stack the number of qwords outside the stack to be displayed
mov qword r14, [rsp+12*8]                                   ;r14 will help define the loop termination condition
neg r14                                                     ;Negate r14.  Now r14 contains a negative or zero integer


;Setup rbx as offset number that will appear in the first column of output.
mov qword rax, [rsp+11*8]                                   ;Retrieve from the stack the number of qwords within the stack to be displayed.
mov qword r12, 8                                            ;Temporarily store 8 in r12
mul r12                                                     ;Multiply rax by 8 bytes per qword: assume product does not overflow into rdx
mov qword rbx, rax                                          ;Save the product in rbx (column 1 of output)

;Setup r12 as the address that will appear in the second column of output
mov qword r12,[rsp+10*8]   ;correct to here                                 ;Copy the new zero point to r1245
mov rax,8                                                   ;8 = number of bytes in a qword
mul r13                                                     ;rdx:rax will hold number of bytes with addresses less than r12 to be outputted.
add r12,rax                                                 ;Add number of bytes of data inside of stack to be outputted; assume rdx is zero


beginloop: ;===== The top of the loop is here ============================================================================================

;===== Prepare to output one line of the body of the stack dump ===========================================================================
;Follow the CCC-64 protocol
mov rdi, stacklineformat                                    ;Format for offset, address, and quadword value
mov qword rsi, rbx                                          ;rbx stores the offset value (column 1 of the output)
mov qword rdx, r12                                          ;r12 stores the address to be displayed (column 2 of the output)
mov qword rcx, [rdx]                                        ;rcx receives the contents of memory at the address to be displayed
mov qword rax, 0                                            ;No vector registers contain data for printf
call printf


;===== Advance the variables 8 bytes in the direction of small addresses ==================================================================
sub rbx, 8                                                  ;rbx stores column 1, which is the offset value
sub r12, 8                                                  ;r12 stores column 2, which is the address value
dec r13                                                     ;r13 is loop counter; it decrements from high value to low (possibly negative) value


;===== Check for loop termination condition ===============================================================================================
cmp r13, r14                                                ;Compare loop variable r13 with terminating value r14
jge beginloop                                               ;If r13 >= r14 then continue to iterate


;===== Restore original values to integer registers =======================================================================================
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

;Now the number of pushes equals the number of pops.
;
;Pick a number to send back to the calling program.  We will send the address in heap space where is located the next instruction for the caller.
;That means we send back the value on the top of the stack.
mov rax,[rsp]

;It is time to leave this program.  The value on top of the stack is the address of the next instruction to execute.
ret                                                         ;Pop the qword on top of the stack into rip

;End of viewmemory
