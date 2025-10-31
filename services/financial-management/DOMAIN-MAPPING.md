# Financial Management Service

**Consolidated Services:**
- service-billing-invoicing
- service-ap-automation

## Domain Structure

### Billing & Invoicing Domain (`billing/`)
- **Models**: Invoice, Bill, Payment, PaymentTerm, TaxRate, BillingAddress, CreditNote
- **Use Cases**: Invoice Generation, Payment Processing, Tax Calculation, Credit Management
- **Infrastructure**: InvoiceRepository, PaymentGateway, TaxService, CreditService

### Accounts Payable Automation Domain (`ap-automation/`)
- **Models**: PurchaseOrder, Vendor, APInvoice, Approval, PaymentSchedule, Expense
- **Use Cases**: AP Invoice Processing, Approval Workflows, Payment Automation, Expense Management
- **Infrastructure**: APRepository, ApprovalEngine, PaymentProcessor, ExpenseTracker

## Integration Points
- Vendor invoices from AP flow to general billing system
- Payment processing shared between domains
- Financial reporting aggregates data from both domains
- Common chart of accounts and GL integration
