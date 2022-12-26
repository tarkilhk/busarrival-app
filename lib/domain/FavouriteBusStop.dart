import 'package:busplanner/domain/BusStop.dart';

class FavouriteBusStop {
  late BusStop busStop;
  late List<String> serviceNos;

  // final Logger log = Logger("BusPlannerLog");

  FavouriteBusStop(this.busStop, this.serviceNos);

  bool isNotYetChosen() {
    return busStop.busStopId == "-1";
  }

  @override
  String toString() {
    return "[$busStop] - Services {${serviceNos.join(",")}}";
  }
}
