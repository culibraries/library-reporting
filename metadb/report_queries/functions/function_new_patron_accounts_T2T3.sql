--metadb:function new_patron_accounts_T2T3

drop function if exists new_patron_accounts_T2T3;

create function new_patron_accounts_T2T3(
  start_date date DEFAULT '2000-01-01',
  end_date date DEFAULT '2999-01-01'
  )
returns table(
"Created Date" date,
"Active" text,
"Patron Group" text,
"Username" text,
"Patron Name" text,
"Patron ID" text,
"Creator Name" text,
created_by_id text
)
as $$
with creators as (
	select concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "Creator Name",
		u.id as created_by_id
	from folio_users.users u 
)
select
	(u.jsonb -> 'metadata'->>'createdDate')::date as "Created Date",
	(u.jsonb ->> 'active') as "Active",
	g.jsonb ->> 'group' as "Patron Group",
	u.jsonb ->> 'username' as "Username",
	concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "Patron Name",
	u.jsonb ->> 'id' as "Patron ID",
	c."Creator Name",
	u.created_by as created_by_id
from folio_users.users u 
join creators c on c.created_by_id = u.created_by
LEFT JOIN folio_users."groups" g  ON u.patrongroup = g.id
where start_date <= (u.jsonb -> 'metadata'->>'createdDate')::date and (u.jsonb -> 'metadata'->>'createdDate')::date <= end_date
	and g.__id in ('1','2','9','11','14','15','17','23','24','25','26','31')
	--and u.jsonb -> 'active' = 'true'
	and u.__current = true
ORDER BY "Created Date"
$$
language sql
stable 
parallel safe;
