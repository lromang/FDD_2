#! /bin/bash

curl https://www.gutenberg.org/ebooks/bookshelf/ | gsed -n '/ebooks\/bookshelf\/[0-9]/p' | gsed -E 's/.*href=(\"[^\"]+\").*/\1/g' | gsed -E 's/.*bookshelf\/([^\/]+[0-9]).*/\1/g' | sort >> pag_gu.txt

