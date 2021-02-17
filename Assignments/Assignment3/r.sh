#!/bin/bash

#echo "The script file for Sorting Array has begun"

#Program: Sorting Array
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

#echo "Compile main.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o main.o main.cpp -std=c++17

#echo "Compile display_array.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o display_array.o display_array.cpp -std=c++17

#echo "Compile isinteger.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o isinteger.o isinteger.cpp -std=c++17

#echo "Compile bubble_sort.c"
gcc -c -Wall -m64 -no-pie -o bubble_sort.o bubble_sort.c -std=c11

#echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

#echo "Assemble input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

#echo "Assemble swap.asm"
nasm -f elf64 -l swap.lis -o swap.o swap.asm

#echo "Assemble read_clock.asm"
nasm -f elf64 -l read_clock.lis -o read_clock.o read_clock.asm

#echo "Assemble atolong.asm"
nasm -f elf64 -l atolong.lis -o atolong.o atol.asm

#echo "Link the object files"
gcc -m64 -no-pie -o array.out -std=c11 main.o manager.o input_array.o swap.o isinteger.o atolong.o display_array.o bubble_sort.o read_clock.o

#echo "Run the program Sorting Array Example:"
./array.out