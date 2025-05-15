select count(*) from egps_fractions;
select count(*) from egps_calls where distance_feet < 0;
select count(*) from egps_calls;
select * from egps_calls order by id desc limit 10;

select * from egps_calls where start_id = 556399;

-- earliest and latest egps races:
-- latest -- today?
select races.id, races.date, races.track_code, races.race_number from races, egps_fractions
where egps_fractions.race_id = races.id
and races.track_code in ('SA', 'DMR', 'CD')
order by races.date desc
limit 10;

-- earliest -- 2022-07-22
select races.id, races.date, races.track_code, races.race_number from races, egps_fractions
where egps_fractions.race_id = races.id
and races.track_code in ('SA', 'DMR', 'CD')
order by races.date
limit 10;

-- earliest egps dates
select min(races.date), track_code from races, egps_fractions
where egps_fractions.race_id = races.id
and races.track_code in ('SA', 'DMR', 'CD')
group by track_code;

-- earliest gmax dates
select min(races.date), track_code from races, gmax_fractions
where gmax_fractions.race_id = races.id
and races.track_code in ('SA', 'DMR', 'CD')
group by track_code;

-- races where there are calls with a length < 0
select distinct races.id, races.date, races.track_code, races.race_number, races.pp3_distance
from races, starts, egps_calls
where races.id = starts.race_id
and starts.id = egps_calls.start_id
and starts.id in (
  select start_id from egps_calls where distance_feet < 0
)
order by races.date, races.track_code, races.race_number;

SELECT COUNT(DISTINCT races.id) AS race_count
FROM races
INNER JOIN egps_fractions ON races.id = egps_fractions.race_id
WHERE egps_fractions.race_id IS NOT NULL;

GROUP BY races.id
HAVING COUNT(fractions.id) > 0;

-- distinct call intervals
select count(id) as count_of, interval_type from egps_calls
group by interval_type
order by interval_type;

select * from egps_calls where seconds = 0;
select * from egps_calls where interval_type = 'interval_start';

select id, distance_feet, interval_type, seconds, average_speed  from egps_calls where start_id = 558073;

-- delete egps calls that have 0's for too many seconds
delete from egps_calls
where seconds is null;

-- select egps calls that have 0's for too many seconds
select races.id, start_id, count(start_id) as count_start_id
from egps_calls, starts, races
where egps_calls.start_id = starts.id
and starts.race_id = races.id
and seconds is null
group by races.id, start_id
order by races.id, start_id * from egps_calls where start_id = 543323;
select * from egps_calls where start_id = 566091;
select * from gmax_calls where start_id = 571743;

select * from egps_calls where start_id = 573043;
select * from egps_calls where start_id = 566075;

select * from egps_calls where start_id = 571743;
select * from egps_calls where start_id = 546015;

select distinct count(id), interval_type from gmax_calls
group by interval_type
order by interval_type;

select distinct count(id), interval_type from egps_calls
group by interval_type
order by interval_type;

select * from egps_calls where start_id = 552524;
select * from gmax_calls where start_id = 559436;
select * from trakus_calls limit 10;

546015-- 559436 |  139747 | 2023-10-29 | CD         |           3
   -- 553864 |  137939 | 2023-09-28 | CD         |           4
select * from gmax_calls where start_id in (559436, 553864)
order by start_id, distance_feet;

select * from start_curves where start_id = 558072
select * from start_curves where start_id = 565970;

select * from interval_trip_notes where start_id = 558072;
select * from interval_trip_notes where start_id = 565970;

select * from curve_polynomial_inputs where polynomialable_id in (
  select id from start_curves where start_id = 565970
)

--turn
select * from curve_coefficients where coefficientable_id in (
  -- select id from start_curves where start_id = 565970
  2721635
)
--pace
select * from curve_coefficients where coefficientable_id in (
  -- select id from start_curves where start_id = 565970
  2721634
)

select data_source_type as ds, modification_type as mod , coverage_type as cov,  coefficient, degree as deg
from start_curves, curve_coefficients
where start_curves.id = curve_coefficients.coefficientable_id
and start_curves.start_id = 558072

select * from curve_coefficients where coefficientable_id in (
  select id from start_curves where start_id = 558072
)

select * from interval_trip_notes limit 100;

select * from curve_coefficients limit 10;

select * from start_curves where data_source_type = 'egps'
select * from start_curves where data_source_type = 'trakus'
limit 30;
1
select * from curve_coefficients where coefficientable_id in
(
  select id from start_curves where start_id = 558072
)

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'data_source_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'coverage_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'derivative_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'equation_t'
);

SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'modification_t'
);


SELECT enumlabel
FROM pg_enum
WHERE enumtypid = (
    SELECT oid
    FROM pg_type
    WHERE typname = 'interval_split_t'
);

SELECT typname
FROM pg_type
WHERE typtype = 'e';


