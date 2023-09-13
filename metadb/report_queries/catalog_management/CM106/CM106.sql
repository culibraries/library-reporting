/** Documentation of Catalog Management: RAPID - Print Monographs 

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT 
inst.id,
count(item.id)
FROM
folio_inventory.item__t AS item
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = item.holdings_record_id
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_derived.instance_statistical_codes AS stat ON stat.instance_id = inst.id
LEFT JOIN folio_derived.instance_formats AS format ON format.instance_id = inst.id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = holdings.effective_location_id
where loc.name not like '%Rare Books Collection%'
and loc.name not like '%Archives%'
AND loc.name NOT LIKE '%Law%'
AND stat.statistical_code_name = 'Book, print (books)'
AND item.barcode != '[NULL]'
AND format.instance_format_name = 'unmediated -- volume'
AND inst.discovery_suppress = FALSE
GROUP BY inst.id ORDER BY count(item.id) DESC
