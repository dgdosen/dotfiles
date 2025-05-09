select * from trackmaster_races;

select distinct count(id), class_rating from tm_races;
select * from tm_races order by updated_at desc limit 40;

group by class_rating
order by class_rating;

