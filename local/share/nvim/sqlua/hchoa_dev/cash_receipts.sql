
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
limit 200;

-- update damico payment - with postitive customer balance
update postings set credit_amount = 1140 where id = 7896;
update postings set debit_amount  = 1140 where id = 7895;

select * from customers;
select * from accounts;

-- cash receipts and posting transactons and accounts?
select
-- invoices.payment_applied,
-- invoices.number,
customer_payments.amount,
customer_payments.id,
customer_payments.customer_id,
customer_payments.debit_financial_account_id,
customer_payments.credit_financial_account_id,
customer_payments.updated_at,
accounts.name,
accounts.description,
posting_transactions.id,
posting_transactions.posting_date,
postings.memo
from customer_payments, posting_transactions, postings, customers, accounts, customer_payment_items
where customer_payments.id = posting_transactions.transactionable_id
and posting_transactions.transactionable_type = 'CustomerPayment'
and posting_transactions.id = postings.posting_transaction_id
and customer_payment_items.customer_payment_id = customer_payments.id
and accounts.name = 'Tom Damico'
and customer_payments.customer_id = customers.id
and accounts.id = customers.account_id
order by posting_transactions.id desc;

-- detail behind a cashrecipt
select * from customer_payments, customer_payment_items
where customer_payments.id = customer_payment_items.customer_payment_id
and customer_payments.id in (1654, 1706, 1701, 1693, 1689, 1672, 1657, 1637, 1627, 1617, 1599, 1726, 1736)
-- and customer_payments.id in (1701)
order by invoice_id desc;

select * from customer_payments where id = 1706;
select * from customer_payments where id = 1701;

SELECT *
FROM customer_payments
LEFT OUTER JOIN customer_payment_items
  ON customer_payments.id = customer_payment_items.customer_payment_id
-- WHERE customer_payments.id IN (1654, 1706, 1701, 1693, 1689, 1672, 1657, 1637, 1627, 1617, 1599, 1726, 1736)
WHERE customer_payments.id IN (1701 )
ORDER BY customer_payment_items.invoice_id DESC;

select * from invoices where id in (1716, 1715);

select * from customer_payments where id = 1701;
select * from posting_transactions where transactionable_id = 1701 and transactionable_type = 'CustomerPayment';
select * from postings where posting_transaction_id = 3711;

update postings set credit_amount = 380, memo = 'Customer Payment - Reclassified to 2025-05-23' where id = 7896;
update postings set debit_amount = 380, memo = 'Customer Payment - Reclassified to 2025-05-23' where id = 7896;

select * from postings where posting_transaction_id = 1199;
