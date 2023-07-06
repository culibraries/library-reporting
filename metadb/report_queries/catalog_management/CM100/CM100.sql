/** Documentation of Catalog Management: Backstage Record Pull 
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
WITH
  field_998 AS (
    (SELECT instance_id
     FROM folio_source_record.marc__t
     WHERE field = '998' AND sf = 'c' AND content NOT IN ('f', 'y', 'g'))
    UNION
    (SELECT instance_id
     FROM folio_source_record.marc__t
     WHERE field = '998' AND sf = 'e' AND content NOT IN ('p')
    )
  )
SELECT field_998.instance_id, i.creation_date
FROM field_998
LEFT JOIN folio_inventory.instance i ON i.id = field_998.instance_id
WHERE
  i.creation_date >='2023-06-01' AND
  i.creation_date < '2023-06-30' AND
  i.jsonb->>'staffSuppress'='false'
