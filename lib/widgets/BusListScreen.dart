import 'dart:async';
import 'dart:convert';

import 'package:busplanner/domain/BusArrival.dart';
import 'package:busplanner/domain/FavouriteBusStop.dart';
import 'package:busplanner/domain/NextBus.dart';
import 'package:busplanner/domain/User.dart';
import 'package:busplanner/utils/BackendRootURL.dart' as backendRootUrl;
import 'package:busplanner/utils/TimeConverter.dart' as TimeConverter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class BusListScreen extends StatefulWidget {
  late User connectedUser;
  late FavouriteBusStop chosenBusStop;

  BusListScreen(this.connectedUser, this.chosenBusStop, {super.key});

  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  // late List<NextBus> myBusTimes;
  late BusArrival busArrival;

  final Logger log = Logger("BusPlannerLog");

  @override
  void initState() {
    log.info("initState of BusListScreen");
    super.initState();
    busArrival = BusArrival("Loading");
    log.info("ready to load NextBusTimes");
    GetBusesTimes(widget.chosenBusStop).then((result) {
      setState(() {
        busArrival = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.connectedUser.userName == "") {
      return const Center(child: Text("You've been logged off"));
      //TODO : find how to navigate to home page
    } else if (busArrival.message == "Loading") {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else if (busArrival.isError) {
      //TODO : display error message only
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                      'Last refresh time : ${TimeConverter.toHHMMSS(busArrival.lastRefreshTime)}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                )
              ],
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 128,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("     Error : ${busArrival.message}",
                      textAlign: TextAlign.left),
                ),
              ),
            ),
          ]));
    } else if (busArrival.services.isEmpty) {
      // TODO : display "No Bus"
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin:
                      new EdgeInsets.only(top: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                      'Last refresh time : ${TimeConverter.toHHMMSS(busArrival.lastRefreshTime)}',
                      textAlign: TextAlign.right,
                      style: new TextStyle(fontStyle: FontStyle.italic)),
                )
              ],
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text("     No bus", textAlign: TextAlign.left),
                ),
                height: MediaQuery.of(context).size.height - 128,
              ),
            ),
          ]));
    }
    {
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, right: 20.0, bottom: 10.0),
                    child: Text(
                        'Last refresh time : ${TimeConverter.toHHMMSS(busArrival.lastRefreshTime)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: busArrival.services.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(busArrival.services[index].toString()),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: busArrival
                                .services[index].iterableListOfNextBuses.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context2, int index2) {
                              return ListTile(
                                title: Text(
                                  FormatLine(busArrival.services[index]
                                      .iterableListOfNextBuses[index2]),
                                  style: TextStyle(
                                      color: pickColorBasedOnSeating(busArrival
                                          .services[index]
                                          .iterableListOfNextBuses[index2]),
                                      fontWeight: pickFontWeightBasedOnBusType(
                                          busArrival.services[index]
                                                  .iterableListOfNextBuses[
                                              index2])),
                                ),
                              );
                            }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ));
    }
  }

  Future<BusArrival> GetBusesTimes(FavouriteBusStop chosenBusStop) async {
    late BusArrival busArrival;

    if (chosenBusStop.busStop.busStopId != "-1") {
      log.info("Can this happen ??? TODO");
    }

    var response = await http.get(Uri.parse(
        '${backendRootUrl.serverRootURL}/bus-arrival/bus-stop-code-and-service-nos?busStopCode=${chosenBusStop.busStop.busStopCode}&serviceNos=${chosenBusStop.serviceNos.join("&serviceNos=")}'));
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      busArrival = BusArrival.fromJSON(jsonBody);
    } else {
      // If that response was not OK, throw an error.
      // throw Exception('Failed to login : ${json.decode(response.body)}');
      log.severe(
          "[${response.statusCode}] Couldn't get BusArrival from backend call '${backendRootUrl.serverRootURL}/bus-arrival/bus-route-and-bus-stop-code?serviceNo=${chosenBusStop.serviceNos.first}&busStopCode=${chosenBusStop.busStop.busStopCode}'");
      busArrival = BusArrival("");
    }

    log.info("About to return BusArrival : $busArrival");
    return busArrival;
  }

  Future<Null> _handleRefresh() async {
    GetBusesTimes(widget.chosenBusStop).then((result) {
      setState(() {
        busArrival = result;
      });
    });
  }

  FontWeight pickFontWeightBasedOnBusType(NextBus nextBus) {
    switch (nextBus.type) {
      case "DD":
        {
          return FontWeight.bold;
        }
        break;
      case "SD":
        {
          return FontWeight.normal;
        }
        break;
      case "BD":
        {
          return FontWeight.normal;
        }
        break;
      default:
        {
          return FontWeight.normal;
        }
        break;
    }
  }
}

Color pickColorBasedOnSeating(NextBus nextBus) {
  switch (nextBus.load) {
    case "SEA":
      {
        return Colors.green;
      }
      break;
    case "SDA":
      {
        return Colors.amber;
      }
      break;
    case "LSD":
      {
        return Colors.red;
      }
      break;
    default:
      {
        return Colors.black;
      }
      break;
  }
}

String FormatLine(NextBus nextBus) {
  return "${nextBus.estimatedArrival}";
}
