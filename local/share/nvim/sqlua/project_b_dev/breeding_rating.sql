select * from breeding_ratings
order by updated_at desc
limit 100;


select horses.name, breeding_ratings.* from breeding_ratings, horses
where year = 2025
and breeding_ratings.horse_id = horses.id
-- and horses.name = 'GALILEAN'
order by horses.name;

select distinct year from breeding_ratings;
select count(*) from breeding_ratings;

select * from breeding_ratings where year = 2020;

select * from breeding_ratings where debutable_id in 
(select id from horses where name = 'CARAVAGGIO');

select * from breeding_ratings where horse_id in 
(select id from horses where name = 'CARAVAGGIO')

select distinct year from breeding_ratings;


SELECT 'SELECT DISTINCT ' || quote_ident(column_name) || ' FROM ' || quote_ident(table_name) || ';' AS query
FROM information_schema.columns
WHERE table_name = 'breeding_ratings';

 -- SELECT DISTINCT horse_id FROM breeding_ratings;
 SELECT DISTINCT status FROM breeding_ratings order by status;
 SELECT DISTINCT fts_grade FROM breeding_ratings order by fts_grade;
 SELECT DISTINCT fts_bomb_squad FROM breeding_ratings order by fts_bomb_squad;
 SELECT DISTINCT fts_synthetic FROM breeding_ratings order by fts_synthetic;
 SELECT DISTINCT fts_turf FROM breeding_ratings order by fts_turf;
 SELECT DISTINCT class_index FROM breeding_ratingsg SELECT DISTINCT class_index_stakes FROM breeding_ratings;
 SELECT DISTINCT turf_grade FROM breeding_ratings;
 SELECT DISTINCT turf_off FROM breeding_ratings;
 SELECT DISTINCT turf_sprint FROM breeding_ratings;
 SELECT DISTINCT mdn_win_2yo_vs_mdn_win_all FROM breeding_ratings;
 SELECT DISTINCT mdn_2yo_conversion FROM breeding_ratings;
 SELECT DISTINCT year FROM breeding_ratings;
 SELECT DISTINCT off_trk FROM breeding_ratings;
 SELECT DISTINCT synthetic FROM breeding_ratings;
 SELECT DISTINCT stamina_index FROM breeding_ratings;
 SELECT DISTINCT stamina_longer FROM breeding_ratings;
 SELECT DISTINCT stamina_turf FROM breeding_ratings;
 SELECT DISTINCT crop_number FROM breeding_ratings;
 SELECT DISTINCT fts_won_debut FROM breeding_ratings;
 SELECT DISTINCT fts_off FROM breeding_ratings;
 SELECT DISTINCT stamina_asterisk FROM breeding_ratings;
 -- SELECT DISTINCT sire_name FROM breeding_ratings;
 -- SELECT DISTINCT dam_sire_name FROM breeding_ratings;

