/*
;********************************************************************************************
; Program name:          Sum of Integers - Array                                            *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns the sum of integers in the array.                          *
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
; Program information                                                                       *
;   Program name: Sum of Integers - Array                                                   *
;   Programming languages: One module in C, Four modules in X86, Two modules in c++         *
;   Files in this program: manager.asm, input_array.asm, sum.asm, atol.asm, main.c,         *   
;   					   validate_decimal_digits.cpp, display_array.cpp                   *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      main.c                                                            			*
;    Purpose:   Prints the welcome message and calls on manager to produce value. Then      *
;				prints out value and outgoing message.       							    *
;                                                                                           *
;********************************************************************************************
*/

#include <stdio.h>
#include <stdint.h>

long int control();

int main()
{
long int result_code = -999;

	printf("%s","\nThe control function will help you.\n");
	printf("%s","Input your integer data with white space separating each number.\n");
	printf("%s","Press <enter> followed by Cntl+D to terminate.\n\n");
	result_code = control();
	printf("%s%ld","\n\nThe operator received this value: ", result_code);
	printf("%s","\n\nMain will return 0 to the operating system. Bye.\n");
	printf("%s","Have a nice day.  The program will return control to the operating system.\n\n");
	return 0;
}
