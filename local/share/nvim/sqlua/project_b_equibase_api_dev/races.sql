select id, track_id, race_date, race_number, race_type  from equibase_races;
select distinct point from equibase_calls;

select count(*) from equibase_races;
select count(*) from equibase_starts;
select count(*) from equibase_fractions;
select count(*) from equibase_calls;
select * from equibase_tracks;

select distinct distance, distance_furlongs from equibase_races;
select distance, distance_furlongs from equibase_races where track_id = 5 limit 10;
select * from equibase_jockeys;
select * from equibase_jockeys;

select * from equibase_fractions where race_id = 10;
select * from equibase_calls where start_id = 67;

select * from equibase_fractions where race_id = 24;
select * from equibase_calls where start_id = 164;

select * from equibase_calls where start_id in (
  select id from equibase_starts where race_id = 10
)
order by start_id, sort_order;


select distinct margin from equibase_calls;

  SELECT
    r.id AS race_id,
    r.race_date,
    r.race_number,
    t.id AS track_id,
    t.code AS track_code,
    s.id AS start_id,
    s.finish_position,
    s.program_number,
    s.comments,
    s.footnotes,
    h.id AS horse_id,
    h.name AS horse_name
  FROM equibase_races r
  JOIN equibase_tracks t ON r.track_id = t.id
  JOIN equibase_starts s ON s.race_id = r.id
  JOIN equibase_horses h ON s.horse_id = h.id
  where t.code = 'LRC'
  and r.race_date = '2025-06-28'
  ORDER BY r.race_date, r.race_number, s.finish_position;

 4 select * from equibase_calls where start_id = 5369;

