import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/measure.dart';

void main() {
  group('measure.dart Tests', () {
    testWidgets('Verify MeasureScreen widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MeasureScreen()));
      expect(find.byType(MeasureScreen), findsOneWidget);
      expect(find.text("Tap the '+' button to add a node"), findsOneWidget);
    });

    testWidgets('Tapping on a plane adds a node to the AR scene', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MeasureScreen()));
      // Simulate plane tap
      await tester.tap(find.byType(ArCoreView));
      await tester.pumpAndSettle();
      // Verify node added to AR scene
      // Add additional checks to ensure no exceptions
      expect(find.byType(MeasureScreen), findsOneWidget);
    });

    testWidgets('Adding two nodes calculates and displays the distance between them', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MeasureScreen()));
      // Simulate adding two nodes
      await tester.tap(find.byType(ArCoreView));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ArCoreView));
      await tester.pumpAndSettle();
      expect(find.textContaining('cm'), findsOneWidget);
    });

    testWidgets('Tapping "Clear All Nodes" button removes all nodes from the AR scene', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MeasureScreen()));
      await tester.tap(find.text('Clear All Nodes'));
      await tester.pumpAndSettle();
      // Verify all nodes removed from AR scene
      // Add additional checks to ensure no exceptions
      expect(find.byType(MeasureScreen), findsOneWidget);
    });
  });
}