import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/dice.dart';
import '../providers.dart';

class SwitchEqualDistrWidget extends ConsumerStatefulWidget {

  const SwitchEqualDistrWidget({super.key, required this.ref});


  final WidgetRef ref;

  @override
  ConsumerState<SwitchEqualDistrWidget> createState() => SwitchEqualDistrWidgetState();
  
}


class SwitchEqualDistrWidgetState extends ConsumerState<SwitchEqualDistrWidget> {

  @override
  Widget build(BuildContext context) {


    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        const Text(
          'Equal distribution:',
        ),
        CupertinoSwitch(
          value: _readValue(),
          onChanged: (value) {
            setState(() {
              // TODO: fix issue that state does not update visibly
              var notifier = ref.watch(modelProvider.notifier);
              notifier.setEqualDistribution(value);
            });
          },
        ),



    ],
    );
  }

  bool _readValue() {
      return ref.watch(modelProvider).currentDice().equalDistr;
  }
}