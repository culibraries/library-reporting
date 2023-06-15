--MM601: Norlin Trace Lost Report
--This reports returns a list of titlesthat have "Trace Lost" somewhere in the item notes field and library location is in Norlin Library.
--These filters still need to be added: Item Create Date 
WITH parameters AS (
	SELECT 
		'' ::VARCHAR AS effective_location_filter, --Locations: https://docs.google.com/spreadsheets/d/1MMGloxcRGcvQ6EpY9tvu8Gi-pOTYmzGZklEqp2_WQMg/edit#gid=0
		'' ::VARCHAR AS status_filter -- You can choose from: Long missing, Missing, Aged to lost, Claimed returned,Declared lost
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
	i.discovery_suppress as item_suppressed,
	i.material_type_name,
	link.title,
	string_agg (distinct ic.contributor_name,' | ') as author,
	i.copy_number,
	i.volume,
	i.enumeration,
	in2.note_type_name,
	string_agg (DISTINCT in2.note,' | ') AS note,
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
	LEFT JOIN folio_derived.item_notes AS in2 ON i.item_id = in2.item_id 
	LEFT JOIN folio_derived.locations_libraries AS loc ON loc.location_id = i.effective_location_id
WHERE
 -- APPLIES FILTERS FROM THE TOP OF THE QUERY
(i.effective_location_name  = (SELECT effective_location_filter FROM parameters) OR (SELECT effective_location_filter FROM parameters) = '') 
AND 
(status_name = (SELECT status_filter FROM parameters) OR (SELECT status_filter FROM parameters) = '')
AND 
	in2.note ILIKE '%trace lost%'
AND
	i.discovery_suppress = 'false'
AND LOC.library_name = 'Norlin'
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
item_suppressed,
i.material_type_name,
link.title,
i.copy_number,
i.volume,
i.enumeration,
in2.note_type_name,
loan_item_status,
loans_items.loan_due_date,
loans_items.loan_return_date,
loan_renewals.num_loans
ORDER BY i.effective_location_name ASC, effective_call_number
;
