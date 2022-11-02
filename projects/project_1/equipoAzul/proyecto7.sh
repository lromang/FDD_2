#! /bin/bash/

psql -d fdd2db -c "select book_id, cart_id, average_popularity_of_cart, popularity, purchase_date from sample_table join purchase_cart using(book_id) join (select cart_id, avg(popularity) as average_popularity_of_cart from sample_table join purchase_cart using(book_id) group by cart_id order by cart_id) as sbq1 using(cart_id)" | awk -F '\|' '/^ +[0-9]+/{print $3 "," $4}'| sed -E "s/ //g" > pruebinha.csv

