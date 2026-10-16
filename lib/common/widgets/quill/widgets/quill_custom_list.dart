import 'dart:convert';

import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// 自定义列表嵌入组件
class QuillCustomList extends quill.EmbedBuilder {
  @override
  String get key => 'list';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final Map<String, dynamic> data = jsonDecode(embedContext.node.value.data);

    final width = double.tryParse(data["width"]?.toString() ?? "") ?? 300;
    final height = double.tryParse(data["height"]?.toString() ?? "") ?? 200;
    final gap = double.tryParse(data["gap"]?.toString() ?? "") ?? 8;
    final scrollDirection = data["scroll_direction"]?.toString() ?? "vertical";
    final List<dynamic> items = data["items"] ?? [];

    if (items.isEmpty) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '暂无列表项',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      );
    }

    final isVertical = scrollDirection == "vertical";
    final maxWidth = context.screenWidth * 0.9;
    final maxHeight = context.screenHeight * 0.6;
    final colorScheme = Theme.of(context).colorScheme;

    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width > maxWidth ? maxWidth : width,
        height: height > maxHeight ? maxHeight : height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surfaceContainerHighest.withOpacity(0.5),
              colorScheme.surfaceContainerLow.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ListView.separated(
            padding: EdgeInsets.all(isVertical ? 8 : 12),
            scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                isVertical ? SizedBox(height: gap) : SizedBox(width: gap),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildListItem(context, item, isVertical);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic item, bool isVertical) {
    final title = item["title"]?.toString() ?? '';
    final subtitle = item["subtitle"]?.toString() ?? '';
    final type = int.tryParse(item["type"]?.toString() ?? "1") ?? 1;
    final content = item["content"]?.toString() ?? '';
    final colorScheme = Theme.of(context).colorScheme;

    final hasAction = content.isNotEmpty;
    final isDialog = type == 1;

    Future<void> handleTap() async {
      if (!hasAction) return;
      if (isDialog) {
        CustomDialog.show(
          title: Text(title),
          hasClose: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
          actionButtons: [
            TextButton(
              onPressed: SmartDialog.dismiss,
              child: Text(context.l10n.confirm),
            ),
          ],
        );
        return;
      }

      final uri = Uri.tryParse(content);
      if (uri != null && uri.hasScheme) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }

      CustomDialog.show(
        title: Text(title),
        hasClose: true,
        child: Text(content),
        actionButtons: [
          TextButton(
            onPressed: SmartDialog.dismiss,
            child: Text(context.l10n.confirm),
          ),
        ],
      );
    }

    if (isVertical) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasAction ? () => handleTap() : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isDialog ? Icons.article_outlined : Icons.link,
                  color: colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasAction ? () => handleTap() : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDialog ? Icons.article_outlined : Icons.link,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
