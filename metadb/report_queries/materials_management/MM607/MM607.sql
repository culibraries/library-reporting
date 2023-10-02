--MM607: Norlin Missing Books MS2 Report
SELECT 
i.jsonb -> 'status' ->> 'name' AS item_status,
loc.name AS item_location,
i.jsonb ->> 'barcode' AS item_barcode,
i.jsonb -> 'effectiveCallNumberComponents' ->> 'callNumber' AS call_number,
i.jsonb ->> 'effectiveShelvingOrder' AS shelf_order,
inst.title AS title,
i.jsonb ->> 'enumeration' AS enumeration,
i.jsonb ->> 'copyNumber' AS volume,
i.jsonb ->> 'volume' AS copy_number
FROM folio_inventory.item i
LEFT JOIN folio_inventory.location__t AS loc ON loc.id = (i.jsonb ->> 'effectiveLocationId')::uuid
LEFT JOIN folio_inventory.holdings_record__t AS holdings ON holdings.id = i.holdingsrecordid
LEFT JOIN folio_inventory.instance__t AS inst ON inst.id = holdings.instance_id
WHERE jsonb_extract_path_text(i.jsonb, 'tags', 'tagList') LIKE '%ms2%'
AND loc.id IN 
(
'2ee5c3f7-4127-444f-af9e-c74c81c50553',
'c43f1a1d-e6af-4efc-b39a-940fda0af4bf',
'470f74b5-10df-4b07-b59e-d59077b948d1',
'fde130b8-6a5a-4ac4-b4a1-3022dbc9149e',
'a130533d-ec91-4c3f-833c-abe70f1c4877',
'ba761c7e-ef71-4392-808d-9b3ba914f4d7',
'c6327c84-0b8b-4a4f-b64e-5acecc31619b',
'c88925fa-af11-4cb4-9b69-e21aafe2ee7f',
'd649c6b1-01db-40df-ad29-65e1978e8c12',
'd85336a7-5195-46e5-b59e-e13b48fc1173',
'c868c028-44ff-47ea-9d51-fad291165228',
'760bc6b9-4e72-41f4-858d-e3e5f32fe52d',
'3bfe6a5b-88e9-46c8-b0a1-dbb7be99cd8b',
'b241764c-1466-4e1d-a028-1a3684a5da87',
'7e94f817-0c5e-45a6-88d4-6a500a9ded61',
'ccfe5f9c-021a-48cc-ad30-34841b3a03f8',
'490ae17a-b1ac-4b21-9512-020a29449dee',
'53cf956f-c1df-410b-8bea-27f712cca7c0',
'9e6087e3-92af-4f3f-880d-073fb460f800',
'd9db3d65-e954-4378-bffd-98d737d63921',
'e5901e19-1c95-455f-8cf0-91bd6c505d1b',
'1f9a228d-6509-4b7f-a916-360587e9201f',
'40bba58d-54c3-4ccf-801b-af8bcd4dd87d',
'c8aeae08-9b8f-4608-aa32-d4eccf75a606',
'842c360c-5bde-49ee-9f53-97b1403f4166',
'ea470113-5c5d-4bdf-bdea-469647886213',
'2515636c-4b84-4cf4-a68b-70b8acf65fc1')
;
