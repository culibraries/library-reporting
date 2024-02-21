/** Documentation of Catalog Management: RAPID - Print Serials

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
WITH holdings_statement AS (
SELECT
hs.holdings_id,
string_agg (DISTINCT hs.holdings_statement,' | ') AS statements
FROM folio_derived.holdings_statements AS hs
GROUP BY hs.holdings_id
),
OCLC AS (
SELECT 
ii.instance_id,
string_agg (DISTINCT ii.identifier,' | ') AS oclc
FROM folio_derived.instance_identifiers AS ii
WHERE ii.identifier_type_id = '439bfbae-75bc-4f74-9fc7-b2a2d47ce3ef'
GROUP BY ii.instance_id
),
ISSN AS (
SELECT 
ii.instance_id,
string_agg (DISTINCT ii.identifier,' | ') AS issn
FROM folio_derived.instance_identifiers AS ii
WHERE ii.identifier_type_id = '913300b2-03ed-469a-8179-c1092c991227'
GROUP BY ii.instance_id
)
SELECT
oclc.oclc,
holdings.hrid AS holdings_hrid,
inst.hrid AS instance_hrid,
inst.index_title as title,
holdings.call_number as call_number,
statements.statements as holdings_statement,
loc.name AS holdings_location,
issn.issn,
inst.discovery_suppress,
stat.statistical_code_name
FROM
folio_inventory.holdings_record__t AS holdings
LEFT JOIN holdings_statement AS statements ON statements.holdings_id = holdings.id
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_derived.instance_statistical_codes AS stat ON stat.instance_id = inst.id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = holdings.effective_location_id
LEFT JOIN oclc ON oclc.instance_id = inst.id
LEFT JOIN ISSN ON issn.instance_id = inst.id
where loc.name not like '%Rare Books Collection%'
and loc.name not like '%Archives%'
AND loc.name NOT LIKE '%Law%'
AND stat.statistical_code_name = 'Serials, print (serials)'
AND inst.discovery_suppress is not true
AND statements.statements NOTNULL
