#! /bin/bash                                                                                                                                                                                                                                                                                                                        
curl https://www.gutenberg.org/ebooks/bookshelf/ | grep -Eio '/ebooks/bookshelf/[0-9]+"\stitle=".*"' | sed 's/"//' | sed 's/title=//'| gsed "s/'/´/g" >linksAndTitles
#Obtaining number of books:                                                                                                                                                                                 
N_BOOKS=$(wc -l < linksAndTitles)

#Creating table                                                                                                                                                                                             
psql -d fdd2db -c "drop table if exists bookshelf cascade"
psql -d fdd2db -c "create table if not exists bookshelf(bookshelf_id serial primary key, title varchar(100), url varchar(100))"

#Populating bookshelf                                                                                                                                                                                       

for i in $(seq $N_BOOKS)
do
    title="'$(cat linksAndTitles | awk -F "\"" -v var=$i 'NR==var {print $2}')'"
    url="'https://www.gutenberg.org$(cat linksAndTitles | awk -v var=$i 'NR==var {print $1}')'"

    psql -d fdd2db -c "insert into bookshelf values($i, $title, $url)"
done
