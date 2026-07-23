select * from vendors;

SELECT
  v.id                                   AS vendor_id,
  e.name                                 AS vendor_name,      -- display name (entity)
  a.name                                 AS ledger_account,   -- AP sub-ledger account
  exp.name                               AS default_expense_account,
  CONCAT(c.first_name, ' ', c.last_name) AS primary_contact,
  c.email,
  c.phone,
  addr.address_1, addr.city, addr.state, addr.zip
FROM vendors v
LEFT JOIN accounts           a    ON a.id   = v.account_id                    -- sub-ledger account
LEFT JOIN entities           e    ON e.vendor_id = v.id                       -- display name
LEFT JOIN financial_accounts fa   ON fa.id  = v.default_bill_debit_account_id -- default expense (GL)
LEFT JOIN accounts           exp  ON exp.id = fa.account_id                   --   → its name
LEFT JOIN contacts           c    ON c.id   = v.primary_contact_id            -- primary contact
LEFT JOIN addresses          addr ON addr.entity_id = e.id                    -- entity address
ORDER BY e.name


