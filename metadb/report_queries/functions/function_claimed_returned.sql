--metadb:function claimed_returned

drop function if exists claimed_returned;

create function claimed_returned()
returns table(
loan_id text,
claimed_date date,
library text,
item_location text,
item_barcode text,
call_number text,
copy text,
volume text
action_comment text,
user_id text,
user_name text,
user_email text
)
as $$
select
l.jsonb ->> 'id' as loan_id,
(i.jsonb -> 'status' ->> 'date')::DATE as claimed_date,
lib.name as library, 
loc.name as item_location,
i.jsonb ->> 'barcode' as item_barcode,
holdings.call_number as call_number,
i.jsonb ->> 'copyNumber' as copy,
i.jsonb ->> 'volume' as volume,
l.jsonb ->> 'actionComment' as action_comment,
l.jsonb ->> 'userId' as user_id,
concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS user_name,
u.jsonb -> 'personal' ->> 'email' as user_email
from folio_circulation.loan as l
left join folio_inventory.item as i on i.id = (l.jsonb ->> 'itemId')::uuid
left join folio_users.users as u on u.id = (l.jsonb ->> 'userId')::uuid
left join folio_inventory.location__t as loc on loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
left join folio_inventory.loclibrary__t as lib on lib.id = loc.library_id
left join folio_inventory.holdings_record__t as holdings on holdings.id = i.holdingsrecordid 
where l.jsonb ->> 'action' = 'claimedReturned'
order by lib.name, claimed_date asc
$$
language sql
stable 
parallel safe;
