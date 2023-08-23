select folio_derived.loans_items.loan_return_date,folio_derived.loans_items.item_status,folio_inventory.item__t__.hrid,
  folio_inventory.item__t__.barcode, folio_inventory.holdings_record__t__.call_number, folio_inventory.instance__t__.title
 from folio_inventory.item__t__
 join folio_inventory.holdings_record__t__ on folio_inventory.item__t__.holdings_record_id=folio_inventory.holdings_record__t__.id
 join folio_inventory.instance__t__ on folio_inventory.holdings_record__t__.instance_id = folio_inventory.instance__t__.id
 join folio_derived.loans_items on folio_inventory.item__t__.id=folio_derived.loans_items.item_id
 where folio_derived.loans_items.item_status ='In transit' and folio_derived.loans_items.in_transit_destination_service_point_name='Law Library'
 ;