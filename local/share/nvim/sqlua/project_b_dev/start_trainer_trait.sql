select * from start_trainer_traits
order by created_at desc
limit 100;

select * from start_trainer_traits as stt
where stt.trainer_id in (
  select id from trainers where name = 'POWELL LEONARD'
)
order by start_id desc;


select stt.*, races.date, races.track_code, track_meets.year
from start_trainer_traits as stt, races, starts, track_meets
where races.id = starts.race_id
and races.track_meet_id = track_meets.id
and starts.id = stt.start_id
and stt.trainer_id in (
  select id from trainers where name = 'POWELL LEONARD'
)
and code = 'Dirt starts'
and starts.post_position <> 99
order by races.date desc;

-- view code?
SELECT
  track_meets.year AS calendar_year,
  starts.trainer_id,
  trainers.name AS trainer_name,
  start_trainer_traits.code AS trait_code,
  COUNT(DISTINCT starts.race_id) AS race_count,
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 1 THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 2 THEN 1 ELSE 0 END) AS places,
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 3 THEN 1 ELSE 0 END) AS shows
FROM
  starts
JOIN
  races ON starts.race_id = races.id
JOIN
  track_meets ON races.track_meet_id = track_meets.id
JOIN
  start_trainer_traits ON starts.id = start_trainer_traits.start_id
JOIN
  trainers ON starts.trainer_id = trainers.id
JOIN
  calls ON starts.id = calls.start_id
WHERE
  starts.post_position <> 99 -- Exclude rows with post_position = 99
  AND calls.call_code = 'finish_call' -- Only include relevant calls
AND trainers.id in (
  select id from trainers where name = 'POWELL LEONARD'
)
GROUP BY
  track_meets.year,
  starts.trainer_id,
  trainers.name,
  start_trainer_traits.code
ORDER BY
  track_meets.year,
  starts.trainer_id,
  start_trainer_traits.code;

-- NOTE: here's that trainer clause
  -- AND trainers.id in (
  --   select id from trainers where name = 'POWELL LEONARD'
  -- )

SELECT
  track_meets.year AS track_meet_year, -- Changed to track_meet_year
  starts.trainer_id,
  trainers.name AS trainer_name,
  start_trainer_traits.code AS trait_code,
  COUNT(DISTINCT races.id) AS race_count, -- Count each race only once per trainer
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 1 THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 2 THEN 1 ELSE 0 END) AS places,
  SUM(CASE WHEN calls.call_code = 'finish_call' AND calls.position = 3 THEN 1 ELSE 0 END) AS shows
FROM
  starts
JOIN
  races ON starts.race_id = races.id
JOIN
  track_meets ON races.track_meet_id = track_meets.id
JOIN
  start_trainer_traits ON starts.id = start_trainer_traits.start_id
JOIN
  trainers ON starts.trainer_id = trainers.id
JOIN
  calls ON starts.id = calls.start_id
WHERE
  starts.post_position <> 99 -- Exclude rows with post_position = 99
  AND calls.call_code = 'finish_call' -- Only include relevant calls
  AND trainers.id in (
    select id from trainers where name = 'O''NEILL DOUG'
  )
  AND races.date < '2025-01-23'
GROUP BY
  track_meets.year, -- Group by track_meet_year
  starts.trainer_id,
  trainers.name,
  start_trainer_traits.code
ORDER BY
  track_meets.year, -- Order by track_meet_year
  starts.trainer_id,
  start_trainer_traits.code;





SELECT *
FROM start_trainer_trait_analysis
limit 100;
WHERE trainer_id in (
  select id from trainers where name = 'O''NEILL DOUG'
);

SELECT starts.id AS start_id, races.date AS race_date
FROM starts
JOIN races ON starts.race_id = races.id
AND races.date < (
  SELECT races.date
  FROM races
  WHERE races.id = starts.race_id
)
limit 100;


SELECT *
FROM start_trainer_trait_analysis
WHERE
calendar_year <= EXTRACT(YEAR FROM DATE '2025-01-01')
  AND EXISTS (
    SELECT 1
    FROM races
    WHERE races.date < DATE '2025-01-01'
  )
ORDER BY trait_code, calendar_year;


select * from start_trainer_trait_analysis
WHERE trainer_id in (
  select id from trainers where name = 'O''NEILL DOUG'
)
AND trait_code = '46-90daysAway';


select * from start_trainer_overall_analysis
limit 50;
select * from start_trainer_trait_analysis
limit 50;

select starts.id, starts.race_id, races.date, races.race_number, trainers.id, trainers.name from races, starts, trainers, start_trainer_traits
where starts.trainer_id = trainers.id
and starts.race_id = races.id
and start_trainer_traits.start_id = starts.id
and trainers.name = 'O''NEILL DOUG'
and start_trainer_traits.code = '1st time lasix'
and date < '2025-01-23'
and date > '2024-12-25'
order by races.date desc, races.id desc limit 25;

select count(*) from start_trainer_traits;

select * from start_trainer_traits order by created_at desc limit 100;
select * from start_trainer_traits where start_id = 630476;
