--this query finds new books catalogued since a certain due date
-- remember to change the cat date in the "where" clause to update this report.

select distinct on (folio_inventory.instance__t.hrid) folio_inventory.instance__t.hrid as "HRID", folio_inventory.instance__t.title as "Title", folio_inventory.holdings_record__t.call_number as "Call Number", folio_inventory.location__t."name" as "Location", folio_source_record.marc__t."content" as "ISBN", folio_inventory.instance__t.cataloged_date as "Cat Date"--, folio_orders.po_line__t.requester as "Requestor" 
from folio_inventory.instance__t
join folio_inventory.holdings_record__t on folio_inventory.instance__t.id = folio_inventory.holdings_record__t.instance_id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_source_record.marc__t on folio_inventory.instance__t.id = folio_source_record.marc__t.instance_id
join folio_orders.po_line__t on folio_inventory.instance__t.id = folio_orders.po_line__t.instance_id
where folio_inventory.instance__t.cataloged_date >= '2023-10-10' and folio_inventory.location__t."name" like '%Law%' and folio_inventory.location__t."name" != 'Law Electronic Resources' and folio_source_record.marc__t.field = '020'
;
