#! /bin/bash

echo 'Please write the id you want to download'

read varnum

until [[ $(cat pag_gu.txt | gsed -n "/^$varnum$/p") == "$varnum" ]]
do
  echo 'Error. This id doesn´t exist in the file. Look the catalogue';
  cat pag_gu.txt
  echo 'Write the id again'
  read varnum
done
  echo 'Succes'
  exit

