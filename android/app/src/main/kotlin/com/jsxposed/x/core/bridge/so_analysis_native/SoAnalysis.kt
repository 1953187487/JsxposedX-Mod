package com.jsxposed.xmod.core.bridge.so_analysis_native

import android.content.Context
import java.util.zip.ZipFile

data class SoElfHeaderJni(
    val magic: String,
    val classType: String,
    val dataEncoding: String,
    val osAbi: String,
    val fileType: String,
    val machine: String,
    val entryPoint: Long,
    val programHeaderOffset: Long,
    val sectionHeaderOffset: Long,
    val flags: Long,
    val programHeaderCount: Long,
    val sectionHeaderCount: Long,
)

data class SoSectionJni(
    val name: String,
    val type: String,
    val offset: Long,
    val size: Long,
    val flags: Long,
    val alignment: Long,
)

data class SoSymbolJni(
    val name: String,
    val type: String,
    val binding: String,
    val visibility: String,
    val address: Long,
    val size: Long,
    val shndx: String?,
)

data class SoDependencyJni(val name: String)

data class SoJniFunctionJni(
    val symbolName: String,
    val javaClass: String,
    val javaMethod: String,
    val signature: String?,
    val address: Long,
    val isDynamic: Boolean,
)

data class SoStringJni(
    val offset: Long,
    val value: String,
    val section: String,
)

object SoAnalysisJni {
    init {
        System.loadLibrary("so_analysis")
    }

    external fun parseSoHeader(data: ByteArray): SoElfHeaderJni?
    external fun getSoSections(data: ByteArray): Array<SoSectionJni>
    external fun getExportedSymbols(data: ByteArray): Array<SoSymbolJni>
    external fun getImportedSymbols(data: ByteArray): Array<SoSymbolJni>
    external fun getDependencies(data: ByteArray): Array<SoDependencyJni>
    external fun getSoStrings(data: ByteArray): Array<SoStringJni>
    external fun getJniFunctions(data: ByteArray): Array<SoJniFunctionJni>
    external fun generateFridaHook(soName: String, symbolName: String, address: Long, isJni: Boolean): String
}

class SoAnalysis(private val context: Context) {
    companion object {
        private const val MAX_CACHED_SO_FILES = 2
        private const val MAX_SO_BYTES = 32L * 1024L * 1024L
        private const val MAX_RESULT_ENTRIES = 20_000
    }

    private val apkSessions = mutableMapOf<String, String>()
    
    // 缓存 SO 文件字节数据，避免重复读取 APK
    private val soBytesCache = mutableMapOf<String, ByteArray>()
    
    // 缓存解析结果，避免重复解析
    private val headerCache = mutableMapOf<String, SoElfHeader>()
    private val sectionsCache = mutableMapOf<String, List<SoSection>>()
    private val exportedSymbolsCache = mutableMapOf<String, List<SoSymbol>>()
    private val importedSymbolsCache = mutableMapOf<String, List<SoSymbol>>()
    private val dependenciesCache = mutableMapOf<String, List<SoDependency>>()
    private val stringsCache = mutableMapOf<String, List<SoString>>()
    private val jniFunctionsCache = mutableMapOf<String, List<SoJniFunction>>()
    private val cacheAccessOrder = LinkedHashMap<String, Unit>(4, 0.75f, true)

    @Synchronized
    fun registerSession(sessionId: String, apkPath: String) {
        apkSessions[sessionId] = apkPath
    }
    
    @Synchronized
    fun clearSession(sessionId: String) {
        apkSessions.remove(sessionId)
        cacheAccessOrder.keys
            .filter { it.startsWith("$sessionId::") }
            .forEach(::evictCacheKey)
    }

    @Synchronized
    fun clearAll() {
        cacheAccessOrder.keys.toList().forEach(::evictCacheKey)
        apkSessions.clear()
    }

    private fun getCacheKey(sessionId: String, soPath: String): String = "$sessionId::$soPath"

    private fun touchCacheKey(cacheKey: String) {
        cacheAccessOrder[cacheKey] = Unit
        while (cacheAccessOrder.size > MAX_CACHED_SO_FILES) {
            evictCacheKey(cacheAccessOrder.entries.first().key)
        }
    }

    private fun evictCacheKey(cacheKey: String) {
        cacheAccessOrder.remove(cacheKey)
        soBytesCache.remove(cacheKey)
        headerCache.remove(cacheKey)
        sectionsCache.remove(cacheKey)
        exportedSymbolsCache.remove(cacheKey)
        importedSymbolsCache.remove(cacheKey)
        dependenciesCache.remove(cacheKey)
        stringsCache.remove(cacheKey)
        jniFunctionsCache.remove(cacheKey)
    }

    private fun readSoBytes(sessionId: String, soPath: String): ByteArray {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return soBytesCache.getOrPut(cacheKey) {
            val apkPath = apkSessions[sessionId]
                ?: throw IllegalStateException("SO session not found: $sessionId")
            ZipFile(apkPath).use { zip ->
                val entry = zip.getEntry(soPath)
                    ?: throw IllegalArgumentException("Entry not found: $soPath")
                require(entry.size <= MAX_SO_BYTES) {
                    "SO file is too large to analyze: ${entry.size} bytes"
                }
                zip.getInputStream(entry).readBytes()
            }
        }
    }

    @Synchronized
    fun parseSoHeader(sessionId: String, soPath: String): SoElfHeader {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return headerCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            val jni = SoAnalysisJni.parseSoHeader(bytes)
                ?: throw IllegalStateException("Failed to parse ELF header")
            SoElfHeader(
                magic = jni.magic,
                classType = jni.classType,
                dataEncoding = jni.dataEncoding,
                osAbi = jni.osAbi,
                fileType = jni.fileType,
                machine = jni.machine,
                entryPoint = jni.entryPoint,
                programHeaderOffset = jni.programHeaderOffset,
                sectionHeaderOffset = jni.sectionHeaderOffset,
                flags = jni.flags,
                programHeaderCount = jni.programHeaderCount,
                sectionHeaderCount = jni.sectionHeaderCount,
            )
        }
    }

    @Synchronized
    fun getSoSections(sessionId: String, soPath: String): List<SoSection> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return sectionsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getSoSections(bytes).asSequence().take(MAX_RESULT_ENTRIES).map {
                SoSection(name = it.name, type = it.type, offset = it.offset, size = it.size, flags = it.flags, alignment = it.alignment)
            }.toList()
        }
    }

    @Synchronized
    fun getExportedSymbols(sessionId: String, soPath: String): List<SoSymbol> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return exportedSymbolsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getExportedSymbols(bytes).asSequence().take(MAX_RESULT_ENTRIES).map {
                SoSymbol(name = it.name, type = it.type, binding = it.binding, visibility = it.visibility, address = it.address, size = it.size, shndx = it.shndx)
            }.toList()
        }
    }

    @Synchronized
    fun getImportedSymbols(sessionId: String, soPath: String): List<SoSymbol> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return importedSymbolsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getImportedSymbols(bytes).asSequence().take(MAX_RESULT_ENTRIES).map {
                SoSymbol(name = it.name, type = it.type, binding = it.binding, visibility = it.visibility, address = it.address, size = it.size, shndx = it.shndx)
            }.toList()
        }
    }

    @Synchronized
    fun getDependencies(sessionId: String, soPath: String): List<SoDependency> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return dependenciesCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getDependencies(bytes).asSequence().take(MAX_RESULT_ENTRIES)
                .map { SoDependency(name = it.name) }.toList()
        }
    }

    @Synchronized
    fun getSoStrings(sessionId: String, soPath: String): List<SoString> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return stringsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getSoStrings(bytes).asSequence().take(MAX_RESULT_ENTRIES).map {
                SoString(offset = it.offset, value = it.value, section = it.section)
            }.toList()
        }
    }

    @Synchronized
    fun getJniFunctions(sessionId: String, soPath: String): List<SoJniFunction> {
        val cacheKey = getCacheKey(sessionId, soPath)
        touchCacheKey(cacheKey)
        return jniFunctionsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getJniFunctions(bytes).asSequence().take(MAX_RESULT_ENTRIES).map {
                SoJniFunction(
                    symbolName = it.symbolName,
                    javaClass = it.javaClass,
                    javaMethod = it.javaMethod,
                    signature = it.signature,
                    address = it.address,
                    isDynamic = it.isDynamic,
                )
            }.toList()
        }
    }

    fun generateFridaHook(sessionId: String, soPath: String, symbolName: String, address: Long): String {
        val soName = soPath.substringAfterLast('/')
        val isJni = symbolName.startsWith("Java_")
        return SoAnalysisJni.generateFridaHook(soName, symbolName, address, isJni)
    }
}
