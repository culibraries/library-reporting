--metadb:function cu_authors_report

DROP FUNCTION IF EXISTS cu_authors_report;

CREATE FUNCTION cu_authors_report(
)
RETURNS TABLE(
	item_hrid text,
	instance_hrid text,
	item_create_date timestamp,
	cataloged_date text,
	material_type text,
	holdings_location text,
	item_location text,
	item_status text,
	item_barcode text,
	call_number text,
	item_call_number text,
	title text,
	author text,
	marc_730 text,
	publisher text,
	publication_year varchar
)
AS $$
WITH cu_author AS (
    SELECT DISTINCT 
        marc.instance_id,
        marc.content
    FROM folio_source_record.marc__t AS marc
    WHERE marc.field = '730'
      AND marc.content LIKE '%CU Boulder Author%'
),
field_264c AS (
    SELECT
        marc.instance_id,
        marc.content AS publication_year
    FROM folio_source_record.marc__t AS marc
    INNER JOIN cu_author AS ca
        ON ca.instance_id = marc.instance_id
    WHERE marc.field = '264'
      AND marc.sf = 'c'
      AND marc.ord = 1
),
field_264 AS (
    SELECT DISTINCT ON (marc.instance_id)
        marc.instance_id,
        marc.content AS publisher,
        c.publication_year
    FROM folio_source_record.marc__t AS marc
    INNER JOIN cu_author AS ca
        ON ca.instance_id = marc.instance_id
    LEFT JOIN field_264c AS c
        ON c.instance_id = marc.instance_id
    WHERE marc.field = '264'
      AND marc.sf = 'b'
      AND marc.ord = 1
    ORDER BY marc.instance_id
),
author AS (
    SELECT
        i.id,
        string_agg(contributor ->> 'name', ' ; ') AS author
    FROM folio_inventory.instance AS i
    INNER JOIN cu_author AS ca
        ON ca.instance_id = i.id
    CROSS JOIN LATERAL jsonb_array_elements(
        coalesce(i.jsonb -> 'contributors', '[]'::jsonb)
    ) AS contributor
    GROUP BY i.id
)
SELECT
    i.jsonb ->> 'hrid' AS item_hrid,
    inst.hrid AS instance_hrid,
    i.creation_date AS item_create_date,
    inst.cataloged_date AS cataloged_date,
    mt.name AS material_type,
    loch.name AS holdings_location,
    loc.name AS item_location,
    i.jsonb -> 'status' ->> 'name' AS item_status,
    i.jsonb ->> 'barcode' AS item_barcode,
    h.call_number AS call_number,
    i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS item_call_number,
    inst.title AS title,
    author.author AS author,
    cu_author.content AS marc_730,
    pub.publisher AS publisher,
    pub.publication_year AS publication_year
FROM cu_author
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = cu_author.instance_id
LEFT JOIN folio_inventory.holdings_record__t AS h ON h.instance_id = inst.id
LEFT JOIN folio_inventory.item AS i ON i.holdingsrecordid = h.id
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = i.effectivelocationid
LEFT JOIN folio_inventory.location__t AS loch ON loch.id = h.effective_location_id
LEFT JOIN folio_inventory.material_type__t AS mt ON mt.id = i.materialtypeid
LEFT JOIN field_264 AS pub ON pub.instance_id = inst.id
LEFT JOIN author ON author.id = inst.id
-- WHERE loc.name = 'Norlin Library – CU Authors Research Display'
ORDER BY
	loc.name,
    i.jsonb ->> 'effectiveShelvingOrder' ASC
$$
language sql
stable 
parallel safe
;
