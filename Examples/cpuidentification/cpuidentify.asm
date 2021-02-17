;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu or activeprofessor@yahoo.com
;  Author location: Fullerton, California
;Course information
;  Course number: CPSC240
;  Assignment number: 8
;  Due date: 2014-Aug-25
;Project information
;  Project title: CPU Identification
;  Purpose: Extract information about the microprocessor in this computer.
;  Status: No known errors
;  Project files: cpuidentification.c, cpuidentify.asm
;  Background: Intel programmers created a 32-bit version of the CPU Identification suite.  This program is a new rewrite of that early
;  software to run on 64-bit platforms.
;  Project references: Intel Processor Identification and the CPUID Instruction, Application Note 485, revised May 2012 (App-Note 485).
;Module information
;  This module's call name: processoridentification
;  Language: X86-64
;  Syntax: Intel
;  History: 2013-07-07 Begin development
;           2014-06-12 Header comments expanded
;           2014-12-18 Bitmap extraction added
;           2019-12-29 CPU frequency added
;  Purpose: This program will identify many properties of the processor in this computer.
;  File name: cpuidentify.asm
;  Status: In production.  No known errors.
;  Future enhancements: Add backup of state components by use of xsave.
;Translator information
;  Linux: nasm -f elf64 -l cpuidentify.lis -o cpuidentify.o cpuidentify.asm
;References and credits
;  Intel Processor Identification and the CPUID Instruction, Application Note 485, revised May 2012 (App-Note 485).
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;Permissions
;  The source code is free for use by members of the 240 programming course.  You should credit this source if you borrow executable statements from this program.  The
;  instructions are free to use, but the borrower must create his or her own comments.  The comments belong to the author.

;===== Begin area for source code ==========================================================================================================================================
;%include "debug.inc"                                       ;This statement makes the debugger available to this program.  However, the debugger is not currently in use.
                                                            ;Therefore, the statement is commented out.  The include is an example of an assembler directive.  Here the
                                                            ;assembler will insert the source code of the debugger.

extern printf                                               ;This function will be linked into the executable by the linker

global processoridentification                              ;Make this program callable by modules outside this file

segment .data                                               ;Place initialized data in this segment

welcome db "Welcome to CPUID verification", 10, 0
specifierforstringdata db "%s", 0
newline db 10, 0

purpose db "This program will first determine if the cpuid instruction is implemented in the present processor", 10, 0

initialrflags db "The initial value of rflags is %016lx", 10, 0
bit21 db "Bit #21 of rflags is  %01ld", 10, 0
modifiedrflags db "Now the value of rflags is %016lx", 10, 0

cpuidmessage db "Bit #21 has been successfully changed, and therefore the cpuid instruction is implemented on this machine.", 10, 10, 0
noncpuidmessage db "Since bit #21 remains unchanged the conclusion is that cpuid is not implemented in this processor.", 10, 0

statecomponentmessage db "The state component bit map of this processor is %1ld.", 10, 0
statecomponentexplanation db "A bitmap value from 4 through 7 indicates the AVX component (also known as 'State Component #2') is present.", 10,
                          db "A value less than 4 indicates the AVX component is absent.", 10, 10, 0

largestbasicdescription db "The largest basic function number implemented on this machine is %ld.", 10, 0
largestbasicconclusion db "Therefore, when extracting basic information, the input value must be in the range: "
                       db "0 ≤ input value ≤ %ld.", 10, 10, 0

largestextendeddescription db "The largest extended function number implemented on this machine is 0x%08x = %ld.", 10, 0
largestextendedconclusion db "Therefore, when extracting extended information, the input value must be in the range: "
                          db "0x80000000 ≤ input value ≤ 0x%08x.", 10, 10, 0

vendoridstring db "The Vendor ID of the CPU in this computer is %s", 0

extendedfamilynumber db "Extended family number: %ld", 10, 0
extendedmodelnumber db "Extended model number: %ld", 10, 0
processortypenumber db "Processor type number: %ld", 10, 0
processorfamilynumber db "Processor family number: %ld", 10, 0
processormodelnumber db "Processor model number: %ld", 10, 0
processorsteppingidnumber db "Processor stepping ID number: %ld",
                          db ", which is also known as the processor revision number.", 10, 0

initialprocessorbrandstring db "The Processor Brand of this cpu is ", 0
brandstringunsupported db "The processor Brand String is not supported in this cpu.", 10, 0

brandidformat db "The brand id number of the CPU in this computer is %ld.", 10, 0
processorsignatureformat db "The processor signature of the CPU in this computer is %lx", 10
                         db "The processor signature has the following components:", 10, 0

brandidnumber db "The brand id number of the CPU in this computer is %ld.", 10, 0

cacheformat db "The L2 cache in this computer has size %ld kiB.", 10, 0


noserialnumbermessage db "Extraction of the serial number is not implemented in this cpu.", 10 ,0
serialnumberinitial db "The serial number of the CPU is %08ld", 0
serialnumbermiddle db "%08ld", 0
serialnumberlast db "%08ld", 10, 0

cpufrequency db "The minimum cpu frequency of all cores in this processor is %ldMHz and the maximum frequency is %ldMHz.",10,0
cpufrequencynotsupported db "Extraction of minimum and maximum cpu frequencies is not supported by this processor.",10,0

stringformat db "%s", 0
stringformatwithnewline db "%s.", 10, 0

xsavenotsupported.notsupportedmessage db "The xsave instruction is not supported in this microprocessor.", 10
                                      db "However, processing will continue without backing up state component data", 10, 0

xsavenotsupported.stringformat db "%s", 0

segment .bss                                                ;Place uninitialized data in this segment

align 64                                                    ;Ask that the next data declaration start on a 64-byte boundary.
backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

segment .text                                               ;Place executable statements in this segment

processoridentification:                                    ;Entry point: execution will begin here.

;=========== Back up all the GPR registers except rax, rsp, and rip =======================================================================================================

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
;==========================================================================================================================================================================

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
xsave      [backuparea]                                     ;All the data of state components managed by xsave have been written to backuparea.

push qword -1                                               ;Set a flag (-1 = true) to indicate that state component data were backed up.
jmp        startapplication

;========== Show message xsave is not supported on this platform ==========================================================================================================
xsavenotsupported:

mov        rax, 0
mov        rdi, .stringformat
mov        rsi, .notsupportedmessage                        ;"The xsave instruction is not supported in this microprocessor.
call       printf

push qword 0                                                ;Set a flag (0 = false) to indicate that state component data were not backed up.

;==========================================================================================================================================================================
;===== End of State Component Backup ======================================================================================================================================
;==========================================================================================================================================================================


;==========================================================================================================================================================================
startapplication: ;===== Begin the application here: Identify the CPU =====================================================================================================
;==========================================================================================================================================================================

;===== Show the welcome message followed by the purpose message ===========================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, specifierforstringdata                       ;"%s"
mov       rsi, welcome                                      ;"Welcome to CPUID verification"
call      printf                                            ;Use external function to handle the output

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, specifierforstringdata                       ;"%s"
mov       rsi, purpose                                      ;"This program will determine if the cpuid instruction is correctly ..."
call      printf                                            ;Use external function to handle the output

;===== Show the initial value of rflags ===================================================================================================================================

mov       r15, [rsp+8]                                      ;Place a working copy of rflags in the state when this module began execution.  rflags is subject to change by
                                                            ;later instructions, and therefore, the original value of rflags is copied to r15.
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, initialrflags                                ;"%016lx"
mov       rsi, r15                                          ;Original value from rflags will be printed
call      printf                                            ;Use external function to handle the output

;===== Isolate bit #21 ====================================================================================================================================================
push      r15                                               ;Save a copy of the original rflags
mov       r14, r15                                          ;r14 holds the original data from rflags
shr       r14, 21                                           ;Eliminate 21 bits on the right of bit #21, which is now in position 0
and       r14, 1                                            ;Set all bits #79 thru 1 to zero.  Bit #0 remains unchanged.

;===== Show bit #21 =======================================================================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, bit21                                        ;"%01ld"
mov       rsi, r14                                          ;Bit #21 (now in position #0) is passed to the printf function
call      printf                                            ;Use external function to handle the output

;===== Replace bit #21 with its logical complement ========================================================================================================================

xor       r15, 0x0000000000200000                           ;By properties of xor bit #21 has been complemented; other bits remain unchanged.
push      r15                                               ;Push the new data for rflags on the stack in order to copy that data to rflags
popf                                                        ;Now rflags has the same data as before except bit #23 has flipped

;===== Show the data in rflags to verify visually any changes in bit #21 ==================================================================================================

pushf                                                       ;Copy the current data of rflags to the stack
pop       r15                                               ;Copy the current data of rflags to r15
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, modifiedrflags                               ;"%016lx"
mov       rsi, r15                                          ;Data from the current value of rflags will be outputted
call      printf                                            ;Use external function to handle the output

;===== Output the conclusion ===============================================================================================================================================
;r15 holds the modified data of rflags
pop       r14                                               ;r14 holds the original data of rflags
cmp       r14, r15                                          ;Compare the original rflags with the modified rflags
je        notimplemented                                    ;if r14==r15 execute at entry notimplemented

;if r14 /= r15 then continue directly below; no jump instruction is needed.

;===== Show message cpuid is implemented ==================================================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers       
mov       rdi, specifierforstringdata                       ;"%s"
mov       rsi, cpuidmessage                                 ;"Bit #21 has been successfully changed, .... "
call      printf                                            ;Use external function to handle the output

jmp       showbitmap                                        ;Execute at entry showbitmap

;===== Show message cpuid is not implemented ==============================================================================================================================
notimplemented:                                             ;An entry point for a jump instruction

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, specifierforstringdata                       ;"%s"
mov       rsi, noncpuidmessage                              ;The cpuid instruction is not implemented
call      printf                                            ;Use external function to handle the output

jmp       preparetoexit

showbitmap: ;===== Extract and display the bitmap for this processor ======================================================================================================
;Preconditions before calling cpuid
mov        rax, 0x000000000000000d                          ;13 is an input value required for extracting the bitmap
mov        rcx, 0                                           ;0 selects subfunction number 0 of cpuid
cpuid
;Postconditions after calling cpuid: the bitmap is in edx:eax.  We discard edx because all the relevant data are in eax.
mov        r15, 0x00000000ffffffff                          ;r15 is used for temporary storage for the next instruction.
and        rax, r15                                         ;Insure that the upper half of rax is entirely zero.
;rax holds the bitmap

;Display the bitmap, which is simply a positive integer.
mov        rdi, statecomponentmessage                       ;"The state component bit map of this processor is %1ld"
mov        rsi, rax                                         ;The bitmap is in the second standard parameter for passing to printf
mov        rax, 0                                           ;This informs printf that no data from SSE or AVX will be outputted.
call       printf                                           ;Use a function from the C-library to format the output.

;Display an explanation about the bitmap.
mov        rdi, stringformat                                ;"%s"
mov        rsi, statecomponentexplanation                   ;"A bitmap value from 4 through 7 indicates the AVX component (also known as 'State Component #2') is present."
mov        rax, 0                                           ;This informs printf that no data from SSE or AVX will be outputted.
call       printf                                           ;Use a function from the C-library to format the output.

;===== Find the largest input number allowed for basic information by cpuid ================================================================================================

mov qword rax, 0                                            ;Zero is the input to the cpuid function
cpuid                                                       ;Call the function and the return value will be in rax
mov       r15, rax                                          ;Store the largest basic function number in r15 for safekeeping.

;===== Show the largest basic function number used by cpuid ================================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, largestbasicdescription                      ;"Largest basic function number ..."
mov       rsi, r15                                          ;Place the largest basic function number in the 2nd passing parameter
call      printf                                            ;Use external function to handle the output

;===== Display the conclusion regarding input values for extracting basic information =====================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, largestbasicconclusion                       ;"Therefore, when extracting basic information the input value must be ... "
mov       rsi, r15                                          ;Place the largest basic function number in the 2nd passing parameter
call      printf                                            ;Use external function to handle the output

;===== Show the largest extended function number used by cpuid ============================================================================================================

mov       rax, 0x0000000080000000                           ;Ref: Section 5.2 of App-Note 485.
cpuid                                                       ;This instruction will extract the largest extended function number.
mov       r15, rax                                          ;Copy the largest extended input function number to a stable place.

;===== Show the largest extended function number used by cpuid ============================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, largestextendeddescription
mov       rsi, r15                                          ;Copy the largest extended input value to the second passing parameter
mov       rdx, r15                                          ;Copy the largest extended input value to the third passing parameter
call      printf                                            ;Use external function to handle the output

;===== Display the conclusion regarding input values for extracting basic information =====================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, largestextendedconclusion                    ;"Therefore, when extracting extended information, the input value must be ..."
mov       rsi, r15                                          ;Place the largest extended input function number in the 2nd passing parameter
call      printf                                            ;Use external function to handle the output

;===== Obtain and show the vendor ID string ===============================================================================================================================

mov qword rbx, 0                                            ;Zero out this register before cpuid writes to it
mov qword rcx, 0                                            ;Zero out this register before cpuid writes to it
mov qword rdx, 0                                            ;Zero out this register before cpuid writes to it

mov qword rax, 0                                            ;Zero is the input to the cpuid function
cpuid                                                       ;Call the function and the return value will be in rax

push      rcx                                               ;Save the last 4 bytes of the Vendor ID
push      rdx                                               ;Save the middle 4 bytes of the Vendor ID
push      rbx                                               ;Save the first 4 bytes of the Vendor ID

;The vendor ID string is in registers rbx, rdx, rcx -- 4 bytes of string in each register using little Endian format
;However, the three registers were pushed onto the integer stack where they are now.  By the nature of a stack the
;little Endian format has been converted to Big Endian format.  All that remains to do is to output the three substrings in 
;succession, and the Vendor ID will be outputted.

;Visual representation of the stack:
;      top+16-->|    UPCl|
;      top+8 -->|    etnI|
;      top ---->|    laeR|
;               ----------
;Note that each substring is null terminated by 4 bytes of null character in the most significant half of each 8-byte string.

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, vendoridstring                               ;"The Vendor ID of the CPU in this computer is %s"
mov       rsi, rsp
call      printf
pop       rbx                                               ;Now the top of stack points to the start of the second 4-byte string.

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp
call      printf
pop       rdx                                               ;Now the top of stack points to the start of the third 4-byte string.

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformatwithnewline                      ;"%s", 10, 0
mov       rsi, rsp
call      printf
pop       rcx                                               ;Now the top of stack has returned to its state before Vendor ID was extracted.

;===== Extract feature information about this cpu =========================================================================================================================
;Ref: App-Note 485, section 5.1.2

mov       rax, 1                                            ;One is the input to the cpuid function
cpuid                                                       ;Call the function and the return value will be in rax, rbx, rcx, rdx

;Processor feature information has been returned in rax, rbx, rcx, and rdx.  However, this program uses only the information from rax.
mov       r15, rax                                          ;Copy feature information to r15 for safekeeping.

;===== Extract and show the processor signature ===========================================================================================================================

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, processorsignatureformat                     ;"The processor signature of the CPU in this computer is %016lx ... "
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
call      printf                                            ;Use external function to handle the output

;Output the extended family number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, extendedfamilynumber                         ;"Extended family number: %ld"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x0000000007f80000                           ;Mask bits 27:20
shr       rsi, 19                                           ;Move the feature number to least significant bits of rsi
call      printf                                            ;Use external function to handle the output

;Output the extended model number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, extendedmodelnumber                          ;"Extended model number: %ld"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x0000000000070000                           ;Mask bits 19:16
shr       rsi, 16                                           ;Move the feature number to least significant bits of rsi
call      printf                                            ;Use external function to handle the output

;Output the processor type number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, processortypenumber                          ;"Processor type number: %ld"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x0000000000003000                           ;Mask bits 13:12
shr       rsi, 12                                           ;Move the feature number to least significant bits of rsi
call      printf                                            ;Use external function to handle the output

;Output the processor family number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, processorfamilynumber                        ;"Processor family number: %ld"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x0000000000000f00                           ;Mask bits 11:8
shr       rsi, 8                                            ;Move the feature number to least significant bits of rsi
call      printf                                            ;Use external function to handle the output

;Output the model number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, processormodelnumber                         ;"Processor model number: %ld"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x00000000000000f0                           ;Mask bits 7:4
shr       rsi, 4                                            ;Move the feature number to least significant bits of rsi
call      printf                                            ;Use external function to handle the output

;Output the processor stepping ID number, which is also known as the revision number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, processorsteppingidnumber                    ;"Processor stepping ID number: %ld also known as processor revision number"
mov       rsi, r15                                          ;Place feature information in the 2nd passing parameter
and       rsi, 0x000000000000000f                           ;Mask bits 3:0
call      printf                                            ;Use external function to handle the output

;===== Determine if Brand String is supported in this processor ===========================================================================================================

mov       rax, 0x0000000080000000                           ;Intel App-Note 485 provides this input number
cpuid                                                       ;Call the function and the return value will be in rax
mov       r15, rax                                          ;Copy the return value to r15 for safekeeping
mov       rcx, 0x0000000080000004                           ;Intel App-Note 485 provides this number for comparison
cmp       r15, rcx                                          ;Is r15 ≥ rcx? Yes => supported; No => unsupported.
jge       brandstringsupported

;Show the following message if Brand String is not supported
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, brandstringunsupported                       ;"The processor Brand String is not supported in this cpu."
call      printf                                            ;Use external function to handle the output
jmp       L2cache

;===== Extract and show the Processor Brand string ========================================================================================================================
brandstringsupported:
;Ref: App-Note 485 Section 7.2.  The maximum length of the Brand string is 48 bytes of ascii.  The brand string is logically subdivided into 3 groups of 16 bytes per group.

;Obtain and display the first group of 16 bytes of the Brand string
mov        rax, 0x0000000080000002                          ;Intel provides this input number
cpuid                                                       ;The function will place return values in rdx, rcx, rbx, rax.

push      rdx                                               ;Save bytes #12-15 of the first 16 bytes of the Brand string
push      rcx                                               ;Save bytes #8-11 of the first 16 bytes of the Brand string
push      rbx                                               ;Save bytes #4-7 of the first 16 bytes of the Brand string
push      rax                                               ;Save bytes #0-3 of the first 16 bytes of the Brand string

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat
mov       rsi, initialprocessorbrandstring                  ;"The Processor Brand of this cpu is "
call      printf                                            ;Use external function to handle the output

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the first 4 bytes within the first group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rbx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the second 4 bytes within the first group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rbx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the third 4 bytes within the first group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rcx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the fourth 4 bytes within the first group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rdx

;Obtain and display the second group of 16 bytes of the Brand string
mov       rax, 0x0000000080000003                           ;Intel provides this input number
cpuid                                                       ;The function will place return values in rdx, rcx, rbx, rax.

push      rdx                                               ;Save bytes #12-15 of the second 16 bytes of the Brand string
push      rcx                                               ;Save bytes #8-11 of the second 16 bytes of the Brand string
push      rbx                                               ;Save bytes #4-7 of the second 16 bytes of the Brand string
push      rax                                               ;Save bytes #0-3 of the second 16 bytes of the Brand string

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat
mov       rsi, rsp                                          ;rsi points to the first 4 bytes within the second group of 16 bytes in the Brand string
call      printf                                            ;Use external function to handle the output
pop       rax

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the second 4 bytes within the second group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rbx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the third 4 bytes within the second group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rcx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the fourth 4 bytes within the second group of 16 bytes in the Brand string.
call      printf                                            ;Use external function to handle the output
pop       rdx

;Obtain and display the third group of 16 bytes of the Brand string
mov       rax, 0x0000000080000004                           ;Intel provides this input number
cpuid                                                       ;The function will place return values in rdx, rcx, rbx, rax.

push      rdx                                               ;Save bytes #12-15 of the third 16 bytes of the Brand string
push      rcx                                               ;Save bytes #8-11 of the third 16 bytes of the Brand string
push      rbx                                               ;Save bytes #4-7 of the third 16 bytes of the Brand string
push      rax                                               ;Save bytes #0-3 of the third 16 bytes of the Brand string

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the first 4 bytes within the third group of 16 bytes in the Brand string
call      printf
pop       rax

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat                                 ;"%s"
mov       rsi, rsp                                          ;rsi points to the second 4 bytes within the third group of 16 bytes in the Brand string
call      printf
pop       rbx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformat
mov       rsi, rsp                                          ;rsi points to the third 4 bytes within the third group of 16 bytes in the Brand string
call      printf
pop       rcx

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, stringformatwithnewline
mov       rsi, rsp                                          ;rsi points to the fourth 4 bytes within the third group of 16 bytes in the Brand string
call      printf
pop       rdx

;===== End of obtain and display the Brand string =========================================================================================================================

;===== Find the size of L2 cache in bytes =================================================================================================================================
L2cache:

mov qword rax, 0x0000000080000006                           ;This input value is provided by Intel as input for finding size of cache
mov qword rcx, 0                                            ;Remove old data from rcx
cpuid

;Postconditions: rcx[31:16] now holds the size in binary kilobytes (kiB) of L2 cache

shr       rcx, 16                                           ;Right justify the cache number
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, cacheformat                                  ;"The L2 cache in this computer has size %ld kiB."
mov       rsi, rcx                                          ;Copy the size of the L2 cache into the second passing parameter
call      printf                                            ;Use external function to handle the output

;===== Find the processor brand id ========================================================================================================================================
;This module is intended for those cpus that have not implemented the Brand String method of identification.  Using the processor
;signature number and the brand id number one can go to tables and find the same information as Brand String.  As a useful exercise
;this program computes processor signature number and brand id number for your general information.  Ref: App-Note 485, p. 17.

mov qword rbx, 0                                            ;Clear out previous noise in rbx.
mov qword rax, 1                                            ;1 is the input to the function cpuid
cpuid                                                       ;Postconditions: The Brand ID of the cpu is in rbx[7:0]
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, brandidformat                                ;"The brand id number of the CPU in this computer is %ld."
mov       rsi, rbx                                          ;Place a copy of the Brand ID into rsi
call      printf                                            ;Use external function to handle the output

;===== Obtain and display the serial number ===============================================================================================================================
;Chapter6

;Test if serial number support is implemented on this machine
mov       rax, 0x0000000000000001                           ;1 is the input value
cpuid                                                       ;Postconditions: rdx[18:18] == 1 determines support for serial number
and       rdx, 262144                                       ;Change all bits except bit #18 to zeros
;if rdx==0 then cpu serial number is not implemented on this computer.
cmp       rdx, 0
jne       obtainserialnumber
mov       rax, 0
mov       rdi, stringformat                                 ;"%s"
mov       rsi, noserialnumbermessage                        ;"Extraction of serial number is not implemented in this cup."
call      printf                                            ;Use external function to handle the output
jmp       extractfrequencies

obtainserialnumber:

mov       rax, 0x0000000000000001
cpuid                                                       ;rax holds the CPU signature, which is the first third of the serial number.
mov       r14, rax                                          ;Copy first third of the serial number to r14 for safekeeping.
mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, serialnumberinitial                          ;"The serial number of the CPU is %08ld"
mov       rsi, r14
call      printf                                            ;Use external function to handle the output

mov       rax, 0x0000000000000003
cpuid                                                       ;rax holds the CPU signature, which is the second third of the serial number.
mov       r14, rdx                                          ;Copy middle third of the serial number to r14 for safekeeping
mov       r15, rcx                                          ;Copy last third of the serial number to r15 for safekeeping

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, serialnumbermiddle                           ;"%08ld"
mov       rsi, r14                                          ;Copy the middle third of the serial number to the second passing parameter
call      printf                                            ;Use external function to handle the output

mov qword rax, 0                                            ;A zero in rax means printf accepts no data from xmm registers
mov       rdi, serialnumberlast                             ;"%08ld"
mov       rsi, r15                                          ;Copy the last third of the serial number to the second passing parameter
call      printf                                            ;Use external function to handle the output

;===== Obtain and display the CPU max and min frequencies ================================================================================================================

extractfrequencies:
mov rax,0x0000000000000016
cpuid
;The next 2 instruction are un-necessary.  The cpuid instruction will zero out the upper 48 bits of both registers.  The two instructions simply emphasize that the
;the max and min numbers will be in the lowest 16 bits of the two registers.
and       rax,0x000000000000FFFF                            ;Zero out the upper 48 bits of rax and preserve the lower 16 bits
and       rbx,0x000000000000FFFF                            ;Zero out the upper 48 bits of rbx and preserve the lower 16 bits

;cpuid will return zero throughout both registers rax and rbx if input value 0x16 is not implemented in the present processor.

cmp rax, 0
jne       showfrequencies
mov       rax, 0
mov       rdi, cpufrequencynotsupported
call      printf
jmp       preparetoexit

showfrequencies:
mov       rdi,cpufrequency
mov       rsi, rax                                          ;Copy minimum frequency to second parameter
mov       rdx, rbx                                          ;Copy maximum frequency to third parameter
mov qword rax,0                                             ;Do not output from any xmm registers
call      printf                                            ;Call a library function to produce the output

preparetoexit:                                              ;Entry point for a jump instruction
;==========================================================================================================================================================================
;===== End of the application: Identify the CPU ===========================================================================================================================
;==========================================================================================================================================================================


;==========================================================================================================================================================================
;===== Begin State Component Restore ======================================================================================================================================
;==========================================================================================================================================================================

;===== Check the flag to determine if state components were really backed up ===============================================================================================

pop        rbx                                              ;Obtain a copy of the flag that indicates state component backup or not.

cmp        rbx, 0                                           ;If there was no backup of state components then jump past the restore section.
je         restoregprs                                      ;Go to restore GPRs

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

xrstor     [backuparea]

;==========================================================================================================================================================================
;===== End State Component Restore ========================================================================================================================================
;==========================================================================================================================================================================


;=========== Restore GPR values and return to the caller ==================================================================================================================

restoregprs:

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


;===== Send a return value to the caller ===================================================================================================================================
;No special value is required for this program, therefore, we'll simply send negative one to the caller program.

mov        rax, -1

ret;                                                        ;ret pops the stack (removes 8 bytes) and resumes execution at the address that was popped.

;===== End of function processoridentification ============================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
