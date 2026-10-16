import 'dart:async';
import 'dart:convert';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/logcat_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _kSourceFilters = [
  (value: 'session'),
  (value: 'frida'),
  (value: 'xposed'),
  (value: 'app'),
  (value: 'framework'),
  (value: 'system'),
];

const _kLevelFilters = [(value: 'D'), (value: 'I'), (value: 'W'), (value: 'E')];

/// 复制的日志条数上限，避免超长文本写入剪贴板时卡顿或失败。
const _kMaxCopyEntries = 5000;

/// 统一封装普通检索与正则检索，供过滤和命中高亮复用。
class _SearchMatcher {
  final RegExp? regex;
  final String? needle;
  final bool caseSensitive;

  const _SearchMatcher({this.regex, this.needle, required this.caseSensitive});

  bool matches(String haystack) {
    final pattern = regex;
    if (pattern != null) return pattern.hasMatch(haystack);
    final target = needle;
    if (target == null) return true;
    return caseSensitive
        ? haystack.contains(target)
        : haystack.toLowerCase().contains(target);
  }

  /// 把 [text] 按命中位置切分为高亮与非高亮片段。
  List<TextSpan> split(String text, TextStyle base, TextStyle highlight) {
    if (text.isEmpty) return [TextSpan(text: text, style: base)];
    final spans = <TextSpan>[];
    final pattern = regex;
    if (pattern != null) {
      var last = 0;
      for (final match in pattern.allMatches(text)) {
        if (match.end == match.start) continue;
        if (match.start > last) {
          spans.add(TextSpan(text: text.substring(last, match.start), style: base));
        }
        spans.add(
          TextSpan(text: text.substring(match.start, match.end), style: highlight),
        );
        last = match.end;
      }
      if (last < text.length) {
        spans.add(TextSpan(text: text.substring(last), style: base));
      }
    } else {
      final target = needle!;
      if (target.isEmpty) return [TextSpan(text: text, style: base)];
      final haystack = caseSensitive ? text : text.toLowerCase();
      final probe = caseSensitive ? target : target.toLowerCase();
      var last = 0;
      var index = haystack.indexOf(probe);
      while (index >= 0) {
        if (index > last) {
          spans.add(TextSpan(text: text.substring(last, index), style: base));
        }
        spans.add(
          TextSpan(text: text.substring(index, index + probe.length), style: highlight),
        );
        last = index + probe.length;
        index = haystack.indexOf(probe, last);
      }
      if (last < text.length) {
        spans.add(TextSpan(text: text.substring(last), style: base));
      }
    }
    if (spans.isEmpty) spans.add(TextSpan(text: text, style: base));
    return spans;
  }
}

class LogcatPanelView extends HookConsumerWidget {
  final bool isFullscreen;
  final VoidCallback onToggleFullscreen;

  const LogcatPanelView({
    super.key,
    required this.isFullscreen,
    required this.onToggleFullscreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logEntries = ref.watch(logcatProvider);
    final logcatNotifier = ref.read(logcatProvider.notifier);
    final autoScroll = logcatNotifier.isAutoScroll;
    final searchQuery = logcatNotifier.searchQuery;
    final scrollController = useScrollController();
    final selectedSource = useState<String?>(null);
    final selectedLevel = useState<String?>(null);
    final regexEnabled = useState(false);
    final caseSensitive = useState(false);
    final showHistory = useState(false);
    final historyLoading = useState(false);
    final historyHasMore = useState(false);
    final historyError = useState<String?>(null);
    final historyLogs = useState<List<ScriptLogRecord>>([]);
    final conversationId =
        logcatNotifier.sessionConversationId ??
        ref.watch(scriptConversationBindingProvider).conversationId;
    final repository = ref.watch(scriptLogRepositoryProvider);
    final historyCursor = historyLogs.value.isEmpty
        ? null
        : historyLogs.value.last;
    final historyRequestGeneration = useRef(0);

    Future<void> loadHistory({bool older = false}) async {
      if (conversationId == null ||
          conversationId.isEmpty ||
          historyLoading.value) {
        return;
      }
      final generation = ++historyRequestGeneration.value;
      final requestConversationId = conversationId;
      final last = older ? historyCursor : null;
      historyLoading.value = true;
      historyError.value = null;
      try {
        if (!older) await logcatNotifier.flushPersistedLogs();
        final page = await repository.getLogs(
          conversationId: requestConversationId,
          before: last?.timestamp,
          beforeId: last?.id,
          limit: 100,
        );
        if (generation != historyRequestGeneration.value ||
            conversationId != requestConversationId) {
          return;
        }
        historyHasMore.value = page.length == 100;
        if (older) {
          historyLogs.value = [...historyLogs.value, ...page];
        } else {
          historyLogs.value = page;
        }
      } catch (error) {
        if (generation == historyRequestGeneration.value &&
            conversationId == requestConversationId) {
          historyError.value = error.toString();
        }
      } finally {
        if (generation == historyRequestGeneration.value) {
          historyLoading.value = false;
        }
      }
    }

    useEffect(() {
      historyRequestGeneration.value++;
      historyLoading.value = false;
      historyLogs.value = [];
      historyHasMore.value = false;
      historyError.value = null;
      if (showHistory.value) unawaited(loadHistory());
      return null;
    }, [conversationId, showHistory.value, repository]);
    final searchDebounce = useRef<Timer?>(null);

    useEffect(() {
      return () => searchDebounce.value?.cancel();
    }, const []);

    // 检索匹配器：普通检索与正则检索统一封装，正则非法时返回 null 并单独提示。
    final searchMatcher = useMemoized(() {
      if (searchQuery.isEmpty) return null;
      if (regexEnabled.value) {
        try {
          return _SearchMatcher(
            regex: RegExp(searchQuery, caseSensitive: caseSensitive.value),
            caseSensitive: caseSensitive.value,
          );
        } catch (_) {
          return null;
        }
      }
      return _SearchMatcher(
        needle: caseSensitive.value ? searchQuery : searchQuery.toLowerCase(),
        caseSensitive: caseSensitive.value,
      );
    }, [searchQuery, regexEnabled.value, caseSensitive.value]);

    final hasRegexError = useMemoized(() {
      if (!regexEnabled.value || searchQuery.isEmpty) return false;
      try {
        RegExp(searchQuery);
        return false;
      } catch (_) {
        return true;
      }
    }, [regexEnabled.value, searchQuery]);

    // 使用 useMemoized 缓存过滤结果，避免每次都重新计算
    final filteredEntries = useMemoized(() {
      final hasFilter =
          searchQuery.isNotEmpty ||
          selectedSource.value != null ||
          selectedLevel.value != null;
      if (!hasFilter) return logEntries;
      return logEntries.where((entry) {
        // Text search filter (from provider search query)
        if (searchMatcher != null &&
            !searchMatcher.matches(entry.searchTextRaw)) {
          return false;
        }
        if (selectedSource.value != null &&
            entry.source != selectedSource.value) {
          return false;
        }
        if (selectedLevel.value != null && entry.level != selectedLevel.value) {
          return false;
        }
        return true;
      }).toList();
    }, [
      logEntries,
      searchQuery,
      searchMatcher,
      selectedSource.value,
      selectedLevel.value,
    ]);

    // 当前可见日志的级别分布，用于工具栏徽标与错误直达。
    final levelCounts = useMemoized(() {
      final counts = <String, int>{'D': 0, 'I': 0, 'W': 0, 'E': 0};
      for (final entry in filteredEntries) {
        final current = counts[entry.level];
        if (current != null) counts[entry.level] = current + 1;
      }
      return counts;
    }, [filteredEntries]);

    // 历史条目复用同一套过滤条件，保证统一时间轴行为一致。
    final filteredHistory = useMemoized(() {
      if (!showHistory.value) return const <ScriptLogRecord>[];
      return historyLogs.value.where((log) {
        if (searchMatcher != null) {
          final haystack = [
            log.message,
            log.scriptName,
            log.source,
            log.stackTrace,
          ].join('\n');
          if (!searchMatcher.matches(haystack)) return false;
        }
        if (selectedSource.value != null && log.source != selectedSource.value) {
          return false;
        }
        if (selectedLevel.value != null && log.level != selectedLevel.value) {
          return false;
        }
        return true;
      }).toList();
    }, [
      showHistory.value,
      historyLogs.value,
      searchMatcher,
      selectedSource.value,
      selectedLevel.value,
    ]);

    final scrollScheduled = useRef(false);
    ref.listen(logcatProvider, (previous, next) {
      if (logcatNotifier.isAutoScroll && scrollController.hasClients) {
        if (scrollScheduled.value) return;
        scrollScheduled.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollScheduled.value = false;
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
      }
    });

    final isAnyFiltered =
        searchQuery.isNotEmpty ||
        selectedSource.value != null ||
        selectedLevel.value != null;

    Future<void> copyVisibleLogs() async {
      final truncated = filteredEntries.length > _kMaxCopyEntries;
      final source = truncated
          ? filteredEntries.sublist(filteredEntries.length - _kMaxCopyEntries)
          : filteredEntries;
      final text = source.map(_formatEntry).join('\n');
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            truncated
                ? context.l10n.consoleCopiedTruncated(
                    source.length,
                    filteredEntries.length,
                  )
                : context.l10n.consoleCopied(source.length),
          ),
        ),
      );
    }

    Future<void> exportVisibleLogs() async {
      final text = filteredEntries.map(_formatEntry).join('\n');
      await FilePicker.platform.saveFile(
        dialogTitle: context.l10n.consoleExportDialogTitle,
        fileName: 'jsxposed-console-${logcatNotifier.sessionId}.log',
        bytes: utf8.encode(text),
      );
    }

    Future<void> deleteConversationHistory() async {
      final target = conversationId;
      if (target == null || target.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.consoleDeleteHistoryUnavailable),
          ),
        );
        return;
      }
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.consoleDeleteHistoryConfirmTitle),
          content: Text(context.l10n.consoleDeleteHistoryConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      try {
        // 先落盘待写队列，避免删除后旧数据又被写回。
        await logcatNotifier.flushPersistedLogs();
        await repository.deleteConversationLogs(target);
        if (!context.mounted) return;
        historyRequestGeneration.value++;
        historyLogs.value = [];
        historyHasMore.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.consoleDeleteHistoryDone)),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }

    Widget buildLogList(BuildContext context) {
      // 历史模式：历史段在上、实时段在下，共用同一个滚动视图。
      if (!showHistory.value) {
        if (filteredEntries.isEmpty) {
          return _EmptyState(isFiltered: isAnyFiltered);
        }
        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          itemCount: filteredEntries.length,
          itemBuilder: (context, index) => _LogRow(
            entry: filteredEntries[index],
            matcher: searchMatcher,
          ),
        );
      }

      if (historyError.value != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(historyError.value!),
              TextButton(
                onPressed: () => loadHistory(),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        );
      }

      if (historyLoading.value &&
          filteredHistory.isEmpty &&
          filteredEntries.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final loadOlderCount =
          historyHasMore.value && filteredHistory.isNotEmpty ? 1 : 0;
      final separatorCount =
          filteredHistory.isNotEmpty && filteredEntries.isNotEmpty ? 1 : 0;
      final itemCount =
          loadOlderCount +
          filteredHistory.length +
          separatorCount +
          filteredEntries.length;

      if (itemCount == 0) {
        return filteredEntries.isEmpty && filteredHistory.isEmpty
            ? _EmptyState(isFiltered: isAnyFiltered)
            : Center(child: Text(context.l10n.consoleNoHistory));
      }

      return ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          var cursor = index;
          if (loadOlderCount == 1 && cursor == 0) {
            return Center(
              child: TextButton(
                onPressed: historyLoading.value
                    ? null
                    : () => loadHistory(older: true),
                child: historyLoading.value
                    ? const CircularProgressIndicator()
                    : Text(context.l10n.consoleLoadOlder),
              ),
            );
          }
          cursor -= loadOlderCount;
          if (cursor < filteredHistory.length) {
            return _PersistedLogRow(log: filteredHistory[cursor]);
          }
          cursor -= filteredHistory.length;
          if (separatorCount == 1 && cursor == 0) {
            return _LiveSectionDivider(label: context.l10n.consoleLiveBelow);
          }
          cursor -= separatorCount;
          return _LogRow(entry: filteredEntries[cursor]);
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(
            color: context.theme.dividerColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Column(
        children: [
          // ── Toolbar ──
          _LogcatToolbar(
            autoScroll: autoScroll,
            filteredCount: filteredEntries.length,
            totalCount: logEntries.length,
            levelCounts: levelCounts,
            selectedLevel: selectedLevel.value,
            isFullscreen: isFullscreen,
            isPaused: logcatNotifier.isPaused,
            isRunning: logcatNotifier.isRunning,
            regexEnabled: regexEnabled.value,
            caseSensitive: caseSensitive.value,
            hasRegexError: hasRegexError,
            onRegexToggle: () => regexEnabled.value = !regexEnabled.value,
            onCaseSensitiveToggle: () =>
                caseSensitive.value = !caseSensitive.value,
            onLevelTap: (level) =>
                selectedLevel.value = selectedLevel.value == level ? null : level,
            onSearchChanged: (query) {
              searchDebounce.value?.cancel();
              searchDebounce.value = Timer(
                const Duration(milliseconds: 200),
                () => logcatNotifier.setSearchQuery(query),
              );
            },
            onAutoScrollToggle: () => logcatNotifier.setAutoScroll(!autoScroll),
            onPauseToggle: () =>
                logcatNotifier.setPaused(!logcatNotifier.isPaused),
            onCopy: copyVisibleLogs,
            onExport: exportVisibleLogs,
            onDeleteHistory: deleteConversationHistory,
            onClear: logcatNotifier.clear,
            onToggleFullscreen: onToggleFullscreen,
            showHistory: showHistory.value,
            onHistoryToggle: () => showHistory.value = !showHistory.value,
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.white.withValues(alpha: 0.06),
          ),
          // ── Source and level filters ──
          _FilterRow(
            selectedSource: selectedSource.value,
            selectedLevel: selectedLevel.value,
            onSourceSelected: (source) => selectedSource.value = source,
            onLevelSelected: (level) => selectedLevel.value = level,
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.white.withValues(alpha: 0.04),
          ),
          // ── Log List ──
          Expanded(child: buildLogList(context)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Toolbar
// ─────────────────────────────────────────────

class _LogcatToolbar extends StatelessWidget {
  final bool autoScroll;
  final int filteredCount;
  final int totalCount;
  final Map<String, int> levelCounts;
  final String? selectedLevel;
  final bool isFullscreen;
  final bool isPaused;
  final bool isRunning;
  final bool regexEnabled;
  final bool caseSensitive;
  final bool hasRegexError;
  final VoidCallback onRegexToggle;
  final VoidCallback onCaseSensitiveToggle;
  final ValueChanged<String> onLevelTap;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAutoScrollToggle;
  final VoidCallback onPauseToggle;
  final VoidCallback onCopy;
  final VoidCallback onExport;
  final VoidCallback onDeleteHistory;
  final VoidCallback onClear;
  final VoidCallback onToggleFullscreen;
  final bool showHistory;
  final VoidCallback onHistoryToggle;

  const _LogcatToolbar({
    required this.autoScroll,
    required this.filteredCount,
    required this.totalCount,
    required this.levelCounts,
    required this.selectedLevel,
    required this.isFullscreen,
    required this.isPaused,
    required this.isRunning,
    required this.regexEnabled,
    required this.caseSensitive,
    required this.hasRegexError,
    required this.onRegexToggle,
    required this.onCaseSensitiveToggle,
    required this.onLevelTap,
    required this.onSearchChanged,
    required this.onAutoScrollToggle,
    required this.onPauseToggle,
    required this.onCopy,
    required this.onExport,
    required this.onDeleteHistory,
    required this.onClear,
    required this.onToggleFullscreen,
    required this.showHistory,
    required this.onHistoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isFiltered = filteredCount != totalCount;
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      color: const Color(0xFF1A1A1A),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 400;
          return Row(
            children: [
              if (!compact) ...[
                Icon(
                  Icons.terminal_rounded,
                  size: 13.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 5.w),
              ],
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: isPaused
                      ? Colors.orange
                      : isRunning
                      ? const Color(0xFF66BB6A)
                      : Colors.grey[700],
                  shape: BoxShape.circle,
                ),
              ),
              if (!compact) ...[
                SizedBox(width: 5.w),
                Text(
                  context.l10n.terminal,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300],
                  ),
                ),
              ],
              SizedBox(width: 6.w),
              // Entry count badge
              if (totalCount > 0)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: compact ? 48.w : 64.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: isFiltered
                          ? Colors.blue.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      isFiltered ? '$filteredCount/$totalCount' : '$totalCount',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: isFiltered ? Colors.blue[300] : Colors.grey[500],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 6.w),
              // Level distribution; tapping a badge filters that level.
              if (!compact)
                for (final level in const ['E', 'W', 'I', 'D'])
                  if ((levelCounts[level] ?? 0) > 0) ...[
                    _LevelCountBadge(
                      level: level,
                      count: levelCounts[level]!,
                      isSelected: selectedLevel == level,
                      onTap: () => onLevelTap(level),
                    ),
                    SizedBox(width: 3.w),
                  ],
              if (!compact) SizedBox(width: 3.w),
              // Search takes the space left after the fixed-size actions.
              Expanded(
                child: SizedBox(
                  height: 26.h,
                  child: TextField(
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[200]),
                    decoration: InputDecoration(
                      hintText: compact
                          ? null
                          : context.l10n.terminalFilterHint,
                      hintStyle: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[700],
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 13.sp,
                        color: hasRegexError
                            ? const Color(0xFFEF5350)
                            : Colors.grey[600],
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 26.w),
                      suffixIcon: regexEnabled || caseSensitive
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (caseSensitive)
                                  Padding(
                                    padding: EdgeInsets.only(right: 2.w),
                                    child: Text(
                                      'Aa',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[300],
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                if (regexEnabled)
                                  Padding(
                                    padding: EdgeInsets.only(right: 4.w),
                                    child: Text(
                                      '.*',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        color: hasRegexError
                                            ? const Color(0xFFEF5350)
                                            : Colors.blue[300],
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : null,
                      suffixIconConstraints: BoxConstraints(minWidth: 26.w),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: BorderSide(
                          color: hasRegexError
                              ? const Color(0xFFEF5350)
                              : Colors.grey[600]!,
                          width: 0.8,
                        ),
                      ),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              _ToolbarIconButton(
                icon: Icons.code_rounded,
                tooltip: context.l10n.consoleRegexSearch,
                color: regexEnabled
                    ? (hasRegexError ? const Color(0xFFEF5350) : Colors.blue[300]!)
                    : Colors.grey[600]!,
                onPressed: onRegexToggle,
              ),
              _ToolbarIconButton(
                icon: Icons.text_fields_rounded,
                tooltip: context.l10n.consoleCaseSensitive,
                color: caseSensitive ? Colors.blue[300]! : Colors.grey[600]!,
                onPressed: onCaseSensitiveToggle,
              ),
              _ToolbarIconButton(
                icon: autoScroll
                    ? Icons.vertical_align_bottom_rounded
                    : Icons.pause_circle_outline_rounded,
                tooltip: context.l10n.autoScroll,
                color: autoScroll ? const Color(0xFF66BB6A) : Colors.grey[600]!,
                onPressed: onAutoScrollToggle,
              ),
              _ToolbarIconButton(
                icon: showHistory
                    ? Icons.history_rounded
                    : Icons.history_toggle_off_rounded,
                tooltip: context.l10n.consoleHistory,
                color: showHistory ? Colors.blue[300]! : Colors.grey[600]!,
                onPressed: onHistoryToggle,
              ),
              _ToolbarIconButton(
                icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                tooltip: isPaused
                    ? context.l10n.consoleResumeOutput
                    : context.l10n.consolePauseOutput,
                color: isPaused ? Colors.orange : Colors.grey[600]!,
                onPressed: onPauseToggle,
              ),
              SizedBox(
                width: 27.w,
                height: 28.h,
                child: PopupMenuButton<String>(
                  tooltip: context.l10n.consoleActions,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 15.sp,
                  icon: Icon(Icons.more_vert_rounded, color: Colors.grey[600]),
                  onSelected: (value) {
                    if (value == 'copy') onCopy();
                    if (value == 'export') onExport();
                    if (value == 'deleteHistory') onDeleteHistory();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'copy',
                      child: Text(context.l10n.consoleCopyVisible),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Text(context.l10n.consoleExportVisible),
                    ),
                    PopupMenuItem(
                      value: 'deleteHistory',
                      child: Text(context.l10n.consoleDeleteHistory),
                    ),
                  ],
                ),
              ),
              _ToolbarIconButton(
                icon: Icons.delete_sweep_outlined,
                tooltip: context.l10n.clearPanel,
                color: Colors.grey[600]!,
                onPressed: onClear,
              ),
              _ToolbarIconButton(
                icon: isFullscreen
                    ? Icons.close_fullscreen_rounded
                    : Icons.open_in_full_rounded,
                tooltip: context.l10n.logcatFullscreen,
                color: isFullscreen ? Colors.blue[300]! : Colors.grey[600]!,
                onPressed: onToggleFullscreen,
              ),
            ],
          );
        },
      ),
    );
  }
}

String _sourceLabel(BuildContext context, String value) => switch (value) {
  'session' => context.l10n.consoleSourceSession,
  'frida' => context.l10n.consoleSourceFrida,
  'xposed' => context.l10n.consoleSourceXposed,
  'app' => context.l10n.consoleSourceApp,
  'framework' => context.l10n.consoleSourceCore,
  'system' => context.l10n.consoleSourceSystem,
  _ => value,
};

String _levelLabel(BuildContext context, String value) => switch (value) {
  'D' => context.l10n.consoleLevelDebug,
  'I' => context.l10n.consoleLevelInfo,
  'W' => context.l10n.consoleLevelWarn,
  'E' => context.l10n.consoleLevelError,
  _ => value,
};

// ─────────────────────────────────────────────
// Tag Filter Row
// ─────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final String? selectedSource;
  final String? selectedLevel;
  final ValueChanged<String?> onSourceSelected;
  final ValueChanged<String?> onLevelSelected;

  const _FilterRow({
    required this.selectedSource,
    required this.selectedLevel,
    required this.onSourceSelected,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      color: const Color(0xFF161616),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kSourceFilters.length + _kLevelFilters.length + 2,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _TagChip(
              label: context.l10n.consoleAll,
              isSelected: selectedSource == null && selectedLevel == null,
              onTap: () {
                onSourceSelected(null);
                onLevelSelected(null);
              },
            );
          }
          if (index <= _kSourceFilters.length) {
            final filter = _kSourceFilters[index - 1];
            return _TagChip(
              label: _sourceLabel(context, filter.value),
              isSelected: selectedSource == filter.value,
              onTap: () => onSourceSelected(
                selectedSource == filter.value ? null : filter.value,
              ),
            );
          }
          if (index == _kSourceFilters.length + 1) {
            return VerticalDivider(
              width: 8.w,
              indent: 7.h,
              endIndent: 7.h,
              color: Colors.white.withValues(alpha: 0.12),
            );
          }
          final filter = _kLevelFilters[index - _kSourceFilters.length - 2];
          return _TagChip(
            label: _levelLabel(context, filter.value),
            isSelected: selectedLevel == filter.value,
            onTap: () => onLevelSelected(
              selectedLevel == filter.value ? null : filter.value,
            ),
          );
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.07),
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: 'monospace',
            color: isSelected ? Colors.blue[200] : Colors.grey[500],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Log Row
// ─────────────────────────────────────────────

/// 统一时间轴中"历史段"与"实时段"的分界提示。
class _LiveSectionDivider extends StatelessWidget {
  final String label;

  const _LiveSectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontFamily: 'monospace',
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCountBadge extends StatelessWidget {
  final String level;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelCountBadge({
    required this.level,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color => switch (level) {
    'E' => const Color(0xFFEF5350),
    'W' => const Color(0xFFFFA726),
    'D' => const Color(0xFF42A5F5),
    _ => const Color(0xFF90A4AE),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: isSelected ? 0.28 : 0.12),
          borderRadius: BorderRadius.circular(4.r),
          border: isSelected
              ? Border.all(color: _color.withValues(alpha: 0.7), width: 0.8)
              : null,
        ),
        child: Text(
          '$level$count',
          style: TextStyle(
            fontSize: 9.sp,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            color: _color,
          ),
        ),
      ),
    );
  }
}

class _PersistedLogRow extends StatelessWidget {
  const _PersistedLogRow({required this.log});

  final ScriptLogRecord log;

  @override
  Widget build(BuildContext context) {
    final color = switch (log.level) {
      'E' || 'F' => const Color(0xFFEF5350),
      'W' => const Color(0xFFFFA726),
      'D' => const Color(0xFF42A5F5),
      _ => const Color(0xFFB0BEC5),
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: SelectableText(
        '[${log.timestamp.toLocal()}] [${log.source}/${log.level}] '
        '${log.scriptName} (run ${log.runId}): ${log.message}'
        '${log.stackTrace.isEmpty ? '' : '\n${log.stackTrace}'}',
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _LogRow extends StatefulWidget {
  final LogcatEntry entry;
  final _SearchMatcher? matcher;

  const _LogRow({required this.entry, this.matcher});

  @override
  State<_LogRow> createState() => _LogRowState();
}

class _LogRowState extends State<_LogRow> {
  bool _stackExpanded = false;

  LogcatEntry get entry => widget.entry;

  Color get _levelColor => switch (entry.level) {
    'E' => const Color(0xFFEF5350),
    'F' => const Color(0xFFEC407A),
    'W' => const Color(0xFFFFA726),
    'D' => const Color(0xFF42A5F5),
    _ => const Color(0xFFB0BEC5),
  };

  Color get _rowBgColor => switch (entry.level) {
    'E' || 'F' => const Color(0x14EF5350),
    'W' => const Color(0x0DFFA726),
    _ => Colors.transparent,
  };

  Color get _sourceColor => switch (entry.source) {
    'frida' => const Color(0xFFFFB74D),
    'xposed' => const Color(0xFF81C784),
    'app' => const Color(0xFF64B5F6),
    'framework' => const Color(0xFFBA68C8),
    _ => const Color(0xFF90A4AE),
  };

  @override
  Widget build(BuildContext context) {
    final hasStructured = entry.tag.isNotEmpty || entry.source.isNotEmpty;
    // Show only HH:MM:SS.mmm from "MM-DD HH:MM:SS.mmm" (skip first 6 chars)
    final timeDisplay = entry.timestamp.length > 6
        ? entry.timestamp.substring(6)
        : '';
    final messageText = hasStructured ? entry.message : entry.rawLine;
    final messageStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 11.sp,
      color: entry.level == 'E' || entry.level == 'F'
          ? const Color(0xFFEF9A9A)
          : entry.level == 'W'
          ? const Color(0xFFFFCC80)
          : Colors.white70,
      height: 1.35,
    );
    final highlightStyle = messageStyle.copyWith(
      color: const Color(0xFF111111),
      backgroundColor: const Color(0xFFFFD54F),
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: _formatEntry(entry)));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.consoleLogCopied)));
      },
      child: Container(
        color: _rowBgColor,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level badge
            Container(
              width: 16.w,
              height: 16.h,
              margin: EdgeInsets.only(top: 2.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _levelColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Text(
                entry.level,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.bold,
                  color: _levelColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasStructured)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            [
                              entry.source.toUpperCase(),
                              if (entry.scriptName.isNotEmpty) entry.scriptName,
                              if (entry.tag.isNotEmpty) entry.tag,
                            ].join('  ·  '),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: _sourceColor.withValues(alpha: 0.85),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (timeDisplay.isNotEmpty)
                          Text(
                            timeDisplay,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.grey[700],
                              fontFamily: 'monospace',
                            ),
                          ),
                      ],
                    ),
                  Text.rich(
                    TextSpan(
                      children: widget.matcher?.split(
                            messageText,
                            messageStyle,
                            highlightStyle,
                          ) ??
                          [TextSpan(text: messageText, style: messageStyle)],
                    ),
                    style: messageStyle,
                  ),
                  if (entry.stackTrace.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _stackExpanded = !_stackExpanded),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.stackTrace,
                              maxLines: _stackExpanded ? null : 5,
                              overflow: _stackExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10.sp,
                                color: const Color(0xFFEF9A9A),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              _stackExpanded
                                  ? context.l10n.consoleCollapseStack
                                  : context.l10n.consoleExpandStack,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.blue[300],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatEntry(LogcatEntry entry) {
  final buffer = StringBuffer();
  if (entry.timestamp.isNotEmpty) buffer.write('${entry.timestamp} ');
  buffer.write('${entry.level} [${entry.source.toUpperCase()}]');
  if (entry.scriptName.isNotEmpty) buffer.write('[${entry.scriptName}]');
  if (entry.pid.isNotEmpty) buffer.write('[pid:${entry.pid}]');
  buffer.write(' ${entry.message}');
  if (entry.stackTrace.isNotEmpty) buffer.write('\n${entry.stackTrace}');
  return buffer.toString();
}

// ─────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isFiltered;

  const _EmptyState({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFiltered ? Icons.filter_list_off : Icons.terminal_rounded,
              size: 28.sp,
              color: Colors.grey[800],
            ),
            SizedBox(height: 8.h),
            Text(
              isFiltered ? context.l10n.noLogsFiltered : context.l10n.noLogs,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Toolbar Icon Button
// ─────────────────────────────────────────────

class _ToolbarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 27.w,
        height: 28.h,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4.r),
          child: Center(
            child: Icon(icon, size: 15.sp, color: color),
          ),
        ),
      ),
    );
  }
}
