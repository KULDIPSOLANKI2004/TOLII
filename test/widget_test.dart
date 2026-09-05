import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolii/main.dart';
import 'package:tolii/constants/app_assets.dart';
import 'package:tolii/controllers/activities_controller.dart';
import 'package:tolii/views/home_screen.dart';
import 'package:tolii/views/nearby_activities_screen.dart';
import 'package:tolii/widgets/custom_bottom_nav_bar.dart';
import 'package:tolii/widgets/filters_bottom_sheet.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ToliiApp());
    expect(find.byType(ToliiApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });

  testWidgets('HomeScreen renders floating overlay nav bar and switches tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify Home Tab Content & Floating Nav Bar
    expect(find.text('What are you up for?'), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsOneWidget);

    // Tap on Activities Icon (2nd icon)
    final activitiesIcon = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.activitiesNavPng,
    );
    expect(activitiesIcon, findsOneWidget);
    await tester.tap(activitiesIcon);
    await tester.pumpAndSettle();

    // Verify Activities Screen Elements
    expect(find.text('Nearby activities'), findsOneWidget);
    expect(find.text('Box Cricket'), findsOneWidget);
    expect(find.text('Pickleball Match'), findsOneWidget);

    // Tap on Community Icon
    final communityIcon = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.communityNavPng,
    );
    expect(communityIcon, findsOneWidget);
    await tester.tap(communityIcon);
    await tester.pumpAndSettle();
    expect(find.text('Join Local Groups'), findsOneWidget);

    // Tap on Profile Icon
    final profileIcon = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.profileNavPng,
    );
    expect(profileIcon, findsOneWidget);
    await tester.tap(profileIcon);
    await tester.pumpAndSettle();
    expect(find.text('My Activities'), findsOneWidget);

    // Tap back on Home Icon
    final homeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.homeNavPng,
    );
    expect(homeIcon, findsOneWidget);
    await tester.tap(homeIcon);
    await tester.pumpAndSettle();
    expect(find.text('What are you up for?'), findsOneWidget);
  });

  testWidgets('FiltersBottomSheet renders all filter sections accurately',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FiltersBottomSheet(),
        ),
      ),
    );

    // Verify Title
    expect(find.text('Filters'), findsOneWidget);

    // Verify Sections
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('When'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Skill Level'), findsOneWidget);
    expect(find.text('Players Needed'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);

    // Verify Chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Sports'), findsOneWidget);
    expect(find.text('Fitness'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Any Time'), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Any Level'), findsOneWidget);
    expect(find.text('Beginner'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);

    // Verify Bottom Actions
    expect(find.text('Clear all'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);

    // Test selection
    await tester.tap(find.text('Fitness'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
  });

  testWidgets('NearbyActivitiesScreen renders all UI elements accurately',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NearbyActivitiesScreen(),
      ),
    );

    // Verify Header
    expect(find.text('Hey Vatsal!'), findsOneWidget);
    expect(find.text('Bhavnagar'), findsOneWidget);

    // Verify Date selector & Month badge
    expect(find.text('AUG'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);

    // Verify Filter Chips
    expect(find.text('All Activities'), findsOneWidget);
    expect(find.text('Within 25 km'), findsOneWidget);
    expect(find.text('Any time'), findsOneWidget);

    // Verify Section Header
    expect(find.text('Nearby activities'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);

    // Verify Activity Cards
    expect(find.text('Box Cricket'), findsOneWidget);
    expect(find.text('Pickleball Match'), findsOneWidget);
    expect(find.text('Football'), findsOneWidget);
    expect(find.text('Badminton'), findsOneWidget);

    // Verify Skill Badges
    expect(find.text('Beginner'), findsWidgets);
    expect(find.text('Intermediate'), findsWidgets);
    expect(find.text('All Levels'), findsWidgets);

    // Verify Prices
    expect(find.text('₹120/person'), findsWidgets);
    expect(find.text('₹150/person'), findsWidgets);
    expect(find.text('₹100/person'), findsWidgets);
    expect(find.text('₹80/person'), findsWidgets);

    // Test Date Selection Interaction
    await tester.tap(find.text('21'));
    await tester.pumpAndSettle();

    // Test Filter Selection Interaction
    await tester.tap(find.text('Within 25 km'));
    await tester.pumpAndSettle();
  });

  test('ActivitiesController manages dates and filters correctly', () {
    final controller = ActivitiesController();
    expect(controller.selectedDateIndex, 0);
    expect(controller.dates.first.isSelected, isTrue);

    controller.selectDate(2);
    expect(controller.selectedDateIndex, 2);
    expect(controller.dates[2].isSelected, isTrue);
    expect(controller.dates[0].isSelected, isFalse);

    controller.toggleFilter('distance');
    expect(controller.filters.firstWhere((f) => f.id == 'distance').isSelected, isTrue);
  });
}
