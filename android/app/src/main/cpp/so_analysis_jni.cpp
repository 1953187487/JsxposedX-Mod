#include <jni.h>
#include <string>
#include <vector>
#include <cstring>
#include <android/log.h>

#include "LIEF/ELF.hpp"
#include "capstone/capstone.h"

#define LOG_TAG "SoAnalysisJNI"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

static jstring toJString(JNIEnv* env, const std::string& s) {
    return env->NewStringUTF(s.c_str());
}

extern "C" JNIEXPORT jobject JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_parseSoHeader(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);

    auto bin = LIEF::ELF::Parser::parse(bytes);
    if (!bin) return nullptr;

    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoElfHeaderJni");
    if (!cls) return nullptr;
    jmethodID ctor = env->GetMethodID(cls, "<init>",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJJJJJ)V");
    if (!ctor) return nullptr;

    auto& hdr = bin->header();

    std::string magic = "\177ELF";
    std::string classType = (hdr.identity_class() == LIEF::ELF::Header::CLASS::ELF64) ? "ELF64" : "ELF32";
    std::string encoding = (hdr.identity_data() == LIEF::ELF::Header::ELF_DATA::LSB) ? "Little Endian" : "Big Endian";

    std::string osAbi;
    switch (hdr.identity_os_abi()) {
        case LIEF::ELF::Header::OS_ABI::SYSTEMV: osAbi = "System V"; break;
        case LIEF::ELF::Header::OS_ABI::LINUX:   osAbi = "Linux/GNU"; break;
        default: osAbi = "Unknown(" + std::to_string(static_cast<int>(hdr.identity_os_abi())) + ")"; break;
    }

    std::string fileType;
    switch (hdr.file_type()) {
        case LIEF::ELF::Header::FILE_TYPE::DYN:  fileType = "Shared Object (DYN)"; break;
        case LIEF::ELF::Header::FILE_TYPE::EXEC: fileType = "Executable (EXEC)"; break;
        case LIEF::ELF::Header::FILE_TYPE::REL:  fileType = "Relocatable (REL)"; break;
        default: fileType = "Unknown"; break;
    }

    std::string machine;
    switch (hdr.machine_type()) {
        case LIEF::ELF::ARCH::ARM:    machine = "ARM"; break;
        case LIEF::ELF::ARCH::AARCH64: machine = "AArch64"; break;
        case LIEF::ELF::ARCH::I386:   machine = "x86"; break;
        case LIEF::ELF::ARCH::X86_64: machine = "x86_64"; break;
        default: machine = "Unknown(" + std::to_string(static_cast<int>(hdr.machine_type())) + ")"; break;
    }

    return env->NewObject(cls, ctor,
        toJString(env, magic),
        toJString(env, classType),
        toJString(env, encoding),
        toJString(env, osAbi),
        toJString(env, fileType),
        toJString(env, machine),
        (jlong)hdr.entrypoint(),
        (jlong)hdr.program_headers_offset(),
        (jlong)hdr.section_headers_offset(),
        (jlong)hdr.processor_flag(),
        (jlong)hdr.numberof_segments(),
        (jlong)hdr.numberof_sections()
    );
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getSoSections(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);

    auto bin = LIEF::ELF::Parser::parse(bytes);
    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoSectionJni");
    jmethodID ctor = env->GetMethodID(cls, "<init>", "(Ljava/lang/String;Ljava/lang/String;JJJJ)V");
    if (!bin) return env->NewObjectArray(0, cls, nullptr);

    std::vector<LIEF::ELF::Section*> secs;
    for (auto& s : bin->sections()) secs.push_back(&s);

    jobjectArray arr = env->NewObjectArray((jsize)secs.size(), cls, nullptr);
    for (int i = 0; i < (int)secs.size(); i++) {
        auto* sec = secs[i];
        std::string typeStr = LIEF::ELF::to_string(sec->type());
        jobject obj = env->NewObject(cls, ctor,
            toJString(env, sec->name()),
            toJString(env, typeStr),
            (jlong)sec->offset(),
            (jlong)sec->size(),
            (jlong)(uint64_t)sec->flags(),
            (jlong)sec->alignment()
        );
        env->SetObjectArrayElement(arr, i, obj);
        env->DeleteLocalRef(obj);
    }
    return arr;
}

static jobjectArray symbolsToArray(JNIEnv* env, std::vector<LIEF::ELF::Symbol*> syms) {
    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoSymbolJni");
    jmethodID ctor = env->GetMethodID(cls, "<init>",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJLjava/lang/String;)V");
    jobjectArray arr = env->NewObjectArray((jsize)syms.size(), cls, nullptr);
    for (int i = 0; i < (int)syms.size(); i++) {
        auto* sym = syms[i];
        std::string typeStr = LIEF::ELF::to_string(sym->type());
        std::string bindStr = LIEF::ELF::to_string(sym->binding());
        std::string visStr  = LIEF::ELF::to_string(sym->visibility());
        std::string shndx = (sym->shndx() != 0 && sym->shndx() < 0xff00)
            ? std::to_string(sym->shndx()) : "";
        jobject obj = env->NewObject(cls, ctor,
            toJString(env, sym->name()),
            toJString(env, typeStr),
            toJString(env, bindStr),
            toJString(env, visStr),
            (jlong)sym->value(),
            (jlong)sym->size(),
            toJString(env, shndx)
        );
        env->SetObjectArrayElement(arr, i, obj);
        env->DeleteLocalRef(obj);
    }
    return arr;
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getExportedSymbols(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);
    auto bin = LIEF::ELF::Parser::parse(bytes);
    if (!bin) return env->NewObjectArray(0, env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoSymbolJni"), nullptr);
    std::vector<LIEF::ELF::Symbol*> ptrs;
    for (auto& s : bin->exported_symbols()) ptrs.push_back(&s);
    return symbolsToArray(env, ptrs);
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getImportedSymbols(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);
    auto bin = LIEF::ELF::Parser::parse(bytes);
    if (!bin) return env->NewObjectArray(0, env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoSymbolJni"), nullptr);
    std::vector<LIEF::ELF::Symbol*> ptrs;
    for (auto& s : bin->imported_symbols()) ptrs.push_back(&s);
    return symbolsToArray(env, ptrs);
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getDependencies(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);
    auto bin = LIEF::ELF::Parser::parse(bytes);
    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoDependencyJni");
    jmethodID ctor = env->GetMethodID(cls, "<init>", "(Ljava/lang/String;)V");
    if (!bin) return env->NewObjectArray(0, cls, nullptr);

    std::vector<std::string> libs;
    for (auto& entry : bin->dynamic_entries()) {
        if (entry.tag() == LIEF::ELF::DynamicEntry::TAG::NEEDED) {
            auto* libEntry = static_cast<const LIEF::ELF::DynamicEntryLibrary*>(&entry);
            libs.push_back(libEntry->name());
        }
    }

    jobjectArray arr = env->NewObjectArray((jsize)libs.size(), cls, nullptr);
    for (int i = 0; i < (int)libs.size(); i++) {
        jobject obj = env->NewObject(cls, ctor, toJString(env, libs[i]));
        env->SetObjectArrayElement(arr, i, obj);
        env->DeleteLocalRef(obj);
    }
    return arr;
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getSoStrings(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);
    auto bin = LIEF::ELF::Parser::parse(bytes);
    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoStringJni");
    jmethodID ctor = env->GetMethodID(cls, "<init>", "(JLjava/lang/String;Ljava/lang/String;)V");
    if (!bin) return env->NewObjectArray(0, cls, nullptr);

    std::vector<std::tuple<long, std::string, std::string>> results;
    const std::vector<std::string> targetSections = {".rodata", ".data", ".data.rel.ro"};
    for (auto& secName : targetSections) {
        auto* sec = bin->get_section(secName);
        if (!sec) continue;
        auto content = sec->content();
        size_t start = 0;
        for (size_t j = 0; j <= content.size(); j++) {
            bool end = (j == content.size() || content[j] == 0);
            if (end) {
                if (j - start >= 4) {
                    std::string s((char*)content.data() + start, j - start);
                    bool printable = true;
                    for (unsigned char c : s) {
                        if (c < 0x20 || c > 0x7e) { printable = false; break; }
                    }
                    if (printable) {
                        results.emplace_back((long)(sec->offset() + start), s, secName);
                    }
                }
                start = j + 1;
            }
        }
        if (results.size() >= 2000) break;
    }

    jobjectArray arr = env->NewObjectArray((jsize)results.size(), cls, nullptr);
    int i = 0;
    for (auto& [off, val, sec] : results) {
        jobject obj = env->NewObject(cls, ctor, (jlong)off, toJString(env, val), toJString(env, sec));
        env->SetObjectArrayElement(arr, i++, obj);
        env->DeleteLocalRef(obj);
    }
    return arr;
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_getJniFunctions(
        JNIEnv* env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte* buf = env->GetByteArrayElements(data, nullptr);
    std::vector<uint8_t> bytes((uint8_t*)buf, (uint8_t*)buf + len);
    env->ReleaseByteArrayElements(data, buf, JNI_ABORT);
    auto bin = LIEF::ELF::Parser::parse(bytes);
    jclass cls = env->FindClass("com/jsxposed/x/core/bridge/so_analysis_native/SoJniFunctionJni");
    jmethodID ctor = env->GetMethodID(cls, "<init>", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JZ)V");
    if (!bin) return env->NewObjectArray(0, cls, nullptr);

    std::vector<std::tuple<std::string,std::string,std::string,std::string,long,bool>> results;

    for (auto& sym : bin->exported_symbols()) {
        const std::string& name = sym.name();
        if (name.rfind("Java_", 0) != 0) continue;
        std::string rest = name.substr(5);
        size_t lastUnderscore = rest.rfind('_');
        if (lastUnderscore == std::string::npos) continue;
        std::string classPart = rest.substr(0, lastUnderscore);
        std::string methodPart = rest.substr(lastUnderscore + 1);
        for (char& c : classPart) if (c == '_') c = '.';
        results.emplace_back(name, classPart, methodPart, "", (long)sym.value(), false);
    }

    LIEF::ELF::Symbol* jniOnLoad = nullptr;
    for (auto& sym : bin->exported_symbols()) {
        if (sym.name() == "JNI_OnLoad") { jniOnLoad = &sym; break; }
    }

    if (jniOnLoad && jniOnLoad->value() != 0) {
        auto* textSec = bin->get_section(".text");
        if (textSec) {
            auto content = textSec->content();
            uint64_t secVA = textSec->virtual_address();
            uint64_t fnVA = jniOnLoad->value() & ~1ULL;
            if (fnVA >= secVA && fnVA < secVA + textSec->size()) {
                size_t offset = fnVA - secVA;
                size_t scanLen = std::min((size_t)8192, content.size() - offset);

                bool isArm64 = (bin->header().machine_type() == LIEF::ELF::ARCH::AARCH64);
                cs_arch arch = isArm64 ? CS_ARCH_ARM64 : CS_ARCH_ARM;
                cs_mode mode = isArm64 ? CS_MODE_ARM :
                    ((jniOnLoad->value() & 1) ? CS_MODE_THUMB : CS_MODE_ARM);

                csh handle;
                if (cs_open(arch, mode, &handle) == CS_ERR_OK) {
                    cs_option(handle, CS_OPT_DETAIL, CS_OPT_ON);
                    cs_insn* insns;
                    size_t count = cs_disasm(handle, content.data() + offset, scanLen, fnVA, 0, &insns);

                    std::vector<uint64_t> regNativeSites;
                    for (size_t i = 0; i < count; i++) {
                        std::string mn(insns[i].mnemonic);
                        if (mn != "bl" && mn != "blx" && mn != "blr") continue;
                        for (auto& impSym : bin->imported_symbols()) {
                            if (impSym.name().find("RegisterNatives") != std::string::npos) {
                                regNativeSites.push_back(insns[i].address);
                                break;
                            }
                        }
                    }

                    for (size_t i = 0; i < count; i++) {
                        bool isRegNat = false;
                        for (auto a : regNativeSites) if (insns[i].address == a) { isRegNat = true; break; }
                        if (!isRegNat) continue;
                        results.emplace_back(
                            "dynamic_jni@0x" + std::to_string(insns[i].address),
                            "(dynamic)",
                            "RegisterNatives@0x" + std::to_string(insns[i].address),
                            "",
                            (long)insns[i].address,
                            true
                        );
                    }
                    cs_free(insns, count);
                    cs_close(&handle);
                }
            }
        }
    }

    jobjectArray arr = env->NewObjectArray((jsize)results.size(), cls, nullptr);
    int i = 0;
    for (auto& [sym, cls2, meth, sig, addr, dyn] : results) {
        jobject obj = env->NewObject(cls, ctor,
            toJString(env, sym),
            toJString(env, cls2),
            toJString(env, meth),
            sig.empty() ? nullptr : toJString(env, sig),
            (jlong)addr,
            (jboolean)dyn
        );
        env->SetObjectArrayElement(arr, i++, obj);
        env->DeleteLocalRef(obj);
    }
    return arr;
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_jsxposed_x_core_bridge_so_1analysis_1native_SoAnalysisJni_generateFridaHook(
        JNIEnv* env, jobject,
        jstring jSoName, jstring jSymbolName, jlong address, jboolean isJni) {
    const char* soName = env->GetStringUTFChars(jSoName, nullptr);
    const char* symbolName = env->GetStringUTFChars(jSymbolName, nullptr);

    std::string hook;
    if (isJni) {
        hook = "Interceptor.attach(Module.findExportByName('" + std::string(soName) +
               "', '" + std::string(symbolName) + "'), {\n"
               "  onEnter(args) {\n"
               "    console.log('[" + std::string(symbolName) + "] onEnter');\n"
               "    // args[0] = JNIEnv*, args[1] = jobject/jclass\n"
               "  },\n"
               "  onLeave(retval) {\n"
               "    console.log('[" + std::string(symbolName) + "] onLeave retval =', retval);\n"
               "  }\n"
               "});";
    } else if (address != 0) {
        char addrBuf[32];
        snprintf(addrBuf, sizeof(addrBuf), "0x%llx", (unsigned long long)address);
        hook = "const base = Module.findBaseAddress('" + std::string(soName) + "');\n"
               "Interceptor.attach(base.add(" + std::string(addrBuf) + "), {\n"
               "  onEnter(args) {\n"
               "    console.log('[" + std::string(symbolName) + "] onEnter');\n"
               "  },\n"
               "  onLeave(retval) {\n"
               "    console.log('[" + std::string(symbolName) + "] onLeave retval =', retval);\n"
               "  }\n"
               "});";
    } else {
        hook = "Interceptor.attach(Module.findExportByName('" + std::string(soName) +
               "', '" + std::string(symbolName) + "'), {\n"
               "  onEnter(args) {\n"
               "    console.log('[" + std::string(symbolName) + "] onEnter');\n"
               "  },\n"
               "  onLeave(retval) {\n"
               "    console.log('[" + std::string(symbolName) + "] onLeave retval =', retval);\n"
               "  }\n"
               "});";
    }

    env->ReleaseStringUTFChars(jSoName, soName);
    env->ReleaseStringUTFChars(jSymbolName, symbolName);
    return toJString(env, hook);
}
