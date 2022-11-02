#! /bin/bash/

psql -d fdd2db -c "drop table if exists catalog cascade"
psql -d fdd2db -c "create table if not exists catalog(book_id serial primary key, bookshelf_id integer references bookshelf(bookshelf_id), title varchar(1000), author varchar(1000), url varchar(1000), downloads integer)"

cat alltogether.txt | sed 's/extraordinaires/0/g' > insertions_sql.txt

num_books=$(wc -l alltogether.txt)

for i in $(seq 5575)
do
	bookshelf_id="$(cat insertions_sql.txt | awk -F "}" -v var=$i 'NR==var {print $1}')"
	book_title="$(cat insertions_sql.txt | awk -F "}" -v var=$i 'NR==var {print $2}')"
	author="$(cat insertions_sql.txt | awk -F "}" -v var=$i 'NR==var {print $3}')"
	url="$(cat insertions_sql.txt | awk -F "}" -v var=$i 'NR==var {print $4}')"
	downloads="$(cat insertions_sql.txt | awk -F "}" -v var=$i 'NR==var {print $5}')"

	psql -d fdd2db -c "insert into catalog values($i,$bookshelf_id, $book_title, $author, $url, $downloads)"
done