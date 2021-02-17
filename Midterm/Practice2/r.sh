#echo "The script file for Sum of Integers - Array has begun"

#Program: Sum of Integers - Array
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

#echo "Assemble control.asm"
nasm -f elf64 -l control.lis -o control.o control.asm

#echo "Compile input_array.c"
gcc -c -Wall -m64 -no-pie -o input_array.o input_array.c -std=c11

#echo "Assemble lengthsquared.asm"
nasm -f elf64 -l lengthsquared.lis -o lengthsquared.o lengthsquared.asm

#echo "Assemble output_array.asm"
nasm -f elf64 -l output_array.lis -o output_array.o output_array.asm

#echo "Compile operator.c"
gcc -c -Wall -m64 -no-pie -o operator.o operator.c -std=c11

#echo "Link the object files"
gcc -m64 -no-pie -o array.out -std=c11 operator.o control.o input_array.o lengthsquared.o output_array.o

#echo "Run the program Array Example:"
./array.out

