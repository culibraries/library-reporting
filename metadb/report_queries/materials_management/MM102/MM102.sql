/** MM102: Old In Transits List
--
--This report returns a list of items that have a status of in transit. 
--
--
--Filters: Filter results by replacing the green text between single quote marks in the parameters section.
----Location can be changed be selecting a location name from the linked spreadsheet, or leave blank to return results for all locations.  
----Last Checkin Date can be changed using the Last_In_Date_Filter
----Item create date can be changed by using the Create_Date_Filter
----Note that for the last in and create date filters, date and timestamp must follow the format YYYY-MM-DD HH:MM:SS MST i.e., 2023-05-01 00:00:00 MST
--
--Outstanding questions: how to filter for items without last checkin date? 
**/

WITH parameters AS (
	SELECT 
		'Norlin Stacks'::VARCHAR AS Effective_Location_Filter, 
		--To query another location, see location names here: https://docs.google.com/spreadsheets/d/1MMGloxcRGcvQ6EpY9tvu8Gi-pOTYmzGZklEqp2_WQMg/edit#gid=0--
		'9999-01-01 00:00:00 MST'::timestamptz AS Last_In_Date_Filter,	-- To make optional use a far future date like '9999-01-01 00:00:00 MST'	
		'9999-01-01 00:00:00 MST'::timestamptz AS Create_Date_Filter	-- To make optional use a far future date like '9999-01-01 00:00:00 MST'
)	
SELECT
	ie.item_id AS UUID, 
	ie.created_date AS Create_Date,
	ie.status_name AS Status,
	ie.effective_location_name AS Effective_Location,
	--ie.permanent_location_name AS Permanent_Location, (removed this column while permanent location is not working--)
	ie2.title AS Title,
	ic2.classification_number AS Instance_Call_Number,
	ie.effective_call_number AS Item_Call_Number,
	cit.occurred_date_time AS Last_Checkin_Date
FROM folio_derived.item_ext AS ie
LEFT JOIN folio_derived.loans_items AS li ON ie.item_id = li.item_id
LEFT JOIN folio_derived.items_holdings_instances AS ihi ON ie.item_id = ihi.item_id
LEFT JOIN folio_derived.instance_ext AS ie2 ON ihi.instance_id = ie2.instance_id
LEFT JOIN folio_derived.instance_classifications AS ic2 ON ihi.instance_id = ic2.instance_id
LEFT JOIN folio_circulation.check_in__t__ as cit on ie.item_id = cit.item_id --trying to get last checkin date, remove this line if faulty--
LEFT JOIN parameters p ON TRUE 
WHERE 
	(ie.status_name = 'In transit')
	AND (ie.effective_location_name  = (SELECT effective_location_filter FROM parameters) OR (SELECT effective_location_filter FROM parameters) = '') 
	AND ie.created_date <= p.Create_Date_Filter	
	AND cit.occurred_date_time <= p.Last_In_Date_Filter
;
