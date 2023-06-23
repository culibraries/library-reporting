CREATE TABLE DASHBOARD_budget_summary as
SELECT
fy.name AS FY,
l.description AS ledger,
b.name AS budget,
b.budget_status,
f.code AS fund_code,
f.name AS fund_name,
b.initial_allocation,
b.allocated,
b.expenditures,
b.encumbered,
b.available,
b.cash_balance,
b.total_funding
FROM folio_finance.budget__t AS b
LEFT JOIN folio_finance.fund__t AS f ON b.fund_id = f.id 
LEFT JOIN folio_finance.fiscal_year__t AS fy ON b.fiscal_year_id = fy.id
LEFT JOIN folio_finance.ledger__t AS l ON f.ledger_id = l.id 
