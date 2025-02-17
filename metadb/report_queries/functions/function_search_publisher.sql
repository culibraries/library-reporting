--ldp:fuction search_publisher

create function search_publisher(
publisher text default ''
)
returns TABLE(
"Barcode" text,
"Item Location" text,
"Instance HRID" text,
"Title" text,
"Date of Publication" text,
"Publisher" text,
"Publication Place" text
)
as $$
select 
i.barcode as "Barcode",
loc.name as "Item Location",
inst.hrid as "Instance HRID",
inst.title AS "Title",
pub.date_of_publication AS "Date of Publication",
pub.publisher as "Publication",
pub.publication_place as "Publication Place"
from folio_derived.instance_publication as pub
left join folio_inventory.instance__t as inst on inst.id = pub.instance_id  
left join folio_inventory.holdings_record__t as ho on ho.instance_id = inst.id
left join folio_inventory.item__t as i on i.holdings_record_id = ho.id
left join folio_inventory.location__t as loc on loc.id = i.effective_location_id
where publisher like publisher
$$
language sql
stable parallel SAFE;
