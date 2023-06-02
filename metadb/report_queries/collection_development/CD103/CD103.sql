--CD103: 956 Platform Name Details Report
--Provides information about titles in a specific collection.
SELECT * 
FROM folio_source_record.marc__t AS marc 
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = marc.instance_id 
WHERE marc.field = '956' 
	AND marc.sf = 'a' 
--Enter value between '% and %'
	AND marc.content LIKE'%%'
;
