/** Documentation of Patron Services: Claimed Returned Report 

DERIVED TABLES

TABLES
folio_circulation.loan__t__
folio_inventory.item__t__
folio_inventory.location__t__
folio_inventory.holdings_record__t__
folio_inventory.instance__t__

FILTERS FOR USER TO SELECT:
*/
--Returns a list of all items marked 'Claimed returned.'
SELECT DISTINCT
	lt.item_status AS status,
	lt.claimed_returned_date AS claim_date,
	it.barcode AS barcode,
	lt2.name AS location,
	hrt.call_number AS call_number,
	it.copy_number AS copy_number,
	it.volume AS volume,
	it2.title AS title,
	lt.action_comment AS note,
	lt.user_id AS patron_uuid
FROM folio_circulation.loan__t__ lt 
LEFT JOIN folio_inventory.item__t__ it ON it.id = lt.item_id
LEFT JOIN folio_inventory.location__t__ lt2 ON lt2.id = lt.item_effective_location_id_at_check_out  --or lt2.id = it.effective_location_id 
LEFT JOIN folio_inventory.holdings_record__t__ hrt ON hrt.id = it.holdings_record_id
LEFT JOIN folio_inventory.instance__t__ it2 ON it2.id = hrt.instance_id
WHERE lt.item_status = 'Claimed returned'
	AND call_number IS NOT NULL
ORDER BY claim_date
;
