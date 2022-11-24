import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/dice.dart';

import '../model/dice.dart';

class DieWidget extends ConsumerStatefulWidget {


  const DieWidget({super.key, required this.ref,
    required this.modelProvider});


  final StateProvider<Dice> modelProvider;
  final WidgetRef ref;


  @override
  ConsumerState<DieWidget> createState() => DieState();
  
}


class DieState extends ConsumerState<DieWidget> {

  @override
  Widget build(BuildContext context) {
    return
      Wrap(
        spacing: 10.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          DiceWidget(ref: ref, valueProvider: getValueProviderDice1()),
          DiceWidget(ref: ref, valueProvider: getValueProviderDice2())
        ],
      );
  }


  StateProvider<int> getValueProviderDice1() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[0]);
  }
  StateProvider<int> getValueProviderDice2() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[1]);
  }

}