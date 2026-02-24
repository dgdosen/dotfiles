select * from race_facts order by updated_at desc limit 100;

select count(id), sex_restriction_dimension_id from race_facts
group by sex_restriction_dimension_id;

select count (id) from race_facts;
  SELECT
    COUNT(rf.id) AS race_count,
    tcd.id AS track_condition_dimension_id,
    tcd.code,
    tcd.name,
    tcd.description
  FROM race_facts rf
  FULL OUTER JOIN track_condition_dimensions tcd
    ON tcd.id = rf.track_condition_dimension_id
  GROUP BY tcd.id, tcd.code, tcd.name, tcd.description
  ORDER BY race_count DESC;

select * from sex_restriction_dimensions;


SELECT
  COUNT(rf.id) AS race_count,
  tcd.id AS track_condition_dimension_id,
  tcd.code,
  tcd.name,
  tcd.description
FROM race_facts rf
INNER JOIN track_condition_dimensions tcd
  ON tcd.id = rf.track_condition_dimension_id
GROUP BY tcd.id, tcd.code, tcd.name, tcd.description
ORDER BY race_count DESC;

select * from race_facts order by updated_at desc
limit 100;

select * from track_dimensions limit 10;

select * from race_facts where track_dimension_id = 25;


