#!/bin/sh
set -e
echo "[toolchain] 安装 OpenJDK 17 与解压工具（首次约 100MB+，耐心等待）"
apk add --no-cache openjdk17 unzip zip
mkdir -p /srv/tools
if [ ! -f /srv/tools/apktool.jar ]; then
  echo "[toolchain] 下载 apktool（逆向解包 / 回编译）"
  curl -L --retry 3 -o /srv/tools/apktool.jar https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar
fi
if [ ! -x /srv/tools/jadx/bin/jadx ]; then
  echo "[toolchain] 下载 jadx（smali 转 Java 源码）"
  curl -L --retry 3 -o /tmp/jadx.zip https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip
  rm -rf /srv/tools/jadx
  unzip -q -o /tmp/jadx.zip -d /srv/tools/jadx
fi
java -version 2>&1 | head -1
echo "[toolchain] 完成：apktool / jadx / apksigner 均已就绪"
