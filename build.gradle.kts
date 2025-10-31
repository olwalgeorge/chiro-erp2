plugins {
    kotlin("jvm") version "2.2.20" apply false
    kotlin("plugin.allopen") version "2.2.20" apply false
    id("io.quarkus") version "3.29.0" apply false
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
    repositories {
        mavenCentral()
        mavenLocal()
    }
}
