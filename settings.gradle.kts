pluginManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
    plugins {
        id("\") version "\"
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
