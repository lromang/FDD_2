#! /bin/bash

# ----------------------------------------
# Filtrar url y títulos de los libros
# ----------------------------------------

file="${1:-bookshelves.csv}"

if [[ ! -f "$file" ]]
then
    curl https://www.gutenberg.org/ebooks/bookshelf/ | sed -nE '/.bookshelf_pages./,/.content ending./{/.li./p}' | grep -oP '(?<=").*(?=")' | sed 's/\"//g' | sed 's/title=//' | sed -r 's/\s+/|/' | awk '{print "https://www.gutenberg.org"$0}' | nl | sed 's/ //g' | sed -r 's/\s+/|/'  > bookshelves.csv
fi

# ----------------------------------------
# Crear tabla 'bookshelf'
# ----------------------------------------

echo "Creating table bookshelf"
psql -d fdd2db -c "create table if not exists bookshelf (bookshelf_id serial primary key, url varchar(100), title varchar(100))"

# ----------------------------------------
# Insertar datos de un archivo csv
# ----------------------------------------

echo "Populating table bookshelf"
psql -d fdd2db -c "\copy bookshelf from 'bookshelves.csv' delimiter '|'"

