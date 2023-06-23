/** Documentation of Catalog Management: GoldRush Holdings

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT instance_id FROM folio_source_record.marc__t AS marc
WHERE (marc.field = '998' and marc.sf = 'e' and marc.content != 'n')
INTERSECT
(SELECT instance_id FROM folio_source_record.marc__t AS marc2
WHERE (marc2.field = '994' and marc2.sf = 'b' and marc2.content != 'UCX'))
