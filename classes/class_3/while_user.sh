#! /bin/bash


echo 'Please enter a number greater than 5 multiple of 3: '
read test

# [[]] || [[]] && 
while [[ $test -lt 5 ]] || (($test % 3 != 0))
do
    echo 'Please enter a number greater than 5 multiple of 3: '
    read test
done

echo 'Success'
