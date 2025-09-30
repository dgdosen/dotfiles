-- egps fractions for race
select egps_fractions.* from egps_fractions, races
where egps_fractions.race_id = races.id
and race_id in (
  select id from races where date = '2024-08-31' and race_number = 10 and track_code = 'DMR'
) order by interval_type;

select * from egps_fractions order by updated_at desc limit 100;

select distinct interval_type, count(id) from egps_fractions
group by interval_type;

select * from egps_fractions where interval_type = 'interval_start';

select * from gmax_fractions where interval_type = 'interval_start';

select distinct interval_type, count(id) from gmax_fractions
group by interval_type;


select * from egps_fractions where interval_type = 'interval_start'



