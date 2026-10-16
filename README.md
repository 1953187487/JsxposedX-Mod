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

- **Dhizuku 权限集成**：无需 root、无需授权，仅依赖 Dhizuku 辅助权限即可完成 Xposed 模块注入
  - 自动检测 Dhizuku 安装状态
  - 引导用户安装 Dhizuku
  - 请求 Dhizuku 授权
  - 执行 shell 命令
  - 管理模块文件（安装/卸载/查询）

### Dhizuku 配置信息

- Dhizuku 包名：`xyz.dhiyan.dhizuku`
- 模块注入路径：`/data/data/xyz.dhiyan.dhizuku/files/modules/`
- 目标进程重启后自动加载模块
- Dhizuku 下载地址：https://github.com/dhiyanrd/dhizuku/releases

## 开源协议

GPL-3.0，完整继承原 JsxposedX 协议。

## 上游项目

- 原仓库：https://github.com/dugongzi/JsxposedX
- 本二改版：https://github.com/1953187487/JsxposedX-Mod

## 免责声明

本项目为 JsxposedX 的二次开发版本，仅用于合法学习与研究。严禁将本项目用于作弊、破解、绕过保护或任何违法违规用途。