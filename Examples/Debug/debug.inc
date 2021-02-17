;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;System Title:  Debugger for X86 assembly programs
;Author: Floyd Holliday
;Email: activeprofessor@yahoo.com
;Status: Released for general use; bugs will be fixed when reported
;This module file name: debug.inc
;This module purpose: This file is an "include" file.  It allows data to pass directly from the calling statement to the subprogram.
;Language: X86
;Syntax: Intel
;Date of last update: 2013-Dec-13
;Source file structure: width is 140 characters; detailed comments begin in column 61.
;Printing: best results are obtained using landscape orientation with 9 point (or less) monospaced font.
;
;Targeted user group: Assembly programmers enrolled in programming courses like CPSC240.
;
;Requirements: debug.asm must be assembled into debug.o  This file is not to be assembled; it is used as is.  Place this file in the 
;directory along with debug.o and with other assembled object files.
;

;===== showregisters ======================================================================================================================

extern showregisterssubprogram

%macro showregisters 1
    push qword %1
    call showregisterssubprogram
    ;Question: Where is the pop corresponding to the push above?  Answer: In the ret statement.
%endmacro

;===== showstack ==========================================================================================================================

extern showstacksubprogram

%macro dumpstack 3
    push rsp                                      ;Save the current value of rsp since rsp is very volatile
    push rbp                                      ;Save the current value of rbp for insurance
    push qword %3                                 ;number of qwords inside the stack
    push qword %2                                 ;number of qwords outside the stack
    push qword %1                                 ;an arbitrary integer created by the caller
    call showstacksubprogram
    ;Question: Where are the pops corresponding to three pushes above?  Answer: In the ret statement.
%endmacro

;===== showfpu ============================================================================================================================

extern showfpusubprogram

%macro showfpuregisters 1
    push qword %1                                 ;Integer identifying this showing of the fpu registers.
    call showfpusubprogram
    ;Where are the pops corresponding to those pushes?
%endmacro

;===== showxmm ============================================================================================================================

extern showxmmsubprogram

%macro showxmmregisters 1
     push qword %1
     call showxmmsubprogram
%endmacro

;===== showymm ============================================================================================================================

extern showymmsubprogram

%macro showymmregisters 1
    push qword %1
    call showymmsubprogram
%endmacro

;==========================================================================================================================================

;How to use the debugger.

;1.  Assemble the file debug.asm and thereby create an object file known as debug.o

;2.  Place into one single directory this file, debug.inc, and debug.o, and as many addition source file as desired.

;3.  Insert the statement < %include "debug.inc" > without angle brackets into an asm source file to be debugged.  Place the statement 
;    before segment .data .

;4.  In segment .text place debugging statements at places where you want to examen the contents of registers.  There are four kinds 
;    of debug statements, namely: show the integer registers, show the system stack, show the fpu registers, and show the SSE2 
;    registers.  Examples of each of the four kinds of debug statements are found below.

;Example of debug statememts.

;==============================================
;  showregisters 33
;==============================================
;The statement above will show the contents of all 16 integer registers and the contents of the flags register.  The trailing number 33 
;is arbitrary.  The number 33 in the example can be replaced with any integer, but it cannot be omitted.

;==============================================
;  dumpstack 88, 2, 5
;==============================================
;The statement above will show the contents the system stack beginning with 2 quadwords outside of the top of the stack and ending with
;quadword #5 inside the stack for a total of 8 quadwords.  The first parameter 88 is an arbitrary integer selected by the programmer.
;The second parameter 2 indicates the number of quadwords beyond the top to be displayed.  To display nothing outside of the stack set
;the middle parameter to 0.  The last parameter 5 is the number of qwords after the top to be display.  The count is from 0 to 5, and
;therefore, a 5 parameter will cause 6 qwords inside the stack to be outputted.

;==============================================
;  showfpuregisters 133
;==============================================
;The statement above will show the contents of all 8 fpu registers.  The parameter 133 is arbitrary and may be replaced by any integer,
;but it cannot be omitted.

;==============================================
;  showxmmregisters 888
;==============================================
;The statement above will show the contents of all 16 SSE2 registers.  The parameter 888 is arbitrary and may be replaced by any integer,
;but it cannot be omitted.

;==============================================
;  showymmregisters 225
;==============================================
;The statement above will show the contents of all 16 AVE registers.  The parameter 225 is arbitrary and may be replaced by any integer,
;but it cannot be omitted.




;To the 240 class:
;This debug set of subprograms was derived from the original work of Dr Paul Carter.  He made a similar set of subprograms that could 
;be easily included in any assembly program.  All of his work was written in X86-32m and unfortunately, he seems to have lost interest 
;in updating his work.  You can and probably should visit his website: http://www.drpaulcarter.com/pcasm/.  There you may download the
;original include files which he called "asm_io.inc" and "asm_io.asm".  They are inside a zip file.  He also has a free ebook there on 
;X86-32 programming.  Yes, all the examples are 32-bit one, but the text description of instructions is still very helpful.  For 
;instance, in his ebook you can read a concise description of many of the FPU87 instructions, that is, those instructions that act on
;the st registers.  Yes, I am aware that others have tried to update his work to become relevant to 64-bit programming, but I still like
;the original ebook.

;Thus, Dr Carter's work was the foundation for the debug.inc and debug.asm files you are now reading.  For the curious, you may wonder 
;what happens when an assembly program has to call a C++ function that requires more that 6 incoming parameters.  There is an example of
;passing 9 parameters to printf in the "showregisterssubprogram", which is inside the file debug.asm.  Notice the registerformat1 requires 8 numeric
;values be passed to printf in addition to passing the string registerformat1 in rdi.  


