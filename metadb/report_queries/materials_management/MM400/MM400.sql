--MM400: Engineering Math and Physics Missing Books
--Returns a list of all items that are marked 'Missing' across all Gemmill Library locations.
SELECT 
loc.name AS LOCATION,
i.barcode, 
h.call_number,
i.volume,
inst.index_title,
jsonb_extract_path_text(ij.jsonb, 'status', 'name') AS status_name
FROM folio_inventory.item__t AS i
LEFT JOIN folio_inventory.holdings_record__t AS h ON i.holdings_record_id = h.id
LEFT JOIN folio_inventory.instance__t AS inst ON h.instance_id = inst.id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = i.effective_location_id
LEFT JOIN folio_inventory.loclibrary__t AS lib ON lib.id = loc.library_id
LEFT JOIN folio_inventory.item AS ij ON ij.id = i.id
WHERE 
jsonb_extract_path_text(ij.jsonb, 'status', 'name') = 'Missing'
AND lib.name = 'Engineering Math & Physics'
ORDER BY loc.name, h.call_number
;
