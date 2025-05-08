select tracks.*,  watched_tracks.is_active from tracks, watched_tracks
where tracks.id = watched_tracks.track_id
and tracks.track_code in ('SA', 'DMR',  'CD');

select * from watched_tracks;

select * from tracks where track_code = 'WO';

select * from tracks order by updated_at desc

select * from tracks where track_code = 'SA' order by updated_at desc

-- look up a track
select * from tracks where track_code = 'BAQ';

select * from locations;

delete from tracks where id = 481


