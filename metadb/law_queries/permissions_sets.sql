-- this query shows permissions sets, in case one needs to clean up permissions in FOLIO

with permissions_granted as (
SELECT id AS permission_id,
       (granted_ids.jsonb #>> '{}')::uuid AS granted_id,
       granted_ids.ordinality
FROM folio_permissions.permissions p
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'grantedTo'))
        WITH ORDINALITY AS granted_ids (jsonb))
select pt.id as permission_id,
pt.description as permission_description,
pt.display_name as permission_display_name,
pt.permission_name  as permission_name,
pt.visible as visible_checkbox,
put.user_id,
jsonb_extract_path_text(fu."jsonb", 'personal', 'email') AS email,
jsonb_extract_path_text(fu."jsonb", 'personal', 'lastName') AS Last_name,
jsonb_extract_path_text(fu."jsonb", 'personal', 'firstName') AS First_name
from folio_permissions.permissions__t as pt
left join permissions_granted as pg on pt.id = pg.permission_id
left join folio_permissions.permissions_users__t as put on pg.granted_id = put.id
left join folio_users.users as fu on put.user_id = fu.id;
