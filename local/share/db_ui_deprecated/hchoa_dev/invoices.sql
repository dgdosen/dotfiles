select * from invoice_templates;

select invoice_templates.id, invoice_templates.customer_id, accounts.id, accounts.name
from invoice_templates, customers, accounts
where invoice_templates.customer_id  = customers.id
and customers.account_id = accounts.id


