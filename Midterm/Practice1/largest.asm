extern printf
extern input_array

global largest

section .data
    welcome db "These are words so I can see whats up", 10, 0
    string db "%s", 0
    number db "%d", 0

section .bss
    array: resq 100

section .text

largest:

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
push rax                           ; Extra push to create even number of pushes
push rax

;14.  Make an asm function “largest” that will find the largest value in the array 
;and return that number to the caller.  The prototype is   long  largest(long arr[ ], long count);
mov rax, 0 
mov rdi, string
mov rsi, welcome
call printf

;push qword -1
mov rax, 0
mov rdi, array
call input_array
mov r12, rax            ; number of elements input into array
pop r8

mov rax, 0 
mov rdi, number
mov rsi, r12
call printf

mov r13, 0              ; counter to iterate through array
mov r14, [array]        ; largest

beginloop:

cmp r13, r12
jge endloop

cmp r14, [array + r13 * 8]                        ; compare largest value to next index
jl newlargest

inc r13

jmp beginloop

newlargest:
mov r14, [array + r13 * 8]
inc r13
jmp beginloop

endloop:

; Restores all registers to their original state.
                               ; Remove extra push of -1 from stack.

pop rax
mov rax, r14                   ; Copies Largest number in array (r13) to rax.
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