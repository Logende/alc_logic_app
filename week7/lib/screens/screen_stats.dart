import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/heatmap_distribution.dart';
import 'package:week6/widgets/heatmap_individual_throws.dart';
import 'package:week6/widgets/info.dart';
import 'package:week6/widgets/navigation_bar.dart';

import '../main.dart';
import '../model/dice.dart';
import '../model/timer_model.dart';
import '../providers.dart';

class ScreenStats extends ConsumerStatefulWidget {
   const ScreenStats({super.key});

   static String get routeName => 'stats';
   static String get routeLocation => '/stats';

  final String title = "Statistics";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenStatsState();
  }
}




class _ScreenStatsState extends ConsumerState<ScreenStats> {



  @override
  Widget build(BuildContext context) {
    TimerModel timerModel = ref.watch(timerModelProvider);

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            InfoWidget(ref: ref),

            Text(
              'Timer delta: last: ${timerModel.lastDelta.toStringAsFixed(1)}, '
                  'min: ${timerModel.minDelta.toStringAsFixed(1)}, '
                  'max: ${timerModel.maxDelta.toStringAsFixed(1)}',
            ),

            HeatmapDistributionWidget(ref: ref),
            HeatmapIndividualThrowsWidget(ref: ref),

            NavigationBarWidget(ref: ref),

          ],
        ),
      ),

    );
  }
   }

