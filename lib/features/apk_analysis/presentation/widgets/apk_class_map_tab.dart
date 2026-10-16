import 'dart:math' as math;

import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_class_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApkClassMapTab extends ConsumerWidget {
  final String sessionId;
  final List<String> dexPaths;
  final String className;
  final String packageName;

  const ApkClassMapTab({
    super.key,
    required this.sessionId,
    required this.dexPaths,
    required this.className,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapAsync = ref.watch(apkClassMapProvider(
      sessionId: sessionId,
      dexPaths: dexPaths,
      className: className,
      packageName: packageName,
    ));

    return mapAsync.when(
      loading: () => const Loading(),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(apkClassMapProvider(
          sessionId: sessionId,
          dexPaths: dexPaths,
          className: className,
          packageName: packageName,
        )),
      ),
      data: (data) {
        if (data.rawError != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                data.rawError!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.colorScheme.error,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          );
        }
        if (data.nodes.isEmpty) {
          return const Center(child: Text('No flow data'));
        }
        return _FlowchartView(data: data);
      },
    );
  }
}

class _FlowchartView extends StatefulWidget {
  final ClassFlowData data;
  const _FlowchartView({required this.data});

  @override
  State<_FlowchartView> createState() => _FlowchartViewState();
}

class _FlowchartViewState extends State<_FlowchartView> {
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startFocal = Offset.zero;
  Offset _startOffset = Offset.zero;

  late Map<String, Offset> _positions;
  static const double _nodeW = 160.0;
  static const double _nodeH = 48.0;
  static const double _hGap = 40.0;
  static const double _vGap = 70.0;

  @override
  void initState() {
    super.initState();
    _positions = _layoutNodes(widget.data);
  }

  @override
  void didUpdateWidget(_FlowchartView old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _positions = _layoutNodes(widget.data);
    }
  }

  Map<String, Offset> _layoutNodes(ClassFlowData data) {
    final positions = <String, Offset>{};
    if (data.nodes.isEmpty) return positions;

    final adjacency = <String, List<String>>{};
    for (final n in data.nodes) {
      adjacency[n.id] = [];
    }
    for (final e in data.edges) {
      adjacency[e.from]?.add(e.to);
    }

    final inDegree = <String, int>{};
    for (final n in data.nodes) {
      inDegree[n.id] = 0;
    }
    for (final e in data.edges) {
      inDegree[e.to] = (inDegree[e.to] ?? 0) + 1;
    }

    final layers = <List<String>>[];
    final visited = <String>{};
    var current = data.nodes
        .where((n) => (inDegree[n.id] ?? 0) == 0)
        .map((n) => n.id)
        .toList();
    if (current.isEmpty) current = [data.nodes.first.id];

    while (current.isNotEmpty) {
      layers.add([...current]);
      visited.addAll(current);
      final next = <String>[];
      for (final id in current) {
        for (final child in (adjacency[id] ?? [])) {
          if (!visited.contains(child)) next.add(child);
        }
      }
      current = next.toSet().toList();
    }

    final unplaced =
        data.nodes.where((n) => !visited.contains(n.id)).map((n) => n.id).toList();
    if (unplaced.isNotEmpty) layers.add(unplaced);

    for (var row = 0; row < layers.length; row++) {
      final layer = layers[row];
      final totalW = layer.length * (_nodeW + _hGap) - _hGap;
      for (var col = 0; col < layer.length; col++) {
        final x = col * (_nodeW + _hGap) - totalW / 2 + _nodeW / 2;
        final y = row * (_nodeH + _vGap) + _nodeH / 2;
        positions[layer[col]] = Offset(x, y);
      }
    }

    return positions;
  }

  Size get _canvasSize {
    if (_positions.isEmpty) return const Size(300, 300);
    double maxX = 0, maxY = 0;
    for (final p in _positions.values) {
      maxX = math.max(maxX, p.dx.abs() + _nodeW);
      maxY = math.max(maxY, p.dy + _nodeH);
    }
    return Size(maxX * 2 + 80, maxY + 80);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final canvas = _canvasSize;

    return GestureDetector(
      onScaleStart: (d) {
        _baseScale = _scale;
        _startFocal = d.focalPoint;
        _startOffset = _offset;
      },
      onScaleUpdate: (d) {
        setState(() {
          if (d.pointerCount >= 2) {
            _scale = (_baseScale * d.scale).clamp(0.3, 3.0);
          }
          final delta = d.focalPoint - _startFocal;
          _offset = _startOffset + delta;
        });
      },
      child: ClipRect(
        child: CustomPaint(
          size: Size.infinite,
          painter: _FlowPainter(
            nodes: widget.data.nodes,
            edges: widget.data.edges,
            positions: _positions,
            scale: _scale,
            offset: _offset,
            canvasSize: canvas,
            isDark: isDark,
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _FlowPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final Map<String, Offset> positions;
  final double scale;
  final Offset offset;
  final Size canvasSize;
  final bool isDark;
  final Color primary;

  _FlowPainter({
    required this.nodes,
    required this.edges,
    required this.positions,
    required this.scale,
    required this.offset,
    required this.canvasSize,
    required this.isDark,
    required this.primary,
  });

  static const double _nodeW = 160.0;
  static const double _nodeH = 48.0;
  static const double _r = 8.0;
  static const double _arrowSize = 8.0;

  Color _nodeColor(String type) {
    switch (type) {
      case 'start':
        return const Color(0xFF4CAF50);
      case 'end':
        return const Color(0xFFF44336);
      case 'condition':
        return const Color(0xFFFF9800);
      case 'method':
        return const Color(0xFF2196F3);
      default:
        return primary;
    }
  }

  Offset _transform(Offset p, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    return Offset(
      cx + (p.dx * scale) + offset.dx,
      cy + (p.dy * scale) + offset.dy - canvasSize.height * scale / 2 + 40,
    );
  }

  Rect _nodeRect(Offset center) => Rect.fromCenter(
        center: center,
        width: _nodeW * scale,
        height: _nodeH * scale,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDark
          ? const Color(0xFF1A1A2E)
          : const Color(0xFFF5F7FB);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final edgePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.25)
      ..strokeWidth = 1.5 * scale
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.35)
      ..style = PaintingStyle.fill;

    for (final edge in edges) {
      final fromPos = positions[edge.from];
      final toPos = positions[edge.to];
      if (fromPos == null || toPos == null) continue;

      final from = _transform(fromPos, size);
      final to = _transform(toPos, size);

      final fromBottom = Offset(from.dx, from.dy + _nodeH * scale / 2);
      final toTop = Offset(to.dx, to.dy - _nodeH * scale / 2);

      final path = Path();
      path.moveTo(fromBottom.dx, fromBottom.dy);
      final midY = (fromBottom.dy + toTop.dy) / 2;
      path.cubicTo(
          fromBottom.dx, midY, toTop.dx, midY, toTop.dx, toTop.dy);
      canvas.drawPath(path, edgePaint);

      _drawArrow(canvas, arrowPaint, toTop, const Offset(0, -1));

      if (edge.label.isNotEmpty) {
        final mid = Offset((fromBottom.dx + toTop.dx) / 2,
            (fromBottom.dy + toTop.dy) / 2);
        _drawLabel(canvas, edge.label, mid, size, isEdge: true);
      }
    }

    for (final node in nodes) {
      final pos = positions[node.id];
      if (pos == null) continue;
      final center = _transform(pos, size);
      final rect = _nodeRect(center);
      final color = _nodeColor(node.type);

      final fillPaint = Paint()
        ..color = color.withOpacity(isDark ? 0.18 : 0.12)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = color.withOpacity(0.7)
        ..strokeWidth = 1.5 * scale
        ..style = PaintingStyle.stroke;

      final rrect =
          RRect.fromRectAndRadius(rect, Radius.circular(_r * scale));
      if (node.type == 'condition') {
        final diamond = Path();
        diamond.moveTo(rect.centerLeft.dx, rect.center.dy);
        diamond.lineTo(rect.center.dx, rect.topCenter.dy);
        diamond.lineTo(rect.centerRight.dx, rect.center.dy);
        diamond.lineTo(rect.center.dx, rect.bottomCenter.dy);
        diamond.close();
        canvas.drawPath(diamond, fillPaint);
        canvas.drawPath(diamond, strokePaint);
      } else {
        canvas.drawRRect(rrect, fillPaint);
        canvas.drawRRect(rrect, strokePaint);
      }

      _drawLabel(canvas, node.label, center, size, color: color);
    }
  }

  void _drawArrow(
      Canvas canvas, Paint paint, Offset tip, Offset dir) {
    final perp = Offset(-dir.dy, dir.dx);
    final base = tip - dir * (_arrowSize * scale);
    final p = Path();
    p.moveTo(tip.dx, tip.dy);
    p.lineTo(
        base.dx + perp.dx * _arrowSize * scale * 0.5,
        base.dy + perp.dy * _arrowSize * scale * 0.5);
    p.lineTo(
        base.dx - perp.dx * _arrowSize * scale * 0.5,
        base.dy - perp.dy * _arrowSize * scale * 0.5);
    p.close();
    canvas.drawPath(p, paint);
  }

  void _drawLabel(Canvas canvas, String text, Offset center, Size size,
      {Color? color, bool isEdge = false}) {
    final fontSize = (isEdge ? 9.0 : 11.0) * scale.clamp(0.5, 2.0);
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color ?? (isDark ? Colors.white70 : Colors.black87),
          fontSize: fontSize,
          fontWeight: isEdge ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    );
    tp.layout(maxWidth: _nodeW * scale - 12 * scale);
    tp.paint(
      canvas,
      center - Offset(tp.width / 2, tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_FlowPainter old) =>
      old.scale != scale ||
      old.offset != offset ||
      old.nodes != nodes ||
      old.isDark != isDark;
}
