WITH
acq AS (
SELECT
	po.id AS po_id,
	au.name AS acquisition_unit
FROM
	folio_orders.purchase_order AS po
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(po.jsonb,
	'acqUnitIds')) WITH ORDINALITY AS acq (DATA)
LEFT JOIN folio_orders.acquisitions_unit__t AS au ON
	au.id = (acq.data #>> '{}')::uuid
),
subject AS (
SELECT *
FROM folio_source_record.marc__t AS marc
WHERE marc.field = '650'
AND marc.sf = 'a'
AND marc.ord = 1
),
publisher AS (
SELECT
	ip.instance_id AS instance_id,
	folio_inventory.holdings_record__t.call_number as call_num,
	string_agg (DISTINCT ip.publisher,
	' | ') AS publisher,
	string_agg (DISTINCT ip.date_of_publication,
	' | ') AS publication_date
FROM
	folio_derived.instance_publication AS ip
JOIN folio_inventory.holdings_record__t on ip.instance_id = folio_inventory.holdings_record__t.instance_id
GROUP BY
	ip.instance_id, call_num
),
transactions AS (
--Transfers Going From Fund
SELECT
fy.name as fiscal_year,	
tr.id AS transaction_id,
tr.jsonb ->> 'sourceInvoiceLineId' as invoice_line_id,
tr.jsonb -> 'encumbrance' ->> 'sourcePoLineId' as pol_id,
tr.jsonb ->> 'transactionType' AS transaction_type,
tr.jsonb ->> 'source' AS transaction_source,
tr.creation_date::date as creation_date,
concat(tcb.jsonb -> 'personal' ->> 'firstName',
		' ',
		tcb.jsonb -> 'personal' ->> 'lastName') AS transaction_created_by,
concat(tub.jsonb -> 'personal' ->> 'firstName',
		' ',
		tub.jsonb -> 'personal' ->> 'lastName') AS transaction_updated_by,
f.name AS transaction_fund,
f.code AS transaction_fund_code,
	(tr.jsonb ->> 'amount')::NUMERIC(12,
	2)*-1 AS transaction_amount
FROM
	folio_finance.TRANSACTION AS tr
LEFT JOIN folio_finance.fund__t AS f ON
	f.id = tr.fromfundid
LEFT JOIN folio_users.users AS tcb ON
	tcb.id = (tr.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
left join folio_users.users as tub on 
	tub.id = (tr.jsonb -> 'metadata' ->> 'updatedByUserId')::uuid
LEFT JOIN folio_finance.fiscal_year__t AS fy ON
	fy.id = tr.fiscalyearid
WHERE
	tr.jsonb ->> 'transactionType' = 'Transfer'
UNION
--Transfers Going To Funds
SELECT
fy.name as fiscal_year,	
tr.id AS transaction_id,
tr.jsonb ->> 'sourceInvoiceLineId' as invoice_line_id,
tr.jsonb -> 'encumbrance' ->> 'sourcePoLineId' as pol_id,
tr.jsonb ->> 'transactionType' AS transaction_type,
tr.jsonb ->> 'source' AS transaction_source,
tr.creation_date::date as creation_date,
concat(tcb.jsonb -> 'personal' ->> 'firstName',
		' ',
		tcb.jsonb -> 'personal' ->> 'lastName') AS transaction_created_by,
concat(tub.jsonb -> 'personal' ->> 'firstName',
		' ',
		tub.jsonb -> 'personal' ->> 'lastName') AS transaction_updated_by,
	f.name AS transaction_fund,
f.code AS transaction_fund_code,
	(tr.jsonb ->> 'amount')::NUMERIC(12,
	2) AS transaction_amount
FROM
	folio_finance.TRANSACTION AS tr
LEFT JOIN folio_finance.fund__t AS f on
	f.id = tr.tofundid
LEFT JOIN folio_users.users AS tcb ON
	tcb.id = (tr.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
left join folio_users.users as tub on 
	tub.id = (tr.jsonb -> 'metadata' ->> 'updatedByUserId')::uuid
LEFT JOIN folio_finance.fiscal_year__t AS fy ON
	fy.id = tr.fiscalyearid
WHERE
	tr.jsonb ->> 'transactionType' = 'Transfer'
UNION
--Money Coming Out of Funds
SELECT
fy.name as fiscal_year,	
tr.id AS transaction_id,
tr.jsonb ->> 'sourceInvoiceLineId' as tsource_invoice,
tr.jsonb -> 'encumbrance' ->> 'sourcePoLineId' as tsource_pol,
tr.jsonb ->> 'transactionType' AS transaction_type,
tr.jsonb ->> 'source' AS transaction_source,
tr.creation_date::date as creation_date,
concat(tcb.jsonb -> 'personal' ->> 'firstName',
		' ',
		tcb.jsonb -> 'personal' ->> 'lastName') AS transaction_created_by,
concat(tub.jsonb -> 'personal' ->> 'firstName',
		' ',
		tub.jsonb -> 'personal' ->> 'lastName') AS transaction_updated_by,
f.name AS transaction_fund,
f.code AS transaction_fund_code,
	(tr.jsonb ->> 'amount')::NUMERIC(12,
	2)*-1 AS transaction_amount
FROM
	folio_finance.transaction AS tr
LEFT JOIN folio_finance.fund__t AS f ON
	f.id = tr.fromfundid
LEFT JOIN folio_users.users AS tcb ON
	tcb.id = (tr.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
left join folio_users.users as tub on 
	tub.id = (tr.jsonb -> 'metadata' ->> 'updatedByUserId')::uuid
LEFT JOIN folio_finance.fiscal_year__t AS fy ON
	fy.id = tr.fiscalyearid
WHERE
	tr.fromfundid NOTNULL
UNION
--Money Going Into Funds
SELECT
fy.name as fiscal_year,	
tr.id AS transaction_id,
tr.jsonb ->> 'sourceInvoiceLineId' as invoice_line_id,
tr.jsonb -> 'encumbrance' ->> 'sourcePoLineId' as pol_id,
tr.jsonb ->> 'transactionType' AS transaction_type,
tr.jsonb ->> 'source' AS transaction_source,
tr.creation_date::date as creation_date,
concat(tcb.jsonb -> 'personal' ->> 'firstName',
		' ',
		tcb.jsonb -> 'personal' ->> 'lastName') AS transaction_created_by,
concat(tub.jsonb -> 'personal' ->> 'firstName',
		' ',
		tub.jsonb -> 'personal' ->> 'lastName') AS transaction_updated_by,
f.name AS transaction_fund,
f.code AS transaction_fund_code,
(tr.jsonb ->> 'amount')::NUMERIC(12,2) AS transaction_amount
FROM
	folio_finance.transaction AS tr
LEFT JOIN folio_finance.fund__t AS f ON
	f.id = tr.tofundid
LEFT JOIN folio_users.users AS tcb ON
	tcb.id = (tr.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
left join folio_users.users as tub on 
	tub.id = (tr.jsonb -> 'metadata' ->> 'updatedByUserId')::uuid
LEFT JOIN folio_finance.fiscal_year__t AS fy ON
	fy.id = tr.fiscalyearid
WHERE
	tr.tofundid NOTNULL
)
select distinct on (concat(pol.jsonb ->> 'poLineNumber', polinvl.jsonb ->> 'poLineNumber')) concat(pol.jsonb ->> 'poLineNumber', polinvl.jsonb ->> 'poLineNumber') AS po_line_number,
	tra.fiscal_year,
	--tra.transaction_id,
	--tra.creation_date::date,
	--tra.transaction_created_by,
	--tra.transaction_updated_by,
	--tra.transaction_type,
	--tra.transaction_source,
	--tra.transaction_fund,
	--tra.transaction_fund_code,
	--tra.transaction_amount,
	concat((po.jsonb ->> 'dateOrdered')::date,
	(poinv.jsonb ->> 'dateOrdered')::date) AS date_ordered,
	concat(oopo.name, ooinv.name, oo.name) AS vendor,
	--concat(concat(upo.jsonb -> 'personal' ->> 'firstName', ' ', upo.jsonb -> 'personal' ->> 'lastName'),
	--concat(upoinvl.jsonb -> 'personal' ->> 'firstName', ' ', upoinvl.jsonb -> 'personal' ->> 'lastName')) AS purchase_created_by,
	--concat(po.jsonb ->> 'poNumber', poinv.jsonb ->> 'poNumber') AS po_number,
	--concat(po.jsonb ->> 'workflowStatus', poinv.jsonb ->> 'workflowStatus') AS workflowstatus,
	--concat(po.jsonb -> 'closeReason' ->> 'reason', poinv.jsonb -> 'closeReason' ->> 'reason') AS reason_closed,
	--concat(po.jsonb ->> 'reEncumber',poinv.jsonb ->> 'reEncumber') AS re_encumber,
	--concat(po.jsonb -> 'ongoing' ->> 'interval', poinv.jsonb -> 'ongoing' ->> 'interval') AS ongoing_interval,
	--concat(po.jsonb -> 'ongoing' ->> 'manualRenewal', poinv.jsonb -> 'ongoing' ->> 'manualRenewal') AS ongoing_manual_renewal,
	--concat(po.jsonb -> 'ongoing' ->> 'isSubscription', poinv.jsonb -> 'ongoing' ->> 'isSubscription') AS is_subscription,
	--concat(po.jsonb ->> 'orderType', poinv.jsonb ->> 'orderType') AS order_type,
	--concat(po.jsonb ->> 'approved', poinv.jsonb ->> 'approved') AS approval_status,
	--concat(otpo.template_name, otpoinv.template_name) AS order_template,
	--concat(amt.value, amtinv.value) AS acquisition_method,
	--concat(acq.acquisition_unit, acqinv.acquisition_unit) as acquisition_unit,
	--concat(pol.jsonb ->> 'poLineNumber', polinvl.jsonb ->> 'poLineNumber') AS po_line_number,
	--concat(pol.jsonb ->> 'orderFormat', polinvl.jsonb ->> 'orderFormat') AS order_format,
	--concat(pol.jsonb ->> 'rush', polinvl.jsonb ->> 'rush') AS rush,
	--concat(pol.jsonb ->> 'paymentStatus', polinvl.jsonb ->> 'paymentStatus') AS payment_status,
	--concat(pol.jsonb ->> 'receiptStatus', polinvl.jsonb ->> 'receiptStatus') AS receipt_status,
	--concat(pol.jsonb ->> 'notes', polinvl.jsonb ->> 'notes') AS po_notes,
	--concat(mte.name, mtp.name, invmte.name, invmtp.name) AS material_type,
	concat(t.title, invl.jsonb ->> 'description') AS title_description,
	concat(publisher.publisher, publisherinvl.publisher) AS publisher,
	--concat(publisher.publication_date, publisherinvl.publication_date) AS publication_date,
	--inv.jsonb ->> 'vendorInvoiceNo' AS vendor_invoice_number,
	--invl.jsonb ->> 'invoiceLineNumber' AS invoice_line_number,
	--inv.jsonb ->> 'adjustmentsTotal' AS invoice_adjustments,
	(invl.jsonb ->> 'total') AS invl_total,
	--(inv.jsonb ->> 'total') AS inv_total, 
	concat(subjectinvl.content, subjectpoline.content) as subject,
	publisher.call_num
from transactions AS tra
LEFT JOIN folio_invoice.invoice_lines AS invl on tra.invoice_line_id::uuid = invl.id
LEFT JOIN folio_invoice.invoices AS inv on inv.id = invl.invoiceid
LEFT JOIN folio_orders.po_line AS pol on pol.id = tra.pol_id::uuid
LEFT JOIN folio_inventory.material_type__t AS mtp on mtp.id = (pol.jsonb -> 'physical' ->> 'materialType')::uuid
LEFT JOIN folio_inventory.material_type__t AS mte on mte.id = (pol.jsonb -> 'eresource' ->> 'materialType')::uuid
LEFT JOIN publisher on publisher.instance_id = (pol.jsonb ->> 'instanceId')::uuid
LEFT JOIN folio_orders.purchase_order AS po on po.id = pol.purchaseorderid
LEFT JOIN acq on acq.po_id = po.id
LEFT JOIN folio_organizations.organizations__t AS oo on oo.id = (po.jsonb ->> 'vendor')::uuid
LEFT JOIN folio_orders.titles__t AS t on tra.pol_id::uuid = t.po_line_id
LEFT JOIN folio_orders.po_line AS polinvl on (invl.jsonb ->> 'poLineId')::uuid = polinvl.id
LEFT JOIN folio_orders.acquisition_method__t AS amt on amt.id = (polinvl.jsonb ->> 'acquisitionMethod')::uuid
LEFT JOIN folio_orders.acquisition_method__t AS amtinv on amtinv.id = (pol.jsonb ->> 'acquisitionMethod')::uuid
LEFT JOIN folio_orders.purchase_order AS poinv on poinv.id = polinvl.purchaseorderid
LEFT JOIN folio_orders.order_templates__t AS otpo on otpo.id = (po.jsonb ->> 'template')::uuid
LEFT JOIN folio_orders.order_templates__t AS otpoinv on otpoinv.id = (poinv.jsonb ->> 'template')::uuid
LEFT JOIN acq AS acqinv on acqinv.po_id = poinv.id
LEFT JOIN folio_organizations.organizations__t AS ooinv on ooinv.id = (inv.jsonb ->> 'vendorId')::uuid
LEFT JOIN folio_organizations.organizations__t AS oopo on oopo.id = (poinv.jsonb ->> 'vendorId')::uuid
LEFT JOIN folio_inventory.material_type__t AS invmtp on invmtp.id = (polinvl.jsonb -> 'physical' ->> 'materialType')::uuid
LEFT JOIN folio_inventory.material_type__t AS invmte on invmte.id = (polinvl.jsonb -> 'eresource' ->> 'materialType')::uuid
LEFT JOIN publisher AS publisherinvl on publisherinvl.instance_id = (polinvl.jsonb ->> 'instanceId')::uuid
left join subject as subjectinvl on subjectinvl.instance_id = (polinvl.jsonb ->> 'instanceId')::uuid
left join subject as subjectpoline on subjectpoline.instance_id = (pol.jsonb ->> 'instanceId')::uuid
LEFT JOIN folio_users.users AS upo on upo.id = (pol.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
LEFT JOIN folio_users.users AS upoinvl on upoinvl.id = (polinvl.jsonb -> 'metadata' ->> 'createdByUserId')::uuid
--left join folio_inventory.holdings_record__t on folio_derived.instance_publication.instance_id = folio_inventory.holdings_record__t
WHERE
	tra.fiscal_year LIKE '%Law%'
--ORDER BY
	--tra.creation_date::date DESC
