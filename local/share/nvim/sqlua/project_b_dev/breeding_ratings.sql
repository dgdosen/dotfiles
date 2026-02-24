select * from breeding_ratings order by date(updated_at) desc limit 1000;

select distinct status from breeding_ratings order by status;

select * from breed

select * from breeding_ratings 
where horse_id = 24230
and year = 2025
order by date(updated_at) desc, date(created_at) ;

  SELECT
    horse_id,
    year,
    COUNT(id) AS rating_count
  FROM breeding_ratings
  GROUP BY horse_id, year
  HAVING COUNT(id) > 1
  ORDER BY rating_count DESC;

select * from breeding_rating_horses;

select * from  horses where name = 'ACCLAMATION';

select * from breeding_rating_horses order by name;


select count(*) from breeding_ratings;
select count(horse_id) from breeding_ratings;
select * from breeding_ratings where horse_id is null;

select * from breeding_ratings where horse_id in (
  select id from horses where name = 'ACCLAMATION'
);

select * from horses where name = 'SIR PERCY';


select * from horses where id = 36923;

select count(id), year from breeding_ratings
group by year;

select * from breeding_ratings where horse_id in
(select id from horses where name = 'UNUSUAL HEAT')

select distinct fts_grade from breeding_ratings;

select distinct fts_bomb_squad from breeding_ratings;
select count(fts_bomb_squad) from breeding_ratings where fts_bomb_squad = 'fts_$$$';

select distinct fts_off from breeding_ratings;


select distinct status, crop_number from breeding_ratings order by status;
select distinct fts_synthetic from breeding_ratings;
select distinct fts_off from breeding_ratings;
select distinct fts_turf from breeding_ratings;
select distinct turf_off from breeding_ratings;
select distinct turf_sprint from breeding_ratings;
select distinct off_trk from breeding_ratings;
select distinct synthetic from breeding_ratings order by synthetic;
select distinct stamina_index from breeding_ratings;
select distinct stamina_longer from breeding_ratings;
select distinct stamina_turf from breeding_ratings;
select distinct stamina_asterisk from breeding_ratings;


