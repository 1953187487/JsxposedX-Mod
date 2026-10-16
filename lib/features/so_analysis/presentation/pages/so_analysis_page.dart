import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/so_analysis/presentation/providers/so_analysis_provider.dart';
import 'package:JsxposedX/generated/so_analysis.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SoAnalysisPage extends HookConsumerWidget {
  final String sessionId;
  final String soPath;
  final String packageName;

  const SoAnalysisPage({
    super.key,
    required this.sessionId,
    required this.soPath,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final tabs = [
      'ELF Info',
      'Exports',
      'Imports',
      'JNI',
      'Strings',
      'Sections',
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(soPath.split('/').last),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
            onTap: (i) => tabIndex.value = i,
          ),
        ),
        body: IndexedStack(
          index: tabIndex.value,
          children: [
            _ElfInfoTab(sessionId: sessionId, soPath: soPath),
            _SymbolsTab(
              sessionId: sessionId,
              soPath: soPath,
              exported: true,
              packageName: packageName,
            ),
            _SymbolsTab(
              sessionId: sessionId,
              soPath: soPath,
              exported: false,
              packageName: packageName,
            ),
            _JniTab(
              sessionId: sessionId,
              soPath: soPath,
              packageName: packageName,
            ),
            _StringsTab(sessionId: sessionId, soPath: soPath),
            _SectionsTab(sessionId: sessionId, soPath: soPath),
          ],
        ),
      ),
    );
  }
}

class _ElfInfoTab extends HookConsumerWidget {
  final String sessionId;
  final String soPath;

  const _ElfInfoTab({required this.sessionId, required this.soPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerAsync = ref.watch(
      parseSoHeaderProvider(sessionId: sessionId, soPath: soPath),
    );
    final depsAsync = ref.watch(
      getDependenciesProvider(sessionId: sessionId, soPath: soPath),
    );

    return headerAsync.when(
      loading: () => const Loading(),
      error: (e, _) {
        return RefError(
          error: e,
          onRetry: () => ref.invalidate(
            parseSoHeaderProvider(sessionId: sessionId, soPath: soPath),
          ),
        );
      },
      data: (hdr) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'ELF Header',
            children: [
              _InfoRow('Magic', hdr.magic),
              _InfoRow('Class', hdr.classType),
              _InfoRow('Encoding', hdr.dataEncoding),
              _InfoRow('OS/ABI', hdr.osAbi),
              _InfoRow('Type', hdr.fileType),
              _InfoRow('Machine', hdr.machine),
              _InfoRow('Entry Point', '0x${hdr.entryPoint.toRadixString(16)}'),
              _InfoRow('Flags', '0x${hdr.flags.toRadixString(16)}'),
              _InfoRow('Program Headers', hdr.programHeaderCount.toString()),
              _InfoRow('Section Headers', hdr.sectionHeaderCount.toString()),
            ],
          ),
          const SizedBox(height: 16),
          depsAsync.when(
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
            data: (deps) => _Section(
              title: 'Dependencies (DT_NEEDED)',
              children: deps.isEmpty
                  ? [const _InfoRow('(none)', '')]
                  : deps.map((d) => _InfoRow(d.name, '')).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SymbolsTab extends HookConsumerWidget {
  final String sessionId;
  final String soPath;
  final bool exported;
  final String packageName;

  const _SymbolsTab({
    required this.sessionId,
    required this.soPath,
    required this.exported,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symsAsync = exported
        ? ref.watch(
            getExportedSymbolsProvider(sessionId: sessionId, soPath: soPath),
          )
        : ref.watch(
            getImportedSymbolsProvider(sessionId: sessionId, soPath: soPath),
          );
    final search = useState('');

    return symsAsync.when(
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => exported
            ? ref.invalidate(
                getExportedSymbolsProvider(
                  sessionId: sessionId,
                  soPath: soPath,
                ),
              )
            : ref.invalidate(
                getImportedSymbolsProvider(
                  sessionId: sessionId,
                  soPath: soPath,
                ),
              ),
      ),
      data: (syms) {
        final filtered = search.value.isEmpty
            ? syms
            : syms
                  .where(
                    (s) => s.name.toLowerCase().contains(
                      search.value.toLowerCase(),
                    ),
                  )
                  .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search symbols...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (v) => search.value = v,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (ctx, i) => _SymbolTile(
                  sym: filtered[i],
                  sessionId: sessionId,
                  soPath: soPath,
                  packageName: packageName,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SymbolTile extends HookConsumerWidget {
  final SoSymbol sym;
  final String sessionId;
  final String soPath;
  final String packageName;

  const _SymbolTile({
    required this.sym,
    required this.sessionId,
    required this.soPath,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      title: Text(
        sym.name,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
      subtitle: Text(
        '${sym.type} • ${sym.binding} • 0x${sym.address.toRadixString(16)}'
        '${sym.size > 0 ? ' • ${sym.size}B' : ''}',
        style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.smart_toy_rounded, size: 16),
        tooltip: context.l10n.soAskAi,
        onPressed: () {
          final soName = soPath.split('/').last;
          final prompt = '分析 $soName 中的符号 ${sym.name}，地址 0x${sym.address.toRadixString(16)}，类型 ${sym.type}，请解释其用途并生成 Frida Hook 代码';
          ref.read(aiChatRuntimeProvider(packageName: packageName).notifier).send(prompt);
          ToastMessage.show(context.l10n.soSentToAi(sym.name));
        },
      ),
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: sym.name));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}


class _JniTab extends HookConsumerWidget {
  final String sessionId;
  final String soPath;
  final String packageName;

  const _JniTab({
    required this.sessionId,
    required this.soPath,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jniAsync = ref.watch(
      getJniFunctionsProvider(sessionId: sessionId, soPath: soPath),
    );

    return jniAsync.when(
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(
          getJniFunctionsProvider(sessionId: sessionId, soPath: soPath),
        ),
      ),
      data: (fns) => fns.isEmpty
          ? const Center(child: Text('No JNI functions found'))
          : ListView.builder(
              itemCount: fns.length,
              itemBuilder: (ctx, i) {
                final fn = fns[i];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    fn.isDynamic
                        ? Icons.dynamic_feed_rounded
                        : Icons.functions_rounded,
                    size: 16,
                    color: fn.isDynamic ? Colors.orange : Colors.blue,
                  ),
                  title: Text(
                    fn.javaMethod,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text(
                    '${fn.javaClass}\n0x${fn.address.toRadixString(16)}'
                    '${fn.isDynamic ? ' • dynamic' : ' • static'}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.smart_toy_rounded, size: 16),
                    tooltip: context.l10n.soAskAi,
                    onPressed: () {
                      final soName = soPath.split('/').last;
                      final prompt = '分析 $soName 中的 JNI 函数 ${fn.symbolName}，对应 Java 方法 ${fn.javaClass}.${fn.javaMethod}，地址 0x${fn.address.toRadixString(16)}，请解释其用途并生成 Frida Hook 代码';
                      ref.read(aiChatRuntimeProvider(packageName: packageName).notifier).send(prompt);
                      ToastMessage.show(context.l10n.soSentToAi(fn.symbolName));
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _StringsTab extends HookConsumerWidget {
  final String sessionId;
  final String soPath;

  const _StringsTab({required this.sessionId, required this.soPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strsAsync = ref.watch(
      getSoStringsProvider(sessionId: sessionId, soPath: soPath),
    );
    final search = useState('');

    return strsAsync.when(
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(
          getSoStringsProvider(sessionId: sessionId, soPath: soPath),
        ),
      ),
      data: (strs) {
        final filtered = search.value.isEmpty
            ? strs
            : strs
                  .where(
                    (s) => s.value.toLowerCase().contains(
                      search.value.toLowerCase(),
                    ),
                  )
                  .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search strings...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (v) => search.value = v,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final s = filtered[i];
                  return ListTile(
                    dense: true,
                    title: Text(
                      s.value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                    subtitle: Text(
                      '${s.section}  offset: 0x${s.offset.toRadixString(16)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: s.value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionsTab extends HookConsumerWidget {
  final String sessionId;
  final String soPath;

  const _SectionsTab({required this.sessionId, required this.soPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secsAsync = ref.watch(
      getSoSectionsProvider(sessionId: sessionId, soPath: soPath),
    );

    return secsAsync.when(
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(
          getSoSectionsProvider(sessionId: sessionId, soPath: soPath),
        ),
      ),
      data: (secs) => ListView.builder(
        itemCount: secs.length,
        itemBuilder: (ctx, i) {
          final sec = secs[i];
          return ListTile(
            dense: true,
            title: Text(
              sec.name.isEmpty ? '(unnamed)' : sec.name,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            subtitle: Text(
              '${sec.type}  offset: 0x${sec.offset.toRadixString(16)}  size: ${sec.size}B  align: ${sec.alignment}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).hintColor,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
