import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 打字机效果渲染组件
class QuillCustomTypewriter extends quill.EmbedBuilder {
  @override
  String get key => 'typewriter';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final text = data['text'] ?? '';
    final colorName = data['color'] ?? 'green';
    final speed = data['speed'] ?? 100;
    final showCursor = data['cursor'] ?? true;
    final loop = data['loop'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _TypewriterWidget(
        text: text,
        colorName: colorName,
        speed: speed,
        showCursor: showCursor,
        loop: loop,
        primaryColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _TypewriterWidget extends StatefulWidget {
  final String text;
  final String colorName;
  final int speed;
  final bool showCursor;
  final bool loop;
  final Color primaryColor;

  const _TypewriterWidget({
    required this.text,
    required this.colorName,
    required this.speed,
    required this.showCursor,
    required this.loop,
    required this.primaryColor,
  });

  @override
  State<_TypewriterWidget> createState() => _TypewriterWidgetState();
}

class _TypewriterWidgetState extends State<_TypewriterWidget> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    if (widget.showCursor) {
      _startCursorBlink();
    }
  }

  Color _getColor() {
    switch (widget.colorName) {
      case 'cyan':
        return Colors.cyan;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'primary':
        return widget.primaryColor;
      default:
        return Colors.green;
    }
  }

  void _startTyping() {
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        if (widget.loop) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _displayedText = '';
                _currentIndex = 0;
              });
              _startTyping();
            }
          });
        }
      }
    });
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _cursorVisible = !_cursorVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              _displayedText,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.showCursor)
            AnimatedOpacity(
              opacity: _cursorVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 2,
                height: 22,
                margin: const EdgeInsets.only(left: 2),
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
