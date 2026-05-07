--metadb:function item_CheckInOut_notes

drop function if exists item_CheckInOut_notes;

create function item_CheckInOut_notes(
	note_type text,
	material_type text,
	item_location text,
	start_date date default '2000-01-01',
	end_date date default '2999-01-01'
)
returns table(
"Location Name" text,
"Barcode" text,
"Material Type" text,
"Note Type" text,
"Note Date" date,
"Note Contents" text
)
as $$
select
	l.jsonb ->> 'name' as "Location Name",
	i.jsonb ->> 'barcode' as "Barcode",
	mtt.name as "Material Type",
	cn ->> 'noteType' as "Note Type",
	(cn ->> 'date')::date as "Note Date",
	cn ->> 'note' as "Note Contents"
from folio_inventory.item i
left join folio_inventory.location l on (l.jsonb ->> 'id')::uuid = (i.jsonb ->> 'effectiveLocationId')::uuid
left join folio_inventory.material_type__t mtt on mtt.id = (i.jsonb ->> 'materialTypeId')::uuid
cross join lateral jsonb_array_elements(i.jsonb -> 'circulationNotes') as cn
where cn ->> 'noteType' = note_type
	--and mtt.name = material_type
	and case when material_type = 'ALL' then true else mtt.name in (material_type) end
	and (cn ->> 'date')::date between start_date and end_date
	and case when item_location = 'ALL' then true else (l.jsonb ->> 'name') in (item_location) end
order by "Location Name", "Note Date"
$$
language sql
stable 
parallel safe;
