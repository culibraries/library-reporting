/*
 * Select Filters
 * 
 * Fund: use subject fund (lowercase)
 * Fiscal year: FY23, FY24
 * Status: Open, Closed
 */
WITH parameters AS (
	SELECT 
		'' ::VARCHAR AS fund_filter,
		'' ::VARCHAR AS fiscal_year_filter,
		'' ::VARCHAR AS po_status_filter)
SELECT
transactions.po_number,
transactions.poline_number,
transactions.po_workflowstatus,
transactions.fund_code,
transactions.fiscal_year,
transactions.poline_title_or_package AS title,
transactions.poline_listunitprice AS unit_price,
transactions.transaction_amount AS transaction_amount
FROM folio_derived.po_line_fund_distribution_transactions AS transactions
WHERE (transactions.fund_code = (SELECT fund_filter FROM parameters) OR (SELECT fund_filter FROM parameters) = '') 
	AND
	(transactions.fiscal_year = (SELECT fiscal_year_filter FROM parameters) OR (SELECT fiscal_year_filter FROM parameters) = '') 
	AND
	(transactions.po_workflowstatus = (SELECT po_status_filter FROM parameters) OR (SELECT po_status_filter FROM parameters) = '')
;
