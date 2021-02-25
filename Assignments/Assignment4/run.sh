#!/bin/bash

echo "Script file for Circumference of a Circle has begun"

#Program: Circumference of a Circle
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble circle.asm"
nasm -f elf64 -o circle.o circle.asm -gdwarf

echo "Compile circumference.c"
gcc -c -Wall -m64 -no-pie -o circumference.o circumference.c -std=c11 -g

echo "Link the object files"
gcc -m64 -no-pie -o a.out -std=c11 circle.o circumference.o -g

echo "\n----- Run the program -----"
gdb ./a.out

echo "------- End Program -------"