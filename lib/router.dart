import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const signIn = '/sign-in';
}

/// Top-level routes and the auth guard. Detail/create screens are still pushed
/// with `Navigator` because they take in-memory objects and callbacks; they
/// move to routes once repositories are async and addressable by id.
final routerProvider = Provider<GoRouter>((ref) {
  final authChanges = ValueNotifier<AuthStatus>(ref.read(authProvider));
  ref.listen<AuthStatus>(authProvider, (_, next) => authChanges.value = next);
  ref.onDispose(authChanges.dispose);

  final router = GoRouter(
    refreshListenable: authChanges,
    redirect: (context, state) {
      final signedIn = authChanges.value == AuthStatus.signedIn;
      final onSignIn = state.matchedLocation == AppRoutes.signIn;
      if (!signedIn) {
        return onSignIn ? null : AppRoutes.signIn;
      }
      return onSignIn ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
