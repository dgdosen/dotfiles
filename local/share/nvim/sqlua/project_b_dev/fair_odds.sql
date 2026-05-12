select races.track_code, races.date, races.race_number, race_fair_odds.*, start_fair_odds.* from start_fair_odds, race_fair_odds, races
where start_fair_odds.race_fair_odds_id = race_fair_odds.id
and races.id = race_fair_odds.race_id
order by races.track_code, races.date desc, race_number;
