--PS111: Patron Billing Report: All details
--This report provide information about all fee/fine actions during a specific amount of time. 
WITH primary_address AS (
SELECT *
FROM folio_derived.users_addresses AS ua
WHERE ua.is_primary_address = TRUE)
SELECT
ffa.SOURCE,
ffa.id AS action_id,
ffa.date_action::date AS Action_Date,
ffa.user_id,
u.jsonb ->> 'barcode' AS user_barcode,
u.jsonb ->> 'externalSystemId' AS user_externalSystemId,
u.jsonb ->> 'username' AS user_username,
concat(u.jsonb -> 'personal' ->> 'firstName',' ',u.jsonb -> 'personal' ->> 'lastName') AS user_name,
a.fee_fine_type AS account_fee_fine_type,
a.amount AS account_original_amount,
ffa.type_action AS feefine_action,
ffa.amount_action AS fee_fine_action_amount,
ffa.payment_method AS payment_method,
a.remaining AS accounts_remaining,
ffa.COMMENTS,
pg.GROUP AS patron_group,
pa.address_line_1,
pa.address_region,
pa.address_postal_code,
a.LOCATION AS item_location,
a.barcode AS item_barcode,
a.title AS item_title,
a.call_number AS item_call_number
FROM folio_feesfines.feefineactions__t__ AS ffa
LEFT JOIN folio_users.users AS u ON ffa.user_id = u.id
LEFT JOIN primary_address AS pa ON u.id = pa.user_id
LEFT JOIN folio_users.groups__t AS pg ON u.patrongroup = pg.id
LEFT JOIN folio_feesfines.accounts__t AS a ON ffa.account_id = a.id 
WHERE a.LOCATION NOT LIKE 'Law%'
AND ffa.source != 'Sierra'
--Enter dates for when the action occurred. Use format YYYY-MM-DD
AND ffa.date_action::date BETWEEN '' AND ''
ORDER BY user_username, item_title, ffa.date_action DESC
