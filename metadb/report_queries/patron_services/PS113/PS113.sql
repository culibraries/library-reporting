--PS113: Expiring Patron Accounts
--Returns ids for all patron accounts expiring before July 1, 2024. 
select 
id, 
jsonb ->> 'active' as active,
jsonb ->> 'externalSystemId' as external_system_id,
(jsonb ->> 'expirationDate')::date as expiration_date
from folio_users.users
where (jsonb ->> 'expirationDate')::date < '2024-07-01'
order by (jsonb ->> 'expirationDate')::date desc
