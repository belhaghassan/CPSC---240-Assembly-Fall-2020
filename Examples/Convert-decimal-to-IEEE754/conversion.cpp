//Author: F. H.
//Email: holliday@fullerton.edu

//Program name: Convert decimal input to IEEE754 output
//Purpose: Show the representation of a given float number in three different IEEE formats: 64-bits, 32-bits, 16-bits

//Compile: g++ -c -m64 -Wall -no-pie -o conversion.o -std=c++17 conversion.cpp      //-mfp16-format=ieee
//Link: g++ -m64 -no-pie -o convert.out conversion.o -std=c++17

#include <iostream>
#include <iomanip>
#include "half.hpp"
//half.hpp is a software implementation of 2-byte IEEE754 compliant float numbers.  
//Ref: https://stackoverflow.com/questions/28581333/fifth-column-of-proc-loadavg?noredirect=1&lq=1



using namespace std;
using namespace half_float;

int main(int argc, char* argv[])
{double number64;
 cout << "Please enter a floating point number using decimal digits: ";
 cin  >> number64;
 cout << "You entered: " << showpoint << setprecision(10) << setfill('0') << setw(14) << left << fixed << number64 << endl << endl;

 //Begin section on 64-bit storage.
 double * pointer2double = &number64;
 void * pointer2void64 = pointer2double;
 unsigned long int * pointer2long = static_cast<unsigned long int *>(pointer2void64);

 //Begin section on 32-bit storage.
 //Cast the 64-bit float to a 32-bit storage object.
 float number32 = static_cast<float>(number64);
 float * pointer2float = &number32;
 void *  pointer2void32 = pointer2float;
 unsigned int * pointer2int = static_cast<unsigned int *>(pointer2void32);

 //Begin section on 16-bit storage
 //Cast the 32-bit float number to a 16-bit storage object.
 half number16 = half_cast<half>(number32);
 half * pointer2half = &number16;
 void * pointer2void16 = pointer2half;
 unsigned short * pointer2short = static_cast<unsigned short *>(pointer2void16);
 
 cout << "Here are the facts about that number using 3 storage sizes: 64, 32, and 16 bits:" << endl;

 cout << '|' << setw(13) << setfill('-') << right << '|' << setw(19) << '|' << setw(19) << '|' << setw(17) << '-' << endl;
 cout << '|' << "Storage size" << '|' << "Memory Location   " << '|' << "IEEE 754 value    " << '|' << "Decimal value" << endl;
 cout << '|' << setw(13) << setfill('-') << right << '|' << setw(19) << '|' << setw(19) << '|' << setw(17) << '-' << endl;
 cout << '|' << "  64 bits   " << '|' << "0x" << hex << right << setw(16) << setfill('0') << &number64 << '|' << "0x" << hex << right << setw(16) << setfill('0') << *pointer2long << '|'<< showpoint << setprecision(15) << setfill('0') << setw(3) << left << fixed << number64 << endl;
 cout << '|' << setw(13) << setfill('-') << right << '|' << setw(19) << '|' << setw(19) << '|' << setw(17) << '-' << endl;
 cout << '|' << "  32 bits   " << '|' << "0x" << hex << right << setw(16) << setfill('0') << &number32 << '|' << "0x" << hex << right << setw(8) << setfill('0') << *pointer2int << "        |"<< showpoint << setprecision(8) << setfill('0') << setw(3) << left << fixed << number32 << endl;
 cout << '|' << setw(13) << setfill('-') << right << '|' << setw(19) << '|' << setw(19) << '|' << setw(17) << '-' << endl;
 cout << '|' << "  16 bits   " << '|' << "0x" << hex << right << setw(16) << setfill('0') << &number16 << '|' << "0x" << hex << right << setw(4) << setfill('0') << *pointer2short << "            |" << showpoint << setprecision(4) << setfill('0') << setw(3) << left << fixed << number16 << endl;
 cout << '|' << setw(13) << setfill('-') << right << '|' << setw(19) << '|' << setw(19) << '|' << setw(17) << '-' << endl << endl;

 printf("That's all. Have fun with your floats.\n");
 return 0;
}
//============================================================================
//Example of declaring a half precision number and initializing it at the same time.
//     half num7 = half_cast<half>(4.2f);	

