--metadb:function iclickers_inventory_2

drop function if exists iclickers_inventory_2;

create function iclickers_inventory_2(
location_name1 text,
item_status1 text,
item_status2 text,
item_status3 text
)
returns table(
"Status" text,
"Barcode" text,
"Copy" text,
"Volume" text,
"Updated" date,
"Location Name" text
)
as $$
select     
	i.jsonb -> 'status' ->> 'name' as "Status",     
	it.barcode as "Barcode",  
	it.copy_number as "Copy",   
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
	else lt.name = location_name1    
end
	and case  
	when item_status1 = 'ALL' then true
	else (i.jsonb -> 'status' ->> 'name') in (item_status1, item_status2, item_status3) 
end
order by "Status"
$$
language sql
stable 
parallel safe;
