--metadb:function weekly_oclc_list

drop function if exists weekly_oclc_list;

create function weekly_oclc_list(
  start_date date DEFAULT '2000-01-01',
  end_date date DEFAULT '2099-01-01'
)
returns TABLE(
uuid text,
index_title text,
discovery_suppress text,
cataloged_date date,
hrid text,
status_name text,
location_name text
)
as $$
select
it.id as uuid,
it.index_title,
it.discovery_suppress,
it.cataloged_date,
it.hrid,
ie.status_name,
lt."name" as location_name
from folio_inventory.instance__t as it
left join folio_derived.instance_ext as ie on ie.instance_id = it.id
left join folio_inventory.holdings_record__t AS hr on hr.instance_id = ie.instance_id
left join folio_inventory.location__t as lt on lt.id = hr.effective_location_id
where it.cataloged_date >= 'start_date' and it.cataloged_date <= 'end_date'
and ie.status_name != 'Batch Loaded'
and it.discovery_suppress is not true
and lt."name" not like 'Law%'
$$
language sql 
stable 
parallel safe;
