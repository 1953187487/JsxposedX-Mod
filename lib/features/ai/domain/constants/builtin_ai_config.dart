import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';

const String builtinAiConfigId = 'builtin_closeai_default';
const String builtinAiConfigName = '沐雪接口';
const String builtinAiConfigBaseUrl = 'https://v2.muxueai.pro';

/// 内置服务的历史域名 → 现役域名。
///
/// 老版本会把 apiUrl 连同 override 一起落盘，仅改常量无法让已安装用户生效，
/// 因此在内置配置的读取路径上按此表做一次升级。
const Map<String, String> builtinAiConfigLegacyHosts = {
  'muxueai.pro': 'v2.muxueai.pro',
};

/// 将内置服务的历史域名改写为现役域名；无变更时原样返回。
///
/// 仅替换 host，保留路径、端口与查询参数，避免误伤用户自定义的
/// 第三方地址（只在内置配置的 id 下调用）。
String normalizeBuiltinAiConfigUrl(String rawUrl) {
  final trimmed = rawUrl.trim();
  if (trimmed.isEmpty) return rawUrl;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return rawUrl;
  final upgradedHost = builtinAiConfigLegacyHosts[uri.host.toLowerCase()];
  if (upgradedHost == null) return rawUrl;
  return uri.replace(host: upgradedHost).toString();
}

// IDs retired from the built-in catalog. They remain recognized only during
// migration so an old selection cannot reappear as a custom configuration.
const Set<String> retiredBuiltinAiConfigIds = {'builtin_closeai_kimi_k25'};

class BuiltinAiConfigSpec {
  const BuiltinAiConfigSpec({
    required this.id,
    required this.name,
    required this.apiUrl,
    required this.moduleName,
    required this.maxToken,
    required this.temperature,
    required this.memoryRounds,
    required this.apiType,
    required this.apiKeyStorageKey,
    required this.statusLabel,
    required this.badgeLabels,
    this.purchaseUrl,
  });

  final String id;
  final String name;
  final String apiUrl;
  final String moduleName;
  final int maxToken;
  final double temperature;
  final double memoryRounds;
  final AiApiType apiType;
  final String apiKeyStorageKey;
  final String statusLabel;
  final List<String> badgeLabels;
  final String? purchaseUrl;

  AiConfig toConfig({String apiKey = ''}) {
    return AiConfig(
      id: id,
      name: name,
      apiKey: apiKey,
      apiUrl: apiUrl,
      moduleName: moduleName,
      maxToken: maxToken,
      temperature: temperature,
      memoryRounds: memoryRounds,
      apiType: apiType,
    );
  }
}

const List<BuiltinAiConfigSpec> builtinAiConfigSpecs = [
  BuiltinAiConfigSpec(
    id: builtinAiConfigId,
    name: builtinAiConfigName,
    apiUrl: builtinAiConfigBaseUrl,
    moduleName: 'gpt-5.4',
    maxToken: 4096,
    temperature: 1.0,
    memoryRounds: 6,
    apiType: AiApiType.openai,
    apiKeyStorageKey: 'ai_builtin_api_key',
    statusLabel: 'GPT-MAX',
    badgeLabels: ['Claude', 'ChatGPT', '国产'],
    purchaseUrl: 'https://muxueai.pro',
  ),
];

BuiltinAiConfigSpec get defaultBuiltinAiConfigSpec =>
    builtinAiConfigSpecs.first;

BuiltinAiConfigSpec? getBuiltinAiConfigSpecById(String id) {
  for (final spec in builtinAiConfigSpecs) {
    if (spec.id == id) {
      return spec;
    }
  }
  return null;
}

AiConfig buildBuiltinAiConfig({
  String id = builtinAiConfigId,
  String apiKey = '',
}) {
  final spec = getBuiltinAiConfigSpecById(id) ?? defaultBuiltinAiConfigSpec;
  return spec.toConfig(apiKey: apiKey);
}

List<AiConfig> buildBuiltinAiConfigs() {
  return builtinAiConfigSpecs
      .map((spec) => spec.toConfig())
      .toList(growable: false);
}

String builtinApiKeyStorageKeyForId(String id) {
  return (getBuiltinAiConfigSpecById(id) ?? defaultBuiltinAiConfigSpec)
      .apiKeyStorageKey;
}

bool isBuiltinAiConfigId(String id) => getBuiltinAiConfigSpecById(id) != null;

bool isRetiredBuiltinAiConfigId(String id) =>
    retiredBuiltinAiConfigIds.contains(id);

bool isBuiltinAiConfig(AiConfig config) => isBuiltinAiConfigId(config.id);
