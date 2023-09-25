/** Documentation of Catalog Management: GoldRush Holdings

DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
SELECT
*
FROM
folio_inventory.instance__t AS it
left join folio_derived.holdings_ext as he on he.instance_id = it.id
where he.permanent_location_name != '%Law%'
and it.discovery_suppress = FALSE
