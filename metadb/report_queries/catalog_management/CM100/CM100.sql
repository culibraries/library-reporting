/** Documentation of Catalog Management: Backstage Record Pull 
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT id
FROM folio_inventory.instance i
WHERE
  i.creation_date >='2023-06-19' AND
  i.creation_date < '2023-06-30' AND
  i.jsonb->>'discoverySuppress'='false';
