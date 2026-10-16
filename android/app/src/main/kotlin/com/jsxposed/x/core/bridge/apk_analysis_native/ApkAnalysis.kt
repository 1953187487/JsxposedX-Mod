package com.jsxposed.xmod.core.bridge.apk_analysis_native

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import jadx.api.JadxArgs
import jadx.api.JadxDecompiler
import org.jf.baksmali.Adaptors.ClassDefinition
import org.jf.baksmali.BaksmaliOptions
import org.jf.baksmali.formatter.BaksmaliWriter
import org.jf.dexlib2.DexFileFactory
import org.jf.dexlib2.Opcodes
import java.io.File
import java.io.StringWriter
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.zip.ZipFile

class ApkAnalysis(private val context: Context, private val session: ApkSession = ApkSession(context)) {
    companion object {
        private const val MAX_APK_INDEX_SESSIONS = 2
        private const val MAX_DEX_CACHE_ENTRIES = 3
        private const val MAX_JADX_CACHE_ENTRIES = 1
    }

    fun openSession(packageName: String): String = session.openSession(packageName)

    @Synchronized
    fun closeSession(sessionId: String) {
        val prefix = "$sessionId::"
        classDexIndex.remove(sessionId)
        dexCache.keys.filter { it.startsWith(prefix) }.forEach(dexCache::remove)
        jadxCache.keys.filter { it.startsWith(prefix) }.forEach { key ->
            jadxCache.remove(key)?.let { runCatching { it.close() } }
        }
        File(context.cacheDir, "dex_extract")
            .listFiles { file -> file.name.startsWith("${sessionId}_") }
            ?.forEach { it.delete() }
        session.closeSession(sessionId)
    }

    @Synchronized
    fun clearCaches() {
        jadxCache.values.forEach { runCatching { it.close() } }
        jadxCache.clear()
        dexCache.clear()
        classDexIndex.clear()
        session.closeAll()
    }

    fun getApkAssets(sessionId: String): List<ApkAsset> =
        getApkAssetsAt(sessionId, "")

    fun getApkAssetsAt(sessionId: String, path: String): List<ApkAsset> {
        val apkPath = session.getLocalPath(sessionId)
        val dirs = mutableSetOf<String>()
        val files = mutableListOf<ApkAsset>()
        ZipFile(apkPath).use { zip ->
            val entries = zip.entries()
            while (entries.hasMoreElements()) {
                val entry = entries.nextElement()
                val entryPath = entry.name
                if (!entryPath.startsWith(path)) continue
                val relative = entryPath.removePrefix(path)
                if (relative.isEmpty()) continue
                val segments = relative.split('/').filter { it.isNotEmpty() }
                if (segments.isEmpty()) continue
                if (segments.size > 1) {
                    dirs.add(segments[0])
                } else if (!entry.isDirectory) {
                    files.add(
                        ApkAsset(
                            path = entryPath,
                            name = segments[0],
                            size = entry.size.coerceAtLeast(0),
                            compressedSize = entry.compressedSize.coerceAtLeast(0),
                            isDirectory = false,
                            lastModified = entry.lastModifiedTime?.toMillis() ?: 0L,
                        ),
                    )
                }
            }
        }
        val result = mutableListOf<ApkAsset>()
        dirs.sorted().forEach { dirName ->
            result.add(
                ApkAsset(
                    path = if (path.isEmpty()) "$dirName/" else "$path$dirName/",
                    name = dirName,
                    size = 0,
                    compressedSize = 0,
                    isDirectory = true,
                    lastModified = 0L,
                ),
            )
        }
        result.addAll(files.sortedBy { it.name })
        return result
    }

    @Suppress("DEPRECATION")
    fun parseManifest(sessionId: String): ApkManifest {
        val apkPath = session.getLocalPath(sessionId)
        val pm = context.packageManager
        val flags = PackageManager.GET_ACTIVITIES or
                PackageManager.GET_SERVICES or
                PackageManager.GET_RECEIVERS or
                PackageManager.GET_PROVIDERS or
                PackageManager.GET_PERMISSIONS or
                PackageManager.GET_META_DATA
        val pkgInfo: PackageInfo = pm.getPackageArchiveInfo(apkPath, flags)
            ?: throw IllegalStateException("Failed to parse APK: $apkPath")
        pkgInfo.applicationInfo?.sourceDir = apkPath
        pkgInfo.applicationInfo?.publicSourceDir = apkPath

        val appInfo = pkgInfo.applicationInfo
        val permissions = pkgInfo.requestedPermissions?.toList() ?: emptyList()

        val activities = pkgInfo.activities?.map {
            ApkComponent(
                name = it.name,
                exported = it.exported,
                process = it.processName.takeIf { p -> p != pkgInfo.packageName },
                intentActions = emptyList(),
            )
        } ?: emptyList()

        val services = pkgInfo.services?.map {
            ApkComponent(
                name = it.name,
                exported = it.exported,
                process = it.processName.takeIf { p -> p != pkgInfo.packageName },
                intentActions = emptyList(),
            )
        } ?: emptyList()

        val receivers = pkgInfo.receivers?.map {
            ApkComponent(
                name = it.name,
                exported = it.exported,
                process = it.processName.takeIf { p -> p != pkgInfo.packageName },
                intentActions = emptyList(),
            )
        } ?: emptyList()

        val providers = pkgInfo.providers?.map {
            ApkComponent(
                name = it.name,
                exported = it.exported,
                process = it.processName.takeIf { p -> p != pkgInfo.packageName },
                intentActions = emptyList(),
            )
        } ?: emptyList()

        val versionCode = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            pkgInfo.longVersionCode
        } else {
            pkgInfo.versionCode.toLong()
        }

        return ApkManifest(
            packageName = pkgInfo.packageName ?: "",
            versionName = pkgInfo.versionName ?: "",
            versionCode = versionCode,
            minSdk = (appInfo?.minSdkVersion ?: 0).toLong(),
            targetSdk = (appInfo?.targetSdkVersion ?: 0).toLong(),
            permissions = permissions,
            activities = activities,
            services = services,
            receivers = receivers,
            providers = providers,
            applicationLabel = appInfo?.let { runCatching { pm.getApplicationLabel(it).toString() }.getOrNull() },
            debuggable = (appInfo?.flags?.and(android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE) ?: 0) != 0,
            allowBackup = (appInfo?.flags?.and(android.content.pm.ApplicationInfo.FLAG_ALLOW_BACKUP) ?: 0) != 0,
        )
    }

    fun parseDex(sessionId: String, dexPath: String): List<DexClass> {
        val apkPath = session.getLocalPath(sessionId)
        val dexBytes = ZipFile(apkPath).use { zip ->
            val entry = zip.getEntry(dexPath)
                ?: throw IllegalArgumentException("Entry not found: $dexPath")
            zip.getInputStream(entry).readBytes()
        }
        return parseDexBytes(dexBytes)
    }

    private val dexCache = object : LinkedHashMap<String, List<DexClass>>(4, 0.75f, true) {
        override fun removeEldestEntry(
            eldest: MutableMap.MutableEntry<String, List<DexClass>>,
        ): Boolean = size > MAX_DEX_CACHE_ENTRIES
    }
    private val classDexIndex = object : LinkedHashMap<String, MutableMap<String, String>>(
        MAX_APK_INDEX_SESSIONS + 1,
        0.75f,
        true,
    ) {
        override fun removeEldestEntry(
            eldest: MutableMap.MutableEntry<String, MutableMap<String, String>>,
        ): Boolean = size > MAX_APK_INDEX_SESSIONS
    }

    @Synchronized
    private fun loadDex(sessionId: String, dexPath: String): List<DexClass> {
        val key = "$sessionId::$dexPath"
        dexCache[key]?.let { return it }
        val classes = parseDex(sessionId, dexPath)
        dexCache[key] = classes
        val sessionIndex = classDexIndex.getOrPut(sessionId) { mutableMapOf() }
        classes.forEach { sessionIndex.putIfAbsent(it.className, dexPath) }
        return classes
    }

    fun getDexPackages(sessionId: String, dexPaths: List<String>, packagePrefix: String): List<String> {
        val result = mutableSetOf<String>()
        for (dexPath in dexPaths) {
            val all = loadDex(sessionId, dexPath)
            for (cls in all) {
                val cn = cls.className
                if (packagePrefix.isEmpty()) {
                    val dot = cn.indexOf('.')
                    if (dot > 0) result.add(cn.substring(0, dot))
                } else {
                    if (!cn.startsWith("$packagePrefix.")) continue
                    val rest = cn.substring(packagePrefix.length + 1)
                    val dot = rest.indexOf('.')
                    if (dot > 0) result.add(rest.substring(0, dot))
                }
            }
        }
        return result.sorted()
    }

    fun getDexClasses(sessionId: String, dexPaths: List<String>, packageName: String): List<DexClass> {
        val seen = mutableSetOf<String>()
        val result = mutableListOf<DexClass>()
        for (dexPath in dexPaths) {
            val all = loadDex(sessionId, dexPath)
            for (cls in all) {
                val cn = cls.className
                val matches = if (packageName.isEmpty()) {
                    !cn.contains('.')
                } else {
                    cn.startsWith("$packageName.") && !cn.substring(packageName.length + 1).contains('.')
                }
                if (matches && seen.add(cn)) result.add(cls)
            }
        }
        return result.sortedBy { it.className }
    }

    fun searchDexClasses(sessionId: String, dexPaths: List<String>, keyword: String): List<String> {
        val lowerKeyword = keyword.lowercase()
        val seen = mutableSetOf<String>()
        val result = mutableListOf<String>()
        for (dexPath in dexPaths) {
            val all = loadDex(sessionId, dexPath)
            for (cls in all) {
                val cn = cls.className
                if (cn.lowercase().contains(lowerKeyword) && seen.add(cn)) {
                    result.add(cn)
                    if (result.size >= 200) return result.sorted()
                }
            }
        }
        return result.sorted()
    }

    private fun extractDexToFile(sessionId: String, dexPath: String): File {
        val apkPath = session.getLocalPath(sessionId)
        val cacheDir = File(context.cacheDir, "dex_extract")
        cacheDir.mkdirs()
        val outFile = File(cacheDir, "${sessionId}_${dexPath.replace('/', '_')}")
        if (!outFile.exists()) {
            ZipFile(apkPath).use { zip ->
                val entry = zip.getEntry(dexPath)
                    ?: throw IllegalArgumentException("Entry not found: $dexPath")
                outFile.outputStream().use { out ->
                    zip.getInputStream(entry).copyTo(out)
                }
            }
        }
        return outFile
    }

    fun getClassSmali(sessionId: String, dexPaths: List<String>, className: String): String {
        val descriptor = "L${className.replace('.', '/')};" 
        for (dexPath in dexPaths) {
            val dexFile = extractDexToFile(sessionId, dexPath)
            runCatching {
                val dex = DexFileFactory.loadDexFile(dexFile, Opcodes.getDefault())
                val classDef = dex.classes.find { it.type == descriptor } ?: return@runCatching null
                val options = BaksmaliOptions()
                val writer = StringWriter()
                val baksmaliWriter = BaksmaliWriter(writer)
                val classDefinition = ClassDefinition(options, classDef)
                classDefinition.writeTo(baksmaliWriter)
                baksmaliWriter.flush()
                writer.toString()
            }.getOrNull()?.let { return it }
        }
        return "// Class not found: $className"
    }

    private val jadxCache = LinkedHashMap<String, JadxDecompiler>(2, 0.75f, true)

    @Synchronized
    private fun getJadxForSingleDex(sessionId: String, dexPath: String): JadxDecompiler {
        val key = "$sessionId::$dexPath"
        jadxCache[key]?.let { return it }
        val jadx = run {
            val args = JadxArgs().apply {
                inputFiles = listOf(extractDexToFile(sessionId, dexPath))
                isSkipResources = true
                threadsCount = 2  // 增加到2个线程，提升反编译速度
                isShowInconsistentCode = true
                // 减少内存占用
                isFsCaseSensitive = true
                isDebugInfo = false
                isReplaceConsts = false
                // 添加更多优化选项
                isDeobfuscationOn = false  // 关闭反混淆，加快速度
                isUseImports = true  // 使用 import 语句，减少代码冗余
            }
            JadxDecompiler(args).also { it.load() }
        }
        jadxCache[key] = jadx
        while (jadxCache.size > MAX_JADX_CACHE_ENTRIES) {
            val eldestKey = jadxCache.entries.first().key
            jadxCache.remove(eldestKey)?.let { runCatching { it.close() } }
        }
        return jadx
    }

    private fun findDexContaining(sessionId: String, dexPaths: List<String>, className: String): String? {
        classDexIndex[sessionId]?.get(className)?.let { indexedPath ->
            if (indexedPath in dexPaths) {
                return indexedPath
            }
        }
        for (dexPath in dexPaths) {
            val classes = loadDex(sessionId, dexPath)
            if (classes.any { it.className == className }) return dexPath
        }
        return null
    }

    @Synchronized
    fun decompileClass(sessionId: String, dexPaths: List<String>, className: String): String {
        return try {
            val dexPath = findDexContaining(sessionId, dexPaths, className)
                ?: return "// Class not found: $className"
            val jadx = getJadxForSingleDex(sessionId, dexPath)
            val cls = jadx.classes.find { it.fullName == className }
                ?: return "// Class not found: $className"
            cls.code
        } catch (e: OutOfMemoryError) {
            // 清理缓存释放内存
            jadxCache.values.forEach { runCatching { it.close() } }
            jadxCache.clear()
            dexCache.clear()  // 同时清理 DEX 缓存
            System.gc()
            "// OutOfMemoryError: DEX 文件过大无法反编译。\n// 建议：尝试反编译更小的类，或重启应用释放内存。"
        } catch (e: Exception) {
            "// 反编译失败: ${e.message ?: "未知错误"}\n// 类名: $className"
        }
    }

    private fun parseDexBytes(bytes: ByteArray): List<DexClass> {
        val buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)

        val magic = String(bytes, 0, 8)
        if (!magic.startsWith("dex\n")) throw IllegalArgumentException("Not a DEX file")

        buf.position(56)
        val stringIdsSize = buf.int
        val stringIdsOff = buf.int
        val typeIdsSize = buf.int
        val typeIdsOff = buf.int
        val protoIdsSize = buf.int
        val protoIdsOff = buf.int
        val fieldIdsSize = buf.int
        val fieldIdsOff = buf.int
        val methodIdsSize = buf.int
        val methodIdsOff = buf.int
        val classDefsSize = buf.int
        val classDefsOff = buf.int

        fun readString(idx: Int): String {
            buf.position(stringIdsOff + idx * 4)
            val strOff = buf.int
            buf.position(strOff)
            var len = 0
            var shift = 0
            while (true) {
                val b = buf.get().toInt() and 0xFF
                len = len or ((b and 0x7F) shl shift)
                if (b and 0x80 == 0) break
                shift += 7
            }
            val strBytes = ByteArray(len)
            buf.get(strBytes)
            return String(strBytes, Charsets.UTF_8)
        }

        fun readTypeName(typeIdx: Int): String {
            if (typeIdx < 0 || typeIdx >= typeIdsSize) return ""
            buf.position(typeIdsOff + typeIdx * 4)
            val strIdx = buf.int
            return readString(strIdx)
        }

        fun descriptor2Class(desc: String): String {
            return when {
                desc.startsWith("L") && desc.endsWith(";") ->
                    desc.substring(1, desc.length - 1).replace('/', '.')
                desc.startsWith("[") -> desc
                else -> desc
            }
        }

        fun readUleb128(position: Int): Pair<Int, Int> {
            var result = 0
            var shift = 0
            var pos = position
            while (true) {
                val b = bytes[pos++].toInt() and 0xFF
                result = result or ((b and 0x7F) shl shift)
                if (b and 0x80 == 0) break
                shift += 7
            }
            return Pair(result, pos)
        }

        fun countEncodedList(off: Int): Int {
            if (off == 0) return 0
            var (count, _) = readUleb128(off)
            return count
        }

        val ACC_INTERFACE = 0x0200
        val ACC_ABSTRACT  = 0x0400
        val ACC_ENUM      = 0x4000

        val classes = mutableListOf<DexClass>()
        for (i in 0 until classDefsSize) {
            val base = classDefsOff + i * 32
            buf.position(base)
            val classIdx    = buf.int
            val accessFlags = buf.int
            val superIdx    = buf.int
            val interfacesOff = buf.int
            buf.int
            val annotationsOff = buf.int
            val classDataOff   = buf.int
            val staticValuesOff = buf.int

            val className = descriptor2Class(readTypeName(classIdx))
            val superClass = if (superIdx == -1 || superIdx == 0xFFFFFF.toInt() || superIdx >= typeIdsSize) null
                             else descriptor2Class(readTypeName(superIdx))

            val interfaces = mutableListOf<String>()
            if (interfacesOff != 0) {
                buf.position(interfacesOff)
                val ifCount = buf.int
                repeat(ifCount) {
                    val typeIdx = buf.short.toInt() and 0xFFFF
                    interfaces.add(descriptor2Class(readTypeName(typeIdx)))
                }
            }

            var methodCount = 0L
            var fieldCount = 0L
            if (classDataOff != 0) {
                var pos = classDataOff
                val (staticFieldsSize, p1) = readUleb128(pos); pos = p1
                val (instanceFieldsSize, p2) = readUleb128(pos); pos = p2
                val (directMethodsSize, p3) = readUleb128(pos); pos = p3
                val (virtualMethodsSize, p4) = readUleb128(pos); pos = p4
                fieldCount = (staticFieldsSize + instanceFieldsSize).toLong()
                methodCount = (directMethodsSize + virtualMethodsSize).toLong()
            }

            classes.add(
                DexClass(
                    className = className,
                    superClass = superClass,
                    interfaces = interfaces,
                    methodCount = methodCount,
                    fieldCount = fieldCount,
                    isAbstract = accessFlags and ACC_ABSTRACT != 0,
                    isInterface = accessFlags and ACC_INTERFACE != 0,
                    isEnum = accessFlags and ACC_ENUM != 0,
                )
            )
        }
        return classes
    }
}
