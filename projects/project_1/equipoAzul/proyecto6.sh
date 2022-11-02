#! /bin/bash/

psql -d fdd2db -c "alter table sample_table add unique(book_id)"

psql -d fdd2db -c "drop table if exists purchase_cart"
psql -d fdd2db -c "create table purchase_cart(cart_id integer, user_id integer references users(user_id), book_id integer references sample_table(book_id), purchase_date date)"




contador=$(psql -d fdd2db -c "select count(distinct user_id) from users;" | awk '/^-+$/ {getline; print $0}')

for i in $(seq $contador)
do
	date="'$(psql -d fdd2db -c "select to_char(day, 'YYYY-MM-DD') from generate_series( '2020-01-01'::date, current_date::date, '1 day'::interval) day order by random() limit 1" | awk '/^-+$/ {getline; print $0}')'"
	k=$(( RANDOM % 10 +1 ))
	for j in $(seq $k)
	do
		book_id=$(psql -d fdd2db -c "select book_id from sample_table order by random() limit 1" |  awk '/^-+$/ {getline; print $0}')
		psql -d fdd2db -c "insert into purchase_cart values($i, $i, $book_id, $date)"
		
	done
	
done

