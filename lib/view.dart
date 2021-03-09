import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller;
  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      // ignore: missing_return
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
      },
    );
    _firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  update(String token) {
    print('Token : ' + token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    //textValue = token;
    setState(() {});
  }


  Future<void> _onWillPop(BuildContext context) async {
    print("onwillpop");
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0), // here the desired height
              child: AppBar(
                backgroundColor: Colors.white,
              )
          ),
          body: WebView(
            initialUrl: 'https://km-stores.com/',
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController c) {
              _controllerCompleter.future.then((value) => controller = value);
              _controllerCompleter.complete(c);
            },
          ),
          floatingActionButton: favoritButton(
            controllerCompleter: _controllerCompleter,),
        )
    );
  }
}
