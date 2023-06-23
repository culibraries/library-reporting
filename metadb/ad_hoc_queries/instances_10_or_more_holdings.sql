SELECT
inst.hrid AS instance_hrid,
count(holdings.id) AS holdings_count
FROM folio_inventory.holdings_record__t AS holdings
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id 
GROUP BY inst.hrid
HAVING count(holdings.id) > 9 
ORDER BY count(holdings.id) DESC
