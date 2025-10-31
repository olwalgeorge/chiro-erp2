# Chiro ERP - Consolidated Microservices Platform

## 🚀 Enterprise ERP System

This project is a comprehensive **Enterprise Resource Planning (ERP) system** built with Quarkus, featuring a **consolidated microservices architecture** that groups 30+ original services into 8 business-domain-focused services for better operational efficiency and world-class ERP capabilities.

🏗️ **Architecture**: 8 Consolidated Services (down from 30+ individual services)  
📈 **Benefits**: 75% reduction in deployments, improved business alignment, simplified operations  
🌟 **Patterns**: SAP ERP patterns (FI, MM, CO), Enterprise security, Hexagonal architecture

## 📁 Project Structure

```
chiro-erp/
├── services/           # 8 consolidated business services
├── libs/              # Shared libraries and common code
├── docs/              # 📖 Complete documentation
│   ├── architecture/  # Architecture and design docs
│   └── migration/     # Migration and consolidation docs
├── scripts/           # 🔧 PowerShell automation scripts
├── templates/         # 📋 Build and structure templates
└── archived-original-structure/  # Legacy structure reference
```

## 🏗️ Consolidated Services Architecture

### 8 Enterprise-Grade Business Services:
1. **🔐 core-platform** - Security, Identity, Organization, Audit & Integration (6 domains)
2. **👥 customer-relationship** - CRM, Client Management, Providers & Subscriptions (5 domains)  
3. **⚙️ operations-service** - Field Service, Scheduling, Records & RMA (4 domains)
4. **🛒 commerce** - E-commerce, POS, Customer Portal & Communication (4 domains)
5. **💰 financial-management** - SAP FI: General Ledger, AP/AR, Assets, Tax & Expenses (6 domains)
6. **🏭 supply-chain-manufacturing** - SAP MM: Production, Quality, Inventory, Costing & Procurement (5 domains)
7. **🚚 logistics-transportation** - Fleet Management, TMS & WMS (3 domains)
8. **📊 analytics-intelligence** - Data Products, AI/ML & Reporting (3 domains)

**Total: 36 Domain Structures** following **Hexagonal Architecture** principles

## 🚀 Quick Start

### 1. Generate Complete Structure
```powershell
.\scripts\create-complete-structure.ps1
```

### 2. Build All Services
```shell script
./gradlew build
```

### 3. Run Specific Service
```shell script
./gradlew :services:customer-relationship:quarkusDev
```

## 📖 Documentation

- **[📚 Complete Documentation](docs/)** - Architecture, migration, and implementation guides
- **[🏗️ Architecture Overview](docs/architecture/ARCHITECTURE-SUMMARY.md)** - Comprehensive system architecture
- **[🔄 Migration Guide](docs/migration/microservice-consolidation-plan.md)** - Consolidation strategy and roadmap
- **[📋 Templates](templates/)** - Build templates and structure examples

## 🔧 Development

### Service-Specific Commands
```shell script
# Build specific service
./gradlew :services:customer-relationship:build

# Run in development mode with hot reload
./gradlew :services:core-platform:quarkusDev

# Run tests for all services
./gradlew test
```

## 📦 Packaging and running the consolidated services

All services can be built together:

```shell script
# Build all consolidated services
./gradlew build

# Build specific service
./gradlew :services:customer-relationship:build
```

Each service produces a `quarkus-run.jar` file in its respective `build/quarkus-app/` directory.
The services are runnable using `java -jar build/quarkus-app/quarkus-run.jar`.

## Service-Specific Commands

Each consolidated service supports custom Gradle tasks:

```shell script
# List business modules in a service
./gradlew :services:customer-relationship:listModules

# Validate module boundaries
./gradlew :services:customer-relationship:validateModuleBoundaries

# Generate module documentation  
./gradlew :services:customer-relationship:generateModuleDocumentation
```cture

This project uses Quarkus, the Supersonic Subatomic Java Framework, with a **consolidated microservices architecture** that groups 30+ original services into 8 business-domain-focused multimodal services for better operational efficiency.

🏗️ **Architecture**: 8 Consolidated Services (down from 30+ individual services)
📈 **Benefits**: 75% reduction in deployments, improved business alignment, simplified operations

If you want to learn more about Quarkus, please visit its website: <https://quarkus.io/>.

## 🏗️ Consolidated Services Architecture

### 8 Enterprise-Grade Business Services:
1. **🔐 core-platform** - Security, Identity, Organization, Audit & Integration (6 domains)
2. **👥 customer-relationship** - CRM, Client Management, Providers & Subscriptions (5 domains)  
3. **⚙️ operations-service** - Field Service, Scheduling, Records & RMA (4 domains)
4. **🛒 commerce** - E-commerce, POS, Customer Portal & Communication (4 domains)
5. **💰 financial-management** - SAP FI: General Ledger, AP/AR, Assets, Tax & Expenses (6 domains)
6. **🏭 supply-chain-manufacturing** - SAP MM: Production, Quality, Inventory, Costing & Procurement (5 domains)
7. **🚚 logistics-transportation** - Fleet Management, TMS & WMS (3 domains)
8. **📊 analytics-intelligence** - Data Products, AI/ML & Reporting (3 domains)

**Total: 36 Domain Structures** following **Hexagonal Architecture** principles

## Running the application in dev mode

You can run any consolidated service in dev mode that enables live coding:

```shell script
# Run a specific service
cd services/customer-relationship
../../gradlew quarkusDev

# Or run from root (builds all services)
./gradlew :services:customer-relationship:quarkusDev
```

> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at <http://localhost:8080/q/dev/>.

## Packaging and running the application

The application can be packaged using:

```shell script
./gradlew build
```

It produces the `quarkus-run.jar` file in the `build/quarkus-app/` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `build/quarkus-app/lib/` directory.

The application is now runnable using `java -jar build/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:

```shell script
./gradlew build -Dquarkus.package.jar.type=uber-jar
```

The application, packaged as an _über-jar_, is now runnable using `java -jar build/*-runner.jar`.

## Creating a native executable

You can create a native executable using:

```shell script
./gradlew build -Dquarkus.native.enabled=true
```

Or, if you don't have GraalVM installed, you can run the native executable build in a container using:

```shell script
./gradlew build -Dquarkus.native.enabled=true -Dquarkus.native.container-build=true
```

You can then execute your native executable with: `./build/chiro-erp-1.0.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult <https://quarkus.io/guides/gradle-tooling>.

## Related Guides

- REST Jackson ([guide](https://quarkus.io/guides/rest#json-serialisation)): Jackson serialization support for Quarkus REST. This extension is not compatible with the quarkus-resteasy extension, or any of the extensions that depend on it
- Kotlin ([guide](https://quarkus.io/guides/kotlin)): Write your services in Kotlin
- SmallRye JWT ([guide](https://quarkus.io/guides/security-jwt)): Secure your applications with JSON Web Token
- Reactive PostgreSQL client ([guide](https://quarkus.io/guides/reactive-sql-clients)): Connect to the PostgreSQL database using the reactive pattern
- SmallRye GraphQL ([guide](https://quarkus.io/guides/smallrye-graphql)): Create GraphQL Endpoints using the code-first approach from MicroProfile GraphQL
- SmallRye Health ([guide](https://quarkus.io/guides/smallrye-health)): Monitor service health

## Provided Code

### REST

Easily start your REST Web Services

[Related guide section...](https://quarkus.io/guides/getting-started-reactive#reactive-jax-rs-resources)

### SmallRye GraphQL

Start coding with this Hello GraphQL Query

[Related guide section...](https://quarkus.io/guides/smallrye-graphql)

### SmallRye Health

Monitor your application's health using SmallRye Health

[Related guide section...](https://quarkus.io/guides/smallrye-health)
