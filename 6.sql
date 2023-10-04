SELECT
  InvoiceDate,
  BillingAddress,
  BillingCity,
  Total
FROM
  Invoice
WHERE
  Total=1.98
ORDER BY
  InvoiceDate
