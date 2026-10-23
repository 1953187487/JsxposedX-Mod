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
        // Dhizuku API 要求 minSdk 26，否则清单合并会把它抬到 26 并产生告警。
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            // 仅构建 arm64-v8a：与 --target-platform android-arm64 一致，
            // 可省去 x86/armeabi-v7a/x86_64 三份 native 对象文件（各约 500-620MB）。
            // 注意：默认 abiFilters 已含全部 ABI，必须 clear 后再 add，addAll 只是追加。
            abiFilters.clear()
            abiFilters.add("arm64-v8a")
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
            // mergeJniLibFolders 会合并 jniLibs/ 下所有 ABI 的预编译库，
            // 与 ndk.abiFilters 相互独立。这里显式排除非 arm64 的产物。
            excludes += listOf(
                "**/armeabi-v7a/**",
                "**/x86/**",
                "**/x86_64/**",
            )
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

// defaultConfig.ndk.abiFilters 不控制 CMake 编译，variant 级配置才生效。
// 必须在 variant 创建时设置，afterEvaluate 太晚。
androidComponents {
    onVariants { variant ->
        variant.externalNativeBuild?.abiFilters?.set(setOf("arm64-v8a"))
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
    // Dhizuku 官方 SDK：通过设备所有者身份共享受管权限。
    // 2.5.4 是最后兼容 compileSdk 36 / AGP 8.9.x 的版本；2.6.0 起要求 compileSdk 37。
    implementation("io.github.iamr0s:Dhizuku-API:2.5.4")

    // Shizuku 官方 SDK：通过 Shizuku 服务实现免 root 权限。
    // 13.1.5 是最新稳定版，provider 模块需单独引入。
    implementation("dev.rikka.shizuku:api:13.1.5")
    implementation("dev.rikka.shizuku:provider:13.1.5")

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
