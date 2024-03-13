/** Documentation of Catalog Management: Occam's Reader

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
WITH instance AS (
WITH
first_author AS (
SELECT * from folio_derived.instance_contributors as ic
where contributor_ordinality = 1
ORDER BY instance_hrid ASC
),
first_edition AS (
SELECT * from folio_derived.instance_editions as ie
where edition_ordinality = 1
ORDER BY instance_hrid ASC
),
first_publication AS (
SELECT * from folio_derived.instance_publication as ip
where publication_ordinality = 1
ORDER BY instance_hrid ASC
),
first_language AS (
SELECT * from folio_derived.instance_languages as il
where il.language_ordinality = 1
ORDER BY instance_hrid ASC
),
electronic_access AS (
SELECT * from folio_derived.instance_electronic_access AS ea
where ea.electronic_access_ordinality = 1
ORDER BY instance_hrid ASC
),
print_ISBN AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '020'
AND marc.sf = 'z'
AND ord = '1'
),
e_ISBN AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '020'
AND marc.sf = 'a'
AND ord = '1'
),
ebook_package AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '956'
AND marc.sf = 'a'
AND ord = '1'
),
series_title AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '830'
AND marc.sf = 'a'
AND ord = '1'
),
series_volume_number AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '830'
AND marc.sf = 'v'
AND ord = '1'
)
SELECT 
inst.id AS instance_id,
auth.contributor_name AS author,
pub.publication_place AS publication_place,
title as title,
pub.publisher AS publisher,
pub.date_of_publication AS copyright,
lang.instance_language AS language,
ed.edition AS edition,
ea.uri AS url,
ep.CONTENT AS ebook_package,
pISBN.CONTENT AS print_ISBN,
eISBN.CONTENT AS e_ISBN,
st.CONTENT AS series_title,
svn.CONTENT AS series_volume_number
FROM folio_inventory.instance__t AS inst
LEFT JOIN first_author AS auth ON auth.instance_id = inst.id 
LEFT JOIN first_edition AS ed ON ed.instance_id = inst.id
LEFT JOIN first_publication AS pub ON pub.instance_id = inst.id
LEFT JOIN first_language AS lang ON lang.instance_id = inst.id
LEFT JOIN electronic_access AS ea ON ea.instance_id = inst.id
LEFT JOIN print_ISBN AS pISBN ON pISBN.instance_id = inst.id
LEFT JOIN e_ISBN AS eISBN ON eISBN.instance_id = inst.id
LEFT JOIN ebook_package AS ep ON ep.instance_id = inst.id
LEFT JOIN series_title AS st ON st.instance_id = inst.id
LEFT JOIN series_volume_number AS svn ON svn.instance_id = inst.id
)
SELECT 
II.instance_hrid,
ii.identifier AS oclc_identifier,
instance.title,
INSTANCE.author,
INSTANCE.publication_place,
INSTANCE.publisher,
INSTANCE.copyright,
INSTANCE.edition,
INSTANCE.LANGUAGE,
INSTANCE.url,
INSTANCE.ebook_package,
INSTANCE.print_ISBN,
INSTANCE.e_ISBN,
INSTANCE.series_title,
INSTANCE.series_volume_number
from folio_derived.instance_identifiers as ii
LEFT JOIN INSTANCE ON INSTANCE.INSTANCE_id = ii.instance_id 
where identifier_type_name = 'OCLC'
and identifier like '%spr%'
ORDER BY instance_hrid ASC
