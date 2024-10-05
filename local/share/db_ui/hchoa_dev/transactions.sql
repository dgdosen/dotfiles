select e.id, e.name, e.customer_id, i.number, i.customer_id, a.id as account_id, a.name,
pt.posting_date, pt.transactionable_id, p.id as posting_id, pt.transactionable_type, pt.memo,
p.credit_amount, p.debit_amount
from posting_transactions as pt,
postings as p,
invoices as i,
accounts as a,
customers as c,
entities as e
where p.posting_transaction_id = pt.id
and pt.transactionable_id = i.id
and i.customer_id = c.id
and c.account_id = a.id
and e.customer_id = c.id
order by pt.id desc, p.id desc
limit 40;

select * from postings
order by id desc
limit 50;

select * from posting_transactions
order by id desc
limit 30;

select * from financial_accounts limit 100;

select * from entities
order by id desc
limit 10;

select * from invoices
order by id desc
limit 10;

select * from customer_payments
order by id desc
limit 10;

select * from contacts
order by id desc
limit 50;

select * from customers
order by id desc
limit 30;

select * from accounts
order by id desc
limit 10;

select * from accounts
where description = 'Customer Account'
and is_active = true
limit 100;

-- update the posting date of a cash reciept?
update posting_transactions set posting_date = '2024-09-24' where id = 3587
