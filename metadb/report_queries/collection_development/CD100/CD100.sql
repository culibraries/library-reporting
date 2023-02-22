/*
 * Filters for:
 * Location
 * 
 * Need to add:
 * Instance Subject Terms - have to connect item to unique instance - may need to be separate query
 * Item Create Date
 * Item Hold Status (from folio_ciruclation.requests_t
 * Item Publisher - have to connect item to unqiue instance
 * ISBN - have to connect item to unique instance
 */
WITH parameters AS (
	SELECT 
		'Norlin Stacks' ::VARCHAR AS effective_location_filter
)
/*
 * Select Table Details
 * 
 * Need to add:
 * Contributer - need to connect items to unique instance
 * ISBN - need to connect items to unique instance
 * Publisher - need to connect items to unique instance
 * Subject Terms - need to connect items to unique instance
 */
SELECT
	i.item_id,
	i.created_date AS create_date,
	i.barcode,
	i.status_name AS status,
	i.effective_location_name,
	i.effective_call_number,
	i.chronology,
	i.enumeration,
	i.material_type_name,
	i.discovery_suppress as item_suppressed,
	link.title,
	loans_items.item_status AS loan_item_status,
	loans_items.loan_due_date,
	loans_items.loan_return_date,
	loan_renewals.num_loans	
FROM 
	folio_derived.item_ext AS i
	LEFT JOIN folio_derived.loans_items ON i.item_id = loans_items.item_id
	LEFT JOIN folio_derived.loans_renewal_count AS loan_renewals ON i.item_id = loan_renewals.item_id
	LEFT JOIN folio_derived.items_holdings_instances AS link ON i.item_id = link.item_id
/*
 * Applies filters from the top of the query
 */
WHERE
(i.effective_location_name  = (SELECT effective_location_filter FROM parameters) OR (SELECT effective_location_filter FROM parameters) = '') 
/*
 * Applies hardcoded filter to only return items that have a status of 'Available'
 */
AND 
	status_name = 'Available'
ORDER BY effective_call_number ASC
;
