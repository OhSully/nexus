# Nexus – Production Plan

Companion to [REQUIREMENTS.md](./REQUIREMENTS.md). The immediate goal is a
single-device pre-alpha using real backend accounts and synthetic test data.
It is a development milestone, not a release to outside testers. After that,
build toward an invite-only private beta and eventually a public launch.

## Baseline (today)

Flutter + Riverpod UI prototype with sample, in-memory data. The auth guard
and sign-in are placeholders; there is no real backend, persistent user data,
chat delivery, or push notifications. Android and iOS have `dev` and `prod`
flavors, app branding, and CI checks; both iOS flavors have built in macOS CI.
Tests cover prototype providers, routing, localization, and UI flows, not
backend authorization or multi-user behavior.

Sentry can be configured by DSN but no Sentry project is connected. Additional
privacy filtering, a notice, and CI upload wiring are in the current worktree;
native crash and network metadata behavior have not been verified. Keep crash
reporting off for pre-alpha and do not claim complete anonymization yet.

## Constraints and backend

- Supabase is the selected backend; prefer Canada Central (`ca-central-1`)
  when available. Pre-alpha uses an isolated development project, not a
  future beta database. Do not embed service-role keys or other secrets in
  the app or repository.
- Pre-alpha and beta have a zero-total-spend constraint. Check free-tier
  project, database, storage, email, and CI limits before provisioning;
  record any unavoidable costs as blockers rather than assuming payment.
- Free hosting can pause and may not provide automatic backups. Use synthetic
  pre-alpha data and plan tested backups, recovery, monitoring, and limits
  before accepting real user data.
- For zero-cost beta distribution, use directly installed Android builds;
  iOS is limited to personal-device testing for now. TestFlight and Play
  distribution require paid developer memberships/registration and remain
  future options when funding is available.

## Phase 0 – Foundations

- Done: app ID `ca.ynexus.nexus`, display name, icons, splash, `dev`/`prod`
  flavors, Android minimum API 26, and iOS 15 minimum.
- Done: CI formatting, analysis, tests, and iOS flavor builds; routing,
  localization, and logging foundations. Authentication is still a stub.
- Deferred until before beta: create the Sentry project, configure credentials,
  inspect Dart and native crash payloads and network metadata, confirm privacy
  settings and a truthful notice, test event delivery and symbolication, and
  define crash-free measurement. Canadian-hosted crash reporting is a future
  goal.
- **Exit for pre-alpha**: current checks pass and a development build runs on
  the test device. Sentry and store release are not pre-alpha blockers.

## Phase 1 – Single-device pre-alpha: accounts, profiles, activities

Build one narrow end-to-end slice before expanding the product. Use two
developer-controlled backend accounts with synthetic profile and activity
content. Switching users means signing out and signing in as the other account
on the same device; it is not a local identity simulation.

1. **Development backend and setup**
   - Provision an isolated free Supabase development project, preferably in
     Canada Central; define setup and migration commands without committing
     credentials. Record any account setup requiring owner action.
   - Disable public signup for this milestone and provision the two test
     accounts securely; do not rely on client-side controls. Decide how to
     handle email verification within free-tier SMTP limits without weakening
     the later beta authentication requirements.
   - Configure the development endpoint and public client key separately from
     future beta credentials. Build-time values are not secrets.
2. **Minimal schema and authorization**
   - Add versioned migrations for profiles and activities with stable user and
     record IDs. Define the small visibility policy needed for the test,
     including a deliberately shared activity; deny unintended reads/writes by
     default. This is not a substitute for the full audience model.
   - Add backend policy tests for both accounts, unauthenticated access,
     ownership, allowed sharing, denied reads/writes, and cross-account edits.
     Use only synthetic data.
3. **Application slice**
   - Replace the fake sign-in for this slice with real email/password auth,
     session restoration, sign-out, and clear error/loading states. Ensure
     account-scoped providers and cached state are cleared on sign-out or
     account change.
   - Make the needed profile and activity repositories asynchronous and
     backend-backed. Persist an editable minimal profile and create/list/view
     a shared activity. Remove sample data from these exercised paths; leave
     unfinished prototype features clearly out of scope.
   - Test failed requests, session restoration, account switching, and server
     authorization; run formatting, analysis, and Flutter tests.
4. **Pre-alpha acceptance on one device**
   - Sign in as test account A, edit a profile, create an activity shared for
     this test and an A-only activity, then sign out. Sign in as B, edit B's
     separate profile, and see the shared activity but not A-only data; B
     cannot edit A's profile or activity. Unauthenticated and unauthorized
     backend requests are denied.
   - Switch back to A, restart the app, then switch to B again. Verify both
     profiles and the activities persist with the correct access and expected
     session behavior. Record device/platform, build, steps, and results.

Pre-alpha does not require social sign-in, general self-service registration,
full custom audiences, RSVP, chat, notifications, Sentry, or store
distribution. Do not expose unfinished screens as working features or invite
external users with real data before the relevant beta gates.

## Phase 2 – Expand authentication and domain rules

- Design the full schema and server-side policies for connections, groups,
  blocks, activities/events, audiences, RSVPs, chats, messages, and reports.
  Keep migrations in the repository and test allowed and denied access using
  multiple identities, including realtime and storage access.
- Beta signup is limited server-side to approved email addresses, including
  social sign-in and identity-linking paths. Address email verification,
  account caps, revocation, Apple private relay addresses, recovery, and a
  suitable free SMTP provider. Add Google and Apple sign-in before beta; phone
  sign-in remains post-beta.
- Replace the former 16+ target with an adults-only age-of-majority gate for
  the user's jurisdiction. Define supported jurisdictions, self-declaration,
  data retention, and legal review before enabling real signups.
- Define dynamic audiences, explicit inclusion/exclusion precedence, and
  mutual blocks across discovery, shared spaces, direct contact, and
  notifications. Specify revocation and cached data behavior.
- Implement profile, interests, and looking-for entries with stable IDs,
  proper viewer-specific access, and persisted settings.
- Separate UI-only model fields from persisted data, replace prototype
  visibility strings with the agreed audience model, and migrate sample
  contacts and directories to backend data. Add tests alongside migrated
  repositories; roll back optimistic updates on failure.
- Migrate remaining detail/create navigation to routes as needed while replacing
  prototype flows.
- **Exit**: schema and policies reviewed; identity, account-switching, and
  authorization tests pass. Do not broaden beyond synthetic data until the
  necessary privacy and safety gates are met.

## Phase 3 – Core social data

- Implement activities/events CRUD, connections, groups, discover, and
  updates with async repositories, pagination, and loading/error states.
- Implement individual RSVPs and capacity enforcement atomically on the
  server. The activity host chooses linked-event enrollment; a linked activity
  RSVP must not be confirmed without an event spot when the link requires
  one. On unlink/change, cancel only RSVPs created by that link, preserving
  independent RSVPs. Define existing-attendee, full-event, permission, and
  concurrent-change edge cases before implementation.
- Implement mutual blocking and reporting with server-side enforcement.
- **Exit**: multi-account flows and negative visibility/capacity tests pass.

## Phase 4 – Chat and notifications

- Implement persisted 1:1/group messages, realtime delivery, unread counts,
  history, and block/report behavior. Encrypt data in transit and at rest;
  end-to-end encryption is deferred until after beta.
- Add push notification permissions, device-token lifecycle, preferences,
  privacy-safe content, delivery handling, and authorization checks.
- **Exit**: messages persist and authorized users receive notifications in
  supported app states; blocked and unauthorized paths are tested.

## Phase 5 – Beta safety and quality gates

- Complete account deletion and export, data retention and tested
  backup/restore (including media), moderation/report handling, content policy,
  bilingual terms/privacy documents, support contact, and legal review.
- Complete image sizing/caching, graceful offline reads, pagination, and
  rollback for failed optimistic updates.
- Complete Sentry setup and privacy validation from Phase 0, or explicitly
  revisit the beta crash-monitoring requirement before release.
- Test accessibility, Canadian French, real devices, two-device persistence,
  backend policies, signup/age gates, RSVP concurrency, and key integrations.
- Configure cost/usage monitoring, rate limits, cohort caps, and a safe
  recovery procedure; confirm all chosen services fit the zero-spend limit.
- **Exit**: beta criteria in REQUIREMENTS §8 are met or any blocker is
  explicitly resolved before real testers are invited.

## Phase 6 – Invite-only private beta

- Prepare a versioned Android direct-install build, using a persistent,
  protected release signing key and a trusted distribution/update process.
  Limited iOS personal-device testing has provisioning/expiration limits and
  does not replace broader iOS beta coverage.
- Use server-enforced approved-email access, controlled cohorts, feedback,
  and crash monitoring. Alpha, if used, precedes beta and follows the same
  safeguards appropriate to its data and participants.
- Revisit TestFlight, Play testing, store metadata, privacy labels, and
  account-deletion web requirements when store distribution is funded.

## Phase 7 – Post-beta

- Evaluate end-to-end encryption, business hosts, promotion/payments, cosmetic
  entitlements, map/place search, discovery ranking, and the Home screen.

## Risks and open decisions

- Privacy rules, linked enrollment, and shared-space blocking need precise
  edge-case decisions before their respective implementations.
- Resolve linked-event enrollment with existing attendees beyond capacity,
  independent RSVPs, activity departures, event changes, concurrency, and
  event authorization.
- Zero-cost hosting, SMTP, backups, and device distribution may limit
  reliability and scale; do not silently relax the budget.
- Confirm supported jurisdictions and age-of-majority handling, ownership of
  the app ID/domain, native French review, cohort caps, and cost thresholds.
- Timeline estimates are provisional; do not infer completion from prototype
  screens or passing widget tests.

## Next step

Start Phase 1 by defining the minimal development Supabase project setup,
profile/activity schema and RLS tests, then implement the real sign-in and
single-device account-switching slice. Owner access is needed to provision the
project; do not wait for Sentry to begin.
