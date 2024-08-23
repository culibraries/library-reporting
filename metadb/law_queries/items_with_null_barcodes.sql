--finds items with no barcodes --

select distinct on (folio_inventory.item__t.hrid) folio_inventory.item__t.hrid as "hrid", folio_inventory.item__t.barcode, folio_inventory.location__t."name" 
from folio_inventory.item__t
join folio_inventory.holdings_record__t on folio_inventory.item__t.holdings_record_id = folio_inventory.holdings_record__t.id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
where folio_inventory.location__t."name" like '%Law Electronic%' and folio_inventory.item__t.discovery_suppress = 'FALSE' and folio_inventory.item__t.barcode is null 
;
