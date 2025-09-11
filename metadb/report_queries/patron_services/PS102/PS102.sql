/** Documentation of Patron Services: Claimed Returned Report 

Returns a list of all items marked 'Claimed returned' across all library locations and Pascal.

TABLES
folio_circulation.loan
folio_inventory.item
folio_users.users
folio_inventory.location
folio_inventory.loclibrary
*/

SELECT 
	(l.jsonb ->> 'claimedReturnedDate')::date AS "Claimed Date",
	i.jsonb ->> 'barcode' as "Barcode",
	l2.jsonb ->> 'name' AS "Location Name",
	i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS "Call Number",
	i.jsonb ->> 'copyNumber' AS "Copy",
	i.jsonb ->> 'volume' AS "Volume",
	l.jsonb ->> 'actionComment' as "Claim Note",
	l.jsonb ->> 'id' AS "Loan ID",
	concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "User Name",
	u.jsonb -> 'personal' ->> 'email' as "User Email"
FROM folio_circulation.loan l 
LEFT JOIN folio_inventory.item i on i.id = (l.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users as u on u.id = (l.jsonb ->> 'userId')::uuid
LEFT JOIN folio_inventory.location l2 on l2.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.loclibrary l3 on l3.id = (l2.jsonb ->> 'libraryId')::uuid
WHERE l3.jsonb ->> 'code' in ('NOR','BUS','MUS','OFF','ESC','ENG','INN-REACH')
	AND i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
	AND l.jsonb ->> 'action' = 'claimedReturned' 
ORDER BY "Claimed Date" asc, "Location Name"
;

--Location names from L3 LocLibrary: Norlin, Business, Music, Offsite, INN-REACH, Earth Sciences & Map, Engineering Math & Physics
--Location codes: NOR, BUS, MUS, OFF, INN-REACH, ESC, ENG
