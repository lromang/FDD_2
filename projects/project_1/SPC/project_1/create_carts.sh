#! /bin/bash 

#giving m users
read -p "enter number of users: " num_users
m="${num_users:-1000}"
while [[ $m -lt 1 || $m -gt 10000 ]]
do
read -p "number out of interval [1-10000], try again: " num_users
m="${num_users:-1000}"
done


#droping table users
psql -d fdd2db -c "drop table if exists users"

#creating table random users
psql -d fdd2db -c "create table if not exists users(user_id serial primary key, name varchar(25));"

#filling table users
for ((i = 1; i <= $m; i++)); do letters=$(for letter in {a..z}; do echo $letter; done | tr '\n' ' '); query=$(echo $i | awk -v letters="$letters" -v v_index="$i" "BEGIN {srand(v_index)}; {split(letters, list_letters); for(i = 0; i < 5 + (rand()*100 % 10); i++) r_word = r_word list_letters[int(rand()*length(list_letters)) + 1]; printf(\"%s\", r_word)}");  psql -d fdd2db -c "insert into users(name) values ('$query')"; done


#droping table carts
psql -d fdd2db -c "drop table if exists carts"


#creating table carts
psql -d fdd2db -c 'create table carts(cart_id int not null, user_id int not null, book_id int not null, percentile float not null,  purchase_date int not null, primary key (cart_id, user_id, book_id), foreign key (user_id) references users (user_id), foreign key (book_id) references books (book_id));'


#filling table carts
for (( i=1; i<=$m; i++ ))
do
k=$(( $RANDOM % 10 + 1 ))
date=$(shuf -n1 -i$(date -d '2020-01-01' '+%s')-$(date -d '2023-01-01' '+%s'))
psql -d fdd2db -c "with carrito as (select * from books_with_percentile order by random() limit $k) select $i as user_id, book_id, percentile from carrito" | awk -v date_var=$date -F '|' '/\| +[0-9]+/ {printf("insert into carts values(%d,%d,%d,%.2f,%d);", $1,$1,$2,$3,date_var)}' | psql -d fdd2db
done

psql -d fdd2db -c "\copy carts to 'carts.csv' csv header"
