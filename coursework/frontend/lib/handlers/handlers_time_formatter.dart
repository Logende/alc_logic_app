import 'package:intl/intl.dart';

String formatTimeTimer(double time) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
  var formattedTime = DateFormat('mm:ss:SS').format(dateTime);
  // cut off two digits of the milliseconds:
  formattedTime = formattedTime.substring(0, formattedTime.length - 2);
  return formattedTime;
}

String formatTimePlaytime(double time) {
  if (time.isInfinite || time.isNaN) {
    time = 0;
  }
  // taken from https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
  var duration = Duration(milliseconds: (time * 1000).toInt());
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  String twoDigitMs = twoDigits(duration.inMilliseconds.remainder(1000));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitMs";
}
