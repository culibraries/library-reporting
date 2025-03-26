# Patron Services: Claimed Returned Report 

## Purpose
This report returns a list of all items marked 'Claimed returned' across all library locations and PASCAL offsite.
## Parameters
Searches Norlin, Gemmill, Business, Music, Earth Science & Maps, and PASCAL locations for items that are currently marked "Claimed returned." Provides the claimed date, item barcode, item location, call number, copy, volume, claimed returned note, loan ID, user name, user email, and user ID.
## Sample Output
All sample output data has been altered to protect patron privacy.
| claimed_date | barcode       | location                              | call_number           | cpy | vol        | claim_note                                                                                 | loan_id                              | user_name    | user_email                | user_id                              |
|--------------|---------------|---------------------------------------|-----------------------|-----|------------|--------------------------------------------------------------------------------------------|--------------------------------------|--------------|---------------------------|--------------------------------------|
| 1/17/2025    | U183028350534 | Business Library - Stacks             | HG4515.3 .T43 1999    | 1   |            | (date) claimed returned end of spring 2024 semester.                                       | 2p6rtt74-7641-7882-946f-990451f80541 | NOAH VEEP    | Noah.Veep@colorado.edu    | c89t4754-c466-4f63-accf-c488e8ca1e12 |
| 3/6/2025     | U183075496242 | Norlin Library - East Desk            | iClickers             | 136 | CU Clicker | (date) Returned 2/26 in the afternoon when   didn't work, exchanged for different clicker. | 22m584dd-25d5-4f37-a98c-1fb0824e74b7 | PILAR SILVER | Pilar.Silver@colorado.edu | 6e2t8bg3-24d6-43e2-bbe8-914846238e5c |
| 3/12/2025    | U183010832302 | Earth Sciences & Map Library - Stacks | QE350.22.N65 E98 1989 | 1   |            | (date) Patron returned book to inside dropbox.                                             | 3tr4j236-3799-44bc-a06b-324ebf2ea1a1 | KARL MIKKEL  | Karl.Mikkel@Colorado.EDU  | f6ty1542-50b7-51d3-bef7-b5e8e2c52ba4 |
| 3/12/2025    | U183080135916 | PASCAL Offsite                        | DS805 .Y6             | 1   | v.6        | (date) note                                                                                | 655711ed-668e-4c85-b5cf-2d0afc6e67fa | EMILIA SPEER | Emilia.Speer@Colorado.EDU | grg23395-259e-43f2-97cc-e97a56b03bfb |
