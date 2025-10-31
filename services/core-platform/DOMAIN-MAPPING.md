# Core Platform Service

**Consolidated Services:**
- service-identity-access
- service-organization-master

## Domain Structure

### Identity Domain (`identity/`)
- **Models**: User, Role, Permission, UserSession, AuthToken
- **Use Cases**: Authentication, User Management, RBAC, Session Management
- **Infrastructure**: UserRepository, TokenService, PasswordEncoder, LDAP Integration

### Organization Domain (`organization/`)
- **Models**: Organization, Department, Team, OrganizationSettings, Tenant
- **Use Cases**: Organization Management, Multi-tenancy, Organizational Structure
- **Infrastructure**: OrganizationRepository, TenantContextProvider

## Integration Points
- Users belong to Organizations (tenantId relationship)
- Shared authentication context across all domains
- Multi-tenant isolation at organization level
