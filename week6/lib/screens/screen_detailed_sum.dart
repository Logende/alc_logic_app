import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/widgets/heatmap_distribution.dart';
import 'package:week6/widgets/heatmap_individual_throws.dart';
import 'package:week6/widgets/info.dart';
import 'package:week6/widgets/info_detailed_combination.dart';
import 'package:week6/widgets/info_detailed_sum.dart';
import 'package:week6/widgets/info_throw_number.dart';
import 'package:week6/widgets/navigation_bar.dart';
import 'package:week6/widgets/switch_equal_distr.dart';

import '../main.dart';
import '../model/dice.dart';

class ScreenDetailedSum extends ConsumerStatefulWidget {
   const ScreenDetailedSum({super.key});

   static String get routeName => 'detailed_sum';
   static String get routeLocation => '/detailed_sum';

  final String title = "Sum Details";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenDetailedSumState();
  }
}




class _ScreenDetailedSumState extends ConsumerState<ScreenDetailedSum> {



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



            InfoDetailedSumWidget(ref: ref, modelProvider: modelProvider),
            NavigationBarWidget(ref: ref, modelProvider: modelProvider),

          ],
        ),
      ),

    );
  }

}

