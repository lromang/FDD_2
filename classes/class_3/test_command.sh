#! /bin/bash


if [[ 'a' == $(echo 'hah' | grep -Eo 'a') ]]
then
    echo 'matches instruction'
fi
