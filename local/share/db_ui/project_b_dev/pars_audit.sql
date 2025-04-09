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
order by track_code, date

SELECT DISTINCT1
  races.track_code,
  races.date,
  races.race_number
FROM
  races
JOIN
  egps_fractions ON races.id = egps_fractions.race_id
WHERE
  races.track_code IN ('SA', 'DMR', 'CD')
ORDER BY
  races.track_code,
  races.date
