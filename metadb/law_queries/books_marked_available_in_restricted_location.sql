--this query finds the HRID and barcode of items that are marked "available" in locations that should have statuses of "restricted"
-- make sure to check these locations: lfed, lsper, lrbra, lrare, lrref, lref, lsc, and lstor

SELECT folio_inventory.item__t.hrid, folio_inventory.item__t.barcode
FROM folio_inventory.item
join folio_inventory.holdings_record__t on folio_inventory.item.holdingsrecordid = folio_inventory.holdings_record__t.id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_inventory.instance__t on folio_inventory.holdings_record__t.instance_id = folio_inventory.instance__t.id
join folio_inventory.item__t on folio_inventory.item.id = folio_inventory.item__t.id
WHERE jsonb_extract_path_text(jsonb, 'status', 'name') IN ('Available') and folio_inventory.location__t.code like '%lfed%' and folio_inventory.location__t.code not like '%lresc%'
;
