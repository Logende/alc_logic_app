import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/model/timer_model.dart';
import 'package:week8/widgets/info_throw_number.dart';

import '../model/dice.dart';
import '../providers.dart';

class InfoWidget extends ConsumerStatefulWidget {

  const InfoWidget({super.key, required this.ref});


  final WidgetRef ref;

  @override
  ConsumerState<InfoWidget> createState() => InfoWidgetState();
  
}


class InfoWidgetState extends ConsumerState<InfoWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(modelProvider).currentDice();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        InfoThrowNumberWidget(ref: ref, valueProvider: getValueProviderNumberThrows()),

        Text(
          'Equal distribution: ${dice.equalDistr}',
        ),




    ],
    );
  }



  StateProvider<int> getValueProviderNumberThrows() {
    return StateProvider((ref) => ref.watch(modelProvider).currentDice().numberOfThrows);
  }
}