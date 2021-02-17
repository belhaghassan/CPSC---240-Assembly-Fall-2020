#!/bin/bash

#Author: F. Holliday
#Program: Exponential Expressions

echo "Exponential Expressions"

nasm -f elf64 -l exponential-expressions.lis -o exponential-expressions.o exponential-expressions.asm

g++ -c -m64 -Wall -std=c++14 -o exponential-expressions-driver.o exponential-expressions-driver.cpp -fno-pie -no-pie

g++ -m64 -o exponential-expressions.out exponential-expressions.o exponential-expressions-driver.o -fno-pie -no-pie -std=c++14

./exponential-expressions.out
