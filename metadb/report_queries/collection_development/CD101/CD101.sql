/** Documentation of Collection Development: PASCAL Criteria List
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
/*
Amelia Spann Updated: 3/6/23
PASCAL Criteria Lists: Creates a table of items that meet the PASCAL transfer criteria.
	Required Fields: Item UUID, Item Create Date, Item Barcode, Item Status, Item Permanent Location, 
		Item Effective Location, Item Hold Status, Title, Contributor, Instance Call Number, Item Call Number
	Filters: Location = '', Item Total Loans = 0, Item Last Out Date less than '', Item Create Date less than or equal to '',
		(TEMP EXCLUDE) Item Volume = "" (verify why since this would potentially limit results due to current quality of data for the volume field),
		 Item Status = available
*/
-- Three required prepared statement parameters.
WITH parameters AS (
	SELECT 
		$1::VARCHAR AS Permanent_Location_Filter,
		$2::VARCHAR AS Last_Out_Date_Filter,	-- To make optional pass a far future date like '9999-01-01'	
		$3::VARCHAR AS Create_Date_Filter		-- To make optional pass a far future date like '9999-01-01'
)		
SELECT
	item_ext.item_id AS UUID,
	item_ext.created_date AS Create_Date,
	item_ext.barcode AS Barcode,
	item_ext.status_name AS Status,
	item_ext.permanent_location_name AS Permanent_Location,
	item_ext.effective_location_name AS Effective_Location,
	loans_items.loan_due_date AS Hold_Status,
	instance_ext.title AS Title,
	instance_contributors.contributor_name AS Contributor,
	instance_classifications.classification_number AS Instance_Call_Number,
	items_holdings_instances.item_level_call_number AS Item_Call_Number,
	loans_renewal_count.num_loans AS Item_Total_Loans,
	loans_items.loan_date AS Last_Out_Date
FROM item_ext
INNER JOIN loans_items ON item_ext.item_id = loans_items.item_id
INNER JOIN items_holdings_instances ON item_ext.item_id = items_holdings_instances.item_id
INNER JOIN loans_renewal_count ON item_ext.item_id = loans_renewal_count.item_id
INNER JOIN instance_ext ON items_holdings_instances.instance_id = instances_ext.instance_id
INNER JOIN instance_contributors ON items_holdings_instances.instance_id = instance_contributors.instance_id
INNER JOIN instance_classifications ON items_holdings_instances.instance_id = instance_classifications.instance_id
-- Joining on prepared statement parameters CTE's single row. 
INNER JOIN parameters p ON TRUE 
WHERE item_ext.status_name = 'Available'
	AND loans_renewal_count.num_loans = 0
	AND item_ext.permanent_location_name = p.Permanent_Location_Filter
	AND item_ext.created_date <= p.Create_Date_Filter	
	AND loans_items.loan_date < p.Last_Out_Date_Filter
;
