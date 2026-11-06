# Nexus – Production Plan

Companion to [REQUIREMENTS.md](./REQUIREMENTS.md). Goal: private beta on
Android + iOS, then public launch. Phases are ordered; each has exit criteria.

## Baseline (today)

Flutter + Riverpod; sample in-memory data behind repository interfaces
(activities, groups, chats, profile); no auth, backend, persistence,
notifications, or CI; placeholder app ID (`com.example.flutter_application_2`);
2 test files. Layering is already friendly to a backend swap.

## Backend: Supabase (approved 2026-11-05)

Project region: Canada Central (`ca-central-1`). Beta scope: email, Google,
Apple sign-in only; 16+ age gate; Toronto-first (America/Toronto, CAD).

Why: relational data (audiences, RSVPs, connections) maps to Postgres; Row Level
Security enforces visibility server-side; built-in auth (email, Google, Apple,
phone), realtime (chat), and storage; free tier then low fixed cost; no vendor
lock-in (open source, can self-host).
Alternative: Firebase (strong push/analytics, but Firestore struggles with
rule-based audience queries and costs scale per read). Push uses FCM either way.

## Phase 0 – Foundations (1 week)
- Rename app ID/display name (done: `ca.ynexus.nexus`, "Nexus"); icons and
  splash done. Dart package renamed to `nexus`.
- Environment config via `--dart-define` (done: `AppConfig`, `APP_ENV`,
  `SENTRY_DSN`; no secrets in git). Android flavors done (`dev` adds `.dev` app
  ID and "Nexus Dev" label; minSdk 26 for Sentry). iOS `dev`/`prod` flavors use
  iOS 15 (required by Sentry); macOS CI builds for both are configured and
  must pass to verify them.
- Lint hardening and CI (done: strict analyzer + extra lints, GitHub Actions
  runs format check, analyze, test on PRs/main); branch workflow remains.
- Error handling/logging convention; crash reporting (Sentry, chosen) (done:
  `bootstrap.dart` global handlers, `appLogger` in `utils/app_logger.dart`,
  SEVERE logs go to Sentry only when `SENTRY_DSN` is set). Remaining: create
  the Sentry project/DSN, add the DSN to CI/release builds, upload symbols,
  and add a user-consent/privacy-policy mention before beta.
- Routing (done: `go_router` in `lib/router.dart`, `authProvider` stub, auth
  redirect guard, placeholder sign-in screen). Detail/create screens still use
  `Navigator.push`; migrate to routes in Phase 1 with async repositories.
- Localization (en/fr) via Flutter gen-l10n + ARB files (done: ~185 keys in
  `lib/l10n`, `localeProvider` override, locale-aware dates, en/fr key parity
  test, Settings language switcher, `test/hardcoded_strings_test.dart` guard,
  localized interest catalog with English keys kept as stored values).
  Remaining: native French review (Phase 5). Interest keys should become stable
  IDs when the schema is designed (Phase 1).
- **Exit**: CI green, app builds for both platforms under the final ID.

## Phase 1 – Domain & backend design (1 week)
- Finalize remaining open questions in the requirements (§9).
- Schema: profiles, connections, blocks, groups/members, activities/events,
  audience rules, RSVPs, interests, looking-for, chats/messages, reports.
- RLS policies encoding the audience rules; migrations kept in repo.
- Make models serializable (JSON); split UI-only fields (`IconData`, `Color`)
  from persisted data; replace string `visibility` with the `Audience` type.
- Make repositories async (`Future`/`Stream`); providers become async notifiers.
- **Exit**: schema + policies reviewed; policy tests written.

## Phase 2 – Auth & profile (1–2 weeks)
- Email, Google, Apple sign-in; verification, reset,
  account deletion; session persistence.
- Onboarding with 16+ age gate;  profile, interests, looking-for backed by backend; avatar upload.
- **Exit**: users sign in on two devices and see the same profile.

## Phase 3 – Core social data (2–3 weeks)
- Activities/events CRUD, RSVP with atomic capacity (DB function/transaction),
  linked-event enrolment, audience-filtered queries and pagination.
- Connections, groups, discover people, updates feed; block/report.
- Loading/empty/error states on every screen.
- **Exit**: end-to-end flows work for 2+ real accounts; visibility tests pass.

## Phase 4 – Chat & notifications (1–2 weeks)
- Realtime 1:1/group chat, unread counts, history paging.
- Push (FCM/APNs): messages, requests, invites, event changes; preferences.
- **Exit**: messages and pushes delivered with app foreground/background.

## Phase 5 – Quality & safety (1–2 weeks)
- Tests: provider/unit, widget, integration (sign-in, create, RSVP, chat);
  backend policy tests.
- Accessibility and text-scaling pass; verify French layouts and translations.
- Moderation: report queue + admin action path, content policy, ToS/privacy
  policy, age gate; data export/delete verified.
- Performance: pagination, image sizing/caching, offline cache of reads.
- **Exit**: success criteria in REQUIREMENTS §8 met.

## Phase 6 – Private beta release (1 week)
- Signing, versioning, store metadata, privacy labels/data-safety forms.
- TestFlight + Play internal testing; feedback and crash monitoring.

## Phase 7 – Post-beta
- Business host accounts, verification, promotion/payments.
- Cosmetic premium features via an entitlement layer (RevenueCat or store
  billing); cost monitoring and quotas.
- Home screen decision; map/place search; ranking in Discover.

## Prototype → production work items (code-level)
- `ActivityItem`: string `visibility` and `eventType` → enums; no `Color`/`IconData`
  in persisted model; `guests` free-text → derived from RSVPs.
- Replace `sample_contacts.dart`, `sample_data.dart`, and sample audience
  directories with backend-driven data.
- Optimistic updates in notifiers need rollback on failure.
- Add tests alongside each migrated repository.

## Risks
- Visibility rules complexity (custom audiences): mitigate with DB-side
  evaluation and thorough policy tests.
- Store review for UGC and account deletion: build report/delete early.
- Phone auth: deferred past beta (SMS cost and abuse).
- French translation quality and string growth: extract strings early; use
  professional/native review.
- PIPEDA/CASL compliance and privacy policy review before beta.
- Scope creep from business features: keep post-beta.
- Solo-developer bandwidth: keep phases small and shippable.

## Next step
Continue Phase 0: verify the iOS flavor builds pass in macOS CI, then confirm
the Phase 0 exit criteria.
