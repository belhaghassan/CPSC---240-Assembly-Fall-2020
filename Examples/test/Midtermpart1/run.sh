#!/bin/bash

#Author: Floyd Holliday
#Program name: Where are arrays

rm *.o, *.lis, *.out
echo " " #Blank line

echo "This program Array Sample Program is compiled without PIC (Position Independent Code)."
echo "The C++ compiler command and the linker command both include switches to turn off PIC."
echo "This program was tested successfully in a distro post-October 2017, and should operate successfully in other distros as well."

#echo "Assemble the X86 file arrays-x86.asm"
#nasm -f elf64 -l arrays-x86.lis -o arrays-x86.o arrays-x86.asm

echo "Compile the C++ file array_location.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o array_location.o array_location.cpp -std=c++14

nasm -f elf64 -o dump.o -l dump.lis viewstack.asm

nasm -f elf64 -o view.o -l viewmemory.lis viewmemory.asm

echo "Link the 'O' file(s) array_location.o"
g++ -m64 -fno-pie -no-pie -o array.out array_location.o dump.o view.o -std=c++14

echo "Run the program Where are the arrays"
./array.out

echo "This Bash script file will now terminate.  Bye."


