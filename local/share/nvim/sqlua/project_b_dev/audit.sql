select * from audits order by updated_at desc
limit 10;

select * from audits where auditable_id = 171959;
select * from audit_reviews;

select * from audits where id = 64733;
select * from audit_source_rows where id = 66140;


select * from audit_reviews limit 100;

delete from audits;

-- known failure audit
select * from
select * from starts where id = 646716;

select count(*) from audits;

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


select id, track_id, track_code, date, race_number from races where id in (
  select race_id from starts where id in (
     SELECT
        a.auditable_id
    FROM audits a,
         jsonb_array_elements(a.status->'data_sources') ds
    WHERE (ds->>'locked')::boolean IS TRUE 
  )
)

  SELECT
    a.id                          AS audit_id,
    a.auditable_type,
    a.auditable_id,
    ds->>'data_source_type'       AS source,
    ds->>'data_category_type'     AS category,
    ds->>'status_type'            AS status_type,
    ds->>'comment'                AS comment,
    ds->>'expected_quantity'      AS expected,
    ds->>'actual_quantity'        AS actual,
    a.updated_at
  FROM audits a,
       jsonb_array_elements(a.status->'data_sources') ds
  WHERE (ds->>'locked')::boolean IS TRUE
  ORDER BY a.auditable_type, a.auditable_id;

