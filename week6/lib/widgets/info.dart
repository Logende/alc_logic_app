import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/info_throw_number.dart';

import '../model/dice.dart';

class InfoWidget extends ConsumerStatefulWidget {

  const InfoWidget({super.key, required this.ref,
    required this.modelProvider});


  final StateProvider<Dice> modelProvider;
  final WidgetRef ref;

  @override
  ConsumerState<InfoWidget> createState() => InfoWidgetState();
  
}


class InfoWidgetState extends ConsumerState<InfoWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(widget.modelProvider);

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
    return StateProvider((ref) => ref.watch(widget.modelProvider).numberOfThrows);
  }
}