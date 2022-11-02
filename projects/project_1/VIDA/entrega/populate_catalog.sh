cat pagina_gutt.txt | awk '{if ($0 ~ /.*\<li\>\<a href=\"\/ebooks\/bookshelf\/[0-9]+.*/) { print $0 }}' | sed -E "s/[^\"]*\"([^\"]*)\"[^\"]*/\"\1\",/g" | sed -E "s/(.*),$/\1/" | sed -E "s/([^']*)'([^']*)/\1''\2/g" | sed -E "s/([^\"]*)\"([^\"]*)/\1'\2/g" | sed -E "s/(.*)/insert into Catalog (url,title) values (\1);/" > populate_catalog.sql 

