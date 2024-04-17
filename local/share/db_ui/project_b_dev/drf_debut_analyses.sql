select * from drf_debut_analyses where debutable_id = 15667
order by effective_date desc;

select * from drf_debut_races order by date desc;

select * from manual_drf_debut_analyses;
select * from trainers where id = 288;

select * from races where id in (
  select race_id from starts where trainer_id = 288
) order by date desc;