-- ensuring date dimension is set
select * from date_dimensions order by date_id desc limit 60;
select * from date_dimensions order by updated_at desc limit 60;

select * from date_dimensions where year = 2023 order by date_id desc;

-- ensuring track_meet dates are set
select * from track_meet_date_dimensions order by date_id desc limit 5;
select * from track_meet_date_dimensions order by updated_at desc limit 5;

-- looking for updated dimensions
select * from distance_dimensions order by updated_at desc;
select * from max_claiming_price_dimensions order by updated_at desc;
select * from purse_dimensions order by updated_at desc;
select * from rail_distance_dimensions order by updated_at desc;
select * from surface_dimensions order by updated_at desc;
select * from surface_dimensions order by updated_at desc;
select * from trainer_dimensions order by updated_at desc;
select * from track_dimensions order by updated_at desc;
