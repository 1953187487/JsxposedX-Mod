plugins {
    java
    id("org.jetbrains.kotlin.jvm")
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

dependencies {
    compileOnly("com.android.tools.lint:lint-api:31.8.0")
    compileOnly("com.android.tools.lint:lint-checks:31.8.0")
    compileOnly("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")
}
