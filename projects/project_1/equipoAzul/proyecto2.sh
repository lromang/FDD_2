#! /bin/bash
#this script produces an archive to populate ALL catalog: book_id, bookshelf_id, book_title, author, url, downloads

#Borramos todo lo de la corrida anterior, primero obtenemos el numero de registros totales:
num_borrar=$(wc -l < alltogether.txt)
cat alltogether.txt | perl -pe '$_=""if 1..$num_borrar' > alltogether.txt


for i in $(seq 338)
do
    id=$i
    bookshelf=$(cat id_url.txt | awk -F "," -v var=$i 'NR==var {print $2}')
    url="https://www.gutenberg.org/ebooks/bookshelf/$bookshelf"


    #Titles                                                              
    curl $url | gsed -nE '/.cell content./,/^<\/span>$/p' | awk '/.title./ {title=$0;getline;subtitle=$0;getline;print title ", " subtitle ", " $0 }' | gsed -E 's/<span class="title">//' | awk 'BEGIN { FS ="<" } ; { print $1 }' | sed "s/'/´/g" | sed 's/Sort Alphabetically by Title//g' | sed 's/Sort Alphabetically by Author//g' | sed 's/Sort by Release Date//g'| sed '/^$/d'  > titles.txt



    #Authors
    #Primero ponemos el codigo del profe en un archivo (ya se eliminaron las primeras tres lineas inutiles)
    curl $url | gsed -nE '/.*cell content.*/,/^<\/span>$/p' | awk '/.*title.*/ {title=$0;getline;subtitle=$0;getline;print title ", " subtitle ", " $0 }' | sed "s/'/´/g" | perl -pe '$_=""if 1..3' > preAut.txt

    num_preAut=$(wc -l < preAut.txt)
    
    #Iteramos por el numero de lineas que tiene preaut 
    for i in $(seq $num_preAut)
    do
	preAutor="$(cat preAut.txt | awk -v var=$i 'NR==var {print $0}')"
	#echo para pasar la variable como texto y el pesito de afuera para convertirla una variable que se pueda jalar
	preAutor2=$( echo $preAutor | grep -o 'subtitle')

	#if necesita espacios                                                                                                                                                                                  
	if [[ "$preAutor2" == "subtitle" ]]
	then
            #si hay autor                                                                                                                                                                                      
            echo $preAutor | grep -Eo 'subtitle.*' | gsed 's/subtitle.>//' | awk 'BEGIN { FS = "<" } ; { print $1 }' >> authors.txt
	else
            #No hay autor
            echo "Unkown" >> authors.txt
	fi
    done

    	
    #URL
    curl $url | grep -Eo '/ebooks/[0-9]+' > urls.txt

    #Downloads                                                                                                                                                                         
    curl $url | gsed -nE '/.cell content./,/^<\/span>$/p' | awk '/.title./ {title=$0;getline;subtitle=$0;getline;print title ", " subtitle ", " $0 }' | grep -Eo 'extra.*' | gsed 's/extra.>//' | awk '{ print $1 }' > downloads.txt

    #Para determinar cuantas libros hay en el bookshelf usamos autores.txt porque no se equivoca
    num_libros=$(wc -l < titles.txt)
    
    for i in $(seq $num_libros)
    do
	title="'$(cat titles.txt | awk -v var=$i 'NR==var {print $0}')'"
	author="'$(cat authors.txt | awk -v var=$i 'NR==var {print $0}')'"
	url="'https://www.gutenberg.org/$(cat urls.txt | awk -v var=$i 'NR==var {print $0}')'"
	downloads="'$(cat downloads.txt | awk -v var=$i 'NR==var {print $1}')'"

	echo $id
	echo $title
	echo $author
	echo $url
	echo $downloads
	echo -e "\n"
	#Ahora metemos todos los datos de todos los libros de todos los bookshelves a un archivo
	#IMPORTANTE: este archivo debe borrarse si se desea correr este script otra vez: pues solo usa append y se repetirian todos lo valores
	#El delimiter para dividir los datos de cada libro en una linea es: }
	echo "$id}$title}$author}$url}$downloads" >> alltogether.txt
	

    done
    


    #Como en author estamos usando >> en vez de > tenemos que borrar el archivo cada vez
    num_auts2=$(wc -l < authors.txt)
    cat authors.txt | perl -pe '$_=""if 1..$num_auts2' > authors.txt


done
