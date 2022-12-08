import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/data_persistence_handler.dart';
import 'package:week8/widgets/die.dart';
import 'package:week8/widgets/info.dart';
import 'package:week8/widgets/navigation_bar.dart';
import 'package:week8/widgets/timer.dart';

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


     @override
     void initState() {
       super.initState();

       // make sure this gets executed after initState
       // to avoid conflicts
       Future.delayed(Duration.zero, () {
         initModelState();
       });

     }

     Future<void> initModelState() async {
       var notifier = ref.watch(modelProvider.notifier);
       var dice = await readState();
       setState(() {
         notifier.initState(dice);
       });
     }


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

