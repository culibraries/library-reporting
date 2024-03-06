/** Documentation of Materials Management: Music Claims Returned

Returns a list of all items marked 'Claimed returned' across Music Library.

TABLES
folio_circulation.loan__
folio_inventory.item__
folio_inventory.location__
folio_inventory.loclibrary__
*/

SELECT DISTINCT
	l.jsonb -> 'id' AS loan_id,
	i.jsonb -> 'status' ->> 'name' AS status,
	l.jsonb -> 'claimedReturnedDate' AS clm_date,
	i.jsonb -> 'barcode' AS barcode,
	l2.jsonb -> 'name' AS location,
	i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_num,
	i.jsonb -> 'copyNumber' AS cpy,
	i.jsonb -> 'volume' AS vol,
	l.jsonb -> 'actionComment' as clm_note,
	l.jsonb -> 'userId' AS pat_uuid
FROM folio_circulation.loan__ l
LEFT JOIN folio_inventory.item__ i on i.jsonb -> 'id' = l.jsonb -> 'itemId'
LEFT JOIN folio_inventory.location__ l2  on l2.jsonb -> 'id' = i.jsonb -> 'effectiveLocationId'
LEFT JOIN folio_inventory.loclibrary__ l3 on l3.jsonb -> 'id' = l2.jsonb -> 'libraryId'
where i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
	AND l.jsonb ->> 'itemStatus' = 'Claimed returned'
	AND l3.jsonb ->> 'code' in ('MUS')
	and l.jsonb ->> 'action' = 'claimedReturned'
	--AND i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' IS NOT null
	AND l.jsonb -> 'claimedReturnedDate' IS NOT null
	AND l.jsonb -> 'userId' IS NOT null
ORDER BY clm_date
;
