select * from horses where name = 'GOOD MAGIC';

select distinct breed from horses;
select distinct pp2_sex from starts;
select distinct breed_category from horses;


select * from horses where name = 'WARD ''N JERRY';
select * from horses where name = 'C''MON JENNA';

select * from horses order by id desc limit 25;

select * from horses where name = 'TARIFF';
select * from horses where id = 54909;

-- find who's got a recent start for a given sire id
select races.track_code, races.date, races.race_number, starts.program_number, horses.name
from races, starts, horses
where starts.race_id = races.id
and starts.horse_id = horses.id
and starts.horse_id in (
  select id from horses where pp2_sire_id = 49500;
)
order by races.date desc;


select * from horses where name = 'OM';
select * from horses where pp2_sire_id = 49500;



select * from horses where name = 'UNUSUAL HEATWAVE';

select starts.id as start_id, races.id, races.date, races.race_number, starts.program_number, starts.pp2_program_number, starts.pp2_original_post_position
from races, starts where
races.id = starts.race_id
and starts.id in (
  select id from starts where horse_id in (
    select id from horses where name = 'DANCING RINCA'
  )
)
order by date desc;

select distinct date from races where track_code in ('SA', 'CD', 'DMR')
and date > '2022-12-31'
order by date;

select * from horses where id =     87484

-- ages
select count(id), year_of_birth from horses
where id in (
  select horse_id from starts where race_id in (
    select id from races where track_code = 'SA' and date > '2024-12-25'
  )
)
group by year_of_birth
order by year_of_birth desc;

select horse_id, starts.id, age, races.date, races.track_code, races.race_number from starts, races  where 
starts.race_id = races.id
and starts.race_id in (
  select id from races where track_code = 'SA' and date > '2024-12-25'
)
order by age desc;
