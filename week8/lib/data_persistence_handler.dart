import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:week8/model/dice.dart';
import 'package:shared_preferences/shared_preferences.dart';


  Future<void> persistState(Dice dice) async {
    final prefs = await SharedPreferences.getInstance();
    String stateString = jsonEncode(dice.toMap());
    prefs.setString("state", stateString);
    debugPrint("persist state");
  }

  Future<Dice> readState() async {
    debugPrint("read state");
    final prefs = await SharedPreferences.getInstance();
    Dice dice;
    if (prefs.getKeys().contains("state")) {
      String? stateString = prefs.getString("state");
      dice = Dice.fromMap(jsonDecode(stateString!));
      debugPrint("found state");
    } else {
      debugPrint("create default state");
      dice = createDefaultDiceState();
    }
    return dice;
  }


