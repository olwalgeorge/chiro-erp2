plugins {
    kotlin("jvm") version "2.2.20" apply false
    kotlin("plugin.allopen") version "2.2.20" apply false
    id("io.quarkus") version "\" apply false
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
