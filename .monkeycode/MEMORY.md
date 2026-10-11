# User Instruction Memory

This file records user instructions, preferences, and teachings for reference in future interactions.

## Entries

[Project Knowledge Summary]
- Date: 2026-10-11
- Context: Agent 创建开源仓库并搭建 PocketServer Android 工程时记录
- Category: Operations & Deployment
- Instructions:
  - GitHub 仓库：https://github.com/1953187487/PocketServer（公开，main 分支，账号 login=1953187487）
  - GitHub 凭据存放于 /root/.netrc（权限 600，git/curl 自动使用），严禁写入任何被 git 跟踪的文件
  - 用户凭据曾在聊天中明文暴露，涉及敏感操作后应提醒用户轮换 token
  - Android SDK 安装在 /opt/android-sdk（platform-34 + build-tools 34.0.0），JDK 17 为系统 apt 安装
  - 项目要点：targetSdk 固定 28（保证 filesDir 内可 exec，proot 方案依赖此行为，与 Termux 一致）；proot 二进制以 jniLibs lib*.so 形式打包
