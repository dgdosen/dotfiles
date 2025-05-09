select entities.id as entity_id, entities.name as entity_name, customers.id as customer_id, addresses.id as address_id,
contacts.id as contact_id, contacts.first_name, contacts.last_name, accounts.is_active,
 accounts.id as account_id  from
entities, customers, addresses, contacts, accounts
where entities.customer_id = customers.id
and addresses.entity_id = entities.id
and customers.account_id = accounts.id
and customers.primary_contact_id = contacts.id
and contacts.customer_id = customers.id
and accounts.description = 'Customer Account'
order by entities.id desc;

select * from contacts order by id desc;
select * from addresses order by id desc;
select * from customers order by id desc;
select * from financial_accounts;

-- entities
select * from entities order by id desc;
-- customers
select customers.id as customer_id, accounts.id as account_id,
accounts.name
from customers, accounts
where customers.account_id = accounts.id
order by customers.id desc;

-- accounts
select * from accounts
where description = 'Customer Account'
and is_active = true
order by id desc;


