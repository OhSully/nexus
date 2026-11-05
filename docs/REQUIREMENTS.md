# Nexus – Requirements & Goals

Status: draft v0.1 (2026-11-05). Update this file as decisions are made; record
changes in the Decision Log at the bottom.

## 1. Vision

Nexus helps people discover activities and events, plan them with friends,
connect with people who share interests, and chat. Individuals use it first;
local businesses later host public events and activities.

## 2. Goals

1. **Private beta first**: a stable build for friends/testers on Android and iOS.
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

- **Individual** (launch): any person; creates/joins activities, connects, chats.
- **Business host** (later): local business that posts public events/activities.
- **Admin/moderator** (needed before public launch): handles reports.

## 5. Functional requirements

Current prototype state is noted per area. All data is currently in-memory
sample data behind repository interfaces (`lib/data/repositories.dart`).

### 5.1 Accounts & authentication (new)
- Sign-in with email/password, Google, Apple, and phone number.
- Sign in with Apple is required on iOS if other social logins are offered.
- Email verification, password reset, account deletion (store requirement)
  and data export.
- Session persistence; secure sign-out.

### 5.2 Activities & events (prototype exists)
- Create/edit/delete activities and events: title, description, location, time,
  hosts, capacity, RSVP on/off, "happens regardless", event type.
- RSVP/enroll with capacity enforcement; link an activity to an event
  (enrol/unenrol counts). Counts must be consistent under concurrent use.
- Location with real place search/map link (later); time zones handled correctly.
- Edit/cancel notifies attendees.

### 5.3 Audience & visibility (prototype exists)
- Audience types: Public, Friends, Groups, Past attendees, Friends with
  interests, Custom (rules: categories intersected, choices unioned, explicit
  people always included).
- Applies to activities/events and to profile "looking for" entries.
- Server must enforce who can see/join; clients never receive hidden items.

### 5.4 People & groups (prototype exists)
- Connections (request/accept/remove), updates feed, discovering people,
  custom groups.
- Block and report users; blocked users cannot see or contact the blocker.
- Contacts come from real users, replacing `sample_contacts.dart`.

### 5.5 Chat (prototype exists)
- 1:1 and group chats, real-time delivery, unread counts, history.
- Push notifications for messages, requests, invites, event changes.
- Respect blocks; report messages.

### 5.6 Profile (prototype exists)
- Bio, interests (catalog + custom, with notes), "looking for" entries with
  audience, avatar. Visibility enforced per viewer.

### 5.7 Discover & plans (prototype exists)
- Discover: browse relevant public/visible activities (search, filters,
  location-based; ranking later).
- Plans: my upcoming/past activities and events.

### 5.8 Home (undecided)
- Purpose undefined; either removed or repurposed. Do not invest until decided.
  Navigation must not depend on it (keep it swappable).

### 5.9 Business hosts (post-beta)
- Verified business accounts, public event posting, host profile page.
- Paid tiers/fees TBD (see §7).

## 6. Non-functional requirements

- **Platforms**: Android and iOS, portrait (current). Min OS versions TBD.
- **Privacy/security**: server-side authorization on every read/write;
  encrypted transport; secrets never in the repo; minimal data collected;
  privacy policy and terms; GDPR/CCPA-style delete & export; age gate (13+/16+
  to be confirmed).
- **Offline/performance**: cached reads, graceful failure, optimistic UI where
  safe; list screens paginate.
- **Reliability**: crash reporting, structured error handling (no silent
  failures), analytics limited to product metrics with consent.
- **Quality**: `flutter analyze` clean; unit + widget tests for providers and
  key flows; integration tests for sign-in, create, RSVP, chat; CI on every PR.
- **Accessibility & i18n**: screen-reader labels, dynamic text sizes, contrast;
  strings externalized for localization (English first).
- **Moderation/safety**: report flows, content policy, an admin way to act on
  reports (required by app stores for UGC).
- **Release**: real app ID/name/icons/splash (currently `com.example.*`),
  flavors (dev/staging/prod), signing, versioning, store listings.

## 7. Business model & cost constraints

- Budget is low; aim to only cover costs.
- Core features stay free for individuals.
- Possible revenue (ideas, not committed):
  - Business hosts pay to post/promote events.
  - Optional cosmetic extras for individuals: premium emoji, themes/skins,
    background colours, extra storage. These must not affect core quality.
- Design implication: choose infrastructure with a generous free tier and
  predictable scaling; keep media storage and SMS (phone auth) costs in check.
- Premium/entitlement checks should be a thin, separate layer so they can be
  added later without reworking features.

## 8. Success criteria for private beta

- Testers can register, build profile, connect, create and RSVP to
  activities, and chat, with data persisted across devices.
- Visibility rules verified by automated tests against the backend.
- No known data-leak or crash-on-launch issues; crash-free sessions ≥ 99%.
- Distributed via TestFlight and Play internal testing.

## 9. Open questions

1. Backend final choice (proposal in PLAN.md: Supabase).
2. Is phone auth needed for beta? SMS costs money per verification.
3. Minimum age and target regions (affects legal/compliance).
4. Location model: free-text vs. map/place search; discovery radius.
5. What is the Home screen (remove, feed, dashboard)?
6. Definition of "friend": mutual connections? Are follows needed?
7. Where do business events appear in Discover vs. friends' content?
8. App name/branding ("Nexus" availability on stores), app ID, domain.

## 10. Decision log

| Date | Decision |
|------|----------|
| 2026-11-05 | Target: private beta on Android + iOS. |
| 2026-11-05 | Sign-in: email/password, Google, Apple, phone. |
| 2026-11-05 | Monetization: cost recovery via businesses + cosmetic extras. |
| 2026-11-05 | Home screen deliberately deferred. |
