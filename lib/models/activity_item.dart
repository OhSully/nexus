import 'package:flutter/material.dart';

import 'audience.dart';

enum ActivityKind { activity, event }

class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String guests;
  final int attendeeCount;
  final IconData icon;
  final Color color;
  final bool isGoing;
  final bool guestsGoing;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String eventType;
  final String visibility;
  final Audience? audience;
  final ActivityKind kind;
  final String description;
  final String location;
  final List<String> hosts;
  final int? capacity;
  final bool rsvpEnabled;
  final bool happensRegardless;
  final String? linkedEventId;
  final bool linkedEventEnrolled;
  final int linkedEnrolledCount;
  final bool linkedEnrolledSelf;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.guests,
    required this.attendeeCount,
    required this.icon,
    required this.color,
    required this.isGoing,
    this.guestsGoing = true,
    this.startsAt,
    this.endsAt,
    this.eventType = 'friends',
    this.visibility = 'friends',
    this.audience,
    this.kind = ActivityKind.activity,
    this.description = '',
    this.location = '',
    this.hosts = const [],
    this.capacity,
    this.rsvpEnabled = true,
    this.happensRegardless = false,
    this.linkedEventId,
    this.linkedEventEnrolled = false,
    this.linkedEnrolledCount = 0,
    this.linkedEnrolledSelf = false,
  });

  bool get isEvent => kind == ActivityKind.event;

  Audience get effectiveAudience =>
      audience ?? (visibility == 'public' ? Audience.public : Audience.friends);

  bool get isFull => capacity != null && attendeeCount >= capacity!;

  ActivityItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? guests,
    int? attendeeCount,
    IconData? icon,
    Color? color,
    bool? isGoing,
    bool? guestsGoing,
    DateTime? startsAt,
    DateTime? endsAt,
    String? eventType,
    String? visibility,
    Audience? audience,
    ActivityKind? kind,
    String? description,
    String? location,
    List<String>? hosts,
    int? capacity,
    bool? rsvpEnabled,
    bool? happensRegardless,
    String? linkedEventId,
    bool? linkedEventEnrolled,
    int? linkedEnrolledCount,
    bool? linkedEnrolledSelf,
    bool clearLinkedEvent = false,
  }) {
    return ActivityItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      guests: guests ?? this.guests,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isGoing: isGoing ?? this.isGoing,
      guestsGoing: guestsGoing ?? this.guestsGoing,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      eventType: eventType ?? this.eventType,
      visibility: visibility ?? this.visibility,
      audience: audience ?? this.audience,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      location: location ?? this.location,
      hosts: hosts ?? this.hosts,
      capacity: capacity ?? this.capacity,
      rsvpEnabled: rsvpEnabled ?? this.rsvpEnabled,
      happensRegardless: happensRegardless ?? this.happensRegardless,
      linkedEventId: clearLinkedEvent
          ? null
          : (linkedEventId ?? this.linkedEventId),
      linkedEventEnrolled: linkedEventEnrolled ?? this.linkedEventEnrolled,
      linkedEnrolledCount: linkedEnrolledCount ?? this.linkedEnrolledCount,
      linkedEnrolledSelf: linkedEnrolledSelf ?? this.linkedEnrolledSelf,
    );
  }
}
