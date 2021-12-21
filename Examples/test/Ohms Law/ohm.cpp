#include<stdio.h>

extern "C" double resistance();

int main(){
    double answer;

    printf("Welcome to Parallel Circuits by Justin Bui\n");
    printf("This program will automate finding the resistance in a large circuit\n\n");
    answer = resistance();
    printf("Main received this number: %lf\n", answer);
    printf("Main will now return 0 to the operating system.");

    return 0;
}