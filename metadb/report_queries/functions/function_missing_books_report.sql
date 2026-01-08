--metadb:function missing_books_report

drop function if exists missing_books_report;

create function missing_books_report(
	lib_location text)
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
	volume text
)
as $$
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
	i.jsonb ->> 'volume' AS volume
FROM folio_inventory.item i
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_inventory.loclibrary__t AS ll ON ll.id = loc.library_id
WHERE i.jsonb -> 'status' ->> 'name' = 'Missing'
	and case when lib_location = 'ALL' then true else ll.name in (lib_location) end
ORDER BY loc.name, i.jsonb ->> 'effectiveShelvingOrder' ASC
$$
language sql
stable 
parallel safe;
