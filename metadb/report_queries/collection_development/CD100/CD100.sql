--CD100: Shelf List
--This reports returns a list of titles and item and biliographic information. 
--These filters still need to be added: Item Create Date
--
WITH parameters AS (
	SELECT 
		'' ::VARCHAR AS effective_location_filter,
			--Locations: https://docs.google.com/spreadsheets/d/1MMGloxcRGcvQ6EpY9tvu8Gi-pOTYmzGZklEqp2_WQMg/edit#gid=0
		'' ::VARCHAR AS status_filter -- Available, Restricted, Withdrawn, Long missing, In process, 
								--Unavailable, In process (non-requestable), 
								--Lost and paid, In transit, Missing, Checked out, Aged to lost, 
								--Awaiting pickup, Claimed returned, On order, Declared lost*/
),
ISBN AS (
SELECT
ii.instance_id AS instance_id,
string_agg (DISTINCT ii.identifier,' | ') AS ISBN
FROM folio_derived.instance_identifiers AS ii
WHERE ii.identifier_type_name = 'ISBN'
GROUP BY instance_id
)
SELECT
	i.item_id,
	inst.instance_hrid AS instance_hrid,
	i.created_date AS create_date,
	i.barcode,
	i.status_name AS status,
	i.effective_location_name,
	i.temporary_location_name,
	i.permanent_location_name,
	i.effective_call_number,
	i.chronology,
	i.enumeration,
	i.material_type_name,
	i.discovery_suppress as item_suppressed,
	link.title,
	string_agg (distinct ic.contributor_name,' | ') as author,
	ISBN.ISBN,
	string_agg (DISTINCT ip.publisher, ' | ') AS publisher, 
	string_agg (DISTINCT ip.date_of_publication,' | ') AS date_publication,
	string_agg (DISTINCT sub.subjects, ' | ') AS inst_subject,
	loans_items.item_status AS loan_item_status,
	loans_items.loan_due_date,
	loans_items.loan_return_date,
	loan_renewals.num_loans	
FROM 
	folio_derived.item_ext AS i
	LEFT JOIN folio_derived.loans_items ON i.item_id = loans_items.item_id
	LEFT JOIN folio_derived.loans_renewal_count AS loan_renewals ON i.item_id = loan_renewals.item_id
	LEFT JOIN folio_derived.items_holdings_instances AS link ON i.item_id = link.item_id
	LEFT JOIN folio_derived.instance_ext AS inst ON link.instance_id = inst.instance_id 
	LEFT JOIN ISBN ON ISBN.instance_id = inst.instance_id 
	LEFT JOIN folio_derived.instance_contributors AS ic ON inst.instance_id = ic.instance_id 
	LEFT JOIN folio_derived.instance_publication ip ON inst.instance_id = ip.instance_id 
	LEFT JOIN folio_derived.instance_subjects AS sub ON inst.instance_id = sub.instance_id 
WHERE
--Enter publisher name in within gree quotation marks (''). Enter "--"" before "publisher" if not using this filter.
publisher LIKE '%Bloomsbury%' AND
--
--APPLIES FILTERS FROM THE TOP OF THE QUERY
(i.effective_location_name  = (SELECT effective_location_filter FROM parameters) OR (SELECT effective_location_filter FROM parameters) = '') 
AND 
(status_name = (SELECT status_filter FROM parameters) OR (SELECT status_filter FROM parameters) = '')
AND
	i.discovery_suppress = 'false'
GROUP BY 
i.item_id,
inst.instance_hrid,
create_date,
i.barcode,
status,
i.effective_location_name,
i.temporary_location_name,
i.permanent_location_name,
i.effective_call_number,
i.chronology,
i.enumeration,
i.material_type_name,
item_suppressed,
link.title,
ISBN.ISBN,
loan_item_status,
loans_items.loan_due_date,
loans_items.loan_return_date,
loan_renewals.num_loans
ORDER BY effective_call_number ASC
;
