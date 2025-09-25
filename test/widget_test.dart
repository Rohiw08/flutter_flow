// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flow/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Example app smoke test', (WidgetTester tester) async {
    // Build the app and pump frames to allow post-frame callbacks.
    await tester.pumpWidget(const MyApp());
    // Allow any post-frame callbacks (e.g., initial node additions) to run.
    await tester.pumpAndSettle();

    // Expect the Add Node button from the example to be present.
    expect(find.text('Add Node'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
