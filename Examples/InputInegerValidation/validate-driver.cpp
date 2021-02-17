//***************************************************************************************************************************
//Program name: "Validate Integer Input".  This program demonstrates how to validate input received from scanf as valid      *
//integer data.  Copyright (C) 2020 Floyd Holliday                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************


//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//Author name: Floyd Holliday
//Author email: holliday@fullerton.edu
//
//Program information
//  Program name: Validate Integer Input
//  Programming languages: Two modules in C++ and one module in X86
//  Date program began: 2020-Sep-02
//  Date of last update: 2020-Sep-02
//  Date of reorganization of comments: 2020-Sep-03
//  Files in this program: validate-driver.cpp, test-validation.asm, test-scanf.cpp
//  Status: In testing phase
//
//This file
//   File name: validate-driver.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o drive.o validate-driver.cpp -std=c++17
//   Link: g++ -m64 -fno-pie -no-pie -o code.out -std=c++17 scan.o valid.o drive.o

//===== Begin code area ==============================================================================================================





#include <iostream>
extern "C" long int testmodule();

int main(int argc, char* argv[])
{printf("This program demonstrates validation of integer inputs received through scanf.\n");
 long int code = -99;
 code = testmodule();
 printf("The driver module received this integer: %ld\n",code);
 printf("End of demonstration test.\n");
 return 0;
}



