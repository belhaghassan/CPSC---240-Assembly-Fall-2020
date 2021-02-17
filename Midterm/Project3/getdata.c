

#include<stdio.h>


int getdata(long int []);

int getdata(long int array[]){
  long int value;
  int size = 0;

  while(scanf("%ld",&value)!=EOF && size <= 100){      //Checking for ctrl+D
    array[size] = value;
    ++size;
  }

  return size;
}