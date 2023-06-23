/** Documentation of Catalog Management: Cataloging Records by User 
Initials have been stored in the 948 field. In the future, may be stored in an administrative note.
ess are Emily Semenoff's initials for testing. Replace those with the initials of the cataloger you are searching for.
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT * FROM folio_source_record.marc__t as marc
WHERE marc.field = '948' and marc."content" like 'ess'

/**If administrative notes are being used
*/
SELECT * FROM folio_derived.instance_administrative_notes 
WHERE (administrative_note like '%ess%');
