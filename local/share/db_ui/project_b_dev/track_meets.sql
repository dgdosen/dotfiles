select * from watched_tracks;
select * from tracks

select * from track_meets order by track_id, year desc, track_meet_type desc ;
select * from track_meets order by updated_at desc ;

select races.date, races.id, races.race_number from races, trakus_fractions where races.track_code = 'DMR' and races.id = trakus_fractions.race_id
order by date desc


