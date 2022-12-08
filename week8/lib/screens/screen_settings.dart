import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/widgets/heatmap_distribution.dart';
import 'package:week8/widgets/heatmap_individual_throws.dart';
import 'package:week8/widgets/info.dart';
import 'package:week8/widgets/info_throw_number.dart';
import 'package:week8/widgets/navigation_bar.dart';
import 'package:week8/widgets/switch_equal_distr.dart';

import '../main.dart';
import '../model/dice.dart';
import '../providers.dart';

class ScreenSettings extends ConsumerStatefulWidget {
   const ScreenSettings({super.key});

   static String get routeName => 'settings';
   static String get routeLocation => '/settings';

  final String title = "Settings";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenSettingsState();
  }
}




class _ScreenSettingsState extends ConsumerState<ScreenSettings> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[



            InfoThrowNumberWidget(ref: ref, valueProvider: getValueProviderNumberThrows()),

            TextButton(onPressed: _attemptReset, child: const Text('Reset')),

            SwitchEqualDistrWidget(ref: ref),

            NavigationBarWidget(ref: ref),

          ],
        ),
      ),

    );
  }


  StateProvider<int> getValueProviderNumberThrows() {
    return StateProvider((ref) => ref.watch(modelProvider).currentDice().numberOfThrows);
  }


  void _attemptReset() {
    final snackBar = SnackBar(
      content: const Text('Reset Statistics?'),
      action: SnackBarAction(
        label: 'Reset',
        onPressed: () {
          _reset();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _reset() {
    setState(() {
      Dice dice = ref.watch(modelProvider).currentDice();
      dice.die[1] = 1;
      dice.die[0] = 1;
      dice.resetStatistics();
    });
  }

}

