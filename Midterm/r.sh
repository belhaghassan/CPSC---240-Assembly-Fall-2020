#!/bin/bash

#echo "The script file for Reverse Array has begun"

#Program: Reverse Array
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

#echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

#echo "Assemble input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

#echo "Assemble swap.asm"
nasm -f elf64 -l swap.lis -o swap.o swap.asm

#echo "Assemble reverse.asm"
nasm -f elf64 -l reverse.lis -o reverse.o reverse.asm

#echo "Assemble read_clock.asm"
nasm -f elf64 -l read_clock.lis -o read_clock.o read_clock.asm

#echo "Assemble atolong.asm"
nasm -f elf64 -l atolong.lis -o atolong.o atol.asm

#echo "Compile display_array.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o display_array.o display_array.cpp -std=c++17

#echo "Compile isinteger.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o isinteger.o validate-decimal-digits.cpp -std=c++17

#echo "Compile main.c"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11

#echo "Link the object files"
gcc -m64 -no-pie -o array.out -std=c11 main.o reverse.o manager.o input_array.o swap.o isinteger.o atolong.o display_array.o read_clock.o

#echo "Run the program Array Example:"
./array.out
