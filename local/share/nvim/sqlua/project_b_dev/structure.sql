ALTER TYPE data_category_t ADD VALUE 'trip_notes';

SELECT n.nspname AS enum_schema,
       t.typname AS enum_name,
       e.enumlabel AS enum_value
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
ORDER BY t.typname, e.enumsortorder;

SELECT schemaname, tablename FROM pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';

Select count(id), data_source_type from audits
group by data_source_type
order by data_source_type;

SELECT
    a.attname AS column_name,
    pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type,
    a.attnotnull AS not_null,
    pg_catalog.pg_get_expr(ad.adbin, ad.adrelid) AS default_value
FROM
    pg_catalog.pg_attribute a
LEFT JOIN
    pg_catalog.pg_attrdef ad ON a.attrelid = ad.adrelid AND a.attnum = ad.adnum
WHERE
    a.attrelid = 'races'::regclass  -- Replace with your actual table name
    AND a.attnum > 0
    AND NOT a.attisdropped
ORDER BY
    a.attnum;


SELECT conname, contype, conrelid::regclass AS table_name FROM pg_constraint;

SELECT objid::regclass, refobjid::regclass, deptype FROM pg_depend WHERE deptype = 'n';

SELECT schemaname, viewname, viewowner, definition
FROM pg_views
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, viewname;
2
