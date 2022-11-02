CREATE OR REPLACE FUNCTION random_exp(
    count INTEGER DEFAULT 1,
    mean DOUBLE PRECISION DEFAULT 1.0
    ) RETURNS SETOF DOUBLE PRECISION
      RETURNS NULL ON NULL INPUT AS $$
        DECLARE
            u DOUBLE PRECISION;
        BEGIN
            WHILE count > 0 LOOP
                u = RANDOM(); -- range: 0.0 <= u < 1.0
                IF u != 0.0 THEN
                    RETURN NEXT -LN(u) * mean;
                    count = count - 1;
                END IF;
            END LOOP;
        END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sample_n_bookshelfs(numero integer)
 RETURNS TABLE(link text)
 LANGUAGE plpgsql
AS $function$
begin
return query
select url from catalog order by random() limit numero;
end;$function$
;
 
 create or replace function reporte_recompra()
returns table (percentil int, promedio double precision)
language plpgsql    
as $$
	declare cuenta int ;
begin 
	select count(*)/2 into cuenta from cart;
	update books  set percentil=rs.percentil from   (
	select id_book  , ntile (10) over (order  by b.downloads desc) as percentil from books b
	)   as rs where books.id_book=rs.id_book;
	insert into  cart (id_user,id_book,purchased_at)
	select id_user,id_book, to_timestamp( 24*60*60 *( case when extra <1.0 then 1.0 else extra end )+ extract(epoch from purchased_at)) from (
		select id_cart,c2.id_user,id_book,purchased_at,random_exp(1,(per_prom*power(10,per_prom/10))) as extra 
		from cart c2 
		 join( 
		 	select id_user,avg(b.percentil) as per_prom from cart c  join books b  on b.id_book =c.id_book group by c.id_user
		 	) as sb1
		 on c2.id_user=sb1.id_user
	 ) as sb2 order by id_cart ;
	return query
		select sub1.percentil,EXTRACT(epoch FROM avg(sub2.purchased_at-sub1.purchased_at)) from ( select * from cart  
		join books on cart.id_book=books.id_book where id_cart<=cuenta) as sub1 join 
		(select *,id_cart-cuenta as aux from cart  where id_cart>cuenta) as sub2 on sub1.id_cart=sub2.aux
		group by sub1.percentil   order by sub1.percentil; 
	end;$$;
