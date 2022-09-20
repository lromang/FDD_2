## Class objectives

* Case when conditions
* String functions
* Date functions
* Array functions
* Filtering

=====

### ACTIVITIES

* Create movies dataset getting max varchar from fields using awk.
* Display all the timezones with time in table format using sql, awk, sed

### String functions
-> regexp_matches | extracting year
-> regexp_split | extracting genre -> case when condition over array length
   -> array_length(array, dimension)
   -> val = ANY (array)
   -> val = ALL (array)
   -> array_to_string(array, string)
-> regexp_replace | reformat title 
   -> Filter titles with structure ~
-> length
-> upper

### Dates

** DATE QUERIES
-> extract(date_part from date)
-> (date + interval )::date

** MULTIPLE TIMEZONES
-> timestamp, timestamptz
-> now
-> show timezone
-> select * from pg_timezone_names
-> set timezone to 'x'
-> select now()


