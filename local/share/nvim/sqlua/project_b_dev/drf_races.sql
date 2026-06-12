select * from drf_races
where track_code = 'SA'
order by date desc, updated_at desc
limit 200;

select * from drf_fractions
order by interval_type
limit 100;

select drf_fractions.*, drf_races.date
from drf_fractions, drf_races
where drf_fractions.drf_race_id = drf_races.id
and interval_type is not null
-- and drf_races.date > '2026-03-01'
order by updated_at desc
limit 100;

SELECT * FROM drf_fractions
WHERE interval_type IS NOT NULL
ORDER BY updated_at DESC LIMIT 10;


select * from drf_calls
order by updated_at desc
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
