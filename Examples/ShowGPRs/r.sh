#!/bin/bash

#Program: Volatility Test of GPRs across printf
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Bash: The script file for Input Integer Validation has begun"

echo "Assemble the utility program Show GPRS"
nasm -f elf64 -o gprs.o -l showgprs.lis showgprs.asm

echo "Bash: Compile the C++ function isinteger" 
g++ -c -m64 -Wall -fno-pie -no-pie -o digits.o validate-decimal-digits.cpp -std=c++17
#References regarding "-no-pie" see Jorgensen, page 226.

echo "Bash: Assemble arithmetic.asm"
nasm -f elf64 -o arithmetic.o arithmetic.asm

echo "Bash: Assemble atol.asm"
nasm -f elf64 -o atol.o atol.asm

echo "Bash: Compile integerdriver.c"
gcc -c -Wall -m64 -no-pie -o integerdriver.o integerdriver.c -std=c18

echo "Bash: Link the object files"
g++ -m64 -no-pie -o valid.out -std=c++17 arithmetic.o integerdriver.o digits.o atol.o gprs.o

echo "Bash: Run the program Integer Arithmetic:"
./valid.out

echo "The script file will terminate"



