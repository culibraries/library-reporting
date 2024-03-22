# Materials Management: Gemmill Claimed Returned Report

## Purpose
This report returns a list of all items marked 'Claimed returned' across the Engingeering, Math and Physics Library locations.
## Parameters
Searches the Gemmill Engingeering, Math and Physics Library location for items that are currently marked "Claimed returned." Provides the loan ID, item status, claimed date, item barcode, item location, call number, copy, volume, claimed returned note, and patron UUID ("Folio number").
## Sample Output
| loan_id                                | status              | clm_date                        | barcode       | location                            | call_num           | cpy | vol | clm_note                                                                                                                            | pat_uuid             |   |   |
|----------------------------------------|---------------------|---------------------------------|---------------|-------------------------------------|--------------------|-----|-----|-------------------------------------------------------------------------------------------------------------------------------------|----------------------|---|---|
| a11af2dc-95d6-4590-a020-51a864854a39   | "Claimed  returned" | "2024-01-30T09:18:28.310+00:00" | U183012710564 | Engineering, Math, Physics Stacks   | QC175.4 .D58 1991  | 1   |     | Patron claims to have   returned the item in Fall 2023                                                                              | patron uuid redacted |   |   |
| "fa0d4359-1c7c-4ef2-b99f-f9ea2fe9dc06" | Claimed returned    | "2024-02-12T23:32:45.420+00:00" | U183034142135 | "Engineering, Math, Physics Stacks" | QC174.12 .D34 2001 | "1" | ""  | "Patron emailed 2/12/24 claiming that they returned them to the drop off location outside of the Math Building last semester. -ADS" | patron uuid redacted |   |   |
