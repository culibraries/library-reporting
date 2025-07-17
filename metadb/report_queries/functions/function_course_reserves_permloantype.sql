--metadb:function course_reserves_permloantype

drop function if exists course_reserves_permloantype;

create function course_reserves_permloantype()
returns table(
--"Title" text,
"Barcode" text,
"Call Number" text
)
as $$
SELECT 
	--(i2.jsonb ->> 'title') as "Title",
	(i.jsonb ->> 'barcode') as "Barcode",
	(i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber') AS "Call Number"
FROM folio_inventory.item i
--left join folio_inventory.instance i2 on (i2.jsonb ->> 'hrid') = (i.jsonb ->> 'hrid')
where (i.jsonb ->> 'permanentLoanTypeId') = 'e8b311a6-3b21-43f2-a269-dd9310cb2d0e'
ORDER BY "Call Number"
$$
language sql
stable 
parallel safe;
