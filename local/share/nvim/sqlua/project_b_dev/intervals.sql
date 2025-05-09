select * from calls limit 10;
select * from trakus_calls limit 10;
select * from par_intervals limit 10;
select * from fractions order by id desc limit 10;
select * from par_interval_starts limit 10;
select * from intervals order by created_at desc limit 10;
select * from interval_trip_notes where start_id = 480777;
select count(*) from interval_trip_notes where distance is null;
select count(*) from interval_trip_notes;

select * from trakus_calls where start_id = 480777 order by distance;

select distinct call_code from calls;
select distinct interval_type, distance from trakus_calls order by distance;
select distinct par_interval_type from par_intervals;
select distinct fraction_code from fractions;
