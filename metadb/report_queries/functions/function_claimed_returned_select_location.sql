--metadb:function claimed_returned_select_location

drop function if exists claimed_returned_select_location;

create function claimed_returned_select_location(
location_name_1 text,
location_name_2 text,
location_name_3 text
)
returns table(
"Claimed Date" date,
"Barcode" text,
"Location Name" text,
"Call Number" text,
"Copy" text,
"Volume" text,
"Claim Note" text,
"Loan ID" text,
"User Name" text,
"User Email" text
)
as $$
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
WHERE CASE
	WHEN location_name_1 = 'ALL' THEN l3.jsonb ->> 'name' in ('Norlin', 'Business', 'Music', 'Offsite', 'INN-REACH', 'Earth Sciences & Map', 'Engineering Math & Physics')
	ELSE l3.jsonb ->> 'name' IN (location_name_1, location_name_2, location_name_3)
END 
AND i.jsonb -> 'status' ->> 'name' = 'Claimed returned'
AND l.jsonb ->> 'action' = 'claimedReturned'
ORDER BY "Claimed Date" asc, "User Name"
$$
language sql
stable 
parallel safe;
