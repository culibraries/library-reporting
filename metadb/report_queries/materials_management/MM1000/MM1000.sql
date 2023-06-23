--MM9000: Google Book Carts Manifest Report
--This reports returns a list of titles that are checked out to google carts. 
SELECT
u.barcode AS cart,
i.barcode,
former_barcode.jsonb #>> '{}' AS former_barcode
FROM folio_circulation.loan__t__ l
LEFT JOIN folio_inventory.item__t i ON l.item_id = i.id 
LEFT JOIN folio_inventory.item AS ij ON ij.id = i.id 
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(ij.jsonb, 'formerIds')) WITH ORDINALITY AS former_barcode (jsonb)
LEFT JOIN folio_users.users__t u ON l.user_id = u.id 
WHERE u.barcode LIKE 'Google%'
;
