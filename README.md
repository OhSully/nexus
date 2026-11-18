# Nexus

Nexus is a Flutter prototype for discovering activities, managing plans, connecting
with people, chatting, and maintaining a profile.

The Android and iOS apps are configured for portrait orientation.

## Run locally

```sh
flutter pub get
flutter run --flavor dev --dart-define=APP_ENV=dev
```

Android has `dev` (`ca.ynexus.nexus.dev`, "Nexus Dev") and `prod`
(`ca.ynexus.nexus`, "Nexus") flavors, so both install side by side. Android
and iOS use the same flavors; both require `--flavor`. Use `prod` for the
production bundle ID and app name. Optional `--dart-define=SENTRY_DSN=...`
enables crash reporting. Dart error events are filtered to remove account
identifiers, request data, free-text error details, and breadcrumbs;
performance tracing is disabled. Complete anonymization has not been verified,
particularly for native crashes and network metadata. Keep Sentry disabled until
its privacy and event handling have been validated. Sentry may process data
outside Canada; Canadian hosting is a future goal.
The iOS deployment target is iOS 15, required by the current Sentry SDK.

## Sentry setup

Sentry project setup is deferred until before beta. Before enabling it, validate
Dart and native event payloads, network metadata, privacy settings, the in-app
notice, event delivery, and symbolication. Then configure these GitHub
repository settings for the Flutter project:

- Variable `SENTRY_DSN` with the project DSN. The app's `APP_ENV` distinguishes
  dev and prod events in Sentry.
- Variables `SENTRY_ORG` and `SENTRY_PROJECT` with the Sentry organization and
  project slugs.
- Secret `SENTRY_AUTH_TOKEN` with a Sentry auth token scoped to upload debug
  symbols. Never add this token to the repository.

The CI workflow only injects the DSN on pushes to `main`. When configured, it
uploads available debug symbols after successful Android and iOS flavor
builds. It does not upload application source code. A main-branch build fails
clearly if the DSN is present but any symbol-upload setting is missing.
Local builds remain disconnected unless a DSN is passed:

```sh
flutter run --flavor dev --dart-define=APP_ENV=dev --dart-define=SENTRY_DSN=<dev-dsn>
```

For a release build, use the matching flavor and DSN, include
`--split-debug-info=build/sentry-symbols/<flavor>`, then run
`dart run sentry_dart_plugin` with `SENTRY_ORG`, `SENTRY_PROJECT`, and
`SENTRY_AUTH_TOKEN` set in the environment.

Run the checks with:

```sh
flutter analyze
flutter test
```

## Coding-agent web guidance

The repository includes Google's [Modern Web Guidance](https://github.com/GoogleChrome/modern-web-guidance)
skill in `.agents/skills/modern-web-guidance`. Use it for direct HTML, CSS, or
JavaScript work in `web/` or explicitly requested web-target work; it does not
apply to Flutter/Dart UI or Android/iOS changes. Update the installed skill
from its upstream source with `npx modern-web-guidance@latest update`.

## App branding

The launcher icon and splash use the same Nexus N design. The square icon is
`assets/branding/nexus_icon.png`; its transparent foreground, extracted from
that icon, is `assets/branding/nexus_icon_foreground.png`. After updating the
icon and its transparent foreground, regenerate the platform assets with:

```sh
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

The app currently uses sample and in-memory data. Activities, profile edits,
connection requests, and messages are not synchronized to a backend or saved
between app launches. Audience selection is also a prototype: it starts empty,
selects individual people using group, sample past-event and interest filters,
and does not enforce privacy on a server. Group usage rankings are in-memory;
sample past events are listed in fixture order rather than from real attendance.
Beacons default to seven days; tapping refresh resets a beacon's expiry, while
holding refresh lets you choose the end of the local day, 1, 7 or 30 days.
Expired beacons are removed from the in-memory profile; backend persistence and
server-side expiry are not implemented.
