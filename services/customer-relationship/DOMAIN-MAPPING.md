# Customer Relationship Management Service

**Consolidated Services:**
- service-crm
- service-client-management
- service-provider-management
- service-subscriptions
- service-retail-promotions

## Domain Structure

### CRM Domain (`crm/`)
- **Models**: Lead, Opportunity, Account, Contact, SalesStage, Pipeline
- **Use Cases**: Lead Management, Opportunity Tracking, Sales Pipeline, Account Management
- **Infrastructure**: CRMRepository, LeadScoringService, SalesReportingService

### Client Management Domain (`client/`)
- **Models**: Customer, CustomerProfile, CustomerSegment, CustomerHistory, Relationship
- **Use Cases**: Customer Lifecycle Management, Customer Segmentation, Relationship Management
- **Infrastructure**: CustomerRepository, SegmentationEngine, CustomerAnalytics

### Provider Management Domain (`provider/`)
- **Models**: Vendor, Supplier, VendorContract, VendorRating, VendorCategory
- **Use Cases**: Vendor Onboarding, Contract Management, Vendor Performance, Supplier Relations
- **Infrastructure**: VendorRepository, ContractService, RatingService

### Subscription Management Domain (`subscription/`)
- **Models**: Subscription, SubscriptionPlan, BillingCycle, SubscriptionHistory, Upgrade
- **Use Cases**: Subscription Lifecycle, Plan Management, Billing Management, Upgrades/Downgrades
- **Infrastructure**: SubscriptionRepository, BillingService, PaymentGateway

### Retail Promotions Domain (`promotion/`)
- **Models**: Campaign, Promotion, Discount, PromotionRule, CustomerSegment
- **Use Cases**: Campaign Management, Promotion Engine, Discount Calculation, Targeted Marketing
- **Infrastructure**: PromotionRepository, RuleEngine, SegmentingService

## Integration Points
- Customers shared across CRM, Client, and Subscription domains
- Promotions targeted based on Customer segments
- Vendor relationships linked to Customer accounts
- Subscription status affects promotional eligibility
