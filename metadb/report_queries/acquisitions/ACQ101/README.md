# Acquisitions: Order Details Report 

## Purpose
This report provides some details about purchases on a particular fund. 

## Parameters
You can filter this query using the following fields: 

Acquisition Unit: 'CU Boulder' or 'Law'

Fund: Subject fund code

Fiscal Year: 'FY23','FY24'

PO Workflow Status: 'Open','Closed'

Payment Status: 'Awaiting Payment','Fully Paid','Pending',etc...

Acquisition Method: 'Purchase','Approval Plan','Demand-Driven Acquisitions (DDA)', etc....

## Sample Output
| acquisition_unit | transaction_id                       | created_by | creation_date | date_ordered | workflow_status | payment_status   | order_type | receipt_status   | receipt_date | source | amount | currency | transaction_type | expense_class | fiscal_year | fund_code | fund_name                            | transaction_encumbrance_status | transaction_encumbrance_subscription | transaction_encumbrance_amount_awaiting_payment | transaction_encumbrance_amount_expended | transaction_encumbrance_initial_amount | encumbrance_po_line_number | encumbrance_po_number | description | acquisition_method | order_type | order_format        | re_encumber | title                                                                    | isbn                                                                     | publisher                  | date_publication | subscription_from | subscription_to | vendor                      |
|------------------|--------------------------------------|------------|---------------|--------------|-----------------|------------------|------------|------------------|--------------|--------|--------|----------|------------------|---------------|-------------|-----------|--------------------------------------|--------------------------------|--------------------------------------|-------------------------------------------------|-----------------------------------------|----------------------------------------|----------------------------|-----------------------|-------------|--------------------|------------|---------------------|-------------|--------------------------------------------------------------------------|--------------------------------------------------------------------------|----------------------------|------------------|-------------------|-----------------|-----------------------------|
| CU Boulder       | 0002557e-88ea-41ca-9070-dcd8ed866dbe | id_admin   | 4/11/2023     | 4/11/2023    | Open            | Awaiting Payment | One-Time   | Awaiting Receipt |              | PoLine | 0      | USD      | Encumbrance      |               | FY2023      | vrtmo     | ProQuest Virtual Approval Plan & DDA | Unreleased                     | FALSE                                | 0                                               | 0                                       | 0                                      | 987209-1                   | 987209                | b12802794   | Approval Plan      | One-Time   | Electronic Resource | FALSE       | Alternatives in Mobilization Ethnicity, Religion, and Political Conflict | 1108331130 \| 9781108331135 \| (OCoLC)1321799153 \| (OCoLC)ebq1321799153 | Cambridge University Press | 2022             |                   |                 | Coutts Information Services |
