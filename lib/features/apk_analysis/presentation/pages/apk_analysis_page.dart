import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/pages/apk_dex_page.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/pages/apk_manifest_page.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/widgets/apk_asset_item.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApkAnalysisPage extends HookConsumerWidget {
  final String packageName;
  final String? sessionId;

  const ApkAnalysisPage({
    super.key,
    required this.packageName,
    this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sid = sessionId;
    if (sid == null || sid.isEmpty) return const Loading();
    final currentPath = useState('');
    final apkAssetsAsync = ref.watch(
      getApkAssetsAtProvider(sessionId: sid, path: currentPath.value),
    );
    final rootAssetsAsync = ref.watch(
      getApkAssetsAtProvider(sessionId: sid, path: ''),
    );

    final allDexPaths = rootAssetsAsync.asData?.value
            .where((a) => !a.isDirectory && a.name.endsWith('.dex'))
            .map((a) => a.path)
            .toList() ??
        [];

    return apkAssetsAsync.when(
      data: (items) {
        return Column(
          children: [
            if (currentPath.value.isNotEmpty)
              _BreadcrumbBar(
                path: currentPath.value,
                onBack: () {
                  final parts = currentPath.value.split('/')
                    ..removeWhere((e) => e.isEmpty);
                  parts.removeLast();
                  currentPath.value = parts.isEmpty ? '' : '${parts.join('/')}/';
                },
              ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ApkAssetItem(
                    asset: items[index],
                    onTap: items[index].isDirectory
                        ? () => currentPath.value = items[index].path
                        : items[index].name == 'AndroidManifest.xml'
                            ? () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      appBar: AppBar(title: const Text('AndroidManifest.xml')),
                                      body: ApkManifestPage(sessionId: sid),
                                    ),
                                  ),
                                )
                            : items[index].name.endsWith('.dex')
                                ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => Scaffold(
                                          appBar: AppBar(title: const Text('DEX Classes')),
                                          body: ApkDexPage(
                                            sessionId: sid,
                                            dexPaths: allDexPaths.isNotEmpty
                                                ? allDexPaths
                                                : [items[index].path],
                                            packageName: packageName,
                                          ),
                                        ),
                                      ),
                                    )
                                : items[index].name.endsWith('.so')
                                    ? () => context.push(
                                          HomeRoute.toSoAnalysis(
                                              packageName: packageName),
                                          extra: {
                                            'sessionId': sid,
                                            'soPath': items[index].path,
                                          },
                                        )
                                    : null,
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (error, stack) => RefError(
        onRetry: () => ref.invalidate(
          getApkAssetsAtProvider(sessionId: sid, path: currentPath.value),
        ),
      ),
      loading: () => const Loading(),
    );
  }
}

class _BreadcrumbBar extends StatelessWidget {
  final String path;
  final VoidCallback onBack;

  const _BreadcrumbBar({required this.path, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBack,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                path,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).hintColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
