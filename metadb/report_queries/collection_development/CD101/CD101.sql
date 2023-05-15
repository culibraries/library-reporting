/* Documentation of Collection Development: PASCAL Criteria List
DERIVED TABLES
	folio_derived.item_ext
	folio_derived.loans_items
	folio_derived.items_holdings_instances
	folio_derived.		(loans_renewal_count is placeholder until total loan count in table)
	folio_derived.instance_ext
	folio_derived.instance_contributors
	folio_derived.instance_classifications
TABLES
FIELDS
	Item UUID
	Item Create Date
	Item Barcode
	Item Status
	Item Permanent Location
	Item Effective Location
	Item Hold Status
	Title
	Contributor
	Instance Call Number
	Item Call Number
FILTERS FOR USER TO SELECT:
	(Item Total Loans = 0)
	(Item Status = available)
	Location = ''
	Item Last Out Date < ''
	Item Create Date <= ''
	Item Volume = ''	(verify why since this would potentially limit results due to current quality of data for the volume field)
(Amelia Spann Updated: 3/14/23)
*/
WITH parameters AS (
	SELECT 
		'' ::VARCHAR AS Effective_Location_Filter,
		'' ::TIMESTAMP AS Create_Date_Filter,	--ie.created_date is a timestamp field
		'' ::TIMESTAMPTZ AS Last_Out_Date_Filter	--li.loan_date is a timestamptz field
		--''::VARCHAR AS Item_Volume_Filter	--Quality of data could limit results, text field
)		
SELECT
	ie.item_id AS UUID, --Would item HRID be more useful for this list?
	ie.created_date AS Create_Date,
	ie.barcode AS Barcode,
	ie.status_name AS Status,
	--ie.permanent_location_name AS Permanent_Location,  --Remove until more widely applied
	ie.effective_location_name AS Effective_Location,
	li.loan_due_date AS Hold_Status,
	ie2.title AS Title,
	ic.contributor_name AS Contributor,
	ic2.classification_number AS Instance_Call_Number,
	ihi.item_level_call_number AS Item_Call_Number,
	--lrc.num_loans AS Item_Total_Loans,	--(table also has num_renewals) Need total loan count not renewal count, so needs new table or no? 
	li.loan_date AS Last_Out_Date
FROM folio_derived.item_ext AS ie
LEFT JOIN folio_derived.loans_items AS li ON ie.item_id = li.item_id
LEFT JOIN folio_derived.items_holdings_instances AS ihi ON ie.item_id = ihi.item_id
--LEFT JOIN folio_derived.loans_renewal_count AS lrc ON ie.item_id = lrc.item_id	--Removed until new table has total loan count, see above
LEFT JOIN folio_derived.instance_ext AS ie2 ON ihi.instance_id = ie2.instance_id
LEFT JOIN folio_derived.instance_contributors AS ic ON ihi.instance_id = ic.instance_id
LEFT JOIN folio_derived.instance_classifications AS ic2 ON ihi.instance_id = ic2.instance_id
WHERE ie.status_name = 'Available'
	--AND lrc.num_loans = 0		--Removed until new table has total loan count, see above
	AND (ie.effective_location_name = (SELECT Effective_Location_Filter FROM parameters) OR (SELECT Effective_Location_Filter FROM parameters) = '')
	AND (ie.created_date <= (SELECT Create_Date_Filter::TIMESTAMP FROM parameters) -- OR (SELECT Create_Date_Filter FROM parameters) = '')
	AND (li.loan_date < (SELECT Last_Out_Date_Filter::TIMESTAMPTZ FROM parameters) -- OR (SELECT Last_Out_Date_Filter FROM parameters) = '')
	--AND (ie.volume = (SELECT Item_Volume_Filter FROM parameters) OR (SELECT Item_Volume_Filter FROM parameters) = '') --Quality of data could limit results
; 
/* Getting SQL Error [22007]: ERROR: invalid input syntax for type timestamp: ""
*/
