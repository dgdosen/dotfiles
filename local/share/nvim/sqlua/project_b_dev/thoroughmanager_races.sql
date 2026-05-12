select * from twinspires_races;
select * from twinspires_starts;
select * from twinspires_jockey_stats_snapshots;

select * from thoroughmanager_races where track_code in ('SA', 'CD', 'DMR');

select * from thoroughmanager_races order by updated_at desc;

select * from thoroughmanager_starts where thoroughmanager_race_id in
(
  select id from thoroughmanager_races where track_code in ('SA', 'CD', 'DMR')
);

select count(id) from thoroughmanager_workouts;
