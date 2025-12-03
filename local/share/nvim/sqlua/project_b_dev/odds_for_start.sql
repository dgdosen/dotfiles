select * from odds_for_starts
-- where start_odds_code <> 'morning line'
order by updated_at desc limit 500;


-- horses and odds for a race
select races.date, races.track_code, races.race_number, horses.name, odds_for_starts.* from horses, races, starts, odds_for_starts
where races.track_code = 'SA'
and races.date = '2025-10-19'
and races.race_number = 9
and races.id = starts.race_id
and horses.id = starts.horse_id
and odds_for_starts.start_id = starts.id
order by start_id, start_odds_code desc limit 500;


  -- horses and odds for a race
  SELECT
    races.date,
    races.track_code,
    races.race_number,
    horses.name,
    odds_for_starts.start_odds_code,
    odds_for_starts.odds,
    odds_for_starts.win_wager
  FROM horses, races, starts, odds_for_starts
  WHERE races.track_code = 'SA'
    AND races.date = '2025-10-19'
    AND races.race_number = 9
    AND races.id = starts.race_id
    AND horses.id = starts.horse_id
    AND odds_for_starts.start_id = starts.id
  ORDER BY
    start_id,
    CASE
      WHEN odds_for_starts.start_odds_code ~ '^[0-9]+\.?[0-9]*$'
        THEN odds_for_starts.start_odds_code::numeric
      ELSE 99
    END DESC
  LIMIT 500;



select count(id), start_odds_code from odds_for_starts group by start_odds_code order by start_odds_code;

select start_id, start_odds_code, odds from odds_for_starts where start_id = 631202 order by created_at;

select distinct odds from odds_for_starts order by odds;

select * from odds_for_starts order by created_at desc limit 100;


-- odds audit
select odds_for_starts.id, start_id, start_odds_code, odds_for_starts.odds, odds_for_starts.updated_at, horses.name from odds_for_starts, starts, horses
where odds_for_starts.start_id = starts.id
and horses.id = starts.horse_id
and start_id in (select id from starts where race_id in (
    select id from races where date = '2025-03-02' and race_number = 11 and track_code = 'SA'
  )
)
order by horses.name, odds_for_starts.id

select id, updated_at from starts where race_id in (
  select id from races where date = '2025-03-02' and race_number = 11 and track_code = 'SA'
)

-- cleaned latest odds
WITH cleaned_odds AS (
  SELECT
    ofs.id,
    ofs.start_id,
    ofs.start_odds_code,
    CASE
      WHEN ofs.start_odds_code ~ '^\d+$' THEN CAST(ofs.start_odds_code AS INTEGER)
      ELSE NULL
    END AS start_odds_code_int,
    ofs.odds,
    ofs.updated_at,
    h.name,
    ROW_NUMBER() OVER (
      PARTITION BY ofs.start_id
      ORDER BY
        CASE
          WHEN ofs.start_odds_code ~ '^\d+$' THEN CAST(ofs.start_odds_code AS INTEGER)
          ELSE NULL
        END ASC NULLS LAST
    ) AS rn
  FROM odds_for_starts ofs
  JOIN starts s ON ofs.start_id = s.id
  JOIN horses h ON h.id = s.horse_id
  WHERE ofs.start_id IN (
    SELECT id FROM starts WHERE race_id IN (
      SELECT id FROM races
      WHERE date = '2025-04-06' AND race_number = 7 AND track_code = 'SA'
    )
  )
)
SELECT *
FROM cleaned_odds
WHERE rn = 1
ORDER BY name, id;


