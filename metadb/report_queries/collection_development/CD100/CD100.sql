/*CD100: Shelf List
 * This reports returns a list of titles and item and biliographic information. 
 * 
 *These filters still need to be added: 
 * Item Create Date
 * ISBNS from folio_derived.identifiers (right now, using a local table in arag3385 schema)
 * 
 * Notes:
 * The query takes a long time to run if the pubisher filter is added
 * in parameters. It runs at a much faster time when I added it in
 * the Where clause. is it better to create
 * 
 * AND 
 * publisher LIKE '%Random House%'
 * '%Random House%' ::VARCHAR AS publisher_filter
 * AND 
 * (publisher LIKE (SELECT status_filter FROM parameters) OR (SELECT status_filter FROM parameters) = '')
 * 
 * when I enter subject into the WHERE statement, i get a 'column does not exist' error
 * 
 * Filters: Enter values for each filter between the 'green' single quotations. 
 * Enter filters for publisher below. 
 */
WITH parameters AS (
	SELECT 
		'' ::VARCHAR AS effective_location_filter, /* 
	Locations: https://docs.google.com/spreadsheets/d/1MMGloxcRGcvQ6EpY9tvu8Gi-pOTYmzGZklEqp2_WQMg/edit#gid=0
		*/
		'' ::VARCHAR AS status_filter /* 
								Available, Restricted, Withdrawn, Long missing,
								In process, Unavailable, In process (non-requestable), 
								Lost and paid, In transit, Missing, Checked out, Aged to lost, 
								Awaiting pickup, Claimed returned, On order, Declared lost*/
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
	string_agg (DISTINCT ii.identifier,' | ') AS ISBN,
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
	LEFT JOIN folio_derived.instance_contributors AS ic ON inst.instance_id = ic.instance_id 
	LEFT JOIN arag3385.instance_isbns AS ii ON inst.instance_id = ii.instance_id 
	LEFT JOIN folio_derived.instance_publication ip ON inst.instance_id = ip.instance_id 
	LEFT JOIN folio_derived.instance_subjects AS sub ON inst.instance_id = sub.instance_id 
WHERE
/*ENTER FILTER FOR PUBLISHER, AUTHOR, SUBJECTS. DELETE IF NOT FILTERING. 
*/
publisher LIKE '%Bloomsbury%'
/*
 * APPLIES FILTERS FROM THE TOP OF THE QUERY
 */
AND
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
loan_item_status,
loans_items.loan_due_date,
loans_items.loan_return_date,
loan_renewals.num_loans
ORDER BY effective_call_number ASC
;
