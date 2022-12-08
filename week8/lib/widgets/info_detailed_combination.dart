import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dice.dart';
import '../providers.dart';

class InfoDetailedCombinationWidget extends ConsumerStatefulWidget {

  const InfoDetailedCombinationWidget({super.key, required this.ref});


  final WidgetRef ref;

  @override
  ConsumerState<InfoDetailedCombinationWidget> createState() => InfoDetailedCombinationWidgetState();
  
}


class InfoDetailedCombinationWidgetState extends ConsumerState<InfoDetailedCombinationWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(modelProvider).currentDice();

    int d1 = dice.die[0];
    int d2 = dice.die[1];

    int combinationCount = dice.dieStatistics[d1-1][d2-1];
    int maxCountAnyCombination = dice.dieStatistics.expand((element) => element).toList().reduce((max));
    int numberOfThrows = dice.numberOfThrows;
    int sumCurrentComb = d1 + d2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[


        Text(
          'Combination: $d1 - $d2 (Sum: $sumCurrentComb)',
        ),
        Text(
          'Combination occurrences: $combinationCount / $numberOfThrows (highest: $maxCountAnyCombination)',
        ),


    ],
    );
  }



}