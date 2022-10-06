# Project 1
========

In this project you'll implement a library and simulate customer behaviour.


To Do

Generate a bash script that performs the following tasks: 

## Load library

1. Generates a catalog of bookshelves from [this site](https://www.gutenberg.org/ebooks/bookshelf/) 
The table must have the following variables:

- bookshelf_id: primary key
- bookshelf_title: varchar
- bookshelf_url: varchar

Example

Table: Catalog

| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |s

| bookshelf_id | bookshelf_title  | bookshelf_url| |
| ------------ | ---------------- |  -------------- |
|      1       |    example_title |  https://www.gutenberg.org/ebooks/bookshelf/210 |


*HINT*:

```curl https://www.gutenberg.org/ebooks/bookshelf/ | gsed -nE '/.*bookshelf_pages.*/,/.*content ending.*/{/.*li.*/p}'```
