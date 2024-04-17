select * from output_facts where start_fact_id in
(select id from start_facts where start_id = 566091)
order by data_source_type, modification_type, interval_type;

select * from rating_facts where start_fact_id in
(select id from start_facts where start_id = 566091)
order by data_source_type, modification_type, interval_type;

select count(id), rating_type from rating_facts
group by rating_type;

