import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/die.dart';
import 'package:week6/widgets/info.dart';
import 'package:week6/widgets/navigation_bar.dart';

import '../main.dart';
import '../model/dice.dart';

class ScreenDices extends ConsumerStatefulWidget {
   const ScreenDices({super.key});


   static String get routeName => 'dices';
   static String get routeLocation => '/';

  final String title = "Dices";


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenDicesState();
  }
}




   class _ScreenDicesState extends ConsumerState<ScreenDices> {




   void _throwDice() {
     setState(() {
       Dice dice = ref.watch(modelProvider);
       dice.throwDice();
     });
   }

   void _manyThrows() {
     setState(() {
       Dice dice = ref.watch(modelProvider);
       for (var i = 0; i < 1000; i++) {
         dice.throwDice();
       }
     });
   }

   void setEqualDistr(bool value) {
     setState(() {
       Dice dice = ref.watch(modelProvider);
       dice.equalDistr = value;
     });
   }

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
            DieWidget(ref: ref, modelProvider: modelProvider),

            InfoWidget(ref: ref, modelProvider: modelProvider),
            /*CupertinoSwitch(
              value: ref.watch(getEqualDistrProvider()),
              onChanged: (value) {
                ref.watch(widget.modelProvider).equalDistr = value;
              },
            ),*/

            TextButton(
                onPressed: _manyThrows, child: const Text('1000 Throws')),

            NavigationBarWidget(ref: ref, modelProvider: modelProvider),


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

