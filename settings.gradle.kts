pluginManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
}

rootProject.name = "chiro-erp"

// Shared libraries
include(":libs:platform-common")
include(":libs:domain-events")
include(":libs:integration-contracts")
include(":libs:security-common")

// Consolidated multimodal services (8 services instead of 30+)
include(":services:core-platform")
include(":services:customer-relationship")
include(":services:operations-service")
include(":services:commerce")
include(":services:financial-management")
include(":services:supply-chain-manufacturing")
include(":services:logistics-transportation")
include(":services:analytics-intelligence")
