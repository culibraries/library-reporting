--ldp:function search_publisher

drop function if exists search_publisher;

create function search_publisher(
search_text text
)
returns TABLE(
"Barcode" text,
"Item Location" text,
"Instance HRID" text,
"Material Type" text,
"Title" text,
"Date of Publication" text,
"Publisher" text,
"Publication Place" text,
"Collection Platform" text
)
as $$
with collection as (
SELECT 
marc.instance_id,
string_agg(marc.content, '|' ) as "MARC 956"
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '956'
and marc.sf = 'a'
group by marc.instance_id
)
select 
i.barcode as "Barcode",
loc.name as "Item Location",
inst.hrid as "Instance HRID",
mt.name as "Material Type",
inst.title AS "Title",
pub.date_of_publication AS "Date of Publication",
pub.publisher as "Publisher",
pub.publication_place as "Publication Place",
collection."MARC 956" as "Collection Platform"
from folio_derived.instance_publication as pub
left join folio_inventory.instance__t as inst on inst.id = pub.instance_id  
left join folio_inventory.holdings_record__t as ho on ho.instance_id = inst.id
left join folio_inventory.item__t as i on i.holdings_record_id = ho.id
left join folio_inventory.location__t as loc on loc.id = i.effective_location_id
left join folio_inventory.material_type__t as mt on mt.id = i.material_type_id
left join collection on collection.instance_id = pub.instance_id
where pub.publisher ilike Concat('%',search_text,'%')
$$
language sql
stable parallel SAFE;
