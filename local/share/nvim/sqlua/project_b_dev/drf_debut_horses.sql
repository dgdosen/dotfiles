select * from drf_debut_horses
order by name
limit 100;

select
horse_matchings.id, primary_matchable_type, primary_matchable_id, alternate_matchable_type, alternate_matchable_id, match_type,
horses.name as h_name,
drf_debut_horses.name as drf_name
from horse_matchings
join horses on horses.id = horse_matchings.primary_matchable_id
join drf_debut_horses on drf_vipuebut_horses.id = horse_matchings.alternate_matchable_id
where horses.name = 'MACLEAN''S MUSIC'
and alternate_matchable_type = 'DrfDebutHorse'
order by horses.name
limit 100;

select
horse_matchings.id, primary_matchable_type, primary_matchable_id, alternate_matchable_type, alternate_matchable_id, match_type,
horses.name as h_name,
breeding_rating_horses.name as drf_name
from horse_matchings
join horses on horses.id = horse_matchings.primary_matchable_id
join breeding_rating_horses on breeding_rating_horses.id = horse_matchings.alternate_matchable_id
where horses.name = 'MACLEAN''S MUSIC'
and alternate_matchable_type = 'BreedingRatingHorse'
order by horses.name
limit 100;
