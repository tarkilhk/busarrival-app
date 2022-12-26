import 'dart:async';
import 'dart:convert';

import 'package:busplanner/domain/FavouriteBusStop.dart';
import 'package:busplanner/utils/BackendRootURL.dart' as backendRootUrl;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'BusStop.dart';

class User {
  late String userName;
  late String userId;
  late List<FavouriteBusStop> favouriteBusStops;

  static final Logger log = Logger("BusPlannerLog");

  User(String myUserId, String myUserName,
      List<FavouriteBusStop> myFavouriteBusStops) {
    userId = myUserId;
    userName = myUserName;
    favouriteBusStops = myFavouriteBusStops;
  }

  Future<String> loginAndReturnSessionId() async {
//    var response = await http.get("http://192.168.1.115:8080/login?userName=pi");
    var response = await http.post(
        Uri.parse("${backendRootUrl.serverRootURL}/users/login"),
        headers: {"Accept": "application/json"},
        body: {"userName": userName});
    // var response = await http.post("${backendRootUrl.serverRootURL}/users/login", headers: {"Accept":"application/json"}, body: {"userName":this.userName} );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return (response.body);
    } else {
      // If that response was not OK, throw an error.
//      throw Exception('Failed to login : ${json.decode(response.body)}');
      return "error";
    }
  }

  bool isConnected() {
    return (userId != "0");
  }

  List<FavouriteBusStop> getFavouriteBusStops() {
    List<FavouriteBusStop> favouriteBusStops = this.favouriteBusStops;

    log.info(
        "about to return userListFromBackend, size = ${favouriteBusStops.length}");
    return favouriteBusStops;
  }

  static Future<User> loadUserFromBackendFromUserId(String userId) async {
    User loadedUser;
    log.info(
        "[busplanner] before get '${backendRootUrl.serverRootURL}/admin/users/${userId}'");
    var response = await http.get(
        Uri.parse('${backendRootUrl.serverRootURL}/admin/users/${userId}'));
    log.info(
        "[busplanner] after get '${backendRootUrl.serverRootURL}/admin/users', response code = ${response.statusCode}");

    if (response.statusCode == 200) {
      log.info("[busplanner] before Clear");
      // json.decode(response.body).forEach((user) => userListFromBackend.add(User(user["userId]"], user["userName"], user["favouriteBusStops"])));
      Map<String, dynamic> user = json.decode(response.body);
      return User.FromJSON(user);
    } else {
      log.info(
          "I am trying to load a user from backend which doesn't exist : userId = ${userId}");
      // If that response was not OK, throw an error.
//      throw Exception('Failed to login : ${json.decode(response.body)}');
      return User("-1", "CouldntLoadLastChosenUser", []);
    }
  }

  factory User.FromJSON(Map<String, dynamic> user) {
    String userId = user["userId"].toString();
    String userName = user["userName"];
    List<FavouriteBusStop> favouriteBusStops = [];
    for (Map<String, dynamic> favouriteBusStop
        in user["favouriteBusStopsAsAPIResponse"]) {
      Map<String, dynamic> busStop = favouriteBusStop["busStop"];
      List<String> serviceNos = [];

      for (String serviceNo in favouriteBusStop["serviceNos"]) {
        serviceNos.add(serviceNo);
      }
      favouriteBusStops.add(FavouriteBusStop(
          BusStop(
              busStop["busStopId"].toString(),
              busStop["busStopName"].toString(),
              busStop["busStopCode"].toString()),
          serviceNos));
    }
    return User(userId, userName, favouriteBusStops);
  }
}
