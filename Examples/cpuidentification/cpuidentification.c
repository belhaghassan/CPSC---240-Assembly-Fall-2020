//****************************************************************************************************************************
//Program name: "Processor Identification".  This program demonstrates how to call functions in the C library for the        *
//purpose of inputting or outputting numeric values.  Copyright (C) 2015  Floyd Holliday                                     *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

//Author information
//  Author name:  F. Holliday
//  Email: holliday@fullerton.edu
//Program information
//  Program name: Processor Identification
//  Programming languages: C (1 module)), X86 (1 module)
//  Date program development began: 2015-Sep-21
//  Date of last modification: 220019-Jan-11 [Comments upgraded]
//  Files in this program: cpuidentification.c, cupidentify.asm
//  Status: Done.  The author plans no more modifications.
//  Access: Open source with GNU GPL v3 license

//Purpose
//  Demonstrate to students enrolled in assembly programming classes how to extract information about the processor

//This module
//  File name: cpuidentification.c
//  Language: C (C99 compliant)
//  Source code page width: 132 chars
//  Purpose:  The is the driver program for an X86 program that will classify the cpu as made by Intel or made by another 
//  manufacturer.  This program is one of a series of programs in the group of cpu identification.  Intel made the original
//  editions of this series of programs for 32-bit processors.  This programs extends one of those older programs to 64-bit 
//  processors.
//
//GNU compiler: gcc -c -Wall -m64 -o cpuidentification.o cpuidentification.c -fno-pie -no-pie
//GNU linker:   gcc -m64 -o cpu.out cpuidentification.o cpuidentify.o -fno-pie -no-pie
//Execute in 64-bit protected mode: ./cpu.out
//
//
//
#include <stdio.h>
#include <stdint.h> //For C99 compatability
//At the time of this writing C99 is the newest available standard for C language.  Most modern C compilers conform to the C99 standard.
//The GNU compiler, known as gcc, is C99 compliant.  If both languages, C and X86, are C99 compliant then object code files from both compilers
//may be linked to form a single executable. 
//
//The standard prototype for functions that will be called later.  This main function calls exactly one function.
extern unsigned long int processoridentification();
//
int main(int argc, char* argv[])
{unsigned long int result = -999;
 printf("%s\n","The main C program will now call the X86-64 subprogram.");
 result = processoridentification();
 printf("%s\n","The subprogram has returned control to main.");
 printf("%s%ld\n","The return code is ",result);
 printf("%s\n","Bye");
 return result;
}


