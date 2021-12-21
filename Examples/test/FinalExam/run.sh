#!/bin/bash

#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out

#echo "Assemble compute.asm"
nasm -f elf64 -o compute.o compute.asm

#echo "Compile ispositivefloat.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o ispositivefloat.o ispositivefloat.cpp -std=c++17

#echo "Compile grosspay.c"
gcc -c -Wall -m64 -no-pie -o grosspay.o grosspay.c -std=c17

#echo "Link the object files"
gcc -m64 -no-pie -o a.out -std=c11 grosspay.o ispositivefloat.o compute.o

#echo "\n----- Run the program -----"
./a.out

#echo "----- End Program -----"