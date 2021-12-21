//Author: Your instructor
//Purpose: Illustrate a midterm test question concerned with the location of an array.
//Date: March 26, 2019
//Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o array_location.o array_location.cpp

#include <iostream>
#include <iomanip>
#include <cstring>
using namespace std;

//Prototype
extern "C" long unsigned int viewstack(long id, long unsigned int number_qwords_outside_stack, long unsigned int number_qwords_inside_stack);
extern "C" long unsigned int * viewmemory(long int a, long unsigned int b, long unsigned int c, void * d);

int main(int argc, char* argv[])
{//Declare a static array
 long house[] = {1,3,5,7,-1,9,16};
 cout << "The address of the start of the static house array is 0x" << hex << setw(16) 
      << setfill('0') << (unsigned long)house << endl;

 //Delcare a static array
 char mess[20];
 strcpy(mess,"Good Morning");
 cout << "The address of the start of the static mess array is 0x" << hex << setw(16) 
      << setfill('0') << (unsigned long)mess << endl;

 //Delcare a dynamic array
 double * truck = new double[10];
 truck[0] = 2.0;
 truck[1] = 3.5;
 truck[2] = 5.25;
 truck[3] = 6.5;
 cout << "The address of the start of the dynamic truck array is 0x" << hex << setw(16) 
      << setfill('0') << (unsigned long)truck << endl;

 cout << "See for yourself.  In the stack the items have high addresses." << endl
      << "In the heap the items have low addresses.  You can see where the static arrays are" << endl
      << "located and where the dynamic array is located." << endl << endl;

 cout << "Here is a display of the top of the stack.  The two static arrays are clearly visible in the stack." << endl
      << "But the one dynamic array is nowhere in sight" << endl;

 viewstack(10,0,16);

 cout << "Look closely.  You will see the data of the array house exactly where it should be in the stack followed by" 
      << endl << "the data of the array mess, which occupies one and a half qwords." << endl;

 cout << "The above shows where static arrays are stored, namely: in the AR of the function that created them" << endl
      << "But where are the dynamic arrays?" << endl;

 cout << "Here is a display of contiguous section of heap.  There is the missing dynamic array called truck." << endl;

 viewmemory(20,2,18,truck);

 cout << "Look at qwords beginning at offset = 0 and advancing to higher addresses.  There are the data elements of the" 
      << endl << "dynamic array truck each with a very low memory address." << endl; 

 return 0;
}//End of main.

