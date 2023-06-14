--MM100 Google Books Cart Manifests Report
--This reports returns a list of titles that are checked out to google carts. 
--NEED TO ADD FORMER IDENTIFIER AFTER NEXT DRY RUN
SELECT
u.barcode,
i.barcode
FROM folio_circulation.loan__t__ l
LEFT JOIN folio_inventory.item__t i ON l.item_id = i.id 
LEFT JOIN folio_users.users__t u ON l.user_id = u.id 
WHERE u.barcode LIKE 'Google%'
