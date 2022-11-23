import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/dice.dart';

import '../model/dice.dart';

class ScreenDices extends ConsumerStatefulWidget {
   ScreenDices({super.key, required this.ref,
    required this.title, required this.modelProvider});


  final String title;
  final StateProvider<Dice> modelProvider;



  final WidgetRef ref;


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenDicesState();
  }
}




   class _ScreenDicesState extends ConsumerState<ScreenDices> {



   StateProvider<bool> getEqualDistrProvider() {
     return StateProvider((ref) => ref.watch(widget.modelProvider).equalDistr);
   }
   StateProvider<int> getValueProvider1() {
     return StateProvider((ref) => ref.watch(widget.modelProvider).die[0]);
   }
   StateProvider<int> getValueProvider2() {
     return StateProvider((ref) => ref.watch(widget.modelProvider).die[1]);
   }

   void _throwDice() {
     setState(() {
       Dice dice = ref.watch(widget.modelProvider);
       dice.throwDice();
     });
   }

   void _manyThrows() {
     setState(() {
       Dice dice = ref.watch(widget.modelProvider);
       for (var i = 0; i < 1000; i++) {
         dice.throwDice();
       }
     });
   }

   void setEqualDistr(bool value) {
     setState(() {
       Dice dice = ref.watch(widget.modelProvider);
       dice.equalDistr = value;
     });
   }

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(widget.modelProvider);

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 10.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                DiceWidget(ref: ref, valueProvider: getValueProvider1()),
                DiceWidget(ref: ref, valueProvider: getValueProvider2())
              ],
            ),

            const Text(
              'Count of throws:',
            ),
            Text(
              '${dice.numberOfThrows}',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),

            const Text(
              'Equal distribution:',
            ),
            CupertinoSwitch(
              value: ref.watch(getEqualDistrProvider()),
              onChanged: (value) {
                ref.watch(widget.modelProvider).equalDistr = value;
              },
            ),

            TextButton(
                onPressed: _manyThrows, child: const Text('1000 Throws')),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _throwDice,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
   }

