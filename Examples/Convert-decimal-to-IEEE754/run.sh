#/bin/bash

#Program: Convert Decimal to IEEE754
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Compile the source file conversion.cpp with g++"
g++ -c -m64 -Wall -no-pie -o conversion.o -std=c++17 conversion.cpp


echo "Link system module to conversion.o to create an executable file: conv.out"
g++ -m64 -no-pie -o conv.out conversion.o -std=c++17


echo "Execute the program that converts decimal input into IEEE754 output"
./conv.out

echo "This bash script will now terminate."




#Footnote: in 2011 GNU created an extension to the gcc standard of 2011.  To compile with that extended standard use a statement such as the one below.
#gcc -c -Wall -m64 -no-pie -o current-time.o current-time.c -std=gnu11       Note the uncommon standard "GNU of 2011"
