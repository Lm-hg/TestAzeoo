import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_azeoo/main.dart';

/// Helper function to increment the counter multiple times
Future<void> incrementCounter(WidgetTester tester, int times) async {
  for (int i = 0; i < times; i++) {
    await tester.tap(find.byTooltip('Increment').last);
    await tester.pump();
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await incrementCounter(tester, 1);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter decrements test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Increment counter twice
    await incrementCounter(tester, 2);

    // Verify counter is at 2
    expect(find.text('2'), findsOneWidget);

    // Tap the '-' icon
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Verify that our counter has decremented.
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter reset test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Increment counter three times
    await incrementCounter(tester, 3);

    // Verify counter is at 3
    expect(find.text('3'), findsOneWidget);

    // Tap the reset button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Verify that our counter has reset to 0.
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Expansion toggle test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the expand button
    expect(find.text('Expand'), findsOneWidget);

    // Tap the expand button
    await tester.tap(find.text('Expand'));
    await tester.pumpAndSettle();

    // Verify the button text changed to 'Collapse'
    expect(find.text('Collapse'), findsOneWidget);
    expect(find.text('Expand'), findsNothing);
  });

  testWidgets('Skills list is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that skills are displayed
    expect(find.text('Flutter Skills Demonstrated:'), findsOneWidget);
    expect(find.text('StatefulWidget & State Management'), findsOneWidget);
    expect(find.text('Material Design 3'), findsOneWidget);
    expect(find.text('Animated Widgets'), findsOneWidget);
  });
}
