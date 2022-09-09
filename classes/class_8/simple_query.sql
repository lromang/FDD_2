drop table if exists test;

create table test (id serial primary key, number1 integer, number2 integer, name varchar);

insert into test values (1, 12, 23, 'name');
