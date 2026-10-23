# User Instruction Memory

This file records user instructions, preferences, and teachings for reference in future interactions.

## Entries

[Project Knowledge Summary]
- Date: 2026-10-18
- Context: JsxposedX-Mod Flutter/Android 工程构建与配置
- Category: Build & Compilation
- Instructions:
  - 构建环境：Flutter 3.35.4 (/opt/flutter)、JDK 17 (/opt/jdk17)、Android SDK (/opt/android-sdk)、NDK 27.0.12077973、CMake 3.22.1
  - 构建命令：`flutter build apk --debug --flavor api100 --target-platform android-arm64`
  - 必须设置环境变量：`JAVA_HOME=/opt/jdk17`、`ANDROID_SDK_ROOT=/opt/android-sdk`、`PATH=/opt/flutter/bin:/opt/jdk17/bin:$PATH`
  - 磁盘 20G 极紧张，构建产物约 3.4G，需提前 `flutter clean` 释放
  - 构建必须用后台终端，`memory_percent: 70`（daemon 理论峰值 ~3.8G，50%/65% 均导致 OOM）
  - `cpu_percent: 200`（nproc=2）
  - 日志用 `stdbuf -oL -eL ... 2>&1`，不接 `| tail`
  - Gradle daemon 参数：`-Xmx2560m -XX:MaxMetaspaceSize=1024m -XX:ReservedCodeCacheSize=256m`

[Project Knowledge Summary]
- Date: 2026-10-18
- Context: AGP 8.9.1 CMake ABI 过滤配置
- Category: Build & Compilation
- Instructions:
  - `defaultConfig.ndk.abiFilters` 不控制 CMake 编译（即使 clear+add 也无效）
  - 正确方式：`androidComponents { onVariants { variant -> variant.externalNativeBuild?.abiFilters?.set(setOf("arm64-v8a")) } }`
  - `packagingOptions.jniLibs.excludes` 仅影响打包，不影响 mergeJniLibFolders 拷贝
  - 当前配置后构建仅产出 arm64-v8a，APK 135M

[Project Knowledge Summary]
- Date: 2026-10-18
- Context: Dhizuku + Shizuku 双通道免 Root 权限实现
- Category: Architecture & Integration
- Instructions:
  - Dhizuku API 2.5.4：`io.github.iamr0s\Dhizuku-API`，包名 `com.rosan.dhizuku`
  - Shizuku API 13.1.5：`dev.rikka.shizuku:api` + `dev.rikka.shizuku:provider`（provider 需单独引入）
  - Shizuku Manifest 需添加：`<provider android:name="rikka.shizuku.ShizukuProvider" android:authorities="${applicationId}.shizuku" android:permission="android.permission.INTERACT_ACROSS_USERS_FULL" />`
  - Shizuku queries：`<package android:name="moe.shizuku.manager" />`
  - 权限逻辑：`StatusManagement.isHook()` 检查 LSPosed 服务 → Dhizuku 授权 → Shizuku 授权，任一成功即返回 true
  - Flutter 设置页：Dhizuku 和 Shizuku 合并在同一区块，标题为"免 Root 权限"
  - Pigeon 通道命名：`dev.flutter.pigeon.JsxposedX.DhizukuNative` / `dev.flutter.pigeon.JsxposedX.ShizukuNative`
  - Shizuku 权限请求需在主线程发起，使用 `Shizuku.requestPermission(requestCode)` + `OnRequestPermissionResultListener` 回调

[Project Knowledge Summary]
- Date: 2026-10-18
- Context: GitHub 仓库与部署信息
- Category: Operations & Deployment
- Instructions:
  - GitHub 仓库：https://github.com/1953187487/JsxposedX-Mod（公开，main 分支）
  - GitHub 凭据存放于 /root/.netrc（权限 600，git/curl 自动使用），严禁写入任何被 git 跟踪的文件
  - 用户凭据曾在聊天中明文暴露，涉及敏感操作后应提醒用户轮换 token
