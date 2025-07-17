--metadb:function outstanding_tech_fines

drop function if exists outstanding_tech_fines;

create function outstanding_tech_fines(
	start_date date DEFAULT '2000-01-01',
 	end_date date DEFAULT '2999-01-01'
)
returns table(
"Updated" date,
"Status" text,
"Material Type" text,
"Barcode" text,
"Call Number" text,
"Volume" text,
"Fine Remaining" text,
"Patron Barcode" text
)
as $$
SELECT DISTINCT
	(a.jsonb -> 'metadata' ->> 'updatedDate')::date as "Updated",	
	a.jsonb -> 'itemStatus' ->> 'name' as "Status",
	a.jsonb ->> 'materialType' as "Material Type",
	a.jsonb ->> 'barcode' as "Barcode",
	a.jsonb ->> 'callNumber' as "Call Number",
	i.jsonb ->> 'volume' AS "Volume",
	--a.jsonb ->> 'loanId' as "Loan",
	a.jsonb ->> 'remaining' as "Fine Remaining",
	--CONCAT(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "Patron Name",
	(u.jsonb ->> 'barcode') AS "Patron Barcode"
FROM folio_feesfines.accounts a
LEFT JOIN folio_inventory.item i on i.id = (a.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users u on u.id = (a.jsonb ->> 'userId')::uuid
WHERE  a.jsonb -> 'status' ->> 'name' = 'Open'
	and start_date <= (a.jsonb -> 'metadata' ->> 'updatedDate')::date and end_date >= (a.jsonb -> 'metadata' ->> 'updatedDate')::date
	and a.jsonb ->> 'materialType' in ('3 Day Tech Items','4 Hour Tech Items','3D item 4 hour loan','3D item 3 day loan','3D item semester loan',
	'Misc Tech/Supply','7 Day Loan','Park Pass','MELL','iClicker','iClicker Kit','Hotspot','Laptop','Key','Lock')
	--and a.jsonb ->> 'location' not like '%law%'
	--and a.jsonb ->> 'feeFineType' not like '%Law%'
	and a.jsonb ->> 'feeFineOwner' in ('Patron Accounts','University Libraries')
	and a.jsonb ->> 'feeFineType' = 'Lost item fee'
ORDER BY "Material Type"
$$
language sql
stable 
parallel safe;
