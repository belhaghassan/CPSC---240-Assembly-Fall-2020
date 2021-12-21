extern printf
global output_array                 ; Capacity limit for number of elements allowed in array.

section .data
    number db "%ld ", 0

section .bss       ; Uninitialized array with 100 reserved qwords.
    
section .text
    

output_array:

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

push qword -1                           ; Extra push to create even number of pushes

;-----------------------------INITIALIZE PARAMETERS-----------------------------------------
mov qword r14, rdi                        ; Reserve register for number of elements in array.
mov qword r13, rsi                        ; Reserve register for largest number in array.

mov qword r12, 0                        ; counter
beginloop:

cmp r12, r13
jge endloop

mov rax, 0
mov rdi, number
mov rsi, [r14 + r12 * 8]
call printf

inc r12

jmp beginloop

endloop:
;-----------------------------END OF FILE-----------------------------------------------

; Restores all registers to their original state.
pop rax                                  ; Remove extra push of -1 from stack.

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
