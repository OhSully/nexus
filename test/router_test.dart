import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/main.dart';
import 'package:nexus/providers/auth_provider.dart';
import 'package:nexus/screens/home_screen.dart';
import 'package:nexus/screens/sign_in_screen.dart';

class _SignedOut extends AuthNotifier {
  @override
  AuthStatus build() => AuthStatus.signedOut;
}

void main() {
  testWidgets('signed-out users are sent to sign-in, then home after', (
    tester,
  ) async {
    await tester.pumpWidget(
      NexusApp(overrides: [authProvider.overrideWith(_SignedOut.new)]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SignInScreen), findsNothing);
  });

  testWidgets('signed-in users land on home', (tester) async {
    await tester.pumpWidget(const NexusApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
