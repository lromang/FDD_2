#! /bin/bash
tables=("books" "catalog" "cart" "client")
num_bookshelfs="${1:-10}"
num_personas="${2:-1000}"
cuenta_books=$(cat populate_catalog.sql | wc -l)
if [[($num_personas -ge 10  &&  $num_personas -le 10000) &&  ($num_bookshelfs -ge 1  &&  $num_bookshelfs -le $cuenta_books)]]
then 
   		# Drop tables
		# Just iterating over an array
		# do not worry about this.
		for table in ${tables[@]}
		do
			echo "Dropping table $table"
			psql -d fdd2db -q -c "drop table if exists $table cascade"
		done
		psql -d fdd2db -q -f funciones_sql.sql
		psql -d fdd2db -q -c "create table catalog (id_bookshelf serial, title text , url text, percentil int );"
		psql -d fdd2db -q -c "create table books (id_book serial,bookshelf_id int, link text, title text, author text, downloads int, percentil int);"
		psql -d fdd2db -q -c "create table client (id_user serial, name varchar(15));"
		psql -d fdd2db -q -c "create table cart (id_cart serial,id_book int, id_user int, purchased_at timestamp);"

		sh populate_catalog.sh
		psql -d fdd2db -q -f populate_catalog.sql
		psql -d fdd2db -t  -c  "select * from sample_n_bookshelfs("$num_bookshelfs") ;" | awk '{print $1}'| xargs -L 1 sh get_bookshelf_books
		numero_libros=$(psql -d fdd2db -t  -c  "select count(*) from books ;" | awk '{ print $1}')
		momento_inicio=$(date --date='1/1/2020' +"%s")
		for i in $(seq $num_personas)
		do
			name=""
			for b in $(seq $((5 + $RANDOM % 11)))
			do
				# Make sure program is interpreted as string.
				name+=$(printf "\\$(printf '%03o' "$((97 + $RANDOM % 26))")")
			done
			psql -d fdd2db -q -c "insert into client (name) values ('$name')"
			momento=$(echo $(($(date +%s%N)/1000000000)))
			momento=$((momento_inicio + $RANDOM * 100000 % ($momento-$momento_inicio)))
			for b in $(seq $((1 + $RANDOM % 10)))
				do
					id_libro=$((1 + $RANDOM % $numero_libros))
				psql -d fdd2db -q  -c "insert into cart (id_book,id_user,purchased_at) values ($id_libro,$i,to_timestamp($momento));"
				done
		done

		psql -d fdd2db -tA -c "select * from reporte_recompra();" > datos2.csv && python3 graficar.py

else
    echo "Ingreso de número de usuarios y/o librerias  inválido"
fi
