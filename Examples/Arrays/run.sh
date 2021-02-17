#!/bin/bash

#Author: Floyd Holliday
#Program name: Array Passing Demonstration

rm *.o, *.lis, *.out
echo " " #Blank line

echo "This program Array Sample Program is compiled without PIC (Position Independent Code)."
echo "The C++ compiler command and the linker command both include switches to turn off PIC."
echo "This program was tested successfully in a distro post-October 2017, and should operate successfully in other distros as well."

echo "Assemble the X86 file arrays-x86.asm"
nasm -f elf64 -l arrays-x86.lis -o arrays-x86.o arrays-x86.asm

echo "Compile the C++ file array-main.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o arrays-main.o arrays-main.cpp

echo "Link the 'O' files arrays-main.o and arrays-x86.o"
g++ -m64 -std=c++14 -fno-pie -no-pie -o array.out arrays-main.o arrays-x86.o

echo "Run the program Floating Point Input Output"
./array.out

echo "This Bash script file will now terminate.  Bye."


