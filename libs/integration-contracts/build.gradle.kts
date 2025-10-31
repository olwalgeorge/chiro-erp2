plugins {
    kotlin("jvm")
    `java-library`
}

dependencies {
    val swaggerVersion: String by project
    
    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    
    // API contracts and OpenAPI
    implementation("io.swagger.core.v3:swagger-annotations:$swaggerVersion")
    implementation("jakarta.ws.rs:jakarta.ws.rs-api")
    implementation("jakarta.validation:jakarta.validation-api")
    
    // JSON serialization
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("com.fasterxml.jackson.core:jackson-annotations")
    
    // Common platform utilities
    implementation(project(":libs:platform-common"))
    implementation(project(":libs:domain-events"))
    
    // Testing
    testImplementation("org.junit.jupiter:junit-jupiter")
    testImplementation("io.mockk:mockk:1.13.8")
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
}
