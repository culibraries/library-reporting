# eResource Management: Film Expiration Search 

## Purpose
The purpose of this query is to find films that have expiring licenses. Run monthly. 
## Parameters
Finds expiration dates (month/year) by instance notes.
## Sample Output
| instance_id                          | instance_hrid | instance_note                         | staff_only_note | instance_note_type_id                | instance_note_type_name     | instance_notes_ordinality |
|--------------------------------------|---------------|---------------------------------------|-----------------|--------------------------------------|-----------------------------|---------------------------|
| ee034c01-a93f-5322-a9d5-a9e9e466d302 | b12766401     | CU Boulder license expires: 8/31/2023 | FALSE           | e814a32e-02da-4773-8f3a-6629cdb7ecdf | Restrictions on Access note | 1                         |
| de48ed0b-8f45-5978-8c3e-8c494787cf25 | b11749435     | CU Boulder license expires: 8/31/2023 | FALSE           | e814a32e-02da-4773-8f3a-6629cdb7ecdf | Restrictions on Access note | 4                         |
| e0a979e4-64df-5ce3-bbb4-e5fa1bb2a67e | b11929862     | CU Boulder license expires: 8/31/2023 | FALSE           | e814a32e-02da-4773-8f3a-6629cdb7ecdf | Restrictions on Access note | 1                         |
| e0926149-d4e8-5808-aee1-4eb6bd8afc0d | b12766399     | CU Boulder license expires: 8/31/2023 | FALSE           | e814a32e-02da-4773-8f3a-6629cdb7ecdf | Restrictions on Access note | 4                         |
