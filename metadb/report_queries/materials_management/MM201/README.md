# Materials Management: Business Claimed Returned Report

## Purpose
This report returns a list of all items currently marked 'Claimed returned' across the Business Library.
## Parameters
Searches the Business Library location for items that are currently marked "Claimed returned." Provides the loan ID, item status, claimed date, item barcode, item location, call number, copy, volume, claimed returned note, and patron UUID ("Folio number").
## Sample Output
| loan_id                                | status             | clm_date                        | barcode       | location          | call_num          | cpy | vol                                   | clm_note                                                                                           | pat_uuid             |
|----------------------------------------|--------------------|---------------------------------|---------------|-------------------|-------------------|-----|---------------------------------------|----------------------------------------------------------------------------------------------------|----------------------|
| 983fe62e-5412-4afd-9e75-2dd485ecbfa2   | "Claimed returned" | "2023-12-05T14:16:37.000+00:00" | U183049388267 | Business Stacks   | HG4521 .J264 2010 | "1" |                                       | Patron said sometime   last year in 10/12/23 email, never responded to further inquiry. RL/ADS     | patron uuid redacted |
| "482cc39c-a31f-484d-bda0-0d0b9a96bc8e" | Claimed returned   | "2024-03-07T23:17:53.000+00:00" | U183075495717 | "Business Stacks" |                   | "1" | "Headphones - Logitech H390 with mic" | "Patron claimed that they returned the item soon after borrowing it at the Business Library. -SRB" | patron uuid redacted |
