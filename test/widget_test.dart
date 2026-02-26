import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vivocare/app/app.dart';

void main() {
  testWidgets('Splash moves to login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const VivoCareApp());

    expect(find.text('VivoCare'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
