
select * from customer_payments order by updated_at desc;
select * from posting_transactions order by updated_at desc limit 10;
select * from postings limit 10;

select
postings.id as posting_id,
posting_transactions.id as transaction_id,
posting_transactions.posting_date,
posting_transactions.transactionable_id,
posting_transactions.transactionable_type,
postings.financial_account_id,
postings.account_id,
postings.credit_amount,
postings.debit_amount
from posting_transactions, postings
where postings.posting_transaction_id = posting_transactions.id
order by posting_transactions.updated_at desc
limit 10;

-- update damico payment - with postitive customer balance
update postings set credit_amount = 1140 where id = 7896;
update postings set debit_amount  = 1140 where id = 7895;

select * from customers;
select * from accounts;

-- cash receipts and posting transactons and accounts?
select
customer_payments.amount,
customer_payments.id,
customer_payments.customer_id,
customer_payments.debit_financial_account_id,
customer_payments.credit_financial_account_id,
customer_payments.updated_at,
accounts.name,
accounts.description,
posting_transactions.id,
posting_transactions.posting_date
from customer_payments, posting_transactions, customers, accounts
where customer_payments.id = posting_transactions.transactionable_id
and posting_transactions.transactionable_type = 'CustomerPayment'
and customer_payments.customer_id = customers.id
and accounts.id = customers.account_id
order by posting_transactions.updated_at desc
