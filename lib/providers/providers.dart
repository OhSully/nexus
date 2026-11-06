import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories.dart';
import '../data/sample_data.dart';
import '../models/activity_item.dart';
import '../models/people.dart';
import '../models/audience.dart';
import '../models/sample_contacts.dart';
import '../models/user_profile.dart';
import '../utils/clock.dart';

/// The user's language override; null follows the device language.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void set(Locale? locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

enum NotificationKind {
  messages,
  connectionRequests,
  invitations,
  eventChanges,
}

/// Which notification kinds the user wants. Stored only; nothing is sent
/// until push notifications exist.
class NotificationPrefsNotifier extends Notifier<Set<NotificationKind>> {
  @override
  Set<NotificationKind> build() => {...NotificationKind.values};

  void setEnabled(NotificationKind kind, {required bool enabled}) {
    state = enabled ? {...state, kind} : ({...state}..remove(kind));
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, Set<NotificationKind>>(
      NotificationPrefsNotifier.new,
    );

/// Audience pre-selected when creating a new activity or event.
class DefaultAudienceNotifier extends Notifier<Audience> {
  @override
  Audience build() => Audience.friends;

  void set(Audience audience) => state = audience;
}

final defaultAudienceProvider =
    NotifierProvider<DefaultAudienceNotifier, Audience>(
      DefaultAudienceNotifier.new,
    );

/// The app's source of "now". Override in tests for deterministic dates.
final clockProvider = Provider<Clock>((ref) => systemClock);

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => InMemoryActivityRepository(clock: ref.read(clockProvider)),
);
final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => InMemoryGroupRepository(),
);
final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => InMemoryChatRepository(),
);

class EnrollResult {
  const EnrollResult({
    required this.activity,
    required this.event,
    required this.enrolled,
    required this.skipped,
  });

  final ActivityItem activity;
  final ActivityItem? event;
  final int enrolled;
  final int skipped;
}

class UnlinkResult {
  const UnlinkResult({
    required this.activity,
    this.cancelledCount = 0,
    this.cancelledEventTitle,
  });

  final ActivityItem activity;
  final int cancelledCount;
  final String? cancelledEventTitle;
}

class ActivitiesNotifier extends Notifier<List<ActivityItem>> {
  @override
  List<ActivityItem> build() => ref.read(activityRepositoryProvider).loadAll();

  void _set(List<ActivityItem> items) {
    state = List.unmodifiable(items);
    ref.read(activityRepositoryProvider).saveAll(items);
  }

  void add(ActivityItem item) => _set([item, ...state]);

  void update(ActivityItem item) {
    final index = state.indexWhere((candidate) => candidate.id == item.id);
    if (index == -1) return;
    _set([...state]..[index] = item);
  }

  EnrollResult enrollLinkedEvent(ActivityItem activity) {
    final index = state.indexWhere((item) => item.id == activity.linkedEventId);
    if (index == -1) {
      return EnrollResult(
        activity: activity,
        event: null,
        enrolled: 0,
        skipped: 0,
      );
    }

    final event = state[index];
    final alreadyGoing = event.isGoing;
    final requested = activity.attendeeCount - (alreadyGoing ? 1 : 0);
    final spots = event.capacity == null
        ? requested
        : (event.capacity! - event.attendeeCount).clamp(0, requested);
    final nextCount = event.attendeeCount + spots;
    final updatedActivity = activity.copyWith(
      linkedEventEnrolled: true,
      linkedEnrolledCount: spots,
      linkedEnrolledSelf: !alreadyGoing && spots > 0,
    );
    final updatedEvent = event.copyWith(
      isGoing: alreadyGoing || spots > 0,
      attendeeCount: nextCount,
      guestsGoing: true,
    );

    final next = [...state];
    next[index] = updatedEvent;
    final activityIndex = next.indexWhere((item) => item.id == activity.id);
    if (activityIndex != -1) next[activityIndex] = updatedActivity;
    _set(next);

    return EnrollResult(
      activity: updatedActivity,
      event: updatedEvent,
      enrolled: spots,
      skipped: requested - spots,
    );
  }

  /// Re-links or unlinks an activity, cancelling any RSVPs the old link made.
  UnlinkResult changeLinkedEvent(ActivityItem activity, String? eventId) {
    final next = [...state];
    var cancelled = 0;
    String? cancelledTitle;

    if (activity.linkedEventEnrolled) {
      final eventIndex = next.indexWhere(
        (item) => item.id == activity.linkedEventId,
      );
      if (eventIndex != -1) {
        final event = next[eventIndex];
        final nextCount = (event.attendeeCount - activity.linkedEnrolledCount)
            .clamp(0, 1 << 30);
        next[eventIndex] = event.copyWith(
          isGoing: activity.linkedEnrolledSelf ? false : event.isGoing,
          attendeeCount: nextCount,
          guestsGoing: true,
        );
        cancelled = activity.linkedEnrolledCount;
        cancelledTitle = event.title;
      }
    }

    final updated = activity.copyWith(
      linkedEventId: eventId,
      clearLinkedEvent: eventId == null,
      linkedEventEnrolled: false,
      linkedEnrolledCount: 0,
      linkedEnrolledSelf: false,
    );
    final activityIndex = next.indexWhere((item) => item.id == activity.id);
    if (activityIndex != -1) next[activityIndex] = updated;
    _set(next);

    return UnlinkResult(
      activity: updated,
      cancelledCount: cancelled,
      cancelledEventTitle: cancelledTitle,
    );
  }
}

final activitiesProvider =
    NotifierProvider<ActivitiesNotifier, List<ActivityItem>>(
      ActivitiesNotifier.new,
    );

final eventsProvider = Provider<List<ActivityItem>>(
  (ref) => [
    for (final item in ref.watch(activitiesProvider))
      if (item.isEvent) item,
  ],
);

class GroupsNotifier extends Notifier<Map<String, List<String>>> {
  @override
  Map<String, List<String>> build() =>
      ref.read(groupRepositoryProvider).loadAll();

  void _set(Map<String, List<String>> groups) {
    state = groups;
    ref.read(groupRepositoryProvider).saveAll(groups);
  }

  /// Saves [members] under [name], renaming from [previousName] if given.
  void save(String name, List<String> members, {String? previousName}) {
    final next = {...state};
    if (previousName != null && previousName != name) {
      next.remove(previousName);
    }
    next[name] = List.unmodifiable(members);
    _set(next);
  }

  void remove(String name) => _set({...state}..remove(name));
}

final groupsProvider =
    NotifierProvider<GroupsNotifier, Map<String, List<String>>>(
      GroupsNotifier.new,
    );

/// Derived from groups, so audience pickers always see current groups.
final audienceDirectoryProvider = Provider<AudienceDirectory>(
  (ref) => AudienceDirectory(groups: ref.watch(groupsProvider)),
);

class ChatsNotifier extends Notifier<List<ChatSummary>> {
  @override
  List<ChatSummary> build() => ref.read(chatRepositoryProvider).loadAll();

  bool hasChatWith(List<String> people) =>
      state.any((chat) => chat.hasSameParticipants(people));

  // A chat is only added or moved to the top once a message is sent.
  void recordSentMessage(List<String> people, String text) {
    final next = [...state];
    final index = next.indexWhere((chat) => chat.hasSameParticipants(people));
    final participants = index == -1
        ? people
        : next.removeAt(index).participants;
    next.insert(
      0,
      ChatSummary(
        participants: participants,
        lastMessage: text,
        time: chatTimeNow,
      ),
    );
    state = List.unmodifiable(next);
    ref.read(chatRepositoryProvider).saveAll(next);
  }
}

final chatsProvider = NotifierProvider<ChatsNotifier, List<ChatSummary>>(
  ChatsNotifier.new,
);

/// People tab data. Swap for a repository-backed provider when a backend exists.
final connectionsProvider = Provider<List<Connection>>(
  (ref) => buildSampleConnections(),
);
final peopleUpdatesProvider = Provider<List<PeopleUpdate>>(
  (ref) => buildSampleUpdates(),
);
final discoverPeopleProvider = Provider<List<DiscoverPerson>>(
  (ref) => buildSampleDiscoverPeople(),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => InMemoryProfileRepository(clock: ref.read(clockProvider)),
);

const maxLookingForEntries = 3;

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => ref.read(profileRepositoryProvider).load();

  void _set(UserProfile profile) {
    state = profile;
    ref.read(profileRepositoryProvider).save(profile);
  }

  void setBio(String bio) => _set(state.copyWith(bio: bio));

  void _updateEntry(
    int index,
    LookingForEntry Function(LookingForEntry) change,
  ) {
    if (index < 0 || index >= state.lookingFor.length) return;
    final next = [...state.lookingFor];
    next[index] = change(next[index]);
    _set(state.copyWith(lookingFor: next));
  }

  void setLookingForText(int index, String text) => _updateEntry(
    index,
    (e) => LookingForEntry(
      text: text,
      declaredAt: e.declaredAt,
      audience: e.audience,
    ),
  );

  void setLookingForAudience(int index, Audience audience) => _updateEntry(
    index,
    (e) => LookingForEntry(
      text: e.text,
      declaredAt: e.declaredAt,
      audience: audience,
    ),
  );

  void addLookingFor() {
    if (state.lookingFor.length >= maxLookingForEntries) return;
    _set(
      state.copyWith(
        lookingFor: [
          ...state.lookingFor,
          LookingForEntry(text: '', declaredAt: ref.read(clockProvider)()),
        ],
      ),
    );
  }

  /// Removes an entry; the last remaining entry is reset instead.
  void removeLookingFor(int index) {
    if (index < 0 || index >= state.lookingFor.length) return;
    if (state.lookingFor.length == 1) {
      _set(
        state.copyWith(
          lookingFor: [
            LookingForEntry(text: '', declaredAt: ref.read(clockProvider)()),
          ],
        ),
      );
      return;
    }
    _set(state.copyWith(lookingFor: [...state.lookingFor]..removeAt(index)));
  }

  void redeclareAll() {
    final now = ref.read(clockProvider)();
    _set(
      state.copyWith(
        lookingFor: [
          for (final e in state.lookingFor)
            LookingForEntry(
              text: e.text,
              declaredAt: now,
              audience: e.audience,
            ),
        ],
      ),
    );
  }

  void toggleInterest(String interest, {required bool isPredefined}) {
    final name = interest.trim();
    if (name.isEmpty) return;
    final selected = {...state.selectedInterests};
    final custom = {...state.customInterests};
    final notes = {...state.interestNotes};
    if (!selected.remove(name)) {
      selected.add(name);
      if (!isPredefined) custom.add(name);
      notes[name] = '';
    } else {
      notes.remove(name);
      custom.remove(name);
    }
    _set(
      state.copyWith(
        selectedInterests: selected,
        customInterests: custom,
        interestNotes: notes,
      ),
    );
  }

  void setInterestNote(String interest, String note) => _set(
    state.copyWith(interestNotes: {...state.interestNotes, interest: note}),
  );
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);

/// Another person's profile with only the "Looking For" items the current
/// user is allowed to see.
final otherProfileProvider = Provider.family<UserProfile, String>((ref, name) {
  final profile = ref.watch(profileRepositoryProvider).loadFor(name);
  final directory = ref.watch(audienceDirectoryProvider);
  return profile.copyWith(
    lookingFor: [
      for (final entry in profile.lookingFor)
        if (entry.audience.isVisibleTo(currentUserName, directory)) entry,
    ],
  );
});
