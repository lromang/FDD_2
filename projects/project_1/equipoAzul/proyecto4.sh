#! /bin/bash/

psql -d fdd2db -c "drop table if exists catalog_with_percentile"
psql -d fdd2db -c "create table catalog_with_percentile as select book_id, bookshelf_id, title, author, url, downloads, percent_rank() over (order by downloads desc) as popularity from catalog order by book_id asc"

#This script is for sampling N books, where N is provided by the user

echo 'Write number of bookshelves to be sampled...'
read n
if(($n>0 && $n<=338))
then
    num=$n
else
    echo 'The number entered is out of range. Accepted range = [1-388]. N has been set to 10'
fi

num_bookshelves=${num:-10}
echo "$num_bookshelves random bookshelves being selected"


#Con subqueries obtenemos primero la ids de los n random bookshelves, luego tomamos todos los libors (y sus atributos) que tengan ese randonmly selected bookshelf_id

psql -d fdd2db -c "drop table if exists sample_table cascade"
psql -d fdd2db -c "create table sample_table as select book_id, bookshelf_id, c.title, author, c.url, downloads, popularity from catalog_with_percentile c join (select bookshelf_id from bookshelf order by random() limit $num_bookshelves) as sbq1 using (bookshelf_id) order by book_id "

