-- quick look
select * from start_facts order by updated_at desc limit 20;

-- start facts for start
select * from output_facts where start_fact_id in
(select id from start_facts where start_id = 584799)
order by data_source_type, modification_type, interval_type;

select * from start_facts where start_id = 584799;

-- ratings facts
select count(id), rating_type from rating_facts
group by rating_type;

select * from output_facts 
where data_source_type = 'egps'
limit 100;

select * from rating_facts 
where data_source_type = 'egps'
and modification_type = 'automatically_adjusted'
and rating_type = 'beyer_race'
limit 100;
