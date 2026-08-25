--metadb:function law_function_lost_item_status

drop function if exists law_function_lost_item_status(text);

create function law_function_lost_item_status()
returns table(
instance_hrid text  
)  
as $$
select
ie.item_hrid,
ie.barcode,
ie.effective_call_number,
ie.material_type_name,
ie.effective_location_name,
ie.status_name,
ie.discovery_suppress,
itn.note_type_name,
itn.note
from folio_derived.item_ext ie
left join folio_derived.item_notes as itn on itn.item_id = ie.item_id
where (ie.status_name = 'Long missing'
or ie.status_name = 'Missing'
or ie.status_name = 'Aged%'
or ie.status_name = 'Declared lost'
or ie.status_name = 'Claimed returned')
and ie.effective_location_name like 'Law%'	
$$
language sql 
stable 
parallel safe;
