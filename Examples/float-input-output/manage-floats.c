//****************************************************************************************************************************
//Program name: "Floating IO".  This program demonstrates the input of multiple float numbers from the standard input device *
//using a single instruction and the output of multiple float numbers to the standard output device also using a single      *
//instruction.  Copyright (C) 2019 Floyd Holliday.                                                                           *
//                                                                                                                           *
//This file is part of the software program "Floating IO".                                                                   *
//Floating IO is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Floating IO is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************


//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Floating IO
//  Programming languages: One modules in C and one module in X86
//  Date program began: 2019-Oct-25
//  Date of last update: 2019-Oct-26
//  Date of reorganization of comments: 2019-Oct-29
//  Files in this program: manage-floats.c, float-input-output.asm
//  Status: Finished.  The program was tested extensively with no errors in Xubuntu19.04.
//
//Purpose
//  Show how to input and output floating point (64-bit) numbers.
//
//This file
//   File name: manage-floats.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -m64 -std=c11 -no-pie -o current-time.o current-time.c
//   Link: gcc -m64 -no-pie -o current.out -std=c11 current-time.o date_and_time.o
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdint.h> //For C99 compatibility
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>   //For malloc
//At the time of this writing C99 is the newest available standard for C language.  Most modern C compilers conform to the C99 
//standard.  The GNU compiler, known as gcc, is C99 compliant.  If both languages, C and X86, are C99 compliant then object code 
//files from both compilers may be linked to form a single executable. 
//
//The standard prototypes for any functions that may be called later.  This main function calls exactly one function.
extern double floatio();
//
int main(int argc, char* argv[])
{double answer = 0.0;
 printf("The main function manage-floats.c has begun\n");
 printf("The function floatio will now be called\n");
 answer = floatio();
 printf("The function floatio has returned this value %8.5lf.  Have a nice day\n",answer);
 return 0;
}
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**




