rm *.o, *.out

echo "--------------------- START PROGRAM ---------------------\n\n"

#C++
g++ -c -g -Wall -m64 -no-pie -o ohm.o ohm.cpp -std=c++17

g++ -c -g -Wall -m64 -no-pie -o isfloat.o isfloat.cpp -std=c++17

g++ -c -g -Wall -m64 -no-pie -o show_resistance.o show_resistance.cpp -std=c++17


#ASM
nasm -g -F dwarf -f elf64 -o resistance.o resistance.asm

nasm -g -F dwarf -f elf64 -o read_clock.o read_clock.asm

nasm -g -F dwarf -f elf64 -o get_frequency.o get_frequency.asm

nasm -g -F dwarf -f elf64 -o compute_resistance.o compute_resistance.asm

nasm -g -F dwarf -f elf64 -o get_resistance.o get_resistance.asm



#Linker
g++ -m64 -no-pie -o a.out ohm.o isfloat.o show_resistance.o resistance.o get_resistance.o read_clock.o get_frequency.o compute_resistance.o

./a.out

echo "\n\n----------------------- END PROGRAM -----------------------"
