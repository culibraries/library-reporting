select count (folio_circulation.loan__t.__id) --folio_circulation.loan__t.__id, folio_circulation.loan__t.loan_date, folio_inventory.location__t.discovery_display_name 
from folio_circulation.loan__t
join folio_inventory.location__t on folio_circulation.loan__t.item_effective_location_id_at_check_out = folio_inventory.location__t.id
where folio_inventory.location__t.discovery_display_name like '%Law%' and folio_circulation.loan__t.loan_date >= '2023-07-01' and folio_circulation.loan__t.loan_date <= '2024-06-30'
;
