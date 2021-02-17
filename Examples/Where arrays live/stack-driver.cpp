//Author name: Floyd Holliday
//Author email: holliday@fullerton.eduu

//Program name: View System Stack
//Programming languages: C++ (driver), X86 (algorithm)
//Date program began: April 2, 2017
//Date of last update: February 1, 2019
//Files in this program: stack-driver.cpp, stackdump.asm, r.sh
//Status: Done.  No more work will be done on this program apart from fixing any reported errors.

//References: Jorgensen, X86-64 Assembly Language Programming with Ubuntu

//Purpose: Show how a C++ programmer can call a program to display the contents of the system stack.

//This file name: stack-driver.cpp
//Compile: g++ -c -m64 -std=c++98 -Wall -o drive.o  stack-driver.cpp -fno-pie -no-pie
//Link:    g++ -m64 -std=c++98 -o go.out drive.o dump.o -fno-pie -no-pie

#include <iostream>
#include "stdlib.h"
using namespace std;

//Prototype:
extern "C" unsigned long dumpstack(long,long unsigned int,long unsigned int,void *);
//The first input parameter is an arbitrary integer chosen by the programmer or the user.
//The second parameter is the number of qwords inside the stack to be displayed.
//The third parameter is the number of qwords outside the stack to be displayed.
//The fourth parameter is the memory address where this stack dump will be focused.

extern "C" unsigned long viewstack(long,unsigned long,unsigned long);
//The first input parameter is an arbitrary integer chosen by the programmer or the user.
//The second parameter is the number of qwords inside the stack to be displayed.
//The third parameter is the number of qwords outside the stack to be displayed.
//The output is always centered on rsp.


//The variables used in this C++ main function have no importance other than their values will apppear in the displayed stack.
int main(int argc, char* argv[])
{long int r=11;
 long int s=12;
 long int n=13;
 long int value_from_dumpstack=200;  //200 = 0xc8;
 long int myarray[4] = {1,2,3,4};

//Question 1: Where are the contents of myarray when the subfunction dumpstack is called?
 cout << "The static array myarray begins at this address = " << hex << (long unsigned int)myarray << endl;
 value_from_dumpstack = dumpstack(100,18,8,myarray);  //The array's name holds a pointer to the first element of the array.
 cout << "Value returned from dumpstack 100 = value on top of the stack = address of next instruction " << " = 0x" << hex << value_from_dumpstack << endl;
 cout << endl;

//Declare some static junk data.  Watch where they will be saved -- space has been saved in the AR for these data -- they will replace junk data in the AR.
long a = 21;
long b = 22;
long c = 23;
long d = 24;
long e = 25;
long f = 26;
long g = a+b+c+d+e+f;

//Question 2: Where are the contents of array goodbye when the subfunction dumpstack is called?
 char goodbye[] = "ABCDEFG";  //Seven bytes + null char = 1qword exactly.  That is good for testing.
 cout << "The static array goodbye begins at this address = " << hex << (long unsigned int)goodbye << endl; 
 value_from_dumpstack = dumpstack(200,22,4,goodbye);  //The array's name holds a pointer to the first element of the array.
 cout << "Value returned from dumpstack 200 = value on top of the stack = address of next instruction" << " = 0x" << hex << value_from_dumpstack << endl;
 cout << endl;

//Question 3: Where are the contents of dynamic array p when the subfunction dumpstack is called?
 cout << "Enter the number of cells in array p -- please no large numbers: ";
 cin >> n;
 long int * p = new long int[n];
 for (r=0;r<n;r++) p[r] = 3*(r+1);
 cout << "The dynamic array p begins at this address = " << hex << (long unsigned int)p << endl;
 value_from_dumpstack = dumpstack(300,10,n+2,p);
 cout << "Value returned from dumpstack 300 = value on top of the stack = address of next instruction" << " = 0x" << hex << value_from_dumpstack << endl;
 cout << "The above is an image of heap space where the array p is stored.  Now view the AR that created p.  Look for the address of p in the AR" << endl;
 viewstack(301,4,28);
 cout << endl;

//Question 4: Suppose we create another dynamic array q.  Where will C++ place this array?  Near the array p?
 cout << "Enter the number of cells in array q -- please no large numbers: ";
 cin >> s;
 long int * q = new long int[s];
 for (r=0;r<s;r++) q[r] = 4*(r+1);
 cout << "The dynamic array q begins at this address = " << hex << (long unsigned int)q << endl;
 value_from_dumpstack = dumpstack(400,20,s+2,q);
 cout << "Value returned from dumpstack 400 = value on top of the stack = address of next instruction" << " = 0x" << hex << value_from_dumpstack << endl;
//Answer: Yes.  q follows immediatelly after p.
 cout << "The above is an image of heap space where the array q is stored.  Now view the AR that created q.  Look for the address of q in the AR" << endl;
 viewstack(401,4,20);
 cout << endl;




/////There are other questions for research into the nature of arrays, but those topics will have to wait for another day.
//Below are questions to research.  The answers should be found.

//Question 5: Let's deallocate the q array.  What happens to the space formerlly occupied by array q?
// delete [] q;
//It appears that delete [] <dynamic-array> set the first element of the array to 0.  That's not enough to delete the array!

//Question 6: Suppose we dynamically allocate an array with the traditional allocator function.  Where is the array placed?
// cout << "Enter the number of cells in array m -- please no large numbers: ";
// cin >> s;
// long int * m = (long int *)calloc(s,8);    //s = #cells, 8 = size of each cell = 1 qword
// cout << "Value returned from dumpstack 600 = " << dec << value_from_dumpstack << " = 0x" << hex << value_from_dumpstack << endl;

//Question 7: Next attempt to delete the array m usine the traditional "free".  Does it do anything?
// free(m);
// cout << "Value returned from dumpstack 700 = " << dec << value_from_dumpstack << " = 0x" << hex << value_from_dumpstack << endl;

//Question 8: Suppose a new dynamic array is created of size less than or equal to s =size of the previous array.  Does the allocator calloc re-use the space of the now deleted array?


 cout << "g = " << dec << g << " Goodbye" << endl;
 return 0;
}
 

//The stack frame ends with the qword containing the next instruction to execute after control returns to the caller.
//Notice that the stack frame always ends off the 16-byte boundary.  The reason is that the next frame begins on a 16-byte boundary.

//Where does the stack frame begin?  That is harder to pin point.  You might try to identify the end of the previous stack frame in order to 
//find the start of the current stack frame.
