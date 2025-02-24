select * from drf_debut_analyses where debutable_id = 15667
order by effective_date desc;

select * from drf_debut_races order by date desc;

select * from manual_drf_debut_analyses;
select * from trainers where id = 288;

select * from races where id in (
  select race_id from starts where trainer_id = 288
) order by date desc;

select * from drf_debut_analyses where debutable_id = 49500;

select * from drf_debut_analyses order by updated_at desc limit 100;
select * from drf_debut_analyses where drf_debutable_id is null;

select * from horses where name = 'OM';
select * from drf_debut_horses where name = 'OM';
select * from drf_debut_horses order by updated_at desc limit 10;

select count(id) from drf_debut_horses where created_at > '2025-01-01';
select * from drf_debut_horses where created_at > '2025-01-01'

select * from drf_debut_trainers where trainer_id is null;

select * from drf_debut_analyses order by updated_at desc limit 1000;
select * from drf_debut_analyses where debutable_id = 49500;
select * from drf_debut_horses order by updated_at desc;

select * from drf_debut_analyses where debutable_id in (
  select id from horses where name = 'NYQUIST'
)
order by effective_date desc;

select effective_date, debutable_role, count(id)
from drf_debut_analyses
group by debutable_role, effective_date
order by debutable_role, effective_date desc
