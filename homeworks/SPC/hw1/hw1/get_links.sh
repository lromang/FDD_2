#! /bin/bash

if [[ -f "links" ]]
then
    rm -r links
fi

for line in `grep -Eo '/ebooks/bookshelf/[0-9]|/ebooks/bookshelf/[0-9][0-9]|/ebooks/bookshelf/[0-9][0-9][0-9]' gutenberg_html.txt`;do echo https://gutenberg.org$line>>links; done
