--metadb:function MARC600Field_SubfieldQ_after_SubfieldD

drop function if exists MARC600Field_SubfieldQ_after_SubfieldD;

create function MARC600Field_SubfieldQ_after_SubfieldD()
returns table(
instance_hrid text  
)  
as $$
SELECT instance_hrid
   FROM folio_source_record.marc__t                                                                                                   
   GROUP BY instance_hrid, field, ord                                                                                                        
   HAVING field = '600' AND string_agg(sf, '' ORDER BY line) ~ '^[^q]*d.*q';
$$
language sql 
stable 
parallel safe;
