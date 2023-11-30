/** Documentation of Catalog Management: Occam's Reader

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
select
string_agg(distinct hrid, ',') as hrid,
string_agg(distinct identifier, ',') as identifier,
string_agg(contributor_name, ';') as author,
string_agg(distinct publication_place, ',') as publication_place,
string_agg(distinct publication_role, ',') as publication_role,
string_agg(distinct publisher, ',') as publisher,
string_agg(distinct date_of_publication, ',') as date_of_publication,
string_agg(distinct identifier_type_name, ',') as identifier_type_name,
string_agg(distinct index_title, ',') as title,
string_agg(distinct uri, ',') as url,
string_agg(distinct instance_language, ',') as language
from folio_derived.instance_identifiers as ii
left join folio_inventory.instance__t as it on it.id = ii.instance_id
left join folio_derived.instance_contributors as ic on ic.instance_id = ii.instance_id
left join folio_derived.instance_editions as ie on ie.instance_id = ic.instance_id
left join folio_derived.instance_publication as ip on ip.instance_id = ii.instance_id
left join folio_derived.instance_languages as il on il.instance_hrid = ip.instance_hrid
left join folio_derived.instance_electronic_access as iea on iea.instance_id = il.instance_id
where identifier_type_name = 'OCLC'
and identifier like '%spr%'
and it.discovery_suppress = false
group by it.hrid, ii.identifier;
