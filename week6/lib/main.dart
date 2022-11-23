import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/screens/screen_all.dart';
import 'package:week6/screens/screen_dices.dart';

import 'heatmap/fl_heatmap.dart';
import 'model/dice.dart';

void main() {
  runApp(ProviderScope(child: MyApp(),)

  );
}

class MyApp extends ConsumerWidget {
   MyApp({super.key});

  final modelProvider = StateProvider((ref) => Dice());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Dice App Felix',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ScreenDices(title: 'Dice Home Page', ref: ref, modelProvider: modelProvider,),
    );
  }
}