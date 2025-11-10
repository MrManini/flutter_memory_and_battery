// Flutter Memory and Battery Optimization Template Tests
//
// These tests verify the basic structure and functionality of the app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_memory_and_battery/main.dart';
import 'package:flutter_memory_and_battery/core/constants/app_constants.dart';

void main() {
  testWidgets('App starts and displays home page', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify the app title is displayed
    expect(find.text(AppConstants.appTitle), findsOneWidget);

    // Verify the welcome message is displayed
    expect(find.text('Welcome! 👋'), findsOneWidget);
  });

  testWidgets('Memory optimization section is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify memory optimization section is present
    expect(find.text('Memory Optimization'), findsOneWidget);
  });

  testWidgets('Battery optimization section is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify battery optimization section is present
    expect(find.text('Battery Optimization'), findsOneWidget);
  });

  testWidgets('Example cards are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that at least one example card is displayed
    expect(find.byType(Card), findsWidgets);
  });
}
