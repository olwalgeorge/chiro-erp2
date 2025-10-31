plugins {
    kotlin("jvm")
    `java-library`
}

dependencies {
    val springSecurityVersion: String by project
    
    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    
    // Security and JWT
    implementation("jakarta.enterprise:jakarta.enterprise.cdi-api")
    implementation("jakarta.ws.rs:jakarta.ws.rs-api")
    implementation("jakarta.annotation:jakarta.annotation-api")
    
    // For JWT and security utilities
    implementation("io.jsonwebtoken:jjwt-api:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.3")
    
    // Encryption and hashing utilities
    implementation("org.springframework.security:spring-security-crypto:$springSecurityVersion")
    
    // Common platform utilities
    implementation(project(":libs:platform-common"))
    
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
