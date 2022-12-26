import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetMainAnswers extends ConsumerStatefulWidget {
  const WidgetMainAnswers({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<WidgetMainAnswers> createState() => WidgetMainAnswersState();
}

class WidgetMainAnswersState extends ConsumerState<WidgetMainAnswers> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onPressedThumbsUp,
            iconSize: 60,
            icon: const Icon(Icons.thumb_up)),
        IconButton(
            onPressed: onPressedThumbsDown,
            iconSize: 60,
            icon: const Icon(Icons.thumb_down))
      ],
    );
  }

  void onPressedThumbsUp() {}
  void onPressedThumbsDown() {}
  
}
