select * from drf_races 
where track_code = 'SA'
order by date desc, updated_at desc
limit 100;

update drf_races
set condition = ''
where track_code = 'SA'
and date = '2026-03-15';

select * from drf_calls limit 100;

select count(id), call_code from drf_calls
group by call_code;

select * from drf_races where track_code = limit 100;

select distinct track_code from drf_races
order by track_code;
