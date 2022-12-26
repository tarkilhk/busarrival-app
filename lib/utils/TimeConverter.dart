library TimeConverter;

String toHHMMSS(DateTime myDate) {
  int hour = myDate.toLocal().hour;
  int minute = myDate.toLocal().minute;
  int second = myDate.toLocal().second;

  String paddedHour = hour < 10 ? "0$hour" : hour.toString();
  String paddedMinute = minute < 10 ? "0$minute" : minute.toString();
  String paddedSecond = second < 10 ? "0$second" : second.toString();

  return "$paddedHour:$paddedMinute:$paddedSecond";
}
