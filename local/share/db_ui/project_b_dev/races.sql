-- about distance issues...
select is_about_distance, about_distance_code, pp1_distance, pp3_distance, count(id)
from races
where pp3_distance in (1430, -1430) and track_code = 'SA'
group by is_about_distance, about_distance_code, pp1_distance, pp3_distance
order by is_about_distance, about_distance_code, pp1_distance, pp3_distance;

select id, distance, is_about_distance, about_distance_code, pp1_distance, pp3_distance
from races
where id = 139044;

select *
from races
where id = 139044;

select date, track_code, race_number, all_source_surface_code, drf_surface from races where date = '2024-04-27' and track_code = 'SA';

select track_code, date, race_number from races where pp1_distance = '1430' and about_distance_code = 'A'

select id, track_code, date, race_number, updated_at from races where track_code in ('SA', 'CD') order by id desc limit 51;
select id, track_code, date, race_number, pp1_distance from races order by date desc limit 100;

delete from races where id > 125957

-- race history for a horse
select starts.id as start_id, races.id as race_id, races.track_code, races.date, races.race_number,
horses.id as horse_id, horses.name, starts.program_number
from races, starts, horses
where races.id = starts.race_id
and starts.horse_id = horses.id
and horses.name = 'CHASING LIBERTY'
order by date desc;

-- distinct pp1_distance (is this where about distance is hidden?)
select distinct pp1_distance from races order by pp1_distance;

-- races for date
select id, date, track_code, race_number, distance, all_source_surface_code, about_distance_code from races where date = '2025-03-22'
order by track_code, race_number;

-- races for two dates
select id, date, track_code, race_number, distance, all_source_surface_code, about_distance_code, pp1_distance, pp1_bris_code, pp1_age_restriction_code from races where date = '2025-03-07' or date = '2025-03-08'
order by track_code, race_number;

select id, date, track_code, race_number, distance, all_source_surface_code, about_distance_code, pp1_distance, pp1_bris_code, pp1_age_restriction_code from races where id in (157035,157058 )
order by track_code, race_number;

-- races on a date at track_code
select id, track_id, date, track_code, race_number, distance, all_source_surface_code, about_distance_code, pp1_distance from races
where date = '2025-01-24'
and track_code = 'SA'
order by track_code, race_number;

-- track geometry issues
select id, date, track_code, race_number, distance, all_source_surface_code, about_distance_code from races
where (date = '2021-10-15'
or date = '2021-10-16')
and distance = 1430
order by race_number;

-- cd import
select * from races where date = '2020-11-29' and track_code = 'CD' order by race_number

delete from races where date = '2020-11-29' and track_code = 'CD' and track_id is null

select * from races where track_code in ( 'SA')
and date < '2022-04-01'
order by date desc
limit 10

-- surface color
select distinct all_source_surface_code from races;

-- testing to see if data is up to date
select id, breed_code, date, track_code, race_number from races order by date desc, race_number desc limit 20;

/* races of a length: */
select date, track_code, race_number from races where distance = 1650 order by date desc limit 20;

/* most recent races at watched tracks */
select  date, track_code, race_number from races where track_code in ('SA', 'DMR')
order by date desc limit 10;

select distinct date from races where track_code = 'DMR' and date > '2019-08-25'
order by date;

/* races of a given length as dmr */
select id, date, track_code, race_number, all_source_surface_code from races where track_code = 'DMR' and
distance = 1760
order by date desc
limit 10;

-- trakus races at del mar
select distinct(date) from races where track_code = 'DMR' and id in (
  select race_id from trakus_fractions
) order by date;


select id, date, track_code, distance, race_number from races where date = '2019-11-24' and race_number = 1;

select id, date, track_code, distance, race_number from races where date = '2019-04-06' and race_number = 10;

select  from races where id in (
  select race_id from starts where id = 443950
  );


select * from races where id = 122025;
select * from starts where race_id = 122025;

select id, race_id, horse_id, created_at, updated_at from starts where jockey_id is null
and race_id in (select id from races where track_code in ('SA', 'DMR'))
order by created_at desc;

select * from races where id in (
  select race_id from starts where horse_id in (
    select id from horses where name = 'PROUD PEDRO'
  )
) order by date desc;

select * from trakus_calls where start_id = 443950;

select distinct interval_type from trakus_calls;

select * from project_b_races where race_id = 111175;
select * from project_b_races where race_id = 111428;

select * from starts where id in (select id from starts where race_id in (select id from races where date = '2019-04-07' and race_number = 1)
and horse_id in (select id from horses where name = 'THE STREET FIGHTER'))

select * from interval_trip_notes where start_id = 453954;

select distinct(winning_numbers) from exotic_payoffs
order by winning_numbers;


select * from odds_for_starts
  where start_odds_code = '19'
where date = '2019-04-27'

select * from odds_for_starts where start_id = 260789
order by id

select * from races where date = '2019-05-10' and race_number = 3
-- 112448
select * from starts where race_id in (
  select id from races where date = '2019-05-10' and race_number = 3
) and horse_id in (
  select id from horses where name = 'VEGAN'
)
--455092
select * from interval_trip_notes where start_id = 455092 order by id;

SELECT races.date, races.track_code, races.race_number, races.distance, races.is_cancelled, races.final_seconds
FROM races
WHERE races.date > '2013-12-25' and races.date < '2019-03-04' AND races.track_code='SA' AND races.is_cancelled=false
ORDER BY races.date DESC , races.is_cancelled DESC;

select count(*) from races
where track_code = 'SA'
and date >=  '2013-12-26'
and date <= '2019-03-03'
and is_cancelled != true
and distance > 0
and breed_code !='AR'

select * from horses where name = 'REDUCTA'


select * from races where id = 115621;
select * from starts where race_id = 115621 order by horse_id

-- program_number is null?
-- this is a good proxy for bad starts:
select races.id, races.is_cancelled, races.date, races.track_code, races.race_number, horses.id, horses.name,
  starts.id, starts.post_position, starts.program_number
from horses, starts, races
where starts.race_id = races.id
and starts.horse_id = horses.id
and starts.program_number is null
and races.date = '2019-12-29'
and races.track_code in ('DMR', 'SA')
and races.is_cancelled != true
order by races.date desc

select races.id, races.is_cancelled, races.date, races.track_code, races.race_number, horses.id, horses.name,
  starts.id, starts.post_position, starts.program_number, starts.created_at
from horses, starts, races
where starts.race_id = races.id
      and starts.horse_id = horses.id
      and races.id = 112716
order by races.date desc

select * from starts where id in (467818, 467440)

select * from horses where name = 'REDUCTA'

select * from races where id in (
  select race_id from starts where horse_id in (
    select id from horses where name = 'HARIBOUX'
  )
) order by date desc;

select * from odds_for_starts where start_id = 467076;
select * from trakus_calls where start_id = 467076;

select * from odds_for_starts where start_id = 465690;
select * from trakus_calls where start_id = 465690;

select * from trakus_fractions where race_id in (
  108091,
  104699,
  105143,
  106807,
  104758,
  104283,
  104801,
  109791,
  109764,
  108201,
  107373,
  109769,
  109789,
  109890,
  108010,
  98943,
  99017,
  100802,
  100821,
  90754,
  99019,
  99146,
  93376,
  92391,
  94140,
  97405,
  94233,
  93240,
  92166,
  91611,
  91467,
  93984,
  91237,
  94578,
  91844,
  91877,
  94575,
  97106,
  98115,
  98169,
  98691,
  91868,
  94369,
  91996,
  94139,
  98561,
  91384,
  91568,
  90942,
  91087,
  91800,
  91779,
  91490,
  91050,
  91327,
  91470,
  89824,
  85237,
  83418,
  84632,
  85727,
  86656,
  84313,
  89568,
  78009,
  83079,
  75029,
  75258,
  75682,
  75009,
  76101,
  75717,
  82198,
  82371,
  81488,
  78433,
  81247,
  82421,
  77356,
  78621,
  90592,
  89898,
  83879,
  87002,
  84978,
  85732,
  84587,
  87070,
  75568,
  75754,
  76242,
  76966,
  81200,
  81615,
  75688,
  75990,
  74873,
  78641,
  76967,
  74870,
  74912,
  105092
) order by race_id

select * from races
where id in (
  83079, 94233, 108201, 109769, 109789
)

select * from trakus_fractions where race_id in (
83079, 94233, 108201, 109769, 109789
)

-- find trakus races without race facts
select id
 from races
where date >= '2013-12-23'
and date <= '2019-03-03'
and track_code = 'SA'
and breed_code != 'AR'
and is_cancelled = false
and id not in (select distinct race_id from trakus_fractions)
order by id


and id not in (
  select race_id from starts where id in(
  select start_id from trakus_calls
  )
)


select * from races where is_cancelled = true
order by date desc;


select * from races where date = '2020-02-02'
and race_number = 1
and track_code = 'SA';

select starts.id, horses.name, drf_beyer from starts, horses
where race_id = 108124
and starts.horse_id = horses.id;

select * from races where id in (
  select race_id from starts where id = 459532
)

select * from horses where id in (
  select horse_id from starts where id = 459532
)

select * from starts where id = 459532

select * from races where date = '2019-03-29' and track_code = 'SA'

select * from races where id in (select race_id from starts where horse_id in (
  select id from horses where name = 'DONUT GIRL'
)) order by date desc;

select starts.id, * from races, starts
where
  starts.race_id = races.id
  and
  races.id in (select race_id from starts where horse_id in (
  select id from horses where name = 'CAMBIER PARC'
)) order by date desc;

select starts.id, * from races, starts
where
  starts.race_id = races.id
  and
  races.id in (select race_id from starts where horse_id in (
    select id from horses where name = 'OSCAR DOMINGUEZ'
  )) order by date desc;

select * from starts where race_id in (
  select id from races where date = '2019-06-23'
  and track_code = 'SA'
  and race_number = 8
)
and horse_id in (
  select id from horses where name = 'OSCAR DOMINGUEZ'
)

select * from starts where race_id = 112716

select * from races where date = '2019-05-31' and track_code = 'SA'

select id, date, race_number, texts from races where date > '2019-11-14'
order by id desc;


select * from races where date > '2019-11-14'
order by id desc;


select * from races where date = '2019-12-29' and race_number = 8
select * from starts where race_id = 116011 and horse_id in (
  select id from horses where name = 'MADAME BOURBON'
)

select distinct sex_restriction_code from races;
select distinct sex_restriction_code, drf_race_sex from races;

select * from races where track_code = 'SA' and distance = '1760' and date >= '2019-01-01' and date <= '2019-01-31'
and all_source_surface_code = 'T' and track_condition_code = 'GD'

select id, track_code, date, race_number, distance, temp_rail_distance from races where track_code = 'DMR' and distance = 1760
and temp_rail_distance = '24'
order by date desc;

select races.id, date, distance, track_code, race_number, distance, rail_distance from races, tm_races
where races.id = tm_races.race_id
and track_code = 'SA'
and all_source_surface_code = 'T'
order by date desc

select id, date, race_number, distance from races where track_code = 'SA' and distance in (3080, 2640)
order by date desc

-- tm races
select distinct track_code from races, tm_races where races.id = tm_races.race_id;
select * from tm_races order by id desc limit 10;

select count (*) from races;

select distinct date from races where track_code = 'DMR' and date > '2020-01-01' and date < '2020-12-31'
order by date

-- adding cd
select id, race_number, date, created_at from races where track_code = 'CD' order by created_at desc limit 750;

-- revisit rail_distance between tm and bris
select races.id, races.date, races.race_number, races.track_code, races.all_source_surface_code, races.run_up_distance, races.temp_rail_distance,
races.weather,
tm_races.run_up_distance as tm_run_up_distance, tm_races.rail_distance as tm_rail_distance, tm_races.weather
from races
join tm_races on races.id = tm_races.race_id
where races.track_code in ('SA', 'DMR')
and (cast(races.temp_rail_distance as integer) <> tm_races.rail_distance)
or (races.run_up_distance <> tm_races.run_up_distance)
/* order by cast(races.temp_rail_distance as integer) - tm_races.rail_distance */
order by date desc

select races.id, races.date, races.race_number, races.track_code, race.all_source_surface_code, races.run_up_distance, races.temp_rail_distance,
tm_races.run_up_distance as tm_run_up_distance, tm_races.rail_distance as tm_rail_distance
from races
join  tm_races on races.id = tm_races.race_id
where races.track_code in ('SA', 'DMR')
and races.run_up_distance <> tm_races.run_up_distance
order by races.run_up_distance - tm_races.run_up_distance
limit 100;

select races.date, races.race_number, races.track_code, races.run_up_distance, races.temp_rail_distance,
tm_races.run_up_distance as tm_run_up_distance, tm_races.rail_distance as tm_rail_distance
from races, tm_races
where races.id = tm_races.race_id
and races.track_code in ('SA', 'DMR')
and races.run_up_distance <> tm_races.run_up_distance
limit 100;

select races.date, races.race_number, races.track_code, footnotes.note, tm_races.footnotes
from races, tm_races, footnotes
where races.id = tm_races.race_id
and races.id = footnotes.race_id
and footnotes.note <> tm_races.footnotes
and races.track_code in ('SA', 'DMR')
limit 100;

select * from gmax_races
order by race_time desc
limit 100;

-- SA 7F Turf
select * from races
where track_code = 'SA'
and distance = 1650
order by date desc
limit 10;

-- races for LA PULCINELA

select * from races where track_code in ('SA', 'DMR') limit 10;
-- scope of data
select distinct alt_rail_distance, temp_rail_distance from races;

-- dirt vs synthetic at del mar
select date, race_number, new_surface_code, new_surface_category, all_source_surface_code from races
where track_code = 'DMR'
order by date desc
limit 1000;

-- missing track meet id
select id, is_cancelled, date, track_code, track_id, race_number, distance, track_meet_id from races where
track_code in ('SA', 'DMR', 'CD')
and track_meet_id is null
order by date desc;


select created_at, updated_at from races order by date desc limit 100;
select date, track_code, race_number, track_meet_id from races order by date desc limit 100;

SELECT track_meets.year, COUNT(*) AS race_count
FROM starts
JOIN races ON starts.race_id = races.id
JOIN track_meets ON races.track_meet_id = track_meets.id
WHERE track_meets.year BETWEEN 2020 AND 2024
GROUP BY track_meets.year
ORDER BY track_meets.year;


select * from gmax_races where race_id in (
138387, 146024
);

-- long race audit of egps
select * from races
where date = '2023-11-12'
and race_number = 5
and track_code = 'CD';

-- comparing gmax_race and race for rail_distance (and notes...)
select gmax_races.race_id,
races.date,
races.race_number,
races.track_code,
races.all_source_surface_code,
gmax_races.header_info,
gmax_races.detail_info,
gmax_races.rail_distance,
races.temp_rail_distance,
tm_races.
from gmax_races, races
where gmax_races.race_id = races.id
and (
  cast(races.temp_rail_distance as int) > 0
  or gmax_races.rail_distance > 0
)
order by track_code, date, race_number;

-- comparing gmax_race and race for rail_distance (and notes...)
select gmax_races.race_id,
races.date,
races.race_number,
races.track_code,
races.all_source_surface_code,
gmax_races.header_info,
gmax_races.detail_info,
gmax_races.rail_distance,
races.temp_rail_distance
from gmax_races, races
where gmax_races.race_id = races.id
order by track_code, date, race_number;

select * from gmax_races order by updated_at desc limit 20;
select * from egps_races;

select distinct (alt_rail_distance) from races;
select distinct (alt_rail_distance) from tm_races;

select * from races where cast(races.alt_rail_distance as int) > 0
order by date desc;

select race_id, rail_distance, alt_rail_distance from tm_races where alt_rail_distance > 0;

-- debugging missing first past start:
-- 2024-05-10 SA R3
-- ID 146972
select * from races
where date = '2024-05-10'
and race_number = 3
and track_code = 'SA';

--state bred code
select distinct drf_state_bred, statebred_code from races;

