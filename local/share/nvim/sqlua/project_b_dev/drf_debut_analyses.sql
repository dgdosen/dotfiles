select * from drf_debut_analyses 
where debutable_id = 15667
and debutable_role = 'DamSire'
order by effective_date desc;

select distinct debutable_type, debutable_role from drf_debut_analyses;
select distinct drf_debutable_type, drf_debutable_role from drf_debut_analyses;

select * from drf_debut_analyses order by created_at desc limit 500;

select * from manual_drf_debut_analyses;
select * from trainers where id = 288;

select * from races where id in (
  select race_id from starts where trainer_id = 288
) order by date desc;

select * from drf_debut_analyses where debutable_id = 49500;

select * from drf_debut_analyses order by updated_at desc limit 100;
select * from drf_debut_analyses where drf_debutable_id is null;

select * from horses where name = 'I''LL HAVE ANOTHER';
select * from horses where name = 'OM';

select * from drf_debut_horses where name = 'OM';
select * from drf_debut_horses limit 10;

select * from drf_debut_analyses order by updated_at desc limit 100;
select * from drf_debut_analyses where drf_debutable_id = 38028;
select * from drf_debut_horses where id = 38028;

select * from horses where name = 'GOOD MAGIC';
select * from drf_debut_horses where name = 'GOOD MAGIC';
select * from drf_debut_horses order by updated_at desc limit 10;

select count(id) from drf_debut_horses where created_at > '2025-01-01';
select * from drf_debut_horses where created_at > '2025-01-01'

select * from drf_debut_trainers where trainer_id is null;

select * from drf_debut_analyses order by updated_at desc limit 1000;
select * from drf_debut_analyses where debutable_id = 49500;
select * from drf_debut_horses order by updated_at desc;
select * from drf_debut_starts limit 10;

select * from drf_debut_analyses where debutable_id in (
  select id from horses where name = 'GOOD MAGIC'
)
order by effective_date desc;

select * from horses where id = 61488;
select * from horses where id = 38000;
select * from horses where id > 37950 and id < 38100;


select * from drf_debut_analyses where debutable_id in (
  select id from horses where name = 'GONE ASTRAY'
)
select effective_date, debutable_role, count(id)
from drf_debut_analyses
where debutable_role = 'Sire'
order by effective_date desc;

group by debutable_role, effective_date
order by debutable_role, effective_date desc;

SELECT
  effective_date,
  DATE(updated_at) AS updated_date,
  COUNT(id) AS count
FROM drf_debut_analyses
WHERE debutable_role = 'Sire'
GROUP BY effective_date, updated_date
ORDER BY effective_date DESC, updated_date DESC;

SELECT
  effective_date,
  DATE(created_at) AS created_date,
  COUNT(id) AS count
FROM drf_debut_analyses
WHERE
  debutable_role = 'Sire'
  AND EXTRACT(MONTH FROM effective_date) = 12
  AND EXTRACT(DAY FROM effective_date) = 31
GROUP BY effective_date, created_date
ORDER BY effective_date DESC, created_date DESC;

SELECT
  horses.name,
  horses.created_at
  from horses, drf_debut_analyses
  where horses.id = drf_debut_analyses.debutable_id
  and drf_debut_analyses.debutable_role = 'Sire'
  and effective_date = '2024-12-31'
  and DATE(drf_debut_analyses.created_at) = '2025-02-24'
  and drf_debut_analyses.summary_type = 1
order by horses.name
