-- This query finds items "purchased" with fund "Law Gifts" --

select fy."name" , inst.hrid as "Instance HRID", inst.title, item.discovery_suppress, item.hrid as "Item HRID", item.barcode, item.effective_shelving_order, item.enumeration
from folio_derived.finance_transaction_purchase_order as ftpo
join folio_finance.fiscal_year__t as fy on ftpo.transaction_fiscal_year_id = fy.id
join folio_orders.po_line__t as pol on ftpo.po_line_id = pol.id
join folio_inventory.instance__t as inst on pol.instance_id = inst.id
join folio_inventory.holdings_record__t as holdz on inst.id = holdz.instance_id 
join folio_inventory.item__t as item on holdz.id = item.holdings_record_id 
where ftpo.transaction_from_fund_name = 'Law Gifts'
;
