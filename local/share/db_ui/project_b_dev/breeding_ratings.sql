select * from breeding_ratings order by created_at desc limit 200;
select count(id), year from breeding_ratings
group by year;

select * from breeding_ratings where horse_id in 
(select id from horses where name = 'JAMES STREET')

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


