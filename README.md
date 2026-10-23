# JsxposedX-Mod

基于 [dugongzi/JsxposedX](https://github.com/dugongzi/JsxposedX) 的二次开发版本。

## 二改说明

本项目在 JsxposedX 开源工程基础上进行了如下改造：

| 改造点 | 原 JsxposedX | 本二改版 |
|--------|-------------|---------|
| 包名 | com.jsxposed.x | com.jsxposed.xmod |
| 项目名称 | JsxposedX | JsxposedX-Mod |
| 版本号 | 6.1.1 | 1.0.0 |

## 功能特性

### 核心功能（继承自 JsxposedX）

- Flutter UI with Android-side Xposed hooks, LSPosed service integration, and native bridge modules
- Project entries for `Quick Functions`, `AI Reverse`, `Xposed Project`, and `Frida Project`
- Additional pages for crypto audit and SO analysis
- Pigeon code generation via `.buildScript/pigen_watch.ps1` on Windows or `.buildScript/pigen_watch.sh` on macOS/Linux
- Debug install flow via `.buildScript/run_install_debug.ps1` on Windows or `.buildScript/run_install_debug.sh` on macOS/Linux

### 二改新增功能

- **Dhizuku 免 root 权限链路**：集成 Dhizuku 官方 SDK（`io.github.iamr0s:Dhizuku-API`），通过设备所有者共享受管权限
  - 自动检测 Dhizuku 安装状态并展示服务端 API 版本
  - 引导用户前往发布页下载安装 Dhizuku
  - 请求并查询 Dhizuku 授权状态
  - 设置页提供 `Dhizuku 权限` 入口，实时展示安装 / 激活 / 授权状态八大维度

### Dhizuku 说明

- Dhizuku 包名：`com.rosan.dhizuku`
- 应用侧依赖：`io.github.iamr0s:Dhizuku-API:2.6.0`
- 需要先在 Dhizuku 中完成设备所有者激活，再于设置页请求授权
- Dhizuku 下载地址：https://github.com/iamr0s/Dhizuku/releases
- 模块加载与作用域管理由 libxposed / LSPosed 服务负责，Dhizuku 仅用于免 root 的受管权限获取

### 构建环境

- Flutter 3.35.4（Dart 3.9.2）
- JDK 17
- Android SDK：platform 35、build-tools 35.0.0、NDK 27.0.12077973、CMake 3.22.1

### 本地构建

```bash
# 拉取依赖
flutter pub get

# 重新生成 Pigeon 桥接代码
dart run pigeon \
  --input lib/pigeons/core/bridge/dhizuku_native/dhizuku.dart \
  --dart_out lib/generated/dhizuku.g.dart \
  --kotlin_out android/app/src/main/kotlin/com/jsxposed/x/core/bridge/dhizuku_native/DhizukuNative.g.kt \
  --kotlin_package com.jsxposed.xmod.core.bridge.dhizuku_native \
  --package_name JsxposedX

# 生成国际化代码
flutter gen-l10n

# 构建调试 APK（默认 api100 变体）
flutter build apk --debug
```

## 开源协议

GPL-3.0，完整继承原 JsxposedX 协议。

## 上游项目

- 原仓库：https://github.com/dugongzi/JsxposedX
- 本二改版：https://github.com/1953187487/JsxposedX-Mod

## 免责声明

本项目为 JsxposedX 的二次开发版本，仅用于合法学习与研究。严禁将本项目用于作弊、破解、绕过保护或任何违法违规用途。