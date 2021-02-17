#!/bin/bash

#echo "The script file for Harmonic Sum has begun"

#Program: Harmonic Sum
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out

#echo "Assemble manager.asm"
nasm -f elf64 -o manager.o manager.asm

#echo "Assemble clock_speed.asm"
nasm -f elf64 -o clock_speed.o clock_speed.asm

#echo "Assemble read_clock.asm"
nasm -f elf64 -o read_clock.o read_clock.asm

#echo "Compile main.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o main.o main.cpp -std=c++17

#echo "Link the object files"
gcc -m64 -no-pie -o a.out -std=c11 main.o read_clock.o manager.o clock_speed.o

#echo "\n----- Run the program -----"
./a.out

#echo "----- End Program -----"