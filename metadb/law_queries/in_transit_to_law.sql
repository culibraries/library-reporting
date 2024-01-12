-- this query finds books that are marked in transit to law, but have not arrived
-- send report to law ILL specialist

select distinct on (folio_inventory.item__t.hrid) folio_derived.loans_items.loan_return_date,folio_derived.loans_items.item_status,folio_inventory.item__t.hrid,
  folio_inventory.item__t.barcode, folio_inventory.holdings_record__t.call_number, folio_inventory.instance__t.title
 from folio_inventory.item__t
 join folio_inventory.holdings_record__t on folio_inventory.item__t.holdings_record_id=folio_inventory.holdings_record__t.id
 join folio_inventory.instance__t on folio_inventory.holdings_record__t.instance_id = folio_inventory.instance__t.id
 join folio_derived.loans_items on folio_inventory.item__t.id=folio_derived.loans_items.item_id
 where folio_derived.loans_items.item_status ='In transit' and folio_derived.loans_items.in_transit_destination_service_point_name='Law Library';
