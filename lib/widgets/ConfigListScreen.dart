import 'package:busplanner/domain/FavouriteBusStop.dart';
import 'package:busplanner/domain/User.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ConfigListScreen extends StatefulWidget {
  final Function setFavouriteBusStop;
  final User connectedUser;

  ConfigListScreen(this.connectedUser, this.setFavouriteBusStop);

  @override
  _ConfigListScreenState createState() => new _ConfigListScreenState();
}

class _ConfigListScreenState extends State<ConfigListScreen> {
  late List<FavouriteBusStop> favouriteBusStops;

  final Logger log = Logger("BusPlannerLog");

  _ConfigListScreenState();

  @override
  void initState() {
    super.initState();
    this.favouriteBusStops = [];

    this.favouriteBusStops = widget.connectedUser.getFavouriteBusStops();
  }

  @override
  Widget build(BuildContext context) {
    // Use the userList to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("What do you want to see ?"),
      ),
      body: this.favouriteBusStops.isEmpty
          ? Center(
              child: new CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: favouriteBusStops.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favouriteBusStops[index].busStop.busStopName),
                  // When a user taps on the ListTile, navigate to the ConfigListScreen.
                  // Notice that we're not only creating a ConfigListScreen, we're
                  // also passing the current user through to it!
                  onTap: () {
                    setState(() {
                      _tapOnConfigName(favouriteBusStops[index]);
                      log.info("I want ${favouriteBusStops[index]}");
                    });
                  },
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                );
              },
            ),
    );
  }

  _tapOnConfigName(FavouriteBusStop tappedFavouriteBusStop) {
    setState(() {
      widget.setFavouriteBusStop(tappedFavouriteBusStop);
    });
  }
}
