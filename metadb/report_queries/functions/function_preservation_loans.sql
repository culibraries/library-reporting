--metadb:function preservation_loans

drop function if exists preservation_loans;

create function preservation_loans(
start_date date,
end_date date,
preservation_account text,
item_location text
)
returns TABLE(
"checkout_date" date,
"user" text,
"item_location" text,
"instance_hrid" text,
"holdings_hrid" text,
"item_barcode" text,
"material_type" text,
"item_status" text,
"call_number" text,
"title" text,
"volume" text
)
as $$
select 
(loan.jsonb -> 'loan' ->> 'loanDate')::date as checkout_date,
u.jsonb ->> 'barcode' as user,
loc.name as item_location,
inst.jsonb ->> 'hrid' as instance_hrid,
ho.jsonb ->> 'hrid' as holdings_hrid,
i.jsonb ->> 'barcode' as item_barcode,
mt.name as material_type,
i.jsonb -> 'status' ->> 'name' as item_status,
i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' as call_number,
inst.jsonb ->> 'title' as title,
i.jsonb ->> 'volume' as volume
from folio_circulation.audit_loan as loan
left join folio_inventory.item as i on i.id = (loan.jsonb -> 'loan' ->> 'itemId')::uuid
left join folio_users.users as u on u.id = (loan.jsonb -> 'loan' ->> 'userId')::uuid
left join folio_inventory.holdings_record as ho on ho.id = i.holdingsrecordid
left join folio_inventory.instance as inst on inst.id = ho.instanceid
left join folio_inventory.material_type__t as mt on mt.id = (i.jsonb ->> 'materialTypeId')::uuid
left join folio_inventory.location__t as loc on loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
where loan.jsonb -> 'loan' ->> 'action' = 'checkedout'
and u.id in 
('08af27e8-887c-543a-944b-cba860dadfab',
'0c14ccf1-279e-43c0-a528-31d90785affe',
'24ce68e0-c5a9-53c5-a67c-a0a5676ff65d',
'4de19469-8b17-5aa1-a84e-9fb0a7dccadf',
'5622ed87-a0be-59c1-be91-df9883e06833',
'60a8ee28-e679-5494-8056-2ce7125fd930',
'67f0b1d5-8e9e-50d0-b51f-66a11139a598',
'76dd88a3-8c7c-59c2-b39e-b31f9fe36010',
'7c7ead0c-5009-5c04-811a-37e568e528c9',
'868bea16-a123-54fd-9d58-de9dd81f8858',
'8f3405b3-b580-4cf1-9e3c-e6128ccb8444',
'b0e50cda-deb0-5225-9cfb-784a31533d82',
'd13b3186-2fc4-5926-a055-260d16a8b776',
'd15043ec-0cc4-5b31-b599-33b377c108e0',
'd9bd0d2b-88c2-5bb6-9e85-2057a1223ede')
and (u.jsonb ->> 'barcode') in (preservation_account)
and loc.name in (item_location)
and start_date <= (loan.jsonb -> 'loan' ->> 'loanDate')::date and(loan.jsonb -> 'loan' ->> 'loanDate')::date <= end_date
order by (loan.jsonb -> 'loan' ->> 'loanDate')::date desc
$$
language sql
stable 
parallel safe;
