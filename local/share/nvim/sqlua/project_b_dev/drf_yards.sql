-- quarter horse racesj
select count(id), abs(pp3_distance), drf_distance from races where abs(pp3_distance) <> drf_distance
group by abs(pp3_distance), drf_distance;

order by abs(pp3_distance), track_code, date, race_number;

select distinct id, name from horses where id in
(
  select horse_id from starts where race_id in
  (
    (select id from races where abs(pp3_distance) = 1000 and drf_distance = 2200)
  )
);

select distinct h.id, h.name
from horses h
join starts s on h.id = s.horse_id
join races r on s.race_id = r.id
where abs(r.pp3_distance) = 1000
  and r.drf_distance = 2200;


select h.id, h.name, r_latest.date, r_latest.track_code
from horses h
-- lateral join gets latest qualifying race
join lateral (
  select r2.date, r2.track_code
  from starts s2
  join races r2 on r2.id = s2.race_id
  where s2.horse_id = h.id
    and r2.track_code in ('SA', 'CD', 'DMR')
  order by r2.date desc
  limit 1
) r_latest on true
-- only include horses who have a matching distance race
where exists (
  select 1
  from starts s_check
  join races r_check on r_check.id = s_check.race_id
  where s_check.horse_id = h.id
    and abs(r_check.pp3_distance) = 1000
    and r_check.drf_distance = 2200
)
order by r_latest.date, r_latest.track_code;

