--metadb:function googlebooknotes

drop function if exists googlebooknotes;

create function googlebooknotes()
returns TABLE(
discovery_suppress text,
item_hrid text,
holdings_hrid text,
item_location text,
barcode text,
formerIds text,
call_number text,
shelving_order text,
material_type text,
title text,
note_type_name text,
note text,
staff_only text,
note_ordinality integer
)
as $$
SELECT
inst.discovery_suppress,
jsonb_extract_path_text(i.jsonb, 'hrid') AS item_hrid,
holdings.hrid  AS holdings_hrid,
loc.name AS item_location,
jsonb_extract_path_text(i.jsonb, 'barcode') AS barcode,
jsonb_extract_path_text(i.jsonb, 'formerIds') AS formerIds,
holdings.call_number,
jsonb_extract_path_text(i.jsonb, 'effectiveShelvingOrder') as shelving_order,
mt.name AS material_type,
inst.title as title,
nt.name AS note_type_name,
jsonb_extract_path_text(notes.data, 'note') AS note,
jsonb_extract_path_text(notes.data, 'staffOnly')::boolean AS staff_only,
notes.ordinality AS note_ordinality
FROM
folio_inventory.item as i
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'notes')) WITH ORDINALITY AS notes (data)
LEFT JOIN folio_inventory.holdings_record__t AS holdings on i.holdingsrecordid = holdings.id
LEFT JOIN folio_inventory.instance__t AS inst ON holdings.instance_id = inst.id 
LEFT JOIN folio_inventory.item_note_type__t AS nt ON jsonb_extract_path_text(notes.data, 'itemNoteTypeId')::uuid = nt.id
LEFT JOIN folio_inventory.location__t AS loc ON effectivelocationid = loc.id
LEFT JOIN folio_inventory.material_type__t AS mt ON materialtypeid = mt.id 
WHERE 		
nt.id = '7a46e1ca-d2eb-49a3-9935-59bed639e6f1'
--AND jsonb_extract_path_text(notes.data, 'note') LIKE ''
ORDER BY item_location, jsonb_extract_path_text(i.jsonb, 'effectiveShelvingOrder')
$$
language sql 
stable 
parallel safe;
