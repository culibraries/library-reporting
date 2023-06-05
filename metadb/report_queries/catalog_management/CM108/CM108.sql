/** Documentation of Catalog Management: EDS Holdings 

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
WITH in_scope AS (
SELECT *
FROM
folio_source_record.marc__t as marc
WHERE marc.field = '998'
AND marc.sf = 'c')
SELECT
inst.instance_hrid,
inst.staff_suppress,
holdings.permanent_location_name,
in_scope.instance_id
FROM folio_derived.instance_ext as inst
LEFT JOIN folio_derived.holdings_ext as holdings ON holdings.instance_id = inst.instance_id
LEFT JOIN in_scope ON in_scope.instance_id = inst.instance_id
WHERE staff_suppress != TRUE
AND holdings.permanent_location_name not like '%ILL%'
AND holdings.permanent_location_name NOT LIKE '%Law%'
