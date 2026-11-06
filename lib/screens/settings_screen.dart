import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/audience.dart';
import '../providers/providers.dart';

/// App settings. Values live in providers and are not persisted yet.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // Language names are shown in their own language so they stay readable
  // regardless of the current app language.
  static const _languages = <(Locale, String)>[
    (Locale('en'), 'English'),
    (Locale('fr'), 'Français'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final enabledNotifs = ref.watch(notificationPrefsProvider);
    final defaultAudience = ref.watch(defaultAudienceProvider);

    void showUnavailable() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsUnavailableYet)));
    }

    final notifLabels = {
      NotificationKind.messages: l10n.settingsNotifMessages,
      NotificationKind.connectionRequests: l10n.settingsNotifRequests,
      NotificationKind.invitations: l10n.settingsNotifInvitations,
      NotificationKind.eventChanges: l10n.settingsNotifEventChanges,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          _SectionTitle(l10n.settingsLanguage),
          _LanguageTile(
            key: const ValueKey('language-system'),
            title: l10n.settingsLanguageSystem,
            subtitle: l10n.settingsLanguageSystemSubtitle,
            isSelected: selected == null,
            onTap: () => notifier.set(null),
          ),
          for (final (locale, name) in _languages)
            _LanguageTile(
              key: ValueKey('language-${locale.languageCode}'),
              title: name,
              isSelected: selected?.languageCode == locale.languageCode,
              onTap: () => notifier.set(locale),
            ),
          const Divider(),
          _SectionTitle(l10n.settingsAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              key: const ValueKey('theme-mode'),
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.settingsThemeDark),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          const Divider(),
          _SectionTitle(l10n.settingsNotifications),
          for (final kind in NotificationKind.values)
            SwitchListTile(
              key: ValueKey('notif-${kind.name}'),
              title: Text(notifLabels[kind]!),
              value: enabledNotifs.contains(kind),
              onChanged: (v) => ref
                  .read(notificationPrefsProvider.notifier)
                  .setEnabled(kind, enabled: v),
            ),
          _Hint(l10n.settingsNotificationsNote),
          const Divider(),
          _SectionTitle(l10n.settingsPrivacy),
          _Hint(l10n.settingsCrashReportingNote),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.settingsDefaultAudience),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<AudienceType>(
              key: const ValueKey('default-audience'),
              segments: [
                ButtonSegment(
                  value: AudienceType.friends,
                  label: Text(AudienceType.friends.label(l10n)),
                ),
                ButtonSegment(
                  value: AudienceType.public,
                  label: Text(AudienceType.public.label(l10n)),
                ),
              ],
              selected: {defaultAudience.type},
              onSelectionChanged: (s) => ref
                  .read(defaultAudienceProvider.notifier)
                  .set(
                    s.first == AudienceType.public
                        ? Audience.public
                        : Audience.friends,
                  ),
            ),
          ),
          _Hint(l10n.settingsDefaultAudienceHelp),
          const Divider(),
          _SectionTitle(l10n.settingsAccount),
          ListTile(
            key: const ValueKey('export-data'),
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.settingsExportData),
            onTap: showUnavailable,
          ),
          ListTile(
            key: const ValueKey('delete-account'),
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.settingsDeleteAccount,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: showUnavailable,
          ),
          const Divider(),
          ListTile(
            key: const ValueKey('about'),
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAbout),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: l10n.appTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: isSelected ? const Icon(Icons.check) : null,
      selected: isSelected,
      onTap: onTap,
    );
  }
}
