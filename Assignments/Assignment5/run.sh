#!/bin/bash

echo "The script file for Area of a Triangle has begun"

#Program: Area of a Triangle
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble area.asm"
nasm -f elf64 -l area.lis -o area.o area.asm

echo "Compile triangle.c"
gcc -c -Wall -m64 -no-pie -o triangle.o triangle.c -std=c17

echo "Compile ispositivefloat.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o ispositivefloat.o ispositivefloat.cpp -std=c++17

echo "Link the object files"
gcc -m64 -no-pie -o a.out -std=c11 area.o triangle.o ispositivefloat.o

echo "\n----- Run the program -----"
./a.out

echo "----- End Program -----"