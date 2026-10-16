import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_view_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 搜索结果：一条命中消息及其在正文中的匹配片段。
class AiChatSearchHit {
  const AiChatSearchHit({required this.message, required this.snippet});

  final AiChatViewMessage message;

  /// 命中位置附近的正文摘录，用于在结果列表中展示上下文。
  final String snippet;
}

/// 在当前会话已加载的消息里做正文检索。
///
/// 匹配不区分大小写；按消息在会话中的时间倒序返回，最新的排在最前。
List<AiChatSearchHit> searchChatMessages(
  List<AiChatViewMessage> messages,
  String keyword, {
  int maxHits = 100,
  int snippetRadius = 40,
}) {
  final query = keyword.trim().toLowerCase();
  if (query.isEmpty) return const <AiChatSearchHit>[];

  final hits = <AiChatSearchHit>[];
  for (var index = messages.length - 1; index >= 0; index--) {
    final message = messages[index];
    final content = message.content;
    if (content.isEmpty) continue;
    final matchIndex = content.toLowerCase().indexOf(query);
    if (matchIndex < 0) continue;

    final start = (matchIndex - snippetRadius).clamp(0, content.length);
    final end = (matchIndex + query.length + snippetRadius).clamp(
      0,
      content.length,
    );
    final snippet =
        '${start > 0 ? '…' : ''}'
        '${content.substring(start, end).replaceAll(RegExp(r'\s+'), ' ')}'
        '${end < content.length ? '…' : ''}';

    hits.add(AiChatSearchHit(message: message, snippet: snippet));
    if (hits.length >= maxHits) break;
  }
  return hits;
}

/// 会话内消息搜索面板（底部弹层）。
///
/// 命中结果被点击时通过 [onSelect] 回传消息 ID，由调用方负责定位与高亮。
class AiChatSearchSheet extends HookWidget {
  const AiChatSearchSheet({
    super.key,
    required this.messages,
    required this.onSelect,
  });

  final List<AiChatViewMessage> messages;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final keyword = useState('');

    final hits = useMemoized(
      () => searchChatMessages(messages, keyword.value),
      [messages, keyword.value],
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
              child: TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) => keyword.value = value,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: context.isDark
                      ? context.colorScheme.surfaceContainerLow
                      : Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  hintText: context.l10n.aiSearchMessagesHint,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.45,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 1.4,
                    ),
                  ),
                  suffixIcon: keyword.value.isEmpty
                      ? null
                      : IconButton(
                          tooltip: context.l10n.clear,
                          onPressed: () {
                            controller.clear();
                            keyword.value = '';
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
            ),
            if (keyword.value.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    hits.isEmpty
                        ? context.l10n.aiSearchNoResults
                        : context.l10n.aiSearchResultCount(hits.length),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
                itemCount: hits.length,
                itemBuilder: (context, index) {
                  final hit = hits[index];
                  return _SearchHitTile(
                    hit: hit,
                    keyword: keyword.value.trim(),
                    onTap: () => onSelect(hit.message.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHitTile extends StatelessWidget {
  const _SearchHitTile({
    required this.hit,
    required this.keyword,
    required this.onTap,
  });

  final AiChatSearchHit hit;
  final String keyword;
  final VoidCallback onTap;

  String _roleLabel(BuildContext context) {
    switch (hit.message.role) {
      case 'user':
        return context.l10n.aiSearchRoleUser;
      case 'assistant':
        return context.l10n.aiSearchRoleAssistant;
      case 'system':
        return context.l10n.aiSearchRoleSystem;
      case 'tool':
        return context.l10n.aiSearchRoleTool;
      default:
        return hit.message.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = switch (hit.message.role) {
      'user' => context.colorScheme.primary,
      'assistant' => context.colorScheme.tertiary,
      _ => context.colorScheme.onSurfaceVariant,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Material(
        color: context.isDark
            ? context.colorScheme.surfaceContainerLow
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.45,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    _roleLabel(context),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: roleColor,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                _HighlightedSnippet(text: hit.snippet, keyword: keyword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 在摘录中把命中的关键词加粗并着色。
class _HighlightedSnippet extends StatelessWidget {
  const _HighlightedSnippet({required this.text, required this.keyword});

  final String text;
  final String keyword;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 12.sp,
      height: 1.4,
      color: context.colorScheme.onSurfaceVariant,
    );
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();

    if (keyword.isEmpty || !lowerText.contains(lowerKeyword)) {
      return Text(
        text,
        style: style,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }

    final spans = <TextSpan>[];
    var cursor = 0;
    while (cursor < text.length) {
      final matchIndex = lowerText.indexOf(lowerKeyword, cursor);
      if (matchIndex < 0) {
        spans.add(TextSpan(text: text.substring(cursor)));
        break;
      }
      if (matchIndex > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, matchIndex)));
      }
      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchIndex + keyword.length),
          style: TextStyle(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w700,
            backgroundColor: context.colorScheme.primary.withValues(
              alpha: 0.12,
            ),
          ),
        ),
      );
      cursor = matchIndex + keyword.length;
    }

    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
