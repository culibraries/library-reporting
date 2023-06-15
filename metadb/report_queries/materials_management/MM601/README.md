# Materials Management: Norlin Trace Lost Search Report

## Purpose
This reports returns a list of titles in Norlin Library that have "Trace Lost" somewhere in the item notes field. 

## Parameters
The Item Note contains 'trace lost' in the item notes field and location is in Norlin Library.

This report can be filtered down further by Item Status and specific location name. 

## Sample Output
| item_id                              | instance_hrid | create_date | barcode       | status       | effective_location_name | temporary_location_name | permanent_location_name | effective_call_number | item_suppressed | material_type_name | title                  | author                                                  | copy_number | volume | enumeration           | note_type_name | note                                                                                     | loan_item_status | loan_due_date | loan_return_date | num_loans |
|--------------------------------------|---------------|-------------|---------------|--------------|-------------------------|-------------------------|-------------------------|-----------------------|-----------------|--------------------|------------------------|---------------------------------------------------------|-------------|--------|-----------------------|----------------|------------------------------------------------------------------------------------------|------------------|---------------|------------------|-----------|
| 25e69268-3cb6-5f95-9986-2a1e84c078f3 | b2134110      | 6/5/2023    | U183043318573 | Long missing | Art & Architecture      |                         |                         | F1219 .A7633          | FALSE           | journal            | ArqueologÃ­a mexicana. | Instituto Nacional de AntropologÃ­a e Historia (Mexico) | 1           |        | v.15-16 no.89-94 2008 | Note           | Changed from Trace 2 to Trace Lost   5/12/22 \| Trace Lost Final Search Ã¢Â€Â“ June 2022 |                  |               |                  | 0         |
| d7944395-8d28-5f20-a960-5bba673b723e | b1481042      | 6/5/2023    | U183002086222 | Long missing | Art & Architecture      |                         |                         | HT166 .N28            | FALSE           | book               | Proceedings.           | National Conference on Urban Design                     | 1           |        | 1st 1978              | Note           | Trace Lost Final Search - March 2022                                                     |                  |               |                  | 0         |
