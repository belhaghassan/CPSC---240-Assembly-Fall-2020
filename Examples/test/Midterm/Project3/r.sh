#echo "The script file for Sum of Integers - Array has begun"

#Program: Sum of Integers - Array
#Author: Bilal El-haghassan

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

#echo "Assemble manage.asm"
nasm -f elf64 -l manage.lis -o manage.o manage.asm

#echo "Compile getdata.c"
gcc -c -Wall -m64 -no-pie -o getdata.o getdata.c -std=c11

#echo "Assemble reverse.asm"
nasm -f elf64 -l reverse.lis -o reverse.o reverse.asm

#echo "Assemble showarray.asm"
nasm -f elf64 -l showarray.lis -o showarray.o showarray.asm

#echo "Compile main.c"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11

#echo "Link the object files"
gcc -m64 -no-pie -o array.out -std=c11 main.o manage.o getdata.o reverse.o showarray.o

#echo "Run the program Array Example:"
./array.out

