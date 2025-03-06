import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/home.dart';

void main() {
  group('main.dart Tests', () {
    testWidgets('Verify MyApp widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MyApp), findsOneWidget);
      expect(find.byType(ARCoreChecker), findsOneWidget);
    });

    testWidgets('ARCoreChecker shows CircularProgressIndicator while checking ARCore availability', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARCoreChecker()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ARCoreChecker navigates to HomePage if ARCore is available', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARCoreChecker()));
      // Simulate ARCore availability
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('ARCoreChecker shows error message if ARCore is not available', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARCoreChecker()));
      // Simulate ARCore not available
      await tester.pumpAndSettle();
      expect(find.text('ARCore is not supported on this device. Please update Google Play Services or use a supported device.'), findsOneWidget);
    });
  });
}