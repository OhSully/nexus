import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class GroupDraft {
  const GroupDraft({required this.name, required this.members});

  final String name;
  final List<String> members;
}

class GroupEditorDialog extends StatefulWidget {
  const GroupEditorDialog({
    super.key,
    required this.connections,
    required this.initialName,
    required this.initialMembers,
  });

  final List<String> connections;
  final String initialName;
  final List<String> initialMembers;

  @override
  State<GroupEditorDialog> createState() => _GroupEditorDialogState();
}

class _GroupEditorDialogState extends State<GroupEditorDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName,
  );
  late final Set<String> _members = {...widget.initialMembers};
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(
        () => _nameError = AppLocalizations.of(context).groupEditorNameError,
      );
      return;
    }
    Navigator.of(
      context,
    ).pop(GroupDraft(name: name, members: _members.toList()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.initialName.isEmpty
            ? l10n.peopleCreateGroup
            : l10n.groupEditorEditTitle,
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (value) {
                if (value.trim().isNotEmpty && _nameError != null) {
                  setState(() => _nameError = null);
                }
              },
              decoration: InputDecoration(
                labelText: l10n.groupEditorNameLabel,
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: widget.connections.map((connection) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(connection),
                    value: _members.contains(connection),
                    onChanged: (selected) {
                      setState(() {
                        if (selected ?? false) {
                          _members.add(connection);
                        } else {
                          _members.remove(connection);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}
