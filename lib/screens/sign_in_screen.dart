import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

/// Placeholder sign-in page; real providers (email, Google, Apple) land in
/// Phase 2.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text(l10n.signInTagline, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => ref.read(authProvider.notifier).signIn(),
                child: Text(l10n.signInContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
