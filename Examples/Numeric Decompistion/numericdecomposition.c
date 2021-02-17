//****************************************************************************************************************************
//Program name: "Numeric Decomposition".  This program accepts a base 10 floating point number from stdin and decomposes it  *
//into standard components: sign big, stored exponent, and significand.  Lastly, the number is displayed in IEEE 754 format. *
//Copyright (C) 2014  Floyd Holliday                                               *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************





//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
//Author information
//  Author name: Floyd Holliday
//  Author email: holliday@fullerton.edu
//  Author location: Fullerton, CA
//Program information
//  Short title: Numeric Decomposition
//  Purpose: This program will demonstrate to the CPSC240 class how to "pass back" multiple values from an X86 subprogram to a C program that called the X86 subprogram.
//  Status: Testing phase. No errors discovered after a few dozen test cases. 
//  Program begun: 2014-Dec-5
//  Program completed and tested: 2014-Dec-08
//  Comments and bash instructions upgraded 2019-Dec-16
//  Project files: numericdecomposition.c, numericmain.asm
//Module information
//  File name: numericdecomposition.c
//  Language: C
//  Date last modified: 2014-Dec-8
//  Purpose: This module is the top level driver.  This module will call numericdecomposition, which will return multiple data values that will be displayed here.
//  Status: This module is simple C code.  This driver has been tested extensively.
//  Future enhancements: Implement the capability of correctly processing subnormal inputs.
//Translator information (Tested in Bash shell)
//  Gnu compiler: gcc -c -m64 -Wall -std=c11 -o numeric_d_com.o -no-pie numericdecomposition.c
//  Gnu linker:   gcc -m64 -std=c11 -no-pie -o decomposition.out numeric.o numeric_d_com.o
//  Execute:      ./decomp.out
//References and credits
//  No references: this module is standard C language
//Format information
//  Page width: 172 columns
//  Begin comments: 61
//  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
//
//===== Background information ============================================================================================================================================
//
//During lab time many of you asked me for help in returning data from a called subprogram to the caller program.  Many times the question refers to the driver: How do I
//return more than one value to the driver?  This program is an example of how to do exactly that.
//
//There are really only two ways to pass data if one of the two (caller or called) is C (or C++).  The caller may pass data to the subprogram by value.  The subprogram
//may pass data back to the caller by pointer.  This example shows 4 values passed back to the caller using "pass by pointer".
//
//The so-called "pass by reference" is not a new technique of passing data, but rather it is a limited version of "pass by pointer".  Pass by reference does not exist in
//C-language; it exists in C++, thereby, helping to created a bloated C++.
//===== Begin code area ===================================================================================================================================================
//
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

extern char * numericdecomposition(double *, char *, long *, short *, unsigned long *);

int main(int argc, char* argv[])
{//In the following declarations the digit '1' is used only to emphasize that storage for a single value is being created.
 double * number = malloc(1*sizeof(double));
 char * sign = malloc(1*sizeof(char));
 long * trueexponent = malloc(1*sizeof(long));
 short * hiddenbit = malloc(1*sizeof(short));
 unsigned long * significand = malloc(1*sizeof(unsigned long));
 char * significandarray;                                   //Declare a pointer to receive an array of bytes that was declared in the subprogram.

 printf("%s","Welcome to Numeric Decomposition\n");
 significandarray = numericdecomposition(number, sign, trueexponent, hiddenbit, significand);

 printf("%s\n","The caller received the following data from the subprogram.");
 printf("%s%1.16lf\n","Original floating point number: ",*number);
 printf("%s%c\n","The sign of the original number: ",*sign);
 printf("%s%ld\n","The true exponent: ",*trueexponent);
 printf("%s%d\n","The hidden bit: ",*hiddenbit);
 printf("%s%013lx\n","The significand: 0x",*significand);   //The significand in 64-bit arithmetic contains 52 bits which equals 13 hex digits.

 //See appendix after the end of this function for an explanation.
 void * abstract = number;                                  //abstract and number both point to the same value, which has not changed.
 unsigned long * longnumber = abstract;                     //longnumber and number both point to the same value, which has not changed.

 printf("Therefore, %1.16lf equals %c%1d.%-52s x 2^%1ld, which equals 0x%016lX\n", *number, *sign, *hiddenbit, significandarray, *trueexponent, *longnumber);
 printf("The driver will now return 0 to the OS.  Bye.\n"); 

 return 0;
}//End of main


//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

//Appendix 1: A unusual solution to the problem of output in hex.

//The problem:  How does the programmer output a double in C (or C++) in hex format?
//You may think the answer is the following, but it is wrong.
//        double myfavorite = 3.1416;
//        printf("0x%016x",myfavorite);
//The problem is format specifier "%x" can only be used with integer data.


//Now the problem becomes how do you make C language think that the number is really an integer.  The wrong way is casting.  Suppose the following:
//        double myfavorite = 3.0;
//        long myinteger = (long)myfavorite [C style]   or  long myinteger = static_cast<long>(myfavorite);
//The problem above is that the bits of the original number 3.0 = 0x4000 8000 0000 0000 will be changed into 3 = 0x0000 0000 0000 0003.  You still cannot output the
//original number in hex.


//There is a way to make the software think you have an integer.  Here is the technique.
//         double * mynumber = new double (3.0);    //Now *mynumber holds 0x4000 8000 0000 0000
//         void * abstract = mynumber;              //Create a void * pointer and make it point to 0x4000 8000 0000 0000
//                                                  //Both *mynumber and *abstract are the same 8 bytes, namely: 0x4000 8000 0000 0000.
//         unsigned long * biginteger = abstract;   //Create an integer pointer and make it point to 0x4000 8000 0000 0000.
//                                                  //Now all 3 of these are names for the same 8 bytes: *mynumber, *abstract, *biginteger.
//         printf(0x%016X, *biginteger);            //Now the program language thinks you are outputting an integer, therefore, you are allowed to use the hex specifier.
//
//End of solution.

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

//Appendix 2: A C-language only solution.

//This program contains a few C-only statements. However, it can be easily converted to compile with a C++ compiler.  The following are modification needed to convert this
//program to a C++ program.

//Replace: double * number = malloc(1*sizeof(double));
//with     double * number = (double *)malloc(1*sizeof(double));

//Replace: char * sign = malloc(1*sizeof(char));
//with     char * sign = (char *)malloc(1*sizeof(char));

//Replace: long * trueexponent = malloc(1*sizeof(long));
//with     long * trueexponent = (long *)malloc(1*sizeof(long));

//Replace: unsigned long * significand = malloc(1*sizeof(unsigned long));
//with     unsigned long * significand = (unsigned long *)malloc(1*sizeof(unsigned long));

//Replace: unsigned long * longnumber = abstract;
//with     unsigned long * longnumber = (unsigned long *)abstract;

//It shows that some of the assignments permitted in C-language require the cast operation in C++.  One can conclude that C++ is a little more restrictive in type
//checking than C is.  Completing the conversion from C to C++ is left as a exercise for anyone interested in the comparison of languages.

//It is interesting to see how C++ has preserved some features from old C.  The allocator malloc is one example.  
//In C you allocate storage for an array of 10 doubles like this:          double * number = malloc(10*sizeof(double));

//In C++ you call the constructor for an array of 10 doubles like this:    double * number = new double[10];

//You cannot use the constructor "new" in C, but you can use the allocator "malloc" in C++.
