//****************************************************************************************************************************
//Program name: "Geometric Mean".  This program demonstrates how to compute the geometric mean of a set of floating point    *
//numbers stored in an array of quadwords.  Copyright (C) 2018  Floyd Holliday                                               *                                                                             *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************




//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Geometric Mean
//  Programming languages: C++. X86, C.
//  Date program began: 2019-Feb-20
//  Date of last update: 2019-Feb-28
//  Comments reorganized: 2019-Mar-10
//  Files in the program: geometric-main.c, geometric-controller.asm, fill-array.cpp, display.c, run.sh
//
//Purpose
//  Compute the Geometric Mean as a mathematical quantity used in statistics.
//  For learning purposes: Demonstrate use of SSE registers (xmm's), Demonstrate how to use the cpu clock to measure runtime.
//
//This file
//  File name: display.c
//  Function name: put_data
//  Language: C
//  Max page width: 136 columns
//  Optimal print specification: 7 point font, monospace, 136 columns, 8½x11 paper
//  Compile: gcc -c -m64 -Wall -fno-pie -no-pie -o display.o display.c




#include "stdio.h"

//Prototype:  
void put_data(double [], long);

//Function put_data begins here

void put_data(double numbers[], long true_count)
{int k = 0;
 for(k=0;k<true_count;k=k+1)
     printf("%-14.8lf\n",numbers[k]);
}//End of put_data
