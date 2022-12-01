import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:week6/model/dice.dart';
import 'package:week6/providers.dart';
import 'package:week6/screens/screen_dices.dart';
import 'package:week6/screens/screen_settings.dart';
import 'package:week6/screens/screen_stats.dart';


enum ActionType {
  screenDices,
  screenStats,
  screenSettings,
  undo,
  redo
}

class NavigationBarWidget extends ConsumerStatefulWidget {
  const NavigationBarWidget({super.key, required this.ref});


  final WidgetRef ref;

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
      'Index 3: Undo',
      style: optionStyle,
    ),
    Text(
      'Index 4: Redo',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {

      ActionType screenType = ActionType.values[index];
      var notifier = ref.watch(modelProvider.notifier);

      switch (screenType) {
        case ActionType.screenDices:
          context.go(ScreenDices.routeLocation);
          break;

        case ActionType.screenStats:
          context.go(ScreenStats.routeLocation);
          break;

        case ActionType.screenSettings:
          context.go(ScreenSettings.routeLocation);
          break;

        case ActionType.undo:
          if (notifier.isUndoPossible()) {
            notifier.undo();
          }
          break;

        case ActionType.redo:
          if (notifier.isRedoPossible()) {
            notifier.redo();
          }
          break;
      }

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var notifier = ref.watch(modelProvider.notifier);

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
            icon: Icon(Icons.undo),
            label: 'Undo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redo),
            label: 'Redo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
    );
  }


}

