--ACQ103 Subscription Details Report
--This report provides information about all ongoing orders. 
WITH
acq AS (
SELECT 
id AS po_id,
acq_unit_id.jsonb #>> '{}' AS acq_unit
FROM folio_orders.purchase_order
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'acqUnitIds')) WITH ORDINALITY
AS acq_unit_id (jsonb)
),
ISSN AS (
SELECT
ii.instance_id AS instance_id,
string_agg (DISTINCT ii.identifier,' | ') AS ISSN
FROM folio_derived.instance_identifiers AS ii
WHERE ii.identifier_type_name = 'ISSN'
GROUP BY instance_id
),
publisher AS (
SELECT 
ip.instance_id,
string_agg (DISTINCT ip.publisher, ' | ') AS publisher, 
string_agg (DISTINCT ip.date_of_publication,' | ') AS publication_date
FROM folio_derived.instance_publication AS ip
GROUP BY
ip.instance_id
)
	SELECT
	ft.id AS transaction_id,  
	ft.SOURCE,
	a.name AS acquisition_unit,
	u.username AS created_by,
    ftj.creation_date,
    po.date_ordered,
    amt.value AS acquisition_method,
    pol.order_format,
    po.workflow_status,
    pol.payment_status,
    po.order_type,
    ft.amount AS amount,
    ft.currency AS currency,
    ft.transaction_type,
    e.name AS expense_class,
    f.code AS fiscal_year,
    ff.code AS fund_code,
    ff.name AS fund_name,
    jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'status') AS transaction_encumbrance_status,
    jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'subscription') AS transaction_encumbrance_subscription,
    jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'amountAwaitingPayment')::numeric(19,4) AS transaction_encumbrance_amount_awaiting_payment,
    jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'amountExpended')::numeric(19,4) AS transaction_encumbrance_amount_expended,
    jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'initialAmountEncumbered')::numeric(19,4) AS transaction_encumbrance_initial_amount,
    pol.po_line_number AS encumbrance_po_line_number,
    po.po_number AS encumbrance_po_number,
    pol.description, 
    po.re_encumber,
    t.title,
    ISSN.ISSN,
    publisher.publisher,
    publisher.publication_date,
    t.subscription_from,
    t.subscription_to,
    oo.name AS vendor
FROM
	folio_finance.transaction__t AS ft
    LEFT JOIN folio_finance.transaction AS ftj ON ft.id = ftj.id
    LEFT JOIN folio_orders.po_line__t AS pol ON jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'sourcePoLineId')::uuid = pol.id
    LEFT JOIN folio_orders.purchase_order__t AS po ON jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'sourcePurchaseOrderId')::uuid = po.id
    LEFT JOIN folio_orders.purchase_order AS poj ON po.id = poj.id
    LEFT JOIN acq ON acq.po_id = po.id
    LEFT JOIN folio_orders.acquisitions_unit__t AS a ON acq.acq_unit::uuid = a.id
    LEFT JOIN folio_finance.fund__t AS ff ON ft.from_fund_id = ff.id
    LEFT JOIN folio_finance.budget__t AS fb ON ft.from_fund_id = fb.fund_id AND ft.fiscal_year_id = fb.fiscal_year_id
    LEFT JOIN folio_organizations.organizations__t AS oo ON po.vendor = oo.id 
    LEFT JOIN folio_users.users__t AS u ON ftj.created_by = u.id
    LEFT JOIN folio_finance.expense_class__t AS e ON ft.expense_class_id = e.id
    LEFT JOIN folio_finance.fiscal_year__t AS f ON ft.fiscal_year_id = f.id 
    LEFT JOIN folio_orders.acquisition_method__t AS amt ON pol.acquisition_method = amt.id
    LEFT JOIN folio_orders.titles__t AS t ON jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'sourcePoLineId')::uuid = t.po_line_id 
    LEFT JOIN ISSN ON pol.instance_id = ISSN.instance_id 
    LEFT JOIN publisher ON pol.instance_id = publisher.instance_id
WHERE
a.name = 'CU Boulder'
AND 
po.order_type = 'Ongoing'
GROUP BY
ft.id,	
a.name,
u.username,
ftj.creation_date,
po.date_ordered,
amt.value,
po.order_type,
po.workflow_status,
pol.payment_status,
po.order_type,
ft.SOURCE,
ft.amount,
ft.currency,
ft.transaction_type,
e.name,
f.code,
ff.code,
ff.name,
jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'status'),
jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'subscription'),
jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'amountAwaitingPayment')::numeric(19,4),
jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'amountExpended')::numeric(19,4),
jsonb_extract_path_text(ftj.jsonb, 'encumbrance', 'initialAmountEncumbered')::numeric(19,4),
pol.po_line_number,
po.po_number,
pol.description,
pol.order_format,
po.re_encumber,
t.title,
ISSN.ISSN,
publisher.publisher,
publisher.publication_date,
t.subscription_from,
t.subscription_to,
oo.name
