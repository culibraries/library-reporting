--metadb:function law_new_books

DROP FUNCTION IF EXISTS law_new_books;

CREATE FUNCTION law_new_books(
    start_date date DEFAULT '2025-01-01'
    )
RETURNS TABLE(
    hrid,i.title,
    h.call_number,
    loc."name",
    folio_source_record.marc__t."content",
    i.cataloged_date,pol.requester
  )
AS $$
select i.hrid,
    i.title, h.call_number, 
    loc."name",
    folio_source_record.marc__t."content",
    i.cataloged_date,
    pol.requester
from folio_inventory.instance__t as i
join folio_inventory.holdings_record__t as h on folio_inventory.instance__t.id = folio_inventory.holdings_record__t.instance_id
join folio_inventory.location__t as loc on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_source_record.marc__t on folio_inventory.instance__t.id = folio_source_record.marc__t.instance_id
join folio_orders.po_line__t as pol on folio_inventory.instance__t.id = folio_orders.po_line__t.instance_id
where i.cataloged_date > start_date
    and loc."name" like '%Law%'
    and loc."name" != 'Law Electronic Resources'
    and folio_source_record.marc__t.field = '020'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE
;
