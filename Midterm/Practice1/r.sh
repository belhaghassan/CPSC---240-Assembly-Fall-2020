#echo "The script file for Sum of Integers - Array has begun"

#Program: Sum of Integers - Array
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

#echo "Assemble largest.asm"
nasm -f elf64 -l largest.lis -o largest.o largest.asm

#echo "Compile input_array.c"
gcc -c -Wall -m64 -no-pie -o input_array.o input_array.c -std=c11

#echo "Compile main.c"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11

#echo "Link the object files"
gcc -m64 -no-pie -o array.out -std=c11 input_array.o largest.o main.o 

#echo "Run the program Array Example:"
./array.out

