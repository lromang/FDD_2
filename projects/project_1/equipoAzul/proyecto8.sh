#! /bin/bash/

psql -d fdd2db -c "select book_id, cart_id, average_popularity_of_cart, popularity, purchase_date from sample_table join purchase_cart using(book_id) join (select cart_id, avg(popularity) as average_popularity_of_cart from sample_table join purchase_cart using(book_id) group by cart_id order by cart_id) as sbq1 using(cart_id)" | awk -F '\|' '/^ +[0-9]+/{print $1 "," $2 "," $3 "," $4 "," $5}'| sed -E "s/ //g" > book_data

cat sample3.csv | awk -F "," '{print $2}' | sed '1d' |  sed '/^$/d' > float_to_integer
cat float_to_integer | awk -F "." '{print $1}' > dates_to_be_added
 
num_libros=$(wc -l < dates_to_be_added)

psql -d fdd2db -c "drop table if exists purchase_cart_w_delta"
psql -d fdd2db -c "create table purchase_cart_w_delta(book_id integer, popularity float, delta_diff integer)"

for i in $(seq $num_libros)
do
	book_id=$(cat book_data | awk -F "," -v var=$i 'NR==var{print $1}')
	echo $book_id
	popularity=$(cat book_data | awk -F "," -v var=$i 'NR==var{print $4}')
	echo $popularity
	delta=$(cat dates_to_be_added | awk -v var=$i 'NR==var {print $1}')
	echo $delta
	psql -d fdd2db -c "insert into purchase_cart_w_delta values($book_id, $popularity, $delta)"
done

psql -d fdd2db -c "select popularity, average_number_days_between_purchases from purchase_cart_w_delta join (select book_id, avg(delta_diff) as average_number_days_between_purchases from purchase_cart_w_delta group by book_id) as sbq1 using (book_id)" | awk -F '\|' '/^ +[0-9]+/{print $2 "," $1 }'| sed -E "s/ //g" > scatter_plot.csv

#psql -d fdd2db -c "select popularity, avg(delta_diff) as average_number_days_between_purcases from purchase_cart_w_delta group by popularity" | awk -F '\|' '/^ +[0-9]+/{print $2\
#"," $1 }'| sed -E "s/ //g" > scatter_plot.csv
