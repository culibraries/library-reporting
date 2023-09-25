--CM111: Gov Docs Call Number Report
WITH first_field_086 AS (
SELECT 
instance_hrid,
marc.sf,
string_agg (DISTINCT content,' |||| ') AS field_086$a
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '086'
AND marc.sf = 'a'
AND marc.ord = 1
GROUP BY marc.instance_hrid, marc.sf
ORDER BY instance_hrid ASC
),
first_field_099 AS (
SELECT 
marc.instance_hrid,
marc.sf,
string_agg (DISTINCT content,' |||| ') AS field_099$a
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '099'
AND marc.sf = 'a'
AND marc.ord = 1
GROUP BY marc.instance_hrid, marc.sf
ORDER BY instance_hrid ASC
),
first_field_092 AS (
SELECT 
marc.instance_hrid,
marc.sf,
string_agg (DISTINCT content,' |||| ') AS field_092$a
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '092'
AND marc.sf = 'a'
AND marc.ord = 1
GROUP BY marc.instance_hrid, marc.sf
ORDER BY instance_hrid ASC
),
first_field_050 AS (
SELECT 
marc.instance_hrid,
marc.sf,
string_agg (DISTINCT content,' |||| ') AS field_050$a
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '050'
AND marc.sf = 'a'
AND marc.ord = 1
GROUP BY marc.instance_hrid, marc.sf
ORDER BY instance_hrid ASC
),
first_field_055 AS (
SELECT 
marc.instance_hrid,
marc.sf,
string_agg (DISTINCT content,' |||| ') AS field_055$a
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '055'
AND marc.sf = 'a'
AND marc.ord = 1
GROUP BY marc.instance_hrid, marc.sf
ORDER BY instance_hrid ASC
)
SELECT
i.hrid AS item_hrid,
holdings.hrid AS holdings_hrid,
inst.hrid AS instance_hrid,
i.item_level_call_number,
cnt.name AS item_call_number_type,
hloc.name AS holdings_location,
holdings.call_number AS holdings_call_number,
hcnt.name AS holdings_call_number_type,
first_field_086.field_086$a,
first_field_099.field_099$a,
first_field_092.field_092$a,
first_field_050.field_050$a,
first_field_055.field_055$a
FROM folio_inventory.item__t AS i
LEFT JOIN folio_inventory.call_number_type__t AS cnt ON cnt.id = i.item_level_call_number_type_id
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdings_record_id
LEFT JOIN folio_inventory.call_number_type__t AS hcnt ON hcnt.id = holdings.call_number_type_id
LEFT JOIN folio_inventory.location__t AS hloc ON hloc.id = holdings.effective_location_id
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN first_field_086 ON first_field_086.instance_hrid = inst.hrid 
LEFT JOIN first_field_099 ON first_field_099.instance_hrid = inst.hrid 
LEFT JOIN first_field_092 ON first_field_092.instance_hrid = inst.hrid 
LEFT JOIN first_field_050 ON first_field_050.instance_hrid = inst.hrid 
LEFT JOIN first_field_055 ON first_field_055.instance_hrid = inst.hrid 
WHERE hloc.name LIKE '%Gov%'
AND first_field_086.field_086$a NOTNULL
AND i.item_level_call_number NOTNULL
;
