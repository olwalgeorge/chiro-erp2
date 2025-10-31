pluginManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
}

rootProject.name = "chiro-erp"

// Include shared libraries
include(":libs:common-domain")
include(":libs:common-event-schemas")
include(":libs:common-api-contracts")
include(":libs:common-security")

// Include all services
include(":services:service-identity-access")
include(":services:service-organization-master")

// Core business services (renamed from healthcare-specific terms)
include(":services:service-client-management")        // formerly service-patient-management
include(":services:service-provider-management")      // formerly service-practitioner-management
include(":services:service-records-management")       // formerly service-treatment-records
include(":services:service-resource-scheduling")      // formerly service-appointment-scheduling

// Analytics & AI services
include(":services:service-ai-ml")
include(":services:service-analytics-data-products")
include(":services:service-reporting-analytics")

// Finance & billing services
include(":services:service-ap-automation")
include(":services:service-billing-invoicing")

// E-commerce & customer services
include(":services:service-ecomm-storefront")
include(":services:service-customer-portal")
include(":services:service-communication-portal")

// CRM & sales services
include(":services:service-crm")
include(":services:service-subscriptions")
include(":services:service-retail-promotions")

// Operations & logistics services
include(":services:service-field-service-management")
include(":services:service-repair-rma")
include(":services:service-fleet-management")
include(":services:service-tms")
include(":services:service-wms-advanced")

// Manufacturing & quality services
include(":services:service-mrp-production")
include(":services:service-quality-management")
include(":services:service-inventory-management")
