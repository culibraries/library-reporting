/** Documentation of Catalog Management: Occam's Reader

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT instance_id FROM folio_source_record.marc__t AS marc
WHERE (marc.field = '035' and marc.sf = 'a' and marc.content like '%spr%')
INTERSECT
(SELECT instance_id FROM folio_source_record.marc__t AS marc2
where (marc2.field = '998' and marc2.sf = 'e' and marc2.content != 'n'));
