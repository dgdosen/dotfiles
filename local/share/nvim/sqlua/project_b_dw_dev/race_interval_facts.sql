select * from race_interval_facts order by updated_at desc limit 20;

select * from race_interval_facts where split_seconds < 0

select * from race_interval_facts where split_seconds < 0
order by updated_at desc;



select * from race_interval_facts where race_fact_id = 101519;
select * from race_interval_facts where race_fact_id = 101210;

select count(*) from race_interval_facts;
select count(*) from race_interval_facts where par_interval_type is null;
select * from race_interval_facts where par_interval_type is not null limit 10;

-- specific race/race_fact_id
select * from race_facts where race_id = 149735;
select * from race_interval_facts where race_fact_id = 101522;
select * from race_interval_facts order by updated_at desc limit 11;

-- raceid 126704 (2022-01-02 R1 SA)
select * from race_facts where race_id = 126704;
select * from race_interval_facts where race_fact_id = 91766;

select distinct(par_interval_type) from race_interval_facts;
select distinct(interval_split_type) from race_interval_facts;


select * from race_interval_facts where interval_type = ''
delete from race_interval_facts where interval_type = ':w'

select count(id), display_interval_type from race_interval_facts group by display_interval_type;
select count(id), par_interval_type from race_interval_facts group by par_interval_type;
select count(id), interval_split_type from race_interval_facts group by interval_split_type;

update race_interval_facts
  set par_interval_type = 'interval_finish' where interval_type = 'interval_finish' and data_derivation_type = 1;
update race_interval_facts
  set par_interval_type = 'interval_turn' where interval_type = 'interval_3x' and data_derivation_type = 1;
update race_interval_facts
  set par_interval_type = 'interval_pace' where interval_type = 'interval_6x' and data_derivation_type = 1;

select count(id), interval_type, par_interval_type from race_interval_facts where data_derivation_type = 1 group by interval_type, par_interval_type;
select * from race_facts where id = 80084;

select * from start_interval_facts limit 100;

select * from surface_dimensions;

/* only migrate facts that aren't Turf (id 34) */
select distinct surface_dimension_id from race_facts;

select * from race_facts
where surface_dimension_id <> 34
and data_derivation_type = 1
limit 10;
