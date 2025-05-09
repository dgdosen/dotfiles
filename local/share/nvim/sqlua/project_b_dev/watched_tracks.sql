select * from watched_tracks;
select * from tracks;


select tracks.*, watched_tracks.* from
tracks, watched_tracks
where tracks.id = watched_tracks.track_id
and watched_tracks.is_active = true;


