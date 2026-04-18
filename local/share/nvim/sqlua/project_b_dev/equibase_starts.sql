select * from equibase_starts limit 10;

select * from equibase_starts where race_id = 249;

select * from equibase_calls limit 10;
select * from equibase_fractions limit 10;

select distinct distance, distance_furlongs from equibase_races
where distance_furlongs not > 0; 

select * from equibase_horses order by updated_at desc;


select * from equibase_tracks;
