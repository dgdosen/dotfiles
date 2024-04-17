select * from par_intervals order by id desc limit 10;

select distinct interval_type from par_tranche_par_intervals;
select distinct par_interval_type from par_tranche_par_intervals;

select * from par_intervals where par_interval_type = 'time_1' limit 10;

select distinct count(id), par_interval_type, interval_type from par_intervals group by interval_type, par_interval_type;

select * from par_intervals limit 10;
select * from pars limit 10;

select * from par_intervals where par_id in (
  select id from pars where data_derivation_type = 1 and project_b_race_id in(
    select id from project_b_races where race_id in (
      select id from races where all_source_surface_code = 'D' and distance = 1760
    )
  )
) limit 1000;

select * from races limit 10;
select * from pars limit 10;
select * from project_b_races limit 10;
select * from par_intervals limit 10;

/* par starts for pars :*/
select races.id as race_id, races.date, races.race_number, starts.id as start_id, starts.program_number, horses.name,
pars.data_derivation_type, pars.id as par_id, par_intervals.par_interval_type
from races, project_b_races, pars, par_intervals, par_interval_starts, starts, horses
where races.id = project_b_races.race_id
and races.id = 124151
and project_b_races.id = pars.project_b_race_id
and pars.id = par_intervals.par_id
and par_intervals.id = par_interval_starts.par_interval_id
and starts.id = par_interval_starts.start_id
and horses.id = starts.horse_id

select * from par_intervals where par_id = 24900 order by common_feet;

select count(id) as c, is_par_reviewed from pars where data_derivation_type = 1
group by is_par_reviewed

-- NOTE: udpate? this isn't very well documented... but these will change as we
-- move dirt pace ratings to 7x
select * from pars limit 10;
select count(id), data_derivation_type, is_par_reviewed from pars group by data_derivation_type, is_par_reviewed
order by data_derivation_type;

select count(par_intervals.id) as c, par_interval_type, interval_type  from pars, par_intervals
where pars.id = par_intervals.par_id and pars.is_par_reviewed = true
group by par_interval_type, interval_type;
order by par_interval_type;

update par_intervals set par_interval_type = 'interval_turn' where par_interval_type = 'interval_3x'

