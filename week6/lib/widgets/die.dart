import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/dice.dart';

class DieWidget extends StatefulWidget {


  const DieWidget({super.key, required this.dice});


  final Dice dice;

  @override
  State<DieWidget> createState() => DieState(dice: dice);
  
}


class DieState extends State<DieWidget> {

  DieState({required this.dice});
  final Dice dice;

  @override
  Widget build(BuildContext context) {
    return
      Wrap(
        spacing: 10.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
            child: Text(
              '${dice.die[0]}',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
            child: Text(
              '${dice.die[1]}',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ],
      );
  }

}