;Author name: Floyd Holliday
;Author email: holliday@fullerton.edu

;Program name: Exponential Expressions
;Programming languages: C++ (driver), X86 (algorithm)
;Date program began: February 14, 2013
;Date completed: February 22, 2013
;Date of upgraded comments: March 2, 2019
;Files in this program: exponential-expressions-driver.cpp, exponential-expressions.asm, r.sh
;Status: Done.  No more work will be done on this program apart from fixing any reported errors.
;Purpose: Accept as inputs a significand s and an exponent e.  The output the exponential expression s x 2^e in standard decimal
;format.   
;Comment: The outcome is mildly interesting when the exponent e is large.  In fact, a sufficiently value for e will cause the
;expression to evaluate as infinity.  More interesting are the outcomes when e is negative and large in magnitude.  The output will 
;show how extremely close to 0.0 are numbers with small negative exponents.

;Technical comment: This program uses the 80-bit registers in the FPU for evaluation of the exponential expression.
;The technical specifications for 80-bit floating point numbers are as follows:
;   Total storage for a floating point number = 80 bits, which is sometimes called a tword whereas qword is used for 64-bit registers.
;   Storage for exponent = 15 bits
;   Storage for significant = 64 bits
;   Base number = -16382
;   Bias number = +16383
;   Smallest positive normal number = 2^(-16382)
;   Positive Infinity = 2^16383

;This file name: exponential-expressions.asm
;This file language: X86
;This file syntax: Intex
;Prototype: extern "C" long int exponentialnumbers();
;This function can be called from any of the 3 languages we study: C or C++ or X86.
;Parameters passed in: none
;Parameter passed out: one long int designated as code number

;Assemble: nasm -f elf64 -l exponential-expressions.lis -o exponential-expressions.o exponential-expressions.asm
;
;Technical background: The world standard for numbers, IEEE 754, there are five categories of numbers: 
;   zero (this category contains exactly two numbers: plus and minus 0.0)
;   denormal numbers (these numbers are very close to zero)
;   normal numbers (these are the usual numbers encountered in most programming applications)
;   infinity (this category contains exactly two numbers: plus infinity and minus infinity)
;   nans (these are not considered to be real numbers; in absolute value they are beyond infinity)
;
;
;
;===== Begin code area =====================================================================================================================
extern printf                                               ;External C++ function for writing to standard output device
extern scanf                                                ;External C++ function for reading from the standard input device, usually the keyboard.
global exponentialnumbers                                   ;Allow this module to be called by modules outside of this file

segment .data                                               ;Place initialized data here

welcome db "This program program will display fp numbers of extreme types such as denormal, infinity, and nans as well as ordinary normals and zeros.", 10, 0
description db "FP numbers can be expressed as {significand} x 2 ^ {exponent} where {significand} is a decimal based fp number", 10,
            db "and {significand} is an integer positive or negative or zero.", 10, 10, 0
classification db "How to classify your inputted number:", 10
               db "The first 4 hex digits of the expression are the biased exponent -- designated here as BE", 10
               db "       BE      Classification", 10
               db "      0000     Positive (zero or denormal) number", 10
               db "      8000     Negative (zero or denormal) number", 10
               db "      7fff     Positive (infinity or nan)", 10
               db "      ffff     Negative (infinity or nan)", 10
               db "None of above: Normal number", 10, 10,0

promptforsignificand db "Enter the significand as a decimal floating point number: ", 0
promptforexponent db "Enter the exponent as a integer (positive, negative, or zero): ", 0
numberdescription db "The number you entered is %20.20Lf x 2^", 0
decimaldescription db "The same number in base 10 is the following:", 10, 0

equals db " = ", 0
newline db 10, 0
goodbye db "The calculation is finished.  This X86 program will return to the caller.  Goodbye.", 10, 0

formatstringdata db "%s", 0
formatlongfloatinput db "%Lf", 0                            ;Be sure to use upper case 'L'
formatlongfloatoutput db "%20.16Lf", 10, 10, 0
formatlongfloatoutput4955 db "%1.4955Lf (4955 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput4940 db "%1.4940Lf (4940 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput4550 db "%1.4550Lf (4550 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput3200 db "%1.3200Lf (3200 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput2400 db "%1.2400Lf (2400 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput1600 db "%1.1600Lf (1600 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput800  db "%1.800Lf (800 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput70   db "%1.70Lf (70 digits displayed right of decimal point)", 10, 10, 0
formatlongfloatoutput32   db "%1.32Lf (32 digits displayed right of decimal point)", 10, 10, 0

formatlongint db "%ld", 0

formatstring2bytes db "0x%04x", 0
formatstring8bytes db "%016lx", 10, 10, 0

segment .bss                                                ;Place un-initialized data here.

          ;Currently this segment is empty

segment .text                                               ;Place executable instructions in this segment.
exponentialnumbers:                                         ;Entry point.  Execution begins here.

;=========== Back up the base pointer =====================================================================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp

;=========== Save registers ===============================================================================================================

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

;=========== Show the welcome message =====================================================================================================

mov qword  rax, 0                                           ;Zero is required
mov        rdi, formatstringdata                            ;Prepare printf for string output
mov        rsi, welcome                                     ;Place starting address of output text into rsi
call       printf                                           ;Display the message

;=========== Describe the planned actions of this program =================================================================================

mov qword  rax, 0                                           ;Zero is required
mov        rdi, formatstringdata                            ;Prepare printf for string output
mov        rsi, description                                 ;Place starting address of output text into rsi
call       printf                                           ;Display the message

;ok to here

;========== Initialize the FPU ============================================================================================================

finit                                                       ;Reset pointers to st registers; reset control word, status word, and tag word.

;========== Request input of the significand ==============================================================================================

mov qword  rax, 0                                           ;Zero is required
mov        rdi, formatstringdata                            ;Set the format for text ouput
mov        rsi, promptforsignificand                        ;Provide printf with the text to output
call       printf                                           ;Display prompt for input of a single fp number

;========== Input the significand from KB into integer stack ==============================================================================

;ok to here.

mov qword  rax, 0                                           ;Zero is required
mov        rdi, formatlongfloatinput                        ;Tell scanf that it will input a long float.
push qword 0                                                ;Reserve space on the integer stack for the incoming fp number.
push qword 0                                                ;At least 10 bytes are needed, but 16 bytes are allocated for the incoming
                                                            ;number, and thus 16-byte boundaries are maintained.
mov        rsi, rsp                                         ;rsi now points to the available storage
call       scanf                                            ;The second parameter of scanf is a pass-by-reference parameter; therefore, 
                                                            ;rsi points to the location where the incoming efp number will be stored.

;ok to here

;========== Copy the inputted number to the FPU ===========================================================================================

fld tword  [rsp]                                            ;Load (that is, push) the new FP number into the next FP register: st0.

;========== Request input of the exponent =================================================================================================

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstringdata                            ;First parameter rdi receives the format specifier for string data
mov        rsi, promptforexponent                           ;Second parameter rsi receives the starting address of the string
call       printf

;ok to here

;=========== Input the exponent from KB into integer stack ================================================================================

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatlongint                               ;First parameter rdi receives the format specifier for 64 bit integer
push qword 0                                                ;Create 8 bytes of space for the incoming long integer
push qword 0
mov        rsi, rsp                                         ;Second paramter rsi points to the available 8 bytes of storage
call       scanf

;========== Save a copy of the exponent in an integer type register =======================================================================

pop        r15                                              ;The (true) exponent is now in r15 as well as in [rsp]

;========== Clean up the integer stack ====================================================================================================

pop        rax                                              ;Reverse the extra push used in the previous call to scanf
pop        rax                                              ;Pop the right side 8 bytes of the significand
pop        rax                                              ;Pop the left side 8 bytes of the significand

;=========== Output the number in exponential notation ====================================================================================
;Presently, the significand is in st0.  In order to print that number it must be copied to memory.  That operation is performed first

push qword 0                                                ;Push 8 bytes for partial storage of the value in st0
push qword 0                                                ;Push 8 more bytes the rest of the storage of the value in st0
fstp tword [rsp]                                            ;Pop the 10-byte number from the fp stack to the integer stack.

;Footnote: The instruction that is really needed here is: fst tword [rsp].  However, NASM rejects that instruction.  There for the work-
;around is used here: pop the number completely from the fp stack, place it into the 10 bytes at the top of the integer stack, output 
;the value, and return that value back to st0 of the fp stack.  That's an ugly way to accomplish the goal, but there is no alternative.

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, numberdescription                           ;First parameter contains the address of the specifier string
mov        rsi, rsp                                         ;rsi points to significand to be outputted as part of the string
call       printf

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatlongint                               ;rdi points to start of specifier for long integers (64 bit integers).
mov        rsi, r15                                         ;rsi contain the true integer to be displayed
call       printf

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstringdata                            ;First parameter receives the starting address of a string specifier
mov        rsi, equals                                      ;Second parameter receives the starting address of the string
call       printf

;=========== Load the exponent and the significand onto the fp stack in that order ========================================================

push       r15                                              ;Push a copy of the exponent into 8 bytes of integer stack

fild qword [rsp]                                            ;Copy and convert to float 8 bytes from the integer stack, ie, the exponent

pop        rax                                              ;Remove the exponent from top of the integer stack

fld tword  [rsp]                                            ;Load the significant from integer stack onto the fp stack
                                                            ;st1=exponent; st0=significand
;Clean up the integer stack.
pop        rax                                              ;Reverse the last push of 8 bytes
pop        rax                                              ;Reverse the first push of 8 bytes

;============ Multiply the significant (in st0) by 2 raised to the exponent (in st1) ======================================================
;Note that a programmer could set up a loop to repeatedly multiply (or divide) the significand by 2.  However, that complex operation is 
;not necessary in light of the fact that there is a built-in instruction that does exactly that, namely: fscale.  The instruction fscale
;multiplies st0 by 2 ^ st1 and leaves the result in st0.

fscale                                                      ;Fast instruction: faster than looping

;Now the final number is in st0.

;========== Show the number in st0 in hex =================================================================================================
;Again: take the number out of the fp stack and move it to the integer stack.  Then the number will be displayed using 2 printf 
;instructions.

push qword 0                                                ;Create 8 bytes of storage for the efp number
push qword 0                                                ;Create 8 more bytes of storage for the same number
fstp tword [rsp]                                            ;Pop the fp stack placing the number in the storage previously created.
mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstring2bytes                          ;Specify that exactly 4 hex digits will be displayed
mov        rsi, [rsp+8]                                     ;Second parameter receives address of 6 bytes of leading zeros followed by 2 bytes of valid data
call       printf

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstring8bytes                          ;Specify that exactly 16 hex digits will be displayed
mov        rsi, [rsp]                                       ;Second paramter receives address of the trailing 8 bytes to be displayed
call       printf

;After printing in hex the fp number remains on top of the integer stack.  Keep it there for future use.

;========== Show the decimal message ==============================================================================================

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstringdata                            ;First parameter is told that the data to be displayed is string type
mov        rsi, decimaldescription                          ;Second paramter knows the actual data to be displayed.
call       printf

;========== Output the number in st0 in decimal format with many significant digits ==============================================

;Next decide how many decimal digits on the right of the decimal point should be displayed.  The answer will depend on value of 
;the true exponent: the small the true exponent the more digits must be displayed.

mov        rdi, formatlongfloatoutput                       ;Default value

;Begin case statement
lessthanorequaltonegative16383:                             ;Case where  - ∞ < true exponent <= -16383
    cmp    r15, -16383
    jg     greaterthannegative16383
    mov    rdi, formatlongfloatoutput4955
    jmp    printdecimal

greaterthannegative16383:                                   ;Case where  -16383 < true exponent <= -15000
    cmp    r15, -15000
    jg     greaterthannegative15000
    mov    rdi, formatlongfloatoutput4940
    jmp    printdecimal

greaterthannegative15000:                                   ;Case where   -15000 < true exponent <= -10000
    cmp    r15, -10000
    jg     greaterthannegative10000
    mov    rdi, formatlongfloatoutput4550
    jmp    printdecimal

greaterthannegative10000:                                   ;Case where     -10000 < true exponent <= -7500
    cmp    r15, -7500
    jg     greaterthannegative7500
    mov    rdi, formatlongfloatoutput3200
    jmp    printdecimal

greaterthannegative7500:                                    ;Case where     -7500 < true exponent <= -5000
    cmp    r15, -5000
    jg     greaterthannegative5000
    mov    rdi, formatlongfloatoutput2400
    jmp    printdecimal

greaterthannegative5000:                                    ;Case where     -5000 < true exponent <= -2500
    cmp    r15, -2500
    jg     greaterthannegative2500
    mov    rdi, formatlongfloatoutput1600
    jmp    printdecimal

greaterthannegative2500:                                    ;Case where     -2500 < true exponent <= -1000
    cmp    r15, -1000
    jg     greaterthannegative1000
    mov    rdi, formatlongfloatoutput800
    jmp    printdecimal

greaterthannegative1000:                                    ;Case where     -1000 < true exponent <= -100
    cmp    r15, -100
    jg     greaterthannegative100
    mov    rdi, formatlongfloatoutput70
    jmp    printdecimal

greaterthannegative100:                                     ;Case where     -100 < true exponent <= 0
    cmp    r15, 0
    jg     positive
    mov    rdi, formatlongfloatoutput32
    jmp    printdecimal

positive:                                                   ;Case where       0 < true exponent 
    mov    rdi, formatlongfloatoutput
    jmp    printdecimal

;End of case statement

printdecimal:                                               ;After the case statement print the number in base 10
mov qword  rax, 0                                           ;Zero in rax is required
mov        rsi, rsp                                         ;rsi points to the number
call       printf

;Clean up the integer stack
pop        rax                                              ;Reverse a previous push qword 0
pop        rax                                              ;Reverse the other previous push qword 0.

;========== Show short message how to classify numbers ==============================================================================

mov qword  rax, 0                                           ;Zero in rax is required
mov        rdi, formatstringdata                            ;rdi receives the specifier for string data
mov        rsi, classification                              ;rsi receives the string to be printed
call       printf

;============ Prepare an exit message ===============================================================================================

mov qword  rax, 0                                           ;Zero is required
mov        rdi, formatstringdata                            ;Prepare printf for string output
mov        rsi, goodbye                                     ;Pass message to printf for outputting
call       printf                                           ;Show exit message
;
;============ Restore all registers =================================================================================================
;Backing up and restoring registers is a good programming practice.

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
;
mov qword rax, 0                                            ;Return 0 to the caller.  0 indicates successful termination.
ret                                                         ;ret pops the stack taking away 8 bytes.
;===== End of extendednumbers subprogram ============================================================================================




