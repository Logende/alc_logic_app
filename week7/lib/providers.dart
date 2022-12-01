import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/model/dice_list.dart';

final modelProvider = StateNotifierProvider<DiceListNotifier, DiceList>((ref) {
return DiceListNotifier();
});