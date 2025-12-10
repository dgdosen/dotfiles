select * from invoice_templates;

select invoice_templates.id, invoice_templates.customer_id, accounts.id, accounts.name
from invoice_templates, customers, accounts
where invoice_templates.customer_id  = customers.id
and customers.account_id = accounts.id


select
invoices.payment_applied,
invoices.id,
invoices.number,
invoices.customer_id,
invoices.debit_financial_account_id,
invoices.credit_financial_account_id,
invoices.updated_at,
accounts.name,
accounts.description
from invoices, customers, accounts
where invoices.customer_id = customers.id
and accounts.id = customers.account_id
order by invoices.number desc;
-- order by posting_transactions.updated_at desc;

select * from invoices,
