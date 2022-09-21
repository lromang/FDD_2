
#! /bin/bash

# Sample size (defaults 500)
n_random=${1:-500}
percentiles=${1:-10}

# Drop table
psql -d fdd2db -c 'drop table if exists random_test'
# Create table
psql -d fdd2db -c 'create table random_test (r_value integer)'
# Populate table
for i in $(seq $n_random)
do
query=$(echo $i | awk -v seed=$i -v query_state="insert into random_test values (%d)" "BEGIN {srand(seed)} {printf(query_state, int(rand()*100) + 1)}")
echo $query
psql -d fdd2db -c "$query"
done


#TODO
query=$(echo 1 | awk -v iterations=$percentiles '{for(i = 1; i <= iterations; i++) query=query "select percentile_cont(" i/10 ") within group (order by r_value) as percentile_" i "  from random_test\\n" }; END {printf(query)}')

query_2=$(echo -e $query | awk '{printf "psql -d fdd2db -c \"%s\";", $0}')

eval  $query_2




