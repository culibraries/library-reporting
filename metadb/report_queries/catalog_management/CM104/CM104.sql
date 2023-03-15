/** Documentation of Catalog Management: Holdings To OCLC

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT * FROM folio_source_record.marc__t as marc
LEFT JOIN folio_inventory.instance as inventory
  ON inventory.id = marc.instance_id
  where marc.field= '994' and marc.sf = 'b' and marc.content != 'UCX'
  and (marc.field = '998' and marc.sf = 'c' and marc."content" != 'f'
  or marc."content" != 'w'
  or marc."content" != 's'
  or marc."content" != 'y'
  or marc."content" != '-'
  or marc."content" != 'b'
  or marc."content" != 'o'
  or marc."content" != 'n'
  or marc."content" != 'g')
	and inventory.creation_date >= '2023-01-01 00:00:00.000'
	and inventory.creation_date < '2023-01-31 00:00:00.000'
