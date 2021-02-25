/*
;********************************************************************************************
; Program name:          Circumference of a Circle	                                        *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 1, 2020													*
; Program Completed:	 November 2, 2020													*
; Last Modified:		 November 7, 2020													*
; Program Description:   This program asks a user to input a radius as a floating-point     *
;                        number and returns the circumference of a circle with that radius  *
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
; Program name:   Circumference of a Circle			                           				*
; Languages used: One module in C, One module in x86                         				*
; Files included: circle.asm, circumference.c                                               *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      circumference..c                                                         	*
;    Purpose:   Prints out welcome message and calls on circle function to take a users     *
;               inputted radius and recieves the calculated circumference.                  *
;	 Language:	C																			*
;	 Assemble:	gcc -c -Wall -m64 -no-pie -o circumference.o circumference.c -std=c11		*
;	 Link:		gcc -m64 -no-pie -o a.out -std=c11 circumference.o circle.o                 *
;																							*
;********************************************************************************************
*/
// Header for printf/scanf
#include <stdio.h>

// Declaration of circle function in assembly.
double circle();

int main()
{
	double result_code = -999;
	// Prints out welcome message to Console.
	printf("%s","Welcome to your friendly circle circumference calculator\n");
	printf("%s","The main program will now call the circle function\n");

	// Calls assembly function circle to calculate the circumference of a users inputted 
	// radius as a floating-point number.
	result_code = circle();

	// Prints out value calculated in circle as a floating-point number and
	// as a hexidecimal number.
	printf("The main recieved this number: %lf", result_code);

	// Prints out goodbye message.
	printf("\n%s","Have a nice day. Main will now return 0 to the operating system.\n");
	return 0;
}
