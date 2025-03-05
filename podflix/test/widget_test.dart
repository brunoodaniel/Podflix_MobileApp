import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podflix/main.dart';

void main() {
  testWidgets('Login screen has email, password fields and login button', (WidgetTester tester) async {
    await tester.pumpWidget(PodflixApp());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('Navigates to home screen after login', (WidgetTester tester) async {
    await tester.pumpWidget(PodflixApp());

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('PODFLIX'), findsOneWidget);
    expect(find.text('Podcast de Exemplo'), findsOneWidget);
  });

  testWidgets('Logout navigates back to login screen', (WidgetTester tester) async {
    await tester.pumpWidget(PodflixApp());

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
  });
}
