import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dice.dart';

class InfoThrowNumberWidget extends ConsumerStatefulWidget {

  const InfoThrowNumberWidget({super.key, required this.ref,
    required this.valueProvider});


  final StateProvider<int> valueProvider;
  final WidgetRef ref;

  @override
  ConsumerState<InfoThrowNumberWidget> createState() => InfoThrowNumberWidgetState();
  
}


class InfoThrowNumberWidgetState extends ConsumerState<InfoThrowNumberWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        const Text(
          'Count of throws:',
        ),
        Text(
          '${_readValue()}',
          style: Theme
              .of(context)
              .textTheme
              .headline4,
        ),



    ],
    );
  }

  int _readValue() {
      return widget.ref.watch(widget.valueProvider);
  }
}