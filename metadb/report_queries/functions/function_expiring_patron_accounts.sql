--metadb:function expiring_patron_accounts

drop function if exists expiring_patron_accounts;

create function expiring_patron_accounts(
  start_date date DEFAULT '2000-01-01',
  end_date date DEFAULT '2999-01-01'
  )
returns table(
"Expiration Date" date,
"Patron Name" text,
"Barcode" text,
"Patron Group" text,
"Open Loans" text,
"Total Fines" text
)
as $$
WITH oloans AS (
	SELECT COUNT(l.id) AS open_loans,
		(l.jsonb ->> 'userId')::uuid AS user_l_id 
	FROM folio_circulation.loan l 
	WHERE l.jsonb -> 'status' ->> 'name' = 'Open'
	GROUP BY user_l_id
),
tfines AS (
	SELECT SUM(at2.remaining) AS total_fines,
		at2.user_id AS user_act_id
	FROM folio_feesfines.accounts__t at2
	GROUP BY user_act_id
)
SELECT DISTINCT
	(u.jsonb ->> 'expirationDate')::DATE AS "Expiration Date",
	CONCAT(u.jsonb -> 'personal' ->> 'firstName',' ', u.jsonb -> 'personal' ->> 'lastName') AS "Patron Name",
	--u.id AS "Patron",
	(u.jsonb ->> 'barcode') AS "Barcode",
	(g.jsonb ->> 'group') AS "Patron Group",
	ol.open_loans as "Open Loans",
	tf.total_fines as "Total Fines"
FROM folio_users.users u
LEFT JOIN folio_feesfines.accounts__t at2 ON at2.user_id = u.id
LEFT JOIN folio_circulation.loan l on (l.jsonb ->> 'userId')::uuid = u.id
LEFT JOIN folio_users."groups" g ON (g.jsonb ->> 'id')::uuid = (l.jsonb ->> 'patronGroupIdAtCheckout')::uuid
LEFT JOIN oloans ol on ol.user_l_id = u.id
LEFT JOIN tfines tf on tf.user_act_id = u.id
WHERE start_date <= (u.jsonb ->>'expirationDate')::date and end_date >= (u.jsonb ->>'expirationDate')::date
	AND g.__id not in ('5','18','19','20','21','22','27','28','29')
	--AND g.__id IN ('1','2','9','11','13','15','17','23','24','25','26')
ORDER BY "Expiration Date"
$$
language sql
stable 
parallel safe;
