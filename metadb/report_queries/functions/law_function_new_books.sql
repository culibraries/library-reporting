--metadb:function law_new_books

DROP FUNCTION IF EXISTS law_new_books(text);

CREATE FUNCTION law_new_books(
    start_date text DEFAULT '2025-01-01'
    )
RETURNS TABLE(
    hrid text,
    title text,
    call_number text,
    location text,
    marco text,
    --cataloged_date timestamptz,
    requester text
  )
AS $$
select distinct on (i.hrid) i.hrid as hrid,
    i.title as title,
    h.call_number as call_number, 
    loc."name" as location,
    marc."content" as marco,
    --i.cataloged_date as cataloged_date,
    pol.requester as requester
from folio_inventory.instance__t as i
join folio_inventory.holdings_record__t as h on i.id = h.instance_id
join folio_inventory.location__t as loc on h.permanent_location_id = loc.id
join folio_source_record.marc__t as marc on i.id = marc.instance_id
join folio_orders.po_line__t as pol on i.id = pol.instance_id
where i.cataloged_date > start_date
    and loc."name" like '%Law%'
    and loc."name" != 'Law Electronic Resources'
    and marc.field = '020';
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
