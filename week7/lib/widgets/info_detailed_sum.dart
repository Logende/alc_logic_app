import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/providers.dart';

import '../model/dice.dart';

class InfoDetailedSumWidget extends ConsumerStatefulWidget {

  const InfoDetailedSumWidget({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<InfoDetailedSumWidget> createState() => InfoDetailedSumWidgetState();
  
}


class InfoDetailedSumWidgetState extends ConsumerState<InfoDetailedSumWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(modelProvider).currentDice();

    int d1 = dice.die[0];
    int d2 = dice.die[1];

    int sum = d1 + d2;
    int sumCount = dice.sumStatistics[sum -2];
    int maxCountAnySum = dice.sumStatistics.reduce(max);
    int numberOfThrows = dice.numberOfThrows;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[


        Text(
          'Sum: $sum',
        ),
        Text(
          'Sum occurrences: $sumCount / $numberOfThrows (highest: $maxCountAnySum)',
        ),


    ],
    );
  }



}