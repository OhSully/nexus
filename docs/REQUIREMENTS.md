# Nexus – Requirements & Goals

Status: draft (updated 2026-11-06). Update this file as decisions are made; record
changes in the Decision Log at the bottom.

## 1. Vision

Nexus helps people discover activities and events, plan them with friends,
connect with people who share interests, and chat. Individuals use it first;
local businesses later host public events and activities.

## 2. Goals

1. **Pre-alpha first**: prove real accounts, profiles, and a shared activity
   using synthetic data on one device; then work toward an invite-only beta.
2. **Production quality**: real accounts, persisted/synced data, enforced
   privacy, crash reporting, automated tests and CI.
3. **Low operating cost**: costs should be covered, not profit-driven (see §7).
4. **Privacy by design**: audience/visibility rules are enforced on the server,
   not only in the UI.

## 3. Non-goals (for now)

- Web and Windows launch (code stays buildable, but not supported).
- Home screen redesign. It is in limbo (see §5.8); minimal effort until decided.
- Ads, selling user data, or paywalling core functionality.
- Business tooling beyond basic verified-host posting (post-beta).

## 4. Users

- **Individual** (launch): an adult; creates/joins activities, connects, chats.
- **Business host** (later): local business that posts public events/activities.
- **Admin/moderator** (needed before public launch): handles reports.

## 5. Functional requirements

Current prototype state is noted per area. All data is currently in-memory
sample data behind repository interfaces (`lib/data/repositories.dart`).

### 5.1 Accounts & authentication (new)
- Sign-in with email/password, Google, and Apple. Phone number sign-in is
  deferred until after beta (SMS cost).
- Pre-alpha uses two developer-controlled email/password accounts, with
  public signup disabled. Beta account creation is limited server-side to
  approved email addresses, including social signup paths.
- Sign in with Apple is required on iOS if other social logins are offered.
- Email verification, password reset, account deletion (store requirement)
  and data export.
- Session persistence; secure sign-out.

### 5.2 Activities & events (prototype exists)
- Create/edit/delete activities and events: title, description, location, time,
  hosts, capacity, RSVP on/off, "happens regardless", event type.
- RSVP/enroll with capacity enforcement; link an activity to an event
  (enrol/unenrol counts). Counts must be consistent under concurrent use.
- The activity host chooses linked-event enrollment. When the link requires
  event enrollment, do not confirm an activity RSVP without an event spot.
  Unlinking or changing the event cancels only event RSVPs created by that
  link; preserve independently made RSVPs. Specify remaining edge cases
  before implementation.
- Location with real place search/map link (later); time zones handled correctly.
- Edit/cancel notifies attendees.

### 5.3 Audience & visibility (prototype exists)
- Audience types: Public, Friends, Groups, Past attendees, Friends with
  interests, Custom (rules: categories intersected, choices unioned, explicit
  people included). Resolve inclusion/exclusion precedence before implementing
  the full audience model.
- Applies to activities/events and to profile "looking for" entries.
- Access follows current audience membership. The server must enforce who can
  see/join; clients never receive hidden items.

### 5.4 People & groups (prototype exists)
- Connections (request/accept/remove), updates feed, discovering people,
  custom groups.
- Block and report users; blocking prevents direct contact and hides users
  from each other. Define safe behavior in shared spaces.
- Contacts come from real users, replacing `sample_contacts.dart`.

### 5.5 Chat (prototype exists)
- 1:1 and group chats, real-time delivery, unread counts, history.
- Push notifications for messages, requests, invites, event changes.
- Respect blocks; report messages.
- Encrypt in transit and at rest; end-to-end encryption is deferred until
  after beta.

### 5.6 Profile (prototype exists)
- Bio, interests (catalog + custom, with notes), "looking for" entries with
  audience, avatar. Visibility enforced per viewer.

### 5.7 Discover & plans (prototype exists)
- Discover: browse relevant public/visible activities (search, filters,
  location-based; ranking later).
- Plans: my upcoming/past activities and events.

### 5.8 Home (undecided)
- Purpose undefined; either removed or repurposed. Do not invest until decided.
  The current Home screen hosts navigation; make it swappable in later work.

### 5.9 Business hosts (post-beta)
- Verified business accounts, public event posting, host profile page.
- Paid tiers/fees TBD (see §7).

## 6. Non-functional requirements

- **Platforms**: Android and iOS, portrait (current); Android API 26+ and
  iOS 15+. Pre-alpha is verified on one available device.
- **Privacy/security**: server-side authorization on every read/write;
  encrypted transport; secrets never in the repo; minimal data collected;
  privacy policy and terms; delete & export of user data; an adults-only gate
  based on age of majority in the user's jurisdiction. Define supported
  jurisdictions, self-declaration and retention with legal review.
  Crash diagnostics should be anonymized and used only to fix bugs and improve
  the app for users. Verify Dart and native crash paths and network metadata
  before enabling Sentry or claiming complete anonymization. Sentry may
  process data outside Canada; Canadian hosting is a future goal. Operational
  account and social data remain identifiable as needed for the app.
- **Region/compliance**: initial market is Canada (Toronto residents first).
  Follow PIPEDA (consent, purpose limitation, breach reporting) and CASL for
  any email/push marketing. Host data in a Canadian region (Supabase
  `ca-central-1`) where possible. Times default to America/Toronto; currency
  CAD. French-language requirements (incl. Quebec Law 25 and Bill 96) apply to
    a bilingual product; confirm with legal review. Not legal advice; have the privacy policy and terms reviewed.
- **Offline/performance**: cached reads, graceful failure, optimistic UI where
  safe; list screens paginate.
- **Reliability**: crash reporting, structured error handling (no silent
  failures), analytics limited to product metrics with consent. Crash
  diagnostics are not product analytics.
- **Quality**: `flutter analyze` clean; unit + widget tests for providers and
  key flows; integration tests for sign-in, create, RSVP, chat; CI on every PR.
- **Accessibility**: screen-reader labels, dynamic text sizes, contrast.
- **Localization (bilingual by design)**: English (en-CA) and French (fr-CA)
  are both first-class. No hardcoded user-facing strings; use Flutter ARB
  localization from the start. Follow device language with an in-app override.
  Layouts must tolerate longer French text. Dates, times, and currency use
  locale formatting. Legal documents, store listings, notifications, and
  server-generated messages (errors, emails) are also bilingual. Users' own
  content is not translated. Design for adding more locales later.
- **Moderation/safety**: report flows, content policy, an admin way to act on
  reports (required by app stores for UGC).
- **Release**: app ID `ca.ynexus.nexus`, name/icons/splash and dev/prod flavors
  are in place. Signing, versioning, direct Android distribution and store
  listings remain; a staging flavor is not currently configured.

## 7. Business model & cost constraints

- Pre-alpha and beta have a zero-total-spend constraint, including developer
  program fees. Surface unavoidable costs as blockers; do not assume payment.
- Longer term, aim to only cover costs.
- Core features stay free for individuals.
- Possible revenue (ideas, not committed):
  - Business hosts pay to post/promote events.
  - Optional cosmetic extras for individuals: premium emoji, themes/skins,
    background colours, extra storage. These must not affect core quality.
- Design implication: choose infrastructure with a generous free tier and
  predictable scaling; keep media storage and SMS (phone auth) costs in check.
- Premium/entitlement checks should be a thin, separate layer so they can be
  added later without reworking features.

## 8. Release phases & success criteria

### Single-device pre-alpha

- Use real backend email/password accounts, not simulated local identities.
  Provision two developer-controlled test accounts and keep public signup
  disabled. Use only synthetic profile and activity content.
- On one device, sign in as account A, edit its profile and create a shared
  activity and an A-only activity. Sign out and sign in as B; B edits its own
  profile, sees the shared activity but not A-only data, and cannot edit A's
  data. Sign back in as A, restart, and switch to B again to verify both
  profiles, activities, access, and expected session behavior persist.
- Backend tests must verify allowed and denied access for both accounts and
  unauthenticated requests. Account switching must clear stale private state.
- Social sign-in, RSVP, chat, notifications, Sentry, and distribution to
  outside testers are not required for this milestone. They remain later work.

### Alpha and private beta

- A small, invite-only alpha may precede the invite-only private beta.
- Before inviting outside testers or using real personal data, complete the
  privacy, security, moderation, data handling, and legal safeguards
  appropriate to that testing; synthetic pre-alpha is not a waiver.
- Only people on the approved invite list can create accounts during these
  phases. Enforce an approved-email allowlist on the server for every signup
  path. Expand in controlled cohorts; set a cohort/account cap before each
  phase, with the initial cap still TBD.
- Invite-only access limits new accounts, not the server usage of each account.
  Before increasing a cohort, monitor backend usage and costs, configure alerts,
  and apply available quotas/rate limits to reduce unexpected usage.
- Testers can register, build profile, connect, create and RSVP to
  activities, and chat, with data persisted across devices.
- Visibility rules verified by automated tests against the backend.
- No known data-leak or crash-on-launch issues; crash-free sessions ≥ 99%.
- With zero spending, beta distribution is Android direct-install; iOS is
  limited to personal-device testing. TestFlight and Play internal testing
  remain future goals contingent on funding developer program fees.

## 9. Open questions

1. Location model: free-text vs. map/place search; discovery radius
   (Toronto-first).
2. What is the Home screen (remove, feed, dashboard)?
3. Definition of "friend": mutual connections? Are follows needed?
4. Where do business events appear in Discover vs. friends' content?
5. App name/branding ("Nexus" availability on stores), app ID, domain.
6. Who translates/reviews French copy (Canadian French, not machine-only)?
7. Initial alpha/beta cohort caps and backend usage/cost alert thresholds.
8. Supported jurisdictions and implementation of the age-of-majority gate.
9. Custom audience inclusion/exclusion precedence, shared-space blocking, and
   linked-event capacity and RSVP edge cases.
10. Free SMTP provider, beta backup/restore and recovery expectations, and
    the path to broader iOS testing when funding is available.

## 10. Decision log

|    Date    | Decision |
|------------|----------|
| 2026-11-05 | Target: private beta on Android + iOS (distribution revised below). |
| 2026-11-05 | Sign-in: email/password, Google, Apple, phone. |
| 2026-11-05 | Backend: Supabase (approved). |
| 2026-11-05 | Phone sign-in dropped from beta scope. |
| 2026-11-05 | Minimum age 16+ (superseded below); initial market Canada (Toronto). |
| 2026-11-05 | English and French supported by design from the start. |
| 2026-11-05 | Crash reporting: Sentry. |
| 2026-11-05 | App ID (Android + iOS): `ca.ynexus.nexus`; display name "Nexus". Permanent once published; confirm domain ownership. |
| 2026-11-05 | Monetization: cost recovery via businesses + cosmetic extras. |
| 2026-11-05 | Home screen deliberately deferred. |
| 2026-11-06 | Rollout: optional invite-only alpha before an invite-only private beta; expand in capped cohorts. |
| 2026-11-06 | Pre-alpha: real backend email/password test accounts, profiles and a shared activity on one device, using synthetic data. |
| 2026-11-06 | Beta signup: server-enforced approved-email allowlist. |
| 2026-11-06 | Audience membership is dynamic; blocking hides users mutually and prevents direct contact. |
| 2026-11-06 | Linked-event enrollment is chosen by the activity host; require event capacity for linked activity RSVPs and preserve independent event RSVPs on unlink. |
| 2026-11-06 | Adults only, based on the user's jurisdiction's age of majority; supersedes the earlier 16+ decision. |
| 2026-11-06 | Defer end-to-end chat encryption until after beta. Anonymization target applies to crash diagnostics, not operational user data. |
| 2026-11-06 | Zero total spending for pre-alpha and beta; Android direct-install and limited personal-device iOS testing replace paid store beta distribution for now. |
| 2026-11-06 | Defer Sentry project setup until before beta; Canadian-hosted crash reporting is a future goal. |
