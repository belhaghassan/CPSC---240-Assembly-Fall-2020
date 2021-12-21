/*
;********************************************************************************************
; Program name:          Reverse Array                                                      *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input integers into an array and       *
;                        returns array in reverse.                                          *
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
*/
#include <stdio.h>
#include <stdint.h>

long int manager();
long int gettime();

int main()
{
long int result_code = -999;
	printf("%s","\n\nWelcome to midterm by Bilal El-haghassan\n");
	printf("%s","The array manager will begin\n");
	printf("%s%ld%s","\nCurrent tics is ", gettime(), ".\n");
	result_code = manager();
	printf("%s%ld%s","Current tics is ", gettime(), ".\n");
	printf("%s%ld","The driver received ", result_code);
	printf("%s", ", and doesnt know what to do with it.\n");
	printf("%s","Have a nice day.\n\n");
	return 0;
}
