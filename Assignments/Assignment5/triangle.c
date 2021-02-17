/*
;********************************************************************************************
; Program name:          Area of a Triangle			                                        *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 4, 2020													*
; Program Completed:	 November 6, 2020													*
; Last Modified:		 November 23, 2020													*
; Program Description:   This program asks a user to input three floating-point lengths     *
;                        of a triangle and returns the area using Herons Formula			*
;                        Herons Formula = Sqrt(s(s-a)(s-b)(s-c)), Where s = (a + b + c)/2   *
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
; Program name:   Area of a Triangle 				                           				*
; Languages used: One module in C, One module in C++, One module in x86                   	*
; Files included: area.asm, ispositivefloat.cpp, triangle.c                                 *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      triangle.c                                                         			*
;    Purpose:   Prints out welcome message and calls on area function to take a users       *
;               input of 3 floating point lengths of a trangle and returns the area.        *
;	 Language:	C																			*
;	 Assemble:	gcc -c -Wall -m64 -no-pie -o triangle.o triangle.c -std=c17					*
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 area.o triangle.o ispositivefloat.o      *
;																							*
;********************************************************************************************
*/
// Header for printf/scanf
#include <stdio.h>

// Declaration of area function in assembly.
double area();

int main()
{
	double result_code = -999;
	printf("\n%s","Welcome to Area of Triangles by Bilal El-haghassan\n\n");

	// Call assembly area function.
	result_code = area();

	// Print out area received from area() in 16 bit Hexidecimal.
	printf("\n%s0x%016lX%s","The driver recieved this number ", *(unsigned long*)&result_code, 
				", and will keep it.");

	// Prints out goodbye message.
	printf("\n\n%s","Now 0 will be returned to the operating system.  Bye.\n\n");
	return 0;
}
