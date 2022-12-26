import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetMainTimer extends ConsumerStatefulWidget {
  const WidgetMainTimer({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<WidgetMainTimer> createState() => WidgetMainTimerState();
}

class WidgetMainTimerState extends ConsumerState<WidgetMainTimer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time_outlined,
          color: Theme.of(context).colorScheme.secondary,
          size: 36,
        ),
        Text(" 10:34:08", style: Theme.of(context).textTheme.headline2)
      ],
    );
  }
}
