#Program Name        : Run
#Programming Language: Bash
#Program Description : This file is responsible for compiling, assembling,
#                      and linking all the files in this project. It creates a
#                      single executeable file and runs it.
#
#Author              : Aaron Lieberman
#Email               : AaronLieberman@csu.fullerton.edu
#Institution         : California State University, Fullerton
#
#Copyright (C) 2020 Aaron Lieberman
#This program is free software: you can redistribute
#it and/or modify it under the terms of the GNU General Public License
#version 3 as published by the Free Software Foundation. This program is
#distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
#without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A
#PARTICULAR PURPOSE. See the GNU General Public License for more details.
#A copy of the GNU General Public License v3 is available here:
#<https://www.gnu.org/licenses/>.


echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble clock_speed.asm"
nasm -f elf64 -l clock_speed.lis -o clock_speed.o clock_speed.asm

echo "Compile main.c"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11

echo "Link the object files"
g++ -m64 -no-pie -o a.out -std=c11 main.o manager.o clock_speed.o

echo "----- Run the program -----"
./a.out
echo "----- Program finished -----"
rm *.o
rm *.out
rm *.lis
