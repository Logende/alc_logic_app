
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:week8/providers.dart';


class TimerWidget extends ConsumerStatefulWidget {

  const TimerWidget({super.key, required this.ref});


  final WidgetRef ref;

  @override
  ConsumerState<TimerWidget> createState() => TimerWidgetState();
  
}


class TimerWidgetState extends ConsumerState<TimerWidget> {


  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        const Text(
          'Timer:',
        ),
        Text(
          _readValue(),
          style: Theme
              .of(context)
              .textTheme
              .headline4,
        ),



    ],
    );
  }

  String _readValue() {
    var timerValue = widget.ref.watch(timerModelProvider).timerValue;
    var dateTime = DateTime.fromMillisecondsSinceEpoch((timerValue * 1000).toInt());
    var formattedTime =  DateFormat('mm:ss:SS').format(dateTime);
    // cut off two digits of the milliseconds:
    formattedTime = formattedTime.substring(0, formattedTime.length - 2);
    return formattedTime;
  }
}