import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:JsxposedX/features/ai/infrastructure/environments/apk_reverse_ai_environment.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ai_conversation_export_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_action_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/features/so_analysis/presentation/providers/so_analysis_provider.dart';

class ApkReverseAiEnvironmentKey {
  const ApkReverseAiEnvironmentKey({
    required this.packageName,
    required this.isZh,
  });

  final String packageName;
  final bool isZh;

  @override
  bool operator ==(Object other) =>
      other is ApkReverseAiEnvironmentKey &&
      other.packageName == packageName &&
      other.isZh == isZh;

  @override
  int get hashCode => Object.hash(packageName, isZh);
}

final apkReverseAiEnvironmentV2Provider = FutureProvider.autoDispose
    .family<ApkReverseAiEnvironment, ApkReverseAiEnvironmentKey>((
      ref,
      key,
    ) async {
      final environment = ApkReverseAiEnvironment(
        packageName: key.packageName,
        isZh: key.isZh,
        apkActionRepository: ref.watch(apkAnalysisActionRepositoryProvider),
        apkQueryRepository: ref.watch(apkAnalysisQueryRepositoryProvider),
        soDataSource: ref.watch(soAnalysisDatasourceProvider),
        conversationBinding: ref.watch(scriptConversationBindingProvider),
        exportService: ref.watch(aiConversationExportServiceProvider),
      );
      ref.onDispose(() => unawaited(environment.dispose()));
      await environment.initialize();
      return environment;
    });

final aiReverseConversationV2Provider = StateProvider.family<String?, String>(
  (ref, packageName) => null,
);
