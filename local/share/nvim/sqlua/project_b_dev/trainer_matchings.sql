
select
trainer_matchings.*,
trainers.name,
drf_debut_trainers.name
from trainer_matchings
join trainers on trainers.id = trainer_matchings.primary_matchable_id
join drf_debut_trainers on drf_debut_trainers.id = trainer_matchings.alternate_matchable_id
where trainers.name like '%AMATO%'
order by trainers.name
limit 100;
