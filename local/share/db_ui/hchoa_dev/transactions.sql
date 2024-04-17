select pt.posting_date, pt.transactionable_id, pt.transactionable_type, pt.memo,
p.credit_amount, p.debit_amount
from posting_transactions as pt, postings as p
where p.posting_transaction_id = pt.id
order by pt.created_at desc
limit 10;

select * from postings limit 10;
select * from posting_transactions limit 10;

select * from financial_accounts limit 100;

select * from accounts
where description = 'Customer Account'
and is_active = true
limit 100;
