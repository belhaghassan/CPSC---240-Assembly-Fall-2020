#!/bin/bash

#Program: Validate Integer Input
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Bash: The script file for Validate Integer Input has begun"

echo "Bash: Compile isinteger.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o scan.o isinteger.cpp -std=c++17

echo "Bash: Assemble test-validation.asm"
nasm -f elf64 -o valid.o test-validation.asm

echo "Bash: Compile validate-driver.c"
g++ -c -m64 -Wall -fno-pie -no-pie -o drive.o validate-driver.cpp -std=c++17

echo "Bash: Link the object files"
g++ -m64 -fno-pie -no-pie -o code.out -std=c++17 scan.o valid.o drive.o

echo "Bash: Run the program Validate Integer Input:"
./code.out

echo "The script file will terminate"




#Summary
#The module arithmetic.asm contains PIC non-compliant code.  The assembler outputs a non-compliant object file.

#The C compiler is directed to create a non-compliant object file.

#The linker received a parameter telling the linker to expect non-compliant object files, and to output a non-compliant executable.

#The program runs successfully.
