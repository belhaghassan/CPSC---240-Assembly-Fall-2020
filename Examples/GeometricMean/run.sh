#!/bin/bash

#Author: Floyd Holliday
#Program name: Geometric Mean
#License: GPL3, an open source license for software.

rm *.o, *.lis, *.out
echo " " #Blank line

echo "This program Geometric Mean is compiled without PIC (Position Independent Code)."
echo "The C++ compiler and the C compiler are configured to turn off PIC."
echo "This program was tested successfully in a distro post-October 2017, and should operate successfully in other distros as well."

echo "Assemble the X86 file geometric-controller.asm"
nasm -f elf64 -l control.lis -o control.o geometric-controller.asm

echo "Compile the C file harmonic-main.c"
gcc -c -m64 -Wall -fno-pie -no-pie -o geometric-main.o geometric-main.c -std=c11

echo "Compile the C++ file fill_array.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o fill.o fill_array.cpp -std=c++14

echo "Compile the C file display.c"
gcc -std=c11 -c -m64 -Wall -fno-pie -no-pie -o display.o display.c

echo "Link the 'O' files arrays-main.o and arrays-x86.o"
g++ -m64 -fno-pie -std=c++14 -no-pie -o har.out geometric-main.o control.o fill.o display.o

echo "Run the program Floating Point Input Output"
./har.out


