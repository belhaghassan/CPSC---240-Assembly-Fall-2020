/*

; Bilal El-haghassan - 887210292 - December 14, 2020

;********************************************************************************************
; Author Information:                                                                       *
; Name:         Bilal El-haghassan                CWID = 887210292                          *
; Email:        bilalelhaghassan@csu.fullerton.edu                                          *
; Institution:  California State University - Fullerton                                     *
; Course:       CPSC 240-05 Assembly Language                                               *
;                                                                                           *
;********************************************************************************************
; Copyright (C) 2020 Bilal El-haghassan                                                     *
; This program is free software: you can redistribute it and/or modify it under the terms   *
; of the GNU General Public License version 3 as published by the Free Software Foundation. *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;                                                                                           *
;********************************************************************************************
*/

#include<stdio.h>
#include<string>
#include<cctype>
#include<math.h>

extern "C" bool ispositivefloat(char[]);

bool ispositivefloat(char digit[]){
    bool trueNumber = true;
    unsigned int dots = 0;
    long unsigned startIndex = 0;      //Used for index in for loop

   
        //Checking for any '+' or '-' on first index
        if(digit[0] == '+'){      //If negative or positive sign located, shift index up    
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