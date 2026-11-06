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
flavors require `--flavor`. iOS flavors are not set up yet, so omit
`--flavor` when running on iOS. Optional `--dart-define=SENTRY_DSN=...` enables
crash reporting.

Run the checks with:

```sh
flutter analyze
flutter test
```

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
between app launches.
