WITH
field_998 AS (
SELECT srs_id, instance_id
FROM folio_source_record.marc__t
WHERE field = '998' AND sf = 'c' AND content NOT IN ('f', 'w', 's', 'y', '-', 'b', 'o', 'n', 'g')
),
field_994 AS (
SELECT srs_id
FROM folio_source_record.marc__t
WHERE field = '994' AND sf = 'b' AND content = 'UCX'
)
SELECT i.id AS instance_id
FROM folio_inventory.instance AS i
JOIN field_998 AS r1 ON i.id = r1.instance_id
LEFT JOIN field_994 AS r2 ON r1.srs_id = r2.srs_id
WHERE r2.srs_id IS NULL AND (i.creation_date >= '2023-01-27' AND i.creation_date < '2023-02-01');

