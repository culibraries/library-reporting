--metadb:function law_books_marked_available_in_restricted_locations

drop function if exists law_books_marked_available_in_restricted_locations(text);

create function law_books_marked_available_in_restricted_locations()
returns table(
title text,
hrid text,
barcode text
)  
as $$
SELECT
folio_inventory.instance__t.title as title,
folio_inventory.item__t.hrid as hrid,
folio_inventory.item__t.barcode as barcode
FROM folio_inventory.item
join folio_inventory.holdings_record__t on folio_inventory.item.holdingsrecordid = folio_inventory.holdings_record__t.id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_inventory.instance__t on folio_inventory.holdings_record__t.instance_id = folio_inventory.instance__t.id
join folio_inventory.item__t on folio_inventory.item.id = folio_inventory.item__t.id
WHERE jsonb_extract_path_text(jsonb, 'status', 'name') IN ('Available')
and folio_inventory.location__t.code like '%lfed%'
and folio_inventory.location__t.code not like '%lresc%';
$$
language sql 
stable 
parallel safe;
