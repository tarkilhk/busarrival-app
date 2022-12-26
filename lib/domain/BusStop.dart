class BusStop {
  late String busStopId;
  late String busStopName;
  late String busStopCode;

  // late String serviceNo;

  // final Logger log = Logger("BusPlannerLog");

  BusStop(this.busStopId, this.busStopName, this.busStopCode);

  @override
  String toString() {
    return "[$busStopId] $busStopName - Bus Stop Code {$busStopCode";
    // return "[${this.busStopId}] ${this.busStopName} - Bus #${this.serviceNo} Stop Code {${this.busStopCode}";
  }
}
