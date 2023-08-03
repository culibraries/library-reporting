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
)
SELECT 
inst.hrid AS instance_hrid,
count(holdings.hrid) AS holdings_count
FROM
folio_inventory.holdings_record__t AS holdings
LEFT JOIN holdings_statement AS statements ON statements.holdings_id = holdings.id
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_derived.instance_statistical_codes AS stat ON stat.instance_id = inst.id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = holdings.effective_location_id
where loc.name not like '%Rare Books Collection%'
and loc.name not like '%Archives%'
AND loc.name NOT LIKE '%Law%'
AND stat.statistical_code_name = 'Serials, print (serials)'
AND inst.discovery_suppress = FALSE
AND statements.statements NOTNULL
GROUP BY inst.hrid ORDER BY count(holdings.hrid) DESC
