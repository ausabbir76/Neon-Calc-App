import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_calc/src/app/calculator_app.dart';

void main() {
  // Helper to setup the calculator app for testing
  Future<void> setupCalculator(WidgetTester tester) async {
    // Set a consistent screen size for tests
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();
  }

  testWidgets('App starts in basic mode and displays essential elements', (
    tester,
  ) async {
    await setupCalculator(tester);

    // Verify logo and basic keys are present
    expect(find.text('NEON CALC'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);

    // Verify scientific keys are NOT present initially
    expect(find.text('sin'), findsNothing);
    expect(find.text('log'), findsNothing);
  });

  testWidgets('Mode switcher toggles between Basic and Scientific', (
    tester,
  ) async {
    await setupCalculator(tester);

    // Switch to Scientific mode
    await tester.tap(find.text('Scientific'));
    await tester.pumpAndSettle();

    // Verify scientific keys appear
    expect(find.text('sin'), findsOneWidget);
    expect(find.text('log'), findsOneWidget);

    // Verify some basic keys (like numbers) are gone in this specific UI implementation
    expect(find.text('7'), findsNothing);

    // Switch back to Basic mode
    await tester.tap(find.text('Basic'));
    await tester.pumpAndSettle();

    expect(find.text('sin'), findsNothing);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('Basic calculation flow works', (tester) async {
    await setupCalculator(tester);

    // Perform 7 + 8 = 15
    await tester.tap(find.text('7'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('8'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    // The result '15' should be visible
    expect(find.text('15'), findsWidgets);
  });
}
