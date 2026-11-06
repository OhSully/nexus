import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { signedOut, signedIn }

/// Placeholder until real auth arrives (Phase 2). It starts signed in so the
/// prototype keeps working; the router guard already reacts to changes, and
/// tests can override it to exercise the signed-out flow.
class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.signedIn;

  void signIn() => state = AuthStatus.signedIn;

  void signOut() => state = AuthStatus.signedOut;
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);
