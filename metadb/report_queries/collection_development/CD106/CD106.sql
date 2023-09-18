--CD106: Alliance Shared Print Trust Title Report
WITH committa AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '583'
AND marc.sf = 'a'
),
committc AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '583'
AND marc.sf = 'c'
),
committd AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '583'
AND marc.sf = 'd'
),
committf AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '583'
AND marc.sf = 'f'
)
SELECT
item.hrid AS item_hrid,
holdings.hrid AS holdings_hrid,
committa.instance_hrid AS instance_hrid,
committa.CONTENT AS retention_note,
committc.CONTENT AS retention_start,
committd.CONTENT AS retention_end,
committf.CONTENT AS program
FROM folio_inventory.item__t AS item
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = item.holdings_record_id
LEFT JOIN committa ON committa.instance_id = holdings.instance_id
LEFT JOIN committc ON committc.instance_id = holdings.instance_id
LEFT JOIN committd ON committd.instance_id = holdings.instance_id
LEFT JOIN committf ON committf.instance_id = holdings.instance_id
WHERE committa.CONTENT NOTNULL
;
