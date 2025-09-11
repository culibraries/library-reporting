--metadb:function tech3d_inventory

drop function if exists tech3d_inventory;

create function tech3d_inventory(
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
	it.barcode as "Barcode",     
	it.volume as "Volume",     
	(i.jsonb -> 'metadata' ->> 'updatedDate')::timestamp as "Updated",     
	lt.name as "Location Name" 
from folio_inventory.item__t it 
join folio_inventory.item i on i.id = it.id 
left join folio_inventory.location__t lt on lt.id = it.effective_location_id 
left join folio_inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id 
where hrt.hrid in ('b12730993-032','b12730993-022','b12730993-009','ho00000214255','b12730993-001','b12730993-013','ho00000350100') 
and case    
	when location_name1 = 'ALL' then true     
	else lt.name in (location_name1, location_name2) 
end 
order by "Status","Volume"
$$
language sql
stable 
parallel safe;
