#!/bin/bashh

echo "Remoove old binary files if any still exist"
rm *.out
rm *.o

echo "Assemble thhe file viewstack.asm"
nasm -f elf64 -o view.o -l view.lis viewstack.asm

echo "Assemble the file stackdump.asm"
nasm -f elf64 -o dump.o -l dump.lis dumpstack.asm

echo "Compile the C++ file stack-driver.cpp"
g++ -c -m64 -std=c++98 -Wall -o drive.o  stack-driver.cpp -fno-pie -no-pie

#echo "Compile the file showgprs.asm"
#nasm -f elf64 -o showgprs.o showgprs.asm

echo "Link together the recently created object files"
g++ -m64 -std=c++98 -o go.out drive.o dump.o view.o -fno-pie -no-pie

echo "Run the program named View System Stack\n"
./go.out

echo "The Bash file has finished"

