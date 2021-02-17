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
;    Name:      bubbleSort.c                                                           		*
;    Purpose:   To sort an array from smallest to largest by iterating through the array    *
;               many times while comparing the values in each index with the next index     *  
                and each time moving the largest value in the array towards the end but     * 
                before the previously moved largest value.                                  *
;	 Language:	C																			*
;	 Assemble:	gcc -c -Wall -m64 -no-pie -o bubble_sort.o bubble_sort.c -std=c11			*
;	 Link:		gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o 		*
;				swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o		*
;																							*
;********************************************************************************************
*/

// Declaration of assembly function swap which swaps the values in the array.
void swap(long arr[], long arr1[]);

// Declaration of bubbleSort function
void bubbleSort(long arr[], long n);

// Definition of bubbleSort function
void bubbleSort(long arr[], long n)
{  
    int i, j;  
    for (i = 0; i < n-1; i++)
        for (j = 0; j < n-i-1; j++)  
            if (arr[j] > arr[j+1])  
                swap(&arr[j], &arr[j+1]);  
}  
  