import 'package:JsxposedX/common/widgets/overlay_window/overlay_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) {
        return MaterialApp(
          home: Scaffold(
            body: SizedBox.expand(child: child),
          ),
        );
      },
    );
  }


  testWidgets('renders custom header instead of title row', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        const OverlayWindow(
          header: Text('Header slot'),
          child: Text('Body'),
        ),
      ),
    );

    expect(find.text('Header slot'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });
}
