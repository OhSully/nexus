import '../models/activity_item.dart';
import '../models/sample_contacts.dart';
import '../models/user_profile.dart';
import '../utils/clock.dart';
import 'sample_data.dart';

/// Storage boundary for activities and events. Swap the in-memory
/// implementation for a backend-backed one without touching the UI.
abstract class ActivityRepository {
  List<ActivityItem> loadAll();
  void saveAll(List<ActivityItem> items);
}

abstract class GroupRepository {
  Map<String, List<String>> loadAll();
  void saveAll(Map<String, List<String>> groups);
}

abstract class ChatRepository {
  List<ChatSummary> loadAll();
  void saveAll(List<ChatSummary> chats);
}

abstract class ProfileRepository {
  UserProfile load();
  void save(UserProfile profile);

  /// Another person's profile, as it is stored (before visibility rules).
  UserProfile loadFor(String name);
}

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository({
    UserProfile? seed,
    Map<String, UserProfile>? others,
    Clock clock = systemClock,
  }) : _profile = seed ?? buildSampleProfile(clock()),
       _others = others ?? buildSampleOtherProfiles(clock());

  UserProfile _profile;
  final Map<String, UserProfile> _others;

  @override
  UserProfile load() => _profile;

  @override
  void save(UserProfile profile) => _profile = profile;

  @override
  UserProfile loadFor(String name) =>
      _others[name] ?? const UserProfile.empty();
}

class InMemoryActivityRepository implements ActivityRepository {
  InMemoryActivityRepository({
    List<ActivityItem>? seed,
    Clock clock = systemClock,
  }) : _items = seed ?? buildSampleActivities(clock());

  List<ActivityItem> _items;

  @override
  List<ActivityItem> loadAll() => List.unmodifiable(_items);

  @override
  void saveAll(List<ActivityItem> items) => _items = List.of(items);
}

class InMemoryGroupRepository implements GroupRepository {
  InMemoryGroupRepository([Map<String, List<String>>? seed])
    : _groups = seed ?? buildSampleGroups();

  Map<String, List<String>> _groups;

  @override
  Map<String, List<String>> loadAll() => {
    for (final entry in _groups.entries) entry.key: List.of(entry.value),
  };

  @override
  void saveAll(Map<String, List<String>> groups) => _groups = {
    for (final entry in groups.entries) entry.key: List.of(entry.value),
  };
}

class InMemoryChatRepository implements ChatRepository {
  InMemoryChatRepository([List<ChatSummary>? seed])
    : _chats = seed ?? buildSampleChats();

  List<ChatSummary> _chats;

  @override
  List<ChatSummary> loadAll() => List.unmodifiable(_chats);

  @override
  void saveAll(List<ChatSummary> chats) => _chats = List.of(chats);
}
