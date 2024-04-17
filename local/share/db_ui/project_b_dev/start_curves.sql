s4elect * from race_curves
select * from start_curves 
where data_source_type = 'trakus'
limit 10;

select count(id), curve_version from start_curves
group by curve_version
select count(*) from interval_infos;

-- these enums are great

select * from start_curves where data_source_type = 'equibase' limit 10;
select * from start_curves where coverage_type = 'early' limit 10;
select * from start_curves where start_id = 558072;

select * from curve_coefficients limit 10;

select count (id) from start_curves;
select distinct coverage_type from race_curves;
select distinct derivative_type from race_curves;

select count(id), category_type from start_curves group by category_type;
select count(id), coverage_type from start_curves group by coverage_type;
select count(id), derivative_type from start_curves group by derivative_type;
select count(id), equation_type from start_curves group by equation_type;

select distinct coverage_type from start_curves;
select distinct derivative_type from start_curves;
select distinct equation_type from start_curves;
select distinct modification_type from start_curves;
select distinct coefficientable_type from curve_coefficients;
select distinct data_derivation_type from pars;

select distinct coefficientable_type from start_curves;

select * from start_curves where start_id = 558072

select * from curve_coefficients where coefficientable_id in (kkk
  select id from start_curves where start_id = 466825
)
  
select distinct equation_type from start_curves
