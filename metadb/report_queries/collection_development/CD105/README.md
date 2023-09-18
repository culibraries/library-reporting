# CD105: Circulation Title Report

## Purpose
Returns a list of currrent loans from **folio_circulation.loan__t__**
## Parameters
Loan has a current status
## Sample Output
| __current | loan_id                              | record_load_date | item_status | loan_date | material_type    | checkout_service_point | item_location                   | due_date   | loan_policy                   | loan_action | item_barcode  | title                                                                                                                                 | patron_group       |
|-----------|--------------------------------------|------------------|-------------|-----------|------------------|------------------------|---------------------------------|------------|-------------------------------|-------------|---------------|---------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| TRUE      | 40f4dc2c-ff19-40a9-b4ea-b54e27f1e8ab | 9/18/2023        | Checked out | 9/18/2023 | gov pres steward | Norlin East Desk       | En Route to PASCAL Reading Room | 9/18/2026  | CU Boulder Library Department | checkedout  | U183060966973 | Weathering the storm: reauthorizing the National Windstorm Impact   Reduction Program, Hearing, Serial no. 117-37, November 10, 2021. | Library Department |
| TRUE      | 099becb0-4573-47d1-947a-fa9d2c9006c4 | 9/18/2023        | Available   | 6/9/2023  | journal          | Norlin East Desk       | PASCAL                          | 11/30/2023 | CU Boulder Library Department | checkedin   | P104301803013 | Science of light.                                                                                                                     | Library Department |
| TRUE      | 4b1de29d-1b94-4ed5-b8e5-4a112d31d772 | 9/18/2023        | Available   | 6/9/2023  | journal          | Norlin East Desk       | PASCAL                          | 11/30/2023 | CU Boulder Library Department | checkedin   | P104320810003 | Industrial education magazine.                                                                                                        | Library Department |
