import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:km_stores_app/view.dart';

Future<void> main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false
  );
  // Periodic task registration
  await Workmanager.registerPeriodicTask("5", "simplePeriodicTask",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 1),//when should it check the link
      initialDelay: Duration(seconds: 5),//duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));*/
  runApp(MyApp());
}

/*void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();
    var settings = new InitializationSettings(android, IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics
  );
  await flip.show(0, 'GeeksforGeeks',
      'Your are one step away to connect with GeeksforGeeks',
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}
**/

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Choufouna', // change this to your company description
        theme: ThemeData(
          primaryColor: Color(0xffFFA28E),
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  final bool connected = connectivity !=
                      ConnectivityResult.none;
                  return new Stack(
                    fit: StackFit.expand,
                    children: [
                      connected ? HomePage() :
                      Stack(
                        children: [
                          Center(
                              child: Stack(children: [
                                AlertDialog(
                                  title: Text("No Internet Connection"),
                                  content: Text("Please Connect to the Internet."),
                                  actions: [
                                    // ignore: deprecated_member_use
                                    FlatButton(
                                      child: Text("Retry"),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ],)
                          )
                        ],
                      )
                    ],
                  );
                },
                child: Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Text("left", textAlign: TextAlign.end,),
                        ],
                      ),
                    )
                )
            );
          },
        )
    );
  }
}