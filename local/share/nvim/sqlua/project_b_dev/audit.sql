select * from audits 
order by updated_at desc
limit 10;

select * from race

select * from audits order by id desc limit 20;

delete from audits;
delete from audits where id = 2


-- import files
select * from import_files where file_date = '2013-03-24'

delete from import_files where file_date = '2013-03-24' and type_category_code like 'results_%';
delete from import_files where file_date = '2013-03-24' and type_category_code like 'import_cha%';


SELECT n.nspname AS enum_schema,
       t.typname AS enum_name,
       e.enumlabel AS enum_value
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
ORDER BY enum_schema, enum_name, e.enumsortorder;
