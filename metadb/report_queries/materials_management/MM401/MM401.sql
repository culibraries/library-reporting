/** Documentation of Materials Management: Gemmill Claims Returned 

Returns a list of all items marked 'Claimed returned' across Engineering, Math and Physics Library.

TABLES
folio_circulation.loan
folio_inventory.item
folio_inventory.item__t
folio_inventory.location
folio_inventory.loclibrary
*/

SELECT 
	l.jsonb -> 'id' AS loan_id,
	i.jsonb -> 'status' ->> 'name' AS status,
	l.jsonb -> 'claimedReturnedDate' AS clm_date,
	it.barcode AS barcode,
	l2.jsonb -> 'name' AS location,
	i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_num,
	i.jsonb -> 'copyNumber' AS cpy,
	i.jsonb -> 'volume' AS vol,
	l.jsonb -> 'actionComment' as clm_note,
	l.jsonb -> 'userId' AS pat_uuid
FROM folio_circulation.loan l 
LEFT JOIN folio_inventory.item i on i.jsonb -> 'id' = l.jsonb -> 'itemId'
LEFT JOIN folio_inventory.item__t it on it.id = i.id
LEFT JOIN folio_inventory."location" l2 on l2.jsonb -> 'id' = i.jsonb -> 'effectiveLocationId'
LEFT JOIN folio_inventory.loclibrary l3 on l3.jsonb -> 'id' = l2.jsonb -> 'libraryId'
where i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
	AND l.jsonb ->> 'itemStatus' = 'Claimed returned'
	AND l3.jsonb ->> 'code' in ('ENG')
	AND l.jsonb ->> 'action' = 'claimedReturned'
	AND i."__current" = true
	AND l."__current" = true
ORDER BY clm_date
;
