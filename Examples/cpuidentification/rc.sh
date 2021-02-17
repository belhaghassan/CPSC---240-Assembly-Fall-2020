#!/bin/bash

#Author: Floyd Holliday
#Program name: Processor Identification
#Author mail: holliday@fullerton.edu

rm *.o
rm *.out

echo "This is program <CPU Identtification>"
echo "This program is built using the C++ linker"

echo "Assemble the module cpuidentify.asm"
nasm -f elf64 -l cpuidentify.lis -o cpuidentify.o cpuidentify.asm

echo "Compile the C module cpuidentification.c"
gcc -c -m64 -Wall -std=c11 -o cpuidentification.o cpuidentification.c -fno-pie -no-pie

echo "Use the C linker to create the executable file."
gcc -m64 -std=c11 -o cpu.out cpuidentification.o cpuidentify.o -fno-pie -no-pie

echo "Execute the program CPU Identification"
./cpu.out

echo "The bash script file is now closing."
