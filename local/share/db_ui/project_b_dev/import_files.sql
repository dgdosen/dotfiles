-- recent history
select * from import_files
order by updated_at desc
limit 100;

--pp_file reprocssing?

-- pp related files
select * from import_files
where type_category_code like 'pp_%'
-- and file_date > '2025-03-01'
and file_date = '2025-03-22'
and file_name is not null
order by file_date, type_category_code;


--pp related files for data range to remove
delete from import_files
where type_category_code like 'pp_%'
-- and file_date > '2025-03-01'
and file_date = '2025-03-22'
and file_name is not null
order by file_date, type_category_code;

--pp_files for data range to update
select * from import_files
where type_category_code like 'pp_files'
-- and file_date > '2025-03-01'
and file_date = '2025-03-22'
order by file_date, type_category_code;

update import_files set import_state_code = 'downloaded'
where type_category_code = 'pp_files'
and file_date = '2025-03-22';

select * from import_files
where type_category_code = 'results_files'
and track_code = 'CD'
order by updated_at desc;

select * from import_files
where type_category_code = 'pp_files'
and file_date > '2024-05-22'
order by file_date desc;

select * from import_files
where import_state_code = 'reset'
order by updated_at desc
limit 500;

-- missing DMR?
select * from import_files
where file_date = '2023-05-19'


update import_files set track_id = 188 where id = 117377

update import_files set import_state_code = 'cd_problem'

-- missing results
where type_category_code = 'results_files'
order by file_date desc
limit 1000;

-- update import_files set import_state_code = 'cd_problem'
-- where type_category_code = 'results_files'
-- and track_code = 'CD'
-- and import_state_code = 'downloaded'

-- finding pp files for a date and track
select * from import_files
where file_date = '2023-11-12'
and type_category_code like 'pp_%'
and track_code = 'DMR'
order by type_category_code desc

delete from import_files where id = 110494
update import_files set import_state_code = 'downloaded' where id = 110514

delete from import_files
where file_date = '2023-11-12'
and type_category_code like 'pp_files_pp%'
and track_code = 'DMR'


select * from races where date = '2017-05-13' and track_code = 'CD' order by race_number

select * from watched_bris_file_types;

select distinct import_state_code from import_files;

select * from import_files
order by file_date desc , type_category_code
limit 100;

select * from import_files
where file_date = '2024-05-18'
order by id desc
limit 100;

delete from import_files where id > 102236;

delete from import_files where file_date in ('2022-01-23')
and type_category_code like 'pp_files%'


delete from import_files where file_date in ('2021-10-01', '2021-10-02', '2021-10-03')
and type_category_code =  'trakus_results'


select * from import_files
order by updated_at desc
limit 100;


delete from import_files where id = 96528;

select id, date, track_code, is_cancelled from races where date = '2021-01-31'

update import_files set import_state_code = 'downloaded' where id in (81112, 81113, 81117, 81118 )
update import_files set import_state_code = 'reset' where id in (81112, 81113, 81117, 81118 )
update import_files set import_state_code = 'downloaded' where id in (81117)

select * from import_files where import_state_code != 'processed' order by id desc;

select * from import_files
where file_date = '2021-03-05'
order by id desc;

update import_files set import_state_code = 'downloaded' where id = 96006

delete from import_files where id in (96014)

delete from import_files where file_date = '2020-01-20' and type_category_code like 'pp_files_pp%'
update import_files set import_state_code = 'downloaded' where file_date = '2020-01-20' and type_category_code = 'pp_files'

select * from import_files
where type_category_code = 'trakus_results'
order by file_date desc;

select * from import_files
where type_category_code = 'trackmaster_chart_files'
order by id desc;

select * from import_files
where file_date = '2019-12-01'
order by id desc;

select * from watched_bris_file_types;

select * from track_meets;

select * from import_files
where import_state_code = 'downloaded'
order by id desc;

select * from import_files
where import_state_code = 'reset'
order by id desc;

select * from import_files where import_state_code != 'processed'
order by id desc;

select * from import_files
where type_category_code = 'trackmaster_chart_files'
order by id desc

select start_id, interval_type, seconds, off_rail, lengths_ahead, lengths_behind, actual_feet from trakus_calls where start_id = 454357
order by distance;

select * from par_tranche_rce

select * from pars order by updated_at desc;

select * from import_files
where import_state_code = 'downloaded'

select * from import_files
where file_date = '2018-11-15'
order by updated_at desc;

select * from import_files where id = 54804;

select * from import_files
where type_category_code = 'trakus_results'
and track_code = 'SA' and file_date = '2019-09-28'
and file_name = 'SA_11'

select * from import_files
where type_category_code = 'trakus_results'
and import_state_code = 'processing'
order by file_date desc;
