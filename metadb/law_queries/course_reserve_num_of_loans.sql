select count (loan.id) as num_loans, holdings.call_number, bib.title 
--loan.id Loan_ID, item.id as Item_ID, holdings.call_number  
from folio_circulation.loan__t as loan
join folio_inventory.item__t as item on loan.item_id = item.id
join folio_inventory.location__t as loc on item.effective_location_id = loc.id
join folio_inventory.holdings_record__t as holdings on item.holdings_record_id = holdings.id
join folio_inventory.instance__t as bib on holdings.instance_id = bib.id
where loc.discovery_display_name like '%Law Library - Course Reserve%' and loan.loan_date >= '2024-01-01'
  --change date per sem/year
group by holdings.call_number, bib.title
;
