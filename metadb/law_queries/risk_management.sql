-- This is the code Rebecca wrote for risk management for Law in 2024. --
-- Much of it suspiciously doesn't work. --
-- Rebecca wanted to keep a record of it, just in case it is useful later. --

-- Microform -> this works!
select count (item.id), loc.discovery_display_name 
from folio_inventory.item__t as item
join folio_inventory.holdings_record as holdz on item.holdings_record_id = holdz.id 
join folio_inventory.location__t as loc on holdz.effectivelocationid = loc.id 
join folio_inventory.holdings_record__t as hold1 on holdz.id = hold1.id
where loc.discovery_display_name like 'Law%' --and hold1.call_number like '%f'
group by loc.discovery_display_name 
;

-- so far this is total count for collection
select count (item.id), loc.discovery_display_name 
from folio_inventory.item__t as item
join folio_inventory.holdings_record as holdz on item.holdings_record_id = holdz.id 
join folio_inventory.location__t as loc on holdz.effectivelocationid = loc.id 
join folio_inventory.holdings_record__t as hold1 on holdz.id = hold1.id
where loc.discovery_display_name like 'Law%'
--	and item.hrid like 'li%'
group by loc.discovery_display_name 
;

--next find the total number of law items

select count(item.id)
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.permanentlocationid = loc.id
where loc.discovery_display_name like 'Law%'
;


--next find counts by material type NOT at PASCAL
--book count leader07 = a or m
select count(item.id), loc.discovery_display_name 
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.permanentlocationid = loc.id
join folio_source_record.marc__t as marc on holding.instanceid = marc.instance_id 
where loc.discovery_display_name like 'Law%'
  and marc.field = '000'
  and substring(marc."content",7,1) = 'm'
group by loc.discovery_display_name
;


--Microfiche 008/23 or 006/06 = b, microfilm = a
select count(item.id), loc.discovery_display_name 
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.permanentlocationid = loc.id
join folio_source_record.marc__t as marc on holding.instanceid = marc.instance_id 
where loc.discovery_display_name like 'Law%'
  and marc.field = '008'
  and substring(marc."content",23,1) = 'b'
group by loc.discovery_display_name 
;

-- Journals & Serials, Leader/07 = s, i, or b
select count(item.id), loc.discovery_display_name 
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.effectivelocationid = loc.id
join folio_source_record.marc__t as marc on holding.instanceid = marc.instance_id 
where loc.discovery_display_name like 'Law%'
  and marc.field = '000'
  and substring(marc."content",7,1) = 's'
group by loc.discovery_display_name 
;

--DVDs, Leader/07 or 006/00 = g
select count(item.id), loc.discovery_display_name 
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.permanentlocationid = loc.id
join folio_source_record.marc__t as marc on holding.instanceid = marc.instance_id 
where loc.discovery_display_name like 'Law%'
  and marc.field = '000'
  and substring(marc."content",7,1) = 'g'
group by loc.discovery_display_name 
;

--CD-ROM 090 or 050 field ends in lowercase "c"
select count(item.id), loc.discovery_display_name 
from folio_inventory.item as item
join folio_inventory.holdings_record as holding on item.holdingsrecordid = holding.id
join folio_inventory.location__t as loc on holding.permanentlocationid = loc.id
join folio_source_record.marc__t as marc on holding.instanceid = marc.instance_id 
where loc.discovery_display_name like 'Law%'
  and marc.field = '090'
  and marc."content" like '%c'
group by loc.discovery_display_name 
;
