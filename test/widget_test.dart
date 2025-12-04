import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_azeoo/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter decrements test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the '+' icon twice
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

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

    // Tap the '+' icon several times
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

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
