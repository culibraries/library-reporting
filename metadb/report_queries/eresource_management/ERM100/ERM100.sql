/** Documentation of eResource Management: Film Expiration Search 

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
Change the month and year as needed. 8 and 2023 in the query currently.
*/
select * from folio_derived.instance_notes in2  
where instance_note like 'CU Boulder license expires: 8%'
and instance_note like '%2023%'
