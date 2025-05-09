select races.date, races.track_code from races, trakus_fractions where 
races.id = trakus_fractions.race_id
and races.track_code = 'DMR'
order by races.date desc
limit 10;

select * from trakus_fractions order by id desc limit 10;
