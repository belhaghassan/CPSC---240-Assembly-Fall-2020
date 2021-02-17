

#include<stdio.h>

int input_array(long int []);

int input_array(long int array[]){
  long int value;
  int size = 0;

  while(scanf("%ld",&value)!=EOF && size <= 20){      //Checking for ctrl+D
    array[size] = value;
    ++size;
  }

  return size;
}