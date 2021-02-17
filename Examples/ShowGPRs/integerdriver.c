//*****************************************************************************************************************************
//Program name: "Volatility Test of GPRs across printf".  This program checks for changes in general registers before and     *
//after a call to printf.  The program will empirically aid in finding stable registers.  Copyright (C) 2020 Floyd Holliday   *
//                                                                                                                            *
//This file is part of the software program "Volatility Test of GPRs across printf".                                          *
//Volatility Test of GPRs across printf is free software: you can redistribute it and/or modify it under the terms of the GNU *
//General Public License version 3 as published by the Free Software Foundation.                                              *
//Volatility Test of GPRs across printf is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without  *
//even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for   *
//ore details.  A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.              *
//*****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Volatility Test of GPRs across printf
//  Programming languages: One modules in C and two modules in X86, one module in C++
//  Date program began:     2020-Sep-18
//  Date program completed: 2020-Sep-18
//  Date comments upgraded: 2020-Sep-18
//  Files in this program: integerdriver.c, arithmetic.asm, atol.asm (lib), validate-decimal-digits.cpp (lib), showgprs.asm (lib)
//  Files labeled "lib" are library files containing source code.  They are borrowed without modification for use here.
//  Library programs do not carry documented comments about this specific program named "Volatility Test of GPRs across printf"
//  because they are used in many application programs.
//  Status: Complete.
//
//Program history
//  This program is a derivation of the open source program "Input Integer Validation".  This program continues to
//  carry the same license at the parent program.  All rights conveyed in the license in the parent program are also 
//conveyed in this derived program.
//
//References for this program
//  Jorgensen, X86-64 Assembly Language Programming with Ubuntu
//
//Purpose
//  Purpose: Empirically test the state of general purpose registers before a call to printf and immediately 
//  the call to printf has terminated.  Four tests have been included in this program and the results have
//  been tabulated.  Four test cases does not 'prove' anything, but four test cases do provide strong 
//  evidence about which registers are always modified by printf, sometimes modified by printf, or never 
//  modified by printf.
//
//This file
//   File name: integerdriver.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -m64 -fno-pie -no-pie -o driver.o integerdriver.c
//   Link: gcc -m64 -fno-pie -no-pie -o current.out driver.o arithmetic.o    //Ref Jorgensen, page 226, "-no-pie"
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper     
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
