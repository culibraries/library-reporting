--metadb:function in_transit_report

DROP FUNCTION IF EXISTS in_transit_report;

CREATE FUNCTION in_transit_report(
	p_lib_location text,
	start_date date DEFAULT '2000-01-01',
	end_date date DEFAULT '2999-01-01'
	)
RETURNS TABLE(
"Item hrid" text,
"Item Created Date" date,
"Holdings Call Number" text,
"Volume" text,
"Barcode" text,
"Current Status" text,
"Last Checkin Date" date,
"Status Prior Checkin" text,
"Service Point" text,
"Effective Location" text,
"Title" text
)
AS $$
WITH checkin AS (
SELECT DISTINCT ON (cit.item_id)
    cit.item_id,
    cit.occurred_date_time AS most_recent_time,
    cit.item_status_prior_to_check_in AS prior_status,
    spt."name" AS last_service_point
FROM folio_circulation.check_in__t cit
LEFT JOIN folio_inventory.service_point__t spt ON spt.id = cit.service_point_id
ORDER BY cit.item_id, cit.occurred_date_time DESC
)	
SELECT
	i.jsonb->>'hrid' AS "Item hrid", 
	i.creation_date::date AS "Item Created Date",
	hrt.call_number AS "Holdings Call Number",
	i.jsonb->>'volume' AS "Volume",
	i.jsonb->>'barcode' as "Barcode",
	i.jsonb->'status'->>'name' AS "Current Status",
	checkin.most_recent_time::date AS "Last Checkin Date",
	checkin.prior_status AS "Status Prior Checkin",
	checkin.last_service_point AS "Service Point",
	loct."name" AS "Effective Location",
	inst.index_title AS "Title"
FROM folio_inventory.item i
LEFT JOIN checkin ON checkin.item_id = i.id
LEFT JOIN folio_inventory.location__t loct ON loct.id = i.effectivelocationid
LEFT JOIN folio_inventory.loclibrary__t llt ON llt.id = loct.library_id
LEFT JOIN folio_inventory.holdings_record__t hrt ON hrt.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t inst ON inst.id = hrt.instance_id
WHERE 
	((i.jsonb->'status'->>'name') = 'In transit')
	AND (NULLIF(p_lib_location, '') IS NULL OR llt."name" = p_lib_location)
	AND (i.creation_date::date) <= start_date	
	AND (checkin.most_recent_time::date) <= end_date
ORDER BY "Effective Location" ASC,"Last Checkin Date" ASC
$$
LANGUAGE SQL
STABLE 
PARALLEL safe;
