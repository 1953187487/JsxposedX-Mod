#!/bin/sh
set -e
APK="$1"
PATCH="$2"
NAME="$3"
OUT=/root/workspace/output
mkdir -p "$OUT" /tmp/patch
rm -rf /tmp/proj /tmp/out.apk
echo "[onlinize] 第 1 步：解包 APK"
java -jar /srv/tools/apktool.jar d -f -o /tmp/proj "$APK"
echo "[onlinize] 第 2 步：解压联机补丁包"
cd /tmp/patch && unzip -o -q "$PATCH"
echo "[onlinize] 第 3 步：一键覆盖替换 APK 内所有文件与服务器联机文件"
cp -a /tmp/patch/. /tmp/proj/
echo "[onlinize] 第 4 步：重建 APK"
java -jar /srv/tools/apktool.jar b -o /tmp/out.apk /tmp/proj
if [ ! -f /root/.pocket.keystore ]; then
  echo "[onlinize] 第 5 步：生成签名密钥"
  keytool -genkeypair -keystore /root/.pocket.keystore -alias pocket -keyalg RSA -keysize 2048 -validity 10000 -storepass pocketserver -keypass pocketserver -dname "CN=PocketServer" 2>/dev/null
fi
echo "[onlinize] 第 6 步：签名（v1+v2）"
java -jar /srv/tools/apksigner.jar sign --ks /root/.pocket.keystore --ks-pass pass:pocketserver --key-pass pass:pocketserver /tmp/out.apk
cp /tmp/out.apk "$OUT/$NAME"
echo "[onlinize] 完成，输出: /root/workspace/output/$NAME"
