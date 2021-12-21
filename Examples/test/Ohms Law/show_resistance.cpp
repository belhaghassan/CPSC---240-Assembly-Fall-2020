#include<stdio.h>

extern "C" void show_resistance(double [], long);

void show_resistance(double arr[], long size){

    for(long i = 0; i < size; ++i){                  //Printing each content of inputted array 
        printf("%lf ", arr[i]);
    }
    printf("\n");
}