--metadb:function law_new_books

DROP FUNCTION IF EXISTS law_new_books;

CREATE FUNCTION get_users(
    start_date date DEFAULT '2025-01-01'
    )
RETURNS TABLE(
  hrid,
  title,
  call_num,
  location,
  isbn,
  cat_date,
  requestor
  )
AS $$
select folio_inventory.instance__t.hrid as hrid,
    folio_inventory.instance__t.title as title, folio_inventory.holdings_record__t.call_number as call_num, 
    folio_inventory.location__t."name" as location, folio_source_record.marc__t."content" as isbn,
    folio_inventory.instance__t.cataloged_date as cat_date,
    folio_orders.po_line__t.requester as requestor
from folio_inventory.instance__t
join folio_inventory.holdings_record__t on folio_inventory.instance__t.id = folio_inventory.holdings_record__t.instance_id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_source_record.marc__t on folio_inventory.instance__t.id = folio_source_record.marc__t.instance_id
join folio_orders.po_line__t on folio_inventory.instance__t.id = folio_orders.po_line__t.instance_id
where folio_inventory.instance__t.cataloged_date > start_date
    and folio_inventory.location__t."name" like '%Law%'
    and folio_inventory.location__t."name" != 'Law Electronic Resources'
    and folio_source_record.marc__t.field = '020'
    
$$
language sql
STABLE
PARALLEL SAFE;
