import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 折叠面板渲染组件
class QuillCustomAccordion extends quill.EmbedBuilder {
  @override
  String get key => 'accordion';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final items = (data['items'] as List?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _AccordionWidget(items: items),
    );
  }
}

class _AccordionWidget extends StatefulWidget {
  final List items;

  const _AccordionWidget({required this.items});

  @override
  State<_AccordionWidget> createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<_AccordionWidget> {
  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: widget.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value as Map<String, dynamic>;
        final isExpanded = _expandedIndices.contains(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isExpanded ? primaryColor : Colors.grey.shade300,
              width: isExpanded ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // 标题栏
              InkWell(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedIndices.remove(index);
                    } else {
                      _expandedIndices.add(index);
                    }
                  });
                },
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isExpanded ? primaryColor.withOpacity(0.05) : null,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(7),
                      bottom: isExpanded ? Radius.zero : const Radius.circular(7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] ?? '',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isExpanded ? primaryColor : null,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: isExpanded ? primaryColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 内容
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Text(
                    item['content'] ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
