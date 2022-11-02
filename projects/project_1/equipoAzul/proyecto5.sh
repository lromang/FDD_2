#! /bin/bash/

echo 'Write number of users to be created...'
read m
if(($m>0 && $m<=10000))
then
    num=$m
else
    echo 'The number entered is out of range. Accepted range = [1-10000]. N has been set to 1000'
fi

num_users=${num:-1000}
echo "$num_users users are going to be created"

psql -d fdd2db -c "drop table if exists users cascade"
psql -d fdd2db -c "create table users (user_id serial primary key, name varchar(30))"

for i in $(seq $num_users)
do
	name= name="'""$(letters=$(for letter in {a..z}; do echo $letter; done | tr '\n' ' '); echo $i | awk -v letters="$letters" -v v_index="$i" "BEGIN {srand(v_index)}; {split(letters, list_letters); for(i =0; \
i<5+(rand()*100%5); i++) r_word = r_word list_letters[int(rand()*length(list_letters)) + 1]; print r_word}")""'"
	psql -d fdd2db -c "insert into users values($i, $name)"
done