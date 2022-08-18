#! /bin/bash


pattern="^H[a-z\ ]+!$"
if [[ $1 =~ $pattern ]]
then
    echo "$1 matches pattern"
else
    echo "$1 doesn't match the pattern"
fi
