import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omra_companion/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Omra Companion - HomeScreen UI Smoke Test', (WidgetTester tester) async {
    // Build the HomeScreen within a standard MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Trigger frame updates
    await tester.pumpAndSettle();

    // Verify that the welcome header and section titles are successfully rendered.
    expect(find.text('Bienvenue, Pèlerin'), findsOneWidget);
    expect(find.text('Votre Progression'), findsOneWidget);
    expect(find.text('Accès Rapide'), findsOneWidget);
  });
}
