#!/bin/bash

#Author: Floyd Holliday
#Program name: Return Data to Caller
#Language: Bash
#Date of last upgrade to this file: 2019-December-15

rm *.o, *.lis, *.out

echo "Assemble the X86 file numericmain.asm"
nasm -f elf64 -l nnumeric.lis -o numeric.o numericmain.asm

echo "Compile the C file numericdecomposition.c"
gcc -c -m64 -Wall -std=c11 -o numeric_d_com.o -no-pie numericdecomposition.c

echo "Link the 'O' files numeric.o, numeric_d_com.o"
gcc -m64 -std=c11 -no-pie -o decomposition.out numeric.o numeric_d_com.o

echo "Run the Control-d program"
./decomposition.out




#This author still uses the old "C 2011" standard out of old habit.  The reader of this message may wish to upgrade to a newer C language.
