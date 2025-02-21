SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public';

SELECT routine_name
FROM information_schema.routines
WHERE routine_type = 'FUNCTION'
AND specific_schema = 'public';

select
starts.id as start_id,
starts.win_payoff,
starts.place_payoff,
starts.show_payoff,
races.id as race_id,
races.date as race_date,
track_meets.year,
starts.trainer_id as start_trainer_id,
horses.pp2_sire_id as start_sire_id,
horses.pp2_dam_sire_id as start_dam_sire_id,
calls.position,
CASE WHEN calls.call_code = 'finish_call' AND calls.position = 1 THEN 1 ELSE 0 END::INTEGER AS wins,
CASE WHEN calls.call_code = 'finish_call' AND calls.position = 2 THEN 1 ELSE 0 END::INTEGER AS places,
CASE WHEN calls.call_code = 'finish_call' AND calls.position = 3 THEN 1 ELSE 0 END::INTEGER AS shows
from starts, races, track_meets, horses, calls
where starts.race_id = races.id
and races.track_meet_id = track_meets.id
and starts.horse_id = horses.id
and starts.id = calls.start_id
and calls.call_code = 'finish_call'
and races.date = '2025-02-21'
and races.race_number = 2
and races.track_code = 'SA'
order by wins desc, places desc, shows desc, position


select
starts.id as start_id,
races.id as race_id,
races.date as race_date,
track_meets.year,
starts.trainer_id as start_trainer_id,
horses.pp2_sire_id as start_sire_id,
horses.pp2_dam_sire_id as start_dam_sire_id
from starts, races, track_meets, horses
where starts.race_id = races.id
and races.track_meet_id = track_meets.id
and starts.horse_id = horses.id
and races.date = '2025-02-21'
and races.race_number = 2
and races.track_code = 'SA';


select * from start_finishers_view where trainer_id = 
(select id from trainers where name = 'HARRIS ANDREW')
order by race_date desc
limit 100;
