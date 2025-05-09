-- gmax fractions for race
select gmax_fractions.* from gmax_fractions, races
where gmax_fractions.race_id = races.id
and race_id in (
  select id from races where date = '2024-08-31' and race_number = 10 and track_code = 'DMR'
) order by interval_type;


