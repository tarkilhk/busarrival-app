import 'package:busplanner/utils/TimeConverter.dart' as TimeConverter;

class NextBus {
  late DateTime estimatedArrival;
  String load = '';
  String type = '';

  // String estimatedArrival24H = '';

  NextBus(this.estimatedArrival, this.load, this.type);

  @override
  String toString() {
    return "Load $load - Type $type - ETA ${TimeConverter.toHHMMSS(estimatedArrival)}";
  }

  factory NextBus.fromJson(Map<String, dynamic> json) {
    NextBus nextBus =
        NextBus(DateTime.fromMillisecondsSinceEpoch(0), "load", "type");
    if (json['estimatedArrival'] != "") {
      nextBus = NextBus(
        DateTime.parse(json['estimatedArrival']),
        json['load'],
        json['type'],
      );
    }
    return nextBus;
  }

  bool isNotEmpty() {
    return estimatedArrival != DateTime.fromMillisecondsSinceEpoch(0);
  }
}
