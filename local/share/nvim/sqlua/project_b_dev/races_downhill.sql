-- races with about_distance_code
select id, date, track_code, all_source_surface_code, distance, race_number, about_distance_code from races where distance = 1430
and track_code = 'SA' and all_source_surface_code = 'T'
order by date, race_number

