//****************************************************************************************************************************
//Program name: "Input Integer Validation".  This program demonstrates how to validate input received from scanf as valid    *
//integer data.  Copyright (C) 2020 Floyd Holliday                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************




//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Input Integer Validation
//  Programming languages: C++
//  Date program began: 2020-Sep-2
//  Date of last update: 2020-Sep-6
//  Comments reorganized: 2020-Sep-7
//  This is a library function.  It does not belong to any one specific application.  It resides in a library available for
//  use by other programmers of this organization.
//
//Future
//  Re-write this function in X86 assembly.
//
//This file
//  File name: validate-decimal-digits.cpp
//  Purpose: Validate a char array as containing only decimal digits or not containing only decimal digits.
//  Function name: isinteger
//  Language: C++
//  Max page width: 136 columns
//  Optimal print specification: 7 point font, monospace, 136 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o digits.o validate-decimal-digits.cpp -std=c++17
//  Classification: Library
//     Library functions are not specific to any one application program.  They are stored on a server and are available for re-use
//     in the development of future applications.


#include <iostream>
//#include <cstring>
using namespace std;
extern "C" bool isinteger(char w[]);
bool isinteger(char w[])
{bool result = true; //Assume true until proven otherwise.
 int start = 0;
 if (w[0] == '-' || w[0] == '+') start = 1;
 unsigned long int k = start;
 while( !(w[k]=='\0') && result )
     {result = result && isdigit(w[k]);
      k++;
     }
 return result;
}//End of isInteger


