import 'dart:async';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/pages/apk_class_view_page.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApkDexPage extends HookConsumerWidget {
  final String? sessionId;
  final List<String> dexPaths;
  final String? packageName;

  const ApkDexPage({
    super.key,
    this.sessionId,
    required this.dexPaths,
    this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sid = sessionId;
    if (sid == null || sid.isEmpty) return const Loading();

    final currentPkg = useState('');
    final pkgStack = useState(<String>[]);
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final searchDebounce = useRef<Timer?>(null);
    final searchFocus = useFocusNode();

    useEffect(() {
      return () => searchDebounce.value?.cancel();
    }, const []);

    return Column(
      children: [
        _SearchBar(
          controller: searchController,
          focusNode: searchFocus,
          onChanged: (value) {
            searchDebounce.value?.cancel();
            searchDebounce.value = Timer(const Duration(milliseconds: 250), () {
              searchQuery.value = value.trim();
            });
          },
          onClear: () {
            searchDebounce.value?.cancel();
            searchController.clear();
            searchQuery.value = '';
            searchFocus.unfocus();
          },
        ),
        if (searchQuery.value.trim().isNotEmpty)
          Expanded(
            child: _SearchResultsLevel(
              sessionId: sid,
              dexPaths: dexPaths,
              keyword: searchQuery.value,
              packageName: packageName,
            ),
          )
        else ...[  
          if (currentPkg.value.isNotEmpty)
            _BreadcrumbBar(
              pkg: currentPkg.value,
              onBack: () {
                final stack = [...pkgStack.value];
                if (stack.isNotEmpty) {
                  currentPkg.value = stack.removeLast();
                  pkgStack.value = stack;
                } else {
                  currentPkg.value = '';
                }
              },
            ),
          Expanded(
            child: _PkgLevel(
              sessionId: sid,
              dexPaths: dexPaths,
              packagePrefix: currentPkg.value,
              packageName: packageName,
              onPackageTap: (sub) {
                final next = currentPkg.value.isEmpty
                    ? sub
                    : '${currentPkg.value}.$sub';
                pkgStack.value = [...pkgStack.value, currentPkg.value];
                currentPkg.value = next;
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: context.l10n.dexSearchHint,
          hintStyle: TextStyle(fontSize: 13.sp),
          prefixIcon: Icon(Icons.search, size: 18.sp),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, size: 16.sp),
                  onPressed: onClear,
                )
              : null,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: context.isDark
              ? context.colorScheme.surfaceContainer
              : Colors.grey.shade100,
        ),
        style: TextStyle(fontSize: 13.sp),
      ),
    );
  }
}

class _SearchResultsLevel extends HookConsumerWidget {
  final String sessionId;
  final List<String> dexPaths;
  final String keyword;
  final String? packageName;

  const _SearchResultsLevel({
    required this.sessionId,
    required this.dexPaths,
    required this.keyword,
    this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchDexClassesProvider(
      sessionId: sessionId,
      dexPaths: dexPaths,
      keyword: keyword,
    ));

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              context.l10n.dexNoClassFound(keyword),
              style: TextStyle(fontSize: 13.sp, color: context.theme.hintColor),
            ),
          );
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final className = results[index];
            return _SearchResultItem(
              className: className,
              sessionId: sessionId,
              dexPaths: dexPaths,
              packageName: packageName,
            );
          },
        );
      },
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(searchDexClassesProvider(
          sessionId: sessionId,
          dexPaths: dexPaths,
          keyword: keyword,
        )),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final String className;
  final String sessionId;
  final List<String> dexPaths;
  final String? packageName;

  const _SearchResultItem({
    required this.className,
    required this.sessionId,
    required this.dexPaths,
    this.packageName,
  });

  String get _shortName => className.contains('.') ? className.split('.').last : className;
  String get _pkg => className.contains('.') ? className.substring(0, className.lastIndexOf('.')) : '';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(Icons.data_object_rounded,
            size: 18.sp, color: context.colorScheme.primary),
      ),
      title: Text(
        _shortName,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _pkg,
        style: TextStyle(
          fontSize: 10.sp,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          size: 18.sp, color: context.theme.hintColor),
      onTap: () {
        Loading.show();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(_shortName)),
              body: ApkClassViewPage(
                sessionId: sessionId,
                dexPaths: dexPaths,
                className: className,
                packageName: packageName,
              ),
            ),
          ),
        ).then((_) => Loading.hide());
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: className));
        ToastMessage.show(context.l10n.dexCopied(className));
      },
    );
  }
}

class _PkgLevel extends HookConsumerWidget {
  final String sessionId;
  final List<String> dexPaths;
  final String packagePrefix;
  final String? packageName;
  final ValueChanged<String> onPackageTap;

  const _PkgLevel({
    required this.sessionId,
    required this.dexPaths,
    required this.packagePrefix,
    this.packageName,
    required this.onPackageTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(getDexPackagesProvider(
      sessionId: sessionId,
      dexPaths: dexPaths,
      packagePrefix: packagePrefix,
    ));
    final classesAsync = ref.watch(getDexClassesProvider(
      sessionId: sessionId,
      dexPaths: dexPaths,
      packageName: packagePrefix,
    ));

    if (packagesAsync.isLoading || classesAsync.isLoading) {
      return const Loading();
    }
    if (packagesAsync.hasError) {
      return RefError(
        onRetry: () {
          ref.invalidate(getDexPackagesProvider(
            sessionId: sessionId,
            dexPaths: dexPaths,
            packagePrefix: packagePrefix,
          ));
        },
      );
    }
    if (classesAsync.hasError) {
      return RefError(
        onRetry: () {
          ref.invalidate(getDexClassesProvider(
            sessionId: sessionId,
            dexPaths: dexPaths,
            packageName: packagePrefix,
          ));
        },
      );
    }

    final packages = packagesAsync.value ?? [];
    final classes = classesAsync.value ?? [];

    return ListView(
      children: [
        ...packages.map(
          (sub) => _PackageItem(
            name: sub,
            onTap: () => onPackageTap(sub),
          ),
        ),
        ...classes.map((cls) => _DexClassItem(
          cls: cls,
          sessionId: sessionId,
          dexPaths: dexPaths,
          packageName: packageName,
        )),
      ],
    );
  }
}

class _BreadcrumbBar extends StatelessWidget {
  final String pkg;
  final VoidCallback onBack;

  const _BreadcrumbBar({required this.pkg, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBack,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                pkg,
                style: TextStyle(
                  fontSize: 11.sp,
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

class _PackageItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _PackageItem({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC107).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child:
            Icon(Icons.folder_rounded, size: 18.sp, color: const Color(0xFFFFC107)),
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18.sp,
        color: Theme.of(context).hintColor,
      ),
      onTap: onTap,
    );
  }
}

class _DexClassItem extends StatelessWidget {
  final DexClass cls;
  final String sessionId;
  final List<String> dexPaths;
  final String? packageName;

  const _DexClassItem({
    required this.cls,
    required this.sessionId,
    required this.dexPaths,
    this.packageName,
  });

  IconData get _icon {
    if (cls.isInterface) return Icons.looks_one_rounded;
    if (cls.isEnum) return Icons.list_alt_rounded;
    if (cls.isAbstract) return Icons.auto_awesome_rounded;
    return Icons.data_object_rounded;
  }

  Color _color(BuildContext context) {
    if (cls.isInterface) return const Color(0xFF4CAF50);
    if (cls.isEnum) return const Color(0xFF9C27B0);
    if (cls.isAbstract) return const Color(0xFFFF9800);
    return context.colorScheme.primary;
  }

  String get _shortName {
    final parts = cls.className.split('.');
    return parts.last;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(_icon, size: 18.sp, color: color),
      ),
      onTap: () {
        Loading.show();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(_shortName)),
              body: ApkClassViewPage(
                sessionId: sessionId,
                dexPaths: dexPaths,
                className: cls.className,
                packageName: packageName,
              ),
            ),
          ),
        ).then((_) {
          Loading.hide();
        });
      },
      onLongPress: () {
        _showCopyMenu(context);
      },
      title: Text(
        _shortName,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: cls.superClass != null && cls.superClass != 'java.lang.Object'
          ? Text(
              'extends ${cls.superClass}',
              style: TextStyle(
                fontSize: 9.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${cls.methodCount}m',
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            '${cls.fieldCount}f',
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  void _showCopyMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(context.l10n.dexCopyShortName, style: TextStyle(fontSize: 14.sp)),
              subtitle: Text(_shortName,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(ctx).hintColor,
                      fontFamily: 'monospace')),
              onTap: () {
                Clipboard.setData(ClipboardData(text: _shortName));
                Navigator.pop(ctx);
                ToastMessage.show(context.l10n.dexCopied(_shortName));
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: Text(context.l10n.dexCopyFullName, style: TextStyle(fontSize: 14.sp)),
              subtitle: Text(cls.className,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(ctx).hintColor,
                      fontFamily: 'monospace'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              onTap: () {
                Clipboard.setData(ClipboardData(text: cls.className));
                Navigator.pop(ctx);
                ToastMessage.show(context.l10n.dexCopied(cls.className));
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  }
