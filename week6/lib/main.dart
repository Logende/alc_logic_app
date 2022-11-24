
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/router.dart';
import 'package:week6/screens/screen_all.dart';
import 'package:week6/screens/screen_dices.dart';
import 'package:week6/screens/screen_stats.dart';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'model/dice.dart';
import 'package:go_router/go_router.dart';


void main() {
  runApp(ProviderScope(child: MyApp(),)

  );
}

final modelProvider = StateProvider((ref) => Dice());

class MyApp extends ConsumerWidget {
   MyApp({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'flutter_riverpod + go_router Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );


    /*return MaterialApp(
      title: 'Dice App Felix',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ScreenStats(title: 'Dice Home Page', ref: ref, modelProvider: modelProvider,),
    );*/
  }
}