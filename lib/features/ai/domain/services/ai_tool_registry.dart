import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/environments/apk_reverse_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/script_lifecycle_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/content_production_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/data_analysis_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/system_control_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/multimodal_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/environments/shell_exec_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';

/// 工具类别（封装标准 §2.1，快捷菜单按此分组）
enum AiToolCategory {
  /// APK 逆向分析（现有 12 工具）
  reverse,

  /// 脚本生成全生命周期
  scriptLifecycle,

  /// 内容生产处理
  contentProduction,

  /// 数据分析处理
  dataAnalysis,

  /// 系统交互管控
  systemControl,

  /// 多模态处理
  multimodal,
}

/// 危险等级三分法（封装标准 §3.1：仅写操作为危险）
enum AiToolDangerLevel {
  /// 纯计算/纯文本生成，零副作用
  pure,

  /// 读文件/读系统状态
  read,

  /// 写文件/改持久状态/系统变更（默认 isRisky）
  write,
}

/// 单个工具注册项：schema 定义 + handler 工厂 + 执行策略，三件配对、单一事实源。
class AiToolRegistration {
  const AiToolRegistration({
    required this.definition,
    required this.category,
    required this.danger,
    required this.handlerFactory,
    this.timeout = const Duration(seconds: 30),
    this.retryable = false,
    this.isSoTool = false,
  });

  final AiToolDefinition definition;
  final AiToolCategory category;
  final AiToolDangerLevel danger;

  /// handler 延迟构造工厂（环境装配时传入运行时上下文）
  final AiChatToolHandler Function(ApkReverseToolRuntimeContext ctx)
  handlerFactory;

  /// 执行超时（封装标准 §4.2 超时矩阵）
  final Duration timeout;

  /// 失败是否允许自动重试一次（read 类瞬时错误；write 类禁止）
  final bool retryable;

  /// 是否属于 SO 分析工具集（includeSoTools 协商开关）
  final bool isSoTool;
}

/// 工具注册表：全部工具在此集中注册，definitions / handlers / UI 分组 / 超时策略
/// 均从本表派生，杜绝「schema 有而 handler 无」的注册漂移。
class AiToolRegistry {
  AiToolRegistry._();

  /// APK 逆向场景全部工具注册项
  static List<AiToolRegistration> apkReverse({bool includeSoTools = true}) => [
    AiToolRegistration(
      definition: AiToolDefinition(
        name: 'get_manifest',
        description: '获取 APK 的完整 Manifest 信息，包括权限、四大组件、SDK 版本、debuggable 等',
        descriptionEn:
            'Get the full APK Manifest, including permissions, components, SDK versions, debuggable flag, etc.',
        parameters: ToolParametersBuilder.empty(),
      ),
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetManifestToolHandler.new,
    ),
    AiToolRegistration(
      definition: _decompileClass,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: DecompileClassToolHandler.new,
    ),
    AiToolRegistration(
      definition: _getSmali,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetSmaliToolHandler.new,
    ),
    AiToolRegistration(
      definition: _listPackages,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: ListPackagesToolHandler.new,
    ),
    AiToolRegistration(
      definition: _listClasses,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: ListClassesToolHandler.new,
    ),
    AiToolRegistration(
      definition: _searchClasses,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: SearchClassesToolHandler.new,
    ),
    AiToolRegistration(
      definition: _listApkFiles,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: ListApkFilesToolHandler.new,
    ),
    if (includeSoTools) ..._soTools,
  ];

  static final List<AiToolRegistration> _soTools = [
    AiToolRegistration(
      definition: _getSoInfo,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetSoInfoToolHandler.new,
      timeout: const Duration(seconds: 120),
      retryable: true,
      isSoTool: true,
    ),
    AiToolRegistration(
      definition: _searchSoSymbols,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: SearchSoSymbolsToolHandler.new,
      timeout: const Duration(seconds: 120),
      retryable: true,
      isSoTool: true,
    ),
    AiToolRegistration(
      definition: _getJniFunctions,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetJniFunctionsToolHandler.new,
      timeout: const Duration(seconds: 120),
      retryable: true,
      isSoTool: true,
    ),
    AiToolRegistration(
      definition: _searchSoStrings,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.read,
      handlerFactory: SearchSoStringsToolHandler.new,
      timeout: const Duration(seconds: 120),
      retryable: true,
      isSoTool: true,
    ),
    AiToolRegistration(
      definition: _generateSoHook,
      category: AiToolCategory.reverse,
      danger: AiToolDangerLevel.pure,
      handlerFactory: GenerateSoHookToolHandler.new,
      timeout: const Duration(seconds: 10),
      isSoTool: true,
    ),
  ];

  // ---- 工具 schema 定义（自 apk_reverse_tool_definitions.dart 迁入） ----

  static final _decompileClass = AiToolDefinition(
    name: 'decompile_class',
    description: '反编译指定类为 Java 源代码。需要提供完整类名（如 com.example.app.MainActivity）',
    descriptionEn:
        'Decompile the specified class into Java source code. Requires the fully qualified class name (e.g., com.example.app.MainActivity).',
    parameters:
        (ToolParametersBuilder()
              ..addString('className', '要反编译的类的全限定名', required: true))
            .build(),
  );

  static final _getSmali = AiToolDefinition(
    name: 'get_smali',
    description: '获取指定类的 Smali 字节码。适合需要查看底层实现细节的场景',
    descriptionEn:
        'Get the Smali bytecode for the specified class. Useful for inspecting low-level implementation details.',
    parameters:
        (ToolParametersBuilder()
              ..addString('className', '要查看的类的全限定名', required: true))
            .build(),
  );

  static final _listPackages = AiToolDefinition(
    name: 'list_packages',
    description:
        '列出指定前缀下的子包名。传空字符串列出顶层包。注意：此工具只用于浏览包结构，不能搜索关键词。如果需要搜索类，使用 search_classes',
    descriptionEn:
        'List sub-packages under a given prefix. Pass an empty string for top-level packages. Note: this tool only browses package structure, not keyword search. Use search_classes to find classes.',
    parameters:
        (ToolParametersBuilder()..addString(
              'prefix',
              '包名前缀，如 "com.example"，空字符串表示顶层',
              required: true,
            ))
            .build(),
  );

  static final _listClasses = AiToolDefinition(
    name: 'list_classes',
    description:
        '列出指定包下的所有类，返回类名、方法数、字段数、是否抽象/接口/枚举等信息。注意：此工具需要精确的包名，不能搜索关键词。如果不知道包名，使用 search_classes',
    descriptionEn:
        'List all classes under the specified package, returning class names, method/field counts, and flags such as abstract/interface/enum. Requires an exact package name; use search_classes if unsure.',
    parameters:
        (ToolParametersBuilder()..addString(
              'packageName',
              '包名，如 "com.example.app"',
              required: true,
            ))
            .build(),
  );

  static final _searchClasses = AiToolDefinition(
    name: 'search_classes',
    description:
        '在所有包中搜索类名包含指定关键词的类，返回匹配的全限定类名列表。用于查找 VIP、支付、登录、加密等功能相关的类。重要：严格使用用户提到的关键词，不要自己发明新关键词',
    descriptionEn:
        'Search all packages for classes whose names contain the given keyword and return matching fully-qualified class names. Use it to locate classes related to VIP, payment, login, encryption, etc. Important: use only the keywords the user mentioned; do not invent new ones.',
    parameters:
        (ToolParametersBuilder()..addString(
              'keyword',
              '搜索关键词，不区分大小写，如 "vip"、"pay"、"login"、"encrypt"',
              required: true,
            ))
            .build(),
  );

  static final _listApkFiles = AiToolDefinition(
    name: 'list_apk_files',
    description:
        '列出 APK 内指定目录下的文件和子目录。传空字符串列出根目录，传 "lib/" 列出所有架构目录，传 "lib/arm64-v8a/" 列出该架构下的所有 SO 文件。分析 Native 层前先用此工具确认 SO 文件路径',
    descriptionEn:
        'List files and subdirectories under the given path inside the APK. Pass an empty string for the root, "lib/" for architecture folders, or "lib/arm64-v8a/" for all SO files of that ABI. Use this before analyzing the native layer to confirm SO paths.',
    parameters:
        (ToolParametersBuilder()..addString(
              'path',
              '目录路径，如 ""（根目录）、"lib/"、"lib/arm64-v8a/"',
              required: true,
            ))
            .build(),
  );

  static final _getSoInfo = AiToolDefinition(
    name: 'get_so_info',
    description: '获取指定 SO 文件的基本信息，包括 ELF 头信息、架构、依赖库、导出/导入符号数量、JNI 函数数量等',
    descriptionEn:
        'Get basic information about the specified SO file, including ELF header, architecture, dependencies, exported/imported symbol counts, and JNI function count.',
    parameters:
        (ToolParametersBuilder()..addString(
              'soPath',
              'SO 文件在 APK 中的路径，如 "lib/arm64-v8a/libnative.so"',
              required: true,
            ))
            .build(),
  );

  static final _searchSoSymbols = AiToolDefinition(
    name: 'search_so_symbols',
    description: '在 SO 文件中搜索符号（函数名），支持搜索导出和导入符号。用于查找加密、签名、校验等关键函数',
    descriptionEn:
        'Search symbols (function names) in an SO file, covering both exported and imported symbols. Useful for locating key functions for encryption, signing, and verification.',
    parameters:
        (ToolParametersBuilder()
              ..addString('soPath', 'SO 文件路径', required: true)
              ..addString(
                'keyword',
                '搜索关键词，如 "encrypt"、"sign"、"check"',
                required: true,
              ))
            .build(),
  );

  static final _getJniFunctions = AiToolDefinition(
    name: 'get_jni_functions',
    description:
        '获取 SO 文件中的所有 JNI 函数列表，包括静态注册和动态注册的 JNI 函数，返回 Java 类名、方法名、地址等信息',
    descriptionEn:
        'List all JNI functions in the SO file, including statically and dynamically registered ones, returning Java class names, method names, addresses, etc.',
    parameters:
        (ToolParametersBuilder()
              ..addString('soPath', 'SO 文件路径', required: true))
            .build(),
  );

  static final _searchSoStrings = AiToolDefinition(
    name: 'search_so_strings',
    description: '在 SO 文件中搜索字符串，用于查找加密密钥、API URL、调试信息等敏感字符串',
    descriptionEn:
        'Search strings in the SO file to locate sensitive strings such as encryption keys, API URLs, and debug messages.',
    parameters:
        (ToolParametersBuilder()
              ..addString('soPath', 'SO 文件路径', required: true)
              ..addString(
                'keyword',
                '搜索关键词，如 "key"、"http"、"password"',
                required: true,
              ))
            .build(),
  );

  static final _generateSoHook = AiToolDefinition(
    name: 'generate_so_hook',
    description: '为指定的 SO 符号生成 Frida Hook 代码模板，包括参数解析、返回值修改等',
    descriptionEn:
        'Generate a Frida hook code template for the specified SO symbol, including argument parsing and return-value modification.',
    parameters:
        (ToolParametersBuilder()
              ..addString('soPath', 'SO 文件路径', required: true)
              ..addString('symbolName', '符号名称', required: true)
              ..addString(
                'address',
                '符号地址（十六进制字符串，如 "0x1234"）',
                required: true,
              ))
            .build(),
    // 可执行 Hook 代码属于敏感能力，即使只返回文本也必须先获得用户确认。
    isRisky: true,
  );

  // ---- 脚本生命周期工具定义 ----

  static final _genXposedHook = AiToolDefinition(
    name: 'generate_xposed_hook',
    description: '为指定 Java 类/方法生成 Jx 糖 Xposed Hook 脚本模板。缺省方法名时生成所有方法的枚举骨架。',
    descriptionEn:
        'Generate a Jx sugar Xposed Hook script template for a specific Java class/method. If no method name is given, enumerates all method skeletons.',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'className',
                '要 Hook 的类全限定名 / Fully qualified class name to hook',
                required: true,
              )
              ..addString(
                'methodName',
                '方法名 / Method name (optional; omit to enumerate all methods)',
                required: false,
              )
              ..addStringArray(
                'parameterTypes',
                '参数类型列表如 ["int", "String"] / Parameter type list e.g. ["int", "String"]',
                required: false,
              )
              ..addString(
                'hookType',
                'Hook 模式 / Hook mode',
                enumValues: ['before_after', 'before', 'after', 'replace'],
                required: false,
              ))
            .build(),
  );

  static final _genFridaHook = AiToolDefinition(
    name: 'generate_frida_hook',
    description:
        '使用 Fx API 生成 Frida Hook 代码。支持三种模式：javaMethod（Java方法 Hook）、jniSymbol（JNI 符号 Hook）、address（地址 Hook）。调用前必须先向用户询问是否确认生成，未获得明确肯定答复不得调用。',
    descriptionEn:
        'Generate Frida Hook code using the Fx API. Supports three modes: javaMethod (Java method hook), jniSymbol (JNI symbol hook), address (address-based hook). Ask for explicit user confirmation before calling; do not call without an affirmative reply.',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'mode',
                '模板模式 / Template mode',
                enumValues: ['javaMethod', 'jniSymbol', 'address'],
                required: true,
              )
              ..addString(
                'className',
                'Java 类全限定名（javaMethod 模式必填）',
                required: false,
              )
              ..addString(
                'methodName',
                'Java 方法名（javaMethod 模式必填）',
                required: false,
              )
              ..addStringArray('parameterTypes', '参数类型列表（可选）', required: false)
              ..addString(
                'soPath',
                'SO 文件路径如 lib/arm64-v8a/libnative.so（jniSymbol/address 模式必填）',
                required: false,
              )
              ..addString('symbolName', '符号名称（jniSymbol 模式必填）', required: false)
              ..addString(
                'address',
                '十六进制地址如 0x1234（address 模式必填）',
                required: false,
              ))
            .build(),
    isRisky: true,
  );

  static final _saveScript = AiToolDefinition(
    name: 'save_script',
    description: '将脚本保存部署到目标包。优先使用 use_last_generated=true 引用缓存脚本，避免重复传输代码。',
    descriptionEn:
        'Save and deploy a script to the target package. Prefer use_last_generated=true to reference cached script, avoiding code duplication.',
    parameters:
        (ToolParametersBuilder()
              ..addBoolean(
                'use_last_generated',
                '使用最近生成的脚本（推荐） / Use recently generated script (recommended)',
                required: false,
              )
              ..addString(
                'scriptType',
                '脚本类型（use_last_generated=true 时可省略） / Script type (optional when use_last_generated=true)',
                enumValues: ['frida', 'xposed'],
                required: false,
              )
              ..addString(
                'fileName',
                '脚本文件名（use_last_generated=true 时可省略） / Script file name (optional when use_last_generated=true)',
                required: false,
              )
              ..addString(
                'code',
                '完整脚本代码（仅当 use_last_generated=false 时需要） / Full script code (only when use_last_generated=false)',
                required: false,
              )
              ..addBoolean(
                'overwrite',
                '完整覆盖同名文件 / Fully replace an existing file',
                required: false,
              ))
            .build(),
  );

  static final _listScripts = AiToolDefinition(
    name: 'list_scripts',
    description: '列出目标包已有脚本及启用状态（AI 的环境感知）。可选过滤 scriptType。',
    descriptionEn:
        'List existing scripts for the target package with enable/disable status (environment awareness for AI). Optionally filter by scriptType.',
    parameters:
        (ToolParametersBuilder()..addString(
              'scriptType',
              '脚本类型过滤 / Filter by script type',
              enumValues: ['frida', 'xposed'],
              required: false,
            ))
            .build(),
  );

  static final _toggleScript = AiToolDefinition(
    name: 'toggle_script',
    description: '启用或停用指定脚本（影响下次注入行为）。',
    descriptionEn:
        'Enable or disable a specified script (affects next injection).',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'scriptType',
                '脚本类型 / Script type',
                enumValues: ['frida', 'xposed'],
                required: true,
              )
              ..addString(
                'fileName',
                '脚本文件名 / Script file name',
                required: true,
              )
              ..addBoolean(
                'enabled',
                '是否启用 / Whether to enable',
                required: true,
              ))
            .build(),
  );

  static final _validateScript = AiToolDefinition(
    name: 'validate_script',
    description: '校验脚本语法。优先使用 use_last_generated=true 引用缓存脚本，避免重复传输代码。',
    descriptionEn:
        'Validate script syntax. Prefer use_last_generated=true to reference cached script, avoiding code duplication.',
    parameters:
        (ToolParametersBuilder()
              ..addBoolean(
                'use_last_generated',
                '使用最近生成的脚本（推荐） / Use recently generated script (recommended)',
                required: false,
              )
              ..addString(
                'code',
                '待校验的脚本代码（仅当 use_last_generated=false 时需要） / Script code to validate (only when use_last_generated=false)',
                required: false,
              )
              ..addString(
                'engine',
                '脚本引擎（use_last_generated=true 时可省略） / Script engine (optional when use_last_generated=true)',
                enumValues: ['frida', 'xposed'],
                required: false,
              ))
            .build(),
  );

  static final _readScript = AiToolDefinition(
    name: 'read_script',
    description: '读取已存在脚本的完整内容（AI 修改/迭代前置条件）。',
    descriptionEn:
        'Read the full content of an existing script (prerequisite for AI modification/iteration).',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'scriptType',
                '脚本类型 / Script type',
                enumValues: ['frida', 'xposed'],
                required: true,
              )
              ..addString(
                'fileName',
                '脚本文件名 / Script file name',
                required: true,
              ))
            .build(),
  );

  static final _deleteScript = AiToolDefinition(
    name: 'delete_script',
    description: '删除指定脚本文件（需 confirm=true 二次确认，拒绝删除保留文件 hook.js/loader.js）。',
    descriptionEn:
        'Delete a specified script file (requires confirm=true for confirmation; refuses to delete reserved files hook.js/loader.js).',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'scriptType',
                '脚本类型 / Script type',
                enumValues: ['frida', 'xposed'],
                required: true,
              )
              ..addString(
                'fileName',
                '脚本文件名 / Script file name',
                required: true,
              )
              ..addBoolean(
                'confirm',
                '确认删除 / Confirm deletion (must be true)',
                required: true,
              ))
            .build(),
  );

  // ---- 脚本生命周期工具注册 ----

  /// 脚本生命周期全部工具注册项
  static final _getScriptLogs = AiToolDefinition(
    name: 'get_script_logs',
    description: '读取当前 AI 会话关联的脚本运行日志，支持 run、脚本、来源、级别和游标过滤。',
    descriptionEn:
        'Read script logs associated with the current AI conversation, with run, script, source, level, and cursor filters.',
    parameters: (ToolParametersBuilder()
          ..addString('runId', '运行 ID / Run ID')
          ..addString('scriptName', '脚本名 / Script name')
          ..addString('source', '来源：xposed 或 frida / Source')
          ..addString('level', '级别 / Level')
          ..addInteger('limit', '返回条数，默认 50，最大 500 / Page size')
          ..addString('before', '时间游标 ISO-8601 / Timestamp cursor')
          ..addInteger('beforeId', '数据库 ID 游标 / Database ID cursor'))
        .build(),
  );

  static List<AiToolRegistration> scriptLifecycle() => [
    AiToolRegistration(
      definition: _getScriptLogs,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetScriptLogsHandler.new,
    ),
    AiToolRegistration(
      definition: _genXposedHook,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.pure,
      handlerFactory: GenerateXposedHookHandler.new,
      timeout: const Duration(seconds: 10),
    ),
    AiToolRegistration(
      definition: _genFridaHook,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.pure,
      handlerFactory: GenerateFridaHookHandler.new,
      timeout: const Duration(seconds: 10),
    ),
    AiToolRegistration(
      definition: _validateScript,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.pure,
      handlerFactory: ValidateScriptHandler.new,
      timeout: const Duration(seconds: 15),
    ),
    AiToolRegistration(
      definition: _saveScript,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.write,
      handlerFactory: SaveScriptHandler.new,
      timeout: const Duration(seconds: 15),
    ),
    AiToolRegistration(
      definition: _listScripts,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.read,
      handlerFactory: ListScriptsHandler.new,
    ),
    AiToolRegistration(
      definition: _toggleScript,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.write,
      handlerFactory: ToggleScriptHandler.new,
      timeout: const Duration(seconds: 10),
    ),
    AiToolRegistration(
      definition: _readScript,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.read,
      handlerFactory: ReadScriptHandler.new,
    ),
    AiToolRegistration(
      definition: _deleteScript,
      category: AiToolCategory.scriptLifecycle,
      danger: AiToolDangerLevel.write,
      handlerFactory: DeleteScriptHandler.new,
      timeout: const Duration(seconds: 10),
    ),
  ];

  // ---- 内容生产工具定义 ----

  static final _exportConversation = AiToolDefinition(
    name: 'export_conversation',
    description: '导出当前会话为 Markdown 文件。',
    descriptionEn: 'Export the current conversation as a Markdown file.',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'format',
                '导出格式 / Format',
                enumValues: ['markdown', 'json'],
                required: false,
              )
              ..addBoolean(
                'includeToolCalls',
                '是否包含工具调用 / Include tool calls',
                required: false,
              )
              ..addString('fileName', '文件名 / File name', required: false))
            .build(),
  );

  static final _generateReport = AiToolDefinition(
    name: 'generate_analysis_report',
    description: '汇总会话中的分析成果生成结构化逆向分析报告；preview 直接返回内容，save 落盘为 Markdown 文件。',
    descriptionEn:
        'Summarize analysis findings from the session into a structured reverse engineering report; preview returns content, save writes a Markdown file.',
    parameters:
        (ToolParametersBuilder()
              ..addStringArray('sections', '所需章节 / Sections', required: false)
              ..addString(
                'format',
                '格式 / Format',
                enumValues: ['preview', 'save'],
                required: false,
              ))
            .build(),
  );

  static final _saveNote = AiToolDefinition(
    name: 'save_note',
    description: '将分析笔记保存为 Markdown 文件（存于本地 notes 目录）。',
    descriptionEn:
        'Save an analysis note as a Markdown file in the local notes directory.',
    parameters:
        (ToolParametersBuilder()
              ..addString('title', '笔记标题 / Note title', required: true)
              ..addString(
                'content',
                '笔记内容（Markdown）/ Note content (Markdown)',
                required: true,
              ))
            .build(),
  );

  // ---- 数据分析工具定义 ----

  static final _analyzeManifest = AiToolDefinition(
    name: 'analyze_manifest',
    description: 'Manifest 风险体检：危险权限分级、导出组件暴露面、debuggable/allowBackup 风险。',
    descriptionEn:
        'Manifest risk scan: dangerous permission grading, exported component exposure, debuggable/allowBackup risks.',
    parameters:
        (ToolParametersBuilder()..addString(
              'focus',
              '分析焦点 / Focus',
              enumValues: ['permissions', 'components', 'all'],
              required: false,
            ))
            .build(),
  );

  static final _detectPackers = AiToolDefinition(
    name: 'detect_packers',
    description: '加固/壳识别（360、梆梆、爱加密、腾讯乐固等），输出壳类型与脱壳建议。',
    descriptionEn:
        'Packer detection (360, Bangcle, Ijiami, Tencent Legu, etc.), with packer type and unpacking suggestions.',
    parameters: ToolParametersBuilder.empty(),
  );

  static final _detectSdk = AiToolDefinition(
    name: 'detect_sdk',
    description: '第三方 SDK 识别（推送/统计/广告等），基于包名前缀特征库。',
    descriptionEn:
        'Third-party SDK identification (push/analytics/ads) based on package prefix signatures.',
    parameters: ToolParametersBuilder.empty(),
  );

  static final _searchCodePatterns = AiToolDefinition(
    name: 'search_code_patterns',
    description: '跨类代码模式搜索：批量扫描方法调用特征（如加密、签名校验）。',
    descriptionEn:
        'Cross-class code pattern search: batch scan for method call signatures (e.g., encryption, signature verification).',
    parameters:
        (ToolParametersBuilder()
              ..addString('pattern', '搜索正则 / Search regex', required: true)
              ..addStringArray(
                'classNames',
                '限定类名列表 / Class name filter',
                required: false,
              )
              ..addInteger(
                'maxClasses',
                '最大扫描类数 / Max classes',
                required: false,
              ))
            .build(),
  );

  // ---- 系统管控工具定义 ----

  static final _readFile = AiToolDefinition(
    name: 'read_file',
    description: '读取设备上任意路径的文件内容（文本返回正文，图片/二进制返回信息与保存路径）。',
    descriptionEn:
        'Read a file at any path on the device (text returns content; image/binary returns info and saved path).',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'path',
                '文件绝对路径 / Absolute file path',
                required: true,
              )
              ..addInteger(
                'maxBytes',
                '文本最大读取字节数 / Max bytes for text',
                required: false,
              ))
            .build(),
  );

  static final _getDeviceInfo = AiToolDefinition(
    name: 'get_device_info',
    description: '环境感知：ABI、Android 版本、Root 状态、Zygisk/LSPosed 状态等。',
    descriptionEn:
        'Environment awareness: ABI, Android version, Root status, Zygisk/LSPosed status, etc.',
    parameters: ToolParametersBuilder.empty(),
  );

  static final _targetAppControl = AiToolDefinition(
    name: 'target_app_control',
    description: '拉起/停止/重启目标应用（验证脚本注入效果的前置操作）。',
    descriptionEn:
        'Launch/stop/restart the target app (prerequisite for verifying script injection).',
    parameters:
        (ToolParametersBuilder()..addString(
              'action',
              '操作 / Action',
              enumValues: ['launch', 'stop', 'restart'],
              required: true,
            ))
            .build(),
  );

  static final _listInstalledApps = AiToolDefinition(
    name: 'list_installed_apps',
    description: '列出设备已装应用（非当前会话目标），辅助切换分析对象。',
    descriptionEn:
        'List installed apps on the device (not current target), assists switching analysis targets.',
    parameters:
        (ToolParametersBuilder()
              ..addString('keyword', '搜索关键词 / Search keyword', required: false)
              ..addBoolean(
                'includeSystem',
                '是否含系统应用 / Include system apps',
                required: false,
              ))
            .build(),
  );

  static final _readTargetLogs = AiToolDefinition(
    name: 'read_target_logs',
    description: '读取目标 App 的 logcat（系统级日志）。',
    descriptionEn: 'Read logcat for the target app (system-level logs).',
    parameters:
        (ToolParametersBuilder()
              ..addString('keyword', '过滤关键词 / Filter keyword', required: false)
              ..addString(
                'level',
                '日志级别 / Log level',
                enumValues: ['V', 'D', 'I', 'W', 'E'],
                required: false,
              )
              ..addInteger('limit', '最大行数 / Max lines', required: false)
              ..addBoolean(
                'includeFramework',
                '是否包含框架日志 / Include framework logs',
                required: false,
              ))
            .build(),
  );

  static final _readFrameworkLogs = AiToolDefinition(
    name: 'read_framework_logs',
    description: '读取 Xposed/Frida 框架的日志输出（包含 Jx.log 和 Fx.log）。',
    descriptionEn: 'Read Xposed/Frida framework logs (including Jx.log and Fx.log).',
    parameters:
        (ToolParametersBuilder()
              ..addString('keyword', '过滤关键词 / Filter keyword', required: false)
              ..addString(
                'level',
                '日志级别 / Log level',
                enumValues: ['V', 'D', 'I', 'W', 'E'],
                required: false,
              )
              ..addInteger('limit', '最大行数 / Max lines', required: false)
              ..addString(
                'scriptType',
                '脚本类型 / Script type',
                enumValues: ['xposed', 'frida'],
                required: false,
              ))
            .build(),
  );

  // ---- 多模态工具定义 ----

  static final _captureScreenshot = AiToolDefinition(
    name: 'capture_screenshot',
    description: '截取当前屏幕并保存为 PNG 文件，返回文件路径（需 root）。',
    descriptionEn:
        'Capture the current screen and save it as a PNG file, returning the file path (requires root).',
    parameters: ToolParametersBuilder.empty(),
  );

  static final _dumpUiHierarchy = AiToolDefinition(
    name: 'dump_ui_hierarchy',
    description: 'dump 目标 App 当前界面视图树（类名/资源id/文本）。',
    descriptionEn:
        'Dump the target app current UI view hierarchy (class names, resource IDs, text content).',
    parameters:
        (ToolParametersBuilder()
              ..addInteger('maxDepth', '最大深度 / Max depth', required: false)
              ..addString(
                'filterById',
                '按资源ID过滤 / Filter by resource ID',
                required: false,
              ))
            .build(),
  );

  static final _extractApkResource = AiToolDefinition(
    name: 'extract_apk_resource',
    description: '从目标应用 APK 中提取指定路径的资源文件到本地。',
    descriptionEn:
        'Extract a resource file at the given path from the target app APK to local storage.',
    parameters:
        (ToolParametersBuilder()..addString(
              'resourcePath',
              'APK 内资源路径（如 res/drawable/icon.png）/ Resource path inside APK',
              required: true,
            ))
            .build(),
  );

  // ---- 内容生产工具注册 ----

  static List<AiToolRegistration> contentProduction() => [
    AiToolRegistration(
      definition: _exportConversation,
      category: AiToolCategory.contentProduction,
      danger: AiToolDangerLevel.read,
      handlerFactory: ExportConversationHandler.new,
    ),
    AiToolRegistration(
      definition: _generateReport,
      category: AiToolCategory.contentProduction,
      danger: AiToolDangerLevel.pure,
      handlerFactory: GenerateAnalysisReportHandler.new,
    ),
    AiToolRegistration(
      definition: _saveNote,
      category: AiToolCategory.contentProduction,
      danger: AiToolDangerLevel.write,
      handlerFactory: SaveNoteHandler.new,
      timeout: const Duration(seconds: 10),
    ),
  ];

  // ---- 数据分析工具注册 ----

  static List<AiToolRegistration> dataAnalysis() => [
    AiToolRegistration(
      definition: _analyzeManifest,
      category: AiToolCategory.dataAnalysis,
      danger: AiToolDangerLevel.read,
      handlerFactory: AnalyzeManifestHandler.new,
    ),
    AiToolRegistration(
      definition: _detectPackers,
      category: AiToolCategory.dataAnalysis,
      danger: AiToolDangerLevel.read,
      handlerFactory: DetectPackersHandler.new,
    ),
    AiToolRegistration(
      definition: _detectSdk,
      category: AiToolCategory.dataAnalysis,
      danger: AiToolDangerLevel.read,
      handlerFactory: DetectSdkHandler.new,
    ),
    AiToolRegistration(
      definition: _searchCodePatterns,
      category: AiToolCategory.dataAnalysis,
      danger: AiToolDangerLevel.read,
      handlerFactory: SearchCodePatternsHandler.new,
      timeout: const Duration(seconds: 120),
      retryable: true,
    ),
  ];

  // ---- shell 工具定义 ----

  static final _shellExec = AiToolDefinition(
    name: 'shell_exec',
    description:
        '执行 shell 命令（可选 su root 权限）。读取项目 API 手册时，仅使用 grep、sed、awk 等只读命令检索关键章节，不要一次性读取整份手册；生成 Frida/Xposed 脚本前必须先检索对应手册。常用命令：\n- pm list packages [keyword] 列出已装应用\n- am start -n pkg/activity 启动应用\n- am force-stop pkg 停止应用\n- logcat -d --pid=<pid> 读取日志\n- getprop ro.build.version.sdk 获取 SDK 版本\n- screencap -p /sdcard/screen.png 截图',
    descriptionEn:
        'Execute a shell command (optional su root). When reading the project API manual, use only read-only commands like grep, sed, awk to look up key sections; do not read the full manual at once. Before generating a Frida/Xposed script, always look up the corresponding manual first. Common commands:\n- pm list packages [keyword] list installed apps\n- am start -n pkg/activity launch app\n- am force-stop pkg stop app\n- logcat -d --pid=<pid> read logs\n- getprop ro.build.version.sdk get SDK version\n- screencap -p /sdcard/screen.png screenshot',
    parameters:
        (ToolParametersBuilder()
              ..addString(
                'command',
                '完整的 shell 命令 / Full shell command',
                required: true,
              )
              ..addBoolean(
                'useSu',
                '是否使用 su root 权限 / Use su for root access',
                required: false,
              )
              ..addInteger(
                'timeoutSeconds',
                '超时秒数默认15 / Timeout seconds default 15',
                required: false,
              ))
            .build(),
  );

  // ---- 系统管控工具注册 ----

  static List<AiToolRegistration> systemControl() => [
    AiToolRegistration(
      definition: _readFile,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: ReadFileToolHandler.new,
    ),
    AiToolRegistration(
      definition: _getDeviceInfo,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: GetDeviceInfoHandler.new,
    ),
    AiToolRegistration(
      definition: _targetAppControl,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: TargetAppControlHandler.new,
    ),
    AiToolRegistration(
      definition: _listInstalledApps,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: ListInstalledAppsHandler.new,
    ),
    AiToolRegistration(
      definition: _readTargetLogs,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: ReadTargetLogsHandler.new,
    ),
    AiToolRegistration(
      definition: _readFrameworkLogs,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.read,
      handlerFactory: ReadFrameworkLogsHandler.new,
    ),
    AiToolRegistration(
      definition: _shellExec,
      category: AiToolCategory.systemControl,
      danger: AiToolDangerLevel.write,
      handlerFactory: ShellExecToolHandler.new,
      timeout: const Duration(seconds: 60),
    ),
  ];

  // ---- 多模态工具注册 ----

  static List<AiToolRegistration> multimodal() => [
    AiToolRegistration(
      definition: _captureScreenshot,
      category: AiToolCategory.multimodal,
      danger: AiToolDangerLevel.read,
      handlerFactory: CaptureScreenshotHandler.new,
    ),
    AiToolRegistration(
      definition: _dumpUiHierarchy,
      category: AiToolCategory.multimodal,
      danger: AiToolDangerLevel.read,
      handlerFactory: DumpUiHierarchyHandler.new,
    ),
    AiToolRegistration(
      definition: _extractApkResource,
      category: AiToolCategory.multimodal,
      danger: AiToolDangerLevel.read,
      handlerFactory: ExtractApkResourceHandler.new,
    ),
  ];

  // ---- 注册表查询 API ----

  static final Map<String, AiToolRegistration> _allByName = {
    for (final r in apkReverse()) r.definition.name: r,
    for (final r in scriptLifecycle()) r.definition.name: r,
    for (final r in contentProduction()) r.definition.name: r,
    for (final r in dataAnalysis()) r.definition.name: r,
    for (final r in systemControl()) r.definition.name: r,
    for (final r in multimodal()) r.definition.name: r,
  };

  /// 按工具名查找注册项（不限场景）
  static AiToolRegistration? byName(String toolName) => _allByName[toolName];

  /// 按工具名查询类别（UI 分组用，未注册返回 null）
  static AiToolCategory? categoryOf(String toolName) =>
      _allByName[toolName]?.category;

  /// 按工具名查询危险等级（未注册视为 read 保守处理）
  static AiToolDangerLevel dangerOf(String toolName) =>
      _allByName[toolName]?.danger ?? AiToolDangerLevel.read;
}
