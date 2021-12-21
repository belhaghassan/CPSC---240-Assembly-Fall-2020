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


;Extract data from processor in the form of two 4-byte strings
mov rax, 0x0000000080000004
cpuid
;Answer is in ebx:eax as big endian strings
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
pop rax


;Restore the values of all GPRs: to be inserted later

ret
