--RS100: Count of LC Call Numbers by Location
--Provides a count of instances, holdings, and items for instances that have a value in MARC 090$a
WITH field_090$a AS(
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE field = '090'
AND marc.sf = 'a'
AND ord = 1
),
field_090$b AS(
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE field = '090'
AND marc.sf = 'b'
AND ord = 1)
SELECT
loc.name AS effective_location,
field_090$a.CONTENT AS field_090$a,
count(DISTINCT field_090$a.instance_hrid) AS instance_count,
count(DISTINCT holdings.hrid) AS holdings_count,
count(DISTINCT item.hrid) AS item_count,
count(DISTINCT item.barcode) AS items_with_barcodes
FROM field_090$a
LEFT JOIN field_090$b ON field_090$a.instance_id = field_090$b.instance_id
LEFT JOIN folio_inventory.instance__t AS inst ON field_090$a.instance_id = inst.id
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON field_090$a.instance_id = holdings.instance_id
LEFT JOIN folio_inventory.location__t AS loc ON holdings.effective_location_id = loc.id
INNER JOIN folio_inventory.item__t AS item ON holdings.id = item.holdings_record_id
INNER JOIN folio_inventory.material_type__t AS mat ON item.material_type_id = mat.id
WHERE inst.discovery_suppress = FALSE
AND field_090$a.instance_hrid NOT LIKE 'lb%'
AND item.discovery_suppress = FALSE
AND mat.name = 'book'
GROUP BY
loc.name,
field_090$a.CONTENT
ORDER BY loc.name, field_090$a.content ASC
;
