--metadb:function course_reserves_permloantype

drop function if exists course_reserves_permloantype;

create function course_reserves_permloantype()
returns table(
"Title" text,
"Barcode" text,
"Call Number" text
)
as $$
SELECT 
	(i2.jsonb ->> 'title') as "Title",
	(i.jsonb ->> 'barcode') as "Barcode",
	(i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber') AS "Call Number"
from folio_inventory."instance" i2
left join folio_inventory.holdings_record h on (h.jsonb ->> 'instanceId')::uuid = i2.id
left join folio_inventory.item i on (i.jsonb ->> 'holdingsRecordId')::uuid = h.id
where (i.jsonb ->> 'permanentLoanTypeId') = 'e8b311a6-3b21-43f2-a269-dd9310cb2d0e'
ORDER BY "Call Number"
$$
language sql
stable 
parallel safe;
