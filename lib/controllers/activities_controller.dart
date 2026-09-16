import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../models/activity_model.dart';

class ActivitiesController extends ChangeNotifier {
  static final ActivitiesController _instance = ActivitiesController._internal();
  factory ActivitiesController() => _instance;

  int _selectedDateIndex = 0;
  String _selectedFilterId = 'all';
  String _selectedLocation = 'Bhavnagar';
  final String _userName = 'Vatsal';

  int get selectedDateIndex => _selectedDateIndex;
  String get selectedFilterId => _selectedFilterId;
  String get selectedLocation => _selectedLocation;
  String get userName => _userName;

  late List<DateItemModel> _dates;
  late List<FilterChipModel> _filters;
  late List<ActivityModel> _allActivities;
  late List<ActivityModel> _userActivities;
  late List<PlayerModel> _quickInvites;

  List<DateItemModel> get dates => _dates;
  List<FilterChipModel> get filters => _filters;
  List<ActivityModel> get userActivities => _userActivities;
  List<PlayerModel> get quickInvites => _quickInvites;

  ActivitiesController._internal() {
    _initializeData();
  }

  void _initializeData() {
    final now = DateTime.now();

    _dates = [
      DateItemModel(
        dayName: 'TODAY',
        dayNumber: '20',
        date: now,
        isSelected: true,
      ),
      DateItemModel(
        dayName: 'FRI',
        dayNumber: '21',
        date: now.add(const Duration(days: 1)),
        isSelected: false,
      ),
      DateItemModel(
        dayName: 'SAT',
        dayNumber: '22',
        date: now.add(const Duration(days: 2)),
        isSelected: false,
      ),
      DateItemModel(
        dayName: 'SUN',
        dayNumber: '23',
        date: now.add(const Duration(days: 3)),
        isSelected: false,
      ),
      DateItemModel(
        dayName: 'MON',
        dayNumber: '24',
        date: now.add(const Duration(days: 4)),
        isSelected: false,
      ),
      DateItemModel(
        dayName: 'TUE',
        dayNumber: '25',
        date: now.add(const Duration(days: 5)),
        isSelected: false,
      ),
      DateItemModel(
        dayName: 'WED',
        dayNumber: '26',
        date: now.add(const Duration(days: 6)),
        isSelected: false,
      ),
    ];

    _filters = [
      const FilterChipModel(
        id: 'all',
        label: 'All Activities',
        icon: Icons.explore_outlined,
        isSelected: true,
      ),
      const FilterChipModel(
        id: 'distance',
        label: 'Within 25 km',
        icon: Icons.location_on_outlined,
        isSelected: false,
      ),
      const FilterChipModel(
        id: 'time',
        label: 'Any time',
        icon: Icons.access_time_rounded,
        isSelected: false,
      ),
    ];

    _allActivities = [
      const ActivityModel(
        id: 'act_1',
        title: 'Box Cricket',
        subtitle: 'Today · 8:00 PM · 2.1 km',
        iconAsset: AppAssets.actBoxCricket,
        sportCategory: SportCategory.boxCricket,
        skillLevel: SkillLevel.beginner,
        joinedPlayers: 6,
        totalPlayers: 10,
        pricePerPerson: 120,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_2',
        title: 'Pickleball Match',
        subtitle: 'Tomorrow · 6:30 PM · 1.8 km',
        iconAsset: AppAssets.actPickleball,
        sportCategory: SportCategory.pickleball,
        skillLevel: SkillLevel.intermediate,
        joinedPlayers: 4,
        totalPlayers: 8,
        pricePerPerson: 150,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_3',
        title: 'Football',
        subtitle: 'Saturday · 5:00 PM · 3.2 km',
        iconAsset: AppAssets.actFootball,
        sportCategory: SportCategory.football,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 8,
        totalPlayers: 14,
        pricePerPerson: 100,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_4',
        title: 'Badminton',
        subtitle: 'Today · 7:00 PM · 0.8 km',
        iconAsset: AppAssets.actBadminton,
        sportCategory: SportCategory.badminton,
        skillLevel: SkillLevel.beginner,
        joinedPlayers: 3,
        totalPlayers: 4,
        pricePerPerson: 80,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_5',
        title: 'Basketball 3v3',
        subtitle: 'Sunday · 6:00 PM · 2.5 km',
        iconAsset: AppAssets.actBasketball,
        sportCategory: SportCategory.basketball,
        skillLevel: SkillLevel.intermediate,
        joinedPlayers: 5,
        totalPlayers: 6,
        pricePerPerson: 90,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_6',
        title: 'Volleyball',
        subtitle: 'Tomorrow · 5:30 PM · 3.0 km',
        iconAsset: AppAssets.actVolleyball,
        sportCategory: SportCategory.volleyball,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 8,
        totalPlayers: 12,
        pricePerPerson: 70,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_7',
        title: 'Table Tennis',
        subtitle: 'Today · 6:00 PM · 1.2 km',
        iconAsset: AppAssets.actTableTennis,
        sportCategory: SportCategory.tableTennis,
        skillLevel: SkillLevel.beginner,
        joinedPlayers: 2,
        totalPlayers: 4,
        pricePerPerson: 110,
        note: 'No equipment needed',
      ),
      const ActivityModel(
        id: 'act_8',
        title: 'Morning Running Club',
        subtitle: 'Tomorrow · 6:00 AM · 1.0 km',
        iconAsset: AppAssets.actRunning,
        sportCategory: SportCategory.running,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 12,
        totalPlayers: 20,
        pricePerPerson: 0,
        note: 'Free entry · All paces welcome',
      ),
      const ActivityModel(
        id: 'act_9',
        title: 'Weekend Cycling Tour',
        subtitle: 'Sunday · 6:30 AM · 4.0 km',
        iconAsset: AppAssets.actCycling,
        sportCategory: SportCategory.cycling,
        skillLevel: SkillLevel.intermediate,
        joinedPlayers: 7,
        totalPlayers: 15,
        pricePerPerson: 50,
        note: 'Helmet required',
      ),
      const ActivityModel(
        id: 'act_10',
        title: 'Outdoor Sunrise Yoga',
        subtitle: 'Sunday · 7:00 AM · 1.5 km',
        iconAsset: AppAssets.actYoga,
        sportCategory: SportCategory.yoga,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 9,
        totalPlayers: 15,
        pricePerPerson: 150,
        note: 'Bring your own mat',
      ),
      const ActivityModel(
        id: 'act_11',
        title: 'Hill Trail Hike',
        subtitle: 'Saturday · 5:30 AM · 8.0 km',
        iconAsset: AppAssets.actHiking,
        sportCategory: SportCategory.hiking,
        skillLevel: SkillLevel.intermediate,
        joinedPlayers: 6,
        totalPlayers: 10,
        pricePerPerson: 200,
        note: 'Trekking shoes recommended',
      ),
      const ActivityModel(
        id: 'act_12',
        title: 'HIIT & Gym Workout',
        subtitle: 'Today · 7:30 PM · 1.8 km',
        iconAsset: AppAssets.actGym,
        sportCategory: SportCategory.gym,
        skillLevel: SkillLevel.advanced,
        joinedPlayers: 4,
        totalPlayers: 8,
        pricePerPerson: 120,
        note: 'Towel & water bottle needed',
      ),
      const ActivityModel(
        id: 'act_13',
        title: 'Board Games & Cafe Hangout',
        subtitle: 'Friday · 6:00 PM · 2.0 km',
        iconAsset: AppAssets.actCafeHangout,
        sportCategory: SportCategory.cafeHangout,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 5,
        totalPlayers: 8,
        pricePerPerson: 100,
        note: 'Snacks & beverages included',
      ),
      const ActivityModel(
        id: 'act_14',
        title: 'Console Gaming Night',
        subtitle: 'Saturday · 8:30 PM · 2.8 km',
        iconAsset: AppAssets.actGaming,
        sportCategory: SportCategory.gaming,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 6,
        totalPlayers: 8,
        pricePerPerson: 150,
        note: 'Controllers provided',
      ),
      const ActivityModel(
        id: 'act_15',
        title: 'Heritage Photography Walk',
        subtitle: 'Sunday · 4:30 PM · 3.5 km',
        iconAsset: AppAssets.actPhotography,
        sportCategory: SportCategory.photography,
        skillLevel: SkillLevel.allLevels,
        joinedPlayers: 5,
        totalPlayers: 12,
        pricePerPerson: 100,
        note: 'Bring camera or smartphone',
      ),
    ];

    _userActivities = [
      ActivityModel(
        id: 'user_act_1',
        title: 'Box Cricket Match',
        subtitle: 'Today · 6:00 PM · Oval Maidan, Churchgate',
        iconAsset: AppAssets.actBoxCricket,
        sportCategory: SportCategory.boxCricket,
        skillLevel: SkillLevel.intermediate,
        joinedPlayers: 6,
        totalPlayers: 10,
        pricePerPerson: 150,
        note: 'Match balls provided',
        isHost: true,
        venueName: 'Oval Maidan, Churchgate',
        venueLocation: 'Mumbai · 1.5 km away',
        players: _getDefaultPlayers(),
      ),
      ActivityModel(
        id: 'user_act_2',
        title: 'Badminton Doubles',
        subtitle: 'Tomorrow · 7:30 AM · Sports Complex, Andheri',
        iconAsset: AppAssets.actBadminton,
        sportCategory: SportCategory.badminton,
        skillLevel: SkillLevel.beginner,
        joinedPlayers: 3,
        totalPlayers: 4,
        pricePerPerson: 200,
        note: 'Bring your own racket',
        isHost: true,
        venueName: 'Sports Complex, Andheri',
        venueLocation: 'Mumbai · 3.2 km away',
        players: _getDefaultPlayers(),
      ),
    ];

    _quickInvites = [
      const PlayerModel(
        id: 'qi_1',
        name: 'Jayesh Mehta',
        subtitle: '3 games together',
        avatarBgColor: Color(0xFF475569),
      ),
      const PlayerModel(
        id: 'qi_2',
        name: 'Kunal Pandya',
        subtitle: '7 games together',
        avatarBgColor: Color(0xFF1E40AF),
      ),
    ];
  }

  static List<PlayerModel> _getDefaultPlayers() {
    return [
      const PlayerModel(
        id: 'p_1',
        name: 'Meet Patel',
        role: 'HOST',
        skill: 'Intermediate',
        isHost: true,
        avatarBgColor: Color(0xFF475569),
      ),
      const PlayerModel(
        id: 'p_2',
        name: 'Rohan Shah',
        role: 'MEMBER',
        skill: 'Advanced',
        avatarBgColor: Color(0xFF334155),
      ),
      const PlayerModel(
        id: 'p_3',
        name: 'Amit Gohel',
        role: 'MEMBER',
        skill: 'Intermediate',
        avatarBgColor: Color(0xFF0F172A),
      ),
      const PlayerModel(
        id: 'p_4',
        name: 'Divyesh Solanki',
        role: 'MEMBER',
        skill: 'Beginner',
        avatarBgColor: Color(0xFF2563EB),
      ),
      const PlayerModel(
        id: 'p_5',
        name: 'Hardik Vora',
        role: 'MEMBER',
        skill: 'Advanced',
        avatarBgColor: Color(0xFF64748B),
      ),
      const PlayerModel(
        id: 'p_6',
        name: 'Kunal Pandya',
        role: 'MEMBER',
        skill: 'Intermediate',
        avatarBgColor: Color(0xFF1E40AF),
      ),
    ];
  }

  List<ActivityModel> get activities {
    return _allActivities;
  }

  void selectDate(int index) {
    if (index < 0 || index >= _dates.length) return;
    _selectedDateIndex = index;
    for (int i = 0; i < _dates.length; i++) {
      _dates[i] = _dates[i].copyWith(isSelected: i == index);
    }
    notifyListeners();
  }

  void selectFilter(String filterId) {
    _selectedFilterId = filterId;
    for (int i = 0; i < _filters.length; i++) {
      _filters[i] = _filters[i].copyWith(isSelected: _filters[i].id == filterId);
    }
    notifyListeners();
  }

  void toggleFilter(String filterId) {
    final index = _filters.indexWhere((f) => f.id == filterId);
    if (index != -1) {
      final current = _filters[index].isSelected;
      _filters[index] = _filters[index].copyWith(isSelected: !current);
      if (!current) {
        _selectedFilterId = filterId;
      }
      notifyListeners();
    }
  }

  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void addActivity(ActivityModel activity) {
    final hostActivity = activity.copyWith(
      isHost: true,
      players: activity.players ?? _getDefaultPlayers(),
      venueConfirmed: true,
    );
    _allActivities.insert(0, hostActivity);
    _userActivities.insert(0, hostActivity);
    notifyListeners();
  }

  void toggleInvitePlayer(String id) {
    final idx = _quickInvites.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _quickInvites[idx] = _quickInvites[idx].copyWith(
        isInvited: !_quickInvites[idx].isInvited,
      );
      notifyListeners();
    }
  }
}
