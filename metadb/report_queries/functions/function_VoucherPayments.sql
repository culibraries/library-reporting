--metadb:function voucher_payments

drop function if exists voucher_payments;

create function voucher_payments()
returns TABLE(
voucher_number text,
voucher_date date,
Vendor_Invoice text,
Vendor_Invoice_Line text,
Invoice_Date date,
Payment_Date date,
invoice_line_adjustment text,
adjustment_value text,
Title text,
PoLine text,
fund_code text,
voucher_value text,
external_account text
)
as $$
with vfdist as (
select
vl.id as voucher_line,
dist.data ->> 'code' as fund_code,
dist.data ->> 'value' as voucher_value,
dist.data ->> 'invoiceLineId' as invoice_line_id,
dist.data ->> 'distributionType' as distribution_type,
dist.data ->> 'encumbrance' as po_line_id,
pol.id
from folio_invoice.voucher_lines as vl
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'fundDistributions')) AS dist (data)
left join folio_orders.po_line as pol on pol.id = (dist.data ->> 'encumbrance')::uuid
where dist.data ->> 'code' not like '%Law%'
),
invl_adj as (
select 
id as invoiceLineId,
dist.data ->> 'description' as invoice_line_adjustment,
dist.data ->> 'value' as adjustment_value
from folio_invoice.invoice_lines 
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'adjustments')) AS dist (data)
)
select
v.jsonb ->> 'voucherNumber' as voucher_number,
(v.jsonb ->> 'voucherDate')::date as voucher_date,
inv.jsonb ->> 'vendorInvoiceNo' as Vendor_Invoice,
invl.jsonb ->> 'invoiceLineNumber' as Vendor_Invoice_Line,
(inv.jsonb ->> 'invoiceDate')::date as Invoice_Date,
(inv.jsonb ->> 'paymentDate')::date as Payment_Date,
invl_adj.invoice_line_adjustment,
invl_adj.adjustment_value,
invl.jsonb ->> 'description' as Title, 
pol.jsonb ->> 'poLineNumber' as PoLine,
vfdist.fund_code,
vfdist.voucher_value,
vl.jsonb ->> 'externalAccountNumber' as external_account
from folio_invoice.voucher_lines vl
left join folio_invoice.vouchers v on v.id = vl.voucherid
left join vfdist on vfdist.voucher_line = vl.id
left join folio_organizations.organizations as org on org.id = (v.jsonb ->> 'vendorId')::uuid
left join folio_invoice.invoice_lines as invl on invl.id = vfdist.invoice_line_id::uuid
left join folio_invoice.invoices as inv on inv.id = (v.jsonb ->> 'invoiceId')::uuid
left join folio_orders.po_line as pol on pol.id = (invl.jsonb ->> 'poLineId')::uuid
left join invl_adj on invl_adj.invoiceLineId = invl.id
where v.jsonb ->> 'acqUnitIds' like '%24c4baf7-0653-517f-b901-bde483894fdd%'
and v.jsonb ->> 'status' = 'Paid'
order by v.jsonb ->> 'voucherDate', inv.jsonb ->> 'vendorInvoiceNo', invl.jsonb ->> 'invoiceLineNumber' ASC
$$
language sql 
stable 
parallel safe;
