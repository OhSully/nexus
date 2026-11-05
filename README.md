# Nexus

Nexus is a Flutter prototype for discovering activities, managing plans, connecting
with people, chatting, and maintaining a profile.

The Android and iOS apps are configured for portrait orientation.

## Run locally

```sh
flutter pub get
flutter run
```

Run the checks with:

```sh
flutter analyze
flutter test
```

The app currently uses sample and in-memory data. Activities, profile edits,
connection requests, and messages are not synchronized to a backend or saved
between app launches.
