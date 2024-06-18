-- PS112: Patron Billing Report: Combined Reports
-- This report provide information on all fee/fine actions during a specific amount of time
--   and in the specifed format needed by the internal Patron Fines Access DB.
WITH parameters AS (
  SELECT
    -- fee fine action date starting (inclusive).  This needs to be cast to DATE.  IE: 'YYYY-MM-DD'::DATE
    '2023-06-15'::DATE as invoice_interval_start,
    -- fee fine action date ending (not inclusive). IE: 'YYYY-MM-DD'::DATE or just the string CURRENT_DATE for upto today
    CURRENT_DATE as invoice_interval_end
),
primary_address AS (
  SELECT
    user_id,
    address_line_1 AS address1,
    CONCAT_WS(' ', CONCAT_WS(', ',address_city, address_region), address_postal_code) AS address2
  FROM
    folio_derived.users_addresses AS ua
  WHERE
    ua.is_primary_address = TRUE
),
-- combine the lost item fee and lost item processing fee
lost_fee AS (
  SELECT
    -- group the invoice date down to minute comparison, since the Lost Item Fee and Lost Item Processing Fee have action timestamps of microseconds differences
    date_trunc('minute', ffa.date_action) AS invoice_date,
    ffa.user_id,
    a.item_id,
    a.barcode AS item_barcode,
    a.title AS item_title,
    a.call_number AS item_call_number,
    a.location AS item_location,
    STRING_AGG(ffa.id::varchar, ',') AS invoice_id,
    SUM(ffa.amount_action)
      FILTER (WHERE LOWER(a.fee_fine_type)=LOWER('Lost item fee') AND LOWER(ffa.type_action)=LOWER('Lost item fee')) AS amount,
    SUM(ffa.amount_action)
      FILTER (WHERE LOWER(a.fee_fine_type)=LOWER('Lost item processing fee') AND LOWER(ffa.type_action)=LOWER('Lost item processing fee')) as amount2,
     NULL::integer AS amount3,
    'Rep Charge' AS label_amount,
    'Lost item processing fee' AS label_amount2,
    '' AS label_amount3,
    'Replacement' AS type
  FROM
    folio_feesfines.feefineactions__t AS ffa
  LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
  WHERE
    ffa.source != 'Sierra'
    AND a.LOCATION NOT LIKE 'Law%'
    AND ffa.date_action >= (SELECT invoice_interval_start FROM parameters)
    AND ffa.date_action < (SELECT invoice_interval_end FROM parameters)
  GROUP BY
    ffa.user_id,
    a.item_id,
    invoice_date,
    a.barcode,
    a.title,
    a.call_number,
    a.location
),
-- combine the Cancelled item returned/renewed Rep Credit and the Cancelled item returned Rep Proc Fee Credit
lost_fee_credit AS (
  SELECT
    -- group the invoice date down to minute comparison, since the Lost Item Fee and Lost Item Processing Fee have action timestamps of microseconds differences
    date_trunc('minute', ffa.date_action) AS invoice_date,
    ffa.user_id,
    a.item_id,
    a.barcode AS item_barcode,
    a.title AS item_title,
    a.call_number AS item_call_number,
    a.location AS item_location,
    STRING_AGG(ffa.id::varchar, ',') AS invoice_id,
    ABS(SUM(ffa.amount_action)
      FILTER (WHERE LOWER(a.fee_fine_type)=LOWER('Lost item fee') AND (LOWER(ffa.type_action)=LOWER('Cancelled item returned') OR LOWER(ffa.type_action)=LOWER('Cancelled item renewed')))) * -1 AS amount,
    ABS(SUM(ffa.amount_action)
      FILTER (WHERE LOWER(a.fee_fine_type)=LOWER('Lost item processing fee') AND (LOWER(ffa.type_action)=LOWER('Cancelled item returned') OR LOWER(ffa.type_action)=LOWER('Cancelled item renewed')))) * -1 AS amount2,
    NULL::integer AS amount3,
    'Rep Credit' AS label_amount,
    'Rep Proc Fee Credit' AS label_amount2,
    '' AS label_amount3,
    'OverdueX' AS type
  FROM
    folio_feesfines.feefineactions__t AS ffa
  LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
  WHERE
    ffa.source != 'Sierra'
    AND a.LOCATION NOT LIKE 'Law%'
    AND ffa.date_action >= (SELECT invoice_interval_start FROM parameters)
    AND ffa.date_action < (SELECT invoice_interval_end FROM parameters)
  GROUP BY
    ffa.user_id,
    a.item_id,
    invoice_date,
    a.barcode,
    a.title,
    a.call_number,
    a.location
),
overdue_fine AS (
  SELECT
    -- group the invoice date down to minute comparison, since the Lost Item Fee and Lost Item Processing Fee have action timestamps of microseconds differences
    date_trunc('minute', ffa.date_action) AS invoice_date,
    ffa.user_id,
    a.item_id,
    a.barcode AS item_barcode,
    a.title AS item_title,
    a.call_number AS item_call_number,
    a.location AS item_location,
    STRING_AGG(ffa.id::varchar, ',') AS invoice_id,
    NULL::integer AS amount,
    NULL::integer AS amount2,
    SUM(ffa.amount_action) AS amount3,
    '' AS label_amount,
    '' AS label_amount2,
    'Fine' AS label_amount3,
    'Overdue' AS type
  FROM
    folio_feesfines.feefineactions__t AS ffa
  LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
  WHERE
    ffa.source != 'Sierra'
    AND a.LOCATION NOT LIKE 'Law%'
    AND a.fee_fine_type = 'Overdue fine'
    AND ffa.type_action  = 'Overdue fine'
    AND ffa.date_action >= (SELECT invoice_interval_start FROM parameters)
    AND ffa.date_action < (SELECT invoice_interval_end FROM parameters)
  GROUP BY
    ffa.user_id,
    a.item_id,
    invoice_date,
    a.barcode,
    a.title,
    a.call_number,
    a.location
),
replacement_fee AS (
  SELECT
    -- group the invoice date down to minute comparison, since the Lost Item Fee and Lost Item Processing Fee have action timestamps of microseconds differences
    date_trunc('minute', ffa.date_action) AS invoice_date,
    ffa.user_id,
    a.item_id,
    a.barcode AS item_barcode,
    a.title AS item_title,
    a.call_number AS item_call_number,
    a.location AS item_location,
    STRING_AGG(ffa.id::varchar, ',') AS invoice_id,
    SUM(ffa.amount_action) AS amount,
    NULL::integer AS amount2,
    NULL::integer AS amount3,
    'Rep Charge' AS label_amount,
    '' AS label_amount2,
    '' AS label_amount3,
    'Manual' AS type
  FROM
    folio_feesfines.feefineactions__t AS ffa
  LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
  WHERE
    ffa.source != 'Sierra'
    AND a.LOCATION NOT LIKE 'Law%'
    AND a.fee_fine_type = 'Replacement Fee'
    AND ffa.type_action  = 'Replacement Fee'
    AND ffa.date_action >= (SELECT invoice_interval_start FROM parameters)
    AND ffa.date_action < (SELECT invoice_interval_end FROM parameters)
  GROUP BY
    ffa.user_id,
    a.item_id,
    invoice_date,
    a.barcode,
    a.title,
    a.call_number,
    a.location
),
-- Combine all the manual fees (except for Replacement Fee).  This includes:
--   Other, Damage Fee, and Repl Processing Fee 
manual_fees as (
  SELECT
    -- group the invoice date down to minute comparison, since the Lost Item Fee and Lost Item Processing Fee have action timestamps of microseconds differences
    date_trunc('minute', ffa.date_action) AS invoice_date,
    ffa.user_id,
    a.item_id,
    a.barcode AS item_barcode,
    a.title AS item_title,
    a.call_number AS item_call_number,
    a.location AS item_location,
    STRING_AGG(ffa.id::varchar, ',') AS invoice_id,
    NULL::integer AS amount,
    NULL::integer AS amount2,
    SUM(ffa.amount_action) AS amount3,
    '' AS label_amount,
    '' AS label_amount2,
    'Fine' AS label_amount3,
    'Manual' AS type
  FROM
    folio_feesfines.feefineactions__t AS ffa
  LEFT JOIN folio_feesfines.accounts__t AS a ON a.id = ffa.account_id
  WHERE
    ffa.source != 'Sierra'
    AND a.LOCATION NOT LIKE 'Law%'
    AND (
      (a.fee_fine_type = 'Other' and ffa.type_action  = 'Other')
      or (a.fee_fine_type = 'Damage Fee' and ffa.type_action  = 'Damage Fee')
      or (a.fee_fine_type = 'Repl Processing Fee' and ffa.type_action  = 'Repl Processing Fee')
    )
    AND ffa.date_action >= (SELECT invoice_interval_start FROM parameters)
    AND ffa.date_action < (SELECT invoice_interval_end FROM parameters)
  GROUP BY
    ffa.user_id,
    a.item_id,
    invoice_date,
    a.barcode,
    a.title,
    a.call_number,
    a.location
)
SELECT
  CONCAT(
    '1',
    TO_CHAR(CURRENT_DATE, 'MMDDYY'),
    LPAD((ROW_NUMBER() OVER (
      ORDER BY 
        CONCAT(u.jsonb -> 'personal' ->> 'lastName',', ',u.jsonb -> 'personal' ->> 'firstName'),
        item_barcode, 
        patron_fines.invoice_date)
      )::text, 4, '0') 
    ) AS "LineNum",
  patron_fines.invoice_id AS "InvoiceNo",
  patron_fines.invoice_date::date AS "InvDate",
  patron_fines.item_location AS "Location",
  u.jsonb ->> 'barcode'::text AS "PatronNo",
  u.jsonb ->> 'externalSystemId'::text AS "ID",
  CONCAT(u.jsonb -> 'personal' ->> 'lastName',', ',u.jsonb -> 'personal' ->> 'firstName') AS "Name",
  '' AS "Name2",
  pa.address1 AS "Address1",
  pa.address2 AS "Address2",
  '' AS "Country",
  '' AS "P1",
  '' AS "P2",
  '' AS "P3",
  pg.GROUP AS "pType",
  patron_fines.item_barcode AS "ItemBarcode",
  patron_fines.item_title AS "ItemTitle",
  patron_fines.item_call_number AS "CallNo",
  patron_fines.type AS "TYPE",
  CASE
    WHEN (patron_fines.amount IS NOT NULL) THEN patron_fines.amount ELSE 0
  END AS "Amount",
  CASE
    WHEN (patron_fines.amount2 IS NOT NULL) THEN patron_fines.amount2 ELSE 0
  END AS "Amount2",
  CASE
    WHEN (patron_fines.amount3 IS NOT NULL) THEN patron_fines.amount3 ELSE 0
  END AS "Amount3",
  COALESCE(patron_fines.amount, 0) + COALESCE(patron_fines.amount2, 0) + COALESCE(patron_fines.amount3, 0) AS "AmtTotal",
  CURRENT_DATE AS "RprtDate",
  (DATE_TRUNC('month', NOW()) + INTERVAL '1 month - 1 day')::DATE AS "CutOffDate",
  (DATE_TRUNC('month', NOW()) + INTERVAL '2 month - 1 day')::DATE AS "DueDateInv",
  '' AS "CheckNo",
  '' AS "DatePaid",
  '' AS "AmtPaid",
  '' AS "WhoEntered",
  '' AS "DateToCashiers",
  '' AS "AcctStatus",
  '' AS "DateNoticeSent",
  '' AS "DateToCollection",
  '' AS "PaidOKToMove",
  '' AS "Notes",
  CASE
    WHEN (patron_fines.amount IS NOT NULL) THEN patron_fines.label_amount ELSE 'NA'
  END AS "LblAmt",
  CASE
    WHEN (patron_fines.amount2 IS NOT NULL) THEN patron_fines.label_amount2 ELSE 'NA'
  END AS "LblAmt2",
  CASE
    WHEN (patron_fines.amount3 IS NOT NULL) THEN patron_fines.label_amount3 ELSE 'NA'
  END AS "LblAmt3",
  'AmtTotal1' as "AmtTotal1"
-- get all the results from each of the separate reports
FROM (
  (SELECT * FROM lost_fee WHERE NOT (lost_fee.amount IS NULL AND lost_fee.amount2 IS NULL AND lost_fee.amount3 IS NULL))
  UNION ALL
  (SELECT * FROM lost_fee_credit WHERE NOT (lost_fee_credit.amount IS NULL AND lost_fee_credit.amount2 IS NULL AND lost_fee_credit.amount3 IS NULL))
  UNION ALL
  (SELECT * FROM overdue_fine)
  UNION ALL
  (SELECT * FROM replacement_fee)
  UNION ALL
  (SELECT * FROM manual_fees)
) AS patron_fines
LEFT JOIN folio_users.users AS u ON patron_fines.user_id = u.id
LEFT JOIN folio_users.groups__t AS pg ON u.patrongroup = pg.id
LEFT JOIN primary_address AS pa ON u.id = pa.user_id
WHERE
  -- Do not look at patrons from group Library Department
 pg.id != 'c4a4cae4-d4a8-5e63-ba36-6b579e4ad5b6'
ORDER BY
  "Name",
  item_barcode,
  patron_fines.invoice_date
