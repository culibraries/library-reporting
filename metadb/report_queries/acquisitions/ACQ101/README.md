# Acquisitions: Order Details Report 

## Purpose
This report provides some details about purchases on a particular fund. 

## Parameters
You can filter this query using the following fields: 

**Acquisition Unit**: 
'CU Boulder' or 'Law'

**Fund**: 
Subject fund code

**Fiscal Year**: 
'FY23','FY24'

**PO Workflow Status**: 
'Open','Closed'

**Payment Status**: 
'Awaiting Payment','Fully Paid','Pending',etc...

**Acquisition Method**: 
'Purchase','Approval Plan','Demand-Driven Acquisitions (DDA)', etc....

## Sample Output
| transaction_id                       | source | acquisition_unit | created_by | creation_date | date_ordered | acquisition_method | order_format      | workflow_status | payment_status   | order_type | receipt_status   | receipt_date | amount | currency | transaction_type | expense_class | fiscal_year | fund_code | fund_name       | transaction_encumbrance_status | transaction_encumbrance_subscription | transaction_encumbrance_amount_awaiting_payment | transaction_encumbrance_amount_expended | transaction_encumbrance_initial_amount | encumbrance_po_line_number | encumbrance_po_number | description | re_encumber | title                                                                                  | isbn                        | issn | publisher             | publication_date | subscription_from | subscription_to | vendor                      |
|--------------------------------------|--------|------------------|------------|---------------|--------------|--------------------|-------------------|-----------------|------------------|------------|------------------|--------------|--------|----------|------------------|---------------|-------------|-----------|-----------------|--------------------------------|--------------------------------------|-------------------------------------------------|-----------------------------------------|----------------------------------------|----------------------------|-----------------------|-------------|-------------|----------------------------------------------------------------------------------------|-----------------------------|------|-----------------------|------------------|-------------------|-----------------|-----------------------------|
| 005a7a23-f597-481b-a204-99a3c11ab325 | PoLine | CU Boulder       | id_admin   | 4/11/2023     | 4/11/2023    | Purchase           | Physical Resource | Open            | Awaiting Payment | One-Time   | Awaiting Receipt |              | 24.95  | USD      | Encumbrance      |               | FY2023      | zsgmo     | Suggest a title | Unreleased                     | FALSE                                | 0                                               | 0                                       | 24.95                                  | 995980-1                   | 995980                | b12873694   | FALSE       | Red star over the Pacific : China's rise and the challenge to U.S.   maritime strategy | 1682472183 \| 9781682472187 |      | Naval Institute Press | [2018]           |                   |                 | Coutts Information Services |
