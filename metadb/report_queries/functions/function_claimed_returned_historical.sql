--metadb:function claimed_returned_historical

drop function if exists claimed_returned_historical;

create function claimed_returned_historical(
	start_date date DEFAULT '2000-01-01',
 	end_date date DEFAULT '2999-01-01'
)
returns table(
"Claimed Date" date,
"Item Location" text,
"Material Type" text,
"Barcode" text,
"Call Number" text,
"Volume" text,
"Checkout Point" text,
"Patron Group" text,
"Loan ID" text
)
as $$
SELECT 
	(al2.jsonb -> 'loan' -> 'metadata' ->> 'updatedDate')::date as "Claimed Date",
	l2.jsonb ->> 'name' AS "Item Location",
	mt.jsonb ->> 'name' as "Material Type",
	i.jsonb ->> 'barcode' as "Barcode",
	i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' as "Call Number",
	i.jsonb ->> 'volume' AS "Volume",
 	sp.jsonb ->> 'name' as "Checkout Point",
	g.jsonb ->> 'group' as "Patron Group",
	al2.jsonb -> 'loan' ->> 'id' AS "Loan ID"
FROM folio_circulation.audit_loan al2
LEFT JOIN folio_inventory.item i on i.id = (al2.jsonb -> 'loan' ->> 'itemId')::uuid
LEFT JOIN folio_inventory.material_type mt on mt.id = (i.jsonb ->> 'materialTypeId')::uuid
LEFT JOIN folio_inventory."location" l2 on l2.id = (al2.jsonb -> 'loan' ->> 'itemEffectiveLocationIdAtCheckOut')::uuid
left join folio_inventory.service_point sp on sp.id = (al2.jsonb -> 'loan' ->> 'checkoutServicePointId')::uuid
left join folio_users."groups" g on g.id = (al2.jsonb -> 'loan' ->> 'patronGroupIdAtCheckout')::uuid
where al2.jsonb -> 'loan' ->> 'action' = 'claimedReturned'	
	and start_date <= (al2.jsonb -> 'loan' -> 'metadata' ->> 'updatedDate')::date and end_date >= (al2.jsonb -> 'loan' -> 'metadata' ->> 'updatedDate')::date
	and l2.jsonb ->> 'name' not like '%Law%'
ORDER BY "Item Location" asc, "Claimed Date" asc
$$
language sql
stable 
parallel safe;
