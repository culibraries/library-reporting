--metadb:function iclickers_inventory

drop function if exists iclickers_inventory;

create function iclickers_inventory(
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
where hrt.hrid = 'b10268020-001' 
and case    
	when location_name1 = 'ALL' then true     
	else lt.name in (location_name1, location_name2) 
end 
order by "Status","Volume"
$$
language sql
stable 
parallel safe;
