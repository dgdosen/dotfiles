select * from audits limit 10;


-- import files
select * from import_files where file_date = '2013-03-24'

delete from import_files where file_date = '2013-03-24' and type_category_code like 'results_%';
delete from import_files where file_date = '2013-03-24' and type_category_code like 'import_cha%';
