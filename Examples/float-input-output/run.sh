#!/bin/bash

#Program: Floating IO
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble float-input-output.asm"
nasm -f elf64 -l float-input-output.lis -o float-input-output.o float-input-output.asm -g -gdwarf

echo "Compile manage-floats.c using the gcc compiler standard 2011" 
gcc -c -Wall -m64 -no-pie -o manage-floats.o manage-floats.c -std=c11 -g

echo "Link the object files using the gcc linker standard 2011"
gcc -m64 -no-pie -o three-numbers.out manage-floats.o float-input-output.o -std=c11 -g

echo "Run the program Floating IO:"
gdb ./three-numbers.out

echo "The script file will terminate"





