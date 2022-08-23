#! /bin/bash

id="${1: -0}"

if grep -Fq "$1" links
then
echo "succes"
else
echo "not found"
echo "these are the available bookshelfs: "
cat links
fi
