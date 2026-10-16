import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/common/widgets/run_app_button.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/crypto_js_generator.dart';
import 'package:JsxposedX/features/project/domain/models/crypto_rule.dart';
import 'package:JsxposedX/features/project/presentation/pages/crypto/tabs/code_crypto_editor_tab.dart';
import 'package:JsxposedX/features/project/presentation/pages/crypto/tabs/visual_crypto_editor_tab.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';

class CryptoAuditJsEditorPage extends HookConsumerWidget {
  final String packageName;

  const CryptoAuditJsEditorPage({super.key, required this.packageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> customKeywords = const [
      'onIntercept',
      'JxCrypto',
      'JxCrypto.replaceWithString',
      'JxCrypto.hexToString',
      'JxCrypto.stringToHex'
    ];
    // TODO: 使用 L10n 替换固定文本
    final l10n = context.l10n;

    final rulesState = useState<List<CryptoRule>>([]);
    final initialized = useState(false);

    // 初始化内容，后续可以在这获取原有脚本或新建默认模板
    final editorController = useMemoized(
      () => CodeLineEditingController.fromText(''),
    );

    // 确保控制器被释放
    useEffect(() {
      return () => editorController.dispose();
    }, [editorController]);

    // 监听 Provider 的状态，获取到代码后初始化给控制器
    ref.listen<AsyncValue<String>>(
      auditLogJsCodeProvider(packageName: packageName),
      (previous, next) {
        final code = next.value;
        if (!initialized.value && code != null) {
          editorController.text = code;
          rulesState.value = CryptoJsGenerator.parseRules(code);
          initialized.value = true;
        }
      },
    );

    final jsCodeAsync = ref.watch(
      auditLogJsCodeProvider(packageName: packageName),
    );
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hook Script"),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.visualRulesTab),
              Tab(text: l10n.codeSourceTab),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: l10n.save,
              onPressed: () {
                ref.read(
                  saveAuditLogJsCodeProvider(
                    packageName: packageName,
                    code: editorController.text,
                  ),
                );
              },
            ),
            RunAppButton(
              packageName: packageName,
              onClick: () {
                ref.read(
                  saveAuditLogJsCodeProvider(
                    packageName: packageName,
                    code: editorController.text,
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: jsCodeAsync.when(
                  data: (_) {
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(), // 禁用滑动切换，防止和代码编辑器滑动冲突
                      children: [
                        VisualCryptoEditorTab(
                          rules: rulesState.value,
                          onChanged: (newRules) {
                            rulesState.value = newRules;
                            final newCode = CryptoJsGenerator.generateJsCode(newRules, editorController.text);
                            editorController.text = newCode;
                            // 立即同步回 Provider 确保持久化
                            ref.read(saveAuditLogJsCodeProvider(
                              packageName: packageName,
                              code: newCode,
                            ));
                          },
                        ),
                        CodeCryptoEditorTab(
                          controller: editorController,
                          customKeywords: customKeywords,
                        ),
                      ],
                    );
                  },
                  error: (error, stack) {
                    return RefError(
                      error: error,
                      onRetry: () => ref.invalidate(
                        auditLogJsCodeProvider(packageName: packageName),
                      ),
                    );
                  },
                  loading: () => const Loading(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
