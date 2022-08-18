#! /bin/bash


t_file="${1:-test_file.txt}"
t_dir="${2:-test_dir}"

# IF OPTIONS: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

if [[ ! -d "$t_dir" ]]
then
    echo 'The current directory does not exist'
else
    echo 'The directory does exist'
    ls $t_dir
fi


if [[ ! -f "$t_file" ]]
then
    echo 'The current file does not exist'
else
    echo 'The file does exist'
    cat $t_file
fi
