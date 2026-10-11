# 口袋服务器 PocketServer

把一台安卓手机变成**服务器**的开源工具：部署用户态 Linux 环境（proot + Alpine Linux），一键安装依赖后，用「服务器功能」运行你自己的软件服务端与游戏服务端，并提供 AI 辅助的 APK 逆向与「一键联机化」工作流。

## 功能（V1.0）

底部导航三个标签页：

### 主页
- 顶部状态卡片：环境状态、服务器运行状态一目了然
- 一键安装依赖：首次进入自动询问，下载 proot 与 Alpine Linux 根文件系统，自动安装基础依赖
- **服务器功能**：选择服务包后一键启动 / 停止
  - 内置「用户系统服务包」：注册 / 登录 / 在线心跳 / 账户列表 API + 软件包静态托管，端口 8080，你的 App 客户端直接对接
  - 自定义服务包：把你的服务端软件放入工作区 `serverpack/<名称>/`（含 `start.sh`），即可在应用内选择启动
- 实时控制台日志输出
- 详细启动方法说明

### AI 与用户
- 接入自定义 AI 服务商（OpenAI 兼容接口），AI 分析服务器状态、注册账户
- 查看当前服务器注册的账户列表与在线状态
- **AI 解包分析**：选择 APK，AI 辅助大量解包（apktool），分析包名、权限、组件、smali 结构，规划联机化改造点
- **一键联机化**：选择 APK + 联机补丁包（zip），自动完成 解包 → 覆盖替换 APK 内所有文件与服务器联机文件 → 回编译 → 签名，输出联机版 APK
- APK 工具链一键安装：apktool（反编译 / 回编译）、jadx（转 Java 源码）、apksigner（签名）、OpenJDK 17

### 设置
- 调节应用主题颜色（8 种预设色）
- 配置自定义 AI 服务商：地址 / Key / 拉取模型列表 / 测试模型
- 检查更新 / 历史版本（基于 GitHub Releases）
- 关于我们、用户须知协议、开源协议

## 服务器功能 API（内置用户系统服务包）

| 接口 | 方法 | 说明 |
|------|------|------|
| `/api/register` | POST | 注册 `{username, password}` |
| `/api/login` | POST | 登录，返回 token |
| `/api/heartbeat` | POST | 在线心跳 `{token}`，60 秒内视为在线 |
| `/api/accounts` | GET | 账户列表与在线状态 |
| `/api/logout` | POST | 注销会话 |
| `/api/ping` | GET | 存活探测 |
| `/*` | GET | 静态托管 `serverdata/www/` 内你的软件包文件 |

## 联机补丁包格式

`onlinepack/<名称>.zip`，zip 内是按 APK 解包目录组织的相对路径文件，例如：

```
smali/com/example/game/NetClient.smali   # 替换客户端联网逻辑
assets/server.conf                        # 指向你手机服务器的地址
lib/arm64-v8a/libgame.so                  # 替换联机 so
```

执行「一键联机化」时会按相对路径覆盖替换解包工程内的所有同名文件，然后回编译 + 自动生成密钥 + v1/v2 签名，输出 `workspace/output/<原名>-online.apk`。

## 技术架构（基于开源技术）

| 组件 | 开源项目 | 用途 |
|------|----------|------|
| 用户态 Linux 环境 | [proot](https://github.com/proot-me/proot) | 无需 root 运行 Linux 根文件系统（Termux bionic 构建，以 jniLibs 打包） |
| 基础系统 | [Alpine Linux](https://alpinelinux.org/) | 轻量 rootfs，apk 包管理 |
| 软件服务器 | Python 3 标准库 | 用户系统 API + 静态托管 |
| 自定义服务端 | 任意（start.sh） | 你的游戏服务端 / 软件服务端 |
| APK 逆向 / 构建 | [apktool](https://github.com/iBotPeaches/Apktool)、[jadx](https://github.com/skylot/jadx)、[apksigner](https://developer.android.com/studio) | 解包、回编译、源码还原、签名 |
| AI 接入 | OpenAI 兼容 API（OkHttp） | 自定义服务商、模型拉取与测试 |
| 应用框架 | Kotlin + AndroidX Material | 界面与交互 |

## 构建

```bash
# 需要 JDK 17 与 Android SDK（platform-34, build-tools 34.0.0）
./gradlew assembleDebug
```

产物：`app/build/outputs/apk/debug/app-debug.apk`

系统要求：Android 7.0（API 24）及以上，arm64-v8a / armeabi-v7a / x86_64。
说明：targetSdk 固定为 28（与 Termux 一致），保证应用私有目录内可执行 proot。

## 开源协议

本项目基于 [GPL-3.0](LICENSE) 协议开源（内置 proot 为 GPL-2.0+，源码随本项目公开）。依赖组件协议详见应用内「设置 - 开源协议」页面。

## 关于

由开发者「东风…zjjaw」开发的安卓自托管（Self-Hosting）工具，让闲置手机发挥余热。
