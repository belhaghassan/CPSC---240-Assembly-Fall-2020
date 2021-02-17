/*
;********************************************************************************************
; Program name:          Sorting Array                                                      *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 October 12, 2020													*
; Program Completed:	 October 23, 2020													*
; Last Modified:		 October 31, 2020													*
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the same array but sorted in ascending order.              *
;                                                                                           *
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Bilal El-haghassan                                                          *
; Email:        bilalelhaghassan@csu.fullerton.edu                                          *    
; Institution:  California State University - Fullerton                                     *
; Course:       CPSC 240-05 Assembly Language                                               *
;                                                                                           *
;********************************************************************************************
; Copyright (C) 2020 Bilal El-haghassan                                                     *
; This program is free software: you can redistribute it and/or modify it under the terms   * 
; of the GNU General Public License version 3 as published by the Free Software Foundation. * 
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. * 
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;                                                                                           *
;********************************************************************************************
; Program Information                                                                       *
; Program name:   Sorting Array			                                       				*
; Languages used: One module in C, Five modules in x86, Three modules in C++ 				*
; Files included: manager.asm, input_array.asm, swap.asm, atol.asm, read_clock.asm 			*   
;   			  main.cpp, isinteger.cpp, display_array.cpp, bubble_sort.c      			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:     main.cpp                                                            			*
;    Purpose:  Prints the welcome message and calls on manager to produce, sort/display	    *
;			   the array. Also calls on read_clock to disply the number of cycles/tics that *
;              have occured on the cpu since startup. 										*
;	 Language: C++																			*
;	 Assemble: g++ -c -m64 -Wall -fno-pie -no-pie -o main.o main.cpp -std=c++17				*
;	 Link:	   gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o 		*
;			   swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o		*
;																							*
;********************************************************************************************
*/
// Header file for printf function.
#include <stdio.h>

// Declaration for assembly manager function which returns largest integer in the array.
extern "C" long int manager();

// Declaration for assembly gettime function which returns cpu cycles/tics since pc reset.
extern "C" long int gettime();

int main()
{
long int result_code = -999;
	printf("%s%ld%s","\nThe time on the CPU clock is now ", gettime(), " tics\n");
	printf("%s","Welcome to Array Sorting program\n");
	printf("%s","Brought to you by Bilal El-haghassan\n\n");
	result_code = manager();
	printf("%s%ld%s","\nMain received ", result_code, ", and plans to keep it.\n");
	printf("%s","Main will return 0 to the operating system. Bye.\n");
	printf("%s%ld%s","The time on the CPU clock is now ", gettime(), " tics\n\n");
	return 0;
}
