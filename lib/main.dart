import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NexusApp());
}

class NexusApp extends StatelessWidget {
  /// [overrides] lets tests or a backend swap in different repositories.
  const NexusApp({super.key, this.overrides = const []});

  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        title: 'Nexus',
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
