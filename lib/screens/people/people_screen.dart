import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/section_header.dart';
import '../profile_screen.dart';
import 'connections_tab.dart';
import 'discover_tab.dart';
import 'group_editor_dialog.dart';
import 'updates_tab.dart';

class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key, required this.onOpenChat});

  final ValueChanged<List<String>> onOpenChat;

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  static const _sections = ['Updates', 'Connections', 'Discover'];

  int _selectedSection = 0;
  int _discoverFilter = 0;
  String? _selectedGroup;
  final Set<String> _connectionRequests = {};
  final Set<String> _sentInvites = {};
  final Map<String, String> _updateResponses = {};

  // Read-only snapshot; build() watches the provider so the UI rebuilds.
  Map<String, List<String>> get _groups => ref.read(groupsProvider);

  void _openProfile(String name) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(isCurrentUser: false, displayName: name),
      ),
    );
  }

  Future<void> _editGroup({String? groupName}) async {
    final connections = ref.read(connectionsProvider);
    final draft = await showDialog<GroupDraft>(
      context: context,
      builder: (_) => GroupEditorDialog(
        connections: connections.map((c) => c.name).toList(),
        initialName: groupName ?? '',
        initialMembers: _groups[groupName] ?? const <String>[],
      ),
    );

    if (draft == null || !mounted) {
      return;
    }

    setState(() {
      if (groupName != null &&
          groupName != draft.name &&
          _selectedGroup == groupName) {
        _selectedGroup = draft.name;
      }
    });
    ref
        .read(groupsProvider.notifier)
        .save(draft.name, draft.members, previousName: groupName);
  }

  Future<void> _manageGroups() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Manage groups'),
              content: SizedBox(
                width: 360,
                child: _groups.isEmpty
                    ? const Text('Create a group to organize your connections.')
                    : ListView(
                        shrinkWrap: true,
                        children: _groups.entries.map((entry) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(entry.key),
                            subtitle: Text('${entry.value.length} connections'),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  tooltip: 'Edit ${entry.key}',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () async {
                                    await Navigator.of(
                                      dialogContext,
                                    ).maybePop();
                                    await _editGroup(groupName: entry.key);
                                    if (mounted) {
                                      _manageGroups();
                                    }
                                  },
                                ),
                                IconButton(
                                  tooltip: 'Delete ${entry.key}',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    ref
                                        .read(groupsProvider.notifier)
                                        .remove(entry.key);
                                    setState(() {
                                      if (_selectedGroup == entry.key) {
                                        _selectedGroup = null;
                                      }
                                    });
                                    setDialogState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.of(dialogContext).maybePop();
                    await _editGroup();
                    if (mounted) {
                      _manageGroups();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create group'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _inviteGroup(String groupName) async {
    final event = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Invite $groupName'),
        content: const Text('Choose an event to invite this group to.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('Sunrise hike'),
            child: const Text('Sunrise hike'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('Sunday brunch'),
            child: const Text('Sunday brunch'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (event == null || !mounted) {
      return;
    }
    final inviteCount = _groups[groupName]?.length ?? 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prepared an invite to $event for $inviteCount people in $groupName.',
        ),
      ),
    );
  }

  Widget _buildSection() {
    switch (_selectedSection) {
      case 0:
        return UpdatesTab(
          updates: ref.watch(peopleUpdatesProvider),
          responses: _updateResponses,
          onRespond: (person, response) =>
              setState(() => _updateResponses[person] = response),
          onOpenProfile: _openProfile,
        );
      case 1:
        return ConnectionsTab(
          connections: ref.watch(connectionsProvider),
          groups: _groups,
          selectedGroup: _selectedGroup,
          onSelectGroup: (group) => setState(() => _selectedGroup = group),
          onManageGroups: _manageGroups,
          onInviteGroup: _inviteGroup,
          onOpenProfile: _openProfile,
          onMessage: (name) => widget.onOpenChat([name]),
        );
      default:
        return DiscoverTab(
          people: ref.watch(discoverPeopleProvider),
          filterIndex: _discoverFilter,
          onFilterChanged: (index) => setState(() => _discoverFilter = index),
          connectionRequests: _connectionRequests,
          sentInvites: _sentInvites,
          onConnect: (name) => setState(() => _connectionRequests.add(name)),
          onInvite: (name) => setState(() => _sentInvites.add(name)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(groupsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle('People'),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_sections.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_sections[index]),
                      selected: _selectedSection == index,
                      onSelected: (_) =>
                          setState(() => _selectedSection = index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildSection()),
          ],
        ),
      ),
    );
  }
}
