import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:week6/model/dice.dart';
import 'package:week6/screens/screen_all.dart';
import 'package:week6/screens/screen_detailed_combination.dart';
import 'package:week6/screens/screen_dices.dart';
import 'package:week6/screens/screen_settings.dart';
import 'package:week6/screens/screen_stats.dart';


enum ScreenType {
  screenDices,
  screenStats,
  screenSettings,
  screenDetailedCombination,
}

class NavigationBarWidget extends ConsumerStatefulWidget {
  const NavigationBarWidget({super.key, required this.ref, required this.modelProvider});


  final WidgetRef ref;
  final StateProvider<Dice> modelProvider;

  @override
  ConsumerState<NavigationBarWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends ConsumerState<NavigationBarWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Dices',
      style: optionStyle,
    ),
    Text(
      'Index 1: Stats',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
    Text(
      'Index 3: CombDet',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {

      ScreenType screenType = ScreenType.values[index];

      switch (screenType) {
        case ScreenType.screenDices:
          context.go(ScreenDices.routeLocation);
          break;

        case ScreenType.screenStats:
          context.go(ScreenStats.routeLocation);
          break;

        case ScreenType.screenSettings:
          context.go(ScreenSettings.routeLocation);
          break;

        case ScreenType.screenDetailedCombination:
          context.go(ScreenDetailedCombination.routeLocation);
          break;
      }

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.holiday_village),
            label: 'CombDet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
    );
  }
}
