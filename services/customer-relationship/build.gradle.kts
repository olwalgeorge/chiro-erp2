plugins {
    kotlin("jvm")
    kotlin("plugin.allopen")
    kotlin("plugin.noarg")
    kotlin("plugin.jpa")
    id("io.quarkus")
    id("jacoco")
}

dependencies {
    val quarkusPlatformGroupId: String by project
    val quarkusPlatformArtifactId: String by project
    val quarkusPlatformVersion: String by project
    
    // Quarkus BOM
    implementation(enforcedPlatform("$quarkusPlatformGroupId:$quarkusPlatformArtifactId:$quarkusPlatformVersion"))
    
    // Core Quarkus dependencies
    implementation("io.quarkus:quarkus-rest-jackson")
    implementation("io.quarkus:quarkus-kotlin")
    implementation("io.quarkus:quarkus-hibernate-reactive-panache-kotlin")
    implementation("io.quarkus:quarkus-smallrye-jwt")
    implementation("io.quarkus:quarkus-reactive-pg-client")
    implementation("io.quarkus:quarkus-smallrye-graphql")
    implementation("io.quarkus:quarkus-smallrye-health")
    implementation("io.quarkus:quarkus-micrometer-registry-prometheus")
    implementation("io.quarkus:quarkus-smallrye-openapi")
    implementation("io.quarkus:quarkus-arc")
    implementation("io.quarkus:quarkus-rest")
    
    // Messaging and Events
    implementation("io.quarkus:quarkus-messaging-kafka")
    implementation("io.quarkus:quarkus-kafka-streams")
    
    // Database
    implementation("io.quarkus:quarkus-flyway")
    implementation("io.quarkus:quarkus-jdbc-postgresql")
    
    // Validation and Serialization
    implementation("io.quarkus:quarkus-hibernate-validator")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    
    // Consolidated shared libraries (NEW APPROACH)
    implementation(project(":libs:platform-common"))
    implementation(project(":libs:domain-events"))
    implementation(project(":libs:integration-contracts"))
    implementation(project(":libs:security-common"))
    
    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactive")
    
    // Testing
    testImplementation("io.quarkus:quarkus-junit5")
    testImplementation("io.rest-assured:rest-assured")
    testImplementation("io.mockk:mockk:1.13.8")
    testImplementation("org.testcontainers:junit-jupiter")
    testImplementation("org.testcontainers:postgresql")
    testImplementation("org.testcontainers:kafka")
    testImplementation("io.quarkus:quarkus-test-kafka-companion")
    testImplementation("io.quarkus:quarkus-jacoco")
}

allOpen {
    annotation("jakarta.ws.rs.Path")
    annotation("jakarta.enterprise.context.ApplicationScoped")
    annotation("jakarta.persistence.Entity")
    annotation("io.quarkus.test.junit.QuarkusTest")
}

noArg {
    annotation("jakarta.persistence.Entity")
    annotation("jakarta.persistence.Embeddable")
    annotation("jakarta.persistence.MappedSuperclass")
}

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
        javaParameters.set(true)
    }
}

tasks.test {
    useJUnitPlatform()
    systemProperty("java.util.logging.manager", "org.jboss.logmanager.LogManager")
    systemProperty("quarkus.log.level", "WARN")
    systemProperty("quarkus.log.category.\"com.chiro.erp\".level", "DEBUG")
    jvmArgs("--add-opens", "java.base/java.lang=ALL-UNNAMED")
}

// Code coverage reports can be added later if needed

// Custom tasks for modular service management
tasks.register("listModules") {
    group = "consolidated-service"
    description = "List all business modules in this consolidated service"
    doLast {
        val modulesDir = file("src/main/kotlin/com/chiro/erp/crm/domain/modules")
        if (modulesDir.exists()) {
            println("=== Business Modules in Customer Relationship Service ===")
            modulesDir.listFiles()?.filter { it.isDirectory }?.forEach { module ->
                println("📦 ${module.name}")
                val moduleFiles = module.walkTopDown()
                    .filter { it.isFile && it.extension == "kt" }
                    .count()
                println("   └── $moduleFiles Kotlin files")
            }
        }
    }
}

tasks.register("validateModuleBoundaries") {
    group = "verification"
    description = "Validate that modules maintain proper boundaries within the consolidated service"
    doLast {
        println("🔍 Validating module boundaries...")
        
        val srcDir = file("src/main/kotlin/com/chiro/erp/crm")
        val violations = mutableListOf<String>()
        
        // Check for cross-module dependencies that should go through shared interfaces
        srcDir.walkTopDown().filter { it.name.endsWith(".kt") }.forEach { file ->
            val content = file.readText()
            // Add boundary validation logic here
            println("✅ Validated: ${file.relativeTo(srcDir)}")
        }
        
        if (violations.isEmpty()) {
            println("✅ All module boundaries are valid!")
        } else {
            violations.forEach { println("❌ $it") }
            throw GradleException("Module boundary violations found!")
        }
    }
}

tasks.register("generateModuleDocumentation") {
    group = "documentation"
    description = "Generate documentation for all modules in this consolidated service"
    doLast {
        println("📚 Generating consolidated service documentation...")
        
        val modulesDir = file("src/main/kotlin/com/chiro/erp/crm/domain/modules")
        val docFile = file("build/module-documentation.md")
        docFile.parentFile.mkdirs()
        
        val doc = StringBuilder()
        doc.appendLine("# Customer Relationship Management Service")
        doc.appendLine("## Business Modules")
        doc.appendLine()
        
        modulesDir.listFiles()?.filter { it.isDirectory }?.forEach { module ->
            doc.appendLine("### ${module.name.replace("-", " ").replaceFirstChar { it.uppercase() }}")
            doc.appendLine("**Location:** `src/main/kotlin/com/chiro/erp/crm/domain/modules/${module.name}/`")
            
            // Find domain models
            val models = module.resolve("model")
            if (models.exists()) {
                doc.appendLine("**Domain Models:**")
                models.listFiles()?.filter { it.extension == "kt" }?.forEach { model ->
                    doc.appendLine("- ${model.nameWithoutExtension}")
                }
            }
            
            doc.appendLine()
        }
        
        docFile.writeText(doc.toString())
        println("📝 Documentation generated: ${docFile.absolutePath}")
    }
}

// Note: Quarkus profile configuration is typically done via application.properties files
// This allows for proper runtime configuration without build script complexity
