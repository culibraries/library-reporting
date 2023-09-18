# CM111: Gov Docs Call Number Report

## Purpose
List of call number fields in Instances located in Government Document locations.

## Parameters
Holdings location is LIKE '%Gov%' and a value exists in MARC Field 086$a and in i.item_level_call_number

## Sample Output
| item_hrid | holdings_hrid | instance_hrid | item_level_call_number | item_call_number_type | holdings_location          | holdings_call_number | holdings_call_number_type                  | field_086$a    | field_099$a | field_092$a | field_050$a | field_055$a |
|-----------|---------------|---------------|------------------------|-----------------------|----------------------------|----------------------|--------------------------------------------|----------------|-------------|-------------|-------------|-------------|
| i4801991  | c168297       | b2819971      | LAW1/200.1/            |                       | Gov Info Basement Colorado | LAW1/200.1/          | Other scheme                               | LAW4.1/year-yr | LAW1/200.1/ |             |             |             |
| i4835249  | c146321       | b2268995      | C 3.186:P-25/1014      |                       | Gov Info US                | C 3.186/7:           | Superintendent of Documents classification | C 3.186/7:     |             |             |             |             |
| i4951071  | c168297       | b2819971      | LAW1/200.1/            |                       | Gov Info Basement Colorado | LAW1/200.1/          | Other scheme                               | LAW4.1/year-yr | LAW1/200.1/ |             |             |             |
