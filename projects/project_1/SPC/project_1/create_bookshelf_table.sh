#! /bin/bash

psql -d fdd2db -c "create table if not exists bookshelves (bookshelf_id int unique, title varchar(100), url varchar(100))"

curl https://www.gutenberg.org/ebooks/bookshelf/ | sed -nE '/.*bookshelf_pages.*/,/.*content ending.*/{/.*li.*/p}' | tr \' \" | awk -F '"' -v q="'" '{printf "insert into bookshelves values(%d, \x27%s\x27,\x27https://www.gutenberg.org%s\x27);", NR,$4,$2};' | psql -d fdd2db
