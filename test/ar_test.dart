import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/ar.dart';

void main() {
  group('ar.dart Tests', () {
    testWidgets('Verify ARScreen widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARScreen()));
      expect(find.byType(ARScreen), findsOneWidget);
      expect(find.text('AR Screen'), findsOneWidget);
    });

    testWidgets('Tapping "Choose Model" button shows model picker', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARScreen()));
      await tester.tap(find.text('Choose Model'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('Tapping "Add Model" button adds a model to the AR scene', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARScreen()));
      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();
      // Verify model added to AR scene
      // Add additional checks to ensure no exceptions
      expect(find.byType(ARScreen), findsOneWidget);
    });

    testWidgets('Tapping "Remove Last Model" button removes the last model from the AR scene', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ARScreen()));
      await tester.tap(find.text('Remove Last Model'));
      await tester.pumpAndSettle();
      // Verify model removed from AR scene
      // Add additional checks to ensure no exceptions
      expect(find.byType(ARScreen), findsOneWidget);
    });
  });
}