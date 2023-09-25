--Returns the first set of publication results from folio_derived.instance_publication
--Creates a local name in arag3385 where it is used in PowerBI dashboards
--Update table once a month
CREATE TABLE dashboard_first_publisher AS
SELECT *
FROM FOLIO_DERIVED.instance_publication
WHERE publication_ordinality = '1'
