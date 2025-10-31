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

// Include core services (starting with just a few for testing)
include(":services:service-identity-access")
include(":services:service-organization-master")
