CREATE TABLE DASHBOARD_item_holdings_instance_statistics AS
SELECT 	
		isc.statistical_code,
		ie.discovery_suppress AS suppression_status,
		ie.effective_location_name AS item_location,
		ie.status_name,
		he.permanent_location_name AS holdings_location,
		lc.name AS item_campus,
		sp.name AS primary_service_point,
		sp.pickup_location AS setup_as_pickup_location,
		lt.name AS item_library,
		ihi.material_type_name as material_type, 
		ihi.call_number_type_name as call_number_type, 
		ihi.acquisition_method AS acquisition_method, 
		ihi.holdings_type_name as holdings_type, 
		ihi.loan_type_name as loan_type, 
		inst.instance_type_name AS instance_type,
		instf.instance_format_name AS instance_format,
		count (distinct ihi.instance_id) as instance_count,
		count (distinct ihi.holdings_id) as holdings_count,
		count (distinct ihi.item_id) as item_count,  
		count (DISTINCT ihi.item_identifier) AS item_identifier_count,
		count (distinct ihi.barcode) as barcode_count, 
		count (ihi.call_number) as call_number_count, 
		count (ihi.item_level_call_number) as item_call_number_count
FROM folio_derived.items_holdings_instances ihi
LEFT JOIN folio_derived.item_ext ie ON ihi.item_id = ie.item_id 
LEFT JOIN folio_derived.instance_ext inst ON ihi.instance_id = inst.instance_id 
LEFT JOIN folio_derived.instance_formats instf ON instf.instance_id = inst.instance_id 
LEFT JOIN folio_derived.holdings_ext he ON ihi.holdings_id = he.holdings_id 
LEFT JOIN folio_inventory.location__t loc ON ie.effective_location_id = loc.id 
LEFT JOIN folio_inventory.loccampus__t lc ON loc.campus_id = lc.id 
LEFT JOIN folio_inventory.service_point__t sp ON loc.primary_service_point = sp.id 
LEFT JOIN folio_inventory.loclibrary__t lt ON loc.library_id = lt.id 
LEFT JOIN folio_derived.instance_statistical_codes isc ON isc.instance_id = inst.instance_id
GROUP BY 	
isc.statistical_code,			
suppression_status,
			item_location,
			ie.status_name,
			holdings_location,
			item_campus,
			sp.name,
			setup_as_pickup_location,
			item_library,
			material_type, 
			call_number_type, 
			ihi.acquisition_method, 
			holdings_type_name, 
			loan_type_name,
			instance_type_name,
			instance_format
;
