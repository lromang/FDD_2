#! /bin/bash

num_bookshelves="${1:-10}"
total=$(psql -d fdd2db -c "select count(bookshelf_id) from bookshelf" | sed 's/[^0-9]*//g' | sed '/^[[:space:]]*$/d' | sed '$d')

if [[ -f bookshelfActive ]]
then
    rm bookshelfActive
fi

if [[ -f bookshelfActive2 ]]
then
    rm bookshelfActive2
fi


if [[ $num_bookshelves -gt $total || $num_bookshelves -lt 1  ]]
then
    echo "Debes ingresar un número válido"
else
	psql -d fdd2db -c "SELECT bookshelf_id, url FROM bookshelf order by RANDOM() limit $num_bookshelves" | sed '1d' | sed '1d' | sed 's| ||g' | head -n -2 > randomBookshelves
	while IFS= read -r  line
	do
   		link=$(echo $line | sed 's/.*|//')
   		id=$(echo $line | awk -F"|" '{print $1}') 
		curl $link > bookshelfActive
		while curl $link | grep -E "Go to the next page of result"; 
		do
    			link=$(cat bookshelfActive | grep "Go to the next page of result" | sed 's|<a title="Go to the next page of results." accesskey="+" href="||g' | sed 's|">Next</a>||g' | head -n 1 | awk '{print "https://www.gutenberg.org"$0}')
			cat bookshelfActive | sed -nE '/.li class="booklink"./,/Displaying results/p' | sed 's|</span>||g' | sed 's|<span class="cell content">||g' | sed 's|<span class="cell leftcell with-cover">||g' | sed 's|<li class="booklink">||g' | grep -v "img class" | sed 's|<a class="link" href="||g' | sed 's|<a class="link" href="||g' | sed 's|" accesskey="[0-9]">||g' | sed 's|<span class="title">||g' | sed 's|<span class="subtitle">||g' | sed 's|<span class="extra">||g' | sed 's| downloads||g' | sed 's| download||g' | sed 's|<span class="hstrut">||g' | awk '!/Displaying results/' | sed 's|<div class="padded">||g' | sed 's|<li class="statusline">||g' | sed 's|</li>||g' | sed 's|</a>||g' | sed 's|<span class="cell leftcell without-cover">||g' | sed 's|<span class="icon-wrapper">||g' | sed 's|<span class="icon icon_audiobook">||g'  | sed '/^$/d' | paste -sd '|' | sed  's|/ebooks/|\n/ebooks/|g' | sed '1d' | awk '{print "https://www.gutenberg.org"$0}' | sed '${s/$/|/}' | sed 's/.$//' | awk 'BEGIN { FS = "|" };{if (NF % 2) {print $1 "|" $2 "|SA|" $3} else {print $1 "|" $2 "|" $3 "|" $4}}' | sed -e "s/^/$id|/" >> bookshelfActive2
    			curl $link > bookshelfActive
		done
		cat bookshelfActive | sed -nE '/.li class="booklink"./,/Displaying results/p' | sed 's|</span>||g' | sed 's|<span class="cell content">||g' | sed 's|<span class="cell leftcell with-cover">||g' | sed 's|<li class="booklink">||g' | grep -v "img class" | sed 's|<a class="link" href="||g' | sed 's|<a class="link" href="||g' | sed 's|" accesskey="[0-9]">||g' | sed 's|<span class="title">||g' | sed 's|<span class="subtitle">||g' | sed 's|<span class="extra">||g' | sed 's| downloads||g' | sed 's| download||g' | sed 's|<span class="hstrut">||g' | awk '!/Displaying results/' | sed 's|<div class="padded">||g' | sed 's|<li class="statusline">||g' | sed 's|</li>||g' | sed 's|</a>||g' | sed 's|<span class="cell leftcell without-cover">||g' | sed 's|<span class="icon-wrapper">||g' | sed 's|<span class="icon icon_audiobook">||g'  | sed '/^$/d' | paste -sd '|' | sed  's|/ebooks/|\n/ebooks/|g' | sed '1d' | awk '{print "https://www.gutenberg.org"$0}' | sed '${s/$/|/}' | sed 's/.$//' | awk 'BEGIN { FS = "|" };{if (NF % 2) {print $1 "|" $2 "|SA|" $3} else {print $1 "|" $2 "|" $3 "|" $4}}' | sed -e "s/^/$id|/" >> bookshelfActive2
	done < randomBookshelves
fi

cat bookshelfActive2 | nl | sed 's/ //g' | sed -r 's/\s+/|/' | sed 's/\r/\\r/' > books

# ----------------------------------------
# Crear tabla 'catalog'
# ----------------------------------------

echo "Creating table catalog"
psql -d fdd2db -c "create table if not exists catalog (book_id serial primary key, bookshelf_id integer, url varchar(100), title varchar(400), author varchar(400), downloads integer)"
#Borrado los datos anteriores de la tabla
psql -d fdd2db -c "TRUNCATE catalog"

# ----------------------------------------
# Insertar datos de un archivo csv
# ----------------------------------------

echo "Populating table catalog"
psql -d fdd2db -c "\copy catalog from 'books' delimiter '|'"

# ----------------------------------------
# Percentiles en una vista
# ----------------------------------------
psql -d fdd2db -c "drop view if exists percentil"
psql -d fdd2db -c "create view percentil as select book_id, bookshelf_id, url, title, author, downloads, ntile(100) over (order by downloads) percentil from catalog"
psql -d fdd2db -c "select * from percentil"
