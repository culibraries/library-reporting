--metadb:function MARC111Field_SubfieldD_after_SubfieldC

drop function if exists MARC111Field_SubfieldD_after_SubfieldC;

create function MARC111Field_SubfieldD_after_SubfieldC()
returns table(
instance_hrid text  
)  
as $$
SELECT instance_hrid
   FROM folio_source_record.marc__t                                                                                                   
   GROUP BY instance_hrid, field, ord                                                                                                        
   HAVING field = '111' AND string_agg(sf, '' ORDER BY line) ~ '^[^d]*c.*d';
$$
language sql 
stable 
parallel safe;
