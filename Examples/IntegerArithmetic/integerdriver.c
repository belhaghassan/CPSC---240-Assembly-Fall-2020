//****************************************************************************************************************************
//Program name: "Integer Arithmetic".  This program demonstrates how to input and output long integer data and how to pre-   *
//form a few simple operations on integers.  Copyright (C) 2020 Floyd Holliday                                               *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************


//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Integer Arithmetic
//  Programming languages: One modules in C and one module in X86
//  Date program began:     2012-Nov-01
//  Date program completed: 2012-Nov-04
//  Date comments upgraded: 2019-July-01
//  Files in this program: integerdrive.c, arithmetic.asm
//  Status: Complete.  Tested with a dozen different inputs.  No error uncovered during that testing session.
//
//References for this program
//  Jorgensen, X86-64 Assembly Language Programming with Ubuntu
//
//Purpose
//  Show how to perform arithmetic operations on two operands both of type long integer.
//
//This file
//   File name: integerdriver.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -m64 -fno-pie -no-pie -o driver.o integerdriver.c
//   Link: gcc -m64 -fno-pie -no-pie -o current.out driver.o arithmetic.o
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//
//
//===== Begin code area ===========================================================================================================



#include <stdio.h>
#include <stdint.h>

long int arithmetic();

int main()
{long int result_code = -999;
 result_code = arithmetic();
 printf("%s%ld\n","The result code is ",result_code);
 return 0;
}//End of main
