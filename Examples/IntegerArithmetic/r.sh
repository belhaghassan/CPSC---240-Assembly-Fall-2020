#!/bin/bash

#Program: Integer Arithmetic
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "The script file for Program Integer Arithmetic has begun"

echo "Assemble arithmetic.asm"
nasm -f elf64 -l arithmetic.lis -o arithmetic.o arithmetic.asm

echo "Compile integerdriver.c"
gcc -c -Wall -m64 -no-pie -o integerdriver.o integerdriver.c -std=c11

echo "Link the object files"
gcc -m64 -no-pie -o math.out -std=c11 arithmetic.o integerdriver.o

echo "Run the program Integer Arithmetic:"
./math.out

echo "The script file will terminate"




#Summary
#The module arithmetic.asm contains PIC non-compliant code.  The assembler outputs a non-compliant object file.

#The C compiler is directed to create a non-compliant object file.

#The linker received a parameter telling the linker to expect non-compliant object files, and to output a non-compliant executable.

#The program runs successfully.
