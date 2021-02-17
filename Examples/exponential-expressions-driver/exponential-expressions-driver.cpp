//Author name: Floyd Holliday
//Author email: holliday@fullerton.edu

//Program name: Exponential Expressions
//Programming languages: C++ (driver), X86 (algorithm)
//Date program began: February 14, 2013
//Date completed: February 22, 2013
//Date of upgraded comments: March 2, 2019
//Files in this program: exponential-expressions-driver.cpp, exponential-expressions.asm, r.sh
//Status: Done.  No more work will be done on this program apart from fixing any reported errors.
//Purpose: Accept as inputs a significand s and an exponent e.  The output the exponential expression s x 2^e in standard decimal
//format.   
//Comment: The outcome is mildly interesting when the exponent e is large.  In fact, a sufficiently value for e will cause the
//expression to evaluate as infinity.  More interesting are the outcomes when e is negative and large in magnitude.  The output will 
//show how extremely close to 0.0 are numbers with small negative exponents.

//Technical comment: This program uses the 80-bit registers in the FPU for evaluation of the exponential expression.
//The technical specifications for 80-bit floating point numbers are as follows:
//   Total storage for a floating point number = 80 bits, which is sometimes called a tword whereas qword is used for 64-bit registers.
//   Storage for exponent = 15 bits
//   Storage for significant = 64 bits
//   Base number = -16382
//   Bias number = +16383
//   Smallest positive normal number = 2^(-16382)
//   Positive Infinity = 2^16383

//This file name: exponential-expressions-driver.cpp
//This file language: C++
//Parameters passed in: none
//Parameter passed out: one long int designated as code number

//Compile:            g++ -c -m64 -Wall -o exponential-expressions-driver.o exponential-expressions-driver.cpp -fno-pie -no-pie
//Link without debug: g++ -m64 -o exponential-expressions.out exponential-expressions.o exponential-expressions-driver.o -fno-pie -no-pie
//
#include <stdio.h>
#include <stdint.h>

extern "C" long int exponentialnumbers();

int main()
{long int return_code = -99;
 printf("%s","Welcome to EFP (Expontial Floating Point) numbers.\n");
 return_code = exponentialnumbers();
 printf("%s%ld%s\n","The result code is ",return_code,".  Enjoy your programming.");
 return 0;
}//End of main

