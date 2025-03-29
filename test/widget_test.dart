import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helix_indicator/helix_indicator.dart';

void main() {
  testWidgets('HelixIndicator renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HelixIndicator(
            color: Colors.red,
            size: 50.0,
          ),
        ),
      ),
    );
    expect(find.byType(HelixIndicator), findsOneWidget);
  });
}
