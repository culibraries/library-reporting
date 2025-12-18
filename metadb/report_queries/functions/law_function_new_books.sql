--metadb:function law_new_books

DROP FUNCTION IF EXISTS law_new_books(start_date);

CREATE FUNCTION law_new_books(
    start_date date DEFAULT '2025-01-01'
    )
RETURNS TABLE(
    hrid text,
    i.title text,
    h.call_number text,
    loc."name" text,
    folio_source_record.marc__t."content" text,
    i.cataloged_date timestampz,
    pol.requester
  )
AS $$
select i.hrid,
    i.title, h.call_number, 
    loc."name",
    folio_source_record.marc__t."content",
    i.cataloged_date,
    pol.requester
from folio_inventory.instance__t as i
join folio_inventory.holdings_record__t as h on i.id = h.instance_id
join folio_inventory.location__t as loc on h.permanent_location_id = loc.id
join folio_source_record.marc__t on i.id = folio_source_record.marc__t.instance_id
join folio_orders.po_line__t as pol on i.id = pol.instance_id
where i.cataloged_date > start_date
    and loc."name" like '%Law%'
    and loc."name" != 'Law Electronic Resources'
    and folio_source_record.marc__t.field = '020'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
