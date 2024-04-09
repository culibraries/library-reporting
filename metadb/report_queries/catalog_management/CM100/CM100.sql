/** Documentation of Catalog Management: Backstage Record Pull 
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT i.id 
FROM folio_inventory.instance i
left join folio_inventory.instance__t as it on it.id = i.id 
WHERE
  i.creation_date >='2023-06-19' AND
  i.creation_date < '2023-06-30' AND
  it.discovery_suppress is not true 
