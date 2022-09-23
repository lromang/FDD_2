#! /bin/bash

read id
while !(cat links | grep $id)
do
    echo "not found"
    echo "these are the available bookshelfs: "
    cat links
    read id
    
done
echo "succes"


