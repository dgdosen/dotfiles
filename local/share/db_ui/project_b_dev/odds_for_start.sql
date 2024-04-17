select * from odds_for_starts
where start_odds_code <> 'morning line'
order by id desc limit 24;

select count(id), start_odds_code from odds_for_starts group by start_odds_code order by start_odds_code;

select start_id, start_odds_code, odds from odds_for_starts where start_id = 483775 order by created_at;

select distinct odds from odds_1for_starts, order by odds;
