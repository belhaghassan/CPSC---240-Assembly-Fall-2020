/*

; Bilal El-haghassan - 887210292 - December 14, 2020

;********************************************************************************************
; Author Information:                                                                       *
; Name:         Bilal El-haghassan                CWID = 887210292                          *
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
// Header file for printf function.
#include <stdio.h>

extern double compute();

int main()
{
	printf("\n%s","CPSC 240-05 FINAL - by Bilal El-haghassan\n\n");
	
	compute();
	
	printf("%s","Bye.\n\n");
	return 0;
}
