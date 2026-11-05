import 'package:flutter/material.dart';

class InterestNoteDialog extends StatefulWidget {
  const InterestNoteDialog({
    super.key,
    required this.interest,
    required this.initialNote,
  });

  final String interest;
  final String initialNote;

  @override
  State<InterestNoteDialog> createState() => _InterestNoteDialogState();
}

class _InterestNoteDialogState extends State<InterestNoteDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialNote,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.interest),
      content: TextField(
        controller: _controller,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Add context for this interest',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
