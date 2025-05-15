select * from trackmaster_races;
select * from trackmaster_fractions order by id;
select * from trackmaster_starts;
select * from trackmaster_jockeys;
select * from trackmaster_horses;
select * from trackmaster_trainers;
select * from trackmaster_calls order by id;

-- tm_races versus trackmaster races
select count(*) from tm_races;
select count(*) from trackmaster_races;


-- tm_races
select * from tm_races order by updated_at desc
limit 40;

select distinct fraction_code from fractions;

select * from trakus_fractions limit 20;
select distinct fraction_code from drf_fractions;

select * from calls limit 5;
select distinct call_code from calls;

select * from races where track_code = 'CD' and date = '2021-05-01' order by race_number;
select * from races where track_code = 'SA' and date = '2021-03-21' order by race_number;

select starts.id, starts.race_id, starts.official_finish_position, calls.position from starts, calls
where calls.start_id = starts.id
and calls.call_code = 'finish_call'
and official_finish_position > 0
and calls.position <> official_finish_position
order by start_id desc
limit 20;

