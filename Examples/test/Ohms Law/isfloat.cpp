//===============================================START OF MODULE=========================================================================
#include<stdio.h>
#include<string>
#include<cctype>
#include<math.h>

extern "C" bool isfloat(char[]);

bool isfloat(char digit[]){
    bool trueNumber = true;
    unsigned int dots = 0;
    long unsigned startIndex = 0;      //Used for index in for loop

   
        //Checking for any '+' or '-' on first index
        if(digit[0] == '-' || digit[0] == '+'){      //If negative or positive sign located, shift index up    
            startIndex++;
        }
        else if (!isdigit(digit[0])){
            trueNumber = false;
        }

        while(digit[startIndex] != '\0'){
            if(!isdigit(digit[startIndex])){
                if(digit[startIndex] == '.'){
                    //Decimal point found
                    dots++; 
                    if(dots > 1) trueNumber = false;        //If more than one decimal point is inputted. 
                }
                else trueNumber = false;
            }
            startIndex++;
        }
        
    return trueNumber;
}
//===============================================END OF MODULE============================================================================