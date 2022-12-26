import 'package:busplanner/domain/NextBus.dart';

class BusArrival {
  var message = "";
  var isError = false;
  late DateTime lastRefreshTime;

  var services = <Service>[];

  BusArrival.fromJSON(Map<String, dynamic> busArrivalJSON) {
    message = busArrivalJSON["message"];
    isError = busArrivalJSON["isError"];
    lastRefreshTime = DateTime.parse(busArrivalJSON["lastRefreshTime"]);

    busArrivalJSON["services"]
        .forEach((service) => services.add(Service.fromJson(service)));
  }

  BusArrival(this.message);

  @override
  String toString() {
    return "BusArrival with ${services.length} service(s) : ${services.join(" | ")}";
  }
}

class Service {
  late NextBus nextBus;
  late NextBus nextBus2;
  late NextBus nextBus3;
  var operator = "";
  var serviceNo = "";
  late List<NextBus> iterableListOfNextBuses;

  // var numberOfNonEmptyNextBus = 0;

  Service(this.nextBus, this.nextBus2, this.nextBus3, this.operator,
      this.serviceNo) {
    iterableListOfNextBuses = [];
    if (nextBus.isNotEmpty()) iterableListOfNextBuses.add(nextBus);
    if (nextBus2.isNotEmpty()) iterableListOfNextBuses.add(nextBus2);
    if (nextBus3.isNotEmpty()) iterableListOfNextBuses.add(nextBus3);
  }

  @override
  String toString() {
    return "Service #${serviceNo} from ${operator} - ${iterableListOfNextBuses.length} buses coming";
  }

  factory Service.fromJson(Map<String, dynamic> service) {
    return Service(
        NextBus.fromJson(service["nextBus"]),
        NextBus.fromJson(service["nextBus2"]),
        NextBus.fromJson(service["nextBus3"]),
        service["operator"].toString(),
        service["serviceNo"].toString());
  }
}
