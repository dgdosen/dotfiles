select * from accounts;

select * from financial_accounts;

select
  accounts.id,
  accounts.name,
  accounts.description,
  financial_accounts.id
from financial_accounts
join accounts on accounts.id = financial_accounts.account_id
order by accounts.id;
