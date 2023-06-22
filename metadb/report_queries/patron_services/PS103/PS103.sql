--PS103: Patron Billing Report
--This report provide information about all fee/fine actions during a specific amount of time. 
WITH primary_address AS (
SELECT *
FROM folio_derived.users_addresses AS ua
WHERE ua.is_primary_address = TRUE)
SELECT
ffa.id,
ffa.date_action AS Action_Date,
ffa.user_id,
a.LOCATION,
pg.GROUP AS patron_group,
u.jsonb ->> 'barcode' AS patron_barcode,
u.jsonb ->> 'username' AS patron_username,
concat(u.jsonb -> 'personal' ->> 'firstName',' ',u.jsonb -> 'personal' ->> 'lastName') AS patron_name,
pa.address_line_1,
pa.address_region,
pa.address_postal_code,
a.barcode AS item_barcode,
a.title AS item_title,
a.call_number AS CallNo,
a.fee_fine_type AS accounts_type,
a.amount AS account_amount,
ffa.type_action AS feefine_action,
ffa.amount_action AS feefine_amount,
ffa.balance AS feefine_balance,
ffa.payment_method AS payment_method,
a.remaining AS accounts_remaining, 
ffa.comments
FROM folio_feesfines.feefineactions__t AS ffa
LEFT JOIN folio_users.users AS u ON ffa.user_id = u.id
LEFT JOIN primary_address AS pa ON u.id = pa.user_id
LEFT JOIN folio_users.groups__t AS pg ON u.patrongroup = pg.id
LEFT JOIN folio_feesfines.accounts__t AS a ON ffa.account_id = a.id 
WHERE a.LOCATION NOT LIKE 'Law%'
--The second date should always be set to the day AFTER the current date. 
AND ffa.date_action BETWEEN '2023-06-19 00:00:00.000' AND '2023-06-23 00:00:00.000'
ORDER BY ffa.date_action DESC
