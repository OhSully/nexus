import 'package:flutter/material.dart';

class Connection {
  const Connection({
    required this.name,
    required this.latestUpdate,
    required this.updateTime,
    required this.initials,
  });

  final String name;
  final String latestUpdate;
  final String updateTime;
  final String initials;
}

class PeopleUpdate {
  const PeopleUpdate({
    required this.person,
    required this.description,
    required this.time,
    required this.icon,
    this.action,
  });

  final String person;
  final String description;
  final String time;
  final IconData icon;
  final String? action;
}

class DiscoveryTag {
  const DiscoveryTag({
    required this.label,
    required this.icon,
    required this.meaning,
  });

  final String label;
  final IconData icon;
  final String meaning;
}

class DiscoverPerson {
  const DiscoverPerson({
    required this.name,
    required this.matchCategories,
    required this.tags,
    this.isInvite = false,
  });

  final String name;
  final List<String> matchCategories;
  final List<DiscoveryTag> tags;
  final bool isInvite;
}

const discoverFilters = [
  'All',
  'Phone contacts',
  'Past events',
  'Friends of friends',
  'Shared interests',
];
