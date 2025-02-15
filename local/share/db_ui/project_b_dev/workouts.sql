select distinct distance  * 3;

select * from workouts where horse_id in (
  select id from horses where name = 'PARLAY BAY'
)
order by date desc;

