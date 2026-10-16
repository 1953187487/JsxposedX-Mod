import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 倒计时组件 - 实时倒计时显示
class QuillCustomCountdown extends quill.EmbedBuilder {
  @override
  String get key => 'countdown';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final Map<String, dynamic> data = jsonDecode(embedContext.node.value.data);
    final title = data['title']?.toString() ?? '倒计时';
    final targetTimestamp = int.tryParse(data['target_timestamp']?.toString() ?? '0') ?? 0;
    final expiredText = data['expired_text']?.toString() ?? '已结束';

    return _CountdownCard(
      title: title,
      targetTimestamp: targetTimestamp,
      expiredText: expiredText,
    );
  }
}

class _CountdownCard extends StatefulWidget {
  final String title;
  final int targetTimestamp;
  final String expiredText;

  const _CountdownCard({
    required this.title,
    required this.targetTimestamp,
    required this.expiredText,
  });

  @override
  State<_CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<_CountdownCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final target = DateTime.fromMillisecondsSinceEpoch(widget.targetTimestamp);
    final now = DateTime.now();
    final diff = target.difference(now);

    setState(() {
      if (diff.isNegative) {
        _isExpired = true;
        _remaining = Duration.zero;
      } else {
        _isExpired = false;
        _remaining = diff;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isExpired
              ? [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainerLow,
                ]
              : [
                  colorScheme.primaryContainer.withOpacity(0.5),
                  colorScheme.secondaryContainer.withOpacity(0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpired
              ? colorScheme.outline.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isExpired ? Icons.timer_off : Icons.timer,
                color: _isExpired ? colorScheme.outline : colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: _isExpired ? colorScheme.outline : colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 倒计时数字
          if (_isExpired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.expiredText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.outline,
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit(context, days, '天'),
                _buildSeparator(context),
                _buildTimeUnit(context, hours, '时'),
                _buildSeparator(context),
                _buildTimeUnit(context, minutes, '分'),
                _buildSeparator(context),
                _buildTimeUnit(context, seconds, '秒'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, int value, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
