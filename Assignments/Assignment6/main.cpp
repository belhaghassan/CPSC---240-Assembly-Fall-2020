/*
;********************************************************************************************
; Program name:          Harmonic Sum                                                       *
; Programming Language:  x86 Assembly                                                       *
; Program Created:		 November 28, 2020													*
; Program Completed:	 December 3, 2020													*
; Last Modified:		 December 3, 2020													*
; Program Description:   This program asks a user to input a value and will return the      *
;                        harmonic sum of that value.                                        *
;                                                                                           *
;                             __n__                                                         *
;                             \      1                                                      *
;            Harmonic Sum =   /     ---                                                     *
;                            /____   i                                                      *
;                            i = 1                                                          *
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
; Program name:   Harmonic Sum			                                       				*
; Languages used: Three modules in x86, One modules in C++ 				                    *
; Files included: manager.asm, read_clock.asm, getfrequency.asm                  			*
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:     main.cpp                                                            			*
;    Purpose:  Prints the welcome message and calls on manager to calculate the Harmonic    *
;			   sum. 								 										*
;	 Language: C++																			*
;	 Assemble: g++ -c -m64 -Wall -fno-pie -no-pie -o main.o main.cpp -std=c++17				*
;	 Link:	   gcc -m64 -no-pie -o a.out -std=c11 main.o manager.o read_clock.o freq.o		*                                                        *
;																							*
;********************************************************************************************
*/
// Header file for printf function.
#include <stdio.h>

// Declaration for assembly manager function which returns largest integer in the array.
extern "C" double manager();

int main()
{
double result_code = -999;
	printf("\n%s","Welcome to the Harmonic Sum programmed by Bilal El-haghassan\n\n");
	result_code = manager();
	printf("%s%.7lf%s","The driver received this number ", result_code, " and will keep it.\n");
	printf("%s","A zero will be returned to the operating system.  Have a nice day.\n\n");
	return 0;
}
