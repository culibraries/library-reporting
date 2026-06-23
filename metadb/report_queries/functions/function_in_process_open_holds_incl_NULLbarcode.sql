--metadb:function in_process_open_holds_incl_NULLbarcode

drop function if exists in_process_open_holds_incl_NULLbarcode;

create function in_process_open_holds_incl_NULLbarcode()
returns table(
	data_source text,
	item_hrid text,
	item_updated date,
	item_updated_by text,
	cataloged_date date,
	barcode text,
	status text,
	status_date date,
	item_location text,
	sort_callnumber text,
	call_number text,
	"inst.title" text,
	"holds.open_holds" integer,
	requested date
)
as $$
with holds as (
select 
	item_id, 
	count(item_id) as open_holds,
	request_date as requested
from folio_circulation.request__t 
where request_type = 'Hold' and status like '%Open%'
group by item_id, request_date
)
select 
	inst."source" as data_source,
	i.jsonb ->> 'hrid' as item_hrid,
	(i.jsonb -> 'metadata' ->> 'updatedDate')::date as item_updated,
	u.username as item_updated_by,
	inst.cataloged_date::date as cataloged_date,
	i.jsonb ->> 'barcode' as barcode,
	i.jsonb -> 'status' ->> 'name' as status,
	(i.jsonb -> 'status'->> 'date')::date as status_date,
	loc.name as item_location,
	i.jsonb ->> 'effectiveShelvingOrder' as sort_callnumber,
	ho.jsonb ->> 'callNumber' as call_number,
	inst.title,
	holds.open_holds,
	holds.requested::date
from folio_inventory.item as i
left join folio_inventory.holdings_record as ho on ho.id = i.holdingsrecordid 
left join folio_inventory.location__t as loc on loc.id = i.effectivelocationid
left join folio_users.users__t as u on u.id = (i.jsonb -> 'metadata' ->> 'updatedByUserId')::uuid
left join folio_inventory.instance__t as inst on inst.id = ho.instanceid
left join holds on holds.item_id = i.id
where i.jsonb -> 'status' ->> 'name' = 'In process'
	and holds.open_holds notnull
order by holds.requested asc
$$
language sql
stable 
parallel safe;
