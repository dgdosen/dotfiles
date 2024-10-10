-- saved par queries - dealing with whether a par is reviewed or excluded...

-- what are we looking at
select * from pars limit 10;
select distinct data_source_type from pars;


select * from pars order by updated_at desc limit 10;
select * from par_intervals where par_id = 26992;


-- how much work has been done on pars
select count(id) as c, is_par_reviewed from pars where data_derivation_type = 1
group by is_par_reviewed

--- par data_derivation_types (soon to be data_soure_types)
select distinct count(id), data_source_type, interval_split_type from pars
group by data_source_type, interval_split_type;


select count(id) as c, is_par_excluded from pars where data_derivation_type = 1
group by is_par_excluded

select count(id) from pars;

select * from pars where id = 2255;

select * from par_intervals where par_id = 2255;
