/** Documentation of Materials Management: Music Claims Returned

Returns a list of all items marked 'Claimed returned' across Music Library.

TABLES
folio_circulation.loan
folio_inventory.item
folio_users.users
folio_inventory.location__t
folio_inventory.loclibrary__t
folio_inventory.holdings_record__t
*/

SELECT 
	(i.jsonb -> 'status' ->> 'date')::DATE as claimed_date,
	i.jsonb ->> 'barcode' as barcode,
	lt.discovery_display_name as location,
	holdings.call_number as call_number,
	i.jsonb ->> 'copyNumber' AS cpy,
	i.jsonb ->> 'volume' AS vol,
	l.jsonb ->> 'actionComment' as claim_note,
	l.jsonb ->> 'id' AS loan_id,
	concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS user_name,
	u.jsonb -> 'personal' ->> 'email' as user_email,
	l.jsonb ->> 'userId' AS user_id
FROM folio_circulation.loan l 
LEFT JOIN folio_inventory.item i on i.id = (l.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users as u on u.id = (l.jsonb ->> 'userId')::uuid
LEFT JOIN folio_inventory.location__t lt  on lt.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.loclibrary__t lt2 on lt2.id = lt.library_id 
LEFT JOIN folio_inventory.holdings_record__t as holdings on holdings.id = i.holdingsrecordid
where i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
	AND l.jsonb ->> 'itemStatus' = 'Claimed returned'
	AND l.jsonb ->> 'action' = 'claimedReturned'
	and lt2.code in ('MUS') 
ORDER BY claimed_date asc
;
