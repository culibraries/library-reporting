--this query finds missing items

SELECT folio_inventory.location__t."name" as "location", folio_inventory.holdings_record__t.call_number, folio_inventory.item__t.enumeration, folio_inventory.item__t.barcode, folio_inventory.instance__t.title 
FROM folio_inventory.item
join folio_inventory.holdings_record__t on folio_inventory.item.holdingsrecordid = folio_inventory.holdings_record__t.id
join folio_inventory.location__t on folio_inventory.holdings_record__t.permanent_location_id = folio_inventory.location__t.id
join folio_inventory.instance__t on folio_inventory.holdings_record__t.instance_id = folio_inventory.instance__t.id
join folio_inventory.item__t on folio_inventory.item.id = folio_inventory.item__t.id
WHERE jsonb_extract_path_text(jsonb, 'status', 'name') IN ('Long missing','Missing') and folio_inventory.location__t."name" like '%Law%'
;
