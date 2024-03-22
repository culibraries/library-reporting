# Materials Management: Music Claimed Returned Report

## Purpose
This report returns a list of all items currently marked 'Claimed returned' across the Music Library.
## Parameters
Searches the Music Library location for items that are currently marked "Claimed returned." Provides the loan ID, item status, claimed date, item barcode, item location, call number, copy, volume, claimed returned note, and patron UUID ("Folio number").
## Sample Output
| loan_id                                | status           | clm_date                        | barcode       | location    | call_num           | cpy | vol | clm_note                                                                      | pat_uuid             |
|----------------------------------------|------------------|---------------------------------|---------------|-------------|--------------------|-----|-----|-------------------------------------------------------------------------------|----------------------|
| "c52f5f6a-b35e-44bc-bed6-b7e058480c14" | Claimed returned | "2024-03-18T21:44:51.891+00:00" | U183072903208 | "Music Ref" | M2.3.U6 R4 vol. 88 | "1" | ""  | "Patron claims it was returned to the book drop in the beginning of January." | patron uuid redacted |
