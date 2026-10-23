#!/bin/bash
# Rebuild android/app/src/lib/XposedBridgeAPI-89.jar from the legacy
# (de.robv.android.xposed) API sources shipped in this directory.
#
# The jar is a compileOnly dependency of the app module. It is excluded from
# the APK, so the private-API stubs it contains are never shipped.
#
# Usage: bash android/app/src/lib/build_xposedbridge_api_jar.sh

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JDK="${JAVA_HOME:-/opt/jdk17}"
ANDROID_JAR="${ANDROID_SDK_ROOT:-/opt/android-sdk}/platforms/android-35/android.jar"
OUT="/tmp/opencode/xbr_api_build"

[ -f "$ANDROID_JAR" ] || { echo "android.jar not found: $ANDROID_JAR"; exit 1; }

rm -rf "$OUT"
mkdir -p "$OUT/gen" "$OUT/out"

# Private Android framework classes are referenced by the legacy API but are
# not part of android.jar. Stubs cover only the signatures the API touches.
mkdir -p "$OUT/gen/android/app" \
         "$OUT/gen/android/content/res" \
         "$OUT/gen/com/android/internal/os" \
         "$OUT/gen/com/android/internal/util" \
         "$OUT/gen/external/org/apache/commons/lang3/reflect"

cat > "$OUT/gen/android/app/ActivityThread.java" <<'JAVA'
package android.app;

import android.content.pm.ApplicationInfo;
import android.content.res.CompatibilityInfo;

public class ActivityThread {
	public static ActivityThread currentActivityThread() { return null; }
	public static String currentPackageName() { return null; }
	public static Application currentApplication() { return null; }
	public LoadedApk getPackageInfoNoCheck(ApplicationInfo appInfo, CompatibilityInfo compatInfo) { return null; }
}
JAVA

cat > "$OUT/gen/android/app/LoadedApk.java" <<'JAVA'
package android.app;

import android.content.pm.ApplicationInfo;

public class LoadedApk {
	public String getResDir() { return null; }
	public ClassLoader getClassLoader() { return null; }
	public String getPackageName() { return null; }
	public ApplicationInfo getApplicationInfo() { return null; }
}
JAVA

cat > "$OUT/gen/android/app/AndroidAppHelper.java" <<'JAVA'
package android.app;

public class AndroidAppHelper {
	public static String currentProcessName() { return null; }
}
JAVA

cat > "$OUT/gen/android/content/res/CompatibilityInfo.java" <<'JAVA'
package android.content.res;

public class CompatibilityInfo {
}
JAVA

cat > "$OUT/gen/android/content/res/XResources.java" <<'JAVA'
package android.content.res;

import android.util.DisplayMetrics;

import de.robv.android.xposed.callbacks.XC_LayoutInflated;

public class XResources extends Resources {

	public XResources(AssetManager assets, DisplayMetrics metrics, Configuration config) {
		super(assets, metrics, config);
	}

	public static void setPackageNameForResDir(String packageName, String resDir) { }
	public static void init(Object resourcesKey) { }
	public static void unhookLayout(String resDir, int id, XC_LayoutInflated callback) { }

	public void initObject(String resDir) { }
	public boolean isFirstLoad() { return false; }
	public String getPackageName() { return null; }

	public static class XTypedArray extends TypedArray {
		public void initObject(XResources res) { }
	}

	public static class ResourceNames {
		public String type;
		public String entry;
		public int id;
	}
}
JAVA

cat > "$OUT/gen/com/android/internal/os/RuntimeInit.java" <<'JAVA'
package com.android.internal.os;

public class RuntimeInit {
	public static void main(String[] args) { }
}
JAVA

cat > "$OUT/gen/com/android/internal/os/ZygoteInit.java" <<'JAVA'
package com.android.internal.os;

public class ZygoteInit {
	public static void main(String[] args) { }
}
JAVA

cat > "$OUT/gen/com/android/internal/util/XmlUtils.java" <<'JAVA'
package com.android.internal.util;

import java.io.InputStream;
import java.util.Map;

import org.xmlpull.v1.XmlPullParserException;

public class XmlUtils {
	public static Map<String, Object> readMapXml(InputStream xml) throws XmlPullParserException { return null; }
}
JAVA

cat > "$OUT/gen/external/org/apache/commons/lang3/ClassUtils.java" <<'JAVA'
package external.org.apache.commons.lang3;

public class ClassUtils {

	public static Class<?> getClass(ClassLoader classLoader, String name, boolean initialize)
			throws ClassNotFoundException { return null; }

	public static boolean isAssignable(Class<?>[] classes1, Class<?>[] classes2, boolean excludePrimitive) {
		return false;
	}
}
JAVA

cat > "$OUT/gen/external/org/apache/commons/lang3/reflect/MemberUtils.java" <<'JAVA'
package external.org.apache.commons.lang3.reflect;

public class MemberUtils {

	public static int compareParameterTypes(Class<?>[] paramTypes1, Class<?>[] paramTypes2,
			Class<?>[] paramTypes) { return 0; }
}
JAVA

cat > "$OUT/gen/external/org/apache/commons/lang3/reflect/MethodUtils.java" <<'JAVA'
package external.org.apache.commons.lang3.reflect;

public class MethodUtils {
}
JAVA

"$JDK/bin/javac" -nowarn -source 1.8 -target 1.8 \
    -bootclasspath "$ANDROID_JAR" \
    -d "$OUT/out" \
    $(find "$OUT/gen" -name '*.java') \
    $(find "$HERE/XposedBridgeAPI-src/de/robv" -name '*.java')

"$JDK/bin/jar" cf "$HERE/XposedBridgeAPI-89.jar" -C "$OUT/out" .

echo "Built: $HERE/XposedBridgeAPI-89.jar"
