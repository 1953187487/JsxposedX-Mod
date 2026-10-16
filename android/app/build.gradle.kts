import java.util.Properties


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    google()
    mavenCentral()
    maven("https://api.xposed.info/")
    maven("https://jitpack.io")
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystoreProperties = keystorePropertiesFile.exists()

if (hasKeystoreProperties) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}
android {
    namespace = "com.jsxposed.xmod"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    flavorDimensions += "xposedApi"

    productFlavors {
        create("api100") {
            dimension = "xposedApi"
        }
        create("api101") {
            dimension = "xposedApi"
        }
        create("api102") {
            dimension = "xposedApi"
        }
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/java", "src/main/kotlin")
        }
        maybeCreate("api100").java.srcDirs("src/api100/java", "src/api100/kotlin")
        maybeCreate("api101").java.srcDirs("src/api101/java", "src/api101/kotlin")
        maybeCreate("api102").java.srcDirs("src/api102/java", "src/api102/kotlin")
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.jsxposed.xmod"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters.addAll(
                listOf(
                    "arm64-v8a", "armeabi-v7a",
                    "x86", "x86_64"
                )
            )
        }
    }

    signingConfigs {
        if (hasKeystoreProperties) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            if (hasKeystoreProperties) {
                signingConfig = signingConfigs.getByName("release")
            }

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
        }
        resources {
            excludes += listOf(
                "baksmali.properties",
                "baksmali.properties/**",
                "META-INF/*.version",
            )
        }
    }
}

afterEvaluate {
    if (tasks.findByName("assembleDebug") == null) {
        tasks.register("assembleDebug") {
            group = "build"
            description = "Assembles the default debug variant (api100Debug)."
            dependsOn("assembleApi100Debug")
        }
    }

    if (tasks.findByName("installDebug") == null) {
        tasks.register("installDebug") {
            group = "install"
            description = "Installs the default debug variant (api100Debug)."
            dependsOn("installApi100Debug")
        }
    }
}

dependencies {
    compileOnly(files("src/lib/XposedBridgeAPI-89.jar"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
    implementation("com.google.code.gson:gson:2.13.2")
    implementation("com.github.suzhelan:XpHelper:2.7") {
        exclude(group = "com.alibaba.fastjson2", module = "fastjson2")
    }

    // WebSocket server for desktop bridge
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("org.nanohttpd:nanohttpd-websocket:2.3.1")

    // Pure QuickJS Wrapper for Android
    implementation("wang.harlon.quickjs:wrapper-android:3.2.0")

    // DEX decompilation
    implementation("io.github.skylot:jadx-core:1.5.1") { isTransitive = true }
    implementation("io.github.skylot:jadx-dex-input:1.5.1") { isTransitive = true }
    implementation("org.smali:baksmali:2.5.2")
    implementation("org.smali:dexlib2:2.5.2")
    add("api100CompileOnly", project(":libxposed:api"))
    add("api101CompileOnly", "io.github.libxposed:api:101.0.1")
    add("api102CompileOnly", "io.github.libxposed:api:102.0.0")
    implementation(project(":libxposed:service"))
}

flutter {
    source = "../.."
}
