import 'package:busplanner/domain/FavouriteBusStop.dart';
import 'package:busplanner/domain/User.dart';
import 'package:busplanner/widgets/BusListScreen.dart';
import 'package:busplanner/widgets/ConfigListScreen.dart';
import 'package:busplanner/widgets/SplashScreen.dart';
import 'package:busplanner/widgets/UserListScreen.dart';
import 'package:busplanner/widgets/UserLoginLoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';

import '../domain/BusStop.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User connectedUser = User("-1", "init", []);
  FavouriteBusStop chosenBusStop = FavouriteBusStop(BusStop("-1", "", ""), []);

  final Logger log = Logger("BusPlannerLog");

  @override
  void initState() {
    log.activateLogcat();
    super.initState();
  }

  void _setConnectedUser(User updatedConnectedUser) {
    setState(() {
      connectedUser = updatedConnectedUser;
//      this.connectedUser.login()      TODO : can we login here directly ?
    });
  }

  void _setConfigName(FavouriteBusStop updatedBusStop) {
    setState(() {
      chosenBusStop = updatedBusStop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: chosenBusStop.isNotYetChosen()
            ? Text('Hello ${connectedUser.userName}')
            : Text(
                'Hello ${connectedUser.userName} - ${chosenBusStop.busStop.busStopName}'),
      ),
      body: widgetPicker(),
    );
  }

  Widget widgetPicker() {
    if (connectedUser.userName == "init") {
      log.info("userName = init");
      // Display SplashScreen (SplashScreen should load from Preferences)
      return SplashScreen(_setConnectedUser);
    } else if (connectedUser.userName == "") {
      log.info("userName empty, need to load list from backend");
      // Display SplashScreen (SplashScreen should load from Preferences)
      return UserListScreen(_setConnectedUser);
    } else if (!connectedUser.isConnected()) {
      log.info("userName ${connectedUser.userName} needs to login");
      return UserLoginLoadingScreen(connectedUser, _setConnectedUser);
    } else {
      // app is already logged in to the backend and has a sessionId
      if (chosenBusStop.isNotYetChosen()) {
        // Display configChooser - should load config list from API
        log.info(
            "userName ${connectedUser.userName} logged in with session id ${connectedUser.userId}");
        return ConfigListScreen(connectedUser, _setConfigName);
      } else {
        // Display BusList
        log.info("I need to display Bus List");
        return BusListScreen(connectedUser, chosenBusStop);
      }
    }
  }
}
