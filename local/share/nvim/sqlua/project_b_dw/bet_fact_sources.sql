select races.race_number, horses.name, races.track_code, race_id, starts.id, program_number, post_position
from starts, races, horses
where race_id in (
  select id from races where date = ' 2019-04-20'
)
and races.id = starts.race_id
and starts.horse_id = horses.id
and program_number <> 'SCR'
and cast(program_number as int) != post_position
order by race_number, post_position;

select * from exotic_payoffs where race_id = 112280;



select distinct winning_numbers from exotic_payoffs order by winning_numbers ;

select * from races where id = 112280;

select id, win_payoff, place_payoff, show_payoff, official_finish_position from starts where race_id = 112280 and show_payoff > 0
order by official_finish_position;

select * from exotic_payoffs;

select distinct winning_numbers, wager_code, races.track_code from exotic_payoffs, races
where winning_numbers similar to '%[A-Z]%'
      and races.id = exotic_payoffs.race_id
      and races.track_code in ('SA', 'DMR', 'HOL', 'BHP')
order by track_code, wager_code, winning_numbers

select distinct winning_numbers, wager_code, races.track_code from exotic_payoffs, races
where winning_numbers similar to '%/%'
      and races.id = exotic_payoffs.race_id
      and races.track_code in ('SA', 'DMR', 'HOL', 'BHP')
order by track_code, wager_code, winning_numbers

select * from starts where race_id in (
  select id from races where date = '2019-05-05' and race_number = 1
) and horse_id in (
  select id from horses where name = 'MINOSO'
)
-- 454997

