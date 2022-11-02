#! /bin/bash

if [[ -f cart.csv ]]
then
    rm cart.csv
fi

if [[ -f datos_grafica ]]
then
    rm datos_grafica
fi

if [[ -f actual ]]
then
    rm actual
fi

cart_id=1
while IFS= read -r  line
do
	iduser=$(echo $line | awk -F"|" '{print $1}')
	date=$(python ./fechapython.py)
	psql -d fdd2db -c "SELECT book_id, percentil FROM percentil order by RANDOM() limit $(((RANDOM%10)+1))" | sed '1d' | sed '1d' | sed 's| ||g' | head -n -2 > actual
	prom=$(bash ./promedio.sh)
        exp=$(python ./exp_delta.py $prom $date)
        date2=$(echo $exp | cut -f1 -d" " | awk 'NR==1 {print; exit}')
        delta=$(echo $exp | awk '{print $3}')
	cat actual | sed "s/^/|$iduser|/g" | sed "s/$/|$date/g" | sed "s/^/$cart_id/g" | sed "s/$/|$delta/g" >> cart.csv
	cat cart.csv | grep "$iduser.*$date" | sed "s|$date|$date2|g" >> cart.csv
	cart_id=$((cart_id + 1))
done < user.csv

cat cart.csv | nl | sed 's/ //g' | sed -r 's/\s+/|/' > cart
# ----------------------------------------
# Crear tabla 'cart'
# ----------------------------------------

echo "Creating table cart"
psql -d fdd2db -c "create table if not exists cart (id serial primary key, cart_id integer, user_id integer, product_id integer, percentil integer, purchase_date date, delta integer)"
#Borrado los datos anteriores de la tabla
psql -d fdd2db -c "TRUNCATE cart"

# ----------------------------------------
# Insertar datos de un archivo csv
# ----------------------------------------

echo "Populating table cart"
psql -d fdd2db -c "\copy cart from 'cart' delimiter '|'"
psql -d fdd2db -c "select cart_id, user_id, product_id, percentil, purchase_date, delta from cart"

psql -d fdd2db -c "select avg(delta), percentil from (select product_id, avg(delta) as delta, percentil from cart group by product_id, percentil order by product_id) as q group by percentil" | sed '1d' | sed '1d' | sed 's| ||g' | head -n -2 | sed 's/|/,/g' > datos_grafica

