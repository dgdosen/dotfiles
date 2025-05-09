select * from start_interval_facts where created_at < '2024-10-13' order by created_at desc limit 100
select * from start_facts order by created_at desc limit 100
select * from output_facts order by created_at desc limit 100
select * from start_interval_facts order by created_at desc limit 100

select distinct display_interval_type from start_interval_facts;
select distinct (data_source_type, modification_type) from start_interval_facts;

select * from start_facts where start_id = 558072;
select * from start_facts where start_id = 565970;
select * from start_interval_facts where start_id = 565970;
select * from start_facts where start_id = 491330;
select * from start_facts where start_id = 478130;

-- start_interval_facts pars (for start) for start_id
select start_interval_facts.display_interval_type, split_par_rating,
par_rating, modification_type, data_source_type, adjusted_beyer_rating
from start_interval_facts, start_facts
where start_interval_facts.start_fact_id = start_facts.id
and start_facts.start_id = 558072
order by data_source_type, modification_type, common_feet;

select start_interval_facts.display_interval_type, split_par_rating,
par_rating, modification_type, data_source_type, adjusted_beyer_rating
from start_interval_facts, start_facts
where start_interval_facts.start_fact_id = start_facts.id
and start_facts.start_id = 565970
order by data_source_type, modification_type, common_feet;


select * from start_interval_facts, start_facts
where start_interval_facts.start_fact_id = start_facts.id
and start_facts.start_id = 558072
order by data_source_type, modification_type, common_feet;

select distinct position from start_interval_facts;

/* id, start_fact_id, seconds, split_seconds, common_feet, split_par_rating, par_rating, interval_type, */
select
  seconds, split_seconds, split_par_rating, par_rating, display_interval_type,
  data_source_type, modification_type, par_interval_type, par_split_seconds, position, lengths_behind, lengths_ahead
from start_interval_facts where start_fact_id in
  ( select id from start_facts where start_id = 490153 )
order by data_source_type, modification_type, display_interval_type;


select distinct time_source_enum from start_interval_facts;
select splits_info from start_interval_facts where splits_info is not null;

select * from start_interval_facts where start_fact_id = 176411;

select * from race_facts where race_id = 121901;
select * from race_facts where id = 90240;

select * from start_facts order by race_fact_id desc  limit 10;
select * from start_facts where race_fact_id = 90170;


SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'data_source_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'display_interval_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'par_interval_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'affinity_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'modification_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'adjustment_t'
);
