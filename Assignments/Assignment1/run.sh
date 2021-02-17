rm *.o
rm *.out
echo "Assemble circle.asm"
nasm -f elf64 -l circle.lis -o circle.o circle.asm
echo "Compile main.c"
gcc -c -Wall -m64 -no-pie -o egyptian.o egyptian.c -std=c11
echo "Link the object files"
gcc -m64 -no-pie -o a.out -std=c11 circle.o egyptian.o
echo "----- Run the program -----"
./a.out
echo "----- Program finished -----"
