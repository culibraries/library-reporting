--MM105: Long Missing Report - All Locations
WITH lmissing AS (
SELECT 
i.jsonb ->> 'hrid' AS item_hrid,
notes.DATA ->> 'note' AS long_missing_note
FROM folio_inventory.item AS i
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'notes')) WITH ORDINALITY AS notes (data)
LEFT JOIN folio_inventory.item_note_type__t AS nt ON nt.id = (notes.DATA ->> 'itemNoteTypeId')::uuid
WHERE nt.id = '66127077-e75b-47f8-8f03-b9e8bb070e1a'
)
SELECT 
jsonb_extract_path_text(i.jsonb, 'tags', 'tagList') AS tag,
i.jsonb -> 'status' ->> 'name' AS item_status,
loc.name AS item_location,
i.jsonb ->> 'barcode' AS item_barcode,
i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_number,
i.jsonb ->> 'effectiveShelvingOrder' AS shelf_order,
inst.title AS title,
i.jsonb ->> 'enumeration' AS enumeration,
i.jsonb ->> 'copyNumber' AS volume,
i.jsonb ->> 'volume' AS copy_number,
lmissing.long_missing_note
FROM folio_inventory.item i
LEFT JOIN lmissing ON lmissing.item_hrid = i.jsonb ->> 'hrid'
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
WHERE i.jsonb -> 'status' ->> 'name' = 'Long missing'
ORDER BY loc.name, i.jsonb ->> 'effectiveShelvingOrder' ASC
;
