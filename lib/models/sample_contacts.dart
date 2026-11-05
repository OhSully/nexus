const currentUserName = "Brendan O'Sullivan";

const sampleContacts = [
  "Brendan O'Sullivan",
  'Maya Patel',
  'Jordan Lee',
  'Sofia Nguyen',
];

class ChatSummary {
  const ChatSummary({
    required this.participants,
    required this.lastMessage,
    required this.time,
    this.unread = false,
    this.isNew = false,
  });

  final List<String> participants;
  final String lastMessage;
  final String time;
  final bool unread;
  final bool isNew;

  String get name => participants.join(', ');

  bool hasSameParticipants(List<String> other) {
    final a = [...participants]..sort();
    final b = [...other]..sort();
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
