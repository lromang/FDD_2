# Project 1


In this project you'll implement a library and simulate customer behaviour.


To Do

Create a bash script that performs the following tasks: 

## 1 Load library

* Generate a catalog of bookshelves from [this site](https://www.gutenberg.org/ebooks/bookshelf/) 
The table must have the following variables:

- bookshelf_id: primary key
- title: varchar
- url: varchar

Example

Table: Catalog

| bookshelf_id  | title | url |
| ------------- | ------------- | ------------- | 
| 1  | title_1  |  https://www.gutenberg.org/ebooks/bookshelf/210 |
| 2  | title_2  |  https://www.gutenberg.org/ebooks/bookshelf/296 |
| ...  | ...  | ... |


**HINT**:

The following script might be useful, but you should be able to explain what it's doing in class. Feel free to use your own if you have a better version

```curl https://www.gutenberg.org/ebooks/bookshelf/ | gsed -nE '/.*bookshelf_pages.*/,/.*content ending.*/{/.*li.*/p}'```

* Sample N bookshelves, where N is a parameter selected by the user in the interval [1, number_of_bookshelfs] (any number out of that intervale should be flagged as an error),
and load the books of each bookshelve in the sample to a book table. The table must have the following variables:

- book_id: primary key
- bookshelf_id: integer references (bookshelf_id)
- title: varchar
- author: varchar
- url: varchar
- downloads: integer

Example

Table: Catalog

| book_id  | bookshelf_id | title | author | url | downloads |
| ------------- | ------------- | ------------- |  ------------- | ------------- |  ------------- | 
| 1  | 1  |  title_1 | the_author_1 | https://www.gutenberg.org/ebooks/24128 | 2555
| 2  | 4  |  title_2 | the_author_2 | https://www.gutenberg.org/ebooks/24343 | 100
| ...  | ...  | ... | ... | ... |


**HINT**:

The following script might be useful, but you should be able to explain what it's doing in class. Feel free to use your own if you have a better version

curl https://www.gutenberg.org/ebooks/bookshelf/210 | gsed -nE '/.*cell content.*/,/^<\/span>$/p' | awk '/.*title.*/ {title=$0;getline;subtitle=$0;getline;print title ", " subtitle ", " $0 }'