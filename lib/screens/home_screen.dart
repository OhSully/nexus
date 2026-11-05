import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../providers/providers.dart';
import '../widgets/contact_picker.dart';
import 'activity_detail_screen.dart';
import 'chat_detail_screen.dart';
import 'chats_screen.dart';
import 'create_activity_screen.dart';
import 'create_event_screen.dart';
import 'create_menu.dart';
import 'discover_screen.dart';
import 'plans_screen.dart';
import 'people/people_screen.dart';
import 'profile_screen.dart';
import '../models/sample_contacts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _showCreateMenu() async {
    final choice = await showCreateMenu(context);

    if (!mounted) {
      return;
    }
    switch (choice) {
      case CreateChoice.chat:
        await _openNewChat();
      case CreateChoice.activity:
        await _openCreateActivity();
      case CreateChoice.event:
        await _openCreateEvent();
      case null:
        break;
    }
  }

  Future<void> _openNewChat() async {
    final people = await showContactPicker(
      context,
      title: AppLocalizations.of(context).homeNewMessageTitle,
      confirmLabel: AppLocalizations.of(context).homeStartChat,
    );
    if (people == null || people.isEmpty || !mounted) {
      return;
    }
    _openChatWith(people);
  }

  // A chat is only added or moved to the top once a message is actually sent.
  void _openChatWith(List<String> people) {
    final existing = ref.read(chatsProvider.notifier).hasChatWith(people);
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ChatDetailScreen(
          contactName: people.join(', '),
          startEmpty: !existing,
          onMessageSent: (text) =>
              ref.read(chatsProvider.notifier).recordSentMessage(people, text),
        ),
      ),
    );
  }

  Future<void> _openCreateActivity() async {
    final created = await Navigator.of(context).push<ActivityItem>(
      MaterialPageRoute(
        builder: (context) => CreateActivityScreen(
          directory: ref.read(audienceDirectoryProvider),
          events: ref.read(eventsProvider),
        ),
      ),
    );
    if (created != null && mounted) {
      ref.read(activitiesProvider.notifier).add(created);
    }
  }

  Future<void> _openCreateEvent() async {
    final created = await Navigator.of(context).push<ActivityItem>(
      MaterialPageRoute(
        builder: (context) =>
            CreateEventScreen(directory: ref.read(audienceDirectoryProvider)),
      ),
    );
    if (created != null && mounted) {
      ref.read(activitiesProvider.notifier).add(created);
    }
  }

  ActivityItem _enrollLinkedEvent(ActivityItem activity) {
    final result = ref
        .read(activitiesProvider.notifier)
        .enrollLinkedEvent(activity);
    final event = result.event;
    if (event == null) {
      return activity;
    }
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.skipped > 0
              ? l10n.homeEnrolledPartial(
                  result.enrolled,
                  event.title,
                  result.skipped,
                )
              : l10n.homeEnrolledAll(event.title),
        ),
      ),
    );
    return result.activity;
  }

  // Re-links or unlinks an activity, cancelling any RSVPs the old link created.
  ActivityItem _changeLinkedEvent(ActivityItem activity, String? eventId) {
    final result = ref
        .read(activitiesProvider.notifier)
        .changeLinkedEvent(activity, eventId);

    if (result.cancelledCount > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).homeCancelledRsvps(
                result.cancelledCount,
                result.cancelledEventTitle ?? '',
              ),
            ),
          ),
        );
    }
    return result.activity;
  }

  void _handleRSVP(ActivityItem updatedItem) =>
      ref.read(activitiesProvider.notifier).update(updatedItem);

  void _openActivityDetail(ActivityItem item) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ActivityDetailScreen(
          item: item,
          onRSVP: _handleRSVP,
          events: ref.read(eventsProvider),
          onEnrollLinkedEvent: _enrollLinkedEvent,
          onChangeLinkedEvent: _changeLinkedEvent,
        ),
      ),
    );
  }

  void _openChatDetail(ChatSummary chat) => _openChatWith(chat.participants);

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(activitiesProvider);
    final chats = ref.watch(chatsProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DiscoverScreen(items: items, onOpenActivity: _openActivityDetail),
          PlansScreen(plans: items, onOpenActivity: _openActivityDetail),
          PeopleScreen(onOpenChat: _openChatWith),
          ChatsScreen(chats: chats, onOpenChat: _openChatDetail),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: const [0, 1, 3].contains(_selectedIndex)
          ? FloatingActionButton(
              onPressed: _showCreateMenu,
              tooltip: l10n.homeCreateTooltip,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l10n.navPlans,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: l10n.navPeople,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            label: l10n.navChats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
