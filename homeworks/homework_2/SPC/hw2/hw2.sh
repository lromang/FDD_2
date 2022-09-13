#! /bin/bash

echo -e $1 |awk '{if(/^[a-zA-Z ]+$/) 
{if(!(NF%2)) {sum_length=0; for(i=1; i<=NF; i++) sum_length+=length($i); printf("\nMean: %.2f", (sum_length/NF))} else {print "\nCentral world length: ", length($(NF/2+1))}} 
else if(/^[0-9 ]+$/) {suma=0;for(i=1;i<=NF;i++) suma+=int($i); printf("\nMean: %.2f", (suma/NF))} 
else {printf "\nERROR"}}'
