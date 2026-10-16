import 'package:JsxposedX/core/themes/ai_activation_theme.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/ai_overlay_collapsed_ball.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('does not render highlight ring when not highlighted', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: AiOverlayCollapsedBall(isHighlighted: false, onTap: () {}),
      ),
    );

    expect(find.byKey(AiOverlayCollapsedBall.highlightRingKey), findsNothing);
    expect(find.byKey(AiOverlayCollapsedBall.innerBallKey), findsOneWidget);
  });

  testWidgets('renders gradient highlight ring when highlighted', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: AiOverlayCollapsedBall(isHighlighted: true, onTap: () {}),
      ),
    );

    final ringFinder = find.byKey(AiOverlayCollapsedBall.highlightRingKey);
    expect(ringFinder, findsOneWidget);
    expect(find.byKey(AiOverlayCollapsedBall.innerBallKey), findsOneWidget);

    final ringWidget = tester.widget<Container>(ringFinder);
    final decoration = ringWidget.decoration! as BoxDecoration;
    expect(decoration.gradient, aiActivationGradient);
    expect(decoration.boxShadow, isNotEmpty);
  });
}

Widget _buildTestApp({required Widget child}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox.square(dimension: 44, child: child)),
        ),
      );
    },
  );
}
