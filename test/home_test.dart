import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/home.dart';
import 'package:myapp/ar.dart';
import 'package:myapp/measure.dart';

void main() {
  group('home.dart Tests', () {
    testWidgets('Verify HomePage widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('PicNoid'), findsOneWidget);
    });

    testWidgets('Tapping chair icon navigates to ARScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.tap(find.byIcon(Icons.chair));
      await tester.pumpAndSettle();
      expect(find.byType(ARScreen), findsOneWidget);
    });

    testWidgets('Tapping draw icon navigates to MeasureScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.tap(find.byIcon(Icons.draw));
      await tester.pumpAndSettle();
      expect(find.byType(MeasureScreen), findsOneWidget);
    });
  });
}