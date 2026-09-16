import 'package:flutter/material.dart';

enum SportCategory {
  boxCricket,
  pickleball,
  football,
  badminton,
  basketball,
  volleyball,
  tableTennis,
  running,
  cycling,
  yoga,
  gym,
  hiking,
  walking,
  cafeHangout,
  gaming,
  photography,
  movie,
  dance,
  shopping,
}

enum SkillLevel {
  beginner('Beginner', Color(0xFFE8F0FE), Color(0xFF1E5BBF)),
  intermediate('Intermediate', Color(0xFFFEF3C7), Color(0xFFD97706)),
  allLevels('All Levels', Color(0xFFD1FAE5), Color(0xFF059669)),
  advanced('Advanced', Color(0xFFFFE4E6), Color(0xFFE11D48));

  final String label;
  final Color backgroundColor;
  final Color textColor;

  const SkillLevel(this.label, this.backgroundColor, this.textColor);
}

class ActivityModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconAsset;
  final SportCategory sportCategory;
  final SkillLevel skillLevel;
  final int joinedPlayers;
  final int totalPlayers;
  final int pricePerPerson;
  final String note;
  final DateTime? date;
  final bool isHost;
  final String? venueName;
  final String? venueLocation;
  final bool venueConfirmed;
  final List<PlayerModel>? players;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.sportCategory = SportCategory.boxCricket,
    required this.skillLevel,
    required this.joinedPlayers,
    required this.totalPlayers,
    required this.pricePerPerson,
    this.note = 'No equipment needed',
    this.date,
    this.isHost = false,
    this.venueName,
    this.venueLocation,
    this.venueConfirmed = true,
    this.players,
  });

  double get progress =>
      totalPlayers > 0 ? (joinedPlayers / totalPlayers).clamp(0.0, 1.0) : 0.0;

  String get playersText => '$joinedPlayers/$totalPlayers players';

  String get priceText => '₹$pricePerPerson/person';

  ActivityModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? iconAsset,
    SportCategory? sportCategory,
    SkillLevel? skillLevel,
    int? joinedPlayers,
    int? totalPlayers,
    int? pricePerPerson,
    String? note,
    DateTime? date,
    bool? isHost,
    String? venueName,
    String? venueLocation,
    bool? venueConfirmed,
    List<PlayerModel>? players,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconAsset: iconAsset ?? this.iconAsset,
      sportCategory: sportCategory ?? this.sportCategory,
      skillLevel: skillLevel ?? this.skillLevel,
      joinedPlayers: joinedPlayers ?? this.joinedPlayers,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      note: note ?? this.note,
      date: date ?? this.date,
      isHost: isHost ?? this.isHost,
      venueName: venueName ?? this.venueName,
      venueLocation: venueLocation ?? this.venueLocation,
      venueConfirmed: venueConfirmed ?? this.venueConfirmed,
      players: players ?? this.players,
    );
  }
}

class PlayerModel {
  final String id;
  final String name;
  final String role; // 'HOST' or 'MEMBER'
  final String skill; // 'Intermediate', 'Advanced', 'Beginner'
  final String? avatarAsset;
  final Color avatarBgColor;
  final bool isHost;
  final String? subtitle; // e.g. '3 games together'
  final bool isInvited;

  const PlayerModel({
    required this.id,
    required this.name,
    this.role = 'MEMBER',
    this.skill = 'Intermediate',
    this.avatarAsset,
    this.avatarBgColor = const Color(0xFF0D47A1),
    this.isHost = false,
    this.subtitle,
    this.isInvited = false,
  });

  PlayerModel copyWith({
    String? id,
    String? name,
    String? role,
    String? skill,
    String? avatarAsset,
    Color? avatarBgColor,
    bool? isHost,
    String? subtitle,
    bool? isInvited,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      skill: skill ?? this.skill,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      avatarBgColor: avatarBgColor ?? this.avatarBgColor,
      isHost: isHost ?? this.isHost,
      subtitle: subtitle ?? this.subtitle,
      isInvited: isInvited ?? this.isInvited,
    );
  }
}

class DateItemModel {
  final String dayName;
  final String dayNumber;
  final DateTime date;
  final bool isSelected;

  const DateItemModel({
    required this.dayName,
    required this.dayNumber,
    required this.date,
    this.isSelected = false,
  });

  DateItemModel copyWith({
    String? dayName,
    String? dayNumber,
    DateTime? date,
    bool? isSelected,
  }) {
    return DateItemModel(
      dayName: dayName ?? this.dayName,
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FilterChipModel {
  final String id;
  final String label;
  final IconData icon;
  final bool isSelected;

  const FilterChipModel({
    required this.id,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  FilterChipModel copyWith({
    String? id,
    String? label,
    IconData? icon,
    bool? isSelected,
  }) {
    return FilterChipModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
