-- revenue

  SELECT
    pt.posting_date   AS date,
    e.name            AS customer,
    cp.amount         AS amount
  FROM customer_payments cp
  JOIN posting_transactions pt
         ON pt.transactionable_type = 'CustomerPayment'
        AND pt.transactionable_id   = cp.id      -- the receipt's date lives on its posting
  JOIN customers c   ON c.id = cp.customer_id
  LEFT JOIN entities e ON e.customer_id = c.id   -- customer display name
  WHERE pt.posting_date BETWEEN '2014-10-01' AND '2026-06-30'
    AND (pt.voided IS DISTINCT FROM TRUE)
  ORDER BY pt.posting_date;

SELECT
  ipt.posting_date  AS invoice_date,     -- the ORIGINAL invoice date
  rpt.posting_date  AS receipt_date,
  e.name            AS customer,
  cpi.amount        AS amount
FROM customer_payment_items cpi
JOIN customer_payments cp   ON cp.id = cpi.customer_payment_id
JOIN posting_transactions rpt
       ON rpt.transactionable_type = 'CustomerPayment' AND rpt.transactionable_id = cp.id
JOIN invoices inv           ON inv.id = cpi.invoice_id
JOIN posting_transactions ipt
       ON ipt.transactionable_type = 'Invoice' AND ipt.transactionable_id = inv.id
JOIN customers c            ON c.id = cp.customer_id
LEFT JOIN entities e        ON e.customer_id = c.id
WHERE rpt.posting_date BETWEEN '2014-10-01' AND '2026-06-30'
  AND (rpt.voided IS DISTINCT FROM TRUE)
ORDER BY rpt.posting_date;


select
  invoices.payment_applied,
  invoices.id,
  invoices.number,
  invoices.customer_id,
  invoices.debit_financial_account_id,
  invoices.credit_financial_account_id,
  invoices.updated_at,
  pt.posting_date,              -- date the invoice was posted
  accounts.name,
  accounts.description
from invoices, customers, accounts
left join posting_transactions pt
  on pt.transactionable_id = invoices.id
  and pt.transactionable_type = 'Invoice'
where invoices.customer_id = customers.id
  and accounts.id = customers.account_id
order by invoices.number desc;





select
  invoices.payment_applied,
  invoices.id,
  invoices.number,
  invoices.customer_id,
  invoices.debit_financial_account_id,
  invoices.credit_financial_account_id,
  invoices.updated_at,
  pt.posting_date,              -- date the invoice was posted
  accounts.name,
  accounts.description
from invoices
join customers on invoices.customer_id = customers.id
join accounts  on accounts.id = customers.account_id
left join posting_transactions pt
  on pt.transactionable_id = invoices.id
  and pt.transactionable_type = 'Invoice'
