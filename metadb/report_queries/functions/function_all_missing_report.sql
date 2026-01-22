--metadb:function all_missing_report

drop function if exists all_missing_report;

create function all_missing_report(
	item_status text,
	lib_location text,
	item_location text)
returns table(
	tag text,
	item_status text,
	lib_location text,
	item_location text,
	item_barcode text,
	call_number text,
	shelf_order text,
	title text,
	enumeration text,
	copy_number text,
	volume text,
	long_missing_note text
)
as $$
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
	ll.name AS lib_location,
	loc.name AS item_location,
	i.jsonb ->> 'barcode' AS item_barcode,
	i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_number,
	i.jsonb ->> 'effectiveShelvingOrder' AS shelf_order,
	inst.title AS title,
	i.jsonb ->> 'enumeration' AS enumeration,
	i.jsonb ->> 'copyNumber' AS copy_number,
	i.jsonb ->> 'volume' AS volume,
	lmissing.long_missing_note
FROM folio_inventory.item i
LEFT JOIN lmissing ON lmissing.item_hrid = i.jsonb ->> 'hrid'
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_inventory.loclibrary__t AS ll ON ll.id = loc.library_id
WHERE i.jsonb -> 'status' ->> 'name' IN (item_status)
	AND loc.name IN (item_location)
	OR CASE WHEN lib_location = 'ALL' THEN TRUE ELSE ll.name IN (lib_location) END
ORDER BY loc.name, i.jsonb ->> 'effectiveShelvingOrder' ASC
$$
language sql
stable 
parallel safe;
