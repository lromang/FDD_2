#!/bin/bash
# Hello World Program in Bash Shell

psql -d fdd2db -c "drop table if exists tabla"
psql -d fdd2db -c "create table if not exists tabla (id int)"



for i in $(seq 500)
do
    psql -d fdd2db -c " insert into tabla values ($(($RANDOM % 101 )))"
done

for i in $(seq 9)
do 
    echo "percentile $i" 
    psql -d fdd2db -c "select percentile_cont(.$i) within group (order by id)  from tabla"
done
echo "percentile 10"
psql -d fdd2db -c "select percentile_cont(1) within group (order by id) from tabla"
