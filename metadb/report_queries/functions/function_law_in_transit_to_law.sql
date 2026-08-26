--metadb:function law_in_transit_to_law

drop function if exists law_in_transit_to_law(text);

create function law_in_transit_to_law()
returns table(
loan_return_date text,
item_status text,
hrid text,
barcode text,
call_number text,
title text
)  
as $$
select distinct on (folio_inventory.item__t.hrid) folio_derived.loans_items.loan_return_date as loan_return_date,
folio_derived.loans_items.item_status as item_status,
folio_inventory.item__t.hrid as hrid,
folio_inventory.item__t.barcode as barcode,
folio_inventory.holdings_record__t.call_number as call_number,
folio_inventory.instance__t.title as title
from folio_inventory.item__t
join folio_inventory.holdings_record__t on folio_inventory.item__t.holdings_record_id=folio_inventory.holdings_record__t.id
join folio_inventory.instance__t on folio_inventory.holdings_record__t.instance_id = folio_inventory.instance__t.id
join folio_derived.loans_items on folio_inventory.item__t.id=folio_derived.loans_items.item_id
where folio_derived.loans_items.item_status ='In transit' and folio_derived.loans_items.in_transit_destination_service_point_name='Law Library';
$$
language sql 
stable 
parallel safe;
