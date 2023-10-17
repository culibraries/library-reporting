--MM503: Music Library Missing Books MS2 Report
SELECT 
i.jsonb -> 'status' ->> 'name' AS item_status,
loc.name AS item_location,
i.jsonb ->> 'barcode' AS item_barcode,
i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_number,
i.jsonb ->> 'effectiveShelvingOrder' AS shelf_order,
inst.title AS title,
i.jsonb ->> 'enumeration' AS enumeration,
i.jsonb ->> 'copyNumber' AS volume,
i.jsonb ->> 'volume' AS copy_number
FROM folio_inventory.item i
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
WHERE jsonb_extract_path_text(i.jsonb, 'tags', 'tagList') LIKE '%ms2%'
AND loc.library_id = '6fdc53e5-32c9-460a-b514-deb876dbe7c5'
;
