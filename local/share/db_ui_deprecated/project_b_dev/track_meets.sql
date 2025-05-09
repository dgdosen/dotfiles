select * from watched_tracks;
select * from tracks;

select * from track_meets order by track_id, year desc, track_meet_type desc ;
select * from track_meets where start_date > '2023-12-15' and start_date < '2025-01-01' order by start_date desc ;
select * from track_meets where year = 2024 order by start_date desc ;
select * from track_meets order by updated_at desc ;
select * from track_meets order by year desc;

select races.date, races.id, races.race_number from races, trakus_fractions where races.track_code = 'DMR' and races.id = trakus_fractions.race_id
order by start_date desc


