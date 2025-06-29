--metadb:function new_patron_accounts_T2T3

drop function if exists new_patron_accounts_T2T3;

create function new_patron_accounts_T2T3(
  start_date date DEFAULT '2000-01-01',
  end_date date DEFAULT '2099-01-01'
)
returns table(
created_date date,
patron_group text,
username text,
patron_name text,
user_id text,
creator_name text,
created_by_id text
)
as $$
with creators as (
	select concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS creator_name,
		u.id as created_by_id
	from folio_users.users u 
)
select
	(u.jsonb -> 'metadata'->>'createdDate')::date as created_date,
	g.jsonb ->> 'group' as patron_group,
	u.jsonb ->> 'username' as username,
	concat(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS patron_name,
	u.jsonb ->> 'id' as user_id,
	c.creator_name,
	u.created_by as created_by_id
from folio_users.users u 
join creators c on c.created_by_id = u.created_by
LEFT JOIN folio_users."groups" g  ON u.patrongroup = g.id
--Enter dates using the format YYYY-MM-DD
--where u.creation_date ::date BETWEEN '2023-7-01' AND '2024-6-28'
where start_date <= (u.jsonb -> 'metadata'->>'createdDate')::date and (u.jsonb -> 'metadata'->>'createdDate')::date < end_date
	and g.__id in ('1','2','9','11','14','15','17','23','24','25','26','31')
	and u.jsonb -> 'active' = 'true'
	and u.__current = true
ORDER BY created_date
$$
language sql
stable 
parallel safe;
