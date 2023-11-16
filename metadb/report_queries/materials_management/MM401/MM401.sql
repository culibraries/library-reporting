/** Documentation of Materials Management: Gemmill Claims Returned 

DERIVED TABLES

TABLES
folio_circulation.loan__
folio_circulation.loan__t__
folio_inventory.item__t__
folio_inventory.location__t__
folio_inventory.holdings_record__t__
folio_inventory.instance__t__

FILTERS FOR USER TO SELECT:
*/
--Returns a list of all items marked 'Claimed returned' across selected Engineering, Math, Physics Library locations.
SELECT DISTINCT
	lsc.id AS loan_id,
	lsc.jsonb -> 'itemStatus' AS lsc_status,
	lt.item_status AS lt_status,
	lt.claimed_returned_date AS claim_date,
	it.barcode AS barcode,
	lt2.name AS location,
	hrt.call_number AS call_number,
	it.copy_number AS copy,
	it.volume AS vol,
	it2.title AS title,
	lt.action_comment AS claim_note,
	lt.user_id AS patron_uuid
FROM folio_circulation.loan__ lsc
LEFT JOIN folio_circulation.loan__t__ lt ON lt.id = lsc.id
LEFT JOIN folio_inventory.item__t__ it ON it.id = lt.item_id
LEFT JOIN folio_inventory.location__t__ lt2 ON lt2.id = lt.item_effective_location_id_at_check_out   
LEFT JOIN folio_inventory.holdings_record__t__ hrt ON hrt.id = it.holdings_record_id
LEFT JOIN folio_inventory.instance__t__ it2 ON it2.id = hrt.instance_id
WHERE lsc.jsonb ->> 'itemStatus' = 'Claimed returned'
	AND lt.item_status = 'Claimed returned'
	AND lt2.code IN ('ENG','ENGRES','ENGOV','ENGPOP','ENGST', 'ENGPS','ENGMC','ENGOS')
	AND hrt.call_number IS NOT null
	AND lt.claimed_returned_date IS NOT null
	AND lt.user_id IS NOT null
ORDER BY claim_date
;
