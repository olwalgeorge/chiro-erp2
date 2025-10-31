# Complete Consolidated Services File Structure

## Directory Structure Template

Each consolidated service follows this hexagonal architecture pattern:

```
services/{service-name}/
├── DOMAIN-MAPPING.md                    # Domain consolidation documentation
├── build.gradle.kts                     # Service build configuration
├── src/
│   ├── main/
│   │   ├── kotlin/com/chiro/erp/{domain}/
│   │   │   ├── {domain-name}/           # Each original microservice becomes a domain
│   │   │   │   ├── domain/              # Pure business logic (hexagon core)
│   │   │   │   │   ├── models/          # Entities, Value Objects, Aggregates
│   │   │   │   │   │   ├── {Entity}.kt
│   │   │   │   │   │   └── ...
│   │   │   │   │   ├── services/        # Domain services (business rules)
│   │   │   │   │   │   ├── {DomainService}.kt
│   │   │   │   │   │   └── ...
│   │   │   │   │   └── ports/           # Interfaces (contracts)
│   │   │   │   │       ├── inbound/     # Use cases (what domain offers)
│   │   │   │   │       │   ├── {UseCase}.kt
│   │   │   │   │       │   └── ...
│   │   │   │   │       └── outbound/    # External dependencies
│   │   │   │   │           ├── {Repository}.kt
│   │   │   │   │           ├── {ExternalService}.kt
│   │   │   │   │           └── ...
│   │   │   │   ├── application/         # Use case implementations
│   │   │   │   │   ├── {ApplicationService}.kt
│   │   │   │   │   └── ...
│   │   │   │   ├── infrastructure/      # External adapters (outbound)
│   │   │   │   │   ├── persistence/     # Database implementations
│   │   │   │   │   │   ├── {JpaRepository}.kt
│   │   │   │   │   │   └── ...
│   │   │   │   │   ├── messaging/       # Event publishing/consuming
│   │   │   │   │   │   ├── {EventPublisher}.kt
│   │   │   │   │   │   ├── {EventListener}.kt
│   │   │   │   │   │   └── ...
│   │   │   │   │   └── external/        # External service clients
│   │   │   │   │       ├── {ExternalServiceClient}.kt
│   │   │   │   │       └── ...
│   │   │   │   └── interfaces/          # Inbound adapters (entry points)
│   │   │   │       ├── rest/            # REST API controllers
│   │   │   │       │   ├── {Controller}.kt
│   │   │   │       │   ├── {DTOs}.kt
│   │   │   │       │   └── ...
│   │   │   │       ├── graphql/         # GraphQL resolvers
│   │   │   │       │   ├── {Resolver}.kt
│   │   │   │       │   └── ...
│   │   │   │       └── events/          # Event listeners
│   │   │   │           ├── {EventHandler}.kt
│   │   │   │           └── ...
│   │   │   └── shared/                  # Service-level shared code
│   │   │       ├── config/
│   │   │       ├── exceptions/
│   │   │       └── utils/
│   │   └── resources/
│   │       ├── application.properties
│   │       └── db/migration/
└── └── test/
        └── kotlin/com/chiro/erp/{domain}/
            └── {domain-name}/
                ├── domain/
                ├── application/
                ├── infrastructure/
                └── interfaces/
```

## Service-to-Domain Mapping

### 1. Core Platform Service (`services/core-platform/`)
**Domains**: `security/`, `organization/`, `audit/`, `configuration/`, `notification/`, `integration/`
- ✅ **security/** - migrates `service-security-framework` (comprehensive identity & security)
- ✅ **organization/** - migrates `service-organization-master`
- ✅ **audit/** - migrates `service-audit-logging`
- ✅ **configuration/** - migrates `service-configuration-management`
- ✅ **notification/** - migrates `service-notification-engine`
- ✅ **integration/** - migrates `service-integration-platform`

### 2. Customer Relationship Service (`services/customer-relationship/`)
**Domains**: `crm/`, `client/`, `provider/`, `subscription/`, `promotion/`
- ✅ **crm/** - migrates `service-crm`
- ✅ **client/** - migrates `service-client-management`
- ✅ **provider/** - migrates `service-provider-management`
- ✅ **subscription/** - migrates `service-subscriptions`
- ✅ **promotion/** - migrates `service-retail-promotions`

### 3. Operations Service (`services/operations-service/`)
**Domains**: `field-service/`, `scheduling/`, `records/`, `repair-rma/`
- ✅ **field-service/** - migrates `service-field-service-management`
- ✅ **scheduling/** - migrates `service-resource-scheduling`
- ✅ **records/** - migrates `service-records-management`
- ✅ **repair-rma/** - migrates `service-repair-rma`

### 4. Commerce Service (`services/commerce/`)
**Domains**: `ecommerce/`, `portal/`, `communication/`, `pos/`
- ✅ **ecommerce/** - migrates `service-ecomm-storefront`
- ✅ **portal/** - migrates `service-customer-portal`
- ✅ **communication/** - migrates `service-communication-portal`
- ✅ **pos/** - migrates `service-point-of-sale`

### 5. Financial Management Service (`services/financial-management/`) - SAP FI Pattern
**Domains**: `general-ledger/`, `accounts-payable/`, `accounts-receivable/`, `asset-accounting/`, `tax-engine/`, `expense-management/`
- ✅ **general-ledger/** - migrates `service-accounting-core` (single source of truth)
- ✅ **accounts-payable/** - migrates `service-ap-automation`
- ✅ **accounts-receivable/** - migrates `service-billing-invoicing`
- ✅ **asset-accounting/** - migrates `service-asset-management`
- ✅ **tax-engine/** - migrates `service-tax-compliance`
- ✅ **expense-management/** - migrates `service-expense-reports`

### 6. Supply Chain Manufacturing Service (`services/supply-chain-manufacturing/`) - SAP MM/CO Pattern
**Domains**: `production/`, `quality/`, `inventory/`, `product-costing/`, `procurement/`
- ✅ **production/** - migrates `service-mrp-production`
- ✅ **quality/** - migrates `service-quality-management`
- ✅ **inventory/** - migrates `service-inventory-management`
- ✅ **product-costing/** - migrates `service-cost-accounting` (SAP CO pattern)
- ✅ **procurement/** - migrates `service-procurement-management` (SAP MM pattern)

### 7. Logistics Transportation Service (`services/logistics-transportation/`)
**Domains**: `fleet/`, `tms/`, `wms/`
- ✅ **fleet/** - migrates `service-fleet-management`
- ✅ **tms/** - migrates `service-tms`
- ✅ **wms/** - migrates `service-wms-advanced`

### 8. Analytics Intelligence Service (`services/analytics-intelligence/`)
**Domains**: `data-products/`, `ai-ml/`, `reporting/`
- ✅ **data-products/** - migrates `service-analytics-data-products`
- ✅ **ai-ml/** - migrates `service-ai-ml`
- ✅ **reporting/** - migrates `service-reporting-analytics`

## Migration Checklist Per Domain

For each domain migration from archived services:

### Phase 1: Domain Structure ✅
- [x] Create domain directory structure
- [x] Create DOMAIN-MAPPING.md documentation
- [x] Create placeholder model files

### Phase 2: Domain Models Migration
- [ ] Migrate entity classes from archived service
- [ ] Migrate value objects and enums
- [ ] Migrate domain events
- [ ] Update package references

### Phase 3: Business Logic Migration
- [ ] Migrate domain services
- [ ] Create inbound ports (use cases)
- [ ] Create outbound ports (repository interfaces)
- [ ] Implement application services

### Phase 4: Infrastructure Migration
- [ ] Migrate repository implementations
- [ ] Migrate external service clients
- [ ] Set up event publishing/consuming
- [ ] Migrate database configurations

### Phase 5: Interface Migration
- [ ] Migrate REST controllers
- [ ] Create DTOs and request/response objects
- [ ] Migrate GraphQL resolvers (if applicable)
- [ ] Set up event handlers

### Phase 6: Configuration & Testing
- [ ] Migrate application.properties
- [ ] Migrate database migrations
- [ ] Migrate unit tests
- [ ] Migrate integration tests
- [ ] Update API documentation

## Benefits of This Structure

1. **Preserved Business Logic**: Each original microservice becomes a domain with intact business rules
2. **Clear Boundaries**: Hexagonal architecture maintains clean separation of concerns
3. **Independent Development**: Each domain can be developed and tested independently
4. **Easy Migration**: Gradual migration domain by domain
5. **Future Flexibility**: Easy to extract domains back to microservices if needed
6. **Shared Infrastructure**: Reduced operational overhead with shared databases, monitoring, etc.

## Next Steps

1. **Choose Starting Domain**: Recommend starting with `core-platform/identity` (foundation)
2. **Migrate Models**: Copy entity classes from archived services
3. **Implement Use Cases**: Create application services following hexagonal pattern
4. **Add Infrastructure**: Implement repositories and external adapters
5. **Create APIs**: Add REST controllers for external consumption
6. **Repeat Pattern**: Apply same approach to next domain

This structure ensures that all 30+ original microservices are properly captured within the 8 consolidated services while maintaining clean architecture principles.
