import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/model_game_state.dart';
import '../providers.dart';

class ScreenMain extends ConsumerStatefulWidget {
  const ScreenMain({super.key});

  static String get routeName => 'main';
  static String get routeLocation => '/';

  final String title = "Main";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainState();
  }
}

class _ScreenMainState extends ConsumerState<ScreenMain> {

  @override
  Widget build(BuildContext context) {
    GameState gameState = ref.watch(gameStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text(gameState.currentTask.concept),
    );
  }
}
