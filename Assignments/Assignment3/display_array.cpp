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
;    Name:      display_array.cpp                                                      		*
;    Purpose:   To print out all the integers in the array seperated by a single space.     *                                           
;	 Language:	C++																			*
;	 Assemble:	g++ -c -m64 -Wall -fno-pie -no-pie -o display_array.o display_array.cpp     *
;               -std=c++17			                                                        *     
;	 Link:		gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o 		*
;				swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o		*
;																							*
;********************************************************************************************
*/

// Header file for printf function.
#include <stdio.h>

// Declaration of display_array with "extern 'C'" to be compatible with c compiler.
extern "C" void display_array(long array[], long index);

// Definition of display_array function.
void display_array(long array[], long index)
{
    for (long i = 0; i < index; ++i)
    {
        printf("%ld", array[i]);
        printf("%s", " ");
    }
    printf("\n");
}