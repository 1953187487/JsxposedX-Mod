# 口袋服务器 PocketServer

把一台安卓手机变成**软件服务器 + 游戏服务器**的开源工具。

手机上部署完整的 Linux 运行环境（proot + Alpine Linux），一键安装依赖后，即可把手机当作服务器使用：

- **软件服务器**：内置用户系统 API（注册 / 登录 / 在线心跳 / 账户列表），并托管你自己开发的软件包，你的 App 客户端直接对接
- **游戏服务器**：自动安装 OpenJDK 17，下载并运行 PaperMC（Minecraft 服务端），也支持自定义启动脚本运行其他游戏服务端

## 功能（V1.0）

底部导航三个标签页：

### 主页
- 顶部状态卡片：环境状态、服务器运行状态一目了然
- 一键安装依赖：首次进入自动询问，下载 proot 与 Alpine Linux 根文件系统，自动安装基础依赖
- 启动 / 停止软件服务器、游戏服务器
- 实时控制台日志输出
- 详细启动方法说明

### AI 与用户
- 接入自定义 AI 服务商（OpenAI 兼容接口），用 AI 分析服务器状态、日志与 APK
- 查看当前服务器注册的账户列表与在线状态
- 选择工作区 APK 进行分析
- 一键安装 APK 工具链：apktool（反编译 / 回编译）、jadx（转 Java 源码）、jarsigner 签名等逆向与构建依赖

### 设置
- 调节应用主题颜色（8 种预设色）
- 配置自定义 AI 服务商：填写地址与 Key，拉取模型列表、测试模型
- 检查更新 / 历史版本（基于 GitHub Releases）
- 关于我们、用户须知协议、开源协议

## 技术架构（基于开源技术）

| 组件 | 开源项目 | 用途 |
|------|----------|------|
| 用户态 Linux 环境 | [proot](https://github.com/proot-me/proot) | 无需 root 运行 Linux 根文件系统 |
| 基础系统 | [Alpine Linux](https://alpinelinux.org/) | 轻量 rootfs，apk 包管理 |
| 软件服务器 | Python 3 标准库 | 用户系统 API + 静态托管 |
| 游戏服务器 | [PaperMC](https://papermc.io/) + OpenJDK | Minecraft 服务端 |
| APK 逆向 / 构建 | [apktool](https://github.com/iBotPeaches/Apktool)、[jadx](https://github.com/skylot/jadx)、JDK jarsigner | 反编译、源码还原、重打包、签名 |
| AI 接入 | OpenAI 兼容 API（OkHttp） | 自定义服务商、模型拉取与测试 |
| 应用框架 | Kotlin + AndroidX Material | 界面与交互 |

## 构建

```bash
# 需要 JDK 17 与 Android SDK（platform-34, build-tools 34.0.0）
./gradlew assembleDebug
```

产物：`app/build/outputs/apk/debug/app-debug.apk`

系统要求：Android 7.0（API 24）及以上，arm64-v8a / armeabi-v7a / x86_64。

## 网络端口

| 服务 | 端口 |
|------|------|
| 软件服务器（用户系统 API + 文件托管） | 8080 |
| Minecraft 游戏服务器 | 25565 |

## 开源协议

本项目基于 [GPL-3.0](LICENSE) 协议开源。依赖的第三方开源组件及其协议详见应用内「设置 - 开源协议」页面。

## 关于

由开发者「东风…zjjaw」开发的安卓自托管（Self-Hosting）工具，让闲置手机发挥余热。
