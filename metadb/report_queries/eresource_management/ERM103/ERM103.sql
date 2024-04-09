/** Documentation of eResource Management: Incorrect Text in URL Field 

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT *
FROM folio_source_record.marc__t
where field = '856' and sf = 'z' and content like '%rder'

SELECT *
FROM folio_source_record.marc__t
where field = '856' and sf = 'z' and content like '%restricted%'

SELECT *
FROM folio_source_record.marc__t
where field = '856' and sf = 'z' and content like '%affiliated%'

SELECT *
FROM folio_source_record.marc__t
where field = '856' and sf = 'y' and content like '%NCSU%'

SELECT *
FROM folio_source_record.marc__t
where field = '856' and sf = 'u' and content like '%ezproxy%'
