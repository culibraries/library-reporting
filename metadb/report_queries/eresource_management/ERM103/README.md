# eResource Management: Incorrect Text in URL Field 

## Purpose
These queries are used on an ongoing monthly basis to check for incorrect text in the URL/856 field. 
## Parameters
These queries check for "order," "restricted," "affiliated," "NCSU," and "ezproxy" in the field. This is text our links do not use and are for access for other insitutions. They are usually just imported with a record during the copy cataloging process. They should be deleted. 
## Sample Output
| srs_id                               | line | matched_id                           | instance_hrid | instance_id                          | field | ind1 | ind2 | ord | sf | content                                    |
|--------------------------------------|------|--------------------------------------|---------------|--------------------------------------|-------|------|------|-----|----|--------------------------------------------|
| 007b9e6a-5b8e-4d6d-812d-1b32c9ef61cd | 106  | 007b9e6a-5b8e-4d6d-812d-1b32c9ef61cd | in00000077151 | b5db2c2c-8b5b-4ab5-9388-35422a5d8b88 | 856   | 4    | 1    | 1   | z  | Available to Stanford-affiliated users at: |
