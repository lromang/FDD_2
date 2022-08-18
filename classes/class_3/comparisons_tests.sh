#! /bin/bash


# Arithmetic: gt, ge, lt, le, eq, ne
if [[ $1 -gt $2 ]]
then
    echo "$1 is greater than $2"
elif [[ $1 -lt $2 ]]
then
    echo "$2 is greater than $1"
else
    echo "$1 equals $2"
fi


# Strings: ==, !=, <, >
if [[ "$1" == "$2" ]]
then
    echo "$1 == $2"
else
    echo "$1 != $2"
fi
