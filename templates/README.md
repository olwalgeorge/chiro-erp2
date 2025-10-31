# Templates Directory

This directory contains template files for the Chiro ERP project.

## 📁 Available Templates

### Build Templates

#### `sample-consolidated-build.gradle.kts`
Template Gradle build file for consolidated services with:
- Quarkus 3.29.0 configuration
- Kotlin support with modern compiler options
- Standard ERP service dependencies
- Testing framework setup
- Jacoco code coverage

**Usage:**
Copy this template when creating new services and customize dependencies as needed.

### Structure Templates

#### `COMPLETE-STRUCTURE-TEMPLATE.md`
Comprehensive template showing:
- Complete 36-domain structure
- Service-to-domain mappings
- Migration status tracking
- Implementation guidelines

## 🔧 Using Templates

### For New Services
1. Copy `sample-consolidated-build.gradle.kts` to your service directory
2. Rename to `build.gradle.kts`
3. Customize dependencies for your specific service needs
4. Update service-specific configurations

### For Project Setup
1. Review `COMPLETE-STRUCTURE-TEMPLATE.md` for structure guidance
2. Use the PowerShell scripts in `/scripts` to generate structure
3. Customize domain implementations based on your requirements

## 📖 Related Documentation

- [Architecture Documentation](../docs/architecture/) - System architecture details
- [Scripts](../scripts/) - Automation scripts for project setup
- [Migration Documentation](../docs/migration/) - Migration strategies and plans
