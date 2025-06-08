--metadb:function tech3d_iclickers_inventory

drop function if exists tech3d_iclickers_inventory;

create function tech3d_iclickers_inventory(
location_name1 text,
location_name2 text
)
returns table(
"Status" text,
"Barcode" text,
"Volume" text,
"Updated" date,
"Location Name" text
)
as $$
select
	i.jsonb -> 'status' ->> 'name' as "Status",
	i.jsonb ->> 'barcode' as "Barcode",
	i.jsonb ->> 'volume' as "Volume",
	(i.jsonb -> 'metadata' ->> 'updatedDate')::timestamp as "Updated",
	l.jsonb ->> 'name' as "Location Name"
from folio_inventory.item i
left join folio_inventory.location l on (l.jsonb ->> 'id')::uuid = (i.jsonb ->> 'effectiveLocationId')::uuid
left join folio_inventory.holdings_record hr on (hr.jsonb ->> 'id')::uuid = (i.jsonb ->> 'holdingsRecordId')::uuid
where hr.jsonb ->> 'hrid' in ('b12730993-032','b12730993-022','b12730993-009','ho00000214255','b12730993-001','b12730993-013','b10268020-001','ho00000350100')
and case 
	when location_name1 = 'ALL' then true
	else l.jsonb ->> 'name' in (location_name1, location_name2)
end
order by "Status","Volume"
$$
language sql
stable 
parallel safe;
