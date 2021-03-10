//****************************************************************************************************************************
//Program name: "Statistical Numbers".  This program demonstrates how to clear the state of the input stream following an    *
//action that placed it into a failed state.  Clearing the failed state is necessary in order to continue receiving inputs   *
//from the standard input stream.  Copyright (C) 2019 Floyd Holliday.                                                        *
//This program is free software: you may redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************

//Author: F. Holliday
//Author email: holliday@fullerton.edu
//
//Program name: Statistical Numbers
//Programming languages: C++ and X86
//Date of last modification: 2019-Sep-08
//Files in the program: stats.cpp, statistics.asm, run.sh
//Status: Testing has been successful
//Future: Separate some of the functionality in statistics.asm into one, or two, or more files containing functions.


#include <stdio.h>

extern "C" long int average();

int main(int argc, char* argv[])
{
 long int mean = -999;
 printf("%s\n", "Welcome to Statistical Numbers");
 printf("%s\n", "Brought to you by a group of students enrolled in 240");
 mean = average();
 printf("\n\n%s%ld%s\n", "The Main function has resumed execution and has received this number: ", mean, ". Have a nice day.");
 printf("%s\n", "The C++ program will now forward that same number to the operating system.");
 return mean;
}





//Message to students of assembly programming.

//This program began with the intention of creating a program that demonstrates how to set the 
//state of the input stream to a 'good' state a failed state.  I intended to use the standard 
//three assembly statements to clear the failed state, namely:
//     mov rax,0
//     mov rdi,[stdin]
//     call clearerr
//The mystery is that when the program was finished I found out that it was performing correctly
//and that I had not used the 3 instructions to set the input stream (buffer) to good state.

//In conclusion, this project kind of failed.   It does not show the use of clearing the input
//stream generally known as stdin.



//In the future I will be looking for another program to demonstrate clearing of the input stream.
