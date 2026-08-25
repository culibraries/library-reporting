--metadb:function law_lost_item_status

drop function if exists law_lost_item_status(text);

create function law_lost_item_status()
returns table(
hrid text,
barcode text,
call_number text,
material_type text,
location text,
status text,
discovery_suppress text,
note_type text,
note text
)  
as $$
select
ie.item_hrid as hrid,
ie.barcode as barcode,
ie.effective_call_number as call_number,
ie.material_type_name as material_type,
ie.effective_location_name as location,
ie.status_name as status,
ie.discovery_suppress as discovery_suppress,
itn.note_type_name as note_type,
itn.note as note
from folio_derived.item_ext ie
left join folio_derived.item_notes as itn on itn.item_id = ie.item_id
where (ie.status_name = 'Long missing'
or ie.status_name = 'Missing'
or ie.status_name = 'Aged%'
or ie.status_name = 'Declared lost'
or ie.status_name = 'Claimed returned')
and ie.effective_location_name like 'Law%';	
$$
language sql 
stable 
parallel safe;
