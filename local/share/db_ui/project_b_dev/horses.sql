select * from horses where name = 'NOTRE DAME';
select * from horses where name = 'WARD ''N JERRY';
select * from horses where name = 'C''MON JENNA';

select * from horses order by id desc limit 25;

select * from horses where name = 'SUMTER';

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
