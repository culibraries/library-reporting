--metadb:function tech3d_iclickers_inventory

drop function if exists tech3d_iclickers_inventory;

create function tech3d_iclickers_inventory(
location_code1 text,
location_code2 text,
location_code3 text,
location_code4 text,
location_code5 text,
location_code6 text
)
returns table(
"Status" text,
"Barcode" text,
"Volume" text,
"Updated" date,
"Location Code" text,
"Location Name" text
)
as $$
select
	i.jsonb -> 'status' ->> 'name' as "Status",
	i.jsonb ->> 'barcode' as "Barcode",
	i.jsonb ->> 'volume' as "Volume",
	(i.jsonb -> 'metadata' ->> 'updatedDate')::timestamp as "Updated",
	l.jsonb ->> 'code' as "Location Code",
	l.jsonb ->> 'name' as "Location Name"
from folio_inventory.item i
left join folio_inventory.location l on (l.jsonb ->> 'id')::uuid = (i.jsonb ->> 'effectiveLocationId')::uuid
left join folio_inventory.holdings_record hr on (hr.jsonb ->> 'id')::uuid = (i.jsonb ->> 'holdingsRecordId')::uuid
where l.jsonb ->> 'code' in (location_code1, location_code2, location_code3, location_code4, location_code5, location_code6)
and hr.jsonb ->> 'hrid' in ('b12730993-032','b12730993-022','b12730993-009','ho00000214255','b12730993-001','b12730993-013','b10268020-001','ho00000350100')
order by "Status","Volume"
$$
language sql
stable 
parallel safe;
