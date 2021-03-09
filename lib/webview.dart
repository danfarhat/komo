import 'dart:async';

import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

WebViewController controllerGlobal;

// ignore: missing_return
Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  _customLaunch(data) async {
    if (await canLaunch(data)) {
      await launch(data);
    } else {
      throw ("Sorry, could not launch $data");
    }
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
      }
    }

    _customLaunch(url());
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.white,
            )
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: 'https://km-stores.com',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              webViewController.clearCache();
              final cookieManager = CookieManager();
              cookieManager.clearCookies();
            },

            // ignore: prefer_collection_literals
            javascriptChannels: <JavascriptChannel>[
              _toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              if (request.url.startsWith('https://flutter.dev/docs')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
          );
        }),
        floatingActionButton: favoriteButton(),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    final primaryColor = Theme
        .of(context)
        .primaryColor;
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return Builder(
              builder: (context) =>
                  FabCircularMenu(
                    key: fabKey,
                    // Cannot be `Alignment.center`
                    alignment: Alignment.bottomRight,
                    ringColor: Color(0x99FFA28E),
                    ringDiameter: 500.0,
                    ringWidth: 150.0,
                    fabSize: 64.0,
                    fabElevation: 8.0,
                    fabIconBorder: CircleBorder(),
                    // Also can use specific color based on wether
                    // the menu is open or not:
                    // fabOpenColor: Colors.white
                    // fabCloseColor: Colors.white
                    // These properties take precedence over fabColor
                    fabColor: Color(0xffFFA28E),
                    fabOpenIcon: Icon(Icons.menu, color: primaryColor),
                    fabCloseIcon: Icon(Icons.close, color: primaryColor),
                    fabMargin: const EdgeInsets.all(16.0),
                    animationDuration: const Duration(milliseconds: 800),
                    animationCurve: Curves.easeInOutCirc,
                    onDisplayChange: (isOpen) {
                      _showSnackBar(
                          context, "The menu is ${isOpen ? "open" : "closed"}");
                    },
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed Home Page");
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.home, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed Notification");
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.bell, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed backward");
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.backward, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed Category");
                          //fabKey.currentState.close();
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(Icons.category, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed Whatsapp");
                          //fabKey.currentState.close();
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.whatsapp, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showSnackBar(context, "You Pressed Facebook");
                          //fabKey.currentState.close();
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.facebookMessenger,
                            color: Colors.white),
                      )
                    ],
                  ),
            );
          }
          return Container();
        });
  }

  void _showSnackBar(BuildContext context, String message) {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1000),
        )
    );
  }
}

