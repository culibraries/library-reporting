--CD105 CIRCULATION TITLE REPORT
--Returns a list of currrent loans from folio_circulation.loan__t__
SELECT
loan.__current,
loan.id,
loan.item_status ,
loan.__start,
loan.__end,
loan_date,
mt.name AS material_type,
co.name AS service_point,
loc.name AS item_location,
due_date,
lp.name AS loan_policy,
loan.ACTION,
item.barcode,
inst.title,
pg.GROUP AS patron_group
FROM folio_circulation.loan__t__ AS loan
LEFT JOIN folio_inventory.item__t AS item ON item.id = loan.item_id
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON item.holdings_record_id = holdings.id
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
LEFT JOIN folio_inventory.material_type__t AS mt ON mt.id = item.material_type_id
LEFT JOIN folio_users.users AS u ON u.id = loan.user_id
LEFT JOIN folio_users.groups__t AS pg ON pg.id = loan.patron_group_id_at_checkout
LEFT JOIN folio_circulation.loan_policy__t AS lp ON lp.id = loan.loan_policy_id
LEFT JOIN folio_inventory.service_point__t AS co ON co.id = loan.checkout_service_point_id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = loan.item_effective_location_id_at_check_out
WHERE loan."__current" = TRUE
ORDER BY __start DESC
