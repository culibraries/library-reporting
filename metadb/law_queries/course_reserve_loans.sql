-- pulls number of loans for course reserve items --
-- will work WITHOUT the items being on course reserve --

select count (loan.__id), insta.title, loc.discovery_display_name, holdz.call_number 
from folio_circulation.loan__t as loan
join folio_inventory.location__t as loc on loan.item_effective_location_id_at_check_out = loc.id
join folio_inventory.item__t as item on loan.item_id = item.id
join folio_inventory.holdings_record__t as holdz on item.holdings_record_id = holdz.id 
join folio_inventory.instance__t as insta on holdz.instance_id = insta.id 
  -- you will need to change the dates per semester --
where loc.discovery_display_name like 'Law Library - Course%' and loan.loan_date >= '2023-07-01'
	and (loan.loan_date between '2024-01-01' and '2024-05-10')
group by insta.title, loc.discovery_display_name, holdz.call_number
;
