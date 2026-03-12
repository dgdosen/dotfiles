select * from drf_races limit 100;

select * from drf_calls limit 100;

select count(id), call_code from drf_calls
group by call_code;

select * from drf_races where track_code = limit 100;

select distinct track_code from drf_races
order by track_code;
