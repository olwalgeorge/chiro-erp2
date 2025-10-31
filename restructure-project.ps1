# PowerShell script to restructure chiro-erp project to multi-service architecture
# This script adapts the current single-service project to the new structure

param(
    [switch]$WhatIf = $false,  # Dry run mode - shows what would be done without doing it
    [switch]$Force = $false    # Force overwrite existing directories
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Get the current directory (should be the project root)
$ProjectRoot = Get-Location
$ProjectName = "chiro-erp"

Write-Host "🚀 Starting project restructure for: $ProjectName" -ForegroundColor Green
Write-Host "📁 Project root: $ProjectRoot" -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "⚠️  DRY RUN MODE - No actual changes will be made" -ForegroundColor Yellow
}

# Function to create directory structure
function New-DirectoryStructure {
    param([string]$Path, [string]$Description)
    
    if ($WhatIf) {
        Write-Host "Would create: $Path ($Description)" -ForegroundColor Yellow
    } else {
        if (!(Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            Write-Host "✅ Created: $Path" -ForegroundColor Green
        } else {
            Write-Host "📁 Exists: $Path" -ForegroundColor Gray
        }
    }
}

# Function to move files
function Move-ProjectFile {
    param([string]$Source, [string]$Destination, [string]$Description)
    
    if ($WhatIf) {
        Write-Host "Would move: $Source -> $Destination ($Description)" -ForegroundColor Yellow
    } else {
        if (Test-Path $Source) {
            $destDir = Split-Path $Destination -Parent
            if (!(Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            Move-Item -Path $Source -Destination $Destination -Force
            Write-Host "📦 Moved: $Source -> $Destination" -ForegroundColor Blue
        } else {
            Write-Host "⚠️  Source not found: $Source" -ForegroundColor Yellow
        }
    }
}

# Function to copy files
function Copy-ProjectFile {
    param([string]$Source, [string]$Destination, [string]$Description)
    
    if ($WhatIf) {
        Write-Host "Would copy: $Source -> $Destination ($Description)" -ForegroundColor Yellow
    } else {
        if (Test-Path $Source) {
            $destDir = Split-Path $Destination -Parent
            if (!(Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-Host "📋 Copied: $Source -> $Destination" -ForegroundColor Cyan
        } else {
            Write-Host "⚠️  Source not found: $Source" -ForegroundColor Yellow
        }
    }
}

# Create the new directory structure
Write-Host "`n🏗️  Creating new directory structure..." -ForegroundColor Magenta

# Root level directories that already exist or should remain
New-DirectoryStructure "gradle" "Gradle wrapper (existing)"
New-DirectoryStructure ".gradle" "Gradle cache (existing)"

# Create libs structure for shared components
Write-Host "`n📚 Creating libs structure..." -ForegroundColor Blue
New-DirectoryStructure "libs" "Shared libraries root"
New-DirectoryStructure "libs/common-domain" "Common domain models"
New-DirectoryStructure "libs/common-domain/src/main/kotlin/com/chiro/erp/common/domain" "Domain package structure"
New-DirectoryStructure "libs/common-event-schemas" "Event schemas (Avro)"
New-DirectoryStructure "libs/common-event-schemas/src/main/avro" "Avro schema files"
New-DirectoryStructure "libs/common-event-schemas/src/main/kotlin/com/chiro/erp/common/event" "Generated event classes"
New-DirectoryStructure "libs/common-api-contracts" "API contracts"
New-DirectoryStructure "libs/common-api-contracts/src/main/kotlin/com/chiro/erp/common/api" "API contracts package"
New-DirectoryStructure "libs/common-security" "Security utilities"
New-DirectoryStructure "libs/common-security/src/main/kotlin/com/chiro/erp/common/security" "Security package"

# Create services structure
Write-Host "`n🏢 Creating services structure..." -ForegroundColor Blue
New-DirectoryStructure "services" "Services root directory"

# Create service-identity-access (main service to migrate existing code to)
$IdentityService = "services/service-identity-access"
New-DirectoryStructure $IdentityService "Identity & Access Management service"

# Docker files for identity service
New-DirectoryStructure "$IdentityService/src/main/docker" "Docker configurations"

# Package structure for identity service following hexagonal architecture
$IdentityPackage = "$IdentityService/src/main/kotlin/com/chiro/erp/identityaccess"
New-DirectoryStructure $IdentityPackage "Identity service main package"

# Application Layer - Detailed structure
New-DirectoryStructure "$IdentityPackage/application/port" "Inbound Ports (Interfaces for driving adapters)"
New-DirectoryStructure "$IdentityPackage/application/service" "Application Services (implement use cases)"
New-DirectoryStructure "$IdentityPackage/application/usecase" "Use Cases (define business operations)"
New-DirectoryStructure "$IdentityPackage/application/usecase/query" "Read-only use cases"

# Domain Layer - Detailed structure
New-DirectoryStructure "$IdentityPackage/domain/event" "Domain Events (internal representation before Kafka mapping)"
New-DirectoryStructure "$IdentityPackage/domain/model" "Entities, Aggregates, Value Objects"
New-DirectoryStructure "$IdentityPackage/domain/repository" "Outbound Ports (Interfaces for driven adapters)"
New-DirectoryStructure "$IdentityPackage/domain/service" "Domain Services (AuthZ rules, entitlement checks)"

# Infrastructure Layer - Detailed structure
New-DirectoryStructure "$IdentityPackage/infrastructure/adapter/http" "REST Controllers (Driving Adapter)"
New-DirectoryStructure "$IdentityPackage/infrastructure/adapter/kafka/consumer" "Event Consumers (e.g., for external IdP sync)"
New-DirectoryStructure "$IdentityPackage/infrastructure/adapter/kafka/producer" "Event Producers"
New-DirectoryStructure "$IdentityPackage/infrastructure/adapter/security" "Authentication/Authorization Adapters (Driven Adapter)"
New-DirectoryStructure "$IdentityPackage/infrastructure/persistence/entity" "JPA/Panache Entities"
New-DirectoryStructure "$IdentityPackage/infrastructure/persistence/mapper" "Mappers between JpaEntities and Domain Models"
New-DirectoryStructure "$IdentityPackage/infrastructure/persistence/repository" "Implementations of Domain Repositories"
New-DirectoryStructure "$IdentityPackage/infrastructure/config" "Quarkus Configuration and setup"
New-DirectoryStructure "$IdentityPackage/infrastructure/startup" "Application startup/initialization"

# Resources and test directories for identity service
New-DirectoryStructure "$IdentityService/src/main/resources" "Resources"
New-DirectoryStructure "$IdentityService/src/main/resources/db/migration" "Database migration scripts"
New-DirectoryStructure "$IdentityService/src/test/kotlin/com/chiro/erp/identityaccess" "Unit tests"
New-DirectoryStructure "$IdentityService/src/native-test/kotlin/com/chiro/erp/identityaccess" "Native tests"

# Define all service packs and their services
$CoreServices = @(
    "service-organization-master",
    "service-patient-management", 
    "service-practitioner-management",
    "service-appointment-scheduling",
    "service-treatment-records",
    "service-billing-invoicing",
    "service-inventory-management",
    "service-reporting-analytics",
    "service-communication-portal"
)

# Additional service packs
$RetailServices = @(
    "service-retail-promotions"
)

$ServicePackServices = @(
    "service-field-service-management",
    "service-repair-rma"
)

$ManufacturingServices = @(
    "service-mrp-production",
    "service-quality-management"
)

$LogisticsServices = @(
    "service-wms-advanced",
    "service-tms",
    "service-fleet-management"
)

$FinancePlusServices = @(
    "service-ap-automation"
)

$CRMServices = @(
    "service-crm",
    "service-subscriptions"
)

$ECommerceServices = @(
    "service-ecomm-storefront",
    "service-customer-portal"
)

$AnalyticsServices = @(
    "service-analytics-data-products",
    "service-ai-ml"
)

# Function to get service package name based on service type
function Get-ServicePackageName {
    param([string]$ServiceName)
    
    switch -Regex ($ServiceName) {
        "service-retail-.*" { return "com/chiro/erp/retail/$($ServiceName.Replace('service-retail-', '').Replace('-', ''))" }
        "service-field-service-management" { return "com/chiro/erp/service/fsm" }
        "service-repair-rma" { return "com/chiro/erp/service/repair" }
        "service-mrp-production" { return "com/chiro/erp/manufacturing/mrp" }
        "service-quality-management" { return "com/chiro/erp/manufacturing/quality" }
        "service-wms-advanced" { return "com/chiro/erp/logistics/wms" }
        "service-tms" { return "com/chiro/erp/logistics/tms" }
        "service-fleet-management" { return "com/chiro/erp/logistics/fleet" }
        "service-ap-automation" { return "com/chiro/erp/finance/apautomation" }
        "service-crm" { return "com/chiro/erp/crm" }
        "service-subscriptions" { return "com/chiro/erp/crm/subscriptions" }
        "service-ecomm-storefront" { return "com/chiro/erp/ecommerce/storefront" }
        "service-customer-portal" { return "com/chiro/erp/ecommerce/portal" }
        "service-analytics-data-products" { return "com/chiro/erp/analytics/dataproducts" }
        "service-ai-ml" { return "com/chiro/erp/analytics/aiml" }
        default { 
            $cleanName = $ServiceName.Replace("-", "").Replace("service", "")
            return "com/chiro/erp/$cleanName"
        }
    }
}

# Combine all services
$AllServices = $CoreServices + $RetailServices + $ServicePackServices + $ManufacturingServices + $LogisticsServices + $FinancePlusServices + $CRMServices + $ECommerceServices + $AnalyticsServices

Write-Host "`n🔧 Creating all services..." -ForegroundColor Blue

# Create basic service structures for all services
foreach ($service in $AllServices) {
    $ServicePath = "services/$service"
    
    # Determine package structure based on service type
    $PackageName = Get-ServicePackageName $service
    $ServicePackage = "$ServicePath/src/main/kotlin/$PackageName"
    
    New-DirectoryStructure $ServicePath "Service: $service"
    New-DirectoryStructure "$ServicePath/src/main/docker" "Docker files"
    New-DirectoryStructure $ServicePackage "Service package"
    New-DirectoryStructure "$ServicePackage/application/port" "Application ports"
    New-DirectoryStructure "$ServicePackage/application/service" "Application services"
    New-DirectoryStructure "$ServicePackage/application/usecase" "Use cases"
    New-DirectoryStructure "$ServicePackage/domain/model" "Domain models"
    New-DirectoryStructure "$ServicePackage/domain/event" "Domain events"
    New-DirectoryStructure "$ServicePackage/domain/repository" "Domain repositories"
    New-DirectoryStructure "$ServicePackage/domain/service" "Domain services"
    New-DirectoryStructure "$ServicePackage/infrastructure/adapter/http" "HTTP adapters"
    New-DirectoryStructure "$ServicePackage/infrastructure/adapter/kafka/consumer" "Kafka consumers"
    New-DirectoryStructure "$ServicePackage/infrastructure/adapter/kafka/producer" "Kafka producers"
    New-DirectoryStructure "$ServicePackage/infrastructure/persistence" "Persistence layer"
    New-DirectoryStructure "$ServicePath/src/main/resources" "Resources"
    New-DirectoryStructure "$ServicePath/src/test/kotlin/$($PackageName.Replace('/', '/')))" "Unit tests"
    New-DirectoryStructure "$ServicePath/src/native-test/kotlin/$($PackageName.Replace('/', '/'))" "Native tests"
}

# Note: Detailed service structures will be created during the file migration phase

# Function to update package declarations in Kotlin files
function Update-KotlinPackageDeclaration {
    param([string]$FilePath, [string]$NewPackage, [string]$Description)
    
    if ($WhatIf) {
        Write-Host "Would update package in: $FilePath to $NewPackage ($Description)" -ForegroundColor Yellow
    } else {
        if (Test-Path $FilePath) {
            $content = Get-Content $FilePath -Raw
            if ($content -match "package\s+chiro\.erp") {
                $newContent = $content -replace "package\s+chiro\.erp", "package $NewPackage"
                Set-Content -Path $FilePath -Value $newContent -Encoding UTF8
                Write-Host "📝 Updated package declaration in: $FilePath" -ForegroundColor Green
            }
        }
    }
}

# Function to create Identity Access service files
function New-IdentityAccessServiceFiles {
    if ($WhatIf) {
        Write-Host "Would create detailed Identity Access service files" -ForegroundColor Yellow
        return
    }

    # Application Layer - Ports
    $portFiles = @{
        "$IdentityPackage/application/port/IdentityAccessApiPort.kt" = "REST API definition for users, orgs, roles"
        "$IdentityPackage/application/port/AuthenticationPort.kt" = "Interface for AuthN/AuthZ integration (e.g., Keycloak)"
        "$IdentityPackage/application/port/EntitlementApiPort.kt" = "REST API for entitlement management"
    }

    # Application Layer - Services
    $serviceFiles = @{
        "$IdentityPackage/application/service/IdentityApplicationService.kt" = "Manages User/Org lifecycle"
        "$IdentityPackage/application/service/EntitlementApplicationService.kt" = "Manages tenant entitlements"
    }

    # Application Layer - Use Cases
    $useCaseFiles = @{
        "$IdentityPackage/application/usecase/IdentityManagementUseCase.kt" = "Create/Update/Delete User, Assign Role"
        "$IdentityPackage/application/usecase/EntitlementManagementUseCase.kt" = "Grant/Revoke Entitlement"
        "$IdentityPackage/application/usecase/query/IdentityQueryUseCase.kt" = "Find User/Org/Role"
        "$IdentityPackage/application/usecase/query/EntitlementQueryUseCase.kt" = "Check Entitlements"
    }

    # Domain Layer - Events
    $eventFiles = @{
        "$IdentityPackage/domain/event/UserDomainEvents.kt" = "UserCreated, UserRoleAssigned"
        "$IdentityPackage/domain/event/EntitlementDomainEvents.kt" = "EntitlementGranted"
    }

    # Domain Layer - Models
    $modelFiles = @{
        "$IdentityPackage/domain/model/User.kt" = "Aggregate Root, contains roles, permissions"
        "$IdentityPackage/domain/model/Role.kt" = "Role entity"
        "$IdentityPackage/domain/model/Permission.kt" = "Permission entity"
        "$IdentityPackage/domain/model/Organization.kt" = "Aggregate Root"
        "$IdentityPackage/domain/model/Tenant.kt" = "Value Object/Entity referencing Organization"
        "$IdentityPackage/domain/model/Entitlement.kt" = "Entity linking Tenant to Add-on/Feature"
        "$IdentityPackage/domain/model/UserId.kt" = "Value Object"
        "$IdentityPackage/domain/model/OrganizationId.kt" = "Organization ID Value Object"
        "$IdentityPackage/domain/model/EntitlementId.kt" = "Entitlement ID Value Object"
    }

    # Domain Layer - Repositories
    $repoFiles = @{
        "$IdentityPackage/domain/repository/UserRepository.kt" = "User repository interface"
        "$IdentityPackage/domain/repository/OrganizationRepository.kt" = "Organization repository interface"
        "$IdentityPackage/domain/repository/EntitlementRepository.kt" = "Entitlement repository interface"
    }

    # Domain Layer - Services
    $domainServiceFiles = @{
        "$IdentityPackage/domain/service/AuthorizationService.kt" = "RBAC/ABAC evaluation"
        "$IdentityPackage/domain/service/EntitlementCheckService.kt" = "Check if tenant has access to a feature"
    }

    # Infrastructure Layer - HTTP Controllers
    $httpFiles = @{
        "$IdentityPackage/infrastructure/adapter/http/UserController.kt" = "Implements IdentityAccessApiPort"
        "$IdentityPackage/infrastructure/adapter/http/OrganizationController.kt" = "Organization REST controller"
        "$IdentityPackage/infrastructure/adapter/http/EntitlementController.kt" = "Entitlement REST controller"
    }

    # Infrastructure Layer - Kafka
    $kafkaFiles = @{
        "$IdentityPackage/infrastructure/adapter/kafka/consumer/ExternalIdpConsumer.kt" = "Consumes events for IdP synchronization"
        "$IdentityPackage/infrastructure/adapter/kafka/producer/UserEventProducer.kt" = "Maps internal domain events to common-event-schemas"
        "$IdentityPackage/infrastructure/adapter/kafka/producer/EntitlementEventProducer.kt" = "Entitlement event producer"
    }

    # Infrastructure Layer - Security
    $securityFiles = @{
        "$IdentityPackage/infrastructure/adapter/security/KeycloakAuthAdapter.kt" = "Implements AuthenticationPort (OIDC/SSO integration)"
        "$IdentityPackage/infrastructure/adapter/security/JwtSecurityFilter.kt" = "JWT token validation"
    }

    # Infrastructure Layer - Persistence Entities
    $persistenceEntityFiles = @{
        "$IdentityPackage/infrastructure/persistence/entity/JpaUser.kt" = "JPA User entity"
        "$IdentityPackage/infrastructure/persistence/entity/JpaRole.kt" = "JPA Role entity"
        "$IdentityPackage/infrastructure/persistence/entity/JpaPermission.kt" = "JPA Permission entity"
        "$IdentityPackage/infrastructure/persistence/entity/JpaOrganization.kt" = "JPA Organization entity"
        "$IdentityPackage/infrastructure/persistence/entity/JpaEntitlement.kt" = "JPA Entitlement entity"
    }

    # Infrastructure Layer - Mappers
    $mapperFiles = @{
        "$IdentityPackage/infrastructure/persistence/mapper/UserMapper.kt" = "User domain-entity mapper"
        "$IdentityPackage/infrastructure/persistence/mapper/RoleMapper.kt" = "Role domain-entity mapper"
        "$IdentityPackage/infrastructure/persistence/mapper/EntitlementMapper.kt" = "Entitlement domain-entity mapper"
    }

    # Infrastructure Layer - Repository Implementations
    $repoImplFiles = @{
        "$IdentityPackage/infrastructure/persistence/repository/PanacheUserRepositoryAdapter.kt" = "Implements UserRepository"
        "$IdentityPackage/infrastructure/persistence/repository/PanacheOrganizationRepositoryAdapter.kt" = "Implements OrganizationRepository"
        "$IdentityPackage/infrastructure/persistence/repository/PanacheEntitlementRepositoryAdapter.kt" = "Implements EntitlementRepository"
    }

    # Infrastructure Layer - Configuration
    $configFiles = @{
        "$IdentityPackage/infrastructure/config/QuarkusKafkaConfig.kt" = "Kafka producer/consumer configurations"
        "$IdentityPackage/infrastructure/config/SecurityConfig.kt" = "JWT configuration, OIDC client setup"
        "$IdentityPackage/infrastructure/config/ObjectMapperConfig.kt" = "Custom Jackson configuration for domain objects"
    }

    # Infrastructure Layer - Startup
    $startupFiles = @{
        "$IdentityPackage/infrastructure/startup/DataLoader.kt" = "Initial users, roles, permissions (for dev/demo)"
    }

    # Main app files
    $mainFiles = @{
        "$IdentityPackage/IdentityAccessHealthCheck.kt" = "Liveness/Readiness checks"
    }

    # Resource files
    $resourceFiles = @{
        "$IdentityService/src/main/resources/db/migration/V1__initial_schema.sql" = "Initial database schema"
        "$IdentityService/src/main/resources/db/migration/V2__add_entitlements.sql" = "Add entitlements schema"
    }

    # Create all files
    $allFiles = $portFiles + $serviceFiles + $useCaseFiles + $eventFiles + $modelFiles + $repoFiles + $domainServiceFiles + $httpFiles + $kafkaFiles + $securityFiles + $persistenceEntityFiles + $mapperFiles + $repoImplFiles + $configFiles + $startupFiles + $mainFiles

    foreach ($file in $allFiles.GetEnumerator()) {
        New-KotlinPlaceholderFile $file.Key $file.Value
    }

    # Create resource files separately
    foreach ($file in $resourceFiles.GetEnumerator()) {
        New-ResourcePlaceholderFile $file.Key $file.Value
    }
}

# Function to create Kotlin placeholder files
function New-KotlinPlaceholderFile {
    param([string]$FilePath, [string]$Description)
    
    $packagePath = $FilePath -replace ".*kotlin/(.*)/[^/]+\.kt", '$1' -replace "/", "."
    $className = (Split-Path $FilePath -Leaf) -replace "\.kt", ""
    
    $content = @"
package $packagePath

/**
 * $Description
 * TODO: Implement this class as part of the Identity Access service
 */
class $className {
    // TODO: Implement
}
"@

    $dir = Split-Path $FilePath -Parent
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    Set-Content -Path $FilePath -Value $content -Encoding UTF8
    Write-Host "📝 Created: $FilePath" -ForegroundColor Green
}

# Function to create resource placeholder files
function New-ResourcePlaceholderFile {
    param([string]$FilePath, [string]$Description)
    
    $dir = Split-Path $FilePath -Parent
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    if ($FilePath -like "*.sql") {
        $content = @"
-- $Description
-- TODO: Add SQL migration script

-- Example:
-- CREATE TABLE IF NOT EXISTS users (
--     id BIGSERIAL PRIMARY KEY,
--     username VARCHAR(255) NOT NULL UNIQUE,
--     email VARCHAR(255) NOT NULL UNIQUE,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );
"@
    } else {
        $content = "# $Description`n# TODO: Add configuration"
    }
    
    Set-Content -Path $FilePath -Value $content -Encoding UTF8
    Write-Host "📝 Created: $FilePath" -ForegroundColor Green
}

# Function to create detailed service files for all service packs
function New-DetailedServiceFiles {
    if ($WhatIf) {
        Write-Host "Would create detailed service pack files" -ForegroundColor Yellow
        return
    }

    # Create key service files for major service packs
    New-RetailPromotionsFiles
    New-FSMFiles
    New-GenericServiceFiles
}

# Retail Promotions Service
function New-RetailPromotionsFiles {
    $servicePath = "services/service-retail-promotions"
    $packagePath = "com/chiro/erp/retail/promotions"
    
    # Create specialized directories
    New-DirectoryStructure "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/rules" "Rules engine adapters"
    
    $files = @{
        # Domain Layer - Key models
        "$servicePath/src/main/kotlin/$packagePath/domain/model/PromotionRule.kt" = "Promotion rule model"
        "$servicePath/src/main/kotlin/$packagePath/domain/model/Coupon.kt" = "Coupon model"
        "$servicePath/src/main/kotlin/$packagePath/domain/model/LoyaltyAccount.kt" = "Loyalty account model"
        "$servicePath/src/main/kotlin/$packagePath/domain/model/RuleEnginePort.kt" = "Rule engine port interface"
        
        # Infrastructure Layer - Key adapters
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/http/PromotionsController.kt" = "Promotions controller"
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/rules/DroolsRuleEngineAdapter.kt" = "Drools rule engine adapter"
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/kafka/consumer/RetailSaleCompletedConsumer.kt" = "Retail sale completed consumer"
        
        # Main app
        "$servicePath/src/main/kotlin/$packagePath/RetailPromotionsApp.kt" = "Retail Promotions main application"
    }
    
    foreach ($file in $files.GetEnumerator()) {
        New-KotlinPlaceholderFile $file.Key $file.Value
    }
}

# Field Service Management Service
function New-FSMFiles {
    $servicePath = "services/service-field-service-management"
    $packagePath = "com/chiro/erp/service/fsm"
    
    # Create specialized directories
    New-DirectoryStructure "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/external" "External integrations"
    New-DirectoryStructure "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/scheduling" "Scheduling algorithms"
    
    $files = @{
        # Domain Layer - Key models
        "$servicePath/src/main/kotlin/$packagePath/domain/model/WorkOrder.kt" = "Work order model"
        "$servicePath/src/main/kotlin/$packagePath/domain/model/Technician.kt" = "Technician model"
        "$servicePath/src/main/kotlin/$packagePath/domain/model/SchedulingAlgorithmPort.kt" = "Scheduling algorithm port"
        
        # Infrastructure Layer - Key adapters
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/http/WorkOrderController.kt" = "Work order controller"
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/external/MobileAppGatewayAdapter.kt" = "Mobile app gateway adapter"
        "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/scheduling/OptimizedSchedulingAdapter.kt" = "Optimized scheduling adapter"
        
        # Main app
        "$servicePath/src/main/kotlin/$packagePath/FSMApp.kt" = "FSM main application"
    }
    
    foreach ($file in $files.GetEnumerator()) {
        New-KotlinPlaceholderFile $file.Key $file.Value
    }
}

# Generic service file creation for remaining services
function New-GenericServiceFiles {
    $serviceConfigs = @{
        "service-repair-rma" = @{ Package = "com/chiro/erp/service/repair"; MainApp = "RepairRMAApp" }
        "service-mrp-production" = @{ Package = "com/chiro/erp/manufacturing/mrp"; MainApp = "MRPProductionApp" }
        "service-quality-management" = @{ Package = "com/chiro/erp/manufacturing/quality"; MainApp = "QualityApp" }
        "service-wms-advanced" = @{ Package = "com/chiro/erp/logistics/wms"; MainApp = "WMSAdvancedApp" }
        "service-tms" = @{ Package = "com/chiro/erp/logistics/tms"; MainApp = "TMSApp" }
        "service-fleet-management" = @{ Package = "com/chiro/erp/logistics/fleet"; MainApp = "FleetApp" }
        "service-ap-automation" = @{ Package = "com/chiro/erp/finance/apautomation"; MainApp = "APAutomationApp" }
        "service-crm" = @{ Package = "com/chiro/erp/crm"; MainApp = "CRMApp" }
        "service-subscriptions" = @{ Package = "com/chiro/erp/crm/subscriptions"; MainApp = "SubscriptionsApp" }
        "service-ecomm-storefront" = @{ Package = "com/chiro/erp/ecommerce/storefront"; MainApp = "EcommStorefrontApp" }
        "service-customer-portal" = @{ Package = "com/chiro/erp/ecommerce/portal"; MainApp = "CustomerPortalApp" }
        "service-analytics-data-products" = @{ Package = "com/chiro/erp/analytics/dataproducts"; MainApp = "AnalyticsDataProductsApp" }
        "service-ai-ml" = @{ Package = "com/chiro/erp/analytics/aiml"; MainApp = "AIMLApp" }
    }
    
    foreach ($serviceConfig in $serviceConfigs.GetEnumerator()) {
        $serviceName = $serviceConfig.Key
        $packagePath = $serviceConfig.Value.Package
        $mainApp = $serviceConfig.Value.MainApp
        $servicePath = "services/$serviceName"
        
        # Create basic service files
        $files = @{
            "$servicePath/src/main/kotlin/$packagePath/application/port/ApiPort.kt" = "API port for $serviceName"
            "$servicePath/src/main/kotlin/$packagePath/domain/model/DomainModel.kt" = "Domain model for $serviceName"
            "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/http/Controller.kt" = "HTTP controller for $serviceName"
            "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/kafka/consumer/EventConsumer.kt" = "Event consumer for $serviceName"
            "$servicePath/src/main/kotlin/$packagePath/infrastructure/adapter/kafka/producer/EventProducer.kt" = "Event producer for $serviceName"
            "$servicePath/src/main/kotlin/$packagePath/$mainApp.kt" = "Main application class for $serviceName"
        }
        
        foreach ($file in $files.GetEnumerator()) {
            New-KotlinPlaceholderFile $file.Key $file.Value
        }
    }
}

# Migrate existing files
Write-Host "`n📦 Migrating existing project files..." -ForegroundColor Magenta

# Move existing Kotlin source files to identity service
if (!$WhatIf) {
    # Move main application file and rename it
    Move-ProjectFile "src/main/kotlin/chiro/erp/ChiroERP.kt" "$IdentityPackage/IdentityAccessApp.kt" "Main application class"
    Move-ProjectFile "src/main/kotlin/chiro/erp/HelloGraphQLResource.kt" "$IdentityPackage/infrastructure/adapter/http/HelloGraphQLResource.kt" "GraphQL resource"
    Move-ProjectFile "src/main/kotlin/chiro/erp/MyLivenessCheck.kt" "$IdentityPackage/infrastructure/adapter/http/MyLivenessCheck.kt" "Health check"

    # Move resources
    Move-ProjectFile "src/main/resources/application.properties" "$IdentityService/src/main/resources/application.properties" "Application properties"

    # Move test files
    Move-ProjectFile "src/test/kotlin/chiro/erp/ChiroERPTest.kt" "$IdentityService/src/test/kotlin/com/chiro/erp/identityaccess/IdentityAccessAppTest.kt" "Unit test"
    Move-ProjectFile "src/native-test/kotlin/chiro/erp/ChiroERPIT.kt" "$IdentityService/src/native-test/kotlin/com/chiro/erp/identityaccess/IdentityAccessAppIT.kt" "Native test"

    # Move Docker files
    Move-ProjectFile "src/main/docker/Dockerfile.jvm" "$IdentityService/src/main/docker/Dockerfile.jvm" "JVM Dockerfile"
    Move-ProjectFile "src/main/docker/Dockerfile.legacy-jar" "$IdentityService/src/main/docker/Dockerfile.legacy-jar" "Legacy JAR Dockerfile"
    Move-ProjectFile "src/main/docker/Dockerfile.native" "$IdentityService/src/main/docker/Dockerfile.native" "Native Dockerfile"
    Move-ProjectFile "src/main/docker/Dockerfile.native-micro" "$IdentityService/src/main/docker/Dockerfile.native-micro" "Native micro Dockerfile"

    # Update package declarations in moved files
    Write-Host "`n📝 Updating package declarations..." -ForegroundColor Blue
    Update-KotlinPackageDeclaration "$IdentityPackage/IdentityAccessApp.kt" "com.chiro.erp.identityaccess" "Main application"
    Update-KotlinPackageDeclaration "$IdentityPackage/infrastructure/adapter/http/HelloGraphQLResource.kt" "com.chiro.erp.identityaccess.infrastructure.adapter.http" "GraphQL resource"
    Update-KotlinPackageDeclaration "$IdentityPackage/infrastructure/adapter/http/MyLivenessCheck.kt" "com.chiro.erp.identityaccess.infrastructure.adapter.http" "Health check"
    Update-KotlinPackageDeclaration "$IdentityService/src/test/kotlin/com/chiro/erp/identityaccess/IdentityAccessAppTest.kt" "com.chiro.erp.identityaccess" "Unit test"
    Update-KotlinPackageDeclaration "$IdentityService/src/native-test/kotlin/com/chiro/erp/identityaccess/IdentityAccessAppIT.kt" "com.chiro.erp.identityaccess" "Native test"

    # Create detailed Identity Access service files
    Write-Host "`n📝 Creating Identity Access service files..." -ForegroundColor Blue
    New-IdentityAccessServiceFiles
    
    # Create detailed service files for all service packs
    Write-Host "`n📝 Creating detailed service pack files..." -ForegroundColor Blue
    New-DetailedServiceFiles
}

# Create build files for libs
Write-Host "`n📋 Creating build configuration files..." -ForegroundColor Blue

# Create build.gradle.kts files for each lib
$LibBuildGradle = @"
plugins {
    kotlin("jvm")
}

dependencies {
    implementation(kotlin("stdlib"))
    // Add specific dependencies as needed
}
"@

$LibDirectories = @("libs/common-domain", "libs/common-event-schemas", "libs/common-api-contracts", "libs/common-security")
foreach ($libDir in $LibDirectories) {
    if (!$WhatIf) {
        Set-Content -Path "$libDir/build.gradle.kts" -Value $LibBuildGradle -Encoding UTF8
        Write-Host "📝 Created build.gradle.kts for $libDir" -ForegroundColor Green
    } else {
        Write-Host "Would create build.gradle.kts for $libDir" -ForegroundColor Yellow
    }
}

# Create service build files
$ServiceBuildGradle = @"
plugins {
    kotlin("jvm")
    kotlin("plugin.allopen")
    id("io.quarkus")
}

dependencies {
    implementation(enforcedPlatform("\${quarkusPlatformGroupId}:\${quarkusPlatformArtifactId}:\${quarkusPlatformVersion}"))
    implementation("io.quarkus:quarkus-rest-jackson")
    implementation("io.quarkus:quarkus-kotlin")
    implementation("io.quarkus:quarkus-hibernate-reactive-panache-kotlin")
    implementation("io.quarkus:quarkus-smallrye-jwt")
    implementation("io.quarkus:quarkus-reactive-pg-client")
    implementation("io.quarkus:quarkus-smallrye-graphql")
    implementation("io.quarkus:quarkus-smallrye-health")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("io.quarkus:quarkus-arc")
    implementation("io.quarkus:quarkus-rest")
    
    // Common libraries
    implementation(project(":libs:common-domain"))
    implementation(project(":libs:common-api-contracts"))
    implementation(project(":libs:common-security"))
    
    testImplementation("io.quarkus:quarkus-junit5")
    testImplementation("io.rest-assured:rest-assured")
}

allOpen {
    annotation("jakarta.ws.rs.Path")
    annotation("jakarta.enterprise.context.ApplicationScoped")
    annotation("jakarta.persistence.Entity")
    annotation("io.quarkus.test.junit.QuarkusTest")
}
"@

# Create build files for all services
Write-Host "`n📝 Creating build files for all services..." -ForegroundColor Blue
foreach ($service in $AllServices) {
    $ServicePath = "services/$service"
    if (!$WhatIf) {
        Set-Content -Path "$ServicePath/build.gradle.kts" -Value $ServiceBuildGradle -Encoding UTF8
        Write-Host "📝 Created build.gradle.kts for $ServicePath" -ForegroundColor Green
    } else {
        Write-Host "Would create build.gradle.kts for $ServicePath" -ForegroundColor Yellow
    }
}

# Update root settings.gradle.kts for multi-project
$SettingsGradle = @"
pluginManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
    plugins {
        id("\${quarkusPluginId}") version "\${quarkusPluginVersion}"
        kotlin("jvm") version "2.2.20"
        kotlin("plugin.allopen") version "2.2.20"
    }
}

rootProject.name = "chiro-erp"

// Include shared libraries
include(":libs:common-domain")
include(":libs:common-event-schemas")
include(":libs:common-api-contracts")
include(":libs:common-security")

// Include core services
include(":services:service-identity-access")
include(":services:service-organization-master")
include(":services:service-patient-management")
include(":services:service-practitioner-management")
include(":services:service-appointment-scheduling")
include(":services:service-treatment-records")
include(":services:service-billing-invoicing")
include(":services:service-inventory-management")
include(":services:service-reporting-analytics")
include(":services:service-communication-portal")

// Include retail pack services
include(":services:service-retail-promotions")

// Include service pack services
include(":services:service-field-service-management")
include(":services:service-repair-rma")

// Include manufacturing pack services
include(":services:service-mrp-production")
include(":services:service-quality-management")

// Include logistics pack services
include(":services:service-wms-advanced")
include(":services:service-tms")
include(":services:service-fleet-management")

// Include finance plus pack services
include(":services:service-ap-automation")

// Include CRM pack services
include(":services:service-crm")
include(":services:service-subscriptions")

// Include e-commerce pack services
include(":services:service-ecomm-storefront")
include(":services:service-customer-portal")

// Include analytics pack services
include(":services:service-analytics-data-products")
include(":services:service-ai-ml")
"@

if (!$WhatIf) {
    Set-Content -Path "settings.gradle.kts" -Value $SettingsGradle -Encoding UTF8
    Write-Host "📝 Updated settings.gradle.kts for multi-project setup" -ForegroundColor Green
} else {
    Write-Host "Would update settings.gradle.kts for multi-project setup" -ForegroundColor Yellow
}

# Update root build.gradle.kts
$RootBuildGradle = @"
plugins {
    kotlin("jvm") version "2.2.20" apply false
    kotlin("plugin.allopen") version "2.2.20" apply false
    id("io.quarkus") version "\${quarkusPluginVersion}" apply false
}

allprojects {
    group = "com.chiro.erp"
    version = "1.0.0-SNAPSHOT"
    
    repositories {
        mavenCentral()
        mavenLocal()
    }
}

subprojects {
    apply(plugin = "org.jetbrains.kotlin.jvm")
    
    java {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
    
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions.jvmTarget = "21"
        kotlinOptions.javaParameters = true
    }
    
    tasks.withType<Test> {
        systemProperty("java.util.logging.manager", "org.jboss.logmanager.LogManager")
        jvmArgs("--add-opens", "java.base/java.lang=ALL-UNNAMED")
    }
}
"@

if (!$WhatIf) {
    Set-Content -Path "build.gradle.kts" -Value $RootBuildGradle -Encoding UTF8
    Write-Host "📝 Updated root build.gradle.kts" -ForegroundColor Green
} else {
    Write-Host "Would update root build.gradle.kts" -ForegroundColor Yellow
}

# Create .gitignore for services
$ServiceGitIgnore = @"
# Quarkus
target/
!maven-wrapper.jar
.mvn/wrapper/maven-wrapper.jar

# Gradle
.gradle/
build/

# Eclipse
.project
.classpath
.settings/
bin/

# IntelliJ
.idea
*.iws
*.iml
*.ipr

# NetBeans
nb-configuration.xml

# Visual Studio Code
.vscode/

# OSX
.DS_Store

# Vim
*.swp
*.swo

# patch
*.orig
*.rej

# Local environment
.env
"@

if (!$WhatIf) {
    Set-Content -Path "$IdentityService/.gitignore" -Value $ServiceGitIgnore -Encoding UTF8
    Write-Host "📝 Created .gitignore for $IdentityService" -ForegroundColor Green
} else {
    Write-Host "Would create .gitignore for $IdentityService" -ForegroundColor Yellow
}

# Clean up old structure
Write-Host "`n🧹 Cleaning up old structure..." -ForegroundColor Red
if (!$WhatIf) {
    if (Test-Path "src") {
        Remove-Item -Path "src" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "🗑️  Removed old src directory" -ForegroundColor Red
    }
    if (Test-Path "build.gradle") {
        Remove-Item -Path "build.gradle" -Force -ErrorAction SilentlyContinue
        Write-Host "🗑️  Removed old build.gradle" -ForegroundColor Red
    }
    if (Test-Path "settings.gradle") {
        Remove-Item -Path "settings.gradle" -Force -ErrorAction SilentlyContinue
        Write-Host "🗑️  Removed old settings.gradle" -ForegroundColor Red
    }
} else {
    Write-Host "Would remove old src directory and gradle files" -ForegroundColor Yellow
}

Write-Host "`n✅ Project restructure completed!" -ForegroundColor Green
Write-Host "📋 Summary of changes:" -ForegroundColor Cyan
Write-Host "  • Created multi-module Gradle project structure" -ForegroundColor White
Write-Host "  • Moved existing code to services/service-identity-access" -ForegroundColor White
Write-Host "  • Updated package declarations in moved Kotlin files" -ForegroundColor White
Write-Host "  • Created complete hexagonal architecture for Identity Access service" -ForegroundColor White
Write-Host "  • Generated 40+ placeholder files with proper package structure" -ForegroundColor White
Write-Host "  • Created 22 total services across 8 service packs:" -ForegroundColor White
Write-Host "    - Core Services (10): Identity, Organization, Patient, etc." -ForegroundColor Gray
Write-Host "    - Retail Pack (1): Promotions & Loyalty" -ForegroundColor Gray
Write-Host "    - Service Pack (2): FSM, Repair/RMA" -ForegroundColor Gray
Write-Host "    - Manufacturing Pack (2): MRP/Production, Quality" -ForegroundColor Gray
Write-Host "    - Logistics Pack (3): WMS, TMS, Fleet" -ForegroundColor Gray
Write-Host "    - Finance Plus Pack (1): AP Automation" -ForegroundColor Gray
Write-Host "    - CRM Pack (2): CRM, Subscriptions" -ForegroundColor Gray
Write-Host "    - E-Commerce Pack (2): Storefront, Customer Portal" -ForegroundColor Gray
Write-Host "    - Analytics Pack (2): Data Products, AI/ML" -ForegroundColor Gray
Write-Host "  • Created libs structure for shared components" -ForegroundColor White
Write-Host "  • Set up database migration structure" -ForegroundColor White
Write-Host "  • Updated build configuration with template variables" -ForegroundColor White

if ($WhatIf) {
    Write-Host "`n⚠️  This was a DRY RUN - no actual changes were made" -ForegroundColor Yellow
    Write-Host "Run without -WhatIf parameter to apply the changes" -ForegroundColor Yellow
} else {
    Write-Host "`n🚀 What's been automated:" -ForegroundColor Green
    Write-Host "  ✅ Package declarations updated in moved Kotlin files" -ForegroundColor White
    Write-Host "  ✅ Complete Identity Access service structure created" -ForegroundColor White
    Write-Host "  ✅ Application Layer: Ports, Services, Use Cases" -ForegroundColor White
    Write-Host "  ✅ Domain Layer: Models, Events, Repositories, Services" -ForegroundColor White
    Write-Host "  ✅ Infrastructure Layer: HTTP, Kafka, Security, Persistence" -ForegroundColor White
    Write-Host "  ✅ Database migration files structure" -ForegroundColor White
    Write-Host "  ✅ All files with proper package declarations" -ForegroundColor White
    
    Write-Host "`n🔧 Manual next steps:" -ForegroundColor Yellow
    Write-Host "  • Review and implement the TODO items in generated files" -ForegroundColor White
    Write-Host "  • Verify dependencies in build.gradle.kts files" -ForegroundColor White
    Write-Host "  • Test the build: ./gradlew build" -ForegroundColor White
    Write-Host "  • Implement the actual business logic in placeholder files" -ForegroundColor White
    Write-Host "  • Configure Kafka, database, and security settings" -ForegroundColor White
}
