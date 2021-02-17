;Author: Floyd Holliday
;Library program name: Get Processor Frequency
;Purpose: Extract the CPU max speed from the processor

;Prototype:  double getfreq()

;Translation: nasm -f elf64 -o freq.o getfrequency.asm

global getfreq

extern atof

segment .data
segment .bss

segment .text
getfreq:

;Back up all GPRs: to be inserted later
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

;Extract data from processor in the form of two 4-byte strings
mov rax, 0x0000000080000004
cpuid
;answer in ebx:eax as big endian string
mov       r15, rbx      ;Second part of string saved in r15
mov       r14, rax      ;First part of string saved in r14

;Catenate the two short strings into one 8-byte string in big endian
and r15, 0x00000000000000FF    ;Convert non-numeric chars to nulls
shl r15, 32
or r15, r14                    ;Combined string is in r15

;Convert string to quadword numeric double.
push r15
mov rax,1
mov rdi,rsp
call atof          ;The number is now in xmm0
movsd xmm11, xmm0
pop rax

;Restore the values of all GPRs: to be inserted later
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
