#! /bin/bash

# ----------------------------------------
# This script creates and populates
# the following tables. 
# -> universities
# -> programs
# -> students
# ----------------------------------------

# PARAMS
database=${1:-fdd2db}
user=${2:-$(whoami)}

# GLOBAL
N_PROGRAMS=20
N_STUDENTS=10000

echo "Working with database: $database | user: $user"

tables=('universities' 'programs' 'students')

# Drop tables
# Just iterating over an array
# do not worry about this.
for table in ${tables[@]}
do
    echo "Dropping table $table"
    psql -d $database -U $user -c "drop table if exists $table cascade"
done


# ----------------------------------------
# Create tables
# ----------------------------------------
# -> create table universities (reading from csv file)
echo "Creating table universities"
psql -d fdd2db -c "create table if not exists universities (id serial primary key, name varchar(25))"
# -> create table programs
echo "Creating table programs"
psql -d fdd2db -c "create table if not exists programs (id serial primary key, university integer references universities(id), name varchar(25), tuition float)"
# -> create table students 
# TODO
# -> create table students with the structure
#    (id, name, age, program)
#    make sure to use the correct
#    datatypes. 
echo "Creating students "
psql -d fdd2db -c "create table if not exists students (id serial primary key, name varchar(10), age numeric(2,0), program integer references programs(id))"

# ----------------------------------------
# Populate tables
# ----------------------------------------
# -> populate universities
echo "Populating table universities"
psql -d fdd2db -c "\copy universities from 'universities.csv' delimiter ','"
# -> populate programs
echo "Populating table programs"
echo $N_PROGRAMS
for i in $(seq $N_PROGRAMS)
do
    echo $i
    # Make sure program is interpreted as string.
    name="'""program_$i""'"
    psql -d fdd2db -c "insert into programs values ($i, $(((RANDOM % 4) + 1)), $name, $((RANDOM * 10)))"
done

# ----------------------------------------
# TODO:
# populate table 'students' with 
# 10k entries with the
# following conditions:
# 
# - id: incremental
# - name: random string of length [5-10] (each must match [a-z]{5,10})
# - age  random integer [18-35]
# - program: integer reference to programs (id)
# ----------------------------------------

for i in $(seq $N_STUDENTS)
do
    name=""
    for b in $(seq $((5 + $RANDOM % 6)))
    do
        # Make sure program is interpreted as string.
        name+=$(printf "\\$(printf '%03o' "$((97 + $RANDOM % 26))")")
    done
    psql -d fdd2db -c "insert into students values ($i, '$name', $((18 + $RANDOM % 18)), $((1 +$RANDOM % $N_PROGRAMS)))"
done