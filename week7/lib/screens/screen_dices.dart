import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/moviedb_handler.dart';
import 'package:week6/widgets/die.dart';
import 'package:week6/widgets/info.dart';
import 'package:week6/widgets/navigation_bar.dart';
import 'package:week6/widgets/timer.dart';

import '../model/dice.dart';
import '../providers.dart';

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




   void _manyThrows() {
     ref.watch(timerModelProvider.notifier).resetTimer(ref);

     setState(() {
       var notifier = ref.watch(modelProvider.notifier);
       notifier.throwDice(1000);
     });
   }

   void setEqualDistr(bool value) {
     setState(() {
       var notifier = ref.watch(modelProvider.notifier);
       if (notifier.currentDice().equalDistr != value) {
         notifier.setEqualDistribution(value);
       }
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

            TimerWidget(ref: ref),

            DieWidget(ref: ref),

            InfoWidget(ref: ref),
            /*CupertinoSwitch(
              value: ref.watch(getEqualDistrProvider()),
              onChanged: (value) {
                ref.watch(widget.modelProvider).equalDistr = value;
              },
            ),*/

            TextButton(
                onPressed: _manyThrows, child: const Text('1000 Throws')),

            NavigationBarWidget(ref: ref),


          ],
        ),
      ),
    );
  }
   }

