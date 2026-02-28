--metadb:function waived_fines_individual

drop function if exists waived_fines_individual;

create function waived_fines_individual(
	start_date date DEFAULT '2000-01-01',
 	end_date date DEFAULT '2999-01-01',
 	material_type_name_search text default ''
)
returns table(
"Patron Name" text,
"Ext Sys ID" text,
"Date Waived" date,
"Fine Type" text,
"Waived Amount" text,
"Status" text,
"Comments" text,
"Material Type" text,
"Barcode" text,
"Call Number" text,
"Volume" text
)
as $$
SELECT DISTINCT
	--CONCAT(u.jsonb -> 'personal' ->> 'lastName',', ', u.jsonb -> 'personal' ->> 'firstName') AS "Patron Name",
	FORMAT('"%s, %s"',
       u.jsonb -> 'personal' ->> 'lastName',
       u.jsonb -> 'personal' ->> 'firstName') AS "Patron Name",
	u.jsonb ->> 'externalSystemId' AS "Ext Sys ID",
	ffa.date_action::date AS "Date Waived", 
	a.jsonb ->> 'feeFineType' AS "Fine Type",
	a.jsonb ->> 'amount' AS "Waived Amount",
	a.jsonb -> 'paymentStatus' ->> 'name' AS "Status",
	ffa."comments" AS "Comments",
	a.jsonb ->> 'materialType' AS "Material Type",
	a.jsonb ->> 'barcode' AS "Barcode",
	a.jsonb ->> 'callNumber' AS "Call Number",
	i.jsonb ->> 'volume' AS "Volume"
FROM folio_feesfines.accounts a
LEFT JOIN folio_inventory.item i ON i.id = (a.jsonb ->> 'itemId')::uuid
LEFT JOIN folio_users.users u ON u.id = (a.jsonb ->> 'userId')::uuid
LEFT JOIN folio_feesfines.feefineactions__t ffa on ffa.account_id = a.id
WHERE start_date <= ffa.date_action::date and end_date >= ffa.date_action::date
	AND a.jsonb ->> 'materialType' ilike Concat('%',material_type_name_search,'%')
	AND a.jsonb -> 'paymentStatus' ->> 'name' IN ('Waived fully','Waived partially')
	AND a.jsonb ->> 'feeFineOwner' IN ('Patron Accounts','University Libraries')
	AND ffa.type_action IN ('Waived fully','Waived partially')
ORDER BY "Date Waived" asc
$$
language sql
stable 
parallel safe;
