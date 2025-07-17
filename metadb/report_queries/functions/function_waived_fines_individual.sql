--metadb:function waived_fines_individual

drop function if exists waived_fines_individual;

create function waived_fines_individual(
	start_date date DEFAULT '2000-01-01',
 	end_date date DEFAULT '2999-01-01'
)
returns table(
"Patron Name" text,
"Ext Sys ID" text,
"Date Waived" date,
"Fine Type" text,
"Waived Amount" text,
"Material Type" text,
"Barcode" text,
"Call Number" text,
"Volume" text
)
as $$
SELECT DISTINCT
	CONCAT(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "Patron Name",
	u.jsonb ->> 'externalSystemId' AS "Ext Sys ID",
	(a.jsonb -> 'metadata' ->> 'updatedDate')::date AS "Date Waived", 
	a.jsonb ->> 'feeFineType' AS "Fine Type",
	a.jsonb ->> 'amount' AS "Waived Amount",
	a.jsonb ->> 'materialType' AS "Material Type",
	a.jsonb ->> 'barcode' AS "Barcode",
	a.jsonb ->> 'callNumber' AS "Call Number",
	i.jsonb ->> 'volume' AS "Volume"
FROM folio_feesfines.accounts a
LEFT JOIN folio_inventory.item i ON i.id = (a.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users u ON u.id = (a.jsonb ->> 'userId')::uuid
WHERE a.jsonb -> 'paymentStatus' ->> 'name' = 'Waived fully'
	and start_date <= (a.jsonb -> 'metadata' ->> 'updatedDate')::date and end_date >= (a.jsonb -> 'metadata' ->> 'updatedDate')::date
	--AND (a.jsonb -> 'metadata' ->> 'updatedDate')::date BETWEEN '2024-7-01' AND '2025-6-30'
	AND a.jsonb ->> 'feeFineOwner' IN ('Patron Accounts','University Libraries')
ORDER BY "Date Waived" asc
$$
language sql
stable 
parallel safe;
