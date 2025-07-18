-- everything for a race?
select races.id as race_id, par_interval_starts.*, pars.interval_split_type from par_interval_starts, par_intervals, pars, project_b_races, races
where races.id = project_b_races.race_id
and project_b_races.race_id = races.id
and pars.project_b_race_id = project_b_races.id
and par_intervals.par_id = pars.id
and par_interval_starts.par_interval_id = par_intervals.id
and pars.interval_split_type = 'complete_interval'
and races.id in (
  select id from races where track_code = 'SA'
  and race_number = 4
  and date = '2025-01-17'
);

SELECT races.id AS race_id, par_interval_starts.*, pars.interval_split_type
FROM races
JOIN project_b_races ON project_b_races.race_id = races.id
JOIN pars ON pars.project_b_race_id = project_b_races.id
JOIN par_intervals ON par_intervals.par_id = pars.id
JOIN par_interval_starts ON par_interval_starts.par_interval_id = par_intervals.id
WHERE pars.interval_split_type = 'complete_interval'
AND races.id IN (
  SELECT id
  FROM races
  WHERE track_code = 'SA'
  AND race_number = 4
  AND date = '2025-01-17'
)

-- sql for auditing completeness of pars (and race fact) data

select distinct races.track_code, distinct races.date, distinct races.race_number
from races, egps_fractions where
races.id = egps_fractions.race_id
and races.track_code in ('SA', 'DMR', 'CD')
order by track_code, date

select distinct races.track_code, distinct races.date, distinct races.race_number
from races, egps_fractions where
races.id = egps_fractions.race_id
and races.track_code in ('SA', 'DMR', 'CD')
order by track_code, date;

-- par tranch of CD races:
select id, track_code, date, race_number, all_source_surface_code, distance
from races where track_code = 'CD'
and distance = 1760
and all_source_surface_code = 'T'
and date >= '2024-06-01'
and date <= '2024-06-30'
order by date, race_number;


-- egps eligible races
SELECT DISTINCT
  races.track_code,
  races.date,
  races.race_number,
  races.id
FROM
  races
JOIN
  egps_fractions ON races.id = egps_fractions.race_id
  -- gmax_fractions ON races.id = gmax_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD')
ORDER BY
  races.track_code,
  races.date

-- gmax races
SELECT
  count (distinct races.id)
FROM
  races
JOIN
  gmax_fractions ON races.id = gmax_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD')


-- egps races
SELECT
  count (distinct races.id), track_code
FROM
  races
JOIN
  -- egps_fractions ON races.id = egps_fractions.race_id
  gmax_fractions ON races.id = gmax_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD')
GROUP BY
  track_code

--
-- total race counts by source:
-- gmax: 5796
-- egps: 4569
--
-- egps races by track
-- SA: 2172
-- DMR: 1217
-- CD: 1180

-- earliest egps dates:
-- SA: 2022-10-15
-- DMR: 2022-07-22
-- CD: 2023-04-29
--
-- gmax races by track
-- SA: 2172
-- DMR: 2178
-- CD: 1367
-
-- earliest gmax dates:
-- SA: 2022-10-15
-- DMR: 2019-08-28
-- CD: 2023-04-29



-- egps pars
SELECT count (DISTINCT project_b_races.id)
FROM
  project_b_races
JOIN
  races on races.id = project_b_races.race_id
JOIN
  egps_fractions ON races.id = egps_fractions.race_id
  -- gmax_fractions ON races.id = gmax_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD');

-- project_b_races shorfall: 928!
-- pars can be no better...

-- (egps, gmax) par eligible races
SELECT DISTINCT
  races.id,
  races.track_code,
  races.date,
  races.race_number
FROM
  races
JOIN
  egps_fractions ON races.id = egps_fractions.race_id
JOIN
  gmax_fractions ON races.id = gmax_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD')
ORDER BY
  races.track_code,
  races.date
