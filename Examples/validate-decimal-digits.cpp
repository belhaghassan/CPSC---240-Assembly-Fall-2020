//****************************************************************************************************************************
//Program name: "isinteger".  This is a single function distributed without accompanying software.  This function scans a    *
//char array seeking to confirm that all characters in the array are in the range of ascii characters '0' .. '9'.  If all    *
//chars in the array are within that range a value true will be returned, otherwise a value false will be returned.          *
//Copyright (C) 2020 Floyd Holliday
//
//This is a library function distributed without accompanying software.                                                      *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
//License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
//useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
//See the GNU General Public License for more details.  A copy of the GNU Lesser General Public License 3.0 should have been *
//distributed with this function.  If the LGPL does not accompany this software then it is available here:                    *
//<https:;www.gnu.org/licenses/>.                                                                                            *
//****************************************************************************************************************************

//To students in CPSC240:  This is my opinion.  I have studied the the available licenses for software especially the GPL,
//the LGPL, and the Affero GPL.  This is what I have learned about the LGPL used with this function "isinteger".
//   The section above the blank line is called the "copyright notice".
//   The section below the blank line is called the "license notice".
//   LGPL is for use on software typically found in software libraries.
//   This LGPL license applies only to the specific function named in the license.
//   This library may be used within another application covered by other licenses (or EULAs).
//   This license requires that source code of this function be distributed with the application (even if other parts of the
//       application are not required to be distributed with source code).
//   This LGPL allows you to re-distribute the function (provided the original LGPL remains).
//   This LGPL allows you to modify the function (provided the original LGPL remains).
//   This LGPL allows you to distribute (or sell) your modified versions to anyone (provided the original LGPL remains). 
//   When you distribute this software to other people a copy of the LGPL is suppose to accompany the source code in a 
//       separate file.  If that separate file becomes lost (by human error) license still has legal standing.
//
//References: 
//   How to correctly place a software license in a source file: https://www.gnu.org/licenses/gpl-howto.html
//   Complete text of LGPl in html format: https://www.gnu.org/licenses/lgpl-3.0.html
//   Complete text of GPL in html format: https://www.gnu.org/licenses/gpl-3.0.html
//
//
//A example: Microsoft programmers are developing a new version of Minecraft.  One of the programmers on that project
//discovers a useful function stored online that can be used in the new version of Minecraft.  If that online function is 
//licensed by GPL and Microsoft uses it, then Microsoft must make all of Minecraft open source and licensed by GPL.  However, 
//if that online function is licensed by LGPL then Microsoft may legally incorporate the function into Minecraft, and 
//Minecraft remains proprietary and wholly secret.  Do you see a major difference between the two kinds of licenses?

//This opinion is included here for educational purposes in the course CPSC240.  You must remove this opinion statement 
//when you use this library function in other application programs such as homework.
//
//To students in 240:  You must remove this block of opinion statements when you use this function in your program.  If this
//block remains when I grade your program then automatically your program is not professional.//
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//
//This file
//  Program name: isinteger
//  File name: validate-decimal-digits.cpp
//  Date development began: 2020-Sep-2
//  Date of last update:  2020-Sep-6
//  Comments reorganized: 2020-Sep-25
//  This is a library function.  It does not belong to any one specific application.  The function is available for inclusion 
//  in other applications.  If it is included in another application and there are no modifications made to the executing 
//  statements in this file then do not modify the license and do not modify any part of this file; use it as is.
//  Language: C++
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Testing: This function was tested successfully on a Linux platform derived from Ubuntu.
//  Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o digits.o validate-decimal-digits.cpp -std=c++17
//  Classification: Library
//
//Future project
//  Re-write this function in X86 assembly.
//
//How to call isinteger from an X86 module:
//  == Declare isinteger to be exist externally: extern isinteger
//  == Obtain an address pointing to valid memory.  Such an address can be a resgister like rsp or a declared array like mystuff resq 300
//  == Do the setup block for isinteger:
//     == mov rax,0
//     == mov rdi, <a register>        or         mov rdi,mystuff
//     == call isinteger
//     == mov r15, rax      ;Copy the returned number to a safer location such as r15.
//
//How to call isinteger from a C function
//  ==Place the prototype near the top of the calling function:  bool isinteger(char []);
//  ==Declare a bool variable:  bool outcome;
//  ==Create an array:  char wonder[200];
//  ==Fill the array with a null-terminate sequence of chars.
//  ==Call the function:  outcome = isinteger(wonder)
//
//
#include <iostream>
//#include <cstring>
using namespace std;
extern "C" bool isinteger(char []);
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
}//End of isinteger


