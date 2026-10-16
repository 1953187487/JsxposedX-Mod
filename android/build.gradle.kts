allprojects {
    repositories {
        // 国内镜像优先，官方仓库兜底，减少 Maven Central / Google Maven 慢下载
        maven {
            url = uri("https://maven.aliyun.com/repository/google")
        }
        maven {
            url = uri("https://maven.aliyun.com/repository/central")
        }
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
        google()
        mavenCentral()
    }
}

// 将构建目录重定向到根目录，解决跨驱动器路径解析问题
val rootBuildDir: File = run {
    val baseDir = project.rootDir.parentFile ?: project.projectDir.parentFile
    baseDir.resolve("build")
}

rootProject.layout.buildDirectory.value(project.layout.projectDirectory.dir(rootBuildDir.absolutePath))

subprojects {
    val newSubprojectBuildDir = rootBuildDir.resolve(project.name)
    project.layout.buildDirectory.value(project.layout.projectDirectory.dir(newSubprojectBuildDir.absolutePath))
}
subprojects {
    project.evaluationDependsOn(":app")
    
    // 修复跨驱动器盘符导致的 Gradle Sync 失败问题 (F: 盘项目与 C: 盘 Pub Cache 冲突)
    val disableAndroidResources = Action<Project> {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            android.testOptions.unitTests.isIncludeAndroidResources = false
        }
    }
    
    if (project.state.executed) {
        disableAndroidResources.execute(project)
    } else {
        project.afterEvaluate(disableAndroidResources)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
