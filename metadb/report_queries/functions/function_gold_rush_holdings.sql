--metadb:function gold_rush_holdings

drop function if exists gold_rush_holdings;

create function gold_rush_holdings()
returns TABLE(
hrid text
)  
as $$
SELECT
it.hrid
FROM
folio_inventory.instance__t AS it
left join folio_derived.holdings_ext as he on he.instance_id = it.id
where he.permanent_location_name != '%Law%'
and it.discovery_suppress is not true
$$
language sql 
stable 
parallel safe;
