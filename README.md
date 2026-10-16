# JsxposedX-Mod

基于 [dugongzi/JsxposedX](https://github.com/dugongzi/JsxposedX) 二改的 Android Xposed 辅助工具，**无需 root、无需面具、无需授权**，仅依赖 [Dhizuku](https://github.com/dhizuku/xyz.dhiyan.dhizuku) 即可完成模块注入。

## 二改说明

本项目在 JsxposedX 开源工程基础上进行了如下改造：

| 改造点 | 原 JsxposedX | 本二改版 |
|--------|-------------|---------|
| 权限模型 | Xposed/LSPosed + 面具授权 | Dhizuku 辅助权限 |
| 注入路径 | /data/data/org.lsposed.manager/files/modules/ | /data/data/xyz.dhiyan.dhizuku/files/modules/ |
| 目标进程 | 目标应用重启后自动加载 | 同上 |
| AI 能力 | 内置 AI 分析（Xposed/Frida） | 保留 |
| 服务端功能 | 无 | 新增 proot + Alpine 用户态 Linux 环境 |
| 账户系统 | 无 | 内置用户注册/登录/心跳 API |
| 工具链 | apktool/jadx/apksigner | 保留 |

## 仓库地址

- 原仓库：https://github.com/dugongzi/JsxposedX
- 本二改版：https://github.com/1953187487/JsxposedX-Mod

## 功能总览

### 主页（服务器 + 环境）
- 状态卡片：环境 / 服务器运行状态
- 一键安装依赖：proot + Alpine Linux 根文件系统（7 镜像、SHA256 校验）
- 服务器功能：内置用户系统服务包 + 自定义 start.sh 服务包
- 实时控制台日志

### AI 与用户
- 自定义 AI 服务商（OpenAI 兼容）
- 注册账户列表与在线状态
- APK 逆向分析（apktool / jadx）
- 一键联机化（解包 → 覆盖 → 回编译 → 签名）
- **Xposed 模块管理**（Dhizuku 辅助，无需 root）

### 设置
- 8 种主题颜色
- AI 服务商配置
- GitHub 仓库 / Token（已预配置默认值）
- 检查更新 / 历史版本（系统 DownloadManager 后台下载）
- 文档与关于

## 开源协议

GPL-3.0，完整继承原 JsxposedX 协议。

## 构建

```bash
./gradlew assembleDebug
```

产物：`app/build/outputs/apk/debug/app-debug.apk`

系统要求：Android 7.0+，arm64-v8a / armeabi-v7a / x86_64，targetSdk=28。

## 免责声明

本项目为 JsxposedX 的二次开发版本，仅用于合法学习与研究。严禁将本项目用于作弊、破解、绕过保护或任何违法违规用途。