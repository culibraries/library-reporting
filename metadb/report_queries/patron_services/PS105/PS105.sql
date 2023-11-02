--PS105: Patron Billing Report - Replacement / Credits
WITH primary_address AS (
SELECT *
FROM folio_derived.users_addresses AS ua
WHERE ua.is_primary_address = TRUE)
SELECT 
ffa.SOURCE,
a.id AS accounts_id,
ffa.id AS action_id,
ffa.date_action::date AS date_action,
a.LOCATION AS item_location,
u.jsonb ->> 'barcode' AS user_barcode,
u.jsonb ->> 'externalSystemId' AS user_externalSystemId,
concat(u.jsonb -> 'personal' ->> 'lastName',', ',u.jsonb -> 'personal' ->> 'firstName') AS user_name,
pa.address_line_1 as "AddressLine1",
CONCAT_WS(' ', CONCAT_WS(', ',pa.address_city, pa.address_region), pa.address_postal_code) as "AddressLine2",
pg.GROUP AS patron_group,
a.barcode AS item_barcode,
a.title AS item_title,
a.call_number AS item_call_number,
sum(a.amount)*-1 AS "Amount",
0 AS "Amount 2",
0 AS "Amount 3",
sum(a.amount) AS "Amt Total",
a.remaining AS accounts_remaining
FROM folio_feesfines.feefineactions__t AS ffa
LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
LEFT JOIN folio_users.users AS u ON ffa.user_id = u.id
LEFT JOIN folio_users.groups__t AS pg ON u.patrongroup = pg.id
LEFT JOIN primary_address AS pa ON u.id = pa.user_id
WHERE ffa.type_action = 'Cancelled item renewed' AND a.fee_fine_type = 'Lost item fee'
and a.LOCATION NOT LIKE 'Law%'
and ffa.source != 'Sierra'
--Enter dates in within the green quotations using the format YYYY-MM-DD
AND ffa.date_action::date BETWEEN '' AND ''
GROUP BY
ffa.SOURCE,
a.id,
ffa.id,
ffa.date_action,
a.LOCATION,
u.jsonb ->> 'barcode',
u.jsonb ->> 'externalSystemId',
concat(u.jsonb -> 'personal' ->> 'lastName',', ',u.jsonb -> 'personal' ->> 'firstName'),
pa.address_line_1,
CONCAT_WS(' ', CONCAT_WS(', ',pa.address_city, pa.address_region), pa.address_postal_code),
pg.GROUP,
a.barcode,
a.title,
a.call_number,
a.amount,
a.remaining
ORDER BY concat(u.jsonb -> 'personal' ->> 'lastName',', ',u.jsonb -> 'personal' ->> 'firstName'), a.id, ffa.id DESC 
