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
//  File name: geometric-main.c
//  Language: C
//  Max page width: 136 columns
//  Optimal print specification: 7 point font, monospace, 136 columns, 8½x11 paper
//  Compile: gcc -c -m64 -Wall -fno-pie -no-pie -o geometric-main.o geometric-main.c
//  Link: g++ -m64 -fno-pie -no-pie -o geo.out geometric-main.o control.o fill-array.o display.o
//
//Execution: ./arrays.out
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>                                         //To students: the second, third, and fourth header files are probably not needed.
#include <time.h>
#include <string.h>
#include <math.h>

extern double geometric_mean();           //The "C" is a directive to the C++ compiler to use standard "CCC" rules for parameter passing.

int main(int argc, char* argv[])
{ double return_code = 88.9;                              //88.9 is an arbitrary number; that initial value could have been anything.


  printf("%s","\nWelcome to Harmonic Mean\n");
  return_code = geometric_mean();

  printf("%s%1.18lf%s\n","The driver received return code ",return_code,".  The driver will now return 0 to the OS.");
  return 0;                                                 //'0' is the traditional code for 'no errors'.

}//End of main
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

