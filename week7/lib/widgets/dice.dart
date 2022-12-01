import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dice.dart';

class DiceWidget extends StatefulWidget {

  const DiceWidget({super.key, required this.ref,
    required this.valueProvider});


  final StateProvider<int> valueProvider;
  final WidgetRef ref;

  @override
  State<DiceWidget> createState() => DiceState();
  
}


class DiceState extends State<DiceWidget> {

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black)
        ),
        child: Text(
          '${_readValue()}',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
  }

  int _readValue() {
      return widget.ref.watch(widget.valueProvider);
  }
}