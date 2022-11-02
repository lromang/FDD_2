#! /bin/bash

users=${1:-1000}
if [[ $users -le 10000 ]]
then
 for i in $(seq $users); do letters=$(for letter in {a..z}; do echo $letter; done | tr '\n' ' ');
 query=$(echo $i | awk -v letters="$letters" -v v_index="$i" "BEGIN{srand(v_index)}; {split(letters, list_letters); for(i=0; i < 5 + (rand()*100 % 5); i++)
 r_word=r_word list_letters[int(rand()*length(list_letters)) + 1];
 printf(r_word)}"); echo $query; done | nl | sed 's/ //g' | sed -r 's/\s+/|/' > user.csv

else
    echo 'error, selecciona algo menor a 10,000'

fi

# ----------------------------------------
# Crear tabla 'users'
# ----------------------------------------

echo "Creating table users"
psql -d fdd2db -c "create table if not exists users (user_id serial primary key, name varchar(15))"
#Borrado los datos anteriores de la tabla
psql -d fdd2db -c "TRUNCATE users"

# ----------------------------------------
# Insertar datos de un archivo csv
# ----------------------------------------

echo "Populating table users"
psql -d fdd2db -c "\copy users from 'user.csv' delimiter '|'"
