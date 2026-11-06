import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passit/app/passit_app.dart';
import 'package:passit/config/app_config.dart';

void main() {
  testWidgets('Login route smoke (no Supabase config)', (
    WidgetTester tester,
  ) async {
    const config = AppConfig(supabaseUrl: '', supabaseAnonKey: '');

    await tester.pumpWidget(const PassitApp(config: config));
    await tester.pumpAndSettle();

    expect(find.textContaining('Registrieren'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
