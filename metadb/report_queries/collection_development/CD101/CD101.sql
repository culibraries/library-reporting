/** Documentation of Collection Development: PASCAL Criteria List
DERIVED TABLES

TABLES

FILTERS FOR USER TO SELECT:
*/
/*
Amelia Spann Updated: 3/7/23
PASCAL Criteria Lists: Creates a table of items that meet the PASCAL transfer criteria.
	Required Fields: Item UUID, Item Create Date, Item Barcode, Item Status, Item Permanent Location (-->Temp Exclude), 
					Item Effective Location, Item Hold Status, Title, Contributor, Instance Call Number, Item Call Number
	Filters: Location = '', Item Total Loans = 0, Item Last Out Date less than '', Item Create Date less than or equal to '',
			 Item Volume = "" (verify why since this would potentially limit results due to current quality of 
			data for the volume field) (-->Temp Exclude), Item Status = available
*/
-- Three required prepared statement parameters.
WITH parameters AS (
	SELECT 
		$1 ::VARCHAR AS Effective_Location_Filter,
		$2 ::VARCHAR AS Last_Out_Date_Filter,		
		$3 ::VARCHAR AS Create_Date_Filter		
)		
SELECT
	item_ext.item_id AS UUID,
	item_ext.created_date AS Create_Date,
	item_ext.barcode AS Barcode,
	item_ext.status_name AS Status,
	--item_ext.permanent_location_name AS Permanent_Location,  --Remove until more widely applied
	item_ext.effective_location_name AS Effective_Location,
	loans_items.loan_due_date AS Hold_Status,
	instance_ext.title AS Title,
	instance_contributors.contributor_name AS Contributor,
	instance_classifications.classification_number AS Instance_Call_Number,
	items_holdings_instances.item_level_call_number AS Item_Call_Number,
	loans_renewal_count.num_loans AS Item_Total_Loans,	--Need total loan count not renewal count --> needs new table
	loans_items.loan_date AS Last_Out_Date
FROM folio_derived.item_ext AS ie 	--Added folio_derived.
INNER JOIN folio_derived.loans_items AS li ON ie.item_id = li.item_id
INNER JOIN folio_derived.items_holdings_instances AS ihi ON ie.item_id = ihi.item_id
INNER JOIN folio_derived.loans_renewal_count AS lrc ON ie.item_id = lrc.item_id
INNER JOIN folio_derived.instance_ext AS ie2 ON ihi.instance_id = ie2.instance_id
INNER JOIN folio_derived.instance_contributors AS ic ON ihi.instance_id = ic.instance_id
INNER JOIN folio_derived.instance_classifications AS ic2 ON ihi.instance_id = ic2.instance_id
--Joining on prepared statement parameters CTE's single row. 
INNER JOIN parameters p ON TRUE 
WHERE item_ext.status_name = 'Available'
	AND loans_renewal_count.num_loans = 0
	AND item_ext.effective_location_name = p.Effective_Location_Filter OR p.Effective_Location_Filter = ''
	AND item_ext.created_date <= p.Create_Date_Filter OR p.Create_Date_Filter = ''
	AND loans_items.loan_date < p.Last_Out_Date_Filter OR p.Last_Out_Date_Filter = ''
;
