# Materials Management: Earth Sciences & Map Claimed Returned Report

## Purpose
This report returns a list of all items currently marked 'Claimed returned' across the Earth Sciences and Map Library.
## Parameters
Searches the Earth Sciences & Map Library location for items that are currently marked "Claimed returned." Provides the loan ID, item status, claimed date, item barcode, item location, call number, copy, volume, claimed returned note, and patron UUID ("Folio number").
## Sample Output
| loan_id                                | status           | clm_date                        | barcode       | location                 | call_num  | cpy | vol | clm_note                                                                                              | pat_uuid             |
|----------------------------------------|------------------|---------------------------------|---------------|--------------------------|-----------|-----|-----|-------------------------------------------------------------------------------------------------------|----------------------|
| "517f83c5-49a5-4ca3-8331-65dc6b47a78d" | Claimed returned | "2024-03-12T18:25:06.830+00:00" | U183033475195 | "Map Library South Wall" | MF-1483-A | "1" | ""  | "Patron says they dropped off this item in a box with multiple other items that got checked in. -SRB" | patron uuid redacted |
