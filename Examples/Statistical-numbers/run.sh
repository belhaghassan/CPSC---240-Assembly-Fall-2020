#!/bin/bash

#Author: F. Holliday
#Author email: holliday@fullerton.edu

#Program name: Statistical Numbers
#Programming languages: C++ and X86
#Date of last modification: 2019-Sep-08
#Files in the program: stats.cpp, statistics.asm, run.sh




echo "Remove old un-needed files"
rm *.o
rm *.out

echo "Assemble the program statistics.asm."
nasm -f elf64 -l statistics.lis -o statistics.o statistics.asm

echo "Compile the C++ main function according to C++ standard 2014"
g++ -c -Wall -std=c++14 -o stats.o -m64 -no-pie -fno-pie stats.cpp

echo "Link 2 object files"
g++ -m64 -std=c++14 stats.o -fno-pie -no-pie -o stats.out statistics.o

echo "Run the program \"Statistical Numbers\""
./stats.out

echo "The bash file has terminated."
