--ACQ100: Reconciliation Report
--This report is used by Accounting to reconcile new purchases. 
SELECT
acqu.po_acquisition_unit_name,
il.id AS invoice_line_id,
il.invoice_line_number,
il.invoice_line_status,
pol.po_line_number,
il.description AS order_name,
f.name AS fund,
org.name AS vendor,
il.total AS invoice_line_total,
l.description AS ledger,
i.folio_invoice_no,
i.vendor_invoice_no,
i.invoice_date,
il.account_number AS invoice_account_number,
i.payment_date,
i.payment_method,
t.transaction_type,
t.amount AS transaction_amount,
pol.receipt_status,
pol.receipt_date
FROM folio_invoice.invoice_lines__t AS il
LEFT JOIN folio_invoice.invoices__t AS i ON i.id = il.invoice_id 
LEFT JOIN folio_finance.transaction__t AS t ON il.id = t.source_invoice_line_id 
LEFT JOIN folio_finance.fund__t AS f ON t.from_fund_id = f.id
LEFT JOIN folio_finance.ledger__t AS l ON f.ledger_id = l.id 
LEFT JOIN folio_orders.po_line__t AS pol ON il.po_line_id = pol.id
LEFT JOIN folio_orders.purchase_order__t AS po ON po.id = pol.purchase_order_id 
LEFT JOIN folio_derived.po_acq_unit_ids AS acqu ON po.id = acqu.po_id 
LEFT JOIN folio_organizations.organizations__t AS org ON po.vendor = org.id
WHERE ACQU.po_acquisition_unit_name != 'Law'
;
