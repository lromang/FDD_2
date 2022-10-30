#! /bin/bash

read -p "Enter number of bookshelves [10]: " number_bookshelves
number_bookshelves=${number_bookshelves:-10}
echo $number_bookshelves

total_bookshelves=$((`psql -d fdd2db -c "select count(*) from bookshelves" | grep -Eo ' +[0-9]+'`))


if [[ $number_bookshelves -gt $total_bookshelves || $number_bookshelves -lt 1 ]]
then
    echo "Invalid number"
else
    psql -d fdd2db -c "drop table if exists carts; drop table if exists books; create table books(book_id serial primary key, bookshelf_id int, url varchar(400), title varchar(400), author varchar(400), downloads int, constraint fk_bookshelves foreign key(bookshelf_id) references bookshelves(bookshelf_id));"

    psql -d fdd2db -c "drop sequence if exists book_id_seq; create sequence book_id_seq start 1 increment 1;"

 
    for ((i = 1; i <= $number_bookshelves; i++))
    do
	bookshelf_url=`psql -d fdd2db -c "select url from bookshelves where bookshelf_id=$i" | tr -d - | sed 's/url //g' | awk -F "(" '{print($1)}'`

	curl $bookshelf_url| sed -nE '/.*booklink.*/,/^<\/hstrut>$/p' | awk '/.*class="link".*/ {booklink=$0; while(!($0 ~ /<span class="cell content">/)){getline; print $0}; getline; title=$0; getline; subtitle=$0; getline; print booklink ", " title ", " subtitle ", " $0}'| grep -oP "(?<=>).*?(?=<)|ebooks/[0-9]+" | grep -Ewv -e "," -e "Sort Alphabetically by Title" -e "Sort Alphabetically by Author" -e "Sort by Release Date" | tr \' \" | awk -v id_bookshelf=$i '{link=$0;getline;title=$0;getline;if($0 ~ /[0-9]+ downloads/){downloads=$0; author=""}else{author=$0;getline;downloads=$0};printf("insert into books values(nextval(\x27book_id_seq\x27), %d,\x27https://www.gutenberg.org/%s\x27,\x27%s\x27,\x27%s\x27,%d);", id_bookshelf,link, title, author, downloads) }'|psql -d fdd2db

    done

fi


total_books=$((`psql -d fdd2db -c "select count(*) from books" | grep -Eo ' +[0-9]+'`))

echo "drop table if exists books_with_percentile; create table books_with_percentile as (select book_id, bookshelf_id, url, author, title, downloads,cast((row_number() over (order by downloads asc)) as float)/cast(($total_books) as float) as percentile from books)" | psql -d fdd2db

psql -d fdd2db -c '\copy books_with_percentile to "books_with_percentile.csv" header csv'
