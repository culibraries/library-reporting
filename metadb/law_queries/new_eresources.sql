-- Use this query to pull new eresources titles

-- This query pulls serial pieces we're expecting but haven't gotten yet. --
-- Alter the pieces.receipt_date as needed. --

select pol.po_line_number, plf.fund_code , pol.title_or_package, pieces.enumeration,
	pieces.receiving_status, pieces.receipt_date 
from folio_orders.po_line__t as pol
join folio_orders.pieces__t as pieces on pol.id = pieces.po_line_id 
join folio_derived.po_lines_fund_distribution_transactions as plf on pol.id = plf.po_line_id 
where pol.receipt_status = 'Ongoing'
	and pieces.receiving_status = 'Expected'
	and plf.fund_code like 'Law%'
	and pieces.receipt_date <= '2023-07-01'
;
