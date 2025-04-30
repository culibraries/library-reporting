drop function if exists missing_item;

create function missing_item()
returns table(
barcode text,
title text,
call_number text,
enumeration text
)
as $$
SELECT
  location."name" as location_name,
  holding.call_number as call_number,
  item.enumeration as enuneration,
  item.barcode as barcode,
  instance.title as title
FROM folio_inventory.item as item
JOIN folio_inventory.holdings_record__t as holding on item.holdingsrecordid = holding.id
JOIN folio_inventory.location__t as location on holding.permanent_location_id = location.id
JOIN folio_inventory.instance__t as instance on holding.instance_id = instance.id
WHERE jsonb_extract_path_text(jsonb, 'status', 'name') IN ('Long missing','Missing') and folio_inventory.location__t."name" like '%Law%'
$$
language sql
stable
parallel safe
;
